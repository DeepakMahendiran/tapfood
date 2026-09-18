-- ---------------------------------------------------------------------------
-- TapFood - catalog seed data
--
-- Contains ONLY the application's public catalog:
--   * restaurant : 25 rows
--   * menu       : 76 rows
--
-- Deliberately EXCLUDED: user, user_address, ordertable, orderitem.
-- This file therefore contains no email addresses, no password hashes, no
-- personal data and no order history.
--
-- restaurant.AdminUserID is set to NULL for every row. In the development
-- database it referenced real user accounts, which are not seeded here; NULL
-- keeps the fk_admin foreign key satisfiable and avoids carrying over any
-- reference to a real person. The column is read into the Restaurant model but
-- is not used by any servlet or JSP, so behaviour is unaffected.
--
-- Primary key values are preserved exactly, because menu.restaurantId must
-- keep pointing at the same restaurants and each row's imagePath must keep
-- matching the files in src/main/webapp/images/.
--
-- Run ONCE against a fresh database, after database/schema.sql.
-- ---------------------------------------------------------------------------

USE Tapfood;

-- --------------------------------------------------------------- restaurant
INSERT INTO restaurant
    (RestaurantID, Name, CuisineType, DeliveryTime, Address, AdminUserID, Rating, IsActive, ImagePath)
VALUES
    (1, 'Southern Spice', 'South Indian', 20, 'City Center', NULL, 4.70, 1, 'images/southernspice.jpg'),
    (2, 'Curry Leaf', 'South Indian', 25, 'Main Street', NULL, 4.50, 1, 'images/curryleaf.jpg'),
    (3, 'Urban Biryani', 'Biryani', 30, 'Food Street', NULL, 4.80, 1, 'images/urbanbiryani.jpg'),
    (4, 'Pizza Planet', 'Italian', 35, 'MG Road', NULL, 4.40, 1, 'images/pizzaplanet.jpg'),
    (5, 'Burger Point', 'Fast Food', 20, 'Commercial Street', NULL, 4.30, 1, 'images/burgerpoint.jpg'),
    (6, 'Dragon Bowl', 'Chinese', 28, 'Lake View Road', NULL, 4.40, 1, 'images/dragonbowl.jpg'),
    (7, 'Green Garden', 'Vegetarian', 18, 'Green Park', NULL, 4.90, 1, 'images/greengarden.jpg'),
    (8, 'Grill Masters', 'BBQ', 32, 'Riverside Road', NULL, 4.60, 1, 'images/grillmasters.jpg'),
    (9, 'Snack Stop', 'Snacks', 15, 'Market Road', NULL, 4.20, 1, 'images/snackstop.jpg'),
    (10, 'Cafe Delight', 'Cafe', 22, 'Tech Park', NULL, 4.50, 1, 'images/cafedelight.jpg'),
    (11, 'Spice Villa', 'North Indian', 25, 'Central Plaza', NULL, 4.80, 1, 'images/spicevilla.jpg'),
    (12, 'Wrap House', 'Wraps', 20, 'Hill View', NULL, 4.40, 1, 'images/wraphouse.jpg'),
    (13, 'Fire Crust', 'Pizza', 28, 'Airport Road', NULL, 4.70, 1, 'images/firecrust.jpg'),
    (14, 'Tandoor Express', 'North Indian', 30, 'College Road', NULL, 4.60, 1, 'images/tandoorexpress.jpg'),
    (15, 'Noodle Nation', 'Chinese', 24, 'Station Road', NULL, 4.50, 1, 'images/noodlenation.jpg'),
    (16, 'Fresh Feast', 'Healthy', 18, 'Garden Street', NULL, 4.90, 1, 'images/freshfeast.jpg'),
    (17, 'Arabian Flame', 'Arabian', 32, 'Ring Road', NULL, 4.70, 1, 'images/arabianflame.jpg'),
    (18, 'Royal Tandoori', 'Mughlai', 30, 'Downtown', NULL, 4.80, 1, 'images/royaltandoori.jpg'),
    (19, 'Chill Scoops', 'Ice Cream', 15, 'Beach Road', NULL, 4.60, 1, 'images/chillscoops.jpg'),
    (20, 'Brew & Beans', 'Cafe', 20, 'Sunrise Avenue', NULL, 4.70, 1, 'images/brewbeans.jpg'),
    (21, 'A2B', 'South Indian', 30, 'Coimbatore', NULL, 4.50, 1, 'images/a2b.jpg'),
    (24, 'Royal Biryani', 'Biryani', 28, 'Charminar Road', NULL, 4.70, 1, 'images/royal_biryani.jpg'),
    (25, 'Burger Hub', 'Burgers', 18, 'Metro Plaza', NULL, 4.40, 1, 'images/burger_hub.jpg'),
    (26, 'Sri Annapoorna', 'South Indian', 22, 'Temple Street', NULL, 4.60, 1, 'images/sri_annapoorna.jpg'),
    (27, 'Pizza Corner', 'Pizza', 30, 'City Mall Road', NULL, 4.50, 1, 'images/pizza_corner.jpg');

