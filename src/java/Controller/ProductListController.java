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

@WebServlet(name = "ProductListController", urlPatterns = {"/sanpham"})
public class ProductListController extends HttpServlet {

    // Khởi tạo ProductDAO
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Gọi DAO để lấy TẤT CẢ sản phẩm đang hoạt động
            List<Product> allProducts = productDAO.getAllProducts(); 
            
            // 2. Đặt danh sách sản phẩm vào Request Scope
            request.setAttribute("allProducts", allProducts);
            
            // 3. Chuyển tiếp yêu cầu đến trang JSP để hiển thị
            request.getRequestDispatcher("/sanpham.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Xử lý lỗi nếu có vấn đề về CSDL hoặc logic
            System.err.println("Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải dữ liệu sản phẩm.");
        }
    }
}