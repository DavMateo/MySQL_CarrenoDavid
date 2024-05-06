-- COMANDOS PRINCIPALES
CREATE DATABASE IF NOT EXISTS campuslands;
USE campuslands;


-- CREANDO LAS TABLAS
CREATE TABLE nombre(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    primerNombre VARCHAR(20) NOT NULL,
    segundoNombre VARCHAR(20),
    primerApellido VARCHAR(20) NOT NULL,
    segundoApellido VARCHAR(20)
);

CREATE TABLE direccion(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    tipoCalle VARCHAR(25) NOT NULL,
    nombreCalle VARCHAR(50) NOT NULL,
    numCalle INT UNSIGNED NOT NULL,
    numEdif VARCHAR(15) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    pais VARCHAR(30) NOT NULL,
    codigoPostal INT UNSIGNED NOT NULL,
    infoAd VARCHAR(255)
);

CREATE TABLE contacto(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    numTelefono VARCHAR(20) NOT NULL,
    email VARCHAR(75) NOT NULL,
    linkedin VARCHAR(100),
    github VARCHAR(100)
);

CREATE TABLE tipoPersona(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    rol VARCHAR(15) NOT NULL
);

CREATE TABLE infoPersonal(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    id_nombre INT UNSIGNED NOT NULL,
    id_direccion INT UNSIGNED NOT NULL,
    id_contacto INT UNSIGNED NOT NULL,
    edad INT UNSIGNED NOT NULL,
    documento VARCHAR(16) NOT NULL,
    estadoCivil VARCHAR(15) NOT NULL,
    sexo CHAR(2) NOT NULL,
    fechaInicio VARCHAR(10),
    fechaFin VARCHAR(10),
    id_tipoPersona INT UNSIGNED NOT NULL,
    FOREIGN KEY(id_nombre) REFERENCES nombre(id),
    FOREIGN KEY(id_direccion) REFERENCES direccion(id),
    FOREIGN KEY(id_contacto) REFERENCES contacto(id),
    FOREIGN KEY(id_tipoPersona) REFERENCES tipoPersona(id)
);

