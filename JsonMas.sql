use Nombres

--
-- STRING_SPLIT (1)
--
--DECLARE @Provincias NVARCHAR(400) = 'Zaragoza;Huesca;Teruel'
--SELECT	value AS Provincia
----		,ROW_NUMBER() OVER(ORDER BY value) AS Rw
--FROM STRING_SPLIT(@Provincias, ';')  


--
-- STRING_SPLIT (2) http://ocharraire.blogspot.com.es/p/nombres-propios-aragoneses.html
--
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

----INSERT INTO NombresAragoneses
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
-- JSON (generate JSON) 	http://codebeautify.org/jsonviewer
--
--SELECT  *
--FROM NombresAragoneses 
----FOR JSON AUTO
--FOR JSON PATH, ROOT('Nombres') 


--
-- NombresPorInicial
--
--DROP TABLE IF EXISTS NombresPorInicial;
--CREATE TABLE NombresPorInicial(
--	Genero nvarchar(1) NULL,
--	EmpiezaPor nvarchar(1) NULL,
--	Numero int NULL,
--	NombresJosn nvarchar(max) NULL
--);
--INSERT INTO NombresPorInicial
--SELECT Genero, SUBSTRING(NombreEs, 1,1) As EmpiezaPor, COUNT(*) AS Numero, NULL
--	FROM NombresAragoneses
--	WHERE LEN(ISNULL(NombreEs, '')) > 1 
--	AND SUBSTRING(NombreEs, 1, 1) IN ( 'A','B','P')
--	GROUP BY Genero, SUBSTRING(NombreEs, 1, 1)

--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'F' AND SUBSTRING(NombreEs, 1, 1) = 'A' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'F' AND EmpiezaPor = 'A'
--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'M' AND SUBSTRING(NombreEs, 1, 1) = 'A' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'M' AND EmpiezaPor = 'A'
--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'F' AND SUBSTRING(NombreEs, 1, 1) = 'B' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'F' AND EmpiezaPor = 'B'
--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'M' AND SUBSTRING(NombreEs, 1, 1) = 'B' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'M' AND EmpiezaPor = 'B'
--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'F' AND SUBSTRING(NombreEs, 1, 1) = 'P' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'F' AND EmpiezaPor = 'P'
--UPDATE NombresPorInicial 
--SET NombresJosn = (SELECT NombreEs, NombreAr FROM NombresAragoneses WHERE Genero = 'M' AND SUBSTRING(NombreEs, 1, 1) = 'P' FOR JSON PATH, ROOT('Nombres'))
--WHERE Genero = 'M' AND EmpiezaPor = 'P'

--select * from NombresPorInicial

--
-- JSON_QUERY, JSON_VALUE
--
--SELECT * 
--, JSON_QUERY(NombresJosn, '$.Nombres[0]') As Nombre1
--, JSON_VALUE(NombresJosn, '$.Nombres[0].NombreEs') As Nombre1Es
--, JSON_VALUE(NombresJosn, '$.Nombres[0].NombreAr') As Nombre1Ar
--FROM NombresPorInicial

--DECLARE @JsonX AS nvarchar(max)
--SET @JsonX = N'{"Nombres":[
-- {"NombreEs":"Giacomo","NombreAr":"Jacobo"}
--,{"NombreEs":"Gino","NombreAr":"Gi"}]}'

--IF ISJSON(@JsonX) = 1
--BEGIN
--	DELETE FROM NombresPorInicial WHERE Genero = 'M' AND EmpiezaPor = 'G'
--	SELECT ISJSON(@JsonX)
--	INSERT INTO NombresPorInicial VALUES ( 'M', 'G', 2, @JsonX)
--END

--
-- OPENJSON
--
--SELECT NombresPorInicial.Genero, NombresPorInicial.EmpiezaPor, DetJson.Es, DetJson.Ar
--FROM NombresPorInicial  
--CROSS APPLY  
--    OPENJSON (NombresPorInicial.NombresJosn, N'$.Nombres')  
--          WITH (  
--              Es   nvarchar(400) N'$.NombreEs'
--			 ,Ar   nvarchar(400) N'$.NombreAr'
--          )  
-- AS DetJson  


--
-- JSON_MODIFY
--
--DECLARE @JsonZ AS nvarchar(max)
--SET @JsonZ = N'{
--	"Serie": {
--		"Titulo": "Halt and Catch Fire",
--		"Fecha": "2014-06-25",
--		"Budget": 1350000.3
--	},
--	"Temporadas": [
--		{
--			"Numero": 1,
--			"Episodios": 12,
--			"Valoracion": 8.2
--		},
--		{
--			"Numero": 2,
--			"Episodios": 15,
--			"Valoracion": 9.2
--		}
--	]
--}'

--IF ISJSON(@JsonZ) = 1
--BEGIN
--	SELECT JSON_VALUE(@JsonZ, '$.Serie.Titulo') as Titulo
--		,CONVERT(date, JSON_VALUE(@JsonZ, '$.Serie.Fecha')) as Fecha
--		,JSON_VALUE(@JsonZ, '$.Serie.Budget') as Budget
--		,CONVERT(decimal, JSON_VALUE(@JsonZ, '$.Serie.Budget')) / 2 As BudgetPorTemporada

--	-- JSON_MODIFY
--	SELECT JSON_VALUE(@JsonZ, '$.Temporadas[0].Episodios') as EpisodiosTemporadaUno
--	SET @JsonZ = JSON_MODIFY(@JsonZ, '$.Temporadas[0].Episodios', '11') 
--	SELECT JSON_QUERY(@JsonZ, '$.Temporadas[0]') as TemporadaUno
--END

--
--  Time ZONE
--
--SELECT GETDATE() AT TIME ZONE 'Pacific Standard Time' AS Pacifico
--SELECT GETDATE() AT TIME ZONE 'Central European Standard Time' AS Europa

--
-- Compress
--
--DECLARE @Json AS nvarchar(max)
--SET @Json = N'{
--	"Serie": {
--		"Titulo": "Halt and Catch Fire",
--		"Fecha": "2014-06-25",
--		"Budget": 1350000.3
--	},
--	"Temporadas": [
--		{
--			"Numero": 1,
--			"Episodios": 12,
--			"Valoracion": 8.2
--		},
--		{
--			"Numero": 2,
--			"Episodios": 15,
--			"Valoracion": 9.2
--		}
--	]
--}'

--SELECT LEN(@Json) AS Largura, @Json AS Datos
--DECLARE @JsonCompres AS VARBINARY(MAX) = COMPRESS(@Json)

--DECLARE @JsonDeCompres AS NVARCHAR(MAX)
--SET @JsonDeCompres = CAST(DECOMPRESS(@JsonCompres) AS NVARCHAR(MAX))

--SELECT LEN(@JsonCompres) AS Largura, @JsonCompres AS DatosComprimidos
--SELECT LEN(@JsonDeCompres) AS Largura, @JsonDeCompres AS Datos
