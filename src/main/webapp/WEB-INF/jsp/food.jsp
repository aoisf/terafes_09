<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.PetCareLogic.CareItem" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ごはん - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/subpage.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/food.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/image-preview.css?v=2">
</head>
<body>
    <div class="app-container page-food care-page"
         data-endpoint="${pageContext.request.contextPath}/food"
         data-count-unit="個" data-balls="${pet.balls}" data-level="${pet.level}"
         data-pet-images="${pageContext.request.contextPath}/images/pets/tamagoro/" data-exp="${pet.exp}" data-next-exp="${pet.nextLevelExp}">
        <h2 class="subpage-title">ごはんをあげる</h2>
        <div class="status-summary" id="care-status">
            <p>所持玉数: <strong id="balls-display" class="formatted-number">${pet.balls} 発</strong></p>
            <p id="level-display">LV: ${pet.level} (EXP: ${pet.exp} / ${pet.nextLevelExp})</p>
        </div>

        <div class="menu-grid">
            <%
                CareItem[] items = (CareItem[]) request.getAttribute("items");
                if (items != null) {
                    for (CareItem item : items) {
            %>
                <div class="care-card food-card" data-cost="<%= item.cost().toString() %>" data-id="<%= item.id() %>">
                    <div class="item-summary">
                        <img class="care-item-icon" src="${pageContext.request.contextPath}/images/pets/tamagoro/care/<%= item.id() %>.png" alt="">
                        <div class="item-info">
                            <span class="item-name"><%= item.name() %></span>
                            <span class="item-meta">1個消費: <%= String.format(java.util.Locale.JAPAN, "%,d", item.cost()) %> 発 / 獲得EXP: +<%= String.format(java.util.Locale.JAPAN, "%,d", item.expGain()) %></span>
                        </div>
                    </div>
                    <div class="action-box">
                        <span class="affordable-count">買える数: <strong class="count-val">0</strong></span>
                        <div class="buy-buttons">
                            <button type="button" class="btn-care btn-buy" data-count="1">1個</button>
                            <button type="button" class="btn-care btn-buy" data-count="10">10個</button>
                            <button type="button" class="btn-care btn-buy" data-count="100">100個</button>
                            <button type="button" class="btn-care btn-buy" data-count="1000">1000個</button>
                            <button type="button" class="btn-care btn-buy btn-max" data-count="max">MAX</button>
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

    <script src="${pageContext.request.contextPath}/js/care.js?v=13" defer></script>
    <script src="${pageContext.request.contextPath}/js/image-preview.js?v=3" defer></script>
<script src="${pageContext.request.contextPath}/js/final-evolution.js?v=2" data-context="${pageContext.request.contextPath}" defer></script>
</body>
</html>
