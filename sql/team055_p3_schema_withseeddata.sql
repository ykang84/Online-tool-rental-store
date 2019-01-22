DROP DATABASE IF EXISTS `cs6400_fa17_team055`; 

CREATE DATABASE IF NOT EXISTS cs6400_fa17_team055;

USE cs6400_fa17_team055;
SET sql_mode = 'STRICT_ALL_TABLES';

CREATE TABLE Phone (
  PhoneID INT(10) AUTO_INCREMENT PRIMARY KEY,
  phone_type varchar (50) NOT NULL,
  area_code varchar(3) NOT NULL,
  phone_number varchar(7) NOT NULL,
  extension varchar(4) NULL DEFAULT ''
  );

CREATE TABLE Customer (
  username varchar(50) NOT NULL,
  CustomerID INT(10) AUTO_INCREMENT PRIMARY KEY,
  email varchar (50) NOT NULL,
  password varchar (50) NOT NULL,
  first_name varchar (50) NOT NULL,
  middle_name varchar (50) NULL,
  last_name varchar (50) NOT NULL,
  state varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  street varchar(50) NOT NULL,
  zip_code varchar(5) NOT NULL,
  zip_extension varchar(4) NULL,
  cvc_3_digit_number varchar(3) NOT NULL,
  card_number varchar(50) NOT NULL,
  name_on_card varchar(50) NOT NULL,
  month varchar(2) NOT NULL,
  year varchar(4) NOT NULL,
  PhoneID INT(10) NOT NULL,  
  FOREIGN KEY (PhoneID)
	REFERENCES Phone (PhoneID),
  UNIQUE (username)
  );
  
 
 CREATE TABLE Secondary (
  CustomerID INT(10) NOT NULL,
  PhoneID INT(10) NOT NULL,
   FOREIGN KEY (CustomerID)
	REFERENCES Customer (CustomerID),
  FOREIGN KEY (PhoneID)
	REFERENCES Phone (PhoneID),
  UNIQUE (CustomerID, PhoneID)
  );
 
 
 CREATE TABLE Clerk (
  username varchar(50) NOT NULL,
  ClerkID INT(10) AUTO_INCREMENT PRIMARY KEY,
  email varchar (50) NOT NULL,
  password varchar (50) NOT NULL,
  first_name varchar (50) NOT NULL,
  middle_name varchar (50) NULL,
  last_name varchar (50) NOT NULL,
  employer_number varchar(50) NOT NULL,
  hire_date date NOT NULL,
  UNIQUE (username));
 
 CREATE TABLE Tool (
  ToolID INT(10) AUTO_INCREMENT PRIMARY KEY,
  original_price FLOAT NOT NULL, 
  power_source varchar(50) NOT NULL,
  manufacturer varchar(50) NULL,
  sub_option varchar(50) NOT NULL,
  sub_type varchar(50) NOT NULL,
  material varchar(50) NULL,
  width FLOAT NOT NULL,
  length FLOAT NOT NULL,
  weight FLOAT NOT NULL,
  type varchar(50) NOT NULL);
  
 CREATE TABLE Reservation (
  reservationID INT(10) AUTO_INCREMENT PRIMARY KEY,
  start_date date NOT NULL, 
  end_date date NOT NULL,
  CustomerID INT(10) NOT NULL,
  DropClerkID INT(10) NULL,
  PickClerkID INT(10) NULL,  
  FOREIGN KEY (CustomerID)
	REFERENCES Customer (CustomerID),
  FOREIGN KEY (DropClerkID)
	REFERENCES Clerk (ClerkID),
  FOREIGN KEY (PickClerkID)
	REFERENCES Clerk (ClerkID));
    
CREATE TABLE AddRes (
  ToolID INT(10) NOT NULL,
  reservationID INT(10) NOT NULL,
  UNIQUE (ToolID, reservationID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID),
  FOREIGN KEY (reservationID)
	REFERENCES Reservation (reservationID));

CREATE TABLE ServiceOrder (
  ServiceOrderID INT(10) AUTO_INCREMENT PRIMARY KEY,
  ClerkID INT(10) NOT NULL,
  ToolID INT(10) NOT NULL,  
  service_start_date date NOT NULL, 
  service_end_date date NOT NULL, 
  repair_cost FLOAT NOT NULL, 
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID),
  FOREIGN KEY (ClerkID)
	REFERENCES Clerk (ClerkID));

