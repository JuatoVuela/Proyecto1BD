DROP DATABASE IF EXISTS banco;
CREATE DATABASE banco;
USE banco;

CREATE TABLE Ciudad (
    cod_postal SMALLINT UNSIGNED NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    PRIMARY KEY (cod_postal)
) ENGINE = InnoDB;

CREATE TABLE Sucursal (
    nro_suc SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    horario VARCHAR(45) NOT NULL,
    cod_postal SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_suc),
    FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
) ENGINE = InnoDB;

CREATE TABLE Empleado (
    legajo SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    apellido VARCHAR(45) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL,
    nro_doc INT UNSIGNED NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    cargo VARCHAR(45) NOT NULL,
    password CHAR(64) NOT NULL,
    nro_suc SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (legajo),
    FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
) ENGINE = InnoDB;

CREATE TABLE Cliente (
    nro_cliente INT UNSIGNED NOT NULL AUTO_INCREMENT,
    apellido  VARCHAR(45) NOT NULL,
    nombre VARCHAR(45) NOT NULL,
    tipo_doc VARCHAR(20) NOT NULL,
    nro_doc INT UNSIGNED NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    telefono VARCHAR(45) NOT NULL,
    fecha_nac DATE NOT NULL,
    PRIMARY KEY (nro_cliente)
) ENGINE = InnoDB;

CREATE TABLE Plazo_Fijo (
    nro_plazo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    capital DECIMAL(16,2) UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
    interes DECIMAL(16,2) UNSIGNED NOT NULL,
    nro_suc SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_plazo),
    FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
) ENGINE = InnoDB;

CREATE TABLE Tasa_Plazo_Fijo (
    periodo SMALLINT UNSIGNED NOT NULL,
    monto_inf DECIMAL(16,2) UNSIGNED NOT NULL,
    monto_sup DECIMAL(16,2) UNSIGNED NOT NULL,
    tasa DECIMAL(4,2) UNSIGNED NOT NULL,
    PRIMARY KEY (periodo, monto_inf, monto_sup)
) ENGINE = InnoDB;

CREATE TABLE Plazo_Cliente (
    nro_plazo INT UNSIGNED NOT NULL,
    nro_cliente INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_plazo, nro_cliente),
    FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo (nro_plazo),
    FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
) ENGINE = InnoDB;

CREATE TABLE Prestamo (
    nro_prestamo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    cant_meses SMALLINT UNSIGNED NOT NULL,
    monto DECIMAL(10,2) UNSIGNED NOT NULL,
    tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
    interes DECIMAL(9,2) UNSIGNED NOT NULL,
    valor_cuota DECIMAL(9,2) UNSIGNED NOT NULL,
    legajo SMALLINT UNSIGNED NOT NULL,
    nro_cliente INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_prestamo),
    FOREIGN KEY (legajo) REFERENCES Empleado (legajo),
    FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente)
) ENGINE = InnoDB;

CREATE TABLE Pago (
    nro_prestamo INT UNSIGNED NOT NULL,
    nro_pago SMALLINT UNSIGNED NOT NULL,
    fecha_venc DATE NOT NULL,
    fecha_pago DATE,
    PRIMARY KEY (nro_prestamo, nro_pago),
    FOREIGN KEY (nro_prestamo) REFERENCES Prestamo (nro_prestamo)
) ENGINE = InnoDB;

CREATE TABLE Tasa_Prestamo (
    periodo SMALLINT UNSIGNED NOT NULL,
    monto_inf DECIMAL(10,2) UNSIGNED NOT NULL,
    monto_sup DECIMAL(10,2) UNSIGNED NOT NULL,
    tasa DECIMAL(4,2) UNSIGNED NOT NULL,
    PRIMARY KEY (periodo, monto_inf, monto_sup)
) ENGINE = InnoDB;

CREATE TABLE Caja_Ahorro (
    nro_ca INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CBU BIGINT UNSIGNED NOT NULL,
    saldo DECIMAL(16,2) UNSIGNED NOT NULL,
    PRIMARY KEY (nro_ca)
) ENGINE = InnoDB;

