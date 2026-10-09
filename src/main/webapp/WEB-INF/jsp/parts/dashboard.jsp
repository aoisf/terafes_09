<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="dashboard-ui" id="dashboard-ui"
     data-reset-url="${pageContext.request.contextPath}/main?reset=true"
     data-background-url="${pageContext.request.contextPath}/background">
    <header class="dashboard-header" aria-label="メニュー">
        <button class="dashboard-nav-button" type="button" data-open-dialog="encyclopedia" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v16H6.5A2.5 2.5 0 0 0 4 21V5.5Zm0 0A2.5 2.5 0 0 1 6.5 8H20M8 12h8M8 15h6"/></svg>
            <span>図鑑</span>
        </button>
        <button class="dashboard-nav-button" type="button" data-open-dialog="settings" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 8.3a3.7 3.7 0 1 0 0 7.4 3.7 3.7 0 0 0 0-7.4Zm0-5.8 1.1 2.2 2.5.6 2-1.2 2 2-1.2 2 .6 2.5 2.2 1.1v2.8l-2.2 1.1-.6 2.5 1.2 2-2 2-2-1.2-2.5.6-1.1 2.2H9.2l-1.1-2.2-2.5-.6-2 1.2-2-2 1.2-2-.6-2.5L0 14.8V12l2.2-1.1.6-2.5-1.2-2 2-2 2 1.2 2.5-.6 1.1-2.2H12Z" transform="translate(2 0) scale(.83)"/></svg>
            <span>設定</span>
        </button>
        <button class="dashboard-nav-button" type="button" data-open-dialog="records" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 20V11h4v9H4Zm6 0V5h4v15h-4Zm6 0v-7h4v7h-4ZM3 4h18"/></svg>
            <span>プレイ記録</span>
        </button>
        <button class="dashboard-nav-button" type="button" data-open-dialog="achievements" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M8 4h8v4a4 4 0 0 1-8 0V4Zm0 2H4v2a4 4 0 0 0 4 4m8-6h4v2a4 4 0 0 1-4 4m-4 2v4m-4 2h8m-8-6h8v6H8z"/></svg>
            <span>実績</span>
        </button>
    </header>

    <div class="dashboard-dialog" data-dialog="encyclopedia" role="dialog" aria-modal="true" aria-labelledby="encyclopedia-title" hidden>
        <div class="dashboard-dialog-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">TAMAGORO FILE</p><h2 id="encyclopedia-title">ちいさな図鑑</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <div class="encyclopedia-grid">
                <article class="encyclopedia-card"><span class="encyclopedia-mark">た</span><div><h3>たまごろう</h3><p>銀玉の音に誘われてやってきた、好奇心いっぱいのたまごろう。</p></div></article>
                <article class="encyclopedia-card"><span class="encyclopedia-mark">食</span><div><h3>ごはん</h3><p>玉を使ってごはんをあげると、経験値を獲得できるよ。</p></div></article>
                <article class="encyclopedia-card"><span class="encyclopedia-mark">遊</span><div><h3>あそぶ</h3><p>遊びながら経験値を獲得。まとめて遊ぶこともできるよ。</p></div></article>
                <article class="encyclopedia-card"><span class="encyclopedia-mark">着</span><div><h3>おきがえ</h3><p>今はお気に入りの姿で待機中。新しい着替えはこれから追加予定。</p></div></article>
            </div>
        </div>
    </div>

    <div class="dashboard-dialog" data-dialog="settings" role="dialog" aria-modal="true" aria-labelledby="settings-title" hidden>
        <div class="dashboard-dialog-panel dashboard-settings-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">YOUR PREFERENCE</p><h2 id="settings-title">設定</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <label class="setting-row" for="default-auto-setting">
                <span><strong>次回表示時にオートを初期選択</strong><small>ONでもレバーを引くまでは回転しません</small></span>
                <input type="checkbox" id="default-auto-setting">
            </label>
            <div class="setting-row reset-setting">
                <span><strong>展示データをリセット</strong><small>玉数・レベル・プレイ記録を初期化します</small></span>
                <button class="dashboard-danger-button" type="button" data-reset-game>リセット</button>
            </div>
            <p class="dashboard-footnote">オート設定はこのブラウザーに保存されます。ゲームの状態と記録は展示中のみ保持されます。</p>
        </div>
    </div>

    <div class="dashboard-dialog" data-dialog="records" role="dialog" aria-modal="true" aria-labelledby="records-title" hidden>
        <div class="dashboard-dialog-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">THIS SESSION</p><h2 id="records-title">プレイ記録</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <p class="records-note">今回の展示中の操作記録です。リセットすると記録も初期化されます。</p>
            <div class="records-grid">
                <div class="record-tile record-total"><span>総操作回数</span><strong data-record-value="totalActions">${playRecord.totalActions}</strong></div>
                <div class="record-tile"><span>パチンコ回転数</span><strong data-record-value="pachinkoSpins">${playRecord.pachinkoSpins}</strong></div>
                <div class="record-tile"><span>大当たり</span><strong data-record-value="jackpots">${playRecord.jackpots}</strong></div>
                <div class="record-tile"><span>ごはん操作</span><strong data-record-value="foodActions">${playRecord.foodActions}</strong></div>
                <div class="record-tile"><span>あそぶ操作</span><strong data-record-value="playActions">${playRecord.playActions}</strong></div>
            </div>
            <p class="dashboard-footnote">回転数は玉を消費して成立した回数、育成操作は購入が成立した回数で記録します。</p>
        </div>
    </div>

    <div class="dashboard-dialog" data-dialog="achievements" role="dialog" aria-modal="true" aria-labelledby="achievements-title" hidden>
        <div class="dashboard-dialog-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">MILESTONES</p><h2 id="achievements-title">実績</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <div class="achievement-list">
                <article class="achievement-card ${playRecord.firstSpinAchieved ? 'is-achieved' : ''}" data-achievement="firstSpin">
                    <span class="achievement-seal">1</span><div><h3>はじめての一回転</h3><p>パチンコを1回遊ぶ</p></div><strong data-achievement-state>${playRecord.firstSpinAchieved ? '達成' : '未達成'}</strong>
                </article>
                <article class="achievement-card ${playRecord.firstJackpotAchieved ? 'is-achieved' : ''}" data-achievement="firstJackpot">
                    <span class="achievement-seal">★</span><div><h3>フィーバー！</h3><p>大当たりを引く</p></div><strong data-achievement-state>${playRecord.firstJackpotAchieved ? '達成' : '未達成'}</strong>
                </article>
                <article class="achievement-card ${playRecord.regularAchieved ? 'is-achieved' : ''}" data-achievement="regular">
                    <span class="achievement-seal">50</span><div><h3>常連さん</h3><p>総操作回数 50回</p></div><strong data-achievement-state>${playRecord.regularAchieved ? '達成' : '未達成'}</strong>
                </article>
            </div>
            <section class="background-unlock ${playRecord.backgroundUnlocked ? 'is-unlocked' : ''}" aria-label="背景カスタマイズ枠">
                <div class="background-unlock-copy">
                    <p class="dashboard-eyebrow">ROOM CUSTOMIZE</p>
                    <h3>育成ルーム背景</h3>
                    <p data-background-copy>${playRecord.backgroundUnlocked ? '通常の部屋と森を選べます。' : '総操作100回で「森」が解放されます。現在 '}${playRecord.backgroundUnlocked ? '' : playRecord.backgroundProgressPercent}${playRecord.backgroundUnlocked ? '' : '%'}</p>
                </div>
                <div class="background-options" aria-label="背景を選択">
                    <button class="background-option ${playRecord.selectedBackground == 'room' ? 'is-selected' : ''}"
                            type="button" data-background-choice="room" aria-pressed="${playRecord.selectedBackground == 'room'}"
                            data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/room.png"
                            ${playRecord.backgroundUnlocked ? '' : 'disabled'}>
                        <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/room.png" alt="">
                        <span>部屋 <small>いつもの背景</small></span>
                    </button>
                    <button class="background-option ${playRecord.selectedBackground == 'forest' ? 'is-selected' : ''}"
                            type="button" data-background-choice="forest" aria-pressed="${playRecord.selectedBackground == 'forest'}"
                            data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/forest.png"
                            ${playRecord.backgroundUnlocked ? '' : 'disabled'}>
                        <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/forest.png" alt="">
                        <span>森 <small>100回達成報酬</small></span>
                    </button>
                </div>
                <span class="background-status" data-background-state>${playRecord.backgroundUnlocked ? '解放済み' : 'LOCKED'}</span>
            </section>
            <p class="dashboard-footnote">総操作100回で森が解放されます。背景と実績は今回の展示中のみ保持されます。</p>
        </div>
    </div>
</div>
