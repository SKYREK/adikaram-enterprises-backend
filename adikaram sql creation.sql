-- Check if the database exists and drop it if it does
DROP DATABASE IF EXISTS `adikaram_enterprises`;

-- Create a new database
CREATE DATABASE `adikaram_enterprises`;

-- Use the newly created database
USE `adikaram_enterprises`;

-- Create the 'role' table
CREATE TABLE `role` (
    `role_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    CONSTRAINT `PK_ROLE` PRIMARY KEY (`role_name`)
);

-- Create the 'role_permissions' table
CREATE TABLE `role_permissions` (
    `role_name` VARCHAR(100),
    `permission` VARCHAR(100),
    CONSTRAINT `PK_ROLE_PERMISSIONS` PRIMARY KEY (`role_name`, `permission`),
    CONSTRAINT `FK_ROLE_PERMISSIONS_ROLE` FOREIGN KEY (`role_name`) REFERENCES `role`(`role_name`) ON DELETE CASCADE
);

-- Create the 'user' table
-- Create the 'user' table with an additional column for password hash
CREATE TABLE `user` (
    `email` VARCHAR(255) NOT NULL,
    `name` VARCHAR(100),
    `phone` VARCHAR(15),
    `whatsapp` VARCHAR(15),
    `address` TEXT,
    `title` VARCHAR(100),
    `role_name` VARCHAR(100),
    `password_hash` VARCHAR(255) NOT NULL, -- Column for storing the password hash
    CONSTRAINT `UNIQUE_EMAIL` UNIQUE (`email`),
    CONSTRAINT `FK_USER_ROLE` FOREIGN KEY (`role_name`) REFERENCES `role`(`role_name`) ON DELETE SET NULL
);


-- Create the 'route' table
CREATE TABLE `route` (
    `route_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `route_length` INT,
    CONSTRAINT `PK_ROUTE` PRIMARY KEY (`route_name`)
);

-- Create the 'route_areas' table
CREATE TABLE `route_areas` (
    `route_name` VARCHAR(100),
    `area` VARCHAR(100),
    CONSTRAINT `PK_ROUTE_AREAS` PRIMARY KEY (`area`, `route_name`),
    CONSTRAINT `FK_ROUTE_AREAS_ROUTE` FOREIGN KEY (`route_name`) REFERENCES `route`(`route_name`) ON DELETE CASCADE
);

-- Create the 'shop' table
CREATE TABLE `shop` (
    `shop_id` INT AUTO_INCREMENT,
    `shop_name` VARCHAR(255),
    `address` TEXT,
    `owners_full_name` VARCHAR(255),
    `phone` VARCHAR(15),
    `whatsapp` VARCHAR(15),
    `latitude` DOUBLE,
    `longitude` DOUBLE,
    `email` VARCHAR(255),
    `route_name` VARCHAR(100),
    `area` VARCHAR(100),
    `notes` TEXT,
    `status` INT DEFAULT 1,
    CONSTRAINT `PK_SHOP` PRIMARY KEY (`shop_id`),
    CONSTRAINT `FK_SHOP_ROUTE` FOREIGN KEY (`route_name`) REFERENCES `route`(`route_name`),
    CONSTRAINT `FK_SHOP_AREA` FOREIGN KEY (`area`) REFERENCES `route_areas`(`area`)
);

-- Create the 'visit' table
CREATE TABLE `visit` (
    `visit_id` INT AUTO_INCREMENT,
    `date` DATE,
    `started_time` TIME,
    `status` ENUM('ongoing', 'completed') NOT NULL,
    `notes` TEXT,
    CONSTRAINT `PK_VISIT` PRIMARY KEY (`visit_id`)
);

-- Create the 'product' table
CREATE TABLE `product` (
    `key` VARCHAR(100) UNIQUE NOT NULL,
    `name` VARCHAR(255),
    `stock` INT,
    `container_type` VARCHAR(100),
    `uom` INT,
    `volume` VARCHAR(100),
    `flavour` VARCHAR(100),
    `default_labeled_price` DECIMAL(10, 2),
    `default_cost` DECIMAL(10, 2),
    CONSTRAINT `UNIQUE_KEY` UNIQUE (`key`)
);

