-- Comandos principales
CREATE DATABASE IF NOT EXISTS parquesMinAmbiente;
USE parquesMinAmbiente;



-- Creando las respectivas tablas
CREATE TABLE categoria(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE alojamiento(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    capacidad INT NOT NULL,
    categoria_id INT UNSIGNED NOT NULL,
    FOREIGN KEY(categoria_id) REFERENCES categoria(id)
);

CREATE TABLE parquesNaturales(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    dia INT(2) NOT NULL,
    mes INT(2) NOT NULL,
    anio INT(4) NOT NULL,
    superficie VARCHAR(20) NOT NULL
);

CREATE TABLE visitante(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    profesion VARCHAR(45) NOT NULL,
    alojamiento_id INT UNSIGNED NOT NULL,
    parquesNaturales_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, alojamiento_id, parquesNaturales_id),
    FOREIGN KEY(alojamiento_id) REFERENCES alojamiento(id),
    FOREIGN KEY(parquesNaturales_id) REFERENCES parquesNaturales(id)
);

CREATE TABLE areas(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    extension VARCHAR(25) NOT NULL,
    parquesNaturales_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, parquesNaturales_id),
    FOREIGN KEY(parquesNaturales_id) REFERENCES parquesNaturales(id) --
);

CREATE TABLE departamento(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL
);

CREATE TABLE departamento_has_parquesNaturales(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    departamento_id INT UNSIGNED NOT NULL,
    parquesNaturales_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, departamento_id, parquesNaturales_id),
    FOREIGN KEY(departamento_id) REFERENCES departamento(id),
    FOREIGN KEY(parquesNaturales_id) REFERENCES parquesNaturales(id)
);

CREATE TABLE entidadRes(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    departamento_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, departamento_id),
    FOREIGN KEY(departamento_id) REFERENCES departamento(id)
);

CREATE TABLE persConservacion(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    areas_id INT UNSIGNED NOT NULL,
    areas_parquesNaturales_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, areas_id, areas_parquesNaturales_id),
    FOREIGN KEY(areas_id) REFERENCES areas(id),
    FOREIGN KEY(areas_parquesNaturales_id) REFERENCES areas(parquesNaturales_id)
);

CREATE TABLE especialidad(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL,
    persConservacion_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, persConservacion_id),
    FOREIGN KEY(persConservacion_id) REFERENCES persConservacion(id)
);

CREATE TABLE entrada(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    numEntrada INT UNSIGNED NOT NULL,
    ubicacion VARCHAR(45) NOT NULL
);

CREATE TABLE persGestion(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    areas_id INT UNSIGNED NOT NULL,
    areas_parquesNaturales_id INT UNSIGNED NOT NULL,
    entrada_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, areas_id, areas_parquesNaturales_id, entrada_id),
    FOREIGN KEY(areas_id) REFERENCES areas(id),
    FOREIGN KEY(areas_parquesNaturales_id) REFERENCES areas(parquesNaturales_id),
    FOREIGN KEY(entrada_id) REFERENCES entrada(id)
);

CREATE TABLE persVigilancia(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    areas_id INT UNSIGNED NOT NULL,
    areas_parquesNaturales_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, areas_id, areas_parquesNaturales_id),
    FOREIGN KEY(areas_id) REFERENCES areas(id),
    FOREIGN KEY(areas_parquesNaturales_id) REFERENCES areas(parquesNaturales_id)
);

CREATE TABLE vehiculo(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    tipo VARCHAR(45) NOT NULL,
    marca VARCHAR(45) NOT NULL,
    persVigilancia_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, persVigilancia_id),
    FOREIGN KEY(persVigilancia_id) REFERENCES persVigilancia(id)
);

CREATE TABLE persInvestigador(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    titulacion VARCHAR(75) NOT NULL
);

CREATE TABLE funcion(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    persInvestigador_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, persInvestigador_id),
    FOREIGN KEY(persInvestigador_id) REFERENCES persInvestigador(id)
);

CREATE TABLE proyecto(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(75) NOT NULL,
    presupuesto VARCHAR(20) NOT NULL,
    fechaInicio DATETIME NOT NULL,
    fechaFin DATETIME NOT NULL,
    persInvestigador_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, persInvestigador_id),
    FOREIGN KEY(persInvestigador_id) REFERENCES persInvestigador(id)
);

