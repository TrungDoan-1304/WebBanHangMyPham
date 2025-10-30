<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - Chi Tiết Sản Phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* CSS DÀNH RIÊNG CHO TRANG CHI TIẾT SẢN PHẨM */
        .detail-container {
            width: 80%;
            margin: 100px auto 50px auto; 
            display: flex;
            gap: 40px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        
        /* PHẦN ẢNH (Bên trái) */
        .image-gallery {
            width: 45%;
        }
        .main-image-box {
            position: relative;
        }
        .main-image-box img {
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        /* Gallery Ảnh Phụ */
        .sub-image-gallery {
            margin-top: 15px;
            width: 100%;
            overflow: hidden;
            position: relative;
            padding: 0 10px;
        }
        .sub-image-container {
            display: flex;
            gap: 10px;
            scroll-behavior: smooth;
            overflow-x: auto; /* Cho phép cuộn ngang */
            padding-bottom: 10px; /* Để tránh thanh cuộn dính vào ảnh */
        }
        .sub-image-item {
            width: 80px; 
            height: 80px;
            flex-shrink: 0;
            cursor: pointer;
            border: 2px solid #eee;
            transition: border-color 0.2s;
            object-fit: cover;
            border-radius: 4px;
        }
        .sub-image-item.active {
            border-color: #D9537A;
        }

        /* PHẦN CHI TIẾT (Bên phải) */
        .product-details {
            width: 55%;
        }
        .product-details h1 {
            color: #D9537A;
            font-size: 32px;
            margin-top: 0;
        }
        .product-details .price {
            font-size: 30px;
            color: #C0426A;
            font-weight: bold;
            margin: 20px 0;
        }
        .product-details .description-text {
            line-height: 1.6;
            color: #555;
            margin-bottom: 30px;
        }

        /* Control Số lượng */
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        .quantity-control input {
            width: 50px;
            text-align: center;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .quantity-control button {
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            padding: 5px 10px;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
        }
        .btn-action {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-right: 15px;
            transition: opacity 0.3s;
        }
        .btn-add-cart {
            background-color: #D9537A;
            color: white;
        }
        .btn-buy-now {
            background-color: #5cb85c;
            color: white;
        }
    </style>
</head>
<body>

    <%@include file="header.jsp" %> 
    
    <c:choose>
        <c:when test="${not empty product}">
            <div class="detail-container">
                
                <%-- KHỐI BÊN TRÁI: ẢNH VÀ GALLERY --%>
                <div class="image-gallery">
                    <div class="main-image-box">
                        <img src="${pageContext.request.contextPath}/${product.mainImageUrl}" 
                             alt="${product.name}" id="mainProductImage">
                    </div>

                    <%-- GALLERY ẢNH PHỤ --%>
                    <div class="sub-image-gallery">
                        <div class="sub-image-container" id="subImageContainer">
                            
                            <%-- Ảnh chính (Thumbnail) --%>
                            <img src="${pageContext.request.contextPath}/${product.mainImageUrl}" 
                                 class="sub-image-item active" 
                                 data-full-src="${pageContext.request.contextPath}/${product.mainImageUrl}"
                                 alt="Ảnh chính" 
                                 onclick="changeMainImage(this)">
                            
                            <%-- Ảnh phụ (Lặp qua subImages từ Controller) --%>
                            <c:forEach var="imageUrl" items="${subImages}">
                                <img src="${pageContext.request.contextPath}/${imageUrl}" 
                                     class="sub-image-item" 
                                     data-full-src="${pageContext.request.contextPath}/${imageUrl}"
                                     alt="Ảnh phụ"
                                     onclick="changeMainImage(this)">
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <%-- KHỐI BÊN PHẢI: MÔ TẢ, GIÁ VÀ CHỨC NĂNG MUA HÀNG --%>
                <div class="product-details">
                    <h1>${product.name}</h1>
                    
                    <p class="price">
                        <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="VND"/>
                    </p>
                    
                    <%-- PHẦN MÔ TẢ --%>
                    <p class="description-text">${product.description}</p>
                    
                    <form action="${pageContext.request.contextPath}/addToCart" method="POST">
                        <input type="hidden" name="productId" value="${product.productId}">
                        
                        <%-- CONTROL SỐ LƯỢNG --%>
                        <div class="quantity-control">
                            <label for="quantity">Số lượng:</label>
                            <button type="button" onclick="changeQuantity(-1)">-</button>
                            <input type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stockQuantity}" required>
                            <button type="button" onclick="changeQuantity(1)">+</button>
                            (Tồn kho: ${product.stockQuantity})
                        </div>
                        
                        <%-- NÚT MUA HÀNG --%>
                        <button type="submit" class="btn-action btn-add-cart" name="action" value="add">Thêm vào Giỏ hàng</button>
                        <button type="submit" class="btn-action btn-buy-now" name="action" value="buy">Đặt hàng ngay</button>
                    </form>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="detail-container" style="text-align: center;">
                <h2>Sản phẩm bạn tìm kiếm không tồn tại.</h2>
                <p><a href="${pageContext.request.contextPath}/home">Quay về trang chủ</a></p>
            </div>
        </c:otherwise>
    </c:choose>

    <%@include file="footer.jsp" %>
    
    <script>
        // Hàm thay đổi ảnh chính khi click vào thumbnail
        function changeMainImage(thumbnail) {
            const mainImage = document.getElementById('mainProductImage');
            const container = document.getElementById('subImageContainer');

            // Đổi đường dẫn ảnh chính
            mainImage.src = thumbnail.getAttribute('data-full-src');
            
            // Cập nhật trạng thái active
            container.querySelectorAll('.sub-image-item').forEach(img => {
                img.classList.remove('active');
            });
            thumbnail.classList.add('active');
        }

        // Hàm tăng giảm số lượng
        function changeQuantity(change) {
            const qtyInput = document.getElementById('quantity');
            let currentValue = parseInt(qtyInput.value);
            let maxValue = parseInt(qtyInput.max);
            let newValue = currentValue + change;
            
            if (newValue >= 1 && newValue <= maxValue) {
                qtyInput.value = newValue;
            }
        }
    </script>
</body>
</html>