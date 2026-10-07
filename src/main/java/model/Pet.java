package model;

import java.io.Serializable;

public class Pet implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private int hunger;   // おなか (0 - 100)
    private int mood;     // ごきげん (0 - 100)
    private int level;    // LV (1 - 100)
    private int exp;      // 経験値 (0 - 9)
    private int balls;    // 所持玉数

    public Pet() {
        this.name = "たまごろう";
        this.hunger = 50;
        this.mood = 50;
        this.level = 1;
        this.exp = 0;
        this.balls = 100;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getHunger() { return hunger; }
    public void setHunger(int hunger) { this.hunger = hunger; }

    public int getMood() { return mood; }
    public void setMood(int mood) { this.mood = mood; }

    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }

    public int getExp() { return exp; }
    public void setExp(int exp) { this.exp = exp; }

    public int getBalls() { return balls; }
    public void setBalls(int balls) { this.balls = balls; }
}