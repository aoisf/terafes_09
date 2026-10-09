package controller;

import java.io.IOException;
import java.math.BigInteger;
import java.util.Random;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Pet;
import model.PetCareLogic;

@WebServlet("/action")
public class GameActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String RESCUE_CLAIMED_ATTRIBUTE = "rescueClaimed";
    private static final String[] SLOT_SYMBOLS = { "○", "□", "△", "☆" };
    private static final int[] SLOT_BASE_PAYOUTS = { 100, 200, 300, 500 };
    private final Random random = new Random();
    private final PetCareLogic petCareLogic = new PetCareLogic();

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

        String action = request.getParameter("action");
        String message = "";
        String slotSymbol = "";
        boolean isHit = false;
        boolean canPlay = false;

        // 救済アクション（玉が0のときのミニゲーム報酬）
        if ("rescue".equals(action)) {
            String type = request.getParameter("type");
            long reward = 0;
            if ("pick".equals(type)) reward = 10;
            else if ("help".equals(type)) reward = 100;
            else if ("work".equals(type)) reward = 1000;

            boolean success = false;
            synchronized (pet) {
                if (reward > 0 && pet.getBalls().signum() == 0
                        && !Boolean.TRUE.equals(session.getAttribute(RESCUE_CLAIMED_ATTRIBUTE))) {
                    petCareLogic.addRescueBalls(pet, reward);
                    session.setAttribute(RESCUE_CLAIMED_ATTRIBUTE, Boolean.TRUE);
                    success = true;
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
            if (pet.getBalls().signum() > 0) {
                session.removeAttribute(RESCUE_CLAIMED_ATTRIBUTE);
            }

            if ("pachinko".equals(action)) {
                // パチンコ実行 (10発消費)
                if (petCareLogic.consumeBalls(pet, 10)) {
                    canPlay = true;
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
                "{\"canPlay\": %b, \"hit\": %b, \"symbol\": \"%s\", \"message\": \"%s\", \"balls\": \"%s\"}",
                canPlay,
                isHit,
                escapeJson(slotSymbol),
                escapeJson(message),
                getBallsSnapshot(pet).toString()
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
