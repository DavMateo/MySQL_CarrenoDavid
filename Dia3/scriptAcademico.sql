CREATE DATABASE IF NOT EXISTS academico;
USE academico;

CREATE TABLE IF NOT EXISTS persona(
	id INT(10) UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nif VARCHAR(9),
    nombre VARCHAR(25) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(9),
    fecha_nacimiento DATE NOT NULL,
    sexo ENUM('H', 'M') NOT NULL,
    tipo ENUM('...') NOT NULL
);

CREATE TABLE IF NOT EXISTS asignatura(
	id INT(10) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    creditos FLOAT NOT NULL,
    tipo ENUM('...') NOT NULL,
    curso TINYINT(3) NOT NULL,
    cuatrimestre TINYINT(3) NOT NULL,
    id_profesor INT(10) UNSIGNED,
    id_grado INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY(id, id_grado)
);

CREATE TABLE IF NOT EXISTS profesor(
	id INT(10) UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    id_departamento INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY(id, id_departamento)
);

CREATE TABLE IF NOT EXISTS departamento(
	id INT(10) UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS grado(
	id INT(10) UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS alumno_se_matricula_asignatura(
	id_persona INT(10) UNSIGNED NOT NULL,
    id_asignatura INT(10) UNSIGNED NOT NULL,
    id_curso_escolar INT(10) UNSIGNED NOT NULL,
    PRIMARY KEY(id_persona, id_asignatura, id_curso_escolar)
);

CREATE TABLE IF NOT EXISTS curso_escolar(
	id INT(10) UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    anyo_inicio YEAR(4) NOT NULL,
    anyo_fin YEAR(4)
);


-- INSERTANDO LAS LLAVES FORÁNEAS
ALTER TABLE asignatura
ADD FOREIGN KEY(id_profesor) REFERENCES profesor(id),
ADD FOREIGN KEY(id_grado) REFERENCES grado(id);

ALTER TABLE profesor
ADD FOREIGN KEY(id_departamento) REFERENCES departamento(id);

ALTER TABLE alumno_se_matricula_asignatura
ADD FOREIGN KEY(id_persona) REFERENCES persona(id),
ADD FOREIGN KEY(id_asignatura) REFERENCES asignatura(id),
ADD FOREIGN KEY(id_curso_escolar) REFERENCES curso_escolar(id);