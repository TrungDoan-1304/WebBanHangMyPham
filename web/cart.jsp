<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ Hàng Của Bạn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS cho modal giỏ hàng */
        .cart-modal {
            margin: 100px auto;
            width: 70%;
            max-width: 900px;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            text-align: center;
        }
        .cart-modal h2 {
            color: #D9537A;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .cart-table th, .cart-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: left;
        }
        .cart-table th {
            background-color: #f7f7f7;
            font-weight: 600;
        }
        .cart-table td:nth-child(3) { /* Số lượng */
            width: 80px;
        }
        .cart-table img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            margin-right: 10px;
            vertical-align: middle;
        }
        .total-row {
            font-size: 20px;
            font-weight: bold;
            color: #D9537A;
        }
        .btn-cart-action {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            margin: 0 10px;
        }
        .btn-continue {
            background-color: #32CD32;
            color: white;
        }
        .btn-checkout {
            background-color: #D9537A;
            color: white;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>
    
    <div class="cart-modal">
        <h2><i class="fas fa-shopping-cart"></i> Giỏ hàng của bạn</h2>
        
        <c:choose>
            <c:when test="${not empty cartItems}">
                <form action="${pageContext.request.contextPath}/cartUpdate" method="POST">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                                <th>Tổng</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="overallTotal" value="${0}" />
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td>
                                        <img src="${pageContext.request.contextPath}/${item.product.mainImageUrl}" alt="${item.product.name}">
                                        ${item.product.name}
                                    </td>
                                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND" /></td>
                                    <td>
                                        <input type="number" name="quantity_${item.cartItemId}" value="${item.quantity}" min="1" style="width: 50px; text-align: center;">
                                    </td>
                                    <td><fmt:formatNumber value="${item.totalAmount}" type="currency" currencySymbol="VND" /></td>
                                    <td>
                                        <button type="submit" name="action" value="update" class="btn-cart-action btn-secondary" style="background-color: #ccc;">Cập nhật</button>
                                        <button type="submit" name="action" value="remove" class="btn-cart-action btn-danger" style="background-color: #dc3545; color: white;">Xóa</button>
                                        <input type="hidden" name="itemId" value="${item.cartItemId}">
                                    </td>
                                </tr>
                                <c:set var="overallTotal" value="${overallTotal + item.totalAmount}" />
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr class="total-row">
                                <td colspan="3" style="text-align: right;">Tổng cộng:</td>
                                <td><fmt:formatNumber value="${overallTotal}" type="currency" currencySymbol="VND" /></td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </form>
                
                <div style="margin-top: 30px;">
                    <a href="${pageContext.request.contextPath}/home.jsp" class="btn-cart-action btn-continue">
                        ← Tiếp tục mua hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn-cart-action btn-checkout">
                        Thanh toán →
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="padding: 50px; border: 1px solid #eee; border-radius: 6px;">
                    <p style="font-size: 18px; color: #555;">Giỏ hàng của bạn hiện đang trống.</p>
                    <a href="${pageContext.request.contextPath}/home.jsp" class="btn-cart-action btn-continue">
                        ← Mua sắm ngay
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>