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
        <p id="msg-display" style="color:red; font-weight:bold; min-height:1.2em; margin:4px 0;"></p>

        <div class="menu-grid">
            <%
                CareItem[] items = (CareItem[]) request.getAttribute("items");
                if (items != null) {
                    for (CareItem item : items) {
            %>
                <form action="${pageContext.request.contextPath}/food" method="post" class="food-card care-form">
                    <input type="hidden" name="itemId" value="<%= item.id() %>">
                    <div class="item-info">
                        <span class="item-name"><%= item.name() %></span>
                        <span class="item-meta">消費: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %></span>
                    </div>
                    <button type="submit" class="cmd-btn food">購入してたべさせる</button>
                </form>
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
            var msgDisplay = document.getElementById('msg-display');

            var forms = document.querySelectorAll('.care-form');
            forms.forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();

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
    </script>
</body>
</html>