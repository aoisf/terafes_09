package model;

import java.io.Serializable;
import java.math.BigInteger;

public class Pet implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private int level;          // LV (1 - 100)
    private BigInteger exp;     // 現在の累積EXP
    private BigInteger balls;   // 所持玉数（インフレ対応）

    public Pet() {
        this.name = "たまごろう";
        this.level = 1;
        this.exp = BigInteger.ZERO;
        this.balls = BigInteger.valueOf(100);
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }

    public BigInteger getExp() { return exp; }
    public void setExp(BigInteger exp) { this.exp = exp; }

    public BigInteger getBalls() { return balls; }
    public void setBalls(BigInteger balls) { this.balls = balls; }

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
