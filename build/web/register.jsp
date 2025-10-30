<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản Mới</title>
    
    <%-- Có thể tái sử dụng CSS từ login_popup_content.jsp cho form. --%>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .register-box {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            width: 400px;
            max-width: 90%;
            text-align: center;
        }
        .register-box h2 {
            color: #D9537A;
            margin-bottom: 25px;
        }
        .input-group {
            margin-bottom: 15px;
        }
        .input-group input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #D9537A;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
            outline: none;
        }
        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: #D9537A;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }
        .btn-register:hover {
            background-color: #C0426A;
        }
        .links-row a {
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <div class="register-box">
        
        <h2>ĐĂNG KÝ TÀI KHOẢN</h2>

        <%-- Hiển thị thông báo lỗi (nếu có) --%>
        <c:if test="${not empty requestScope.error}">
            <p style="color: red; font-weight: bold;">${requestScope.error}</p>
        </c:if>
        
        <form action="register" method="POST">
            
            <div class="input-group">
                <input type="text" name="username" placeholder="Tên đăng nhập (Duy nhất)" required 
                       value="${requestScope.username}">
            </div>
            
            <div class="input-group">
                <input type="password" name="password" placeholder="Mật khẩu" required>
            </div>
            
            <div class="input-group">
                <input type="password" name="confirmPassword" placeholder="Nhập lại Mật khẩu" required>
            </div>
            
            <div class="input-group">
                <input type="email" name="email" placeholder="Email (Duy nhất)" required
                       value="${requestScope.email}">
            </div>
            
            <div class="input-group">
                <input type="text" name="fullName" placeholder="Họ và tên" required
                       value="${requestScope.fullName}">
            </div>
            
            <button type="submit" class="btn-register">ĐĂNG KÝ</button>
        </form>
        
        <p class="links-row" style="margin-top: 15px;">
            Đã có tài khoản? <a href="home.jsp">Đăng nhập</a>
        </p>
        
    </div>

</body>
</html>