CREATE TABLE ToolForSale (
  SaleID INT(10) AUTO_INCREMENT PRIMARY KEY,
  ClerkID INT(10) NOT NULL,
  CustomerID INT(10) NULL,
  ToolID INT(10) NOT NULL,  
  for_sale_date date NOT NULL, 
  sold_date date NULL, 
  UNIQUE (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID),
  FOREIGN KEY (ClerkID)
	REFERENCES Clerk (ClerkID),
  FOREIGN KEY (CustomerID)
	REFERENCES Customer (CustomerID));

CREATE TABLE PowerTool (
  ToolID INT(10) NOT NULL,
  amp_rating FLOAT NOT NULL, 
  min_rpm_rating FLOAT NOT NULL,
  volt_rating FLOAT NOT NULL,
  max_rpm_rating FLOAT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID));

CREATE TABLE Accessory (
  ToolID INT(10) NOT NULL,
  AccessoryName varchar(50) NOT NULL,
  accessory_quantity INT NOT NULL,
  PRIMARY KEY (ToolID, AccessoryName),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID));
    
 CREATE TABLE Cordless (
  CordlessID INT(10) AUTO_INCREMENT PRIMARY KEY,
  battery_type varchar(50) NOT NULL);
 
CREATE TABLE Sander (
  ToolID INT(10) NOT NULL,
  dust_bag BOOLEAN NOT NULL,
  CordlessID INT(10) NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID),
  FOREIGN KEY (CordlessID)
	REFERENCES Cordless (CordlessID));
    
CREATE TABLE Saw (
  ToolID INT(10) NOT NULL,
  blade_size FLOAT NOT NULL,
  CordlessID INT(10) NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID),
  FOREIGN KEY (CordlessID)
	REFERENCES Cordless (CordlessID));

CREATE TABLE Drill (
  ToolID INT(10) NOT NULL,
  min_torque_rating FLOAT NOT NULL,
  max_torque_rating FLOAT NULL,
  adjustable_clutch BOOLEAN NOT NULL,
  CordlessID INT(10) NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID),
  FOREIGN KEY (CordlessID)
	REFERENCES Cordless (CordlessID));

CREATE TABLE AirCompressor (
  ToolID INT(10) NOT NULL,
  tank_size FLOAT NOT NULL,
  pressure_rating FLOAT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID)
);

CREATE TABLE Mixer (
  ToolID INT(10) NOT NULL,
  motor_rating FLOAT NOT NULL,
  drum_size FLOAT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID)
);

CREATE TABLE Generator (
  ToolID INT(10) NOT NULL,
  power_rating FLOAT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES PowerTool (ToolID)
);

