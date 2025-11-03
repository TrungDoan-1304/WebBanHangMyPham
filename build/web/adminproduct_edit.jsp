<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${product.productId > 0 ? 'Sửa' : 'Thêm'} Sản Phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        .product-form {
        max-width: 600px;
        margin: 0 auto; /* Căn giữa form */
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        text-align: left;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .product-form label {
        display: block;
        font-weight: 600;
        margin-bottom: 5px;
    }
    .product-form input[type="text"],
    .product-form input[type="number"],
    .product-form textarea {
        width: 100%; /* Đảm bảo input chiếm toàn bộ chiều ngang */
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    .product-form textarea {
        resize: vertical;
        min-height: 100px;
    }
    /* Style cho Checkbox */
    .checkbox-group {
        margin-top: 15px;
        padding: 10px 0;
        border-top: 1px solid #eee;
    }
    .checkbox-group label {
        font-weight: normal;
        display: inline-block;
        margin-right: 20px;
    }
    /* Style cho nút LƯU/QUAY LẠI */
    .btn-save-edit {
        background-color: #00897b;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
        margin-top: 20px;
    }
    .btn-cancel {
        color: #555;
        text-decoration: none;
        margin-left: 15px;
    }
    </style>
    </head>
<body>
    <div class="admin-layout">
        <%-- HEADER ADMIN --%>
        
        <main class="dashboard-content" style="margin-left: 250px;">
            <h2>${product.productId > 0 ? 'Sửa Thông Tin Sản Phẩm' : 'Thêm Sản Phẩm Mới'}</h2>
            
        <form action="${pageContext.request.contextPath}/adminproducts" method="POST" class="product-form">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="productId" value="${product.productId}">
                
                <div class="form-group">
                    <label for="name">Tên Sản phẩm:</label>
                    <input type="text" id="name" name="name" value="${product.name}" required>
                </div>
                
                <div class="form-group">
                    <label for="slug">Slug (URL):</label>
                    <input type="text" id="slug" name="slug" value="${product.slug}" required>
                </div>
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description">${product.description}</textarea>
                </div>
                <div class="form-group">
                    <label for="price">Giá</label>
                    <input type ="number" id="price" name="price" value="${product.price}" required>
                </div>
                <div class="form-group">
                    <label for="stockQuantity">Tồn kho:</label>
                    <input type="number" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}" required>
                </div>
                <div class="form-group">
                    <label for="categoryId">ID Danh mục:</label>
                    <input type="number" id="categoryId" name="categoryId" value="${product.categoryId}" required>
                </div>
                <div class="form-group">
                    <label for="brandId">ID Thương hiệu:</label>
                    <input type="number" id="brandId" name="brandId" value="${product.brandId}" required>
                </div>
                <div class="form-group">
                    <input type="checkbox" name="isActive" ${product.isActive ? 'checked' : ''}>
                    <label>Hiển thị (Active)</label>
                </div>
                <div class="form-group">
                    <input type="checkbox" name="isFeatured" ${product.isFeatured ? 'checked' : ''}>
                    <label>Nổi bật (Featured)</label>
                </div>
                
                <button type="submit" class="btn-action-small btn-success">Lưu Thông Tin</button>
                <a href="${pageContext.request.contextPath}/adminproducts" class="btn-action-small btn-secondary">Quay lại</a>
            </form>
        </main>
        
        <%-- FOOTER --%>
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>