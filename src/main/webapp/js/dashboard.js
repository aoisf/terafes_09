// メイン画面の図鑑・設定・記録・実績
(function() {
    var dashboard = document.getElementById('dashboard-ui');
    if (!dashboard) return;

    var autoToggle = document.getElementById('auto-toggle');
    var defaultAuto = document.getElementById('default-auto-setting');
    var encyclopedia = dashboard.querySelector('[data-dialog="encyclopedia"]');
    var encyclopediaList = encyclopedia && encyclopedia.querySelector('[data-encyclopedia-list]');
    var lastEncyclopediaTrigger = null;
    var storageKey = 'pachipet.autoDefault';
    var lastTrigger = null;
    var backgroundMilestones = [
        { id: 'forest', name: '森', threshold: 100 },
        { id: 'pool', name: 'プール', threshold: 500 },
        { id: 'pacific', name: '太平洋', threshold: 2500 },
        { id: 'space', name: '宇宙', threshold: 12500 }
    ];

    function showEncyclopediaList() {
        if (!encyclopediaList) return;
        encyclopediaList.hidden = false;
        encyclopedia.querySelectorAll('[data-encyclopedia-detail]').forEach(function(detail) { detail.hidden = true; });
    }

    if (encyclopediaList) {
        encyclopediaList.querySelectorAll('[data-encyclopedia-entry]').forEach(function(button) {
            button.addEventListener('click', function() {
                var entry = button.getAttribute('data-encyclopedia-entry');
                var detail = encyclopedia.querySelector('[data-encyclopedia-detail="' + entry + '"]');
                if (!detail) return;
                lastEncyclopediaTrigger = button;
                encyclopediaList.hidden = true;
                detail.hidden = false;
                var back = detail.querySelector('[data-encyclopedia-back]');
                if (back) back.focus();
            });
        });
        encyclopedia.querySelectorAll('[data-encyclopedia-back]').forEach(function(button) {
            button.addEventListener('click', function() {
                showEncyclopediaList();
                if (lastEncyclopediaTrigger) lastEncyclopediaTrigger.focus();
            });
        });
    }

    function saveAutoDefault(enabled) {
        if (defaultAuto) defaultAuto.checked = enabled;
        try { window.localStorage.setItem(storageKey, enabled ? 'true' : 'false'); }
        catch (error) { /* ブラウザーの保存が使えない場合も画面上の設定は反映する */ }
    }

    var autoDefaultValue = false;
    try { autoDefaultValue = window.localStorage.getItem(storageKey) === 'true'; }
    catch (error) { /* 保存が使えない場合はオートOFFを初期値にする */ }
    if (autoToggle) autoToggle.checked = autoDefaultValue;
    if (defaultAuto) defaultAuto.checked = autoDefaultValue;

    if (defaultAuto) {
        defaultAuto.addEventListener('change', function() {
            saveAutoDefault(defaultAuto.checked);
        });
    }
    if (autoToggle) {
        autoToggle.addEventListener('change', function() {
            saveAutoDefault(autoToggle.checked);
        });
    }

    window.updateDashboardRecord = function(record) {
        function monotonicValue(key) {
            var current = dashboard.querySelector('[data-record-value="' + key + '"]');
            var currentValue = current ? Number(current.textContent.replace(/,/g, '')) || 0 : 0;
            return Math.max(currentValue, Number(record[key]) || 0);
        }
        var totalActions = monotonicValue('totalActions');
        var spins = monotonicValue('pachinkoSpins');
        var jackpots = monotonicValue('jackpots');
        var foodActions = monotonicValue('foodActions');
        var playActions = monotonicValue('playActions');
        var values = {
            totalActions: totalActions,
            pachinkoSpins: spins,
            jackpots: jackpots,
            foodActions: foodActions,
            playActions: playActions
        };

        Object.keys(values).forEach(function(key) {
            var value = dashboard.querySelector('[data-record-value="' + key + '"]');
            if (value) value.textContent = values[key].toLocaleString();
        });

        backgroundMilestones.forEach(function(milestone) {
            var unlocked = totalActions >= milestone.threshold;
            var card = dashboard.querySelector('[data-background-achievement="' + milestone.id + '"]');
            if (card) {
                card.classList.toggle('is-achieved', unlocked);
                var state = card.querySelector('[data-background-achievement-state]');
                if (state) state.textContent = unlocked ? '獲得済み' : '未獲得';
                var progress = card.querySelector('[data-background-progress="' + milestone.id + '"]');
                if (progress) progress.textContent = Math.min(totalActions, milestone.threshold).toLocaleString() + '/' + milestone.threshold.toLocaleString() + '回';
            }
        });

        var forestUnlocked = totalActions >= backgroundMilestones[0].threshold;
        var background = dashboard.querySelector('.background-unlock');
        var backgroundCopy = dashboard.querySelector('[data-background-copy]');
        if (background) background.classList.toggle('is-unlocked', forestUnlocked);
        dashboard.querySelectorAll('[data-background-choice]').forEach(function(button) {
            var threshold = Number(button.getAttribute('data-background-threshold')) || 0;
            button.disabled = threshold > 0 && totalActions < threshold;
        });
        var nextMilestone = backgroundMilestones.find(function(milestone) { return totalActions < milestone.threshold; });
        if (backgroundCopy) {
            backgroundCopy.textContent = nextMilestone
                ? '次は「' + nextMilestone.name + '」を獲得できます。あと ' + (nextMilestone.threshold - totalActions).toLocaleString() + ' 回です。'
                : 'すべての背景を獲得済みです。';
        }
    };

    function closeDialog(dialog) {
        if (!dialog) return;
        if (dialog === encyclopedia) showEncyclopediaList();
        dialog.hidden = true;
        document.body.classList.remove('dashboard-dialog-open');
        if (lastTrigger) lastTrigger.focus();
    }

    dashboard.querySelectorAll('[data-open-dialog]').forEach(function(button) {
        button.addEventListener('click', function() {
            var dialog = dashboard.querySelector('[data-dialog="' + button.getAttribute('data-open-dialog') + '"]');
            if (!dialog) return;
            dashboard.querySelectorAll('[data-dialog]').forEach(function(openDialog) {
                openDialog.hidden = true;
            });
            lastTrigger = button;
            dialog.hidden = false;
            document.body.classList.add('dashboard-dialog-open');
            var closeButton = dialog.querySelector('[data-close-dialog]');
            if (closeButton) closeButton.focus();
        });
    });

    dashboard.querySelectorAll('[data-background-choice]').forEach(function(button) {
        button.addEventListener('click', function() {
            if (button.disabled) return;
            var body = new URLSearchParams();
            body.set('background', button.getAttribute('data-background-choice'));
            fetch(dashboard.getAttribute('data-background-url'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: body.toString()
            }).then(function(response) {
                if (!response.ok) throw new Error('背景を変更できませんでした');
                return response.json();
            }).then(function(data) {
                if (!data.success) throw new Error('背景を変更できませんでした');
                var room = document.querySelector('.room-section');
                if (room) room.style.setProperty('--room-background-image', 'url("' + button.getAttribute('data-background-image') + '")');
                dashboard.querySelectorAll('[data-background-choice]').forEach(function(option) {
                    var selected = option === button;
                    option.classList.toggle('is-selected', selected);
                    option.setAttribute('aria-pressed', selected ? 'true' : 'false');
                });
            }).catch(function(error) {
                window.alert(error.message);
            });
        });
    });

    dashboard.querySelectorAll('[data-close-dialog]').forEach(function(button) {
        button.addEventListener('click', function() { closeDialog(button.closest('[data-dialog]')); });
    });
    dashboard.querySelectorAll('[data-dialog]').forEach(function(dialog) {
        dialog.addEventListener('click', function(event) {
            if (event.target === dialog) closeDialog(dialog);
        });
    });
    document.addEventListener('keydown', function(event) {
        if (event.key !== 'Escape') return;
        var openedDialog = dashboard.querySelector('[data-dialog]:not([hidden])');
        if (openedDialog === encyclopedia && encyclopediaList && encyclopediaList.hidden) {
            showEncyclopediaList();
            if (lastEncyclopediaTrigger) lastEncyclopediaTrigger.focus();
            event.preventDefault();
            event.stopPropagation();
        } else if (openedDialog) {
            closeDialog(openedDialog);
        }
    });

    var resetButton = dashboard.querySelector('[data-reset-game]');
    if (resetButton) {
        resetButton.addEventListener('click', function() {
            window.location.assign(dashboard.getAttribute('data-reset-url'));
        });
    }
})();
