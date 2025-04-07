import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;

@WebServlet("/EmployeeListServlet")
public class EmployeeListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String search = request.getParameter("search"); // Get the search parameter from the URL

        try (Connection conn = DatabaseConnection.getConnection()) {
            PreparedStatement ps;

            if (search != null && !search.trim().isEmpty()) {
                String query = "SELECT * FROM employees WHERE LOWER(name) LIKE ? OR LOWER(email) LIKE ?";
                ps = conn.prepareStatement(query);
                String searchTerm = "%" + search.toLowerCase() + "%";
                ps.setString(1, searchTerm);
                ps.setString(2, searchTerm);
            } else {
                ps = conn.prepareStatement("SELECT * FROM employees");
            }

            ResultSet rs = ps.executeQuery();

            ArrayList<String[]> employees = new ArrayList<>();
            while (rs.next()) {
                String[] emp = {
                    String.valueOf(rs.getInt("id")),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("position"),
                    String.valueOf(rs.getDouble("salary"))
                };
                employees.add(emp);
            }

            request.setAttribute("employees", employees);
            request.getRequestDispatcher("employee-list.jsp").forward(request, response);
        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
