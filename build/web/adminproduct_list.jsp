<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Sản Phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS bổ sung cho bảng quản lý */
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .admin-table th, .admin-table td { padding: 10px; border: 1px solid #ddd; text-align: left; font-size: 14px; }
        .admin-table th { background-color: #f0f0f0; }
        .btn-action-small { padding: 5px 10px; margin-right: 5px; border-radius: 3px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <%-- HEADER ADMIN (Giả sử bạn đã INCLUDE hoặc nằm trong file này) --%>
        
        <main class="dashboard-content" style="margin-left: 250px;">
            <h2><i class="fas fa-box"></i> Danh Sách Sản Phẩm</h2>
            
            <a href="adminproducts?action=create" class="btn-action-small btn-success" style="margin-bottom: 20px; display: inline-block;">
                <i class="fas fa-plus"></i> Thêm Sản Phẩm Mới
            </a>
            
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Sản phẩm</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Danh mục</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${listProduct}">
                        <tr>
                            <td>${product.productId}</td>
                            <td>${product.name}</td>
                            <td><fmt:formatNumber value="${product.price}" pattern="#,##0"/> VND</td>
                            <td>${product.stockQuantity}</td>
                            <td>${product.categoryId}</td> <%-- Cần JOIN/tìm tên danh mục --%>
                            <td>
                                <a href="adminproducts?action=edit&id=${product.productId}" class="btn-action-small" style="background-color: #ffc107;">Sửa</a>
                                <a href="adminproducts?action=delete&id=${product.productId}" class="btn-action-small" 
                                   style="background-color: #dc3545; color: white;" 
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listProduct}">
                        <tr><td colspan="6">Hiện chưa có sản phẩm nào trong cửa hàng.</td></tr>
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