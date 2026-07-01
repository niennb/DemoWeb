<%-- 
    Document   : main
    Created on : 17 thg 6, 2026, 19:24:08
    Author     : baoni
--%>

<%-- WEB-INF/views/layout/main.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${empty pageTitle ? 'AlphaCinema' : pageTitle}</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #0f172a;
                --accent-orange: #ff5b00;
                --text-light: #f8fafc;
                --text-muted: #94a3b8;
                --card-bg: #1e293b;
                --border-color: #334155;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: var(--primary-blue);
                color: var(--text-light);
                line-height: 1.6;
            }

            a {
                text-transform: none;
                color: inherit;
                text-decoration: none;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* --- STYLE CHO PHẦN HEADER DÙNG CHUNG --- */
            .header-wrapper {
                display: flex;
                justify-content: space-between;
                align-items: center;
                height: 70px;
            }
            .logo {
                font-size: 24px;
                font-weight: 700;
                color: var(--text-light);
            }
            .logo span {
                color: var(--accent-orange);
            }
            nav ul {
                display: flex;
                list-style: none;
                gap: 25px;
            }
            nav ul li a {
                font-weight: 500;
                transition: color 0.3s;
            }
            nav ul li a:hover {
                color: var(--accent-orange);
            }
            .auth-buttons {
                display: flex;
                gap: 15px;
                align-items: center;
            }
            .auth-buttons .btn-login {
                font-weight: 600;
                transition: color 0.3s;
            }
            .auth-buttons .btn-login:hover {
                color: var(--accent-orange);
            }
            .auth-buttons .btn-register {
                background-color: var(--accent-orange);
                color: white;
                padding: 8px 20px;
                border-radius: 6px;
                font-weight: 600;
                transition: opacity 0.3s;
            }
            .auth-buttons .btn-register:hover {
                opacity: 0.9;
            }
            .user-profile-wrapper {
                position: relative;
                cursor: pointer;
            }
            .user-avatar-btn {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 5px;
                border-radius: 50px;
                transition: background-color 0.3s;
            }
            .user-avatar-btn:hover {
                background-color: rgba(255, 255, 255, 0.05);
            }
            .fb-avatar-svg {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #4b5563;
                fill: #e5e7eb;
                display: block;
            }
            .user-name {
                font-weight: 600;
                font-size: 14px;
                color: var(--text-light);
                max-width: 120px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .profile-dropdown {
                position: absolute;
                top: 55px;
                right: 0;
                background-color: var(--card-bg);
                border: 1px solid var(--border-color);
                border-radius: 8px;
                width: 200px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.4);
                display: none;
                overflow: hidden;
                z-index: 1000;
            }
            .profile-dropdown.show {
                display: block;
            }
            .profile-dropdown a {
                display: block;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: 500;
                color: var(--text-light);
                transition: background-color 0.2s, color 0.2s;
                border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            }
            .profile-dropdown a:last-child {
                border-bottom: none;
                color: #f87171;
            }
            .profile-dropdown a:hover {
                background-color: rgba(255, 255, 255, 0.05);
            }
            .profile-dropdown a:last-child:hover {
                background-color: rgba(239, 68, 68, 0.1);
            }
            footer {
                background-color: #0b0f19;
                padding: 40px 0;
                border-top: 1px solid #222f43;
                font-size: 14px;
                color: var(--text-muted);
            }
            .footer-wrapper {
                display: flex;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 20px;
            }
            .footer-bottom {
                text-align: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #222f43;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/layout/header.jsp"/>

        <main>
            <jsp:include page="/WEB-INF/views/${viewFile}.jsp"/>
        </main>

        <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
    </body>
    <div id="global-loader" class="loader-container">
        <div class="loader-box">
            <div class="spinner"></div>
            <p class="loader-text">Đang xử lý....</p>
            <span class="loader-subtext">Vui lòng đợi trong giây lát</span>
        </div>
    </div>

    <style>
        /* Khung nền mờ phủ toàn màn hình */
        .loader-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(15, 23, 42, 0.95); /* Màu nền tối #0f172a ẩn hiện mượt */
            z-index: 999999; /* Đảm bảo luôn nằm trên cùng mọi linh kiện khác */
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 1;
            visibility: visible;
            transition: opacity 0.4s ease, visibility 0.4s ease; /* Hiệu ứng fade-out hiệu năng cao */
        }

        /* Lớp ẩn hiệu ứng khi hoàn thành */
        .loader-container.loader-hidden {
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
        }

        .loader-box {
            text-align: center;
        }

        /* Hiệu ứng vòng tròn xoay Công nghệ */
        .spinner {
            width: 55px;
            height: 55px;
            border: 5px solid #334155; /* Vòng nền xám tối */
            border-top: 5px solid #fb923c; /* Vòng xoay màu cam Thương hiệu */
            border-radius: 50%;
            animation: spin-animation 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin-animation {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        /* Cấu hình chữ thông báo */
        .loader-text {
            color: #f8fafc;
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 8px 0;
            letter-spacing: 0.5px;
        }
        .loader-subtext {
            color: #64748b;
            font-size: 13px;
        }
    </style>

    <script>
        // Lắng nghe sự kiện toàn bộ tài nguyên (Data, Hình ảnh, DOM) đã dựng xong vĩnh viễn
        window.addEventListener('load', function () {
            const loader = document.getElementById('global-loader');
            if (loader) {
                // Thêm class ẩn để kích hoạt hiệu ứng mờ dần (Fade-out)
                loader.classList.add('loader-hidden');
            }
        });
    </script>
</html>

