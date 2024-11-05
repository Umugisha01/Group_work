```sql
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
```
