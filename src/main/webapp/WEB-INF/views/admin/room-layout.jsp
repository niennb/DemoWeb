<%-- 
    Document   : room-layout
    Created on : 20 thg 6, 2026
    Author     : baoni
--%>

<%-- WEB-INF/views/admin/room-layout.jsp --%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        color: #f8fafc;
    }
    .page-title p {
        margin: 5px 0 0 0;
        color: #94a3b8;
        font-size: 14px;
    }

    /* HỆ THỐNG GRID CHIA ĐÔI KHÔNG GIAN (FORM TRÁI - BẢNG PHẢI) */
    .admin-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 25px;
    }
    @media (min-width: 992px) {
        .admin-grid {
            grid-template-columns: 360px 1fr;
        }
    }

    /* THIẾT KẾ PHÂN HỆ FORM NHẬP LIỆU */
    .form-panel {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 24px;
        height: fit-content;
    }
    .form-panel-title {
        font-size: 16px;
        color: #fb923c; /* Màu cam thương hiệu */
        margin-top: 0;
        margin-bottom: 20px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 1px solid #334155;
        padding-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .form-group {
        margin-bottom: 18px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        color: #94a3b8;
        font-size: 13px;
        font-weight: 500;
    }
    .form-control {
        width: 100%;
        padding: 10px 14px;
        background-color: #0f172a;
        border: 1px solid #334155;
        border-radius: 6px;
        color: #cbd5e1;
        font-size: 14px;
        transition: all 0.2s;
        box-sizing: border-box;
    }
    .form-control:focus {
        outline: none;
        border-color: #fb923c;
        box-shadow: 0 0 0 2px rgba(251, 146, 60, 0.2);
    }
    .form-actions {
        display: flex;
        gap: 10px;
        margin-top: 24px;
    }

    /* BẢNG DỮ LIỆU PHÒNG CHIẾU */
    .table-responsive {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        overflow: hidden;
    }
    .admin-table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
        color: #cbd5e1;
    }
    .admin-table th {
        background-color: #0f172a;
        color: #fb923c;
        padding: 16px 20px;
        font-weight: 600;
        font-size: 14px;
        border-bottom: 2px solid #334155;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .admin-table td {
        padding: 16px 20px;
        border-bottom: 1px solid #334155;
        font-size: 14px;
        vertical-align: middle;
    }
    .admin-table tr:hover {
        background-color: rgba(51, 65, 85, 0.5);
    }

    /* BADGES (NHÃN ĐỘNG CHỨA SỨC CHỨA) */
    .badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
    }
    .badge-capacity {
        background-color: rgba(56, 189, 248, 0.15);
        color: #38bdf8;
        border: 1px solid rgba(56, 189, 248, 0.3);
    }

    /* NÚT HÀNH ĐỘNG (ACTION BUTTONS) */
    .action-btns {
        display: flex;
        gap: 10px;
    }
    .btn-action {
        padding: 8px 14px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        border: none;
        transition: all 0.2s;
    }
    .btn-submit-save {
        background-color: rgba(16, 185, 129, 0.15);
        color: #10b981;
        border: 1px solid rgba(16, 185, 129, 0.3);
        flex: 1;
        justify-content: center;
    }
    .btn-submit-save:hover {
        background-color: #10b981;
        color: white;
    }
    .btn-reset {
        background-color: #334155;
        color: #e2e8f0;
    }
    .btn-reset:hover {
        background-color: #475569;
        color: #ffffff;
    }
    .btn-edit {
        background-color: rgba(251, 146, 60, 0.1);
        color: #fb923c;
        border: 1px solid rgba(251, 146, 60, 0.2);
    }
    .btn-edit:hover {
        background-color: #fb923c;
        color: white;
    }
    .btn-delete {
        background-color: rgba(239, 68, 68, 0.1);
        color: #ef4444;
        border: 1px solid rgba(239, 68, 68, 0.2);
    }
    .btn-delete:hover {
        background-color: #ef4444;
        color: white;
    }
    .d-none {
        display: none !important;
    }
</style>

<div class="page-header">
    <div class="page-title">
        <h2>🎬 Cấu Trúc Sơ Đồ Phòng Chiếu</h2>
        <p>Thiết lập hạ tầng phòng rạp, cấu hình số lượng ghế ngồi đáp ứng ma trận lịch chiếu phim.</p>
    </div>
</div>

