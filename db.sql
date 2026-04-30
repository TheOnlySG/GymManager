-- ============================================
-- Gym Membership & Workout Tracking System
-- Database Schema + Sample Data
-- ============================================

CREATE DATABASE IF NOT EXISTS gym_management;
USE gym_management;

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS progress_logs;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS trainer_assignments;
DROP TABLE IF EXISTS trainers;
DROP TABLE IF EXISTS members;

-- ============================================
-- MEMBERS TABLE
-- ============================================
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    membership_type ENUM('Basic', 'Premium', 'VIP') NOT NULL DEFAULT 'Basic',
    join_date DATE NOT NULL DEFAULT (CURDATE()),
    status ENUM('Active', 'Inactive', 'Expired') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TRAINERS TABLE
-- ============================================
CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    specialization VARCHAR(100),
    hire_date DATE NOT NULL DEFAULT (CURDATE()),
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TRAINER ASSIGNMENTS TABLE
-- ============================================
CREATE TABLE trainer_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    trainer_id INT NOT NULL,
    assigned_date DATE NOT NULL DEFAULT (CURDATE()),
    status ENUM('Active', 'Completed') NOT NULL DEFAULT 'Active',
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) ON DELETE CASCADE
);

-- ============================================
-- ATTENDANCE TABLE
-- ============================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    check_in_date DATE NOT NULL DEFAULT (CURDATE()),
    check_in_time TIME NOT NULL DEFAULT (CURTIME()),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- ============================================
-- PROGRESS LOGS TABLE
-- ============================================
CREATE TABLE progress_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    log_date DATE NOT NULL DEFAULT (CURDATE()),
    weight_kg DECIMAL(5,2) NOT NULL,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- ============================================
-- PAYMENTS TABLE
-- ============================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL DEFAULT (CURDATE()),
    payment_method ENUM('Cash', 'Card', 'UPI', 'Online') NOT NULL DEFAULT 'Cash',
    description VARCHAR(255),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Members (10)
INSERT INTO members (first_name, last_name, email, phone, date_of_birth, gender, membership_type, join_date, status) VALUES
('Rahul', 'Sharma', 'rahul.sharma@email.com', '9876543210', '1995-03-15', 'Male', 'Premium', '2025-01-10', 'Active'),
('Priya', 'Patel', 'priya.patel@email.com', '9876543211', '1998-07-22', 'Female', 'VIP', '2025-02-05', 'Active'),
('Amit', 'Kumar', 'amit.kumar@email.com', '9876543212', '1992-11-08', 'Male', 'Basic', '2025-01-20', 'Active'),
('Sneha', 'Reddy', 'sneha.reddy@email.com', '9876543213', '1997-05-30', 'Female', 'Premium', '2025-03-01', 'Active'),
('Vikram', 'Singh', 'vikram.singh@email.com', '9876543214', '1990-09-12', 'Male', 'VIP', '2024-12-15', 'Active'),
('Anita', 'Desai', 'anita.desai@email.com', '9876543215', '1996-01-25', 'Female', 'Basic', '2025-03-10', 'Active'),
('Rohan', 'Mehta', 'rohan.mehta@email.com', '9876543216', '1993-06-18', 'Male', 'Premium', '2025-02-20', 'Inactive'),
('Kavya', 'Nair', 'kavya.nair@email.com', '9876543217', '1999-12-03', 'Female', 'Basic', '2025-04-01', 'Active'),
('Suresh', 'Gupta', 'suresh.gupta@email.com', '9876543218', '1988-04-14', 'Male', 'VIP', '2024-11-20', 'Active'),
('Divya', 'Joshi', 'divya.joshi@email.com', '9876543219', '1994-08-07', 'Female', 'Premium', '2025-01-15', 'Expired');

-- Trainers (3)
INSERT INTO trainers (first_name, last_name, email, phone, specialization, hire_date) VALUES
('Arjun', 'Verma', 'arjun.verma@gym.com', '9988776601', 'Strength Training', '2024-06-01'),
('Meera', 'Iyer', 'meera.iyer@gym.com', '9988776602', 'Yoga & Flexibility', '2024-08-15'),
('Karan', 'Malhotra', 'karan.malhotra@gym.com', '9988776603', 'Cardio & HIIT', '2024-10-01');

