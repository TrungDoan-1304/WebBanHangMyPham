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
        .detail-header {
            color: #D9537A;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-group strong {
            display: block;
            color: #555;
            margin-bottom: 5px;
        }
        .info-group span {
            font-size: 16px;
            color: #000;
        }
        /* Bảng chi tiết sản phẩm */
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .order-items-table th, .order-items-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .order-items-table th { background-color: #f7f7f7; }
        .total-row { font-weight: bold; font-size: 18px; color: #D9537A; }
                    html, body {
                height: 100%;
                margin: 0;
            }

            /* Biến body thành flex column */
            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Đảm bảo các layout wrapper cũng linh hoạt */
            .admin-layout, .admin-main-content {
                display: flex;
                flex-direction: column;
                flex-grow: 1;
            }

            /* Đẩy nội dung chính (main) chiếm không gian thừa */
            main.dashboard-content {
                flex-grow: 1;
            }

            /* Ngăn footer co lại */
            footer.footer {
                flex-shrink: 0;
            }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%-- HEADER ADMIN --%>
        
        <main class="dashboard-content" style="margin-left: 250px;">
            <div class="detail-wrapper">
                <h2 class="detail-header">Chi Tiết Đơn Hàng #${order.orderId}</h2>
                
                <div class="info-grid">
                    <div class="info-group">
                        <strong>Khách hàng:</strong>
                        <span>${order.customerName}</span>
                    </div>
                    <div class="info-group">
                        <strong>Số điện thoại:</strong>
                        <span>${empty order.customerPhone ? '(Khách vãng lai)' : order.customerPhone}</span>
                    </div>
                    <div class="info-group">
                        <strong>Địa chỉ giao hàng:</strong>
                        <span>${order.shippingAddress}</span>
                    </div>
                    <div class="info-group">
                        <strong>Phương thức thanh toán:</strong>
                        <span>${order.paymentMethod}</span>
                    </div>
                </div>

                <h3>Danh sách sản phẩm</h3>
                <table class="order-items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderItems}">
                            <tr>
                                <td>${item.productName}</td>
                                <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND"/></td>
                                <td>${item.quantity}</td>
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

                <a href="${pageContext.request.contextPath}/adminorders" style="display: inline-block; margin-top: 20px;">
                    ← Quay lại Danh sách
                </a>
            </div>
        </main>
        
        <%-- FOOTER --%>
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>