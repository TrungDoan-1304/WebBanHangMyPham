package DAO;

import Model.Cart;
import Model.CartItem;
import Model.Product;
import Util.DBconnect;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
public int getOrCreateCartId(Integer userId, String sessionId) {
    
    String selectByUserSql = "SELECT cart_id FROM Carts WHERE user_id = ?";
    String selectBySessionSql = "SELECT cart_id FROM Carts WHERE session_id = ?";
    String insertSql = "INSERT INTO Carts (user_id, session_id) VALUES (?, ?)";
    String updateSql = "UPDATE Carts SET user_id = ?, session_id = NULL WHERE cart_id = ?"; 

    try (Connection conn = DBconnect.getConnection()) {
        

        if (userId != null) {
            try (PreparedStatement ps = conn.prepareStatement(selectByUserSql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("cart_id"); 
                    }
                }
            }
        }

        int cartIdBySession = -1;
        if (sessionId != null) {
            try (PreparedStatement ps = conn.prepareStatement(selectBySessionSql)) {
                ps.setString(1, sessionId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cartIdBySession = rs.getInt("cart_id");
                    }
                }
            }
        }

        if (cartIdBySession != -1) {
             if (userId != null) {
                try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                    updatePs.setInt(1, userId);
                    updatePs.setInt(2, cartIdBySession);
                    updatePs.executeUpdate();
                }
             }
             return cartIdBySession; 
        }

        if (userId != null || sessionId != null) {
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setObject(1, userId); 
                ps.setString(2, sessionId); 
                
                if (ps.executeUpdate() > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            return rs.getInt(1); // Trả về ID mới
                        }
                    }
                }
            }
        }

    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi tạo/tìm Cart ID: " + e.getMessage());
        e.printStackTrace();
    }
    return -1; 
}

    // Thêm hoặc cập nhật mặt hàng vào giỏ hàng
    public boolean addOrUpdateCartItem(int cartId, int productId, int quantity, BigDecimal unitPrice) {
        String checkSql = "SELECT cart_item_id, quantity FROM Cart_Items WHERE cart_id = ? AND product_id = ?";
        String updateSql = "UPDATE Cart_Items SET quantity = ? WHERE cart_item_id = ?";
        String insertSql = "INSERT INTO Cart_Items (cart_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBconnect.getConnection()) {
            
            // 1. Kiểm tra mặt hàng đã tồn tại chưa
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Cập nhật số lượng
                        int currentQty = rs.getInt("quantity");
                        int itemId = rs.getInt("cart_item_id");
                        
                        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                            updatePs.setInt(1, currentQty + quantity);
                            updatePs.setInt(2, itemId);
                            return updatePs.executeUpdate() > 0;
                        }
                    }
                }
            }
            
            // 2. Thêm mới mặt hàng
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setInt(1, cartId);
                insertPs.setInt(2, productId);
                insertPs.setInt(3, quantity);
                insertPs.setBigDecimal(4, unitPrice);
                return insertPs.executeUpdate() > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy chi tiết giỏ hàng
    public List<CartItem> getCartItemsByCartId(int cartId) {
        List<CartItem> items = new ArrayList<>();
        
        // LEFT JOIN để lấy thông tin chi tiết sản phẩm (name, price)
        String sql = "SELECT ci.*, p.name, p.slug, p.price AS product_price, pi.image_url AS main_image_url " +
                     "FROM Cart_Items ci " +
                     "JOIN Products p ON ci.product_id = p.product_id " +
                     "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " +
                     "WHERE ci.cart_id = ?";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, cartId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    
                    // Ánh xạ thông tin sản phẩm cần thiết cho hiển thị
                    Product product = new Product();
                    product.setProductId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setSlug(rs.getString("slug"));
                    product.setMainImageUrl(rs.getString("main_image_url"));
                    
                    item.setProduct(product);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    public boolean removeCartItem(int cartItemId) {
    String sql = "DELETE FROM Cart_Items WHERE cart_item_id = ?";
    
    try (Connection conn = DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, cartItemId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }

    }
    public boolean updateCartItemQuantity(int cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
        // Nếu số lượng là 0 hoặc âm, thực hiện xóa
        return removeCartItem(cartItemId);
    }
    
    String sql = "UPDATE Cart_Items SET quantity = ? WHERE cart_item_id = ?";
    
    try (Connection conn = DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, newQuantity);
        ps.setInt(2, cartItemId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
}
