"""SIGNUP"""

"see if user already exists and insert it into table"
SELECT name FROM user WHERE name="?";
INSERT INTO user (name, age, state, role) 
VALUES ("?","?","?","?");

"see if user is owner or user"
SELECT (name, role) FROM user WHERE name="?";

"""CATEGORY"""

"displays all categories"
SELECT (name, description) FROM category;

"create a category"
INSERT INTO category (user, name, description)
VALUES ("?","?","?");

"update a category (name and description)"
UPDATE category SET name = "?", description = "?" WHERE name = "?";

"delete category by name"
SELECT ID FROM category WHERE name = "?"; "get id from category"
SELECT ID FROM incategory WHERE category = "?"; "check if category has no products"
DELETE FROM category WHERE ID = "?"; "delete the category if no products found"

"""PRODUCTS"""

"create a product"
INSERT INTO product (name, sku, price, category)
VALUES ("?","?","?","?");

"display product by name"
SELECT (name, sku, price, category) FROM product WHERE name = "?"

"display product by category"
SELECT ID FROM category WHERE name = "?"; "get category id first"
SELECT (name, sku, price, category) FROM product WHERE ID =
(SELECT product FROM inCategory WHERE category = "?"); "where category = category id" "gets all prod id's"


"display all products"
SELECT (name, sku, price, category) FROM product

"""CARTS"""

"displays all products in user's cart"
SELECT (name, ID) FROM product WHERE ID = (SELECT ID FROM cart WHERE user = "?");

"add product to cart"
INSERT INTO cart (user, product, quantity)
VALUES ("?","?","?");

"remove product from cart"
DELETE FROM cart WHERE product = "?";

"update quantity of product in cart"
UPDATE cart SET quantity = "?" WHERE product = "?";
