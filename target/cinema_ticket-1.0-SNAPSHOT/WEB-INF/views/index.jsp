<%-- 
    Document   : index
    Created on : 18 thg 6, 2026, 01:02:19
    Author     : baoni
--%>

<%-- WEB-INF/views/index.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="AlphaCinema - Hệ Thống Rạp Chiếu Phim Giá Rẻ" scope="request"/>

<style>
    .hero-banner {
        background: linear-gradient(rgba(15, 23, 42, 0.4), rgba(15, 23, 42, 1)),
            url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=1200') no-repeat center center/cover;
        height: 450px;
        display: flex;
        align-items: center;
    }

    .hero-content h1 {
        font-size: 42px;
        font-weight: 700;
        margin-bottom: 10px;
    }
    .hero-content p {
        font-size: 18px;
        color: var(--text-muted);
        margin-bottom: 20px;
    }

    /* 3. MOVIE TABS */
    .movie-section {
        padding: 60px 0;
    }
    .movie-tabs {
        display: flex;
        gap: 20px;
        margin-bottom: 40px;
        border-bottom: 2px solid var(--border-color);
        padding-bottom: 10px;
    }
    .tab-item {
        font-size: 20px;
        font-weight: 700;
        cursor: pointer;
        color: var(--text-muted);
        position: relative;
        padding-bottom: 10px;
    }
    .tab-item.active {
        color: var(--text-light);
    }
    .tab-item.active::after {
        content: '';
        position: absolute;
        bottom: -12px;
        left: 0;
        width: 100%;
        height: 3px;
        background-color: var(--accent-orange);
    }

    /* GRID PHIM */
    .movie-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 30px;
    }
    .movie-card {
        background-color: var(--card-bg);
        border-radius: 12px;
        overflow: hidden;
        transition: transform 0.3s;
        border: 1px solid var(--border-color);
    }
    .movie-card:hover {
        transform: translateY(-5px);
    }
    .movie-poster {
        width: 100%;
        height: 360px;
        object-fit: cover;
        background-color: #0f172a;
    }
    .movie-info {
        padding: 20px;
    }
    .movie-title {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 8px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .movie-meta {
        font-size: 13px;
        color: var(--text-muted);
        margin-bottom: 15px;
        display: flex;
        justify-content: space-between;
    }
    .btn-booking {
        display: block;
        text-align: center;
        background-color: transparent;
        color: var(--accent-orange);
        border: 2px solid var(--accent-orange);
        padding: 10px;
        border-radius: 6px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .btn-booking:hover {
        background-color: var(--accent-orange);
        color: white;
    }
</style>

<section class="hero-banner">
    <div class="container">
        <div class="hero-content">
            <h1>Trải Nghiệm Điện Ảnh Đỉnh Cao</h1>
            <p>Hệ thống rạp chiếu phim hiện đại, âm thanh sống động cùng kho tàng phim bom tấn mới nhất đang chờ đón bạn.</p>
            <a href="#now-showing" class="btn-cta">
                Đặt Vé Ngay 
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
            </a>
        </div>
    </div>
</section>

<section id="now-showing" class="container movie-section">
    <div class="movie-tabs">
        <div class="tab-item active">PHIM ĐANG CHIẾU</div>
    </div>

    <div class="movie-grid">
        <%-- Duyệt danh sách các bộ phim có trạng thái 'Đang chiếu' --%>
        <c:forEach var="movie" items="${movies}">
            <c:if test="${movie.status == 'Đang chiếu'}">
                <div class="movie-card">
                    <%-- Sử dụng c:url để Spring tự nhận diện chính xác thư mục resources trong app --%>
                    <img src="${pageContext.request.contextPath}${movie.poster}" alt="Poster Phim" class="movie-poster">

                    <div class="movie-info">
                        <%-- Tên phim --%>
                        <div class="movie-title">
                            <c:out value="${movie.name}" />
                        </div>

                        <%-- Siêu dữ liệu (Thể loại, thời lượng) --%>
                        <div class="movie-meta">
                            <span><c:out value="${movie.genre}" /></span>
                            <span><c:out value="${movie.duration} phút" /></span>
                        </div>

                        <%-- Nút xem chi tiết phim --%>
                        <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="btn-booking">
                            Xem Chi Tiết
                        </a>
                    </div>
                </div>
            </c:if>
        </c:forEach>
    </div>
</section>

<section class="container movie-section">
    <div class="movie-tabs">
        <div class="tab-item active">PHIM SẮP CHIẾU</div>
    </div>

    <div class="movie-grid">
        <%-- Lọc và duyệt danh sách các bộ phim có trạng thái 'Sắp chiếu' --%>
        <c:forEach var="movie" items="${movies}">
            <c:if test="${movie.status == 'Sắp chiếu'}">
                <div class="movie-card">
                    <%-- Sử dụng c:url để load ảnh --%>
                    <img src="${pageContext.request.contextPath}${movie.poster}" alt="Poster Phim" class="movie-poster">

                    <div class="movie-info">
                        <%-- Tên phim --%>
                        <div class="movie-title">
                            <c:out value="${movie.name}" />
                        </div>

                        <%-- Siêu dữ liệu (Thể loại, thời lượng) --%>
                        <div class="movie-meta">
                            <span><c:out value="${movie.genre}" /></span>
                            <span><c:out value="${movie.duration} phút" /></span>
                        </div>

                        <%-- Nút xem chi tiết phim --%>
                        <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="btn-booking">
                            Xem Chi Tiết
                        </a>
                    </div>
                </div>
            </c:if>
        </c:forEach>
    </div>
</section>