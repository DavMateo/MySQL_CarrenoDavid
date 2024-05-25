CREATE DATABASE dia8;
USE dia8;


CREATE TABLE productos(
	id INT NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(100),
    precio DECIMAL(10,2),
    CONSTRAINT pk_productos PRIMARY KEY(id)
);


INSERT INTO productos VALUES
(1, "Pepito", 23.20),
(2, "MousePad", 100000.21),
(3, "Espionap", 2500.25),
(4, "Bob-Esponja", 1500.25),
(5, "Cary", 23540000.23),
(6, "OvulAPP", 198700.23),
(7, "PapayAPP", 2000.00),
(8, "Menosprecio", 3800.00),
(9, "CariciasOlfer", 2300.00),
(10, "Perfume La Cumbre", 35000.25),
(11, "Nevera M800", 3000.12),
(12, "Crema Suave", 2845.00),
(13, "Juego de Mesa La Cabellera", 9800.00);


/*
Para crear una función la cuál me retorne el
nombre del producto con el precio más iva (19%)
*/
DELIMITER //
CREATE FUNCTION totalConIVA(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
	RETURN precio + ((precio * 19) / 100);
END //
DELIMITER ;

SELECT totalConIVA(25000.300);