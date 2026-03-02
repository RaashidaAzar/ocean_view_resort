<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String reservationId = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation</title>
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
        <a href="view-reservations.jsp" class="back-button">← Back to Reservations</a>
        <h1 class="page-title">Edit Reservation</h1>
        
        <div id="alertMessage"></div>
        
        <form id="reservationForm">
            <input type="hidden" id="reservationId" name="id" value="<%= reservationId %>">
            
            <div class="form-row">
                <div class="form-group">
                    <label for="reservationNumber">Reservation Number</label>
                    <input type="text" id="reservationNumber" name="reservationNumber" readonly>
                </div>
                
                <div class="form-group">
                    <label for="guestName">Guest Name *</label>
                    <input type="text" id="guestName" name="guestName" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="address">Address *</label>
                <textarea id="address" name="address" rows="3" required></textarea>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="nicNumber">NIC Number *</label>
                    <input type="text" id="nicNumber" name="nicNumber" required>
                </div>
                
                <div class="form-group">
                    <label for="contactNumber">Contact Number *</label>
                    <input type="text" id="contactNumber" name="contactNumber" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="roomCategory">Room Category *</label>
                    <select id="roomCategory" name="roomCategory" required onchange="calculateTotal()">
                        <option value="">Select Category</option>
                        <option value="Superior">Superior</option>
                        <option value="Deluxe">Deluxe</option>
                        <option value="Premium">Premium</option>
                        <option value="Suites">Suites</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="roomType">Room Type *</label>
                    <select id="roomType" name="roomType" required onchange="calculateTotal()">
                        <option value="">Select Type</option>
                        <option value="SGL">Single (SGL)</option>
                        <option value="DBL">Double (DBL)</option>
                        <option value="TPL">Triple (TPL)</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="mealPlan">Meal Plan *</label>
                    <select id="mealPlan" name="mealPlan" required onchange="calculateTotal()">
                        <option value="">Select Plan</option>
                        <option value="BB">Bed & Breakfast (BB)</option>
                        <option value="HB">Half Board (HB)</option>
                        <option value="FB">Full Board (FB)</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="checkInDate">Check-in Date *</label>
                    <input type="date" id="checkInDate" name="checkInDate" required onchange="calculateTotal()">
                </div>
                
                <div class="form-group">
                    <label for="checkOutDate">Check-out Date *</label>
                    <input type="date" id="checkOutDate" name="checkOutDate" required onchange="calculateTotal()">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="numAdults">Number of Adults *</label>
                    <input type="number" id="numAdults" name="numAdults" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="numChildren">Number of Children</label>
                    <input type="number" id="numChildren" name="numChildren" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="numRooms">Number of Rooms *</label>
                    <input type="number" id="numRooms" name="numRooms" min="1" required onchange="calculateTotal()">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="promoCode">Promotion Code</label>
                    <input type="text" id="promoCode" name="promoCode">
                </div>
                <div class="form-group">
                    <label>&nbsp;</label>
                    <button type="button" class="btn btn-secondary" onclick="applyPromoCode()">Apply</button>
                </div>
            </div>
            
            <input type="hidden" id="discountAmount" name="discountAmount" value="0">
            
            <div class="price-display">
                Total Amount: LKR <span id="totalAmount">0.00</span>
            </div>
            
            <input type="hidden" id="totalAmountHidden" name="totalAmount" value="0">
            
            <div class="btn-group">
                <button type="submit" class="btn btn-success">Update Reservation</button>
                <button type="button" class="btn btn-secondary" onclick="location.href='view-reservations.jsp'">Cancel</button>
            </div>
        </form>
    </div>
    
    <script>
        let discountPercentage = 0;
        
        window.onload = function() {
            loadReservation();
        };
        
        function loadReservation() {
            const id = document.getElementById('reservationId').value;
            
            fetch('reservation?action=getById&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('reservationNumber').value = data.reservationNumber;
                    document.getElementById('guestName').value = data.guestName;
                    document.getElementById('address').value = data.address;
                    document.getElementById('nicNumber').value = data.nicNumber;
                    document.getElementById('contactNumber').value = data.contactNumber;
                    document.getElementById('roomCategory').value = data.roomCategory;
                    document.getElementById('roomType').value = data.roomType;
                    document.getElementById('mealPlan').value = data.mealPlan;
                    document.getElementById('checkInDate').value = data.checkInDate;
                    document.getElementById('checkOutDate').value = data.checkOutDate;
                    document.getElementById('numAdults').value = data.numAdults;
                    document.getElementById('numChildren').value = data.numChildren;
                    document.getElementById('numRooms').value = data.numRooms;
                    document.getElementById('promoCode').value = data.promoCode || '';
                    document.getElementById('discountAmount').value = data.discountAmount;
                    document.getElementById('totalAmount').textContent = formatCurrency(data.totalAmount);
                    document.getElementById('totalAmountHidden').value = data.totalAmount;
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error loading reservation', 'error');
                });
        }
        
        function calculateTotal() {
            const roomCategory = document.getElementById('roomCategory').value;
            const roomType = document.getElementById('roomType').value;
            const mealPlan = document.getElementById('mealPlan').value;
            const checkIn = document.getElementById('checkInDate').value;
            const checkOut = document.getElementById('checkOutDate').value;
            const numRooms = parseInt(document.getElementById('numRooms').value) || 1;
            
            if (!roomCategory || !roomType || !mealPlan || !checkIn || !checkOut) {
                return;
            }
            
            const checkInDate = new Date(checkIn);
            const checkOutDate = new Date(checkOut);
            const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
            
            if (nights <= 0) {
                showAlert('Check-out date must be after check-in date', 'error');
                return;
            }
            
            fetch('roomPrice?action=getPrice&roomCategory=' + roomCategory + '&roomType=' + roomType + '&mealPlan=' + mealPlan)
                .then(response => response.json())
                .then(data => {
                    const pricePerNight = parseFloat(data.price);
                    const subtotal = pricePerNight * nights * numRooms;
                    const discount = (subtotal * discountPercentage) / 100;
                    const total = subtotal - discount;
                    
                    document.getElementById('discountAmount').value = discount.toFixed(2);
                    document.getElementById('totalAmount').textContent = formatCurrency(total);
                    document.getElementById('totalAmountHidden').value = total.toFixed(2);
                })
                .catch(error => console.error('Error:', error));
        }
        
        function applyPromoCode() {
            const promoCode = document.getElementById('promoCode').value.trim();
            
            if (!promoCode) {
                showAlert('Please enter a promo code', 'error');
                return;
            }
            
            fetch('promotion?action=validate&promoCode=' + promoCode)
                .then(response => response.json())
                .then(data => {
                    if (data.valid === false) {
                        showAlert(data.message, 'error');
                        discountPercentage = 0;
                    } else {
                        discountPercentage = parseFloat(data.discountPercentage);
                        showAlert('Promo code applied! ' + discountPercentage + '% discount', 'success');
                    }
                    calculateTotal();
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error validating promo code', 'error');
                });
        }
        
        function formatCurrency(amount) {
            return parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            formData.append('action', 'update');
            
            fetch('reservation', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('Reservation updated successfully!', 'success');
                    setTimeout(() => {
                        location.href = 'view-reservations.jsp';
                    }, 1500);
                } else {
                    showAlert('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error updating reservation', 'error');
            });
        });
        
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
