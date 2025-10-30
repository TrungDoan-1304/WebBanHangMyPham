/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;


public class EmailUtility {

 /*   // Thông tin SMTP Server của Gmail
    private final static String HOST = "smtp.gmail.com";
    private final static String PORT = "587"; // TLS Port
    
    // Thông tin tài khoản Email của bạn (Dùng để gửi đi)
    private final static String FROM_EMAIL = "trunglay2k4@gmail.com"; 
    private final static String PASSWORD = "nrxh daaa qirq jvgn"; 
*/
    public static boolean sendEmail(String toEmail, String subject, String body) {
        // 1. Cấu hình Properties
        final String FROM_EMAIL = "trunglay2k4@gmail.com";
        final String PASSWORD = "nrxh daaa qirq jvgn"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true"); // bật SSL
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        // 2. Tạo Session với thông tin xác thực
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            // 3. Tạo đối tượng MimeMessage
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Web Mỹ Phẩm","UTF-8"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            
            // Nội dung email (có thể dùng HTML)
            message.setContent(body, "text/html; charset=UTF-8");

            // 4. Gửi email
            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
