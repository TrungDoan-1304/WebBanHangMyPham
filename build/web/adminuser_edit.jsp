<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${user.userId > 0 ? 'Sửa' : 'Thêm'} Người Dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .user-form { max-width: 600px; margin: 0 auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .user-form label { display: block; font-weight: 600; margin-bottom: 5px; }
        .user-form input[type="text"], .user-form input[type="email"], .user-form select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .readonly-field { background-color: #f0f0f0; cursor: not-allowed; }
        .btn-save-edit { background-color: #00897b; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; margin-top: 20px; }
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
            <h2>${user.userId > 0 ? 'Sửa Thông Tin Người Dùng #' : 'Thêm Người Dùng Mới'} ${user.userId}</h2>
            
            <form action="${pageContext.request.contextPath}/adminusers" method="POST" class="user-form">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="userId" value="${user.userId}">
                
                <div class="form-group">
                    <label>Username:</label>
                    <input type="text" name="username" value="${user.username}" readonly class="readonly-field">
                </div>
                
                <div class="form-group">
                    <label>Họ và Tên:</label>
                    <input type="text" name="fullName" value="${user.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" value="${user.email}" readonly class="readonly-field">
                </div>
                
                <div class="form-group">
                    <label>Số điện thoại:</label>
                    <input type="text" name="phonenumber" value="${user.phonenumber}">
                </div>
                
                <div class="form-group">
                    <label>Địa chỉ:</label>
                    <input type="text" name="address" value="${user.address}">
                </div>
                
                <div class="form-group">
                    <label>Vai trò (Role):</label>
                    <select name="role" required>
                        <option value="customer" ${user.role eq 'customer' ? 'selected' : ''}>Customer</option>
                        <option value="admin" ${user.role eq 'admin' ? 'selected' : ''}>Admin</option>
                    </select>
                </div>

                <button type="submit" class="btn-save-edit"><i class="fas fa-save"></i> Lưu Thông Tin</button>
                <a href="${pageContext.request.contextPath}/adminusers" class="btn-cancel">Quay lại</a>
            </form>
            
        </main>
        
        <%-- FOOTER --%>
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>