<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thanh Toán Chuyển Khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        .bank-details {
            text-align: left;
            margin: 20px 0;
            padding: 15px;
            border: 1px dashed #D9537A;
            border-radius: 5px;
        }
        .bank-details ul {
            list-style: disc;
            padding-left: 20px;
        }
        .qr-code {
            width: 200px;
            height: 200px;
            margin: 20px auto;
        }
        .qr-code img {
            width: 100%;
        }
        .note-text {
            color: #dc3545;
            font-weight: bold;
            margin-top: 20px;
        }
        .btn-back-shop {
            display: inline-block;
            margin-top: 30px;
            color: #007bff;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>
    
    <div class="bank-transfer-box">
        <h2><i class="fas fa-credit-card"></i> Thanh toán chuyển khoản ngân hàng</h2>
        
        <p>Xin chào, Khách hàng</p>
        <p>Vui lòng chuyển khoản đến:</p>
        
        <div class="bank-details">
            <ul>
                <li>Ngân hàng: <strong>Vietcombank</strong></li>
                <li>Số tài khoản: <strong>1025284735</strong></li>
                <li>Chủ tài khoản: <strong>ĐOÀN QUỐC TRUNG</strong></li>
            </ul>
        </div>
        
        <div class="qr-code">
            <%-- Giả định URL QR code được tạo sẵn hoặc tĩnh --%>
            <img src="${pageContext.request.contextPath}/media/vietcombankqr.jpg" alt="QR Code Vietcombank">
        </div>
        
        <p class="note-text">Ghi chú chuyển khoản: Tên + SĐT</p>
        
        <p style="margin-top: 10px; font-size: 14px;">Sau khi chuyển khoản, shop sẽ liên hệ xác nhận!</p>
        
        <a href="${pageContext.request.contextPath}/home" class="btn-back-shop">
            ← Quay về cửa hàng
        </a>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>