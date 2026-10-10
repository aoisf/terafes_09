// 救済モーダルとミニゲームの操作
var rescueModal = null;
var rescueMenu = null;
var rescueGameArea = null;
var gameTitle = null;
var gameCanvas = null;
var gameControls = null;
var rescueStatus = null;
var activeInterval = null;
var activeTimeout = null;
var rescueRequestPending = false;

function setRescueOpen(isOpen) {
    if (!rescueModal) return;
    var wasOpen = rescueModal.classList.contains('is-open');
    rescueModal.classList.toggle('is-open', isOpen);
    rescueModal.setAttribute('aria-hidden', String(!isOpen));
    document.body.classList.toggle('rescue-open', isOpen);

    var app = document.querySelector('.app-container');
    if (app) app.inert = isOpen;

    if (isOpen && !wasOpen) {
        window.setTimeout(function() {
            var firstButton = rescueMenu && rescueMenu.querySelector('button:not(:disabled)');
            if (firstButton) firstButton.focus();
        }, 0);
    } else if (!isOpen && wasOpen) {
        var startButton = document.getElementById('start-button');
        if (startButton) startButton.focus();
    }
}

function checkZeroBalls(ballsVal) {
    if (!rescueModal) return;
    var cleaned = String(ballsVal == null ? '' : ballsVal).replace(/[^0-9]/g, '');
    setRescueOpen(cleaned !== '' && /^0+$/.test(cleaned));
}

function setRescueStatus(message) {
    if (!rescueStatus) return;
    rescueStatus.textContent = message || '';
    rescueStatus.hidden = !message;
}

function focusGameControl() {
    var button = gameControls && gameControls.querySelector('button:not(:disabled)');
    if (button) button.focus();
    else {
        var pickup = gameCanvas && gameCanvas.querySelector('button:not(:disabled)');
        if (pickup) pickup.focus();
    }
}

function showRescueGame(type) {
    if (!rescueMenu || !rescueGameArea || rescueRequestPending) return;
    setRescueStatus('');
    rescueMenu.classList.add('is-hidden');
    rescueGameArea.classList.remove('is-hidden');
    rescueGameArea.classList.add('is-active');
    gameCanvas.innerHTML = '';
    gameControls.innerHTML = '';

    if (type === 'pick') runPickGame();
    else if (type === 'help') runHelpGame();
    else if (type === 'work') runWorkGame();
    else {
        cancelRescueGame(false);
        setRescueStatus('ゲームを選び直してください。');
        return;
    }
    window.setTimeout(focusGameControl, 0);
}

function cancelRescueGame(restoreMenuFocus) {
    if (activeInterval) window.clearInterval(activeInterval);
    if (activeTimeout) window.clearTimeout(activeTimeout);
    activeInterval = null;
    activeTimeout = null;
    if (rescueGameArea) {
        rescueGameArea.classList.remove('is-active');
        rescueGameArea.classList.add('is-hidden');
    }
    if (rescueMenu) rescueMenu.classList.remove('is-hidden');
    if (gameCanvas) gameCanvas.innerHTML = '';
    if (gameControls) gameControls.innerHTML = '';
    if (restoreMenuFocus !== false) {
        var firstButton = rescueMenu && rescueMenu.querySelector('button:not(:disabled)');
        if (firstButton) firstButton.focus();
    }
}

function makeRescueButton(label, extraClass) {
    var button = document.createElement('button');
    button.type = 'button';
    button.className = 'rescue-game-button ' + extraClass;
    button.textContent = label;
    return button;
}

