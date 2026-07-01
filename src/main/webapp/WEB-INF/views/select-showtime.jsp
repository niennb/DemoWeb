<%-- 
    Document   : select-showtime
    Created on : 29 thg 6, 2026, 10:37:43
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Đưa tiêu đề động lên layout/main.jsp --%>
<c:set var="pageTitle" value="Chọn Suất Chiếu: ${movie.name} - AlphaCinema" scope="request"/>

<style>
    .st-section {
        padding: 50px 0;
        min-height: calc(100vh - 70px - 150px);
    }

    .st-grid {
        display: grid;
        grid-template-columns: 320px 1fr;
        gap: 40px;
        align-items: start;
    }

    @media (max-width: 992px) {
        .st-grid {
            grid-template-columns: 1fr;
        }
    }

    /* CARD BÊN TRÁI: THÔNG TIN PHIM */
    .st-movie-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        position: sticky;
        top: 20px;
    }

    .st-movie-poster {
        width: 100%;
        border-radius: 8px;
        aspect-ratio: 2/3;
        object-fit: cover;
        margin-bottom: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .st-movie-title {
        font-size: 22px;
        font-weight: 700;
        color: var(--text-light);
        margin-bottom: 12px;
        line-height: 1.3;
    }

    .st-movie-meta {
        font-size: 14px;
        color: var(--text-muted);
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    /* CARD BÊN PHẢI: LỊCH CHIẾU */
    .st-main-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .st-section-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-light);
        margin-bottom: 25px;
        border-left: 4px solid var(--accent-orange);
        padding-left: 12px;
    }

    /* Khung rỗng khi không có lịch chiếu */
    .st-empty-box {
        text-align: center;
        padding: 40px 20px;
        color: var(--text-muted);
    }
    .st-empty-box i {
        font-size: 48px;
        color: #475569;
        display: block;
        margin-bottom: 15px;
    }

    /* DANH SÁCH SUẤT CHIẾU */
    .st-day-group {
        border-bottom: 1px solid #334155;
        padding-bottom: 25px;
        margin-bottom: 25px;
    }
    .st-day-group:last-child {
        border-bottom: none;
        padding-bottom: 0;
        margin-bottom: 0;
    }

    .st-date-header {
        font-size: 16px;
        font-weight: 600;
        color: #fb923c; /* Màu cam sáng */
        margin-bottom: 15px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .st-time-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
        gap: 12px;
    }

    /* NÚT BẤM CHỌN GIỜ CHIẾU */
    .st-time-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background-color: #0f172a; /* Nền tối sâu */
        border: 1px solid var(--border-color);
        border-radius: 8px;
        padding: 12px 10px;
        color: var(--text-light);
        text-decoration: none;
        transition: all 0.2s ease;
        text-align: center;
    }

    .st-time-btn:hover {
        border-color: var(--accent-orange);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 91, 0, 0.2);
    }

    .st-time-btn .time-clock {
        font-size: 18px;
        font-weight: 700;
        color: var(--text-light);
    }

    .st-time-btn .room-name {
        font-size: 12px;
        color: var(--text-muted);
        margin-top: 4px;
    }
    /* NÚT BẤM BỊ KHÓA (KHI QUÁ GIỜ CHIẾU) */
    .st-time-btn.disabled {
        background-color: #1e293b; /* Nền tối hơn */
        border-color: #334155;
        color: #64748b; /* Chữ mờ đi */
        cursor: not-allowed; /* Đổi icon con trỏ chuột thành cấm */
        pointer-events: none; /* Ngăn chặn hoàn toàn hành vi click */
        opacity: 0.5;
        transform: none !important;
        box-shadow: none !important;
    }
</style>