<div class="admin-grid">
    <div class="form-panel">
        <h3 class="form-panel-title" id="formTitle">
            <i class="fa-solid fa-square-plus"></i> Thêm Phòng Chiếu Mới
        </h3>

        <form id="roomForm" action="${pageContext.request.contextPath}/admin/room/add" method="POST">
            <input type="hidden" id="roomId" name="id" />

            <div class="form-group">
                <label for="roomName">Tên Phòng Chiếu</label>
                <input type="text" class="form-control" id="roomName" name="roomName" 
                       placeholder="Ví dụ: Phòng chiếu 1, IMAX 3D..." required>
            </div>

            <div class="form-group">
                <label for="capacity">Sức Chứa Thống Kê (Ghế)</label>
                <input type="number" class="form-control" id="capacity" name="capacity" min="1" 
                       placeholder="Ví dụ: 60, 120..." required>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-action btn-submit-save" id="btnSubmit">
                    <i class="fa-solid fa-floppy-disk"></i> Lưu Phòng
                </button>
                <button type="button" class="btn-action btn-reset d-none" id="btnReset" onclick="resetForm()">
                    Hủy Bỏ
                </button>
            </div>
        </form>
    </div>

    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 100px;">Mã ID</th>
                    <th>Tên Phòng Chiếu</th>
                    <th>Quy Mô Sức Chứa</th>
                    <th>Số Ghế Hiện Có</th> <th style="text-align: center; width: 220px;">Tác Vụ Xử Lý</th>
                </tr>
            </thead>
            <tbody>
                <%-- Vòng lặp lấy danh sách phòng từ AdminController --%>
                <c:forEach var="room" items="${rooms}">
                    <tr>
                        <td><strong>#${room.id}</strong></td>
                        <td style="font-weight: 600; color: #f8fafc;">
                            <c:out value="${room.roomName}" />
                        </td>
                        <td>
                            <span class="badge badge-capacity">
                                <i class="fa-solid fa-chair"></i> <c:out value="${room.capacity}" /> Ghế ngồi
                            </span>
                        </td>
                        <td>
                            <span class="badge" style="background-color: rgba(16, 185, 129, 0.15); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3);">
                                <i class="fa-solid fa-circle-check"></i> Đã xếp: ${fn:length(room.seats)} Ghế
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <div class="action-btns">
                                <button type="button" class="btn-action btn-edit" 
                                        onclick="activateEditMode('${room.id}', '${room.roomName}', '${room.capacity}')">
                                    <i class="fa-solid fa-pen-to-square"></i> Sửa
                                </button>

                                <a href="${pageContext.request.contextPath}/admin/room/delete?id=${room.id}" 
                                   class="btn-action btn-delete"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa phòng [${room.roomName}] không? Hệ thống sẽ giải phóng toàn bộ suất chiếu liên đới!')">
                                    <i class="fa-solid fa-trash-can"></i> Xóa
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <%-- Hiển thị thông báo dự phòng nếu danh sách phòng trống --%>
                <c:if test="${empty rooms}">
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: #64748b;">
                            <i class="fa-solid fa-circle-info" style="font-size: 24px; margin-bottom: 10px; display: block; color: #fb923c;"></i>
                            Hệ thống chưa ghi nhận hạ tầng phòng chiếu nào. Hãy tạo ở Form bên cạnh.
                        </td>
                    </tr>
                </c:if>
                <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">${errorMsg}</div>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
    function activateEditMode(id, name, capacity) {
        // 1. Đổi tiêu đề form và cấu hình đường dẫn đích sang hàm update của AdminController
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-pen-to-square"></i> Cập Nhật Phòng (#' + id + ')';
        document.getElementById('roomForm').action = "${pageContext.request.contextPath}/admin/room/update";

        // 2. Điền ngược dữ liệu từ dòng được chọn lên các ô input tương ứng
        document.getElementById('roomId').value = id;
        document.getElementById('roomName').value = name;
        document.getElementById('capacity').value = capacity;

        // 3. Hiện nút Hủy Bỏ để Admin có thể thoát chế độ sửa bất kỳ lúc nào
        document.getElementById('btnReset').classList.remove('d-none');
    }

    function resetForm() {
        // 1. Khôi phục tiêu đề gốc và đích xử lý hành động Thêm mới dữ liệu
        document.getElementById('formTitle').innerHTML = '<i class="fa-solid fa-square-plus"></i> Thêm Phòng Chiếu Mới';
        document.getElementById('roomForm').action = "${pageContext.request.contextPath}/admin/room/add";

        // 2. Làm rỗng hoàn toàn các ô dữ liệu
        document.getElementById('roomId').value = "";
        document.getElementById('roomName').value = "";
        document.getElementById('capacity').value = "";

        // 3. Ẩn nút hủy bỏ đi
        document.getElementById('btnReset').classList.add('d-none');
    }
</script>