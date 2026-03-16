CREATE DATABASE SchoolManagementSystem;
GO

USE SchoolManagementSystem;
GO

CREATE TABLE Schools (
    SchoolID INT PRIMARY KEY IDENTITY(1,1),
    SchoolName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    EstablishedYear INT,
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + LastName) PERSISTED, -- Computed column for full name
    DateOfBirth DATE,
    EnrollmentDate DATE DEFAULT GETDATE(),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    Description VARCHAR(255),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID) -- Courses can be school-specific
);

-- Create Instructors table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + LastName) PERSISTED, -- Computed column for full name
    HireDate DATE,
    Department VARCHAR(50),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE ClassRooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    Building VARCHAR(50),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE LabRooms (
    LabID INT PRIMARY KEY IDENTITY(1,1),
    LabNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    Equipment VARCHAR(255),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Semester VARCHAR(20) NOT NULL, -- e.g., 'Fall', 'Spring'
    Year INT NOT NULL,
    RegistrationDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Enrolled' -- e.g., 'Enrolled', 'Dropped'
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Grade DECIMAL(5,2) NOT NULL, -- e.g., 85.50
    LetterGrade AS (CASE 
                        WHEN Grade >= 90 THEN 'A' 
                        WHEN Grade >= 80 THEN 'B' 
                        WHEN Grade >= 70 THEN 'C' 
                        WHEN Grade >= 60 THEN 'D' 
                        ELSE 'F' 
                    END) PERSISTED, -- Computed column for letter grade
    GradeDate DATE DEFAULT GETDATE()
);
GO

USE SchoolManagementSystem;
GO

TRUNCATE TABLE Schools;
INSERT INTO Schools (SchoolName, Location, EstablishedYear)
VALUES
('Riverside High'         ,'Amsterdam'         ,1998),
('Zuidas Academy'         ,'Amsterdam'         ,2012),
('North Holland International','Haarlem'       ,2004),
('Delft Technical College' ,'Delft'            ,1987),
('Utrecht Science School' ,'Utrecht'           ,1995),
('Rotterdam Maritime HS'  ,'Rotterdam'         ,2001),
('Eindhoven Tech Academy' ,'Eindhoven'         ,2010),
('Groningen North College','Groningen'         ,1992),
('Leiden Classical School','Leiden'            ,2006),
('The Hague Euro School'  ,'Den Haag'          ,2008),
('Tilburg Business HS'    ,'Tilburg'           ,2003),
('Almere Modern College'  ,'Almere'            ,2015),
('Breda Arts & Design'    ,'Breda'             ,1999),
('Nijmegen Green School'  ,'Nijmegen'          ,2007),
('Zwolle Regional HS'     ,'Zwolle'            ,2000),
('Enschede Innovation HS' ,'Enschede'          ,2011),
('Apeldoorn Forest School','Apeldoorn'         ,2005),
('Arnhem River College'   ,'Arnhem'            ,1996),
('Maastricht South HS'    ,'Maastricht'        ,2009),
('Amersfoort Unity School','Amersfoort'        ,2014);
GO

TRUNCATE TABLE Students;
INSERT INTO Students (FirstName, LastName, DateOfBirth, SchoolID)
SELECT TOP 150
    fn.FirstName,
    ln.LastName,
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 3650 + 4383), '2025-09-01'),
    1 + (ABS(CHECKSUM(NEWID())) % 20)
FROM (
    VALUES
    ('Lars'),('Emma'),('Noah'),('Sophie'),('Sem'),('Julia'),('Liam'),('Mila'),('Luca'),('Tess'),
    ('Finn'),('Sara'),('Thijs'),('Lot'),('Mees'),('Fleur'),('Noud'),('Yara'),('Cas'),('Lina'),
    ('Daan'),('Zoë'),('Luuk'),('Floor'),('Jelle'),('Isabel'),('Thomas'),('Lotte'),('Sam'),('Nova'),
    ('Tim'),('Elin'),('Jesse'),('Myrthe'),('Max'),('Roos'),('Sven'),('Amber'),('Bas'),('Lieve'),
    ('Gijs'),('Mara'),('Hidde'),('Fien'),('Milan'),('Esmee'),('Joris'),('Liv'),('Stijn'),('Noor'),
    ('Ruben'),('Lina'),('Teun'),('Elise'),('Nick'),('Hanna'),('Floris'),('Pien'),('Jasmijn'),('Merel'),
    ('Bram'),('Isis'),('Kees'),('Vera'),('Wout'),('Lune'),('Tuur'),('Fenne'),('Boaz'),('Saar'),
    ('Guus'),('Mevrouw'),('Jip'),('Sterre'),('Pim'),('Nova'),('Olaf'),('Maeve'),('Kian'),('Liza'),
    ('Johan'),('Fabiënne'),('Sander'),('Evi'),('Mats'),('Freek'),('Rens'),('Lara'),('Duco'),('Nienke'),
    ('Bart'),('Linde'),('Jurre'),('Minke'),('Koen'),('Zara'),('Ties'),('Fay'),('Jochem'),('Elodie'),
    ('Dirk'),('Sterre'),('Maarten'),('Lien'),('Jort'),('Fien'),('Seb'),('Mila'),('Luuk'),('Yenthe')
) fn(FirstName)
CROSS JOIN (
    VALUES
    ('de Jong'),('Jansen'),('de Vries'),('van Dijk'),('Bakker'),('Visser'),('Smit'),('Meijer'),
    ('de Boer'),('Mulder'),('de Groot'),('Bos'),('Vermeulen'),('van den Berg'),('van Dijk'),
    ('Hendriks'),('Dekker'),('Hoogendoorn'),('Janssen'),('Verhoeven'),('van der Linden'),
    ('van Beek'),('van der Meer'),('van Leeuwen'),('Claassen'),('Willems'),('van der Wal'),
    ('Groen'),('van der Velde'),('Schouten'),('van der Heijden'),('Kramer'),('van Dongen'),
    ('Veenstra'),('Post'),('van der Horst'),('de Haan'),('Kuipers'),('Blok'),('van Dam'),
    ('Hermans'),('van den Akker'),('Sanders'),('Peeters'),('van der Horst'),('Molenaar')
) ln(LastName)
ORDER BY NEWID()
OPTION (MAXDOP 1);   
GO

TRUNCATE TABLE Courses;
INSERT INTO Courses (CourseName, Credits, Description, SchoolID)
VALUES
('Mathematics A'        ,4 ,'Advanced algebra & calculus'     ,NULL),
('Mathematics B'        ,5 ,'Calculus & analytic geometry'     ,NULL),
('Physics 1'            ,4 ,'Mechanics & waves'                ,NULL),
('Physics 2'            ,5 ,'Electricity & magnetism'          ,NULL),
('Chemistry A'          ,4 ,'General & inorganic chemistry'    ,NULL),
('Chemistry B'          ,5 ,'Organic & biochemistry'           ,NULL),
('Biology A'            ,4 ,'Cell biology & genetics'          ,NULL),
('Biology B'            ,5 ,'Ecology & evolution'              ,NULL),
('Dutch Language'       ,4 ,'Literature & writing'             ,NULL),
('English B'            ,4 ,'Advanced English'                 ,NULL),
('German B'             ,4 ,'Intermediate German'              ,NULL),
('French B'             ,4 ,'Intermediate French'              ,NULL),
('History A'            ,3 ,'Modern European history'          ,NULL),
('History B'            ,4 ,'World history 1900–present'       ,NULL),
('Geography'            ,4 ,'Human & physical geography'       ,NULL),
('Economics'            ,4 ,'Micro & macro economics'          ,NULL),
('Business Economics'   ,4 ,'Entrepreneurship & accounting'    ,NULL),
('Informatics'          ,5 ,'Programming & algorithms'         ,NULL),
('Art & Design'         ,3 ,'Visual arts & design'             ,NULL),
('Music'                ,3 ,'Music theory & practice'          ,NULL),
('Physical Education'   ,2 ,'Sports & fitness'                 ,NULL),
('Philosophy'           ,3 ,'Introduction to philosophy'       ,NULL),
('Social Studies'       ,3 ,'Sociology & politics'             ,NULL),
('Statistics'           ,4 ,'Probability & data analysis'      ,NULL),
('Astronomy'            ,3 ,'Introduction to astronomy'        ,NULL),
('Psychology'           ,3 ,'Basic psychology'                 ,NULL),
('Law & Society'        ,3 ,'Introduction to law'              ,NULL),
('Entrepreneurship'     ,4 ,'Starting a business'              ,NULL),
('Digital Skills'       ,3 ,'Office & web tools'                ,NULL),
('Media & Communication',4 ,'Journalism & media literacy'      ,NULL),
('Sustainable Development',4,'Environment & society'           ,NULL),
('Robotics'             ,5 ,'Robotics & automation'            ,NULL),
('Data Science Intro'   ,4 ,'Python for data analysis'         ,NULL),
('Machine Learning Basics',5,'Supervised & unsupervised'       ,NULL),
('Cyber Security'       ,4 ,'Network & information security'   ,NULL),
('Biotechnology'        ,4 ,'Genetic engineering basics'       ,NULL),
('Environmental Chemistry',4,'Pollution & green chemistry'     ,NULL),
('Advanced Calculus'    ,5 ,'Multivariable calculus'           ,NULL),
('Linear Algebra'       ,5 ,'Matrices & vector spaces'         ,NULL),
('Mechanics & Materials',5 ,'Engineering mechanics'            ,NULL),
('Thermodynamics'       ,5 ,'Heat & energy transfer'           ,NULL),
('Electronics'          ,5 ,'Analog & digital circuits'        ,NULL),
('Dutch Literature'     ,4 ,'17th–21st century literature'     ,NULL),
('English Literature'   ,4 ,'British & American classics'      ,NULL),
('Drama & Theater'      ,3 ,'Acting & stage production'        ,NULL),
('Dance'                ,3 ,'Contemporary & classical dance'   ,NULL),
('Visual Communication' ,4 ,'Graphic design & typography'      ,NULL),
('Photography'          ,3 ,'Digital & analog photography'     ,NULL),
('Fashion Design'       ,4 ,'Fashion sketching & textiles'     ,NULL),
('Architecture Intro'   ,4 ,'Basics of architectural design'   ,NULL);
GO

