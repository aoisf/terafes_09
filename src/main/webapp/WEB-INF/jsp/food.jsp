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
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/header.jsp" />
        <div class="subpage-container" style="overflow-y: auto;">
            <h2>ごはんをあげる</h2>
            <p>所持玉数: <strong id="balls-display" style="color:#d9534f;">${pet.balls} 発</strong></p>
            <p id="level-display">LV: ${pet.level} (EXP: ${pet.exp} / ${pet.nextLevelExp})</p>
            <p id="msg-display" style="color:red; font-weight:bold; min-height:1.2em;"></p>

            <div class="menu-grid">
                <%
                    CareItem[] items = (CareItem[]) request.getAttribute("items");
                    if (items != null) {
                        for (CareItem item : items) {
                %>
                    <form action="${pageContext.request.contextPath}/food" method="post" class="food-card care-form">
                        <input type="hidden" name="itemId" value="<%= item.id() %>">
                        <p style="font-weight:bold; margin:2px 0;"><%= item.name() %></p>
                        <p style="font-size:0.75rem; color:#666; margin:2px 0;">
                            消費玉: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %>
                        </p>
                        <button type="submit" class="cmd-btn food" style="width:100%;">購入してたべさせる</button>
                    </form>
                <%
                        }
                    }
                %>
            </div>

            <div style="margin: 15px 0;">
                <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
            </div>
        </div>
    </div>

    <!-- 確実に動くようにここに直接スクリプトを配置 -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var ballsDisplay = document.getElementById('balls-display');
            var levelDisplay = document.getElementById('level-display');
            var msgDisplay = document.getElementById('msg-display');

            var forms = document.querySelectorAll('.care-form');
            forms.forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault(); // 画面遷移・リロードを完全阻止

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