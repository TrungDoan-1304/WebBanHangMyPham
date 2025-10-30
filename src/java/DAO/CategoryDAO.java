package DAO;

import Model.Category;
import Util.DBconnect; // Giả định lớp kết nối CSDL của bạn
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setSlug(rs.getString("slug"));
 
        return category;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        // Truy vấn tất cả các cột cần thiết
        String sql = "SELECT category_id, category_name, slug FROM Categories ORDER BY category_name ASC";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy tất cả danh mục: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT category_id, category_name, slug FROM Categories WHERE category_id = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCategoryFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy danh mục theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public int getCategoryIdBySlug(String slug) {
        String sql = "SELECT category_id FROM Categories WHERE slug = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("category_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy ID theo slug: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }
}