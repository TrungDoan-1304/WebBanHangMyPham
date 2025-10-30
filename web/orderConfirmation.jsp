<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Xác Nhận Đơn Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .confirmation-box {
            margin: 120px auto;
            width: 50%;
            max-width: 600px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .confirmation-box h2 {
            color: #32CD32;
            font-size: 32px;
            margin-bottom: 15px;
        }
        .confirmation-box p {
            font-size: 16px;
            color: #555;
        }
        .order-detail-summary {
            text-align: left;
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="confirmation-box">
        <c:choose>
            <c:when test="${not empty order}">
                <h2><i class="fas fa-check-circle"></i> Đặt Hàng Thành Công!</h2>
                <p>Cảm ơn bạn đã tin tưởng và đặt hàng tại Mỹ Phẩm TD.</p>
                <p>Mã đơn hàng của bạn là: <strong>#${order.orderId}</strong></p>

                <div class="order-detail-summary">
                    <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                    <p><strong>Tổng tiền:</strong> <span style="color: #D9537A;"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" /></span></p>
                    <p><strong>Phương thức:</strong> ${order.paymentMethod eq 'COD' ? 'Thanh toán khi nhận hàng (COD)' : 'Chuyển khoản Ngân hàng'}</p>
                </div>
                
                <a href="${pageContext.request.contextPath}/home.jsp" style="display: block; margin-top: 30px; color: #32CD32;">
                    ← Tiếp tục mua sắm
                </a>
            </c:when>
            <c:otherwise>
                 <h2 style="color: red;"><i class="fas fa-times-circle"></i> Đặt Hàng Thất Bại</h2>
                 <p>Có lỗi xảy ra hoặc đơn hàng không tồn tại.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>