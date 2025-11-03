package Controller;

import DAO.ProductDAO;
import Model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductAdminController", urlPatterns = {"/adminproducts"})
public class ProductAdminController extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();
    private static final String LIST_PAGE = "/adminproduct_list.jsp";
    private static final String EDIT_PAGE = "/adminproduct_edit.jsp";
    private static final String REDIRECT_LIST = "products";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định hiển thị danh sách
        }

        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "edit":
            case "create":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if ("save".equals(action)) {
            saveProduct(request, response);
        } else {
            response.sendRedirect(REDIRECT_LIST); // Quay lại trang danh sách
        }
    }

    // --- LOGIC XỬ LÝ GET ---

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // Giả sử ProductDAO có hàm getAllProducts() để lấy tất cả sản phẩm (bao gồm cả ảnh chính)
        List<Product> listProduct = productDAO.getAllProducts(); 
        
        request.setAttribute("listProduct", listProduct);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String productIdStr = request.getParameter("id");
        Product existingProduct = new Product(); // Mặc định là tạo mới
        
        if (productIdStr != null && !productIdStr.isEmpty()) {
            // Lấy thông tin sản phẩm để chỉnh sửa
            int productId = Integer.parseInt(productIdStr);
            existingProduct = productDAO.getProductById(productId);
        }
        
        // Truyền đối tượng sản phẩm và chuyển hướng đến trang form
        request.setAttribute("product", existingProduct);
        request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int productId = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(productId);
        
        // Quay lại trang danh sách sau khi xóa
        response.sendRedirect(REDIRECT_LIST);
    }

    // --- LOGIC XỬ LÝ POST ---
    
private void saveProduct(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // Đảm bảo xử lý ký tự tiếng Việt
    request.setCharacterEncoding("UTF-8"); 
    
    // Khai báo biến
    String redirectUrl = request.getContextPath() + "/adminproducts?status=";
    String statusMessage = "failure"; // Mặc định là thất bại
    
    try {
        // 1. LẤY VÀ XỬ LÝ ID SẢN PHẨM (0 nếu là tạo mới)
        int productId = 0;
        String productIdStr = request.getParameter("productId");
        if (productIdStr != null && !productIdStr.isEmpty()) {
            productId = Integer.parseInt(productIdStr);
        }

        // 2. LẤY TẤT CẢ THAM SỐ KHÁC TỪ FORM
        String name = request.getParameter("name");
        String slug = request.getParameter("slug");
        String description = request.getParameter("description");
        
        // Chuyển đổi kiểu dữ liệu số
        double price = Double.parseDouble(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        
        // Lấy trạng thái (Kiểm tra checkbox)
        boolean isActive = "on".equalsIgnoreCase(request.getParameter("isActive"));
        boolean isFeatured = "on".equalsIgnoreCase(request.getParameter("isFeatured"));

        // 3. TẠO ĐỐI TƯỢNG PRODUCT VÀ GÁN DỮ LIỆU
        Product product = new Product();
        product.setProductId(productId);
        product.setName(name);
        product.setSlug(slug);
        product.setDescription(description);
        product.setPrice(price);
        product.setStockQuantity(stockQuantity);
        product.setCategoryId(categoryId);
        product.setBrandId(brandId);
        product.setActive(isActive);
        product.setFeatured(isFeatured);

        // 4. GỌI DAO ĐỂ THỰC HIỆN LƯU/CẬP NHẬT
        boolean success;
        if (productId == 0) {
            // Tạo mới (CREATE)
            success = productDAO.addProduct(product);
        } else {
            // Cập nhật (UPDATE)
            success = productDAO.updateProduct(product);
        }

        if (success) {
            statusMessage = "success";
        }
        
    } catch (NumberFormatException e) {
        // Xử lý lỗi chuyển đổi số (ví dụ: giá, tồn kho không phải số)
        System.err.println("Lỗi định dạng số khi lưu sản phẩm: " + e.getMessage());
        statusMessage = "format_error";
    } catch (Exception e) {
        System.err.println("Lỗi hệ thống khi lưu sản phẩm: " + e.getMessage());
        statusMessage = "error";
    }
    
    // 5. CHUYỂN HƯỚNG VỀ TRANG DANH SÁCH VỚI THAM SỐ TRẠNG THÁI
    response.sendRedirect(redirectUrl + statusMessage);
}
}