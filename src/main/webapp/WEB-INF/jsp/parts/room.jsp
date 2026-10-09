<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 育成ルーム -->
<section class="room-section">
    <div class="section-label">育成ルーム</div>
    <div class="pet-name">${pet.name}</div>
    <div class="pet-area">
        <img src="${pageContext.request.contextPath}/images/pets/tamagoro/lv1.png"
             alt="たまごろう"
             class="pet-image">
    </div>
    <div class="stats-panel">
        <p>LV: ${pet.level} <span class="exp-bar"><span class="exp-fill" data-percent="${pet.expPercent}"></span></span></p>
        <p class="pet-exp">EXP: <span id="current-exp" data-value="${pet.exp}">${pet.exp}</span>
            / <span id="next-exp" data-value="${pet.nextLevelExp}">${pet.nextLevelExp}</span></p>
    </div>
</section>