TRUNCATE TABLE Instructors;
INSERT INTO Instructors (FirstName, LastName, HireDate, Department, SchoolID)
VALUES
('Anna'     ,'de Vries'    ,'2015-08-01','Mathematics'      ,NULL),
('Mark'     ,'Jansen'      ,'2012-09-01','Physics'          ,NULL),
('Sophie'   ,'Bakker'      ,'2018-01-15','Chemistry'        ,NULL),
('Thomas'   ,'Mulder'      ,'2010-03-20','Biology'          ,NULL),
('Laura'    ,'Visser'      ,'2016-11-05','Dutch Language'   ,NULL),
('Erik'     ,'Smit'        ,'2014-06-10','English'          ,NULL),
('Lisa'     ,'de Boer'     ,'2019-02-28','History'          ,NULL),
('Pieter'   ,'van Dijk'    ,'2013-09-12','Geography'        ,NULL),
('Marieke'  ,'Hoogendoorn' ,'2017-04-01','Economics'        ,NULL),
('Jeroen'   ,'Verhoeven'   ,'2011-10-15','Informatics'      ,NULL),
('Femke'    ,'van Beek'    ,'2020-01-10','Art & Design'     ,NULL),
('Bas'      ,'van Leeuwen' ,'2015-07-22','Music'            ,NULL),
('Niels'    ,'Claassen'    ,'2018-03-05','Physical Education',NULL),
('Eline'    ,'Willems'     ,'2016-12-01','Philosophy'       ,NULL),
('Koen'     ,'Groen'       ,'2019-08-19','Social Studies'   ,NULL),
('Sara'     ,'van der Wal' ,'2014-05-30','Statistics'       ,NULL),
('Tim'      ,'Kuipers'     ,'2021-02-14','Astronomy'        ,NULL),
('Noor'     ,'Blok'        ,'2017-11-08','Psychology'       ,NULL),
('Jesse'    ,'Hermans'     ,'2020-06-25','Law & Society'    ,NULL),
('Mila'     ,'van Dam'     ,'2013-04-03','Entrepreneurship' ,NULL),
('Sem'      ,'Sanders'     ,'2018-09-17','Digital Skills'   ,NULL),
('Fleur'    ,'Peeters'     ,'2015-10-12','Media'            ,NULL),
('Luca'     ,'van der Horst','2019-01-20','Sustainable Dev' ,NULL),
('Yara'     ,'Molenaar'    ,'2022-03-08','Robotics'         ,NULL),
('Finn'     ,'Dekker'      ,'2016-07-14','Data Science'     ,NULL),
('Tess'     ,'van der Linden','2021-11-30','Cyber Security' ,NULL),
('Noah'     ,'van der Meer' ,'2014-02-09','Biotechnology'   ,NULL),
('Julia'    ,'van der Heijden','2017-05-16','Advanced Math' ,NULL),
('Liam'     ,'Kramer'      ,'2020-08-21','Electronics'      ,NULL),
('Mila'     ,'van Dongen'  ,'2018-12-04','Dutch Literature' ,NULL),
('Sem'      ,'Veenstra'    ,'2015-03-27','English Lit'      ,NULL),
('Emma'     ,'Post'        ,'2019-09-10','Drama'            ,NULL),
('Lars'     ,'van der Horst','2022-01-15','Dance'           ,NULL),
('Sophie'   ,'Kuipers'     ,'2016-06-08','Photography'      ,NULL),
('Noah'     ,'Blok'        ,'2021-04-19','Fashion Design'   ,NULL);
GO

TRUNCATE TABLE ClassRooms;
INSERT INTO ClassRooms (RoomNumber, Capacity, Building, SchoolID)
VALUES
('A101',32,'A',NULL),('A102',28,'A',NULL),('A201',40,'A',NULL),('A202',36,'A',NULL),
('B101',30,'B',NULL),('B102',25,'B',NULL),('B201',45,'B',NULL),('B202',38,'B',NULL),
('C101',34,'C',NULL),('C102',30,'C',NULL),('C201',42,'C',NULL),('C202',35,'C',NULL),
('D101',28,'D',NULL),('D102',24,'D',NULL),('D201',39,'D',NULL),('D202',33,'D',NULL),
('E101',31,'E',NULL),('E102',27,'E',NULL),('E201',44,'E',NULL),('E202',37,'E',NULL);
GO

TRUNCATE TABLE LabRooms;
INSERT INTO LabRooms (LabNumber, Capacity, Equipment, SchoolID)
VALUES
('L01',20,'Computers & projectors'         ,NULL),
('L02',18,'Chemistry benches + fume hoods' ,NULL),
('L03',16,'Microscopes + biology kits'     ,NULL),
('L04',22,'Physics experiment stations'    ,NULL),
('L05',15,'Robotics & Arduino kits'        ,NULL),
('L06',24,'3D printers + CAD computers'    ,NULL),
('L07',19,'Electronics workstations'       ,NULL),
('L08',17,'Darkroom + photo equipment'     ,NULL),
('L09',21,'Music instruments + studio'     ,NULL),
('L10',14,'Art & design tables'            ,NULL),
('L11',23,'Computers + data analysis SW'   ,NULL),
('L12',20,'Chemistry + safety gear'        ,NULL),
('L13',18,'Biology wet lab'                ,NULL),
('L14',16,'Physics optics & electricity'   ,NULL),
('L15',22,'Fabrication lab (wood/metal)'   ,NULL),
('L16',19,'Sewing machines + textiles'     ,NULL),
('L17',17,'Dance & movement studio'        ,NULL),
('L18',24,'Theater rehearsal space'        ,NULL),
('L19',15,'Greenhouse & plant lab'         ,NULL),
('L20',21,'Environmental monitoring equip' ,NULL),
('L21',18,'Cyber security workstations'    ,NULL),
('L22',20,'High-performance computing'     ,NULL),
('L23',16,'Astronomy simulation + telescopes',NULL),
('L24',19,'Psychology observation rooms'   ,NULL),
('L25',22,'Fashion atelier & sewing'       ,NULL);
GO

TRUNCATE TABLE Registrations;
WITH student_course AS (
    SELECT 
        s.StudentID,
        c.CourseID,
        ROW_NUMBER() OVER (PARTITION BY s.StudentID ORDER BY NEWID()) AS rn,
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 75 THEN 1 ELSE 0 END AS enroll
    FROM Students s
    CROSS JOIN Courses c
)
INSERT INTO Registrations (StudentID, CourseID, Semester, Year, Status)
SELECT 
    StudentID,
    CourseID,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'Fall' ELSE 'Spring' END,
    2024 + (ABS(CHECKSUM(NEWID())) % 2),
    'Enrolled'
FROM student_course
WHERE rn <= 6          
  AND enroll = 1
  AND StudentID % 7 <> 0;  
GO

TRUNCATE TABLE Grades;
INSERT INTO Grades (StudentID, CourseID, Grade)
SELECT 
    r.StudentID,
    r.CourseID,
    ROUND(50 + ABS(CHECKSUM(NEWID())) % 51.0, 1)   
FROM Registrations r
WHERE ABS(CHECKSUM(NEWID())) % 100 <= 75;  
GO

SELECT * FROM Schools;
GO

SELECT * FROM Students;
GO

SELECT * FROM Courses;
GO

SELECT * FROM Instructors;
GO

SELECT * FROM ClassRooms;
GO

SELECT * FROM LabRooms;
GO

SELECT * FROM Registrations;
GO

SELECT * FROM Grades;
GO

--Section 1: Basic SELECT Statements, WHERE, ORDER BY, DISTINCT, IN, BETWEEN (50 Questions) 

SELECT FullName, SchoolID
FROM Students
WHERE SchoolID = 1;
SELECT DISTINCT CourseName, Credits
FROM Courses
ORDER BY Credits DESC;
SELECT FullName, HireDate
FROM Instructors
WHERE HireDate BETWEEN '2010-01-01' AND '2015-01-01';
SELECT RoomNumber, Capacity, Building
FROM ClassRooms
WHERE Capacity > 25
ORDER BY RoomNumber;
SELECT StudentID, DateOfBirth, SchoolID
FROM Students
WHERE SchoolID IN (2, 3);
SELECT LabNumber, Capacity, Equipment
FROM LabRooms
WHERE Equipment LIKE '%Computers%'
ORDER BY Capacity ASC;
SELECT RegistrationID, StudentID, CourseID, Semester, Year, Status
FROM Registrations
WHERE Status = 'Enrolled' AND Year = 2023;
SELECT StudentID, CourseID, Grade, LetterGrade
FROM Grades
WHERE Grade > 80
ORDER BY Grade DESC;
SELECT SchoolName, EstablishedYear, Location
FROM Schools
WHERE EstablishedYear > 2000
ORDER BY EstablishedYear;
SELECT DISTINCT Semester, Year
FROM Registrations
WHERE Year BETWEEN 2023 AND 2024
ORDER BY Year, Semester;
SELECT FullName, DateOfBirth
FROM Students
WHERE DateOfBirth < '2005-01-01';
SELECT InstructorID, Department, SchoolID
FROM Instructors
WHERE SchoolID IN (1, 2);
SELECT CourseName, Credits, Description
FROM Courses
WHERE Credits BETWEEN 3 AND 4;
SELECT LabID, LabNumber, Capacity, SchoolID
FROM LabRooms
WHERE Capacity <> 20;
SELECT RegistrationID, StudentID, CourseID, Semester
FROM Registrations
WHERE StudentID IN (1, 2, 3, 4, 5) 
  AND Semester = 'Fall';
  SELECT Grade, LetterGrade, StudentID, CourseID
FROM Grades
WHERE Grade BETWEEN 70 AND 89;
SELECT DISTINCT Building
FROM ClassRooms
ORDER BY Building;
SELECT StudentID, FullName, EnrollmentDate
FROM Students
WHERE EnrollmentDate > '2020-01-01'
ORDER BY EnrollmentDate;
SELECT FullName, Department
FROM Instructors
WHERE Department IN ('Mathematics', 'Physics', 'Chemistry', 'Biology', 'Advanced Math');
SELECT CourseID, CourseName
FROM Courses
WHERE CourseName LIKE '%101%';
SELECT SchoolID, SchoolName, Location, EstablishedYear,
       (SELECT COUNT(*) FROM Students s WHERE s.SchoolID = Schools.SchoolID) AS TotalStudents
FROM Schools
WHERE (SELECT COUNT(*) FROM Students s WHERE s.SchoolID = Schools.SchoolID) > 2;
SELECT DISTINCT Status
FROM Registrations
ORDER BY Status;
SELECT GradeID, StudentID, CourseID, Grade, LetterGrade, GradeDate
FROM Grades
WHERE GradeDate > '2023-01-01'
ORDER BY GradeDate DESC;
SELECT LabID, LabNumber, Capacity, Equipment, SchoolID
FROM LabRooms
WHERE Capacity BETWEEN 15 AND 25
ORDER BY Capacity;
SELECT DISTINCT StudentID, CourseID
FROM Registrations
WHERE CourseID IN (1, 3, 5)
ORDER BY StudentID, CourseID;
SELECT InstructorID, FullName, HireDate, Department
FROM Instructors
WHERE HireDate < '2015-01-01'
ORDER BY HireDate ASC;
SELECT DISTINCT Location
FROM Schools
ORDER BY Location;
SELECT RegistrationID, StudentID, CourseID, Semester, Year, Status
FROM Registrations
WHERE Semester = 'Spring' 
  AND Status <> 'Dropped';
  SELECT CourseID, CourseName, Credits, Description
