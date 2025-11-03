<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - Mỹ Phẩm TD</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            /* CSS DÀNH RIÊNG CHO ADMIN LAYOUT */

            /* HEADER (Thay đổi màu nền) */
            .admin-header {
                background-color: #00796B;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: fixed;
                width: 100%;
                top: 0;
                z-index: 100;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            }
            .admin-logo {
                font-size: 24px;
                font-weight: bold;
            }
            .admin-logo i {
                margin-right: 10px;
            }

            /* MAIN LAYOUT (Sidebar + Content) */
            .admin-main-content {
                display: flex;
                min-height: calc(100vh - 80px); /* Bù trừ footer */
                padding-top: 65px; /* Bù trừ header cố định */
                background-color: #f7f7f7;
            }

            /* SIDEBAR */
            .admin-sidebar {
                width: 250px;
                flex-shrink: 0;
                background-color: #263238; /* Màu tối */
                color: #cfd8dc;
                padding-top: 20px;
                position: fixed;
                height: 100%;
                top: 65px;
                left: 0;
                overflow-y: auto;
            }
            .admin-sidebar h3 {
                color: #fff;
                padding: 0 20px 10px;
                margin: 0 0 15px 0;
                border-bottom: 1px solid #37474f;
                font-size: 18px;
            }
            .admin-sidebar ul {
                list-style: none;
                padding: 0;
            }
            .admin-sidebar a {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                text-decoration: none;
                color: #cfd8dc;
                transition: background-color 0.2s, color 0.2s;
            }
            .admin-sidebar a:hover, .admin-sidebar li.active a {
                background-color: #00897b; /* Màu xanh lá nhạt */
                color: white;
            }
            .admin-sidebar i {
                margin-right: 15px;
                width: 20px;
            }

            /* DASHBOARD CONTENT */
            .dashboard-content {
                flex-grow: 1;
                margin-left: 250px; /* Bù trừ chiều rộng sidebar */
                padding: 30px;
            }

            /* KPI Cards */
            .kpi-cards {
                display: flex;
                gap: 20px;
                margin-bottom: 30px;
            }
            .kpi-card {
                flex: 1;
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                border-left: 5px solid #00897b;
            }
            .kpi-card h4 {
                margin-top: 0;
                font-size: 16px;
                color: #555;
            }
            .kpi-value {
                font-size: 28px;
                font-weight: bold;
                color: #00796B;
            }

            /* Biểu đồ */
            .chart-section {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .chart-section h3 {
                margin-top: 0;
                color: #00796B;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }

            /* FOOTER ADMIN */
            .admin-footer {
                margin-left: 250px;
                background-color: #222;
                color: #ccc;
                padding: 15px 30px;
                text-align: center;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <%-- HEADER --%>
        <header class="admin-header">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="admin-logo">
                <i class="fas fa-gem"></i> Web Mỹ Phẩm TD 
            </a>
            <div class="user-info">
                Xin chào, Admin | <a href="${pageContext.request.contextPath}/logout" style="color: #ff9800; text-decoration: none;">Đăng xuất</a>
            </div>
        </header>

        <div class="admin-main-content">

            <%-- SIDEBAR MENU --%>
            <nav class="admin-sidebar">
                <h3><i class="fas fa-cogs"></i> Admin Menu</h3>
                <ul>
                    <li class="active"><a href="${pageContext.request.contextPath}/admindashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/adminproducts"><i class="fas fa-box-open"></i> Quản lý sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/adminusers"><i class="fas fa-users"></i> Quản lý người dùng</a></li>
                    <li><a href="${pageContext.request.contextPath}/adminorders"><i class="fas fa-clipboard-list"></i> Quản lý đơn hàng</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </nav>

            <%-- DASHBOARD CONTENT --%>
            <main class="dashboard-content">

                <h2><i class="fas fa-tachometer-alt"></i> Dashboard</h2>

                <%-- KHỐI KPI (Doanh thu tháng, năm, Yêu cầu chờ xử lý) --%>
                <div class="kpi-cards">
                    <div class="kpi-card">
                        <h4>Doanh thu tháng</h4>
                        <div class="kpi-value">
                            <fmt:formatNumber value="${monthlyRevenue}" pattern="#,##0"/> VND
                        </div>
                    </div>
                    <div class="kpi-card">
                        <h4>Doanh thu năm</h4>
                        <div class="kpi-value">
                            <fmt:formatNumber value="${yearlyRevenue}" pattern="#,##0"/> VND
                        </div>
                    </div>
                </div>

                <%-- KHỐI BIỂU ĐỒ (Biểu đồ doanh thu theo tuần) --%>
                <div class="chart-section">
                    <h3>Biểu đồ doanh thu theo tuần</h3>
                    <div style="height: 400px;">
                        <canvas id="weeklyRevenueChart"></canvas>
                    </div>

            </main>
        </div>

        <%-- FOOTER --%>
        <footer class="admin-footer">
            <%-- Bạn cần đảm bảo file footer.jsp chứa nội dung của footer gốc --%>
            <%@include file="footer.jsp" %>
        </footer>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Lấy dữ liệu (JSON) từ Controller
                const labels = ${chartLabels};
                const dataValues = ${chartData};

                const ctx = document.getElementById('weeklyRevenueChart').getContext('2d');

                // Cấu hình màu sắc
                const gradient = ctx.createLinearGradient(0, 0, 0, 400);
                gradient.addColorStop(0, 'rgba(0, 137, 123, 0.6)'); // Màu xanh lá/teal (Màu Admin)
                gradient.addColorStop(1, 'rgba(255, 255, 255, 0.1)');

                const myChart = new Chart(ctx, {
                    type: 'line', // Kiểu biểu đồ (line)
                    data: {
                        labels: labels, // Dữ liệu trục X
                        datasets: [{
                                label: 'Doanh thu theo ngày (VND)',
                                data: dataValues, // Dữ liệu trục Y
                                borderColor: '#00796B',
                                backgroundColor: gradient, // Màu nền (Gradient)
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4 // Làm mượt đường
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.y !== null) {
                                            // Định dạng tiền tệ
                                            label += new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(context.parsed.y);
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>