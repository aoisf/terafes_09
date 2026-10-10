<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>玉の数だけ愛される？パチペット生活</title>
    <!-- 分割したCSSを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/room.css?v=6">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pachinko.css?v=18">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/control.css?v=10">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rescue.css?v=6">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css?v=9">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/image-preview.css?v=1">
</head>
<body>
    <!-- メイン画面コンテナ -->
    <div class="app-container">
        <jsp:include page="/WEB-INF/jsp/parts/dashboard.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/room.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/pachinko.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/control.jsp" />
        <jsp:include page="/WEB-INF/jsp/parts/command.jsp" />
        <section aria-label="デバッグ用レベル変更" style="margin-top:16px;padding:14px;border:1px dashed #b79a58;border-radius:12px;background:#fff8e7;color:#32240e">
            <strong>デバッグ用 · レベル変更</strong>
            <p style="margin:6px 0 12px;font-size:12px">経験値を0、服を「ふつう」に戻して指定レベルに変更します。玉数はそのままです。未追加の進化形は最新の姿で表示します。</p>
            <form method="post" action="${pageContext.request.contextPath}/main" style="display:flex;flex-wrap:wrap;gap:8px">
                <% for (int debugLevel : new int[]{1,10,20,30,40,50,60,70,80,90,100}) { %>
                <button type="submit" name="debugLevel" value="<%= debugLevel %>" style="padding:8px 12px;border:1px solid #b79a58;border-radius:8px;background:#fff;color:#32240e;font-weight:bold;cursor:pointer">level<%= debugLevel %></button>
                <% } %>
            </form>
        </section>
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
    <script src="${pageContext.request.contextPath}/js/rescue.js?v=9"></script>
    <script src="${pageContext.request.contextPath}/js/dashboard.js?v=9" defer></script>
    <script src="${pageContext.request.contextPath}/js/image-preview.js?v=2" defer></script>
<script src="${pageContext.request.contextPath}/js/final-evolution.js?v=1" data-context="${pageContext.request.contextPath}" defer></script>
</body>
</html>
