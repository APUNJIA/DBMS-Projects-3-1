--PART - 1
-- Table creation

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(15),
    LastName VARCHAR(15),
    Age INT,
    DepartmentID INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    DepartmentID INT
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade DECIMAL(5, 3),
    CONSTRAINT FK_Student FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Course FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insertion of data in Students

INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (1, 'John', 'Doe', 20, 1);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (2, 'Jane', 'Smith', 22, 2);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (3, 'Bob', 'Johnson', 21, 1);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (4, 'Alice', 'Williams', 23, 2);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (5, 'Charlie', 'Brown', 19, 3);

--Insertion of data in Courses

INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (101, 'Mathematics', 1);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (102, 'Physics', 2);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (103, 'Computer Science', 3);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (104, 'History', 1);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (105, 'Biology', 2);

--Insertion of data in Grades

INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES
    (1, 1, 101, 9.5);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (2, 2, 102, 8.0);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (3, 3, 103, 7.5);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (4, 4, 104, 8.0);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (5, 5, 105, 9.5);

-- PART - 2

UPDATE Students
SET Age = 26
WHERE Age > 23;
--
UPDATE Courses
SET CourseName = 'Advanced Mathematics'
WHERE CourseID = 101;
--
UPDATE Grades
SET Grade = 9.0
WHERE StudentID = 2 AND CourseID = 102;
--
UPDATE Courses
SET departmentid = 4
WHERE CourseID = 101;
--
UPDATE students
SET firstname = 'Joe'
WHERE lastname = 'Smith';

-- Create a package specification
CREATE OR REPLACE PACKAGE StudentPackage AS
  -- Procedure to insert a new student
  PROCEDURE InsertStudent(
    p_StudentID INT,
    p_FirstName VARCHAR2,
    p_LastName VARCHAR2,
    p_Age INT,
    p_DepartmentID INT
  );

  -- Procedure to update the age of students in a department
  PROCEDURE UpdateAgeInDepartment(
    p_DepartmentID INT,
    p_NewAge INT
  );

  -- Procedure to delete a student
  PROCEDURE DeleteStudent(
    p_StudentID INT
  );
  
END StudentPackage;
/

-- Create a package body
CREATE OR REPLACE PACKAGE BODY StudentPackage AS
  -- Procedure to insert a new student
  PROCEDURE InsertStudent(
    p_StudentID INT,
    p_FirstName VARCHAR2,
    p_LastName VARCHAR2,
    p_Age INT,
    p_DepartmentID INT
  ) IS
  BEGIN
    -- Insert new student record
    INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
    VALUES (p_StudentID, p_FirstName, p_LastName, p_Age, p_DepartmentID);
    
    -- Commit the transaction
    COMMIT;
  EXCEPTION
    -- Handle exceptions
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      ROLLBACK;
      -- Raise an application-specific error
      RAISE_APPLICATION_ERROR(-20001, 'Error inserting student. ' || SQLERRM);
  END InsertStudent;

  -- Procedure to update the age of students in a department
  PROCEDURE UpdateAgeInDepartment(
    p_DepartmentID INT,
    p_NewAge INT
  ) IS
  BEGIN
    -- Update the age of students in the specified department
    UPDATE Students
    SET Age = p_NewAge
    WHERE DepartmentID = p_DepartmentID;
    
    -- Commit the transaction
    COMMIT;
  EXCEPTION
    -- Handle exceptions
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      ROLLBACK;
      -- Raise an application-specific error
      RAISE_APPLICATION_ERROR(-20002, 'Error updating age in department. ' || SQLERRM);
  END UpdateAgeInDepartment;

  -- Procedure to delete a student
  PROCEDURE DeleteStudent(
    p_StudentID INT
  ) IS
  BEGIN
    -- Delete the student record
    DELETE FROM Students
    WHERE StudentID = p_StudentID;
    
    -- Commit the transaction
    COMMIT;
  EXCEPTION
    -- Handle exceptions
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      ROLLBACK;
      -- Raise an application-specific error
      RAISE_APPLICATION_ERROR(-20003, 'Error deleting student. ' || SQLERRM);
  END DeleteStudent;
  
END StudentPackage;
/

-- Create a before insert trigger
CREATE OR REPLACE TRIGGER BeforeInsertStudent
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
  -- You can add additional logic before the insert operation if needed
  DBMS_OUTPUT.PUT_LINE('Insert into Students Table. (TRIGGER Execution Before Insert Operation)');
END BeforeInsertStudent;
/

-- Create an after insert trigger
CREATE OR REPLACE TRIGGER AfterInsertStudent
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
  -- You can add additional logic after the insert operation if needed
  DBMS_OUTPUT.PUT_LINE('Insert into Students Table. (TRIGGER Execution After Insert Operation)');
END AfterInsertStudent;
/

-- Create a before update trigger
CREATE OR REPLACE TRIGGER BeforeUpdateAgeInDepartment
BEFORE UPDATE ON Students
FOR EACH ROW
BEGIN
  -- You can add additional logic before the update operation if needed
  DBMS_OUTPUT.PUT_LINE('Age Update in Students Table. (TRIGGER Execution Before Update Operation)');
END BeforeUpdateAgeInDepartment;
/

-- Create an after update trigger
CREATE OR REPLACE TRIGGER AfterUpdateAgeInDepartment
AFTER UPDATE ON Students
FOR EACH ROW
BEGIN
  -- We can add additional logic after the update operation if needed
  DBMS_OUTPUT.PUT_LINE('Age Update in Students Table. (TRIGGER Execution After Update Operation)');
END AfterUpdateAgeInDepartment;
/

-- Create a before delete trigger
CREATE OR REPLACE TRIGGER BeforeDeleteStudent
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
  -- You can add additional logic before the delete operation if needed
  DBMS_OUTPUT.PUT_LINE('Delete from Students Table. (TRIGGER Execution Before Delete Operation)');
END BeforeDeleteStudent;
/

-- Create an after delete trigger
CREATE OR REPLACE TRIGGER AfterDeleteStudent
AFTER DELETE ON Students
FOR EACH ROW
BEGIN
  -- You can add additional logic after the delete operation if needed
  DBMS_OUTPUT.PUT_LINE('Delete from Students Table. (TRIGGER Execution After Delete Operation)');
END AfterDeleteStudent;
/

BEGIN
StudentPackage.UpdateAgeInDepartment(1,19);
END;
/

BEGIN
StudentPackage.InsertStudent (6,'Paul','Miller',25,3);
StudentPackage.InsertStudent (7,'Jack','Anderson',20,1);
StudentPackage.InsertStudent (8,'Hugh','Wilson',22,2);
StudentPackage.InsertStudent (9,'Drew','Thomas',19,3);
StudentPackage.InsertStudent (10,'Luna','Moore',21,1);

END;
/

SELECT * FROM STUDENTS
