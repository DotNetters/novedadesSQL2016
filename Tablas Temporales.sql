Use Nombres

--ALTER TABLE Clientes SET (SYSTEM_VERSIONING = OFF);
DROP TABLE IF EXISTS ClientesHistory;
CREATE TABLE ClientesHistory
(    
  IdCliente int NOT NULL
  , Denominacion nvarchar(400) NOT NULL  
  , Telefono nvarchar(100) NOT NULL   
  , ValidoDesde datetime2 (2) NOT NULL   
  , ValidoHasta datetime2 (2) NOT NULL   
);
CREATE CLUSTERED COLUMNSTORE INDEX IX_ClientesHistory ON ClientesHistory;
CREATE NONCLUSTERED INDEX IX_ClientesHistory_IdCliente 
	ON ClientesHistory (ValidoDesde, ValidoHasta, IdCliente);   
GO

DROP TABLE IF EXISTS Clientes;
CREATE TABLE Clientes
(    
  IdCliente int NOT NULL IDENTITY PRIMARY KEY CLUSTERED
  , Denominacion nvarchar(400) NOT NULL  
  , Telefono nvarchar(100) NOT NULL   
  , ValidoDesde datetime2 (2) GENERATED ALWAYS AS ROW START  
  , ValidoHasta datetime2 (2) GENERATED ALWAYS AS ROW END  
  , PERIOD FOR SYSTEM_TIME (ValidoDesde, ValidoHasta)  
 ) 
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ClientesHistory));


--INSERT INTO Clientes VALUES ('Joaquín Sabina', '+34 639 00 00 01', DEFAULT, DEFAULT);
--INSERT INTO Clientes VALUES ('Enrique Bunbury', '+34 640 00 00 01', DEFAULT, DEFAULT);
--INSERT INTO Clientes VALUES ('Jim Morrison', '+34 641 00 00 01', DEFAULT, DEFAULT);

--UPDATE Clientes SET Telefono = '+34 639 00 00 02' WHERE Denominacion = 'Joaquín Sabina';
--UPDATE Clientes SET Telefono = '+34 639 00 00 05' WHERE Denominacion = 'Jim Morrison';
--DELETE FROM Clientes WHERE Denominacion = 'Enrique Bunbury';


 
 
 --SELECT * FROM Clientes;
 --SELECT * FROM ClientesHistory;

 