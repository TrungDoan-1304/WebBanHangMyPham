/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UserDAO;
import Util.EmailUtility;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgotPassword"})
public class ForgotPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String destination = "/home.jsp"; // Chuyển hướng về trang chủ hoặc JSP chính

        // 1. Kiểm tra Email trong CSDL
        String password = userDAO.getPasswordByEmail(email);

        if (password != null) {
            // 2. Tìm thấy Email -> Gửi mật khẩu
            String subject = "[Web Mỹ Phẩm] Khôi Phục Mật Khẩu";
            String body = "Xin chào Quý khách,<br><br>"
                        + "Chúng tôi đã nhận được yêu cầu khôi phục mật khẩu của bạn.<br>"
                        + "Mật khẩu hiện tại của bạn là: <strong>" + password + "</strong><br><br>"
                        + "Vui lòng đăng nhập và thay đổi mật khẩu để bảo mật tài khoản.<br><br>"
                        + "Trân trọng,<br>Đội ngũ Web Mỹ Phẩm.";
            
            boolean success = EmailUtility.sendEmail(email, subject, body);

            if (success) {
                request.setAttribute("fpMessage", "Mật khẩu đã được gửi đến địa chỉ email của bạn.");
            } else {
                request.setAttribute("fpError", "Gửi email thất bại. Vui lòng thử lại sau.");
            }
        } else {
            // 3. Email không tồn tại
            request.setAttribute("fpError", "Email này chưa được đăng ký trong hệ thống.");
        }
        
        // Chuyển hướng về trang chủ để hiển thị thông báo (Popup sẽ hiển thị thông báo)
        request.getRequestDispatcher(destination).forward(request, response);
    }
}
