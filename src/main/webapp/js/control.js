// メイン画面のパチンコ操作
document.addEventListener('DOMContentLoaded', function() {
    var panel = document.querySelector('.control-section');
    var startButton = document.getElementById('start-button');
    var leverCaption = document.getElementById('lever-caption');
    var autoToggle = document.getElementById('auto-toggle');
    var ballDisplay = document.getElementById('main-ball-count');
    var actionUrl = panel.getAttribute('data-action-url');
    var autoTimer = null;
    var isRunning = false;
    var autoInFlight = 0;
    var maxAutoInFlight = 5;
    var manualInFlight = false;
    var nextRequestSequence = 0;
    var latestBallSequence = 0;

    function updateBalls(value, sequence) {
        if (sequence != null && sequence < latestBallSequence) return;
        if (sequence != null) latestBallSequence = sequence;
        if (ballDisplay) ballDisplay.textContent = BigInt(value).toLocaleString() + '発';
    }

    updateBalls(panel.getAttribute('data-initial-balls'));
    document.querySelectorAll('.pet-exp [data-value]').forEach(function(value) {
        value.textContent = BigInt(value.getAttribute('data-value')).toLocaleString();
    });
    document.querySelectorAll('.exp-fill[data-percent]').forEach(function(fill) {
        var percent = Number(fill.getAttribute('data-percent'));
        fill.style.width = Math.max(0, Math.min(100, percent)) + '%';
    });
    var multiplierDisplay = document.getElementById('current-multiplier');
    if (multiplierDisplay) {
        var level = Number(multiplierDisplay.getAttribute('data-level'));
        var multiplierPower = level <= 1 ? 0 : Math.floor((level - 1) / 2) + 1;
        multiplierDisplay.textContent = (BigInt(3) ** BigInt(multiplierPower)).toLocaleString();
    }
    var serverToast = document.getElementById('result-toast');
    if (serverToast) {
        requestAnimationFrame(function() { serverToast.classList.add('show'); });
        var toastDuration = Number(serverToast.getAttribute('data-duration')) || 2200;
        window.setTimeout(function() {
            serverToast.classList.remove('show');
            window.setTimeout(function() { serverToast.remove(); }, 400);
        }, toastDuration);
    }
    // オート設定は初期選択だけに使い、レバーを操作するまでは回転させない。
    if (typeof setPachinkoAutoMode === 'function') setPachinkoAutoMode(false);

    function showToast(message, isHit) {
        var existing = document.getElementById('result-toast');
        if (existing) existing.remove();

        var toast = document.createElement('div');
        toast.id = 'result-toast';
        toast.className = 'pachinko-result-toast ' + (isHit ? 'hit' : 'miss');
        if (isHit) {
            var formatted = message.replace(/(\d[\d,]*発)/, '<span class="rainbow-text">$1</span>');
            toast.innerHTML = '✨ ' + formatted + ' ✨';
        } else {
            toast.textContent = message;
        }
        document.body.appendChild(toast);
        requestAnimationFrame(function() { toast.classList.add('show'); });

        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() { toast.remove(); }, 350);
        }, isHit ? 2800 : 1200);
    }

    function playPachinko() {
        var autoRequest = isRunning && autoToggle.checked;
        if (autoRequest) {
            if (autoInFlight >= maxAutoInFlight) return;
            autoInFlight++;
        } else {
            if (manualInFlight) return;
            manualInFlight = true;
        }
        var requestSequence = ++nextRequestSequence;
        var showReels = !autoToggle.checked;
        var spinStartedAt = Date.now();
        if (showReels && typeof startPachinkoSpin === 'function') startPachinkoSpin();

        function releaseRequest() {
            if (autoRequest) autoInFlight = Math.max(0, autoInFlight - 1);
            else manualInFlight = false;
        }

        function finishRequest(result, callback, winningSymbol) {
            var delay = showReels ? Math.max(0, 600 - (Date.now() - spinStartedAt)) : 0;
            setTimeout(function() {
                if (autoRequest && isRunning && autoToggle.checked
                        && typeof setPachinkoAutoMode === 'function') {
                    setPachinkoAutoMode(true);
                } else if (!autoRequest && typeof stopPachinkoSpin === 'function') {
                    stopPachinkoSpin(result, winningSymbol);
                }
                releaseRequest();
                callback();
            }, delay);
        }

        fetch(actionUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: 'action=pachinko'
        })
        .then(function(response) {
            if (!response.ok) throw new Error('HTTP ' + response.status);
            return response.json();
        })
        .then(function(data) {
            if (data.balls != null) updateBalls(data.balls, requestSequence);
            if (data.record && typeof window.updateDashboardRecord === 'function') {
                window.updateDashboardRecord(data.record);
            }
            if (!data.canPlay) {
                finishRequest('empty', function() {
                    if (autoRequest) {
                        if (isRunning) {
                            stopAuto();
                            showToast('玉が足りません！オートを停止しました。', false);
                        }
                    } else {
                        showToast('玉が足りません！', false);
                    }
                });
                return;
            }

            finishRequest(data.hit ? 'hit' : 'miss', function() {
                if (!autoRequest) showToast(data.message, data.hit);
            }, data.symbol);
        })
        .catch(function(error) {
            finishRequest('empty', function() {
                console.error('通信エラー:', error);
                if (autoRequest) {
                    if (isRunning) {
                        stopAuto();
                        showToast('オート通信に失敗したため停止しました。', false);
                    }
                } else {
                    showToast('通信に失敗しました。もう一度お試しください。', false);
                }
            });
        });
    }

    function startAuto() {
        isRunning = true;
        if (typeof setPachinkoAutoMode === 'function') setPachinkoAutoMode(true);
        startButton.setAttribute('aria-label', 'オートを停止する');
        if (leverCaption) leverCaption.textContent = 'PULL TO STOP';
        startButton.classList.add('is-auto-running');
        playPachinko();
        autoTimer = setInterval(function() {
            if (!isRunning) return stopAuto();
            playPachinko();
        }, 10);
    }

    function stopAuto() {
        isRunning = false;
        if (autoTimer) clearInterval(autoTimer);
        autoTimer = null;
        startButton.setAttribute('aria-label', 'レバーを引いてスロットを回す');
        if (leverCaption) leverCaption.textContent = 'PULL TO START';
        startButton.classList.remove('is-auto-running');
        startButton.classList.remove('is-pulled');
        if (typeof setPachinkoAutoMode === 'function') setPachinkoAutoMode(false);
    }

    startButton.addEventListener('click', function(event) {
        event.preventDefault();
        if (isRunning) return stopAuto();
        if (autoToggle.checked) startAuto();
        else {
            startButton.classList.add('is-pulled');
            window.setTimeout(function() { startButton.classList.remove('is-pulled'); }, 420);
            playPachinko();
        }
    });

    autoToggle.addEventListener('change', function() {
        if (!autoToggle.checked && isRunning) stopAuto();
        if (typeof setPachinkoAutoMode === 'function') {
            setPachinkoAutoMode(autoToggle.checked && isRunning);
        }
    });
});
