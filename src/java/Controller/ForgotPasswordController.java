package Controller;

import DAO.UserDAO;
import Util.EmailUtility;
import Util.PasswordGeneratorUtility; // Import hàm tạo mật khẩu
import org.mindrot.jbcrypt.BCrypt; // Import thư viện BCrypt
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgotPassword"})
public class ForgotPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String destination = "/home.jsp"; 

        // 1. Kiểm tra Email có tồn tại không (Không lấy mật khẩu cũ)
        // (Sử dụng hàm checkUserExistence, giả định nó kiểm tra cả username và email)
        boolean emailExists = userDAO.checkUserExistence(null, email);

        if (emailExists) {
            // 2. Tạo mật khẩu mới
            String newTempPassword = PasswordGeneratorUtility.generateRandomPassword();
            // 3. Hash mật khẩu mới để lưu vào CSDL
            String newHashedPassword = BCrypt.hashpw(newTempPassword, BCrypt.gensalt());

            // 4. Cập nhật mật khẩu mới (đã hash) vào CSDL
            boolean updateSuccess = userDAO.updatePasswordByEmail(email, newHashedPassword);

            if (updateSuccess) {
                // 5. Gửi Mật khẩu MỚI (chưa hash) qua email
                String subject = "[Web Mỹ Phẩm] Mật khẩu Mới Của Bạn";
                String body = "Xin chào Quý khách,<br><br>"
                            + "Mật khẩu của bạn đã được đặt lại.<br>"
                            + "Mật khẩu tạm thời MỚI của bạn là: <h3>" + newTempPassword + "</h3><br>"
                            + "Vui lòng đăng nhập bằng mật khẩu này và đổi mật khẩu ngay lập tức tại trang Hồ sơ cá nhân.<br><br>"
                            + "Trân trọng,<br>Đội ngũ Web Mỹ Phẩm.";
                
                boolean emailSent = EmailUtility.sendEmail(email, subject, body);

                if (emailSent) {
                    request.setAttribute("fpMessage", "Một mật khẩu mới đã được gửi đến email của bạn.");
                } else {
                    request.setAttribute("fpError", "Gửi email thất bại. Vui lòng thử lại sau.");
                }
            } else {
                request.setAttribute("fpError", "Lỗi CSDL khi cập nhật mật khẩu.");
            }
        } else {
            // 3. Email không tồn tại
            request.setAttribute("fpError", "Email này chưa được đăng ký trong hệ thống.");
        }
        
        request.getRequestDispatcher(destination).forward(request, response);
    }
}