<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cập Nhật Trạng Thái Đơn Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .edit-form { max-width: 500px; margin: 20px; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .edit-form label { display: block; font-weight: 600; margin-bottom: 5px; }
        .edit-form select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-save-edit { background-color: #00897b; color: white; padding: 10px 20px; border: none; }
        .btn-cancel { color: #555; text-decoration: none; margin-left: 15px; }
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
            <h2>Cập Nhật Trạng Thái Đơn Hàng #${order.orderId}</h2>
            
            <form action="adminorders" method="POST" class="edit-form">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="orderId" value="${order.orderId}">
                
                <p><strong>Ngày đặt:</strong> ${order.orderDate}</p>
                <p><strong>Tổng tiền:</strong> ${order.totalAmount} VND</p>
                
                <div class="form-group">
                    <label for="status">Trạng thái đơn hàng:</label>
                    <select id="status" name="status" required>
                        <option value="pending" ${order.status eq 'pending' ? 'selected' : ''}>Chờ xử lý (Pending)</option>
                        <option value="processing" ${order.status eq 'processing' ? 'selected' : ''}>Đang xử lý (Processing)</option>
                        <option value="shipped" ${order.status eq 'shipped' ? 'selected' : ''}>Đang giao (Shipped)</option>
                        <option value="delivered" ${order.status eq 'delivered' ? 'selected' : ''}>Đã giao (Delivered)</option>
                        <option value="canceled" ${order.status eq 'canceled' ? 'selected' : ''}>Đã hủy (Canceled)</option>
                    </select>
                </div>

                <button type="submit" class="btn-save-edit">Lưu Thay Đổi</button>
                <a href="adminorders" class="btn-cancel">Quay lại</a>
            </form>
            
        </main>
        
        <%-- FOOTER --%>
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>