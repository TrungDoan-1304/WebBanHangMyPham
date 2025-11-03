package Controller;

import DAO.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CartUpdateController", urlPatterns = {"/cartUpdate"})
public class CartUpdateController extends HttpServlet {
    
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         request.setCharacterEncoding("UTF-8");
        // Lấy hành động và ID mặt hàng từ form
        String action = request.getParameter("action");
        String cartItemIdStr = request.getParameter("itemId");
        
        if (cartItemIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        int cartItemId;
        try {
            cartItemId = Integer.parseInt(cartItemIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID mặt hàng không hợp lệ.");
            return;
        }

        boolean success = false;
        
        // 1. Xử lý hành động XÓA
        if ("remove".equalsIgnoreCase(action)) {
            success = cartDAO.removeCartItem(cartItemId);
            
        } 
        // 2. Xử lý hành động CẬP NHẬT
        else if ("update".equalsIgnoreCase(action)) {
            String quantityStr = request.getParameter("quantity_" + cartItemIdStr);
            int newQuantity;
            
            try {
                newQuantity = Integer.parseInt(quantityStr);
                success = cartDAO.updateCartItemQuantity(cartItemId, newQuantity);
            } catch (NumberFormatException e) {
                // Nếu số lượng không hợp lệ, chuyển hướng lỗi
                request.getSession().setAttribute("cartStatus", "Lỗi: Số lượng phải là số nguyên.");
            }
        }
        
        // Cập nhật trạng thái (tùy chọn)
        if (success) {
            request.getSession().setAttribute("cartStatus", action + " thành công!");
        } else {
            request.getSession().setAttribute("cartStatus", action + " thất bại.");
        }
        
        // 3. Chuyển hướng về trang giỏ hàng
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}