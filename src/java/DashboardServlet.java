import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Employee;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.getConnection();

            // 1. Get total employee count
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM employees");
            rs = stmt.executeQuery();
            if (rs.next()) {
                request.setAttribute("totalEmployees", rs.getInt(1));
            }

            // 2. Get role count
            stmt = conn.prepareStatement("SELECT position, COUNT(*) FROM employees GROUP BY position");
            rs = stmt.executeQuery();
            Map<String, Integer> roleCount = new HashMap<>();
            while (rs.next()) {
                roleCount.put(rs.getString(1), rs.getInt(2));
            }
            request.setAttribute("roleCount", roleCount);

            // 3. Get recent employees
            stmt = conn.prepareStatement("SELECT name, position, join_date FROM employees ORDER BY join_date DESC LIMIT 5");
            rs = stmt.executeQuery();
            List<Employee> recentEmployees = new ArrayList<>();
            while (rs.next()) {
                recentEmployees.add(new Employee(
                        rs.getString("name"),
                        rs.getString("position"),
                        rs.getString("join_date")
                ));
            }
            request.setAttribute("recentEmployees", recentEmployees);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (stmt != null) stmt.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }

        // Forward to JSP
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
