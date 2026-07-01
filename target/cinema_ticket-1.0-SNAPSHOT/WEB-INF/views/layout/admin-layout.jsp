<%-- 
    Document   : admin-layout
    Created on : 18 thg 6, 2026, 23:51:54
    Author     : baoni
    Upgraded   : Tối ưu UI/UX, Bổ sung Dashboard & Trang chủ, Tự động phân trang, TỰ ĐỘNG CẮT CHỮ (...) & HOVER TOOLTIP GLOBAL
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${pageTitle}</title>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <style>
            :root {
                --admin-bg: #0f172a;
                --sidebar-bg: #1e293b;
                --accent: #fb923c;
                --text: #f8fafc;
                --border-color: #334155;
            }
            body {
                margin: 0;
                padding: 0;
                font-family: 'Plus Jakarta Sans', sans-serif;
                background-color: var(--admin-bg);
                color: var(--text);
                display: flex; 
                min-height: 100vh;
            }
            
            /* =========================================================
               1. CẤU HÌNH SIDEBAR & MENU CHỨC NĂNG
               ========================================================= */
            .admin-sidebar {
                width: 260px;
                background-color: var(--sidebar-bg);
                border-right: 1px solid var(--border-color);
                display: flex;
                flex-direction: column;
                position: fixed;
                top: 0;
                bottom: 0;
                left: 0;
                z-index: 100;
            }
            .sidebar-brand {
                padding: 24px;
                font-size: 20px;
                font-weight: 700;
                color: var(--accent);
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .sidebar-menu {
                list-style: none;
                padding: 12px;
                margin: 0;
                flex: 1;
                overflow-y: auto;
            }
            .menu-item a {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                color: #94a3b8;
                text-decoration: none;
                border-radius: 8px;
                margin-bottom: 4px;
                font-weight: 500;
                font-size: 14px;
                transition: all 0.2s ease;
            }
            .menu-item a:hover {
                background-color: rgba(251, 146, 60, 0.1);
                color: var(--accent);
            }
            .menu-item.active a {
                background-color: var(--accent);
                color: #0f172a;
                font-weight: 600;
            }

            /* =========================================================
               2. CẤU HÌNH TOPBAR (THANH ĐẦU TRANG - CHỨA NÚT XEM TRANG CHỦ)
               ========================================================= */
            .topbar-header {
                height: 70px;
                background-color: var(--sidebar-bg);
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: flex-end;
                padding: 0 40px;
                position: sticky;
                top: 0;
                z-index: 90;
            }
            .btn-view-home {
                display: flex;
                align-items: center;
                gap: 8px;
                background-color: #334155;
                color: #f8fafc;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 500;
                border: 1px solid transparent;
                transition: all 0.2s ease;
            }
            .btn-view-home:hover {
                background-color: transparent;
                border-color: var(--accent);
                color: var(--accent);
            }

            /* =========================================================
               3. KHUNG PANEL CHỨA NỘI DUNG CHÍNH
               ========================================================= */
            .main-wrapper {
                margin-left: 260px;
                flex: 1;
                display: flex;
                flex-direction: column;
                min-width: 0;
            }
            .admin-content {
                flex: 1;
                padding: 40px;
                background-color: var(--admin-bg);
            }
            
            .form-panel {
                background-color: #1e293b;
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 24px;
                margin-bottom: 25px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }
            
            .table-panel {
                background-color: #1e293b;
                border: 1px solid var(--border-color);
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
            }

            /* =========================================================
               4. ĐƯỜNG KẺ BẢNG VÀ TÍNH NĂNG TỰ ĐỘNG CẮT CHỮ GỌN GÀNG (MỚI)
               ========================================================= */
            .table-responsive {
                overflow-x: auto;
                position: relative;
                border-radius: 8px;
                border: 1px solid var(--border-color);
            }
            .custom-table {
                margin-bottom: 0 !important;
                border-collapse: separate !important;
                border-spacing: 0;
            }
            
            .custom-table th, .custom-table td {
                border-right: 1px solid var(--border-color) !important;
                border-bottom: 1px solid var(--border-color) !important;
                
                /* TÍNH NĂNG MỚI: Ép toàn bộ ô trong bảng tự động hiển thị dấu ... nếu quá dài */
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            
            /* LOẠI TRỪ: Cột Hành động (cột cuối) không được cắt chữ để tránh vỡ nút bấm */
            .custom-table th:last-child, .custom-table td:last-child {
                border-right: none !important;
                max-width: none;
                overflow: visible;
            }
            
            .sticky-left-1 {
                position: sticky !important;
                left: 0;
                z-index: 5;
                background-color: #1e293b !important;
            }
            .sticky-left-2 {
                position: sticky !important;
                left: 80px;
                z-index: 5;
                background-color: #1e293b !important;
            }
            
            .custom-table tbody tr:hover td.sticky-left-1,
            .custom-table tbody tr:hover td.sticky-left-2 {
                background-color: #24334d !important;
            }
            
            .custom-table thead th.sticky-left-1,
            .custom-table thead th.sticky-left-2 {
                z-index: 6;
                background-color: #0f172a !important;
            }

            /* =========================================================
               5. THANH PHÂN TRANG (PAGINATION)
               ========================================================= */
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 20px;
                padding-top: 15px;
                border-top: 1px solid var(--border-color);
            }
            .pagination-info {
                color: #94a3b8;
                font-size: 13.5px;
            }
            .pagination-buttons {
                display: flex;
                gap: 6px;
            }
            .page-link-custom {
                background-color: #0f172a;
                border: 1px solid var(--border-color);
                color: #e2e8f0;
                padding: 6px 14px;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: all 0.2s ease;
                user-select: none;
            }
            .page-link-custom:hover:not(.disabled) {
                border-color: var(--accent);
                color: var(--accent);
            }
            .page-link-custom.active {
                background-color: var(--accent);
                border-color: var(--accent);
                color: #0f172a;
                font-weight: 600;
            }
            .page-link-custom.disabled {
                color: #475569;
                cursor: not-allowed;
                border-color: rgba(51, 65, 85, 0.4);
                background-color: rgba(15, 23, 42, 0.5);
            }

            /* =========================================================
               6. LOADER SCREEN
               ========================================================= */
            #screen-loader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: #0f172a;
                z-index: 99999;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: opacity 0.4s ease, visibility 0.4s ease;
            }
            #screen-loader.fade-out {
                opacity: 0;
                visibility: hidden;
                pointer-events: none;
            }
            .loader-box {
                text-align: center;
            }
            .spinner {
                width: 55px;
                height: 55px;
                border: 5px solid #334155;
                border-top: 5px solid var(--accent);
                border-radius: 50%;
                animation: spin-animation 1s linear infinite;
                margin: 0 auto 20px;
            }
            @keyframes spin-animation {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
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
    </head>
    <body>

        <div id="screen-loader">
            <div class="loader-box">
                <div class="spinner"></div>
                <h3 class="loader-text">HỆ THỐNG ADMIN ALPHACINEMA</h3>
                <p class="loader-subtext">Đang tải và đồng bộ dữ liệu bảo mật...</p>
            </div>
        </div>

        <div class="admin-sidebar">
            <div class="sidebar-brand">
                <i class="fa-solid fa-clapperboard"></i> AlphaCinema
            </div>
            <ul class="sidebar-menu">
                <li class="menu-item ${viewFile eq 'admin/dashboard' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fa-solid fa-chart-pie"></i> Dashboard Tổng Quan
                    </a>
                </li>
                
                <li class="menu-item ${viewFile eq 'admin/movie-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/movie-manage">
                        <i class="fa-solid fa-film"></i> Quản Lý Phim
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/showtime-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/showtime-manage">
                        <i class="fa-solid fa-calendar-days"></i> Quản Lý Suất Chiếu
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/room-layout' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/room-layout">
                        <i class="fa-solid fa-masks-theater"></i> Quản Lý Rạp Phim
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/seat-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/seat-manage">
                        <i class="fa-solid fa-couch"></i> Sơ Đồ Ghế Ngồi
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/ticket-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/ticket-manage">
                        <i class="fa-solid fa-ticket"></i> Quản Lý Vé Xem Phim
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/account-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/account-manage">
                        <i class="fa-solid fa-users-gear"></i> Quản Lý Người Dùng
                    </a>
                </li>
                <li class="menu-item ${viewFile eq 'admin/payment-manage' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/admin/payment-manage">
                        <i class="fa-solid fa-wallet"></i> Thống Kê Doanh Thu
                    </a>
                </li>
            </ul>
        </div>

        <div class="main-wrapper">
            
            <div class="topbar-header">
                <a href="${pageContext.request.contextPath}/" class="btn-view-home" target="_blank">
                    <i class="fa-solid fa-house-laptop"></i> Xem Trang Chủ Client
                </a>
            </div>

            <div class="admin-content">
                <jsp:include page="../${viewFile}.jsp" />
            </div>
        </div>

        <script>
            // TẮT MÀN HÌNH CHỜ SAU KHI DỰNG XONG GIAO DIỆN
            window.addEventListener('load', function () {
                const loader = document.getElementById('screen-loader');
                if (loader) {
                    loader.classList.add('fade-out');
                }
            });

            document.addEventListener("DOMContentLoaded", function() {
                
                // =========================================================================
                // ENGINE 1: TỰ ĐỘNG THÊM TOOLTIP (HOVER XEM ĐẦY ĐỦ) CHO CÁC Ô BỊ CẮT CHỮ
                // =========================================================================
                const tableCells = document.querySelectorAll(".custom-table td");
                tableCells.forEach(function(cell) {
                    // Loại trừ các cột chứa nút bấm, hình ảnh hoặc các liên kết thao tác
                    if (!cell.querySelector('.btn-action') && !cell.querySelector('img') && !cell.querySelector('button') && !cell.classList.contains('action-group')) {
                        const cellText = cell.innerText.trim();
                        // Chỉ gán hiển thị đầy đủ nếu ô đó có chữ dài hơn 10 ký tự
                        if (cellText.length > 10) {
                            cell.setAttribute('title', cellText);
                            // Thêm nhẹ kiểu con trỏ để báo hiệu người dùng có thể hover
                            cell.style.cursor = "help"; 
                        }
                    }
                });

                // =========================================================================
                // ENGINE 2: TỰ ĐỘNG PHÂN TRANG (PAGINATION) BẤT KỲ BẢNG NÀO CÓ > 10 DÒNG
                // =========================================================================
                const tables = document.querySelectorAll(".custom-table");
                
                tables.forEach(function(table) {
                    const tbody = table.querySelector("tbody");
                    if (!tbody) return;
                    
                    const rows = Array.from(tbody.querySelectorAll("tr"));
                    if (rows.length <= 1 && rows[0] && rows[0].querySelector("td[colspan]")) {
                        return; // Bỏ qua nếu bảng đang rỗng (chỉ có dòng báo Không tìm thấy dữ liệu)
                    }
                    
                    const rowsPerPage = 10;
                    const totalRows = rows.length;
                    if (totalRows <= rowsPerPage) return;
                    
                    const totalPages = Math.ceil(totalRows / rowsPerPage);
                    let currentPage = 1;
                    
                    const panel = table.closest(".table-panel") || table.parentElement;
                    const container = document.createElement("div");
                    container.className = "pagination-container";
                    
                    const infoText = document.createElement("div");
                    infoText.className = "pagination-info";
                    
                    const buttonGroup = document.createElement("div");
                    buttonGroup.className = "pagination-buttons";
                    
                    container.appendChild(infoText);
                    container.appendChild(buttonGroup);
                    panel.appendChild(container);
                    
                    function setPage(page) {
                        currentPage = page;
                        const start = (page - 1) * rowsPerPage;
                        const end = start + rowsPerPage;
                        
                        rows.forEach(function(row, index) {
                            if (index >= start && index < end) {
                                row.style.display = "";
                            } else {
                                row.style.display = "none";
                            }
                        });
                        
                        const currentShowing = Math.min(end, totalRows);
                        infoText.innerHTML = "Hiển thị từ dòng <b>" + (start + 1) + "</b> đến <b>" + currentShowing + "</b> trên tổng số <b>" + totalRows + "</b> dữ liệu.";
                        buildButtons();
                    }
                    
                    function buildButtons() {
                        buttonGroup.innerHTML = "";
                        
                        const prevBtn = document.createElement("span");
                        prevBtn.className = "page-link-custom " + (currentPage === 1 ? "disabled" : "");
                        prevBtn.innerHTML = '<i class="fa-solid fa-angle-left"></i>';
                        if (currentPage > 1) {
                            prevBtn.onclick = function() { setPage(currentPage - 1); };
                        }
                        buttonGroup.appendChild(prevBtn);
                        
                        for (let i = 1; i <= totalPages; i++) {
                            const pageBtn = document.createElement("span");
                            pageBtn.className = "page-link-custom " + (currentPage === i ? "active" : "");
                            pageBtn.innerText = i;
                            pageBtn.onclick = function() { setPage(i); };
                            buttonGroup.appendChild(pageBtn);
                        }
                        
                        const nextBtn = document.createElement("span");
                        nextBtn.className = "page-link-custom " + (currentPage === totalPages ? "disabled" : "");
                        nextBtn.innerHTML = '<i class="fa-solid fa-angle-right"></i>';
                        if (currentPage < totalPages) {
                            nextBtn.onclick = function() { setPage(currentPage + 1); };
                        }
                        buttonGroup.appendChild(nextBtn);
                    }
                    
                    setPage(1);
                });
            });
        </script>
    </body>
</html>