function createScoreHud(label, goal, seconds) {
    var hud = document.createElement('div');
    hud.className = 'rescue-score-hud';
    var score = document.createElement('span');
    score.className = 'rescue-score-value';
    score.textContent = label + ': 0 / ' + goal;
    var timer = document.createElement('span');
    timer.className = 'rescue-timer';
    timer.setAttribute('role', 'timer');
    timer.textContent = '⏱ ' + seconds + '秒';
    hud.appendChild(score);
    hud.appendChild(timer);

    var track = document.createElement('div');
    track.className = 'rescue-progress-track';
    track.setAttribute('role', 'progressbar');
    track.setAttribute('aria-label', label);
    track.setAttribute('aria-valuemin', '0');
    track.setAttribute('aria-valuemax', String(goal));
    track.setAttribute('aria-valuenow', '0');
    var fill = document.createElement('div');
    fill.className = 'rescue-progress-fill';
    track.appendChild(fill);
    gameCanvas.appendChild(hud);
    gameCanvas.appendChild(track);

    return {
        update: function(value, timeLeft) {
            score.textContent = label + ': ' + value + ' / ' + goal;
            timer.textContent = '⏱ ' + timeLeft + '秒';
            timer.classList.toggle('is-urgent', timeLeft <= 5);
            fill.style.width = Math.min(100, value / goal * 100) + '%';
            track.setAttribute('aria-valuenow', String(value));
        }
    };
}

function showRetryButton(label, restart) {
    gameControls.innerHTML = '';
    var button = makeRescueButton(label, 'rescue-retry-button');
    button.addEventListener('click', function() {
        gameCanvas.innerHTML = '';
        gameControls.innerHTML = '';
        restart();
        focusGameControl();
    });
    gameControls.appendChild(button);
    button.focus();
}

function completeMiniGame(type, message) {
    if (activeInterval) window.clearInterval(activeInterval);
    if (activeTimeout) window.clearTimeout(activeTimeout);
    activeInterval = null;
    activeTimeout = null;
    gameTitle.textContent = message;
    gameControls.innerHTML = '';
    var notice = document.createElement('p');
    notice.className = 'rescue-success-note';
    notice.setAttribute('role', 'status');
    notice.textContent = '救済センターへ結果を送っています…';
    gameControls.appendChild(notice);
    finishRescueAfterDelay(type, 550);
}

function runPickGame() {
    var goal = 8;
    var secondsLeft = 18;
    var score = 0;
    var spawnCount = 0;
    var combo = 0;
    gameTitle.textContent = '18秒以内に銀玉を集めよう。金の玉は2ポイント！';
    var hud = createScoreHud('獲得ポイント', goal, secondsLeft);

    function spawnBall() {
        if (score >= goal) return;
        var ball = document.createElement('button');
        ball.type = 'button';
        var isGold = ++spawnCount % 4 === 0;
        ball.className = 'rescue-pickup-ball' + (isGold ? ' is-gold' : '');
        ball.setAttribute('aria-label', isGold ? '金の玉を拾う。2ポイント' : '銀玉を拾う。1ポイント');
        ball.textContent = isGold ? '✦' : '⚪';
        var maxX = Math.max(0, gameCanvas.clientWidth - 38);
        var maxY = Math.max(28, gameCanvas.clientHeight - 38);
        ball.style.setProperty('--ball-x', Math.floor(Math.random() * (maxX + 1)) + 'px');
        ball.style.setProperty('--ball-y', (28 + Math.floor(Math.random() * (maxY - 27))) + 'px');
        ball.addEventListener('click', function() {
            if (score >= goal || secondsLeft <= 0) return;
            combo++;
            score = Math.min(goal, score + (isGold ? 2 : 1));
            hud.update(score, secondsLeft);
            gameTitle.textContent = combo >= 3 ? 'コンボ！いい調子！' : '銀玉を集めよう！';
            ball.remove();
            if (score >= goal) completeMiniGame('pick', 'フィーバー！銀玉を集めきった！');
            else spawnBall();
        });
        gameCanvas.appendChild(ball);
    }

    spawnBall();
    activeInterval = window.setInterval(function() {
        secondsLeft--;
        hud.update(score, secondsLeft);
        if (secondsLeft <= 0) {
            window.clearInterval(activeInterval);
            activeInterval = null;
            gameTitle.textContent = 'タイムアップ！あと少しだったね。';
            showRetryButton('もう一度チャレンジ', runPickGame);
        }
    }, 1000);
}

