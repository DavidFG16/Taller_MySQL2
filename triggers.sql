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

DELIMITER // 
DROP TRIGGER IF EXISTS tg_after_insert_detalle_pedido_pizza //

CREATE TRIGGER IF NOT EXISTS tg_after_insert_detalle_pedido_pizza
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    -- detalle_pedido_pizza no existe en la BD
    END IF;
END //
DELIMITER ;


-- PUNTO 3
DROP TABLE IF EXISTS auditoria_precios;
CREATE TABLE IF NOT EXISTS auditoria_precios (
  id                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  precio_new        INT NOT NULL,
  precio_old        INT NOT NULL,
  fecha_cambio      DATETIME NOT NULL DEFAULT NOW(),
  usuario_creador   VARCHAR(50) NOT NULL
);


DELIMITER // 
DROP TRIGGER IF EXISTS tg_after_update_pizza_precio //

CREATE TRIGGER IF NOT EXISTS tg_after_update_pizza_precio
AFTER UPDATE ON producto_presentacion
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_precios(precio_new, precio_old, fecha_cambio, usuario_creador) 
    VALUES (NEW.precio, OLD.precio, NOW(), USER());
END //
DELIMITER ;

UPDATE producto_presentacion SET precio = 12 
WHERE producto_id = 1 AND presentacion_id = 1

SELECT * FROM producto_presentacion

SELECT * FROM auditoria_precios


-- PUNTO 4

DELIMITER // 
DROP TRIGGER IF EXISTS tg_before_delete_pizza //

CREATE TRIGGER IF NOT EXISTS tg_before_delete_pizza
BEFORE DELETE ON pizza
FOR EACH ROW
BEGIN
    -- detalle_pedido_pizza no existe en la BD
END //
DELIMITER ;


-- PUNTO 5 
ALTER TABLE pedido ADD COLUMN facturacion VARCHAR(50) NOT NULL DEFAULT 'Sin facturar';

DELIMITER // 
DROP TRIGGER IF EXISTS tg_after_insert_factura //

CREATE TRIGGER IF NOT EXISTS tg_after_insert_factura
AFTER INSERT ON factura
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET facturacion = 'Facturado' 
    WHERE NEW.pedido_id = pedido.id;
END //
DELIMITER ;

INSERT INTO factura(total, fecha, pedido_id, cliente_id) VALUES
(35000, '2025-06-10 12:05:00', 4, 4);

SELECT * FROM pedido

SELECT * FROM factura

-- PUNTO 6

DELIMITER // 
DROP TRIGGER IF EXISTS tg_after_delete_detalle_pedido_pizza //

CREATE TRIGGER IF NOT EXISTS tg_after_delete_detalle_pedido_pizza
AFTER DELETE
FOR EACH ROW
BEGIN
    -- No existe detalle_pedido_pizza en la BD
END //
DELIMITER ;


-- PUNTO 7

CREATE TABLE IF NOT EXISTS notificacion_stock_bajo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ingrediente_id INT NOT NULL,
    mensaje VARCHAR(255) NOT NULL,
    fecha_notificacion DATETIME NOT NULL,
    stock_actual INT NOT NULL,
    FOREIGN KEY (ingrediente_id) REFERENCES ingrediente(id)
);

DELIMITER //

CREATE TRIGGER tg_after_update_ingrediente_stock
AFTER UPDATE ON ingrediente
FOR EACH ROW
BEGIN
    IF NEW.stock < 10 THEN
        INSERT INTO notificacion_stock_bajo (ingrediente_id, mensaje, fecha_notificacion, stock_actual)
        VALUES (
            NEW.id,
            CONCAT('Stock bajo para ', NEW.nombre, ': solo ', NEW.stock, ' unidades disponibles.'),
            NOW(),
            NEW.stock
        );
    END IF;
END//

DELIMITER ;

UPDATE ingrediente SET stock = 5 WHERE id = 1

SELECT * FROM ingrediente;
SELECT * FROM notificacion_stock_bajo

