package Controller;

import DAO.OrderDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "OrderConfirmationController", urlPatterns = {"/orderConfirmation"})
public class OrderConfirmationController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO(); // Giả định bạn có hàm getOrderById

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderIdStr = request.getParameter("orderId");
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // LƯU Ý: Bạn cần tạo hàm getOrderById(orderId) trong OrderDAO
            // Order order = orderDAO.getOrderById(orderId);
            
            // Tạm thời tạo đối tượng giả để kiểm tra giao diện (Sau này thay bằng DAO)
            Order order = new Order();
            order.setOrderId(orderId);
            order.setTotalAmount(java.math.BigDecimal.valueOf(1420000.00));
            order.setPaymentMethod("COD");
            order.setOrderDate(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));

            request.setAttribute("order", order);
            
            // Chuyển tiếp đến trang xác nhận
            request.getRequestDispatcher("/orderConfirmation.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}