CREATE TABlE Cliente_CA (
    nro_cliente INT UNSIGNED NOT NULL,
    nro_ca INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_cliente, nro_ca),
    FOREIGN KEY (nro_cliente) REFERENCES Cliente (nro_cliente),
    FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
) Engine = InnoDB;

CREATE TABLE Tarjeta (
    nro_tarjeta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PIN CHAR(64) NOT NULL,
    CVT CHAR(64) NOT NULL,
    fecha_venc DATE NOT NULL,
    nro_cliente INT UNSIGNED NOT NULL,
    nro_ca INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_tarjeta),
    FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA (nro_cliente, nro_ca)
) Engine = InnoDB;

CREATE TABLE Caja (
    cod_caja INT UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (cod_caja)
) ENGINE = InnoDB;

CREATE TABLE Ventanilla (
    cod_caja INT UNSIGNED NOT NULL,
    nro_suc SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (cod_caja),
    FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja),
    FOREIGN KEY (nro_suc) REFERENCES Sucursal (nro_suc)
) Engine = InnoDB;

CREATE TABLE ATM (
    cod_caja INT UNSIGNED NOT NULL,
    cod_postal SMALLINT UNSIGNED NOT NULL,
    direccion VARCHAR(45) NOT NULL,
    PRIMARY KEY (cod_caja),
    FOREIGN KEY (cod_caja) REFERENCES Caja(cod_caja),
    FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal)
) Engine = InnoDB;

CREATE TABLE Transaccion (
    nro_trans BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    monto DECIMAL(16,2) UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans)
) Engine = InnoDB;

CREATE TABLE Debito (
    nro_trans BIGINT UNSIGNED NOT NULL,
    descripcion TEXT,
    nro_cliente INT UNSIGNED NOT NULL,
    nro_ca INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans),
    FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA (nro_cliente, nro_ca)
) Engine = InnoDB;

CREATE TABLE Transaccion_por_caja (
    nro_trans BIGINT UNSIGNED NOT NULL,
    cod_caja INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES Transaccion (nro_trans),
    FOREIGN KEY (cod_caja) REFERENCES Caja (cod_caja)
) Engine = InnoDB;

CREATE TABLE Deposito (
    nro_trans BIGINT UNSIGNED NOT NULL,
    nro_ca INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans),
    FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro (nro_ca)
) Engine = InnoDB;

CREATE TABLE Extraccion (
    nro_trans BIGINT UNSIGNED NOT NULL,
    nro_cliente INT UNSIGNED NOT NULL,
    nro_ca INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans),
    FOREIGN KEY (nro_cliente, nro_ca) REFERENCES Cliente_CA (nro_cliente, nro_ca)
) Engine = InnoDB;

