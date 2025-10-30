package Controller;

import DAO.ProductDAO;
import DAO.CategoryDAO; // Giả định có
import Model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CategoryController", urlPatterns = {"/category"})
public class CategoryController extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();
    // private final CategoryDAO categoryDAO = new CategoryDAO(); // Nếu cần dùng
    
    // Ánh xạ các mục trong Sidebar đến ID trong CSDL
    private int mapCategoryToId(String categoryName) {
        switch (categoryName.toLowerCase()) {
            case "dưỡng da": 
            case "làm sạch": 
             // Dùng chung ID 2 (skincare)
                return 2; 
            case "trang điểm nền":
            case "trang điểm mắt môi":
            // Dùng chung ID 1 (make)
                return 1;
            case "chăm sóc tóc": // Dùng chung ID 3 (haircare)
                return 3;
            case "dược mỹ phẩm ":
            case "sức khỏe làm đẹp":
            case "thực phẩm chức năng":
                return 99;
            default:
                return -1; // ID không hợp lệ
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Lấy tên danh mục từ tham số (Ví dụ: category?name=duong+da)
        String categoryNameParam = request.getParameter("name");
        
        if (categoryNameParam == null || categoryNameParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }
        
        // 1. Ánh xạ tên thành ID CSDL
        int categoryId = mapCategoryToId(categoryNameParam);
        if (categoryId == 99) {
            request.setAttribute("categoryTitle", categoryNameParam.toUpperCase());
            request.setAttribute("products", new ArrayList<Product>()); // Gửi danh sách RỖNG
            request.setAttribute("showNoProductMessage", true); // <-- THIẾT LẬP CỜ HIỂN THỊ
        }
        else if (categoryId == -1) {
            request.setAttribute("categoryTitle", "Danh mục không tồn tại");
            request.setAttribute("products", new ArrayList<Product>());
        } else {
            // 2. Lấy danh sách sản phẩm
            List<Product> products = productDAO.getProductsByCategoryId(categoryId);

            // 3. Đặt dữ liệu vào Request Scope
            request.setAttribute("categoryTitle", categoryNameParam.toUpperCase());
            request.setAttribute("products", products);
        }

        request.getRequestDispatcher("/category.jsp").forward(request, response);
    }
}