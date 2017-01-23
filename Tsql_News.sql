use Nombres

--
-- STRING_SPLIT (1)
--
--DECLARE @Provincias NVARCHAR(400) = 'Zaragoza;Huesca;Teruel'
--SELECT	value AS Provincia
--		,ROW_NUMBER() OVER(ORDER BY value) AS Rw
--FROM STRING_SPLIT(@Provincias, ';')  


--
-- STRING_SPLIT (2) http://ocharraire.blogspot.com.es/p/nombres-propios-aragoneses.html
-- 
--SELECT * FROM NombreBase

--SELECT Base.Genero, Base.Nombres, Split.Element, Split.Rw 
--FROM NombreBase as Base
--CROSS APPLY 
--( 
--	SELECT RTRIM(LTRIM(value)) AS Element, ROW_NUMBER() OVER(ORDER BY Base.Nombres) AS Rw 
--	FROM STRING_SPLIT(Base.Nombres, '-')  
--	WHERE RTRIM(LTRIM(value)) <> ''  
--) AS Split

--
-- IF EXISTS
--
--DROP TABLE IF EXISTS NombresAragoneses;
--CREATE TABLE NombresAragoneses(
--	Genero nvarchar(1) NULL,
--	NombreAr nvarchar(400) NULL,
--	NombreEs nvarchar(400) NULL
--);

--INSERT INTO NombresAragoneses
--SELECT PivotNombres.Genero, PivotNombres.[1] As NombreAr, PivotNombres.[2] As NombreEs
--FROM NombreBase as Base
--CROSS APPLY 
--( 
--	SELECT RTRIM(LTRIM(value)) AS Element, ROW_NUMBER() OVER(ORDER BY Base.Nombres) AS Rw 
--	FROM STRING_SPLIT(Base.Nombres, '-')  
--	WHERE RTRIM(LTRIM(value)) <> ''  
--) AS Split
--PIVOT( MIN(Split.Element) FOR Split.Rw IN ([1], [2])) AS PivotNombres;

--SELECT * FROM NombresAragoneses WHERE NombreEs like '%Pablo%'



--
--  Time ZONE
--
--SELECT GETDATE() AT TIME ZONE 'Pacific Standard Time' AS Pacifico
--SELECT GETDATE() AT TIME ZONE 'Central European Standard Time' AS Europa

--
-- Compress
--
--DECLARE @Txt AS nvarchar(max)
--SET @Txt = N'Texto largooooooooooooo aburridoooooooooooooo y de pocooooooooooooo sentidooooooooo, que ocupa mucho espacio ......  !!!!!!!!!!'
--SELECT LEN(@Txt) AS Largura, @Txt AS Datos

--DECLARE @TxtCompres AS VARBINARY(MAX) = COMPRESS(@Txt)
--SELECT LEN(@TxtCompres) AS Largura, @TxtCompres AS DatosComprimidos


--DECLARE @TxtDeCompres AS NVARCHAR(MAX)
--SET @TxtDeCompres = CAST(DECOMPRESS(@TxtCompres) AS NVARCHAR(MAX))
--SELECT LEN(@TxtDeCompres) AS Largura, @TxtDeCompres AS Datos
