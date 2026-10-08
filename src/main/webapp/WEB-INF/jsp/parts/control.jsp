<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 操作パネル -->
<section class="control-section">
    <div class="status-bar">
        <div class="ball-count">玉数 <span id="main-ball-count">${pet.balls}発</span></div>
        <div class="toggles">
            <label style="cursor: pointer; user-select: none;">
                オート <input type="checkbox" id="auto-toggle" checked>
            </label>
        </div>
    </div>
    <!-- formを使わず通常のボタンにすることでリロード暴発を完全防止 -->
    <div class="button-wrapper">
        <button type="button" id="start-button" class="start-button">スタート！</button>
    </div>
</section>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var startBtn = document.getElementById('start-button');
    var autoToggle = document.getElementById('auto-toggle');
    var ballDisplay = document.getElementById('main-ball-count');
    var actionUrl = '${pageContext.request.contextPath}/action';

    var autoTimer = null;
    var isRunning = false;
    var isFetching = false; // 通信の重複防止フラグ

    // トーストポップアップ表示
    function showToast(message, isHit) {
        var existing = document.getElementById('result-toast');
        if (existing) existing.remove();

        var toast = document.createElement('div');
        toast.id = 'result-toast';
        toast.className = 'pachinko-result-toast ' + (isHit ? 'hit' : 'miss');

        if (isHit) {
            var formatted = message.replace(/(\d+発)/, '<span class="rainbow-text">$1</span>');
            toast.innerHTML = '✨ ' + formatted + ' ✨';
        } else {
            toast.textContent = message;
        }

        document.body.appendChild(toast);

        requestAnimationFrame(function() {
            toast.classList.add('show');
        });

        var duration = isHit ? 2800 : 1200;
        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() { toast.remove(); }, 350);
        }, duration);
    }

    // パチンコ実行関数
    function playPachinko() {
        if (isFetching) return;
        isFetching = true;

        fetch(actionUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: 'action=pachinko'
        })
        .then(function(res) {
            return res.json();
        })
        .then(function(data) {
            isFetching = false;
            if (data.canPlay) {
                if (ballDisplay) {
                    ballDisplay.textContent = data.balls + '発';
                }
                // 大当たりのときは必ず表示。オート中のハズレは画面がチラつかないよう大当たりのみ通知
                if (data.hit || !isRunning) {
                    showToast(data.message, data.hit);
                }
            } else {
                showToast('玉が足りません！', false);
                stopAuto();
            }
        })
        .catch(function(err) {
            isFetching = false;
            console.error('通信エラー:', err);
            stopAuto();
        });
    }

    // オート開始
    function startAuto() {
        isRunning = true;
        startBtn.textContent = 'ストップ！';
        startBtn.style.background = 'linear-gradient(to bottom, #777, #333)';
        startBtn.style.boxShadow = '0 4px 0 #111';

        // まず1回目を即時実行
        playPachinko();

        // 0.1秒間隔で連続実行
        autoTimer = setInterval(function() {
            if (!isRunning) {
                stopAuto();
                return;
            }
            playPachinko();
        }, 1);
    }

    // オート停止
    function stopAuto() {
        isRunning = false;
        if (autoTimer) {
            clearInterval(autoTimer);
            autoTimer = null;
        }
        startBtn.textContent = 'スタート！';
        startBtn.style.background = 'linear-gradient(to bottom, #ff6666, #cc0000)';
        startBtn.style.boxShadow = '0 4px 0 #990000';
    }

    // ボタンクリック時の挙動
    startBtn.addEventListener('click', function(e) {
        e.preventDefault();

        if (isRunning) {
            stopAuto();
            return;
        }

        if (autoToggle && autoToggle.checked) {
            startAuto();
        } else {
            playPachinko();
        }
    });

    // オートチェックボックスの変更監視
    if (autoToggle) {
        autoToggle.addEventListener('change', function() {
            if (!autoToggle.checked && isRunning) {
                stopAuto();
            }
        });
    }
});
</script>