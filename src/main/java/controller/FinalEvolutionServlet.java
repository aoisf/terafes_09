package controller;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Pet;
@WebServlet("/final-evolution")
public class FinalEvolutionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session = req.getSession(false);
        Pet pet = session == null ? null : (Pet) session.getAttribute("pet");
        res.setContentType("application/json; charset=UTF-8");
        boolean pending = false;
        if (pet != null) synchronized (pet) { pending = pet.isFinalEvolutionPending(); }
        res.getWriter().write("{\"pending\":" + pending + "}");
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("application/json; charset=UTF-8");
        HttpSession session = req.getSession(false);
        Pet pet = session == null ? null : (Pet) session.getAttribute("pet");
        if (pet == null) { res.sendError(409); return; }
        synchronized (pet) {
            String form = req.getParameter("form");
            if (!pet.chooseFinalForm(form) && !(pet.getLevel() >= 100 && form != null && form.equals(pet.getFinalForm()))) { res.sendError(409); return; }
            res.getWriter().write("{\"image\":\"" + pet.getOutfitImage() + "\"}");
        }
    }
}
