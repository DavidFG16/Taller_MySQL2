USE pizzas;
--PUNTO 1 (NO ENTENDI)
--PUNTO 2
DELIMITER //
DROP PROCEDURE IF EXISTS ps_actualizar_precio_pizza

CREATE PROCEDURE ps_actualizar_precio_pizza (
    IN p_pizza_id INT,
    IN p_presentacion_id INT,
    IN p_nuevo_precio DECIMAL(10,2)
)
BEGIN

    IF p_nuevo_precio <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio debe ser mayor que 0';
    END IF;


    UPDATE producto_presentacion
    SET precio = p_nuevo_precio
    WHERE producto_id = p_pizza_id AND presentacion_id = p_presentacion_id;


    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró la pizza o presentación especificada';
    END IF;
END //

DELIMITER ;

CALL ps_actualizar_precio_pizza(2, 1, 12.50);

-- La siguiente consulta es para verificar si se actualizó el precio o no, se tienen que cambiar los ID's del 'WHERE' 
-- dependiendo del producto y la presentacion de dicho producto al que se le cambio el precio 
SELECT p.nombre AS Pizza, pr.nombre AS Presentacion, pp.precio
FROM producto_presentacion AS pp
JOIN producto  AS p ON pp.producto_id = p.id
JOIN presentacion AS pr ON pp.presentacion_id = pr.id
WHERE pp.producto_id = 2 AND pp.presentacion_id = 1;

--PUNTO 3 (NO ENTENDI)

--PUNTO 4 
DELIMITER //

DROP PROCEDURE IF EXISTS ps_cancelar_pedido //

CREATE PROCEDURE ps_cancelar_pedido (IN p_pedido_id INT)
BEGIN
    -- Declara manejador de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error al cancelar el pedido';
    END;

    -- Validación
    IF NOT EXISTS (SELECT 1 FROM pedido WHERE id = p_pedido_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe ingresar un ID de Pedido Existente';
    END IF;

    START TRANSACTION;
        -- Cancelar Pedido
        UPDATE pedido
        SET estado = 'Cancelado'
        WHERE id = p_pedido_id;

        -- DELETE detalle_pedido_producto
        DELETE FROM detalle_pedido_producto
        WHERE detalle_id IN (SELECT id FROM detalle_pedido WHERE pedido_id = p_pedido_id);

        -- DELETE detalle_pedido
        DELETE FROM detalle_pedido
        WHERE pedido_id = p_pedido_id;

        --líneas eliminadas
        SELECT ROW_COUNT() AS filas_eliminadas;
    COMMIT;
END //

DELIMITER ;

CALL ps_cancelar_pedido(2)

SELECT * FROM pedido

SELECT * FROM detalle_pedido
