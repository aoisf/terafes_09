<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.PetCareLogic.CareItem" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>あそぶ - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/play.css">
</head>
<body>
    <div class="app-container page-play">
        <h2 class="subpage-title">いっしょにあそぶ</h2>
        <div class="status-summary">
            <p>所持玉数: <strong id="balls-display" style="color:#d9534f; font-size:1.2rem;">${pet.balls} 発</strong></p>
            <p id="level-display">LV: ${pet.level} (EXP: ${pet.exp} / ${pet.nextLevelExp})</p>
        </div>

        <div class="menu-grid">
            <%
                CareItem[] items = (CareItem[]) request.getAttribute("items");
                if (items != null) {
                    for (CareItem item : items) {
            %>
                <div class="play-card" data-cost="<%= item.cost().toString() %>" data-id="<%= item.id() %>">
                    <div class="item-info">
                        <span class="item-name"><%= item.name() %></span>
                        <span class="item-meta">1回消費: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %></span>
                    </div>
                    <div class="action-box">
                        <span class="affordable-count">あそべる数: <strong class="count-val">0</strong></span>
                        <div class="buy-buttons">
                            <button type="button" class="btn-play" data-count="1">1回</button>
                            <button type="button" class="btn-play" data-count="10">10回</button>
                            <button type="button" class="btn-play" data-count="100">100回</button>
                            <button type="button" class="btn-play" data-count="1000">1000回</button>
                        </div>
                    </div>
                </div>
            <%
                    }
                }
            %>
        </div>

        <div class="footer-area">
            <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var ballsDisplay = document.getElementById('balls-display');
            var levelDisplay = document.getElementById('level-display');
            var cards = document.querySelectorAll('.play-card');

            var currentBalls = BigInt("${pet.balls}");

            function updateAffordableCounts() {
                cards.forEach(function(card) {
                    var cost = BigInt(card.getAttribute('data-cost'));
                    var countVal = card.querySelector('.count-val');
                    var buttons = card.querySelectorAll('.btn-play');

                    if (cost === 0n) {
                        countVal.textContent = '∞';
                        buttons.forEach(function(b) { b.classList.remove('disabled'); });
                    } else {
                        var maxAffordable = currentBalls / cost;
                        countVal.textContent = maxAffordable.toLocaleString() + '回';
                        buttons.forEach(function(b) {
                            var needed = BigInt(b.getAttribute('data-count'));
                            if (maxAffordable < needed) {
                                b.classList.add('disabled');
                            } else {
                                b.classList.remove('disabled');
                            }
                        });
                    }
                });
            }

            function showBubble(targetBtn, text) {
                var parent = targetBtn.closest('.action-box');
                var existing = parent.querySelector('.bubble-popup');
                if (existing) existing.remove();

                var bubble = document.createElement('div');
                bubble.className = 'bubble-popup';
                bubble.textContent = text;
                parent.appendChild(bubble);

                setTimeout(function() {
                    bubble.classList.add('fade-out');
                    setTimeout(function() { bubble.remove(); }, 300);
                }, 1800);
            }

            updateAffordableCounts();

            cards.forEach(function(card) {
                var itemId = card.getAttribute('data-id');
                var cost = BigInt(card.getAttribute('data-cost'));

                card.querySelectorAll('.btn-play').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        var count = parseInt(btn.getAttribute('data-count'), 10);
                        var totalCost = cost * BigInt(count);

                        if (cost > 0n && currentBalls < totalCost) {
                            showBubble(btn, '玉が足りないよ！');
                            return;
                        }

                        var params = new URLSearchParams();
                        params.append('itemId', itemId);
                        params.append('count', count);

                        fetch('${pageContext.request.contextPath}/play', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params.toString()
                        })
                        .then(function(res) { return res.json(); })
                        .then(function(data) {
                            if (data.success) {
                                currentBalls = BigInt(data.balls);
                                if (ballsDisplay) ballsDisplay.textContent = data.balls + ' 発';
                                if (levelDisplay) levelDisplay.textContent = 'LV: ' + data.level + ' (EXP: ' + data.exp + ' / ' + data.nextExp + ')';
                                updateAffordableCounts();
                            } else {
                                showBubble(btn, '玉が足りないよ！');
                            }
                        })
                        .catch(function(err) {
                            console.error(err);
                        });
                    });
                });
            });
        });
    </script>
</body>
</html>