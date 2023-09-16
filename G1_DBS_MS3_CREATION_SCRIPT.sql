//DELETION OF SIMILAR NAMED TABLES FIRST, AS PER ROB'S SQL SAMPLE
//DROP TABLE MS3_order_bridge_items;

//DROP TABLE MS3_menu_item_pricing_history;
//DROP TABLE MS3_recipe_bridge;
//DROP TABLE MS3_menu_item;
//DROP TABLE MS3_shifts;
//DROP TABLE MS3_menu_category;

//DROP TABLE MS3_orders;
//DROP TABLE MS3_employees;

//DROP TABLE MS3_menu_item_status;
//DROP TABLE MS3_ingredient;
//DROP TABLE MS3_order_status;
//DROP TABLE MS3_shift_schedule;
//DROP TABLE MS3_positions;

//CREATION BEGINS:

CREATE TABLE MS3_positions
(
    position_id NUMBER(3) PRIMARY KEY,
    position_title VARCHAR2(25) NOT NULL,
    hourly_rate NUMBER(6,2) NOT NULL
);

CREATE TABLE MS3_shift_schedule
(
    shift_id NUMBER(3) PRIMARY KEY,
    shift_type VARCHAR2(25) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL
);

CREATE TABLE MS3_order_status
(
    order_status_id NUMBER(3) PRIMARY KEY,
    status_name VARCHAR2(25) NOT NULL
);


CREATE TABLE MS3_ingredient (
	ingredient_id NUMBER(5) PRIMARY KEY,
	ingredient_name VARCHAR2(40) NOT NULL,
	ingredient_source VARCHAR2(10) NOT NULL,
	CONSTRAINT ingredient_source_check CHECK (ingredient_source = 'local'OR ingredient_source = 'import')
);

CREATE TABLE MS3_menu_item_status(
	item_status_id NUMBER(1) PRIMARY KEY,
	status_name VARCHAR2(10) NOT NULL
);

CREATE TABLE MS3_menu_category (
	category_id NUMBER(1) PRIMARY KEY,
	category_name VARCHAR2(15) NOT NULL
);

//Tables with foreign keys next:
CREATE TABLE MS3_employees
(
    employee_id NUMBER(4) PRIMARY KEY,
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR2(25) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    phone NUMBER(11) NOT NULL,
    dob DATE NOT NULL,
    position_id NUMBER(3) NOT NULL,
    reports_to NUMBER(4),
    CONSTRAINT fk_position_id FOREIGN KEY (position_id) REFERENCES MS3_positions(position_id)
);

CREATE TABLE MS3_shifts
(
    employee_id NUMBER(4),
    shift_date DATE DEFAULT CURRENT_DATE,
    shift_id NUMBER(3) NOT NULL,
    in_time TIMESTAMP NOT NULL,
    out_time TIMESTAMP NOT NULL,
    PRIMARY KEY (employee_id, shift_date),
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES MS3_employees(employee_id),
    CONSTRAINT fk_shift_id FOREIGN KEY (shift_id) REFERENCES MS3_shift_schedule(shift_id)
);

CREATE TABLE MS3_menu_item(
	category_id NUMBER(1) NOT NULL,
	menu_item_id NUMBER(3) PRIMARY KEY,
	item_name VARCHAR2(40) NOT NULL,
	item_status_id NUMBER(1) NOT NULL,
	CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES MS3_menu_category(category_id),
	CONSTRAINT fk_item_status_id FOREIGN KEY (item_status_id) REFERENCES MS3_menu_item_status(item_status_id)
);

CREATE TABLE MS3_recipe_bridge(
	menu_item_id NUMBER(3) NOT NULL,
	ingredient_id NUMBER(5) NOT NULL,
	ingredient_qty NUMBER(3) NOT NULL,
	PRIMARY KEY (menu_item_id, ingredient_id),
	CONSTRAINT fk_menu_item_id FOREIGN KEY (menu_item_id) REFERENCES MS3_menu_item(menu_item_id),
	CONSTRAINT fk_ingredient_id FOREIGN KEY (ingredient_id) REFERENCES MS3_ingredient(ingredient_id)
);

CREATE TABLE MS3_menu_item_pricing_history(
	menu_item_id NUMBER(3) NOT NULL,
	item_price NUMBER(5,2) DEFAULT 0.00,
	price_date DATE NOT NULL,
	PRIMARY KEY (menu_item_id, price_date),
	CONSTRAINT fk_menu_item_id_priceHx FOREIGN KEY (menu_item_id) REFERENCES MS3_menu_item(menu_item_id)
);

CREATE TABLE MS3_orders 
(
    order_id NUMBER(9) PRIMARY KEY,
    employee_id NUMBER(4) NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    order_time TIMESTAMP NOT NULL,
    order_status_id NUMBER(3) NOT NULL,
    order_tip NUMBER(8,2),
    CONSTRAINT fk_employee_id_orders FOREIGN KEY (employee_id) REFERENCES MS3_employees(employee_id),
    CONSTRAINT fk_order_status_id FOREIGN KEY (order_status_id) REFERENCES MS3_order_status(order_status_id)
);

CREATE TABLE MS3_order_bridge_items(
	order_id NUMBER(9) NOT NULL,
	menu_item_id NUMBER (3) NOT NULL,
	quantity NUMBER(9) NOT NULL,
	PRIMARY KEY (order_id, menu_item_id),
	CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES MS3_orders(order_id),
	CONSTRAINT fk_menu_item_id_orderBridge FOREIGN KEY (menu_item_id) REFERENCES MS3_menu_item(menu_item_id)
);
