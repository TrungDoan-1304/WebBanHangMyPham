<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tin Tức - Mỹ Phẩm Cao Cấp</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="container" style="display: block; width: 80%; margin: 100px auto 50px auto; text-align: center;">
        
        <h2 style="color: #D9537A; margin-bottom: 30px;">CẬP NHẬT TIN TỨC</h2>
        
        <div style="padding: 50px; border: 2px dashed #D9537A; border-radius: 8px;">
            <p style="font-size: 18px; color: #555;">
                Hiện tại, chưa có bài viết hay tin tức mới nào được cập nhật.
            </p>
            <p>Vui lòng quay lại sau!</p>
        </div>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>