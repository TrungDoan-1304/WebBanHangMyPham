<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tra cứu đơn hàng cho khách</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container">
        <h2>Tra cứu đơn hàng</h2>
        <p>Nhập SĐT hoặc Email đã dùng khi đặt hàng:</p>
        <form action="${pageContext.request.contextPath}/guestLookup" method="get">
            <input type="text" name="q" placeholder="SĐT hoặc Email" required />
            <button type="submit">Tra cứu</button>
        </form>

        <c:if test="${not empty orders}">
            <h3>Kết quả tìm kiếm (${fn:length(orders)} đơn)</h3>
            <c:forEach var="order" items="${orders}">
                <div class="order-card" style="border:1px solid #ddd; padding:12px; margin-bottom:10px;">
                    <h4>Đơn hàng #${order.orderId}</h4>
                    <p><strong>Khách:</strong>
                        <c:choose>
                            <c:when test="${not empty order.guestInfo}">
                                ${order.guestInfo}
                            </c:when>
                            <c:otherwise>
                                (Tài khoản nội bộ)
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Ngày:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                    <p><strong>Tổng:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" /></p>
                    <p><a href="${pageContext.request.contextPath}/orderDetail?id=${order.orderId}">Xem chi tiết</a></p>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty orders && not empty param.q}">
            <p>Không tìm thấy đơn hàng với từ khoá "${param.q}".</p>
        </c:if>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
