-- ---------------------------------------------------------------------------
-- TapFood - MySQL schema
--
-- Verified against a live `mysqldump --no-data` of the working database, so the
-- column types, lengths, nullability, defaults and constraints below match the
-- schema the application actually runs against.
--
-- Run once before starting the app for the first time:
--
--     mysql -u your_username -p < database/schema.sql
--
-- No credentials and no application data are stored in this file.
--
-- ---------------------------------------------------------------------------
-- IMPORTANT - table name case sensitivity
--
-- MySQL treats table names as case-sensitive on Linux (lower_case_table_names=0,
-- the default there) but case-insensitively on Windows and macOS. The table
-- names below are all lowercase, matching how they exist in the development
-- database. Keep them lowercase when deploying to a Linux MySQL host.
-- ---------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS Tapfood
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE Tapfood;

-- ---------------------------------------------------------------------------
-- user
--
-- `password` holds a BCrypt hash from org.mindrot.jbcrypt.BCrypt, never a
-- plaintext password. BCrypt hashes are 60 characters; the column is sized
-- larger to allow for future cost/algorithm changes.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user (
    userId        int          NOT NULL AUTO_INCREMENT,
    userName      varchar(100) NOT NULL,
    email         varchar(150) NOT NULL,
    password      varchar(255) NOT NULL,
    address       text,
    role          enum('user','restaurant owner','admin') DEFAULT 'user',
    createdDate   timestamp    NULL DEFAULT CURRENT_TIMESTAMP,
    lastLoginDate timestamp    NULL DEFAULT NULL,
    PRIMARY KEY (userId),
    UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- restaurant
--
-- Note the PascalCase column names. MySQL column names are always
-- case-insensitive, so the DAO layer's `restaurantId` / `imagePath` references
-- resolve correctly against `RestaurantID` / `ImagePath`.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant (
    RestaurantID int          NOT NULL AUTO_INCREMENT,
    Name         varchar(255) NOT NULL,
    CuisineType  varchar(100)  DEFAULT NULL,
    DeliveryTime int           DEFAULT NULL,
    Address      text,
    AdminUserID  int           DEFAULT NULL,
    Rating       decimal(3,2)  DEFAULT NULL,
    IsActive     tinyint(1)    DEFAULT '1',
    ImagePath    varchar(255)  DEFAULT NULL,
    PRIMARY KEY (RestaurantID),
    KEY fk_admin (AdminUserID),
    CONSTRAINT fk_admin FOREIGN KEY (AdminUserID) REFERENCES user (userId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- menu
--
-- `imagePath` stores a web-relative path including the directory, for example
-- 'images/a2b.jpg'. The JSP layer renders this value as-is.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS menu (
    menuId       int           NOT NULL AUTO_INCREMENT,
    restaurantId int           DEFAULT NULL,
    itemName     varchar(100)  NOT NULL,
    description  text,
    price        decimal(10,2) NOT NULL,
    isAvailable  tinyint(1)    DEFAULT '1',
    imagePath    varchar(255)  DEFAULT NULL,
    PRIMARY KEY (menuId),
    KEY restaurantId (restaurantId),
    CONSTRAINT menu_ibfk_1 FOREIGN KEY (restaurantId) REFERENCES restaurant (RestaurantID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- user_address
--
-- Saved delivery addresses. This is the only table that cascades on delete.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_address (
    addressId   int          NOT NULL AUTO_INCREMENT,
    userId      int          NOT NULL,
    label       varchar(30)  NOT NULL DEFAULT 'Home',
    addressLine varchar(500) NOT NULL,
    city        varchar(100) DEFAULT NULL,
    phone       varchar(20)  DEFAULT NULL,
    PRIMARY KEY (addressId),
    KEY userId (userId),
    CONSTRAINT user_address_ibfk_1 FOREIGN KEY (userId) REFERENCES user (userId) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- ordertable
--
-- Named `ordertable` because ORDER is a reserved word in SQL.
--
-- `status` is an ENUM, so only the six listed values are accepted. The
-- application writes 'Preparing' when an order is placed (OrderServlet).
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS ordertable (
    orderId         int           NOT NULL AUTO_INCREMENT,
    userId          int           NOT NULL,
    restaurantId    int           NOT NULL,
    orderDate       timestamp     NULL DEFAULT CURRENT_TIMESTAMP,
    totalAmount     decimal(10,2) NOT NULL,
    status          enum('Pending','Confirmed','Preparing','Out for Delivery','Delivered','Cancelled') NOT NULL,
    paymentMode     varchar(40)   NOT NULL,
    deliveryAddress varchar(500)  DEFAULT NULL,
    PRIMARY KEY (orderId),
    KEY userId (userId),
    KEY restaurantId (restaurantId),
    CONSTRAINT ordertable_ibfk_1 FOREIGN KEY (userId) REFERENCES user (userId),
    CONSTRAINT ordertable_ibfk_2 FOREIGN KEY (restaurantId) REFERENCES restaurant (RestaurantID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ---------------------------------------------------------------------------
-- orderitem
--
-- `price` is the unit price captured at order time, so historical orders stay
-- correct even if the menu price changes later. `itemTotal` is price * quantity.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orderitem (
    orderItemId int           NOT NULL AUTO_INCREMENT,
    orderId     int           NOT NULL,
    menuId      int           NOT NULL,
    quantity    int           NOT NULL,
    price       decimal(10,2) NOT NULL,
    itemTotal   decimal(10,2) NOT NULL,
    PRIMARY KEY (orderItemId),
    KEY orderId (orderId),
    KEY menuId (menuId),
    CONSTRAINT orderitem_ibfk_1 FOREIGN KEY (orderId) REFERENCES ordertable (orderId),
    CONSTRAINT orderitem_ibfk_2 FOREIGN KEY (menuId) REFERENCES menu (menuId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
