<%@page isELIgnored="false" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<%@ page import="Model.Product" %>
<%@ page import="DAO.ProductDAO" %>
<!DOCTYPE html>
<html lang="vi">
    <%
    
    try {
        DAO.ProductDAO productDAO = new DAO.ProductDAO();
        java.util.List<Model.Product> featuredProducts = productDAO.getFeaturedProducts();
        request.setAttribute("featuredProducts", featuredProducts);

    } catch (Exception e) {
        System.err.println("Lỗi khi tải sản phẩm nổi bật trong JSP: " + e.getMessage());
        request.setAttribute("featuredProducts", new java.util.ArrayList<Model.Product>()); 
        e.printStackTrace();
    }
%>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Chủ - Mỹ Phẩm Cao Cấp</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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


<%@include file="header.jsp" %>


        <div class="container">
            <aside class="sidebar">
                <div class="category-box">
                    <h3>DANH MỤC</h3>
                    <ul class="category-list">
                        <li><a href="category?name=dưỡng da">DƯỠNG DA</a></li>
                        <li><a href="category?name=làm sạch">LÀM SẠCH</a></li>
                        <li><a href="category?name=trang điểm nền">TRANG ĐIỂM NỀN</a></li>
                        <li><a href="category?name=trang điểm mắt môi">TRANG ĐIỂM MẮT MÔI</a></li>
                        <li><a href="category?name=chăm sóc tóc">CHĂM SÓC TÓC</a></li>
                        <li><a href="category?name=dược mỹ phẩm">DƯỢC MỸ PHẨM</a></li>
                        <li><a href="category?name=sức khỏe làm đẹp">SỨC KHỎE LÀM ĐẸP</a></li>
                        <li><a href="category?name=thực phẩm chức năng">THỰC PHẨM CHỨC NĂNG</a></li>
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
                    <hr style="border: 0; height: 1px; background-color: #D9537A; margin-bottom: 30px;">

                    <div class="slider-wrapper">
                        <button class="slider-btn prev-btn">&lt;</button>

                        <div class="slider-content" id="featuredSlider">

                            <c:forEach var="product" items="${featuredProducts}">
                                <div class="product-card slider-item">

                                    <img src="${pageContext.request.contextPath}/${product.mainImageUrl}" alt="${product.name}">

                                    <div class="product-info">

                                        <p class="name">${product.name}</p>

                                        <p class="price">
                                            <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VND"/>
                                        </p>

                                        <a href="${pageContext.request.contextPath}/productDetail?id=${product.productId}" class="detail-link">
                                            Xem chi tiết
                                        </a>
                                    </div>

                                </div>
                            </c:forEach>

                            <c:if test="${empty featuredProducts}">
                                <p style="text-align: center; width: 100%; color: #999;">
                                    Hiện chưa có sản phẩm nổi bật nào được đánh dấu.
                                </p>
                            </c:if>
                        </div>

                        <button class="slider-btn next-btn">&gt;</button>

                    </div>
                </div>
            </main>

        </div>

<%@include file="footer.jsp" %>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const slider = document.getElementById('featuredSlider');
                const prevBtn = document.querySelector('.prev-btn');
                const nextBtn = document.querySelector('.next-btn');
                const scrollAmount = 600; // Số pixel cuộn mỗi lần

                if (prevBtn && nextBtn && slider) {

                    // Xử lý nút TRƯỚC
                    prevBtn.addEventListener('click', () => {
                        // Cuộn sang trái
                        slider.scrollBy({
                            left: -scrollAmount,
                            behavior: 'smooth'
                        });
                    });

                    // Xử lý nút SAU
                    nextBtn.addEventListener('click', () => {
                        // Cuộn sang phải
                        slider.scrollBy({
                            left: scrollAmount,
                            behavior: 'smooth'
                        });
                    });
                }
            });
        </script>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" 
      integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />
        <%@include file="login.jsp" %>
    </body>
</html>
