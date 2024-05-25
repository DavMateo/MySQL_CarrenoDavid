/*
Creando y usando la base de datos "Dia10"
*/
CREATE DATABASE IF NOT EXISTS dia10;
USE dia10;


/*
Creando las tablas pertinentes
*/
-- Crear la tabla "departamento"
CREATE TABLE departamento(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    presupuesto DOUBLE UNSIGNED NOT NULL,
	gastos DOUBLE UNSIGNED NOT NULL,
    CONSTRAINT pk_departamento PRIMARY KEY(id)
);

-- Crear la tabla "empleado"
CREATE TABLE empleado(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nif VARCHAR(9) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido1 VARCHAR(100) NOT NULL,
    apellido2 VARCHAR(100),
    id_departamento INT UNSIGNED,
    CONSTRAINT pk_empleado PRIMARY KEY(id),
    CONSTRAINT fk_empleado_id_departamento FOREIGN KEY(id_departamento) REFERENCES departamento(id)
);

-- Crear la tabla "nif_empleado"
CREATE TABLE nif_empleado(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nifNums VARCHAR(9),
    nifChars VARCHAR(9),
    CONSTRAINT pk_nif_empleado PRIMARY KEY(id)
);


/*
Agregando información a la base de datos
*/
-- Insertando datos a la tabla "departamento"
INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);

-- Insertando datos a la tabla "empleado"
INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero', NULL);


/*
Creando las consultas solicitadas
*/

-- CONSULTAS SOBRE UNA TABLA
/* Consulta n°1
Lista el primer apellido de todos los empleados.
*/
SELECT apellido1
	FROM empleado;

/* Consulta n°2
Lista el primer apellido de los empleados eliminando los apellidos que estén
repetidos.
*/
SELECT DISTINCT apellido1
	FROM empleado;

/* Consulta n°3
Lista todas las columnas de la tabla empleado.
*/
SELECT *
	FROM empleado;

/* Consulta n°4
Lista el nombre y los apellidos de todos los empleados.
*/
SELECT nombre, CONCAT(apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS apellidos
	FROM empleado;

/* Consulta n°5
Lista el identificador de los departamentos de los empleados que aparecen
en la tabla empleado.
*/
SELECT id_departamento
	FROM empleado
    WHERE id_departamento IS NOT NULL;

/* Consulta n°6
Lista el identificador de los departamentos de los empleados que aparecen
en la tabla empleado, eliminando los identificadores que aparecen repetidos.
*/
SELECT DISTINCT id_departamento
	FROM empleado
    WHERE id_departamento IS NOT NULL;

/* Consulta n°7
Lista el nombre y apellidos de los empleados en una única columna.
*/
SELECT CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS nombreCompleto
	FROM empleado;

/* Consulta n°8
Lista el nombre y apellidos de los empleados en una única columna,
convirtiendo todos los caracteres en mayúscula.
*/
SELECT UPPER(CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, ''))) AS nombreCompletoUpperCase
	FROM empleado;

/* Consulta n°9
Lista el nombre y apellidos de los empleados en una única columna,
convirtiendo todos los caracteres en minúscula.
*/
SELECT LOWER(CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, ''))) AS nombreCompletoLowerCase
	FROM empleado;

