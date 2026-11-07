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

DROP USER IF EXISTS 'atm'@'%';
CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';
GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';
GRANT SELECT, UPDATE ON banco.Tarjeta TO 'atm'@'%';

FLUSH PRIVILEGES;