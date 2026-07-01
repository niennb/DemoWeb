<%-- 
    Document   : header
    Created on : 17 thg 6, 2026, 19:24:16
    Author     : baoni
--%>

<%-- WEB-INF/views/layout/header.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header>
    <div class="container header-wrapper">
        <div class="logo"><a href="${pageContext.request.contextPath}/">Alpha<span>Cinema</span></a></div>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/">Trang Chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/movie">Phim</a></li>
                <li><a href="${pageContext.request.contextPath}/uudai">Ưu đãi</a></li>
                <li><a href="${pageContext.request.contextPath}/about">Về Chúng Tôi</a></li>
            </ul>
        </nav>

        <c:choose>
            <%-- Nếu user chưa đăng nhập (user == null) --%>
            <c:when test="${empty user}">
                <div class="auth-buttons">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng Nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng Ký</a>
                </div>
            </c:when>
            
            <%-- Nếu user ĐÃ đăng nhập --%>
            <c:otherwise>
                <div class="user-profile-wrapper" id="profileWrapper">
                    <div class="user-avatar-btn">
                        <svg class="fb-avatar-svg" viewBox="0 0 24 24">
                            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                        <span class="user-name"><c:out value="${user.username}" /></span>
                    </div>

                    <div class="profile-dropdown" id="profileDropdown">
                        <%-- ĐIỀU KIỆN KIỂM TRA QUYỀN ADMIN --%>
                        <c:if test="${user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" 
                               style="color: #fb923c; font-weight: bold; border-bottom: 1px solid #334155;">
                                🛠️ Trang Quản Trị
                            </a>
                        </c:if>
                        
                        <a href="${pageContext.request.contextPath}/profile">Thông tin cá nhân</a>
                        <a href="${pageContext.request.contextPath}/history">Lịch sử đặt vé</a>
                        <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const profileWrapper = document.getElementById('profileWrapper');
            const profileDropdown = document.getElementById('profileDropdown');

            if (profileWrapper) {
                profileWrapper.addEventListener('click', (e) => {
                    e.stopPropagation();
                    profileDropdown.classList.toggle('show');
                });

                document.addEventListener('click', () => {
                    profileDropdown.classList.remove('show');
                });
            }
        });
    </script>
</header>
