// ごはん・あそぶ画面で共通する購入操作
document.addEventListener('DOMContentLoaded', function() {
    var page = document.querySelector('.care-page');
    if (!page) return;

    var endpoint = page.getAttribute('data-endpoint');
    var unit = page.getAttribute('data-count-unit');
    var ballsDisplay = document.getElementById('balls-display');
    var levelDisplay = document.getElementById('level-display');
    var cards = Array.from(page.querySelectorAll('.care-card'));
    var currentBalls = BigInt(page.getAttribute('data-balls'));
    var requestPending = false;

    function showEvolution(data) {
        var previousFocus = document.activeElement;
        var dialog = document.createElement('dialog');
        dialog.className = 'evolution-popup';
        var title = document.createElement('h2');
        title.id = 'evolution-title';
        title.textContent = 'たまごろが進化したよ!';
        dialog.setAttribute('aria-labelledby', title.id);
        var stage = document.createElement('div');
        stage.className = 'evolution-stage';
        var before = document.createElement('img');
        before.src = page.getAttribute('data-pet-images') + 'lv' + data.evolutionFrom + '.png';
        before.alt = '進化前のたまごろ';
        before.className = 'evolution-before';
        var after = document.createElement('img');
        after.src = page.getAttribute('data-pet-images') + 'lv' + data.evolutionTo + '.png';
        after.alt = 'レベル' + data.evolutionTo + 'の姿に進化したたまごろ';
        after.className = 'evolution-after';
        stage.append(before, after);
        var message = document.createElement('p');
        message.textContent = (data.evolutionTo >= 90 ? '靄が固まって、ひよこの姿に。小さな足で歩き出した…！' : data.evolutionTo >= 80 ? '口と靄の翼が現れた。ふわりと飛べそう…！' : data.evolutionTo >= 70 ? '全身がふわりと靄に。きらりと光る目だけが見える…！' : data.evolutionTo >= 60 ? '殻の欠片がふわり。靄で浮かせられるようになった…！' : data.evolutionTo >= 50 ? '殻がぱかっと左右に割れて、小さな体と足が現れた…！' : data.evolutionTo >= 40 ? '丸い耳がぴょこん。黒い中身にも顔が現れた…！' : data.evolutionTo >= 30 ? '上の殻がなくなって、黒い中身が姿を現した…！' : data.evolutionTo >= 20 ? '殻が浮いて、黒い靄があふれてきた…！' : '殻の中から黒い靄が…！') + ' おきがえは「ふつう」に戻ったよ。';
        var close = document.createElement('button');
        close.type = 'button';
        close.textContent = 'やったね！';
        close.addEventListener('click', function() { dialog.close(); });
        dialog.addEventListener('close', function() {
            dialog.remove();
            if (previousFocus && previousFocus.isConnected) previousFocus.focus();
        });
        dialog.append(title, stage, message, close);
        document.body.appendChild(dialog);
        dialog.showModal();
        close.focus();
    }

    function renderStatus(level, exp, nextExp) {
        ballsDisplay.textContent = currentBalls.toLocaleString() + ' 発';
        levelDisplay.textContent = 'LV: ' + level + ' (EXP: '
            + BigInt(exp).toLocaleString() + ' / ' + BigInt(nextExp).toLocaleString() + ')';
    }

    function updateAffordableCounts() {
        cards.forEach(function(card) {
            var cost = BigInt(card.getAttribute('data-cost'));
            var countVal = card.querySelector('.count-val');
            var maxAffordable = currentBalls / cost;
            card.setAttribute('data-max', maxAffordable.toString());
            countVal.textContent = maxAffordable.toLocaleString() + unit;

            card.querySelectorAll('.btn-care').forEach(function(button) {
                var target = button.getAttribute('data-count');
                var unavailable = target === 'max'
                    ? maxAffordable === 0n
                    : maxAffordable < BigInt(target);
                button.disabled = unavailable || requestPending;
                button.classList.toggle('disabled', unavailable || requestPending);
            });
        });
    }

    function showBubble(button, message) {
        var parent = button.closest('.action-box');
        var oldBubble = parent.querySelector('.bubble-popup');
        if (oldBubble) oldBubble.remove();

        var bubble = document.createElement('div');
        bubble.className = 'bubble-popup';
        bubble.textContent = message;
        parent.appendChild(bubble);

        setTimeout(function() {
            bubble.classList.add('fade-out');
            setTimeout(function() { bubble.remove(); }, 300);
        }, 1800);
    }

    updateAffordableCounts();

    cards.forEach(function(card) {
        var cost = BigInt(card.getAttribute('data-cost'));
        card.querySelectorAll('.btn-care').forEach(function(button) {
            button.addEventListener('click', function() {
                if (requestPending || button.disabled) return;

                var target = button.getAttribute('data-count');
                var count = target === 'max' ? currentBalls / cost : BigInt(target);
                if (count <= 0n || currentBalls < cost * count) {
                    showBubble(button, '玉が足りないよ！');
                    return;
                }

                var params = new URLSearchParams();
                params.append('itemId', card.getAttribute('data-id'));
                params.append('count', count.toString());
                requestPending = true;
                updateAffordableCounts();

                fetch(endpoint, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString()
                })
                .then(function(response) {
                    if (!response.ok) throw new Error('HTTP ' + response.status);
                    return response.json();
                })
                .then(function(data) {
                    currentBalls = BigInt(data.balls);
                    renderStatus(data.level, data.exp, data.nextExp);
                    if (!data.success) {
                        showBubble(button, data.error === 'invalid_count' ? '個数を確認してね！' : '玉が足りないよ！');
                        return;
                    }
                    if (data.record && typeof window.updateDashboardRecord === 'function') {
                        window.updateDashboardRecord(data.record);
                    }
                    if (data.level >= 100) window.showFinalEvolutionChoice();
                    else if (data.evolved) showEvolution(data);
                })
                .catch(function(error) {
                    console.error('育成操作に失敗しました:', error);
                    showBubble(button, '通信に失敗しました。画面を更新してね！');
                })
                .finally(function() {
                    requestPending = false;
                    updateAffordableCounts();
                });
            });
        });
    });

    renderStatus(page.getAttribute('data-level'), page.getAttribute('data-exp'), page.getAttribute('data-next-exp'));
});
