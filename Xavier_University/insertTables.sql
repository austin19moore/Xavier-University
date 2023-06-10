
UNLOCK TABLES;
DROP PROCEDURE IF EXISTS `update_degree_credits`;
DROP TRIGGER IF EXISTS `update_degree_credits_trigger`;
DROP TRIGGER IF EXISTS `update_degree_credits_trigger_insert`;
DROP PROCEDURE IF EXISTS `update_gpa`;
DROP TRIGGER IF EXISTS `update_gpa_trigger`;
DROP TRIGGER IF EXISTS `update_gpa_trigger_insert`;
DROP PROCEDURE IF EXISTS `update_degree_all_credits`;
DROP TABLE IF EXISTS `ENROLLMENT`;
DROP TABLE IF EXISTS `CLASS`;
DROP TABLE IF EXISTS `STU_DEGREE_LIST`;
DROP TABLE IF EXISTS `PROFESSOR`;
DROP TABLE IF EXISTS `STUDENT`;
DROP TABLE IF EXISTS `BUILDING`;
DROP TABLE IF EXISTS `DEGREE`;
DROP TABLE IF EXISTS `DEPARTMENT`;
DROP TABLE IF EXISTS `PERSON`;
DROP PROCEDURE IF EXISTS `update_stu_grade_level`;
DROP TRIGGER IF EXISTS `update_stu_grade_level`;
DROP TRIGGER IF EXISTS `update_stu_grade_level_after_insert`;
DROP PROCEDURE IF EXISTS `update_standing`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: xavier_university
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `person`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PERSON` (
  `PERSON_ID` int NOT NULL AUTO_INCREMENT,
  `PERSON_FNAME` text,
  `PERSON_LNAME` text,
  `PERSON_EMAIL` text,
  `PERSON_PHONE` text,
  `PERSON_ADDR` text,
  PRIMARY KEY (`PERSON_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-17 19:51:30
