USE pizzas;

-- PUNTO 1
DELIMITER $$;
DROP FUNCTION IF EXISTS fc_calcular_subtotal_pizza

CREATE FUNCTION fc_calcular_subtotal_pizza(p_pizza_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC 
READS SQL DATA
BEGIN
    DECLARE v_pizza DECIMAL(10,2);
    DECLARE v_ingredientes DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);

    SELECT SUM(precio) INTO v_ingredientes
    FROM ingrediente;

    SELECT precio INTO v_pizza 
    FROM producto_presentacion
    WHERE presentacion_id = 2 AND producto_id = 2;

    SET v_total = (v_pizza + v_ingredientes);
    RETURN (v_total);
END $$

DELIMITER ;

SELECT fc_calcular_subtotal_pizza(1) AS CasiTotal

SELECT * FROM ingrediente

SELECT * FROM producto_presentacion


-- PUNTO 2
DELIMITER //

DROP FUNCTION IF EXISTS fc_descuento_por_cantidad //

CREATE FUNCTION fc_descuento_por_cantidad (p_cantidad INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE v_descuento DECIMAL(5,2);

    IF p_cantidad >= 5 THEN
        SET v_descuento = 0.10; 
    ELSE
        SET v_descuento = 0.00; 
    END IF;

    RETURN v_descuento;
END //

DELIMITER ;

SELECT fc_descuento_por_cantidad(3) AS descuento;
SELECT fc_descuento_por_cantidad(5) AS descuento; 
SELECT fc_descuento_por_cantidad(10) AS descuento;

-- PUNTO 3
DELIMITER $$

DROP FUNCTION IF EXISTS fc_precio_final_pedido $$

CREATE FUNCTION fc_precio_final_pedido (p_cantidad INT, p_pizza_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_descuento DECIMAL(5,2);
    DECLARE v_total DECIMAL(10,2);

    SET v_subtotal = fc_calcular_subtotal_pizza(p_pizza_id);

    SET v_descuento = fc_descuento_por_cantidad(p_cantidad);

    SET v_total = v_subtotal * p_cantidad * (1 - v_descuento);

    RETURN v_total;
END $$

DELIMITER ;

SELECT fc_precio_final_pedido(6, 1) AS precio_final;