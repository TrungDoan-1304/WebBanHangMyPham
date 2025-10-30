/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordMigrationUtility {

    // Mã hóa mật khẩu
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    // So sánh mật khẩu gõ vào với mật khẩu đã mã hóa trong DB
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (hashedPassword == null || !hashedPassword.startsWith("$2a$")) {
            // Nếu mật khẩu cũ không mã hóa → so sánh thẳng
            return plainPassword.equals(hashedPassword);
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }

    // Kiểm tra mật khẩu đã được mã hóa hay chưa
    public static boolean isHashed(String password) {
        return password != null && password.startsWith("$2a$");
    }
}