CREATE TABLE `DEPARTMENT` (
    `DEPT_ID` int NOT NULL AUTO_INCREMENT,
    `DEPT_NAME` varchar(60) DEFAULT NULL,
    PRIMARY KEY (`DEPT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `DEGREE` (
    `DEGREE_ID` int NOT NULL AUTO_INCREMENT,
    `DEGREE_NAME` varchar(60) DEFAULT NULL,
    `DEGREE_TYPE` varchar(45) DEFAULT NULL, -- Certificate, Associate, Bachelor, Master, Doctorate
    `DEPT_ID` int NOT NULL, -- Foreign key to DEPARTMENT table
    `DEGREE_GPA` decimal(4,2) DEFAULT NULL, -- This could be different for a student with multiple degrees from the student's overall GPA. This is what shows up on their transcript for this specific degree
    `CATALOG_YEAR` int DEFAULT NULL, -- This is the year the catalog was published for this degree, as the degree could be updated over time, so this allows us to know which catalog the student was following
    `YEAR_STARTED` int DEFAULT NULL, -- This is the year the student started the degree
    `YEAR_COMPLETED` int DEFAULT NULL, -- This is the year the student completed the degree
    `DEGREE_CREDITS` int DEFAULT NULL, -- This is the number of credits required for this degree
    PRIMARY KEY (`DEGREE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


----------------
-- PROCEDURES --
----------------

-- Update DEGREE_CREDITS based on the DEGREE_TYPE
-- This is done as follows:
-- Certificate: 30
-- Associate: 60
-- Bachelor: 120
-- Master: 30
-- Doctorate: 60
DELIMITER $$
CREATE PROCEDURE `update_degree_credits`(IN NEW_ID int)
BEGIN
    -- make variables for degree_type, year_level_start, credits_earned, and credits_required
    -- get the student's degree type
    SELECT DEGREE_TYPE INTO @degree_type FROM DEGREE WHERE DEGREE_ID = NEW_ID;
    IF @degree_type = 'Certificate' THEN
        SET @degree_credits = 30;
    ELSEIF @degree_type = 'Associate' THEN
        SET @degree_credits = 60;
    ELSEIF @degree_type = 'Bachelor' THEN
        SET @degree_credits = 120;
    ELSEIF @degree_type = 'Master' THEN
        SET @degree_credits = 30;
    ELSEIF @degree_type = 'Doctorate' THEN
        SET @degree_credits = 60;
    END IF;
    UPDATE DEGREE SET DEGREE_CREDITS = @degree_credits WHERE DEGREE_ID = NEW_ID;
END$$
DELIMITER ;
-- create trigger to run when the DEGREE table is updated and it's the degree's id that is updated in the DEGREE_ID field
-- the trigger will run the update_degree_credits procedure
-- DELIMITER $$
-- CREATE TRIGGER `update_degree_credits_trigger`
-- BEFORE UPDATE ON `DEGREE`
-- FOR EACH ROW
-- BEGIN
--     IF NEW.DEGREE_ID != OLD.DEGREE_ID THEN
--         CALL update_degree_credits(NEW.DEGREE_ID);
--     END IF;
-- END$$
-- DELIMITER ;
-- create trigger to run when the DEGREE table is inserted into
-- the trigger will run the update_degree_credits procedure
-- DELIMITER $$
-- CREATE TRIGGER `update_degree_credits_trigger_insert`
-- BEFORE INSERT ON `DEGREE`
-- FOR EACH ROW
-- BEGIN
--     CALL update_degree_credits(NEW.DEGREE_ID);
-- END$$
-- DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `update_degree_all_credits`()
BEGIN
    -- call update_degree_credits for every row in DEGREE
    DECLARE done INT DEFAULT FALSE;
    DECLARE id INT;
    DECLARE cur CURSOR FOR SELECT DEGREE_ID FROM DEGREE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        CALL update_degree_credits(id);
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;
CREATE TABLE `BUILDING` (
    `BUILDING_ID` int NOT NULL AUTO_INCREMENT,
    `DEPT_ID` int NOT NULL, -- Foreign key to DEPARTMENT table
    `BUILDING_NAME` varchar(45) DEFAULT NULL,
    `BUILDING_ADDRESS` varchar(45) DEFAULT NULL,
    PRIMARY KEY (`BUILDING_ID`),
    FOREIGN KEY (`DEPT_ID`) REFERENCES DEPARTMENT(`DEPT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `STUDENT` (
    `STU_ID` int NOT NULL AUTO_INCREMENT,
    `PERSON_ID` int NOT NULL, -- Foreign key to PERSON table
    -- `DEPT_ID` int NOT NULL, -- Foreign key to DEPARTMENT table
    `STU_GPA` decimal(4,2) DEFAULT NULL,
    `STU_STANDING` varchar(45) DEFAULT NULL,
    `STU_GRADE_LEVEL` varchar(45) DEFAULT NULL,
    PRIMARY KEY (`STU_ID`),
    FOREIGN KEY (`PERSON_ID`) REFERENCES PERSON(`PERSON_ID`)
    -- FOREIGN KEY (`DEPT_ID`) REFERENCES DEPARTMENT(`DEPT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

----------------
-- PROCEDURES --
----------------


-- Update standing
-- From the current GPA, set it to the corresponding standing
-- If the student has no GPA, set the standing to "No Standing" (0)
-- If the student has a GPA of 3.5 or higher, set the standing to "Dean's List" (4)
-- If the student has a GPA of 2.5 or higher, set the standing to "Good Standing" (3)
-- If the student has a GPA of 2.0 or higher, set the standing to "Academic Probation" (2)
-- If the student has a GPA below 2.0, set the standing to "Academic Dismissal" (1)
DELIMITER $$
CREATE PROCEDURE `update_standing` (IN `stud_id` INT)
BEGIN
    DECLARE `gpa` DECIMAL(4,2);
    DECLARE `standing` VARCHAR(45);
    SET `gpa` = (SELECT `STU_GPA` FROM `STUDENT` WHERE `STU_ID` = `stud_id`);
    IF `gpa` IS NULL THEN
        SET `standing` = "No Standing";
    ELSEIF `gpa` >= 3.5 THEN
        SET `standing` = "Dean's List";
    ELSEIF `gpa` >= 2.5 THEN
        SET `standing` = "Good Standing";
    ELSEIF `gpa` >= 2.0 THEN
        SET `standing` = "Academic Probation";
    ELSE
        SET `standing` = "Academic Dismissal";
    END IF;
    UPDATE `STUDENT` SET `STU_STANDING` = `standing` WHERE `STU_ID` = `stu_id`;
END$$
-- call with `CALL update_standing(n);` where n is the student id
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS `update_all_standings`$$
CREATE PROCEDURE `update_all_standings` ()
BEGIN
    DECLARE `stud_id` INT;
    DECLARE `done` INT DEFAULT FALSE;
    DECLARE `cur` CURSOR FOR SELECT `STU_ID` FROM `STUDENT`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;
    OPEN `cur`;
    `loop`: LOOP
        FETCH `cur` INTO `stud_id`;
        IF `done` THEN
            LEAVE `loop`;
        END IF;
        CALL `update_standing`(`stud_id`);
    END LOOP `loop`;
    CLOSE `cur`;
END$$
DELIMITER ;
-- CALL `update_all_standings`();


DELIMITER $$
DROP PROCEDURE IF EXISTS `average_gpa`$$
CREATE PROCEDURE `average_gpa` (OUT `avg_gpa` DECIMAL(4,2))
BEGIN
    SELECT AVG(`STU_GPA`) INTO `avg_gpa` FROM `STUDENT`;
END$$
-- call with `CALL average_gpa(@avg_gpa);` then `SELECT @avg_gpa;`
DELIMITER ;
CREATE TABLE `PROFESSOR` (
  `PROF_ID` int NOT NULL AUTO_INCREMENT,
  `PERSON_ID` int NOT NULL, -- Can't be NULL (?), the professor must be a person -- Foreign key to PERSON table
  `DEPT_ID` int DEFAULT NULL, -- Foreign key to DEPARTMENT table
  `OFFICE_NUM` int DEFAULT NULL,
  `BUILDING_ID` int DEFAULT NULL, -- Foreign key to BUILDING table
  PRIMARY KEY (`PROF_ID`),
  FOREIGN KEY (`PERSON_ID`) REFERENCES PERSON(`PERSON_ID`),
  FOREIGN KEY (`BUILDING_ID`) REFERENCES BUILDING(`BUILDING_ID`),
  FOREIGN KEY (`DEPT_ID`) REFERENCES DEPARTMENT(`DEPT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `STU_DEGREE_LIST` (
    `STU_DEGREE_LIST_ID` int NOT NULL AUTO_INCREMENT,
    `STU_ID` int NOT NULL, -- Foreign key to STUDENT table
    `DEGREE_ID` int NOT NULL, -- Foreign key to DEGREE table
    `CREDITS_EARNED` int DEFAULT 0, -- This is the number of credits the student has earned towards this degree
    PRIMARY KEY (`STU_DEGREE_LIST_ID`),
    FOREIGN KEY (`STU_ID`) REFERENCES STUDENT(`STU_ID`),
    FOREIGN KEY (`DEGREE_ID`) REFERENCES DEGREE(`DEGREE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


----------------
-- PROCEDURES --
----------------

-- Update STU_GRADE_LEVEL in the STUDENT table
-- This is done as follows:
-- Certificate: year 1 to 1
-- Associate: year 1 to 2
-- Bachelor: year 1 to 4
-- Master: year 5 to 6
-- Doctorate: year 5 to 8
-- The student's year is determined by start_year of their degree type, + CREDITS_EARNED/DEGREE_CREDITS
-- If the student already has a year which is higher than the calculated year, then the year is not updated

DELIMITER $$
DROP PROCEDURE IF EXISTS `update_stu_grade_level`$$
CREATE PROCEDURE `update_stu_grade_level`(IN NEW_ID int)
BEGIN
    -- make variables for degree_type, year_level_start, credits_earned, and credits_required
    -- get the student's degree type
    SELECT DEGREE_TYPE, DEGREE_CREDITS INTO @degree_type, @degree_credits FROM DEGREE WHERE DEGREE_ID IN (SELECT DEGREE_ID FROM STU_DEGREE_LIST WHERE STU_ID = NEW_ID);
    -- set year_level_start to 1, unless it's a master or doctorate, then set it to 5
    IF @degree_type = 'Master' OR @degree_type = 'Doctorate' THEN
        SET @year_level_start = 5;
    ELSE
        SET @year_level_start = 1;
    END IF;
    IF @degree_type = 'Certificate' THEN
        SET @degree_length = 1;
    ELSEIF @degree_type = 'Associate' THEN
        SET @degree_length = 2;
    ELSEIF @degree_type = 'Bachelor' THEN
        SET @degree_length = 4;
    ELSEIF @degree_type = 'Master' THEN
        SET @degree_length = 2;
    ELSEIF @degree_type = 'Doctorate' THEN
        SET @degree_length = 4;
    END IF;
    -- get the student's credits earned
    SELECT MAX(CREDITS_EARNED) INTO @credits_earned FROM STU_DEGREE_LIST WHERE STU_ID = NEW_ID;
    -- credits_earned/degree_credits*degree_length + year_level_start
    SET @year_level = FLOOR(@credits_earned/@degree_credits*@degree_length) + @year_level_start;
    -- if the student's prior year level is null
    IF (SELECT STU_GRADE_LEVEL FROM STUDENT WHERE STU_ID = NEW_ID) IS NULL THEN
        UPDATE STUDENT SET STU_GRADE_LEVEL = @year_level WHERE STU_ID = NEW_ID;
    -- if the student's year level is higher than the calculated year level, then don't update it
    ELSEIF @year_level > (SELECT STU_GRADE_LEVEL FROM STUDENT WHERE STU_ID = NEW_ID) THEN
        UPDATE STUDENT SET STU_GRADE_LEVEL = @year_level WHERE STU_ID = NEW_ID;
    END IF;
END$$
DELIMITER ;
-- create a trigger to call the procedure when `CREDITS_EARNED` is updated in this table
DELIMITER $$
CREATE TRIGGER `update_stu_grade_level` AFTER UPDATE ON `STU_DEGREE_LIST`
FOR EACH ROW
BEGIN
    CALL update_stu_grade_level(NEW.STU_ID);
END$$
-- create a trigger to call the procedure when a new row is inserted into this table
DELIMITER $$
DROP TRIGGER IF EXISTS `update_stu_grade_level_after_insert`$$
CREATE TRIGGER `update_stu_grade_level_after_insert` AFTER INSERT ON `STU_DEGREE_LIST`
FOR EACH ROW
BEGIN
    CALL update_stu_grade_level(NEW.STU_ID);
END$$
DELIMITER ;
DELIMITER $$
DROP PROCEDURE IF EXISTS `update_all_stu_grade_levels`$$
CREATE PROCEDURE `update_all_stu_grade_levels`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id INT;
    DECLARE cur CURSOR FOR SELECT STU_ID FROM STUDENT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        CALL update_stu_grade_level(id);
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;
CREATE TABLE `CLASS` (
    `CLASS_ID` int NOT NULL AUTO_INCREMENT,
    `DEPT_ID` int NOT NULL, -- Foreign key to DEPARTMENT table
    `CLASS_NAME` varchar(45) DEFAULT NULL,
    `CLASS_NUMBER` varchar(45) DEFAULT NULL,
    `CLASS_YEAR` int DEFAULT NULL,
    `CLASS_SEMESTER` int DEFAULT NULL, -- 1 = Fall, 2 = Spring, 3 = Summer
    `CLASS_CREDITS` int DEFAULT 3,
    `CLASS_ROOM_NUM` int DEFAULT NULL,
    `BUILDING_ID` int DEFAULT NULL, -- Foreign key to BUILDING table
    `CLASS_TIME_SLOTS` int DEFAULT NULL, -- This would be likely a foreign key to a time slot table that would specify days and times of the class
    `PROF_ID` int DEFAULT NULL, -- Foreign key to PROFESSOR table
    PRIMARY KEY (`CLASS_ID`),
    FOREIGN KEY (`DEPT_ID`) REFERENCES DEPARTMENT(`DEPT_ID`),
    FOREIGN KEY (`BUILDING_ID`) REFERENCES BUILDING(`BUILDING_ID`),
    FOREIGN KEY (`PROF_ID`) REFERENCES PROFESSOR(`PROF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `ENROLLMENT` (
    `ENROLL_ID` int NOT NULL AUTO_INCREMENT,
    `STU_ID` int NOT NULL, -- Foreign key to STUDENT table
    `CLASS_ID` int NOT NULL, -- Foreign key to CLASS table
    `ENROLL_GRADE` decimal(4,2) DEFAULT NULL, -- Grade received in class, only if the semester is over. Otherwise it's the grade the professor has given the student so far.
    PRIMARY KEY (`ENROLL_ID`),
    FOREIGN KEY (`STU_ID`) REFERENCES STUDENT(`STU_ID`),
    FOREIGN KEY (`CLASS_ID`) REFERENCES CLASS(`CLASS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


----------------
-- PROCEDURES --
----------------

-- student triggers placed here because they need ENROLLMENT table to exist

-- Update GPA
-- search enrollment table for student id, the sum of the grades, and the count of the grades, then divide the sum by the count to get the GPA
-- update the student table with the new GPA
-- if the student has no grades, set the GPA to 0
DELIMITER $$
CREATE PROCEDURE `update_gpa` (IN `stud_id` INT)
BEGIN
    DECLARE `gpa` DECIMAL(4,2);
    DECLARE `grade_sum` DECIMAL(4,2);
    DECLARE `grade_count` INT;
    SET `grade_sum` = (SELECT SUM(`ENROLL_GRADE`) FROM `ENROLLMENT` WHERE `STU_ID` = `stud_id` AND `ENROLL_GRADE` IS NOT NULL);
    SET `grade_count` = (SELECT COUNT(`ENROLL_GRADE`) FROM `ENROLLMENT` WHERE `STU_ID` = `stud_id` AND `ENROLL_GRADE` IS NOT NULL);
    IF `grade_count` = 0 THEN
        SET `gpa` = 0;
    ELSE
        SET `gpa` = `grade_sum` / `grade_count`;
    END IF;
    UPDATE `STUDENT` SET `STU_GPA` = `gpa` WHERE `STU_ID` = `stud_id`;
END$$
-- run with `CALL update_gpa(n);` where n is the student id
-- create trigger to run when the ENROLLMENT table is updated and it's the student's id that is updated in the STU_ID field
-- the trigger will run the update_gpa procedure

DELIMITER $$
DROP PROCEDURE IF EXISTS `update_all_gpa`$$
CREATE PROCEDURE `update_all_gpa` ()
BEGIN
    -- loop through each student id, and if the student has no grades, set the GPA to 0
    -- else, call the update_gpa procedure
    DECLARE `stud_id` INT;
    DECLARE `grade_count` INT;
    DECLARE `grade_sum` DECIMAL(4,2);
    DECLARE `gpa` DECIMAL(4,2);
    DECLARE `done` INT DEFAULT FALSE;
    DECLARE `cur` CURSOR FOR SELECT `STU_ID` FROM `STUDENT`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;
    OPEN `cur`;
    `loop`: LOOP
        FETCH `cur` INTO `stud_id`;
        IF `done` THEN
            LEAVE `loop`;
        END IF;
        SET `grade_count` = (SELECT COUNT(`ENROLL_GRADE`) FROM `ENROLLMENT` WHERE `STU_ID` = `stud_id` AND `ENROLL_GRADE` IS NOT NULL);
        IF `grade_count` = 0 THEN
            SET `gpa` = 0;
        ELSE
            SET `grade_sum` = (SELECT SUM(`ENROLL_GRADE`) FROM `ENROLLMENT` WHERE `STU_ID` = `stud_id` AND `ENROLL_GRADE` IS NOT NULL);
            SET `gpa` = `grade_sum` / `grade_count`;
        END IF;
        UPDATE `STUDENT` SET `STU_GPA` = `gpa` WHERE `STU_ID` = `stud_id`;
    END LOOP `loop`;
    CLOSE `cur`;
END$$
DELIMITER ;

-- INSERT statements

-- Order to insert data into tables:
    -- Person || Department
    -- Degree || Building || Student
    -- Professor || Stu_degree_list
    -- Class
    -- Enroll
    -- Calculate GPAs for each student with a function? Or just throw some numbers in there?

-- NOTE:
    -- I have not included any of the primary keys ({table}_id), as they are marked as auto-incrementing in the CREATE TABLE statements
    -- This sets them to 1, and for each new row, it increments by 1
    -- To use a key/id from a table as a FK for another table, simply count which row you want to use, and use that number as the ID, starting at 1

-- ----- PERSON -------
LOCK TABLES `PERSON` WRITE;
INSERT INTO `PERSON`(PERSON_FNAME, PERSON_LNAME, PERSON_EMAIL, PERSON_PHONE, PERSON_ADDR)
VALUES ('John', 'Doe', 'johndoe@gmail.com', '2109876543', '123 lane'),
    ('Bob', 'Smith', 'bobsmith@outlook.com', '2101234567', '124 lane'),
    ('Haley', 'H', 'haleyh@gmail.com', '2108376432', '126 lane'),
    ('Jalen', 'G', 'gjalen@outlook.com', '2102439173', '127 lane'),
    ('Chloe', 'Smith', 'chloesmith@gmail.com', '2102439786', '124 lane'),
    ('Jude', 'Flight', 'cjflight@gmail.com', '2102491733', '128 lane'),
    ('Denise', 'Dumner', 'denised@gmail.com', '2109224391', '129 lane'),
    ('Ava', 'Smith', 'avasmith@gmail.com', '1234567890', '123 Main St'),
    ('Emma', 'Johnson', 'emmajohnson@gmail.com', '2345678901', '234 Elm St'),
    ('Olivia', 'Williams', 'oliviawilliams@gmail.com', '3456789012', '345 Oak St'),
    ('Timmy', 'Zu', 'timmyzu@gmail.com', '2102347364', '125 lane'),
    ('Sophia', 'Brown', 'sophiabrown@gmail.com', '4567890123', '456 Pine St'),
    ('Isabella', 'Jones', 'isabellajones@gmail.com', '5678901234', '567 Maple St'),
    ('Mia', 'Miller', 'miamiller@gmail.com', '6789012345', '678 Birch St'),
    ('Charlotte', 'Davis', 'charlottedavis@gmail.com', '7890123456', '789 Cedar St'),
    ('Amelia', 'Garcia', 'ameliagarcia@gmail.com', '8901234567', '890 Walnut St'),
    ('Harper', 'Rodriguez', 'harperrodriguez@gmail.com', '9012345678', '901 Chestnut St'),
    ('Evelyn', 'Wilson', 'evelynwilson@gmail.com', '0123456789', '012 Cherry St'),
    ('Abigail', 'Anderson','abigailanderson@gmail.com','1234567890','123 Apple St'),
    ('Emily','Taylor','emilytaylor@gmail.com','2345678901','234 Peach St'),
    ('Elizabeth','Moore','elizabethmoore@gmail.com','3456789012','345 Plum St'),
    ('Sofia','Jackson','sofiajackson@gmail.com','4567890123','456 Pear St'),
    ('Avery','Martin','averymartin@gmail.com','5678901234','567 Orange St'),
    ('Ella','Lee','ellalee@gmail.com','6789012345','678 Grapefruit St'),
    ('Scarlett','Perez','scarlettperez@gmail.com','7890123456','789 Lemon St'),
    ('Grace','Thompson','gracethompson@gmail.com','8901234567','890 Lime St'),
    ('Victoria','White','victoriawhite@gmail.com','9012345678','901 Kiwi St'),
    ('Riley','Harris','rileyharris@gmail.com' ,'0123456789' ,'012 Mango St'),
    ('Aria' ,'Clark' ,'ariaclark@gmail.com' ,'1234567890' ,'123 Papaya St'),
    ('Lily' ,'Lewis' ,'lilylewis@gmail.com' ,'2345678901' ,'234 Pineapple St'),
    ('Chloe' ,'Nelson' ,'chloenelson@gmail.com' ,'3456789012' ,'345 Banana St'),
    ('Layla' ,'Carter' ,'laylacarter@gmail.com' ,'4567890123' ,'456 Strawberry St'),
    ('Natalie' ,'Mitchell' ,'nataliemitchell@gmail.com' ,'5678901234' ,'567 Raspberry St'),
    ('Savannah' ,'Perez' ,'savannahperez@gmail.com' ,'6789012345' ,'678 Blueberry St'),
    ('Leah' ,'Roberts' ,'leahroberts@gmail.com' ,'7890123456' ,'789 Blackberry St'),
    ('Audrey' ,'Turner' ,'audreyturner@gmail.com' ,'8901234567' ,'890 Cranberry St'),
    ('Allison' ,'Phillips' ,'allisonphillips@gmail.com' ,'9012345678' ,'901 Cherry St'),
    ('Anna' ,'Campbell' ,'annacampbell@gmail.com' ,'5252562244' ,'567 Raspberry St'), -- #38
    ('Isabella' ,'Inman' ,'isabella.inman@gmail.com' ,'5255559512' ,'123 lane'),
    ('Connie', 'Vigue', 'ConnieCVigue@gmail.com', '8053650871', '413 Turtle Crest Dr' ),
    ('Tahi-Popa', 'Wikiriwhi', 'TahiPopaWikiriwhi@gmail.com', '9411326663', '967 Raspberry St'),
    ('Elizabeth', 'Cryer', 'Ecryer@gmail.com', '9281497351', '112 lane' ),
    ('George', 'Jones', 'georgejones@gmail.com', '5551235734', '123 Main St'),
    ('Jane', 'Smith', 'jane.smith@gmail.com', '3455673578', '456 Elm St'),
    ('Bob', 'Johnson', 'bob.johnson@gmail.com', '1577458765', '789 Oak St'),
    ('Alice', 'Williams', 'alice.williams@gmail.com', '3556554321', '321 Pine St'),
    ('Charlie', 'Brown', 'charlie.brown@gmail.com', '5365552468', '246 Maple St'),
    ('Dave', 'Davis', 'dave.davis@gmail.com', '4551357', '357 Cedar St'),
    ('Emily', 'Evans', 'emily.evans@gmail.com', '4255557531', '531 Birch St');
-- ( {PERSON_FNAME},     {PERSON_LNAME},    {PERSON_EMAIL},     {PERSON_PHONE},     {PERSON_ADDR} ),

UNLOCK TABLES;


-- ----- DEPARTMENT -------
LOCK TABLES `DEPARTMENT` WRITE;
INSERT INTO `DEPARTMENT`(DEPT_NAME)
VALUES('Architecture'),
	('Astronomy and Astrophysics'),
    ('Neuroscience'),
    ('Integrative Biology'),
    ('Earth and Planetary Sciences'),
    ('Business'),
    ('Computer Science'),
    ('Engineering'),
    ('Fine Arts'),
    ('Foreign Language'),
    ('History'),
    ('Humanities & Sciences'),
    ('Information Systems'),
    ('Law'),
    ('Liberal Arts'),
    ('Mathematics'),
    ('Medicine'),
    ('Molecular Microbiology and Immunology'),
    ('Energy & Utility Management'),
    ('Contract & Support Services'),
    ('Facilities Leadership Team'),
    ('Operations & Maintenance'),
    ('Business & Customer Services'),
    ('Political Science and Geography'),
    ('Philosophy and Classics');


UNLOCK TABLES;


-- ----- DEGREE -------
LOCK TABLES `DEGREE` WRITE;
INSERT INTO `DEGREE`(DEGREE_NAME, DEGREE_TYPE, DEPT_ID, DEGREE_GPA, CATALOG_YEAR, YEAR_STARTED, YEAR_COMPLETED /* NULL if not completed */)
VALUES('Computer Science', 'Bachelor', '7', '4.0', '2020', '2020', NULL),
    ('Mathematics', 'Bachelor', '16', '4.0', '2019', '2019', NULL),
    ('Spanish', 'Bachelor', '3', '3.5', '2021', '2021', NULL),
    ('Computer Science', 'Bachelor', '2', '3.2', '2019', '2019', '2023'),
    ('Art', 'Bachelor', '15', '2.9', '2020', '2016', '2020'),
    ('Computer Engineering', 'Bachelor', '8', '3.8', '2021', '2019', NULL),
    ('Computer Science', 'Master', '7', '4.0', '2022', '2022', NULL),
    ('Business Administration', 'Master', '6', '3.6', '2023', '2023', NULL),
    ('Philosophy', 'Bachelor', '26', '3.9', '2022', '2022', NULL),
    ('Political Science', 'Bachelor', '24', '3.2', '2020', '2020', NULL),
    ('History', 'Master', '11', '3.7', '2021', '2021', NULL),
    ('Information Systems', 'Bachelor', '13', '3.5', '2020', '2020', NULL),
    ('Neuroscience', 'Doctorate', '4', '4.0', '2022', '2018', '2022'),
    ('Mechanical Engineering', 'Bachelor', '8', '3.3', '2019', '2019', NULL),
    ('Biology', 'Bachelor', '4', '3.8', '2021', '2021', NULL),
    ('Environmental Science', 'Master', '5', '3.6', '2022', '2022', NULL),
    ('Physics', 'Doctorate', '2', '4.0', '2023', '2019', '2023'),
    ('Computer Science', 'Associate', '7', '3.5', '2020', '2020', NULL),
    ('Fine Arts', 'Bachelor', '9', '3.2', '2019', '2019', NULL),
    ('Energy Management', 'Certificate', '19', '3.7', '2021', '2021', NULL),
    ('Facilities Management', 'Associate', '21', '3.5', '2020', '2020', NULL),
    ('Business', 'Bachelor', '6', '3.9', '2022', '2022', NULL),
    ('Architecture', 'Bachelor', '0', '0', NULL, NULL, NULL),
    ('Astronomy and Astrophysics', 'Bachelor', '0', '0', NULL, NULL, NULL),
    ('Neuroscience, Developmental and Regenerative Biology', 'Bachelor', '0', '0', NULL, NULL, NULL);


UNLOCK TABLES;


-- ----- BUILDING -------
LOCK TABLES `BUILDING` WRITE;
INSERT INTO `BUILDING`(DEPT_ID, BUILDING_NAME, BUILDING_ADDRESS)
VALUES('1', 'West', '1 Xavier ln'),
    ('2', 'North', '2 Xavier ln'),
    ('3', 'East', '3 Xavier ln'),
    ('4', 'South', '4 Xavier ln'),
    ('5', 'A1', '5 Xavier ln'),
    ('6', 'A2', '6 Xavier ln'),
    ('7', 'A3', '7 Xavier ln'),
    ('8', 'A4', '8 Xavier ln'),
    ('9', 'A5', '9 Xavier ln'),
    ('10', 'A6', '10 Xavier ln'),
    ('11', 'A7', '11 Xavier ln'),
    ('12', 'A8', '12 Xavier ln'),
    ('13', 'A9', '13 Xavier ln'),
    ('14', 'B1', '14 Xavier ln'),
    ('15', 'B2', '15 Xavier ln'),
    ('16', 'B3', '16 Xavier ln'),
    ('17', 'B4', '17 Xavier ln'),
    ('18', 'B5', '18 Xavier ln'),
    ('19', 'B6', '19 Xavier ln'),
    ('20', 'B7', '20 Xavier ln'),
    ('21', 'B8', '21 Xavier ln'),
    ('22', 'B9', '22 Xavier ln'),
    ('23', 'C1', '23 Xavier ln'),
    ('24', 'C2', '24 Xavier ln');

UNLOCK TABLES;

-- ----- STUDENT -------
-- just did EVEN PERSON_ID for student (odd for professor)
LOCK TABLES `STUDENT` WRITE;
INSERT INTO `STUDENT`(PERSON_ID)
VALUES('1'), ('2'), ('3'), ('4'), ('5'),
    ('6'), ('7'), ('8'), ('9'), ('10'),
    ('11'), ('12'), ('13'), ('14'), ('15'),
    ('16'), ('17'), ('18'), ('19'), ('20'),
    ('21'), ('22'), ('23'), ('24'), ('25');


UNLOCK TABLES;

-- ----- PROFESSOR -------
-- just did odd PERSON_ID for prefessor (even for student)
LOCK TABLES `PROFESSOR` WRITE;
INSERT INTO `PROFESSOR`(PERSON_ID, DEPT_ID, OFFICE_NUM, BUILDING_ID)
VALUES('26', '1', '1', '1'),
    ('27', '2', '2', '2'),
    ('28', '3', '3', '3'),
    ('29', '4', '9', '4'),
    ('30', '5', '10', '5'),
    ('31', '6', '11', '6'),
    ('32', '7', '12', '7'),
    ('33', '8', '13', '18'),
    ('34', '9', '14', '19'),
    ('35', '10', '15', '20'),
    ('36', '11', '16', '21'),
    ('37', '12', '4', '22'),
    ('38', '13', '5', '23'),
    ('39', '14', '6', '24'),
    ('40', '15', '7', '8'),
    ('41', '16', '8', '9'),
    ('42', '17', '17', '10'),
    ('43', '18', '18', '11'),
    ('44', '19', '19', '12'),
    ('45', '20', '20', '13'),
    ('46', '21', '24', '14'),
    ('47', '22', '23', '15'),
    ('48', '23', '22', '16'),
    ('49', '24', '21', '17');

UNLOCK TABLES;

-- ----- STU DEGREE LIST -------
LOCK TABLES `STU_DEGREE_LIST` WRITE;
INSERT INTO `STU_DEGREE_LIST`(STU_ID, DEGREE_ID, CREDITS_EARNED)
VALUES('1', '1', '60'),
    ('2', '2', '110'),
    ('3', '3', '80'),
    ('4', '4', '120'),
    ('5', '5', '120'),
    ('6', '6', '128'),
    ('7', '7', '32'),
    ('8', '8', '96'),
    ('9', '9', '112'),
    ('10', '10', '104'),
    ('11', '11', '72'),
    ('12', '12', '128'),
    ('13', '13', '80'),
    ('14', '14', '120'),
    ('15', '15', '108'),
    ('16', '16', '116'),
    ('17', '17', '136'),
    ('18', '18', '24'),
    ('19', '19', '36'),
    ('20', '20', '48'),
    ('21', '21', '80'),
    ('22', '22', '80'),
    ('23', '23', '96'),
    ('24', '24', '112'),
    ('25', '25', '72');

UNLOCK TABLES;


-- ----- CLASS -------
LOCK TABLES `CLASS` WRITE;
INSERT INTO `CLASS`(DEPT_ID, CLASS_NAME, CLASS_NUMBER, CLASS_YEAR, CLASS_SEMESTER, CLASS_CREDITS, CLASS_ROOM_NUM, BUILDING_ID, CLASS_TIME_SLOTS, PROF_ID)
VALUES('2', 'Databases', '0001', '2023', '1', '3', '1', '2', '10', '1'),
    ('4', 'Spanish', '0002', '2023', '1', '3', '2', '4', '10', '1'),
    ('2', 'Astronomy 101', '101', '2023', '1', '3', '101', '1', '12', '14'),
    ('5', 'Geology Lab', '201L', '2023', '3', '1', '102', '5', '2', '6'),
    ('12', 'Introduction to World History', '101', '2023', '2', '3', '201', '11', '10', '2'),
    ('21', 'Operations Management', '301', '2023', '1', '4', '101', '8', '9', '19'),
    ('3', 'Developmental Biology', '301', '2023', '2', '3', '201', '2', '3', '7'),
    ('8', 'Oil Painting', '201', '2023', '3', '3', '101', '9', '14', '23'),
    ('11', 'Ancient Greek Literature', '301', '2023', '1', '3', '107', '6', '12', '11'),
    ('18', 'Organic Chemistry Lab', '301L', '2023', '2', '1', '107', '16', '20', '17'),
    ('1', 'Architecture Studio I', '101', '2023', '3', '3', '105', '1', '12', '4'),
    ('22', 'Human Resource Management', '401', '2023', '1', '3', '201', '8', '11', '18'),
    ('7', 'Web Programming', '301', '2023', '2', '3', '205', '4', '10', '20'),
    ('14', 'Jazz', '101', '2023', '3', '3', '204', '12', '2', '9'),
    ('9', 'Ceramics', '201', '2023', '1', '3', '301', '5', '9', '24'),
    ('25', 'Philosophy of Science', '401', '2023', '2', '3', '101', '19', '17', '15'),
    ('15', 'Legal Writing', '201', '2023', '3', '3', '101', '13', '18', '8'),
    ('13', 'Principles of Marketing', '301', '2023', '1', '3', '203', '11', '16', '13'),
    ('10', 'Sculpture', '201', '2023', '2', '3', '202', '6', '14', '22'),
    ('6', 'Database Systems', '301', '2023', '3', '3', '101', '3', '11', '21'),
    ('17', 'Physical Chemistry', '401', '2023', '1', '4', '201', '15', '3', '16'),
    ('19', 'Organic Chemistry', '401', '2023', '2', '3', '201', '16', '9', '17'),
    ('20', 'Inorganic Chemistry', '401', '2023', '1', '3', '201', '16', '10', '17'),
    ('16', 'Criminal Law', '201', '2023', '2', '3', '103', '14', '9', '10'),
    ('23', 'Business Law', '401', '2023', '3', '3', '207', '18', '3', '12'),
    ('24', 'Ethics', '401', '2023', '1', '3', '209', '19', '1', '15');
-- Use random numbers for the time slots. It's a fake foreign key, so the actual value doesn't mean anything right now

UNLOCK TABLES;


-- ----- ENROLLMENT -------
LOCK TABLES `ENROLLMENT` WRITE;
INSERT INTO `ENROLLMENT` (STU_ID, CLASS_ID, ENROLL_GRADE)
VALUES('1', '1', '4.0'), ('1', '3', '3.2'),
    ('2', '6', '2.9'), ('3', '17', '3.6'),
    ('4', '8', '3.8'), ('5', '2', '2.6'),
    ('6', '19', '4.0'), ('7', '25', '3.4'),
    ('8', '20', '3.5'), ('9', '9', '3.1'),
    ('10', '21', '2.5'), ('11', '11', '3.9'),
    ('12', '10', '3.3'), ('13', '26', '3.7'),
    ('14', '7', '2.8'), ('15', '22', '3.0'),
    ('16', '14', '3.5'), ('17', '12', '3.2'),
    ('18', '13', '3.9'), ('19', '24', '2.7'),
    ('20', '4', '3.3'), ('21', '1', '3.8'),
    ('22', '16', '3.4'), ('23', '15', '2.9'),
    ('24', '5', '3.1'), ('25', '26', '3.7'),
    ('1', '2', '2.9'), ('2', '13', '3.7'),
    ('3', '7', '3.3'), ('4', '11', '3.8'),
    ('5', '15', '3.5'), ('6', '10', '2.8'),
    ('7', '17', '3.9'), ('8', '6', '2.5'),
    ('9', '19', '3.2'), ('10', '22', '3.0'),
    ('11', '16', '2.6'), ('12', '8', '3.4'),
    ('13', '18', '3.1'), ('14', '4', '2.7'),
    ('15', '20', '3.5'), ('16', '21', '2.9'),
    ('17', '24', '3.8'), ('18', '1', '3.6'),
    ('19', '9', '3.0'), ('20', '14', '3.3'),
    ('21', '25', '3.9'), ('22', '12', '3.5'),
    ('23', '3', '2.8'), ('24', '23', '3.2'),
    ('25', '5', '2.5'), ('25', '4', '3.5');
UNLOCK TABLES;


-- adding here to avoid error while setting up tables
DELIMITER $$
CREATE TRIGGER `update_gpa_trigger` AFTER UPDATE ON `ENROLLMENT`
FOR EACH ROW
BEGIN
    IF NEW.`STU_ID` = OLD.`STU_ID` THEN
        CALL update_gpa(NEW.`STU_ID`);
    END IF;
END$$
-- create trigger to run when an entry is inserted into the ENROLLMENT table
-- the trigger will run the update_gpa procedure
DELIMITER $$
CREATE TRIGGER `update_gpa_trigger_insert` AFTER INSERT ON `ENROLLMENT`
FOR EACH ROW
BEGIN
    CALL update_gpa(NEW.`STU_ID`);
END$$
DELIMITER ;


-- ----- UPDATE TABLES AS NEEDED -------
CALL update_all_gpa();
CALL update_standing(1);
CALL update_degree_all_credits();
CALL update_all_stu_grade_levels();
