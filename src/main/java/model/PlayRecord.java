package model;

import java.io.Serializable;

/** 展示中の操作記録。HttpSessionと同じ寿命で保持する。 */
public class PlayRecord implements Serializable {
    private static final long serialVersionUID = 1L;
    private static final long FOREST_UNLOCK_ACTIONS = 100L;
    private static final long POOL_UNLOCK_ACTIONS = 500L;
    private static final long PACIFIC_UNLOCK_ACTIONS = 2_500L;
    private static final long SPACE_UNLOCK_ACTIONS = 12_500L;

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
    public synchronized boolean isForestUnlocked() { return totalActions >= FOREST_UNLOCK_ACTIONS; }
    public synchronized boolean isPoolUnlocked() { return totalActions >= POOL_UNLOCK_ACTIONS; }
    public synchronized boolean isPacificUnlocked() { return totalActions >= PACIFIC_UNLOCK_ACTIONS; }
    public synchronized boolean isSpaceUnlocked() { return totalActions >= SPACE_UNLOCK_ACTIONS; }
    public synchronized boolean isBackgroundUnlocked() { return isForestUnlocked(); }
    public synchronized String getSelectedBackground() { return selectedBackground; }

    public synchronized String getNextBackgroundName() {
        if (!isForestUnlocked()) return "森";
        if (!isPoolUnlocked()) return "プール";
        if (!isPacificUnlocked()) return "太平洋";
        if (!isSpaceUnlocked()) return "宇宙";
        return "すべての背景";
    }

    public synchronized long getActionsToNextBackground() {
        if (!isForestUnlocked()) return FOREST_UNLOCK_ACTIONS - totalActions;
        if (!isPoolUnlocked()) return POOL_UNLOCK_ACTIONS - totalActions;
        if (!isPacificUnlocked()) return PACIFIC_UNLOCK_ACTIONS - totalActions;
        if (!isSpaceUnlocked()) return SPACE_UNLOCK_ACTIONS - totalActions;
        return 0;
    }

    public synchronized String getNextBackgroundMessage() {
        String next = getNextBackgroundName();
        if ("すべての背景".equals(next)) return "すべての背景を獲得済みです。";
        return String.format(java.util.Locale.JAPAN, "次は「%s」を獲得できます。あと %,d 回です。",
                next, getActionsToNextBackground());
    }

    public synchronized String getFormattedTotalActions() {
        return String.format(java.util.Locale.JAPAN, "%,d", totalActions);
    }

    public synchronized boolean isBackgroundUnlocked(String background) {
        if ("room".equals(background)) return true;
        if ("forest".equals(background)) return isForestUnlocked();
        if ("pool".equals(background)) return isPoolUnlocked();
        if ("pacific".equals(background)) return isPacificUnlocked();
        return "space".equals(background) && isSpaceUnlocked();
    }

    public synchronized boolean selectBackground(String background) {
        if (!isBackgroundUnlocked(background)) return false;
        selectedBackground = background;
        return true;
    }

    public synchronized String toJson() {
        return String.format(
            java.util.Locale.ROOT,
            "{\"totalActions\":%d,\"pachinkoSpins\":%d,\"jackpots\":%d,\"foodActions\":%d,\"playActions\":%d}",
            totalActions, pachinkoSpins, jackpots, foodActions, playActions
        );
    }
}
