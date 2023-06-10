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