FROM Courses
WHERE Credits > 2
ORDER BY CourseName;
SELECT StudentID, FirstName, LastName, FullName
FROM Students
WHERE LastName LIKE 'D%'
ORDER BY LastName, FirstName;
SELECT GradeID, StudentID, CourseID, Grade, LetterGrade, GradeDate
FROM Grades
WHERE LetterGrade IN ('A', 'B')
ORDER BY LetterGrade, Grade DESC;
SELECT RoomID, RoomNumber, Capacity, Building, SchoolID
FROM ClassRooms
WHERE Building IN ('A', 'B')
ORDER BY Capacity;
SELECT DISTINCT Equipment
FROM LabRooms
ORDER BY Equipment;
SELECT RegistrationID, StudentID, CourseID, Semester, Year, RegistrationDate, Status
FROM Registrations
WHERE RegistrationDate BETWEEN '2023-01-01' AND '2024-12-31';
SELECT InstructorID, FullName, HireDate, Department, SchoolID
FROM Instructors
WHERE HireDate >= '2010-01-01'
ORDER BY HireDate;
SELECT StudentID, FullName, SchoolID
FROM Students
WHERE SchoolID = 3
ORDER BY FullName;
SELECT CourseID, CourseName, Credits, Description
FROM Courses
WHERE Description LIKE '%basic%'
ORDER BY CourseName;
SELECT DISTINCT Year
FROM Registrations
ORDER BY Year DESC;
SELECT GradeID, StudentID, CourseID, Grade, LetterGrade
FROM Grades
WHERE Grade BETWEEN 80 AND 90
ORDER BY Grade DESC;
SELECT LabID, LabNumber, Capacity, Equipment, SchoolID
FROM LabRooms
WHERE LabNumber LIKE '%1'
ORDER BY LabNumber;
SELECT StudentID, FirstName, LastName, FullName, DateOfBirth, EnrollmentDate, SchoolID
FROM Students
WHERE FirstName IN ('John', 'Jane');
SELECT RoomID, RoomNumber, Capacity, Building, SchoolID
FROM ClassRooms
WHERE Capacity IN (30, 35)
ORDER BY Capacity, RoomNumber;
SELECT DISTINCT Department
FROM Instructors
WHERE Department IS NOT NULL
ORDER BY Department;
SELECT RegistrationID, StudentID, CourseID, Semester, Year, RegistrationDate, Status
FROM Registrations
WHERE Year = 2024
ORDER BY StudentID;
SELECT SchoolID, SchoolName, Location, EstablishedYear
FROM Schools
WHERE EstablishedYear BETWEEN 1980 AND 2000
ORDER BY EstablishedYear;
SELECT InstructorID, FirstName, LastName, FullName, Department
FROM Instructors
WHERE LastName LIKE '%S%'
ORDER BY LastName, FirstName;
SELECT GradeID, StudentID, CourseID, Grade, LetterGrade, GradeDate
FROM Grades
WHERE LetterGrade <> 'F'
ORDER BY LetterGrade, Grade DESC;
SELECT DISTINCT CourseID
FROM Grades
WHERE CourseID IS NOT NULL
ORDER BY CourseID;
SELECT StudentID, FirstName, LastName, FullName, DateOfBirth, SchoolID
FROM Students
WHERE YEAR(DateOfBirth) = 2005
ORDER BY DateOfBirth;
SELECT LabID, LabNumber, Capacity, Equipment, SchoolID
FROM LabRooms
WHERE Equipment LIKE 'C%'
ORDER BY Equipment;

--Section 2: Aggregate Functions (SUM, AVG, MIN, MAX), GROUP BY, HAVING (50 Questions) 

SELECT StudentID, AVG(Grade) AS AverageGrade
FROM Grades
GROUP BY StudentID
HAVING AVG(Grade) > 80
ORDER BY AverageGrade DESC;
SELECT SchoolID, SUM(Credits) AS TotalCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT Department, MIN(HireDate) AS EarliestHireDate
FROM Instructors
WHERE Department IS NOT NULL
GROUP BY Department
ORDER BY EarliestHireDate;
SELECT Building, MAX(Capacity) AS MaxCapacity
FROM ClassRooms
GROUP BY Building
HAVING MAX(Capacity) > 30
ORDER BY MaxCapacity DESC;
SELECT CourseID, AVG(Grade) AS AverageGrade
FROM Grades
GROUP BY CourseID
HAVING AVG(Grade) < 85
ORDER BY AverageGrade;
SELECT SchoolID, SUM(Capacity) AS TotalCapacity
FROM LabRooms
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT Semester, COUNT(*) AS RegistrationCount
FROM Registrations
GROUP BY Semester
HAVING COUNT(*) > 5
ORDER BY RegistrationCount DESC;
SELECT StudentID, MAX(Grade) AS HighestGrade
FROM Grades
GROUP BY StudentID
ORDER BY HighestGrade DESC;
SELECT SchoolID, AVG(Credits) AS AverageCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING AVG(Credits) > 3
ORDER BY AverageCredits DESC;
SELECT SchoolID, MIN(Capacity) AS MinimumCapacity
FROM ClassRooms
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY MinimumCapacity;
SELECT CourseID, COUNT(*) AS GradeCount
FROM Grades
GROUP BY CourseID
HAVING COUNT(*) > 1
ORDER BY GradeCount DESC;
SELECT StudentID, SUM(Grade) AS TotalGradePoints
FROM Grades
GROUP BY StudentID
ORDER BY TotalGradePoints DESC;
SELECT SchoolID, AVG(YEAR(HireDate)) AS AverageHireYear
FROM Instructors
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT SchoolID, MAX(LEN(Equipment)) AS MaxEquipmentLength
FROM LabRooms
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING MAX(LEN(Equipment)) > 10
ORDER BY SchoolID;
SELECT SchoolID, COUNT(*) AS StudentCount
FROM Students
GROUP BY SchoolID
HAVING COUNT(*) >= 3
ORDER BY StudentCount DESC;
SELECT CourseID, MIN(Grade) AS LowestGrade
FROM Grades
GROUP BY CourseID
ORDER BY LowestGrade;
SELECT Building, AVG(Capacity) AS AverageCapacity
FROM ClassRooms
GROUP BY Building
ORDER BY AverageCapacity DESC;
SELECT SchoolID, SUM(Credits) AS TotalCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING SUM(Credits) > 10
ORDER BY TotalCredits DESC;
SELECT Year, COUNT(*) AS EnrolledCount
FROM Registrations
WHERE Status = 'Enrolled'
GROUP BY Year
HAVING COUNT(*) > 4
ORDER BY Year;
SELECT SchoolID, MAX(DateOfBirth) AS YoungestStudentDOB
FROM Students
GROUP BY SchoolID
ORDER BY YoungestStudentDOB DESC;
SELECT StudentID, AVG(Grade) AS AverageGrade
FROM Grades
WHERE Grade > 70
GROUP BY StudentID
HAVING AVG(Grade) > 85
ORDER BY AverageGrade DESC;
SELECT SchoolID, COUNT(*) AS LabCount
FROM LabRooms
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY LabCount DESC;
SELECT SchoolID, MIN(Credits) AS MinimumCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING MIN(Credits) < 3
ORDER BY MinimumCredits;
SELECT Department, COUNT(*) AS InstructorCount
FROM Instructors
WHERE Department IS NOT NULL
GROUP BY Department
HAVING COUNT(*) > 1
ORDER BY InstructorCount DESC;
SELECT SchoolID, SUM(Capacity) AS TotalComputerLabCapacity
FROM LabRooms
WHERE Equipment LIKE '%Computers%'
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT LetterGrade, AVG(Grade) AS AverageGrade
FROM Grades
GROUP BY LetterGrade
ORDER BY LetterGrade;
SELECT SchoolID, MAX(EnrollmentDate) AS LatestEnrollmentDate
FROM Students
GROUP BY SchoolID
ORDER BY LatestEnrollmentDate DESC;
SELECT SchoolID, COUNT(*) AS CourseCount
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING COUNT(*) = 3
ORDER BY SchoolID;
SELECT SchoolID, MIN(HireDate) AS EarliestHireDate
FROM Instructors
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY EarliestHireDate;
SELECT StudentID, COUNT(*) AS RegistrationCount
FROM Registrations
GROUP BY StudentID
HAVING COUNT(*) > 1
ORDER BY RegistrationCount DESC;
SELECT SchoolID, AVG(Capacity) AS AverageCapacity
FROM ClassRooms
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
HAVING AVG(Capacity) > 25
ORDER BY AverageCapacity DESC;
SELECT CourseID, SUM(Grade) AS TotalGradePoints
FROM Grades
GROUP BY CourseID
ORDER BY TotalGradePoints DESC;
SELECT Semester, COUNT(*) AS DroppedCount
FROM Registrations
WHERE Status = 'Dropped'
GROUP BY Semester
ORDER BY DroppedCount DESC;
SELECT StudentID, MAX(GradeDate) AS LatestGradeDate
FROM Grades
GROUP BY StudentID
HAVING MAX(GradeDate) > '2023-01-01'
ORDER BY LatestGradeDate DESC;
SELECT SchoolID, AVG(Credits) AS AverageCredits
FROM Courses
WHERE CourseName LIKE '%101%'
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT Equipment, MIN(Capacity) AS MinimumCapacity
FROM LabRooms
WHERE Equipment IS NOT NULL
GROUP BY Equipment
ORDER BY MinimumCapacity;
SELECT SchoolID, COUNT(*) AS StudentsBornIn2005
FROM Students
WHERE YEAR(DateOfBirth) = 2005
GROUP BY SchoolID
ORDER BY SchoolID;
SELECT Building, SUM(Capacity) AS TotalCapacity
FROM ClassRooms
WHERE Capacity > 20
GROUP BY Building
HAVING SUM(Capacity) > 50
ORDER BY TotalCapacity DESC;
SELECT YEAR(GradeDate) AS GradeYear, AVG(Grade) AS AverageGrade
FROM Grades
GROUP BY YEAR(GradeDate)
ORDER BY GradeYear;
SELECT SchoolID, MAX(Credits) AS MaximumCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY MaximumCredits DESC;
SELECT LetterGrade, COUNT(*) AS GradeCount
FROM Grades
GROUP BY LetterGrade
HAVING COUNT(*) > 2
ORDER BY GradeCount DESC;
SELECT SchoolID, COUNT(*) AS InstructorCount
FROM Instructors
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID
ORDER BY InstructorCount DESC;
SELECT Semester, MIN(RegistrationDate) AS EarliestRegistration
FROM Registrations
GROUP BY Semester
ORDER BY EarliestRegistration;
SELECT s.Location, AVG(student_counts.StudentCount) AS AverageStudentsPerSchool
FROM Schools s
LEFT JOIN (
    SELECT SchoolID, COUNT(*) AS StudentCount
    FROM Students
    GROUP BY SchoolID
) student_counts ON s.SchoolID = student_counts.SchoolID
GROUP BY s.Location
ORDER BY AverageStudentsPerSchool DESC;
SELECT g.CourseID, SUM(g.Grade) AS TotalGradePoints
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE s.SchoolID = 1
GROUP BY g.CourseID
ORDER BY TotalGradePoints DESC;
SELECT Capacity, COUNT(*) AS LabCount
FROM LabRooms
GROUP BY Capacity
HAVING COUNT(*) > 1
ORDER BY Capacity;
SELECT Building, MAX(LEN(RoomNumber)) AS MaxRoomNumberLength
FROM ClassRooms
GROUP BY Building
ORDER BY Building;
SELECT StudentID, AVG(Grade) AS AverageGrade
FROM Grades
WHERE LetterGrade = 'A'
GROUP BY StudentID
ORDER BY AverageGrade DESC;
SELECT SchoolID, COUNT(*) AS AdvancedCourseCount
FROM Courses
WHERE Credits > 3
GROUP BY SchoolID
ORDER BY AdvancedCourseCount DESC;
SELECT Location, MIN(EstablishedYear) AS OldestSchoolYear
FROM Schools
GROUP BY Location
ORDER BY OldestSchoolYear;

