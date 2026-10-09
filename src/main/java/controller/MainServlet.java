package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Pet;
import model.PlayRecord;

@WebServlet("/main")
public class MainServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();

        // URLに ?reset=true がついていたらセッションを破棄して再作成
        if ("true".equals(request.getParameter("reset"))) {
            session.invalidate();
            session = request.getSession(true);
        }

        Pet pet = (Pet) session.getAttribute("pet");

        if (pet == null) {
            pet = new Pet();
            session.setAttribute("pet", pet);
        }

        if (session.getAttribute("playRecord") == null) {
            session.setAttribute("playRecord", new PlayRecord());
        }

        request.getRequestDispatcher("/WEB-INF/jsp/main.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
