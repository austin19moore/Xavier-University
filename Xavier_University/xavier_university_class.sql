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