--Section 3: Joins (Inner, Left, Right, Full) with Focus on Complex Combinations (50 Questions) 

SELECT s.FullName, sch.SchoolName, sch.Location
FROM Students s
INNER JOIN Schools sch ON s.SchoolID = sch.SchoolID
ORDER BY sch.SchoolName, s.FullName;
SELECT r.RegistrationID, r.StudentID, r.CourseID, r.Semester, r.Year, 
       c.CourseName, c.Credits
FROM Registrations r
LEFT JOIN Courses c ON r.CourseID = c.CourseID
ORDER BY r.RegistrationID;
SELECT g.GradeID, s.FullName, g.CourseID, g.Grade, g.LetterGrade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE g.Grade > 80
ORDER BY g.Grade DESC;
SELECT sch.SchoolName, sch.Location, i.FullName AS InstructorName, i.Department
FROM Instructors i
RIGHT JOIN Schools sch ON i.SchoolID = sch.SchoolID
ORDER BY sch.SchoolName, i.FullName;
SELECT cr.RoomNumber, cr.Capacity, cr.Building, sch.SchoolName, sch.Location
FROM ClassRooms cr
FULL OUTER JOIN Schools sch ON cr.SchoolID = sch.SchoolID
ORDER BY sch.SchoolName, cr.RoomNumber;
SELECT s.FullName, c.CourseName, r.Semester, r.Year
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics A'
ORDER BY s.FullName;
SELECT c.CourseID, c.CourseName, AVG(g.Grade) AS AverageGrade, COUNT(g.GradeID) AS GradeCount
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseID, c.CourseName
ORDER BY AverageGrade DESC;
SELECT sch.SchoolName, i.FullName AS InstructorName, i.Department, 
       c.CourseName, c.Credits
FROM Instructors i
INNER JOIN Schools sch ON i.SchoolID = sch.SchoolID
INNER JOIN Courses c ON sch.SchoolID = c.SchoolID
ORDER BY sch.SchoolName, i.FullName, c.CourseName;
SELECT DISTINCT s.FullName, r.CourseID, r.Semester, r.Year, g.Grade
FROM Registrations r
INNER JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
INNER JOIN Students s ON r.StudentID = s.StudentID
ORDER BY s.FullName, r.CourseID;
SELECT sch.SchoolName, sch.Location, lr.LabNumber, lr.Capacity, lr.Equipment
FROM LabRooms lr
RIGHT JOIN Schools sch ON lr.SchoolID = sch.SchoolID
ORDER BY sch.SchoolName, lr.LabNumber;
SELECT s.StudentID, s.FullName, g.CourseID, g.Grade, g.LetterGrade
FROM Students s
FULL OUTER JOIN Grades g ON s.StudentID = g.StudentID
ORDER BY s.StudentID, g.CourseID;
SELECT sch.SchoolName, sch.Location, COUNT(r.RegistrationID) AS EnrollmentCount
FROM Schools sch
LEFT JOIN Students s ON sch.SchoolID = s.SchoolID
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
GROUP BY sch.SchoolName, sch.Location
ORDER BY EnrollmentCount DESC;
SELECT c.CourseID, c.CourseName, c.Credits
FROM Courses c
LEFT JOIN Registrations r ON c.CourseID = r.CourseID
WHERE r.RegistrationID IS NULL
ORDER BY c.CourseName;
SELECT sch.SchoolName, sch.Location, AVG(g.Grade) AS AverageGrade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
INNER JOIN Schools sch ON s.SchoolID = sch.SchoolID
GROUP BY sch.SchoolName, sch.Location
ORDER BY AverageGrade DESC;
SELECT i.FullName AS InstructorName, i.Department, sch.SchoolName, sch.Location
FROM Instructors i
INNER JOIN Schools sch ON i.SchoolID = sch.SchoolID
ORDER BY sch.Location, i.FullName;
SELECT c.CourseID, c.CourseName, g.GradeID, g.StudentID, g.Grade, g.LetterGrade
FROM Grades g
RIGHT JOIN Courses c ON g.CourseID = c.CourseID
ORDER BY c.CourseID, g.StudentID;
SELECT sch.SchoolName, 
       cr.RoomNumber AS Classroom, cr.Capacity AS ClassroomCapacity,
       lr.LabNumber AS Lab, lr.Capacity AS LabCapacity
FROM Schools sch
LEFT JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
LEFT JOIN LabRooms lr ON sch.SchoolID = lr.SchoolID
ORDER BY sch.SchoolName, cr.RoomNumber, lr.LabNumber;
SELECT c.CourseName, s.FullName, g.Grade AS HighestGrade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
INNER JOIN (
    SELECT CourseID, MAX(Grade) AS MaxGrade
    FROM Grades
    GROUP BY CourseID
) maxgrades ON g.CourseID = maxgrades.CourseID AND g.Grade = maxgrades.MaxGrade
ORDER BY c.CourseName;
SELECT s.StudentID, s.FullName, r.RegistrationID, r.CourseID, r.Semester, r.Year
FROM Students s
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
ORDER BY s.StudentID, r.Year, r.Semester;
SELECT s.FullName AS StudentName, c.CourseName, r.Semester, r.Year, r.Status,
       sch.SchoolName, sch.Location
FROM Schools sch
INNER JOIN Students s ON sch.SchoolID = s.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE sch.SchoolID = 1
ORDER BY s.FullName, r.Year, r.Semester;
SELECT g.GradeID, g.StudentID, g.CourseID, g.Grade, r.RegistrationID, r.Status
FROM Grades g
INNER JOIN Registrations r ON g.StudentID = r.StudentID AND g.CourseID = r.CourseID
ORDER BY g.StudentID, g.CourseID;
SELECT sch.SchoolName, sch.Location, i.InstructorID, i.FullName AS InstructorName
FROM Instructors i
RIGHT JOIN Schools sch ON i.SchoolID = sch.SchoolID
WHERE i.InstructorID IS NULL
ORDER BY sch.SchoolName;
SELECT sch.SchoolName, 
       c.CourseName, c.Credits,
       i.FullName AS InstructorName, i.Department
FROM Schools sch
LEFT JOIN Courses c ON sch.SchoolID = c.SchoolID
LEFT JOIN Instructors i ON sch.SchoolID = i.SchoolID
ORDER BY sch.SchoolName, c.CourseName, i.FullName;
SELECT sch.SchoolName, sch.Location, s.FullName, s.DateOfBirth
FROM Students s
INNER JOIN Schools sch ON s.SchoolID = sch.SchoolID
ORDER BY sch.SchoolName, s.FullName;
SELECT s.StudentID, s.FullName, COUNT(g.GradeID) AS GradeCount, AVG(g.Grade) AS AverageGrade
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.FullName
ORDER BY GradeCount DESC;
SELECT sch.SchoolName, c.CourseName, c.Credits, COUNT(r.RegistrationID) AS EnrollmentCount
FROM Schools sch
INNER JOIN Courses c ON sch.SchoolID = c.SchoolID
LEFT JOIN Registrations r ON c.CourseID = r.CourseID
GROUP BY sch.SchoolName, c.CourseName, c.Credits
ORDER BY sch.SchoolName, EnrollmentCount DESC;
SELECT sch.Location, SUM(lr.Capacity) AS TotalLabCapacity, COUNT(lr.LabID) AS LabCount
FROM Schools sch
LEFT JOIN LabRooms lr ON sch.SchoolID = lr.SchoolID
GROUP BY sch.Location
ORDER BY TotalLabCapacity DESC;
SELECT s.StudentID, s.FullName, s.SchoolID, r.RegistrationID, r.CourseID
FROM Registrations r
RIGHT JOIN Students s ON r.StudentID = s.StudentID
WHERE r.RegistrationID IS NULL
ORDER BY s.StudentID;
SELECT i.FullName AS InstructorName, i.Department, 
       c.CourseName, c.Credits,
       sch.SchoolName
FROM Instructors i
FULL OUTER JOIN Courses c ON i.SchoolID = c.SchoolID
FULL OUTER JOIN Schools sch ON COALESCE(i.SchoolID, c.SchoolID) = sch.SchoolID
WHERE i.Department IS NOT NULL AND c.CourseName IS NOT NULL
  AND (c.CourseName LIKE '%' + LEFT(i.Department, 3) + '%' 
       OR i.Department LIKE '%' + LEFT(c.CourseName, 3) + '%')
ORDER BY sch.SchoolName, i.FullName, c.CourseName;
SELECT c.CourseName, c.Credits, AVG(g.Grade) AS AverageGrade, COUNT(g.GradeID) AS GradeCount
FROM Courses c
INNER JOIN Grades g ON c.CourseID = g.CourseID
INNER JOIN Students s ON g.StudentID = s.StudentID
GROUP BY c.CourseName, c.Credits
ORDER BY AverageGrade DESC;
SELECT sch.SchoolName,
       cr.RoomNumber, cr.Capacity AS ClassroomCapacity, cr.Building,
       lr.LabNumber, lr.Capacity AS LabCapacity, lr.Equipment
FROM Schools sch
LEFT JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
LEFT JOIN LabRooms lr ON sch.SchoolID = lr.SchoolID
ORDER BY sch.SchoolName, cr.RoomNumber, lr.LabNumber;
SELECT sch.SchoolName, sch.Location,
       s.FullName AS StudentName,
       c.CourseName, c.Credits,
       r.Semester, r.Year, r.Status,
       g.Grade, g.LetterGrade, g.GradeDate
FROM Schools sch
INNER JOIN Students s ON sch.SchoolID = s.SchoolID
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
LEFT JOIN Courses c ON r.CourseID = c.CourseID
LEFT JOIN Grades g ON s.StudentID = g.StudentID AND c.CourseID = g.CourseID
WHERE sch.SchoolID = 1 
ORDER BY s.FullName, r.Year, r.Semester, c.CourseName;
SELECT sch.SchoolName,
       i.FullName AS InstructorName, i.Department,
       s.FullName AS StudentName, s.DateOfBirth