CREATE TABLE Step (
  ToolID INT(10) NOT NULL,
  step_count INT NULL,
  weight_capacity FLOAT NULL,
  pail_shelf BOOLEAN NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Straight (
  ToolID INT(10) NOT NULL,
  rubber_feet BOOLEAN NULL,
  step_count INT NULL,
  weight_capacity FLOAT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);



CREATE TABLE Screwdriver (
  ToolID INT(10) NOT NULL,
  screw_size INT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Socket (
  ToolID INT(10) NOT NULL,
  deep_socket BOOLEAN NULL,
  drive_size FLOAT NOT NULL,
  sae_size FLOAT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Plier (
  ToolID INT(10) NOT NULL,
  adjustable BOOLEAN NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Gun (
  ToolID INT(10) NOT NULL,
  capacity INT NOT NULL,
  gauge_rating INT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Wrench (
  ToolID INT(10) NOT NULL,
  drive_size FLOAT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
  REFERENCES Tool (ToolID)
);

CREATE TABLE Hammer (
  ToolID INT(10) NOT NULL,
  anti_vibration BOOLEAN NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Ratchet (
  ToolID INT(10) NOT NULL,
  drive_size INT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);


CREATE TABLE Pruner (
  ToolID INT(10) NOT NULL,
  handle_material varchar(50) NOT NULL,
  blade_length FLOAT NOT NULL,
  blade_material varchar(50) NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Digger (
  ToolID INT(10) NOT NULL,
  handle_material varchar(50) NOT NULL,
  blade_length FLOAT NOT NULL,
  blade_width FLOAT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Striking (
  ToolID INT(10) NOT NULL,
  handle_material varchar(50) NOT NULL,
  head_weight FLOAT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Rakes (
  ToolID INT(10) NOT NULL,
  handle_material varchar(50) NOT NULL,
  tine_count INT NOT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);

CREATE TABLE Wheelbarrows (
  ToolID INT(10) NOT NULL,
  handle_material varchar(50) NOT NULL,
  wheel_count INT NOT NULL,
  bin_material varchar(50) NOT NULL,
  bin_volume FLOAT NULL,
  PRIMARY KEY (ToolID),
  FOREIGN KEY (ToolID)
	REFERENCES Tool (ToolID)
);


-- Constraints
ALTER TABLE Customer
Add CONSTRAINT Customer 
    CHECK (zip_code LIKE REPLICATE('[0-9]', 5)),
Add CONSTRAINT Customer 
    CHECK (zip_extension LIKE REPLICATE('[0-9]', 4)),
Add CONSTRAINT Customer 
    CHECK (cvc_3_digit_number LIKE REPLICATE('[0-9]', 3)),    
Add CONSTRAINT Customer 
    CHECK (card_number LIKE REPLICATE('[0-9]', 16)),
Add CONSTRAINT Customer 
    CHECK (month LIKE REPLICATE('[0-9]', 2)),
Add CONSTRAINT Customer 
    CHECK (year LIKE REPLICATE('[0-9]', 2));
    
ALTER TABLE Phone
Add CONSTRAINT Phone 
    CHECK (area_code LIKE REPLICATE('[0-9]', 3)),
Add CONSTRAINT Phone 
    CHECK (phone_number LIKE REPLICATE('[0-9]', 7)),
Add CONSTRAINT Phone 
    CHECK (extension LIKE REPLICATE('[0-9]', 4));

ALTER TABLE Reservation
Add CONSTRAINT Reservation
	CHECK (start_date < end_date);
ALTER TABLE ServiceOrder
Add CONSTRAINT Reservation
	CHECK (service_start_date < service_end_date);
    
-- Insert Test (seed) Data 
-- Insert into Phone, 11 rows
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (849, 5356455, 12, 'Cell');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (650, 4076287, '', 'Work');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (225, 1734010, '', 'Home');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (638, 5395459, '', 'Cell');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (096, 7732877, '', 'Cell');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (403, 4649620, '', 'Home');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (442, 7513157, '', 'Cell');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (326, 3774826, '', 'Work');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (968, 4702249, '', 'Work');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (975, 2984135, '', 'Cell');
INSERT INTO Phone(area_code, phone_number, extension, phone_type) VALUES (563, 4395459, '', 'Cell');
-- Insert into Customer ;11 rows
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('TomSmith', 'Tom.Smith@gatech.edu', 'Tom123', 'Tom', '', 'Smith', '4785612609212764', 'Tom Smith', 06, 16,356, 09890, '', 'NJ', 'Kristinaland', '968 Bahringer Garden Apt. 722', 1);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('KristinaHamilton', 'Kristina.Hamilton@gatech.edu', 'Kristina123', 'Kristina', '', 'Hamilton','9853564557518120', 'Kristina Hamilton', 02, 15, 004, 69812, 9046,'OR', 'Leahland', '8658 James Route', 2);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('KyleLee', 'Kyle.Lee@gatech.edu', 'Kyle123', 'Kyle', '','Lee', '7832842720977630', 'Kyle Lee', 06, 09, 420, 64503, 5583,'AZ', 'FPO', 'USNS', 3);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('RickColeman', 'Rick.Coleman@gatech.edu', 'Rick123', 'Rick', '', 'Coleman','9561503223085630', 'Rick Coleman', 10, 13, 702, 31211,'', 'DE', 'Adambury', '4010 Jeremy Islands Apt. 976', 4);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('RichardScott', 'Richard.Scott@gatech.edu', 'Richard123', 'Richard', '', 'Scott', '7850013148036410', 'Richard Scott', 05, 15, 483,  28151, '', 'NH', 'Port Pamela', '41267 Amy Skyway Suite 129', 5);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('GreggMcdaniel', 'Gregg.Mcdaniel@gatech.edu', 'Gregg123', 'Gregg', '', 'Mcdaniel', '5988497190684675', 'Gregg Mcdaniel', 02, 11, 638, 09956, '', 'MN', 'West Kylestad', 'Unit 6588', 6);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('JenniferChavez', 'Jennifer.Chavez@gatech.edu', 'Jennifer123', 'Jennifer', '', 'Chavez', '4697788057135372', 'Jennifer Chavez', 05, 08, 703, 42732, 8671, 'GA', 'South Michael', '4030 Michael Land Apt. 066', 7);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('MatthewHamilton', 'Matthew.Hamilton@gatech.edu', 'Matthew123', 'Matthew', '', 'Hamilton', '2975003606186236', 'Matthew Hamilton', 07, 14, 815,  44801, '', 'ID', 'Martinezfurt', '90987 Brian Underpass', 8);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('StevenDudley', 'Steven.Dudley@gatech.edu', ' Steven123', 'Steven', '','Dudley', '3906505326389496', 'Steven Dudley', 03, 16, 905,  21073, '', 'KS', 'New Michelleport', '524 Patton Common Apt. 997', 9);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('BrandonKidd', 'Brandon.Kidd@gatech.edu', 'Brandon123', 'Brandon', '', 'Kidd', '6390116759513998', 'Brandon Kidd', 05, 11, 989,  68086, '', 'MS', 'Lake Mark', '70224 Darryl Run Suite 548', 10);
INSERT INTO Customer(username, email, password, first_name, middle_name, last_name, card_number, name_on_card, month, year, cvc_3_digit_number, zip_code, zip_extension, state, city, street, PhoneID) 
VALUES ('AmandaHarris', 'Amanda.Harris@gatech.edu', 'Amanda123', 'Amanda', '', 'Harris', '1912255624420968', 'Amanda Harris', 04, 05, 727,  97287, '', 'IN', 'Coryton', '595 Joshua Port', 11);

-- Insert into Clerk, 5 rows
INSERT INTO Clerk(username, email, password, first_name, middle_name, last_name,employer_number, hire_date) 
VALUES ('JamesDoe', 'James.Doe@gatech.edu', 'James123', 'James', '', 'Doe', 254874,'2007-05-01');
INSERT INTO Clerk(username, email, password, first_name, middle_name, last_name,employer_number, hire_date) 
VALUES ('LindseyFunke', 'Lindsey.Funke@gatech.edu', 'Lindsey123', 'Lindsey', '', 'Funke', 892145,'2008-04-15');
INSERT INTO Clerk(username, email, password, first_name, middle_name, last_name,employer_number, hire_date) 
VALUES ('JimHalpert', 'Jim.Halpert@gatech.edu', 'Jim123', 'Jim', '', 'Halpert', 107628,'2010-09-22');
INSERT INTO Clerk(username, email, password, first_name, middle_name, last_name,employer_number, hire_date) 
VALUES ('DwightSchrute', 'Dwight.Schrute@gatech.edu', 'Dwight123', 'Dwight', '', 'Schrute', 627834,'2008-01-13');
INSERT INTO Clerk(username, email, password, first_name, middle_name, last_name,employer_number, hire_date) 
VALUES ('MichaelBluth', 'Michael.Bluth@gatech.edu', 'Michael123', 'Michael', '', 'Bluth', 367102,'2011-02-24');





-- Insert into Tool;one for each sub-type
INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (110, 'Manual', 'folding', 'Step', 12, 15, 50, 'Ladder');
INSERT INTO Step (ToolID, step_count, weight_capacity, pail_shelf) 
VALUES (1, 12, 200, true);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (100, 'Manual', 'rigid', 'Straight', 8, 11, 30, 'Ladder');
INSERT INTO Straight (ToolID, step_count, weight_capacity, rubber_feet) 
VALUES (2, 21, 300, false);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (80, 'Manual', 'leaf', 'Rakes', 22, 25, 20, 'Garden Tool');
INSERT INTO Rakes (ToolID, handle_material, tine_count) 
VALUES (3, 'poly', 14);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (70, 'Manual', 'sheer', 'Pruner', 13, 14, 34, 'Garden Tool');
INSERT INTO Pruner (ToolID, handle_material, blade_length, blade_material) 
VALUES (4, 'poly', 6, '');

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (75, 'Manual', 'edger', 'Digger', 12, 23, 45, 'Garden Tool');
INSERT INTO Digger (ToolID, handle_material, blade_length, blade_width) 
VALUES (5, 'wooden', 5, 7);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (65, 'Manual', '1-wheel', 'Wheelbarrows', 32, 52, 13, 'Garden Tool');
INSERT INTO Wheelbarrows (ToolID, handle_material, bin_material, bin_volume, wheel_count) 
VALUES (6, 'wooden', 'steel', 5.2, 1);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (85, 'Manual', 'pick axe', 'Striking', 45, 12, 45, 'Garden Tool');
INSERT INTO Striking (ToolID, handle_material, head_weight) 
VALUES (7, 'steel', 2.2);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (85, 'Manual', 'hex', 'Screwdriver', 10, 24, 26, 'Hand Tool');
INSERT INTO Screwdriver (ToolID, screw_size) 
VALUES (8, 2);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (25, 'Manual', 'deep', 'Socket', 10, 18, 22, 'Hand Tool');
INSERT INTO Socket (ToolID, drive_size, sae_size, deep_socket) 
VALUES (9,  1/2, 1/4, TRUE);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (85, 'Manual', 'fixed', 'Ratchet', 12, 16, 11, 'Hand Tool');
INSERT INTO Ratchet (ToolID,  drive_size) 
VALUES (10, 1/2);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (25, 'Manual', 'pipe', 'Wrench', 13, 21, 22, 'Hand Tool');
INSERT INTO Wrench (ToolID,  drive_size) 
VALUES (11, 10);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (60, 'Manual', 'cutting', 'Plier', 16, 31, 15, 'Hand Tool');
INSERT INTO Plier (ToolID, adjustable) 
VALUES (12, true);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (85, 'Manual', 'nail', 'Gun', 10, 24, 18, 'Hand Tool');
INSERT INTO Gun (ToolID, capacity, gauge_rating) 
VALUES (13, 20, 20);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (75, 'Manual', 'claw', 'Hammer', 17, 34, 44, 'Hand Tool');
INSERT INTO Hammer (ToolID, anti_vibration) 
VALUES (14, true);

-- power tool--tbd
INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (150, 'A/C', 'finish', 'Sander', 82, 85, 88, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (15, 25, 46, 12, 16);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (15, 'battery', 12);
INSERT INTO Cordless (battery_type) VALUES ('NiCd');
INSERT INTO Sander(ToolID, dust_bag, CordlessID) VALUES (15, TRUE, 1);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (98, 'D/C', 'jig', 'Saw', 56, 55, 58, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (16, 24, 16, 57, 86);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (16, 'battery', 5);
INSERT INTO Cordless (battery_type) VALUES ('NiCd');
INSERT INTO Saw(ToolID, blade_size, CordlessID) VALUES (16, 52, 2);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (25, 'D/C', 'hammer', 'Drill', 16, 25, 34, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (17, 34, 1, 18, 64);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (17, 'Drill Bits', 10);
INSERT INTO Cordless (battery_type) VALUES ('Li-Ion');
INSERT INTO Drill (ToolID, min_torque_rating, max_torque_rating, adjustable_clutch, CordlessID) VALUES (17, 11, 25, FALSE, 3);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (25, 'Gas', 'reciprocating', 'AirCompressor', 8, 17, 24, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (18, 35, 6, 13, 21);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (18, 'Soft Case', 2);
INSERT INTO AirCompressor (ToolID, tank_size, pressure_rating) VALUES (18, 8, 5);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (41, 'Gas', 'concrete', 'Mixer', 5, 27, 13, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (19, 21, 12, 5, 14);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (19, 'Soft Case', 3);
INSERT INTO Mixer (ToolID, motor_rating, drum_size) VALUES (19, 23, 8);

INSERT INTO Tool (original_price, power_source, sub_option, sub_type, width, length, weight, type)
VALUES (55, 'Gas', 'electric', 'Generator', 22, 14, 32, 'Power Tool');
INSERT INTO PowerTool (ToolID, volt_rating, amp_rating, min_rpm_rating, max_rpm_rating) 
VALUES (20, 21, 12, 5, 14);
INSERT INTO Accessory (ToolID, AccessoryName, accessory_quantity) VALUES (20, 'Hard Case', 8);
INSERT INTO Generator (ToolID, power_rating) VALUES (20, 17);
-- past reservation
INSERT INTO Reservation (start_date, end_date, CustomerID, DropClerkID, PickClerkID)
VALUES ('2017-11-27', '2017-11-28', 9, 1, 2);
INSERT INTO AddRes (ToolID, reservationID) VALUES (7, 1);

INSERT INTO Reservation (start_date, end_date, CustomerID, DropClerkID, PickClerkID)
VALUES ('2017-10-27', '2017-10-28', 2, 4, 4);
INSERT INTO AddRes (ToolID, reservationID) VALUES (10, 2);