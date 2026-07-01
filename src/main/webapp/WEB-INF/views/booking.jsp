<%-- 
    Document   : booking
    Created on : 18 thg 6, 2026, 01:02:04
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Đặt Vé: ${movie.name} - AlphaCinema" scope="request"/>
<style>
    .bk-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
    }

    .bk-grid {
        display: grid;
        grid-template-columns: 1fr 360px;
        gap: 40px;
        align-items: start;
    }

    @media (max-width: 992px) {
        .bk-grid {
            grid-template-columns: 1fr;
        }
    }

    .bk-main-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .bk-movie-title {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 30px;
        color: var(--text-light);
        border-left: 4px solid var(--accent-orange);
        padding-left: 14px;
    }

    .bk-section-title {
        font-size: 15px;
        font-weight: 600;
        margin-bottom: 18px;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 1.5px;
    }

    /* Suất chiếu */
    .bk-showtimes-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 15px;
        margin-bottom: 40px;
    }

    .bk-showtime-item {
        position: relative;
    }

    .bk-showtime-item input[type="radio"] {
        position: absolute;
        opacity: 0;
        width: 0;
        height: 0;
    }

    .bk-showtime-label {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 14px;
        background-color: rgba(255, 255, 255, 0.02);
        border: 1px solid var(--border-color);
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.25s ease;
        text-align: center;
    }

    .bk-showtime-label:hover {
        border-color: var(--accent-orange);
        background-color: rgba(255, 91, 0, 0.04);
        transform: translateY(-2px);
    }

    .bk-showtime-item input[type="radio"]:checked + .bk-showtime-label {
        background-color: var(--accent-orange);
        border-color: var(--accent-orange);
        color: white;
        box-shadow: 0 4px 15px rgba(255, 91, 0, 0.3);
    }

    .bk-showtime-time {
        font-size: 16px;
        font-weight: 700;
    }

    .bk-showtime-date, .bk-showtime-room {
        font-size: 12px;
        opacity: 0.8;
        margin-top: 3px;
    }

    /* Sơ đồ ghế dạng Grid 5 cột */
    .bk-seat-map-wrapper {
        display: none;
        margin-top: 20px;
        text-align: center;
        animation: bkFadeIn 0.4s ease-out forwards;
    }

    .bk-seat-map-wrapper.active {
        display: block;
    }

    .bk-screen-container {
        perspective: 400px;
        margin: 25px auto 45px auto;
        width: 85%;
    }

    .bk-screen {
        background: linear-gradient(to bottom, rgba(255, 91, 0, 0.35), transparent);
        height: 12px;
        transform: rotateX(-15deg);
        border-radius: 50% / 100% 100% 0 0;
        box-shadow: 0 4px 20px rgba(255, 91, 0, 0.2);
    }

    .bk-screen-text {
        color: var(--text-muted);
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 5px;
        margin-top: 8px;
        display: block;
    }

    .bk-seat-grid {
        display: grid;
        grid-template-columns: repeat(5, 52px);
        gap: 14px;
        justify-content: center;
        margin: 25px auto;
    }

    .bk-seat {
        width: 52px;
        height: 46px;
        background-color: var(--seat-empty);
        border: 1px solid rgba(255, 255, 255, 0.03);
        color: var(--text-light);
        font-size: 14px;
        font-weight: 600;
        border-radius: 6px 6px 12px 12px;
        cursor: pointer;
        transition: all 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        outline: none;
    }

    .bk-seat:not(.booked):not(.pending):hover {
        background-color: #475569;
        transform: scale(1.06);
    }

    /* 1. GHẾ ĐANG CHỌN (Đổi thành màu Xanh lá) */
    .bk-seat.selected {
        background-color: #22c55e !important;
        color: white !important;
        box-shadow: 0 0 12px rgba(34, 197, 94, 0.6) !important;
        border-color: #22c55e !important;
    }

    /* 2. GHẾ ĐÃ ĐẶT - BOOKED (Đổi thành màu Đỏ) */
    .bk-seat.booked {
        background-color: #ef4444 !important;
        color: white !important;
        border: 1px solid #dc2626 !important;
        cursor: not-allowed !important;
        pointer-events: none !important;
        box-shadow: none !important;
        transform: none !important;
    }

    .bk-legend-container {
        display: flex;
        justify-content: center;
        gap: 25px;
        margin-top: 35px;
        padding-top: 20px;
        border-top: 1px solid rgba(255,255,255,0.05);
    }

    .bk-legend-item {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
        color: var(--text-muted);
    }

    .bk-legend-item .bk-seat-sample {
        width: 22px;
        height: 20px;
        border-radius: 4px;
    }

    /* Sidebar chi tiết hóa đơn */
    .bk-sidebar-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        position: sticky;
        top: 100px;
    }

    .bk-summary-title {
        font-size: 18px;
        font-weight: 700;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 15px;
        margin-bottom: 22px;
    }

    .bk-summary-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 16px;
        font-size: 14px;
    }

    .bk-summary-label {
        color: var(--text-muted);
    }

    .bk-summary-value {
        font-weight: 600;
        text-align: right;
        max-width: 60%;
    }

    .bk-summary-value.highlight {
        color: var(--accent-orange);
        word-break: break-all;
    }

    .bk-total-row {
        border-top: 1px dashed var(--border-color);
        padding-top: 18px;
        margin-top: 18px;
        align-items: center;
    }

    .bk-total-label {
        font-size: 16px;
        font-weight: 700;
    }

    .bk-total-price {
        font-size: 24px;
        font-weight: 700;
        color: #22c55e;
    }

    .bk-btn-confirm {
        width: 100%;
        background-color: var(--accent-orange);
        color: white;
        border: none;
        padding: 15px;
        font-size: 16px;
        font-weight: 600;
        border-radius: 8px;
        cursor: pointer;
        margin-top: 22px;
        transition: opacity 0.2s, transform 0.1s;
    }

    .bk-btn-confirm:hover {
        opacity: 0.9;
    }

    .bk-btn-confirm:disabled {
        background-color: var(--border-color);
        color: var(--text-muted);
        cursor: not-allowed;
        opacity: 0.6;
    }

    /* 3. GHẾ ĐANG CHỜ THANH TOÁN (Giữ nguyên màu Vàng chuẩn chỉnh) */
    .bk-seat.pending {
        background-color: #eab308 !important;
        border-color: #ca8a04 !important;
        color: #fff !important;
        cursor: not-allowed;
        opacity: 0.8;
    }