CREATE TABLE tipoPersonal(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    persConservacion_id INT UNSIGNED NOT NULL,
    persGestion_id INT UNSIGNED NOT NULL,
    persVigilancia_id INT UNSIGNED NOT NULL,
    persInvestigador_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, persConservacion_id, persGestion_id, persVigilancia_id, persInvestigador_id),
    FOREIGN KEY(persConservacion_id) REFERENCES persConservacion(id),
    FOREIGN KEY(persGestion_id) REFERENCES persGestion(id),
    FOREIGN KEY(persVigilancia_id) REFERENCES persVigilancia(id),
    FOREIGN KEY(persInvestigador_id) REFERENCES persInvestigador(id)
);

CREATE TABLE personal(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    sueldo VARCHAR(20) NOT NULL,
    parquesNaturales_id INT UNSIGNED NOT NULL,
    tipoPersonal_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, parquesNaturales_id, tipoPersonal_id),
    FOREIGN KEY(parquesNaturales_id) REFERENCES parquesNaturales(id),
    FOREIGN KEY(tipoPersonal_id) REFERENCES tipoPersonal(id)
);

CREATE TABLE telefono(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    numCelular INT UNSIGNED NOT NULL,
    numFijo INT UNSIGNED NOT NULL,
    personal_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, personal_id),
    FOREIGN KEY(personal_id) REFERENCES personal(id)
);

CREATE TABLE documentoID(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    tipo VARCHAR(25) NOT NULL,
    numero INT(16) UNSIGNED NOT NULL,
    personal_id INT UNSIGNED NOT NULL,
    visitante_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, personal_id, visitante_id),
    FOREIGN KEY(personal_id) REFERENCES personal(id),
    FOREIGN KEY(visitante_id) REFERENCES visitante(id)
);

CREATE TABLE tipoEspecie(
	id INT UNSIGNED PRIMARY KEY UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(10) NOT NULL
);

CREATE TABLE especie(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    denCientifica VARCHAR(75) NOT NULL,
    denVulgar VARCHAR(75) NOT NULL,
    numTotal INT UNSIGNED NOT NULL,
    areas_id INT UNSIGNED NOT NULL,
    areas_parquesNaturales_id INT UNSIGNED NOT NULL,
    tipoEspecie_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, tipoEspecie_id),
    FOREIGN KEY(areas_id) REFERENCES areas(id),
    FOREIGN KEY(areas_parquesNaturales_id) REFERENCES areas(parquesNaturales_id),
    FOREIGN KEY(tipoEspecie_id) REFERENCES tipoEspecie(id)
);

CREATE TABLE proyecto_has_especie(
	id INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    proyecto_id INT UNSIGNED NOT NULL,
    especie_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(id, proyecto_id, especie_id),
    FOREIGN KEY(proyecto_id) REFERENCES proyecto(id),
    FOREIGN KEY(especie_id) REFERENCES especie(id)
);

ALTER TABLE alojamiento
ADD areas_id INT UNSIGNED NOT NULL,
ADD PRIMARY KEY(id, categoria_id, areas_id),
ADD FOREIGN KEY(areas_id) REFERENCES areas(id);




