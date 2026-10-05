// スタートボタンを押したときの仮の動き
function startGame() {
    alert("パチンコスタート！");
    // ここにJava（バックエンド）と通信して玉を減らしたり、
    // 当たりの抽選結果を受け取る処理を後で書いていくんだね。
}

// 育成コマンドのボタンにもイベントをつけておくね
document.querySelectorAll('.cmd-btn').forEach(button => {
    button.addEventListener('click', (e) => {
        const commandName = e.target.textContent;
        alert(`${commandName} を選択したよ！`);
    });
});