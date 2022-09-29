DROP TABLE IF EXISTS _2, _1
CREATE TABLE _1 (
    StatChar char(1) PRIMARY KEY,
    StatStatus varchar(20) NOT NULL 
    );

CREATE TABLE _2 (
    StatChar CHAR(1) NULL REFERENCES _1(StatChar)
            ON UPDATE SET NULL
    );

INSERT INTO _1 (StatChar, StatStatus)
    VALUES ('A', 'A-Status'), ('B', 'B-Status');
INSERT INTO _2 VALUES ('A'), ('B');

SELECT * FROM _2;

UPDATE _1 SET 
    StatChar = 'C',
    StatStatus = 'C-Status'
WHERE StatChar = 'B'; 

SELECT * FROM _2;
