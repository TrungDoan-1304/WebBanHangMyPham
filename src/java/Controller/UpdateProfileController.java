package Controller;

import DAO.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateProfileController", urlPatterns = {"/updateProfile"})
public class UpdateProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();
    User currentUser = (User) session.getAttribute("currentUser");
    User userCheck = (User) session.getAttribute("currentUser");
    System.out.println("DEBUG: Current User ID: " + (userCheck != null ? userCheck.getUserId() : "NULL"));
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/home.jsp"); 
        return;
    }

    String fullName = request.getParameter("full_name");
    String phonenumber = request.getParameter("phone_number"); 
    String address = request.getParameter("address");

    if (userDAO.updateUserInfo(currentUser.getUserId(), fullName, phonenumber, address)) {
        
        currentUser.setFullName(fullName);
        currentUser.setPhonenumber(phonenumber);
        currentUser.setAddress(address);
        session.setAttribute("currentUser", currentUser);
        session.setAttribute("statusMessage", "Cập nhật thông tin thành công!");
        session.setAttribute("statusType", "success");
    } else {
        session.setAttribute("statusMessage", "Cập nhật thất bại. Vui lòng thử lại.");
        session.setAttribute("statusType", "error");
    }
    response.sendRedirect(request.getContextPath() + "/user.jsp?tab=edit");
    }
}