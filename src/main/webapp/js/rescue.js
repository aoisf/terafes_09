// 救済モーダル＆ミニゲーム制御スクリプト
var rescueModal = document.getElementById('rescue-modal');
var rescueMenu = document.getElementById('rescue-menu');
var rescueGameArea = document.getElementById('rescue-game-area');
var gameTitle = document.getElementById('game-title');
var gameCanvas = document.getElementById('game-canvas');
var gameControls = document.getElementById('game-controls');
var activeInterval = null;

// 厳密な0発チェック（EclipseのES5バリデータ対策で0nを使わず判定）
function checkZeroBalls(ballsVal) {
    if (!rescueModal) return;
    try {
        var cleaned = String(ballsVal).replace(/[^0-9]/g, '');
        // 文字列が空でなく、すべて0（または数値変換して0）の場合
        if (cleaned !== '' && /^0+$/.test(cleaned)) {
            rescueModal.style.setProperty('display', 'flex', 'important');
        } else {
            rescueModal.style.setProperty('display', 'none', 'important');
        }
    } catch (e) {
        rescueModal.style.setProperty('display', 'none', 'important');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    rescueModal = document.getElementById('rescue-modal');
    rescueMenu = document.getElementById('rescue-menu');
    rescueGameArea = document.getElementById('rescue-game-area');
    gameTitle = document.getElementById('game-title');
    gameCanvas = document.getElementById('game-canvas');
    gameControls = document.getElementById('game-controls');

    if (rescueModal) {
        var initialBalls = rescueModal.getAttribute('data-initial-balls');
        checkZeroBalls(initialBalls);
    }

    // 玉数表示の変更監視（0発になった瞬間に表示）
    var ballElem = document.getElementById('main-ball-count');
    if (ballElem) {
        var ballObserver = new MutationObserver(function() {
            checkZeroBalls(ballElem.textContent);
        });
        ballObserver.observe(ballElem, { childList: true, characterData: true, subtree: true });
    }
});

function cancelRescueGame() {
    if (activeInterval) clearInterval(activeInterval);
    if (rescueGameArea) rescueGameArea.style.display = 'none';
    if (rescueMenu) rescueMenu.style.display = 'flex';
    if (gameCanvas) gameCanvas.innerHTML = '';
    if (gameControls) gameControls.innerHTML = '';
}

function startRescueGame(type) {
    if (rescueMenu) rescueMenu.style.display = 'none';
    if (rescueGameArea) rescueGameArea.style.display = 'block';
    if (gameCanvas) gameCanvas.innerHTML = '';
    if (gameControls) gameControls.innerHTML = '';

    if (type === 'pick') runPickGame();
    else if (type === 'help') runHelpGame();
    else if (type === 'work') runWorkGame();
}

// ==========================================
// 1. 道で玉を拾う
// ==========================================
function runPickGame() {
    var picked = 0;
    var targetCount = 3;
    gameTitle.textContent = '落ちている銀玉をタップして拾おう！（残り: ' + (targetCount - picked) + '個）';

    function spawnBall() {
        if (picked >= targetCount) return;
        var ball = document.createElement('div');

        ball.style.width = '30px';
        ball.style.height = '30px';
        ball.style.borderRadius = '50%';
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
    var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    fetch(contextPath + '/action', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: 'action=rescue&type=' + type
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (!data.success) {
            cancelRescueGame();
            checkZeroBalls(data.balls);
            if (rescueModal && rescueModal.style.display !== 'none') {
                rescueGameArea.style.display = 'block';
                rescueMenu.style.display = 'none';
                gameTitle.textContent = '救済を利用できません。玉数を確認してください。';
            }
            return;
        }

        cancelRescueGame();
        if (rescueModal) rescueModal.style.setProperty('display', 'none', 'important');

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
