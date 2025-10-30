package DAO;

import Model.CartItem;
import Model.Order;
import Util.DBconnect;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // INSERT Orders: lưu user_id nếu có, hoặc guest_info nếu guest
    public int createOrder(Order order, List<CartItem> cartItems, int cartId) {
        // Lưu guest_info vào cột guest_info (G1.1 format) và order_date
        String orderSql = "INSERT INTO Orders (user_id, guest_info, order_date, total_amount, status, shipping_address, payment_method) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String deleteCartSql = "DELETE FROM Carts WHERE cart_id = ?";

        Connection conn = null;
        int orderId = -1;

        try {
            conn = DBconnect.getConnection();
            conn.setAutoCommit(false); // Transaction bắt đầu

            // 1. Insert vào Orders
            try (PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                // user_id (nullable)
                if (order.getUserId() != null) {
                    orderPs.setInt(1, order.getUserId());
                } else {
                    orderPs.setNull(1, Types.INTEGER);
                }

                // guest_info (nullable)
                if (order.getGuestInfo() != null && !order.getGuestInfo().trim().isEmpty()) {
                    orderPs.setString(2, order.getGuestInfo());
                } else {
                    orderPs.setNull(2, Types.VARCHAR);
                }

                // order_date: set current timestamp
                orderPs.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

                // total_amount
                if (order.getTotalAmount() != null) {
                    orderPs.setBigDecimal(4, order.getTotalAmount());
                } else {
                    orderPs.setBigDecimal(4, BigDecimal.ZERO);
                }

                orderPs.setString(5, order.getStatus());
                orderPs.setString(6, order.getShippingAddress());
                orderPs.setString(7, order.getPaymentMethod());

                orderPs.executeUpdate();

                try (ResultSet rs = orderPs.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            // 2. Insert order items (batch)
            try (PreparedStatement itemPs = conn.prepareStatement(itemSql)) {
                for (CartItem item : cartItems) {
                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, item.getProductId());
                    itemPs.setInt(3, item.getQuantity());
                    // unit_price assumed as BigDecimal in DB Order_Items, but model had double/BigDecimal - adapt:
                    itemPs.setBigDecimal(4, item.getUnitPrice());
                    itemPs.addBatch();
                }
                itemPs.executeBatch();
            }

            // 3. Xóa cart
            try (PreparedStatement deletePs = conn.prepareStatement(deleteCartSql)) {
                deletePs.setInt(1, cartId);
                deletePs.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
                if (conn != null) conn.close();
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // Lấy danh sách đơn hàng của user (user đã login)
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ? ORDER BY order_date DESC";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Tìm các đơn hàng của guest theo SĐT hoặc email (search substring)
    // query có thể là SĐT hoặc Email hoặc tên; sẽ tìm trong guest_info
    public List<Order> searchOrdersByGuestInfo(String query) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE guest_info LIKE ? ORDER BY order_date DESC";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + query + "%";
            ps.setString(1, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Lấy order theo order_id (dùng cho chi tiết)
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM Orders WHERE order_id = ?";
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrderFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hàm tiện ích map ResultSet -> Order
    private Order mapOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        int uid = rs.getInt("user_id");
        if (rs.wasNull()) order.setUserId(null); else order.setUserId(uid);

        try {
            order.setGuestInfo(rs.getString("guest_info"));
        } catch (SQLException ex) {
            // Nếu DB không có cột guest_info, sẽ ném, nhưng assume có
            order.setGuestInfo(null);
        }

        Timestamp ts = rs.getTimestamp("order_date");
        if (ts != null) order.setOrderDate(new java.util.Date(ts.getTime()));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        return order;
    }
}
