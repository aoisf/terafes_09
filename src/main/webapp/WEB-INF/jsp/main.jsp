<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>玉の数だけ愛される？パチペット生活</title>
    <!-- 分割したCSSを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pachinko.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/control.css">
</head>
<body>
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/header.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/room.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/pachinko.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/control.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/command.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/footer.jsp" />
    </div>

    <!-- 分割したJSを読み込み -->
    <script src="${pageContext.request.contextPath}/js/pachinko.js"></script>
    <script src="${pageContext.request.contextPath}/js/command.js"></script>
</body>
</html>