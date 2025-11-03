/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author PC
 */
import java.sql.*;
import Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import Util.DBconnect;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class UserDAO {
private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setPhonenumber(rs.getString("phone_number"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        // Không lấy password_hash trừ khi thực hiện login/đổi mật khẩu
        return user;
    }

    // --- R (READ): Lấy tất cả người dùng ---
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT user_id, username, email, full_name, phone_number, address, role FROM Users ORDER BY user_id ASC";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                userList.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }
public User getUserByUsername(String username) {
        
        // Truy vấn SELECT tất cả các trường cần thiết, bao gồm password_hash
        String sql = "SELECT user_id, username, password_hash, email, full_name, phone_number, address, role FROM Users WHERE username = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Tạo và điền dữ liệu vào đối tượng User
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordhash(rs.getString("password_hash")); 
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhonenumber(rs.getString("phone_number"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    
                    return user;
                }
            }
        } catch(SQLException e) {
            // Xử lý lỗi CSDL
            System.err.println("Lỗi SQL khi tìm kiếm người dùng: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            // Xử lý lỗi kết nối hoặc lỗi khác
            System.err.println("Lỗi hệ thống khi tìm kiếm người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
   public String getPasswordByEmail(String email) {
        // LƯU Ý: Thay 'password_hash' bằng tên cột mật khẩu thực tế trong CSDL của bạn
        String sql = "SELECT password_hash FROM Users WHERE email = ?"; 
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Trả về mật khẩu đã lưu trong DB
                    return rs.getString("password_hash"); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
   public boolean checkUserExistence(String username, String email) {
        String sql = "SELECT user_id FROM Users WHERE username = ? OR email = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // True nếu đã tồn tại
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (username, password_hash, email, full_name, role, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordhash()); 
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getFullName());
            ps.setString(5, "customer"); 
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public Map<Integer, String> getAllUserPlainPasswords() {
        Map<Integer, String> userPasswords = new HashMap<>();
        
        // SELECT password_hash, username (hoặc user_id)
        String sql = "SELECT user_id, password_hash FROM Users"; 

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Lấy UserID và mật khẩu (dạng plaintext hiện tại)
                userPasswords.put(rs.getInt("user_id"), rs.getString("password_hash")); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userPasswords;
    }
    public void updatePasswordHash(int userId, String newHash) {
        // Cập nhật giá trị HASH mới vào cột password_hash
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";

        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public boolean updateUserInfo(int userId, String fullName, String phoneNumber, String address) {
    String sql = "UPDATE Users SET full_name = ?, phone_number = ?, address = ? WHERE user_id = ?";
    
    try (Connection conn = Util.DBconnect.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, fullName);
        ps.setString(2, phoneNumber);
        ps.setString(3, address);
        ps.setInt(4, userId); 

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    public User getUserById(int userId) {
        String sql = "SELECT user_id, username, password_hash, email, full_name, phone_number, address, role FROM Users WHERE user_id = ?";
        User user = null;
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                    // Có thể cần setPasswordHash(rs.getString("password_hash")) nếu dùng cho form sửa
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // --- U (UPDATE): Cập nhật thông tin người dùng (Admin) ---
    public boolean updateUser(User user) {
        // Chú ý: Admin không nên cập nhật password_hash ở đây
        String sql = "UPDATE Users SET full_name=?, phone_number=?, address=?, role=? WHERE user_id=?";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhonenumber());
            ps.setString(3, user.getAddress());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // --- D (DELETE): Xóa người dùng ---
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id=?";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updatePasswordByEmail(String email, String newHashedPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE email = ?";
        
        try (Connection conn = DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newHashedPassword);
            ps.setString(2, email);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public String getPasswordHash(int userId) {
        String sql = "SELECT password_hash FROM Users WHERE user_id = ?";
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        
        try (Connection conn = Util.DBconnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}