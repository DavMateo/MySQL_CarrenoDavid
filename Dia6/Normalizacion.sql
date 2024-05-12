-- ##############################
-- ###### EJERCICIO DIA 6  ######
-- ##############################



-- TITULO: NORMALIZACIÓN DE BASE DE DATOS
/* ¿QUÉ ES NORMALIZAR?:
Reducir las posibles redundancias de datos y con ello mejorar la 
integridad de los datos.
*/


/* PASOS PRINCIPALES PARA LA NORMALIZACIÓN
1NF: Primera Forma Normal --> "Reducir"
2NF: Segunda Forma Normal --> "Redundancia"
3NF: Tercera Forma Normal--> "Independencia"
*/

/* PRIMERA FORMA NORMAL (1NF)
En la 1NF se busca eliminar las repeticiones de datos y asegurar con ello que cada columna 
contenga un solo valor atómico (Dato que no se puede dividir, sea por conveniencia o por especificación 
del lenguaje)

-- EJEMPLO 1
Ej1: nombreCompleto = PEDRO FELIPE GOMEZ BONILLA --> ¿Es atómico?
RTA: No, por que se puede dividir en nombres y apellidos.

-- EJEMPLO 2
Ej2: nombre=Pedro Felipe, apellido=Gomez Bonilla --> ¿Es atómico?
RTA: Depende del diseñador de base de datos, pues es un criterio muy subjetivo

-- EJEMPLO 3
EX1: ¿El siguiente query está normalizado de acuerdo al 1NF?
*/
CREATE DATABASE dia6;
use dia6;

CREATE TABLE Estudiante(
	ID INT,
    Nombre VARCHAR(100),
    Telefono VARCHAR(15)
);

/*
RTA: No, por que el usuario está ingresando el nombre completo. Aún así, si el diseñador lo
ve pertinente por los requisitos empresariales, lo puede dejar así.

¿Cómo podemos normalizarla, ya habiendo creado la tabla anteriormente?
*/
ALTER TABLE Estudiante
	ADD Apellido VARCHAR(100);

-- Prueba de agregación de datos
SHOW TABLES;
SELECT * FROM Estudiante;

-- Revisar columnas creadas con su tipología de dato
SHOW COLUMNS FROM Estudiante;

-- Manera #2 de mostrar información de la tabla
DESCRIBE Estudiante;
INSERT INTO Estudiante(ID, Nombre, Apellido, Telefono) VALUES (1, 'Pedro', '3023019865', 'Gomez');

-- Alterar la tabla existente
ALTER TABLE Estudiante ADD Edad VARCHAR(2) NOT NULL;
DROP TABLE Estudainte;

-- Creación de la tabla de estudiante
CREATE TABLE curso(
	ID_Curso INT,
    Nombre_Curso VARCHAR(50),
    Estudiantes_Inscritos VARCHAR(50)
);

INSERT INTO curso VALUES
	(101, 'Matematicas', 'Ana, Juan, Maria'),
	(102, 'Historia', 'Pedro, Luis, Ana, Carmen'),
	(103, 'Fisica', 'Juan, Carmen, Beatriz');
SELECT * FROM curso;

TRUNCATE curso;

ALTER TABLE curso
CHANGE COLUMN Estudiantes_Inscritos Estudiantes VARCHAR(100);

INSERT INTO curso VALUES
	(101, 'Matemáticas', 'Ana'),
    (101, 'Matemáticas', 'Juan'),
    (101, 'Matemáticas', 'Maria'),
    (102, 'Historia', 'Pedro'),
    (102, 'Historia', 'Luis'),
    (102, 'Historia', 'Ana'),
    (102, 'Historia', 'Carmen'),
    (103, 'Fisica', 'Juan'),
    (103, 'Fisica', 'Carmen'),
    (103, 'Fisica', 'Beatriz');



/* SEGUNDA FORMA NORMAL (2NF)
- Es cuando una tabla está en la forma 1NF, donde cada atributo que no forma parte de la
clave primaria es COMPLETAMENTE DEPENDIENTE de la clave primaria.

- Dicha 2NF se aplica a las tablas que tienen claves primarias compuestas de dos o más
atributos, donde si una tabla está en 1NF y su clave primaria es simple (Tiene un solo atributo),
entonces también está en su 2NF.

- Lo que busca hacer la 2NF es que cada atributo no clave en una tabla deba depender completamente
de la clave primaria de esa tabla, mas no ser una parte de ella.

REQUISITO: Estar en la 1NF donde todos los atributos no claves deban depender totalmente
de la clave primaria. En otras palabras, el nombre del curso es dependiente del id de este mismo,
pero están juntas. Dicho esto, debemos buscar una manera de INDEPENDIZAR dichos datos.
*/