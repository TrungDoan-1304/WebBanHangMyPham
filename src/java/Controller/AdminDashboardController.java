/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author PC
 */
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {
    
    private final OrderDAO orderDAO = new OrderDAO(); // Giả định đã có OrderDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy dữ liệu KPI (Doanh thu tháng, năm, chờ xử lý)
        BigDecimal monthlyRevenue = orderDAO.getMonthlyRevenue();
        BigDecimal yearlyRevenue = orderDAO.getYearlyRevenue();
        int pendingCount = orderDAO.getPendingRequestsCount();

        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("yearlyRevenue", yearlyRevenue);
        request.setAttribute("pendingCount", pendingCount);
        
        // 2. LẤY DỮ LIỆU BIỂU ĐỒ
        Map<Integer, Double> weeklyDataMap = orderDAO.getWeeklyRevenueData();
        
        // Chuyển đổi Map sang List<Double> theo đúng thứ tự (1=CN, 2=T2,...)
        List<Double> chartData = new ArrayList<>();
        chartData.add(weeklyDataMap.get(1)); // CN
        chartData.add(weeklyDataMap.get(2)); // T2
        chartData.add(weeklyDataMap.get(3)); // T3
        chartData.add(weeklyDataMap.get(4)); // T4
        chartData.add(weeklyDataMap.get(5)); // T5
        chartData.add(weeklyDataMap.get(6)); // T6
        chartData.add(weeklyDataMap.get(7)); // T7
        
        // 3. Đặt vào Request Scope (Dùng chuỗi JSON thủ công để JS dễ đọc)
        String chartLabelsJson = "[\"CN\", \"T2\", \"T3\", \"T4\", \"T5\", \"T6\", \"T7\"]";
        String chartDataJson = chartData.toString(); // Sẽ ra dạng [0.0, 0.0, 2230000.0, ...]
        
        request.setAttribute("chartLabels", chartLabelsJson);
        request.setAttribute("chartData", chartDataJson);

        // 4. Forward
        request.getRequestDispatcher("/admindashboard.jsp").forward(request, response);
    }
}