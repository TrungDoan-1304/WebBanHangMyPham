<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Tất Cả Sản Phẩm - Mỹ Phẩm Cao Cấp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="container" style="display: block; width: 90%; margin: 100px auto 50px auto;">
        
        <h2 style="color: #D9537A; margin-bottom: 30px; border-bottom: 2px solid #D9537A; padding-bottom: 10px;">
            TẤT CẢ SẢN PHẨM
        </h2>
        
        <div class="product-grid">
            <c:choose>
                <c:when test="${not empty allProducts}">
                    <c:forEach var="product" items="${allProducts}">
                        <%-- Tái sử dụng product-card CSS từ home.jsp --%>
                        <div class="product-card" style="width: calc(25% - 15px);">
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
                </c:when>
                <c:otherwise>
                    <p>Hiện không có sản phẩm nào để hiển thị.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>