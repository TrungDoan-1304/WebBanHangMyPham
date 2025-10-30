package Controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import Model.Product;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "AddToCartController", urlPatterns = {"/addToCart"})
public class AddToCartController extends HttpServlet {
    
    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO(); // Dùng để lấy giá sản phẩm

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. Xác định User ID hoặc Session ID
        User user = (User) session.getAttribute("currentUser");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        
        // 2. Lấy thông tin mặt hàng từ form
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String action = request.getParameter("action"); // 'add' (thêm vào giỏ) hoặc 'buy' (mua ngay)
        
        // 3. Lấy giá sản phẩm từ CSDL (đảm bảo giá là BigDecimal)
        Product product = productDAO.getProductById(productId);
        BigDecimal unitPrice = (product != null) ? BigDecimal.valueOf(product.getPrice()) : BigDecimal.ZERO;

        if (unitPrice.compareTo(BigDecimal.ZERO) > 0) {
            // 4. Lấy/Tạo Cart ID
            int cartId = cartDAO.getOrCreateCartId(userId, sessionId);
            
            if (cartId != -1) {
                // 5. Thêm/Cập nhật Cart Item
                cartDAO.addOrUpdateCartItem(cartId, productId, quantity, unitPrice);
                
                // 6. Điều hướng
                if ( "buy".equalsIgnoreCase(action)) {
                    // Mua ngay -> Chuyển đến trang giỏ hàng để thanh toán
                    response.sendRedirect(request.getContextPath() + "/cart"); 
                } else {
                    // Thêm vào giỏ -> Quay lại trang chi tiết sản phẩm
                    response.sendRedirect(request.getContextPath() + "/productDetail?id=" + productId + "&status=added");
                }
            }
        }
    }
}