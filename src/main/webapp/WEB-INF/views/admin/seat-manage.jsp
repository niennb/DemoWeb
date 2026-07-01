<%-- 
    Document   : seat-manage
    Created on : 21 thg 6, 2026
    Author     : baoni
    Upgraded   : Tích hợp chế độ lọc theo Suất chiếu và Hiển thị màu sắc trạng thái Ghế (Trống/Chờ/Đã mua)
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* KHU VỰC TIÊU ĐỀ VÀ THANH LỌC PHÒNG */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        flex-wrap: wrap;
        gap: 15px;
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

    .room-selector {
        background-color: #1e293b;
        border: 1px solid #334155;
        padding: 12px 20px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .room-selector label {
        color: #94a3b8;
        font-size: 14px;
        font-weight: 500;
    }
    .form-select {
        padding: 8px 16px;
        background-color: #0f172a;
        border: 1px solid #334155;
        border-radius: 6px;
        color: #fb923c;
        font-weight: 600;
        outline: none;
        cursor: pointer;
    }

    /* THÔNG BÁO (ALERTS) */
    .alert {
        padding: 14px 20px;
        border-radius: 8px;
        margin-bottom: 25px;
        font-size: 14px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .alert-success {
        background-color: rgba(16, 185, 129, 0.15);
        color: #10b981;
        border: 1px solid rgba(16, 185, 129, 0.3);
    }
    .alert-danger {
        background-color: rgba(239, 68, 68, 0.15);
        color: #ef4444;
        border: 1px solid rgba(239, 68, 68, 0.3);
    }

    /* LƯỚI BỐ CỤC CHÍNH */
    .seat-layout-container {
        display: grid;
        grid-template-columns: 320px 1fr;
        gap: 25px;
    }
    @media (max-width: 992px) {
        .seat-layout-container {
            grid-template-columns: 1fr;
        }
    }

    /* KHU VỰC ĐIỀU KHIỂN (LEFT PANEL) */
    .control-panel {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 20px;
        height: fit-content;
    }
    .panel-title {
        font-size: 15px;
        color: #fb923c;
        text-transform: uppercase;
        margin-top: 0;
        margin-bottom: 15px;
        font-weight: 600;
        letter-spacing: 0.5px;
        border-bottom: 1px solid #334155;
        padding-bottom: 10px;
    }

    /* THỐNG KÊ PHÒNG (KPI CARDS) */
    .stat-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-bottom: 20px;
    }
    .stat-card {
        background-color: #0f172a;
        border: 1px solid #334155;
        border-radius: 8px;
        padding: 12px 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .stat-label {
        color: #94a3b8;
        font-size: 13px;
    }
    .stat-value {
        color: #f8fafc;
        font-size: 16px;
        font-weight: 600;
    }

    /* INPUT FORM */
    .form-group {
        margin-bottom: 15px;
    }
    .form-group label {
        display: block;
        margin-bottom: 6px;
        color: #94a3b8;
        font-size: 13px;
    }
    .form-control {
        width: 100%;
        padding: 10px;
        background-color: #0f172a;
        border: 1px solid #334155;
        border-radius: 6px;
        color: #cbd5e1;
        box-sizing: border-box;
    }
    .form-control:focus {
        outline: none;
        border-color: #fb923c;
    }

    /* NÚT BẤM BUTTONS */
    .btn-block {
        width: 100%;
        padding: 11px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: all 0.2s;
        margin-top: 10px;
        text-decoration: none;
        box-sizing: border-box;
    }
    .btn-primary {
        background-color: #fb923c;
        color: #fff;
    }
    .btn-primary:hover {
        background-color: #ea580c;
    }
    .btn-danger-outline {
        background-color: rgba(239, 68, 68, 0.1);
        color: #ef4444;
        border: 1px solid rgba(239, 68, 68, 0.2);
    }
    .btn-danger-outline:hover {
        background-color: #ef4444;
        color: #fff;
    }

    /* KHU VỰC SƠ ĐỒ GHẾ TRỰC QUAN (RIGHT PANEL) */
    .visual-panel {
        background-color: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 30px 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    /* MÀN HÌNH CHIẾU */
    .cinema-screen {
        width: 70%;
        height: 8px;
        background-color: #38bdf8;
        border-radius: 4px;
        box-shadow: 0 4px 20px rgba(56, 189, 248, 0.7);
        margin: 10px 0 15px 0;
    }
    .screen-text {
        color: #38bdf8;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 4px;
        margin-bottom: 45px;
    }

    /* KHU VỰC MAP GHẾ */
    .cinema-map {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 10px;
        max-width: 100%;
        background: #0f172a;
        padding: 25px;
        border-radius: 10px;
        border: 1px solid #334155;
        box-shadow: inset 0 2px 10px rgba(0,0,0,0.5);
    }

    /* Ô GHẾ NGỒI ĐƠN LẺ */
    .seat-box {
        width: 42px;
        height: 38px;
        background-color: #334155;
        border: 1px solid #475569;
        border-radius: 5px;
        color: #cbd5e1;
        font-size: 11px;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        cursor: default;
        user-select: none;
    }
    .seat-box:hover {
        background-color: #fb923c;
        border-color: #fb923c;
        color: #fff;
        transform: scale(1.1);
    }

    /* CHÚ THÍCH SƠ ĐỒ */
    .map-legend {
        display: flex;
        gap: 20px;
        margin-top: 25px;
        font-size: 13px;
        color: #94a3b8;
    }
    .legend-item {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    /* TRẠNG THÁI TRỐNG HOÁC */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #64748b;
        width: 100%;
    }
    .empty-state i {
        font-size: 40px;
        color: #334155;
        margin-bottom: 15px;
        display: block;
    }

    /* MÀU SẮC TRẠNG THÁI THEO DÕI GHẾ CHO SUẤT CHIẾU */
    .seat-status-success {
        background-color: #ef4444 !important;
        border-color: #dc2626 !important;
        color: #ffffff !important;
    }
    .seat-status-pending {
        background-color: #f59e0b !important;
        border-color: #d97706 !important;
        color: #ffffff !important;
    }
</style>

<div class="page-header">
    <div class="page-title">
        <h2>💺 Cấu Hình Sơ Đồ Ghế Tự Động</h2>
        <p>Hệ thống tự động sinh ma trận ghế (Hàng x Cột) dựa trên Sức chứa quy định của từng phòng chiếu.</p>
    </div>

    <div style="display: flex; gap: 15px; flex-wrap: wrap; align-items: center;">
        <div class="room-selector">
            <label for="roomSelect"><i class="fa-solid fa-door-open"></i> Lựa chọn phòng chiếu:</label>
            <select id="roomSelect" class="form-select" onchange="switchRoom(this.value)">
                <option value="">-- Chọn phòng chiếu để quản lý --</option>
                <c:forEach var="r" items="${rooms}">
                    <option value="${r.id}" ${param.roomId == r.id ? 'selected' : ''}>
                        ${r.roomName} (Sức chứa: ${r.capacity})
                    </option>
                </c:forEach>
            </select>
        </div>

        <c:if test="${not empty showtimes}">
            <div class="room-selector" style="border-color: #475569;">
                <label for="showtimeSelect"><i class="fa-solid fa-film"></i> Xem Trạng Thế Theo Suất Chiêu:</label>
                <select id="showtimeSelect" class="form-select" style="color: #38bdf8;" onchange="switchShowtime(this.value)">
                    <option value="">-- Chế độ cấu hình phòng (Mặc định) --</option>
                    <c:forEach var="st" items="${showtimes}">
                        <option value="${st.id}" ${selectedShowtimeId == st.id ? 'selected' : ''}>
                            ${st.startTime} - ${st.endTime} | Phim: ${st.movie.name} (${st.showDate})
                        </option>
                    </c:forEach>
                </select>
            </div>
        </c:if>
    </div>
</div>

<c:if test="${not empty successMsg}">
    <div class="alert alert-success">
        <i class="fa-solid fa-circle-check"></i> ${successMsg}
    </div>
</c:if>
<c:if test="${not empty errorMsg}">
    <div class="alert alert-danger">
        <i class="fa-solid fa-triangle-exclamation"></i> ${errorMsg}
    </div>
</c:if>

<c:choose>
    <c:when test="${empty param.roomId or empty selectedRoom}">
        <div class="visual-panel" style="padding: 80px 20px;">
            <div class="empty-state">
                <i class="fa-solid fa-cubes"></i>
                <h3>Vui lòng chọn một phòng chiếu cụ thể ở thanh công cụ phía trên</h3>
                <p>Hệ thống sẽ tải thông tin cấu hình, tổng số ghế hiện tại và kết xuất sơ đồ thiết kế trực quan.</p>
            </div>
        </div>
    </c:when>

    <c:otherwise>
        <div class="seat-layout-container">

            <div class="control-panel">
                <h3 class="panel-title"><i class="fa-solid fa-circle-info"></i> Thông Số Phòng Chiếu</h3>
                <div class="stat-group">
                    <div class="stat-card">
                        <span class="stat-label">Tên phòng:</span>
                        <span class="stat-value" style="color: #fb923c;">${selectedRoom.roomName}</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">Sức chứa tối đa:</span>
                        <span class="stat-value">${selectedRoom.capacity} ghế</span>
                    </div>
                    <div class="stat-card">
                        <span class="stat-label">Số ghế đã tạo:</span>
                        <span class="stat-value" style="color: ${currentSeatCount == selectedRoom.capacity ? '#10b981' : '#f59e0b'};">
                            ${currentSeatCount} / ${selectedRoom.capacity}
                        </span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${currentSeatCount >= selectedRoom.capacity}">
                        <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2); padding: 15px; border-radius: 8px; text-align: center; color: #10b981; font-size: 13px; font-weight: 500;">
                            <i class="fa-solid fa-circle-check" style="font-size: 18px; margin-bottom: 6px; display: block;"></i>
                            Phòng chiếu đã được cấu hình đủ số lượng ghế quy định. Không cần sinh thêm!
                        </div>
                    </c:when>
                    <c:otherwise>
                        <h3 class="panel-title" style="margin-top: 25px;"><i class="fa-solid fa-wand-magic-sparkles"></i> Sinh Ghế Tự Động</h3>
                        <form action="${pageContext.request.contextPath}/admin/seat/generate" method="POST">
                            <input type="hidden" name="roomId" value="${selectedRoom.id}">

                            <div class="form-group">
                                <label for="rows">Số hàng dọc ghế (Chữ cái):</label>
                                <input type="number" id="rows" name="rows" class="form-control" min="1" max="26" required placeholder="Ví dụ: 5 hàng (A -> E)">
                            </div>

                            <div class="form-group">
                                <label for="cols">Số ghế mỗi hàng (Cột số):</label>
                                <input type="number" id="cols" name="cols" class="form-control" min="1" max="30" required placeholder="Ví dụ: 10 ghế">
                            </div>

                            <div style="font-size: 12px; color: #94a3b8; margin: 10px 0; background: #0f172a; padding: 10px; border-radius: 6px; border-left: 3px solid #fb923c;">
                                <i class="fa-solid fa-lightbulb" style="color: #fb923c;"></i> 
                                Nhập 5 hàng và 4 ghế sẽ tự sinh ra 20 ghế: từ A1 đến E4.
                            </div>

                            <button type="submit" class="btn-block btn-primary">
                                <i class="fa-solid fa-bolt"></i> Kích Hoạt Tạo Ghế
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <c:if test="${currentSeatCount > 0}">
                    <h3 class="panel-title" style="margin-top: 30px; border-color: rgba(239, 68, 68, 0.2); color: #ef4444;"><i class="fa-solid fa-triangle-exclamation"></i> Khu Vực Nguy Hiểm</h3>
                    <a href="${pageContext.request.contextPath}/admin/seat/clear?roomId=${selectedRoom.id}" 
                       class="btn-block btn-danger-outline"
                       onclick="return confirm('CẢNH BÁO NGUY HIỂM:\nHành động này sẽ XÓA TOÀN BỘ ghế hiện có của phòng này để cài đặt lại!\nBạn có chắc chắn muốn tiếp tục không?')">
                        <i class="fa-solid fa-trash-arrow-up"></i> Xóa Sơ Đồ Làm Lại
                    </a>
                </c:if>
            </div>

            <div class="visual-panel">
                <div class="cinema-screen"></div>
                <div class="screen-text">Màn Hình Chiếu Phim (SCREEN)</div>

                <c:choose>
                    <c:when test="${empty seats}">
                        <div class="empty-state" style="padding: 40px 0;">
                            <i class="fa-solid fa-border-none" style="font-size: 32px;"></i>
                            <p style="font-size: 14px;">Chưa có sơ đồ ghế nào được thiết lập cho phòng chiếu này.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="cinema-map" id="cinemaMapContainer">
                            <c:forEach var="seat" items="${seats}">
                                <c:set var="status" value="${seatStatusMap[seat.id]}" />
                                <c:choose>
                                    <c:when test="${status == 'SUCCESS'}">
                                        <div class="seat-box seat-status-success" title="Mã ghế: ${seat.seatName} (Đã mua thành công)">
                                            ${seat.seatName}
                                        </div>
                                    </c:when>
                                    <c:when test="${status == 'PENDING'}">
                                        <div class="seat-box seat-status-pending" title="Mã ghế: ${seat.seatName} (Đang chờ thanh toán)">
                                            ${seat.seatName}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="seat-box" title="Mã ghế: ${seat.seatName} (Còn trống)">
                                            ${seat.seatName}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>

                        <div class="map-legend">
                            <div class="legend-item">
                                <div class="seat-box" style="width: 16px; height: 16px; background-color: #334155; pointer-events: none;"></div>
                                <span>Còn trống</span>
                            </div>
                            <div class="legend-item">
                                <div class="seat-box seat-status-pending" style="width: 16px; height: 16px; pointer-events: none;"></div>
                                <span>Đang chờ thanh toán (Cam)</span>
                            </div>
                            <div class="legend-item">
                                <div class="seat-box seat-status-success" style="width: 16px; height: 16px; pointer-events: none;"></div>
                                <span>Đã mua / Đã đặt (Đỏ)</span>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </c:otherwise>
</c:choose>

<script>
    function switchRoom(roomId) {
        if (roomId) {
            window.location.href = "${pageContext.request.contextPath}/admin/seat-manage?roomId=" + roomId;
        } else {
            window.location.href = "${pageContext.request.contextPath}/admin/seat-manage";
        }
    }

    // JS CHUYỂN ĐỔI SUẤT CHIẾU ĐỂ THEO DÕI TRẠNG THÁI GHẾ REAL-TIME
    function switchShowtime(showtimeId) {
        var roomId = "${param.roomId}";
        var url = "${pageContext.request.contextPath}/admin/seat-manage?roomId=" + roomId;
        if (showtimeId) {
            url += "&showtimeId=" + showtimeId;
        }
        window.location.href = url;
    }

    // Tự động sắp xếp ma trận ghế bằng CSS Grid (Giữ nguyên logic gốc)
    document.addEventListener("DOMContentLoaded", function () {
        var mapContainer = document.getElementById("cinemaMapContainer");

        if (mapContainer) {
            var seats = mapContainer.querySelectorAll('.seat-box');
            if (seats.length > 0) {
                // Bước 1: Tìm xem hàng đầu tiên (VD: hàng A) có bao nhiêu ghế để lấy làm số Cột
                var firstLetter = seats[0].innerText.trim().charAt(0);
                var cols = 0;

                for (var i = 0; i < seats.length; i++) {
                    if (seats[i].innerText.trim().charAt(0) === firstLetter) {
                        cols++;
                    } else {
                        break; // Sang hàng B thì dừng đếm
                    }
                }

                // Bước 2: Ép sơ đồ hiển thị theo dạng Grid với số cột đã tính
                mapContainer.style.display = "grid";
                mapContainer.style.gridTemplateColumns = "repeat(" + cols + ", 42px)"; // 42px là độ rộng mỗi ghế
                mapContainer.style.gap = "10px";
                mapContainer.style.justifyContent = "center";
            }
        }
    });
</script>