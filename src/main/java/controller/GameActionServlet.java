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
        boolean isHit = false;
        boolean canPlay = false;

        // 救済アクション（玉が0のときのミニゲーム報酬）
        if ("rescue".equals(action)) {
            String type = request.getParameter("type");
            long reward = 0;
            if ("pick".equals(type)) reward = 10;
            else if ("help".equals(type)) reward = 100;
            else if ("work".equals(type)) reward = 1000;

            if (reward > 0) {
                petCareLogic.addRescueBalls(pet, reward);
            }

            response.setContentType("application/json; charset=UTF-8");
            String json = String.format(
                "{\"success\": true, \"balls\": \"%s\", \"reward\": %d}",
                pet.getBalls().toString(),
                reward
            );
            response.getWriter().write(json);
            return;
        }

        if ("pachinko".equals(action)) {
            // パチンコ実行 (10発消費)
            if (petCareLogic.consumeBalls(pet, 10)) {
                canPlay = true;
                if (random.nextInt(5) == 0) {
                    isHit = true;
                    BigInteger payout = petCareLogic.calculateJackpotPayout(pet.getLevel());
                    petCareLogic.handlePachinkoHit(pet, payout);
                    message = "大当り！" + payout + "発 獲得！";
                } else {
                    message = "ハズレ… 10発消費";
                }
            } else {
                message = "玉が足りません！";
            }
        }

        // Ajax / Fetch からのアクセスの場合は JSON を返す
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            response.setContentType("application/json; charset=UTF-8");
            String json = String.format(
                "{\"canPlay\": %b, \"hit\": %b, \"message\": \"%s\", \"balls\": \"%s\"}",
                canPlay,
                isHit,
                message,
                pet.getBalls().toString()
            );
            response.getWriter().write(json);
            return;
        }

        // 通常のフォーム送信の場合はリダイレクト
        session.setAttribute("actionMessage", message);
        response.sendRedirect(request.getContextPath() + "/main");
    }
}