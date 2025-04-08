<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%
    List<String[]> employees = (List<String[]>) request.getAttribute("employees");
    if (employees == null) {
        employees = new ArrayList<>();
    }

    if (session.getAttribute("adminEmail") == null) {
        response.sendRedirect("index.html");
        return;
    }
    String adminName = (String) session.getAttribute("adminName");
    String adminEmail = (String) session.getAttribute("adminEmail");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            position: fixed;
            top: 0;
            left: -250px;
            width: 250px;
            height: 100%;
            background: #343a40;
            color: white;
            padding-top: 60px;
            transition: 0.3s ease-in-out;
        }
        .sidebar.active { left: 0; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar ul li { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.2); }
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
        .content {
            margin-left: 0;
            padding: 20px;
            transition: margin-left 0.3s;
        }
        .sidebar.active ~ .content {
            margin-left: 250px;
        }
        .table-container {
            max-width: 1200px;
            margin: auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            background: white;
            padding: 20px;
        }
        .table {
            margin: 0;
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn { margin: 0 2px; }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <ul>
            <li><a href="DashboardServlet">🏠 Dashboard</a></li>
            <li><a href="add-employee.jsp">👨‍💼 Add Employee</a></li>
            <li><a href="EmployeeListServlet">📂 Manage Employees</a></li>
            <li><a href="LogoutServlet">🚪 Logout</a></li>
        </ul>
    </div>

    <!-- Toggle Button -->
    <button class="menu-toggle"><i class="bi bi-list"></i></button>

    <!-- Content -->
    <!-- Content -->
<div class="content">
    <!-- Elegant Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-semibold text-dark">👨‍💼 Employee Directory</h2>
        <a href="add-employee.jsp" class="btn btn-success rounded-pill">
            <i class="bi bi-plus-circle"></i> Add New
        </a>
    </div>

    <!-- Search Form (Centered + Elegant) -->
    <form method="get" action="EmployeeListServlet" class="mb-4 d-flex justify-content-center">
        <div class="input-group shadow-sm w-100" style="max-width: 500px;">
            <input type="text" name="search" class="form-control rounded-start" placeholder="Search by name or email"
                value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button class="btn btn-primary rounded-end" type="submit">
                <i class="bi bi-search"></i>
            </button>
        </div>
    </form>

    <!-- Table Container (Card Style) -->
    <div class="table-container shadow-sm p-4 bg-white rounded-4">
        <table class="table table-hover align-middle">
            <thead class="table-light text-center">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Position</th>
                    <th>Salary</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (String[] emp : employees) { %>
                <tr class="text-center">
                    <td><%= emp[0] %></td>
                    <td><%= emp[1] %></td>
                    <td><%= emp[2] %></td>
                    <td><%= emp[3] %></td>
                    <td>₹ <%= emp[4] %></td>
                    <td>
                        <a href="EditEmployeeServlet?id=<%= emp[0] %>" class="btn btn-outline-warning btn-sm rounded-pill me-1">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>
                        <a href="DeleteEmployeeServlet?id=<%= emp[0] %>" class="btn btn-outline-danger btn-sm rounded-pill"
                            onclick="return confirm('Are you sure you want to delete this employee?');">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelector('.menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.content').classList.toggle('active');
        });
    </script>

</body>
</html>
