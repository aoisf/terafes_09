package model;

public class PetCareLogic {

    public static final int MAX_LEVEL = 100;
    public static final int EXP_PER_LEVEL = 10;
    public static final int MAX_STATUS = 100;
    public static final int MIN_STATUS = 0;

    // ごはんコマンド
    public void feed(Pet pet) {
        int nextHunger = Math.min(MAX_STATUS, pet.getHunger() + 15);
        pet.setHunger(nextHunger);
        addExp(pet, 10);
    }

    // あそぶコマンド
    public void play(Pet pet) {
        int nextMood = Math.min(MAX_STATUS, pet.getMood() + 10);
        int nextHunger = Math.max(MIN_STATUS, pet.getHunger() - 5);
        pet.setMood(nextMood);
        pet.setHunger(nextHunger);
        addExp(pet, 15);
    }

    // 経験値加算とレベルアップ計算
    public void addExp(Pet pet, int gain) {
        if (pet.getLevel() >= MAX_LEVEL) {
            pet.setLevel(MAX_LEVEL);
            pet.setExp(0);
            return;
        }

        int currentExp = pet.getExp() + gain;
        int currentLevel = pet.getLevel();

        while (currentExp >= EXP_PER_LEVEL && currentLevel < MAX_LEVEL) {
            currentLevel++;
            currentExp -= EXP_PER_LEVEL;
        }

        if (currentLevel >= MAX_LEVEL) {
            currentLevel = MAX_LEVEL;
            currentExp = 0;
        }

        pet.setLevel(currentLevel);
        pet.setExp(currentExp);
    }

    // 玉の消費
    public boolean consumeBalls(Pet pet, int amount) {
        if (pet.getBalls() >= amount) {
            pet.setBalls(pet.getBalls() - amount);
            return true;
        }
        return false;
    }

    // パチンコ当たり時（出玉加算＋ごきげんUP＋経験値5）
    public void handlePachinkoHit(Pet pet, int amount) {
        pet.setBalls(pet.getBalls() + amount);
        pet.setMood(Math.min(MAX_STATUS, pet.getMood() + 5));
        addExp(pet, 5); // 当たりで経験値5
    }

    // パチンコ外れ時（経験値1）
    public void handlePachinkoMiss(Pet pet) {
        addExp(pet, 1); // 外れで経験値1
    }
}