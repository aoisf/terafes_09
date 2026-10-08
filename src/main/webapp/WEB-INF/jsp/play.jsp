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
        <p id="msg-display" style="color:red; font-weight:bold; min-height:1.2em; margin:4px 0;"></p>

        <div class="menu-grid">
            <%
                CareItem[] items = (CareItem[]) request.getAttribute("items");
                if (items != null) {
                    for (CareItem item : items) {
            %>
                <form action="${pageContext.request.contextPath}/play" method="post" class="play-card care-form">
                    <input type="hidden" name="itemId" value="<%= item.id() %>">
                    <div class="item-info">
                        <span class="item-name"><%= item.name() %></span>
                        <span class="item-meta">消費: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %></span>
                    </div>
                    <button type="submit" class="cmd-btn play">購入してあそぶ</button>
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
    <script src="${pageContext.request.contextPath}/js/play.js"></script>
</body>
</html>