<%-- 
    Document   : ticket-manage
    Created on : 20 thg 6, 2026
    Author     : baoni
    Upgraded   : Đồng bộ bộ lọc tìm kiếm nâng cao chuẩn Premium Admin (Giống payment-manage) + Tích hợp Phân trang tự động (10 dòng/trang) + Thêm cột Mã phòng & Tên phòng (Giữ nguyên UI dự phòng và Popup ghế)
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<style>
    /* ĐỒNG BỘ NỀN VÀ PHÔNG CHỮ CHUẨN ADMIN */
    .page-title h2 {
        font-size: 24px;
        font-weight: 700;
        color: #f8fafc;
        margin: 0;
    }
    .page-title p {
        font-size: 14px;
        color: #94a3b8;
        margin-top: 4px;
        margin-bottom: 0;
    }

    /* ĐỒNG BỘ KHU VỰC BỘ LỌC & TÌM KIẾM THEO CHUẨN PREMIUM DARK */
    .filter-card-custom {
        background-color: #1e293b !important;
        border: 1px solid #334155 !important;
    }
    .form-input-custom,
    .form-select-custom {
        background-color: #0f172a !important;
        border: 1px solid #334155 !important;
        color: #cbd5e1 !important;
        font-size: 14px;
        padding: 10px 14px !important;
        border-radius: 8px !important;
        width: 100%;
        transition: all 0.2s ease-in-out;
    }
    .form-input-custom:focus,
    .form-select-custom:focus {
        border-color: #38bdf8 !important;
        box-shadow: 0 0 0 2px rgba(56, 189, 248, 0.15) !important;
        color: #f8fafc !important;
        outline: none;
    }
    .search-wrapper-custom {
        position: relative;
        width: 100%;
    }
    .search-icon-custom {
        color: #64748b;
        position: absolute;
        top: 50%;
        left: 14px;
        transform: translateY(-50%);
        pointer-events: none;
        font-size: 14px;
    }
    .form-input-custom.ps-icon {
        padding-left: 40px !important;
    }
    .btn-filter-submit {
        background-color: #38bdf8 !important;
        color: #0f172a !important;
        font-weight: 600;
        font-size: 14px;
        border: none !important;
        padding: 10px 18px !important;
        border-radius: 8px !important;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        cursor: pointer;
    }
    .btn-filter-submit:hover {
        background-color: #0ea5e9 !important;
        transform: translateY(-1px);
    }
    .btn-filter-reset {
        background-color: #334155 !important;
        color: #94a3b8 !important;
        border: 1px solid #475569 !important;
        padding: 10px 14px !important;
        border-radius: 8px !important;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
    }
    .btn-filter-reset:hover {
        background-color: #475569 !important;
        color: #f8fafc !important;
        transform: translateY(-1px);
    }

    /* ĐỊNH DẠNG BẢNG KHÓA FIXED CHỐNG TRÀN CHỮ VÀ DÒNG */
    .table-custom {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        background-color: #1e293b !important;
    }
    .table-custom th {
        background-color: #0f172a !important;
        color: #94a3b8 !important;
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        padding: 14px 12px !important;
        border-bottom: 1px solid #334155 !important;
        border-right: 1px solid #334155 !important;
    }
    .table-custom td {
        padding: 14px 12px !important;
        color: #cbd5e1 !important;
        background-color: transparent !important;
        vertical-align: middle;
        border-bottom: 1px solid rgba(51, 65, 85, 0.4) !important;
        border-right: 1px solid rgba(51, 65, 85, 0.3) !important;
        font-size: 14px;
    }
    .table-custom th:last-child,
    .table-custom td:last-child {
        border-right: none !important;
    }
    .table-custom tbody tr:hover td {
        background-color: rgba(51, 65, 85, 0.4) !important;
    }

    /* ĐỊNH VỊ ĐỘ RỘNG CHO TỪNG CỘT (Đã thêm 2 cột mới và tối ưu lại width) */
    .col-id         {
        width: 65px;
    }
    .col-invoice    {
        width: 95px;
    }
    .col-customer   {
        width: 140px;
    }
    .col-movie      {
        width: 160px;
    }
    .col-room-id    {
        width: 85px;
        text-align: center;
    } /* Cột mới */
    .col-room-name  {
        width: 120px;
    }                    /* Cột mới */
    .col-showtime   {
        width: 145px;
    }
    .col-seats      {
        width: 85px;
        text-align: center;
    }
    .col-time       {
        width: 130px;
    }
    .col-price      {
        width: 110px;
    }
    .col-status     {
        width: 135px;
    }
    .col-actions    {
        width: 100px;
        text-align: center;
    }

    /* CẮT BA CHẤM CHO CHỮ DÀI (TÊN PHIM, TÊN KHÁCH, EMAIL) */
    .text-truncate-custom {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: block;
        width: 100%;
    }

    /* BADGE TRẠNG THÁI TRÒN */
    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 11px;
        font-weight: 600;
    }
    .status-paid {
        background-color: rgba(34, 197, 94, 0.1);
        color: #4ade80;
        border: 1px solid rgba(34, 197, 94, 0.2);
    }
    .status-pending {
        background-color: rgba(234, 179, 8, 0.1);
        color: #facc15;
        border: 1px solid rgba(234, 179, 8, 0.2);
    }
    .status-canceled {
        background-color: rgba(239, 68, 68, 0.1);
        color: #f87171;
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    /* LINK GHẾ CHỌN */
    .seat-badge-link {
        color: #38bdf8;
        text-decoration: none;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 4px 6px;
        border-radius: 6px;
        transition: background-color 0.2s;
    }
    .seat-badge-link:hover {
        background-color: rgba(56, 189, 248, 0.1);
        color: #7dd3fc;
    }

    /* MODAL POP-UP GHẾ NỀN TỐI CAO CẤP */
    .modal-seat-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(15, 23, 42, 0.8);
        backdrop-filter: blur(4px);
        z-index: 2000;
        align-items: center;
        justify-content: center;
    }
    .modal-seat-box {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        width: 100%;
        max-width: 420px;
        padding: 24px;
        position: relative;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
    }
    .modal-seat-close {
        position: absolute;
        top: 14px;
        right: 18px;
        font-size: 22px;
        color: #94a3b8;
        cursor: pointer;
    }
    .modal-seat-close:hover {
        color: #f8fafc;
    }

    /* ===== PHÂN TRANG (PAGINATION) ===== */
    .pagination-wrapper {
        padding: 12px 16px;
        background-color: #0f172a;
        border-top: 1px solid #334155;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .pagination-list {
        display: flex;
        list-style: none;
        padding: 0;
        margin: 0;
        gap: 6px;
    }
    .page-btn {
        background-color: #1e293b;
        border: 1px solid #334155;
        color: #94a3b8;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        text-decoration: none;
        cursor: pointer;
        transition: all 0.2s;
    }
    .page-btn:hover:not(.disabled) {
        background-color: #334155;
        color: #f8fafc;
    }
    .page-btn.active {
        background-color: #38bdf8;
        border-color: #38bdf8;
        color: #0f172a;
    }
    .page-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