</style>



<main class="container bk-section">
    <form action="${pageContext.request.contextPath}/booking/confirm" method="post">

        <%-- Chỉ cần giữ lại showtimeId và danh sách ghế khách chọn --%>
        <input type="hidden" id="showtimeId" name="showtimeId" value="${showtime.id}" />
        <input type="hidden" id="selectedSeats" name="selectedSeats" value="" />

        <div class="bk-grid">
            <div class="bk-main-card">
                <h1 class="bk-movie-title"><c:out value="${movie.name}"/></h1>

                <%-- Hiển thị thông tin suất chiếu khách đã chọn từ trang trước --%>
                <div style="background: rgba(255, 255, 255, 0.05); padding: 15px; border-radius: 8px; margin-bottom: 25px; border: 1px solid var(--border-color);">
                    <p style="margin: 0; color: #cbd5e1;">
                        <strong style="color: var(--accent-orange);">Suất chiếu:</strong> 
                        ${showtime.showDate} | Ngày: <fmt:parseDate value="${showtime.showDate}" pattern="yyyy-MM-dd" var="parsedDate" /><fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                        | <strong>${showtime.room.roomName}</strong>
                    </p>
                </div>

                <div class="bk-seat-map-wrapper active" id="seatMapWrapper">
                    <h2 class="bk-section-title">Sơ Đồ Ghế Ngồi</h2>
                    <div class="bk-screen-container">
                        <div class="bk-screen"></div>
                        <span class="bk-screen-text">Màn hình chiếu</span>
                    </div>

                  
                    <div class="bk-seat-grid" id="seatGridContainer">
                        <c:forEach var="seatName" items="${allSeats}">
                            <c:choose>
                               
                                <c:when test="${bookedSeats.contains(seatName)}">
                                    <button type="button" class="bk-seat booked" disabled>${seatName}</button>
                                </c:when>

                               
                                <c:when test="${pendingSeats.contains(seatName)}">
                                    <button type="button" class="bk-seat pending" disabled>${seatName}</button>
                                </c:when>

                               
                                <c:otherwise>
                                    <button type="button" class="bk-seat empty">${seatName}</button>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>

                    <div class="bk-legend-container">
                        <div class="bk-legend-item">
                            <div class="bk-seat-sample" style="background-color: var(--seat-empty);"></div>
                            <span>Ghế Trống</span>
                        </div>
                        <div class="bk-legend-item">
                            <div class="bk-seat-sample" style="background-color: var(--seat-selected);"></div>
                            <span>Đang Chọn</span>
                        </div>
                        <div class="bk-legend-item">
                            <div class="bk-seat-sample" style="background-color: #eab308; border: 1px solid #ca8a04;"></div>
                            <span>Đang Giữ Chỗ</span>
                        </div>
                        <div class="bk-legend-item">
                            <div class="bk-seat-sample" style="background-color: var(--seat-booked); border: 1px solid var(--border-color);"></div>
                            <span>Đã Đặt</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bk-sidebar-card">
                <h3 class="bk-summary-title">Thông Tin Thanh Toán</h3>

                <%-- Vùng hiển thị lỗi khi khách mua trùng ghế --%>
                <c:if test="${not empty error}">
                    <div style="background-color: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 10px; border-radius: 6px; margin-bottom: 15px; border: 1px solid #ef4444; font-size: 14px;">
                        ⚠️ ${error}
                    </div>
                </c:if>

                <div class="bk-summary-row">
                    <span class="bk-summary-label">Phim</span>
                    <span class="bk-summary-value"><c:out value="${movie.name}"/></span>
                </div>

                <div class="bk-summary-row">
                    <span class="bk-summary-label">Suất Chiếu</span>
                    <span class="bk-summary-value">${showtime.showDate} - <fmt:formatDate value="${parsedDate}" pattern="dd/MM" /></span>
                </div>

                <div class="bk-summary-row">
                    <span class="bk-summary-label">Ghế Đã Chọn</span>
                    <span class="bk-summary-value highlight" id="summarySeats">Chưa chọn</span>
                </div>

                <div class="bk-summary-row">
                    <span class="bk-summary-label">Số Lượng</span>
                    <span class="bk-summary-value" id="summaryCount">0 ghế</span>
                </div>

                <div class="bk-summary-row">
                    <span class="bk-summary-label">Giá Vé</span>
                    <span class="bk-summary-value">
                        <fmt:formatNumber value="${movie.price != null ? movie.price : 75000}" type="number" pattern="#,##0" /> VNĐ
                    </span>
                </div>

                <div class="bk-summary-row bk-total-row">
                    <span class="bk-total-label">Tổng Tiền</span>
                    <span class="bk-total-price" id="summaryTotal">0 VNĐ</span>
                </div>

                <button type="submit" class="bk-btn-confirm" id="btnSubmit" disabled>XÁC NHẬN ĐẶT VÉ</button>
            </div>
        </div>
    </form>
