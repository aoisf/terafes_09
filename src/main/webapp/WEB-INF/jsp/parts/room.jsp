<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 育成ルーム -->
<section class="room-section">
    <div class="section-label">育成ルーム</div>
    <div class="pet-name">${pet.name}</div>
    <div class="pet-area">
        <img src="${pageContext.request.contextPath}/images/pets/tamagoro/lv1.png"
             alt="たまごろう"
             style="max-width: 100px; height: auto; display: block; margin: 0 auto;">
    </div>
    <div class="stats-panel">
        <p>LV: ${pet.level} <span class="exp-bar"><span class="exp-fill" style="width: ${pet.expPercent}%;"></span></span></p>
        <p style="font-size:0.6rem; color:#666; margin:0;">EXP: ${pet.exp} / ${pet.nextLevelExp}</p>
    </div>
</section>