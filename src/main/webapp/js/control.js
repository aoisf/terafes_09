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

    // 既存の姿をそのまま使う、9秒間のお祭り演出。
    var festivalLayer = null;
    var festivalEnd = 0;
    var festivalFrame = null;
    var festivalChain = 0;
    function startFestival(preview) {
        festivalEnd = performance.now() + 9000;
        if (festivalLayer) {
            festivalChain++;
            return;
        }
        festivalChain = 1;
        var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        festivalLayer = document.createElement('div');
        festivalLayer.className = 'festival-layer';
        festivalLayer.setAttribute('aria-hidden', 'true');
        var canopy = document.createElement('div');
        canopy.className = 'festival-canopy';
        for (var i = 0; i < 9; i++) {
            var lantern = document.createElement('span');
            lantern.className = 'festival-lantern';
            lantern.textContent = i % 2 ? '祝' : '祭';
            lantern.style.setProperty('--sway-delay', (-i * .27) + 's');
            canopy.appendChild(lantern);
        }
        var title = document.createElement('div');
        title.className = 'festival-title';
        title.innerHTML = '<span class="festival-eyebrow">今宵、銀玉乱舞。</span><strong>祭<span>フィーバー</span></strong><span class="festival-subtitle">たまごろうと、お祭り騒ぎ！</span>';
        var badge = document.createElement('div');
        badge.className = 'festival-badge';
        var curtain = document.createElement('div');
        curtain.className = 'festival-curtain';
        var canvas = document.createElement('canvas');
        canvas.className = 'festival-fireworks';
        festivalLayer.append(canvas, canopy, title, badge, curtain);
        document.body.appendChild(festivalLayer);
        document.body.classList.add('festival-active');
        var petArea = document.querySelector('.room-section .pet-area');
        var reaction = document.createElement('div');
        reaction.className = 'festival-pet-reaction';
        reaction.setAttribute('aria-hidden', 'true');
        reaction.innerHTML = '<span class="festival-pixel-heart"></span><span class="festival-pixel-shout">!</span><span class="festival-pet-cheer">わっしょい！</span>';
        if (petArea) petArea.appendChild(reaction);
        var notice = document.createElement('div');
        notice.className = 'festival-announcement';
        notice.setAttribute('role', 'status');
        notice.textContent = preview ? 'お祭りフィーバーの演出プレビュー' : 'お祭りフィーバー！';
        document.body.appendChild(notice);
        var context = canvas.getContext('2d');
        var particles = [];
        var width = 0, height = 0, lastBurst = 0, previous = performance.now();
        var colors = ['#ffd861', '#ff657f', '#65eced', '#fff3ce', '#c4a0ff'];
        function resize() {
            width = window.innerWidth; height = window.innerHeight;
            var ratio = Math.min(window.devicePixelRatio || 1, 2);
            canvas.width = width * ratio; canvas.height = height * ratio;
            if (context) context.setTransform(ratio, 0, 0, ratio, 0, 0);
        }
        resize();
        window.addEventListener('resize', resize);
        function burst(now) {
            var x = width * (.12 + Math.random() * .76);
            var y = height * (.12 + Math.random() * .42);
            var color = colors[Math.floor(Math.random() * colors.length)];
            for (var j = 0; j < 72; j++) {
                var angle = j / 72 * Math.PI * 2;
                var speed = (j % 3 === 0 ? 110 : 220) + Math.random() * 35;
                particles.push({x:x, y:y, vx:Math.cos(angle)*speed, vy:Math.sin(angle)*speed, life:1.5, max:1.5, color:color, size:2.5, confetti:false});
            }
            for (var k = 0; k < 14; k++) {
                particles.push({x:Math.random()*width, y:-20, vx:(Math.random()-.5)*60, vy:100+Math.random()*100, life:4.5, max:4.5, color:colors[k%colors.length], size:4+Math.random()*4, confetti:true});
            }
            lastBurst = now;
        }
        var finished = false;
        function finish() {
            if (finished) return;
            finished = true;
            window.removeEventListener('pagehide', finish);
            window.removeEventListener('resize', resize);
            if (festivalFrame != null) cancelAnimationFrame(festivalFrame);
            festivalFrame = null;
            document.body.classList.remove('festival-active');
            reaction.remove(); notice.remove();
            var endingLayer = festivalLayer;
            festivalLayer = null;
            endingLayer.classList.add('is-ending');
            window.setTimeout(function() { endingLayer.remove(); }, 500);
        }
        function draw(now) {
            if (now >= festivalEnd || document.hidden) { finish(); return; }
            badge.textContent = (preview ? '演出プレビュー' : festivalChain > 1 ? '祭り連発 ×' + festivalChain : '祭フィーバー開催中') + ' · ' + Math.ceil((festivalEnd - now)/1000) + '秒';
            var dt = Math.min((now - previous) / 1000, .05); previous = now;
            if (context && !reducedMotion) {
                context.clearRect(0, 0, width, height);
                if (now - lastBurst > 520) burst(now);
                particles = particles.filter(function(p) { return p.life > 0; });
                particles.forEach(function(p) {
                    p.life -= dt; p.x += p.vx*dt; p.y += p.vy*dt;
                    if (!p.confetti) p.vy += 60*dt;
                    context.globalAlpha = Math.max(0, Math.min(1, p.life / p.max * 2));
                    context.fillStyle = p.color;
                    context.save(); context.translate(p.x, p.y);
                    if (p.confetti) context.rotate(now / 550 + p.x);
                    context.fillRect(-p.size/2, -p.size/2, p.size, p.confetti ? p.size*1.7 : p.size);
                    context.restore();
                });
                context.globalAlpha = 1;
            }
            festivalFrame = requestAnimationFrame(draw);
        }
        festivalFrame = requestAnimationFrame(draw);
        window.addEventListener('pagehide', finish, {once:true});
    }
    var festivalPreview = document.querySelector('[data-preview-festival]');
    if (festivalPreview) festivalPreview.addEventListener('click', function() {
        var dialog = festivalPreview.closest('[data-dialog]');
        if (dialog) dialog.querySelector('[data-close-dialog]').click();
        startFestival(true);
    });

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
            signal: AbortSignal.timeout(10000),
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
                if (data.festival) startFestival(false);
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
