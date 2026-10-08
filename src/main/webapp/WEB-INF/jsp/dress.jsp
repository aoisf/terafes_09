<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>おきがえ - パチペット生活</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dress.css">
</head>
<body>
    <div class="app-container page-dress">
        <h2 class="subpage-title">クローゼット</h2>
        <p class="subpage-subtitle">${pet.name} のおきがえ</p>

        <div class="wardrobe-list">
            <div class="item-card">
                <p class="wardrobe-name">ふつうの服</p>
                <button class="cmd-btn dress-btn" disabled>着用中</button>
            </div>
            <div class="item-card">
                <p class="wardrobe-name">パチンコ法被</p>
                <button class="cmd-btn dress-btn">着替える</button>
            </div>
        </div>

        <div class="footer-area">
            <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/dress.js"></script>
</body>
</html>