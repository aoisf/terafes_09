<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 育成ルーム -->
<section class="room-section">
    <div class="section-label">育成ルーム</div>
    <div class="pet-name">${pet.name}</div>
    <div class="pet-area">
        <div class="pet-character">(・∀・)</div>
    </div>
    <div class="stats-panel">
        <p>おなか：${pet.hunger}%</p>
        <p>ごきげん：${pet.mood}%</p>
        <p>LV: ${pet.level} <span class="exp-bar"><span class="exp-fill" style="width: ${pet.exp * 10}%;"></span></span></p>
    </div>
</section>