CREATE TABLE Transferencia (
    nro_trans BIGINT UNSIGNED NOT NULL,
    nro_cliente INT UNSIGNED NOT NULL,
    origen INT UNSIGNED NOT NULL,
    destino INT UNSIGNED NOT NULL,
    PRIMARY KEY (nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES Transaccion_por_caja (nro_trans),
    FOREIGN KEY (nro_cliente, origen) REFERENCES Cliente_CA (nro_cliente, nro_ca),
    FOREIGN KEY (destino) REFERENCES Caja_Ahorro (nro_ca)
) Engine = InnoDB;

-- Create the view
CREATE VIEW trans_cajas_ahorro AS
    SELECT 
        d.nro_ca,
        ca.saldo,
        t.nro_trans,
        t.fecha,
        t.hora,
        'debito' AS tipo,
        t.monto,
        NULL AS cod_caja,
        c.nro_cliente,
        c.tipo_doc,
        c.nro_doc,
        c.nombre,
        c.apellido,
        NULL AS destino
    FROM Debito AS d
    JOIN Transaccion AS t ON d.nro_trans = t.nro_trans
    JOIN Caja_Ahorro AS ca ON d.nro_ca = ca.nro_ca 
    JOIN Cliente AS c ON d.nro_cliente = c.nro_cliente

    UNION ALL
    
    SELECT 
        dep.nro_ca,
        ca.saldo,
        t.nro_trans,
        t.fecha,
        t.hora,
        'deposito' AS tipo,
        t.monto,
        tpc.cod_caja,
        NULL AS nro_cliente,
        NULL AS tipo_doc,
        NULL AS nro_doc,
        NULL AS nombre,
        NULL AS apellido,
        NULL AS destino
    FROM Deposito dep
    JOIN Transaccion_por_caja tpc on dep.nro_trans = tpc.nro_trans
    JOIN Transaccion t ON tpc.nro_trans = t.nro_trans
    JOIN Caja_Ahorro ca ON dep.nro_ca = ca.nro_ca
    
    UNION ALL

    SELECT
        e.nro_ca,
        ca.saldo,
        t.nro_trans,
        t.fecha,
        t.hora,
        'extraccion' AS tipo,
        t.monto,
        tpc.cod_caja,
        c.nro_cliente,
        c.tipo_doc,
        c.nro_doc,
        c.nombre,
        c.apellido,
        NULL AS destino
    FROM Extraccion e
    JOIN Transaccion_por_caja tpc ON e.nro_trans = tpc.nro_trans
    JOIN Transaccion t ON tpc.nro_trans = t.nro_trans
    JOIN Caja_Ahorro ca ON e.nro_ca = ca.nro_ca
    JOIN Cliente c ON e.nro_cliente = c.nro_cliente

    UNION ALL

    SELECT
        tr.origen AS nro_ca,
        ca.saldo,
        t.nro_trans,
        t.fecha,
        t.hora,
        'transferencia' AS tipo,
        t.monto,
        tpc.cod_caja,
        c.nro_cliente,
        c.tipo_doc,
        c.nro_doc,
        c.nombre,
        c.apellido,
        tr.destino AS destino
    FROM Transferencia tr
    JOIN Transaccion_por_caja tpc ON tr.nro_trans = tpc.nro_trans
    JOIN Transaccion t ON tpc.nro_trans = t.nro_trans
    JOIN Caja_Ahorro ca ON tr.origen = ca.nro_ca
    JOIN Cliente c ON tr.nro_cliente = c.nro_cliente;
    
DROP USER IF EXISTS 'admin'@'localhost';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;
GRANT CREATE USER ON *.* TO 'admin'@'localhost';

DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS 'empleado'@'%';
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';
GRANT SELECT ON banco.Empleado TO 'empleado'@'%';
GRANT SELECT ON banco.Sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT ON banco.Tasa_Prestamo TO 'empleado'@'%';

GRANT SELECT, INSERT ON banco.Prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Plazo_Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Caja_Ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.Tarjeta TO 'empleado'@'%';

GRANT SELECT, INSERT, UPDATE ON banco.Cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.Pago TO 'empleado'@'%';

GRANT EXECUTE ON PROCEDURE banco.crear_prestamo TO 'empleado'@'%';
GRANT EXECUTE ON PROCEDURE banco.pagar_cuota TO 'empleado'@'%';
GRANT EXECUTE ON PROCEDURE banco.lista_morosos TO 'empleado'@'%';

DROP USER IF EXISTS 'atm'@'%';
CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';
GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.Tarjeta TO 'atm'@'%';

GRANT EXECUTE ON PROCEDURE banco.transferir TO 'atm'@'%';
GRANT EXECUTE ON PROCEDURE banco.extraer TO 'atm'@'%';
GRANT EXECUTE ON PROCEDURE banco.ultimos_movimientos TO 'atm'@'%';
GRANT EXECUTE ON PROCEDURE banco.movimientos_por_periodo TO 'atm'@'%';

FLUSH PRIVILEGES;


-- Ejercicio 1-b)

DROP PROCEDURE IF EXISTS extraer;

