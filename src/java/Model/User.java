/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDateTime;

public class User {

    private Integer userId;
    private String username;
    private String passwordhash; 
    private String fullName;
    private String email;
    private String phonenumber; 
    private String address;
    private String role; // "admin" hoặc "customer"
    private LocalDateTime created_at;

    public User() {
    }

    public User(Integer userId, String username, String passwordhash, String fullName, String email, String phonenumber, String address, String role, LocalDateTime created_at) {
        this.userId = userId;
        this.username = username;
        this.passwordhash = passwordhash;
        this.fullName = fullName;
        this.email = email;
        this.phonenumber = phonenumber;
        this.address = address;
        this.role = role;
        this.created_at = created_at;
    }

    

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

 


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordhash() {
        return passwordhash;
    }

    public void setPasswordhash(String passwordhash) {
        this.passwordhash = passwordhash;
    }

    public String getPhonenumber() {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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