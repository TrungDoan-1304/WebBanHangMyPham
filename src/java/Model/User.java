/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDateTime;

public class User {

    private int userId;
    private String username;
    private String password; // Lưu ý: Trong thực tế, đây nên là passwordHash
    private String HoTen;
    private String email;
    private String SDT; // Số điện thoại
    private String DiaChi;
    private String role; // "admin" hoặc "customer"
    private LocalDateTime created_at;

    public User() {
    }

    public User(int userId, String username, String password, String HoTen,
                String email, String SDT, String DiaChi, String role, LocalDateTime created_at) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.HoTen = HoTen;
        this.email = email;
        this.SDT = SDT;
        this.DiaChi = DiaChi;
        this.role = role;
        this.created_at = created_at;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getHoTen() {
        return HoTen;
    }

    public void setHoTen(String HoTen) {
        this.HoTen = HoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSDT() {
        return SDT;
    }

    public void setSDT(String SDT) {
        this.SDT = SDT;
    }

    public String getDiaChi() {
        return DiaChi;
    }

    public void setDiaChi(String DiaChi) {
        this.DiaChi = DiaChi;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    
    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }
}