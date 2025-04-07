<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
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
    <title>Edit Employee</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f4f4f9, #e2e8f0);
           
        }
        .edit-container {
            background-color: #fff;
            padding: 40px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            width: 400px;
            animation: fadeIn 0.5s ease;
            margin: 50px auto;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .edit-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #084298;
            border-color: #084298;
        }
        .navbar-brand {
            font-weight: bold;
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
            margin-left: 0;
            padding: 20px;
            transition: margin-left 0.3s;
        }

        .sidebar.active ~ .content {
            margin-left: 250px;
        }
        .content {
            padding: 20px;
            flex-grow: 1;
        }
    </style>
</head>
<body>
         <!-- Sidebar -->
    <div class="sidebar">
        <ul>
            <li><a href="/Admin_Management_System/dashboard.jsp">🏠 Dashboard</a></li>
            <li><a href="add-employee.jsp">👨‍💼 Add Employee</a></li>
            <li><a href="EmployeeListServlet">📂 Manage Employees</a></li>
            <li><a href="LogoutServlet">🚪 Logout</a></li>
        </ul>
    </div>

    <!-- Sidebar Toggle Button -->
    <button class="menu-toggle"><i class="bi bi-list"></i></button>
    <div class="content">
            <div class="edit-container">
        <h2>Edit Employee</h2>
        <form action="UpdateEmployeeServlet" method="post">
            <input type="hidden" name="id" value="<%= request.getAttribute("id") %>">

            <div class="mb-3">
                <label class="form-label">Name:</label>
                <input type="text" name="name" class="form-control" value="<%= request.getAttribute("name") %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" class="form-control" value="<%= request.getAttribute("email") %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Position:</label>
                <input type="text" name="position" class="form-control" value="<%= request.getAttribute("position") %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Salary:</label>
                <input type="number" step="0.01" name="salary" class="form-control" value="<%= request.getAttribute("salary") %>" required>
            </div>

            <button type="submit" class="btn btn-dark w-100">Update</button>
        </form>
    </div>
    </div>
    <script>
        document.querySelector('.menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.content').classList.toggle('active');
        });
    </script>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