-- Trainer Assignments
INSERT INTO trainer_assignments (member_id, trainer_id, assigned_date, status) VALUES
(1, 1, '2025-01-15', 'Active'),
(2, 2, '2025-02-10', 'Active'),
(3, 1, '2025-01-25', 'Active'),
(4, 3, '2025-03-05', 'Active'),
(5, 1, '2024-12-20', 'Active'),
(6, 2, '2025-03-15', 'Active'),
(9, 3, '2024-11-25', 'Active');

-- Attendance Records
INSERT INTO attendance (member_id, check_in_date, check_in_time) VALUES
(1, '2025-04-20', '06:30:00'),
(1, '2025-04-21', '06:45:00'),
(1, '2025-04-22', '07:00:00'),
(1, '2025-04-23', '06:30:00'),
(1, '2025-04-24', '06:15:00'),
(2, '2025-04-20', '08:00:00'),
(2, '2025-04-22', '08:15:00'),
(2, '2025-04-24', '07:45:00'),
(3, '2025-04-21', '17:00:00'),
(3, '2025-04-23', '17:30:00'),
(4, '2025-04-20', '09:00:00'),
(4, '2025-04-21', '09:15:00'),
(4, '2025-04-22', '09:00:00'),
(4, '2025-04-23', '09:30:00'),
(5, '2025-04-20', '05:30:00'),
(5, '2025-04-21', '05:45:00'),
(5, '2025-04-22', '05:30:00'),
(5, '2025-04-23', '05:15:00'),
(5, '2025-04-24', '05:30:00'),
(6, '2025-04-22', '18:00:00'),
(8, '2025-04-20', '16:00:00'),
(8, '2025-04-24', '16:30:00'),
(9, '2025-04-20', '07:00:00'),
(9, '2025-04-21', '07:15:00'),
(9, '2025-04-22', '07:00:00');

-- Progress Logs
INSERT INTO progress_logs (member_id, log_date, weight_kg, notes) VALUES
(1, '2025-01-15', 82.5, 'Starting weight'),
(1, '2025-02-15', 80.0, 'Good progress, diet on track'),
(1, '2025-03-15', 78.2, 'Lost 2kg this month'),
(1, '2025-04-15', 76.8, 'Consistent training paying off'),
(2, '2025-02-10', 58.0, 'Initial measurement'),
(2, '2025-03-10', 57.2, 'Slight decrease'),
(2, '2025-04-10', 56.5, 'On target'),
(3, '2025-01-25', 95.0, 'Starting weight - goal is 80kg'),
(3, '2025-03-01', 91.5, 'Slow but steady'),
(3, '2025-04-20', 88.0, 'Great improvement'),
(5, '2024-12-20', 70.0, 'Lean bulk start'),
(5, '2025-02-20', 72.5, 'Gaining muscle'),
(5, '2025-04-20', 74.0, 'Strength up significantly');

-- Payments
INSERT INTO payments (member_id, amount, payment_date, payment_method, description) VALUES
(1, 2500.00, '2025-01-10', 'UPI', 'Monthly Premium membership - January'),
(1, 2500.00, '2025-02-10', 'UPI', 'Monthly Premium membership - February'),
(1, 2500.00, '2025-03-10', 'UPI', 'Monthly Premium membership - March'),
(2, 5000.00, '2025-02-05', 'Card', 'Monthly VIP membership - February'),
(2, 5000.00, '2025-03-05', 'Card', 'Monthly VIP membership - March'),
(3, 1500.00, '2025-01-20', 'Cash', 'Monthly Basic membership - January'),
(3, 1500.00, '2025-02-20', 'Cash', 'Monthly Basic membership - February'),
(4, 2500.00, '2025-03-01', 'Online', 'Monthly Premium membership - March'),
(5, 15000.00, '2024-12-15', 'Card', 'Quarterly VIP membership'),
(6, 1500.00, '2025-03-10', 'UPI', 'Monthly Basic membership - March'),
(8, 1500.00, '2025-04-01', 'Cash', 'Monthly Basic membership - April'),
(9, 5000.00, '2024-11-20', 'Online', 'Monthly VIP membership - November');
