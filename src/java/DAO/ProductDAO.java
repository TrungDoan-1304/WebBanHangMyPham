package DAO;

import Model.Product;
import Util.DBconnect; // Giả định lớp kết nối
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product product = new Product();
        
        // --- Ánh xạ các cột chuẩn từ bảng Products ---
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setSlug(rs.getString("slug"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setBrandId(rs.getInt("brand_id"));
        
        // --- ÁNH XẠ CỘT ALIAS 'main_image_url' TỪ KẾT QUẢ JOIN (Khắc phục lỗi) ---
        product.setMainImageUrl(rs.getString("main_image_url")); 
        
        product.setActive(rs.getBoolean("is_active"));
        product.setFeatured(rs.getBoolean("is_featured"));
        
        Timestamp createdTimestamp = rs.getTimestamp("created_at");
        if (createdTimestamp != null) {
             product.setCreated_at(createdTimestamp.toLocalDateTime());
        }
        return product;
    }

    public Product getProductById(int productId) {
        // CÂU TRUY VẤN MỚI: Dùng LEFT JOIN để lấy URL ảnh chính
        String sql = "SELECT p.*, pi.image_url AS main_image_url " +
                     "FROM Products p " + 
                     "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " + // 1 = TRUE
                     "WHERE p.product_id = ?";
                     
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Hàm ánh xạ bây giờ có thể đọc được cột 'main_image_url'
                    return extractProductFromResultSet(rs); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy chi tiết sản phẩm: " + e.getMessage());
            e.printStackTrace();
        } 
        return null;
    }

    public List<Product> getFeaturedProducts() {
        List<Product> featuredProducts = new ArrayList<>();

        String sql = "SELECT p.*, pi.image_url AS main_image_url " + 
                     "FROM Products p " +
                     "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " + 
                     "WHERE p.is_active = 1 AND p.is_featured = 1 " + 
                     "ORDER BY p.created_at DESC";

        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                featuredProducts.add(extractProductFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy sản phẩm nổi bật kèm ảnh: " + e.getMessage());
            e.printStackTrace();
        }
        return featuredProducts;
    }

    public List<String> getProductImagesByProductId(int productId) {
        List<String> imageUrls = new ArrayList<>();
        // Truy vấn lấy tất cả ảnh có is_primary = 0 (Ảnh phụ)
        String sql = "SELECT image_url FROM Product_Images WHERE product_id = ? AND is_primary = 0"; 

        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    imageUrls.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy ảnh phụ: " + e.getMessage());
            e.printStackTrace();
        }
        return imageUrls;
    }
public List<Product> getAllProducts() {
    List<Product> allProducts = new ArrayList<>();
    String sql = "SELECT p.product_id, p.name, p.slug, p.description, p.price, p.stock_quantity, p.category_id, p.brand_id, p.is_active, p.created_at, p.is_featured, " + 
                 "pi.image_url AS main_image_url " + 
                 "FROM Products p " +
                 "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " + 
                 "WHERE p.is_active = 1 " + 
                 "ORDER BY p.created_at DESC";

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            // Sử dụng hàm ánh xạ đã có
            allProducts.add(extractProductFromResultSet(rs));
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi lấy tất cả sản phẩm: " + e.getMessage());
        e.printStackTrace();
        // Sau khi sửa SQL, lỗi này sẽ giảm đi. Nếu vẫn còn, kiểm tra kết nối.
    }
    return allProducts;
}
    public List<Product> searchProducts(String keyword) {
        List<Product> searchResults = new ArrayList<>();

        String searchPattern = "%" + keyword + "%";

        String sql = "SELECT p.*, pi.image_url AS main_image_url " + 
                     "FROM Products p " +
                     "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " + 
                     "WHERE p.is_active = 1 AND (p.name LIKE ? OR p.description LIKE ?) " + 
                     "ORDER BY p.price ASC"; 

        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    searchResults.add(extractProductFromResultSet(rs)); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi tìm kiếm sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return searchResults;
    }
    public List<Product> getProductsByCategoryId(int categoryId) {
    List<Product> products = new ArrayList<>();
    
    // LEFT JOIN để lấy URL ảnh chính
    String sql = "SELECT p.*, pi.image_url AS main_image_url " + 
                 "FROM Products p " +
                 "LEFT JOIN Product_Images pi ON p.product_id = pi.product_id AND pi.is_primary = 1 " + 
                 "WHERE p.is_active = 1 AND p.category_id = ? " + // Lọc theo categoryId
                 "ORDER BY p.name ASC"; 

    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, categoryId);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                // Dùng hàm ánh xạ đã sửa để lấy cả ảnh
                products.add(extractProductFromResultSet(rs)); 
            }
        }
    } catch (SQLException e) {
        System.err.println("Lỗi SQL khi lấy sản phẩm theo danh mục: " + e.getMessage());
        e.printStackTrace();
    }
    return products;
}
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Products (name, slug, description, price, stock_quantity, category_id, brand_id, is_active, is_featured) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getName());
            ps.setString(2, product.getSlug());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setInt(5, product.getStockQuantity());
            ps.setInt(6, product.getCategoryId());
            ps.setInt(7, product.getBrandId());
            ps.setBoolean(8, product.isActive());
            ps.setBoolean(9, product.isFeatured());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi thêm sản phẩm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        // Sửa lỗi: Chỉ có 9 cột UPDATE nên chỉ cần 10 tham số (9 giá trị + 1 WHERE)
        String sql = "UPDATE Products SET name = ?, slug = ?, description = ?, price = ?, stock_quantity = ?, " +
                     "category_id = ?, brand_id = ?, is_active = ?, is_featured = ? " +
                     "WHERE product_id = ?";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, product.getName());
            ps.setString(2, product.getSlug());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setInt(5, product.getStockQuantity());
            ps.setInt(6, product.getCategoryId());
            ps.setInt(7, product.getBrandId());
            ps.setBoolean(8, product.isActive());
            ps.setBoolean(9, product.isFeatured());
            // Tham số thứ 10 là điều kiện WHERE
            ps.setInt(10, product.getProductId()); 

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi cập nhật sản phẩm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE product_id = ?";

        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi xóa sản phẩm: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}