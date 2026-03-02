<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="home.jsp" class="navbar-brand">Ocean View Resort</a>
        <div class="navbar-menu">
            <span style="color: #E0D8D6;">Welcome, <%= session.getAttribute("fullName") %></span>
            <a href="logout">Sign Out</a>
        </div>
    </nav>
    
    <div class="container">
        <h1 class="page-title">Dashboard</h1>
        
        <div class="card-grid">
            <div class="card" onclick="location.href='add-reservation.jsp'">
                <div class="card-title">Add New Reservation</div>
                <div class="card-description">Create a new guest reservation</div>
            </div>
            
            <div class="card" onclick="location.href='view-reservations.jsp'">
                <div class="card-title">Reservation Details</div>
                <div class="card-description">View and manage all reservations</div>
            </div>
            
            <div class="card" onclick="location.href='billing.jsp'">
                <div class="card-title">Calculate & Print Bill</div>
                <div class="card-description">Generate guest bills</div>
            </div>
            
            <div class="card" onclick="location.href='room-prices.jsp'">
                <div class="card-title">Manage Room Prices</div>
                <div class="card-description">Update room pricing</div>
            </div>
            
            <div class="card" onclick="location.href='promotions.jsp'">
                <div class="card-title">Promotions & Offers</div>
                <div class="card-description">Manage promotional codes</div>
            </div>
            
            <div class="card" onclick="location.href='help.jsp'">
                <div class="card-title">Help Section</div>
                <div class="card-description">System usage guidelines</div>
            </div>
        </div>
    </div>
</body>
</html>
