package controller;

import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.PlayRecord;

@WebServlet("/background")
public class BackgroundServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        HttpSession session = request.getSession(false);
        PlayRecord record = session == null ? null : (PlayRecord) session.getAttribute("playRecord");
        String background = request.getParameter("background");
        boolean success = record != null && record.selectBackground(background);
        if (!success) response.setStatus(HttpServletResponse.SC_FORBIDDEN);

        response.getWriter().write("{\"success\":" + success + ",\"background\":\""
                + (success ? background : "") + "\"}");
    }
}
