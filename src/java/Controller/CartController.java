package Controller;

import DAO.CartDAO;
import Model.CartItem;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {
    
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. Xác định User ID hoặc Session ID
        User user = (User) session.getAttribute("currentUser");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        
        try {
            // 2. Lấy hoặc Tạo Cart ID
            int cartId = cartDAO.getOrCreateCartId(userId, sessionId);
            
            if (cartId != -1) {
                // 3. Lấy chi tiết các mặt hàng trong giỏ (CartItems)
                List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cartId);
                
                // 4. Đặt dữ liệu vào Request Scope
                request.setAttribute("cartItems", cartItems);
                
                // 5. Chuyển tiếp đến trang giỏ hàng
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
                
            } else {
                // Xử lý lỗi nếu không thể tạo hoặc tìm thấy Cart ID
                request.setAttribute("errorMessage", "Không thể truy cập giỏ hàng. Vui lòng thử lại.");
                request.getRequestDispatcher("/home.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi khi tải giỏ hàng: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi tải giỏ hàng.");
        }
    }
}