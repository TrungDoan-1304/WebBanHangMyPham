/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import DAO.UserDAO;
import Util.PasswordMigrationUtility;
import java.util.Map;

public class MigrationExecutor {

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        
        // 1. Lấy tất cả mật khẩu (plaintext) hiện tại
        Map<Integer, String> userPasswords = userDAO.getAllUserPlainPasswords();

        System.out.println("Bắt đầu di chuyển mật khẩu BCrypt...");
        int count = 0;
        
        // 2. Lặp qua từng người dùng, hash và cập nhật
        for (Map.Entry<Integer, String> entry : userPasswords.entrySet()) {
            int userId = entry.getKey();
            String plainPassword = entry.getValue(); 

            // Kiểm tra: Chỉ hash nếu mật khẩu chưa được hash (ít hơn 60 ký tự)
            if (plainPassword != null && plainPassword.length() < 60) { 
                
                String hashedPassword = PasswordMigrationUtility.hashPassword(plainPassword);
                
                // 3. Cập nhật hash mới vào database
                userDAO.updatePasswordHash(userId, hashedPassword);
                count++;
            }
        }

        System.out.println("Hoàn tất di chuyển. Tổng số tài khoản được cập nhật: " + count);
    }
}