<%-- 
    Document   : home
    Created on : Oct 27, 2025, 9:49:58 PM
    Author     : PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Chủ - Mỹ Phẩm Cao Cấp</title>

        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #fff;
                color: #333;
            }
            .top-bar, .header-main, .menu-bar {
                padding-left: 10px;
                padding-right: 10px;
            }
            /* Top Bar - Thanh liên hệ trên cùng */
            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;

                padding: 5px 50px;
                background-color: #f8f8f8;
                border-bottom: 1px solid #eee;
                font-size: 13px;
            }
            .top-bar-info span {
                margin-right: 15px;
                color: #666;
            }
            .top-bar-info i {
                color: #D9537A; /* Màu hồng/đỏ đặc trưng của web mỹ phẩm */
                margin-right: 5px;
            }

            /* HEADER & Navigation */
            .header-main {

                padding: 10px 50px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .logo-section {
                display: flex;
                align-items: center;
            }
            .logo-text {
                font-size: 28px;
                font-weight: 900;
                color: #D9537A;
            }
            .logo-text span {
                color: #333;
                font-weight: 300;
            }
            .account-actions a {
                color: #333;
                text-decoration: none;
                margin-left: 15px;
                padding: 5px 10px;
                border: 1px solid #ccc;
                border-radius: 3px;
                transition: background-color 0.3s;
            }
            .account-actions a:hover {
                background-color: #f0f0f0;
            }
            .cart-count {
                background-color: #D9537A;
                color: white;
                padding: 2px 7px;
                border-radius: 50%;
                font-size: 12px;
                margin-left: 5px;
            }

            /* Main Menu Bar */
            .menu-bar {
                background-color: #D9537A;
                padding: 0 50px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .main-nav {
                list-style: none;
                padding: 0;
                margin: 0;
                display: flex;
            }
            .main-nav li a {
                color: white;
                text-decoration: none;
                padding: 15px 20px;
                display: block;
                font-weight: 600;
                transition: background-color 0.3s;
            }
            .main-nav li a:hover {
                background-color: #C0426A;
            }

            .search-box {
                display: flex;
                align-items: center;
            }
            .search-box input {
                padding: 8px 10px;
                border: none;
                border-radius: 3px 0 0 3px;
                outline: none;
                width: 200px;
            }
            .search-box button {
                background-color: #fff;
                border: none;
                padding: 8px 10px;
                cursor: pointer;
                border-radius: 0 3px 3px 0;
                color: #D9537A;
            }
            .container {
                width: 100%;
                margin: 20px 0;
                display: flex;
                gap: 0;
            }
            .sidebar {
                width: 220px;
                flex-shrink: 0;
                padding-left: 10px;
                box-sizing: border-box;

            }
            .content {
                flex-grow: 1;
                min-width: 0;
                padding-left: 10px;
                padding-right: 10px;
                box-sizing: border-box;
            }

            /* Danh mục (Sidebar) */
            .category-box {
                border: 1px solid #eee;
                border-top-color: #D9537A;
                min-height: 400px;
            }
            .category-box h3 {
                background-color: #D9537A;
                color: white;
                margin: 0;
                padding: 10px 15px;
                font-size: 18px;
                font-weight: 600;
            }
            .category-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .category-list li a {
                display: block;
                padding: 10px 15px;
                text-decoration: none;
                color: #555;
                border-bottom: 1px dotted #eee;
                transition: background-color 0.2s, color 0.2s;
            }
            .category-list li a:hover {
                background-color: #fff0f5;
                color: #D9537A;
            }
            /* Loại bỏ dấu chấm tròn cho các danh mục con */
            .category-list li {
                list-style-type: none;
            }
            .small-banners {
                display: flex;
                justify-content: space-between;
                gap: 10px;
                margin-bottom: 30px;
                width: 100%;
                flex-wrap: nowrap;
                min-width: 0;
            }

            .small-banners img {
                flex: 1 1 calc((100% - 20px) / 3);
                max-width: calc((100% - 20px) / 3);
                height: 180px;
                object-fit: cover;
                border-radius: 5px;
                box-sizing: border-box;
                display: block;
            }
            .main-banner {
                height: 400px;
                overflow: hidden;
                margin-bottom: 15px;
                width: 100%;
            }
            .main-banner img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 5px;
            }
            .product-list-container h2 {
                text-align: center;
                font-size: 24px;
                color: #D9537A;
                border-bottom: 2px solid #D9537A;
                padding-bottom: 10px;
                margin: 40px 0 20px 0;
            }
            .product-grid {
                display: flex;
                flex-wrap: wrap;
                justify-content: flex-start; /* Sắp xếp từ trái sang phải */
                gap: 20px;
            }
            .product-card {
                width: calc(20% - 16px); /* 5 cột */
                border: 1px solid #eee;
                text-align: center;
                padding: 10px;
                transition: box-shadow 0.3s;
                box-sizing: border-box;
            }
            .product-card:hover {
                box-shadow: 0 4px 8px rgba(217, 83, 122, 0.2);
            }
            .product-card img {
                width: 100%;
                height: 150px;
                object-fit: contain;
                margin-bottom: 10px;
            }
            .product-card p {
                margin: 5px 0;
                font-size: 14px;
                color: #666;
            }
            .product-card .name {
                font-weight: 600;
                color: #333;
                height: 36px; /* Giữ chiều cao cố định cho tên */
                overflow: hidden;
            }
            .product-card .price {
                color: #D9537A;
                font-weight: bold;
                font-size: 16px;
            }

            /* FOOTER */
            .footer {
                background-color: #333;
                color: #ccc;
                padding: 30px 10%;
                text-align: center;
                border-top: 5px solid #D9537A;
                margin-top: 40px;
            }
            .footer-info {
                display: flex;
                justify-content: center;
                gap: 40px;
                margin-top: 20px;
                padding-top: 15px;
                border-top: 1px dashed #555;
            }
            .team-member h4 {
                color: #fff;
                margin-bottom: 5px;
                font-size: 16px;
            }
            .team-member p {
                margin: 0;
                font-size: 13px;
            }
        </style>


    </head>
    <body>
        <fmt:setLocale value="vi_VN" />

        <div class="top-bar">
            <div class="top-bar-info">
                <span>Email: mypham24h@gmail.com</span>
                <span><i class="fas fa-shipping-fast"></i> Vận chuyển toàn quốc - Đổi trả dịch vụ Viettel Post</span>
            </div>
            <div class="top-bar-info">
                <span><i class="fas fa-headset"></i> Hỗ trợ 24/7: 0123445678</span>
                <span><i class="far fa-clock"></i> Giờ làm việc: 6:30 - 18:30 (Từ T2 - CN)</span>
            </div>
        </div>

        <header class="header-main">
            <div class="logo-section">
                <div class="logo-text">R<span>D</span></div>
                <p style="font-size: 12px; margin-left: 10px; color: #D9537A;">Mỹ Phẩm Cao Cấp</p>
            </div>
            <div class="account-actions">
                <a href="login.jsp">Đăng nhập</a> 
                <a href="cart.jsp">
                    <i class="fas fa-shopping-cart"></i> Giỏ hàng (<span class="cart-count">0</span>) 
                </a>
            </div>
        </header>
        <nav class="menu-bar">
            <ul class="main-nav">
                <li><a href="#">TRANG CHỦ</a></li>
                <li><a href="#">GIỚI THIỆU</a></li>
                <li><a href="#">SẢN PHẨM</a></li>
                <li><a href="#">CHÍNH SÁCH ĐẠI LÝ</a></li>
                <li><a href="#">TIN TỨC</a></li>
                <li><a href="#">CHIA SẺ</a></li>
                <li><a href="#">LIÊN HỆ</a></li>
            </ul>
            <div class="search-box">
                <input type="text" placeholder="Nhập từ khóa tìm kiếm">
                <button><i class="fas fa-search"></i> Q</button>
            </div>
        </nav>


        <div class="container">
            <aside class="sidebar">
                <div class="category-box">
                    <h3>DANH MỤC</h3>
                    <ul class="category-list">
                        <li><a href="#">ĐƯỜNG DA</a></li>
                        <li><a href="#">LÀM SẠCH</a></li>
                        <li><a href="#">TRANG ĐIỂM NỀN</a></li>
                        <li><a href="#">TRANG ĐIỂM MẮT MÔI</a></li>
                        <li><a href="#">CHĂM SÓC CƠ THỂ</a></li>
                        <li><a href="#">DƯỢC MỸ PHẨM</a></li>
                        <li><a href="#">SỨC KHỎE LÀM ĐẸP</a></li>
                        <li><a href="#">THỰC PHẨM CHỨC NĂNG</a></li>
                    </ul>
                </div>

            </aside>
            <main class="content">
                <div class="main-banner">
                    <img src="media/giaodien.jpg" alt="giaodien">
                </div>
                <div class="small-banners">
                    <img src="media/chamsocda.jpg" alt="Sản phẩm dưỡng da ">
                    <img src="media/chamsoctoc.jpg" alt="Sản phẩm chăm sóc tóc">
                    <img src="media/trangdiem.jpg" alt="Sản phẩm trang điểm ">
                </div>    
                <div class="product-list-container">
                    <h2>SẢN PHẨM NỔI BẬT</h2>
                    <div class="product-grid">
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product.category eq 'Nổi Bật'}">
                                <div class="product-card">
                                    <img src="${product.imageUrl}" alt="${product.name}">
                                    <p class="name">${product.name}</p>
                                    <p>${product.weight}</p>
                                    <p class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VND"/>*</p>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>

                <%-- DƯỠNG DA (Ví dụ về Danh mục khác) --%>
                <div class="product-list-container">
                    <h2>DƯỠNG DA</h2>
                    <div class="product-grid">
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product.category eq 'Dưỡng Da'}">
                                <div class="product-card">
                                    <img src="${product.imageUrl}" alt="${product.name}">
                                    <p class="name">${product.name}</p>
                                    <p>${product.weight}</p>
                                    <p class="price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VND"/>*</p>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
            </main>

        </div>

        <footer class="footer">
            <div class="footer-info">
                <div class="team-member">
                    <h4>Thành viên 1</h4>
                    <p>Họ tên: Đoàn Quốc Trung</p>
                    <p>Ngày sinh: 13/04/2004</p>
                </div>
                <div class="team-member">
                    <h4>Thành viên 2</h4>
                    <p>Họ tên: Lương Sỹ Anh Tuấn</p>
                    <p>Ngày sinh: 26/09/2004</p>
                </div>
                <div class="team-member">
                    <h4>Thành viên 3</h4>
                    <p>Họ tên: Đỗ Ngọc Sơn</p>
                    <p>Ngày sinh: 05/11/2004</p>
                </div>
            </div>
        </footer>

        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script> 

    </body>
</html>
