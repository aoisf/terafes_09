<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.PetCareLogic" %>
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
            <span>記録</span>
        </button>
        <button class="dashboard-nav-button" type="button" data-open-dialog="achievements" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M8 4h8v4a4 4 0 0 1-8 0V4Zm0 2H4v2a4 4 0 0 0 4 4m8-6h4v2a4 4 0 0 1-4 4m-4 2v4m-4 2h8m-8-6h8v6H8z"/></svg>
            <span>実績</span>
        </button>
        <button class="dashboard-nav-button" type="button" data-open-dialog="background" aria-haspopup="dialog">
            <svg class="dashboard-nav-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 5h18v14H3zM4 16l5-5 3 3 3-4 5 6M8 9h.01"/></svg>
            <span>背景</span>
        </button>
    </header>

    <div class="dashboard-dialog" data-dialog="encyclopedia" role="dialog" aria-modal="true" aria-labelledby="encyclopedia-title" hidden>
        <div class="dashboard-dialog-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">TAMAGORO FILE</p><h2 id="encyclopedia-title">ちいさな図鑑</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <div class="encyclopedia-grid" data-encyclopedia-list>
                <button class="encyclopedia-card" type="button" data-encyclopedia-entry="tamagoro">
                    <span class="encyclopedia-mark">た</span><span class="encyclopedia-copy"><strong>たまごろう</strong><span>銀玉の音に誘われてやってきた、好奇心いっぱいのたまごろう。</span></span><span class="encyclopedia-arrow" aria-hidden="true">›</span>
                </button>
                <button class="encyclopedia-card" type="button" data-encyclopedia-entry="food">
                    <span class="encyclopedia-mark">食</span><span class="encyclopedia-copy"><strong>ごはん</strong><span>玉を使ってごはんをあげると、経験値を獲得できるよ。</span></span><span class="encyclopedia-arrow" aria-hidden="true">›</span>
                </button>
                <button class="encyclopedia-card" type="button" data-encyclopedia-entry="play">
                    <span class="encyclopedia-mark">遊</span><span class="encyclopedia-copy"><strong>あそぶ</strong><span>遊びながら経験値を獲得。まとめて遊ぶこともできるよ。</span></span><span class="encyclopedia-arrow" aria-hidden="true">›</span>
                </button>
                <button class="encyclopedia-card" type="button" data-encyclopedia-entry="outfits">
                    <span class="encyclopedia-mark">着</span><span class="encyclopedia-copy"><strong>おきがえ</strong><span>気分に合わせて、たまごろうの衣装を選ぼう。</span></span><span class="encyclopedia-arrow" aria-hidden="true">›</span>
                </button>
            </div>
            <section class="encyclopedia-entry-detail" data-encyclopedia-detail="tamagoro" aria-labelledby="encyclopedia-tamagoro-title" hidden>
                <button class="encyclopedia-back" type="button" data-encyclopedia-back>‹ 図鑑にもどる</button>
                <div class="encyclopedia-entry-heading">
                    <p class="encyclopedia-entry-no">No.001 · たまごろう</p><h3 id="encyclopedia-tamagoro-title">たまごろう</h3>
                    <p class="encyclopedia-flavor">銀玉の音を聞きつけて現れた、好奇心旺盛なたまごろう。育つにつれて、その姿も変わっていく。</p>
                </div>
                <div class="encyclopedia-catalog-grid" aria-label="たまごろうの姿一覧">
                    <% int[] tamagoroStages = model.Pet.getEvolutionLevels(); String[] tamagoroNotes = {"殻の中身はまだ秘密。本人も知らないらしい。", "殻にひびが入り、黒い靄がちらり。まだ本人は卵のつもり。", "殻が浮いて、靄がふわり。中身もそろそろ外が気になる。", "上の殻を卒業！黒い中身も、ようやく外の世界へ。", "丸い耳がぴょこん。銀玉の音を聞くのが、ますます得意になった。", "殻が左右にぱかっ。外へ出る準備はできたけど、殻はまだ手放せない。", "殻の欠片をふわりと浮かせた。手が空いても、思い出の殻はそばにいる。", "全身が靄になって、目だけきらり。かくれんぼは得意だけど、目でばれる。", "靄の翼と小さな口が現れた。飛ぶより先に、にっこり笑ってみた。"}; for (int stageIndex = 0; stageIndex < tamagoroStages.length; stageIndex++) { %>
                    <article class="encyclopedia-catalog-card" style="grid-template-columns:80px minmax(0,1fr)">
                        <img class="encyclopedia-catalog-image pixel-art" style="width:80px;height:80px" src="${pageContext.request.contextPath}/images/pets/tamagoro/lv<%= tamagoroStages[stageIndex] %>.png" alt="LV<%= tamagoroStages[stageIndex] %>のたまごろう">
                        <div><h4>LV<%= tamagoroStages[stageIndex] %> · たまごろう</h4><p><%= stageIndex < tamagoroNotes.length ? tamagoroNotes[stageIndex] : "新しい姿に進化したたまごろう。冒険はまだまだ続く。" %></p></div>
                    </article>
                    <% } %>
                </div>
            </section>
            <section class="encyclopedia-entry-detail" data-encyclopedia-detail="food" aria-labelledby="encyclopedia-food-title" hidden>
                <button class="encyclopedia-back" type="button" data-encyclopedia-back>‹ 図鑑にもどる</button>
                <div class="encyclopedia-entry-heading">
                    <p class="encyclopedia-entry-no">No.002 · ごはん</p><h3 id="encyclopedia-food-title">ごはん</h3>
                    <p class="encyclopedia-flavor">食べると経験値が増える。高級メニューほど、食べる前から目が輝く。</p>
                </div>
                <div class="encyclopedia-catalog-grid" aria-label="ごはん全10種類">
                    <% String[] foodNotes = {"まずはこれ。迷ったらカリカリ、たまごろうも迷わない。", "余った玉が乳酸菌に変身。お腹もお財布もびっくり。", "勝負の前にひと皿。勝敗より先に香りで元気が出る。", "A5ランクのごちそう。食べる姿まで少し上品に見える。", "金ぴかだけど食べられる。歯みがきのことはあとで考える。", "秘伝の鍋でぐつぐつ。湯気の向こうに明日の元気が見える。", "小さな粒にプラチナ級の期待。ひと粒ずつ大切にどうぞ。", "味の感想は難しい。たまごろうは黙って完食した。", "宇宙規模のうまみをぎゅっと凝縮。スプーンも浮きそう。", "究極のゼリー。食べたあとの感想は『おかわり』らしい。"}; int foodIndex = 0; for (PetCareLogic.CareItem item : PetCareLogic.FOOD_ITEMS) { %>
                    <article class="encyclopedia-catalog-card">
                        <img class="encyclopedia-catalog-image pixel-art" src="${pageContext.request.contextPath}/images/pets/tamagoro/care/<%= item.id() %>.png" alt="">
                        <div><h4><%= item.name() %></h4><p><%= foodNotes[foodIndex++] %></p></div>
                    </article>
                    <% } %>
                </div>
            </section>
            <section class="encyclopedia-entry-detail" data-encyclopedia-detail="play" aria-labelledby="encyclopedia-play-title" hidden>
                <button class="encyclopedia-back" type="button" data-encyclopedia-back>‹ 図鑑にもどる</button>
                <div class="encyclopedia-entry-heading">
                    <p class="encyclopedia-entry-no">No.003 · あそぶ</p><h3 id="encyclopedia-play-title">あそぶ</h3>
                    <p class="encyclopedia-flavor">遊ぶほど経験値が増える。まとめて遊ぶと、先に息切れするのはだいたい飼い主。</p>
                </div>
                <div class="encyclopedia-catalog-grid" aria-label="あそび全10種類">
                    <% String[] playNotes = {"まずはじゃんけん。勝つと嬉しい、負けても経験値は嬉しい。", "銀玉を磨く遊び。気づくとたまごろうより玉がぴかぴか。", "ハンドルを固定して練習。真剣な顔だけはプロ級。", "実機を解体して仕組みを研究。戻すところまでが遊びです。", "ドル箱を高く積もう。崩れても片付け競争に早変わり。", "みんなでフィーバー。盛り上がりすぎて休憩を忘れがち。", "重力子を加速する不思議な遊び。説明書はたぶん宇宙にある。", "恒星系をまたいで大会開催。集合時間は光より早めに。", "因果律まで書き換えるスロットル。昨日の負けもなかったことに？", "多元宇宙を巻き込む大遊び。帰り道はひとつに決めてね。"}; int playIndex = 0; for (PetCareLogic.CareItem item : PetCareLogic.PLAY_ITEMS) { %>
                    <article class="encyclopedia-catalog-card">
                        <img class="encyclopedia-catalog-image pixel-art" src="${pageContext.request.contextPath}/images/pets/tamagoro/care/<%= item.id() %>.png" alt="">
                        <div><h4><%= item.name() %></h4><p><%= playNotes[playIndex++] %></p></div>
                    </article>
                    <% } %>
                </div>
            </section>
            <section class="encyclopedia-entry-detail" data-encyclopedia-detail="outfits" aria-labelledby="encyclopedia-outfits-title" hidden>
                <button class="encyclopedia-back" type="button" data-encyclopedia-back>‹ 図鑑にもどる</button>
                <div class="encyclopedia-entry-heading">
                    <p class="encyclopedia-entry-no">No.004 · おきがえ</p><h3 id="encyclopedia-outfits-title">おきがえ</h3>
                </div>
                <div class="encyclopedia-outfit-grid" aria-label="たまごろうの衣装4種類">
                    <article class="encyclopedia-outfit-card">
                        <span class="encyclopedia-outfit-icon encyclopedia-outfit-icon--empty" aria-hidden="true"></span>
                        <div><h4>ふつう</h4><p>たまごろうのいつもの姿。</p></div>
                    </article>
                    <article class="encyclopedia-outfit-card">
                        <img class="encyclopedia-outfit-icon pixel-art" src="${pageContext.request.contextPath}/images/pets/tamagoro/outfits/happi.png" alt="">
                        <div><h4>パチンコ法被</h4><p>お祭り気分で、今日の運も呼び込み中。</p></div>
                    </article>
                    <article class="encyclopedia-outfit-card">
                        <img class="encyclopedia-outfit-icon pixel-art" src="${pageContext.request.contextPath}/images/pets/tamagoro/outfits/sunglasses.png" alt="">
                        <div><h4>サングラス</h4><p>視線はクール。中身はいつもの好奇心。</p></div>
                    </article>
                    <article class="encyclopedia-outfit-card">
                        <img class="encyclopedia-outfit-icon pixel-art" src="${pageContext.request.contextPath}/images/pets/tamagoro/outfits/school-swimsuit.png" alt="">
                        <div><h4>水着</h4><p>水泳の準備は万全。まずは陸でポーズ。</p></div>
                    </article>
                </div>
            </section>
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
                <article class="achievement-card ${playRecord.forestUnlocked ? 'is-achieved' : ''}" data-background-achievement="forest" data-background-threshold="100">
                    <span class="achievement-seal">森</span><div><h3>森の背景</h3><p>総操作100回 <small data-background-progress="forest">現在 ${playRecord.formattedTotalActions}回</small></p></div><strong data-background-achievement-state="forest">${playRecord.forestUnlocked ? '獲得済み' : '未獲得'}</strong>
                </article>
                <article class="achievement-card ${playRecord.poolUnlocked ? 'is-achieved' : ''}" data-background-achievement="pool" data-background-threshold="500">
                    <span class="achievement-seal">水</span><div><h3>プールの背景</h3><p>総操作500回 <small data-background-progress="pool">現在 ${playRecord.formattedTotalActions}回</small></p></div><strong data-background-achievement-state="pool">${playRecord.poolUnlocked ? '獲得済み' : '未獲得'}</strong>
                </article>
                <article class="achievement-card ${playRecord.pacificUnlocked ? 'is-achieved' : ''}" data-background-achievement="pacific" data-background-threshold="2500">
                    <span class="achievement-seal">海</span><div><h3>太平洋の背景</h3><p>総操作2,500回 <small data-background-progress="pacific">現在 ${playRecord.formattedTotalActions}回</small></p></div><strong data-background-achievement-state="pacific">${playRecord.pacificUnlocked ? '獲得済み' : '未獲得'}</strong>
                </article>
                <article class="achievement-card ${playRecord.spaceUnlocked ? 'is-achieved' : ''}" data-background-achievement="space" data-background-threshold="12500">
                    <span class="achievement-seal">宇宙</span><div><h3>宇宙の背景</h3><p>総操作12,500回 <small data-background-progress="space">現在 ${playRecord.formattedTotalActions}回</small></p></div><strong data-background-achievement-state="space">${playRecord.spaceUnlocked ? '獲得済み' : '未獲得'}</strong>
                </article>
            </div>
            <section class="background-unlock ${playRecord.backgroundUnlocked ? 'is-unlocked' : ''}" aria-label="背景カスタマイズ枠">
                <div class="background-unlock-copy">
                    <p class="dashboard-eyebrow">ROOM CUSTOMIZE</p>
                    <h3>背景コレクション</h3>
                    <p>背景メニューから獲得済みの背景を選べます。</p>
                </div>
            </section>
            <p class="dashboard-footnote">背景は操作回数の実績で獲得できます。獲得状況は今回の展示中のみ保持されます。</p>
        </div>
    </div>

    <div class="dashboard-dialog" data-dialog="background" role="dialog" aria-modal="true" aria-labelledby="background-title" hidden>
        <div class="dashboard-dialog-panel">
            <div class="dashboard-dialog-heading">
                <div><p class="dashboard-eyebrow">ROOM CUSTOMIZE</p><h2 id="background-title">背景を選ぶ</h2></div>
                <button class="dashboard-close" type="button" data-close-dialog aria-label="閉じる">×</button>
            </div>
            <p class="background-choice-intro" data-background-copy>${playRecord.nextBackgroundMessage}</p>
            <div class="background-options" aria-label="背景を選択">
                <button class="background-option ${playRecord.selectedBackground == 'room' ? 'is-selected' : ''}"
                        type="button" data-background-choice="room" aria-pressed="${playRecord.selectedBackground == 'room'}"
                        data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/room.png">
                    <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/room.png" alt="">
                    <span>部屋 <small>いつもの背景</small></span>
                </button>
                <button class="background-option ${playRecord.selectedBackground == 'forest' ? 'is-selected' : ''}"
                        type="button" data-background-choice="forest" data-background-threshold="100" aria-pressed="${playRecord.selectedBackground == 'forest'}"
                        data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/forest.png"
                        ${playRecord.forestUnlocked ? '' : 'disabled'}>
                    <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/forest.png" alt="">
                    <span>森 <small>100回で獲得</small></span>
                </button>
                <button class="background-option ${playRecord.selectedBackground == 'pool' ? 'is-selected' : ''}"
                        type="button" data-background-choice="pool" data-background-threshold="500" aria-pressed="${playRecord.selectedBackground == 'pool'}"
                        data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/pool.png"
                        ${playRecord.poolUnlocked ? '' : 'disabled'}>
                    <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/pool.png" alt="">
                    <span>プール <small>500回で獲得</small></span>
                </button>
                <button class="background-option ${playRecord.selectedBackground == 'pacific' ? 'is-selected' : ''}"
                        type="button" data-background-choice="pacific" data-background-threshold="2500" aria-pressed="${playRecord.selectedBackground == 'pacific'}"
                        data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/pacific.png"
                        ${playRecord.pacificUnlocked ? '' : 'disabled'}>
                    <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/pacific.png" alt="">
                    <span>太平洋 <small>2,500回で獲得</small></span>
                </button>
                <button class="background-option ${playRecord.selectedBackground == 'space' ? 'is-selected' : ''}"
                        type="button" data-background-choice="space" data-background-threshold="12500" aria-pressed="${playRecord.selectedBackground == 'space'}"
                        data-background-image="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/space.png"
                        ${playRecord.spaceUnlocked ? '' : 'disabled'}>
                    <img src="${pageContext.request.contextPath}/images/pets/tamagoro/backgrounds/space.png" alt="">
                    <span>宇宙 <small>12,500回で獲得</small></span>
                </button>
            </div>
            <p class="dashboard-footnote" data-background-state>ロック中の背景は、実績を獲得すると選べます。</p>
        </div>
    </div>
</div>