FROM Schools sch
INNER JOIN Instructors i ON sch.SchoolID = i.SchoolID
INNER JOIN Students s ON sch.SchoolID = s.SchoolID
ORDER BY sch.SchoolName, i.FullName, s.FullName;
SELECT c.CourseID, c.CourseName, COUNT(r.RegistrationID) AS RegistrationCount
FROM Registrations r
RIGHT JOIN Courses c ON r.CourseID = c.CourseID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(r.RegistrationID) > 1
ORDER BY RegistrationCount DESC;
SELECT sch.SchoolName, sch.Location, cr.RoomNumber, cr.Capacity, cr.Building
FROM Schools sch
FULL OUTER JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
WHERE cr.RoomID IS NULL OR sch.SchoolID IS NULL
ORDER BY sch.SchoolName, cr.RoomNumber;
SELECT s.FullName, c.CourseName, g.Grade, g.LetterGrade, g.GradeDate
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
ORDER BY g.Grade DESC;
SELECT r.RegistrationID, s.FullName, c.CourseName, r.Semester, r.Year, r.Status
FROM Registrations r
INNER JOIN Students s ON r.StudentID = s.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
WHERE g.GradeID IS NULL
ORDER BY s.FullName, r.Year, r.Semester;
SELECT sch.SchoolName, 
       COUNT(DISTINCT i.InstructorID) AS InstructorCount,
       COUNT(DISTINCT c.CourseID) AS CourseCount,
       AVG(c.Credits) AS AverageCourseCredits
FROM Schools sch
LEFT JOIN Instructors i ON sch.SchoolID = i.SchoolID
LEFT JOIN Courses c ON sch.SchoolID = c.SchoolID
GROUP BY sch.SchoolName
ORDER BY sch.SchoolName;
SELECT sch.SchoolName,
       cr.RoomNumber, cr.Capacity AS ClassroomCapacity, cr.Building,
       lr.LabNumber, lr.Capacity AS LabCapacity, lr.Equipment
FROM Schools sch
INNER JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
INNER JOIN LabRooms lr ON sch.SchoolID = lr.SchoolID AND cr.Capacity = lr.Capacity
ORDER BY sch.SchoolName, cr.Capacity;
SELECT s.StudentID, s.FullName, SUM(g.Grade) AS TotalGradePoints, AVG(g.Grade) AS AverageGrade
FROM Grades g
RIGHT JOIN Students s ON g.StudentID = s.StudentID
GROUP BY s.StudentID, s.FullName
ORDER BY TotalGradePoints DESC;
SELECT c.CourseID, c.CourseName, AVG(g.Grade) AS AverageGrade, COUNT(g.GradeID) AS GradeCount
FROM Courses c
FULL OUTER JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseID, c.CourseName
ORDER BY AverageGrade DESC;
SELECT sch.SchoolName, sch.Location, COUNT(DISTINCT r.StudentID) AS EnrolledStudentCount
FROM Schools sch
LEFT JOIN Students s ON sch.SchoolID = s.SchoolID
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
GROUP BY sch.SchoolName, sch.Location
ORDER BY EnrolledStudentCount DESC;
SELECT i.InstructorID, i.FullName AS InstructorName, i.Department, i.HireDate,
       sch.SchoolName, sch.Location
FROM Instructors i
LEFT JOIN Schools sch ON i.SchoolID = sch.SchoolID
WHERE i.SchoolID IS NULL OR sch.SchoolID IS NULL
ORDER BY i.FullName;
SELECT s.FullName AS StudentName, c.CourseName, g.Grade, g.LetterGrade
FROM Grades g
INNER JOIN Courses c ON g.CourseID = c.CourseID
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE c.CourseName LIKE 'Math%'
ORDER BY c.CourseName, g.Grade DESC;
SELECT sch.Location, sch.SchoolName, cr.RoomNumber, cr.Capacity, cr.Building
FROM Schools sch
INNER JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
ORDER BY sch.Location, cr.Capacity DESC;
SELECT sch.SchoolName, sch.Location, COUNT(lr.LabID) AS LabCount
FROM LabRooms lr
RIGHT JOIN Schools sch ON lr.SchoolID = sch.SchoolID
GROUP BY sch.SchoolName, sch.Location
ORDER BY LabCount DESC;
SELECT s.StudentID, s.FullName, r.RegistrationID, r.CourseID, r.Semester, r.Year, r.Status
FROM Students s
FULL OUTER JOIN Registrations r ON s.StudentID = r.StudentID
WHERE r.Status = 'Dropped'
ORDER BY s.StudentID, r.Year, r.Semester;
SELECT sch.SchoolName, 
       i.FullName AS InstructorName, i.Department,
       c.CourseName, c.Credits
FROM Schools sch
INNER JOIN Instructors i ON sch.SchoolID = i.SchoolID
INNER JOIN Courses c ON sch.SchoolID = c.SchoolID
WHERE i.Department LIKE '%' + LEFT(c.CourseName, 3) + '%' 
   OR c.CourseName LIKE '%' + LEFT(i.Department, 3) + '%'
ORDER BY sch.SchoolName, i.Department, c.CourseName;
SELECT r.StudentID, r.CourseID, AVG(g.Grade) AS AverageGrade
FROM Registrations r
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
GROUP BY r.StudentID, r.CourseID
HAVING AVG(g.Grade) > 80
ORDER BY AverageGrade DESC;
SELECT 
    sch.SchoolName,
    sch.Location,
    sch.EstablishedYear,
    s.FullName AS StudentName,
    s.DateOfBirth AS StudentDOB,
    s.EnrollmentDate,
    c.CourseName,
    c.Credits,
    r.Semester,
    r.Year AS RegistrationYear,
    r.Status AS RegistrationStatus,
    g.Grade,
    g.LetterGrade,
    g.GradeDate,
    i.FullName AS InstructorName,
    i.Department AS InstructorDepartment,
    cr.RoomNumber,
    cr.Building AS ClassroomBuilding,
    lr.LabNumber,
    lr.Equipment AS LabEquipment
FROM Schools sch
LEFT JOIN Students s ON sch.SchoolID = s.SchoolID
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
LEFT JOIN Courses c ON r.CourseID = c.CourseID
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
LEFT JOIN Instructors i ON sch.SchoolID = i.SchoolID AND i.Department LIKE '%' + LEFT(c.CourseName, 3) + '%'
LEFT JOIN ClassRooms cr ON sch.SchoolID = cr.SchoolID
LEFT JOIN LabRooms lr ON sch.SchoolID = lr.SchoolID
WHERE sch.SchoolID = 1
ORDER BY s.FullName, r.Year, r.Semester, c.CourseName;

--Section 4: String Functions (UPPER, LOWER), LIKE with Wildcards, HAVING with Aggregates (50 Questions) 

SELECT UPPER(FullName) AS UppercaseFullName, LastName
FROM Students
WHERE LastName LIKE 'D%'
ORDER BY LastName;
SELECT LOWER(CourseName) AS LowercaseCourseName, Description
FROM Courses
WHERE Description LIKE '%basic%'
ORDER BY CourseName;
SELECT UPPER(FirstName) AS UppercaseFirstName, COUNT(*) AS NameCount
FROM Students
GROUP BY UPPER(FirstName)
HAVING COUNT(*) > 1
ORDER BY NameCount DESC;
SELECT LOWER(FullName) AS LowercaseFullName, Department
FROM Instructors
WHERE Department LIKE 'M%'
ORDER BY FullName;
SELECT RegistrationID, StudentID, CourseID, Semester, Year, Status
FROM Registrations
WHERE UPPER(Semester) = 'FALL' 
  AND Status LIKE 'E%'
ORDER BY Year, StudentID;
SELECT LOWER(LetterGrade) AS LowercaseLetterGrade, AVG(Grade) AS AverageGrade
FROM Grades
GROUP BY LOWER(LetterGrade)
HAVING AVG(Grade) > 80
ORDER BY AverageGrade DESC;
SELECT UPPER(SchoolName) AS UppercaseSchoolName, Location
FROM Schools
WHERE Location LIKE '%York%'
ORDER BY SchoolName;
SELECT LOWER(Equipment) AS LowercaseEquipment, LabNumber, Capacity
FROM LabRooms
WHERE LabNumber LIKE '%1'
ORDER BY LabNumber;
SELECT UPPER(Building) AS UppercaseBuilding, MAX(Capacity) AS MaxCapacity
FROM ClassRooms
GROUP BY UPPER(Building)
HAVING MAX(Capacity) > 30
ORDER BY MaxCapacity DESC;
SELECT UPPER(LastName) AS UppercaseLastName, FirstName, FullName
FROM Students
WHERE FullName LIKE '%John%'
ORDER BY LastName;
SELECT CourseName, LOWER(Description) AS LowercaseDescription
FROM Courses
WHERE CourseName LIKE 'Math%'
ORDER BY CourseName;
SELECT LOWER(Department) AS LowercaseDepartment, MIN(HireDate) AS EarliestHireDate
FROM Instructors
WHERE Department IS NOT NULL
GROUP BY LOWER(Department)
HAVING MIN(HireDate) < '2015-01-01'
ORDER BY EarliestHireDate;
SELECT UPPER(RoomNumber) AS UppercaseRoomNumber, Building, Capacity
FROM ClassRooms
WHERE Building LIKE 'B%'
ORDER BY RoomNumber;
SELECT LabNumber, LOWER(Equipment) AS LowercaseEquipment, Capacity
FROM LabRooms
WHERE LOWER(Equipment) LIKE '%comp%'
ORDER BY LabNumber;
SELECT UPPER(Status) AS UppercaseStatus, COUNT(*) AS StatusCount
FROM Registrations
GROUP BY UPPER(Status)
HAVING COUNT(*) > 5
ORDER BY StatusCount DESC;
SELECT Grade, LOWER(LetterGrade) AS LowercaseLetterGrade
FROM Grades
WHERE CAST(Grade AS VARCHAR) LIKE '8%'
ORDER BY Grade;
SELECT UPPER(Location) AS UppercaseLocation, SchoolName
FROM Schools
WHERE SchoolName LIKE '%High%'
ORDER BY Location;
SELECT LOWER(LEFT(LastName, 1)) AS LastNameInitial, COUNT(*) AS StudentCount
FROM Students
GROUP BY LOWER(LEFT(LastName, 1))
HAVING COUNT(*) > 1
ORDER BY LastNameInitial;
SELECT UPPER(Department) AS UppercaseDepartment, FullName
FROM Instructors
WHERE FullName LIKE '%Scott%'
ORDER BY Department;
SELECT SchoolID, LOWER(CourseName) AS LowercaseCourseName, AVG(Credits) AS AverageCredits
FROM Courses
WHERE SchoolID IS NOT NULL
GROUP BY SchoolID, LOWER(CourseName)
HAVING AVG(Credits) > 3
ORDER BY SchoolID, LowercaseCourseName;
SELECT g.GradeID, g.Grade, g.LetterGrade, s.FullName, s.LastName
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE UPPER(g.LetterGrade) = 'A' 
  AND s.LastName LIKE 'S%'
ORDER BY s.LastName, g.Grade DESC;
SELECT LabNumber, UPPER(Equipment) AS UppercaseEquipment, Capacity
FROM LabRooms
WHERE Capacity > 20 
  AND Equipment LIKE '%kit%'
ORDER BY Capacity;
SELECT LOWER(sch.Location) AS LowercaseLocation, SUM(lr.Capacity) AS TotalLabCapacity
FROM LabRooms lr
INNER JOIN Schools sch ON lr.SchoolID = sch.SchoolID
GROUP BY LOWER(sch.Location)
HAVING SUM(lr.Capacity) > 40
ORDER BY TotalLabCapacity DESC;
SELECT LOWER(FullName) AS LowercaseFullName, DateOfBirth
FROM Students
WHERE CONVERT(VARCHAR, DateOfBirth, 120) LIKE '2005%'
ORDER BY DateOfBirth;
SELECT RegistrationID, UPPER(Status) AS UppercaseStatus, Semester, Year
FROM Registrations
WHERE Semester LIKE 'S%' 
  AND Year = 2024
