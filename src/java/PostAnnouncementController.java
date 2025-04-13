import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PostAnnouncementController")
public class PostAnnouncementController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String message = request.getParameter("message");
        LocalDate date = LocalDate.now();

        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "INSERT INTO announcements (message, posted_on) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, message);
            ps.setDate(2, java.sql.Date.valueOf(date));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("Success.jsp"); // or confirmation page
            } else {
                response.getWriter().println("Failed to post announcement.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
