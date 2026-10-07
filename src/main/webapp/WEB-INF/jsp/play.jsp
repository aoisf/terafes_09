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
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/header.jsp" />
        <div class="subpage-container" style="overflow-y: auto;">
            <h2>いっしょにあそぶ</h2>
            <p>所持玉数: <strong id="balls-display" style="color:#d9534f;">${pet.balls} 発</strong></p>
            <p id="level-display">LV: ${pet.level} (EXP: ${pet.exp} / ${pet.nextLevelExp})</p>
            <p id="msg-display" style="color:red; font-weight:bold; min-height:1.2em;"></p>

            <div class="menu-grid">
                <%
                    CareItem[] items = (CareItem[]) request.getAttribute("items");
                    if (items != null) {
                        for (CareItem item : items) {
                %>
                    <form action="${pageContext.request.contextPath}/play" method="post" class="food-card care-form" style="margin:5px 0; padding:10px;">
                        <input type="hidden" name="itemId" value="<%= item.id() %>">
                        <p style="font-weight:bold; margin:2px 0;"><%= item.name() %></p>
                        <p style="font-size:0.75rem; color:#666; margin:2px 0;">
                            消費玉: <%= item.cost() %> 発 / 獲得EXP: +<%= item.expGain() %>
                        </p>
                        <button type="submit" class="cmd-btn play" style="width:100%;">購入してあそぶ</button>
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
    <script src="${pageContext.request.contextPath}/js/play.js"></script>
</body>
</html>