/* Consulta n°10
Lista el identificador de los empleados junto al nif, pero el nif deberá
aparecer en dos columnas, una mostrará únicamente los dígitos del nif y la
otra la letra.
*/
DELIMITER $$
CREATE FUNCTION detector_letras(codigoNif VARCHAR(9))
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
	SET @contador = 1;
    SET @idxNumStr = '';
    
    WHILE @contador <= LENGTH(codigoNif) DO
		IF ASCII(SUBSTR(UPPER(TRIM(codigoNif)), @contador, 1)) >= 65 AND ASCII(SUBSTR(UPPER(TRIM(codigoNif)), @contador, 1)) <= 90 THEN
			SET @idxNumStr = CONCAT(IF(@idxNumStr = "", '', CONCAT(@idxNumStr, ',')), @contador);
		END IF;
		SET @contador = @contador + 1;
	END WHILE;
    
    RETURN @idxNumStr;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION incrementador_count()
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
	DECLARE countNum INT;
    DECLARE infoConsulta VARCHAR(25);
    SET countNum = 0;
    
    DELETE FROM nif_empleado;
    WHILE countNum < 13 DO
        SET @infoConsulta = (SELECT extraer_filas_consulta(countNum));
        SET countNum = countNum + 1;
	END WHILE;
    
    RETURN 'Ejecuta "SELECT * FROM nif_empleado" para ver los resultados';
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION extraer_filas_consulta(countLimit INT)
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
	DECLARE nifCode VARCHAR(9);
    SET @nifCode = (SELECT nif FROM empleado LIMIT 1 OFFSET countLimit);
    SET @infoReturn = (SELECT detector_letras(@nifCode));
    
    IF LENGTH(@infoReturn) > 1 THEN
		SET @infoInsertNum = (
			SELECT SUBSTR(nif, LEFT(@infoReturn, 1) + 1, RIGHT(@infoReturn, 1) - 2)
			FROM empleado 
			WHERE nif = @nifCode
		);
	ELSEIF LENGTH(@infoReturn) = 1 THEN
		SET @infoInsertNum = (
			SELECT SUBSTR(nif, IF(LEFT(@infoReturn, 1) = 1, LEFT(@infoReturn, 1), 1), RIGHT(@infoReturn, 1) - 1)
            FROM empleado
            WHERE nif = @nifCode
        );
	END IF;
        
	IF LENGTH(@infoReturn) > 1 THEN
		SET @infoInsertStr = (
			SELECT CONCAT(SUBSTR(nif, LEFT(@infoReturn, 1), LEFT(@infoReturn, 1)), SUBSTR(nif, RIGHT(@infoReturn, 1), RIGHT(@infoReturn, 1)))
            FROM empleado
            WHERE nif = @nifCode
        );
	ELSEIF LENGTH(@infoReturn) = 1 THEN
		SET @infoInsertStr = (
			SELECT SUBSTR(nif, LEFT(@infoReturn, 1), RIGHT(@infoReturn, 1))
            FROM empleado 
            WHERE nif = @nifCode
        );
	ELSE
		SET @infoInsertStr = '';
	END IF;
    
    INSERT INTO nif_empleado(nifNums, nifChars) VALUES (@infoInsertNum, @infoInsertStr);
    
    RETURN @infoInsertStr;
END$$
DELIMITER ;

SELECT incrementador_count();
SELECT * FROM nif_empleado;


/* Consulta n°11
Lista el nombre de cada departamento y el valor del presupuesto actual del que dispone. Para calcular 
este dato tendrá que restar al valor del presupuesto inicial (columna presupuesto) los gastos que 
se han generado (columna gastos). Tenga en cuenta que en algunos casos pueden existir valores 
negativos. Utilice un alias apropiado para la nueva columna columna que está calculando.
*/
SELECT presupuesto - gastos AS presupuestoActual
	FROM departamento;


/* Consulta n°12
Lista el nombre de los departamentos y el valor del presupuesto actual
ordenado de forma ascendente.
*/
SELECT nombre, presupuesto - gastos AS presupuestoActual
	FROM departamento
    ORDER BY nombre ASC;


/* Consulta n°13
Lista el nombre de todos los departamentos ordenados de forma
ascendente.
*/
SELECT nombre
	FROM departamento
    ORDER BY nombre ASC;


/* Consulta n°14
Lista el nombre de todos los departamentos ordenados de forma
descendente.
*/
SELECT nombre
	FROM departamento
    ORDER BY nombre DESC;


/* Consulta n°15
Lista los apellidos y el nombre de todos los empleados, ordenados de forma
alfabética tendiendo en cuenta en primer lugar sus apellidos y luego su nombre.
*/
SELECT CONCAT(apellido1, '', IF(apellido2 IS NOT NULL, apellido2, ''), '', nombre) AS nombreEmpleado
	FROM empleado
    ORDER BY apellido1 ASC, apellido2 ASC, nombre ASC;


