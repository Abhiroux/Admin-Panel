<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign Task</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa; /* Light gray background */
            color: #212529; /* Bootstrap dark text */
        }

        .card-custom {
            background-color: #ffffff;
            border-radius: 15px;
            padding: 25px;
            color: #212529;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .form-label {
            font-weight: 500;
        }

        .form-control, .form-select {
            background-color: #ffffff;
            color: #212529;
        }

        .btn-primary {
            background-color: #0d6efd;
            border: none;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
        }

        footer {
            background-color: #ffffff;
            color: #6c757d;
            border-top: 1px solid #dee2e6;
            padding: 10px 0;
            text-align: center;
            position: fixed;
            width: 100%;
            bottom: 0;
        }

        .form-wrapper {
            max-width: 500px;
            margin: auto;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: -250px; /* Initially hidden */
            width: 250px;
            height: 100%;
            background: #343a40;
            color: white;
            padding-top: 60px;
            transition: 0.3s ease-in-out;
            box-shadow: 3px 0 10px rgba(0, 0, 0, 0.2);
        }

        .sidebar.active {
            left: 0;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            padding: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            display: block;
            font-size: 16px;
        }

        .sidebar ul li a:hover {
            background: #495057;
            padding-left: 10px;
            transition: 0.3s;
        }

        /* Sidebar Toggle Button */
        .menu-toggle {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #343a40;
            color: white;
            border: none;
            padding: 10px 12px;
            border-radius: 5px;
            cursor: pointer;
            z-index: 1000;
        }

        .menu-toggle i {
            font-size: 20px;
        }

        /* Content Area */
        .content {
            margin-top: 50px;
            margin-left: 0;
            padding: 20px;
            transition: margin-left 0.3s;
        }

        .sidebar.active ~ .content {
            margin-left: 250px;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <ul>
            <li><a href="DashboardServlet">🏠 Dashboard</a></li>
            <li><a href="AssignTask.jsp">📝 Assign Task</a></li>
            <li><a href="PostAnnouncement.jsp">📢 Post Announcement</a></li>
            <li><a href="ManageLeaves.jsp">✅ Manage Leaves</a></li>
            <li><a href="add-employee.jsp">👨‍💼 Add Employee</a></li>
            <li><a href="EmployeeListServlet">📂 Manage Employees</a></li>
            <li><a href="LogoutServlet">🚪 Logout</a></li>
        </ul>
    </div>

    <!-- Sidebar Toggle Button -->
    <button class="menu-toggle"><i class="bi bi-list"></i></button>
<div class="container my-5">
    <div class="form-wrapper">
        <div class="card card-custom">
            <h3 class="text-center mb-4">Assign Task</h3>
            <form action="AssignTaskController" method="post">
                <!-- Employee selection -->
                <div class="mb-3">
                    <label for="employeeId" class="form-label">Select Employee</label>
                    <select name="employeeId" id="employeeId" class="form-select" required>
                        <option value="">-- Choose Employee --</option>
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/admin_db", "root", "1447");
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT id, name FROM employees");

                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String name = rs.getString("name");
                        %>
                            <option value="<%= id %>"><%= name %></option>
                        <%
                                }
                            } catch (Exception e) {
                                out.println("<option disabled>Error loading employees</option>");
                                e.printStackTrace();
                            } finally {
                                try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (Exception ex) {}
                            }
                        %>
                    </select>
                </div>

                <!-- Task Title -->
                <div class="mb-3">
                    <label for="taskTitle" class="form-label">Task Title</label>
                    <input type="text" name="taskTitle" id="taskTitle" class="form-control" required>
                </div>

                <!-- Task Description -->
                <div class="mb-3">
                    <label for="taskDescription" class="form-label">Task Description</label>
                    <textarea name="taskDescription" id="taskDescription" class="form-control" rows="3" required></textarea>
                </div>

                <!-- Deadline -->
                <div class="mb-3">
                    <label for="deadline" class="form-label">Deadline</label>
                    <input type="date" name="deadline" id="deadline" class="form-control" required>
                </div>

                <!-- Status -->
                <div class="mb-4">
                    <label for="status" class="form-label">Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="Assigned">Assigned</option>
                        <option value="In Progress">In Progress</option>
                        <option value="Completed">Completed</option>
                    </select>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-dark">Assign Task</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer>
    &copy; 2025 Admin Management System | Developed by Abhishek Kumar
</footer>
    
    <script>
        document.querySelector('.menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.content').classList.toggle('active');
        });
    </script>
</body>
</html>
