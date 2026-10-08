package model;

import java.math.BigInteger;

public class PetCareLogic {

    public static final int MAX_LEVEL = 100;

    // ごはん10段階のデータ (名前, 必要玉数, 獲得EXP)
    public record CareItem(String id, String name, BigInteger cost, BigInteger expGain) {}

    public static final CareItem[] FOOD_ITEMS = {
        new CareItem("food_1", "定番かりかりフード", BigInteger.ONE, BigInteger.valueOf(2)),
        new CareItem("food_2", "余り玉のヤクルト", BigInteger.valueOf(10), BigInteger.valueOf(8)),
        new CareItem("food_3", "特製勝カレー", BigInteger.valueOf(50), BigInteger.valueOf(64)),
        new CareItem("food_4", "特上A5霜降りパチ牛", BigInteger.valueOf(500), BigInteger.valueOf(1024)),
        new CareItem("food_5", "純金箔コーティング軍艦", BigInteger.valueOf(5000), BigInteger.valueOf(16384)),
        new CareItem("food_6", "パチプロ秘伝精力薬膳鍋", BigInteger.valueOf(100000), BigInteger.valueOf(1048576)),
        new CareItem("food_7", "超高密度プラチナペレット", new BigInteger("100000000"), BigInteger.valueOf(1073741824)),
        new CareItem("food_8", "暗黒物質の煮凝り", new BigInteger("100000000000"), new BigInteger("1099511627776")),
        new CareItem("food_9", "ビッグバン凝縮スープ", new BigInteger("1000000000000000"), new BigInteger("1152921504606846976")),
        new CareItem("food_10", "全知全能オメガパチゼリー", new BigInteger("10000000000000000000000"), new BigInteger("1000000000000000000000000000"))
    };

    // あそぶ10段階のデータ
    public static final CareItem[] PLAY_ITEMS = {
        new CareItem("play_1", "じゃんけんあそび", BigInteger.ONE, BigInteger.valueOf(3)),
        new CareItem("play_2", "ピカピカ銀玉みがき", BigInteger.valueOf(15), BigInteger.valueOf(12)),
        new CareItem("play_3", "ハンドル固定の練習", BigInteger.valueOf(80), BigInteger.valueOf(96)),
        new CareItem("play_4", "パチンコ実機解体ショー", BigInteger.valueOf(800), BigInteger.valueOf(1536)),
        new CareItem("play_5", "島設備ドル箱タワー積み", BigInteger.valueOf(8000), BigInteger.valueOf(24576)),
        new CareItem("play_6", "全台一斉フィーバーフェス", BigInteger.valueOf(150000), BigInteger.valueOf(1572864)),
        new CareItem("play_7", "重力子加速シミュ", new BigInteger("150000000"), BigInteger.valueOf(1610612736)),
        new CareItem("play_8", "恒星系メガパチンコ大会", new BigInteger("150000000000"), new BigInteger("1649267441664")),
        new CareItem("play_9", "因果律書き換えスロットル", new BigInteger("1500000000000000"), new BigInteger("1729382256910270464")),
        new CareItem("play_10", "多元宇宙ビッグループ崩壊劇", new BigInteger("15000000000000000000000"), new BigInteger("2000000000000000000000000000"))
    };

    // レベルに応じたパチンコ大当たり獲得玉数（インフレ計算）
    public BigInteger calculateJackpotPayout(int level) {
        return calculateJackpotPayout(level, 300);
    }

    // 記号ごとの基準払い出しに、従来どおりのレベル倍率を適用する。
    public BigInteger calculateJackpotPayout(int level, int basePayout) {
        BigInteger base = BigInteger.valueOf(basePayout);
        if (level <= 1) return base;

        BigInteger multiplier = BigInteger.valueOf(3).pow((level - 1) / 2 + 1);
        return base.multiply(multiplier);
    }

    // ごはん実行（BigIntegerまとめ買い対応）
    public boolean feed(Pet pet, String itemId, BigInteger count) {
        if (count == null || count.compareTo(BigInteger.ZERO) <= 0) return false;
        for (CareItem item : FOOD_ITEMS) {
            if (item.id().equals(itemId)) {
                BigInteger totalCost = item.cost().multiply(count);
                if (consumeBalls(pet, totalCost)) {
                    BigInteger totalExp = item.expGain().multiply(count);
                    addExp(pet, totalExp);
                    return true;
                }
                return false;
            }
        }
        return false;
    }

    public boolean feed(Pet pet, String itemId, int count) {
        return feed(pet, itemId, BigInteger.valueOf(count));
    }

    public boolean feed(Pet pet, String itemId) {
        return feed(pet, itemId, BigInteger.ONE);
    }

    // あそぶ実行（BigIntegerまとめ買い対応）
    public boolean play(Pet pet, String itemId, BigInteger count) {
        if (count == null || count.compareTo(BigInteger.ZERO) <= 0) return false;
        for (CareItem item : PLAY_ITEMS) {
            if (item.id().equals(itemId)) {
                BigInteger totalCost = item.cost().multiply(count);
                if (consumeBalls(pet, totalCost)) {
                    BigInteger totalExp = item.expGain().multiply(count);
                    addExp(pet, totalExp);
                    return true;
                }
                return false;
            }
        }
        return false;
    }

    public boolean play(Pet pet, String itemId, int count) {
        return play(pet, itemId, BigInteger.valueOf(count));
    }

    public boolean play(Pet pet, String itemId) {
        return play(pet, itemId, BigInteger.ONE);
    }

    // 経験値加算とレベルアップ計算
    public void addExp(Pet pet, BigInteger gain) {
        if (pet.getLevel() >= MAX_LEVEL) {
            pet.setLevel(MAX_LEVEL);
            pet.setExp(BigInteger.ZERO);
            return;
        }

        BigInteger currentExp = pet.getExp().add(gain);
        int currentLevel = pet.getLevel();

        while (currentLevel < MAX_LEVEL) {
            BigInteger neededExp = BigInteger.valueOf(2).pow(currentLevel);
            if (currentExp.compareTo(neededExp) >= 0) {
                currentExp = currentExp.subtract(neededExp);
                currentLevel++;
            } else {
                break;
            }
        }

        if (currentLevel >= MAX_LEVEL) {
            currentLevel = MAX_LEVEL;
            currentExp = BigInteger.ZERO;
        }

        pet.setLevel(currentLevel);
        pet.setExp(currentExp);
    }

    // 玉消費 (BigInteger対応)
    public boolean consumeBalls(Pet pet, BigInteger amount) {
        if (pet.getBalls().compareTo(amount) >= 0) {
            pet.setBalls(pet.getBalls().subtract(amount));
            return true;
        }
        return false;
    }

    public boolean consumeBalls(Pet pet, int amount) {
        return consumeBalls(pet, BigInteger.valueOf(amount));
    }

    // パチンコ当たり加算
    public void handlePachinkoHit(Pet pet, BigInteger payout) {
        pet.setBalls(pet.getBalls().add(payout));
    }

    // 救済用の玉加算
    public void addRescueBalls(Pet pet, long amount) {
        if (amount > 0) {
            pet.setBalls(pet.getBalls().add(BigInteger.valueOf(amount)));
        }
    }
}
