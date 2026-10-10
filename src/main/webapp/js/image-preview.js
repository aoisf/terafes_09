(function() {
    var dialog = document.createElement('dialog');
    dialog.className = 'image-preview-dialog';
    dialog.hidden = true;
    dialog.setAttribute('role', 'dialog');
    dialog.setAttribute('aria-modal', 'true');
    dialog.setAttribute('aria-label', '画像プレビュー');

    var previewImage = document.createElement('img');
    previewImage.className = 'image-preview-image';
    previewImage.alt = '';
    previewImage.draggable = false;

    var closeButton = document.createElement('button');
    closeButton.className = 'image-preview-close';
    closeButton.type = 'button';
    closeButton.setAttribute('aria-label', '画像を閉じる');
    closeButton.textContent = '×';

    dialog.appendChild(previewImage);
    dialog.appendChild(closeButton);
    document.body.appendChild(dialog);

    var lastFocusedElement = null;
    var closeTimer = null;

    function getImageLabel(image) {
        var card = image.closest('.care-card');
        var name = card && card.querySelector('.item-name');
        if (name) return name.textContent.trim();

        var option = image.closest('.background-option');
        var optionLabel = option && option.querySelector('span');
        if (optionLabel) return optionLabel.textContent.trim();

        var command = image.closest('.cmd-btn');
        var commandLabel = command && command.querySelector('.cmd-label');
        if (commandLabel) return commandLabel.textContent.trim();

        return image.alt || image.getAttribute('title') || '画像プレビュー';
    }

    function prepareImage(image) {
        image.classList.add('image-preview-trigger');
        if (!image.hasAttribute('tabindex')) image.setAttribute('tabindex', '0');
        if (!image.hasAttribute('role')) image.setAttribute('role', 'button');
        if (!image.hasAttribute('aria-label')) image.setAttribute('aria-label', getImageLabel(image) + 'を拡大表示');
        image.setAttribute('aria-haspopup', 'dialog');
    }

    function openPreview(src, label, pixelArt, trigger) {
        if (!src) return;
        if (closeTimer) window.clearTimeout(closeTimer);
        lastFocusedElement = trigger || document.activeElement;
        previewImage.src = src;
        previewImage.alt = label || '画像プレビュー';
        previewImage.classList.toggle('is-pixel-art', Boolean(pixelArt));
        dialog.hidden = false;
        if (!dialog.open) dialog.showModal();
        dialog.setAttribute('aria-label', (label || '画像') + 'の拡大表示');
        document.body.classList.add('image-preview-open');
        dialog.classList.add('is-open');
        closeButton.focus();
    }

    function closePreview() {
        if (dialog.hidden) return;
        dialog.classList.remove('is-open');
        document.body.classList.remove('image-preview-open');
        closeTimer = window.setTimeout(function() {
            dialog.close();
            dialog.hidden = true;
            previewImage.removeAttribute('src');
            if (lastFocusedElement && document.contains(lastFocusedElement)) {
                lastFocusedElement.focus({ preventScroll: true });
            }
        }, 180);
    }

    closeButton.addEventListener('click', closePreview);
    dialog.addEventListener('cancel', function(event) {
        event.preventDefault();
        closePreview();
    });
    dialog.addEventListener('click', function(event) {
        if (event.target === dialog) closePreview();
    });

    document.addEventListener('click', function(event) {
        if (event.target.closest && event.target.closest('.attract-screen')) return;
        if (event.target.closest && event.target.closest('.background-option')) return;

        var image = event.target.closest && event.target.closest('img:not(.image-preview-image)');
        if (image) {
            event.preventDefault();
            event.stopPropagation();
            prepareImage(image);
            openPreview(image.currentSrc || image.src, getImageLabel(image),
                image.classList.contains('pet-image') || image.classList.contains('care-item-icon') || image.classList.contains('encyclopedia-entry-image'), image);
            return;
        }

    }, true);

    document.addEventListener('keydown', function(event) {
        if (!dialog.open) {
            var targetImage = event.target.closest && event.target.closest('img.image-preview-trigger');
            if (targetImage && (event.key === 'Enter' || event.key === ' ')) {
                event.preventDefault();
                event.stopPropagation();
                openPreview(targetImage.currentSrc || targetImage.src, getImageLabel(targetImage),
                    targetImage.classList.contains('pet-image') || targetImage.classList.contains('care-item-icon') || targetImage.classList.contains('encyclopedia-entry-image'), targetImage);
            }
            return;
        }
        if (event.key === 'Escape') {
            event.preventDefault();
            event.stopImmediatePropagation();
            closePreview();
        } else if (event.key === 'Tab') {
            event.preventDefault();
            closeButton.focus();
        }
    }, true);

    document.querySelectorAll('img:not(.image-preview-image)').forEach(function(image) {
        if (!image.closest('.background-option')) prepareImage(image);
    });
})();

