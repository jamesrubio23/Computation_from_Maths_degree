CREATE DATABASE IF NOT EXISTS Bruto;

USE Bruto;
CREATE TABLE IF NOT EXISTS Elfos(
 NSS VARCHAR(11) NOT NULL PRIMARY KEY,
 Nombre varchar(20) NOT NULL,
 Apellido varchar(30) NOT NULL,
 contrato_completo BOOL NOT NULL,
 codigo_departamento INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Niños(
	Nombre           VARCHAR(30) NOT NULL,
  Apellido         VARCHAR(30) NOT NULL,
  Coordenadas      VARCHAR(50) NOT NULL,
  Fecha_nacimiento DATE  NOT NULL,
  NSS_elfo         VARCHAR(11) NOT NULL,
  PRIMARY KEY(Nombre,Apellido,Coordenadas)
);


CREATE TABLE Juguetes(
  Nombre      VARCHAR(40) NOT NULL PRIMARY KEY,
  Descripcion VARCHAR(40) NOT NULL,
  Duracion    INTEGER  NOT NULL,
  Edad_min    INTEGER  NOT NULL,
  Edad_max    INTEGER  NOT NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Elfos.csv'
INTO TABLE Elfos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Juguetes.csv'
INTO TABLE Juguetes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/NinosBruto.csv'
IGNORE INTO TABLE Niños
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;