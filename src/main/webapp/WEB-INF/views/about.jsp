<%-- 
    Document   : about
    Created on : 18 thg 6, 2026, 01:01:40
    Author     : baoni
--%>
<%-- WEB-INF/views/about.jsp --%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<style>
    .about-section {
        padding: 60px 0;
        min-height: calc(100vh - 70px - 150px);
    }

    .about-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 40px;
        align-items: start;
    }

    @media (max-width: 768px) {
        .about-grid {
            grid-template-columns: 1fr;
        }
    }

    .about-info {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 40px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .about-info h2 {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .about-info h2 span {
        color: var(--accent-orange);
    }

    .about-info .subtitle {
        color: var(--text-muted);
        font-size: 15px;
        margin-bottom: 25px;
        font-style: italic;
    }

    .about-info p {
        margin-bottom: 20px;
        color: #cbd5e1;
        font-size: 15px;
        text-align: justify;
    }

    .contact-details {
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid var(--border-color);
    }

    .contact-item {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 12px;
        font-size: 15px;
    }

    .contact-item strong {
        color: var(--accent-orange);
        min-width: 80px;
    }

    /* MAP WRAPPER */
    .about-map {
        background-color: var(--card-bg);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        height: 100%;
        min-height: 450px;
        display: flex;
        flex-direction: column;
    }

    .about-map h3 {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 15px;
        padding-left: 5px;
    }

    .map-container {
        flex: 1;
        border-radius: 8px;
        overflow: hidden;
        border: 1px solid var(--border-color);
    }

    .map-container iframe {
        width: 100%;
        height: 100%;
        min-height: 400px;
        display: block;
    }
</style>

<main class="container about-section">
    <div class="about-grid">
        <div class="about-info">
            <h2>Về <span>AlphaCinema</span></h2>
            <p class="subtitle">Hệ thống rạp chiếu phim hàng đầu cho giới trẻ</p>

            <p>
                Chào mừng bạn đến với <strong>AlphaCinema</strong>, điểm hẹn giải trí công nghệ cao và đỉnh cao nghệ thuật điện ảnh.
                Chúng tôi tự hào mang đến cho khán giả những trải nghiệm xem phim tuyệt vời nhất với hệ thống phòng chiếu hiện đại,
                âm thanh vòm chuẩn quốc tế và màn hình lớn cực nét.
            </p>
            <p>
                Không chỉ dừng lại ở dịch vụ trình chiếu phim chất lượng, AlphaCinema còn xây dựng không gian tiện ích sáng tạo,
                đội ngũ phục vụ chuyên nghiệp, tận tâm để mỗi phút giây của bạn tại rạp đều trở thành những khoảnh khắc đáng nhớ.
            </p>

            <div class="contact-details">
                <div class="contact-item">
                    <strong>Địa chỉ:</strong>
                    <span>141 Điện Biên Phủ, Quận Bình Thạnh, TP. Hồ Chí Minh</span>
                </div>
                <div class="contact-item">
                    <strong>Hotline:</strong>
                    <span>1900 123X (8:00 - 24:00)</span>
                </div>
                <div class="contact-item">
                    <strong>Email:</strong>
                    <span>contact@alphacinema.com</span>
                </div>
            </div>
        </div>

        <div class="about-map">
            <h3>Vị Trí Rạp Chiếu Phim</h3>
            <div class="map-container">
                <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.319357065355!2d106.70327317480504!3d10.786638789360879!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f4c4786438f%3A0x8670846067b84f3c!2s141%20%C4%90i%E1%BB%87n%20Bi%C3%AAn%20Ph%E1%BB%A7%2C%20%C4%90a%20Kao%2C%20Qu%E1%BA%ADn%201%2C%20H%E1%BB%93%20Ch%C3%AD%20Minh!5e0!3m2!1svi!2svn!4v1718700000000"
                    style="border:0;"
                    allowfullscreen=""
                    loading="lazy">
                </iframe>
            </div>
        </div>
    </div>
</main>