<main class="container st-section">
    <div class="st-grid">

        <div class="st-movie-card">
            <c:choose>
                <c:when test="${not empty movie.poster}">
                    <img class="st-movie-poster" src="${pageContext.request.contextPath}${movie.poster}" alt="${movie.name}">
                </c:when>
                <c:otherwise>
                    <img class="st-movie-poster" src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500" alt="${movie.name}">
                </c:otherwise>
            </c:choose>

            <h2 class="st-movie-title"><c:out value="${movie.name}"/></h2>

            <div class="st-movie-meta">
                <span>🎭 Thể loại:</span>
                <strong style="color: #cbd5e1;"><c:out value="${movie.genre}"/></strong>
            </div>

            <div class="st-movie-meta">
                <span>⏱ Thời lượng:</span>
                <strong style="color: #cbd5e1;">${movie.duration} phút</strong>
            </div>

            <div class="st-movie-meta">
                <span>💵 Giá vé gốc:</span>
                <strong style="color: var(--accent-orange);">
                    <fmt:formatNumber value="${movie.price != null ? movie.price : 75000}" type="number" pattern="#,##0" /> VNĐ
                </strong>
            </div>
        </div>

        <div class="st-main-card">
            <h2 class="st-section-title">Vui lòng chọn Suất Chiếu</h2>

            <c:choose>
                <%-- TRƯỜNG HỢP: Phim chưa được lên lịch chiếu --%>
                <c:when test="${empty showtimes}">
                    <div class="st-empty-box">
                        <i>📅</i>
                        <p>Hiện tại bộ phim này chưa có suất chiếu nào khả dụng.</p>
                        <p style="font-size: 14px; margin-top: 5px;">Vui lòng quay lại sau hoặc chọn bộ phim khác!</p>
                        <a href="${pageContext.request.contextPath}/" 
                           style="display: inline-block; margin-top: 20px; color: var(--accent-orange); text-decoration: none; font-size: 14px; font-weight: 600;">
                            ← Quay về trang chủ
                        </a>
                    </div>
                </c:when>

                <%-- TRƯỜNG HỢP: Có suất chiếu khả dụng --%>
                <c:otherwise>
                    <%-- 1. Khai báo đối tượng lấy ngày giờ hiện tại của hệ thống --%>
                    <jsp:useBean id="now" class="java.util.Date" />

                    <c:set var="currentDate" value="" />

                    <c:forEach var="st" items="${showtimes}">
                        <%-- Định dạng ngày hiển thị (VD: 30/06/2026) --%>
                        <fmt:parseDate value="${st.showDate}" pattern="yyyy-MM-dd" var="parsedDate" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" var="formattedDate"/>

                        <%-- 2. Ghép Ngày + Giờ chiếu thành chuỗi để parse sang kiểu Date so sánh --%>
                        <%-- Lưu ý: Nếu st.startTime ở DB của bạn có cả giây (VD: 18:30:00) thì bạn đổi pattern thành "yyyy-MM-dd HH:mm:ss" nhé --%>
                        <c:set var="fullShowtimeStr" value="${st.showDate} ${st.startTime}" />
                        <fmt:parseDate value="${fullShowtimeStr}" pattern="yyyy-MM-dd HH:mm" var="fullShowtime" />

                        <%-- Nếu phát hiện sang một ngày mới, đóng block cũ và mở tiêu đề ngày mới --%>
                        <c:if test="${formattedDate != currentDate}">
                            <c:if test="${not empty currentDate}">
                            </div> </div> <%-- Đóng st-time-grid và st-day-group của ngày trước đó --%>
                        </c:if>

                    <c:set var="currentDate" value="${formattedDate}" />

                    <%-- Tạo dòng mới (Row) riêng biệt cho từng ngày chiếu --%>
                    <div class="st-day-group">
                        <div class="st-date-header">
                            <span>📅 Ngày chiếu:</span> <strong>${formattedDate}</strong>
                        </div>
                        <div class="st-time-grid">
                        </c:if>

                        <%-- 3. Kiểm tra điều kiện: Nếu (Ngày + Giờ Chiếu) < (Ngày + Giờ Hiện Tại) --%>
                        <c:choose>
                            <c:when test="${fullShowtime.time < now.time}">
                                <%-- Đổi từ thẻ <a> thành thẻ <span> để an toàn + thêm class disabled --%>
                                <span class="st-time-btn disabled" title="Suất chiếu này đã diễn ra">
                                    <span class="time-clock">${st.startTime}</span>
                                    <span class="room-name">${st.room.roomName}</span>
                                </span>
                            </c:when>
                            <c:otherwise>
                                <%-- Suất chiếu hợp lệ, cho phép click bình thường --%>
                                <a href="${pageContext.request.contextPath}/booking/seat?showtimeId=${st.id}" class="st-time-btn">
                                    <span class="time-clock">${st.startTime}</span>
                                    <span class="room-name">${st.room.roomName}</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Đóng các thẻ div còn sót lại sau khi kết thúc vòng lặp --%>
                    <c:if test="${not empty currentDate}">
                    </div>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

</div>
</main>
