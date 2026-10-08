<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>玉の数だけ愛される？パチペット生活</title>
    <!-- 分割したCSSを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pachinko.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/control.css">

    <style>
        /* 救済ポップアップ（背景オーバーレイ） */
        #rescue-modal {
            display: none;
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100vw !important;
            height: 100vh !important;
            background-color: rgba(0, 0, 0, 0.75) !important;
            z-index: 999999 !important;
            justify-content: center !important;
            align-items: center !important;
        }

        .rescue-modal-box {
            background: #ffffff !important;
            width: 90% !important;
            max-width: 360px !important;
            padding: 20px 16px !important;
            border-radius: 12px !important;
            border: 3px solid #ff4444 !important;
            text-align: center !important;
            box-shadow: 0 8px 24px rgba(0,0,0,0.5) !important;
            box-sizing: border-box !important;
        }

        .rescue-btn-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 15px;
        }

        .rescue-action-btn {
            border: 2px solid #333;
            border-radius: 8px;
            padding: 10px 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            cursor: pointer;
            font-weight: bold;
            font-size: 0.95rem;
        }

        .rescue-btn-pick { background: #e0f2fe; color: #0369a1; border-color: #0284c7; }
        .rescue-btn-help { background: #fef3c7; color: #b45309; border-color: #d97706; }
        .rescue-btn-work { background: #dcfce7; color: #15803d; border-color: #16a34a; }

        .game-canvas-area {
            width: 260px;
            height: 140px;
            background: #f8fafc;
            border: 2px dashed #64748b;
            border-radius: 8px;
            margin: 10px auto;
            position: relative;
            box-sizing: border-box;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <!-- メイン画面コンテナ -->
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/room.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/pachinko.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/control.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/command.jsp" />
    </div>

    <%-- 救済ポップアップ（0発のときだけ画面中央に出現） --%>
    <div id="rescue-modal">
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

    <%-- パチンコ結果トースト --%>
    <%
        String actionMsg = (String) session.getAttribute("actionMessage");
        if (actionMsg != null && !actionMsg.isEmpty()) {
            boolean isHit = actionMsg.contains("大当り");
            session.removeAttribute("actionMessage");

            String formattedMsg = actionMsg;
            if (isHit) {
                formattedMsg = actionMsg.replaceAll("(\\d+発)", "<span class=\"rainbow-text\">$1</span>");
            }
    %>
        <div id="result-toast" class="pachinko-result-toast <%= isHit ? "hit" : "miss" %>">
            <% if (isHit) { %>
                ✨ <%= formattedMsg %> ✨
            <% } else { %>
                <%= formattedMsg %>
            <% } %>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var toast = document.getElementById('result-toast');
                if (toast) {
                    requestAnimationFrame(function() {
                        toast.classList.add('show');
                    });
                    var duration = <%= isHit ? 3200 : 2200 %>;
                    setTimeout(function() {
                        toast.classList.remove('show');
                        setTimeout(function() { toast.remove(); }, 400);
                    }, duration);
                }
            });
        </script>
    <%
        }
    %>

    <script src="${pageContext.request.contextPath}/js/pachinko.js"></script>
    <script src="${pageContext.request.contextPath}/js/command.js"></script>

    <!-- 救済モーダル＆ミニゲーム制御スクリプト -->
    <script>
        var rescueModal = document.getElementById('rescue-modal');
        var rescueMenu = document.getElementById('rescue-menu');
        var rescueGameArea = document.getElementById('rescue-game-area');
        var gameTitle = document.getElementById('game-title');
        var gameCanvas = document.getElementById('game-canvas');
        var gameControls = document.getElementById('game-controls');
        var activeInterval = null;

        // 厳密な0発チェック
        function checkZeroBalls(ballsVal) {
            if (!rescueModal) return;
            try {
                var cleaned = String(ballsVal).replace(/[^0-9]/g, '');
                if (cleaned !== '' && BigInt(cleaned) === 0n) {
                    rescueModal.style.setProperty('display', 'flex', 'important');
                } else {
                    rescueModal.style.setProperty('display', 'none', 'important');
                }
            } catch (e) {
                rescueModal.style.setProperty('display', 'none', 'important');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            checkZeroBalls("${pet.balls}");
        });

        // 玉数表示の変更監視（0発になった瞬間に表示）
        var ballElem = document.getElementById('main-ball-count');
        if (ballElem) {
            var ballObserver = new MutationObserver(function() {
                checkZeroBalls(ballElem.textContent);
            });
            ballObserver.observe(ballElem, { childList: true, characterData: true, subtree: true });
        }

        function cancelRescueGame() {
            if (activeInterval) clearInterval(activeInterval);
            rescueGameArea.style.display = 'none';
            rescueMenu.style.display = 'flex';
            gameCanvas.innerHTML = '';
            gameControls.innerHTML = '';
        }

        function startRescueGame(type) {
            rescueMenu.style.display = 'none';
            rescueGameArea.style.display = 'block';
            gameCanvas.innerHTML = '';
            gameControls.innerHTML = '';

            if (type === 'pick') runPickGame();
            else if (type === 'help') runHelpGame();
            else if (type === 'work') runWorkGame();
        }

        // ==========================================
        // 1. 道で玉を拾う（インラインスタイルで確実描画）
        // ==========================================
        function runPickGame() {
            var picked = 0;
            var targetCount = 3;
            gameTitle.textContent = '落ちている銀玉をタップして拾おう！（残り: ' + (targetCount - picked) + '個）';

            function spawnBall() {
                if (picked >= targetCount) return;
                var ball = document.createElement('div');

                // 絶対に表示されるインラインスタイル
                ball.style.width = '30px';
                ball.style.height = '30px';
                ball.style.borderRadius = '50%';
                ball.style.background = '#silver';
                ball.style.backgroundColor = '#94a3b8';
                ball.style.border = '2px solid #334155';
                ball.style.boxShadow = '0 3px 6px rgba(0,0,0,0.3)';
                ball.style.position = 'absolute';
                ball.style.cursor = 'pointer';
                ball.style.display = 'flex';
                ball.style.justifyContent = 'center';
                ball.style.alignItems = 'center';
                ball.style.fontSize = '14px';
                ball.innerHTML = '⚪';

                var x = Math.floor(Math.random() * 210) + 10;
                var y = Math.floor(Math.random() * 90) + 10;
                ball.style.left = x + 'px';
                ball.style.top = y + 'px';

                ball.addEventListener('click', function() {
                    picked++;
                    ball.remove();
                    if (picked >= targetCount) {
                        gameTitle.textContent = '3個拾えたよ！';
                        finishRescue('pick');
                    } else {
                        gameTitle.textContent = '落ちている銀玉をタップして拾おう！（残り: ' + (targetCount - picked) + '個）';
                        spawnBall();
                    }
                });
                gameCanvas.appendChild(ball);
            }
            spawnBall();
        }

        // ==========================================
        // 2. お手伝いをする（連打ゲージ）
        // ==========================================
        function runHelpGame() {
            gameTitle.textContent = 'そうじボタンを5回連打しよう！';
            var progress = 0;
            var needed = 5;

            var barBox = document.createElement('div');
            barBox.style.width = '85%';
            barBox.style.height = '22px';
            barBox.style.backgroundColor = '#e2e8f0';
            barBox.style.border = '2px solid #64748b';
            barBox.style.borderRadius = '11px';
            barBox.style.overflow = 'hidden';
            barBox.style.margin = '25px auto 10px auto';

            var barFill = document.createElement('div');
            barFill.style.width = '0%';
            barFill.style.height = '100%';
            barFill.style.backgroundColor = '#f59e0b';
            barFill.style.transition = 'width 0.1s ease';
            barBox.appendChild(barFill);

            var countText = document.createElement('div');
            countText.style.fontSize = '0.85rem';
            countText.style.color = '#555';
            countText.textContent = '進行度: 0 / 5';

            gameCanvas.appendChild(barBox);
            gameCanvas.appendChild(countText);

            var tapBtn = document.createElement('button');
            tapBtn.type = 'button';
            tapBtn.textContent = '🧹 そうじする！';
            tapBtn.style.padding = '8px 24px';
            tapBtn.style.backgroundColor = '#d97706';
            tapBtn.style.color = 'white';
            tapBtn.style.fontWeight = 'bold';
            tapBtn.style.fontSize = '0.95rem';
            tapBtn.style.border = '2px solid #92400e';
            tapBtn.style.borderRadius = '8px';
            tapBtn.style.cursor = 'pointer';

            tapBtn.addEventListener('click', function() {
                progress++;
                var percent = Math.min(100, Math.floor((progress / needed) * 100));
                barFill.style.width = percent + '%';
                countText.textContent = '進行度: ' + progress + ' / ' + needed;
                if (progress >= needed) {
                    tapBtn.disabled = true;
                    tapBtn.textContent = 'おそうじ完了！';
                    setTimeout(function() { finishRescue('help'); }, 300);
                }
            });

            gameControls.appendChild(tapBtn);
        }

        // ==========================================
        // 3. バイトをする（目押しゲーム）
        // ==========================================
        function runWorkGame() {
            gameTitle.textContent = '黄色ゾーンでタイミングよくストップ！';

            var rail = document.createElement('div');
            rail.style.width = '230px';
            rail.style.height = '34px';
            rail.style.backgroundColor = '#cbd5e1';
            rail.style.border = '2px solid #475569';
            rail.style.borderRadius = '17px';
            rail.style.position = 'relative';
            rail.style.margin = '35px auto 0 auto';
            rail.style.overflow = 'hidden';

            // 成功ゾーン（黄色）
            var zone = document.createElement('div');
            zone.style.position = 'absolute';
            zone.style.left = '75px';
            zone.style.width = '80px';
            zone.style.height = '100%';
            zone.style.backgroundColor = '#facc15';
            zone.style.display = 'flex';
            zone.style.alignItems = 'center';
            zone.style.justifyContent = 'center';
            zone.style.fontSize = '11px';
            zone.style.fontWeight = 'bold';
            zone.style.color = '#854d0e';
            zone.textContent = 'HIT!';
            rail.appendChild(zone);

            // 動くカーソル（赤いバー）
            var cursor = document.createElement('div');
            cursor.style.position = 'absolute';
            cursor.style.top = '0';
            cursor.style.left = '0';
            cursor.style.width = '14px';
            cursor.style.height = '100%';
            cursor.style.backgroundColor = '#dc2626';
            cursor.style.boxShadow = '0 0 4px #000';
            rail.appendChild(cursor);

            gameCanvas.appendChild(rail);

            var stopBtn = document.createElement('button');
            stopBtn.type = 'button';
            stopBtn.textContent = 'ストップ！';
            stopBtn.style.padding = '8px 26px';
            stopBtn.style.backgroundColor = '#16a34a';
            stopBtn.style.color = 'white';
            stopBtn.style.fontWeight = 'bold';
            stopBtn.style.fontSize = '0.95rem';
            stopBtn.style.border = '2px solid #15803d';
            stopBtn.style.borderRadius = '8px';
            stopBtn.style.cursor = 'pointer';

            var pos = 0;
            var direction = 1;
            var speed = 3;

            activeInterval = setInterval(function() {
                pos += speed * direction;
                if (pos >= 216) { pos = 216; direction = -1; }
                if (pos <= 0) { pos = 0; direction = 1; }
                cursor.style.left = pos + 'px';
            }, 16);

            stopBtn.addEventListener('click', function() {
                if (activeInterval) clearInterval(activeInterval);
                stopBtn.disabled = true;

                // 判定ゾーン: 75px - 14px 〜 155px
                if (pos >= 68 && pos <= 152) {
                    stopBtn.textContent = '大成功！';
                    stopBtn.style.backgroundColor = '#22c55e';
                    setTimeout(function() { finishRescue('work'); }, 400);
                } else {
                    stopBtn.textContent = '失敗…やり直し！';
                    stopBtn.style.backgroundColor = '#ef4444';
                    setTimeout(function() {
                        gameCanvas.innerHTML = '';
                        gameControls.innerHTML = '';
                        runWorkGame();
                    }, 800);
                }
            });

            gameControls.appendChild(stopBtn);
        }

        // 救済完了処理
        function finishRescue(type) {
            fetch('${pageContext.request.contextPath}/action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Accept': 'application/json'
                },
                body: 'action=rescue&type=' + type
            })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                cancelRescueGame();
                rescueModal.style.setProperty('display', 'none', 'important');

                var bElem = document.getElementById('main-ball-count');
                if (bElem) {
                    bElem.textContent = data.balls + '発';
                }
            })
            .catch(function(err) {
                console.error(err);
                cancelRescueGame();
            });
        }
    </script>
</body>
</html>