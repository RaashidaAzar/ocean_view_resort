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
    <title>Calculate & Print Bill</title>
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
        <h1 class="page-title">Calculate & Print Bill</h1>
        
        <div class="search-container">
            <select id="searchType">
                <option value="reservation">Reservation Number</option>
                <option value="nic">NIC Number</option>
            </select>
            <input type="text" id="searchValue" placeholder="Enter search value">
            <button class="btn btn-primary" onclick="searchReservation()">Search</button>
        </div>
        
        <div id="billSection" style="display: none;">
            <div class="bill-container" id="billContent">
                <div class="bill-header">
                    <h2 style="color: #1E0C04; margin-bottom: 10px;">Ocean View Resort</h2>
                    <p style="color: #775646;">Galle, Sri Lanka</p>
                    <p style="color: #775646;">Tel: +94 91 234 5678</p>
                    <h3 style="color: #4C2A19; margin-top: 20px;">GUEST BILL</h3>
                </div>
                
                <div style="margin: 20px 0;">
                    <div class="bill-row">
                        <strong>Reservation Number:</strong>
                        <span id="billReservationNumber"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Guest Name:</strong>
                        <span id="billGuestName"></span>
                    </div>
                    <div class="bill-row">
                        <strong>NIC Number:</strong>
                        <span id="billNIC"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Contact Number:</strong>
                        <span id="billContact"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Address:</strong>
                        <span id="billAddress"></span>
                    </div>
                </div>
                
                <div style="margin: 20px 0;">
                    <h4 style="color: #4C2A19; margin-bottom: 15px;">Reservation Details</h4>
                    <div class="bill-row">
                        <strong>Room Category:</strong>
                        <span id="billRoomCategory"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Room Type:</strong>
                        <span id="billRoomType"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Meal Plan:</strong>
                        <span id="billMealPlan"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Check-in Date:</strong>
                        <span id="billCheckIn"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Check-out Date:</strong>
                        <span id="billCheckOut"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Number of Nights:</strong>
                        <span id="billNights"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Number of Rooms:</strong>
                        <span id="billNumRooms"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Number of Adults:</strong>
                        <span id="billAdults"></span>
                    </div>
                    <div class="bill-row">
                        <strong>Number of Children:</strong>
                        <span id="billChildren"></span>
                    </div>
                </div>
                
                <div style="margin: 20px 0;">
                    <h4 style="color: #4C2A19; margin-bottom: 15px;">Payment Details</h4>
                    <div class="bill-row">
                        <strong>Rate per Night:</strong>
                        <span>LKR <span id="billRatePerNight"></span></span>
                    </div>
                    <div class="bill-row">
                        <strong>Subtotal:</strong>
                        <span>LKR <span id="billSubtotal"></span></span>
                    </div>
                    <div class="bill-row" id="discountRow" style="display: none;">
                        <strong>Discount (<span id="billPromoCode"></span>):</strong>
                        <span>LKR <span id="billDiscount"></span></span>
                    </div>
                    <div class="bill-total">
                        <div class="bill-row">
                            <strong style="font-size: 22px;">TOTAL AMOUNT:</strong>
                            <strong style="font-size: 22px; color: #1E0C04;">LKR <span id="billTotal"></span></strong>
                        </div>
                    </div>
                </div>
                
                <div style="margin-top: 40px; text-align: center; color: #775646;">
                    <p>Thank you for choosing Ocean View Resort!</p>
                    <p style="font-size: 12px; margin-top: 10px;">This is a computer-generated bill</p>
                </div>
            </div>
            
            <div class="btn-group" style="margin-top: 20px;">
                <button class="btn btn-primary" onclick="window.print()">Print Bill</button>
                <button class="btn btn-secondary" onclick="resetBill()">New Search</button>
            </div>
        </div>
    </div>
    
    <script>
        function searchReservation() {
            const searchType = document.getElementById('searchType').value;
            const searchValue = document.getElementById('searchValue').value.trim();
            
            if (!searchValue) {
                alert('Please enter a search value');
                return;
            }
            
            fetch('reservation?action=search&searchType=' + searchType + '&searchValue=' + searchValue)
                .then(response => response.json())
                .then(data => {
                    if (data.length === 0) {
                        alert('No reservation found');
                        return;
                    }
                    
                    displayBill(data[0]);
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error searching reservation');
                });
        }
        
        function displayBill(reservation) {
            document.getElementById('billReservationNumber').textContent = reservation.reservationNumber;
            document.getElementById('billGuestName').textContent = reservation.guestName;
            document.getElementById('billNIC').textContent = reservation.nicNumber;
            document.getElementById('billContact').textContent = reservation.contactNumber;
            document.getElementById('billAddress').textContent = reservation.address;
            
            document.getElementById('billRoomCategory').textContent = reservation.roomCategory;
            document.getElementById('billRoomType').textContent = reservation.roomType;
            document.getElementById('billMealPlan').textContent = reservation.mealPlan;
            document.getElementById('billCheckIn').textContent = reservation.checkInDate;
            document.getElementById('billCheckOut').textContent = reservation.checkOutDate;
            document.getElementById('billNumRooms').textContent = reservation.numRooms;
            document.getElementById('billAdults').textContent = reservation.numAdults;
            document.getElementById('billChildren').textContent = reservation.numChildren;
            
            const checkIn = new Date(reservation.checkInDate);
            const checkOut = new Date(reservation.checkOutDate);
            const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
            document.getElementById('billNights').textContent = nights;
            
            const subtotal = parseFloat(reservation.totalAmount) + parseFloat(reservation.discountAmount);
            const ratePerNight = subtotal / (nights * reservation.numRooms);
            
            document.getElementById('billRatePerNight').textContent = formatCurrency(ratePerNight);
            document.getElementById('billSubtotal').textContent = formatCurrency(subtotal);
            
            if (reservation.promoCode && parseFloat(reservation.discountAmount) > 0) {
                document.getElementById('discountRow').style.display = 'flex';
                document.getElementById('billPromoCode').textContent = reservation.promoCode;
                document.getElementById('billDiscount').textContent = formatCurrency(reservation.discountAmount);
            } else {
                document.getElementById('discountRow').style.display = 'none';
            }
            
            document.getElementById('billTotal').textContent = formatCurrency(reservation.totalAmount);
            
            document.getElementById('billSection').style.display = 'block';
        }
        
        function formatCurrency(amount) {
            return parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        
        function resetBill() {
            document.getElementById('billSection').style.display = 'none';
            document.getElementById('searchValue').value = '';
        }
    </script>
</body>
</html>
