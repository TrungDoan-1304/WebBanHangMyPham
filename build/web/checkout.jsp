<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <title>Xác Nhận Thanh Toán</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .checkout-box {
                margin: 80px auto;
                width: 50%;
                max-width: 650px;
                background-color: #fff;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }
            .checkout-section {
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            .checkout-section h3 {
                color: #D9537A;
                font-size: 20px;
                margin-bottom: 15px;
            }
            .checkout-box input, .checkout-box select, .checkout-box textarea {
                width: 100%;
                padding: 10px;
                margin-bottom: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .order-summary-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .order-summary-table th, .order-summary-table td {
                padding: 8px;
                border-bottom: 1px solid #f0f0f0;
                text-align: left;
            }
            .order-summary-table th {
                font-weight: 600;
            }
            .final-total {
                font-size: 18px;
                font-weight: bold;
                color: #D9537A;
                text-align: right;
                padding-top: 10px;
            }
            .btn-confirm {
                width: 100%;
                padding: 15px;
                background-color: #32CD32;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>

        <div class="checkout-box">
            <h2 style="color: #32CD32; text-align: center; margin-bottom: 30px;"><i class="fas fa-check-circle"></i> Xác Nhận Thanh Toán</h2>

            <form action="${pageContext.request.contextPath}/processCheckout" method="POST">

                <%-- THÔNG TIN NGƯỜI NHẬN --%>
                <div class="checkout-section">
                    <h3>Thông tin người nhận</h3>
                    <input type="text" name="fullName" placeholder="Họ và tên" value="${user.fullName}" required>
                    <input type="text" name="phoneNumber" placeholder="Số điện thoại" value="${user.phoneNumber}" required>
                    <textarea name="shippingAddress" placeholder="Địa chỉ giao hàng" required>${user.address}</textarea>
                </div>

                <%-- PHƯƠNG THỨC THANH TOÁN --%>
                <div class="checkout-section">
                    <h3>Phương thức thanh toán</h3>
                    <select name="paymentMethod" required>
                        <option value="COD">Thanh toán khi nhận hàng (COD)</option>
                        <option value="BANK_TRANSFER">Chuyển khoản Ngân hàng</option>
                    </select>
                </div>

                <%-- GHI CHÚ --%>
                <div class="checkout-section">
                    <h3>Ghi chú</h3>
                    <textarea name="notes" placeholder="Ví dụ: Giao hàng giờ hành chính, gọi trước khi đến..."></textarea>
                </div>

                <%-- TỔNG KẾT ĐƠN HÀNG --%>
                <div class="checkout-section">
                    <h3>Đơn hàng của bạn</h3>
                    <table class="order-summary-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="finalTotal" value="${0}" />
                            <%-- LẶP QUA DANH SÁCH CART ITEMS --%>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td>${item.product.name}</td>
                                    <td>${item.quantity}</td>
                                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND" /></td>
                                    <td><fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="VND" /></td>
                                </tr>
                                <c:set var="finalTotal" value="${finalTotal + item.totalAmount}" />
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="final-total">
                        Tổng cộng: <fmt:formatNumber value="${finalTotal}" type="currency" currencySymbol="VND" />
                    </div>
                </div>

                <button type="submit" class="btn-confirm">Xác nhận & Thanh toán</button>
            </form>
        </div>

        <%@include file="footer.jsp" %>
    </body>
</html>