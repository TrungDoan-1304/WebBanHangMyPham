<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <title>Quản Lý Đơn Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            /* CSS Admin Layout (Tái sử dụng) */
            .admin-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .admin-table th, .admin-table td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
                font-size: 14px;
            }
            .admin-table th {
                background-color: #f0f0f0;
            }
            .btn-action-small {
                padding: 5px 10px;
                margin-right: 5px;
                border-radius: 3px;
                cursor: pointer;
            }

            /* CSS cho Trạng thái */
            .status {
                padding: 3px 8px;
                border-radius: 4px;
                color: white;
                font-weight: bold;
            }
            .status-pending {
                background-color: #ffc107;
                color: #333;
            }
            .status-processing {
                background-color: #007bff;
            }
            .status-shipped {
                background-color: #17a2b8;
            }
            .status-delivered {
                background-color: #28a745;
            }
            .status-canceled {
                background-color: #dc3545;
            }
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

        <%-- HEADER ADMIN (Giả sử bạn đã INCLUDE header admin tại đây) --%>

        <div class="admin-main-content">
            <%-- SIDEBAR MENU (Giả sử bạn đã INCLUDE sidebar admin) --%>

            <main class="dashboard-content" style="margin-left: 250px;">
                <h2><i class="fas fa-clipboard-list"></i> Quản Lý Đơn Hàng</h2>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách hàng</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Thanh toán</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${listOrders}">
                            <tr>
                                <td><strong>#${order.orderId}</strong></td>
                                <td>${order.customerName}</td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND"/></td>
                                <td>
                                    <span class="status status-${order.status}">
                                        ${order.status}
                                    </span>
                                </td>
                                <td>${order.paymentMethod}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/adminorderDetail?id=${order.orderId}" 
                                       class="btn-action-small" style="background-color: #007bff; color: white;">Chi tiết</a>

                                    <a href="adminorders?action=edit&id=${order.orderId}" class="btn-action-small" style="background-color: #ffc107;">Sửa TT</a>
                                    <a href="adminorders?action=delete&id=${order.orderId}" class="btn-action-small" 
                                       style="background-color: #dc3545; color: white;" 
                                       onclick="return confirm('Bạn có chắc chắn muốn XÓA đơn hàng này không?');">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <p style="margin-top: 20px;"><a href="${pageContext.request.contextPath}/admindashboard.jsp">
                        ← Quay lại Dashboard
                    </a></p>
            </main>

            <%-- FOOTER --%>
            <%@include file="footer.jsp" %>
        </div>
    </body>
</html>