<%-- 
    Document   : dashboard
    Created on : 26 thg 6, 2026
    Author     : baoni
    Description: Bảng điều khiển trung tâm (Admin Dashboard) hiển thị số liệu thực tế.
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    /* CSS CƠ BẢN ĐỒNG BỘ DARK THEME */
    .page-title h2 {
        font-size: 24px;
        font-weight: 700;
        color: #f8fafc;
        margin: 0;
    }
    .page-title p {
        font-size: 14px;
        color: #94a3b8;
        margin-top: 4px;
        margin-bottom: 25px;
    }

    /* LƯỚI GRID BỐ CỤC CHUNG */
    .dash-grid {
        display: grid;
        gap: 20px;
        margin-bottom: 20px;
    }
    .grid-4 {
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    }
    .grid-2 {
        grid-template-columns: repeat(auto-fit, minmax(450px, 1fr));
    }

    /* THẺ THỐNG KÊ (KPI CARD) */
    .kpi-card {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .kpi-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3);
    }
    .kpi-info .kpi-label {
        font-size: 13px;
        font-weight: 600;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 6px;
    }
    .kpi-info .kpi-value {
        font-size: 24px;
        font-weight: 700;
        color: #f8fafc;
    }
    .kpi-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }

    /* ĐỊNH DẠNG KHUNG PANEL CHỨA ĐỒ THỊ / BẢNG BIỂU */
    .dash-panel {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 12px;
        padding: 20px;
        display: flex;
        flex-direction: column;
    }
    .panel-header {
        font-size: 16px;
        font-weight: 600;
        color: #f8fafc;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }
    .chart-container {
        position: relative;
        width: 100%;
        height: 280px;
    }

    /* ĐỊNH DẠNG BẢNG BIỂU TINH GỌN (TABLE CUSTOM) */
    .dash-table {
        width: 100%;
        border-collapse: collapse;
    }
    .dash-table th {
        text-align: left;
        padding: 10px 12px;
        font-size: 12px;
        font-weight: 600;
        color: #64748b;
        text-transform: uppercase;
        border-bottom: 1px solid #334155;
    }
    .dash-table td {
        padding: 12px;
        font-size: 14px;
        color: #e2e8f0;
        border-bottom: 1px solid #334155;
    }
    .dash-table tr:last-child td {
        border-bottom: none;
    }

    /* DANH SÁCH HOẠT ĐỘNG / LỊCH CHIẾU (LIST STYLES) */
    .dash-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .dash-list li {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 0;
        border-bottom: 1px solid #334155;
    }
    .dash-list li:last-child {
        border-bottom: none;
    }
    .text-main {
        font-size: 14px;
        font-weight: 500;
        color: #e2e8f0;
    }
    .text-sub {
        font-size: 12px;
        color: #64748b;
        margin-top: 2px;
    }
</style>

<div class="container-fluid px-4">
    <div class="page-title">
        <h2>Tổng Quan Hệ Thống</h2>
        <p>Báo cáo tổng hợp tình hình doanh thu và vận hành phòng chiếu thời gian thực</p>
    </div>

    <div class="dash-grid grid-4">
        <div class="kpi-card">
            <div class="kpi-info">
                <div class="kpi-label">Tổng Doanh Thu</div>
                <div class="kpi-value">
                    <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="" maxFractionDigits="0"/> đ
                </div>
            </div>
            <div class="kpi-icon" style="background: rgba(16, 185, 129, 0.1); color: #10b981;">
                <i class="fa-solid fa-wallet"></i>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-info">
                <div class="kpi-label">Vé Bán Hôm Nay</div>
                <div class="kpi-value">${ticketsToday != null ? ticketsToday : 0} vé</div>
            </div>
            <div class="kpi-icon" style="background: rgba(59, 130, 246, 0.1); color: #3b82f6;">
                <i class="fa-solid fa-ticket"></i>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-info">
                <div class="kpi-label">Khách Hàng</div>
                <div class="kpi-value">${totalCustomers != null ? totalCustomers : 0} user</div>
            </div>
            <div class="kpi-icon" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b;">
                <i class="fa-solid fa-users"></i>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-info">
                <div class="kpi-label">Phim Đang Chiếu</div>
                <div class="kpi-value">${showingMovies != null ? showingMovies : 0} phim</div>
            </div>
            <div class="kpi-icon" style="background: rgba(139, 92, 246, 0.1); color: #8b5cf6;">
                <i class="fa-solid fa-film"></i>
            </div>
        </div>
    </div>

    <div class="dash-grid" style="grid-template-columns: 1fr;">
        <div class="dash-panel">
            <div class="panel-header">
                <span><i class="fa-solid fa-chart-line me-2 text-warning"></i> Xu Hướng Doanh Thu (7 Ngày Qua)</span>
            </div>
            <div class="chart-container">
                <canvas id="revenueLineChart"></canvas>
            </div>
        </div>
    </div>

    <div class="dash-grid grid-2">
        <div class="dash-panel">
            <div class="panel-header"><span><i class="fa-solid fa-chart-pie me-2 text-info"></i> Doanh Thu Theo Phim</span></div>
            <div class="chart-container">
                <canvas id="movieDoughnutChart"></canvas>
            </div>
        </div>

        <div class="dash-panel">
            <div class="panel-header"><span><i class="fa-solid fa-chart-gantt me-2 text-success"></i> Doanh Thu Theo Thể Loại</span></div>
            <div class="chart-container">
                <canvas id="genreDoughnutChart"></canvas>
            </div>
        </div>
    </div>

    <div class="dash-grid grid-2">
        <div class="dash-panel">
            <div class="panel-header"><i class="fa-solid fa-trophy me-2 text-warning"></i> Top 5 Phim Có Doanh Thu Cao Nhất</div>
            <table class="dash-table">
                <thead>
                    <tr>
                        <th>Tên Phim</th>
                        <th style="text-align: center;">Vé Bán Ra</th>
                        <th style="text-align: right;">Doanh Thu (đ)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty top5Movies}">
                            <tr>
                                <td colspan="3" class="text-center text-sub py-4">Hệ thống chưa ghi nhận dữ liệu doanh thu phim.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${top5Movies}" var="movie">
                                <tr>
                                    <td class="fw-semibold text-main">${movie[0]}</td>
                                    <td style="text-align: center;"><span class="badge bg-slate-800 text-light px-2.5">${movie[1]}</span></td>
                                    <td style="text-align: right;" class="text-success font-monospace fw-medium">
                                        <fmt:formatNumber value="${movie[2]}" type="number" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="dash-panel">
            <div class="panel-header"><i class="fa-solid fa-fire me-2 text-danger"></i> Top 5 Suất Chiếu Đông Khách Nhất</div>
            <table class="dash-table">
                <thead>
                    <tr>
                        <th>Suất Chiếu / Tên Phim</th>
                        <th style="text-align: center;">Phòng Chiếu</th>
                        <th style="text-align: right;">Số Khách Đặt</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty top5Showtimes}">
                            <tr>
                                <td colspan="3" class="text-center text-sub py-4">Chưa có dữ liệu suất chiếu phát sinh vé đặt.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${top5Showtimes}" var="st">
                                <tr>
                                    <td>
                                        <div class="text-main">${st[1]}</div>
                                        <div class="text-sub font-monospace">ID Suất: #${st[0]} | Ngày: ${st[5]} | Giờ: ${fn:substring(st[2], 0, 5)}</div>
                                    </td>
                                    <td style="text-align: center;"><span class="badge bg-slate-800 text-info">${st[3]}</span></td>
                                    <td style="text-align: right;" class="text-warning font-monospace fw-bold">${st[4]} ghế</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <div class="dash-grid" style="grid-template-columns: 1fr; margin-bottom: 0;">

        <div class="dash-panel">
            <div class="panel-header"><i class="fa-regular fa-calendar-days me-2 text-primary"></i> Lịch Chiếu Hôm Nay</div>
            <div style="max-height: 250px; overflow-y: auto; padding-right: 5px;">
                <ul class="dash-list">
                    <c:choose>
                        <c:when test="${empty todayShowtimes}">
                            <li class="text-sub justify-content-center py-3">Không có suất chiếu nào được lên lịch cho hôm nay.</li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${todayShowtimes}" var="st">
                                <li>
                                    <div>
                                        <div class="text-main">${st.movie.name}</div>
                                        <div class="text-sub">Phòng: ${st.room.roomName}</div>
                                    </div>
                                    <div class="badge bg-slate-800 text-info font-monospace">
                                        ${fn:substring(st.startTime, 0, 5)}
                                    </div>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <div class="dash-panel">
            <div class="panel-header"><i class="fa-solid fa-bolt me-2 text-warning"></i> Hoạt Động Gần Đây (Vé Mới)</div>
            <div style="max-height: 250px; overflow-y: auto; padding-right: 5px;">
                <ul class="dash-list">
                    <c:choose>
                        <c:when test="${empty recentActivities}">
                            <li class="text-sub justify-content-center py-3">Chưa ghi nhận hoạt động đặt vé nào gần đây.</li>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${recentActivities}" var="ticket">
                                <li>
                                    <div>
                                        <div class="text-main">${ticket.user.full_name} <span class="text-sub fw-normal">đã đặt vé</span></div>
                                        <div class="text-sub">${ticket.movie.name}</div>
                                    </div>
                                    <div style="text-align: right;">
                                        <div class="text-main" style="font-size: 12px;">${fn:substring(ticket.bookingTime, 11, 16)}</div>
                                        <c:choose>
                                            <c:when test="${ticket.status == 'SUCCESS' || ticket.status == 'Thành công'}">
                                                <div class="text-sub text-success" style="font-size: 11px; font-weight: 600;">${ticket.status}</div>
                                            </c:when>
                                            <c:when test="${ticket.status == 'PENDING' || ticket.status == 'Chờ thanh toán'}">
                                                <div class="text-sub text-warning" style="font-size: 11px; font-weight: 600;">${ticket.status}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-sub text-danger" style="font-size: 11px; font-weight: 600;">${ticket.status}</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

    </div>
