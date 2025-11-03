<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Người Dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* CSS Admin Layout (Giả định nằm trong style.css hoặc được include) */
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .admin-table th, .admin-table td { padding: 10px; border: 1px solid #ddd; text-align: left; font-size: 14px; }
        .btn-action-small { padding: 5px 10px; margin-right: 5px; border-radius: 3px; cursor: pointer; }
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
    
    <%-- HEADER ADMIN (Giả định bạn đã INCLUDE header admin tại đây) --%>
    
    <div class="admin-main-content">
        <%-- SIDEBAR MENU (Giả định bạn đã INCLUDE sidebar admin) --%>
        
        <main class="dashboard-content" style="margin-left: 250px;">
            <h2><i class="fas fa-users"></i> Danh Sách Người Dùng</h2>
            
            <a href="adminusers?action=create" class="btn-action-small btn-success" style="margin-bottom: 20px; display: none;">
                <i class="fas fa-plus"></i> Thêm Người Dùng Mới </a>
            
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${listUser}">
                        <tr>
                            <td>${user.userId}</td>
                            <td><strong>${user.username}</strong></td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>
                                <span style="color: ${user.role eq 'admin' ? 'red' : 'green'}; font-weight: bold;">
                                    ${user.role}
                                </span>
                            </td>
                            <td>
                                <a href="adminusers?action=edit&id=${user.userId}" class="btn-action-small" style="background-color: #ffc107;">Sửa</a>
                                <a href="adminusers?action=delete&id=${user.userId}" class="btn-action-small" 
                                   style="background-color: #dc3545; color: white;" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng ${user.username} không?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listUser}">
                        <tr><td colspan="6">Hiện chưa có người dùng nào đăng ký.</td></tr>
                    </c:if>
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