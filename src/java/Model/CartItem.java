package Model;

import java.time.LocalDateTime;

public class CartItem {
    private int cartItemId;
    private int cartId;      // Khóa ngoại
    private int productId;   // Khóa ngoại
    private String size;     // Biến thể (nếu cần)
    private int quantity;
    private double unitPrice; // Giá tại thời điểm thêm vào giỏ
    private LocalDateTime added_at;

    public CartItem() {
    }

    public CartItem(int cartItemId, int cartId, int productId, String size, int quantity, double unitPrice, LocalDateTime added_at) {
        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.productId = productId;
        this.size = size;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.added_at = added_at;
    }

    public int getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public LocalDateTime getAdded_at() {
        return added_at;
    }

    public void setAdded_at(LocalDateTime added_at) {
        this.added_at = added_at;
    }

    public double getTotalAmount() {
        return unitPrice * quantity;
    }
}