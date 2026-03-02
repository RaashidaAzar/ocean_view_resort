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
    <title>Promotions & Offers</title>
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
        <h1 class="page-title">Promotions & Offers</h1>
        
        <div id="alertMessage"></div>
        
        <button class="btn btn-primary" onclick="showAddModal()" style="margin-bottom: 20px;">Add New Promotion</button>
        
        <table id="promotionsTable">
            <thead>
                <tr>
                    <th>Promo Code</th>
                    <th>Description</th>
                    <th>Discount %</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="promotionsBody">
                <tr>
                    <td colspan="6" style="text-align: center;">Loading...</td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <!-- Add/Edit Modal -->
    <div id="promoModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; overflow-y: auto;">
        <div style="background: white; max-width: 600px; margin: 50px auto; padding: 30px; border-radius: 10px;">
            <h3 style="color: #1E0C04; margin-bottom: 20px;" id="modalTitle">Add New Promotion</h3>
            
            <form id="promoForm">
                <input type="hidden" id="promoId" name="id">
                
                <div class="form-group">
                    <label for="promoCode">Promo Code *</label>
                    <input type="text" id="promoCode" name="promoCode" required style="text-transform: uppercase;">
                </div>
                
                <div class="form-group">
                    <label for="description">Description *</label>
                    <textarea id="description" name="description" rows="3" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="discountPercentage">Discount Percentage (%) *</label>
                    <input type="number" id="discountPercentage" name="discountPercentage" step="0.01" min="0" max="100" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="startDate">Start Date *</label>
                        <input type="date" id="startDate" name="startDate" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="endDate">End Date *</label>
                        <input type="date" id="endDate" name="endDate" required>
                    </div>
                </div>
                
                <input type="hidden" id="isActive" name="isActive" value="true">
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-success">Save</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        window.onload = function() {
            loadPromotions();
        };
        
        function loadPromotions() {
            fetch('promotion?action=getAll')
                .then(response => response.json())
                .then(data => {
                    displayPromotions(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error loading promotions', 'error');
                });
        }
        
        function displayPromotions(promotions) {
            const tbody = document.getElementById('promotionsBody');
            
            if (promotions.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">No promotions found</td></tr>';
                return;
            }
            
            let html = '';
            promotions.forEach(p => {
                html += '<tr>';
                html += '<td><strong>' + p.promoCode + '</strong></td>';
                html += '<td>' + p.description + '</td>';
                html += '<td>' + p.discountPercentage + '%</td>';
                html += '<td>' + p.startDate + '</td>';
                html += '<td>' + p.endDate + '</td>';
                html += '<td>';
                html += '<button class="btn btn-secondary" style="margin-right: 5px;" onclick="editPromotion(' + p.id + ')">Edit</button>';
                html += '<button class="btn btn-danger" onclick="deletePromotion(' + p.id + ')">Delete</button>';
                html += '</td>';
                html += '</tr>';
            });
            
            tbody.innerHTML = html;
        }
        
        function showAddModal() {
            document.getElementById('modalTitle').textContent = 'Add New Promotion';
            document.getElementById('promoForm').reset();
            document.getElementById('promoId').value = '';
            document.getElementById('promoModal').style.display = 'block';
        }
        
        function editPromotion(id) {
            fetch('promotion?action=getById&id=' + id)
                .then(response => response.json())
                .then(data => {
                    document.getElementById('modalTitle').textContent = 'Edit Promotion';
                    document.getElementById('promoId').value = data.id;
                    document.getElementById('promoCode').value = data.promoCode;
                    document.getElementById('description').value = data.description;
                    document.getElementById('discountPercentage').value = data.discountPercentage;
                    document.getElementById('startDate').value = data.startDate;
                    document.getElementById('endDate').value = data.endDate;
                    document.getElementById('promoModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('Error loading promotion', 'error');
                });
        }
        
        function closeModal() {
            document.getElementById('promoModal').style.display = 'none';
        }
        
        document.getElementById('promoForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const id = document.getElementById('promoId').value;
            const formData = new URLSearchParams();
            formData.append('action', id ? 'update' : 'save');
            if (id) formData.append('id', id);
            formData.append('promoCode', document.getElementById('promoCode').value);
            formData.append('description', document.getElementById('description').value);
            formData.append('discountPercentage', document.getElementById('discountPercentage').value);
            formData.append('startDate', document.getElementById('startDate').value);
            formData.append('endDate', document.getElementById('endDate').value);
            formData.append('isActive', 'true');
            
            fetch('promotion', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert(id ? 'Promotion updated successfully' : 'Promotion added successfully', 'success');
                    closeModal();
                    loadPromotions();
                } else {
                    showAlert('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error saving promotion', 'error');
            });
        });
        
        function deletePromotion(id) {
            if (!confirm('Are you sure you want to delete this promotion?')) {
                return;
            }
            
            fetch('promotion?action=delete&id=' + id, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('Promotion deleted successfully', 'success');
                    loadPromotions();
                } else {
                    showAlert('Error: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('Error deleting promotion', 'error');
            });
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
