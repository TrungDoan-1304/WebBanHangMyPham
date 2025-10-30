<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <title>${categoryTitle} - Danh Mục</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <%@include file="header.jsp" %>

        <div class="container" style="display: block; width: 90%; margin: 100px auto 50px auto;">

            <h2 style="color: #D9537A; margin-bottom: 30px; border-bottom: 2px solid #D9537A; padding-bottom: 10px;">
                DANH MỤC: ${categoryTitle}
            </h2>

            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty products}">
                        <%-- HIỂN THỊ SẢN PHẨM --%>
                        <c:forEach var="product" items="${products}">
                            <div class="product-card" style="width: calc(25% - 15px);">

                                <img src="${pageContext.request.contextPath}/${product.mainImageUrl}" alt="${product.name}">

                                <div class="product-info">
                                    <p class="name">${product.name}</p>

                                    <p style="font-size: 14px; color: #777;">Tồn kho: ${product.stockQuantity}</p>

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

                    <c:when test="${empty products || requestScope.showNoProductMessage}">
                        <div style="width: 100%; text-align: center; padding: 50px; background-color: #f9f9f9; border-radius: 8px;">
                            <p style="font-size: 20px; color: #D9537A; font-weight: bold;">
                                TẠM THỜI CHƯA CÓ SẢN PHẨM NÀO THUỘC DANH MỤC NÀY.
                            </p>
                            <p style="color: #777;">
                                Chúng tôi đang cập nhật các sản phẩm mới chất lượng cao! Vui lòng quay lại sau.
                            </p>
                        </div>
                    </c:when>


                    <c:otherwise>
                        <c:forEach var="product" items="${products}">
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%@include file="footer.jsp" %>
    </body>
</html>