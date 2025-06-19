USE pizzas;

-- PUNTO 1

DELIMITER // 
DROP TRIGGER IF EXISTS tg_before_insert_detalle_pedido //

CREATE TRIGGER IF NOT EXISTS tg_before_insert_detalle_pedido
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad < 1 THEN
        SIGNAL SQLSTATE '40001'
         SET MESSAGE_TEXT = 'La cantidad de ser minimo 1';

    END IF;
END //
DELIMITER ;

INSERT INTO detalle_pedido VALUES(NULL, LAST_INSERT_ID(), -1);


-- PUNTO 2
