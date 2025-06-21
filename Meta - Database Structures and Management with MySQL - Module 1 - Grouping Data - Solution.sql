/*
Task 1: Use the ANY operator to identify all employees with the Order Status status 'Completed'. 
Task 2: Use the ALL operator to identify the IDs of employees who earned a handling cost of "more than 20% of the order value" from all orders they have handled.
Task 3: Use the GROUP BY clause to summarize the duplicate records with the same column values into a single record by grouping them based on those columns.
Task 4: Use the HAVING clause to filter the grouped data in the subquery that you wrote in task 3 to filter the 20% OrderTotal values to only retrieve values that are more than $100.
*/

-- Task 1
SELECT employees.EmployeeName
FROM employees
JOIN employee_orders
ON employees.EmployeeID = employee_orders.EmployeeID
WHERE employee_orders.`Status` = 'Completed'
GROUP BY employees.EmployeeName
;

-- Task 2
SELECT employee_orders.EmployeeID
FROM employee_orders
JOIN orders
ON employee_orders.OrderID = orders.OrderID
WHERE employee_orders.HandlingCost > orders.OrderTotal * 0.2
GROUP BY employee_orders.EmployeeID
;

-- Task 3 & 4
SELECT EmployeeID, `Status`, SUM(HandlingCost)
FROM employee_orders
GROUP BY EmployeeID, `Status`
;