DELIMITER //
CREATE PROCEDURE extraer(IN nro_atm INT, IN tarjeta BIGINT, IN monto DECIMAL (16, 2), OUT resultado VARCHAR(100))
BEGIN
    DECLARE v_nro_cliente INT;
    DECLARE v_nro_ca INT;
    DECLARE v_saldo DECIMAL(16, 2);
    DECLARE v_nro_trans BIGINT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET resultado = 'Error: la transaccion fue cancelada';
    END;

    START TRANSACTION;

    SELECT t.nro_cliente, t.nro_ca INTO v_nro_cliente, v_nro_ca FROM Tarjeta t WHERE t.nro_tarjeta = tarjeta;

    IF NOT EXISTS (SELECT * FROM ATM a WHERE a.cod_caja = a.nro_atm) THEN
        SET resultado = 'Error: odigo de ATM invalido';
        ROLLBACK; 

    ELSEIF v_nro_ca IS NULL THEN
        SET resultado = 'Error: la tarejta no existe';
        ROLLBACK;

    ELSEIF monto <= 0 THEN
        SET resultado = 'Error: el monto debe ser positivo';
        ROLLBACK;
    
    ELSE
        SELECT ca.saldo INTO v_saldo FROM Caja_Ahorro ca WHERE ca.nro_ca = v_nro_ca;

    FOR UPDATE;
        IF monto > v_saldo THEN
            SET resultado = 'Error" el monto excede el saldo de la cuenta';
            ROLLBACK;
        ELSE
            UPDATE Caja_Ahorro ca SET ca.saldo = ca.saldo - monto
            WHERE ca.nro_ca = v_nro_ca;

            INSERT INTO Transaccion (fecha, hora, monto) VALUES (CURDATE(), CURTIME(), monto);
            SET v_nro_trans = LAST_INSERT_ID();
            INSERT INTO Transaccion_por_caja (nro_trans, cod_caja) VALUES (v_nro_trans, nro_atm);
            
            INSERT INTO Extraccion (nro_trans, nro_cliente, nro_ca) VALUES (v_nro_trans, v_nro_cliente, v_nro_ca);

            COMMIT;
            SET resultado = 'Extraccion exitosa';
        END IF;
    END IF;
END //
DELIMITER ;

--Ejercicio 1-a)

DROP PROCEDURE IF EXISTS transferir;

DELIMITER //
CREATE PROCEDURE transferir(IN nro_atm INT, IN tarjeta_origen BIGINT, IN destino INT, IN monto DECIMAL(16,2), OUT resultado VARCHAR(100))
BEGIN
    DECLARE v_nro_cliente INT;
    DECLARE v_nro_ca INT;
    DECLARE v_saldo DECIMAL(16,2);
    DECLARE v_saldo_destino DECIMAL (16, 2);
    DECLARE v_nro_trans BIGINT UNSIGNED;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET resultado = 'La transaccion fue cancelada';
    END;

    START TRANSACTION;

    SELECT t.nro_ca, t.nro_cliente INTO v_nro_ca, v_nro_cliente FROM Tarjeta t WHERE tarjeta_origen = t.nro_tarjeta;
    
    IF NOT EXISTS (SELECT * FROM ATM a WHERE a.cod_caja = nro_atm) THEN
        SET resultado = 'Error: codigo de ATM invalido';
        ROLLBACK;
    ELSEIF v_nro_ca IS NULL THEN
        SET resultado = 'Error: la tarjeta no existe';
        ROLLBACK;
    ELSEIF monto <= 0 THEN
        SET resultado = 'Error: el monto debe ser positivo';
        ROLLBACK;
    ELSEIF NOT EXISTS (SELECT * FROM Caja_Ahorro ca WHERE ca.nro_ca = destino) THEN
        SET resultado = 'Error: la cuenta destino no existe';
        ROLLBACK;
    ELSEIF (v_nro_ca = destino) THEN
        SET resultado  = 'Error: la cuenta destino y la origen son la misma cuenta';
        ROLLBACK;
    ELSE
        SELECT ca.saldo INTO v_saldo FROM Caja_Ahorro ca WHERE v_nro_ca = ca.nro_ca
    FOR UPDATE;
        IF monto > v_saldo THEN
            SET resultado = 'Error: el monto excede el saldo de la cuenta';
            ROLLBACK;
        ELSE
            UPDATE Caja_Ahorro ca SET ca.saldo = ca.saldo - monto WHERE ca.nro_ca = v_nro_ca;
            UPDATE Caja_Ahorro ca SET ca.saldo = ca.saldo + monto WHERE ca.nro_ca = destino;
            
            INSERT INTO Transaccion (fecha, hora, monto) VALUES (CURDATE(), CURTIME(), monto);
            SET v_nro_trans = LAST_INSERT_ID();
            INSERT INTO Transaccion_por_caja (nro_trans, cod_caja) VALUES (v_nro_trans, nro_atm);
            INSERT INTO Transferencia (nro_trans, nro_cliente, origen, destino) VALUE (v_nro_trans, v_nro_cliente, v_nro_ca, destino);
            
            INSERT INTO Transaccion (fecha, hora, monto) VALUES (CURDATE(), CURTIME(), monto);
            SET v_nro_trans = LAST_INSERT_ID();
            INSERT INTO Transaccion_por_caja (nro_trans, cod_caja) VALUES (v_nro_trans, nro_atm);
            INSERT INTO Deposito (nro_trans, nro_ca) VALUES (v_nro_trans, destino);
            
            COMMIT;
            SET resultado = 'Transaccion exitosa';
        END IF;
    END IF;
