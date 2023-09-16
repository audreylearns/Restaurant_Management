//DROP VIEW Menu_item_ingredient_list_vw;
//DROP VIEW Price_History_of_Menu_vw ;
//DROP VIEW orders_In_Progress_VW;
//DROP VIEW wages_VW;



//1) Report the ingredient list of each menu item
//Purpose: 
//Show the recipe of a menu item

//Benefit:
//- Track which ingredient is used the most to possibly order in larger batches for a possible discounted fee. This also opens up the possibility of changing suppliers for better deals.
//- Show which menu item has imported ingredients which may result in increased pricing related to import fees and product availability. 
//- This ensures each staff is knowledgeable and able to aquire the ingredient list when needed. 
//		This offers transparency when customers inquire about ingredient list related to  a customer s nutritional needs, diet and possible allergies.
//- To ease in employee training due to ease of access. 
//- To ensure there is adequate storage space for every ingredient used.

CREATE VIEW Menu_item_ingredient_list_vw AS
SELECT t1.item_name "Menu Item", t3.ingredient_name "Ingredient Name", t2.ingredient_qty "Ingredient Quantity"
FROM MS3_menu_item t1
    INNER JOIN MS3_recipe_bridge t2 ON t2.menu_item_id = t1.menu_item_id
    INNER JOIN MS3_ingredient t3 ON t3.ingredient_id = t2.ingredient_id
ORDER BY t1.item_name, t3.ingredient_name ASC
;

//2) Create a report of each menu item with their price changes 
//Purpose: 
//To track the price changes of each menu item 
//Benefit: 
 
// - To ensure that each menu item price changes is in line with inflation rates
// - To provide owners with price history tracking of each menu item for comparative analysis with competitors
// - To aid in ensuring fair pricing and how these changes in price affects customer loyalty and company profit

CREATE VIEW Price_History_of_Menu_vw AS
SELECT t2.item_name "Menu Item",t1.item_price "Price",
TO_CHAR(t1.price_date, 'YYYY Mon') "Date"
FROM MS3_menu_item_pricing_history t1
    INNER JOIN MS3_menu_item t2 ON t2.menu_item_id = t1.menu_item_id
ORDER BY t2.item_name, t1.price_date ASC
;

//3) Orders in progress
//Purpose:
//To show which orders are still ongoing and which server are they assigned to.
//Benefits:
//- Managers will stay informed in real-time about all the orders that are
//currently in progress, so action can be taken about those running late.
//- Managers will know exactly who to ask for any details on an in-progress
//order. Employees will feel more accountable.
//- Employee workload can be determined at a particular time, so if assignment
//needs to be changed it can be done as well.

CREATE VIEW orders_In_Progress_VW AS
SELECT t1.order_id "Order ID", t1.order_time "Order Time", t2.employee_id "Employee ID", t2.first_name || ' ' || t2.last_name "Employee Name"
FROM MS3_orders t1
JOIN MS3_employees t2 ON t1.employee_id = t2.employee_id
WHERE t1.order_status_id < 6
ORDER BY t1.order_time DESC;


//4) Daily Salary
//Purpose:
//Calculates the daily wages present on a specific date. 
//Benefits:
//- Accurate compensation is calculated based on the hours worked to the second.
//(However, our restaurant rounds down so if employee worked 7 hours 50 mins,
//they will be paid for 7 hours only)
//- This can help accounting and the manager immensely when calculating payroll 
//and making accounts.
//- It offers insights into labor costs for 2023-08-02. Management
//can analyze the daily salary expenses, identify high labor costs, and make informed 
//decisions to optimize labor allocation and improve cost-efficiency.

CREATE VIEW wages_VW AS
SELECT t1.employee_id "Employee ID", t1.first_name || ' ' || t1.last_name "Employee Name", t3.position_title "Position Title", t3.hourly_rate "Hourly Wage", EXTRACT(HOUR FROM (t2.out_time - t2.in_time)) "Hours Worked", ROUND(t3.hourly_rate * EXTRACT(HOUR FROM (t2.out_time - t2.in_time)), 2) "Daily Wage"
FROM MS3_employees t1
JOIN MS3_shifts t2 ON t1.employee_id = t2.employee_id
JOIN MS3_positions t3 ON t1.position_id = t3.position_id
WHERE t2.shift_date = DATE '2023-08-02'
ORDER BY t1.last_name;

