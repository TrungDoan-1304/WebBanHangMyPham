<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>


<header class="header-main">
    <div class="logo-section">
        <div class="logo-text">T<span>D</span></div>
        <p style="font-size: 12px; margin-left: 10px; color: #D9537A;">Mỹ Phẩm Cao Cấp</p>
    </div>
    <div class="account-actions">
        <a href="cart">Giỏ hàng</a>
        <c:if test="${empty sessionScope.username}">
            <a href="LoginController" onclick="openLoginModal(); return false;" class="login-link">
                Đăng nhập
            </a>
        </c:if>
        <c:if test="${not empty sessionScope.username}">  
            <span class="user-display">
                <a href="user.jsp" style="text-decoration: none; color: inherit;">
                Xin chào, <strong>${sessionScope.username}</strong>
                </a>
            </span>
            <a href="logout" class="logout-link">
                Đăng xuất
            </a>
        </c:if>
    </div>
</header>

<nav class="menu-bar">
    <ul class="main-nav">
        <li><a href="home.jsp">TRANG CHỦ</a></li>
        <li><a href="gioithieu.jsp">GIỚI THIỆU</a></li>
        <li><a href="sanpham">SẢN PHẨM</a></li>
        <li><a href="chinhsach.jsp">CHÍNH SÁCH ĐẠI LÝ</a> </li>
        <li><a href="tintuc.jsp">TIN TỨC</a></li>
        <li><a href="lienhe.jsp">LIÊN HỆ</a></li>
    </ul>
    <div class="search-box">
        <form action="search" method="GET"> <input type="text" name="keyword" placeholder="Nhập từ khóa tìm kiếm" required>
            <button type="submit"><i class="fas fa-search"></i></button>
        </form>
    </div>
</nav>