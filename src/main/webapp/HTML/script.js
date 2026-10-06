// スタートボタン
function startGame() {
    alert("パチンコスタート！");
}

// ごはんポップアップを開く
function openFoodModal() {
    const modal = document.getElementById('food-modal');
    modal.style.display = 'flex'; // 画面に表示する
}

// ごはんポップアップを閉じる
function closeFoodModal() {
    const modal = document.getElementById('food-modal');
    modal.style.display = 'none'; // 画面から隠す
}

// ごはんを選んだ時の処理
function feedPet(foodName, cost) {
    alert(`${foodName}（${cost}発）をあげたよ！`);
    closeFoodModal(); // 選んだらポップアップを閉じる
}

// 背景の黒い部分をクリックしても閉じられるようにする
document.addEventListener('DOMContentLoaded', () => {
    const modal = document.getElementById('food-modal');
    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                closeFoodModal();
            }
        });
    }
});

// 「あそぶ」「おきがえ」ボタン用
document.querySelectorAll('.cmd-btn:not(.food)').forEach(button => {
    button.addEventListener('click', (e) => {
        const commandName = e.target.textContent;
        alert(`${commandName} を選択したよ！`);
    });
});

// 育成コマンドのボタンにもイベントをつけておくね
document.querySelectorAll('.cmd-btn').forEach(button => {
    button.addEventListener('click', (e) => {
        const commandName = e.target.textContent;
        alert(`${commandName} を選択したよ！`);
    });
});