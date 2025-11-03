<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán Chuyển Khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .bank-transfer-box {
            margin: 80px auto;
            width: 500px;
            max-width: 90%;
            background-color: #fff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            text-align: center;
        }
        .bank-transfer-box h2 {
            color: #D9537A; /* Màu hồng/đỏ cho tiêu đề */
            font-size: 24px;
            margin-bottom: 20px;
        }
        .bank-details {
            text-align: left;
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #D9537A; /* Viền hồng */
            background-color: #fff0f5; /* Nền nhạt */
            border-radius: 5px;
            font-size: 16px;
        }
        .bank-details ul {
            list-style: none; /* Bỏ dấu chấm mặc định */
            padding-left: 0;
        }
        .bank-details li {
            margin-bottom: 8px;
        }
        .qr-code-container {
            width: 250px;
            height: auto;
            margin: 20px auto;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 8px;
        }
        .qr-code-container img {
            width: 100%;
            height: auto;
            display: block;
        }
        .note-text {
            color: #dc3545; /* Màu đỏ nổi bật cho ghi chú */
            font-weight: bold;
            font-size: 15px;
            margin-top: 15px;
        }
        .btn-back-shop {
            display: inline-block;
            margin-top: 20px;
            color: #32CD32; /* Màu xanh lá cây nổi bật */
            text-decoration: none;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>
    
    <div class="bank-transfer-box">
        <h2><i class="fas fa-credit-card"></i> Thanh toán chuyển khoản ngân hàng</h2>
        
        <p style="margin-bottom: 20px;">Xin chào, Khách hàng</p>
        <p>Vui lòng chuyển khoản đến:</p>
        
        <div class="bank-details">
            <ul>
                <li>Ngân hàng: <strong>Vietcombank</strong></li>
                <li>Số tài khoản: <strong style="color: #D9537A;">1025284735</strong></li>
                <li>Chủ tài khoản: <strong>ĐOÀN QUỐC TRUNG</strong></li>
            </ul>
        </div>
        
        <%-- KHỐI QR CODE --%>
        <div class="qr-code-container">
            <img src="${pageContext.request.contextPath}/media/vietcombankqr.jpg" alt="QR Code Vietcombank">
        </div>
        
        <p class="note-text">Ghi chú chuyển khoản: Tên + SĐT</p>
        
        <p style="margin-top: 15px; font-size: 14px;">Sau khi chuyển khoản, shop sẽ liên hệ xác nhận!</p>
        
        <a href="${pageContext.request.contextPath}/home.jsp" class="btn-back-shop">
            ← Quay về cửa hàng
        </a>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>