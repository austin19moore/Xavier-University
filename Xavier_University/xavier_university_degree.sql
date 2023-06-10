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
