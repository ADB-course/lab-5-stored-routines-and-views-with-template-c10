-- (i) A Procedure called PROC_LAB5
DELIMITER $$

CREATE PROCEDURE `PROC_LAB5`()
BEGIN
    SELECT
        employees.employeeNumber AS 'Employee ID',
        employees.firstName AS 'James',
        employees.lastName AS 'Andrews',
        SUM(orders.amount) AS 'Total'
    FROM
        employees
    JOIN
        customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
    JOIN
        orders ON customers.customerNumber = orders.customerNumber
    GROUP BY
        employees.employeeNumber
    ORDER BY
        `Total ` DESC
    LIMIT 5;
END$$

DELIMITER ;

-- (ii) A Function called FUNC_LAB5

DELIMITER $$

CREATE FUNCTION `FUNC_LAB5`(orderAmount DOUBLE, disRate DOUBLE) RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE discAmount DOUBLE;
    SET discAmount = orderAmount * discRate;
    RETURN discAmount;
END$$

DELIMITER ;
-- (iii) A View called VIEW_LAB5
CREATE VIEW `VIEW_LAB5` AS
SELECT
    customers.customerNumber AS 'Customer ID',
    customers.customerName AS 'Customer Name',
    orders.orderNumber AS 'Order No.',
    orders.orderDate AS 'Order Date',
    orders.amount AS 'Order Amnt',
    FUNC_LAB5(orders.amount, customers.discRate) AS 'Discount Amount'
FROM
    customers
JOIN
    orders ON customers.customerNumber = orders.customerNumber
WHERE
    orders.orderDate = (
        SELECT MAX(orderDate)
        FROM orders AS latestOrders
        WHERE latestOrders.customerNumber = customers.customerNumber
    );