END //
DELIMITER ;
    
-- Ejercicio 2
DELIMITER //
CREATE TRIGGER inserta_nuevo_prestamo
AFTER INSERT ON Prestamo
FOR EACH ROW
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= NEW.cant_meses DO
        INSERT INTO Pago (nro_prestamo, nro_pago, fecha_venc, fecha_pago)
        VALUES (NEW.nro_prestamo, i, DATE_ADD(NEW.fecha, INTERVAL i MONTH), NULL);
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- Ejercicio 3a
DELIMITER //
CREATE PROCEDURE ultimos_movimientos(IN tarjeta BIGINT)
BEGIN
    SELECT
        v.fecha,
        v.hora,
        v.tipo,
        IF(UPPER(v.tipo) = 'DEPOSITO', v.monto, (-1) * v.monto) AS monto,
        v.cod_caja,
        v.destino
    FROM trans_cajas_ahorro v
    JOIN Tarjeta t ON v.nro_ca = t.nro_ca
    WHERE t.nro_tarjeta = tarjeta
    ORDER BY v.fecha DESC, v.hora DESC
    LIMIT 15;
END //
DELIMITER ;

-- Ejercicio 3b
DELIMITER //
CREATE PROCEDURE movimientos_por_periodo(IN tarjeta BIGINT, IN desde DATE, IN hasta DATE)
BEGIN
    SELECT
        v.fecha,
        v.hora,
        v.tipo,
        IF(UPPER(v.tipo) = 'DEPOSITO', v.monto, (-1) * v.monto) AS monto,
        v.cod_caja,
        v.destino
    FROM trans_caja_ahorro v
    JOIN Tarjeta t ON v.nro_ca = t.nro_ca
    WHERE t.nro_tarjeta = tarjeta AND v.fecha >= desde AND v.fecha <= hasta
    ORDER BY v.fecha DESC, v.hora DESC
END //
DELIMITER ;

