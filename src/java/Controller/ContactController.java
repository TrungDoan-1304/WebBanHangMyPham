package Controller;

import Util.EmailUtility;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ContactController", urlPatterns = {"/lienhe"})
public class ContactController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ hiển thị trang liên hệ khi là GET
        request.getRequestDispatcher("/lienhe.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String hoTen = request.getParameter("hoTen");
        String emailLienHe = request.getParameter("emailLienHe");
        String chuDe = request.getParameter("chuDe");
        String noiDung = request.getParameter("noiDung");
        
        // Email nhận liên hệ (ví dụ: email quản trị)
        String adminEmail = "admin@myphamtd.com"; 

        String subject = "[LIÊN HỆ KHÁCH HÀNG] - " + chuDe;
        String body = "<h3>Khách hàng liên hệ từ website:</h3>" +
                      "<ul>" +
                      "<li>Họ và tên: " + hoTen + "</li>" +
                      "<li>Email: " + emailLienHe + "</li>" +
                      "<li>Chủ đề: " + chuDe + "</li>" +
                      "</ul>" +
                      "<p><b>Nội dung tin nhắn:</b></p>" +
                      "<p style='border: 1px solid #ccc; padding: 10px;'>" + noiDung + "</p>";

        boolean success = EmailUtility.sendEmail(adminEmail, subject, body);
        
        if (success) {
            request.setAttribute("contactMessage", "success");
        } else {
            request.setAttribute("contactMessage", "failure");
        }
        
        // Quay lại trang liên hệ để hiển thị thông báo
        doGet(request, response);
    }
}