function runHelpGame() {
    var goal = 8;
    var secondsLeft = 25;
    var progress = 0;
    var combo = 0;
    var mistakes = 0;
    var items = [
        { icon: '📰', name: '新聞紙', category: 'recycle' },
        { icon: '🥫', name: '空き缶', category: 'recycle' },
        { icon: '🧴', name: 'ペットボトル', category: 'recycle' },
        { icon: '🍌', name: 'バナナの皮', category: 'burn' },
        { icon: '🧻', name: '使ったティッシュ', category: 'burn' },
        { icon: '📦', name: '汚れた紙箱', category: 'burn' },
        { icon: '🔋', name: '乾電池', category: 'other' },
        { icon: '☂️', name: 'こわれた傘', category: 'other' }
    ];
    gameTitle.textContent = '25秒以内に8個を分別しよう。間違えると3秒減るよ！';
    var hud = createScoreHud('分別できた数', goal, secondsLeft);
    var itemCard = document.createElement('div');
    itemCard.className = 'rescue-sort-item';
    itemCard.setAttribute('aria-live', 'polite');
    var itemIcon = document.createElement('span');
    itemIcon.className = 'rescue-sort-icon';
    var itemName = document.createElement('strong');
    itemName.className = 'rescue-sort-name';
    itemCard.appendChild(itemIcon);
    itemCard.appendChild(itemName);
    gameCanvas.appendChild(itemCard);

    var bins = document.createElement('div');
    bins.className = 'rescue-sort-bins';
    var categories = [
        { id: 'burn', icon: '🔥', label: '燃える' },
        { id: 'recycle', icon: '♻️', label: '資源' },
        { id: 'other', icon: '🗑️', label: '燃えない' }
    ];
    categories.forEach(function(category) {
        var button = document.createElement('button');
        button.type = 'button';
        button.className = 'rescue-sort-bin';
        button.setAttribute('data-category', category.id);
        button.setAttribute('aria-label', category.label + 'ゴミに分別');
        var icon = document.createElement('span');
        icon.className = 'rescue-sort-bin-icon';
        icon.textContent = category.icon;
        var label = document.createElement('span');
        label.textContent = category.label;
        button.appendChild(icon);
        button.appendChild(label);
        bins.appendChild(button);
    });
    gameControls.appendChild(bins);

    for (var i = items.length - 1; i > 0; i--) {
        var swapIndex = Math.floor(Math.random() * (i + 1));
        var temp = items[i];
        items[i] = items[swapIndex];
        items[swapIndex] = temp;
    }

    var currentIndex = 0;
    var changingItem = false;
    function showItem() {
        var item = items[currentIndex];
        itemIcon.textContent = item.icon;
        itemName.textContent = item.name;
        itemCard.classList.remove('is-correct', 'is-wrong');
    }
    bins.addEventListener('click', function(event) {
        var button = event.target.closest('[data-category]');
        if (!button || changingItem || secondsLeft <= 0 || progress >= goal) return;

        if (button.getAttribute('data-category') === items[currentIndex].category) {
            progress++;
            combo++;
            hud.update(progress, secondsLeft);
            itemCard.classList.add('is-correct');
            gameTitle.textContent = combo >= 3 ? combo + '連続正解！すごい！' : '正解！その調子！';
            if (progress >= goal) {
                completeMiniGame('help', '全問分別成功！お手伝い完了！');
                return;
            }
            changingItem = true;
            currentIndex++;
            activeTimeout = window.setTimeout(function() {
                activeTimeout = null;
                if (secondsLeft <= 0) return;
                showItem();
                changingItem = false;
            }, 180);
        } else {
            mistakes++;
            combo = 0;
            secondsLeft = Math.max(0, secondsLeft - 3);
            hud.update(progress, secondsLeft);
            itemCard.classList.remove('is-wrong');
            void itemCard.offsetWidth;
            itemCard.classList.add('is-wrong');
            gameTitle.textContent = 'おしい！分別を確認してね（ミス ' + mistakes + '回）';
            if (secondsLeft === 0) endSortingGame();
        }
    });
    showItem();

    function endSortingGame() {
        if (activeInterval) window.clearInterval(activeInterval);
        activeInterval = null;
        gameTitle.textContent = '時間切れ！もう一度分別に挑戦しよう。';
        showRetryButton('分別をやり直す', runHelpGame);
    }

    activeInterval = window.setInterval(function() {
        secondsLeft--;
        hud.update(progress, secondsLeft);
        if (secondsLeft <= 0) {
            endSortingGame();
        }
    }, 1000);
}

