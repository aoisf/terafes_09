package controller;

import java.math.BigInteger;

import jakarta.servlet.annotation.WebServlet;

import model.Pet;
import model.PetCareLogic;

@WebServlet("/play")
public class PlayServlet extends FoodServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected PetCareLogic.CareItem[] getCareItems() {
        return PetCareLogic.PLAY_ITEMS;
    }

    @Override
    protected String getCarePage() {
        return "/WEB-INF/jsp/play.jsp";
    }

    @Override
    protected boolean applyCare(Pet pet, String itemId, BigInteger count) {
        return petCareLogic.play(pet, itemId, count);
    }
}
