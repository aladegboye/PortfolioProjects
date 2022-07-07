-- CREATE DATABASE Ahoy_1614072
-- GO
USE Ahoy_1614072

IF OBJECT_ID('Pillage', 'U') IS NOT NULL
DROP TABLE Pillage
GO

IF OBJECT_ID ('Pirate', 'U') IS NOT NULL
DROP TABLE Pirate
GO

IF OBJECT_ID('Boat', 'U') IS NOT NULL
DROP TABLE Boat
GO

IF OBJECT_ID('Booty', 'U') IS NOT NULL
DROP TABLE Booty
GO

CREATE TABLE Pirate(
  p_code NCHAR(6),
  p_name NVARCHAR(30),
  no_legs INT,
  no_eyes INT,
  origin NVARCHAR(30),
  CONSTRAINT pk_Pirates PRIMARY KEY(p_code))

CREATE TABLE Boat(
  b_code NCHAR(6),
  b_name NVARCHAR(50),
  b_type NVARCHAR(50),
  origin NVARCHAR(30),
  CONSTRAINT pk_Boat PRIMARY KEY(b_code) 
)

CREATE TABLE Booty(
  bt_code NCHAR(6),
  bt_name NVARCHAR(50),
  value INT,
  CONSTRAINT pk_Booty PRIMARY KEY(bt_code)
)

CREATE TABLE Pillage(
  pillage_code NCHAR(6),
  p_code NCHAR(6),
  b_code NCHAR(6),
  bt_code NCHAR(6),
  p_date DATE,
  CONSTRAINT pk_Pillage PRIMARY KEY(pillage_code),
  CONSTRAINT fk_Pillage_Pirate FOREIGN KEY(p_code) REFERENCES Pirate(p_code) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Pillage_Boat FOREIGN KEY(b_code) REFERENCES Boat(b_code) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_Pillage_Booty FOREIGN KEY(bt_code) REFERENCES Booty(bt_code) ON DELETE CASCADE ON UPDATE CASCADE
)
 
 INSERT INTO Pirate 
 VALUES('p1', 'Blue Peter', 2,2,'British'), ('p2', 'One-Eyed Jack', 2,1,'American'), ('p3', 'Black Jack', 1,2,'Spanish'), ('p4', 'Blind Pierre', 2, 0,'French');

 INSERT INTO Boat
 VALUES('b1', 'Saucey Sue', 'Barque', 'British'),('b2', 'Hispaniola', 'Spanish Galleon', 'Spanish'),('b3', 'Narcissus', 'Clipper', 'American'),
 ('b4', 'Don Fanucci', 'Merchantman', 'Italian'),('b5', 'Reine de la Mar', 'Merchantman', 'French'), ('b6', 'Conquistador', 'Spanish Galleon', 'Spanish'),
('b7', 'Ubiquitous', 'Man O''War', 'British'),('b8', 'Chrysos', 'Argosy', 'Spanish');

INSERT INTO Booty
VALUES('bt1', 'Oriental Spices', 10000), ('bt2', 'Silver Plate', 50000), ('bt3', 'Gold Sovereigns', 80000), ('bt4', 'Gold Dubloons', 55000), ('bt5', 'Bags of Turnip', 100),
('bt6', 'Chests of Tea', 10000), ('bt7', 'Precious Gems', 100000), ('bt8', 'Nothing', 0), ('bt9', 'Weevil-Ridden Biscuits', 10), ('bt10', 'Barrels of Pemmican', 2000),
('bt11', 'Fresh Fruit', 10000), ('bt12', 'Rotten Fruit', 100);

INSERT INTO Pillage
VALUES ('pge1', 'p1', 'b1', 'bt5', '1735/07/06'), ('pge2', 'p1', 'b1', 'bt8', '1735/07/07'),('pge3', 'p2', 'b3', 'bt1', '1745/05/08'),
('pge4', 'p2', 'b3', 'bt2', '1745/05/08'),('pge5', 'p2', 'b3', 'bt6', '1745/05/08'),('pge6', 'p3', 'b5', 'bt2', '1750/08/08'),
('pge7', 'p3', 'b5', 'bt3', '1750/08/08'),('pge8', 'p4', 'b5', 'bt8', '1750/08/09'),('pge9', 'p4', 'b2', 'bt4', '1743/06/30'),
('pge10', 'p4', 'b2', 'bt7', '1743/06/30'), ('pge11', 'p4', 'b5', 'bt3', '1744/09/10');


SELECT * FROM Pirate;
SELECT * FROM Boat;

SELECT * FROM Booty
ORDER BY value;

SELECT b_name, b_type, origin
FROM Boat
WHERE origin = 'Spanish';

SELECT * FROM Pirate
WHERE p_name LIKE 'B%';

SELECT p_name
FROM Pirate
WHERE (no_legs < 2) OR (no_eyes<2);

SELECT * 
FROM Booty
WHERE bt_name LIKE 'Gold%';

SELECT * 
FROM Pillage
WHERE (p_code = 'p1') AND (p_date>'1742/12/31');

SELECT p_name, Pillage.bt_code
FROM Pirate, Pillage
WHERE Pirate.p_code = Pillage.p_code
AND Pillage.bt_code = 'bt3';

SELECT p_name, Booty.bt_name
FROM Pirate, Pillage, Booty
WHERE Pirate.p_code = Pillage.p_code
AND Booty.bt_code = Pillage.bt_code
AND Booty.bt_name = 'Gold Dubloons';

SELECT DISTINCT b_name
FROM Boat, Pillage
WHERE Boat.b_code = Pillage.b_code
AND (p_date >= '1740/01/01') AND (p_date <'1750/01/01');

SELECT DISTINCT b_name, Pirate.origin
FROM Boat, Pillage, Pirate
WHERE Boat.b_code = Pillage.b_code
AND Pirate.p_code = Pillage.p_code
AND ((Pirate.origin = 'French') OR (Pirate.origin = 'Spanish'));

SELECT DISTINCT b_name, Pirate.origin, Booty.bt_name
FROM Boat, Pillage, Pirate, Booty
WHERE Boat.b_code = Pillage.b_code
AND Pirate.p_code = Pillage.p_code
AND Booty.bt_code = Pillage.bt_code
AND ((Pirate.origin = 'French') OR (Pirate.origin = 'Spanish'))
AND ((bt_name = 'Silver Plate') OR (bt_name = 'Gold Dubloons'));

SELECT * FROM Boat;

SELECT origin, COUNT(*) AS origin_count
FROM Boat
GROUP BY origin;

SELECT * FROM Booty;

SELECT Boat.b_name, SUM(Booty.value) AS booty_value 
FROM Boat, Booty, Pillage
WHERE Boat.b_code = Pillage.b_code
AND Booty.bt_code = Pillage.bt_code
GROUP BY Boat.b_name;

SELECT Boat.b_name, SUM(Booty.value) AS booty_value, COUNT(Pillage.b_code) AS no_times_pillaged 
FROM Boat, Booty, Pillage
WHERE Boat.b_code = Pillage.b_code
AND Booty.bt_code = Pillage.bt_code
GROUP BY Boat.b_name
HAVING COUNT(Pillage.b_code)>2;
