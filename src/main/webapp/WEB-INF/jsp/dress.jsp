<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Pet" %>
<% Pet pet = (Pet) request.getAttribute("pet"); String currentOutfitName = "school-swimsuit".equals(pet.getOutfitId()) ? "水着" : pet.getOutfitName(); %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>おきがえ - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dress.css?v=4">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/image-preview.css?v=1">
</head>
<body>
    <div class="app-container page-dress">
        <h2 class="subpage-title">クローゼット</h2>
        <p class="subpage-subtitle">${pet.name} のおきがえ</p>

        <div class="wardrobe-list" aria-label="着替えを選択">
            <%
                String[] outfitIds = {"normal", "happi", "sunglasses", "school-swimsuit"};
                String[] outfitNames = {"ふつう", "パチンコ法被", "サングラス", "水着"};
                String[] outfitImages = {"lv1.png", "lv1-happi.png", "lv1-sunglasses.png", "lv1-school-swimsuit.png"};
                for (int i = 0; i < outfitIds.length; i++) {
                    boolean selected = outfitIds[i].equals(pet.getOutfitId());
            %>
            <article class="wardrobe-card <%= selected ? "is-selected" : "" %>">
                <img class="wardrobe-image pet-image" src="${pageContext.request.contextPath}/images/pets/tamagoro/<%= outfitImages[i] %>" alt="<%= outfitNames[i] %>を着たたまごろう">
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
    <script src="${pageContext.request.contextPath}/js/image-preview.js?v=2" defer></script>
</body>
</html>
