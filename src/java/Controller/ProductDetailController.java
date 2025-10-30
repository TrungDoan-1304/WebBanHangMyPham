/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


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

@WebServlet(name = "ProductDetailController", urlPatterns = {"/productDetail"}) 
public class ProductDetailController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
        try {
            String productIdStr = request.getParameter("id");
            int productId = Integer.parseInt(productIdStr);
            Product product = productDAO.getProductById(productId); 
            
            if (product != null) {
                List<String> subImages = productDAO.getProductImagesByProductId(productId);
                request.setAttribute("product", product);
                request.setAttribute("subImages", subImages); 
                
                request.getRequestDispatcher("/productDetail.jsp").forward(request, response);
            } else {
             
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sản phẩm không hợp lệ.");
        }
    }
}