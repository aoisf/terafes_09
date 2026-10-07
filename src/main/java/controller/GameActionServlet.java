package controller;

import java.io.IOException;
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
        String jackpotResult = "";

        if ("pachinko".equals(action)) {
            // パチンコ実行 (10発消費)
            if (petCareLogic.consumeBalls(pet, 10)) {
                if (random.nextInt(5) == 0) {
                    petCareLogic.handlePachinkoHit(pet, 300);
                    jackpotResult = "7 7 7";
                    message = "大当り！300発獲得！（EXP +5）";
                } else {
                    petCareLogic.handlePachinkoMiss(pet);
                    jackpotResult = "3 4 8";
                    message = "ハズレ… 10発消費（EXP +1）";
                }
            } else {
                message = "玉が足りません！";
            }
        } else if ("feed".equals(action)) {
            petCareLogic.feed(pet);
            message = pet.getName() + " にごはんをあげたよ！";
        } else if ("play".equals(action)) {
            petCareLogic.play(pet);
            message = pet.getName() + " と遊んだよ！";
        }

        session.setAttribute("actionMessage", message);
        session.setAttribute("jackpotResult", jackpotResult);

        response.sendRedirect(request.getContextPath() + "/main");
    }
}