package controller;

import java.io.IOException;
import java.math.BigInteger;

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
    protected final PetCareLogic petCareLogic = new PetCareLogic();

    protected PetCareLogic.CareItem[] getCareItems() {
        return PetCareLogic.FOOD_ITEMS;
    }

    protected boolean applyCare(Pet pet, String itemId, BigInteger count) {
        return petCareLogic.feed(pet, itemId, count);
    }

    protected String getCarePage() {
        return "/WEB-INF/jsp/food.jsp";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("pet") == null) {
            session.setAttribute("pet", new Pet());
        }
        request.setAttribute("items", getCareItems());
        request.getRequestDispatcher(getCarePage()).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession();
        Pet pet = (Pet) session.getAttribute("pet");
        if (pet == null) {
            pet = new Pet();
            session.setAttribute("pet", pet);
        }

        boolean success = false;
        boolean invalidCount = false;
        String balls;
        int level;
        String exp;
        String nextExp;
        String itemId = request.getParameter("itemId");
        BigInteger count = BigInteger.ONE;
        String countParam = request.getParameter("count");
        try {
            if (countParam != null) count = new BigInteger(countParam);
        } catch (NumberFormatException e) {
            invalidCount = true;
        }
        synchronized (pet) {
            if (pet.getBalls().signum() > 0) {
                session.removeAttribute("rescueClaimed");
            }
            if (!invalidCount) success = applyCare(pet, itemId, count);
            balls = pet.getBalls().toString();
            level = pet.getLevel();
            exp = pet.getExp().toString();
            nextExp = pet.getNextLevelExp().toString();
        }

        String json = String.format(
            "{\"success\": %b, \"error\": \"%s\", \"balls\": \"%s\", \"level\": %d, \"exp\": \"%s\", \"nextExp\": \"%s\"}",
            success,
            invalidCount ? "invalid_count" : success ? "" : "insufficient_balls_or_invalid_item",
            balls, level, exp, nextExp
        );
        response.getWriter().write(json);
    }
}
