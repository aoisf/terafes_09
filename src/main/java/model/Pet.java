package model;

import java.io.Serializable;
import java.math.BigInteger;

public class Pet implements Serializable {
    private static final long serialVersionUID = 1L;
    // 実装済みの姿を昇順で管理。進化と図鑑はこの一覧を共有する。
    private static final int[] EVOLUTION_LEVELS = {1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100};

    private String name;
    private int level;          // LV (1 - 100)
    private BigInteger exp;     // 現在の累積EXP
    private BigInteger balls;   // 所持玉数（インフレ対応）
    private String outfitId = "normal";
    private String finalForm;

    public Pet() {
        this.name = "たまごろう";
        this.level = 1;
        this.exp = BigInteger.ZERO;
        this.balls = BigInteger.valueOf(100);
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getLevel() { return level; }
    public void setLevel(int level) {
        if (getEvolutionLevelFor(level) > getEvolutionLevel()) this.outfitId = "normal";
        if (level < 100) finalForm = null;
        this.level = level;
    }

    public BigInteger getExp() { return exp; }
    public void setExp(BigInteger exp) { this.exp = exp; }

    public BigInteger getBalls() { return balls; }
    public void setBalls(BigInteger balls) { this.balls = balls; }

    public String getOutfitId() { return outfitId == null ? "normal" : outfitId; }
    public void setOutfitId(String outfitId) {
        if ("normal".equals(outfitId) || "happi".equals(outfitId)
                || "sunglasses".equals(outfitId) || "school-swimsuit".equals(outfitId)) {
            this.outfitId = outfitId;
        }
    }
    public String getOutfitImage() {
        return getOutfitImageFor(getOutfitId());
    }
    public String getOutfitImageFor(String outfit) {
        String stage = getEvolutionLevel() == 100 ? "lv100-" + finalForm : "lv" + getEvolutionLevel();
        return "normal".equals(outfit) ? stage + ".png" : stage + "-" + outfit + ".png";
    }
    public boolean isFinalEvolutionPending() { return level >= 100 && finalForm == null; }
    public String getFinalForm() { return finalForm; }
    public boolean chooseFinalForm(String form) {
        if (!isFinalEvolutionPending() || !("bird".equals(form) || "spirit".equals(form))) return false;
        finalForm = form;
        outfitId = "normal";
        return true;
    }
    public int getEvolutionLevel() { return isFinalEvolutionPending() ? 90 : getEvolutionLevelFor(level); }
    public static int getEvolutionLevelFor(int level) {
        // 到達レベル以下で最も高い姿を選ぶ。複数段階の飛び越しにも対応。
        for (int i = EVOLUTION_LEVELS.length - 1; i >= 0; i--) {
            if (level >= EVOLUTION_LEVELS[i]) return EVOLUTION_LEVELS[i];
        }
        return EVOLUTION_LEVELS[0];
    }
    public static int[] getEvolutionLevels() { return EVOLUTION_LEVELS.clone(); }
    public String getOutfitName() {
        return switch (getOutfitId()) {
            case "happi" -> "パチンコ法被";
            case "sunglasses" -> "サングラス";
            case "school-swimsuit" -> "水着";
            default -> "ふつう";
        };
    }

    // 次のレベルまでに必要な経験値（2のlevel乗）
    public BigInteger getNextLevelExp() {
        return BigInteger.valueOf(2).pow(this.level);
    }

    // ゲージ表示用の進捗パーセント (0 - 100)
    public int getExpPercent() {
        if (this.level >= 100) return 100;
        if (this.level < 1) return 0;
        BigInteger next = getNextLevelExp();
        if (next.equals(BigInteger.ZERO)) return 0;
        return Math.min(100, this.exp.multiply(BigInteger.valueOf(100)).divide(next).intValue());
    }
}