</style>

<div class="container-fluid px-4 py-2">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="page-title">
            <h2>Quản Lý Vé Xem Phim</h2>
            <p>Tra cứu lịch sử đặt vé, doanh thu hóa đơn và thực hiện quyền hủy vé hệ thống.</p>
        </div>
    </div>

    <div class="card filter-card-custom mb-4 rounded-3">
        <div class="card-body p-3">
            <form action="${pageContext.request.contextPath}/admin/ticket-manage" method="GET" class="row g-3 align-items-center">
                <div class="col-12 col-md-4 col-lg-4">
                    <div class="search-wrapper-custom">
                        <span class="search-icon-custom">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </span>
                        <input type="text" name="search" value="${param.search}" 
                               class="form-input-custom ps-icon" 
                               placeholder="Tìm tên khách, mã vé...">
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-md-3 col-lg-3">
                    <select name="statusFilter" class="form-select-custom">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="PAID" ${param.statusFilter == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                        <option value="PENDING" ${param.statusFilter == 'PENDING' ? 'selected' : ''}>Chờ thanh toán</option>
                        <option value="Đã hủy" ${param.statusFilter == 'Đã hủy' ? 'selected' : ''}>Đã hủy vé</option>
                    </select>
                </div>

                <div class="col-12 col-sm-6 col-md-3 col-lg-3">
                    <select name="sortBy" class="form-select-custom">
                        <option value="date_desc" ${param.sortBy == 'date_desc' || empty param.sortBy ? 'selected' : ''}>Mới nhất</option>
                        <option value="date_asc" ${param.sortBy == 'date_asc' ? 'selected' : ''}>Cũ nhất</option>
                        <option value="price_desc" ${param.sortBy == 'price_desc' ? 'selected' : ''}>Giá cao nhất</option>
                    </select>
                </div>

                <div class="col-12 col-md-2 col-lg-2 d-flex gap-2">
                    <button type="submit" class="btn-filter-submit w-100 text-nowrap">
                        <i class="fa-solid fa-filter"></i> Lọc
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/ticket-manage" class="btn-filter-reset text-nowrap" title="Đặt lại bộ lọc">
                        <i class="fa-solid fa-rotate-left"></i>
                    </a>
                </div>
            </form>
        </div>
    </div>

    <div class="card bg-slate-900 border-slate-800 rounded-3 overflow-hidden shadow-sm" style="background-color: #1e293b;">
        <div class="table-responsive">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th class="col-id">Mã Vé</th>
                        <th class="col-invoice">Mã HĐ</th>
                        <th class="col-customer">Khách Hàng</th>
                        <th class="col-movie">Phim Đã Đặt</th>
                        <th class="col-room-id">Mã Phòng</th> <th class="col-room-name">Phòng Chiếu</th> <th class="col-showtime">Lịch Chiếu</th>
                        <th class="col-seats">Ghế</th>
                        <th class="col-time">Thời Gian Đặt</th>
                        <th class="col-price">Tổng Tiền</th>
                        <th class="col-status">Trạng Thái</th>
                        <th class="col-actions">Hành Động</th>
                    </tr>
                </thead>
                <tbody id="tableBody">
                    <c:choose>
                        <c:when test="${empty tickets}">
                            <tr class="empty-row">
                                <td colspan="12" class="text-center py-5 text-slate-500"> <i class="fa-solid fa-folder-open d-block fs-2 mb-2"></i>
                                    Không tìm thấy dữ liệu vé xem phim nào phù hợp.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${tickets}" var="t">
                                <tr class="data-row">
                                    <td class="text-slate-500 font-monospace">#${t.id}</td>
                                    <td class="text-warning font-semibold">
                                        <c:choose>
                                            <c:when test="${not empty t.payment}"><span style="color: #fbd38d;">INV-${t.payment.id}</span></c:when>
                                            <c:otherwise><span class="text-slate-600">N/A</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column" style="max-width: 100%;">
                                            <span class="font-semibold text-slate-200 text-truncate-custom" title="${t.user.full_name}">${not empty t.user.full_name ? t.user.full_name : t.user.username}</span>
                                            <span class="text-slate-400 font-monospace text-truncate-custom" title="${t.user.email}" style="font-size: 11px;">${t.user.email}</span>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="text-truncate-custom font-medium text-slate-200" title="${t.movie.name}">
                                            ${t.movie.name}
                                        </span>
                                    </td>

                                    <td align="center" class="font-monospace" style="color: #38bdf8;">
                                        #${t.showtime.room.id}
                                    </td>

                                    <td>
                                        <span class="font-semibold text-truncate-custom" style="color: #38bdf8;" title="${t.showtime.room.roomName}">
                                            ${t.showtime.room.roomName}
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty t.showtime}">
                                                <div class="d-flex flex-column">
                                                    <span class="text-slate-200" style="font-size: 13px;"><i class="fa-regular fa-calendar-days me-1 text-slate-500"></i>${t.showtime.showDate}</span>
                                                    <span class="text-slate-400 font-monospace" style="font-size: 11px;">
                                                        <i class="fa-solid fa-film me-1 text-slate-500"></i>${fn:substring(t.showtime.startTime, 0, 5)} - ${fn:substring(t.showtime.endTime, 0, 5)}
                                                    </span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-500 font-monospace text-xs">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td align="center">
                                        <c:set var="seatStr" value="" />
                                        <c:forEach items="${t.seats}" var="s" varStatus="loop">
                                            <c:set var="seatStr" value="${seatStr}${s.seatName}${!loop.last ? ', ' : ''}" />
                                        </c:forEach>

                                        <a href="javascript:void(0)" class="seat-badge-link" 
                                           onclick="openSeatModal('Vé #${t.id}', '${seatStr}')">
                                            <i class="fa-solid fa-couch"></i> 
                                            <span class="ms-1">${fn:length(t.seats)}</span>
                                        </a>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <span class="text-slate-200" style="font-size: 13px;"><i class="fa-solid fa-cart-shopping me-1 text-slate-500"></i>${fn:substring(t.bookingTime, 0, 10)}</span>
                                            <span class="text-slate-400 font-monospace" style="font-size: 11px;"><i class="fa-regular fa-clock me-1 text-slate-500"></i>${fn:substring(t.bookingTime, 11, 16)}</span>
                                        </div>
                                    </td>
                                    <td class="font-semibold text-emerald-400">
                                        <fmt:formatNumber value="${t.totalPrice}" type="number" maxFractionDigits="0"/> đ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${t.status == 'PAID' || t.status == 'SUCCESS'}">
                                                <span class="status-badge status-paid"><i class="fa-solid fa-circle-check"></i> Đã trả</span>
                                            </c:when>
                                            <c:when test="${t.status == 'PENDING'}">
                                                <span class="status-badge status-pending"><i class="fa-solid fa-clock"></i> Chờ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-canceled"><i class="fa-solid fa-ban"></i> Đã hủy</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td align="center">
                                        <c:choose>
                                            <c:when test="${t.status != 'Đã hủy' && t.status != 'CANCELED'}">
                                                <a href="${pageContext.request.contextPath}/admin/ticket/cancel?id=${t.id}" 
                                                   class="btn btn-sm btn-outline-danger d-inline-flex 
                                                   align-items-center gap-1 py-1 px-2"
                                                   style="font-size: 11px; border-radius: 6px;"
                                                   onclick="return confirm('Bạn có chắc chắn muốn thực hiện hủy chiếc vé này không?')">
                                                    <i class="fa-solid fa-xmark"></i> Hủy
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-slate-600 font-medium" style="font-size: 12px;"><i class="fa-solid fa-lock me-1"></i>Khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="pagination-wrapper w-100" id="paginationWrapper" style="display: none;">
            <div class="text-slate-400" style="font-size: 12px;" id="paginationInfo">
            </div>
            <ul class="pagination-list" id="paginationControls">
            </ul>
        </div>
    </div>
