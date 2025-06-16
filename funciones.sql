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