package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {
    private int cartItemId;
    private int cartId;      // Khóa ngoại
    private int productId;   // Khóa ngoại
    private int quantity;
   private BigDecimal unitPrice; // Giá tại thời điểm thêm vào giỏ
    private LocalDateTime added_at;
    private Product product;
    public CartItem() {
    }

    public CartItem(int cartItemId, int cartId, int productId, int quantity, BigDecimal unitPrice, LocalDateTime added_at) {
        this.cartItemId = cartItemId;
        this.cartId = cartId;
        this.productId = productId;
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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
    
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public LocalDateTime getAdded_at() {
        return added_at;
    }

    public void setAdded_at(LocalDateTime added_at) {
        this.added_at = added_at;
    }
public BigDecimal getTotalAmount() {
        if (unitPrice == null) return BigDecimal.ZERO;
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}