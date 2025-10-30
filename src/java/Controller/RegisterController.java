/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UserDAO;
import Model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author PC
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        String url = "register.jsp"; // Mặc định quay lại trang đăng ký
        String errorMessage = null;

        // 1. Kiểm tra mật khẩu khớp nhau
        if (!password.equals(confirmPassword)) {
            errorMessage = "Mật khẩu nhập lại không khớp.";
        } 
        
        // 2. Kiểm tra tính duy nhất
        else if (userDAO.checkUserExistence(username, email)) {
            errorMessage = "Tên đăng nhập hoặc Email đã tồn tại trong hệ thống.";
        } 
        
        // 3. Nếu không có lỗi, tiến hành đăng ký
        else {
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt()); 
            
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPasswordhash(hashedPassword); // <-- LƯU MẬT KHẨU ĐÃ BĂM
            newUser.setEmail(email);
            newUser.setFullName(fullName);
            newUser.setRole("customer");

            if (userDAO.registerUser(newUser)) {
                // Đăng ký thành công -> Chuyển hướng về trang chủ để đăng nhập
                url = "/home.jsp"; 
                request.getSession().setAttribute("registrationSuccess", "Đăng ký thành công! Vui lòng đăng nhập.");
            } else {
                errorMessage = "Lỗi hệ thống. Đăng ký thất bại.";
            }
        }
        
        // Xử lý chuyển hướng và lỗi
        if (errorMessage != null) {
            // Giữ lại dữ liệu người dùng đã nhập (trừ mật khẩu)
            request.setAttribute("error", errorMessage);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.getRequestDispatcher(url).forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + url);
        }
    }
}