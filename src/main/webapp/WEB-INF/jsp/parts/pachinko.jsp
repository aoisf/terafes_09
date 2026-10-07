<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- パチンコ画面 -->
<section class="pachinko-section">
    <div class="section-label">パチンコ画面</div>
    <div class="machine-area">
        <div class="jackpot-screen">
            <h2 class="jackpot-numbers">${empty jackpotResult ? '7 7 7' : jackpotResult}</h2>
            <p class="jackpot-text">${empty actionMessage ? '待機中' : actionMessage}</p>
            <p class="jackpot-details">1回：10発消費</p>
        </div>
    </div>
</section>