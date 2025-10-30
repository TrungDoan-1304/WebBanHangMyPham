package Controller;

import DAO.OrderDAO;
import Model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GuestLookupController", urlPatterns = {"/guestLookup"})
public class GuestLookupController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String q = request.getParameter("q");
        if (q != null && !q.trim().isEmpty()) {
            // search theo guest_info chứa q (SĐT hoặc email hoặc tên)
            List<Order> orders = orderDAO.searchOrdersByGuestInfo(q.trim());
            request.setAttribute("orders", orders);
        }

        request.getRequestDispatcher("/guest-order-lookup.jsp").forward(request, response);
    }
}
