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

@WebServlet(name = "SearchController", urlPatterns = {"/search"})
public class SearchController extends HttpServlet {
    
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đảm bảo hỗ trợ ký tự tiếng Việt trong URL
        request.setCharacterEncoding("UTF-8"); 
        
        // 1. Lấy từ khóa
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            // Nếu từ khóa rỗng, chuyển hướng về trang chủ
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // 2. Gọi DAO để thực hiện tìm kiếm
        List<Product> results = productDAO.searchProducts(keyword);
        
        // 3. Đặt dữ liệu vào Request Scope
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchResults", results);
        
        // 4. Chuyển tiếp đến trang hiển thị kết quả
        request.getRequestDispatcher("/search_results.jsp").forward(request, response);
    }
}