-- CREANDO Y USANDO LA BASE DE DATOS "jardineria"
CREATE DATABASE IF NOT EXISTS jardineria;
USE jardineria;



-- DEFINICIÓN DE CONSULTAS
/* Consulta n°1
Devuelve un listado con el código de oficina y la ciudad donde hay oficinas
*/
SELECT codigo_oficina AS codOficina, ciudad 
	FROM oficina;


/* Consulta n°2
Devuelve un listado con la ciudad y el teléfono de las oficinas de España
*/
SELECT ciudad, telefono
	FROM oficina
    WHERE pais = "España";


/* Consulta n°3
Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
*/
SELECT nombre, concat(apellido1, ' ', if(apellido2 is not null, apellido2, '')) AS apellidos, email 
	FROM empleado
    WHERE codigo_jefe = 7;


/* Consulta n°4
Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
*/
SELECT puesto, nombre, concat(apellido1, ' ', if(apellido2 is not null, apellido2, '')) AS apellidos, email
	FROM empleado
    WHERE codigo_jefe is null;


/* Consulta n°5
Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
*/
SELECT nombre, concat(apellido1, ' ', if(apellido2 is not null, apellido2, '')) AS apellidos, puesto
	FROM empleado
    WHERE puesto <> 'Representante Ventas';


/* Consulta n°6
Devuelve un listado con el nombre de los todos los clientes españoles.
*/
SELECT nombre_cliente
	FROM cliente
    WHERE pais = "Spain";


/* Consulta n°7
Devuelve un listado con los distintos estados por los que puede pasar un pedido.
*/
SELECT estado
	FROM pedido;


/* Consulta n°8
Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Utilizando
Resuelva la consulta: la función YEAR de MySQL.
*/
SELECT DISTINCT codigo_cliente, YEAR(fecha_pago) AS fechaPago
	FROM pago
    GROUP BY codigo_cliente, fecha_pago
    HAVING YEAR(fecha_pago) = 2008;


/* Consulta n°9
Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos.
Resuelva la consulta: Utilizando la función DATE_FORMAT de MySQL.
*/
SELECT DISTINCT codigo_cliente, DATE_FORMAT(fecha_pago, "%Y") AS fechaPago
	FROM pago
    GROUP BY codigo_cliente, fecha_pago
    HAVING DATE_FORMAT(fecha_pago, "%Y") = 2008;


/* Consulta n°10
Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. 
Resuelva la consulta: Sin utilizar ninguna de las funciones anteriores.
*/
SELECT DISTINCT codigo_cliente, SUBSTR(YEARWEEK(fecha_pago), 1, 4) AS fechaPago
	FROM pago
    WHERE SUBSTR(YEARWEEK(fecha_pago), 1, 4) = 2008;


/* Consulta n°11
Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega 
de los pedidos que no han sido entregados a tiempo.
*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	FROM pedido
    WHERE DATEDIFF(fecha_esperada, fecha_entrega) < 0;


/* Consulta n°12
Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos 
cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
Resuelva la consulta: Utilizando la función ADDDATE de MySQL.
*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	FROM pedido
    WHERE ADDDATE(fecha_entrega, INTERVAL 2 DAY) = fecha_esperada;


/* Consulta n°13
Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos 
cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
Resuelva la consulta: Utilizando la función DATEDIFF de MySQL.
*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	FROM pedido
    WHERE DATEDIFF(fecha_esperada, fecha_entrega) = 2;


/* Consulta n°14
Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos 
cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
Resuelva la consulta: ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?
*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	FROM pedido
    WHERE fecha_esperada - fecha_entrega = 2;

SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	FROM pedido
    WHERE fecha_entrega + 2 = fecha_esperada;


/* Consulta n°15
Devuelve un listado de todos los pedidos que fueron en 2009.
*/
SELECT *
	FROM pedido
    WHERE YEAR(fecha_pedido) = 2009;


/* Consulta n°16
Devuelve un listado de todos los pedidos que han sido  en el mes de enero de cualquier año.
*/
SELECT *
	FROM pedido
    WHERE MONTH(fecha_pedido) = 1;


/* Consulta n°17
Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. 
Ordene el resultado de mayor a menor.
*/
SELECT *
	FROM pago
    WHERE YEAR(fecha_pago) = 2008 AND forma_pago = "PayPal"
    ORDER BY fecha_pago DESC;


/* Consulta n°18
Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que 
no deben aparecer formas de pago repetidas.
*/
SELECT DISTINCT forma_pago
	FROM pago;


/* Consulta n°19
Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 
unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar 
los de mayor precio.
*/
SELECT *
	FROM producto
    WHERE gama = "Ornamentales" AND cantidad_en_stock > 100
    ORDER BY precio_venta DESC;


/* Consulta n°20
Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código 
de empleado 11 o 30.
*/
SELECT *
	FROM cliente
    WHERE ciudad = "Madrid" AND codigo_empleado_rep_ventas BETWEEN 11 AND 30;



