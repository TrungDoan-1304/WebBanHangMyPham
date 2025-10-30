<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <script>
        // Tọa độ mặc định của cửa hàng (Ví dụ: 218 Lĩnh Nam, Hà Nội)
        const DEFAULT_LAT = 21.0044; // Vĩ độ
        const DEFAULT_LNG = 105.8643; // Kinh độ
        const DEFAULT_ZOOM = 15;
        
        let map; // Biến toàn cục để lưu đối tượng bản đồ
        let marker; // Biến toàn cục để lưu đối tượng điểm đánh dấu

        // Hàm được gọi tự động khi Google Maps API tải xong
        function initMap() {
            const mapElement = document.getElementById('mapLocation');
            
            // Thiết lập tùy chọn bản đồ
            const mapOptions = {
                center: { lat: DEFAULT_LAT, lng: DEFAULT_LNG },
                zoom: DEFAULT_ZOOM,
                // Tắt các điều khiển không cần thiết để có giao diện sạch
                mapTypeControl: false, 
                streetViewControl: false 
            };
            
            // Khởi tạo bản đồ
            map = new google.maps.Map(mapElement, mapOptions);

            // Thêm điểm đánh dấu mặc định (Marker)
            marker = new google.maps.Marker({
                position: { lat: DEFAULT_LAT, lng: DEFAULT_LNG },
                map: map,
                title: 'Shop Mỹ Phẩm TD'
            });
            
            // Hiển thị thông báo (InfoWindow) khi click vào marker
            const infoWindow = new google.maps.InfoWindow({
                content: '<h6>Shop Mỹ Phẩm TD</h6><p>218 Lĩnh Nam, Hà Nội</p>'
            });
            
            marker.addListener('click', () => {
                infoWindow.open(map, marker);
            });
        }
        </script>
<head>
    <title>Liên Hệ - Mỹ Phẩm Cao Cấp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* CSS cho bố cục liên hệ 2 cột */
        .contact-layout {
            height: 80vh; /* Chiếm phần lớn màn hình */
            display: flex;
            justify-content: center;
            align-items: center;
            background: url('media/contact_bg.jpg') no-repeat center center / cover; /* Thay ảnh nền */
            position: relative;
            padding-top: 60px;
        }
        .contact-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.6); /* Lớp phủ mờ */
        }
        .contact-content {
            position: relative;
            z-index: 10;
            display: flex;
            gap: 30px;
            width: 85%;
            max-width: 1100px;
        }

        /* Khối Form và Thông tin */
        .contact-form-box, .contact-info-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            flex: 1; /* Chia đều 2 cột */
        }
        .contact-form-box {
            background-color: rgba(0, 0, 0, 0.6); /* Nền tối mờ cho Form */
            color: white;
        }
        .contact-info-box {
            background-color: rgba(255, 255, 255, 0.9); /* Nền sáng cho Info */
            color: #333;
        }
        
        /* Form Styling */
        .contact-form-box input, .contact-form-box textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            background-color: rgba(255, 255, 255, 0.9);
        }
        .contact-form-box label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            text-align: left;
        }
        .btn-submit-contact {
            width: 100%;
            padding: 12px;
            background-color: #32CD32; /* Màu xanh lá */
            color: white;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        /* Info Styling */
        .info-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .info-item i {
            font-size: 20px;
            color: #D9537A;
            margin-right: 15px;
        }
        .map-placeholder {
            height: 250px; 
            background-color: #e0e0e0;
            margin-top: 20px;
            border-radius: 4px;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="contact-layout">
        <div class="contact-overlay"></div>
        
        <div class="contact-content">
            
            <%-- CỘT 1: FORM GỬI LIÊN HỆ --%>
            <div class="contact-form-box">
                <h2 style="color: #32CD32; text-align: center; margin-bottom: 30px;">LIÊN HỆ VỚI CHÚNG TÔI</h2>
                
                <%-- HIỂN THỊ THÔNG BÁO --%>
                <c:if test="${requestScope.contactMessage eq 'success'}">
                    <p style="color: lightgreen; font-weight: bold;">Cảm ơn bạn, thư đã được gửi thành công!</p>
                </c:if>
                <c:if test="${requestScope.contactMessage eq 'failure'}">
                    <p style="color: red; font-weight: bold;">Lỗi: Không gửi được email. Vui lòng thử lại sau.</p>
                </c:if>

                <form action="lienhe" method="POST">
                    <label for="hoTen">Họ và tên</label>
                    <input type="text" id="hoTen" name="hoTen" placeholder="Nhập họ tên" required>
                    
                    <label for="emailLienHe">Email liên hệ</label>
                    <input type="email" id="emailLienHe" name="emailLienHe" placeholder="abc@example.com" required>
                    
                    <label for="chuDe">Chủ đề</label>
                    <input type="text" id="chuDe" name="chuDe" placeholder="Nhập chủ đề" required>
                    
                    <label for="noiDung">Nội dung</label>
                    <textarea id="noiDung" name="noiDung" rows="5" placeholder="Nội dung tin nhắn..." required></textarea>
                    
                    <button type="submit" class="btn-submit-contact"><i class="fas fa-paper-plane"></i> Gửi liên hệ ngay</button>
                </form>
            </div>
            
            <%-- CỘT 2: THÔNG TIN CỬA HÀNG & BẢN ĐỒ --%>
            <div class="contact-info-box">
                <h2 style="color: #D9537A; margin-bottom: 30px;">Thông tin cửa hàng</h2>
                
                <div class="info-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>218 Lĩnh Nam, Hoàng Mai, Hà Nội</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-phone"></i>
                    <span>0987 123 456</span>
                </div>
                <div class="info-item">
                    <i class="fas fa-envelope"></i>
                    <span>mypham24h@gmail.com</span>
                </div>
                <div class="info-item">
                    <i class="fab fa-facebook"></i>
                    <span>facebook.com/myphamchinhhang</span>
                </div>
                <div class="info-item">
                    <i class="far fa-clock"></i>
                    <span>Giờ mở cửa: 08h00 - 21h00 (T2 - CN)</span>
                </div>
                
                <%-- BẢN ĐỒ (Sử dụng DIV placeholder, cần JS/Iframe để nhúng Google Maps) --%>
                <div class="map-placeholder" id="mapLocation">
                    [Vị trí Bản đồ sẽ được nhúng]
                </div>
            </div>
        </div>
    </div>

    <%@include file="footer.jsp" %>
    
<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap">
</script>
</body>
</html>