ORDER BY Status;
SELECT UPPER(LEFT(CourseName, 1)) AS FirstLetter, MAX(Credits) AS MaxCredits
FROM Courses
GROUP BY UPPER(LEFT(CourseName, 1))
HAVING MAX(Credits) > 3
ORDER BY FirstLetter;
SELECT RoomNumber, LOWER(Building) AS LowercaseBuilding, Capacity
FROM ClassRooms
WHERE RoomNumber LIKE '%10%'
ORDER BY Building;
SELECT InstructorID, FullName, UPPER(Department) AS UppercaseDepartment
FROM Instructors
WHERE UPPER(Department) LIKE '%SCIENCE%'
ORDER BY Department;
SELECT LOWER(Semester) AS LowercaseSemester, MIN(RegistrationDate) AS EarliestRegistration
FROM Registrations
GROUP BY LOWER(Semester)
HAVING MIN(RegistrationDate) > '2023-01-01'
ORDER BY EarliestRegistration;
SELECT CourseID, UPPER(LetterGrade) AS UppercaseLetterGrade, COUNT(*) AS GradeCount
FROM Grades
GROUP BY CourseID, UPPER(LetterGrade)
HAVING COUNT(*) > 2
ORDER BY CourseID, UppercaseLetterGrade;
SELECT LOWER(SchoolName) AS LowercaseSchoolName, Location
FROM Schools
WHERE LOWER(SchoolName) LIKE '%academy%'
ORDER BY SchoolName;
SELECT LabNumber, UPPER(Equipment) AS UppercaseEquipment
FROM LabRooms
WHERE Equipment LIKE '%s'
ORDER BY Equipment;
SELECT UPPER(DATENAME(month, DateOfBirth)) AS BirthMonth, 
       AVG(YEAR(DateOfBirth)) AS AverageBirthYear,
       COUNT(*) AS StudentCount
FROM Students
GROUP BY UPPER(DATENAME(month, DateOfBirth))
HAVING AVG(YEAR(DateOfBirth)) = 2005
ORDER BY BirthMonth;
SELECT LOWER(FullName) AS LowercaseFullName, LastName
FROM Instructors
WHERE LastName LIKE 'B%'
ORDER BY LastName;
SELECT CourseID, CourseName, UPPER(Description) AS UppercaseDescription
FROM Courses
WHERE UPPER(Description) LIKE '%INTRO%'
ORDER BY CourseName;
SELECT LOWER(LEFT(RoomNumber, 1)) AS RoomFirstChar, AVG(Capacity) AS AverageCapacity
FROM ClassRooms
GROUP BY LOWER(LEFT(RoomNumber, 1))
HAVING AVG(Capacity) > 25
ORDER BY RoomFirstChar;
SELECT RegistrationID, UPPER(Status) AS UppercaseStatus, RegistrationDate
FROM Registrations
WHERE CONVERT(VARCHAR, RegistrationDate, 120) LIKE '2023%'
ORDER BY RegistrationDate;
SELECT LOWER(Department) AS LowercaseDepartment, HireDate
FROM Instructors
WHERE CONVERT(VARCHAR, HireDate, 120) LIKE '201%-01%'
ORDER BY HireDate;
SELECT UPPER(Equipment) AS UppercaseEquipment, MIN(Capacity) AS MinimumCapacity
FROM LabRooms
GROUP BY UPPER(Equipment)
HAVING MIN(Capacity) < 20
ORDER BY MinimumCapacity;
SELECT UPPER(CourseName) AS UppercaseCourseName, Credits
FROM Courses
WHERE Credits > 3 
  AND CourseName LIKE '%10%'
ORDER BY CourseName;
SELECT LOWER(Location) AS LowercaseLocation, EstablishedYear, COUNT(*) AS SchoolCount
FROM Schools
GROUP BY LOWER(Location), EstablishedYear
HAVING COUNT(*) > 1
ORDER BY EstablishedYear, LowercaseLocation;
SELECT UPPER(FullName) AS UppercaseFullName, FirstName, LastName
FROM Students
WHERE FullName LIKE '% %'  
ORDER BY FullName;
SELECT LOWER(LetterGrade) AS LowercaseLetterGrade, SUM(Grade) AS TotalGradePoints, COUNT(*) AS GradeCount
FROM Grades
GROUP BY LOWER(LetterGrade)
HAVING SUM(Grade) > 200
ORDER BY TotalGradePoints DESC;
SELECT DISTINCT UPPER(Building) AS UppercaseBuilding, Capacity
FROM ClassRooms
WHERE CAST(Capacity AS VARCHAR) LIKE '3%'
ORDER BY Capacity;
SELECT LabNumber, LOWER(Equipment) AS LowercaseEquipment
FROM LabRooms
WHERE LOWER(Equipment) LIKE '_o%'
ORDER BY Equipment;
SELECT LEN(LastName) AS LastNameLength, 
       UPPER(LastName) AS UppercaseLastName,
       MAX(YEAR(HireDate)) AS LatestHireYear
FROM Instructors
GROUP BY LEN(LastName), UPPER(LastName)
HAVING MAX(YEAR(HireDate)) > 2010
ORDER BY LastNameLength;
SELECT RegistrationID, LOWER(Semester) AS LowercaseSemester, Status, Year
FROM Registrations
WHERE Status LIKE 'E%'
ORDER BY Semester;
SELECT CourseName, UPPER(Description) AS UppercaseDescription
FROM Courses
WHERE LOWER(Description) LIKE '%fund%'
ORDER BY CourseName;
SELECT LOWER(CAST(Year AS VARCHAR)) AS YearString, AVG(StudentID) AS AverageStudentID
FROM Registrations
GROUP BY LOWER(CAST(Year AS VARCHAR))
HAVING AVG(StudentID) > 5
ORDER BY YearString;
SELECT UPPER(FullName) AS UppercaseFullName, DateOfBirth
FROM Students
WHERE CONVERT(VARCHAR, DateOfBirth, 120) LIKE '2004%'
ORDER BY DateOfBirth;

--Section 5: Mixed Complex Queries, Alters, and Updates (50 Questions)

ALTER TABLE Students
ADD Email VARCHAR(100);
GO
UPDATE Students
SET Email = 'john.doe@example.com'
WHERE StudentID = 1;
GO
ALTER TABLE Courses
ALTER COLUMN Credits DECIMAL(3,1);
GO
UPDATE Grades
SET Grade = Grade + 5
WHERE Grade < 70;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'Instructors' AND COLUMN_NAME = 'Department')
BEGIN
    ALTER TABLE Instructors
    DROP COLUMN Department;
END
GO
UPDATE Schools
SET Location = 'New York City'
WHERE SchoolID = 1;
GO
ALTER TABLE Registrations
ADD CONSTRAINT CHK_Registration_Status 
CHECK (Status IN ('Enrolled', 'Dropped', 'Completed'));
GO
UPDATE r
SET r.Status = 'Completed'
FROM Registrations r
INNER JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
WHERE r.Status = 'Enrolled';
GO
UPDATE Grades SET Grade = 0 WHERE Grade IS NULL;
GO
ALTER TABLE Grades
ALTER COLUMN Grade DECIMAL(5,2) NOT NULL;
GO
ALTER TABLE Grades
ADD CONSTRAINT DF_Grades_Grade DEFAULT 0 FOR Grade;
GO
UPDATE Instructors
SET HireDate = GETDATE()
WHERE InstructorID = 1;
GO
-- SQL Server uses sp_rename
EXEC sp_rename 'Schools.Location', 'City', 'COLUMN';
GO
UPDATE Students
SET EnrollmentDate = '2023-01-01'
WHERE SchoolID = 2;
GO
ALTER TABLE ClassRooms
ADD CONSTRAINT UQ_ClassRooms_RoomNumber_SchoolID 
UNIQUE (RoomNumber, SchoolID);
GO
UPDATE Courses
SET Credits = 5
WHERE CourseName LIKE 'Science%';
GO
ALTER TABLE LabRooms
DROP COLUMN Equipment;
GO
UPDATE Grades
SET Grade = 100
WHERE LetterGrade = 'A';
GO
ALTER TABLE Students
ALTER COLUMN DateOfBirth DATETIME;
GO
UPDATE Registrations
SET Year = 2025
WHERE Semester = 'Spring';
GO
ALTER TABLE Grades
ADD PassFail AS 
   (CASE WHEN Grade >= 60 THEN 'Pass' ELSE 'Fail' END) PERSISTED;
GO
UPDATE Instructors
SET LastName = 'Updated'
WHERE Department LIKE '%Math%';
GO
SELECT sch.SchoolName, sch.Location, AVG(g.Grade) AS AverageGrade
FROM Schools sch
INNER JOIN Students s ON sch.SchoolID = s.SchoolID
INNER JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY sch.SchoolName, sch.Location
HAVING AVG(g.Grade) > 85
ORDER BY AverageGrade DESC;
SELECT s.StudentID, s.FullName, SUM(g.Grade) AS TotalGradePoints
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
WHERE s.FirstName LIKE 'J%' OR s.LastName LIKE 'J%'
GROUP BY s.StudentID, s.FullName
HAVING SUM(g.Grade) > 150
ORDER BY TotalGradePoints DESC;
SELECT c.CourseID, c.CourseName, c.Credits
FROM Courses c
LEFT JOIN Registrations r ON c.CourseID = r.CourseID
WHERE r.RegistrationID IS NULL
  AND c.CourseName LIKE '%101%'
ORDER BY c.CourseName;
SELECT i.Department, MAX(g.Grade) AS HighestGrade
FROM Instructors i
INNER JOIN Courses c ON i.SchoolID = c.SchoolID
INNER JOIN Grades g ON c.CourseID = g.CourseID
WHERE i.Department IS NOT NULL
GROUP BY i.Department
HAVING MAX(g.Grade) > 90
ORDER BY HighestGrade DESC;
SELECT DISTINCT UPPER(s.FullName) AS UppercaseFullName, sch.SchoolName, sch.City
FROM Students s
INNER JOIN Schools sch ON s.SchoolID = sch.SchoolID
WHERE sch.City BETWEEN 'A' AND 'N'
ORDER BY UppercaseFullName;
SELECT c.CourseID, c.CourseName, COUNT(r.RegistrationID) AS EnrollmentCount
FROM Courses c
LEFT JOIN Registrations r ON c.CourseID = r.CourseID
LEFT JOIN Students s ON r.StudentID = s.StudentID
GROUP BY c.CourseID, c.CourseName
HAVING COUNT(r.RegistrationID) > 2
ORDER BY EnrollmentCount DESC;
SELECT lr.LabNumber, lr.Capacity, LOWER(sch.SchoolName) AS LowercaseSchoolName
FROM LabRooms lr
INNER JOIN Schools sch ON lr.SchoolID = sch.SchoolID
WHERE lr.Capacity IN (20, 25)
  AND LOWER(sch.SchoolName) LIKE '%high%'
