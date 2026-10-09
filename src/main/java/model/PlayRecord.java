package model;

import java.io.Serializable;

/** 展示中の操作記録。HttpSessionと同じ寿命で保持する。 */
public class PlayRecord implements Serializable {
    private static final long serialVersionUID = 1L;
    private static final long BACKGROUND_UNLOCK_ACTIONS = 100L;

    private long totalActions;
    private long pachinkoSpins;
    private long jackpots;
    private long foodActions;
    private long playActions;
    private String selectedBackground = "room";

    public synchronized void recordPachinko(boolean hit) {
        totalActions++;
        pachinkoSpins++;
        if (hit) jackpots++;
    }

    public synchronized void recordCare(boolean food) {
        totalActions++;
        if (food) foodActions++;
        else playActions++;
    }

    public synchronized long getTotalActions() { return totalActions; }
    public synchronized long getPachinkoSpins() { return pachinkoSpins; }
    public synchronized long getJackpots() { return jackpots; }
    public synchronized long getFoodActions() { return foodActions; }
    public synchronized long getPlayActions() { return playActions; }
    public synchronized boolean isFirstSpinAchieved() { return pachinkoSpins >= 1; }
    public synchronized boolean isFirstJackpotAchieved() { return jackpots >= 1; }
    public synchronized boolean isRegularAchieved() { return totalActions >= 50; }
    public synchronized boolean isBackgroundUnlocked() { return totalActions >= BACKGROUND_UNLOCK_ACTIONS; }
    public synchronized String getSelectedBackground() { return selectedBackground; }

    public synchronized boolean selectBackground(String background) {
        if (!isBackgroundUnlocked() || !("room".equals(background) || "forest".equals(background))) {
            return false;
        }
        selectedBackground = background;
        return true;
    }

    public synchronized int getBackgroundProgressPercent() {
        return (int) Math.min(100L, totalActions * 100L / BACKGROUND_UNLOCK_ACTIONS);
    }

    public synchronized String toJson() {
        return String.format(
            java.util.Locale.ROOT,
            "{\"totalActions\":%d,\"pachinkoSpins\":%d,\"jackpots\":%d,\"foodActions\":%d,\"playActions\":%d}",
            totalActions, pachinkoSpins, jackpots, foodActions, playActions
        );
    }
}
