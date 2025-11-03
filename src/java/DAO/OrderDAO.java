package DAO;

import Model.CartItem;
import Model.Order;
import Model.OrderItem;
import Util.DBconnect;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    String sql = "SELECT o.*, COALESCE(u.full_name, o.guest_info) AS customer_name, u.phone_number " +
                 "FROM Orders o " +
                 "LEFT JOIN Users u ON o.user_id = u.user_id " +
                 "WHERE o.order_id = ?";
    Order order = null;
    
    try (Connection conn = DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                order = mapOrderFromResultSet(rs); // Hàm map cũ của bạn
                
                // Set các trường mới từ JOIN
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerPhone(rs.getString("phone_number"));
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return order;
}

// THÊM HÀM MỚI NÀY: Lấy chi tiết các mặt hàng (Tên SP, SL, Giá)
public List<OrderItem> getOrderItemsWithDetails(int orderId) {
    List<OrderItem> items = new ArrayList<>();
    
    // JOIN với bảng Products để lấy tên sản phẩm
    String sql = "SELECT oi.*, p.name AS product_name " +
                 "FROM Order_Items oi " +
                 "JOIN Products p ON oi.product_id = p.product_id " +
                 "WHERE oi.order_id = ?";

    try (Connection conn = DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                
                // Set trường mới
                item.setProductName(rs.getString("product_name"));
                
                items.add(item);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return items;
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
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        
        // Sử dụng COALESCE để lấy Tên (nếu là User) hoặc Guest Info (nếu là Khách)
        String sql = "SELECT o.*, COALESCE(u.full_name, o.guest_info) AS customer_name " +
                     "FROM Orders o " +
                     "LEFT JOIN Users u ON o.user_id = u.user_id " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = mapOrderFromResultSet(rs); // Dùng hàm map đã có
                
                // Set thuộc tính customer_name mới
                order.setCustomerName(rs.getString("customer_name")); 
                
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, orderId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM Orders WHERE order_id = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean cancelOrder(int orderId, int userId) {
    // Cập nhật trạng thái, nhưng chỉ khi user_id khớp VÀ status = 'pending'
    String sql = "UPDATE Orders SET status = 'canceled' WHERE order_id = ? AND user_id = ? AND status = 'pending'";
    
    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, orderId);
        ps.setInt(2, userId);
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

public boolean updateShippingAddress(int orderId, int userId, String newAddress) {
    String sql = "UPDATE Orders SET shipping_address = ? WHERE order_id = ? AND user_id = ? AND status = 'pending'";
    
    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, newAddress);
        ps.setInt(2, orderId);
        ps.setInt(3, userId);
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
public Map<Integer, Double> getWeeklyRevenueData() {
    // Khởi tạo 7 ngày với 0 doanh thu
    Map<Integer, Double> weeklyRevenue = new HashMap<>();
    for (int i = 1; i <= 7; i++) {
        weeklyRevenue.put(i, 0.0);
    }
    
    // SQL: Lấy tổng doanh thu (delivered) của tuần hiện tại, nhóm theo ngày
    String sql = "SELECT DAYOFWEEK(order_date) AS day_of_week, SUM(total_amount) AS daily_revenue " +
                 "FROM Orders " +
                 "WHERE status = 'delivered' " +
                 "  AND YEARWEEK(order_date, 1) = YEARWEEK(NOW(), 1) " + // 1 = Tuần bắt đầu từ Thứ 2
                 "GROUP BY DAYOFWEEK(order_date)";

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            int dayOfWeek = rs.getInt("day_of_week"); // 1=CN, 2=T2, ...
            double dailyRevenue = rs.getDouble("daily_revenue");
            weeklyRevenue.put(dayOfWeek, dailyRevenue);
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi lấy doanh thu tuần: " + e.getMessage());
        e.printStackTrace();
    }
    
    return weeklyRevenue;
}
public BigDecimal getMonthlyRevenue() {
    BigDecimal revenue = BigDecimal.ZERO;
    
    String sql = "SELECT SUM(total_amount) AS monthly_revenue " +
                 "FROM Orders WHERE status = 'delivered' " +
                 "AND YEAR(order_date) = YEAR(NOW()) AND MONTH(order_date) = MONTH(NOW())";

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            revenue = rs.getBigDecimal("monthly_revenue");
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi tính doanh thu tháng: " + e.getMessage());
        e.printStackTrace();
    }
    
    return (revenue == null) ? BigDecimal.ZERO : revenue;
}

public BigDecimal getYearlyRevenue() {
    BigDecimal revenue = BigDecimal.ZERO;
    
    String sql = "SELECT SUM(total_amount) AS yearly_revenue " +
                 "FROM Orders WHERE status = 'delivered' " +
                 "AND YEAR(order_date) = YEAR(NOW())";

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            revenue = rs.getBigDecimal("yearly_revenue");
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi tính doanh thu năm: " + e.getMessage());
        e.printStackTrace();
    }
    
    return (revenue == null) ? BigDecimal.ZERO : revenue;
}

public int getPendingRequestsCount() {
    int count = 0;
    
    String sql = "SELECT COUNT(order_id) AS pending_count " +
                 "FROM Orders WHERE status IN ('pending', 'processing')";

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            count = rs.getInt("pending_count");
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi đếm yêu cầu chờ xử lý: " + e.getMessage());
        e.printStackTrace();
    }
    
    return count;
}
}