ORDER BY sch.SchoolName, lr.LabNumber;
SELECT i.InstructorID, i.FullName, i.SchoolID, AVG(c.Credits) AS AverageCourseCredits
FROM Instructors i
INNER JOIN Courses c ON i.SchoolID = c.SchoolID
GROUP BY i.InstructorID, i.FullName, i.SchoolID
HAVING AVG(c.Credits) < 4
ORDER BY AverageCourseCredits;
SELECT sch.SchoolID, sch.SchoolName, MIN(i.HireDate) AS EarliestHireDate,
       (SELECT COUNT(*) FROM Students s WHERE s.SchoolID = sch.SchoolID) AS StudentCount
FROM Schools sch
LEFT JOIN Instructors i ON sch.SchoolID = i.SchoolID
WHERE (SELECT COUNT(*) FROM Students s WHERE s.SchoolID = sch.SchoolID) > 3
GROUP BY sch.SchoolID, sch.SchoolName
ORDER BY EarliestHireDate;
SELECT s.FullName, c.CourseName, g.Grade,
       (SELECT AVG(Grade) FROM Grades g2 WHERE g2.CourseID = c.CourseID) AS CourseAverage
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
WHERE g.Grade > (SELECT AVG(Grade) FROM Grades g3 WHERE g3.CourseID = c.CourseID)
ORDER BY c.CourseName, g.Grade DESC;
SELECT s.FullName, c.CourseName, g.Grade, g.LetterGrade, sch.SchoolName
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
INNER JOIN Schools sch ON s.SchoolID = sch.SchoolID
WHERE g.LetterGrade = 'A'
  AND c.CourseName LIKE 'Bio%'
ORDER BY s.FullName;
SELECT r.Semester, r.Year, SUM(g.Grade) AS TotalGradePoints
FROM Registrations r
INNER JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
GROUP BY r.Semester, r.Year
HAVING SUM(g.Grade) > 500
ORDER BY r.Year, r.Semester;
SELECT DISTINCT UPPER(c.CourseName) AS UppercaseCourseName, c.Credits,
       (SELECT COUNT(*) FROM Registrations r WHERE r.CourseID = c.CourseID) AS RegistrationCount
FROM Courses c
WHERE c.Credits BETWEEN 2 AND 4
  AND (SELECT COUNT(*) FROM Registrations r WHERE r.CourseID = c.CourseID) > 1
ORDER BY UppercaseCourseName;
SELECT s.StudentID, s.FullName, r.RegistrationID, r.CourseID
FROM Students s
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
WHERE s.LastName LIKE '%son%'
  AND r.RegistrationID IS NULL
ORDER BY s.FullName DESC;
SELECT LOWER(cr.Building) AS LowercaseBuilding, MAX(cr.Capacity) AS MaxCapacity,
       sch.SchoolName
FROM ClassRooms cr
INNER JOIN Schools sch ON cr.SchoolID = sch.SchoolID
GROUP BY LOWER(cr.Building), sch.SchoolName
HAVING MAX(cr.Capacity) > 35
ORDER BY MaxCapacity DESC;
SELECT s.StudentID, s.FullName, s.SchoolID, AVG(g.Grade) AS AverageGrade
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
WHERE s.SchoolID IN (1, 2)
GROUP BY s.StudentID, s.FullName, s.SchoolID
HAVING AVG(g.Grade) > 80
ORDER BY AverageGrade DESC;
SELECT DISTINCT s.StudentID, s.FullName, r.RegistrationID, r.Status, c.CourseName
FROM Students s
FULL OUTER JOIN Registrations r ON s.StudentID = r.StudentID
FULL OUTER JOIN Courses c ON r.CourseID = c.CourseID
WHERE r.Status LIKE 'En%'
ORDER BY s.StudentID;
SELECT Equipment, COUNT(*) AS LabCount
FROM LabRooms
WHERE Equipment LIKE '%comp%'
GROUP BY Equipment
HAVING COUNT(*) = 2
ORDER BY Equipment;
UPDATE Grades
SET Grade = Grade + 2
WHERE StudentID IN (
    SELECT StudentID
    FROM Grades
    GROUP BY StudentID
    HAVING AVG(Grade) > 85
);
GO
SELECT s.FullName, 
       c.CourseName, 
       g.Grade,
       (SELECT AVG(Grade) FROM Grades g2 WHERE g2.CourseID = c.CourseID) AS CourseAvg,
       CASE 
           WHEN g.Grade > (SELECT AVG(Grade) FROM Grades g2 WHERE g2.CourseID = c.CourseID) 
           THEN 'Above Average'
           ELSE 'Below Average'
       END AS Performance
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
ORDER BY s.FullName, c.CourseName;
GO
SELECT LOWER(s.FullName) AS LowercaseFullName, sch.SchoolName, s.DateOfBirth
FROM Students s
RIGHT JOIN Schools sch ON s.SchoolID = sch.SchoolID
ORDER BY s.DateOfBirth;
SELECT c.CourseName, g.LetterGrade, MIN(g.Grade) AS MinimumGrade, MAX(g.Grade) AS MaximumGrade
FROM Grades g
INNER JOIN Courses c ON g.CourseID = c.CourseID
WHERE g.Grade BETWEEN 70 AND 90
GROUP BY c.CourseName, g.LetterGrade
HAVING MIN(g.Grade) < 75
ORDER BY c.CourseName, g.LetterGrade;
SELECT UPPER(i.Department) AS UppercaseDepartment, i.FullName AS InstructorName, 
       sch.SchoolName, sch.City
FROM Instructors i
INNER JOIN Schools sch ON i.SchoolID = sch.SchoolID
WHERE i.FirstName LIKE '_i%' OR i.LastName LIKE '_i%'
ORDER BY i.Department, i.FullName;
SELECT DISTINCT r.Year, SUM(g.Grade) AS TotalGradePoints
FROM Registrations r
INNER JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
GROUP BY r.Year
HAVING SUM(g.Grade) > 100
ORDER BY r.Year;
SELECT s.StudentID, s.FullName, r.RegistrationID, r.CourseID, r.Status
FROM Students s
LEFT JOIN Registrations r ON s.StudentID = r.StudentID
WHERE s.StudentID IN (1, 3, 5)
  AND r.RegistrationID IS NULL
ORDER BY s.FullName ASC;
SELECT sch.SchoolName, c.CourseName, AVG(g.Grade) AS AverageGrade
FROM Schools sch
INNER JOIN Courses c ON sch.SchoolID = c.SchoolID
INNER JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY sch.SchoolName, c.CourseName
HAVING AVG(g.Grade) BETWEEN 80 AND 90
ORDER BY sch.SchoolName, AverageGrade DESC;
SELECT LOWER(i.FullName) AS LowercaseInstructorName, 
       i.Department,
       LOWER(c.CourseName) AS LowercaseCourseName,
       c.Description
FROM Instructors i
FULL OUTER JOIN Courses c ON i.SchoolID = c.SchoolID
WHERE c.Description LIKE '%prog%' OR c.Description LIKE '%program%'
ORDER BY LowercaseCourseName;
SELECT sch.City, sch.Location AS Region, COUNT(s.StudentID) AS StudentCount
FROM Schools sch
LEFT JOIN Students s ON sch.SchoolID = s.SchoolID
GROUP BY sch.City, sch.Location
HAVING COUNT(s.StudentID) > 2
ORDER BY StudentCount DESC;
SELECT s.StudentID, s.FullName, 
       MAX(g.Grade) AS HighestGrade, 
       MIN(g.Grade) AS LowestGrade,
       MAX(g.Grade) - MIN(g.Grade) AS GradeRange
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.FullName
HAVING MAX(g.Grade) - MIN(g.Grade) > 10
ORDER BY GradeRange DESC;
SELECT UPPER(sch.SchoolName) AS UppercaseSchoolName, 
       lr.LabNumber, 
       lr.Capacity, 
       lr.Equipment
FROM LabRooms lr
INNER JOIN Schools sch ON lr.SchoolID = sch.SchoolID
WHERE lr.Equipment LIKE '%tools%'
  AND lr.Capacity BETWEEN 15 AND 25
ORDER BY sch.SchoolName, lr.Capacity;
SELECT UPPER(r.Semester) AS UppercaseSemester,
       sch.SchoolName,
       sch.City,
       COUNT(DISTINCT r.StudentID) AS StudentCount,
       SUM(c.Credits) AS TotalCredits,
       AVG(g.Grade) AS AverageGrade
FROM Schools sch
INNER JOIN Students s ON sch.SchoolID = s.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
GROUP BY UPPER(r.Semester), sch.SchoolName, sch.City
HAVING SUM(c.Credits) > 10
ORDER BY TotalCredits DESC, AverageGrade DESC;

--LIKE + Wildcards – Pattern Matching (Questions 1–10) 

SELECT StudentID, FirstName, LastName, FullName
FROM Students
WHERE (FirstName LIKE 'J___' OR FirstName LIKE 'S___')
  AND LEN(FirstName) = 4
ORDER BY FirstName;
SELECT CourseID, CourseName, Credits
FROM Courses
WHERE CourseName LIKE '%Science%'
   OR CourseName LIKE '%science%'
   OR CourseName LIKE '%SCIENCE%'
ORDER BY CourseName;
SELECT StudentID, FirstName, LastName, FullName
FROM Students
WHERE LastName LIKE '%sen' OR LastName LIKE '%man'
ORDER BY LastName;
SELECT InstructorID, FirstName, LastName, FullName
FROM Instructors
WHERE FullName LIKE '% de %'  
   OR FullName LIKE '% van %'  
ORDER BY FullName;
SELECT LabID, LabNumber, Equipment, Capacity
FROM LabRooms
WHERE Equipment LIKE '%computers%' AND Equipment LIKE '%projector%'
   OR Equipment LIKE '%Computers%' AND Equipment LIKE '%Projector%'
ORDER BY Equipment;
SELECT StudentID, FirstName, LastName, LEN(FirstName) AS NameLength
FROM Students
WHERE (FirstName LIKE 'A%' OR FirstName LIKE 'E%' OR FirstName LIKE 'I%' 
       OR FirstName LIKE 'O%' OR FirstName LIKE 'U%')
  AND LEN(FirstName) > 4
ORDER BY FirstName;
SELECT CourseID, CourseName, Credits
FROM Courses
WHERE CourseName LIKE '[0-9]%'  
   OR CourseName LIKE '%[0-9]%'  
ORDER BY CourseName;
SELECT DISTINCT LastName
FROM Students
WHERE LastName NOT LIKE 'V%'
  AND LastName NOT LIKE 'd%'
  AND LastName NOT LIKE 'J%'
ORDER BY LastName;
SELECT RegistrationID, StudentID, CourseID, Semester, Year
FROM Registrations
WHERE LEN(Semester) = 4
  AND (Semester LIKE 'F%' OR Semester LIKE 'S%')
ORDER BY Semester, Year;
SELECT RoomID, RoomNumber, Building, Capacity
FROM ClassRooms
WHERE RoomNumber LIKE '[A-Z][0-9][A-Z]' 
   OR RoomNumber LIKE '[A-Z][0-9][0-9][A-Z]' 
   OR RoomNumber LIKE '[A-Z][A-Z][0-9][A-Z]'  
