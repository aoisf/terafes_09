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
            response.sendRedirect(request.getContextPath() + "/main"
                    + ("true".equals(request.getParameter("attract")) ? "?attract=true" : ""));
            return;
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
        String debugLevel = request.getParameter("debugLevel");
        if (debugLevel != null) {
            int level;
            try {
                level = Integer.parseInt(debugLevel);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            if (level != 1 && (level < 10 || level > 100 || level % 10 != 0)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            HttpSession session = request.getSession();
            Pet pet = (Pet) session.getAttribute("pet");
            if (pet == null) {
                pet = new Pet();
                session.setAttribute("pet", pet);
            }
            synchronized (pet) {
                pet.setLevel(level);
                pet.setExp(java.math.BigInteger.ZERO);
                pet.setOutfitId("normal");
            }
            response.sendRedirect(request.getContextPath() + "/main");
            return;
        }
        doGet(request, response);
    }
}
