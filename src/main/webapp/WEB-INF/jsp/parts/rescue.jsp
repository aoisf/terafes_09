<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 救済ポップアップ（0発のときだけ画面中央に出現） -->
<div id="rescue-modal" data-initial-balls="${pet.balls}">
    <div class="rescue-modal-box">
        <h3 style="margin: 0 0 6px 0; color: #cc0000; font-size: 1.2rem;">💸 すっからかん救済センター 💸</h3>
        <p style="margin: 0; font-size: 0.85rem; color: #444; line-height: 1.4;">
            玉が完全に尽きてしまいました…！<br>ミニゲームでお金を稼いでやり直そう！
        </p>
        
        <!-- メニュー選択 -->
        <div id="rescue-menu" class="rescue-btn-group">
            <button type="button" class="rescue-action-btn rescue-btn-pick" onclick="startRescueGame('pick')">
                <span>道で玉を拾う</span>
                <span style="font-size: 0.8rem;">+10発</span>
            </button>
            <button type="button" class="rescue-action-btn rescue-btn-help" onclick="startRescueGame('help')">
                <span>お手伝いをする</span>
                <span style="font-size: 0.8rem;">+100発</span>
            </button>
            <button type="button" class="rescue-action-btn rescue-btn-work" onclick="startRescueGame('work')">
                <span>バイトをする</span>
                <span style="font-size: 0.8rem;">+1,000発</span>
            </button>
        </div>

        <!-- ミニゲームプレイ領域 -->
        <div id="rescue-game-area" style="display: none; margin-top: 10px;">
            <div id="game-title" style="font-size: 0.9rem; font-weight: bold; color: #333; margin-bottom: 5px;"></div>
            <div id="game-canvas" class="game-canvas-area"></div>
            <div id="game-controls"></div>
            <button type="button" onclick="cancelRescueGame()" style="margin-top: 8px; background: none; border: none; color: #888; font-size: 0.8rem; cursor: pointer; text-decoration: underline;">やめる</button>
        </div>
    </div>
</div>