-- INSERCCIÓN DE 51 DATOS A LA BASE DE DATOS
INSERT INTO categoria(nombre, descripcion) VALUES
("Parque Nacional Natural", "Áreas extensas protegidas por el Estado, donde se conservan ecosistemas naturales y la biodiversidad."),
("Reserva Nacional Natural", "Áreas protegidas con fines científicos, investigación, educación ambiental o conservación de la fauna y flora."),
("Santuario de Fauna y Flora", "Áreas protegidas para la conservación de especies de fauna y flora silvestres."),
("Área Natural Única", "Áreas con características excepcionales desde el punto de vista geológico, geomorfológico, hidrológico, biótico o paisajístico."),
("Parque Natural Regional", "Áreas protegidas bajo la responsabilidad de las entidades territoriales, con características ecológicas, paisajísticas y culturales significativas."),
("Reserva Natural de la Sociedad Civil", "Áreas protegidas bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Manejo Especial", "Áreas con características especiales para la conservación y el desarrollo sostenible."),
("Distrito de Manejo Integrado", "Áreas con características especiales para la conservación y el desarrollo sostenible, con la participación de comunidades locales."),
("Reserva Forestal Protectora", "Áreas protegidas para la conservación de los suelos y la regulación hídrica."),
("Parque Arqueológico Nacional", "Áreas protegidas con fines de investigación, conservación y divulgación del patrimonio arqueológico."),
("Sitio de Interés Cultural", "Áreas con valor histórico, cultural o arqueológico que requieren protección especial."),
("Área de Reserva Forestal", "Áreas protegidas para la producción forestal y la conservación de los suelos."),
("Área de Manejo de Recursos Naturales", "Áreas con potencial para el aprovechamiento sostenible de los recursos naturales."),
("Área de Bosques Protectores", "Áreas protegidas para la conservación de los bosques y la regulación hídrica."),
("Humedal", "Áreas con ecosistemas acuáticos o terrestres con características hidrológicas especiales."),
("Área Marina Costera", "Áreas protegidas en el mar territorial y la zona contigua."),
("Área Protegida Marina", "Áreas protegidas en el mar territorial, la zona contigua y la zona económica exclusiva."),
("Área de Corales", "Áreas protegidas con arrecifes coralinos y otros ecosistemas marinos."),
("Área de Manglares", "Áreas protegidas con ecosistemas de manglares."),
("Área de Praderas Marinas", "Áreas protegidas con praderas marinas."),
("Área de Inundación", "Áreas con características especiales para la regulación hídrica."),
("Área de Restauración Ecológica", "Áreas destinadas a la recuperación de ecosistemas degradados."),
("Área de Conservación Privada", "Áreas protegidas bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Reserva Forestal Protectora Privada", "Áreas protegidas para la conservación de los suelos y la regulación hídrica, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Manejo de Recursos Naturales Privada", "Áreas con potencial para el aprovechamiento sostenible de los recursos naturales, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Bosques Protectores Privados", "Áreas protegidas para la conservación de los bosques y la regulación hídrica, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Humedal Privado", "Áreas con ecosistemas acuáticos o terrestres con características hidrológicas especiales, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Conservación Biológica", "Áreas destinadas a la protección de la biodiversidad y los ecosistemas naturales."),
("Área de Reserva de la Biosfera", "Áreas designadas por la UNESCO para promover la conservación de la biodiversidad y el desarrollo sostenible."),
("Área de Patrimonio Natural Mundial", "Áreas designadas por la UNESCO con valor excepcional universal desde el punto de vista natural."),
("Sitio Ramsar", "Humedales de importancia internacional para las aves acuáticas, designados por la Convención de Ramsar."),
("Área de Reserva de la Biosfera Privada", "Áreas designadas por la UNESCO para promover la conservación de la biodiversidad y el desarrollo sostenible, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Sitio Ramsar Privado", "Humedales de importancia internacional para las aves acuáticas, designados por la Convención de Ramsar, bajo la propiedad y responsabilidad de personas naturales o jurídicas de derecho privado."),
("Área de Interés Científico", "Áreas con valor científico especial para la investigación y la educación ambiental."),
("Área de Interés Paisajístico", "Áreas con valor paisajístico especial para la recreación y el turismo."),
("Área de Interés Histórico", "Áreas con valor histórico especial para la investigación y la divulgación del patrimonio cultural."),
("Área de Interés Arqueológico", "Áreas con valor arqueológico especial para la investigación y la divulgación del patrimonio arqueológico."),
("Área de Interés Paleontológico", "Áreas con valor paleontológico especial para la investigación y la divulgación del patrimonio paleontológico."),
("Área de Interés Geológico", "Áreas con valor geológico especial para la investigación y la divulgación del patrimonio geológico."),
("Área de Interés Espeleológico", "Áreas con valor espeleológico especial para la investigación y la divulgación del patrimonio espeleológico."),
("Área de Interés Hidrogeológico", "Áreas con valor hidrogeológico especial para la investigación y la divulgación del patrimonio hidrogeológico."),
("Área de Interés Minero", "Áreas con valor minero especial para la investigación y la divulgación del patrimonio minero."),
("Área de Interés Agropecuario", "Áreas con valor agropecuario especial para la investigación y la divulgación del patrimonio agropecuario."),
("Área de Interés Forestal", "Áreas con valor forestal especial para la investigación y la divulgación del patrimonio forestal."),
("Área de Interés Pesquero", "Áreas con valor pesquero especial para la investigación y la divulgación del patrimonio pesquero."),
("Área de Interés Acuícola", "Áreas con valor acuícola especial para la investigación y la divulgación del patrimonio acuícola."),
("Área de Interés Turístico", "Áreas con valor turístico especial para la recreación y el turismo."),
("Área de Interés Cultural Inmaterial", "Áreas con valor cultural inmaterial especial para la investigación y la divulgación del patrimonio cultural inmaterial."),
("Área de Interés Artesanal", "Áreas con valor artesanal especial para la investigación y la divulgación del patrimonio artesanal."),
("Área de Interés Gastronómico", "Áreas con valor gastronómico especial para la investigación y la divulgación del patrimonio gastronómico."),
("Área de Interés Medicinal", "Áreas con valor medicinal especial para la investigación y la divulgación del patrimonio medicinal.");


