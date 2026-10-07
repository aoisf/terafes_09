<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <div class="subpage-container">
            <h2>いっしょにあそぶ</h2>
            <p>現在のごきげん：${pet.mood}%</p>
            <div class="minigame-box">
                <form action="${pageContext.request.contextPath}/play" method="post">
                    <p>じゃんけんあそび（ごきげん+10 / EXP+15）</p>
                    <button type="submit" class="cmd-btn play" style="width:100%;">あそぶ！</button>
                </form>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/main" class="back-link">メイン画面へもどる</a>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/play.js"></script>
</body>
</html>