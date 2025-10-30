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
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author PC
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

 private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO(); 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String plainPassword = request.getParameter("password");
        User user = userDAO.getUserByUsername(username);
        boolean loginSuccessful = false;
        if (user != null) {
            if (BCrypt.checkpw(plainPassword, user.getPasswordhash())) {
            loginSuccessful = true;
            }
            if (loginSuccessful) {
            user.setPasswordhash(null);
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user); 
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/home.jsp");
            }            
        } else {

            String errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng.";
            request.setAttribute("loginError", errorMessage);
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Controller xử lý đăng nhập người dùng";
    }

}