function runWorkGame() {
    var round = 1;
    var totalRounds = 3;

    function startRound() {
        gameTitle.textContent = '3ラウンド連続で黄色ゾーンを狙おう！';
        gameCanvas.innerHTML = '';
        gameControls.innerHTML = '';
        var hud = document.createElement('div');
        hud.className = 'rescue-work-hud';
        hud.textContent = 'ラウンド ' + round + ' / ' + totalRounds;
        gameCanvas.appendChild(hud);

        var rail = document.createElement('div');
        rail.className = 'rescue-work-rail';
        rail.setAttribute('aria-label', '黄色い成功ゾーンで止めてください');
        var zone = document.createElement('div');
        zone.className = 'rescue-work-zone';
        var zoneWidth = Math.max(36, 78 - (round - 1) * 16);
        var railWidth = rail.clientWidth || 230;
        var zoneLeft = Math.floor(Math.random() * Math.max(1, railWidth - zoneWidth));
        zone.style.setProperty('--zone-left', zoneLeft + 'px');
        zone.style.setProperty('--zone-width', zoneWidth + 'px');
        zone.textContent = 'HIT!';
        var cursor = document.createElement('div');
        cursor.className = 'rescue-work-cursor';
        rail.appendChild(zone);
        rail.appendChild(cursor);
        gameCanvas.appendChild(rail);

        var feedback = document.createElement('p');
        feedback.className = 'rescue-work-feedback';
        feedback.setAttribute('aria-live', 'polite');
        feedback.textContent = round === 1 ? 'ストップを押してタイミングを合わせよう！' : '次のラウンドは少し速くなるよ！';
        gameCanvas.appendChild(feedback);

        var stopButton = makeRescueButton('ストップ！', 'rescue-stop-button');
        var pos = 0;
        var direction = 1;
        var speed = 3 + (round - 1) * 1.4;
        var maxPosition = Math.max(0, railWidth - 18);
        activeInterval = window.setInterval(function() {
            pos += speed * direction;
            if (pos >= maxPosition) { pos = maxPosition; direction = -1; }
            if (pos <= 0) { pos = 0; direction = 1; }
            cursor.style.setProperty('--cursor-x', pos + 'px');
        }, 16);

        stopButton.addEventListener('click', function() {
            if (activeInterval) window.clearInterval(activeInterval);
            activeInterval = null;
            stopButton.disabled = true;
            if (pos + 7 >= zoneLeft && pos + 7 <= zoneLeft + zoneWidth) {
                stopButton.classList.add('is-success');
                stopButton.textContent = 'ジャスト！';
                feedback.textContent = '成功！';
                round++;
                if (round > totalRounds) completeMiniGame('work', '目押し成功！3ラウンド達成！');
                else {
                    activeTimeout = window.setTimeout(function() {
                        activeTimeout = null;
                        startRound();
                        focusGameControl();
                    }, 650);
                }
            } else {
                stopButton.classList.add('is-failure');
                stopButton.textContent = '惜しい！';
                feedback.textContent = 'ゾーンを逃した！このラウンドから再挑戦。';
                activeTimeout = window.setTimeout(function() {
                    activeTimeout = null;
                    startRound();
                    focusGameControl();
                }, 850);
            }
        });
        gameControls.appendChild(stopButton);
    }

    startRound();
}

function finishRescueAfterDelay(type, delay) {
    activeTimeout = window.setTimeout(function() {
        activeTimeout = null;
        finishRescue(type);
    }, delay);
}

