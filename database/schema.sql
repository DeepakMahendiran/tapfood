-- ---------------------------------------------------------------------------
-- TapFood - MySQL schema
--
-- Creates the six tables used by the application. Run this once before
-- starting the app for the first time:
--
--     mysql -u your_username -p < database/schema.sql
--
-- No credentials are stored in this file.
-- ---------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS Tapfood
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE Tapfood;

-- ---------------------------------------------------------------------------
-- Application users
--
-- `password` stores a BCrypt hash produced by org.mindrot.jbcrypt.BCrypt,
-- never a plaintext password. BCrypt hashes are always 60 characters.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user (
    userId        INT AUTO_INCREMENT PRIMARY KEY,
    userName      VARCHAR(100)  NOT NULL,
    email         VARCHAR(150)  NOT NULL UNIQUE,
    password      VARCHAR(255)  NOT NULL,
    address       VARCHAR(255),
    role          VARCHAR(20)   NOT NULL DEFAULT 'user',
    createdDate   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    lastLoginDate TIMESTAMP     NULL
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Restaurants
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant (
    restaurantId INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    cuisineType  VARCHAR(100),
    deliveryTime INT,
    address      VARCHAR(255),
    adminUserId  INT,
    rating       FLOAT        DEFAULT 0,
    isActive     BOOLEAN      NOT NULL DEFAULT TRUE,
    imagePath    VARCHAR(255),
    CONSTRAINT fk_restaurant_admin
        FOREIGN KEY (adminUserId) REFERENCES user (userId)
        ON DELETE SET NULL
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Menu items, each belonging to one restaurant
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS menu (
    menuId       INT AUTO_INCREMENT PRIMARY KEY,
    restaurantId INT          NOT NULL,
    itemName     VARCHAR(150) NOT NULL,
    description  VARCHAR(500),
    price        FLOAT        NOT NULL,
    isAvailable  BOOLEAN      NOT NULL DEFAULT TRUE,
    imagePath    VARCHAR(255),
    CONSTRAINT fk_menu_restaurant
        FOREIGN KEY (restaurantId) REFERENCES restaurant (restaurantId)
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Saved delivery addresses for a user
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_address (
    addressId   INT AUTO_INCREMENT PRIMARY KEY,
    userId      INT          NOT NULL,
    label       VARCHAR(50),
    addressLine VARCHAR(255) NOT NULL,
    city        VARCHAR(100),
    phone       VARCHAR(20),
    CONSTRAINT fk_address_user
        FOREIGN KEY (userId) REFERENCES user (userId)
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Placed orders
--
-- Named `orderTable` because ORDER is a reserved word in SQL.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orderTable (
    orderId         INT AUTO_INCREMENT PRIMARY KEY,
    userId          INT         NOT NULL,
    restaurantId    INT         NOT NULL,
    totalAmount     FLOAT       NOT NULL,
    status          VARCHAR(50) NOT NULL DEFAULT 'PLACED',
    paymentMode     VARCHAR(50),
    deliveryAddress VARCHAR(255),
    orderDate       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user
        FOREIGN KEY (userId) REFERENCES user (userId)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (restaurantId) REFERENCES restaurant (restaurantId)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------
-- Line items belonging to an order
--
-- `price` is the unit price captured at order time, so historical orders stay
-- correct even if the menu price changes later.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orderItem (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId     INT   NOT NULL,
    menuId      INT   NOT NULL,
    quantity    INT   NOT NULL,
    price       FLOAT NOT NULL,
    itemTotal   FLOAT NOT NULL,
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (orderId) REFERENCES orderTable (orderId)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_menu
        FOREIGN KEY (menuId) REFERENCES menu (menuId)
) ENGINE = InnoDB;

-- Lookup indexes for the queries the DAO layer runs most often.
CREATE INDEX idx_menu_restaurant  ON menu (restaurantId);
CREATE INDEX idx_order_user       ON orderTable (userId);
CREATE INDEX idx_orderitem_order  ON orderItem (orderId);
CREATE INDEX idx_address_user     ON user_address (userId);
