<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
    <head>
        <title>Lịch Sử Đơn Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* CSS cho bố cục Hồ sơ */
            .profile-container {
                width: 85%;
                margin: 80px auto 50px auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                display: flex;
                gap: 30px;
                min-height: 700px;
            }
            .profile-sidebar {
                width: 250px;
                flex-shrink: 0;
                background-color: #f7f7f7;
                padding: 20px 0;
                border-radius: 8px;
            }
            .profile-menu {
                list-style: none;
                padding: 0;
            }
            .profile-menu li a {
                display: block;
                padding: 15px 20px;
                text-decoration: none;
                color: #333;
                font-size: 16px;
                border-left: 5px solid transparent;
                transition: all 0.2s;
            }
            .profile-menu li a:hover, .profile-menu li.active a {
                background-color: #fff0f5;
                color: #D9537A;
                border-left-color: #D9537A;
                font-weight: bold;
            }
            .profile-menu i {
                margin-right: 10px;
            }

            /* Nội dung chính */
            .profile-content {
                flex-grow: 1;
                padding: 10px 20px;
            }
            .profile-content h2 {
                color: #D9537A;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 30px;
            }
        </style>
    </head>

    <body>
        <%@include file="header.jsp" %>

        <div class="profile-container">
            <aside class="profile-sidebar">
                <ul class="profile-menu">
                    <li><a href="user.jsp"><i class="fas fa-user-alt"></i> Hồ Sơ Cá Nhân</a></li>
                    <li class="active"><a href="orders"><i class="fas fa-box-open"></i> Đơn hàng</a></li>
                    <li><a href="cart"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a></li>
                    <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </aside>

            <main class="profile-content">
                <h2>Lịch Sử Đơn Hàng</h2>

                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="order" items="${orders}">
                            <div class="form-section" style="border-left: 5px solid ${order.status eq 'delivered' ? 'green' : (order.status eq 'canceled' ? 'red' : 'orange')};">

                                <h3 style="color: #333; margin-bottom: 5px;">Đơn hàng #${order.orderId}</h3>
                                <p><strong>Ngày đặt:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                                <p><strong>Tổng tiền:</strong> <span class="price"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND" /></span></p>
                                <p><strong>Trạng thái:</strong> <span style="font-weight: bold; color: ${order.status eq 'delivered' ? 'green' : 'orange'}">${order.status}</span></p>

                                <a href="${pageContext.request.contextPath}/orderDetail?orderId=${order.orderId}" style="display: block; margin-top: 10px; color: #D9537A;">
                                    Xem chi tiết đơn hàng
                                </a>
                            </div>
                            <p>
                                <strong>Khách:</strong>
                                <c:choose>
                                    <c:when test="${not empty order.userId}">
                                        (Người dùng nội bộ)
                                    </c:when>
                                    <c:when test="${not empty order.guestInfo}">
                                        ${order.guestInfo}
                                    </c:when>
                                    <c:otherwise>
                                        N/A
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p>Bạn chưa có đơn hàng nào.</p>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>

        <%@include file="footer.jsp" %>
    </body>
</html>