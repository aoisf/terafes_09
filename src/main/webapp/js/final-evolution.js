document.addEventListener('DOMContentLoaded', function () {
    var script = document.querySelector('script[src*="final-evolution.js"]');
    var context = script.getAttribute('data-context');
    var endpoint = context + '/final-evolution';
    var active = false;
    window.showFinalEvolutionChoice = function () {
        if (active) return;
        active = true;
        fetch(endpoint, { signal: AbortSignal.timeout(10000) }).then(function (response) {
            if (!response.ok) throw new Error('status');
            return response.json();
        }).then(function (data) {
            if (!data.pending) { active = false; return; }
            var dialog = document.createElement('dialog');
            dialog.setAttribute('aria-label', 'きみにとってたまごろうは何?');
            dialog.style.cssText = 'border:2px solid #d5ae42;border-radius:20px;padding:24px;max-width:560px;width:calc(100% - 64px);text-align:center;background:#fffdf4;color:#25364b;box-shadow:0 12px 40px #0005';
            var title = document.createElement('h2');
            title.textContent = 'きみにとってたまごろうは何?';
            var note = document.createElement('p');
            note.textContent = 'LV100！最後の姿を選んでね。';
            var choices = document.createElement('div');
            choices.style.cssText = 'display:flex;gap:16px;justify-content:center';
            var buttons = [];
            var error = document.createElement('p');
            error.setAttribute('role', 'status');
            ['bird', 'spirit'].forEach(function (form) {
                var button = document.createElement('button');
                button.type = 'button';
                button.style.cssText = 'flex:1;border:2px solid #d5ae42;border-radius:14px;padding:12px;background:#fff7d7;color:#25364b;font-size:20px;font-weight:bold;cursor:pointer';
                var img = document.createElement('img');
                img.src = context + '/images/pets/tamagoro/lv100-' + form + '.png';
                img.alt = '';
                img.className = 'image-preview-image';
                img.style.cssText = 'display:block;width:120px;max-width:100%;height:120px;object-fit:contain;image-rendering:pixelated;margin:auto';
                button.append(img, document.createTextNode(form === 'bird' ? '鳥' : '精霊'));
                buttons.push(button);
                button.addEventListener('click', function () {
                    buttons.forEach(function (b) { b.disabled = true; });
                    error.textContent = '';
                    fetch(endpoint, {signal:AbortSignal.timeout(10000), method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body:'form=' + form})
                    .then(function (response) {
                        if (!response.ok) throw new Error('choice');
                        return response.json();
                    }).then(function (result) {
                        choices.remove();
                        title.textContent = 'たまごろが進化したよ!';
                        note.textContent = (form === 'bird' ? '立派な黒い鶏になったよ！' : '何かあったたまごろうは、精霊になったよ！') + ' おきがえは「ふつう」に戻ったよ。';
                        var image = document.createElement('img');
                        image.src = context + '/images/pets/tamagoro/' + result.image;
                        image.alt = '進化したたまごろう';
                        image.className = 'image-preview-image';
                        image.style.cssText = 'width:180px;height:180px;object-fit:contain;image-rendering:pixelated';
                        var close = document.createElement('button');
                        close.textContent = 'やったね！';
                        close.addEventListener('click', function () { location.reload(); });
                        dialog.append(image, document.createElement('br'), close);
                        close.focus();
                    }).catch(function () {
                        error.textContent = '選択を保存できませんでした。もう一度選んでね。';
                        buttons.forEach(function (b) { b.disabled = false; });
                    });
                });
                choices.append(button);
            });
            dialog.addEventListener('cancel', function (event) { event.preventDefault(); });
            dialog.append(title, note, choices, error);
            document.body.append(dialog);
            dialog.showModal();
        }).catch(function () { active = false; });
    };
    window.showFinalEvolutionChoice();
});
