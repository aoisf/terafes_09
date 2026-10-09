<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>玉の数だけ愛される？パチペット生活</title>
    <!-- 分割したCSSを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pachinko.css?v=18">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/control.css?v=10">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rescue.css?v=6">
</head>
<body>
    <!-- メイン画面コンテナ -->
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/room.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/pachinko.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/control.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/command.jsp" />
    </div>

    <%-- 救済ポップアップ（部品化） --%>
    <jsp:include page="/WEB-INF/jsp/parts/rescue.jsp" />

    <%-- パチンコ結果トースト --%>
    <%
        String actionMsg = (String) session.getAttribute("actionMessage");
        if (actionMsg != null && !actionMsg.isEmpty()) {
            boolean isHit = actionMsg.contains("大当り");
            session.removeAttribute("actionMessage");

            String formattedMsg = actionMsg;
            if (isHit) {
                formattedMsg = actionMsg.replaceAll("([\\d,]+発)", "<span class=\"rainbow-text\">$1</span>");
            }
    %>
        <div id="result-toast" class="pachinko-result-toast <%= isHit ? "hit" : "miss" %>"
             data-duration="<%= isHit ? 3200 : 2200 %>" role="status" aria-live="polite">
            <% if (isHit) { %>
                ✨ <%= formattedMsg %> ✨
            <% } else { %>
                <%= formattedMsg %>
            <% } %>
        </div>
    <%
        }
    %>

    <script src="${pageContext.request.contextPath}/js/pachinko.js?v=8"></script>
    <script src="${pageContext.request.contextPath}/js/rescue.js?v=6"></script>
</body>
</html>
