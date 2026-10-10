<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 育成ルーム -->
<section class="room-section"
         style="--room-background-image: url('${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/${playRecord.selectedBackground}.png')">
    <div class="section-label">育成ルーム</div>
    <div class="pet-name">${pet.name}</div>
    <div class="pet-area">
        <img src="${pageContext.request.contextPath}/images/pets/tamagoro/${pet.outfitImage}"
             alt="${pet.name}（${pet.outfitName}）"
             class="pet-image">
    </div>
    <div class="stats-panel">
        <p class="pet-level"><span class="level-caption">LV.</span><strong>${pet.level}</strong><span class="exp-bar" aria-label="経験値進捗"><span class="exp-fill" data-percent="${pet.expPercent}"></span></span></p>
        <p class="pet-exp"><span class="exp-label">EXP</span> <span id="current-exp" data-value="${pet.exp}">${pet.exp}</span>
            / <span id="next-exp" data-value="${pet.nextLevelExp}">${pet.nextLevelExp}</span></p>
    </div>
</section>
