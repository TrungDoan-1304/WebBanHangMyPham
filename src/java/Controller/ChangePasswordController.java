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
import org.mindrot.jbcrypt.BCrypt; // Import BCrypt

@WebServlet(name = "ChangePasswordController", urlPatterns = {"/changePassword"})
public class ChangePasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // URL để chuyển hướng lại (với tab chỉnh sửa được mở)
        String redirectURL = request.getContextPath() + "/user.jsp?tab=edit"; 

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // 1. Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // 2. Lấy mật khẩu hash hiện tại từ CSDL (Không dùng hash trong session)
        String storedHash = userDAO.getPasswordHash(currentUser.getUserId());

        // 3. Kiểm tra mật khẩu hiện tại
        if (storedHash == null || !BCrypt.checkpw(currentPassword, storedHash)) {
            session.setAttribute("statusMessage", "Lỗi: Mật khẩu hiện tại không đúng.");
            session.setAttribute("statusType", "error");
            response.sendRedirect(redirectURL);
            return;
        }

        // 4. Kiểm tra mật khẩu mới khớp nhau
        if (!newPassword.equals(confirmNewPassword)) {
            session.setAttribute("statusMessage", "Lỗi: Mật khẩu mới không khớp.");
            session.setAttribute("statusType", "error");
            response.sendRedirect(redirectURL);
            return;
        }

        // 5. Hash và Cập nhật mật khẩu mới
        String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean success = userDAO.updatePassword(currentUser.getUserId(), newHashedPassword);
        
        if (success) {
            session.setAttribute("statusMessage", "Đổi mật khẩu thành công!");
            session.setAttribute("statusType", "success");
        } else {
            session.setAttribute("statusMessage", "Lỗi CSDL: Không thể cập nhật mật khẩu.");
            session.setAttribute("statusType", "error");
        }
        
        response.sendRedirect(redirectURL);
    }
}