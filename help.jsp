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
    <title>Help Section</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .help-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #E0D8D6;
            border-radius: 8px;
        }
        .help-section h3 {
            color: #1E0C04;
            margin-bottom: 15px;
        }
        .help-section ol, .help-section ul {
            margin-left: 20px;
            color: #4C2A19;
        }
        .help-section li {
            margin-bottom: 10px;
            line-height: 1.6;
        }
        .help-note {
            background-color: #775646;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            margin-top: 10px;
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
        <h1 class="page-title">Help Section - System Usage Guidelines</h1>
        
        <div class="help-section">
            <h3>01. Adding a New Reservation</h3>
            <ol>
                <li>Click on "Add New Reservation" from the dashboard</li>
                <li>The system will automatically generate a unique reservation number (e.g., R000001)</li>
                <li>Fill in all required guest details:
                    <ul>
                        <li>Guest Name</li>
                        <li>Address</li>
                        <li>NIC Number</li>
                        <li>Contact Number</li>
                    </ul>
                </li>
                <li>Select room preferences:
                    <ul>
                        <li>Room Category (Superior, Deluxe, Premium, Suites)</li>
                        <li>Room Type (SGL, DBL, TPL)</li>
                        <li>Meal Plan (BB, HB, FB)</li>
                    </ul>
                </li>
                <li>Enter check-in and check-out dates</li>
                <li>Specify number of adults, children, and rooms</li>
                <li>If applicable, enter a promotion code and click "Apply" to get discount</li>
                <li>The total amount will be calculated automatically</li>
                <li>Click "Save Reservation" to complete the booking</li>
            </ol>
            <div class="help-note">
                <strong>Note:</strong> All fields marked with * are mandatory. The system will validate dates to ensure check-out is after check-in.
            </div>
        </div>
        
        <div class="help-section">
            <h3>02. Viewing and Managing Reservations</h3>
            <ol>
                <li>Click on "Reservation Details" from the dashboard</li>
                <li>All reservations are displayed in a table format</li>
                <li>To search for specific reservations:
                    <ul>
                        <li>Select search type (All, Reservation Number, or NIC Number)</li>
                        <li>Enter the search value</li>
                        <li>Click "Search"</li>
                    </ul>
                </li>
                <li>To edit a reservation, click the "Edit" button next to it</li>
                <li>To delete a reservation, click the "Delete" button (confirmation required)</li>
            </ol>
            <div class="help-note">
                <strong>Tip:</strong> Use the search function to quickly find specific guest reservations.
            </div>
        </div>
        
        <div class="help-section">
            <h3>03. Editing Reservations</h3>
            <ol>
                <li>From the Reservation Details page, click "Edit" on the desired reservation</li>
                <li>Modify any required information</li>
                <li>If you change room details or dates, the total will recalculate automatically</li>
                <li>You can apply or change promotion codes</li>
                <li>Click "Update Reservation" to save changes</li>
                <li>Click "Cancel" to return without saving</li>
            </ol>
            <div class="help-note">
                <strong>Important:</strong> The reservation number cannot be changed once created.
            </div>
        </div>
        
        <div class="help-section">
            <h3>04. Calculating and Printing Bills</h3>
            <ol>
                <li>Click on "Calculate & Print Bill" from the dashboard</li>
                <li>Select search type (Reservation Number or NIC Number)</li>
                <li>Enter the search value and click "Search"</li>
                <li>The system will display a detailed bill including:
                    <ul>
                        <li>Guest information</li>
                        <li>Reservation details</li>
                        <li>Number of nights (calculated automatically)</li>
                        <li>Rate per night</li>
                        <li>Subtotal</li>
                        <li>Discount (if applicable)</li>
                        <li>Total amount</li>
                    </ul>
                </li>
                <li>Click "Print Bill" to print the bill</li>
                <li>Click "New Search" to search for another reservation</li>
            </ol>
            <div class="help-note">
                <strong>Note:</strong> All amounts are displayed in LKR with proper formatting (e.g., LKR 45,000.00)
            </div>
        </div>
        
        <div class="help-section">
            <h3>05. Managing Room Prices</h3>
            <ol>
                <li>Click on "Manage Room Prices" from the dashboard</li>
                <li>View all room prices in a table format organized by:
                    <ul>
                        <li>Room Category</li>
                        <li>Room Type</li>
                        <li>Meal Plan</li>
                    </ul>
                </li>
                <li>To update a price, click the "Edit" button</li>
                <li>Enter the new price per night</li>
                <li>Click "Save" to update the price</li>
            </ol>
            <div class="help-note">
                <strong>Important:</strong> Price changes will apply to all new reservations. Existing reservations are not affected.
            </div>
        </div>
        
        <div class="help-section">
            <h3>06. Managing Promotions and Offers</h3>
            <ol>
                <li>Click on "Promotions & Offers" from the dashboard</li>
                <li>View all existing promotions with their details</li>
                <li><strong>To add a new promotion:</strong>
                    <ul>
                        <li>Click "Add New Promotion"</li>
                        <li>Enter promo code (e.g., SUMMER2024)</li>
                        <li>Enter description</li>
                        <li>Set discount percentage</li>
                        <li>Select start and end dates</li>
                        <li>Check "Active" to enable the promotion</li>
                        <li>Click "Save"</li>
                    </ul>
                </li>
                <li><strong>To edit a promotion:</strong>
                    <ul>
                        <li>Click "Edit" button next to the promotion</li>
                        <li>Modify the details</li>
                        <li>Click "Save"</li>
                    </ul>
                </li>
                <li><strong>To delete a promotion:</strong>
                    <ul>
                        <li>Click "Delete" button</li>
                        <li>Confirm deletion</li>
                    </ul>
                </li>
            </ol>
            <div class="help-note">
                <strong>Note:</strong> Only active promotions within their valid date range can be applied to reservations.
            </div>
        </div>
        
        <div class="help-section">
            <h3>07. System Security</h3>
            <ul>
                <li>Always sign out when you finish using the system</li>
                <li>Do not share your login credentials</li>
                <li>The system will automatically log you out after a period of inactivity</li>
                <li>Use the "Sign Out" button in the navigation bar to log out safely</li>
            </ul>
        </div>
        
        <div class="help-section">
            <h3>08. Important Tips</h3>
            <ul>
                <li>All prices are displayed in LKR (Sri Lankan Rupees) with comma separators</li>
                <li>Dates must be in the correct format (YYYY-MM-DD)</li>
                <li>Check-out date must be after check-in date</li>
                <li>Promotion codes are case-insensitive</li>
                <li>Use the "Back" button to navigate to previous pages</li>
                <li>The system validates all inputs before saving</li>
                <li>Success and error messages will appear at the top of each page</li>
            </ul>
        </div>
        
        <div class="help-section">
            <h3>09. Need More Help?</h3>
            <p style="color: #4C2A19;">If you encounter any issues or need additional assistance, please contact the system administrator or IT support team.</p>
        </div>
    </div>
</body>
</html>