function updateBallDisplay(value) {
    var ballElement = document.getElementById('main-ball-count');
    if (!ballElement || value == null) return;
    try {
        ballElement.textContent = BigInt(value).toLocaleString() + '発';
    } catch (error) {
        ballElement.textContent = String(value) + '発';
    }
}

function finishRescue(type) {
    if (rescueRequestPending) return;
    rescueRequestPending = true;
    if (rescueModal) rescueModal.setAttribute('aria-busy', 'true');
    rescueModal.querySelectorAll('button').forEach(function(button) { button.disabled = true; });

    var contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    fetch(contextPath + '/action', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        body: 'action=rescue&type=' + encodeURIComponent(type)
    })
    .then(function(response) {
        if (!response.ok) throw new Error('HTTP ' + response.status);
        return response.json();
    })
    .then(function(data) {
        updateBallDisplay(data.balls);
        checkZeroBalls(data.balls);
        if (data.success) {
            cancelRescueGame(false);
            setRescueStatus('救済の玉を受け取りました。');
        } else if (data.balls != null && !/^0+$/.test(String(data.balls).replace(/[^0-9]/g, ''))) {
            cancelRescueGame(false);
            setRescueStatus('玉数を更新しました。ゲームを続けられます。');
        } else {
            cancelRescueGame(false);
            setRescueStatus('救済を受け取れませんでした。メニューからもう一度試してください。');
            var firstButton = rescueMenu && rescueMenu.querySelector('button');
            if (firstButton) firstButton.focus();
        }
    })
    .catch(function(error) {
        console.error('救済処理に失敗しました:', error);
        cancelRescueGame(false);
        setRescueStatus('通信に失敗しました。メニューから再度お試しください。');
        var firstButton = rescueMenu && rescueMenu.querySelector('button');
        if (firstButton) firstButton.focus();
    })
    .finally(function() {
        rescueRequestPending = false;
        if (rescueModal) {
            rescueModal.removeAttribute('aria-busy');
            rescueModal.querySelectorAll('button').forEach(function(button) { button.disabled = false; });
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    rescueModal = document.getElementById('rescue-modal');
    rescueMenu = document.getElementById('rescue-menu');
    rescueGameArea = document.getElementById('rescue-game-area');
    gameTitle = document.getElementById('game-title');
    gameCanvas = document.getElementById('game-canvas');
    gameControls = document.getElementById('game-controls');
    rescueStatus = document.getElementById('rescue-status');
    if (!rescueModal) return;

    rescueMenu.addEventListener('click', function(event) {
        var button = event.target.closest('[data-rescue-type]');
        if (button) showRescueGame(button.getAttribute('data-rescue-type'));
    });
    document.getElementById('rescue-cancel').addEventListener('click', function() {
        cancelRescueGame(true);
        setRescueStatus('');
    });

    document.addEventListener('keydown', function(event) {
        if (!rescueModal.classList.contains('is-open')) return;
        if (event.key === 'Escape') {
            if (!rescueGameArea.classList.contains('is-hidden')) {
                cancelRescueGame(true);
                setRescueStatus('メニューに戻りました。');
            }
            event.preventDefault();
            return;
        }
        if (event.key !== 'Tab') return;
        var focusable = Array.prototype.slice.call(rescueModal.querySelectorAll(
            'button:not(:disabled), [href], input:not(:disabled), [tabindex]:not([tabindex="-1"])'
        )).filter(function(element) {
            return element.getClientRects().length > 0;
        });
        if (!focusable.length) return;
        var first = focusable[0];
        var last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) {
            last.focus();
            event.preventDefault();
        } else if (!event.shiftKey && document.activeElement === last) {
            first.focus();
            event.preventDefault();
        }
    });

    var ballElement = document.getElementById('main-ball-count');
    if (ballElement) {
        var ballObserver = new MutationObserver(function() {
            checkZeroBalls(ballElement.textContent);
        });
        ballObserver.observe(ballElement, { childList: true, characterData: true, subtree: true });
    }
    checkZeroBalls(rescueModal.getAttribute('data-initial-balls'));
});
