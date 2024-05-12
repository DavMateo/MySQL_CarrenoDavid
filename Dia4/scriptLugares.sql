-- #############################
-- ###### EJERCICIO DIA 4 ######
-- #############################


-- Creación y uso de la BBDD "lugares"
CREATE DATABASE lugares;
USE lugares;


-- Crear la tabla "pais"
CREATE TABLE pais(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

-- Crear la tabla "idioma"
CREATE TABLE idioma(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    idioma VARCHAR(50)
);

-- Crear la tabla "ciudad"
CREATE TABLE ciudad(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20),
    id_pais INT UNSIGNED,
    FOREIGN KEY(id_pais) REFERENCES pais(id)
);

-- Crear la tabla intermedia "idioma_pais"
CREATE TABLE idioma_pais(
	id_idioma INT UNSIGNED NOT NULL,
    id_pais INT UNSIGNED NOT NULL,
    es_oficial TINYINT(1),
    PRIMARY KEY(id_idioma, id_pais),
    FOREIGN KEY(id_idioma) REFERENCES idioma(id),
    FOREIGN KEY(id_pais) REFERENCES pais(id)
);



-- INSERTANDO 10 DATOS A LA BASE DE DATOS
-- Insertando datos a la tabla "pais"
INSERT INTO pais(nombre, continente, poblacion) VALUES
("Colombia", "América del Sur", 51870000),
("Filipinas", "Asia", 115600000),
("Indonesia", "Asia", 275500000),
("Tailandia", "Asia", 717000000),
("Japón", "Asia", 125100000),
("Argentina", "América del Sur", 631100000),
("Chile", "América del Sur", 19600000),
("Estados Unidos", "América del Norte", 333300000),
("Nueva Zelanda", "Oceanía", 5124000),
("España", "Europa", 47780000);

-- Insertando datos a la tabla "ciudad"
INSERT INTO ciudad(nombre, id_pais) VALUES
("Floridablanca", 1),
("Mindanao", 2),
("Java", 3),
("Pattaya", 4),
("Shibuya", 5),
("Mendoza", 6),
("Valdivia", 7),
("Arizona", 8),
("Wellington", 9),
("Alicante", 10);

-- Insertando datos a la tabla "idioma"
INSERT INTO idioma(idioma) VALUES
("Tagalo"),
("Español"),
("Japonés"),
("Tailandés"),
("Indonesio"),
("Inglés"),
("Cebuano"),
("Malayo"),
("Portugués"),
("Francés");

-- Insertando datos a la tabla "idioma_pais"
INSERT INTO idioma_pais(id_idioma, id_pais, es_oficial) VALUES
(1, 2, 1),
(6, 1, 0),
(10, 7, 0),
(3, 5, 1),
(5, 3, 1),
(9, 10, 0),
(7, 4, 0),
(2, 6, 1),
(8, 8, 0),
(4, 9, 0);



-- DESARROLLADO POR DAVID CARREÑO C.C 1.099.737.474