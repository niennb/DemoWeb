<%-- 
    Document   : movie
    Created on : 28 thg 6, 2026, 20:38:07
    Author     : baoni
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- 1. Thiết lập tiêu đề trang cho layout main.jsp nhận diện --%>
<c:set var="pageTitle" value="Danh Sách Phim - AlphaCinema" scope="request"/>
<style>
    .movie-section {
        padding: 40px 0 60px 0;
    }
    .genre-block {
        margin-bottom: 50px;
    }
    .genre-title {
        font-size: 24px;
        font-weight: 700;
        color: var(--text-light);
        margin-bottom: 20px;
        border-left: 4px solid var(--accent-orange);
        padding-left: 15px;
        text-transform: uppercase;
    }

    /* GRID PHIM (GIỮ NGUYÊN) */
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


<%-- 2. Nội dung chính (Sẽ được tự động include vào phần <main> của main.jsp) --%>
<section class="container movie-section">

    <%-- 
        Duyệt qua Map dữ liệu 'moviesByGenre' từ Controller truyền xuống.
        - entry.key: Tên thể loại phim (Chuỗi)
        - entry.value: Danh sách (List) các bộ phim thuộc thể loại đó
    --%>
    <c:forEach var="entry" items="${moviesByGenre}">
        <div class="genre-block">
            <%-- Hiển thị tên Thể loại --%>
            <div class="genre-title">
                <c:out value="${entry.key}" />
            </div>

            <div class="movie-grid">
                <%-- Duyệt qua danh sách List các bộ phim nằm trong value của Map --%>
                <c:forEach var="movie" items="${entry.value}">
                    <div class="movie-card">
                        <%-- Poster phim --%>
                        <img src="${pageContext.request.contextPath}${movie.poster}" alt="Poster Phim" class="movie-poster">

                        <div class="movie-info">
                            <%-- Tên bộ phim --%>
                            <div class="movie-title">
                                <c:out value="${movie.name}" />
                            </div>

                            <div class="movie-meta">
                                <span><c:out value="${movie.genre}" /></span>
                                <span><c:out value="${movie.duration}" /> phút</span>
                            </div>

                            <%-- Đường dẫn chi tiết phim chuẩn Spring MVC (Sử dụng ContextPath và id phim) --%>
                            <a href="${pageContext.request.contextPath}/movie/${movie.id}" class="btn-detail">
                                CHI TIẾT
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:forEach>

</section>
