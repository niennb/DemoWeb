<%-- 
    Document   : payment-manage
    Created on : 26 thg 6, 2026
    Author     : baoni
    Upgraded   : Tích hợp bộ lọc 3 lớp (Tên + Trạng thái + Phương thức), Sắp xếp và Phân trang tự động (10 dòng/trang)
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- BỘ TÍNH TOÁN DỮ LIỆU CHO THẺ THỐNG KÊ NHANH --%>
<c:set var="totalRev" value="0" />
<c:set var="countSuccess" value="0" />
<c:set var="countPending" value="0" />
<c:set var="countFailed" value="0" />

<c:forEach items="${payments}" var="pm">
    <c:choose>
        <c:when test="${pm.status == 'SUCCESS' || pm.status == 'Thành công'}">
            <c:set var="totalRev" value="${totalRev + pm.amount}" />
            <c:set var="countSuccess" value="${countSuccess + 1}" />
        </c:when>
        <c:when test="${pm.status == 'PENDING' || pm.status == 'Chưa thanh toán'}">
            <c:set var="countPending" value="${countPending + 1}" />
        </c:when>
        <c:otherwise>
            <c:set var="countFailed" value="${countFailed + 1}" />
        </c:otherwise>
    </c:choose>
</c:forEach>

<style>
    /* KHU VỰC TIÊU ĐỀ VÀ THANH CÔNG CỤ */
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

    /* BỘ LỌC VÀ TÌM KIẾM */
    .toolbar-container {
        display: flex;
        gap: 15px;
        align-items: center;
        flex-wrap: wrap;
    }
    .search-box {
        position: relative;
        width: 260px;
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
    }

    /* HỆ THỐNG THẺ BÁO CÁO THỐNG KÊ NHANH */
    .summary-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 20px;
        margin-bottom: 25px;
    }
    .summary-card {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    .summary-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }
    .icon-rev {
        background-color: rgba(251, 146, 60, 0.15);
        color: #fb923c;
    }
    .icon-success {
        background-color: rgba(52, 211, 153, 0.15);
        color: #34d399;
    }
    .icon-pending {
        background-color: rgba(250, 204, 21, 0.15);
        color: #facc15;
    }
    .icon-failed {
        background-color: rgba(248, 113, 113, 0.15);
        color: #f87171;
    }

    .summary-info p {
        margin: 0;
        color: #94a3b8;
        font-size: 13px;
        font-weight: 500;
    }
    .summary-info h3 {
        margin: 5px 0 0 0;
        font-size: 22px;
        font-weight: 700;
    }
    .text-val-rev {
        color: #f8fafc;
    }
    .text-val-success {
        color: #4ade80;
    }
    .text-val-pending {
        color: #fde047;
    }
    .text-val-failed {
        color: #f87171;
    }

    /* CẤU TRÚC BẢNG QUẢN LÝ DỮ LIỆU */
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
    .table-custom th:nth-child(1) {
        width: 75px;
    }
    .table-custom th:nth-child(2) {
        width: 230px;
    }
    .table-custom th:nth-child(3) {
        width: 170px;
    }
    .table-custom th:nth-child(4) {
        width: 140px;
    }
    .table-custom th:nth-child(5) {
        width: 175px;
    }
    .table-custom th:nth-child(6) {
        width: auto;
    }
    .table-custom th:nth-child(7) {
        width: 210px;
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
    .table-custom tr:hover td {
        background-color: #24334d;
    }

    /* DROPDOWN TRẠNG THÁI */
    .select-status {
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        outline: none;
        border: 1px solid transparent;
        width: 100%;
        transition: all 0.2s;
    }
    .sel-success {
        background-color: rgba(34, 197, 94, 0.15);
        color: #4ade80;
        border-color: rgba(34, 197, 94, 0.3);
    }
    .sel-pending {
        background-color: rgba(234, 179, 8, 0.15);
        color: #fde047;
        border-color: rgba(234, 179, 8, 0.3);
    }
    .sel-failed {
        background-color: rgba(239, 68, 68, 0.15);
        color: #f87171;
        border-color: rgba(239, 68, 68, 0.3);
    }

    .email-truncated {
        max-width: 200px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        color: #94a3b8;
        font-size: 13px;
        margin-top: 2px;
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
    } /* Đổi màu nút active sang Cam cho hợp tông Payment */
    .page-btn.disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
</style>

<div class="page-header">
    <div class="page-title">
        <h2>Quản Lý Hóa Đơn & Thanh Toán</h2>
        <p>Hệ thống tự động ghi lại lịch sử dòng tiền mua vé và cập nhật trạng thái đồng bộ.</p>
    </div>

    <div class="toolbar-container">
        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input type="text" id="paymentSearchInput" onkeyup="filterPaymentTable()" placeholder="Tìm theo tên khách hàng...">
        </div>

        <select id="paymentStatusFilter" class="filter-select" onchange="filterPaymentTable()">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="SUCCESS">Thành công (SUCCESS)</option>
            <option value="PENDING">Chờ xử lý (PENDING)</option>
            <option value="FAILED">Thất bại / Hủy (FAILED)</option>
        </select>

        <select id="paymentMethodFilter" class="filter-select" onchange="filterPaymentTable()">
            <option value="">-- Tất cả phương thức --</option>
            <option value="Momo">Momo</option>
            <option value="VNPAY">VNPAY</option>
            <option value="Tiền mặt">Tiền mặt</option>
            <option value="Thẻ tín dụng">Thẻ tín dụng</option>
        </select>

        <select id="paymentSortFilter" class="filter-select" onchange="sortPaymentTable()">
            <option value="date_desc">Mới nhất xếp trước</option>
            <option value="date_asc">Cũ nhất xếp trước</option>
            <option value="amount_desc">Số tiền cao tiền giảm dần</option>
            <option value="amount_asc">Số tiền thấp tăng dần</option>
        </select>
    </div>
</div>

<c:if test="${not empty successMsg}">
    <div class="alert alert-success d-flex align-items-center m-0 mb-4 p-3" style="background-color: rgba(34,197,94,0.15); color: #4ade80; border: 1px solid rgba(34,197,94,0.25); border-radius: 8px;">
        <i class="fa-solid fa-circle-check me-2 fs-5"></i> ${successMsg}
    </div>
</c:if>
<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger d-flex align-items-center m-0 mb-4 p-3" style="background-color: rgba(239,68,68,0.15); color: #f87171; border: 1px solid rgba(239,68,68,0.25); border-radius: 8px;">
        <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i> ${errorMsg}
    </div>
</c:if>

<div class="summary-grid">
    <div class="summary-card">
        <div class="summary-icon icon-rev"><i class="fa-solid fa-wallet"></i></div>
        <div class="summary-info">
            <p>Doanh Thu Thực Tế</p>
            <h3 class="text-val-rev">
                <fmt:formatNumber value="${totalRev}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
            </h3>
        </div>
    </div>
    <div class="summary-card">
        <div class="summary-icon icon-success"><i class="fa-solid fa-square-check"></i></div>
        <div class="summary-info">
            <p>Giao Dịch Thành Công</p>
            <h3 class="text-val-success">${countSuccess} đơn</h3>
        </div>
    </div>
    <div class="summary-card">
        <div class="summary-icon icon-pending"><i class="fa-solid fa-hourglass-half"></i></div>
        <div class="summary-info">
            <p>Hóa Đơn Chờ Xử Lý</p>
            <h3 class="text-val-pending">${countPending} đơn</h3>
        </div>
    </div>
    <div class="summary-card">
        <div class="summary-icon icon-failed"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="summary-info">
            <p>Giao Dịch Thất Bại / Hủy</p>
            <h3 class="text-val-failed">${countFailed} đơn</h3>
        </div>
    </div>
</div>

<div class="table-container">
    <table class="table-custom" id="adminPaymentTable">
        <thead>
            <tr>
                <th>Mã HD</th>
                <th>Khách Hàng</th>
                <th>Thông Tin Vé</th>
                <th>Phương Thức</th>
                <th>Thời Gian Giao Dịch</th>
                <th style="text-align: right;">Số Tiền</th>
                <th style="text-align: center;">Trạng Thái Thanh Toán</th>
            </tr>
        </thead>
        <tbody id="tableBody">
            <c:choose>
                <c:when test="${not empty payments}">
                    <c:forEach items="${payments}" var="pm">
                        <tr class="data-row" data-time="${pm.paymentTime}" data-amount="${pm.amount}" data-method="${pm.paymentMethod}">

                            <td class="font-monospace text-slate-400" style="font-weight: 600;">#${pm.id}</td>

                            <td>
                                <div style="font-weight: 600; color: #f1f5f9;">${pm.ticket.user.full_name}</div>
                                <div class="email-truncated" title="${pm.ticket.user.email}">
                                    ${pm.ticket.user.email}
                                </div>
                            </td>

                            <td>
                                <div class="text-warning" style="font-weight: 500;">Mã Vé: #${pm.ticket.id}</div>
                                <div style="font-size: 12px; color: #94a3b8; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${pm.ticket.movie.name}">
                                    Phim: ${pm.ticket.movie.name}
                                </div>
                            </td>

                            <td>
                                <span class="badge" style="background-color: #334155; color: #cbd5e1; padding: 5px 10px; border-radius: 6px; font-size: 12px;">
                                    <i class="fa-solid fa-credit-card me-1" style="font-size: 11px;"></i> ${pm.paymentMethod}
                                </span>
                            </td>

                            <td style="color: #94a3b8; font-size: 13px;">
                                <fmt:parseDate value="${pm.paymentTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </td>

                            <td style="text-align: right; font-weight: 700; color: #fb923c; font-size: 15px; white-space: nowrap;">
                                <fmt:formatNumber value="${pm.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </td>

                            <td align="center">
                                <form action="${pageContext.request.contextPath}/admin/payment-manage/update-status" method="POST" class="m-0 w-100">
                                    <input type="hidden" name="paymentId" value="${pm.id}">

                                    <c:set var="statusClass" value="sel-failed" />
                                    <c:if test="${pm.status == 'SUCCESS' || pm.status == 'Thành công'}"><c:set var="statusClass" value="sel-success" /></c:if>
                                    <c:if test="${pm.status == 'PENDING' || pm.status == 'Chưa thanh toán'}"><c:set var="statusClass" value="sel-pending" /></c:if>

                                        <select name="status" class="select-status ${statusClass}" 
                                            onchange="if (confirm('Xác nhận cập nhật trạng thái thanh toán cho Hóa Đơn #${pm.id}?')) {
                                                        this.form.submit();
                                                    } else {
                                                        this.value = '${pm.status}';
                                                    }">
                                        <option value="SUCCESS" ${pm.status == 'SUCCESS' || pm.status == 'Thành công' ? 'selected' : ''}>● SUCCESS</option>
                                        <option value="PENDING" ${pm.status == 'PENDING' || pm.status == 'Chưa thanh toán' ? 'selected' : ''}>● PENDING</option>
                                        <option value="FAILED" ${pm.status == 'FAILED' || pm.status == 'Đã hủy' ? 'selected' : ''}>● FAILED</option>
                                    </select>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr class="empty-row">
                        <td colspan="7" style="text-align: center; padding: 50px 0; color: #64748b;">
                            <i class="fa-solid fa-receipt d-block mb-3" style="font-size: 32px; color: #475569;"></i>
                            Không tìm thấy dữ liệu hóa đơn giao dịch nào trong hệ thống.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="pagination-wrapper w-100" id="paginationWrapper" style="display: none;">
        <div class="text-slate-400" style="font-size: 12px;" id="paginationInfo">
        </div>
        <ul class="pagination-list" id="paginationControls">
        </ul>
    </div>
