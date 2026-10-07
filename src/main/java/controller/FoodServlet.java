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

@WebServlet("/food")
public class FoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final PetCareLogic petCareLogic = new PetCareLogic();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/food.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Pet pet = (Pet) session.getAttribute("pet");
        if (pet != null) {
            petCareLogic.feed(pet);
        }
        response.sendRedirect(request.getContextPath() + "/food");
    }
}