import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AssignTaskController")
public class AssignTaskController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String empId = request.getParameter("employeeId");
        String taskTitle = request.getParameter("taskTitle");
        String task = request.getParameter("taskDescription");
        String deadline = request.getParameter("deadline");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.getConnection(); // Using your DB utility

            String sql = "INSERT INTO tasks (employee_id, task_title, description, deadline, status) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(empId));
            ps.setString(2, taskTitle);
            ps.setString(3, task);
            ps.setString(4, deadline);
            ps.setString(5, "Assigned");

            int result = ps.executeUpdate();

            if (result > 0) {
                
                response.sendRedirect("Success.jsp?taskAssigned=success");
            } else {
                response.sendRedirect("AssignTask.jsp?error=fail");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AssignTask.jsp?error=exception");
        } finally {
            try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }
}
