 OCEAN VIEW RESORT – RESERVATION MANAGEMENT SYSTEM

OVERVIEW
Ocean View Resort is a web-based application designed to manage hotel reservations, guest information, room pricing, and billing operations efficiently. The system allows staff to handle reservations, manage dynamic room pricing, generate bills, and maintain guest records through a simple and user-friendly interface.

The application supports full CRUD operations (Create, Read, Update, Delete) for all major entities, making reservation and billing management more organized and efficient.

 KEY FEATURES

1. USER AUTHENTICATION

   * Secure login and logout functionality
   * Session management for user security

2. RESERVATION MANAGEMENT

   * Add new reservations
   * Update existing reservations
   * Delete reservations
   * View reservation details

3. ROOM PRICING MANAGEMENT

   * Dynamic pricing based on room category and type
   * Easy price updates for administrators

4. BILLING SYSTEM

   * Automatic bill generation
   * Total price calculation based on reservation details

5. GUEST MANAGEMENT

   * Store and manage guest information
   * Maintain contact and identification details

6. PROMOTIONS & OFFERS MANAGEMENT

   * Create promotional codes
   * Apply discounts during reservations

7. SEARCH FUNCTIONALITY

   * Search reservations using Reservation ID
   * Search guests using NIC

8. INPUT VALIDATION

   * Guest name validation
   * NIC validation
   * Contact number validation
   * Date validation
   * Price validation

9. DATABASE INTEGRATION

   * MySQL database for secure data storage

10. DAO PATTERN

    * Structured data access using the DAO design pattern

 TECHNOLOGIES USED

* Java EE / Jakarta EE
* Servlets and JSP
* MySQL Database
* DAO Design Pattern
* Maven (Dependency Management)
* Jetty Server (Maven Plugin)
* HTML, CSS, JavaScript

 SETUP INSTRUCTIONS

1. CLONE THE REPOSITORY

   git clone https://github.com/RaashidaAzar/ocean_view_resort.git
   cd ocean_view

2. DATABASE SETUP

   1. Start XAMPP and ensure MySQL is running
   2. Open phpMyAdmin:
      http://localhost/phpmyadmin
   3. Import the SQL file located at:
      src/main/resources/ocean_view_db

   4. The database and required tables will be created automatically

3. CONFIGURE DATABASE CONNECTION

   If required, update the database credentials in the following file:

   src/main/java/com/oceanview/util/DBConnection.java

   Modify the username, password, or database name according to your MySQL configuration.

4. BUILD AND RUN THE APPLICATION

   Run the following commands in the project directory:

   mvn clean install
   mvn jetty:run

5. ACCESS THE APPLICATION

   Open the following URL in your browser:

   http://localhost:8080/ocean_view

 DEFAULT LOGIN CREDENTIALS

Username : admin
Password : admin123

 SYSTEM PURPOSE

The Ocean View Resort Reservation Management System helps hotel staff efficiently manage reservations, pricing, billing, and guest information within a centralized platform. The system improves operational efficiency, reduces manual errors, and provides quick access to reservation and billing data.
