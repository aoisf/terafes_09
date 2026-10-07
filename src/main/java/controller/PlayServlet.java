package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Pet;
import model.PetCareLogic;

@WebServlet("/play")
public class PlayServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PetCareLogic petCareLogic = new PetCareLogic();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("items", PetCareLogic.PLAY_ITEMS);
        request.getRequestDispatcher("/WEB-INF/jsp/play.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        Pet pet = (Pet) session.getAttribute("pet");

        boolean success = false;
        if (pet != null) {
            String itemId = request.getParameter("itemId");
            success = petCareLogic.play(pet, itemId);
        }

        String json = String.format(
            "{\"success\": %b, \"balls\": \"%s\", \"level\": %d, \"exp\": \"%s\", \"nextExp\": \"%s\"}",
            success,
            pet != null ? pet.getBalls().toString() : "0",
            pet != null ? pet.getLevel() : 1,
            pet != null ? pet.getExp().toString() : "0",
            pet != null ? pet.getNextLevelExp().toString() : "2"
        );
        response.getWriter().write(json);
    }
}