<%-- 
    Document   : movie-detail
    Created on : 18 thg 6, 2026, 01:02:41
    Author     : baoni
--%>
<%-- 1. GIỮ LẠI: Các thẻ khai báo taglib ở đầu file để trang con vẫn hiểu được cú pháp JSTL --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 2. GIỮ LẠI: Dòng này để truyền tiêu đề phim lên cho layout/main.jsp bắt lấy và hiển thị ở thẻ <title> --%>
<c:set var="pageTitle" value="${movie.name} - AlphaCinema" scope="request"/>

<%-- 3. GIỮ LẠI: Đoạn <style> riêng của trang chi tiết (nếu bạn chưa tách ra file .css riêng) --%>
<style>
    .detail-box {
        background: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .movie-top {
        display: flex;
        gap: 30px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }

    .movie-poster {
        width: 300px;
        height: 420px;
        object-fit: cover;
        border-radius: 10px;
    }

    .movie-info {
        flex: 1;
        min-width: 300px;
    }

    .movie-info h1 {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 20px;
        color: var(--text-light);
    }

    .movie-info p {
        margin-bottom: 15px;
        font-size: 16px;
        color: var(--text-light);
    }

    .movie-info p strong {
        color: var(--text-muted);
        font-weight: 500;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: var(--text-light);
        margin-bottom: 15px;
        position: relative;
        padding-bottom: 5px;
    }

    .movie-description {
        margin-top: 40px;
        line-height: 1.8;
        color: var(--text-muted);
    }

    .movie-trailer {
        margin-top: 40px;
    }

    .movie-trailer iframe {
        border-radius: 10px;
        border: 1px solid var(--border-color);
    }

    /* 🔥 ĐÃ SỬA: Nút viền cam, chữ cam, nền trong suốt hoàn hảo */
    .btn-booking {
        display: inline-block;
        margin-top: 25px;
        background-color: transparent;         /* Nền trong suốt */
        color: var(--accent-orange) !important; /* Chữ màu cam */
        border: 2px solid var(--accent-orange); /* Chỉ lấy khung viền màu cam */
        padding: 14px 38px;                     /* Padding giữ nút cân đối */
        font-size: 18px;                        /* Chữ to rõ nét */
        font-weight: 700;                       /* Chữ đậm */
        border-radius: 8px;                     /* Bo góc */
        transition: all 0.3s ease;
    }
    .btn-disabled{
        background: #555;
        border: 2px solid #555;
        color: #ddd;
        cursor: not-allowed;
    }

    .btn-disabled:hover{
        background: #555;
        color: #ddd;
    }

    /* Hiệu ứng khi di chuột qua: Đổ đầy nền cam, chữ chuyển sang trắng */
    .btn-booking:hover {
        background-color: var(--accent-orange);
        color: white !important;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(255, 91, 0, 0.4);
    }
</style>

<%-- 4. PHẦN NỘI DUNG CHÍNH: Chỉ giữ lại các thẻ <div> chứa giao diện hiển thị --%>
<div class="container movie-detail-section" style="padding: 40px 0;">
    <div class="detail-box">
        <div class="movie-top">

            <%-- ĐÃ SỬA: Thêm contextPath vào nguồn ảnh để không bị mất poster khi URL thay đổi --%>
            <img src="${pageContext.request.contextPath}${movie.poster}" alt="Poster Phim" class="movie-poster">

            <div class="movie-info">
                <h1><c:out value="${movie.name}" /></h1>
                <p><strong>Thể loại:</strong> <span><c:out value="${movie.genre}" /></span></p>
                <p><strong>Thời lượng:</strong> <span><c:out value="${movie.duration}" /></span> phút</p>
                <p>
                    <strong>Giá vé:</strong> 
                    <fmt:formatNumber value="${movie.price}" type="number" pattern="#,##0" /> VNĐ
                </p>

                <%-- Điều kiện 1: Nếu phim ĐANG CHIẾU -> Cho phép bấm ĐẶT VÉ --%>
                <c:if test="${movie.status == 'Đang chiếu'}">
                    <a href="${pageContext.request.contextPath}/booking/${movie.id}" class="btn-booking">
                        ĐẶT VÉ
                    </a>
                </c:if>

                <%-- Điều kiện 2: Nếu phim SẮP CHIẾU -> Khóa nút đặt vé --%>
                <c:if test="${movie.status == 'Sắp chiếu'}">
                    <button class="btn-booking btn-disabled" disabled>
                        SẮP KHỞI CHIẾU
                    </button>
                </c:if>
            </div>
        </div>

        <%-- Phần Nội dung phim --% bounds --%>
        <div class="movie-description">
            <h2 class="section-title">Nội Dung Phim</h2>
            <p><c:out value="${movie.description}" /></p>
        </div>

        <%-- Phần Trailer phim --%>
        <div class="movie-trailer">
            <h2 class="section-title">Trailer</h2>
            <iframe src="${movie.trailerUrl}" width="100%" height="500" style="border:none; border-radius:12px;"></iframe>
        </div>
    </div>
</div>
