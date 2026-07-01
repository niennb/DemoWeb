<%-- 
    Document   : change-password
    Created on : 28 thg 6, 2026, 20:37:29
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Đổi mật khẩu - AlphaCinema" scope="request"/>

<%-- 2. CSS riêng biệt dành riêng cho giao diện Đổi mật khẩu --%>
<style>
    .hs-section { 
        padding: 60px 0; 
        min-height: calc(100vh - 70px - 150px); 
    }
    .hs-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        max-width: 500px;
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

    .hs-form-group { margin-bottom: 20px; }
    .hs-label { display: block; color: var(--text-muted); font-size: 13px; margin-bottom: 8px; }
    .hs-input {
        width: 100%; 
        padding: 12px; 
        border-radius: 8px; 
        border: 1px solid var(--border-color);
        background: rgba(255,255,255,0.03); 
        color: white; 
        font-size: 15px;
    }

    .hs-button-submit {
        width: 100%; 
        background-color: var(--accent-orange); 
        color: white; 
        border: none;
        padding: 15px; 
        border-radius: 8px; 
        font-weight: 600; 
        cursor: pointer; 
        margin-top: 20px;
    }
    .hs-button-back {
        display: block; 
        text-align: center; 
        color: var(--text-muted); 
        margin-top: 20px; 
        font-size: 14px;
    }

    .error-message { 
        color: #f87171; 
        background: rgba(248, 113, 113, 0.1); 
        padding: 10px; 
        border-radius: 6px; 
        margin-bottom: 20px; 
        font-size: 14px; 
    }
    .success-message { 
        color: #22c55e; 
        background: rgba(34, 197, 94, 0.1); 
        padding: 10px; 
        border-radius: 6px; 
        margin-bottom: 20px; 
        font-size: 14px; 
    }
</style>

<%-- 3. Nội dung form nằm bên trong container (Sẽ được include vào thẻ <main> của main.jsp) --%>
<div class="container hs-section">
    <div class="hs-card">
        <h1 class="hs-title">ĐỔI MẬT KHẨU</h1>

        <%-- Hiển thị thông báo lỗi bằng JSTL nếu có --%>
        <c:if test="${not empty error}">
            <div class="error-message">
                <span><c:out value="${error}" /></span>
            </div>
        </c:if>

        <%-- Hiển thị thông báo thành công bằng JSTL nếu có --%>
        <c:if test="${not empty success}">
            <div class="success-message">
                <span><c:out value="${success}" /></span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/change-password" method="post">
            <div class="hs-form-group">
                <label class="hs-label">Mật khẩu hiện tại</label>
                <input type="password" name="oldPassword" class="hs-input" required>
            </div>

            <div class="hs-form-group">
                <label class="hs-label">Mật khẩu mới</label>
                <input type="password" name="newPassword" class="hs-input" required>
            </div>

            <div class="hs-form-group">
                <label class="hs-label">Xác nhận mật khẩu</label>
                <input type="password" name="confirmPassword" class="hs-input" required>
            </div>

            <button type="submit" class="hs-button-submit">ĐỔI MẬT KHẨU</button>
        </form>

        <%-- Đường dẫn quay về trang cá nhân --%>
        <a href="${pageContext.request.contextPath}/profile" class="hs-button-back">← QUAY LẠI PROFILE</a>
    </div>
</div>
