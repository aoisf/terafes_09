// メイン画面のパチンコ操作
document.addEventListener('DOMContentLoaded', function() {
    var panel = document.querySelector('.control-section');
    var startButton = document.getElementById('start-button');
    var autoToggle = document.getElementById('auto-toggle');
    var ballDisplay = document.getElementById('main-ball-count');
    var actionUrl = panel.getAttribute('data-action-url');
    var autoTimer = null;
    var isRunning = false;
    var isFetching = false;

    function updateBalls(value) {
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
    var serverToast = document.getElementById('result-toast');
    if (serverToast) {
        requestAnimationFrame(function() { serverToast.classList.add('show'); });
        var toastDuration = Number(serverToast.getAttribute('data-duration')) || 2200;
        window.setTimeout(function() {
            serverToast.classList.remove('show');
            window.setTimeout(function() { serverToast.remove(); }, 400);
        }, toastDuration);
    }
    if (typeof setPachinkoAutoMode === 'function') {
        setPachinkoAutoMode(autoToggle.checked);
    }

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
        if (isFetching) return;
        isFetching = true;
        var showReels = !autoToggle.checked;
        var spinStartedAt = Date.now();
        if (showReels && typeof startPachinkoSpin === 'function') startPachinkoSpin();

        function finishRequest(result, callback, winningSymbol) {
            var delay = showReels ? Math.max(0, 600 - (Date.now() - spinStartedAt)) : 0;
            setTimeout(function() {
                if (autoToggle.checked && isRunning && result !== 'empty'
                        && typeof setPachinkoAutoMode === 'function') {
                    setPachinkoAutoMode(true);
                } else if (typeof stopPachinkoSpin === 'function') {
                    stopPachinkoSpin(result, winningSymbol);
                }
                isFetching = false;
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
            if (data.balls != null) updateBalls(data.balls);
            if (!data.canPlay) {
                finishRequest('empty', function() {
                    showToast('玉が足りません！', false);
                    stopAuto();
                });
                return;
            }

            finishRequest(data.hit ? 'hit' : 'miss', function() {
                if (data.hit || !isRunning) showToast(data.message, data.hit);
            }, data.symbol);
        })
        .catch(function(error) {
            finishRequest('empty', function() {
                console.error('通信エラー:', error);
                stopAuto();
                showToast('通信に失敗しました。画面を更新します。', false);
                setTimeout(function() { window.location.reload(); }, 1400);
            });
        });
    }

    function startAuto() {
        isRunning = true;
        if (typeof setPachinkoAutoMode === 'function') setPachinkoAutoMode(true);
        startButton.textContent = 'ストップ！';
        startButton.classList.add('is-auto-running');
        playPachinko();
        autoTimer = setInterval(function() {
            if (!isRunning) return stopAuto();
            playPachinko();
        }, 1000);
    }

    function stopAuto() {
        isRunning = false;
        if (autoTimer) clearInterval(autoTimer);
        autoTimer = null;
        startButton.textContent = 'スタート！';
        startButton.classList.remove('is-auto-running');
    }

    startButton.addEventListener('click', function(event) {
        event.preventDefault();
        if (isRunning) return stopAuto();
        if (autoToggle.checked) startAuto();
        else playPachinko();
    });

    autoToggle.addEventListener('change', function() {
        if (!autoToggle.checked && isRunning) stopAuto();
        if (typeof setPachinkoAutoMode === 'function') {
            setPachinkoAutoMode(autoToggle.checked && isRunning);
        }
    });
});
