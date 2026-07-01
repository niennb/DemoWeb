<%-- 
    Document   : movie-manage
    Created on : 20 thg 6, 2026
    Author     : baoni
    Upgraded   : Giữ nguyên logic gốc. Đồng bộ giao diện Bảng, Thanh lọc (Payment) 
                 và Form nhập liệu (Account - Flat Dark).
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    /* KHU VỰC TIÊU ĐỀ */
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

    /* KHUNG PANEL FORM NHẬP LIỆU GỐC */
    .form-panel {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 24px;
        margin-bottom: 25px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    /* ĐỒNG BỘ CSS Ô NHẬP LIỆU TỪ ACCOUNT-MANAGE */
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
        border-color: #fb923c; /* Tone cam đồng bộ với theme hiện tại */
        outline: none;
        box-shadow: 0 0 0 3px rgba(251, 146, 60, 0.15);
    }
    /* Đổi màu placeholder cho tinh tế hơn */
    .form-input-custom::placeholder {
        color: #475569;
    }

    /* BỘ LỌC VÀ TÌM KIẾM ĐỒNG NHẤT PAYMENT */
    .toolbar-container {
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }
    .search-box {
        position: relative;
        width: 280px;
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

    /* CẤU TRÚC BẢNG QUẢN LÝ DỮ LIỆU ĐỒNG NHẤT PAYMENT */
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
        border-bottom: 1px solid #334155;
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
        background-color: #24334d !important;
    }

    /* NÚT HÀNH ĐỘNG CỦA BẢNG TỪ FILE GỐC */
    .action-group {
        display: flex;
        gap: 8px;
        justify-content: center;
        flex-wrap: wrap;
    }
    .btn-action {
        padding: 6px 12px;
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

    /* LINK POSTER MODAL TỪ FILE GỐC */
    .poster-link {
        color: #38bdf8;
        text-decoration: none;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        width: fit-content;
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
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
    }
    .modal-close {
        position: absolute;
        top: 10px;
        right: 16px;
        color: #94a3b8;
        font-size: 24px;
        cursor: pointer;
        transition: color 0.2s;
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
        background-color: #fb923c;
        border-color: #fb923c;
        color: #0f172a;
    }
    .page-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
</style>

<div class="container-fluid px-4">
    <div class="page-header">
        <div class="page-title">
            <h2>Quản Lý Danh Sách Phim</h2>
            <p>Thêm mới, sửa đổi thông tin lịch chiếu và trạng thái các phim trong hệ thống</p>
        </div>
    </div>

    <div class="form-panel">
        <h5 class="text-orange-400 mb-4 font-semibold" id="formTitle">
            <i class="fa-solid fa-film me-2"></i> Thêm Phim Mới Vào Rạp
        </h5>
        <form id="movieForm" action="${pageContext.request.contextPath}/admin/movie/add" method="POST">
            <input type="hidden" id="movieId" name="id">

            <div class="row g-4">
                <div class="col-md-4">
                    <label class="form-label-custom">Tên bộ phim</label>
                    <input type="text" id="name" name="name" class="form-input-custom" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label-custom">Thể loại</label>
                    <input type="text" id="genre" name="genre" class="form-input-custom" required>
                </div>
                <div class="col-md-2">
                    <label class="form-label-custom">Thời lượng (Phút)</label>
                    <input type="number" id="duration" name="duration" class="form-input-custom" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label-custom">Giá vé gốc (đ)</label>
                    <input type="number" id="price" name="price" class="form-input-custom" required>
                </div>

                <div class="col-md-3">
                    <label class="form-label-custom">Ngày khởi chiếu</label>
                    <input type="date" id="releaseDate" name="releaseDate" class="form-input-custom">
                </div>
                <div class="col-md-3">
                    <label class="form-label-custom">Trạng thái chiếu</label>
                    <select id="status" name="status" class="form-select-custom">
                        <option value="Đang chiếu">Đang chiếu</option>
                        <option value="Sắp chiếu">Sắp chiếu</option>
                        <option value="Ngưng chiếu">Ngưng chiếu</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label-custom">Đường dẫn Poster Image</label>
                    <input type="text" id="poster" name="poster" class="form-input-custom" placeholder="Ví dụ: resources/image/p1.jpg">
                </div>
                <div class="col-md-3">
                    <label class="form-label-custom">Đường dẫn Trailer URL</label>
                    <input type="text" id="trailerUrl" name="trailerUrl" class="form-input-custom" placeholder="Link Youtube Trailer...">
                </div>
                <div class="col-12">
                    <label class="form-label-custom">Tóm tắt nội dung phim</label>
                    <textarea id="description" name="description" class="form-input-custom" rows="2" placeholder="Nhập tóm tắt mô tả phim..."></textarea>
                </div>

                <div class="col-12 d-flex gap-2 justify-content-end mt-4">
                    <button type="button" id="btnReset" class="btn btn-secondary px-4 d-none" onclick="resetForm()">Hủy chỉnh sửa</button>
                    <button type="submit" class="btn btn-warning px-4 font-semibold text-slate-900" style="background-color: #fb923c; border-color: #fb923c;">Lưu dữ liệu</button>
                </div>
            </div>
        </form>
    </div>

    <div class="toolbar-container">
        <form action="${pageContext.request.contextPath}/admin/movie-manage" method="GET" class="d-flex gap-3 align-items-center flex-wrap w-100 m-0">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="search" value="${param.search}" placeholder="Tìm tên phim, thể loại...">
            </div>

            <select name="statusFilter" class="filter-select">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="Đang chiếu" ${param.statusFilter == 'Đang chiếu' ? 'selected' : ''}>Đang chiếu</option>
                <option value="Sắp chiếu" ${param.statusFilter == 'Sắp chiếu' ? 'selected' : ''}>Sắp chiếu</option>
                <option value="Ngưng chiếu" ${param.statusFilter == 'Ngưng chiếu' ? 'selected' : ''}>Ngưng chiếu</option>
            </select>

            <select name="sortBy" class="filter-select">
                <option value="id_desc" ${param.sortBy == 'id_desc' ? 'selected' : ''}>Mới thêm lên đầu</option>
                <option value="name_asc" ${param.sortBy == 'name_asc' ? 'selected' : ''}>Tên phim (A -> Z)</option>
                <option value="price_asc" ${param.sortBy == 'price_asc' ? 'selected' : ''}>Giá vé tăng dần</option>
                <option value="price_desc" ${param.sortBy == 'price_desc' ? 'selected' : ''}>Giá vé giảm dần</option>
            </select>

            <button type="submit" class="btn-filter-submit">
                <i class="fa-solid fa-filter me-1"></i> Lọc
            </button>
            <a href="${pageContext.request.contextPath}/admin/movie-manage" class="btn-filter-reset">
                <i class="fa-solid fa-rotate-left"></i> Xóa lọc
            </a>
        </form>
    </div>

    <div class="table-container">
        <table class="table-custom" id="adminMovieTable">
            <thead>
                <tr>
                    <th style="width: 80px;">Mã ID</th>
                    <th>Tên Phim</th>
                    <th>Thể Loại</th>
                    <th>Thời Lượng</th>
                    <th>Giá Vé</th>
                    <th>Khởi Chiếu</th>
                    <th>Trạng Thái</th>
                    <th style="width: 200px; text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <c:forEach items="${movies}" var="movie">
                    <tr class="data-row">
                        <td class="text-slate-500 font-medium">#${movie.id}</td>
                        <td class="font-semibold text-slate-200">
                            <div class="d-flex flex-column">
                                <span>${movie.name}</span>

                                <a href="javascript:void(0)" class="poster-link text-xs mt-1" 
                                   data-poster="${movie.poster}" 
                                   data-context="${pageContext.request.contextPath}"
                                   data-moviename="<c:out value='${movie.name}'/>" 
                                   onclick="openPosterModal(this)">
                                    <i class="fa-regular fa-image"></i> Xem Poster
                                </a>
                            </div>
                        </td>
                        <td><span class="text-slate-300">${movie.genre}</span></td>
                        <td><span class="text-slate-300">${movie.duration} phút</span></td>
                        <td class="text-orange-400 font-medium">
                            <c:choose>
                                <c:when test="${not empty movie.price}">
                                    <fmt:formatNumber value="${movie.price}" type="number" maxFractionDigits="0"/> đ
                                </c:when>
                                <c:otherwise>
                                    <span class="text-slate-600 italic">0 đ</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty movie.releaseDate}">
                                    <span class="text-slate-300">${movie.releaseDate}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-slate-500 italic">Chưa xác định</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${movie.status == 'Đang chiếu'}">
                                    <span class="badge bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 px-2.5 py-1 rounded-full text-xs font-medium">
                                        ● Đang Chiếu
                                    </span>
                                </c:when>
                                <c:when test="${movie.status == 'Sắp chiếu'}">
                                    <span class="badge bg-amber-500/10 text-amber-400 border border-amber-500/20 px-2.5 py-1 rounded-full text-xs font-medium">
                                        ● Sắp Chiếu
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-slate-500/10 text-slate-400 border border-slate-500/20 px-2.5 py-1 rounded-full text-xs font-medium">
                                        ● Ngưng Chiếu
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-group justify-content-center">
                                <button type="button" 
                                        class="btn-action btn-edit"
                                        data-id="${movie.id}"
                                        data-name="<c:out value='${movie.name}'/>"
                                        data-genre="${movie.genre}"
                                        data-duration="${movie.duration}"
                                        data-price="${movie.price}"
                                        data-release="${movie.releaseDate}"
                                        data-status="${movie.status}"
                                        data-poster="${movie.poster}"
                                        data-trailer="${movie.trailerUrl}"
                                        data-description="<c:out value='${movie.description}'/>"
                                        onclick="editMovie(this)">
                                    <i class="fa-solid fa-pen-to-square"></i> Sửa
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/movie/delete?id=${movie.id}" 
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa bộ phim này?')">
                                    <i class="fa-solid fa-trash"></i> Xóa
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty movies}">
                    <tr class="empty-row">
                        <td colspan="8" style="text-align: center; padding: 40px; color: #64748b;">
                            <i class="fa-solid fa-folder-open mb-2" style="font-size: 26px; display: block;"></i>
                            Không tìm thấy bộ phim nào phù hợp dữ liệu yêu cầu.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="pagination-wrapper w-100" id="paginationWrapper" style="display: none;">
            <div class="text-slate-400" style="font-size: 12px;" id="paginationInfo">
            </div>
            <ul class="pagination-list" id="paginationControls">
            </ul>
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
    document.getElementById('releaseDate').min = todayStr;

    function openPosterModal(element) {
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

    function editMovie(btnElement) {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen-to-square"></i> Chỉnh Sửa Thông Tin Phim';
        document.getElementById('movieForm').action = "${pageContext.request.contextPath}/admin/movie/update";

        document.getElementById('movieId').value = btnElement.getAttribute('data-id');
        document.getElementById('name').value = btnElement.getAttribute('data-name');
        document.getElementById('genre').value = btnElement.getAttribute('data-genre');
        document.getElementById('duration').value = btnElement.getAttribute('data-duration');
        document.getElementById('price').value = btnElement.getAttribute('data-price');

        const originalDate = btnElement.getAttribute('data-release');
        const releaseDateInput = document.getElementById('releaseDate');
        releaseDateInput.value = originalDate;

        if (originalDate && originalDate < todayStr) {
            releaseDateInput.min = originalDate;
        } else {
            releaseDateInput.min = todayStr;
        }

        document.getElementById('status').value = btnElement.getAttribute('data-status');
        document.getElementById('poster').value = btnElement.getAttribute('data-poster');

        let trailerField = document.getElementById('trailerUrl');
        if (trailerField) {
            trailerField.value = btnElement.getAttribute('data-trailer');
        }

        document.getElementById('description').value = btnElement.getAttribute('data-description');
        document.getElementById('btnReset').classList.remove('d-none');
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function resetForm() {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-film"></i> Thêm Phim Mới Vào Rạp';
        document.getElementById('movieForm').action = "${pageContext.request.contextPath}/admin/movie/add";
        document.getElementById('movieForm').reset();
        document.getElementById('movieId').value = "";
        document.getElementById('releaseDate').min = todayStr;
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
            paginationInfo.innerHTML = `Hiển thị <strong>\${start + 1} - \${currentEnd}</strong> trên tổng <strong>\${totalRows}</strong> bộ phim`;

            renderPaginationButtons();
        };

        function renderPaginationButtons() {
            paginationControls.innerHTML = "";

            const prevBtn = document.createElement("li");
            prevBtn.innerHTML = `<a class="page-btn \${currentPage === 1 ? 'disabled' : ''}" onclick="showPage(\${currentPage - 1})">&laquo;</a>`;
            paginationControls.appendChild(prevBtn);

            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement("li");
                pageBtn.innerHTML = `<a class="page-btn \${i === currentPage ? 'active' : ''}" onclick="showPage(\${i})">\${i}</a>`;
                paginationControls.appendChild(pageBtn);
            }

            const nextBtn = document.createElement("li");
            nextBtn.innerHTML = `<a class="page-btn \${currentPage === totalPages ? 'disabled' : ''}" onclick="showPage(\${currentPage + 1})">&raquo;</a>`;
            paginationControls.appendChild(nextBtn);
        }

        // Kích hoạt phân trang hiển thị
        paginationWrapper.style.display = "flex";
        showPage(1);
    });
</script>