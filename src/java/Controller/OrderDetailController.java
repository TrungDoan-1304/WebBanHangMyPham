package Controller;

import DAO.OrderDAO;
import Model.Order;
import Model.OrderItem; // Cần import
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/orderDetail"})
public class OrderDetailController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String orderIdStr = request.getParameter("orderId");
        
        try {
            int orderId = Integer.parseInt(orderIdStr);
            
            // 1. Lấy thông tin đơn hàng (Tên, SĐT, Địa chỉ, v.v.)
            // (Hàm này cần được sửa trong DAO để lấy cả customerName/Phone)
            Order order = orderDAO.getOrderById(orderId); 
            
            // 2. Lấy danh sách sản phẩm (Tên, SL, Giá)
            // (Hàm này cần được tạo trong DAO)
            List<OrderItem> orderItems = orderDAO.getOrderItemsWithDetails(orderId);

            if (order != null) {
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                
                // Chuyển tiếp đến trang JSP hiển thị chi tiết
                request.getRequestDispatcher("/orderDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy chi tiết đơn hàng.");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn hàng không hợp lệ.");
        }
    }
}