/* Consulta n°16
Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos
que tienen mayor presupuesto.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), ' COP') AS presupuesto
	FROM departamento
    ORDER BY presupuesto DESC
    LIMIT 3;


/* Consulta n°17
Devuelve una lista con el nombre y el presupuesto, de los 3 departamentos
que tienen menor presupuesto.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), ' COP') AS presupuesto
	FROM departamento
    ORDER BY presupuesto ASC
    LIMIT 3;


/* Consulta n°18
Devuelve una lista con el nombre y el gasto, de los 2 departamentos que
tienen mayor gasto.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), ' COP') AS gasto
	FROM departamento
    ORDER BY gastos DESC
    LIMIT 2;


/* Consulta n°19
Devuelve una lista con el nombre y el gasto, de los 2 departamentos que
tienen menor gasto.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), ' COP') AS gasto
	FROM departamento
    ORDER BY gastos ASC
    LIMIT 2;


/* Consulta n°20
Devuelve una lista con 5 filas a partir de la tercera fila de la tabla empleado. La
tercera fila se debe incluir en la respuesta. La respuesta debe incluir todas las
columnas de la tabla empleado.
*/
SELECT * 
	FROM empleado 
    LIMIT 5 
    OFFSET 2;


/* Consulta n°21
Devuelve una lista con el nombre de los departamentos y el presupuesto, de
aquellos que tienen un presupuesto mayor o igual a 150000 euros.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoTotal
	FROM departamento
    WHERE presupuesto >= 150000;


/* Consulta n°22
Devuelve una lista con el nombre de los departamentos y el gasto, de
aquellos que tienen menos de 5000 euros de gastos.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), '€') AS gasto
	FROM departamento
    WHERE gastos < 5000;


/* Consulta n°23
Devuelve una lista con el nombre de los departamentos y el presupuesto, de
aquellos que tienen un presupuesto entre 100000 y 200000 euros. Sin
utilizar el operador BETWEEN.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoTotal
	FROM departamento
    WHERE presupuesto >= 100000 AND presupuesto <= 200000;
    
    

/* Consulta n°24
Devuelve una lista con el nombre de los departamentos que no tienen un
presupuesto entre 100000 y 200000 euros. Sin utilizar el operador BETWEEN.
*/
SELECT nombre
	FROM departamento
    WHERE presupuesto <= 100000 OR presupuesto >= 200000;


/* Consulta n°25
Devuelve una lista con el nombre de los departamentos que tienen un
presupuesto entre 100000 y 200000 euros. Utilizando el operador BETWEEN.
*/
SELECT nombre
	FROM departamento
    WHERE presupuesto BETWEEN 100000 AND 200000;


/* Consulta n°26
Devuelve una lista con el nombre de los departamentos que no tienen un
presupuesto entre 100000 y 200000 euros. Utilizando el operador BETWEEN.
*/
SELECT nombre
	FROM departamento
    WHERE presupuesto NOT BETWEEN 100000 AND 200000;


/* Consulta n°27
Devuelve una lista con el nombre de los departamentos, gastos y
presupuesto, de aquellos departamentos donde los gastos sean mayores
que el presupuesto del que disponen.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), '€') AS gastosDept, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept
	FROM departamento
    WHERE gastos > presupuesto;


/* Consulta n°28
Devuelve una lista con el nombre de los departamentos, gastos y
presupuesto, de aquellos departamentos donde los gastos sean menores
que el presupuesto del que disponen.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), '€') AS gastosDept, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept
	FROM departamento
    WHERE gastos < presupuesto;


/* Consulta n°29
Devuelve una lista con el nombre de los departamentos, gastos y
presupuesto, de aquellos departamentos donde los gastos sean iguales al
presupuesto del que disponen.
*/
SELECT nombre, CONCAT('$', FORMAT(gastos, 2), '€') AS gastosDept, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept
	FROM departamento
    WHERE gastos = presupuesto;


