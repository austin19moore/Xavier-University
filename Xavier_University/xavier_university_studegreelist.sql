
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
