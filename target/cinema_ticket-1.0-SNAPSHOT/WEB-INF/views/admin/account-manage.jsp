<%-- 
    Document   : account-manage
    Created on : 18 thg 6, 2026
    Author     : baoni
    Upgraded   : Tích hợp đầy đủ Phân trang tự động (10 dòng/trang), Bộ Lọc, Tìm Kiếm, UI Compact 100%
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* ===== PAGE HEADER ===== */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .page-title h2 {
        margin: 0;
        font-size: 22px;
        font-weight: 700;
        color: #f8fafc;
    }
    .page-title p {
        margin: 4px 0 0;
        color: #94a3b8;
        font-size: 13px;
    }

    /* ===== ALERT BANNER ===== */
    .alert-banner {
        padding: 10px 16px;
        border-radius: 6px;
        margin-bottom: 16px;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 500;
    }
    .alert-success {
        background: rgba(34, 197, 94, 0.12);
        color: #4ade80;
        border: 1px solid rgba(34, 197, 94, 0.2);
    }
    .alert-danger {
        background: rgba(239, 68, 68, 0.12);
        color: #f87171;
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    /* ===== CARD VÀ FORM CHUẨN COMPACT ===== */
    .card-custom {
        background-color: #1e293b !important;
        border: 1px solid #334155 !important;
        border-radius: 8px !important;
    }
    .card-custom .card-header-custom {
        background-color: #0f172a !important;
        border-bottom: 1px solid #334155 !important;
        padding: 12px 16px !important;
    }
    .card-custom .card-header-custom h5 {
        margin: 0;
        font-size: 14px;
        font-weight: 600;
        color: #f8fafc;
    }
    .form-label-custom {
        color: #94a3b8;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.03em;
        margin-bottom: 6px;
        display: block;
    }
    .form-input-custom, .form-select-custom {
        background-color: #0f172a !important;
        border: 1px solid #334155 !important;
        color: #cbd5e1 !important;
        font-size: 13px !important;
        padding: 8px 12px !important;
        border-radius: 6px !important;
        width: 100%;
        transition: all 0.2s ease-in-out;
    }
    .form-input-custom:focus, .form-select-custom:focus {
        border-color: #38bdf8 !important;
        box-shadow: 0 0 0 2px rgba(56, 189, 248, 0.15) !important;
        color: #f8fafc !important;
        outline: none;
    }

    /* ===== SEARCH ICON ===== */
    .search-wrapper-custom {
        position: relative;
        width: 100%;
    }
    .search-icon-custom {
        color: #64748b;
        position: absolute;
        top: 50%;
        left: 12px;
        transform: translateY(-50%);
        pointer-events: none;
        font-size: 13px;
    }
    .form-input-custom.ps-icon {
        padding-left: 36px !important;
    }

    /* ===== BUTTONS ===== */
    .btn-submit-custom {
        background-color: #38bdf8 !important;
        color: #0f172a !important;
        font-weight: 600;
        font-size: 13px;
        border: none !important;
        padding: 8px 16px !important;
        border-radius: 6px !important;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
    }
    .btn-submit-custom:hover {
        background-color: #0ea5e9 !important;
    }
    .btn-reset-custom {
        background-color: #334155 !important;
        color: #94a3b8 !important;
        border: 1px solid #475569 !important;
        font-weight: 500;
        font-size: 13px;
        padding: 8px 14px !important;
        border-radius: 6px !important;
        text-decoration: none;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
    }
    .btn-reset-custom:hover {
        background-color: #475569 !important;
        color: #f8fafc !important;
    }

    /* ===== BẢNG DỮ LIỆU ===== */
    .table-custom {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        background-color: #1e293b !important;
    }
    .table-custom th {
        background-color: #0f172a !important;
        color: #94a3b8 !important;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        padding: 10px 12px !important;
        border-bottom: 1px solid #334155 !important;
        border-right: 1px solid #334155 !important;
    }
    .table-custom td {
        padding: 10px 12px !important;
        color: #cbd5e1 !important;
        vertical-align: middle;
        border-bottom: 1px solid rgba(51, 65, 85, 0.4) !important;
        border-right: 1px solid rgba(51, 65, 85, 0.3) !important;
        font-size: 13px;
    }
    .table-custom th:last-child, .table-custom td:last-child {
        border-right: none !important;
    }
    .table-custom tbody tr:hover td {
        background-color: rgba(51, 65, 85, 0.4) !important;
    }

    /* CĂN CHỈNH CỘT BẢNG */
    .col-acc-id     {
        width: 55px;
    }
    .col-acc-name   {
        width: 140px;
    }
    .col-acc-user   {
        width: 110px;
    }
    .col-acc-email  {
        width: 150px;
    }
    .col-acc-pass   {
        width: 90px;
        text-align: center;
    }
    .col-acc-role   {
        width: 95px;
        text-align: center;
    }
    .col-acc-status {
        width: 105px;
        text-align: center;
    }
    .col-acc-action {
        width: 220px;
        text-align: center;
    }

    .text-truncate-custom {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: block;
        width: 100%;
    }
    .password-masked {
        color: #64748b;
        font-family: monospace;
        letter-spacing: 1.5px;
        font-size: 11px;
    }

    /* BADGES & ACTION BUTTONS */
    .badge-custom {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 3px 6px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 600;
    }
    .badge-admin {
        background: rgba(56, 189, 248, 0.12);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.2);
    }
    .badge-user {
        background: rgba(148, 163, 184, 0.12);
        color: #94a3b8;
        border: 1px solid rgba(148, 163, 184, 0.2);
    }
    .badge-active {
        background: rgba(34, 197, 94, 0.12);
        color: #4ade80;
        border: 1px solid rgba(34, 197, 94, 0.2);
    }
    .badge-banned {
        background: rgba(239, 68, 68, 0.12);
        color: #f87171;
        border: 1px solid rgba(239, 68, 68, 0.2);
    }

    .action-group-custom {
        display: flex;
        gap: 6px;
        justify-content: center;
        flex-wrap: wrap;
    }
    .btn-action-small {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        border: none;
        cursor: pointer;
        transition: all 0.2s;
    }
    .btn-edit {
        background: rgba(56, 189, 248, 0.1);
        color: #38bdf8;
    }
    .btn-edit:hover {
        background: #38bdf8;
        color: #0f172a;
    }
    .btn-reset {
        background: #334155;
        color: #e2e8f0;
    }
    .btn-reset:hover {
        background: #475569;
        color: white;
    }
    .btn-lock {
        background: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }
    .btn-lock:hover {
        background: #ef4444;
        color: white;
    }
    .btn-unlock {
        background: rgba(16, 185, 129, 0.1);
        color: #10b981;
    }
    .btn-unlock:hover {
        background: #10b981;
        color: white;
    }

    /* ===== PHÂN TRANG (PAGINATION) ===== */
    .pagination-wrapper {
        padding: 12px 16px;
        background-color: #0f172a;
        border-top: 1px solid #334155;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom-left-radius: 8px;
        border-bottom-right-radius: 8px;
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
    <div class="page-header">
        <div class="page-title">
            <h2>Quản Lý Tài Khoản Hệ Thống</h2>
            <p>Thiết lập, cập nhật thông tin thành viên và phân quyền bảo mật quản trị viên.</p>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert-banner alert-success">
            <i class="fa-solid fa-circle-check"></i> ${successMessage}
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert-banner alert-danger">
            <i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}
        </div>
    </c:if>

    <div class="row g-4">
        <div class="col-12 col-xl-3">
            <div class="card card-custom shadow-sm sticky-top" style="top: 20px; z-index: 10;">
                <div class="card-header-custom">
                    <h5 id="formTitle"><i class="fa-solid fa-user-plus me-2 text-info"></i> Tạo Tài Khoản Mới</h5>
                </div>
                <div class="card-body p-3">
                    <form id="accountForm" action="${pageContext.request.contextPath}/admin/account/save" method="POST">
                        <input type="hidden" name="id" id="accountId" value="">

                        <div class="mb-2.5">
                            <label class="form-label-custom">Họ và tên</label>
                            <input type="text" name="full_name" id="fullName" class="form-input-custom" placeholder="Nhập tên đầy đủ..." required>
                        </div>

                        <div class="mb-2.5">
                            <label class="form-label-custom">Tên đăng nhập</label>
                            <input type="text" name="username" id="username" class="form-input-custom" placeholder="username..." required>
                        </div>

                        <div class="mb-2.5">
                            <label class="form-label-custom">Mật khẩu</label>
                            <input type="password" name="password" id="password" class="form-input-custom" placeholder="••••••••" required>
                        </div>

                        <div class="mb-2.5">
                            <label class="form-label-custom">Địa chỉ Email</label>
                            <input type="email" name="email" id="email" class="form-input-custom" placeholder="example@mail.com" required>
                        </div>

                        <div class="row g-2 mb-3.5">
                            <div class="col-6">
                                <label class="form-label-custom">Vai trò nhóm</label>
                                <select name="role" id="role" class="form-select-custom">
                                    <option value="USER">Khách hàng</option>
                                    <option value="ADMIN">Quản trị viên</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="form-label-custom">Trạng thái</label>
                                <select name="status" id="status" class="form-select-custom">
                                    <option value="ACTIVE">Hoạt động</option>
                                    <option value="LOCKED">Đang khóa</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-2 border-top border-slate-800 mt-2">
                            <a href="javascript:void(0)" id="btnReset" class="btn-reset-custom d-none" onclick="resetForm()">
                                Hủy
                            </a>
                            <button type="submit" id="btnSubmit" class="btn-submit-custom">
                                <i class="fa-solid fa-cloud-arrow-up"></i> Lưu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-12 col-xl-9">

            <div class="card card-custom mb-3 shadow-sm border-0 bg-transparent">
                <form action="${pageContext.request.contextPath}/admin/account-manage" method="GET" class="d-flex flex-wrap gap-2 align-items-center">

                    <div class="search-wrapper-custom flex-grow-1" style="min-width: 250px;">
                        <span class="search-icon-custom"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <input type="text" name="search" value="${param.search}" class="form-input-custom ps-icon m-0" placeholder="Tìm tên, username, email...">
                    </div>

                    <select name="roleFilter" class="form-select-custom w-auto m-0">
                        <option value="">- Tất cả quyền -</option>
                        <option value="USER" ${param.roleFilter == 'USER' ? 'selected' : ''}>USER</option>
                        <option value="ADMIN" ${param.roleFilter == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                    </select>

                    <select name="statusFilter" class="form-select-custom w-auto m-0">
                        <option value="">- Trạng thái -</option>
                        <option value="ACTIVE" ${param.statusFilter == 'ACTIVE' ? 'selected' : ''}>Hoạt Động</option>
                        <option value="LOCKED" ${param.statusFilter == 'LOCKED' ? 'selected' : ''}>Đang Khóa</option>
                    </select>

                    <select name="sortBy" class="form-select-custom w-auto m-0">
                        <option value="id_desc" ${param.sortBy == 'id_desc' ? 'selected' : ''}>ID: Mới -> Cũ</option>
                        <option value="id_asc" ${param.sortBy == 'id_asc' ? 'selected' : ''}>ID: Cũ -> Mới</option>
                        <option value="name_asc" ${param.sortBy == 'name_asc' ? 'selected' : ''}>Tên: A -> Z</option>
                        <option value="name_desc" ${param.sortBy == 'name_desc' ? 'selected' : ''}>Tên: Z -> A</option>
                    </select>

                    <button type="submit" class="btn-submit-custom text-nowrap"><i class="fa-solid fa-filter"></i> Lọc</button>
                    <a href="${pageContext.request.contextPath}/admin/account-manage" class="btn-reset-custom text-nowrap" title="Xóa Bộ Lọc"><i class="fa-solid fa-rotate-left"></i></a>
                </form>
            </div>

            <div class="card card-custom overflow-hidden shadow-sm">
                <div class="card-header-custom d-flex justify-content-between align-items-center">
                    <h5><i class="fa-solid fa-users me-2 text-slate-400"></i> Cơ Sở Dữ Liệu Thành Viên</h5>
                </div>

                <div class="table-responsive">
                    <table class="table-custom" id="adminAccountTable">
                        <thead>
                            <tr>
                                <th class="col-acc-id">ID</th>
                                <th class="col-acc-name">Họ Tên</th>
                                <th class="col-acc-user">Username</th>
                                <th class="col-acc-email">Email</th>
                                <th class="col-acc-pass">Mật Khẩu</th>
                                <th class="col-acc-role">Vai Trò</th>
                                <th class="col-acc-status">Trạng Thái</th>
                                <th class="col-acc-action">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <c:choose>
                                <c:when test="${empty accounts}">
                                    <tr class="empty-row">
                                        <td colspan="8" class="text-center py-5 text-slate-500">
                                            <i class="fa-solid fa-folder-open d-block fs-2 mb-2"></i>
                                            Không tìm thấy tài khoản người dùng nào thỏa mãn bộ lọc hiện tại.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${accounts}" var="acc">
                                        <tr class="data-row">
                                            <td class="text-slate-500 font-monospace">#${acc.id}</td>
                                            <td>
                                                <span class="font-semibold text-slate-200 text-truncate-custom" title="${acc.full_name}">
                                                    ${acc.full_name}
                                                </span>
                                            </td>
                                            <td class="font-monospace text-slate-300">${acc.username}</td>
                                            <td>
                                                <span class="text-slate-400 font-monospace text-truncate-custom" title="${acc.email}">
                                                    ${acc.email}
                                                </span>
                                            </td>
                                            <td align="center">
                                                <span class="password-masked" title="${acc.password}">••••••••</span>
                                            </td>
                                            <td align="center">
                                                <c:choose>
                                                    <c:when test="${acc.role == 'ADMIN'}">
                                                        <span class="badge-custom badge-admin"><i class="fa-solid fa-shield-halved"></i> ADMIN</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-custom badge-user"><i class="fa-solid fa-user"></i> USER</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td align="center">
                                                <c:choose>
                                                    <c:when test="${acc.status == 'LOCKED'}">
                                                        <span class="badge-custom badge-banned"><i class="fa-solid fa-lock"></i> Locked</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-custom badge-active"><i class="fa-solid fa-check"></i> Active</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-group-custom">
                                                    <button type="button" class="btn-action-small btn-edit" 
                                                            data-id="${acc.id}" data-fullname="${acc.full_name}"
                                                            data-username="${acc.username}" data-email="${acc.email}"
                                                            data-role="${acc.role}" data-status="${acc.status}"
                                                            data-password="${acc.password}" onclick="editAccount(this)">
                                                        <i class="fa-solid fa-pen"></i> Sửa
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/admin/account/reset-password?id=${acc.id}" 
                                                       class="btn-action-small btn-reset"
                                                       onclick="return confirm('Đặt lại mật khẩu mặc định (123456) cho tài khoản này?')">
                                                        <i class="fa-solid fa-key"></i> Reset MK
                                                    </a>
                                                    <c:choose>
                                                        <c:when test="${acc.status == 'LOCKED'}">
                                                            <a href="${pageContext.request.contextPath}/admin/account/toggle-status?id=${acc.id}" 
                                                               class="btn-action-small btn-unlock">
                                                                <i class="fa-solid fa-unlock"></i> Mở Khóa
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${acc.role != 'ADMIN'}">
                                                                <a href="${pageContext.request.contextPath}/admin/account/toggle-status?id=${acc.id}" 
                                                                   class="btn-action-small btn-lock"
                                                                   onclick="return confirm('Bạn chắc chắn muốn khóa tài khoản này?')">
                                                                    <i class="fa-solid fa-ban"></i> Khóa
                                                                </a>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="pagination-wrapper" id="paginationWrapper" style="display: none;">
                    <div class="text-slate-400" style="font-size: 12px;" id="paginationInfo">
                    </div>
                    <ul class="pagination-list" id="paginationControls">
                    </ul>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
    // --------------------------------------------------------
    // HÀM XỬ LÝ FORM SỬA / THÊM TÀI KHOẢN
    // --------------------------------------------------------
    function editAccount(btn) {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-user-pen me-2 text-warning"></i> Cập Nhật #' + btn.getAttribute('data-id');
        document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-rotate"></i> Cập Nhật';

        document.getElementById('accountId').value = btn.getAttribute('data-id');
        document.getElementById('fullName').value = btn.getAttribute('data-fullname') || '';
        document.getElementById('username').value = btn.getAttribute('data-username') || '';
        document.getElementById('email').value = btn.getAttribute('data-email') || '';
        document.getElementById('role').value = btn.getAttribute('data-role') || 'USER';
        document.getElementById('status').value = btn.getAttribute('data-status') || 'ACTIVE';
        document.getElementById('password').value = btn.getAttribute('data-password') || '';

        document.getElementById('password').required = false;
        document.getElementById('btnReset').classList.remove('d-none');
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function resetForm() {
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-user-plus me-2 text-info"></i> Tạo Tài Khoản Mới';
        document.getElementById('btnSubmit').innerHTML = '<i class="fa-solid fa-cloud-arrow-up"></i> Lưu';
        document.getElementById('accountForm').reset();
        document.getElementById('accountId').value = "";
        document.getElementById('password').required = true;
        document.getElementById('btnReset').classList.add('d-none');
    }

    // --------------------------------------------------------
    // HỆ THỐNG PHÂN TRANG (10 DÒNG / TRANG) CLIENT-SIDE TỰ ĐỘNG
    // --------------------------------------------------------
    document.addEventListener("DOMContentLoaded", function () {
        const rowsPerPage = 10; // Giới hạn 10 dòng mỗi trang theo yêu cầu
        const tableBody = document.getElementById("tableBody");
        const rows = Array.from(tableBody.querySelectorAll("tr.data-row"));

        const totalRows = rows.length;
        if (totalRows === 0)
            return; // Không có dữ liệu thì không phân trang

        const totalPages = Math.ceil(totalRows / rowsPerPage);
        let currentPage = 1;

        const paginationWrapper = document.getElementById("paginationWrapper");
        const paginationControls = document.getElementById("paginationControls");
        const paginationInfo = document.getElementById("paginationInfo");

        // Hàm hiển thị dữ liệu của trang chỉ định
        window.showPage = function (page) {
            if (page < 1 || page > totalPages)
                return;
            currentPage = page;

            const start = (page - 1) * rowsPerPage;
            const end = start + rowsPerPage;

            // Ẩn/hiện các dòng tương ứng
            rows.forEach((row, index) => {
                if (index >= start && index < end) {
                    row.style.display = "table-row";
                } else {
                    row.style.display = "none";
                }
            });

            // Cập nhật thông tin text hiển thị
            const currentEnd = Math.min(end, totalRows);
            paginationInfo.innerHTML = `Hiển thị <strong>\${start + 1} - \${currentEnd}</strong> trên tổng <strong>\${totalRows}</strong> tài khoản`;

            renderPaginationButtons();
        };

        // Hàm render lại các nút (1, 2, 3, Prev, Next)
        function renderPaginationButtons() {
            paginationControls.innerHTML = "";

            // Nút "Lùi" (Previous)
            const prevBtn = document.createElement("li");
            prevBtn.innerHTML = `<a class="page-btn \${currentPage === 1 ? 'disabled' : ''}" onclick="showPage(\${currentPage - 1})">&laquo;</a>`;
            paginationControls.appendChild(prevBtn);

            // Các nút Số trang (1, 2, 3...)
            for (let i = 1; i <= totalPages; i++) {
                const pageBtn = document.createElement("li");
                pageBtn.innerHTML = `<a class="page-btn \${i === currentPage ? 'active' : ''}" onclick="showPage(\${i})">\${i}</a>`;
                paginationControls.appendChild(pageBtn);
            }

            // Nút "Tiến" (Next)
            const nextBtn = document.createElement("li");
            nextBtn.innerHTML = `<a class="page-btn \${currentPage === totalPages ? 'disabled' : ''}" onclick="showPage(\${currentPage + 1})">&raquo;</a>`;
            paginationControls.appendChild(nextBtn);
        }

        // Kích hoạt phân trang và hiển thị Trang 1 đầu tiên
        paginationWrapper.style.display = "flex";
        showPage(1);
    });
</script>