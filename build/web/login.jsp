<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Popup</title>
    
    <%-- Thêm Font Awesome để sử dụng icon con mắt --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <style>
        /* CSS cho MODAL/POPUP (Bao quanh toàn bộ màn hình khi mở) */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7); 
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1050; 
            /* Để popup ẩn mặc định, hãy thêm display: none; vào đây hoặc qua JavaScript */
            display: none; 
        }

        /* KHỐI FORM CHÍNH */
        .login-box {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            width: 380px;
            max-width: 90%;
            text-align: center;
            position: relative;
        }

        /* Nút Đóng (X) */
        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 24px;
            color: #ccc;
            cursor: pointer;
            transition: color 0.2s;
        }
        .close-btn:hover {
            color: #D9537A;
        }

        /* Tiêu đề */
        .login-box h2 {
            font-size: 26px;
            color: #D9537A;
            margin-bottom: 25px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }

        /* Nhóm input */
        .input-group {
            margin-bottom: 20px;
            position: relative; /* QUAN TRỌNG: Để icon nằm trong group */
        }
        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #D9537A; 
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s;
        }
        .input-group input:focus {
            border-color: #C0426A;
            box-shadow: 0 0 5px rgba(217, 83, 122, 0.3);
        }

        /* CSS cho icon ẩn/hiện mật khẩu */
        .toggle-password {
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            z-index: 10;
        }

        /* Nút Đăng nhập chính */
        .btn-login {
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
            margin-bottom: 15px;
        }
        .btn-login:hover {
            background-color: #C0426A;
        }
        
        /* Link quên mật khẩu/Đăng ký */
        .links-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
        }
        .links-row a {
            color: #555;
            text-decoration: none;
            transition: color 0.3s;
        }
        .links-row a:hover {
            color: #D9537A;
        }

    </style>
</head>
<body>

    <div class="modal-overlay" id="loginModal">
        <div class="modal-overlay" id="forgotPasswordModal" style="display: none;">
    <div class="login-box">
        
        <span class="close-btn" onclick="closeForgotPasswordModal();">&times;</span>
        
        <h2>KHÔI PHỤC MẬT KHẨU</h2>
        
        <%-- Hiển thị thông báo (nếu có) --%>
        <c:if test="${not empty requestScope.fpMessage}">
            <p style="color: green; font-weight: bold;">${requestScope.fpMessage}</p>
        </c:if>
        <c:if test="${not empty requestScope.fpError}">
            <p style="color: red; font-weight: bold;">${requestScope.fpError}</p>
        </c:if>

        <form action="forgotPassword" method="POST">
            
            <div class="input-group">
                <input type="email" name="email" placeholder="Nhập Email đã đăng ký" required>
            </div>
            
            <button type="submit" class="btn-login">GỬI MẬT KHẨU</button>
        </form>
        
        <div class="links-row">
            <a href="#" onclick="openLoginModal(); return false;">Quay lại Đăng nhập</a>
        </div>
        
    </div>
</div>
        <div class="login-box">
            
            <span class="close-btn" onclick="document.getElementById('loginModal').style.display='none'">&times;</span>
            
            <h2>ĐĂNG NHẬP</h2>
            
            <form action="LoginController" method="POST">
                
                <div class="input-group">
                    <input type="text" name="username" placeholder="Tên đăng nhập hoặc Email" required>
                </div>
                
                <div class="input-group">
                    <input type="password" name="password" id="passwordField" placeholder="Mật khẩu" required>
                  
                    <i class="fas fa-eye toggle-password" id="togglePass" onclick="togglePasswordVisibility()"></i>
                </div>
                
                <button type="submit" class="btn-login">ĐĂNG NHẬP</button>
            </form>
            
            <div class="links-row">
                <a href="#" onclick="openForgotPasswordModal(); return false;">Quên mật khẩu?</a>
                <a href="register.jsp">Đăng ký tài khoản</a>
            </div>
            
        </div>
    </div>

    <script>
        function openForgotPasswordModal() {
        document.getElementById('loginModal').style.display = 'none';
        document.getElementById('forgotPasswordModal').style.display = 'flex';
    }
        function closeForgotPasswordModal() {
        document.getElementById('forgotPasswordModal').style.display = 'none';
    }
        function togglePasswordVisibility() {
            const passwordField = document.getElementById('passwordField');
            const toggleIcon = document.getElementById('togglePass');

       
            if (passwordField.type === 'password') {
                passwordField.type = 'text'; 
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash'); 
            } else {
                passwordField.type = 'password'; 
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye'); 
            }
        }   
        function openLoginModal() {
            document.getElementById('loginModal').style.display = 'flex';
        }
        
        function closeLoginModal() {
            document.getElementById('loginModal').style.display = 'none';
        }
    </script>

</body>
</html>