-- CONSULTAS MULTITABLAS
/* Consulta n°21
Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
*/
SELECT C.nombre_cliente, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, E.puesto
	FROM cliente AS C
    INNER JOIN empleado AS E ON C.codigo_empleado_rep_ventas = E.codigo_empleado
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°22
Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
*/
SELECT C.nombre_cliente, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, P.forma_pago, E.puesto
	FROM pago AS P
    INNER JOIN cliente AS C ON P.codigo_cliente = C.codigo_cliente
    INNER JOIN empleado AS E ON C.codigo_empleado_rep_ventas = E.codigo_empleado
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°23
Muestra el nombre de los clientes que  hayan realizado pagos junto con el nombre de sus representantes de ventas.
*/
SELECT FCP.nombre_cliente, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, FCP.forma_pago, E.puesto
	FROM(
		SELECT *
        FROM pago AS P
        NATURAL JOIN cliente AS C
    ) FCP  #FCP = Filtrado de Cliente por Pago
    INNER JOIN empleado AS E ON FCP.codigo_empleado_rep_ventas = E.codigo_empleado
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°24
Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de 
la oficina a la que pertenece el representante.
*/
SELECT C.nombre_cliente, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, O.ciudad AS ciudad_oficina, P.forma_pago, E.puesto
	FROM pago AS P
    INNER JOIN cliente AS C ON P.codigo_cliente = C.codigo_cliente
    INNER JOIN empleado AS E ON C.codigo_empleado_rep_ventas = E.codigo_empleado
    INNER JOIN oficina AS O ON E.codigo_oficina = O.codigo_oficina
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°25
Devuelve el nombre de los clientes que  hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la 
oficina a la que pertenece el representante. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
*/
SELECT 	C.nombre_cliente, 
		CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, 
        O.ciudad AS ciudad_oficina, IF(O.ciudad = "Fuenlabrada", CONCAT(O.linea_direccion1, ' ', 
        IF(O.linea_direccion2 IS NOT NULL, O.linea_direccion2, '')), '') AS direccion_oficina, 
        P.forma_pago, E.puesto
	FROM pago AS P
    INNER JOIN cliente AS C ON P.codigo_cliente = C.codigo_cliente
    INNER JOIN empleado AS E ON C.codigo_empleado_rep_ventas = E.codigo_empleado
    INNER JOIN oficina AS O ON E.codigo_oficina = O.codigo_oficina
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°26
Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina 
a la que pertenece el representante.
*/
SELECT C.nombre_cliente, CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_representante, O.ciudad, E.puesto
	FROM cliente AS C
    INNER JOIN empleado AS E ON C.codigo_empleado_rep_ventas = E.codigo_empleado
    INNER JOIN oficina AS O ON E.codigo_oficina = O.codigo_oficina
    WHERE E.puesto = "Representante Ventas";


/* Consulta n°27
Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
*/
SELECT	CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombre_empleado,
		CONCAT(J.nombre, ' ', J.apellido1, ' ', IF(J.apellido2 IS NOT NULL, J.apellido2, '')) AS nombre_jefe
	FROM (
		SELECT *
        FROM empleado
    ) AS E
    INNER JOIN empleado AS J ON E.codigo_jefe = J.codigo_empleado;


/* Consulta n°28
Devuelve un listado que muestre el nombre de cada empleados, el nombre de su 
jefe y el nombre del jefe de sus jefe.
*/
SELECT 	DISTINCT CONCAT(E.nombre, ' ', E.apellido1, ' ', IF(E.apellido2 IS NOT NULL, E.apellido2, '')) AS nombreJefe, E.puesto,
		nombreEmpleado, SFEJ.puesto
	FROM(
		SELECT 	DISTINCT E.codigo_empleado,
				CONCAT(E.nombre,' ', E.apellido1,' ',IF(E.apellido2 IS NOT NULL, E.apellido2,'')) AS nombreEmpleado, E.codigo_jefe, E.puesto
		FROM(
			SELECT 	codigo_empleado,
					CONCAT(nombre, ' ', apellido1, ' ', IF(apellido2 IS NOT NULL, apellido2, '')) AS nombreEmpleado, codigo_jefe, puesto
			FROM empleado
        ) AS PFE  #PFE = Primer Filtrado de Empleados
        INNER JOIN empleado AS E ON PFE.codigo_jefe = E.codigo_jefe
    ) AS SFEJ  #SFEJ = Segundo Filtrado de Empleados por su Jefe
    INNER JOIN empleado AS E ON SFEJ.codigo_jefe = E.codigo_jefe;


/* Consulta n°29
Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
*/
SELECT C.nombre_cliente
	FROM pedido AS P
    INNER JOIN cliente AS C ON P.codigo_cliente = C.codigo_cliente
    WHERE DATEDIFF(fecha_esperada, fecha_entrega) < 0;


/* Consulta n°30
Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
*/
SELECT DISTINCT C.codigo_cliente, C.nombre_cliente, Pr.gama
	FROM detalle_pedido AS DP
    INNER JOIN pedido AS P ON DP.codigo_pedido = P.codigo_pedido
    INNER JOIN cliente AS C ON P.codigo_cliente = C.codigo_cliente
    INNER JOIN producto AS Pr ON DP.codigo_producto = Pr.codigo_producto;