</div>

<script>
    let currentPage = 1;
    const rowsPerPage = 10; // Giới hạn 10 dòng/trang
    let allRows = [];
    let filteredRows = [];

    document.addEventListener("DOMContentLoaded", function () {
        const tableBody = document.getElementById("tableBody");
        allRows = Array.from(tableBody.querySelectorAll("tr.data-row"));

        if (allRows.length > 0) {
            document.getElementById("paginationWrapper").style.display = "flex";
            // Lần đầu tải trang, filteredRows sẽ bằng tất cả các row
            filteredRows = [...allRows];
            sortFilteredRowsArray(); // Áp dụng sắp xếp mặc định nếu có
            showPage(1);
        }
    });

    // -----------------------------------------------------------------
    // HÀM LỌC: CHỈ LỌC NHỮNG ROW PHÙ HỢP VÀ ĐƯA VÀO FILTERED ROWS
    // -----------------------------------------------------------------
    function filterPaymentTable() {
        const searchInput = document.getElementById("paymentSearchInput").value.toUpperCase();
        const statusFilter = document.getElementById("paymentStatusFilter").value;
        const methodFilter = document.getElementById("paymentMethodFilter").value.toUpperCase();

        filteredRows = allRows.filter(row => {
            let tdCustomer = row.querySelector("td:nth-child(2)");
            let tdStatusSelect = row.querySelector("td:nth-child(7) select");
            let currentMethod = row.getAttribute("data-method") ? row.getAttribute("data-method").toUpperCase() : "";

            if (tdCustomer && tdStatusSelect) {
                let txtCustomer = tdCustomer.textContent || tdCustomer.innerText;
                let currentStatus = tdStatusSelect.value;

                let matchesSearch = txtCustomer.toUpperCase().indexOf(searchInput) > -1;
                let matchesStatus = (statusFilter === "") || (currentStatus === statusFilter);
                let matchesMethod = (methodFilter === "") || (currentMethod.indexOf(methodFilter) > -1);

                return matchesSearch && matchesStatus && matchesMethod;
            }
            return false;
        });

        // Sau khi lọc xong, gọi hàm sort lại những dòng vừa lọc để đảm bảo dữ liệu hiển thị đúng chuẩn
        sortFilteredRowsArray();

        // Luôn trả về trang 1 sau khi lọc
        showPage(1);
    }

    // -----------------------------------------------------------------
    // HÀM SẮP XẾP: SẮP XẾP MẢNG DỮ LIỆU ĐÃ LỌC
    // -----------------------------------------------------------------
    function sortPaymentTable() {
        sortFilteredRowsArray();
        showPage(1);
    }

    function sortFilteredRowsArray() {
        const sortBy = document.getElementById("paymentSortFilter").value;
        if (filteredRows.length === 0)
            return;

        filteredRows.sort((a, b) => {
            let valA, valB;
            if (sortBy.includes("date")) {
                valA = new Date(a.getAttribute("data-time") || 0).getTime();
                valB = new Date(b.getAttribute("data-time") || 0).getTime();
            } else if (sortBy.includes("amount")) {
                valA = parseFloat(a.getAttribute("data-amount") || 0);
                valB = parseFloat(b.getAttribute("data-amount") || 0);
            }

            if (sortBy.includes("asc")) {
                return valA - valB;
            } else {
                return valB - valA;
            }
        });

        // Cập nhật lại thứ tự DOM vật lý (Cần thiết để khi phân trang, các dòng hiển thị đúng thứ tự)
        const tbody = document.getElementById("tableBody");
        filteredRows.forEach(row => tbody.appendChild(row));
    }

    // -----------------------------------------------------------------
    // HÀM PHÂN TRANG: CẮT DỮ LIỆU TỪ MẢNG FILTERED ĐỂ HIỂN THỊ
    // -----------------------------------------------------------------
    function showPage(page) {
        const totalRows = filteredRows.length;
        const totalPages = Math.ceil(totalRows / rowsPerPage) || 1;

        if (page < 1)
            page = 1;
        if (page > totalPages)
            page = totalPages;
        currentPage = page;

        // Ẩn tất cả dữ liệu
        allRows.forEach(row => row.style.display = "none");

        // Hiển thị dữ liệu tương ứng với trang hiện tại
        const start = (page - 1) * rowsPerPage;
        const end = Math.min(start + rowsPerPage, totalRows);

        for (let i = start; i < end; i++) {
            filteredRows[i].style.display = "table-row";
        }

        renderPaginationUI(totalRows, totalPages, start, end);
    }

    // Xây dựng giao diện nút bấm
    function renderPaginationUI(totalRows, totalPages, start, end) {
        const paginationInfo = document.getElementById("paginationInfo");
        const paginationControls = document.getElementById("paginationControls");

        if (totalRows === 0) {
            paginationInfo.innerHTML = "Không tìm thấy giao dịch nào.";
            paginationControls.innerHTML = "";
            return;
        }

        paginationInfo.innerHTML = `Hiển thị <strong>\${start + 1} - \${end}</strong> trên tổng <strong>\${totalRows}</strong> giao dịch`;
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
</script>