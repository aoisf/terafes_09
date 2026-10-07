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
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/header.jsp" />
        <div class="subpage-container">
            <h2>クローゼット</h2>
            <p>${pet.name} のおきがえ</p>
            <div class="wardrobe-list">
                <div class="item-card"><p>ふつうの服</p><button disabled>着用中</button></div>
                <div class="item-card"><p>パチンコ法被</p><button>着替える</button></div>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/dress.js"></script>
</body>
</html>