-- Ejercicio 3c
DELIMITER //
CREATE PROCEDURE crear_prestamo(IN nro_cliente INT, IN legajo INT, IN monto DECIMAL(10,2), IN cant_meses INT, OUT resultado VARCHAR(100))
BEGIN
    DECLARE v_tasa DECIMAL(4,2);
    DECLARE v_interes_total DECIMAL(9,2);
    DECLARE v_valor_cuota DECIMAL(9,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET resultado = 'El prestamo fue cancelado';
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE nro_cliente = nro_cliente) THEN
        SET resultado = 'El cliente no existe';
        ROLLBACK;
    ELSEIF EXISTS (SELECT 1 FROM Prestamo pr JOIN Pago pa ON pa.nro_prestamo = pr.nro_prestamo WHERE pr.nro_cliente = nro_cliente AND pa.fecha_pago IS NULL) THEN
        SET resultado = 'El cliente tiene prestamos sin pagar';
        ROLLBACK;
    ELSEIF NOT EXISTS (SELECT 1 FROM Tasa_Prestamo tp WHERE tp.periodo = cant_meses AND monto >= tp.monto_inf AND monto <= tp.monto_sup) THEN
        SET resultado = 'El monto o cantidad de meses no corresponden a una tasa valida';
        ROLLBACK;
    ELSE
    
        SELECT tp.tasa INTO v_tasa FROM Tasa_Prestamo tp WHERE tp.periodo = cant_meses AND monto >= tp.monto_inf AND monto <= tp.monto_sup;
        IF v_tasa IS NULL
            SET resultado = 'El monto tasa es nulo';
            ROLLBACK;
        END IF;
        
        SET v_interes_total = (monto * v_tasa * cant_meses) / 1200;
        SET v_valor_cuota = (monto + v_interes_total) / cant_meses;
        
        INSERT INTO Prestamo (fecha, cant_meses, monto, tasa_interes, interes, valor_cuota, legajo, nro_cliente)
        VALUES (CURDATE(), cant_meses, monto, v_tasa, v_interes, v_valor_cuota, legajo, nro_cliente);
        
        COMMIT;
        SET resultado='Se creo el prestamo exitosamente';
        
    END IF;
END //
DELIMITER ;

-- Ejercicio 3d
DELIMITER //
CREATE PROCEDURE pagar_cuota(IN nro_prestamo INT, IN nro_pago INT, OUT resultado VARCHAR(100))
BEGIN
    DECLARE v_fecha_pago DATE;
    DECLARE v_fecha_vencimiento DATE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN     
        ROLLBACK;
        SET resultado = 'El prestamo fue cancelado';
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT * FROM Prestamo p WHERE nro_prestamo = p.nro_prestamo) THEN
        SET resultado = 'Error: el prestamo no existe';
        ROLLBACK;
    ELSEIF NOT EXISTS (SELECT * FROM Pago p WHERE nro_prestamo = p.nro_prestamo AND nro_pago = p.nro_pago) THEN
        SET resultado = 'Error: el pago no corresponde a nignun prestamo';
        ROLLBACK;
    ELSE
        SELECT p.fecha_pago, p.fecha_vencimiento INTO v_fecha_pago, v_fecha_vencimiento FROM Pago p WHERE nro_prestamo = p.nro_prestamo AND nro_pago = p.nro_pago;
        IF (v_fecha_pago IS NOT NULL) THEN
            SET resultado = 'Error: el pago ya fue hecho';
            ROLLBACK;
        ELSE
            FOR UPDATE;
            UPDATE Pago p SET p.fecha_pago = CURDATE() WHERE p.nro_pago = nro_pago AND p.nro_prestamo = nro_prestamo;
            COMMIT;
            SET resultado = 'El pago se realizo con exito';
        END IF;
    END IF;
END //
DELIMITER ;

-- Ejercicio 3e
DELIMITER //
CREATE PROCEDURE listado_morosos (INT cant_cuotas)
BEGIN
    SELECT
        c.nro_cliente,
        c.tipo_doc,
        c.nro_doc,
        c.nombre,
        c.apellido,
        pr.nro_prestamo,
        pr.monto,
        pr.cant_meses,
        pr.valor_cuota,
        COUNT(*) AS cant_cuotas_atrasadas
    FROM Cliente c
    JOIN Prestamo pr ON c.nro_cliente = pr.nro_cliente
    JOIN Pago pa ON pr.nro_prestamo = pa.nro_prestamo
    WHERE pa.fecha_pago IS NULL AND pa.fecha_venc < CURDATE()
    GROUP BY
        c.nro_cliente,
        c.tipo_doc,
        c.nro_doc,
        c.nombre,
        c.apellido,
        pr.nro_prestamo,
        pr.monto,
        pr.cant_meses,
        pr.valor_cuota
    HAVING COUNT(*) >= cant_cuotas;
END //
DELIMITER ;