drop table "Ship"; 
CREATE TABLE "Ship"
(
      ID INT NOT NULL constraint pk_ship primary key, 
      NAME CHAR(50),
      CAPACITY INT,
      TONNAGE DOUBLE PRECISION
);
exit;