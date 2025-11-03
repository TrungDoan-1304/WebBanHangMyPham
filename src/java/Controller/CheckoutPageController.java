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

@WebServlet(name = "CheckoutPageController", urlPatterns = {"/checkout"})
public class CheckoutPageController extends HttpServlet {
    
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        User user = (User) session.getAttribute("currentUser");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        
        try {
            // 1. Lấy Cart ID
            int cartId = cartDAO.getOrCreateCartId(userId, sessionId);
            
            if (cartId != -1) {
                // 2. Lấy chi tiết các mặt hàng trong giỏ
                List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cartId);
                
                // 3. Kiểm tra giỏ hàng rỗng
                if (cartItems.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart?error=empty");
                    return;
                }
                
                // 4. Đặt dữ liệu vào Request Scope
                request.setAttribute("cartItems", cartItems);
                
                // 5. Chuyển tiếp đến trang xác nhận thanh toán
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
                
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            
        } catch (Exception e) {
            System.err.println("Lỗi khi tải trang thanh toán: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi tải trang thanh toán.");
        }
    }
}