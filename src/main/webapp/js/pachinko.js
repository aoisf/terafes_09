// パチンコ盤面の演出。外部ライブラリや画像を使わず、CSSとJavaScriptで描画する。
var pachinkoSpinTimer = null;
var pachinkoSymbols = ['○', '□', '△', '☆'];

function renderPachinkoBoard(reelsMarkup) {
    return '<div class="chance-lamp chance-lamp-left" aria-hidden="true">'
        + '<span class="chance-lamp-star">★</span><span class="chance-lamp-title">CHANCE</span>'
        + '<span class="chance-lamp-caption">GOGO!</span></div>'
        + '<div class="chance-lamp chance-lamp-right" aria-hidden="true">'
        + '<span class="chance-lamp-star">7</span><span class="chance-lamp-title">BONUS</span>'
        + '<span class="chance-lamp-caption">LUCKY</span></div>'
        + reelsMarkup;
}

function setPachinkoAutoMode(isAuto) {
    var board = document.getElementById('pachinko-board');
    if (!board) return;

    if (isAuto && board.classList.contains('auto-mode')
            && board.classList.contains('is-spinning') && pachinkoSpinTimer) return;

    if (pachinkoSpinTimer) {
        clearInterval(pachinkoSpinTimer);
        pachinkoSpinTimer = null;
    }

    board.classList.remove('is-spinning', 'is-hit', 'is-miss');
    if (isAuto) {
        board.classList.add('auto-mode');
        board.classList.add('is-spinning');
        board.innerHTML = renderPachinkoBoard('<div class="pachinko-reels" aria-label="オート回転中">'
            + '<span class="pachinko-reel">○</span><span class="pachinko-reel">□</span>'
            + '<span class="pachinko-reel">☆</span></div>');
        var autoReels = board.querySelectorAll('.pachinko-reel');
        pachinkoSpinTimer = setInterval(function() {
            autoReels.forEach(function(reel) {
                reel.textContent = pachinkoSymbols[Math.floor(Math.random() * pachinkoSymbols.length)];
            });
        }, 30);
    } else {
        board.classList.remove('auto-mode');
        board.classList.remove('is-spinning');
        board.innerHTML = renderPachinkoBoard('<div class="pachinko-reels" aria-label="スタートするとスロットが回ります">'
            + '<span class="pachinko-reel">○</span><span class="pachinko-reel">□</span>'
            + '<span class="pachinko-reel">△</span></div>');
    }
}

function startPachinkoSpin() {
    var board = document.getElementById('pachinko-board');
    if (!board) return;

    if (pachinkoSpinTimer) clearInterval(pachinkoSpinTimer);
    board.classList.remove('auto-mode', 'is-hit', 'is-miss');
    board.classList.add('is-spinning');
    board.innerHTML = renderPachinkoBoard('<div class="pachinko-reels" aria-label="スロット回転中">'
        + '<span class="pachinko-reel">○</span><span class="pachinko-reel">□</span>'
        + '<span class="pachinko-reel">☆</span></div>');

    var reels = board.querySelectorAll('.pachinko-reel');
    pachinkoSpinTimer = setInterval(function() {
        reels.forEach(function(reel) {
            reel.textContent = pachinkoSymbols[Math.floor(Math.random() * pachinkoSymbols.length)];
        });
    }, 70);
}

function stopPachinkoSpin(result, winningSymbol) {
    var board = document.getElementById('pachinko-board');
    if (!board) return;

    if (pachinkoSpinTimer) {
        clearInterval(pachinkoSpinTimer);
        pachinkoSpinTimer = null;
    }

    board.classList.remove('is-spinning', 'is-hit', 'is-miss');
    var symbols = result === 'hit' ? [winningSymbol, winningSymbol, winningSymbol]
        : result === 'miss' ? ['○', '□', '☆'] : ['－', '－', '－'];
    board.classList.add(result === 'hit' ? 'is-hit' : 'is-miss');
    board.innerHTML = renderPachinkoBoard('<div class="pachinko-reels" aria-label="'
        + (result === 'hit' ? '大当たり' : result === 'miss' ? 'はずれ' : '玉不足') + '">'
        + symbols.map(function(symbol) { return '<span class="pachinko-reel">' + symbol + '</span>'; }).join('')
        + '</div>');
}
