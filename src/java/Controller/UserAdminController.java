package Controller;


import DAO.UserDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserAdminController", urlPatterns = {"/adminusers"})
public class UserAdminController extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    private static final String LIST_PAGE = "/adminuser_list.jsp";
    private static final String EDIT_PAGE = "/adminuser_edit.jsp";
    private static final String REDIRECT_LIST = "adminusers";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String action = request.getParameter("action");
        if (action == null) { action = "list"; }

        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "edit":
            case "create":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String action = request.getParameter("action");
        if ("save".equals(action)) {
            saveUser(request, response);
        } else {
            response.sendRedirect(REDIRECT_LIST); 
        }
    }

    // --- LOGIC GET ---

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        List<User> listUser = userDAO.getAllUsers(); 
        request.setAttribute("listUser", listUser);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        String userIdStr = request.getParameter("id");
        User existingUser = new User();
        
        if (userIdStr != null && !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            // Lấy thông tin user (đã sửa để lấy cả password_hash nếu cần)
            existingUser = userDAO.getUserById(userId); 
        }
        
        request.setAttribute("user", existingUser);
        request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        int userId = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(userId);
        
        response.sendRedirect(REDIRECT_LIST);
    }

    // --- LOGIC POST ---
    
    private void saveUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        int userId = 0;
        if (request.getParameter("userId") != null && !request.getParameter("userId").isEmpty()) {
            userId = Integer.parseInt(request.getParameter("userId"));
        }
        
        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phonenumber");
        String address = request.getParameter("address");
        String role = request.getParameter("role"); // Lấy vai trò (admin/customer)
        
        // 2. Tạo đối tượng User
        User user = new User();
        user.setUserId(userId);
        user.setFullName(fullName);
        user.setPhonenumber(phoneNumber);
        user.setAddress(address);
        user.setRole(role);

        // 3. Gọi DAO
        boolean success = false;
        if (userId == 0) {
            // Admin không nên tạo user mới mà không có password/username (nên dùng hàm register)
            // Tạm thời bỏ qua logic add user phức tạp ở đây.
            // Nếu muốn add, cần yêu cầu thêm username/password/email.
            success = false; 
        } else {
            success = userDAO.updateUser(user);
        }
        
        // 4. Chuyển hướng
        response.sendRedirect(request.getContextPath() + "/adminusers?status=" + REDIRECT_LIST + (success ? "?status=success" : "?status=failure"));
    }
}