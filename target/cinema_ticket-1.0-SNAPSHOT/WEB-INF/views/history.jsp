<%-- 
    Document   : history
    Created on : 28 thg 6, 2026, 20:35:38
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Lịch Sử Đặt Vé - AlphaCinema" scope="request"/>

<style>
    .hs-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
    }
    .hs-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }
    .hs-title {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 30px;
        color: var(--text-light);
        border-left: 4px solid var(--accent-orange);
        padding-left: 14px;
    }
    .hs-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        color: var(--text-light);
    }
    .hs-table th {
        text-align: left;
        padding: 15px;
        border-bottom: 2px solid var(--border-color);
        color: var(--text-muted);
    }
    .hs-table td {
        padding: 15px;
        border-bottom: 1px solid var(--border-color);
    }
    .hs-button {
        background-color: var(--accent-orange);
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        font-weight: 600;
        display: inline-block;
        transition: opacity 0.2s;
    }
    .hs-empty {
        text-align: center;
        padding: 60px 0;
        color: var(--text-muted);
    }
</style>
<%-- 2. Nội dung chính (Sẽ được include vào thẻ <main> của main.jsp) --%>
<div class="container hs-section">
    <div class="hs-card">
        <h1 class="hs-title">LỊCH SỬ ĐẶT VÉ</h1>

        <%-- Trường hợp 1: Có dữ liệu lịch sử đặt vé (histories không rỗng) --%>
        <c:if test="${not empty histories}">
            <table class="hs-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên phim</th>
                        <th>Thể loại</th>
                        <th>Ngày chiếu</th>
                        <th>Giờ chiếu</th>
                        <th>Phòng</th>
                        <th>Ghế</th>
                        <th>Số ghế</th>
                        <th>Tổng tiền</th>
                        <th>Ngày đặt</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Duyệt vòng lặp danh sách bằng JSTL, varStatus thay thế cho stat trong Thymeleaf --%>
                    <c:forEach var="item" items="${histories}" varStatus="stat">
                        <tr>
                            <td><c:out value="${stat.count}" /></td>
                            <td><c:out value="${item.movieName}" /></td>
                            <td><c:out value="${item.category}" /></td>
                            <td><c:out value="${item.showDate}" /></td>
                            <td><c:out value="${item.startTime}" /></td>
                            <td><c:out value="${item.room}" /></td>
                            <td><c:out value="${item.seats}" /></td>
                            <td><c:out value="${item.seatCount}" /></td>
                            <td>
                                <%-- Định dạng tiền tệ VNĐ hoặc in chuỗi thô kèm ký tự VNĐ --%>
                                <c:out value="${item.totalPrice} VNĐ" />
                            </td>
                            <td><c:out value="${item.bookingTime}" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <%-- Trường hợp 2: Chưa có lịch sử đặt vé (histories trống) --%>
        <c:if test="${empty histories}">
            <div class="hs-empty">
                <div style="font-size: 50px; margin-bottom: 20px;">📽️</div>
                <h3>Bạn chưa có lịch sử đặt vé.</h3>

                <%-- Sử dụng contextPath để link quay lại trang chủ chuẩn xác --%>
                <a href="${pageContext.request.contextPath}/" class="hs-button" style="margin-top: 20px;">
                    ĐẶT VÉ NGAY
                </a>
            </div>
        </c:if>
    </div>
</div>