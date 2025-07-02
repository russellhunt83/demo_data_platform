--Create a database in our brand new server
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'demo_data_platform')
    EXEC('CREATE database demo_data_platform');
GO

-- Make sure we're in the datbase we just created
USE demo_data_platform
GO

-- Create schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'customer')
    EXEC('CREATE SCHEMA customer');
GO

-- Create person table
IF OBJECT_ID('customer.person', 'U') IS NOT NULL
    DROP TABLE customer.person;
GO

CREATE TABLE customer.person (
    id INT IDENTITY(1,1) PRIMARY KEY,
    firstname NVARCHAR(50),
    surname NVARCHAR(50),
    email_address NVARCHAR(100),
    phone_number NVARCHAR(20)
);
GO

-- Insert 50 fake users
INSERT INTO customer.person (firstname, surname, email_address, phone_number) VALUES
('Olivia', 'Smith', 'olivia.smith@example.com', '555-0101'),
('Liam', 'Johnson', 'liam.johnson@example.com', '555-0102'),
('Emma', 'Williams', 'emma.williams@example.com', '555-0103'),
('Noah', 'Brown', 'noah.brown@example.com', '555-0104'),
('Ava', 'Jones', 'ava.jones@example.com', '555-0105'),
('Elijah', 'Garcia', 'elijah.garcia@example.com', '555-0106'),
('Sophia', 'Martinez', 'sophia.martinez@example.com', '555-0107'),
('Lucas', 'Davis', 'lucas.davis@example.com', '555-0108'),
('Isabella', 'Rodriguez', 'isabella.rodriguez@example.com', '555-0109'),
('Mason', 'Hernandez', 'mason.hernandez@example.com', '555-0110'),
('Mia', 'Lopez', 'mia.lopez@example.com', '555-0111'),
('Logan', 'Gonzalez', 'logan.gonzalez@example.com', '555-0112'),
('Charlotte', 'Wilson', 'charlotte.wilson@example.com', '555-0113'),
('Ethan', 'Anderson', 'ethan.anderson@example.com', '555-0114'),
('Amelia', 'Thomas', 'amelia.thomas@example.com', '555-0115'),
('James', 'Taylor', 'james.taylor@example.com', '555-0116'),
('Harper', 'Moore', 'harper.moore@example.com', '555-0117'),
('Benjamin', 'Jackson', 'benjamin.jackson@example.com', '555-0118'),
('Evelyn', 'Martin', 'evelyn.martin@example.com', '555-0119'),
('Henry', 'Lee', 'henry.lee@example.com', '555-0120'),
('Abigail', 'Perez', 'abigail.perez@example.com', '555-0121'),
('Sebastian', 'Thompson', 'sebastian.thompson@example.com', '555-0122'),
('Emily', 'White', 'emily.white@example.com', '555-0123'),
('Jack', 'Harris', 'jack.harris@example.com', '555-0124'),
('Elizabeth', 'Sanchez', 'elizabeth.sanchez@example.com', '555-0125'),
('Alexander', 'Clark', 'alexander.clark@example.com', '555-0126'),
('Sofia', 'Ramirez', 'sofia.ramirez@example.com', '555-0127'),
('Daniel', 'Lewis', 'daniel.lewis@example.com', '555-0128'),
('Avery', 'Robinson', 'avery.robinson@example.com', '555-0129'),
('Matthew', 'Walker', 'matthew.walker@example.com', '555-0130'),
('Ella', 'Young', 'ella.young@example.com', '555-0131'),
('Jackson', 'Allen', 'jackson.allen@example.com', '555-0132'),
('Scarlett', 'King', 'scarlett.king@example.com', '555-0133'),
('David', 'Wright', 'david.wright@example.com', '555-0134'),
('Grace', 'Scott', 'grace.scott@example.com', '555-0135'),
('Carter', 'Torres', 'carter.torres@example.com', '555-0136'),
('Chloe', 'Nguyen', 'chloe.nguyen@example.com', '555-0137'),
('Wyatt', 'Hill', 'wyatt.hill@example.com', '555-0138'),
('Penelope', 'Flores', 'penelope.flores@example.com', '555-0139'),
('Julian', 'Green', 'julian.green@example.com', '555-0140'),
('Layla', 'Adams', 'layla.adams@example.com', '555-0141'),
('Leo', 'Nelson', 'leo.nelson@example.com', '555-0142'),
('Victoria', 'Baker', 'victoria.baker@example.com', '555-0143'),
('Gabriel', 'Hall', 'gabriel.hall@example.com', '555-0144'),
('Lillian', 'Rivera', 'lillian.rivera@example.com', '555-0145'),
('Samuel', 'Campbell', 'samuel.campbell@example.com', '555-0146'),
('Hannah', 'Mitchell', 'hannah.mitchell@example.com', '555-0147'),
('Anthony', 'Carter', 'anthony.carter@example.com', '555-0148'),
('Aria', 'Roberts', 'aria.roberts@example.com', '555-0149'),
('Isaac', 'Gomez', 'isaac.gomez@example.com', '555-0150');
GO
