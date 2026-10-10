package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Pet;

@WebServlet("/dress")
public class DressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Pet getPet(HttpSession session) {
        Pet pet = (Pet) session.getAttribute("pet");
        if (pet == null) {
            pet = new Pet();
            session.setAttribute("pet", pet);
        }
        return pet;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setAttribute("pet", getPet(session));
        request.getRequestDispatcher("/WEB-INF/jsp/dress.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Pet pet = getPet(session);
        String outfitId = request.getParameter("outfit");
        if (outfitId == null || !("normal".equals(outfitId) || "happi".equals(outfitId)
                || "sunglasses".equals(outfitId) || "school-swimsuit".equals(outfitId))) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        pet.setOutfitId(outfitId);
        response.sendRedirect(request.getContextPath() + "/dress");
    }
}
