<%-- 
    Document   : showtime-manage
    Created on : 20 thg 6, 2026
    Author     : baoni
    Upgraded   : Đồng bộ giao diện phẳng tối (Flat Dark) chuẩn xác 100%. Giữ nguyên tên biến gốc.
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /* KHU VỰC TIÊU ĐỀ TIÊU CHUẨN */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
    }
    .page-title h2 {
        margin: 0;
        font-size: 24px;
        font-weight: 700;
        color: #f8fafc;
    }
    .page-title p {
        margin: 5px 0 0 0;
        color: #94a3b8;
        font-size: 14px;
    }

    /* KHU VỰC ALERT BANNER THÔNG BÁO */
    .alert-banner {
        padding: 12px 18px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 500;
    }
    .alert-success {
        background-color: rgba(34, 197, 94, 0.15);
        color: #4ade80;
        border: 1px solid rgba(34, 197, 94, 0.3);
    }
    .alert-danger {
        background-color: rgba(239, 68, 68, 0.15);
        color: #f87171;
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    /* KHUNG PANEL FORM THÊM MỚI / SỬA */
    .form-panel {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 25px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    /* ĐỒNG BỘ LỚP TRẠNG THÁI Ô NHẬP LIỆU */
    .form-label-custom {
        color: #94a3b8;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 8px;
        display: block;
    }
    .form-input-custom, .form-select-custom {
        background-color: #0f172a;
        border: 1px solid #334155;
        color: #f8fafc;
        border-radius: 8px;
        padding: 10px 14px;
        font-size: 14px;
        width: 100%;
        transition: all 0.2s ease;
        box-sizing: border-box;
    }
    .form-input-custom:focus, .form-select-custom:focus {
        border-color: #fb923c;
        outline: none;
        box-shadow: 0 0 0 3px rgba(251, 146, 60, 0.15);
    }
    .form-input-custom::placeholder {
        color: #475569;
    }

    /* BỘ LỌC VÀ TÌM KIẾM ĐỒNG BỘ */
    .toolbar-container {
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }
    .search-box {
        position: relative;
        width: 250px;
    }
    .search-box input {
        width: 100%;
        background-color: #1e293b;
        border: 1px solid #334155;
        color: #f8fafc;
        padding: 9px 12px 9px 38px;
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.2s ease;
    }
    .search-box input:focus {
        border-color: #fb923c;
        outline: none;
        box-shadow: 0 0 0 2px rgba(251, 146, 60, 0.15);
    }
    .search-box i {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: #64748b;
    }
    .filter-select {
        background-color: #1e293b;
        border: 1px solid #334155;
        color: #f8fafc;
        padding: 9px 12px;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
        outline: none;
        transition: border-color 0.2s;
        max-width: 160px;
    }
    .filter-select:focus {
        border-color: #fb923c;
        box-shadow: 0 0 0 2px rgba(251, 146, 60, 0.15);
    }

    .btn-filter-submit {
        background-color: #fb923c;
        color: #0f172a;
        font-weight: 600;
        font-size: 14px;
        border: none;
        padding: 9px 18px;
        border-radius: 8px;
        transition: all 0.2s ease;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
    }
    .btn-filter-submit:hover {
        background-color: #f97316;
    }

    .btn-filter-reset {
        background-color: #334155;
        color: #94a3b8;
        border: 1px solid #475569;
        padding: 9px 14px;
        border-radius: 8px;
        font-size: 14px;
        text-decoration: none;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
    }
    .btn-filter-reset:hover {
        background-color: #475569;
        color: #f8fafc;
    }

    /* CẤU TRÚC BẢNG QUẢN LÝ SUẤT CHIẾU */
    .table-container {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    .table-custom {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
    }
    .table-custom th {
        background-color: #0f172a;
        color: #94a3b8;
        font-weight: 600;
        font-size: 13px;
        padding: 14px 16px;
        text-align: left;
        border-bottom: 1px solid #334155;
        border-right: 1px solid #233044;
        letter-spacing: 0.3px;
        text-transform: uppercase;
    }
    .table-custom th:last-child {
        border-right: none;
    }
    .table-custom td {
        padding: 14px 16px;
        color: #e2e8f0;
        font-size: 14px;
        border-bottom: 1px solid rgba(51, 65, 85, 0.5);
        border-right: 1px solid #2d3d57;
        vertical-align: middle;
        word-wrap: break-word;
    }
    .table-custom td:last-child {
        border-right: none;
    }
    .table-custom tr:last-child td {
        border-bottom: none;
    }
    .table-custom tbody tr:hover td {
        background-color: rgba(30, 41, 59, 0.6) !important;
    }

    /* NHÓM NÚT THAO TÁC HÀNH ĐỘNG */
    .action-group {
        display: flex;
        gap: 8px;
        justify-content: center;
        flex-wrap: wrap;
    }
    .btn-action {
        padding: 6px 14px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        border: none;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-edit {
        background-color: rgba(251, 146, 60, 0.1);
        color: #fb923c;
    }
    .btn-edit:hover {
        background-color: #fb923c;
        color: #0f172a;
    }
    .btn-delete {
        background-color: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }
    .btn-delete:hover {
        background-color: #ef4444;
        color: #ffffff;
    }

    /* MODAL POSTER (GIỮ NGUYÊN GỐC) */
    .poster-link {
        color: #38bdf8;
        text-decoration: none;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        width: fit-content;
        cursor: pointer;
    }
    .poster-link:hover {
        text-decoration: underline;
        color: #7dd3fc;
    }
    .image-modal {
        display: none;
        position: fixed;
        z-index: 9999;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(15, 23, 42, 0.85);
        align-items: center;
        justify-content: center;
    }
    .modal-content-box {
        background-color: #1e293b;
        padding: 24px;
        border-radius: 12px;
        border: 1px solid #334155;
        position: relative;
        max-width: 380px;
        width: 90%;
        text-align: center;
    }
    .modal-close {
        position: absolute;
        top: 10px;
        right: 16px;
        color: #94a3b8;
        font-size: 24px;
        cursor: pointer;
    }
    .modal-close:hover {
        color: #f8fafc;
    }
    .modal-img-preview {
        max-width: 100%;
        max-height: 480px;
        object-fit: contain;
        border-radius: 8px;
        margin-top: 12px;
        border: 1px solid #475569;
    }

    /* PHÂN TRANG (PAGINATION) */
    .pagination-wrapper {
        padding: 12px 16px;
        background-color: #0f172a;
        border-top: 1px solid #334155;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom-left-radius: 12px;
        border-bottom-right-radius: 12px;
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
        background-color: #fb923c;
        border-color: #fb923c;
        color: #0f172a;
    }
    .page-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    /* KHÓA NÚT THAO TÁC KHI SUẤT CHIẾU ĐÃ QUA THỜI GIAN THỰC */
    .btn-action.disabled {
        opacity: 0.4 !important;
        cursor: not-allowed !important;
        pointer-events: none !important;
        background-color: rgba(71, 85, 105, 0.2) !important;
        color: #64748b !important;
        border: none !important;
    }
</style>

<div class="container-fluid px-4">
    <div class="page-header">
        <div class="page-title">
            <h2>Quản Lý Cơ Sở Suất Chiếu</h2>
            <p>Sắp xếp, thiết lập lịch chiếu phim cho các phòng và kiểm soát thời gian</p>
        </div>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert-banner alert-success">
            <i class="fa-solid fa-circle-check fs-5"></i> ${successMsg}
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert-banner alert-danger">
            <i class="fa-solid fa-triangle-exclamation fs-5"></i> ${errorMsg}
        </div>
    </c:if>

    <div class="form-panel">
        <h5 class="text-orange-400 mb-4 font-semibold" id="formTitle">
            <i class="fa-solid fa-calendar-plus me-2"></i> Thiết Lập Suất Chiếu Mới
        </h5>
        <form id="showtimeForm" action="${pageContext.request.contextPath}/admin/showtime/save" method="POST" onsubmit="return validateShowtimeForm()">
            <input type="hidden" id="showtimeId" name="id">

            <div class="row g-4">
                <div class="col-md-4">
                    <label class="form-label-custom">Chọn bộ phim</label>
                    <select id="movieId" name="movie.id" class="form-select-custom" required>
                        <option value="" disabled selected>-- Vui lòng chọn phim --</option>
                        <c:forEach items="${movies}" var="movie">
                            <option value="${movie.id}">[ID: ${movie.id}] - ${movie.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label-custom">Phòng chiếu</label>
                    <select id="roomId" name="room.id" class="form-select-custom" required>
                        <option value="" disabled selected>-- Chọn phòng --</option>
                        <c:forEach items="${rooms}" var="room">
                            <%-- ĐẾM SỐ LƯỢNG GHẾ TRONG PHÒNG: NẾU LỚN HƠN 0 THÌ MỚI HIỂN THỊ --%>
                            <c:if test="${fn:length(room.seats) > 0}">
                                <option value="${room.id}">${room.roomName}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label-custom">Ngày chiếu</label>
                    <input type="date" id="showDate" name="showDate" id="showDateInput" class="form-input-custom" required>
                </div>

                <div class="col-md-2">
                    <label class="form-label-custom">Bắt đầu</label>
                    <input type="time" id="startTime" name="startTime" id="startTimeInput" class="form-input-custom" required>
                </div>

                <div class="col-md-2">
                    <label class="form-label-custom">Dự kiến xong</label>
                    <input type="time" id="endTime" name="endTime" class="form-input-custom" readonly>
                </div>

                <div class="col-12 d-flex gap-2 justify-content-end mt-4">
                    <button type="button" id="btnReset" class="btn btn-secondary px-4 d-none" onclick="resetForm()">Hủy thao tác</button>
                    <button type="submit" id="btnSubmit" class="btn btn-warning px-4 font-semibold text-slate-900" style="background-color: #fb923c; border-color: #fb923c;">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Phát Hành Lịch
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="toolbar-container">
        <form action="${pageContext.request.contextPath}/admin/showtime-manage" method="GET" class="d-flex gap-3 align-items-center flex-wrap w-100 m-0">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="search" value="${param.search}" placeholder="Tìm tên phim...">
            </div>

            <select name="roomFilter" class="filter-select">
                <option value="">-- Tất cả phòng --</option>
                <c:forEach items="${rooms}" var="r">
                    <option value="${r.id}" ${param.roomFilter == r.id ? 'selected' : ''}>${r.roomName}</option>
                </c:forEach>
            </select>

            <select name="dateFilter" class="filter-select">
                <option value="">-- Mọi thời điểm --</option>
                <option value="today" ${param.dateFilter == 'today' ? 'selected' : ''}>Chiếu hôm nay</option>
                <option value="future" ${param.dateFilter == 'future' ? 'selected' : ''}>Sắp chiếu tới</option>
                <option value="past" ${param.dateFilter == 'past' ? 'selected' : ''}>Đã chiếu xong</option>
            </select>

            <select name="sortBy" class="filter-select" style="max-width: 180px;">
                <option value="date_desc" ${param.sortBy == 'date_desc' ? 'selected' : ''}>Mới nhất -> Cũ nhất</option>
                <option value="date_asc" ${param.sortBy == 'date_asc' ? 'selected' : ''}>Cũ nhất -> Mới nhất</option>
            </select>

            <button type="submit" class="btn-filter-submit">
                <i class="fa-solid fa-filter me-1"></i> Lọc Lịch
            </button>
            <a href="${pageContext.request.contextPath}/admin/showtime-manage" class="btn-filter-reset">
                <i class="fa-solid fa-rotate-left"></i> Xóa
            </a>
        </form>
    </div>

    <div class="table-container">
        <table class="table-custom" id="adminShowtimeTable">
            <thead>
                <tr>
                    <th style="width: 80px;">Mã ST</th>
                    <th>Thông tin Phim</th>
                    <th>Phòng Chiếu</th>
                    <th>Ngày Chiếu</th>
                    <th>Thời Gian Chiếu</th>
                    <th style="width: 180px; text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <c:forEach items="${showtimes}" var="st">
                    <tr class="data-row">
                        <td class="text-slate-500 font-medium">#${st.id}</td>
                        <td class="font-semibold text-slate-200">
                            <div class="d-flex flex-column">
                                <span>${st.movie.name}</span>
                                <a onclick="showPosterSafe(this)" class="poster-link text-xs mt-1" 
                                   data-poster="${st.movie.poster}" 
                                   data-context="${pageContext.request.contextPath}" 
                                   data-moviename="<c:out value='${st.movie.name}'/>">
                                    <i class="fa-regular fa-image"></i> Xem Poster
                                </a>
                            </div>
                        </td>
                        <td><span class="text-orange-300 font-medium">${st.room.roomName}</span></td>
                        <td><span class="text-slate-300 font-medium">${st.showDate}</span></td>
                        <td>
                            <div class="d-flex flex-column gap-1">
                                <span class="text-emerald-400 font-medium text-xs">
                                    <i class="fa-regular fa-clock me-1"></i> Bắt đầu: ${st.startTime}
                                </span>
                                <span class="text-rose-400 font-medium text-xs">
                                    <i class="fa-regular fa-clock me-1"></i> Kết thúc: ${st.endTime}
                                </span>
                            </div>
                        </td>
                        <td>

                            <div class="action-group justify-content-center">
                                <c:choose>
                                    <c:when test="${st.past}">
                                        <button type="button" class="btn-action btn-edit disabled" title="Không thể sửa suất chiếu đã qua">
                                            <i class="fas fa-edit"></i> Sửa
                                        </button>
                                        <button type="button" class="btn-action btn-delete disabled" title="Không thể xóa suất chiếu đã qua">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn-action btn-edit" 
                                                data-id="${st.id}" 
                                                data-movieid="${st.movie.id}" 
                                                data-roomid="${st.room.id}" 
                                                data-showdate="${st.showDate}" 
                                                data-starttime="${st.startTime}" 
                                                data-endtime="${st.endTime}" 
                                                onclick="editShowtime(this)">
                                            <i class="fa-solid fa-pen-to-square"></i> Sửa
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/showtime/delete?id=${st.id}" 
                                           class="btn-action btn-delete" 
                                           onclick="return confirm('Bạn có chắc chắn muốn hủy bỏ lịch chiếu này không?')">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>

                </c:forEach>

                <c:if test="${empty showtimes}">
                    <tr class="empty-row">
                        <td colspan="6" style="text-align: center; padding: 40px; color: #64748b;">
                            <i class="fa-solid fa-folder-open mb-2" style="font-size: 26px; display: block;"></i>
                            Không tìm thấy suất chiếu nào phù hợp dữ liệu yêu cầu.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="pagination-wrapper w-100" id="paginationWrapper" style="display: none;">
            <div class="text-slate-400" style="font-size: 12px;" id="paginationInfo"></div>
            <ul class="pagination-list" id="paginationControls"></ul>
        </div>
    </div>
</div>

<div id="posterModal" class="image-modal" onclick="closePosterModal()">
    <div class="modal-content-box" onclick="event.stopPropagation()">
        <span class="modal-close" onclick="closePosterModal()">&times;</span>
        <h6 id="modalTitle" class="text-slate-200 font-semibold mb-1">Poster Phim</h6>
        <img id="modalImage" src="" class="modal-img-preview" alt="Poster Preview">
    </div>
</div>

<script>
    // JS GỐC CỦA BẠN CHO FORM VÀ MODAL POSTER
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];
    const showDateInput = document.getElementById('showDate');
    if (showDateInput) {
        showDateInput.min = todayStr;
    }

    function showPosterSafe(element) {
        let imageUrl = element.getAttribute('data-poster');
        const movieName = element.getAttribute('data-moviename');
        const contextPath = element.getAttribute('data-context') || '';

        const modal = document.getElementById('posterModal');
        const modalImg = document.getElementById('modalImage');
        const modalTitle = document.getElementById('modalTitle');

        if (imageUrl && imageUrl.trim() !== '') {
            if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
                modalImg.src = imageUrl;
            } else {
                if (imageUrl.includes('WEB-INF/')) {
                    imageUrl = imageUrl.replace('WEB-INF/', '');
                }
                if (!imageUrl.startsWith('/')) {
                    imageUrl = '/' + imageUrl;
                }
                modalImg.src = contextPath + imageUrl;
            }
        } else {
            modalImg.src = 'https://placehold.co/300x450?text=No+Poster+Available';
        }

        modalTitle.innerText = movieName;
        modal.style.display = 'flex';
    }

    function closePosterModal() {
        document.getElementById('posterModal').style.display = 'none';
    }

    // HÀM ĐƯA DỮ LIỆU LÊN FORM ĐỂ CHỈNH SỬA
    function editShowtime(btn) {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen-to-square"></i> Chỉnh Sửa Suất Chiếu';
        document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-cloud-arrow-up"></i> Phát Hành Lịch';
        document.getElementById('showtimeForm').action = "${pageContext.request.contextPath}/admin/showtime/save";

        document.getElementById('showtimeId').value = btn.getAttribute('data-id');
        document.getElementById('movieId').value = btn.getAttribute('data-movieid');
        document.getElementById('roomId').value = btn.getAttribute('data-roomid');

        const originalDate = btn.getAttribute('data-showdate');
        const sDateInput = document.getElementById('showDate');
        sDateInput.value = originalDate;

        if (originalDate && originalDate < todayStr) {
            sDateInput.min = originalDate;
        } else {
            sDateInput.min = todayStr;
        }

        document.getElementById('startTime').value = btn.getAttribute('data-starttime');
        document.getElementById('endTime').value = btn.getAttribute('data-endtime');
        document.getElementById('btnReset').classList.remove('d-none');
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    // HÀM RESET FORM VỀ TRẠNG THÁI THÊM MỚI BAN ĐẦU
    function resetForm() {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-calendar-plus"></i> Thiết Lập Suất Chiếu Mới';
        document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-cloud-arrow-up"></i> Phát Hành Lịch';
        document.getElementById('showtimeForm').action = "${pageContext.request.contextPath}/admin/showtime/save";
        document.getElementById('showtimeForm').reset();
        document.getElementById('showtimeId').value = "";
        document.querySelectorAll('#showtimeForm select').forEach(s => s.value = "");
        document.getElementById('showDate').min = todayStr;
        document.getElementById('btnReset').classList.add('d-none');
    }

    // --------------------------------------------------------
    // TÍCH HỢP HỆ THỐNG PHÂN TRANG (10 DÒNG / TRANG) MỚI TỪ PAYMENT
    // --------------------------------------------------------

    document.addEventListener("DOMContentLoaded", function () {
        const rowsPerPage = 10;
        const tableBody = document.getElementById("tableBody");
        const rows = Array.from(tableBody.querySelectorAll("tr.data-row"));

        const totalRows = rows.length;
        if (totalRows === 0)
            return;

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
            // Dùng dấu cộng (+) nối chuỗi để JSP không hiểu nhầm là EL
            paginationInfo.innerHTML = 'Hiển thị <strong>' + (start + 1) + ' - ' + currentEnd + '</strong> trên tổng <strong>' + totalRows + '</strong> suất chiếu';

            renderPaginationButtons();
        };

        function renderPaginationButtons() {
            paginationControls.innerHTML = "";

            // Nút Lùi
            const prevBtn = document.createElement("li");
            let prevDisabled = (currentPage === 1) ? 'disabled' : '';
            prevBtn.innerHTML = '<a class="page-btn ' + prevDisabled + '" onclick="showPage(' + (currentPage - 1) + ')">&laquo;</a>';
            paginationControls.appendChild(prevBtn);

            // Các nút số trang
            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement("li");
                let activeClass = (i === currentPage) ? 'active' : '';
                pageBtn.innerHTML = '<a class="page-btn ' + activeClass + '" onclick="showPage(' + i + ')">' + i + '</a>';
                paginationControls.appendChild(pageBtn);
            }

            // Nút Tiến
            const nextBtn = document.createElement("li");
            let nextDisabled = (currentPage === totalPages) ? 'disabled' : '';
            nextBtn.innerHTML = '<a class="page-btn ' + nextDisabled + '" onclick="showPage(' + (currentPage + 1) + ')">&raquo;</a>';
            paginationControls.appendChild(nextBtn);
        }

        // Kích hoạt phân trang hiển thị trang đầu tiên
        paginationWrapper.style.display = "flex";
        showPage(1);
    });


// HÀM CHẶN SUBMIT GIỜ QUÁ KHỨ NẾU CHỌN NGÀY CHIẾU LÀ HÔM NAY
    function validateShowtimeForm() {
        // Lấy chính xác theo 2 ID có sẵn trong file của bạn là 'showDate' và 'startTime'
        const showDateInput = document.getElementById("showDate");
        const startTimeInput = document.getElementById("startTime");

        if (!showDateInput || !startTimeInput)
            return true;

        const selectedDate = showDateInput.value;
        const selectedTime = startTimeInput.value;

        if (!selectedDate || !selectedTime)
            return true;

        const now = new Date();
        // Lấy chuỗi ngày hôm nay theo định dạng YYYY-MM-DD
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const localTodayStr = year + '-' + month + '-' + day;

        // Chỉ kiểm tra giờ nếu ngày chiếu được chọn chính là ngày hôm nay
        if (selectedDate === localTodayStr) {
            const currentHours = now.getHours();
            const currentMinutes = now.getMinutes();

            const timeParts = selectedTime.split(':');
            const inputHours = parseInt(timeParts[0], 10);
            const inputMinutes = parseInt(timeParts[1], 10);

            // So sánh giờ và phút nhập vào với giờ phút hiện tại của máy tính
            if (inputHours < currentHours || (inputHours === currentHours && inputMinutes < currentMinutes)) {
                alert("Bạn đã chọn khung giờ trong quá khứ (" + selectedTime + "). Vui lòng chọn giờ chiếu lớn hơn hoặc bằng thời gian hiện tại (" + String(currentHours).padStart(2, '0') + ":" + String(currentMinutes).padStart(2, '0') + ")!");
                startTimeInput.focus();
                return false; // Trả về false để chặn đứng hành động submit form lên Server
            }
        }
        return true; // Cho phép submit form bình thường nếu hợp lệ
    }
</script>