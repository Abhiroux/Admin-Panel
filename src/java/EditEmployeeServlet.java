import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

@WebServlet("/EditEmployeeServlet")
public class EditEmployeeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String name = "";
        String email = "";
        String position = "";
        double salary = 0.0;

        if (id != null) {
            try {
                // Using DatabaseConnection from the default package
                Connection conn = DatabaseConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM employees WHERE id = ?");
                ps.setInt(1, Integer.parseInt(id));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    name = rs.getString("name");
                    email = rs.getString("email");
                    position = rs.getString("position");
                    salary = rs.getDouble("salary");
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Set attributes to forward to JSP
        request.setAttribute("id", id);
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("position", position);
        request.setAttribute("salary", salary);

        RequestDispatcher dispatcher = request.getRequestDispatcher("edit-employee.jsp");
        dispatcher.forward(request, response);
    }
}
