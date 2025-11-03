package Model;

import java.time.LocalDateTime;

public class Product {
    private int productId;
    private String name;
    private String slug;
    private String description;
    private double price;
    private int stockQuantity;
    private int categoryId; // Khóa ngoại
    private int brandId;    // Khóa ngoại
    private String mainImageUrl;
    private boolean isActive;
    private boolean isFeatured;
    private LocalDateTime created_at;

    public Product() {
    }

    public Product(int productId, String name, String slug, String description, double price, int stockQuantity, int categoryId, int brandId, String mainImageUrl, boolean isActive, LocalDateTime created_at) {
        this.productId = productId;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.categoryId = categoryId;
        this.brandId = brandId;
        this.mainImageUrl = mainImageUrl;
        this.isActive = isActive;
        this.created_at = created_at;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
    public boolean getIsActive() {
        return isActive;
    }
    
    public boolean getIsFeatured() {
        return isFeatured;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }
    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }
}