INSERT INTO alojamiento(nombre, capacidad, categoria_id) VALUES
("Cabañas Rústicas Chía", 4, 1),
("Glamping Bosque Esmeralda", 2, 1),
("Hotel Tayrona del Mar", 10, 2),
("Ecolodge Sierra Nevada", 8, 3),
("Hospedaje Familiar Ulloa", 5, 5),
("Apartamentos Villa de Leyva", 6, 5),
("Hotel Mancora", 12, 2),
("Cabañas La Chorrera", 3, 1),
("Posada Guatavita", 4, 5),
("Hotel Biodiversidad", 15, 3),
("Cabañas San Jacinto", 7, 1),
("Lodge Mamá Natura", 6, 3),
("Hostería El Mirador", 8, 5),
("Hotel Boutique La Candelaria", 10, 2),
("Cabañas Termales Calarcá", 5, 1),
("Glamping La Palma", 2, 1),
("Hotel Santa Marta Marriott", 18, 2),
("Ecolodge Río Negro", 6, 3),
("Hospedaje Familiar Popayán", 4, 5),
("Apartamentos Cartagena Histórica", 7, 5),
("Hotel Mocoa", 14, 2),
("Cabañas Neusa", 3, 1),
("Posada Salento", 4, 5),
("Hotel Yakushima", 15, 3),
("Cabañas Providencia", 7, 1),
("Lodge Gotsezé", 6, 3),
("Hostería Panaca", 8, 5),
("Hotel Boutique Chapinero", 10, 2),
("Cabañas Termales Tolima", 5, 1),
("Glamping Ibagué", 2, 1),
("Hotel Valledupar Hilton", 18, 2),
("Ecolodge Villa Leyva", 6, 3),
("Hospedaje Familiar Tunja", 4, 5),
("", 7, 5),
("", 14, 2),
("", 3, 1),
("", 4, 5),
("", 15, 3),
("", 7, 1),
("", 6, 3),
("", 8, 5),
("", 10, 2),
("", , ),
("", , ),
("", , ),
("", , ),
("", , ),
("", , ),
("", , ),
("", , ),
("", , );


INSERT INTO parquesNaturales(nombre, dia, mes, anio, superficie) VALUES 
	("Parque Nacional Natural Cordillera de Los Picachos", 02, 05, 1977, "287.493,57"),
    ("Santuario de Fauna y Flora Iguaque", 02, 05, 1977, "6.888"),
    ("Parque Nacional Natural Serranía de Los Yariguíes", 13, 05, 2005, "59.288"),
    ("Parque Nacional Natural Río Puré", 05, 08, 2002, "970.643"),
    ("Parque Nacional Natural Serranía de los Churumbelos", 23, 07, 2007, "97.239"),
    ("Parque Nacional Natural Reserva Natural Cordillera Beata", 28, 06, 2022, "3.312,54"),
    ("Parque Nacional Natural Paramillo", 06, 06, 1977, "504.643,74"),
    ("Parque Nacional Natural Corales de Profundidad", 12, 04, 2013, "142.195,15")