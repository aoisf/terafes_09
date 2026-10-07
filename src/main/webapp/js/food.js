document.addEventListener('DOMContentLoaded', function() {
    var ballsDisplay = document.getElementById('balls-display');
    var levelDisplay = document.getElementById('level-display');
    var msgDisplay = document.getElementById('msg-display');

    var forms = document.querySelectorAll('.care-form');
    forms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault(); // 画面遷移・JSON画面表示を絶対に防ぐ

            var formData = new FormData(form);
            var params = new URLSearchParams(formData);

            fetch(form.action, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
            .then(function(res) {
                return res.json();
            })
            .then(function(data) {
                if (data.success) {
                    if (ballsDisplay) ballsDisplay.textContent = data.balls + ' 発';
                    if (levelDisplay) levelDisplay.textContent = 'LV: ' + data.level + ' (EXP: ' + data.exp + ' / ' + data.nextExp + ')';
                    if (msgDisplay) msgDisplay.textContent = '';
                } else {
                    if (msgDisplay) msgDisplay.textContent = '玉が足りなくて買えないよ…！';
                }
            })
            .catch(function(err) {
                console.error(err);
            });
        });
    });
});