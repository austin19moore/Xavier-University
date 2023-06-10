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
