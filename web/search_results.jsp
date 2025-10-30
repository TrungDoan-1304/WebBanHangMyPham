<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm cho: ${searchKeyword}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <%@include file="header.jsp" %>

    <div class="container" style="margin-top: 100px;">
        <div class="content" style="width: 100%; padding-left: 20px;">
            <h2>🔎 Kết Quả Tìm Kiếm (${searchResults.size()} sản phẩm)</h2>
            <p>Từ khóa: <strong>${searchKeyword}</strong></p>

            <div class="product-grid">
                <c:choose>
                    <c:when test="${not empty searchResults}">
                        <c:forEach var="product" items="${searchResults}">
                            <%-- Tái sử dụng cấu trúc product-card từ home.jsp --%>
                            <div class="product-card">
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
                        <p>Không tìm thấy sản phẩm nào phù hợp với từ khóa "${searchKeyword}".</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>