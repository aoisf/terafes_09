package controller;

import java.io.IOException;
import java.math.BigInteger;
import java.util.Random;
import java.io.Serializable;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Pet;
import model.PetCareLogic;
import model.PlayRecord;

@WebServlet("/action")
public class GameActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String RESCUE_CLAIMED_ATTRIBUTE = "rescueClaimed";
    private static final String[] SLOT_SYMBOLS = { "○", "□", "△", "☆" };
    private static final int[] SLOT_BASE_PAYOUTS = { 100, 200, 300, 500 };
    private final Random random = new Random();
    private final PetCareLogic petCareLogic = new PetCareLogic();
    private static final String RESCUE_GAME_ATTRIBUTE = "rescueGame";

    /** 一回の救済挑戦。進捗と使い捨ての操作トークンをサーバーで保持する。 */
    private static class RescueGame implements Serializable {
        private static final long serialVersionUID = 1L;
        final String type;
        final int[] order = {0, 1, 2, 3, 4, 5, 6, 7};
        long deadline;
        long roundStartedAt;
        long issuedAt;
        int score;
        int pickups;
        int round = 1;
        int zoneLeft;
        String token = UUID.randomUUID().toString();
        RescueGame(String type, Random random) {
            this.type = type;
            deadline = System.currentTimeMillis() + ("pick".equals(type) ? 18_000 : "help".equals(type) ? 25_000 : 300_000);
            for (int i = order.length - 1; i > 0; i--) {
                int j = random.nextInt(i + 1);
                int value = order[i]; order[i] = order[j]; order[j] = value;
            }
            startRound(random);
        }
        void startRound(Random random) {
            zoneLeft = random.nextInt(230 - zoneWidth() + 1);
            roundStartedAt = System.currentTimeMillis() + 500;
        }
        int zoneWidth() { return Math.max(36, 78 - (round - 1) * 16); }
        boolean complete() { return "work".equals(type) ? round > 3 : score >= 8; }
        String toJson() {
            issuedAt = System.currentTimeMillis();
            return "{\"token\":\"" + token + "\",\"score\":" + score + ",\"round\":" + round
                    + ",\"zoneLeft\":" + zoneLeft + ",\"zoneWidth\":" + zoneWidth()
                    + ",\"startedAt\":" + roundStartedAt + ",\"serverTime\":" + issuedAt + ",\"deadline\":" + deadline
                    + ",\"complete\":" + complete() + ",\"order\":" + java.util.Arrays.toString(order) + "}";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Pet pet = (Pet) session.getAttribute("pet");

        if (pet == null) {
            pet = new Pet();
            session.setAttribute("pet", pet);
        }

        PlayRecord playRecord = (PlayRecord) session.getAttribute("playRecord");
        if (playRecord == null) {
            playRecord = new PlayRecord();
            session.setAttribute("playRecord", playRecord);
        }

        String action = request.getParameter("action");
        String message = "";
        String slotSymbol = "";
        boolean isHit = false;
        boolean canPlay = false;
        boolean festival = false;

        if ("rescue-start".equals(action) || "rescue-step".equals(action)) {
            response.setContentType("application/json; charset=UTF-8");
            synchronized (pet) {
                if (pet.getBalls().compareTo(BigInteger.TEN) >= 0) {
                    response.sendError(HttpServletResponse.SC_CONFLICT); return;
                }
                RescueGame game;
                if ("rescue-start".equals(action)) {
                    String type = request.getParameter("type");
                    if (!("pick".equals(type) || "help".equals(type) || "work".equals(type))) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                    }
                    game = new RescueGame(type, random);
                    session.setAttribute(RESCUE_GAME_ATTRIBUTE, game);
                } else {
                    game = (RescueGame) session.getAttribute(RESCUE_GAME_ATTRIBUTE);
                    long now = System.currentTimeMillis();
                    long playedAt;
                    try {
                        playedAt = Long.parseLong(request.getParameter("playedAt"));
                    } catch (NumberFormatException e) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                    }
                    // 操作時刻は直近2秒以内に限定。通信到着が期限を越えても時間内の操作を確認する。
                    if (game == null || game.complete() || playedAt > game.deadline
                            || playedAt < game.issuedAt - 250 || playedAt < now - 2_000 || playedAt > now + 250
                            || !game.token.equals(request.getParameter("token"))) {
                        response.sendError(HttpServletResponse.SC_CONFLICT); return;
                    }
                    if ("pick".equals(game.type)) {
                        // 金玉は4個目ごとに2ポイント。
                        String expected = (game.pickups + 1) % 4 == 0 ? "gold" : "silver";
                        if (!expected.equals(request.getParameter("answer"))) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                        }
                        game.score += ++game.pickups % 4 == 0 ? 2 : 1;
                    } else if ("help".equals(game.type)) {
                        int item = game.order[game.score];
                        String expected = item < 3 ? "recycle" : item < 6 ? "burn" : "other";
                        if (expected.equals(request.getParameter("answer"))) game.score++;
                        else game.deadline -= 3_000;
                    } else {
                        if (!"stop".equals(request.getParameter("answer"))) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                        }
                        double elapsed;
                        try {
                            elapsed = Double.parseDouble(request.getParameter("elapsedMillis"));
                        } catch (NumberFormatException | NullPointerException e) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                        }
                        // 最後に描画されたフレームの時刻から、画面と同じ位置を再計算する。
                        // 申告時刻はサーバーの経過時間と照合し、任意の未来・過去への変更を拒否する。
                        if (!Double.isFinite(elapsed) || elapsed < 0 || playedAt < game.roundStartedAt
                                || Math.abs(elapsed - (playedAt - game.roundStartedAt)) > 100) {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST); return;
                        }
                        double speed = 3 + (game.round - 1) * 1.4;
                        double travel = elapsed / 16.0 * speed % 424;
                        double position = (travel <= 212 ? travel : 424 - travel) + 7;
                        boolean hit = position >= game.zoneLeft && position <= game.zoneLeft + game.zoneWidth();
                        if (hit) game.round++;
                        game.startRound(random);
                    }
                    game.token = UUID.randomUUID().toString();
                    // 時間内にクリアできれば、報酬の受け取り通信には別の猶予を設ける。
                    if (game.complete()) game.deadline = now + 30_000;
                }
                response.getWriter().write(game.toJson());
            }
            return;
        }

        // 救済アクション（10発未満でミニゲームを完了したときの報酬）
        if ("rescue".equals(action)) {
            String type = request.getParameter("type");
            long reward = 0;
            if ("pick".equals(type)) reward = 10;
            else if ("help".equals(type)) reward = 100;
            else if ("work".equals(type)) reward = 1000;

            boolean success = false;
            synchronized (pet) {
                RescueGame game = (RescueGame) session.getAttribute(RESCUE_GAME_ATTRIBUTE);
                if (reward > 0 && pet.getBalls().compareTo(BigInteger.TEN) < 0
                        && game != null && game.type.equals(type) && game.complete()
                        && game.token.equals(request.getParameter("token"))
                        && System.currentTimeMillis() <= game.deadline
                        && !Boolean.TRUE.equals(session.getAttribute(RESCUE_CLAIMED_ATTRIBUTE))) {
                    petCareLogic.addRescueBalls(pet, reward);
                    session.setAttribute(RESCUE_CLAIMED_ATTRIBUTE, Boolean.TRUE);
                    success = true;
                    session.removeAttribute(RESCUE_GAME_ATTRIBUTE);
                }
            }

            response.setContentType("application/json; charset=UTF-8");
            String json = String.format(
                "{\"success\": %b, \"balls\": \"%s\", \"reward\": %d}",
                success,
                getBallsSnapshot(pet).toString(),
                success ? reward : 0
            );
            response.getWriter().write(json);
            return;
        }

        if (!"pachinko".equals(action)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported action");
            return;
        }

        synchronized (pet) {
            // 玉が残っている状態で通常操作に入ったら、次の0発到達時の救済を再度許可する。
            if (pet.getBalls().compareTo(BigInteger.TEN) >= 0) {
                session.removeAttribute(RESCUE_CLAIMED_ATTRIBUTE);
            }

            if ("pachinko".equals(action)) {
                // パチンコ実行 (10発消費)
                if (petCareLogic.consumeBalls(pet, 10)) {
                    canPlay = true;
                    festival = random.nextInt(1000) == 0;
                    int result = random.nextInt(20);
                    if (result < SLOT_SYMBOLS.length) {
                        isHit = true;
                        slotSymbol = SLOT_SYMBOLS[result];
                        BigInteger payout = petCareLogic.calculateJackpotPayout(
                            pet.getLevel(), SLOT_BASE_PAYOUTS[result]
                        );
                        petCareLogic.handlePachinkoHit(pet, payout);
                        message = "大当り！「" + slotSymbol + "」が3つ揃い！ "
                                + String.format(java.util.Locale.JAPAN, "%,d", payout) + "発 獲得！";
                    } else {
                        message = "ハズレ… 10発消費";
                    }
                    playRecord.recordPachinko(isHit);
                } else {
                    message = "玉が足りません！";
                }
            }
        }

        // Ajax / Fetch からのアクセスの場合は JSON を返す
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            response.setContentType("application/json; charset=UTF-8");
            String json = String.format(
                "{\"canPlay\": %b, \"hit\": %b, \"festival\": %b, \"symbol\": \"%s\", \"message\": \"%s\", \"balls\": \"%s\", \"record\": %s}",
                canPlay,
                isHit,
                festival,
                escapeJson(slotSymbol),
                escapeJson(message),
                getBallsSnapshot(pet).toString(),
                playRecord.toJson()
            );
            response.getWriter().write(json);
            return;
        }

        // 通常のフォーム送信の場合はリダイレクト
        session.setAttribute("actionMessage", message);
        response.sendRedirect(request.getContextPath() + "/main");
    }

    private BigInteger getBallsSnapshot(Pet pet) {
        synchronized (pet) {
            return pet.getBalls();
        }
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}
