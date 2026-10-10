<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 操作パネル -->
<section class="control-section" data-action-url="${pageContext.request.contextPath}/action" data-initial-balls="${pet.balls}">
    <div class="control-readouts">
        <div class="control-readout ball-count">
            <span class="readout-label">玉数</span>
            <strong id="main-ball-count">${pet.balls}発</strong>
        </div>
        <div class="control-readout multiplier-count">
            <span class="readout-label">現在の倍率</span>
            <strong><span id="current-multiplier" data-level="${pet.level}">1</span><span>倍</span></strong>
        </div>
    </div>
    <div class="control-actions">
        <label class="auto-toggle-label">
            <span class="auto-indicator" aria-hidden="true"></span>
            <span>オート <small>10ms/回</small></span>
            <input type="checkbox" id="auto-toggle">
        </label>
        <div class="lever-area">
            <button type="button" id="start-button" class="start-button lever-button" aria-label="レバーを引いてスロットを回す">
                <span class="lever-rail" aria-hidden="true"></span>
                <span class="lever-arm" aria-hidden="true"><span class="lever-grip">SPIN</span></span>
            </button>
            <span class="lever-caption" id="lever-caption">PULL TO START</span>
        </div>
    </div>
</section>
<script src="${pageContext.request.contextPath}/js/control.js?v=7" defer></script>
