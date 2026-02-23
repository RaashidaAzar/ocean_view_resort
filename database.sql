-- Create Database
CREATE DATABASE IF NOT EXISTS ocean_view_db;
USE ocean_view_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, full_name) VALUES 
('admin', 'admin123', 'System Administrator');

-- Room Prices Table
CREATE TABLE IF NOT EXISTS room_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_category VARCHAR(50) NOT NULL,
    room_type VARCHAR(10) NOT NULL,
    meal_plan VARCHAR(10) NOT NULL,
    price_per_night DECIMAL(12,2) NOT NULL,
    UNIQUE KEY unique_room_config (room_category, room_type, meal_plan)
);

-- Insert default room prices
INSERT INTO room_prices (room_category, room_type, meal_plan, price_per_night) VALUES
('Superior', 'SGL', 'BB', 25000.00),
('Superior', 'SGL', 'HB', 30000.00),
('Superior', 'SGL', 'FB', 35000.00),
('Superior', 'DBL', 'BB', 35000.00),
('Superior', 'DBL', 'HB', 40000.00),
('Superior', 'DBL', 'FB', 45000.00),
('Superior', 'TPL', 'BB', 45000.00),
('Superior', 'TPL', 'HB', 50000.00),
('Superior', 'TPL', 'FB', 55000.00),
('Deluxe', 'SGL', 'BB', 35000.00),
('Deluxe', 'SGL', 'HB', 40000.00),
('Deluxe', 'SGL', 'FB', 45000.00),
('Deluxe', 'DBL', 'BB', 45000.00),
('Deluxe', 'DBL', 'HB', 50000.00),
('Deluxe', 'DBL', 'FB', 55000.00),
('Deluxe', 'TPL', 'BB', 55000.00),
('Deluxe', 'TPL', 'HB', 60000.00),
('Deluxe', 'TPL', 'FB', 65000.00),
('Premium', 'SGL', 'BB', 45000.00),
('Premium', 'SGL', 'HB', 50000.00),
('Premium', 'SGL', 'FB', 55000.00),
('Premium', 'DBL', 'BB', 55000.00),
('Premium', 'DBL', 'HB', 60000.00),
('Premium', 'DBL', 'FB', 65000.00),
('Premium', 'TPL', 'BB', 65000.00),
('Premium', 'TPL', 'HB', 70000.00),
('Premium', 'TPL', 'FB', 75000.00),
('Suites', 'SGL', 'BB', 65000.00),
('Suites', 'SGL', 'HB', 70000.00),
('Suites', 'SGL', 'FB', 75000.00),
('Suites', 'DBL', 'BB', 75000.00),
('Suites', 'DBL', 'HB', 80000.00),
('Suites', 'DBL', 'FB', 85000.00),
('Suites', 'TPL', 'BB', 85000.00),
('Suites', 'TPL', 'HB', 90000.00),
('Suites', 'TPL', 'FB', 95000.00);

-- Promotions Table
CREATE TABLE IF NOT EXISTS promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    promo_code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample promotions
INSERT INTO promotions (promo_code, description, discount_percentage, start_date, end_date, is_active) VALUES
('SUMMER2024', 'Summer Special Discount', 15.00, '2024-06-01', '2024-08-31', TRUE),
('BANK10', 'Bank Card Promotion', 10.00, '2024-01-01', '2024-12-31', TRUE),
('WEEKEND20', 'Weekend Special', 20.00, '2024-01-01', '2024-12-31', TRUE);

-- Reservations Table
CREATE TABLE IF NOT EXISTS reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_number VARCHAR(20) UNIQUE NOT NULL,
    guest_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    nic_number VARCHAR(20) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    room_category VARCHAR(50) NOT NULL,
    room_type VARCHAR(10) NOT NULL,
    meal_plan VARCHAR(10) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_adults INT NOT NULL,
    num_children INT NOT NULL,
    num_rooms INT NOT NULL,
    promo_code VARCHAR(50),
    discount_amount DECIMAL(12,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nic (nic_number),
    INDEX idx_reservation_number (reservation_number)
);
