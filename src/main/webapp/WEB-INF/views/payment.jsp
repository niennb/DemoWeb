<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Đưa tiêu đề lên layout/main.jsp --%>
<c:set var="pageTitle" value="Thanh Toán Đơn Hàng - AlphaCinema" scope="request"/>

<main class="container" style="padding: 40px 0; margin-top: 80px;">
    <div style="max-width: 900px; margin: 0 auto; background: var(--card-bg); border: 1px solid var(--border-color); border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);">
        <h2 style="text-align: center; margin-bottom: 30px; color: var(--accent-orange); font-size: 28px;">XÁC NHẬN THANH TOÁN</h2>

        <div style="display: flex; gap: 40px; margin-bottom: 30px; flex-wrap: wrap;">
            <%-- CỘT TRÁI: Thông tin chi tiết vé --%>
            <div style="flex: 1; min-width: 300px; background: rgba(0,0,0,0.2); padding: 25px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.05);">
                <h3 style="margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px; font-size: 18px;">Chi Tiết Đơn Hàng #<c:out value="${ticket.id}" /></h3>
                
                <div style="margin-bottom: 15px;">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Phim</p>
                    <p style="font-weight: 600; font-size: 18px;"><c:out value="${ticket.movie.name}" /></p>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Suất chiếu</p>
                    <p style="font-weight: 600;"><c:out value="${ticket.showtime.startTime}" /> - <c:out value="${ticket.showtime.showDate}" /></p>
                </div>

                <div style="margin-bottom: 15px;">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Phòng chiếu</p>
                    <p style="font-weight: 600;"><c:out value="${ticket.showtime.room.roomName}" /></p>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Ghế đã chọn</p>
                    <p style="font-weight: 600; color: var(--accent-orange);">
                        <c:forEach var="seat" items="${ticket.seats}" varStatus="status">
                            <c:out value="${seat.seatName}"/><c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                    </p>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Người đặt</p>
                    <p style="font-weight: 600;"><c:out value="${user.username}" /> (<c:out value="${user.email}" />)</p>
                </div>
                
                <div style="margin-top: 25px; padding-top: 20px; border-top: 1px dashed var(--border-color);">
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 4px;">Tổng Tiền Thanh Toán</p>
                    <p style="color: #10b981; font-weight: 700; font-size: 28px;">
                        <fmt:formatNumber value="${ticket.totalPrice}" type="number" pattern="#,##0" /> VNĐ
                    </p>
                </div>
            </div>

            <%-- CỘT PHẢI: Form chọn phương thức thanh toán --%>
            <div style="flex: 1; min-width: 300px;">
                <h3 style="margin-bottom: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 10px; font-size: 18px;">Chọn Phương Thức Thanh Toán</h3>
                
                <form action="${pageContext.request.contextPath}/payment/process" method="post">
                    <%-- Gửi ẩn ticketId lên server để xử lý cập nhật trạng thái --%>
                    <input type="hidden" name="ticketId" value="${ticket.id}" />
                    
                    <div style="margin-bottom: 15px;">
                        <label class="payment-method-label" style="display: flex; align-items: center; padding: 18px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 8px; cursor: pointer; transition: 0.3s;">
                            <input type="radio" name="paymentMethod" value="CASH" required style="margin-right: 15px; width: 18px; height: 18px; accent-color: var(--accent-orange);"> 
                            <span style="font-weight: 500;">Thanh toán tại quầy (Tiền mặt)</span>
                        </label>
                    </div>
                    
                    <div style="margin-bottom: 15px;">
                        <label class="payment-method-label" style="display: flex; align-items: center; padding: 18px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 8px; cursor: pointer; transition: 0.3s;">
                            <input type="radio" name="paymentMethod" value="VNPAY" required style="margin-right: 15px; width: 18px; height: 18px; accent-color: var(--accent-orange);"> 
                            <span style="font-weight: 500;">Thanh toán qua VNPay</span>
                        </label>
                    </div>
                    
                    <div style="margin-bottom: 30px;">
                        <label class="payment-method-label" style="display: flex; align-items: center; padding: 18px; background: rgba(255,255,255,0.03); border: 1px solid var(--border-color); border-radius: 8px; cursor: pointer; transition: 0.3s;">
                            <input type="radio" name="paymentMethod" value="MOMO" required style="margin-right: 15px; width: 18px; height: 18px; accent-color: var(--accent-orange);"> 
                            <span style="font-weight: 500;">Thanh toán qua Ví Momo</span>
                        </label>
                    </div>

                    <button type="submit" style="width: 100%; padding: 16px; background-color: var(--accent-orange); color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; transition: background 0.3s; box-shadow: 0 4px 12px rgba(255, 91, 0, 0.3);">
                        TIẾN HÀNH THANH TOÁN
                    </button>
                    
                    <div style="text-align: center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); font-size: 14px; text-decoration: none; transition: 0.3s;" onmouseover="this.style.color='#fff'" onmouseout="this.style.color='var(--text-muted)'">
                            Hủy giao dịch và về Trang Chủ
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<style>
    /* CSS bổ sung để highlight khi hover/chọn phương thức thanh toán */
    .payment-method-label:hover {
        background: rgba(255, 91, 0, 0.05) !important;
        border-color: var(--accent-orange) !important;
    }
    /* Style khi radio được check */
    .payment-method-label:has(input[type="radio"]:checked) {
        background: rgba(255, 91, 0, 0.1) !important;
        border-color: var(--accent-orange) !important;
    }
    .payment-method-label:has(input[type="radio"]:checked) span {
        color: var(--accent-orange);
    }
</style>
