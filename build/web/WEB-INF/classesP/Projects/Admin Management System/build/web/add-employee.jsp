<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminEmail") == null) { 
        response.sendRedirect("index.jsp");
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
    <title>Add Employee</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f4f4f9, #e2e8f0);
            display: flex;
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
        .form-container {
            background-color: #fff;
            padding: 40px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            width: 400px;
            margin: 50px auto;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 5px rgba(13, 110, 253, 0.5);
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
        .icon {
            margin-right: 8px;
        }
        .navbar-brand {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <ul>
            <li><a href="DashboardServlet">🏠 Dashboard</a></li>
            <li><a href="add-employee.jsp">👨‍💼 Add Employee</a></li>
            <li><a href="EmployeeListServlet">📂 Manage Employees</a></li>
            <li><a href="LogoutServlet">🚪 Logout</a></li>
        </ul>
    </div>

    <!-- Sidebar Toggle Button -->
    <button class="menu-toggle"><i class="bi bi-list"></i></button>
    <div class="content">
        <div class="form-container">
            <h2><i class="bi bi-person-plus"></i> Add Employee</h2>
            <form action="AddEmployeeServlet" method="post">
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" name="name" id="name" class="form-control" placeholder="Enter employee name" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" id="email" class="form-control" placeholder="Enter employee email" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="position" class="form-label">Position</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-briefcase"></i></span>
                        <input type="text" name="position" id="position" class="form-control" placeholder="Enter position" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="salary" class="form-label">Salary</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-cash"></i></span>
                        <input type="number" name="salary" id="salary" step="0.01" class="form-control" placeholder="Enter salary" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-dark w-100">Add Employee</button>
            </form>
        </div>
    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
     <script>
        document.querySelector('.menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.content').classList.toggle('active');
        });
    </script>
</body>
</html>