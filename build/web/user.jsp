<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page isELIgnored="false" %>

<%-- Lấy đối tượng User hiện tại từ Session --%>
<c:set var="user" value="${sessionScope.currentUser}" />

<!DOCTYPE html>
<html>
    <head>
        <title>Hồ Sơ Của Tôi - Mỹ Phẩm Cao Cấp</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            /* CSS cho bố cục Hồ sơ */
            .profile-container {
                width: 85%;
                margin: 80px auto 50px auto;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                display: flex;
                gap: 30px;
                min-height: 700px;
            }
            .profile-sidebar {
                width: 250px;
                flex-shrink: 0;
                background-color: #f7f7f7;
                padding: 20px 0;
                border-radius: 8px;
            }
            .profile-menu {
                list-style: none;
                padding: 0;
            }
            .profile-menu li a {
                display: block;
                padding: 15px 20px;
                text-decoration: none;
                color: #333;
                font-size: 16px;
                border-left: 5px solid transparent;
                transition: all 0.2s;
            }
            .profile-menu li a:hover, .profile-menu li.active a {
                background-color: #fff0f5;
                color: #D9537A;
                border-left-color: #D9537A;
                font-weight: bold;
            }
            .profile-menu i {
                margin-right: 10px;
            }

            /* Nội dung chính */
            .profile-content {
                flex-grow: 1;
                padding: 10px 20px;
            }
            .profile-content h2 {
                color: #D9537A;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 30px;
            }

            /* Form styling */
            .form-section {
                background-color: #fff;
                padding: 25px;
                border: 1px solid #ddd;
                border-radius: 6px;
                margin-bottom: 40px;
            }
            .form-section h3 {
                color: #333;
                font-size: 20px;
                border-bottom: 1px solid #ddd;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
            .form-group label {
                font-weight: 600;
                display: block;
                margin-bottom: 5px;
            }
            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                margin-bottom: 15px;
                box-sizing: border-box;
            }
            .btn-action {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s;
                margin-right: 10px;
            }
            .btn-success {
                background-color: #32CD32;
                color: white;
            }
            .btn-secondary {
                background-color: #ccc;
                color: #333;
            }
            .readonly-field {
                background-color: #f0f0f0;
                cursor: not-allowed;
            }
            .tab-content {
                display: none;
                padding-top: 15px;
            }
            .tab-content.active {
                display: block;
            }
            .info-display-group {
                margin-bottom: 20px;
            }
            .info-display-group label {
                font-weight: 600;
                display: block;
                color: #D9537A; /* Màu hồng cho tiêu đề trường */
                margin-bottom: 5px;
                border-bottom: 1px dotted #eee;
            }
            .info-display-group p {
                font-size: 16px;
                color: #333;
                padding: 5px 0;
                margin: 0;
            }
            .btn-change-profile {
                /* Style tương tự btn-success */
                background-color: #32CD32;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-weight: bold;
                cursor: pointer;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>

        <%@include file="header.jsp" %>

        <div class="profile-container">

            <%-- SIDEBAR MENU --%>
            <aside class="profile-sidebar">
                <ul class="profile-menu">
                    <%-- MỤC MỚI: HỒ SƠ CÁ NHÂN (Chỉ xem) --%>
                    <li class="active"><a href="user.jsp" onclick="showTab('viewProfile', this)"><i class="fas fa-user-alt"></i> Hồ Sơ Cá Nhân</a></li>
                        <%-- MỤC MỚI: THAY ĐỔI THÔNG TIN (Form) --%>
                    <li><a href="#" onclick="showTab('editProfile', this)"><i class="fas fa-edit"></i> Thay Đổi Thông Tin</a></li>

                    <li><a href="orders"><i class="fas fa-box-open"></i> Đơn hàng</a></li>
                    <li><a href="cart"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a></li>
                    <li><a href="logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                </ul>
            </aside>

            <%-- NỘI DUNG CHÍNH --%>
            <main class="profile-content">

                <c:if test="${not empty requestScope.statusMessage}">
                    <div style="padding: 10px; margin-bottom: 20px; color: ${requestScope.statusType == 'success' ? 'green' : 'red'}; border: 1px solid currentColor; border-radius: 4px;">
                        ${requestScope.statusMessage}
                    </div>
                </c:if>
                <div id="viewProfile" class="tab-content active">
                    <h2>Hồ Sơ Cá Nhân</h2>

                    <div class="info-display-group">
                        <label>Họ và tên:</label>
                        <p>${user.fullName}</p>
                    </div>
                    <div class="info-display-group">
                        <label>Email:</label>
                        <p>${user.email}</p>
                    </div>
                    <div class="info-display-group">
                        <label>Số điện thoại:</label>
                        <p>${user.phonenumber != null && !user.phonenumber.isEmpty() ? user.phonenumber : 'Chưa cập nhật'}</p>
                    </div>
                    <div class="info-display-group">
                        <label>Địa chỉ:</label>
                        <p>${user.address != null && !user.address.isEmpty() ? user.address : 'Chưa cập nhật'}</p>
                    </div>
                </div>
                <div id="editProfile" class="tab-content">
                    <h2>Thay Đổi Thông Tin Cá Nhân</h2>

                    <%-- PHẦN 1: CHỈNH SỬA SĐT/ĐỊA CHỈ --%>
                    <div class="form-section">
                        <h3>Chỉnh Sửa Thông Tin Cơ Bản</h3>
                        <form action="${pageContext.request.contextPath}/updateProfile" method="POST">
                            <div class="form-group">
                                <label>Họ và tên:</label>
                                <input type="text" name="full_name" value="${user.fullName}" required>
                            </div>
                            <div class="form-group">
                                <label>Email:</label>
                                <input type="email" value="${user.email}" readonly class="readonly-field">
                                <p style="font-size: 12px; color: #777;">*Email là duy nhất, không thể chỉnh sửa trực tiếp.</p>
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại:</label>
                                <input type="text" name="phone_number" value="${user.phonenumber}" placeholder="Nhập số điện thoại mới">
                            </div>
                            <div class="form-group">
                                <label>Địa chỉ:</label>
                                <input type="text" name="address" value="${user.address}" placeholder="Nhập địa chỉ mới">
                            </div>

                            <button type="submit" class="btn-action btn-success"><i class="fas fa-save"></i> Lưu Thông Tin</button>
                        </form>
                    </div>

                    <%-- PHẦN 2: ĐỔI MẬT KHẨU --%>
                    <div class="form-section">
                        <h3>Đổi Mật Khẩu</h3>
                        <form action="${pageContext.request.contextPath}/changePassword" method="POST">

                            <div class="form-group">
                                <label>Mật khẩu hiện tại:</label>
                                <input type="password" name="currentPassword" required>
                            </div>

                            <div class="form-group">
                                <label>Mật khẩu mới:</label>
                                <input type="password" name="newPassword" required>
                            </div>

                            <div class="form-group">
                                <label>Xác nhận mật khẩu mới:</label>
                                <input type="password" name="confirmNewPassword" required>
                            </div>

                            <button type="submit" class="btn-action btn-success"><i class="fas fa-lock"></i> Lưu Thay Đổi</button>
                        </form>
                    </div>

                </div>
                <%-- KHỐI HIỂN THỊ THÔNG BÁO TỪ SESSION --%>
                <c:if test="${not empty sessionScope.statusMessage}">
                    <div class="alert alert-${sessionScope.statusType} status-message">
                        ${sessionScope.statusMessage}
                    </div>
                    <%-- XÓA THÔNG BÁO KHỎI SESSION NGAY SAU KHI HIỂN THỊ --%>
                    <c:remove var="statusMessage" scope="session"/>
                    <c:remove var="statusType" scope="session"/>
                </c:if>
            </main>
        </div>

        <%@include file="footer.jsp" %>

        <script>
            function showTab(tabId, clickedElement) {
                // Ẩn tất cả các tab content
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });
                // Hiển thị tab được chọn
                document.getElementById(tabId).classList.add('active');

                // Cập nhật trạng thái active cho Sidebar
                document.querySelectorAll('.profile-menu li').forEach(li => {
                    li.classList.remove('active');
                });
                // Tìm thẻ <li> chứa thẻ <a> được click và thêm class active
                if (clickedElement) {
                    clickedElement.closest('li').classList.add('active');
                }
            }

            // Khởi tạo tab Hồ sơ cá nhân khi tải trang
            document.addEventListener('DOMContentLoaded', function () {
                showTab('viewProfile', document.querySelector('.profile-menu li'));
            });
            function showTab(tabId, clickedElement) {
                // ... (Giữ nguyên nội dung hàm showTab hiện tại của bạn) ...
                document.querySelectorAll('.tab-content').forEach(tab => {
                    tab.classList.remove('active');
                });
                document.getElementById(tabId).classList.add('active');

                document.querySelectorAll('.profile-menu li').forEach(li => {
                    li.classList.remove('active');
                });
                if (clickedElement) {
                    clickedElement.closest('li').classList.add('active');
                }
            }

// Khởi tạo tab Hồ sơ cá nhân hoặc tab Chỉnh sửa
            document.addEventListener('DOMContentLoaded', function () {
                const urlParams = new URLSearchParams(window.location.search);
                const requestedTab = urlParams.get('tab');

                if (requestedTab === 'edit') {
                    // Nếu có tham số 'tab=edit', mở tab "Thay Đổi Thông Tin"
                    const editLink = document.querySelector('a[href*="editProfile"]');
                    if (editLink) {
                        showTab('editProfile', editLink);
                    } else {
                        // Fallback nếu không tìm thấy link (nên chỉ định tabId và element default)
                        showTab('viewProfile', document.querySelector('.profile-menu li.active a'));
                    }
                } else {
                    // Mặc định mở tab Hồ sơ Cá nhân (viewProfile)
                    showTab('viewProfile', document.querySelector('.profile-menu li.active a'));
                }
            });
        </script>
    </body>
</html>