/* Consulta n°30
Lista todos los datos de los empleados cuyo segundo apellido sea NULL.
*/
SELECT *
	FROM empleado
    WHERE apellido2 IS NULL;


/* Consulta n°31
Lista todos los datos de los empleados cuyo segundo apellido no sea NULL.
*/
SELECT *
	FROM empleado
    WHERE apellido2 IS NOT NULL;


/* Consulta n°32
Lista todos los datos de los empleados cuyo segundo apellido sea López.
*/
SELECT *
	FROM empleado
    WHERE apellido2 = 'López';


/* Consulta n°33
Lista todos los datos de los empleados cuyo segundo apellido
sea Díaz o Moreno. Sin utilizar el operador IN.
*/
SELECT *
	FROM empleado
    WHERE apellido2 = 'Díaz' OR apellido2 = 'Moreno';


/* Consulta n°34
Lista todos los datos de los empleados cuyo segundo apellido
sea Díaz o Moreno. Utilizando el operador IN.
*/
SELECT *
	FROM empleado
    WHERE apellido2 IN ('Díaz', 'Moreno');


/* Consulta n°35
Lista los nombres, apellidos y nif de los empleados que trabajan en el
departamento 3.
*/
SELECT nombre, CONCAT(apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS apellidos, nif
	FROM empleado
    WHERE id_departamento = 3;


/* Consulta n°36
Lista los nombres, apellidos y nif de los empleados que trabajan en los
departamentos 2, 4 o 5.
*/
SELECT nombre, CONCAT(apellido1, IF(apellido2 IS NOT NULL, apellido2, '')) AS apellidos, nif
	FROM empleado
    WHERE id_departamento IN (2, 4, 5);



-- CONSULTAS MULTITABLA (COMPOSICIÓN INTERNA)
/* Consulta n°37
Devuelve un listado con los empleados y los datos de los departamentos
donde trabaja cada uno.
*/
SELECT 	E.id, E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto, E.id_departamento, 
		D.nombre, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(D.gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id;


/* Consulta n°38
Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada 
uno. Ordena el resultado, en primer lugar por el nombre del departamento (en orden 
alfabético) y en segundo lugar por los apellidos y el nombre de los empleados.
*/
SELECT	E.id, E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto, E.id_departamento,
		D.nombre, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(D.gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    ORDER BY D.nombre ASC, E.apellido1 ASC, E.apellido2 ASC, E.nombre ASC;


/* Consulta n°39
Devuelve un listado con el identificador y el nombre del departamento,
solamente de aquellos departamentos que tienen empleados.
*/
SELECT DISTINCT D.id, D.nombre
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id;


/* Consulta n°40
Devuelve un listado con el identificador, el nombre del departamento y el valor del presupuesto 
actual del que dispone, solamente de aquellos departamentos que tienen empleados. El valor 
del presupuesto actual lo puede calcular restando al valor del presupuesto inicial (columna 
presupuesto) el valor de los gastos que ha generado (columna gastos).
*/
SELECT DISTINCT D.id, D.nombre, CONCAT('$', FORMAT(presupuesto - gastos, 2), '€') AS presupuestoActual
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id;


/* Consulta n°41
Devuelve el nombre del departamento donde trabaja el empleado que tiene
el nif 38382980M.
*/
SELECT D.nombre
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE E.nif = '38382980M';


/* Consulta n°42
Devuelve el nombre del departamento donde trabaja el empleado Pepe Ruiz Santana.
*/
SELECT D.nombre
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE E.nombre = 'Pepe' AND E.apellido1 = 'Ruiz' AND E.apellido2 = 'Santana';


/* Consulta n°43
Devuelve un listado con los datos de los empleados que trabajan en el
departamento de I+D. Ordena el resultado alfabéticamente.
*/
SELECT E.id, E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE D.nombre = 'I+D'
    ORDER BY E.nombre ASC, E.apellido1 ASC, E.apellido2 ASC;


/* Consulta n°44
Devuelve un listado con los datos de los empleados que trabajan en el departamento de 
Sistemas, Contabilidad o I+D. Ordena el resultado alfabéticamente.
*/
SELECT E.id, E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE D.nombre IN ('Sistemas', 'Contabilidad', 'I+D')
    ORDER BY E.nombre ASC, E.apellido1 ASC, E.apellido2 ASC;


/* Consulta n°45
Devuelve una lista con el nombre de los empleados que tienen los
departamentos que no tienen un presupuesto entre 100000 y 200000 euros.
*/
SELECT CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE presupuesto NOT BETWEEN 100000 AND 200000;


/* Consulta n°46
Devuelve un listado con el nombre de los departamentos donde existe algún empleado cuyo segundo 
apellido sea NULL. Tenga en cuenta que no debe mostrar nombres de departamentos que 
estén repetidos.
*/
SELECT DISTINCT D.nombre
	FROM empleado AS E
    INNER JOIN departamento AS D ON E.id_departamento = D.id
    WHERE E.apellido2 IS NULL;



-- CONSULTAS MULTITABLA (COMPOSICIÓN EXTERNA)
/* Consulta n°47
Devuelve un listado con todos los empleados junto con los datos de los
departamentos donde trabajan. Este listado también debe incluir los
empleados que no tienen ningún departamento asociado.
*/
SELECT 	E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto, 
		D.nombre, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    RIGHT JOIN departamento AS D ON E.id_departamento = D.id;


/* Consulta n°48
Devuelve un listado donde sólo aparezcan aquellos empleados que no
tienen ningún departamento asociado.
*/
SELECT id, nif, CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS nombreCompleto
	FROM empleado
    WHERE id_departamento IS NULL;


/* Consulta n°49
Devuelve un listado donde sólo aparezcan aquellos departamentos que no
tienen ningún empleado asociado.
*/
SELECT D.id, D.nombre, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(D.gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    RIGHT JOIN departamento AS D ON E.id_departamento = D.id
    WHERE E.id_departamento IS NULL;


/* Consulta n°50
Devuelve un listado con todos los empleados junto con los datos de los departamentos donde trabajan. 
El listado debe incluir los empleados que no tienen ningún departamento asociado y los 
departamentos que no tienen ningún empleado asociado. Ordene el listado alfabéticamente por el
nombre del departamento.
*/
SELECT 	E.id, E.nif, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreCompleto, E.id_departamento,
		D.nombre, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(D.gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    RIGHT JOIN departamento AS D ON E.id_departamento = D.id
    ORDER BY D.nombre ASC;


/* Consulta n°51
Devuelve un listado con los empleados que no tienen ningún departamento
asociado y los departamentos que no tienen ningún empleado asociado.
Ordene el listado alfabéticamente por el nombre del departamento.
*/
SELECT id AS id_nombreDept, nif AS nif_presupuesto, CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS nombreCompleto_gastos
	FROM empleado
    WHERE id_departamento IS NULL
    
UNION

SELECT D.nombre, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept, CONCAT('$', FORMAT(D.gastos, 2), '€') AS gastosDept
	FROM empleado AS E
    RIGHT JOIN departamento AS D ON E.id_departamento = D.id
    WHERE E.id_departamento IS NULL;



-- CONSULTAS RESUMEN
/* Consulta n°52
Calcula la suma del presupuesto de todos los departamentos.
*/
SELECT CONCAT('$', FORMAT(SUM(presupuesto), 2), '€') AS sumaPresupuesto
	FROM departamento;

/* Consulta n°53
Calcula la media del presupuesto de todos los departamentos.
*/
SELECT CONCAT('$', FORMAT(AVG(presupuesto), 2), '€') AS mediaPresupuesto
	FROM departamento;

/* Consulta n°54
Calcula el valor mínimo del presupuesto de todos los departamentos.
*/
SELECT CONCAT('$', FORMAT(MIN(presupuesto), 2), '€') AS presupuestoMinimo
	FROM departamento;

/* Consulta n°55
Calcula el nombre del departamento y el presupuesto que tiene asignado,
del departamento con menor presupuesto.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept
	FROM departamento
    ORDER BY presupuesto ASC
    LIMIT 1;

/* Consulta n°56
Calcula el valor máximo del presupuesto de todos los departamentos.
*/
SELECT CONCAT('$', FORMAT(MAX(presupuesto), 2), '€') AS presupuestoMaximo
	FROM departamento;

/* Consulta n°57
Calcula el nombre del departamento y el presupuesto que tiene asignado,
del departamento con mayor presupuesto.
*/
SELECT nombre, CONCAT('$', FORMAT(presupuesto, 2), '€') AS presupuestoDept
	FROM departamento
    ORDER BY presupuesto DESC
    LIMIT 1;

/* Consulta n°58
Calcula el número total de empleados que hay en la tabla empleado.
*/
SELECT COUNT(id) AS numEmpleados
	FROM empleado;

/* Consulta n°59
Calcula el número de empleados que no tienen NULL en su segundo
apellido.
*/
SELECT COUNT(apellido2) AS numDifNullApellido2
	FROM empleado
    WHERE apellido2 IS NOT NULL;

/* Consulta n°60
Calcula el número de empleados que hay en cada departamento. Tienes que
devolver dos columnas, una con el nombre del departamento y otra con el
número de empleados que tiene asignados.
*/
SELECT D.nombre, FIDCTE.cantEmpleados
	FROM (
		SELECT D.id, COUNT(E.id) AS cantEmpleados
        FROM empleado AS E
        RIGHT JOIN departamento AS D ON E.id_departamento = D.id
        GROUP BY D.id
    ) AS FIDCTE  #FIDCTE = Filtrado de Id por Departamento con su Conteo Total de Empleados
    INNER JOIN departamento AS D ON FIDCTE.id = D.id
    WHERE FIDCTE.cantEmpleados > 0;

/* Consulta n°61
Calcula el nombre de los departamentos que tienen más de 2 empleados. El
resultado debe tener dos columnas, una con el nombre del departamento y
otra con el número de empleados que tiene asignados.
*/
SELECT D.nombre, FIDCTE.cantEmpleados
	FROM (
		SELECT D.id, COUNT(E.id) AS cantEmpleados
        FROM empleado AS E
        RIGHT JOIN departamento AS D ON E.id_departamento = D.id
        GROUP BY D.id
    ) AS FIDCTE  #FIDCTE = Filtrado de Id por Departamento con su Conteo Total de Empleados
    INNER JOIN departamento AS D ON FIDCTE.id = D.id
    WHERE FIDCTE.cantEmpleados > 2;

/* Consulta n°62
Calcula el número de empleados que trabajan en cada uno de los
departamentos. El resultado de esta consulta también tiene que incluir
aquellos departamentos que no tienen ningún empleado asociado.
*/
SELECT D.nombre, FIDCTE.cantEmpleados
	FROM (
		SELECT D.id, COUNT(E.id) AS cantEmpleados
        FROM empleado AS E
        RIGHT JOIN departamento AS D ON E.id_departamento = D.id
        GROUP BY D.id
    ) AS FIDCTE  #FIDCTE = Filtrado de Id por Departamento con su Conteo Total de Empleados
    INNER JOIN departamento AS D ON FIDCTE.id = D.id;

/* Consulta n°63
Calcula el número de empleados que trabajan en cada unos de los
departamentos que tienen un presupuesto mayor a 200000 euros.
*/
SELECT D.nombre, FIDCTE.cantEmpleados, CONCAT('$', FORMAT(D.presupuesto, 2), '€') AS presupuestoDept
	FROM (
		SELECT D.id, COUNT(E.id) AS cantEmpleados
        FROM empleado AS E
        RIGHT JOIN departamento AS D ON E.id_departamento = D.id
        GROUP BY D.id
    ) AS FIDCTE  #FIDCTE = Filtrado de Id por Departamento con su Conteo Total de Empleados
    INNER JOIN departamento AS D ON FIDCTE.id = D.id
    WHERE D.presupuesto > 200000;