</div>

<script>
    const formatCurrency = (value) => {
        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(value);
    };

    Chart.defaults.color = '#94a3b8';
    Chart.defaults.borderColor = 'rgba(51, 65, 85, 0.5)';

    const chartColors = [
        '#38bdf8', '#4ade80', '#fb923c', '#c084fc', '#f472b6',
        '#facc15', '#2dd4bf', '#818cf8', '#f87171', '#a3e635'
    ];

    window.addEventListener('load', function () {

        // 1. BIỂU ĐỒ ĐƯỜNG: DOANH THU 7 NGÀY
        const rev7DaysLabels = [];
        const rev7DaysData = [];
    <c:forEach items="${revenue7Days}" var="item">
        rev7DaysLabels.push("${item[0]}");
        rev7DaysData.push(${item[1] != null ? item[1] : 0});
    </c:forEach>

        const ctxLine = document.getElementById('revenueLineChart').getContext('2d');
        new Chart(ctxLine, {
            type: 'line',
            data: {
                labels: rev7DaysLabels,
                datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: rev7DaysData,
                        borderColor: '#fb923c',
                        backgroundColor: 'rgba(251, 146, 60, 0.1)',
                        borderWidth: 3,
                        pointBackgroundColor: '#fff',
                        pointBorderColor: '#fb923c',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        fill: true,
                        tension: 0.3
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return ' ' + formatCurrency(context.raw);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return value.toLocaleString('vi-VN');
                            }
                        }
                    }
                }
            }
        });

        // 2. BIỂU ĐỒ DOUGHNUT: DOANH THU THEO PHIM
        const movieLabels = [];
        const movieData = [];
    <c:forEach items="${revenueByMovie}" var="item">
        movieLabels.push("${item[0]}");
        movieData.push(${item[1] != null ? item[1] : 0});
    </c:forEach>

        const ctxMovie = document.getElementById('movieDoughnutChart').getContext('2d');
        new Chart(ctxMovie, {
            type: 'doughnut',
            data: {
                labels: movieLabels,
                datasets: [{
                        data: movieData,
                        backgroundColor: chartColors,
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                plugins: {
                    legend: {position: 'right', labels: {boxWidth: 12, font: {size: 11}}},
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return ' ' + formatCurrency(context.raw);
                            }
                        }
                    }
                }
            }
        });

        // 3. BIỂU ĐỒ PIE: DOANH THU THEO THỂ LOẠI
        const genreLabels = [];
        const genreData = [];
    <c:forEach items="${revenueByGenre}" var="item">
        genreLabels.push("${item[0]}");
        genreData.push(${item[1] != null ? item[1] : 0});
    </c:forEach>

        const ctxGenre = document.getElementById('genreDoughnutChart').getContext('2d');
        new Chart(ctxGenre, {
            type: 'pie',
            data: {
                labels: genreLabels,
                datasets: [{
                        data: genreData,
                        backgroundColor: chartColors.slice(4).concat(chartColors.slice(0, 4)),
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {position: 'right', labels: {boxWidth: 12, font: {size: 11}}},
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return ' ' + formatCurrency(context.raw);
                            }
                        }
                    }
                }
            }
        });
    });
</script>