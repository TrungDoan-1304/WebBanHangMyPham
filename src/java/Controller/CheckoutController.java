package Controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import Model.CartItem;
import Model.Order;
import Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CheckoutController", urlPatterns = {"/processCheckout"})
public class CheckoutController extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
         request.setCharacterEncoding("UTF-8");
        User user = (User) session.getAttribute("currentUser");
        Integer userId = (user != null) ? user.getUserId() : null;
        String sessionId = session.getId();
        // Lấy thông tin vận chuyển / payment từ form
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        String status = "pending";
        int cartId = cartDAO.getOrCreateCartId(userId, sessionId);
        // Lấy cartId (ví dụ lưu trong session hoặc param)
        if (cartId == -1) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lấy cartItems từ CartDAO
        List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cartId);
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Tính tổng
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem it : cartItems) {
            total = total.add(it.getUnitPrice().multiply(BigDecimal.valueOf(it.getQuantity())));
        }

        Order order = new Order();
        order.setTotalAmount(total);
        order.setStatus(status);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);

        if (user != null) {
            // User đăng nhập
            order.setUserId(user.getUserId());
            order.setGuestInfo(null);
        } else {
            // Guest: lấy thông tin guest từ form: guestName, guestPhone, guestEmail
            String guestName = request.getParameter("guestName");
            String guestPhone = request.getParameter("guestPhone");
            String guestEmail = request.getParameter("guestEmail");

            // Format theo G1.1: "Tên - SĐT - Email"
            String guestInfo = String.format("%s - %s - %s", 
                    guestName == null ? "" : guestName.trim(),
                    guestPhone == null ? "" : guestPhone.trim(),
                    guestEmail == null ? "" : guestEmail.trim());

            order.setUserId(null);
            order.setGuestInfo(guestInfo);
        }

        int createdOrderId = orderDAO.createOrder(order, cartItems, cartId);
        if (createdOrderId > 0) {
                    if ("BANK_TRANSFER".equals(paymentMethod)) { 
                response.sendRedirect(request.getContextPath() + "/bankTransfer?orderId=" + createdOrderId);
                    } else {
        response.sendRedirect(request.getContextPath() + "/orderConfirmation?orderId=" + createdOrderId);
        } }
        else {
            // Lỗi
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }
}