-- Create the 'purchase_invoice' table
CREATE TABLE `purchase_invoice` (
    `id` INT AUTO_INCREMENT,
    `bill_no` VARCHAR(100),
    `date` DATE,
    `discount` DECIMAL(10, 2),
    `tax` DECIMAL(10, 2),
    `status` VARCHAR(100),
    `payment_due` DATE,
    `checked_by` VARCHAR(255),
    CONSTRAINT `PK_PURCHASE_INVOICE` PRIMARY KEY (`id`),
    CONSTRAINT `FK_PURCHASE_INVOICE_USER` FOREIGN KEY (`checked_by`) REFERENCES `user`(`email`)
);

-- Create the 'batch' table
CREATE TABLE `batch` (
    `batch_id` INT AUTO_INCREMENT,
    `uom` INT,
    `packs` INT,
    `loose` INT,
    `mfd` DATE,
    `exp` DATE,
    `cost` DECIMAL(10, 2),
    `labeled_price` DECIMAL(10, 2),
    `purchase_invoice_id` INT,
    CONSTRAINT `PK_BATCH` PRIMARY KEY (`batch_id`),
    CONSTRAINT `FK_BATCH_PURCHASE_INVOICE` FOREIGN KEY (`purchase_invoice_id`) REFERENCES `purchase_invoice`(`id`)
);

-- Create the 'bill' table
CREATE TABLE `bill` (
    `bill_id` INT AUTO_INCREMENT,
    `notes` TEXT,
    `discount` DECIMAL(10, 2),
    `status` VARCHAR(100),
    `type` VARCHAR(100),
    `shop_id` INT,
    `visit_id` INT,
    `date_and_time` DATETIME,
    `placed_by` VARCHAR(255),
    CONSTRAINT `PK_BILL` PRIMARY KEY (`bill_id`),
    CONSTRAINT `FK_BILL_SHOP` FOREIGN KEY (`shop_id`) REFERENCES `shop`(`shop_id`),
    CONSTRAINT `FK_BILL_VISIT` FOREIGN KEY (`visit_id`) REFERENCES `visit`(`visit_id`),
    CONSTRAINT `FK_BILL_USER` FOREIGN KEY (`placed_by`) REFERENCES `user`(`email`)
);

-- Create the 'bill_item' table
CREATE TABLE `bill_item` (
    `bill_id` INT,
    `item_id` INT,
    `product` VARCHAR(100),
    `uom` INT,
    `packs` INT,
    `loose` INT,
    `price` DECIMAL(10, 2),
    CONSTRAINT `PK_BILL_ITEM` PRIMARY KEY (`bill_id`, `item_id`),
    CONSTRAINT `FK_BILL_ITEM_BILL` FOREIGN KEY (`bill_id`) REFERENCES `bill`(`bill_id`),
    CONSTRAINT `FK_BILL_ITEM_PRODUCT` FOREIGN KEY (`product`) REFERENCES `product`(`key`)
);

-- Create the 'payment' table
CREATE TABLE `payment` (
    `payment_id` INT AUTO_INCREMENT,
    `bill` INT,
    `date_and_time` DATETIME,
    `amount` DECIMAL(10, 2),
    `type` VARCHAR(100),
    `notes` TEXT,
    `status` VARCHAR(100) DEFAULT 'completed',
    CONSTRAINT `PK_PAYMENT` PRIMARY KEY (`payment_id`),
    CONSTRAINT `FK_PAYMENT_BILL` FOREIGN KEY (`bill`) REFERENCES `bill`(`bill_id`)
);

-- Create the 'return_item' table
CREATE TABLE `return_item` (
    `bill` INT,
    `return_item_no` INT,
    `purchase_bill` INT,
    `product` VARCHAR(100),
    `shop` INT,
    `cost` DECIMAL(10, 2),
    `note` TEXT,
    `reason` TEXT,
    CONSTRAINT `PK_RETURN_ITEM` PRIMARY KEY (`bill`, `return_item_no`),
    CONSTRAINT `FK_RETURN_ITEM_BILL` FOREIGN KEY (`bill`) REFERENCES `bill`(`bill_id`),
    CONSTRAINT `FK_RETURN_ITEM_PURCHASE_BILL` FOREIGN KEY (`purchase_bill`) REFERENCES `bill`(`bill_id`),
    CONSTRAINT `FK_RETURN_ITEM_PRODUCT` FOREIGN KEY (`product`) REFERENCES `product`(`key`),
    CONSTRAINT `FK_RETURN_ITEM_SHOP` FOREIGN KEY (`shop`) REFERENCES `shop`(`shop_id`)
);

