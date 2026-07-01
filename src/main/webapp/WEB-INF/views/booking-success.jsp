<%-- 
    Document   : booking-success
    Purpose    : Hiển thị thông báo đặt vé thành công
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Đặt Vé Thành Công - AlphaCinema" scope="request"/>

<%-- 2. CSS riêng biệt cho trang thông báo thành công --%>
<style>
    .sc-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
        display: flex;
        align-items: center;
        justify-content: center;
        flex: 1; /* Đảm bảo đẩy Footer nằm sát đáy màn hình */
    }

    .sc-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        width: 100%;
        max-width: 540px;
        text-align: center;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        animation: scFadeIn 0.5s ease-out forwards;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .sc-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
    }

    .sc-icon-wrapper {
        width: 70px;
        height: 70px;
        background-color: rgba(34, 197, 94, 0.1);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px auto;
    }

    .sc-icon-wrapper svg {
        width: 40px;
        height: 40px;
        fill: #22c55e; /* var(--success-green) */
    }

    .sc-title {
        font-size: 26px;
        font-weight: 700;
        color: var(--text-light);
        margin-bottom: 8px;
    }

    .sc-subtitle {
        color: var(--text-muted);
        font-size: 14px;
        margin-bottom: 30px;
    }

    .sc-details-list {
        background-color: rgba(255, 255, 255, 0.01);
        border: 1px dashed var(--border-color);
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
        text-align: left;
    }

    .sc-btn-group {
        display: flex;
        gap: 15px;
    }

    .sc-btn {
        flex: 1;
        padding: 14px;
        font-size: 14px;
        font-weight: 600;
        border-radius: 6px;
        transition: all 0.2s ease;
        text-align: center;
        cursor: pointer;
    }

    .sc-btn-home {
        background-color: #ff5b00; /* var(--accent-orange) */
        color: white;
        border: none;
        display: block;
    }

    .sc-btn-home:hover {
        opacity: 0.9;
    }

    @media (max-width: 480px) {
        .sc-btn-group {
            flex-direction: column;
            gap: 10px;
        }
    }

    @keyframes scFadeIn {
        from {
            opacity: 0;
            transform: translateY(15px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>

<%-- 3. Nội dung chính của trang nằm bên trong thẻ container --%>
<div class="container sc-section">
    <div class="sc-card">

        <div class="sc-icon-wrapper">
            <svg viewBox="0 0 24 24">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
            </svg>
        </div>

        <h1 class="sc-title">🎉 ĐẶT VÉ THÀNH CÔNG</h1>
        <p class="sc-subtitle">Cảm ơn bạn đã đặt vé tại Cinema Ticket.</p>

        <div class="sc-details-list">
            <h3 style="color:#22c55e; text-align:center; margin-bottom:15px;">
                ✔ Đặt vé thành công!
            </h3>

            <p style="text-align:center; color:#94a3b8; line-height:1.8;">
                Cảm ơn bạn đã lựa chọn <strong style="color:#ff5b00;">AlphaCinema</strong>.<br><br>

                Hệ thống đã ghi nhận thông tin đặt vé của bạn thành công.<br>

                Chúc bạn có những phút giây xem phim thật vui vẻ cùng bạn bè và người thân!
            </p>
        </div>

        <div class="sc-btn-group">
            <%-- Sử dụng contextPath của Spring MVC để đảm bảo đường dẫn chuẩn xác --%>
            <a href="${pageContext.request.contextPath}/" class="sc-btn sc-btn-home" style="width:100%;">
                XÁC NHẬN
            </a>
        </div>

    </div>
</div>