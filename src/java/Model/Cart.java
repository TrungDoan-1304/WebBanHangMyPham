package Model;

import java.time.LocalDateTime;

public class Cart {
    private int cartId;
    private Integer userId; // Có thể NULL nếu là khách vãng lai
    private String sessionId; // Dành cho khách vãng lai
    private LocalDateTime created_at;
    private LocalDateTime updated_at;

    public Cart() {
    }

    public Cart(int cartId, Integer userId, String sessionId, LocalDateTime created_at, LocalDateTime updated_at) {
        this.cartId = cartId;
        this.userId = userId;
        this.sessionId = sessionId;
        this.created_at = created_at;
        this.updated_at = updated_at;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public LocalDateTime getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDateTime updated_at) {
        this.updated_at = updated_at;
    }
}