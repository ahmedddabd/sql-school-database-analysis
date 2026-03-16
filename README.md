# SQL School Database Project

This project demonstrates SQL queries for a school management system.

## Skills Demonstrated
- SELECT queries
- JOIN operations
- GROUP BY and HAVING
- Aggregate functions
- LIKE and pattern matching
- Database updates and alterations

## Database Tables
Students
Schools
Courses
Grades
Registrations
Instructors
ClassRooms
LabRooms

## Example Query

SELECT StudentID, AVG(Grade)
FROM Grades
GROUP BY StudentID
HAVING AVG(Grade) > 80;

This query finds students whose average grade is above 80.
