<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Pet" %>
<% Pet pet = (Pet) request.getAttribute("pet"); String currentOutfitName = "school-swimsuit".equals(pet.getOutfitId()) ? "水着" : pet.getOutfitName(); %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>おきがえ - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dress.css?v=4">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/image-preview.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar-ads.css?v=3">
</head>
<body>
    <aside class="side-ad side-ad-left" aria-label="新型ショッピングモールの広告">
        <span class="side-ad-label">ADVERTISEMENT</span>
        <a href="${pageContext.request.contextPath}/advertisement.html?from=shopping-mall" aria-label="新型ショッピングモールの広告を見る">
            <img src="${pageContext.request.contextPath}/images/ads/shopping-mall-ad.png" alt="新型ショッピングモール。新しい街が、はじまる。" width="1000" height="2500">
        </a>
    </aside>
    <aside class="side-ad side-ad-right" aria-label="古着店95％ONの広告">
        <span class="side-ad-label">ADVERTISEMENT</span>
        <a href="${pageContext.request.contextPath}/advertisement.html?from=vintage-shop" aria-label="古着店全品95％ONの広告を見る">
            <img src="${pageContext.request.contextPath}/images/ads/vintage-shop-ad.png" alt="古着店、全品95％ON。お値段まさかの1.95倍。値下げじゃない、値上げです。" width="1000" height="2500">
        </a>
    </aside>
    <div class="app-container page-dress">
        <h2 class="subpage-title">クローゼット</h2>
        <p class="subpage-subtitle">${pet.name} のおきがえ</p>

        <div class="wardrobe-list" aria-label="着替えを選択">
            <%
                String[] outfitIds = {"normal", "happi", "sunglasses", "school-swimsuit"};
                String[] outfitNames = {"ふつう", "パチンコ法被", "サングラス", "水着"};
                for (int i = 0; i < outfitIds.length; i++) {
                    boolean selected = outfitIds[i].equals(pet.getOutfitId());
            %>
            <article class="wardrobe-card <%= selected ? "is-selected" : "" %>">
                <img class="wardrobe-image pet-image" src="${pageContext.request.contextPath}/images/pets/tamagoro/<%= pet.getOutfitImageFor(outfitIds[i]) %>" alt="<%= outfitNames[i] %>を着たたまごろう">
                <div class="wardrobe-copy"><h3 class="wardrobe-name"><%= outfitNames[i] %></h3></div>
                <form method="post" action="${pageContext.request.contextPath}/dress">
                    <button class="dress-btn" type="submit" name="outfit" value="<%= outfitIds[i] %>" <%= selected ? "disabled aria-current=\"true\"" : "" %>><%= selected ? "着用中" : "これに着替える" %></button>
                </form>
            </article>
            <% } %>
        </div>

        <section class="current-outfit" aria-live="polite">
            <div><p class="current-outfit-label">CURRENT LOOK</p><h3>現在のたまごろ</h3><p><%= currentOutfitName %>を着用中</p></div>
            <img class="current-outfit-image pet-image" src="${pageContext.request.contextPath}/images/pets/tamagoro/${pet.outfitImage}" alt="現在の姿：<%= currentOutfitName %>">
        </section>

        <div class="footer-area">
            <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/image-preview.js?v=5" defer></script>
<script src="${pageContext.request.contextPath}/js/final-evolution.js?v=2" data-context="${pageContext.request.contextPath}" defer></script>
</body>
</html>
