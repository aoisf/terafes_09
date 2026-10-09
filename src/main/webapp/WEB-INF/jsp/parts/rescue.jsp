<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 救済ポップアップ（0発のときだけ画面中央に出現） -->
<div id="rescue-modal" role="dialog" aria-modal="true" aria-labelledby="rescue-title"
     aria-hidden="true" data-initial-balls="${pet.balls}">
    <div class="rescue-modal-box">
        <h3 id="rescue-title" class="rescue-title">💸 すっからかん救済センター 💸</h3>
        <p class="rescue-description">
            玉が完全に尽きてしまいました…！<br>ミニゲームでお金を稼いでやり直そう！
        </p>
        
        <!-- メニュー選択 -->
        <div id="rescue-menu" class="rescue-btn-group">
            <button type="button" class="rescue-action-btn rescue-btn-pick" onclick="startRescueGame('pick')">
                <span>道で玉を拾う</span>
                <span class="rescue-reward">+10発</span>
            </button>
            <button type="button" class="rescue-action-btn rescue-btn-help" onclick="startRescueGame('help')">
                <span>お手伝いをする</span>
                <span class="rescue-reward">+100発</span>
            </button>
            <button type="button" class="rescue-action-btn rescue-btn-work" onclick="startRescueGame('work')">
                <span>バイトをする</span>
                <span class="rescue-reward">+1,000発</span>
            </button>
        </div>

        <!-- ミニゲームプレイ領域 -->
        <div id="rescue-game-area" class="rescue-game-area">
            <div id="game-title" class="rescue-game-title"></div>
            <div id="game-canvas" class="game-canvas-area"></div>
            <div id="game-controls"></div>
            <button type="button" class="rescue-cancel" onclick="cancelRescueGame()">やめる</button>
        </div>
    </div>
</div>
