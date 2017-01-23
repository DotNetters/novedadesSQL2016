use Nombres
--http://codebeautify.org/jsonviewer

--
-- JSON (generate JSON) 	
--
--SELECT  *
--FROM NombresAragoneses 
----FOR JSON AUTO
--FOR JSON PATH, ROOT('Nombres') 

--
-- JSON
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

--
-- IS JSON
--
--IF ISJSON(@Json) = 1
--	SELECT 'JSON cremoso delicioso !!!'
--ELSE
--	SELECT 'JSON más malo que Darth Vader !!!'


--
-- JSON_QUERY, JSON_VALUE
--
--SELECT 
--	  JSON_QUERY(@Json, '$.Serie') As SerieDatos
--	, JSON_VALUE(@Json, '$.Serie.Titulo') As Titulo
--	, JSON_VALUE(@Json, '$.Serie.Fecha') As Fecha
--	, JSON_VALUE(@Json, '$.Temporadas[0].Episodios') As EpisodiosPrimerTemporada
--	, JSON_VALUE(@Json, '$.Temporadas[1].Episodios') As EpisodiosSecundaTemporada


--
-- OPENJSON
--
--SELECT *
-- FROM 
--   OPENJSON (@Json, N'$.Serie')  
--          WITH (  
--              Titulo	nvarchar(400)	N'$.Titulo'
--			 ,Fecha		Date			N'$.Fecha'
--			 ,Budget	Decimal(18,3)	N'$.Budget'
--          )  
--CROSS APPLY		
--    OPENJSON (@Json, N'$.Temporadas')  
--          WITH (  
--              Episodios   nvarchar(400) N'$.Episodios'
--			 ,Valoracion  Decimal(3,2)  N'$.Valoracion'
--          ) AS Temporadas

--
-- JSON_MODIFY
--
--SELECT JSON_VALUE(@Json, '$.Temporadas[0].Episodios') as EpisodiosTemporadaUno
--SET @Json = JSON_MODIFY(@Json, '$.Temporadas[0].Episodios', '111') 
--SELECT JSON_VALUE(@Json, '$.Temporadas[0].Episodios') as EpisodiosTemporadaUno
--SELECT JSON_QUERY(@Json, '$.Temporadas[0]') as TemporadaUno


--
-- OPENJSON dentro de una tabla
--
--SELECT * FROM NombresPorInicial
--SELECT NombresPorInicial.Genero, NombresPorInicial.EmpiezaPor, DetJson.Es, DetJson.Ar
--FROM NombresPorInicial  
--CROSS APPLY  
--    OPENJSON (NombresPorInicial.NombresJosn, N'$.Nombres')  
--          WITH (  
--              Es   nvarchar(400) N'$.NombreEs'
--			 ,Ar   nvarchar(400) N'$.NombreAr'
--          ) AS DetJson  


