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
    <title>Manage Room Prices</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .price-table {
            margin-bottom: 30px;
        }
        .category-header {
            background-color: #4C2A19;
            color: white;
            padding: 12px;
            font-size: 18px;
            font-weight: bold;
        }
        .price-table table {
            margin-top: 0;
        }
    </style>
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
        <h1 class="page-title">Manage Room Prices</h1>
        
        <div id="alertMessage"></div>
        
        <p style="color: #775646; margin-bottom: 20px;">Click Edit to update prices. All prices are in LKR per night.</p>
        
        <div id="pricesContainer">Loading...</div>
    </div>
    
    <div id="editModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000;">
        <div style="background: white; max-width: 500px; margin: 100px auto; padding: 30px; border-radius: 10px;">
            <h3 style="color: #1E0C04; margin-bottom: 20px;">Edit Room Price</h3>
            
            <div class="form-group">
                <label>Room Category</label>
                <input type="text" id="editCategory" readonly style="background: #E0D8D6;">
            </div>
            
            <div class="form-group">
                <label>Room Type</label>
                <input type="text" id="editType" readonly style="background: #E0D8D6;">
            </div>
            
            <div class="form-group">
                <label>Meal Plan</label>
                <input type="text" id="editMealPlan" readonly style="background: #E0D8D6;">
            </div>
            
            <div class="form-group">
                <label>Price per Night (LKR) *</label>
                <input type="number" id="editPrice" step="0.01" min="0" required>
            </div>
            
            <input type="hidden" id="editId">
            
            <div class="btn-group">
                <button class="btn btn-success" onclick="savePrice()">Save</button>
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>
    
    <script>
        window.onload = function() {
            loadRoomPrices();
        };
        
        function loadRoomPrices() {
            fetch('roomPrice?action=getAll')
                .then(response => response.json())
                .then(data => {
                    displayPrices(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error loading room prices', 'error');
                });
        }
        
        function displayPrices(prices) {
            const categories = ['Superior', 'Deluxe', 'Premium', 'Suites'];
            const roomTypes = ['SGL', 'DBL', 'TPL'];
            const mealPlans = ['BB', 'HB', 'FB'];
            
            let html = '';
            
            categories.forEach(category => {
                html += '<div class="price-table">';
                html += '<div class="category-header">' + category + '</div>';
                html += '<table>';
                html += '<thead><tr><th>Room Type</th>';
                mealPlans.forEach(meal => {
                    html += '<th>' + meal + '</th>';
                });
                html += '<th>Action</th></tr></thead>';
                html += '<tbody>';
                
                roomTypes.forEach(type => {
                    html += '<tr>';
                    html += '<td><strong>' + type + '</strong></td>';
                    
                    mealPlans.forEach(meal => {
                        const price = prices.find(p => p.roomCategory === category && p.roomType === type && p.mealPlan === meal);
                        if (price) {
                            html += '<td>' + formatCurrency(price.pricePerNight) + '</td>';
                        } else {
                            html += '<td>-</td>';
                        }
                    });
                    
                    html += '<td>';
                    mealPlans.forEach((meal, idx) => {
                        const price = prices.find(p => p.roomCategory === category && p.roomType === type && p.mealPlan === meal);
                        if (price) {
                            html += '<button class="btn btn-secondary" style="margin: 2px;" onclick="editPrice(' + price.id + ', \'' + 
                                    category + '\', \'' + type + '\', \'' + meal + '\', ' + 
                                    price.pricePerNight + ')">' + meal + '</button>';
                        }
                    });
                    html += '</td>';
                    html += '</tr>';
                });
                
                html += '</tbody></table></div>';
            });
            
            document.getElementById('pricesContainer').innerHTML = html;
        }
        
        function editPrice(id, category, type, mealPlan, price) {
            document.getElementById('editId').value = id;
            document.getElementById('editCategory').value = category;
            document.getElementById('editType').value = type;
            document.getElementById('editMealPlan').value = mealPlan;
            document.getElementById('editPrice').value = price;
            document.getElementById('editModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        function savePrice() {
            const id = document.getElementById('editId').value;
            const price = document.getElementById('editPrice').value;
            
            if (!price || parseFloat(price) <= 0) {
                alert('Please enter a valid price');
                return;
            }
            
            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('id', id);
            formData.append('price', price);
            
            fetch('roomPrice', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('Price updated successfully', 'success');
                    closeModal();
                    loadRoomPrices();
                } else {
                    showAlert('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error updating price', 'error');
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
