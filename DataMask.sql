USE Nombres
GO

DROP TABLE IF EXISTS Empleados;
CREATE TABLE Empleados(
	Nombre nvarchar(150) NOT NULL,
	FechaNacimiento date MASKED WITH (FUNCTION = 'default()') NULL,
	Nomina decimal(18, 3) MASKED WITH (FUNCTION = 'random(100, 8000)') NULL,
	Email nvarchar(150) MASKED WITH (FUNCTION = 'email()') NULL
) 
GO

INSERT INTO Empleados VALUES ('Jefe Luis', '19650315', 6500, 'JLuis@empresa.es');
INSERT INTO Empleados VALUES ('Tito Pinto', '19800512', 1300, 'TPinto@empresa.es');
INSERT INTO Empleados VALUES ('Nino Bravo', '19600114', 1400, 'NBravo@empresa.es');

SELECT * FROM Empleados

