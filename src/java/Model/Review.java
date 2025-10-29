package Model;

import java.time.LocalDateTime;

public class Review {
    private int reviewId;
    private int productId;  // Khóa ngoại
    private int userId;     // Khóa ngoại
    private int rating;     // 1-5 sao
    private String comment;
    private LocalDateTime created_at;

    public Review() {
    }

    public Review(int reviewId, int productId, int userId, int rating, String comment, LocalDateTime created_at) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
        this.created_at = created_at;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }
}