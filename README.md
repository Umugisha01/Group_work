# Group_work
# Employee Attendance Analysis Procedure

This repository contains a PL/SQL procedure, calculate_attendance_stats, that analyzes and displays attendance statistics for employees within a specified month and year. The procedure loops through employee attendance records, calculates the number of 'Present' and 'Absent' days, and displays the results, including the attendance percentage.

## Table of Contents

1. Overview

2. Database Structure

3. Procedure Details

4. Usage

5. Sample Output

6. Error Handling

7. Testing

8. Conclusion
---
## 1.Overview

### The calculate_attendance_stats procedure:

Accepts a month and year as input.

Retrieves and analyzes attendance records for each employee in the specified month.

Displays each employee's full name, total 'Present' and 'Absent' days, and their attendance percentage.

Handles cases where an employee has no attendance records for the specified month.


This procedure provides a helpful utility for database developers to generate monthly attendance reports.


---
## 2.Database Structure

To use this procedure, two tables are required in our database: Employees and Attendance. Below are the table structures:

sql
CREATE TABLE Employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50)
);

CREATE TABLE Attendance (
    attendance_id NUMBER PRIMARY KEY,
    employee_id NUMBER REFERENCES Employees(employee_id),
    attendance_date DATE,
    status VARCHAR2(10) CHECK (status IN ('Present', 'Absent'))
);

Employees Table: Stores employee information, including employee_id, first_name, and last_name.

Attendance Table: Stores attendance records with an employee_id (foreign key) and status indicating if the employee was 'Present' or 'Absent' on that date.
## 3.Procedure Details

### PL/SQL Code

The main code for the procedure is shown below. The code uses a FOR loop to iterate through employees and a single query to count each employee’s attendance in the specified month.

```sql
CREATE OR REPLACE PROCEDURE calculate_attendance_stats (
    p_month IN NUMBER,
    p_year IN NUMBER
) AS
    -- Variables for employee information and attendance counts
    v_total_presents NUMBER := 0;
    v_total_absents NUMBER := 0;
    v_total_days_in_month NUMBER;
    v_attendance_percentage NUMBER;

    -- Cursor to loop through each employee
    CURSOR emp_cursor IS
        SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name
        FROM employees e;

BEGIN
    -- Calculate total days in the specified month
    SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_year || '-' || p_month || '-01', 'YYYY-MM-DD')), 'DD'))
    INTO v_total_days_in_month
    FROM dual;

    -- Loop through each employee
    FOR emp_record IN emp_cursor LOOP
        -- Reset counts for each employee
        v_total_presents := 0;
        v_total_absents := 0;

        -- Count attendance status for the employee in the specified month
        SELECT COUNT(CASE WHEN status = 'Present' THEN 1 END),
               COUNT(CASE WHEN status = 'Absent' THEN 1 END)
        INTO v_total_presents, v_total_absents
        FROM attendance
        WHERE employee_id = emp_record.employee_id
          AND EXTRACT(MONTH FROM attendance_date) = p_month
          AND EXTRACT(YEAR FROM attendance_date) = p_year;

        -- Calculate attendance percentage if there are records
        IF v_total_presents + v_total_absents > 0 THEN
            v_attendance_percentage := (v_total_presents / v_total_days_in_month) * 100;
            
            -- Display results
            DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_record.full_name);
            DBMS_OUTPUT.PUT_LINE('Total Presents: ' || v_total_presents);
            DBMS_OUTPUT.PUT_LINE('Total Absents: ' || v_total_absents);
            DBMS_OUTPUT.PUT_LINE('Attendance Percentage: ' || ROUND(v_attendance_percentage, 2) || '%');
        ELSE
            -- Display message if no records for the month
            DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_record.full_name);
            DBMS_OUTPUT.PUT_LINE('No attendance records found for the specified month.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
END calculate_attendance_stats;
/
```
### Key Components

1. Input Parameters: p_month and p_year filter attendance records by month and year.


2. Employee Cursor: Loops through each employee in the Employees table.


3. Attendance Counts: Counts 'Present' and 'Absent' days using SELECT COUNT based on the status.


4. Output Display: Shows the employee’s name, total presents, absents, and attendance percentage.
---
## 4.Usage

To use this procedure, call it in SQL with the month and year as input parameters:

sql
BEGIN
    calculate_attendance_stats(10, 2024);  -- Example: October 2024
END;


### Requirements

Oracle Database with Employees and Attendance tables created.

Sufficient privileges to create and execute procedures.

---

## 5.Sample Output

The output displays each employee's full name, total presents, absents, and attendance percentage. If no records exist for an employee in the specified month, it indicates this in the output.

### Example:
```sql
Employee: John Doe
Total Presents: 18
Total Absents: 6
Attendance Percentage: 75%
--------------------------
Employee: Jane Smith
No attendance records found for the specified month.
--------------------------
```
---
## 6.Error Handling

The procedure uses logic to check if attendance records exist for an employee in the specified month:

If records exist, it calculates and displays the attendance stats.

If no records exist, it displays a message indicating no records found.

---

## 7.Testing

For accurate testing, try different month and year values:

1. Normal Case: A month with some 'Present' and 'Absent' days.


2. No Records Case: A month with no attendance records.


3. Edge Case: Employees with only 'Present' or only 'Absent' days.

---
## 8.Conclusion

This Employee Attendance Analysis project efficiently calculates monthly attendance statistics, providing clear insights into employee presence and absence patterns. It’s a simple, effective tool for supporting workforce management and data-driven decisions.
