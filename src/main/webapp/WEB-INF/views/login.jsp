<%-- 
    Document   : login
    Created on : 18 thg 6, 2026, 01:02:29
    Author     : baoni
--%>

<%-- WEB-INF/views/login.jsp --%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<style>
            .login-section {
            padding: 80px 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 70px - 150px);
        }

        .login-box {
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            width: 100%;
            max-width: 450px;
            padding: 40px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }

        .login-box h2 {
            font-size: 26px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 8px;
        }

        .login-box .subtitle {
            color: var(--text-muted);
            text-align: center;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-group input {
            background-color: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--text-light);
            padding: 12px 16px;
            font-size: 14px;
            border-radius: 6px;
            outline: none;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            border-color: var(--accent-orange);
        }

        .form-submit-btn {
            width: 100%;
            background-color: var(--accent-orange);
            color: white;
            border: none;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 10px;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: var(--text-muted);
        }

        .register-link a {
            color: var(--accent-orange);
            font-weight: 500;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
</style>

<main class="container login-section">
    <div class="login-box">
        <h2>Đăng Nhập</h2>
        <p class="subtitle">Vui lòng đăng nhập để đặt vé xem phim</p>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <%-- Hiển thị thông báo lỗi nếu có --%>
            <c:if test="${not empty error}">
                <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; text-align: center;">
                    ${error}
                </div>
            </c:if>

            <div class="form-group">
                <label for="username">Tên tài khoản</label>
                <input type="text" id="username" name="username" value="${username}" placeholder="Nhập tên tài khoản" required />
            </div>

            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required />
            </div>

            <button type="submit" class="form-submit-btn">Đăng Nhập</button>
        </form>

        <div class="register-link">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
    </div>
</main>