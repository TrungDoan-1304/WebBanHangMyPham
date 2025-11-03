package Controller;

import DAO.OrderDAO;
import Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderUpdateController", urlPatterns = {"/updateOrder"})
public class OrderUpdateController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");
        
        if (user == null || user.getUserId() == null) {
            response.sendRedirect(request.getContextPath() + "/user.jsp");
            return;
        }

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        int userId = user.getUserId();

        boolean success = false;
        
        if ("updateAddress".equals(action)) {
            String newAddress = request.getParameter("shippingAddress");
            success = orderDAO.updateShippingAddress(orderId, userId, newAddress);
            request.getSession().setAttribute("statusMessage", success ? "Cập nhật địa chỉ thành công!" : "Cập nhật địa chỉ thất bại.");
            
        } else if ("cancelOrder".equals(action)) {
            success = orderDAO.cancelOrder(orderId, userId);
            request.getSession().setAttribute("statusMessage", success ? "Đã hủy đơn hàng thành công!" : "Hủy đơn hàng thất bại.");
        }

        // Quay lại trang chi tiết đơn hàng
        response.sendRedirect(request.getContextPath() + "/orderDetail?orderId=" + orderId);
    }
}