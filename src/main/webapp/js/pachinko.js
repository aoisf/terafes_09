// パチンコ盤面の演出。外部ライブラリや画像を使わず、CSSとJavaScriptで描画する。
var pachinkoSpinTimer = null;
var pachinkoSymbols = ['○', '□', '△', '☆'];

function setPachinkoAutoMode(isAuto) {
    var board = document.getElementById('pachinko-board');
    if (!board) return;

    if (pachinkoSpinTimer) {
        clearInterval(pachinkoSpinTimer);
        pachinkoSpinTimer = null;
    }

    board.classList.remove('is-spinning', 'is-hit', 'is-miss');
    if (isAuto) {
        board.classList.add('auto-mode');
        board.innerHTML = '<span class="pachinko-board-message">オート中は演出が出ないよ！</span>';
    } else {
        board.classList.remove('auto-mode');
        board.innerHTML = '<div class="pachinko-reels" aria-label="スタートするとスロットが回ります">'
            + '<span class="pachinko-reel">○</span><span class="pachinko-reel">□</span>'
            + '<span class="pachinko-reel">△</span></div>';
    }
}

function startPachinkoSpin() {
    var board = document.getElementById('pachinko-board');
    if (!board) return;

    if (pachinkoSpinTimer) clearInterval(pachinkoSpinTimer);
    board.classList.remove('auto-mode', 'is-hit', 'is-miss');
    board.classList.add('is-spinning');
    board.innerHTML = '<div class="pachinko-reels" aria-label="スロット回転中">'
        + '<span class="pachinko-reel">○</span><span class="pachinko-reel">□</span>'
        + '<span class="pachinko-reel">☆</span></div>';

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
    board.innerHTML = '<div class="pachinko-reels" aria-label="'
        + (result === 'hit' ? '大当たり' : result === 'miss' ? 'はずれ' : '玉不足') + '">'
        + symbols.map(function(symbol) { return '<span class="pachinko-reel">' + symbol + '</span>'; }).join('')
        + '</div>';
}