-- --------------------------------------------------------------------- menu
INSERT INTO menu
    (menuId, restaurantId, itemName, description, price, isAvailable, imagePath)
VALUES
    (1, 1, 'Idli', 'Soft Idli', 40.00, 1, 'images/idli.jpg'),
    (2, 1, 'Masala Dosa', 'Crispy Dosa', 80.00, 1, 'images/dosa.jpg'),
    (3, 1, 'Pongal', 'Ghee Pongal', 70.00, 1, 'images/pongal.jpg'),
    (4, 2, 'Poori', 'Poori Set', 60.00, 1, 'images/poori.jpg'),
    (5, 2, 'Meals', 'Veg Meals', 120.00, 1, 'images/meals.jpg'),
    (6, 2, 'Vada', 'Medu Vada', 25.00, 1, 'images/vada.jpg'),
    (7, 3, 'Chicken Biryani', 'Spicy', 220.00, 1, 'images/chickenbiryani.jpg'),
    (8, 3, 'Mutton Biryani', 'Special', 320.00, 1, 'images/muttonbiryani.jpg'),
    (9, 3, 'Egg Biryani', 'Delicious', 180.00, 1, 'images/eggbiryani.jpg'),
    (10, 4, 'Margherita', 'Cheese Pizza', 250.00, 1, 'images/pizza.jpg'),
    (11, 4, 'Farmhouse', 'Veg Pizza', 340.00, 1, 'images/farmhouse.jpg'),
    (12, 4, 'Garlic Bread', 'Bread', 120.00, 1, 'images/garlicbread.jpg'),
    (13, 5, 'Veg Burger', 'Burger', 120.00, 1, 'images/vegburger.jpg'),
    (14, 5, 'Chicken Burger', 'Burger', 180.00, 1, 'images/chickenburger.jpg'),
    (15, 5, 'French Fries', 'Fries', 90.00, 1, 'images/fries.jpg'),
    (16, 6, 'Fried Rice', 'Rice', 170.00, 1, 'images/friedrice.jpg'),
    (17, 6, 'Noodles', 'Noodles', 160.00, 1, 'images/noodles.jpg'),
    (18, 6, 'Manchurian', 'Starter', 180.00, 1, 'images/manchurian.jpg'),
    (19, 7, 'Mini Meals', 'Meal', 100.00, 1, 'images/minimeals.jpg'),
    (20, 7, 'Chapathi', '2 Chapathi', 60.00, 1, 'images/chapathi.jpg'),
    (21, 7, 'Curd Rice', 'Rice', 70.00, 1, 'images/curdrice.jpg'),
    (22, 8, 'Grilled Chicken', 'BBQ', 280.00, 1, 'images/grillchicken.jpg'),
    (23, 8, 'Tandoori', 'Chicken', 260.00, 1, 'images/tandoori.jpg'),
    (24, 8, 'Shawarma', 'Roll', 150.00, 1, 'images/shawarma.jpg'),
    (25, 9, 'Mixture', 'Snack', 80.00, 1, 'images/mixture.jpg'),
    (26, 9, 'Samosa', 'Snack', 20.00, 1, 'images/samosa.jpg'),
    (27, 9, 'Puffs', 'Snack', 30.00, 1, 'images/puffs.jpg'),
    (28, 10, 'Cold Coffee', 'Drink', 120.00, 1, 'images/coffee.jpg'),
    (29, 10, 'Brownie', 'Dessert', 90.00, 1, 'images/brownie.jpg'),
    (30, 10, 'Sandwich', 'Snack', 140.00, 1, 'images/sandwich.jpg'),
    (61, 11, 'Butter Chicken', 'Creamy butter chicken', 280.00, 1, 'images/butterchicken.jpg'),
    (62, 11, 'Butter Naan', 'Soft butter naan', 40.00, 1, 'images/butternaan.jpg'),
    (63, 11, 'Paneer Tikka', 'Grilled paneer cubes', 220.00, 1, 'images/paneertikka.jpg'),
    (64, 24, 'Hyderabadi Chicken Biryani', 'Aromatic dum biryani', 240.00, 1, 'images/hyderabadi.jpg'),
    (65, 24, 'Mutton Biryani', 'Rich mutton biryani', 320.00, 1, 'images/muttonbiryani.jpg'),
    (66, 24, 'Chicken 65', 'Spicy fried chicken', 180.00, 1, 'images/chicken65.jpg'),
    (67, 13, 'Pepperoni Pizza', 'Loaded pepperoni pizza', 350.00, 1, 'images/pepperoni.jpg'),
    (68, 13, 'Veg Supreme Pizza', 'Loaded vegetable pizza', 320.00, 1, 'images/vegsupreme.jpg'),
    (69, 13, 'Cheesy Garlic Bread', 'Garlic bread with cheese', 140.00, 1, 'images/cheesygarlic.jpg'),
    (70, 25, 'Classic Burger', 'Juicy chicken burger', 180.00, 1, 'images/classicburger.jpg'),
    (71, 25, 'Cheese Burger', 'Double cheese burger', 220.00, 1, 'images/cheeseburger.jpg'),
    (72, 25, 'French Fries', 'Crispy fries', 110.00, 1, 'images/fries.jpg'),
    (73, 15, 'Hakka Noodles', 'Stir fried noodles', 170.00, 1, 'images/hakkanoodles.jpg'),
    (74, 15, 'Schezwan Fried Rice', 'Spicy fried rice', 190.00, 1, 'images/schezwanrice.jpg'),
    (75, 15, 'Gobi Manchurian', 'Crispy cauliflower', 180.00, 1, 'images/gobimanchurian.jpg'),
    (76, 21, 'Masala Dosa', 'Crispy dosa', 90.00, 1, 'images/dosa.jpg'),
    (77, 21, 'Mini Meals', 'South Indian meals', 140.00, 1, 'images/minimeals.jpg'),
    (78, 21, 'Filter Coffee', 'Authentic filter coffee', 45.00, 1, 'images/filtercoffee.jpg'),
    (79, 17, 'Grilled Chicken', 'Charcoal grilled chicken', 320.00, 1, 'images/grilledchicken.jpg'),
    (80, 17, 'Chicken Shawarma', 'Arabic shawarma', 170.00, 1, 'images/shawarma.jpg'),
    (81, 17, 'BBQ Wings', 'Smoky chicken wings', 240.00, 1, 'images/bbqwings.jpg'),
    (82, 12, 'Chicken Wrap', 'Grilled chicken wrap', 180.00, 1, 'images/chickenwrap.jpg'),
    (83, 12, 'Paneer Wrap', 'Paneer roll', 160.00, 1, 'images/paneerwrap.jpg'),
    (84, 12, 'Falafel Wrap', 'Middle eastern wrap', 170.00, 1, 'images/falafel.jpg'),
    (85, 19, 'Chocolate Sundae', 'Chocolate ice cream', 140.00, 1, 'images/sundae.jpg'),
    (86, 19, 'Belgian Waffle', 'Hot waffle', 180.00, 1, 'images/waffle.jpg'),
    (87, 19, 'Mango Delight', 'Fresh mango scoop', 120.00, 1, 'images/mangoicecream.jpg'),
    (88, 20, 'Cappuccino', 'Hot cappuccino', 120.00, 1, 'images/cappuccino.jpg'),
    (89, 20, 'Cold Coffee', 'Cold coffee with ice cream', 150.00, 1, 'images/coldcoffee.jpg'),
    (90, 20, 'Chocolate Brownie', 'Brownie with ice cream', 170.00, 1, 'images/brownie.jpg'),
    (91, 1, 'Chicken Biriyani', 'Very spicy and tasty', 299.00, 1, 'images/chickenbiryani.jpg'),
    (94, 14, 'Tandoori Chicken', 'Char-grilled, smoky and juicy', 260.00, 1, 'images/tandoori.jpg'),
    (95, 14, 'Paneer Tikka', 'Cottage cheese in spiced marinade', 210.00, 1, 'images/paneertikka.jpg'),
    (96, 14, 'Butter Naan', 'Soft naan brushed with butter', 45.00, 1, 'images/butternaan.jpg'),
    (97, 16, 'Curd Rice Bowl', 'Cooling curd rice with tempering', 90.00, 1, 'images/curdrice.jpg'),
    (98, 16, 'Grilled Chicken Salad', 'Lean grilled chicken over greens', 220.00, 1, 'images/grilledchicken.jpg'),
    (99, 16, 'Paneer Tikka Bowl', 'Protein-rich grilled paneer bowl', 190.00, 1, 'images/paneertikka.jpg'),
    (100, 18, 'Butter Chicken', 'Rich tomato gravy, tender chicken', 280.00, 1, 'images/butterchicken.jpg'),
    (101, 18, 'Tandoori Platter', 'Assorted tandoori specials', 320.00, 1, 'images/tandoori.jpg'),
    (102, 18, 'Butter Naan', 'Soft naan brushed with butter', 45.00, 1, 'images/butternaan.jpg'),
    (103, 26, 'Pongal', 'Ghee pongal with cashews', 70.00, 1, 'images/pongal.jpg'),
    (104, 26, 'Poori', 'Fluffy pooris with potato masala', 60.00, 1, 'images/poori.jpg'),
    (105, 26, 'Idli', 'Steamed soft idlis with chutney', 40.00, 1, 'images/idli.jpg'),
    (106, 27, 'Garlic Bread', 'Herbed garlic butter loaf', 99.00, 1, 'images/garlicbread.jpg'),
    (107, 27, 'Farmhouse Pizza', 'Loaded with garden veggies', 259.00, 1, 'images/farmhouse.jpg'),
    (108, 27, 'Margherita Pizza', 'Classic cheese and tomato', 199.00, 1, 'images/pizza.jpg');
