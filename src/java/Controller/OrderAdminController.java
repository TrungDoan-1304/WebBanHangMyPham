package Controller; // Đảm bảo đặt trong package Admin

import DAO.OrderDAO;
import Model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderAdminController", urlPatterns = {"/adminorders"})
public class OrderAdminController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO();
    private static final String LIST_PAGE = "/admin_order_list.jsp";
    private static final String EDIT_PAGE = "/admin_order_edit.jsp";
    private static final String REDIRECT_LIST = "adminorders"; 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) { action = "list"; }

        switch (action) {
            case "list":
                listOrders(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteOrder(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            updateStatus(request, response);
        } else {
            response.sendRedirect(REDIRECT_LIST); 
        }
    }

    // --- LOGIC GET ---

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        List<Order> listOrders = orderDAO.getAllOrders(); 
        request.setAttribute("listOrders", listOrders);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId); // Lấy đơn hàng hiện tại
        
        request.setAttribute("order", order);
        request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
    }
    
    private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        orderDAO.deleteOrder(orderId);
        
        response.sendRedirect(REDIRECT_LIST + "?status=deleted");
    }

    // --- LOGIC POST ---
    
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");
        
        boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
        
        response.sendRedirect(REDIRECT_LIST + "?status=" + (success ? "updated" : "error"));
    }
}