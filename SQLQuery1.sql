CREATE DATABASE HotelDatabase

USE HotelDatabase

CREATE TABLE Hotels(
Id int PRIMARY KEY IDENTITY (1,1),
HotelName nvarchar(100) NOT NULL,
)

INSERT INTO Hotels(HotelName) VALUES
('LeMeridien Lav'),
('Sunce'),
('Plaza'),
('Marjan'),
('San Antonio')

CREATE TABLE Rooms(
Id int PRIMARY KEY IDENTITY(1,1),
RoomNumber int,
HotelId int FOREIGN KEY REFERENCES Hotels(Id),
Category nvarchar(100) NOT NULL,
Capacity int NOT NULL,
Price decimal(10,2) NOT NULL
)

INSERT INTO Rooms(RoomNumber ,HotelId ,Category, Capacity, Price) VALUES
(1000, 1, 'Presidential', 5, 6000.00),
(512, 1, 'Room', 2, 900.00),
(210, 2, 'Room', 2, 600.00),
(500, 2, 'Suite', 3, 800.00),
(420, 3, 'Room', 2, 950.00),
(700, 3, 'Suite', 4, 4300.50),
(110, 4, 'Room', 2, 550.00),
(120, 4, 'Room', 2, 550.00),
(303, 5, 'Room', 2, 400.00),
(102, 5, 'Room', 2, 400.00)


CREATE TABLE Employees(
Id int PRIMARY KEY IDENTITY(1,1),
HotelId int FOREIGN KEY REFERENCES Hotels(Id),
FirstName nvarchar(50) NOT NULL,
LastName nvarchar(50) NOT NULL,
JobDescription nvarchar(100) NOT NULL
)

INSERT INTO Employees(FirstName, LastName, HotelId, JobDescription) VALUES
('Gabrijel','Videc', 1,'Room service supervisor'),
('Ante', 'Šarić', 1, 'Cleaner'),
('Ivo','Andrić', 2,'Room service supervisor'),
('Joško','Batina', 2,'Cleaner'),
('Antonela','Kristić', 3,'Room service supervisor'),
('Tina','Turner', 3,'Cleaner'),
('Mate','Ivanišević', 4,'Room service supervisor'),
('Mate','Matić', 4,'Cleaner'),
('Ivan','Jujnović', 5,'Room service supervisor'),
('Danijela','Jukić', 5,'Cleaner')

CREATE TABLE Guests(
Id int PRIMARY KEY IDENTITY(1,1),
FirstName nvarchar(100) NOT NULL,
LastName nvarchar(100) NOT NULL
)

INSERT INTO Guests(FirstName, LastName) VALUES
('Stipe','Stipić'),
('Josip','Josipović'),
('Jeff','Daniels'),
('Bob','Dylan'),
('Ivo','Ivić')

CREATE TABLE Purchases(
Id int PRIMARY KEY IDENTITY(1,1),
GuestId int FOREIGN KEY REFERENCES Guests(Id),
HotelId int FOREIGN KEY REFERENCES Hotels(Id),
RoomId int FOREIGN KEY REFERENCES Rooms(Id),
ServiceType nvarchar(50) NOT NULL,
CheckinTime datetime2 NOT NULL,
CheckoutTime datetime2 NOT NULL,
BookTime datetime2 NOT NULL,
PriceTotal decimal(10,2),
TransactionTime datetime2
)

INSERT INTO Purchases(RoomId, GuestId, ServiceType, BookTime, CheckinTime, CheckoutTime, TransactionTime, PriceTotal) VALUES
(1, 1, 'Noćenje','2019-12-05 18:22', '2020-01-03 10:00', '2020-01-10 12:00', GETDATE(), 60000.00),
(4, 2, 'Pansion','2020-01-05 18:22', '2020-02-04 10:00', '2020-02-11 12:00', '2020-02-12 16:45', 9000.00),
(4, 2, 'Pansion','2019-01-05 18:22', '2019-02-04 10:00', '2019-02-06 12:00', '2019-02-12 16:45', 1600.00),
(5, 3, 'Polupansion','2020-02-29 18:22', '2020-03-05 10:00', '2020-03-12 12:00', '2020-03-12 13:28', 10000.00),
(8, 4, 'Noćenje','2019-12-05 18:22', '2020-04-06 10:00', '2020-04-13 12:00', GETDATE(), 5500.00),
(9, 5, 'Polupansion','2019-12-05 18:22', '2018-08-15 10:00', '2018-08-30 12:00', '2018-08-31 13:20', 4300.00),
(7, 2, 'Nocenje','2019-12-05 18:22', '2020-12-20 10:00', '2021-01-03 12:00','' , 7700.00)


CREATE TABLE RoomService(
Id int PRIMARY KEY IDENTITY (1,1),
EmployeeId int FOREIGN KEY REFERENCES Employees(Id),
RoomId int FOREIGN KEY REFERENCES Rooms(Id),
EntryTime datetime2 NOT NULL,
ExitTime datetime2
)

INSERT INTO RoomService(EmployeeId, RoomId, EntryTime, ExitTime) VALUES
(2,1, '2018-08-30 12:00', '2018-08-30 13:00'),
(4,4, '2020-04-13 12:00', '2020-04-13 13:00'),
(5,6,'2020-03-12 12:00', '2020-03-12 13:00'),
(8,8, '2020-02-11 12:00', '2020-02-11 13:00'),
(9,10,'2020-01-10 12:00', '2020-01-10 13:00')



--Dohvatiti sve sobe hotela određenog imena, i to poredane uzlazno po svom broju

SELECT * FROM Rooms WHERE HotelId = (SELECT Id FROM Hotels WHERE HotelName = 'LeMeridien Lav') ORDER BY RoomNumber


--Dohvatiti sve sobe u svim hotelima kojima broj počinje sa brojem 1

SELECT * FROM Rooms WHERE RoomNumber LIKE '1%'


--Dohvatiti samo ime i prezime svih čistačica u određenom hotelu

Select FirstName, LastName FROM Employees WHERE HotelId = (SELECT Id FROM Hotels WHERE HotelName = 'LeMeridien Lav') AND JobDescription = 'Cleaner'

--Dohvatiti kupnje od 1.12.2020. koje prelaze cijenu od 1000

SELECT * FROM Purchases WHERE TransactionTime > '2020-12-01 00:00' AND PriceTotal > 1000

--Dohvatiti sve boravke u svim hotelima koji su trenutno u tijeku

SELECT * FROM Purchases WHERE CheckoutTime > GETDATE()

--Izbrisati sve boravke koji su napravljeni prije 1.1.2020.

DELETE FROM Purchases WHERE BookTime < '2020-01-01'

--Sve sobe drugog hotela po redu koje imaju kapacitet 3 povećati kapacitet na 4

UPDATE Rooms SET Capacity = 4 WHERE HotelId = 2 AND Capacity = 3

--Dohvatiti povijesni pregled boravaka određene sobe, poredano po vremenu boravka

SELECT * FROM Purchases WHERE RoomId = 4 ORDER BY DATEDIFF(day, CheckinTime, CheckoutTime)

--Dohvatiti sve boravke koji su bili ili pansion ili polupansion, i to samo u određenom hotelu

SELECT * FROM Purchases WHERE (ServiceType = 'Pansion' OR ServiceType = 'Polupansion') AND RoomId = (SELECT Id FROM Hotels WHERE HotelName = 'Sunce')

--Promovirati 2 zaposlenika sobne posluge u recepcioniste

UPDATE TOP(2) Employees SET JobDescription = 'Receptionist' WHERE JobDescription = 'Cleaner'
