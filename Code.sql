CREATE DATABASE StudentCourseManagement;
USE StudentCourseManagement;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    course_description TEXT
);

CREATE TABLE Instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Students (student_id, first_name, last_name, email, date_of_birth)
VALUES 
(10123, 'Ali', 'Ali', 'ali.ali@gmail.com', '2000-01-15'),
(10234, 'Fatima', 'Ahmad', 'fatima.ahmad@gmail.com', '1999-05-22'),
(10345, 'Mariam', 'Barakat', 'mariam.barakat@gmail.com', '2001-03-11'),
(10456, 'Sara', 'Hosseini', 'sara.hosseini@gmail.com', '1998-07-09'),
(10567, 'Youssef', 'Omari', 'youssef.omari@gmail.com', '2002-11-30'),
(10678, 'Saeed', 'Nasser', 'saeed.alnasser@gmail.com', '2000-02-18'),
(10789, 'Jamila', 'Zaid', 'jamila.alzaid@gmail.com', '1999-08-14'),
(10890, 'Ibrahim', 'Fatih', 'ibrahim.alfatih@gmail.com', '2001-12-05'),
(10901, 'Hala', 'Sadiq', 'hala.alsadiq@gmail.com', '2003-04-28'),
(11012, 'Rashid', 'Madani', 'rashid.almadani@gmail.com', '2000-06-17');



INSERT INTO Courses (course_id, course_name, course_description)
VALUES 
(30512, 'Mathematics', 'Study of numbers and shapes.'),
(40987, 'Physics', 'Study of matter and energy.'),
(21874, 'Chemistry', 'Study of substances and their interactions.'),
(52301, 'Biology', 'Study of living organisms.'),
(63429, 'Computer Science', 'Study of computers and computational systems.');


INSERT INTO Instructors (instructor_id, first_name, last_name, email)
VALUES 
(41234, 'Ahmed', 'Hassan', 'ahmed.alhassan@gmail.com'),
(52345, 'Laila', 'Mansoor', 'fatima.almansoor@gmail.com'),
(63456, 'Omar', 'Sayed', 'omar.alsayed@gmail.com');


INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date)
VALUES 
(43821, 10123, 30512, '2024-01-10'),
(59234, 10234, 40987, '2024-01-15'),
(48375, 10345, 21874, '2024-01-20'),
(15792, 10456, 52301, '2024-02-01'),
(67289, 10567, 63429, '2024-02-05'),
(32817, 10678, 30512, '2024-02-10'),
(84920, 10789, 40987, '2024-02-15'),
(71524, 10890, 21874, '2024-03-01'),
(29573, 10901, 52301, '2024-03-05'),
(64831, 11012, 63429, '2024-03-10'),
(43928, 10123, 40987, '2024-04-01'),
(58273, 10234, 21874, '2024-04-05'),
(72839, 10345, 52301, '2024-04-10'),
(16492, 10456, 63429, '2024-05-01'),
(73948, 10567, 30512, '2024-05-05');



SELECT * FROM Students;

SELECT * FROM Courses;

SELECT E.enrollment_id, S.first_name, S.last_name, C.course_name 
FROM Enrollments E
JOIN Students S ON E.student_id = S.student_id
JOIN Courses C ON E.course_id = C.course_id;

SELECT S.* 
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
WHERE E.course_id = 40987;  

SELECT C.course_name
FROM Courses C
JOIN Enrollments E ON C.course_id = E.course_id
GROUP BY C.course_name
HAVING COUNT(E.student_id) > 2;

UPDATE Students
SET email = 'myemail@gmail.com'
WHERE student_id = 10345;  
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Courses
WHERE course_id NOT IN (
    SELECT DISTINCT course_id
    FROM Enrollments
);

SELECT AVG(YEAR(CURDATE()) - YEAR(date_of_birth)) AS avg_age 
FROM Students;

SELECT C.course_name
FROM Courses C
JOIN Enrollments E ON C.course_id = E.course_id
GROUP BY C.course_name
ORDER BY COUNT(E.student_id) DESC
LIMIT 1;

SELECT C.course_name, COUNT(E.student_id) AS num_students
FROM Courses C
LEFT JOIN Enrollments E ON C.course_id = E.course_id
GROUP BY C.course_name;

SELECT S.first_name, S.last_name, C.course_name
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
JOIN Courses C ON E.course_id = C.course_id;



SELECT S.first_name, S.last_name
FROM Students S
LEFT JOIN Enrollments E ON S.student_id = E.student_id
WHERE E.enrollment_id IS NULL;

SELECT S.*
FROM Students S
WHERE S.student_id IN (
    SELECT E.student_id
    FROM Enrollments E
    GROUP BY E.student_id
    HAVING COUNT(E.course_id) > 1
);


SELECT S.first_name, S.last_name, COUNT(E.course_id) AS num_enrollments
FROM Students S
JOIN Enrollments E ON S.student_id = E.student_id
GROUP BY S.student_id
ORDER BY num_enrollments DESC
LIMIT 3;

DELIMITER $$
CREATE PROCEDURE AddStudent(
    IN fname VARCHAR(50), 
    IN lname VARCHAR(50), 
    IN email VARCHAR(100), 
    IN dob DATE
)
BEGIN
    INSERT INTO Students (first_name, last_name, email, date_of_birth) 
    VALUES (fname, lname, email, dob);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION CalculateAge(dob DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(CURDATE()) - YEAR(dob);
END $$
DELIMITER ;

SELECT COUNT(*) AS total_students FROM Students;

SELECT AVG(num_students), MIN(num_students), MAX(num_students)
FROM (
    SELECT COUNT(E.student_id) AS num_students
    FROM Enrollments E
    GROUP BY E.course_id
) AS EnrollmentStats;

SELECT C.course_name AS "Course Name", COUNT(E.student_id) AS "Number of Students"
FROM Courses C
LEFT JOIN Enrollments E ON C.course_id = E.course_id
GROUP BY C.course_name;

SELECT first_name, last_name, 
CASE
    WHEN CalculateAge(date_of_birth) < 20 THEN 'Teenager'
    WHEN CalculateAge(date_of_birth) BETWEEN 20 AND 30 THEN 'Young Adult'
    ELSE 'Adult'
END AS age_category
FROM Students;

SELECT course_name
FROM Courses C
WHERE EXISTS (
    SELECT 1 
    FROM Enrollments E 
    WHERE E.course_id = C.course_id
);