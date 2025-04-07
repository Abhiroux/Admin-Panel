import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminEmail") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {
            // 1. Total Employees Count
            int totalEmployees = 0;
            PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM employees");
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                totalEmployees = countRs.getInt(1);
            }

            // 2. Role-wise Distribution
            Map<String, Integer> roleCount = new HashMap<>();
            PreparedStatement roleStmt = conn.prepareStatement("SELECT position, COUNT(*) AS count FROM employees GROUP BY position");
            ResultSet roleRs = roleStmt.executeQuery();
            while (roleRs.next()) {
                roleCount.put(roleRs.getString("position"), roleRs.getInt("count"));
            }

            // 3. Recently Added Employees (last 5)
            ArrayList<String[]> recentEmployees = new ArrayList<>();
            PreparedStatement recentStmt = conn.prepareStatement("SELECT * FROM employees ORDER BY id DESC LIMIT 5");
            ResultSet recentRs = recentStmt.executeQuery();
            while (recentRs.next()) {
                String[] emp = {
                    String.valueOf(recentRs.getInt("id")),
                    recentRs.getString("name"),
                    recentRs.getString("email"),
                    recentRs.getString("position")
                };
                recentEmployees.add(emp);
            }

            // Set attributes
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("roleCount", roleCount);
            request.setAttribute("recentEmployees", recentEmployees);

            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
