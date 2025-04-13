<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Employee" %>
<%
    if (session.getAttribute("adminEmail") == null) { 
        response.sendRedirect("index.jsp");
        return;
    }

    String adminName = (String) session.getAttribute("adminName");
    String adminEmail = (String) session.getAttribute("adminEmail");
    Integer totalEmployees = (Integer) request.getAttribute("totalEmployees");
    Map<String, Integer> roleCount = (Map<String, Integer>) request.getAttribute("roleCount");
    List<Employee> recentEmployees = (List<Employee>) request.getAttribute("recentEmployees");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        /* Sidebar Styling */
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
        footer {
            background-color: #212529;
            color: #ffffff;
            text-align: center;
            padding: 10px 0;
            width: 100%;
            bottom: 0;
            left: 0;
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

    <!-- Main Content -->
    <div class="content">
     <div class="container mt-4">
        <h2>Welcome, <%= adminName %></h2>
        <p>Email: <%= adminEmail %></p>

        <div class="row my-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary mb-3">
                    <div class="card-body">
                        <h5>Total Employees</h5>
                        <p style="font-size: 24px;"><%= totalEmployees != null ? totalEmployees : 0 %></p>
                    </div>
                </div>
            </div>
           <div class="col-md-8 d-flex justify-content-center">
             <canvas id="roleChart" style="width: 450px; height: 450px;"></canvas>
           </div>

        </div>

        <h4>Recently Added Employees</h4>
        <table class="table table-bordered">
            <thead>
                <tr><th>Name</th><th>Role</th><th>Join Date</th></tr>
            </thead>
            <tbody>
                <% if (recentEmployees != null && !recentEmployees.isEmpty()) {
                    for (Employee emp : recentEmployees) { %>
                        <tr>
                            <td><%= emp.getName() %></td>
                            <td><%= emp.getPosition() %></td>
                            <td><%= emp.getJoinDate() %></td>
                        </tr>
                <%  } 
                } else { %>
                    <tr><td colspan="3">No recent employees found.</td></tr>
                <% } %>
            </tbody>
        </table>
    <a href="EmployeeListServlet" class="btn btn-outline-dark mt-2">See All Employees</a>

    </div>
    </div>
            <footer>
    <p>&copy; 2025 Your Company. All Rights Reserved.</p>
</footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Sidebar Toggle Script -->
    <script>
        document.querySelector('.menu-toggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.content').classList.toggle('active');
        });
        
        const ctx = document.getElementById('roleChart').getContext('2d');
const roleChart = new Chart(ctx, {
    type: 'pie',
    data: {
        labels: [<%
            if (roleCount != null) {
                int i = 0;
                for (String role : roleCount.keySet()) {
                    out.print("\"" + role + "\"");
                    if (++i < roleCount.size()) out.print(", ");
                }
            }
        %>],
        datasets: [{
            label: 'Role Distribution',
            data: [<%
                if (roleCount != null) {
                    int i = 0;
                    for (Integer count : roleCount.values()) {
                        out.print(count);
                        if (++i < roleCount.size()) out.print(", ");
                    }
                }
            %>],
            backgroundColor: [
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        responsive: false,
        maintainAspectRatio: false
    }
});

    </script>

</body>
</html>
