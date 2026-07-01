<%-- 
    Document   : profile
    Created on : 28 thg 6, 2026, 20:38:22
    Author     : baoni
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Thông tin tài khoản - AlphaCinema" scope="request"/>
<style>

    /* --- CSS MỚI CHO TRANG PROFILE (Class hs-) --- */
    .hs-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
    }
    .hs-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        max-width: 600px;
        margin: 0 auto;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }
    .hs-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 30px;
        color: var(--text-light);
        border-left: 4px solid var(--accent-orange);
        padding-left: 14px;
    }
    .hs-info-group {
        margin-bottom: 20px;
    }
    .hs-label {
        display: block;
        color: var(--text-muted);
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        margin-bottom: 8px;
    }
    .hs-value {
        font-size: 18px;
        font-weight: 500;
        color: var(--text-light);
        display: block;
        padding: 10px;
        background: rgba(255,255,255,0.03);
        border-radius: 6px;
    }
    .hs-button {
        display: block;
        text-align: center;
        background-color: var(--accent-orange);
        color: white;
        padding: 15px;
        border-radius: 8px;
        font-weight: 600;
        margin-top: 30px;
        transition: opacity 0.2s;
    }
    .hs-button:hover {
        opacity: 0.9;
    }
</style>

<%-- 2. Nội dung chính (Sẽ được tự động include vào phần <main> của main.jsp) --%>
<div class="container hs-section">
    <div class="hs-card">
        <h1 class="hs-title">THÔNG TIN TÀI KHOẢN</h1>

        <%-- Hiển thị Username --%>
        <div class="hs-info-group">
            <span class="hs-label">Username</span>
            <span class="hs-value"><c:out value="${user.username}" /></span>
        </div>

        <%-- Hiển thị Email --%>
        <div class="hs-info-group">
            <span class="hs-label">Email</span>
            <span class="hs-value"><c:out value="${user.email}" /></span>
        </div>

        <%-- Hiển thị Số điện thoại --%>
        <div class="hs-info-group">
            <span class="hs-label">Vai trò</span>
            <span class="hs-value"><c:out value="${user.role}" /></span>
        </div>

        <%-- Đường dẫn chuyển hướng sang trang Đổi mật khẩu chuẩn Spring MVC --%>
        <a href="${pageContext.request.contextPath}/change-password" class="hs-button">
            ĐỔI MẬT KHẨU
        </a>
    </div>
</div>
