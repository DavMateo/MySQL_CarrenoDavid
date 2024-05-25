-- ############################
-- ##### EJERCICIO DIA 12 #####
-- ############################

-- Optimización de consultas, programación de tareas y tiggers

-- Consultar y usar BBDD
use world;
show tables;


-- Revisar datos
select * from city;
SELECT count(*) FROM city;
SELECT * FROM city WHERE countryCode = 'GBR';
SELECT COUNT(*) FROM city WHERE countryCode = 'GBR';

SELECT * FROM country;
SELECT COUNT(*) FROM country;

SELECT * FROM countrylanguage;
SELECT COUNT(*) FROM countrylanguage;


-- Creemos un query complejo
SELECT * FROM city WHERE name = 'Peking';
SELECT * FROM city WHERE countryCode = 'CHN';
SELECT * FROM city WHERE countryCode = 'CHN' AND population > 2243000;


-- Creación de una indexación
CREATE INDEX idx_cityName ON city(Name);
CREATE INDEX idx_cityCountry ON city(countryCode);

-- Revisar indexaciones creadas
SHOW KEYS FROM city;  -- Forma 1
SHOW INDEX FROM city; -- Forma 2


-- Hacer estudio de rendimiento de un index
EXPLAIN ANALYZE SELECT * FROM city WHERE name = 'Bogota';

select database_name, table_name, index_name, stat_value*@@innodb_page_size
from mysql.innodb_index_stats where stat_name='size' and index_name = "idx_cityCountry";


SELECT database_name, table_name, index_name,
ROUND(stat_value * @@innodb_page_size / 1024 / 1024, 2) size_in_mb
FROM mysql.innodb_index_stats
WHERE stat_name = 'size' AND index_name != 'PRIMARY'
ORDER BY size_in_mb DESC;


-- Se puede hacer una función que extraiga automáticamente
-- todos los nombres de los índices con su respectivo espacio
-- ocupado en memoria siguiendo la siguiente consulta:
SELECT database_name, table_name, index_name, ROUND(stat_value * @@innodb_page_size / 1024, 2) AS size_in_kb
FROM mysql.innodb_index_stats
WHERE stat_name = 'size' AND index_name != 'PRIMARY'
ORDER BY size_in_kb DESC;


-- Consulta base en bruto
SELECT *, @@innodb_page_size
FROM mysql.innodb_index_stats
LIMIT 2000;


-- Buscar tamaño de index
select database_name, table_name, index_name, ROUND(stat_value * @@innodb_page_size / 1024 / 1024, 2) size_in_mb
from mysql.innodb_index_stats where stat_name='size' and index_name = "idx_cityName" ;
select *
from mysql.innodb_index_stats;