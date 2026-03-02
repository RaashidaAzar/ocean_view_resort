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
    <title>View Reservations</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <a href="home.jsp" class="navbar-brand">Ocean View Resort</a>
        <div class="navbar-menu">
            <a href="home.jsp">Home</a>
            <a href="logout">Sign Out</a>
        </div>
    </nav>
    
    <div class="container">
        <a href="home.jsp" class="back-button">← Back to Dashboard</a>
        <h1 class="page-title">Reservation Details</h1>
        
        <div id="alertMessage"></div>
        
        <div class="search-container">
            <select id="searchType">
                <option value="all">All Reservations</option>
                <option value="reservation">Reservation Number</option>
                <option value="nic">NIC Number</option>
            </select>
            <input type="text" id="searchValue" placeholder="Enter search value">
            <button class="btn btn-primary" onclick="searchReservations()">Search</button>
        </div>
        
        <table id="reservationsTable">
            <thead>
                <tr>
                    <th>Reservation #</th>
                    <th>Guest Name</th>
                    <th>NIC</th>
                    <th>Contact</th>
                    <th>Room Details</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Total (LKR)</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="reservationsBody">
                <tr>
                    <td colspan="9" style="text-align: center;">Loading...</td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <script>
        window.onload = function() {
            loadAllReservations();
        };
        
        function loadAllReservations() {
            fetch('reservation?action=getAll')
                .then(response => response.json())
                .then(data => {
                    displayReservations(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error loading reservations', 'error');
                });
        }
        
        function searchReservations() {
            const searchType = document.getElementById('searchType').value;
            const searchValue = document.getElementById('searchValue').value.trim();
            
            if (searchType === 'all') {
                loadAllReservations();
                return;
            }
            
            if (!searchValue) {
                showAlert('Please enter a search value', 'error');
                return;
            }
            
            fetch('reservation?action=search&searchType=' + searchType + '&searchValue=' + searchValue)
                .then(response => response.json())
                .then(data => {
                    displayReservations(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error searching reservations', 'error');
                });
        }
        
        function displayReservations(reservations) {
            const tbody = document.getElementById('reservationsBody');
            
            if (reservations.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align: center;">No reservations found</td></tr>';
                return;
            }
            
            let html = '';
            reservations.forEach(r => {
                html += '<tr>';
                html += '<td>' + r.reservationNumber + '</td>';
                html += '<td>' + r.guestName + '</td>';
                html += '<td>' + r.nicNumber + '</td>';
                html += '<td>' + r.contactNumber + '</td>';
                html += '<td>' + r.roomCategory + ' - ' + r.roomType + ' - ' + r.mealPlan + '</td>';
                html += '<td>' + r.checkInDate + '</td>';
                html += '<td>' + r.checkOutDate + '</td>';
                html += '<td>' + formatCurrency(r.totalAmount) + '</td>';
                html += '<td>';
                html += '<button class="btn btn-secondary" style="margin-right: 5px;" onclick="editReservation(' + r.id + ')">Edit</button>';
                html += '<button class="btn btn-danger" onclick="deleteReservation(' + r.id + ')">Delete</button>';
                html += '</td>';
                html += '</tr>';
            });
            
            tbody.innerHTML = html;
        }
        
        function editReservation(id) {
            location.href = 'edit-reservation.jsp?id=' + id;
        }
        
        function deleteReservation(id) {
            if (!confirm('Are you sure you want to delete this reservation?')) {
                return;
            }
            
            fetch('reservation?action=delete&id=' + id, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('Reservation deleted successfully', 'success');
                    loadAllReservations();
                } else {
                    showAlert('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error deleting reservation', 'error');
            });
        }
        
        function formatCurrency(amount) {
            return parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        
        function showAlert(message, type) {
            const alertDiv = document.getElementById('alertMessage');
            alertDiv.innerHTML = '<div class="alert alert-' + type + '">' + message + '</div>';
            setTimeout(() => {
                alertDiv.innerHTML = '';
            }, 5000);
        }
    </script>
</body>
</html>
