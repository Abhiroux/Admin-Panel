<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Timestamp" %>

<%
    String employeeName = (String) session.getAttribute("EmpName");
    String employeeEmail = (String) session.getAttribute("EmpEmail");
    String employeeRole = (String) session.getAttribute("position");
    int empId = (int) session.getAttribute("empId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            height: 100vh;
            background-color: #212529;
            padding-top: 20px;
            transition: all 0.3s ease;
        }
        .sidebar a {
            color: #ffffff;
            text-decoration: none;
            display: block;
            padding: 15px 20px;
            border-radius: 8px;
        }
        .sidebar a:hover {
            background-color: #343a40;
        }
        .sidebar .active {
            background-color: #495057;
        }
        .content {
            padding: 30px;
            transition: margin-left 0.3s ease;
        }
        .sidebar.collapsed {
            width: 0;
            overflow: hidden;
            padding: 0;
        }
        .content.full {
            margin-left: 0 !important;
        }
        #toggleSidebarBtn {
            background: none;
            border: none;
            font-size: 24px;
            margin-bottom: 20px;
        }
        footer {
            background-color: #212529;
            color: #ffffff;
            text-align: center;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            bottom: 0;
            left: 0;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 sidebar" id="sidebar">
            <h4 class="text-center text-white mb-4"><i class="bi bi-person-badge-fill"></i> Employee</h4>
            <a href="EmployeeDashboard.jsp" class="active"><i class="bi bi-house-door-fill me-2"></i>Dashboard</a>
            <a href="ChangePassword.jsp"><i class="bi bi-key-fill me-2"></i>Change Password</a>
            <a href="LogoutServlet" class="btn btn-danger mt-4"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10 content" id="contentArea">
            
            <button id="toggleSidebarBtn" class="d-md-none">
                <i class="bi bi-list"></i>
            </button>

            <h2 class="mb-4">Welcome, <%= employeeName %>!</h2>

            <!-- Profile Info -->
            <div class="d-flex justify-content-between">
                <div class="card mb-4 w-50">
                    <div class="card-header bg-dark text-white">
                        Your Profile
                    </div>
                    <div class="card-body">
                        <p><strong>Name:</strong> <%= employeeName %></p>
                        <p><strong>Email:</strong> <%= employeeEmail %></p>
                        <p><strong>Role:</strong> <%= employeeRole %></p>
                    </div>
                </div>

                <!-- Announcements -->
                <div class="card mb-4 w-50">
                    <div class="card-header bg-dark text-white">
                        Announcements
                    </div>
                    <div class="card-body">
                        <ul class="mb-0">
                            <%
                                Connection conn = null;
                                PreparedStatement ps = null;
                                ResultSet rs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/admin_db", "root", "1447");
                                    ps = conn.prepareStatement("SELECT message, posted_on FROM announcements ORDER BY posted_on DESC");
                                    rs = ps.executeQuery();

                                    boolean hasData = false;
                                    while(rs.next()) {
                                        hasData = true;
                                        String message = rs.getString("message");
                                        Timestamp postedOn = rs.getTimestamp("posted_on");
                            %>
                                <li>📢 <%= message %> <br><small class="text-muted">Posted on <%= postedOn %></small></li>
                            <%
                                    }

                                    if (!hasData) {
                            %>
                                <li class="text-muted">No announcements yet.</li>
                            <%
                                    }
                                } catch (Exception e) {
                            %>
                                <li class="text-danger">Error loading announcements: <%= e.getMessage() %></li>
                            <%
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                                    if (ps != null) try { ps.close(); } catch (Exception ignored) {}
                                    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                                }
                            %>
                            </ul>

                    </div>
                </div>
            </div>

            <!-- Tasks Table -->
            <div class="card mb-4">
                <div class="card-header bg-dark text-white">
                    Assigned Tasks
                </div>
                <div class="card-body p-0">
                    <table class="table table-striped mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Deadline</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection taskConn = null;
                                PreparedStatement taskPs = null;
                                ResultSet taskRs = null;

                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    taskConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/admin_db", "root", "1447");

                                    String taskQuery = "SELECT task_title, description, deadline, status FROM tasks WHERE employee_id = ?";
                                    taskPs = taskConn.prepareStatement(taskQuery);
                                    taskPs.setInt(1, empId);
                                    taskRs = taskPs.executeQuery();

                                    boolean hasTasks = false;
                                    while (taskRs.next()) {
                                        hasTasks = true;
                                        String title = taskRs.getString("task_title");
                                        String description = taskRs.getString("description");
                                        String deadline = taskRs.getString("deadline");
                                        String status = taskRs.getString("status");
                            %>
                                <tr>
                                    <td><%= title %></td>
                                    <td><%= description %></td>
                                    <td><%= deadline %></td>
                                    <td>
                                        <% if ("Completed".equalsIgnoreCase(status)) { %>
                                            <span class="badge bg-success">Completed</span>
                                        <% } else if ("In Progress".equalsIgnoreCase(status)) { %>
                                            <span class="badge bg-warning text-dark">In Progress</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary"><%= status %></span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%
                                    }

                                    if (!hasTasks) {
                            %>
                                <tr>
                                    <td colspan="4" class="text-center text-muted">No tasks assigned yet.</td>
                                </tr>
                            <%
                                    }

                                } catch (Exception e) {
                            %>
                                <tr>
                                    <td colspan="4" class="text-danger">Error: <%= e.getMessage() %></td>
                                </tr>
                            <%
                                } finally {
                                    if (taskRs != null) try { taskRs.close(); } catch (Exception ignored) {}
                                    if (taskPs != null) try { taskPs.close(); } catch (Exception ignored) {}
                                    if (taskConn != null) try { taskConn.close(); } catch (Exception ignored) {}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Footer Buttons -->
            <div class="d-flex justify-content-end gap-3">
                <a href="ChangePassword.jsp" class="btn btn-outline-dark"><i class="bi bi-key"></i> Change Password</a>
                <a href="LogoutServlet" class="btn btn-danger"><i class="bi bi-box-arrow-right me-2"></i>Logout</a>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    <p>&copy; 2025 Your Company. All Rights Reserved.</p>
</footer>

<!-- Script for sidebar toggle -->
<script>
    const toggleBtn = document.getElementById("toggleSidebarBtn");
    const sidebar = document.getElementById("sidebar");
    const contentArea = document.getElementById("contentArea");

    toggleBtn.addEventListener("click", () => {
        sidebar.classList.toggle("collapsed");
        contentArea.classList.toggle("full");
    });
</script>

</body>
</html>
