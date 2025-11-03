package Controller;

import DAO.OrderDAO;
import Model.Order;
import Model.OrderItem; // Đảm bảo đã import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrderDetailController", urlPatterns = {"/adminorderDetail"})
public class AdminOrderDetailController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int orderId = Integer.parseInt(request.getParameter("id"));
            
            // 1. Lấy thông tin đơn hàng (Tên, SĐT, Địa chỉ, v.v.)
            Order order = orderDAO.getOrderById(orderId);
            
            // 2. Lấy danh sách sản phẩm (Tên, SL, Giá)
            List<OrderItem> orderItems = orderDAO.getOrderItemsWithDetails(orderId);
            
            if (order != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                request.getRequestDispatcher("/admin_order_detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/adminorders?status=notfound");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/adminorders?status=invalid_id");
        }
    }
}