// 展示の無操作監視は育成画面でも継続する。
(function() {
    var script = document.querySelector('script[src*="/js/image-preview.js"]');
    var base = new URL('../', script.src);
    var mainUrl = new URL('main', base);
    var key = 'pachipet-last-interaction';
    var lastInteraction = Date.now();
    try { lastInteraction = Number(sessionStorage.getItem(key)) || lastInteraction; } catch (e) {}
    var idleLimit = 5 * 60 * 1000;
    var entering = false;
    var screen = null;
    var frame = null;
    function remember() {
        lastInteraction = Date.now();
        try { sessionStorage.setItem(key, String(lastInteraction)); } catch (e) {}
    }
    try { sessionStorage.setItem(key, String(lastInteraction)); } catch (e) {}
    function enterIdle() {
        if (entering || screen) return;
        entering = true;
        window.dispatchEvent(new Event('pachipet-idle'));
        var target = new URL(mainUrl);
        target.search = 'reset=true&attract=true';
        window.location.replace(target.href);
    }
    function checkIdle() {
        if (!screen && Date.now() - lastInteraction >= idleLimit) enterIdle();
    }
    function interaction(event) {
        if (!event.isTrusted || entering || screen) return;
        // タイマーが背景タブで遅れても、期限切れのゲームは再開しない。
        if (Date.now() - lastInteraction >= idleLimit) { enterIdle(); return; }
        remember();
    }
    ['pointerdown', 'keydown', 'wheel'].forEach(function(type) {
        document.addEventListener(type, interaction, {capture:true, passive:true});
    });
    document.addEventListener('visibilitychange', checkIdle);
    var idleTimer = window.setInterval(checkIdle, 1000);
    window.addEventListener('pagehide', function() { clearInterval(idleTimer); if (frame) cancelAnimationFrame(frame); });

    function showAttract(preview) {
        if (screen) return;
        document.querySelectorAll('dialog[open]').forEach(function(dialog) {
            var closeButton = dialog.querySelector('[data-close-dialog]');
            if (closeButton) closeButton.click();
            else dialog.close();
        });
        document.body.classList.remove('dashboard-dialog-open', 'image-preview-open');
        window.dispatchEvent(new Event('pachipet-idle'));
        screen = document.createElement('dialog');
        screen.className = 'attract-screen';
        screen.setAttribute('aria-label', 'パチペット生活・呼び込み画面');
        screen.innerHTML = '<canvas class="attract-sparks" aria-hidden="true"></canvas>' +
            '<div class="attract-lanterns" aria-hidden="true">' + Array.from({length:9}, function(_, i) { return '<span style="--i:'+i+'">'+(i%2?'祭':'玉')+'</span>'; }).join('') + '</div>' +
            '<div class="attract-content"><p class="attract-kicker">ようこそ、たまごろうの夜祭りへ</p>' +
            '<h1><small>玉の数だけ愛される？</small>パチペット<span>生活</span></h1>' +
            '<div class="attract-stage" aria-hidden="true"><div class="attract-halo"></div><span class="attract-cheer">いっしょに遊ぼ！</span><span class="attract-heart">♥</span><span class="attract-star">✦</span><div class="attract-mascot"><img src="'+new URL('images/pets/tamagoro/lv1.png',base).href+'" alt=""></div><div class="attract-podium"></div></div>' +
            '<p class="attract-message">回して、育てて、どんな姿に進化する？</p>' +
            '<div class="attract-steps"><span><b>01</b>レバーで回す</span><i>›</i><span><b>02</b>玉を集める</span><i>›</i><span><b>03</b>たまごろうを育てる</span></div>' +
            '<button type="button" class="attract-start">'+(preview?'プレビューを閉じる':'タッチして はじめる')+'<span>LET’S PLAY!</span></button>' +
            '<p class="attract-footnote">'+(preview?'演出プレビュー · ゲームのデータはリセットされません':'1人でも、みんなでも。気軽に遊んでね！')+'</p></div><div class="attract-curtain" aria-hidden="true"></div>';
        document.body.appendChild(screen);
        document.body.classList.add('attract-open');
        screen.showModal();
        screen.querySelector('button').focus();
        function close() {
            if (frame) cancelAnimationFrame(frame);
            window.removeEventListener('resize', resize);
            screen.close(); screen.remove(); screen = null;
            document.body.classList.remove('attract-open');
            remember();
            if (!preview) history.replaceState(null, '', mainUrl.href);
        }
        screen.querySelector('button').addEventListener('click', close);
        screen.addEventListener('cancel', function(event) { event.preventDefault(); close(); });
        var canvas = screen.querySelector('canvas');
        var ctx = canvas.getContext('2d');
        var width, height, particles = [], lastBurst = 0, previous = performance.now();
        var reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
        function resize() {
            width = innerWidth; height = innerHeight;
            var ratio = Math.min(devicePixelRatio || 1, 2);
            canvas.width = width * ratio; canvas.height = height * ratio;
            if (ctx) ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
        }
        resize(); window.addEventListener('resize', resize);
        function draw(now) {
            var dt = Math.min((now-previous)/1000, .05); previous = now;
            if (ctx && !reduced && !document.hidden) {
                ctx.clearRect(0,0,width,height);
                if (now-lastBurst > 1700) {
                    lastBurst = now;
                    var x = width*(Math.random()<.5 ? .08+Math.random()*.2 : .72+Math.random()*.2);
                    var y = height*(.15+Math.random()*.4);
                    var color = ['#ffd66c','#ff719b','#8af1e3'][Math.floor(Math.random()*3)];
                    for(var i=0;i<48;i++) { var a=i/48*Math.PI*2; var v=60+Math.random()*75; particles.push({x:x,y:y,vx:Math.cos(a)*v,vy:Math.sin(a)*v,life:2,color:color}); }
                }
                particles = particles.filter(function(p){return p.life>0;});
                particles.forEach(function(p){p.life-=dt;p.x+=p.vx*dt;p.y+=p.vy*dt;p.vy+=18*dt;ctx.globalAlpha=Math.max(0,p.life/2);ctx.fillStyle=p.color;ctx.fillRect(p.x,p.y,3,3);});
                ctx.globalAlpha=1;
            }
            frame = requestAnimationFrame(draw);
        }
        frame = requestAnimationFrame(draw);
    }
    var previewButton = document.querySelector('[data-preview-attract]');
    if (previewButton) previewButton.addEventListener('click', function(){ showAttract(true); });
    if (new URL(location.href).searchParams.get('attract') === 'true') showAttract(false);
    else checkIdle();
})();