CREATE TABLE salon(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    capacidad INT UNSIGNED NOT NULL,
    estado VARCHAR(20) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE horario(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    dia INT UNSIGNED NOT NULL,
    horaInicio VARCHAR(10) NOT NULL,
    horaFin VARCHAR(10) NOT NULL,
    id_asignatura INT UNSIGNED NOT NULL
);

CREATE TABLE infoAcademico(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    id_grupo INT UNSIGNED NOT NULL,
    id_salon INT UNSIGNED NOT NULL,
    id_horario INT UNSIGNED NOT NULL
);

CREATE TABLE etapa(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE estado(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE camper(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
	id_infoPersonal INT UNSIGNED NOT NULL,
	id_infoAcademico INT UNSIGNED NOT NULL,
	id_etapa INT UNSIGNED NOT NULL,
	id_estado INT UNSIGNED NOT NULL,
	puntosNegativos INT NOT NULL,
	campCoins INT UNSIGNED NOT NULL
);

CREATE TABLE asistencia(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(15) NOT NULL,
    justificacion BOOLEAN NOT NULL,
    descripcion VARCHAR(255),
    fechaRegistro DATETIME NOT NULL,
    id_camper INT UNSIGNED NOT NULL
);

CREATE TABLE sesiones(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(75) NOT NULL,
    descripcion VARCHAR(255),
    id_asistencia INT UNSIGNED NOT NULL
);

CREATE TABLE ruta(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE trainer(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
	id_infoPersonal INT UNSIGNED NOT NULL,
	id_infoAcademico INT UNSIGNED NOT NULL,
	id_ruta INT UNSIGNED NOT NULL
);

CREATE TABLE camper_has_trainer(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
	camper_id INT UNSIGNED NOT NULL,
	camper_id_infoPersonal INT UNSIGNED NOT NULL,
	camper_id_infoAcademico INT UNSIGNED NOT NULL,
	camper_id_estado INT UNSIGNED NOT NULL,
	camper_id_etapa INT UNSIGNED NOT NULL,
	trainer_id INT UNSIGNED NOT NULL,
	trainer_id_infoPersonal INT UNSIGNED NOT NULL,
	trainer_id_infoAcademico INT UNSIGNED NOT NULL,
	trainer_id_ruta INT UNSIGNED NOT NULL
);

CREATE TABLE calificacion(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    notaCalificacion VARCHAR(3) NOT NULL,
    porcentaje INT UNSIGNED NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE modulo(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_sesiones INT UNSIGNED NOT NULL,
    id_trainer INT UNSIGNED NOT NULL,
    id_ruta INT UNSIGNED NOT NULL,
    id_calificacion INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, id_sesiones, id_trainer, id_ruta, id_calificacion)
);

CREATE TABLE asignatura(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    id_modulo INT UNSIGNED NOT NULL,
    id_trainer INT UNSIGNED NOT NULL,
    id_ruta INT UNSIGNED NOT NULL
);

CREATE TABLE grupo(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    id_asignatura INT UNSIGNED NOT NULL,
    id_ruta INT UNSIGNED NOT NULL,
    cantCampers INT UNSIGNED NOT NULL,
    estado VARCHAR(20) NOT NULL
);



-- AGREGANDO LAS LLAVES FORÁNEAS
ALTER TABLE horario
ADD FOREIGN KEY(id_asignatura) REFERENCES asignatura(id);

ALTER TABLE infoAcademico
ADD FOREIGN KEY(id_grupo) REFERENCES grupo(id),
ADD FOREIGN KEY(id_salon) REFERENCES salon(id),
ADD FOREIGN KEY(id_horario) REFERENCES horario(id);

ALTER TABLE camper
ADD FOREIGN KEY(id_infoPersonal) REFERENCES infoPersonal(id),
ADD FOREIGN KEY(id_infoAcademico) REFERENCES infoAcademico(id),
ADD FOREIGN KEY(id_etapa) REFERENCES etapa(id),
ADD FOREIGN KEY(id_estado) REFERENCES estado(id);

ALTER TABLE asistencia
ADD FOREIGN KEY(id_camper) REFERENCES camper(id);

ALTER TABLE sesiones
ADD FOREIGN KEY(id_asistencia) REFERENCES asistencia(id);

ALTER TABLE trainer
ADD FOREIGN KEY(id_infoPersonal) REFERENCES infoPersonal(id),
ADD FOREIGN KEY(id_infoAcademico) REFERENCES infoAcademico(id),
ADD FOREIGN KEY(id_ruta) REFERENCES ruta(id);

ALTER TABLE camper_has_trainer
ADD FOREIGN KEY(camper_id) REFERENCES camper(id),
ADD FOREIGN KEY(camper_id_infoPersonal) REFERENCES camper(id_infoPersonal),
ADD FOREIGN KEY(camper_id_infoAcademico) REFERENCES camper(id_infoAcademico),
ADD FOREIGN KEY(camper_id_estado) REFERENCES camper(id_estado),
ADD FOREIGN KEY(camper_id_etapa) REFERENCES camper(id_etapa),
ADD FOREIGN KEY(trainer_id) REFERENCES trainer(id),
ADD FOREIGN KEY(trainer_id_infoPersonal) REFERENCES trainer(id_infoPersonal),
ADD FOREIGN KEY(trainer_id_infoAcademico) REFERENCES trainer(id_infoAcademico),
ADD FOREIGN KEY(trainer_id_ruta) REFERENCES trainer(id_ruta);

ALTER TABLE modulo
ADD FOREIGN KEY(id_sesiones) REFERENCES sesiones(id),
ADD FOREIGN KEY(id_trainer) REFERENCES trainer(id),
ADD FOREIGN KEY(id_ruta) REFERENCES ruta(id),
ADD FOREIGN KEY(id_calificacion) REFERENCES calificacion(id);

ALTER TABLE asignatura
ADD FOREIGN KEY(id_modulo) REFERENCES modulo(id),
ADD FOREIGN KEY(id_trainer) REFERENCES trainer(id),
ADD FOREIGN KEY(id_ruta) REFERENCES ruta(id);

ALTER TABLE grupo
ADD FOREIGN KEY(id_asignatura) REFERENCES asignatura(id),
ADD FOREIGN KEY(id_ruta) REFERENCES ruta(id);



-- AGREGANDO LOS DATOS A LA BASE DE DATOS