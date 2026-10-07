<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <div class="subpage-container">
            <h2>ごはんをあげる</h2>
            <p>現在のおなか：${pet.hunger}%</p>
            <div class="menu-grid">
                <form action="${pageContext.request.contextPath}/food" method="post" class="food-card">
                    <p>定番フード（満腹度+15 / EXP+10）</p>
                    <button type="submit" class="cmd-btn food" style="width:100%;">たべさせる</button>
                </form>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/food.js"></script>
</body>
</html>