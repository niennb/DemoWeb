<%-- 
    Document   : uudai
    Created on : 28 thg 6, 2026, 20:38:30
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Ưu Đãi Tại Rạp - AlphaCinema" scope="request"/>

<style>
    .promo-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
    }

    .promo-header {
        margin-bottom: 40px;
    }

    .promo-header h2 {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .promo-header h2 span {
        color: var(--accent-orange);
    }

    .promo-header .subtitle {
        color: var(--text-muted);
        font-size: 15px;
        font-style: italic;
    }

    .promo-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
        gap: 30px;
        align-items: start;
    }

    @media (max-width: 768px) {
        .promo-grid {
            grid-template-columns: 1fr;
        }
    }

    .promo-card {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        transition: transform 0.3s ease, border-color 0.3s ease;
        display: flex;
        flex-direction: column;
        height: 100%;
    }

    .promo-card:hover {
        transform: translateY(-5px);
        border-color: var(--accent-orange);
    }

    .promo-image {
        width: 100%;
        height: 200px;
        background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        color: var(--text-light);
        border-bottom: 1px solid var(--border-color);
        position: relative;
        text-align: center;
        padding: 20px;
    }

    .promo-image .main-tag {
        font-size: 24px;
        font-weight: 800;
        color: var(--accent-orange);
        letter-spacing: 1px;
    }

    .promo-image .sub-tag {
        font-size: 13px;
        color: var(--text-muted);
        margin-top: 5px;
        text-transform: uppercase;
    }

    .promo-badge {
        position: absolute;
        top: 15px;
        left: 15px;
        background-color: #22c55e;
        color: white;
        padding: 4px 12px;
        border-radius: 50px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .promo-badge.orange {
        background-color: var(--accent-orange);
    }

    .promo-content {
        padding: 25px;
        flex: 1;
        display: flex;
        flex-direction: column;
    }

    .promo-content h3 {
        font-size: 19px;
        font-weight: 700;
        margin-bottom: 12px;
        color: var(--text-light);
    }

    .promo-content p {
        color: #cbd5e1;
        font-size: 14px;
        margin-bottom: 20px;
        text-align: justify;
        flex: 1;
    }

    .promo-footer {
        padding-top: 15px;
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 13px;
    }

    .promo-date {
        color: var(--text-muted);
    }

    .promo-date strong {
        color: var(--accent-orange);
        font-weight: 500;
    }

    .btn-detail {
        color: var(--accent-orange);
        font-weight: 600;
        transition: opacity 0.2s;
    }

    .btn-detail:hover {
        text-decoration: underline;
        opacity: 0.9;
    }
</style>

<%-- 3. Nội dung danh sách ưu đãi (Sẽ tự động đưa vào thẻ <main> của main.jsp) --%>
<div class="container promo-section">
    <h1 class="page-title">ƯU ĐÃI TẠI RẠP</h1>

    <div class="promo-grid">
        <div class="promo-card">
            <div class="promo-image">
                <span class="main-tag">COMBO GIẢM 25%</span>
                <span class="sub-tag">BẮP NƯỚC CỰC ĐÃ</span>
                <span class="promo-badge">HOT ƯU ĐÃI</span>
            </div>
            <div class="promo-content">
                <h3>Thưởng Thức Phim Hay - Nhận Ngay Ưu Đãi Combo Bắp Nước</h3>
                <p>
                    Khi quý khách mua gói Combo 2 Vé Phim bất kỳ kèm theo 1 Bắp Lớn + 2 Nước Ngọt ngay tại quầy bỏng nước, tổng hóa đơn sẽ được giảm trực tiếp 25%. Tiết kiệm tối đa chi phí cho buổi hẹn hò xem phim hoàn hảo.
                </p>
                <div class="promo-footer">
                    <span class="promo-date">Hạn dùng: <strong>Hàng ngày</strong></span>
                    <a href="#" class="btn-detail">Xem chi tiết</a>
                </div>
            </div>
        </div>

        <div class="promo-card">
            <div class="promo-image">
                <span class="main-tag">MEMBER DAY</span>
                <span class="sub-tag">THỨ HAI ĐẦU TIÊN CỦA THÁNG</span>
                <span class="promo-badge">THÀNH VIÊN</span>
            </div>
            <div class="promo-content">
                <h3>Ngày Thứ Hai Vui Vẻ - Đồng Giá 45K</h3>
                <p>
                    Vào ngày Thứ Hai đầu tiên của mỗi tháng, khách hàng thành viên khi quét mã thành viên tại quầy vé sẽ được mua vé với giá chỉ 45.000 VNĐ. Ngoài ra, bạn còn được nhân đôi điểm tích lũy AlphaPoint vào tài khoản.
                </p>
                <div class="promo-footer">
                    <span class="promo-date">Hạn dùng: <strong>Định kỳ tháng</strong></span>
                    <a href="#" class="btn-detail">Xem chi tiết</a>
                </div>
            </div>
        </div>

        <div class="promo-card">
            <div class="promo-image">
                <span class="main-tag">STUDENT WEEK</span>
                <span class="sub-tag">ƯU ĐÃI HỌC SINH SINH VIÊN</span>
                <span class="promo-badge">HSSV</span>
            </div>
            <div class="promo-content">
                <h3>Đồng Giá Vé 50K Dành Riêng Cho Học Sinh - Sinh Viên</h3>
                <p>
                    Từ thứ Hai đến thứ Sáu hàng tuần, học sinh, sinh viên dưới 22 tuổi xuất trình thẻ HSSV hợp lệ hoặc căn cước công dân tại quầy vé sẽ được áp dụng mức giá ưu đãi đồng giá 50.000 VNĐ/vé đối với tất cả các phim 2D.
                </p>
                <div class="promo-footer">
                    <span class="promo-date">Hạn dùng: <strong>Thứ 2 - Thứ 6</strong></span>
                    <a href="#" class="btn-detail">Xem chi tiết</a>
                </div>
            </div>
        </div>
    </div>
</div>