ORDER BY RoomNumber;

--LIKE + Functions + Conditions (Questions 11–20) 

SELECT StudentID, FirstName, LastName, FullName
FROM Students
WHERE LEFT(FirstName, 1) = LEFT(LastName, 1)
ORDER BY FirstName, LastName;
SELECT CourseID, CourseName, Credits
FROM Courses
WHERE LEN(CourseName) >= 2
  AND SUBSTRING(CourseName, 2, 1) IN ('A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u')
ORDER BY CourseName;
SELECT InstructorID, FirstName, LastName, FullName, HireDate
FROM Instructors
WHERE CONVERT(VARCHAR, YEAR(HireDate)) LIKE '%201%'
   OR CONVERT(VARCHAR, HireDate, 120) LIKE '%201%'
ORDER BY HireDate;
SELECT GradeID, StudentID, CourseID, Grade, LetterGrade
FROM Grades
WHERE LetterGrade IN ('A', 'B')
  AND (CAST(Grade AS VARCHAR) LIKE '%.5' 
       OR CAST(Grade AS VARCHAR) LIKE '%.0'
       OR CAST(Grade AS VARCHAR) LIKE '%_._5' 
       OR CAST(Grade AS VARCHAR) LIKE '%_._0')
ORDER BY Grade DESC;
SELECT SchoolID, SchoolName, Location
FROM Schools
WHERE SchoolName LIKE '% %'  
  AND SchoolName NOT LIKE '% % %'  
ORDER BY SchoolName;
SELECT SchoolID, SchoolName, Location
FROM Schools
WHERE SchoolName LIKE '% %'  
ORDER BY SchoolName;
SELECT SchoolID, SchoolName, Location
FROM Schools
WHERE SchoolName LIKE '% %' 
  AND SchoolName NOT LIKE '% % %'
ORDER BY SchoolName;
SELECT StudentID, FirstName, LastName, DateOfBirth, 
       DATENAME(month, DateOfBirth) AS BirthMonth
FROM Students
WHERE DATENAME(month, DateOfBirth) LIKE 'J%'
ORDER BY DATEPART(month, DateOfBirth);
SELECT DISTINCT LastName
FROM Students
WHERE LastName LIKE '%aa%' 
   OR LastName LIKE '%bb%'
   OR LastName LIKE '%cc%'
   OR LastName LIKE '%dd%'
   OR LastName LIKE '%ee%'
   OR LastName LIKE '%ff%'
   OR LastName LIKE '%gg%'
   OR LastName LIKE '%hh%'
   OR LastName LIKE '%ii%'
   OR LastName LIKE '%jj%'
   OR LastName LIKE '%kk%'
   OR LastName LIKE '%ll%'
   OR LastName LIKE '%mm%'
   OR LastName LIKE '%nn%'
   OR LastName LIKE '%oo%'
   OR LastName LIKE '%pp%'
   OR LastName LIKE '%qq%'
   OR LastName LIKE '%rr%'
   OR LastName LIKE '%ss%'
   OR LastName LIKE '%tt%'
   OR LastName LIKE '%uu%'
   OR LastName LIKE '%vv%'
   OR LastName LIKE '%ww%'
   OR LastName LIKE '%xx%'
   OR LastName LIKE '%yy%'
   OR LastName LIKE '%zz%'
ORDER BY LastName;
SELECT DISTINCT LastName
FROM Students
WHERE PATINDEX('%[a-z][a-z]%', LastName) > 0
  AND SUBSTRING(LastName, PATINDEX('%[a-z][a-z]%', LastName), 1) 
      = SUBSTRING(LastName, PATINDEX('%[a-z][a-z]%', LastName) + 1, 1)
ORDER BY LastName;
SELECT CourseID, CourseName, Description
FROM Courses
WHERE Description IS NOT NULL
  AND (Description LIKE '%introduction%' 
       OR Description LIKE '%Introduction%' 
       OR Description LIKE '%INTRO%')
  AND Description NOT LIKE '%advanced%'
  AND Description NOT LIKE '%Advanced%'
  AND Description NOT LIKE '%ADVANCED%'
ORDER BY CourseName;
WITH VowelCheck AS (
    SELECT 
        FirstName,
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
        REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            LOWER(FirstName), 
            'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', ''),
            'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '') AS WithoutVowels,
        LEN(LOWER(FirstName)) - LEN(REPLACE(LOWER(FirstName), 'a', '')) AS CountA,
        LEN(LOWER(FirstName)) - LEN(REPLACE(LOWER(FirstName), 'e', '')) AS CountE,
        LEN(LOWER(FirstName)) - LEN(REPLACE(LOWER(FirstName), 'i', '')) AS CountI,
        LEN(LOWER(FirstName)) - LEN(REPLACE(LOWER(FirstName), 'o', '')) AS CountO,
        LEN(LOWER(FirstName)) - LEN(REPLACE(LOWER(FirstName), 'u', '')) AS CountU
    FROM Students
)
SELECT DISTINCT FirstName
FROM VowelCheck
WHERE 
    (CountA + CountE + CountI + CountO + CountU) > 0
    AND (
        (CountA > 0 AND CountE = 0 AND CountI = 0 AND CountO = 0 AND CountU = 0) OR
        (CountE > 0 AND CountA = 0 AND CountI = 0 AND CountO = 0 AND CountU = 0) OR
        (CountI > 0 AND CountA = 0 AND CountE = 0 AND CountO = 0 AND CountU = 0) OR
        (CountO > 0 AND CountA = 0 AND CountE = 0 AND CountI = 0 AND CountU = 0) OR
        (CountU > 0 AND CountA = 0 AND CountE = 0 AND CountI = 0 AND CountO = 0)
    )
ORDER BY FirstName;
SELECT StudentID, FirstName, LastName, FullName, LEN(FullName) AS NameLength
FROM Students
WHERE LEN(FullName) BETWEEN 10 AND 14
  AND FullName LIKE '% %'  
  AND FullName NOT LIKE '% % %'  
ORDER BY NameLength, FullName;

--LIKE in JOIN / Subquery / HAVING (Questions 21–30) 

SELECT s.StudentID, s.FirstName, s.LastName, c.CourseID, c.CourseName
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName LIKE '%' + s.FirstName + '%'
   OR c.CourseName LIKE '%' + UPPER(s.FirstName) + '%'
   OR c.CourseName LIKE '%' + LOWER(s.FirstName) + '%'
ORDER BY s.FirstName, c.CourseName;
SELECT DISTINCT i.InstructorID, i.FullName AS InstructorName, i.Department
FROM Instructors i
WHERE EXISTS (
    SELECT 1
    FROM Courses c
    WHERE c.Description IS NOT NULL
      AND (c.Description LIKE '%' + i.Department + '%'
           OR c.Description LIKE '%' + UPPER(i.Department) + '%'
           OR c.Description LIKE '%' + LOWER(i.Department) + '%')
)
ORDER BY i.Department;
SELECT DISTINCT sch.SchoolID, sch.SchoolName, sch.Location
FROM Schools sch
WHERE EXISTS (
    SELECT 1
    FROM Students s
    WHERE s.SchoolID = sch.SchoolID
      AND s.LastName LIKE LEFT(sch.SchoolName, 1) + '%'
)
ORDER BY sch.SchoolName;
SELECT sch.SchoolID, sch.SchoolName, 
       COUNT(CASE 
           WHEN c.Description LIKE '%intro%' 
             OR c.Description LIKE '%basic%' 
             OR c.Description LIKE '%Introduction%' 
             OR c.Description LIKE '%Basic%'
           THEN 1 
       END) AS IntroBasicCourseCount
FROM Schools sch
LEFT JOIN Courses c ON sch.SchoolID = c.SchoolID
GROUP BY sch.SchoolID, sch.SchoolName
HAVING COUNT(CASE 
           WHEN c.Description LIKE '%intro%' 
             OR c.Description LIKE '%basic%' 
             OR c.Description LIKE '%Introduction%' 
             OR c.Description LIKE '%Basic%'
           THEN 1 
       END) > 0
ORDER BY IntroBasicCourseCount DESC;
SELECT s.StudentID, s.FirstName, s.LastName, COUNT(*) AS MathCourseCount
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName LIKE '%Math%'
   OR c.CourseName LIKE '%Mathematics%'
   OR c.CourseName LIKE '%Calculus%'
GROUP BY s.StudentID, s.FirstName, s.LastName
HAVING COUNT(*) >= 2
ORDER BY MathCourseCount DESC;
SELECT DISTINCT cr.RoomID, cr.RoomNumber AS ClassroomRoom, cr.Building,
       lr.LabID, lr.LabNumber AS LabRoom
FROM ClassRooms cr
CROSS JOIN LabRooms lr
WHERE cr.RoomNumber LIKE '%' + SUBSTRING(lr.LabNumber, 
                                          PATINDEX('%[0-9]%', lr.LabNumber), 
                                          LEN(lr.LabNumber)) + '%'
   OR lr.LabNumber LIKE '%' + SUBSTRING(cr.RoomNumber, 
                                         PATINDEX('%[0-9]%', cr.RoomNumber), 
                                         LEN(cr.RoomNumber)) + '%'
ORDER BY cr.RoomNumber, lr.LabNumber;
SELECT DISTINCT s.StudentID, s.FirstName, s.LastName AS StudentLastName,
       i.InstructorID, i.LastName AS InstructorLastName
FROM Students s
INNER JOIN Instructors i ON i.LastName LIKE '%' + s.LastName + '%'
WHERE LEN(s.LastName) <= LEN(i.LastName)
  AND s.LastName != i.LastName
ORDER BY s.LastName, i.LastName;
SELECT c.CourseID, c.CourseName, c.Credits
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Registrations r
    INNER JOIN Students s ON r.StudentID = s.StudentID
    WHERE r.CourseID = c.CourseID
      AND (s.FirstName LIKE 'M%' OR s.FirstName LIKE 'N%')
)
ORDER BY c.CourseName;
SELECT c.CourseID, c.CourseName, AVG(g.Grade) AS AverageGrade, COUNT(g.GradeID) AS GradeCount
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
WHERE LEFT(c.CourseName, 1) = RIGHT(c.CourseName, 1)
  AND LEFT(c.CourseName, 1) LIKE '[A-Za-z]'  
GROUP BY c.CourseID, c.CourseName
ORDER BY AverageGrade DESC;
SELECT TOP 5
    RIGHT(s.LastName, 1) AS LastNameEndingLetter,
    COUNT(DISTINCT s.StudentID) AS StudentCount
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
WHERE g.LetterGrade IN ('A', 'B', 'C', 'D')
  AND (c.CourseName LIKE '%Bio%' 
       OR c.CourseName LIKE '%Chem%'
       OR c.CourseName LIKE '%Biology%'
       OR c.CourseName LIKE '%Chemistry%')
  AND RIGHT(s.LastName, 1) LIKE '[A-Za-z]'
GROUP BY RIGHT(s.LastName, 1)
ORDER BY StudentCount DESC;

--