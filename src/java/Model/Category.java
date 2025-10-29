package Model;

public class Category {
    private int categoryId;
    private String categoryName;
    private String slug;
    private String description;

    public Category() {
    }

    public Category(int categoryId, String categoryName, String slug, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.slug = slug;
        this.description = description;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
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
}