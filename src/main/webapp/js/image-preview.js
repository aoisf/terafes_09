(function() {
    var dialog = document.createElement('div');
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
        dialog.setAttribute('aria-label', (label || '画像') + 'の拡大表示');
        document.body.classList.add('image-preview-open');
        window.requestAnimationFrame(function() { dialog.classList.add('is-open'); });
        closeButton.focus();
    }

    function closePreview() {
        if (dialog.hidden) return;
        dialog.classList.remove('is-open');
        document.body.classList.remove('image-preview-open');
        closeTimer = window.setTimeout(function() {
            dialog.hidden = true;
            previewImage.removeAttribute('src');
            if (lastFocusedElement && document.contains(lastFocusedElement)) {
                lastFocusedElement.focus({ preventScroll: true });
            }
        }, 180);
    }

    closeButton.addEventListener('click', closePreview);
    dialog.addEventListener('click', function(event) {
        if (event.target === dialog) closePreview();
    });

    document.addEventListener('click', function(event) {
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
        if (!dialog.classList.contains('is-open')) {
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
