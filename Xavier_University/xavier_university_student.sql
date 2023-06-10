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