</main>

<script>
    (function () {
        const PRICE_PER_SEAT = ${movie.price != null ? movie.price : 75000};

        window.addEventListener('load', function () {
            const seats = document.querySelectorAll('.bk-seat-grid .bk-seat');
            const selectedSeatsInput = document.getElementById('selectedSeats');
            const summarySeats = document.getElementById('summarySeats');
            const summaryCount = document.getElementById('summaryCount');
            const summaryTotal = document.getElementById('summaryTotal');
            const btnSubmit = document.getElementById('btnSubmit');
            const seatGrid = document.getElementById("seatGridContainer");

            // THUẬT TOÁN TỰ ĐỘNG TÍNH CỘT CHUẨN THEO SEAT-MANAGE
            if (seats.length > 0) {
                let maxSeatNumber = 0;

                seats.forEach(seat => {
                    const text = seat.innerText.trim();
                    // Dùng Regex lấy phần số ở cuối tên ghế (Ví dụ: "A10" -> 10, "B4" -> 4)
                    const numMatch = text.match(/\d+$/);
                    if (numMatch) {
                        const num = parseInt(numMatch[0], 10);
                        if (num > maxSeatNumber) {
                            maxSeatNumber = num;
                        }
                    }
                });

                // Nếu không tìm được số, mặc định lùi về đếm theo chữ cái hàng đầu tiên
                let cols = maxSeatNumber;
                if (cols === 0) {
                    const firstLetter = seats[0].innerText.trim().charAt(0);
                    for (let i = 0; i < seats.length; i++) {
                        if (seats[i].innerText.trim().charAt(0) === firstLetter) {
                            cols++;
                        } else {
                            break;
                        }
                    }
                }

                // Ép ma trận Grid hiển thị chuẩn xác
                seatGrid.style.display = "grid";
                seatGrid.style.gridTemplateColumns = "repeat(" + cols + ", 42px)";
                seatGrid.style.gap = "10px";
                seatGrid.style.justifyContent = "center";
            }

            // Xử lý sự kiện click chọn ghế
            seats.forEach(seat => {
                seat.addEventListener('click', function () {
                    if (this.classList.contains("booked") || this.classList.contains("pending")) {
                        return;
                    }
                    this.classList.toggle("selected");
                    updateSummaryAndForm();
                });
            });

            // Cập nhật thông tin giỏ hàng bên phải
            function updateSummaryAndForm() {
                const selectedSeatElements = document.querySelectorAll('.bk-seat-grid .bk-seat.selected');
                const seatNames = [...selectedSeatElements].map(s => s.innerText);

                selectedSeatsInput.value = seatNames.join(',');

                const totalCount = selectedSeatElements.length;
                const totalPrice = totalCount * PRICE_PER_SEAT;

                if (totalCount > 0) {
                    summarySeats.innerText = seatNames.join(', ');
                    summaryCount.innerText = totalCount + ' ghế';
                    summaryTotal.innerText = totalPrice.toLocaleString('vi-VN') + ' VNĐ';
                    btnSubmit.removeAttribute('disabled');
                } else {
                    summarySeats.innerText = 'Chưa chọn';
                    summaryCount.innerText = '0 ghế';
                    summaryTotal.innerText = '0 VNĐ';
                    btnSubmit.setAttribute('disabled', 'true');
                }
            }
        });
    })();
</script>
