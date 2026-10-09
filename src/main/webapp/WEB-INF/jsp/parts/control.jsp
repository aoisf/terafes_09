<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 操作パネル -->
<section class="control-section" data-action-url="${pageContext.request.contextPath}/action" data-initial-balls="${pet.balls}">
    <div class="status-bar">
        <div class="ball-count">玉数 <span id="main-ball-count">${pet.balls}発</span></div>
        <div class="toggles">
            <label class="auto-toggle-label">
                オート <input type="checkbox" id="auto-toggle">
            </label>
        </div>
    </div>
    <div class="button-wrapper">
        <button type="button" id="start-button" class="start-button">スタート！</button>
    </div>
</section>
<script src="${pageContext.request.contextPath}/js/control.js?v=1" defer></script>
