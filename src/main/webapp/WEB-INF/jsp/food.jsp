<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.PetCareLogic.CareItem" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ごはん - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/food.css">
</head>
<body>
    <div class="app-container page-food">
        <h2 class="subpage-title">ごはんをあげる</h2>
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
                <div class="food-card" data-cost="<%= item.cost().toString() %>" data-id="<%= item.id() %>">
                    <div class="item-info">
                        <span class="item-name"><%= item.name() %></span>
                        <span class="item-meta">1個消費: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %></span>
                    </div>
                    <div class="action-box">
                        <span class="affordable-count">買える数: <strong class="count-val">0</strong></span>
                        <div class="buy-buttons">
                            <button type="button" class="btn-buy" data-count="1">1個</button>
                            <button type="button" class="btn-buy" data-count="10">10個</button>
                            <button type="button" class="btn-buy" data-count="100">100個</button>
                            <button type="button" class="btn-buy" data-count="1000">1000個</button>
                            <button type="button" class="btn-buy btn-max" data-count="max">MAX</button>
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
            var cards = document.querySelectorAll('.food-card');

            var currentBalls = BigInt("${pet.balls}");

            function updateAffordableCounts() {
                cards.forEach(function(card) {
                    var cost = BigInt(card.getAttribute('data-cost'));
                    var countVal = card.querySelector('.count-val');
                    var buttons = card.querySelectorAll('.btn-buy');

                    var maxAffordable = currentBalls / cost;
                    card.setAttribute('data-max', maxAffordable.toString());
                    countVal.textContent = maxAffordable.toLocaleString() + '個';

                    buttons.forEach(function(b) {
                        var target = b.getAttribute('data-count');
                        if (target === 'max') {
                            if (maxAffordable <= 0n) {
                                b.classList.add('disabled');
                            } else {
                                b.classList.remove('disabled');
                            }
                        } else {
                            var needed = BigInt(target);
                            if (maxAffordable < needed) {
                                b.classList.add('disabled');
                            } else {
                                b.classList.remove('disabled');
                            }
                        }
                    });
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

                card.querySelectorAll('.btn-buy').forEach(function(btn) {
                    btn.addEventListener('click', function() {
                        var targetCount = btn.getAttribute('data-count');
                        var count = 0n;

                        if (targetCount === 'max') {
                            count = currentBalls / cost;
                        } else {
                            count = BigInt(targetCount);
                        }

                        if (count <= 0n || currentBalls < (cost * count)) {
                            showBubble(btn, '玉が足りないよ！');
                            return;
                        }

                        var params = new URLSearchParams();
                        params.append('itemId', itemId);
                        params.append('count', count.toString());

                        fetch('${pageContext.request.contextPath}/food', {
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