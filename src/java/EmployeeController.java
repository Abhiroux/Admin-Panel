/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;

/**
 *
 * @author sriva
 */
@WebServlet(urlPatterns = {"/EmployeeController"})
public class EmployeeController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        
        response.setContentType("text/html;charset=UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String hashedInput = PasswordUtil.hashPassword(password);
        try (Connection conn = DatabaseConnection.getConnection()) {
            
            
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM employees WHERE email=? AND password=?");
            ps.setString(1, email);
            ps.setString(2, hashedInput);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                HttpSession session = request.getSession();
                int empId = rs.getInt("id");
                session.setAttribute("empId", empId);
                session.setAttribute("EmpName", rs.getString("name"));
                session.setAttribute("EmpEmail", rs.getString("email"));
                session.setAttribute("position",rs.getString("position"));
                session.setAttribute("join_date", rs.getString("join_date"));
                response.sendRedirect("EmployeeDashboard.jsp");
//                out.println("Logged in Successfully");
                return;
            }else{
                out.println("<script>alert('Invalid credentials!');</script>");
                request.getRequestDispatcher("EmployeeLogin.html").include(request, response);
            }
        }catch(Exception e){
            
            out.println("Logged in Failed");
            out.println(e);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
