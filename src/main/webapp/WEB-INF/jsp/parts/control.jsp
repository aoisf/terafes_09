<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 操作パネル -->
<section class="control-section">
    <div class="status-bar">
        <!-- ここが「54,320発」と直書きされていたら ${pet.balls}発 に変更するよ -->
        <div class="ball-count">玉数 <span>${pet.balls}発</span></div>
        <div class="toggles">
            <label>玉を投入 <input type="checkbox"></label>
            <label>オート <input type="checkbox" checked></label>
        </div>
    </div>
    <form action="${pageContext.request.contextPath}/action" method="post">
        <input type="hidden" name="action" value="pachinko">
        <button type="submit" class="start-button">スタート！</button>
    </form>
</section>