-- Create the 'visit_collection' table
-- visit id, payment id, verified by(user foreign key, nullable), notes, status (default 'pending')
CREATE TABLE `visit_collection` (
    `visit_id` INT,
    `payment_id` INT,
    `verified_by` VARCHAR(255),
    `notes` TEXT,
    `status` VARCHAR(100) DEFAULT 'pending',
    CONSTRAINT `PK_VISIT_COLLECTION` PRIMARY KEY (`visit_id`, `payment_id`),
    CONSTRAINT `FK_VISIT_COLLECTION_VISIT` FOREIGN KEY (`visit_id`) REFERENCES `visit`(`visit_id`),
    CONSTRAINT `FK_VISIT_COLLECTION_PAYMENT` FOREIGN KEY (`payment_id`) REFERENCES `payment`(`payment_id`),
    CONSTRAINT `FK_VISIT_COLLECTION_USER` FOREIGN KEY (`verified_by`) REFERENCES `user`(`email`)
);

-- Create the 'visit_verification' table
-- visit id, verified_by(user foreign key), notes, date and time
CREATE TABLE `visit_verification` (
    `visit_id` INT,
    `verified_by` VARCHAR(255),
    `notes` TEXT,
    `date_and_time` DATETIME,
    CONSTRAINT `PK_VISIT_VERIFICATION` PRIMARY KEY (`visit_id`, `verified_by`),
    CONSTRAINT `FK_VISIT_VERIFICATION_VISIT` FOREIGN KEY (`visit_id`) REFERENCES `visit`(`visit_id`),
    CONSTRAINT `FK_VISIT_VERIFICATION_USER` FOREIGN KEY (`verified_by`) REFERENCES `user`(`email`)
);

-- Create the 'shop_visit' table
-- shop id, visit id, notes, status [primary key is shop id + visit id]
CREATE TABLE `shop_visit` (
    `shop_id` INT,
    `visit_id` INT,
    `notes` TEXT,
    `status` VARCHAR(100),
    CONSTRAINT `PK_SHOP_VISIT` PRIMARY KEY (`shop_id`, `visit_id`),
    CONSTRAINT `FK_SHOP_VISIT_SHOP` FOREIGN KEY (`shop_id`) REFERENCES `shop`(`shop_id`),
    CONSTRAINT `FK_SHOP_VISIT_VISIT` FOREIGN KEY (`visit_id`) REFERENCES `visit`(`visit_id`)
);


-- Trigger to handle the auto increment of item_id in bill_item table
DELIMITER $$
CREATE TRIGGER `TRG_AUTO_INCREMENT_ITEM_ID` BEFORE INSERT ON `bill_item`
FOR EACH ROW
BEGIN
    SET NEW.item_id = (SELECT IFNULL(MAX(item_id), 0) + 1 FROM bill_item WHERE bill_id = NEW.bill_id);
END$$
DELIMITER ;

CREATE TABLE `shop_order` (
    `route` VARCHAR(100),
    `shop` INT,
    `order_number` INT,
    CONSTRAINT `PK_SHOP_ORDER` PRIMARY KEY (`route`, `shop`),
    CONSTRAINT `FK_SHOP_ORDER_ROUTE` FOREIGN KEY (`route`) REFERENCES `route`(`route_name`),
    CONSTRAINT `FK_SHOP_ORDER_SHOP` FOREIGN KEY (`shop`) REFERENCES `shop`(`shop_id`)
);

-- Insert the 'Admin' role into the 'role' table
INSERT INTO `role` (`role_name`, `description`)
VALUES ('Admin', 'Administrator with full privileges');

-- Assuming 'create_user' as the permission code for creating users
-- Insert the user-creation permission for the 'Admin' role
INSERT INTO `role_permissions` (`role_name`, `permission`)
VALUES ('Admin', 'create_user');

-- Insert an initial admin user into the 'user' table
-- Insert an initial admin user into the 'user' table with password hash
-- Example hash for password 'AdminPass123!' (you must hash this appropriately)
INSERT INTO `user` (
    `email`, 
    `name`, 
    `phone`, 
    `whatsapp`, 
    `address`, 
    `title`, 
    `role_name`, 
    `password_hash`
)
VALUES (
    'admin@example.com', 
    'Admin User', 
    '1234567890', 
    '1234567890', 
    '123 Admin Blvd, Admin City', 
    'System Administrator', 
    'Admin', 
    '$2y$12$W3ulNwQG7ssME77.nA.SQO7E5gUL3yC9i9ZmMA1a6Fg2/9BHV1HqC' -- This is a bcrypt hash for 'AdminPass123!'
);

