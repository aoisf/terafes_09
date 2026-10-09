<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>玉の数だけ愛される？パチペット生活</title>
    <!-- 分割したCSSを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pachinko.css?v=7">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/control.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rescue.css?v=2">
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
        <div id="result-toast" class="pachinko-result-toast <%= isHit ? "hit" : "miss" %>">
            <% if (isHit) { %>
                ✨ <%= formattedMsg %> ✨
            <% } else { %>
                <%= formattedMsg %>
            <% } %>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var toast = document.getElementById('result-toast');
                if (toast) {
                    requestAnimationFrame(function() {
                        toast.classList.add('show');
                    });
                    var duration = <%= isHit ? 3200 : 2200 %>;
                    setTimeout(function() {
                        toast.classList.remove('show');
                        setTimeout(function() { toast.remove(); }, 400);
                    }, duration);
                }
            });
        </script>
    <%
        }
    %>

    <script src="${pageContext.request.contextPath}/js/pachinko.js?v=6"></script>
    <script src="${pageContext.request.contextPath}/js/rescue.js?v=2"></script>
</body>
</html>
