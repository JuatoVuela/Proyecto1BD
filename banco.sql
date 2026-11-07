DROP DATABASE IF EXISTS banco;
CREATE DATABASE banco;
USE banco;

CREATE TABLE Ciudad (
    cod_postal SMALLINT UNSIGNED NOT NULL;
    nombre VARCHAR(45) NOT NULL;
    PRIMARY KEY (cod_postal)
) ENGINE = InnoDB;

CREATE TABLE Sucursal (
    nro_suc SMALLINT UNSIGNED NOT NULL;
    nombre VARCHAR(45) NOT NULL;
    direccion VARCHAR(45) NOT NULL;
    telefono VARCHAR(45) NOT NULL;
    horario VARCHAR(45) NOT NULL;   
    ciod_postal SMALLINT UNSIGNED NOT NULL;
    PRIMARY KEY (nro_suc),
    FOREIGN KEY (cod_postal) REFERENCES Ciudad (cod_postal)
) ENGINE=InnoDB;

