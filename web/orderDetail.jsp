<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Đơn Hàng #${order.orderId}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .detail-wrapper {
            max-width: 900px;
            margin: 20px;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .detail-header { color: #D9537A; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .info-group strong { display: block; color: #555; margin-bottom: 5px; }
        .order-items-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .order-items-table th, .order-items-table td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        .order-items-table th { background-color: #f7f7f7; }
        .total-row { font-weight: bold; font-size: 18px; color: #D9537A; }
    </style>
</head>
<body>
    
    <%@include file="header.jsp" %>

    <div class="profile-container">


        <main class="profile-content">
            <div class="detail-wrapper">
                <h2 class="detail-header">Chi Tiết Đơn Hàng #${order.orderId}</h2>
                
                <%-- Hiển thị thông báo (nếu có) --%>
                <c:if test="${not empty sessionScope.statusMessage}">
                    <p style="color: green; font-weight: bold;">${sessionScope.statusMessage}</p>
                    <c:remove var="statusMessage" scope="session"/>
                </c:if>

                <h3>Danh sách sản phẩm</h3>
                <table class="order-items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderItems}">
                            <tr>
                                <td>${item.productName}</td>
                                <td>${item.quantity}</td>
                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND"/></td>
                                <td><fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="VND"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td colspan="3" style="text-align: right;">Tổng cộng:</td>
                            <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND"/></td>
                        </tr>
                    </tfoot>
                </table>

                <div class="info-grid" style="margin-top: 30px;">
                    <div class="info-group">
                        <strong>Ngày đặt:</strong>
                        <span><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                    <div class="info-group">
                        <strong>Phương thức thanh toán:</strong>
                        <span>${order.paymentMethod}</span>
                    </div>
                    <div class="info-group">
                        <strong>Địa chỉ giao hàng:</strong>
                        <span>${order.shippingAddress}</span>
                    </div>
                    <div class="info-group">
                        <strong>Trạng thái:</strong>
                        <span style="font-weight: bold; color: ${order.status eq 'delivered' ? 'green' : 'orange'}">${order.status}</span>
                    </div>
                </div>

                <c:if test="${order.status eq 'pending'}">
                    <div class="form-section" style="margin-top: 30px; border-top: 2px solid #eee; padding-top: 20px;">
                        
                        <%-- SỬA ĐỊA CHỈ --%>
                        <form action="${pageContext.request.contextPath}/updateOrder" method="POST" style="margin-bottom: 20px;">
                            <input type="hidden" name="action" value="updateAddress">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            
                            <div class="form-group">
                                <label><strong>Cập nhật địa chỉ giao hàng:</strong></label>
                                <textarea name="shippingAddress" rows="3" style="width: 100%;">${order.shippingAddress}</textarea>
                            </div>
                            <button type="submit" class="btn-action btn-success">Lưu Địa Chỉ Mới</button>
                        </form>
                        
                        <%-- HỦY ĐƠN --%>
                        <form action="${pageContext.request.contextPath}/updateOrder" method="POST">
                            <input type="hidden" name="action" value="cancelOrder">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            
                            <label><strong>Hủy đơn hàng:</strong></label>
                            <button type="submit" class="btn-action" style="background-color: #dc3545; color: white;"
                                    onclick="return confirm('Bạn có chắc chắn muốn HỦY đơn hàng này không?');">
                                Hủy Đơn Hàng
                            </button>
                        </form>
                    </div>
                </c:if>
                
                <a href="${pageContext.request.contextPath}/orders" style="display: inline-block; margin-top: 20px;">
                    ← Quay lại Lịch sử Đơn hàng
                </a>
            </div>
        </main>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>