</div>

<div id="seatModal" class="modal-seat-overlay" onclick="closeSeatModal()">
    <div class="modal-seat-box" onclick="event.stopPropagation()">
        <span class="modal-seat-close" onclick="closeSeatModal()">&times;</span>
        <h5 id="modalTitle" class="text-warning font-semibold mb-3 fs-6">Vị Trí Ghế Chọn</h5>
        <div class="text-slate-400 mb-2 font-medium" style="font-size: 13px;">Danh sách vị trí ghế được giữ chỗ thành công:</div>
        <div id="modalBody" class="p-3 bg-slate-950 border border-slate-800 rounded text-emerald-400 font-monospace font-bold text-center fs-5 tracking-wide">
        </div>
        <div class="mt-4 text-end">
            <button class="btn btn-secondary btn-sm px-4" style="border-radius: 6px;" onclick="closeSeatModal()">Đóng lại</button>
        </div>
    </div>
</div>

<script>
    function openSeatModal(title, seatsString) {
        document.getElementById('modalTitle').innerHTML = '<i class="fa-solid fa-ticket text-warning me-2"></i>Chi Tiết Vị Trí - ' + title;
        if (!seatsString || seatsString.trim() === '' || seatsString === 'null') {
            document.getElementById('modalBody').innerText = 'Không có dữ liệu vị trí ghế.';
            document.getElementById('modalBody').className = 'p-3 bg-slate-950 border border-slate-800 rounded text-slate-500 font-medium text-center';
        } else {
            document.getElementById('modalBody').innerText = seatsString;
            document.getElementById('modalBody').className = 'p-3 bg-slate-950 border border-slate-800 rounded text-emerald-400 font-monospace font-bold text-center fs-5';
        }
        document.getElementById('seatModal').style.display = 'flex';
    }

    function closeSeatModal() {
        document.getElementById('seatModal').style.display = 'none';
    }

    window.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            closeSeatModal();
        }
    });

    // --------------------------------------------------------
    // HỆ THỐNG PHÂN TRANG (10 DÒNG / TRANG) CLIENT-SIDE TỰ ĐỘNG
    // --------------------------------------------------------
    document.addEventListener("DOMContentLoaded", function () {
        const rowsPerPage = 10;
        const tableBody = document.getElementById("tableBody");
        const rows = Array.from(tableBody.querySelectorAll("tr.data-row"));

        const totalRows = rows.length;
        if (totalRows === 0)
            return; // Bỏ qua nếu không có dữ liệu

        const totalPages = Math.ceil(totalRows / rowsPerPage);
        let currentPage = 1;

        const paginationWrapper = document.getElementById("paginationWrapper");
        const paginationControls = document.getElementById("paginationControls");
        const paginationInfo = document.getElementById("paginationInfo");

        window.showPage = function (page) {
            if (page < 1 || page > totalPages)
                return;
            currentPage = page;
            const start = (page - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            rows.forEach((row, index) => {
                if (index >= start && index < end) {
                    row.style.display = "table-row";
                } else {
                    row.style.display = "none";
                }
            });
            const currentEnd = Math.min(end, totalRows);
            paginationInfo.innerHTML = `Hiển thị <strong>\${start + 1} - \${currentEnd}</strong> trên tổng <strong>\${totalRows}</strong> vé`;

            renderPaginationButtons();
        };

        function renderPaginationButtons() {
            paginationControls.innerHTML = "";
            // Nút Previous
            const prevBtn = document.createElement("li");
            prevBtn.innerHTML = `<a class="page-btn \${currentPage === 1 ? 'disabled' : ''}" onclick="showPage(\${currentPage - 1})">&laquo;</a>`;
            paginationControls.appendChild(prevBtn);
            // Nút Số trang
            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement("li");
                pageBtn.innerHTML = `<a class="page-btn \${i === currentPage ? 'active' : ''}" onclick="showPage(\${i})">\${i}</a>`;
                paginationControls.appendChild(pageBtn);
            }

            // Nút Next
            const nextBtn = document.createElement("li");
            nextBtn.innerHTML = `<a class="page-btn \${currentPage === totalPages ? 'disabled' : ''}" onclick="showPage(\${currentPage + 1})">&raquo;</a>`;
            paginationControls.appendChild(nextBtn);
        }

        // Kích hoạt hiển thị phân trang
        paginationWrapper.style.display = "flex";
        showPage(1);
    });
</script>