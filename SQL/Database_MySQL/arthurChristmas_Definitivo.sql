Create database if not exists ArthurChristmas;

use ArthurChristmas;

###########################################################################################################
#####################################     COMENTARIOS EJECUCIÓN      ######################################
###########################################################################################################

/*
	1º: Ejecutar "todo" sin seleccionar nada 
    (se crea la base de datos arthurchristmas y las tablas y se definen los disparadores y la función calcular_Edad)
    2º: Definir claves ajenas
    3º: Ejecutar la parte de inserción de datos completa
    4º: Ya es posible ejecutar las consultas
*/

###########################################################################################################
#####################################        CREACIÓN TABLAS         ######################################
###########################################################################################################


Create table if not exists Departamentos(
  Codigo INT not null PRIMARY KEY,
  Nombre varchar(40) NOT NULL,
  NSS_director varchar(11) NOT NULL
);

Create table if not exists Elfos(
 NSS varchar(11) not null PRIMARY KEY,
 Nombre varchar(20) not null,
 Apellido varchar(30) not null,
 contrato_completo bool not null,
 codigo_departamento int not null
);
# Si contrato_completo es True el elfo estará contratado a tiempo completo, 
# si es False será a tiempo parcial

Create table if not exists Elfos_TiempoCompleto(
 NSS varchar(11) not null PRIMARY KEY
);

Create table if not exists Elfos_TiempoParcial(
 NSS varchar(11) not null PRIMARY KEY
);

Create table if not exists Tareas(
  Codigo INT PRIMARY KEY,
  Descripcion VARCHAR(90) not null
);

Create table if not exists Asignacion_tareas(
  NSS_elfo varchar(11) not null,
  Codigo_tarea INT not null,
  PRIMARY KEY(NSS_elfo,Codigo_tarea)
);

CREATE TABLE IF NOT EXISTS Niños(
	Nombre           VARCHAR(30) NOT NULL,
  Apellido         VARCHAR(30) NOT NULL,
  Coordenadas      VARCHAR(50) NOT NULL,
  Fecha_nacimiento DATE  NOT NULL,
  NSS_elfo         VARCHAR(11) NOT NULL,
  PRIMARY KEY(Nombre,Apellido,Coordenadas),
  UNIQUE(NSS_elfo)
);


CREATE TABLE Juguetes(
  Nombre      VARCHAR(40) NOT NULL PRIMARY KEY,
  Descripcion VARCHAR(40) NOT NULL,
  Duracion    INTEGER  NOT NULL,
  Edad_min    INTEGER  NOT NULL,
  Edad_max    INTEGER  NOT NULL
);

Create table if not exists Peticiones(
  Nombre_niño varchar(20) not null,
  Apellido_niño varchar(20) not null,
  Coordenadas_niño VARCHAR(24) NOT NULL,
  Nombre_juguete varchar(40) not null,
  PRIMARY KEY(Nombre_niño,Apellido_niño,Coordenadas_niño,Nombre_juguete)
);

Create table if not exists Entregas(
  Nombre_niño varchar(20) not null,
  Apellido_niño varchar(20) not null,
  Coordenadas_niño VARCHAR(24) NOT NULL,
  Nombre_juguete varchar(40) not null,
  PRIMARY KEY(Nombre_niño,Apellido_niño,Coordenadas_niño,Nombre_juguete)
);


CREATE TABLE IF NOT EXISTS Mascotas(
  Nombre_niño      VARCHAR(20) NOT NULL,
  Apellido_niño    VARCHAR(20) NOT NULL,
  Coordenadas_niño VARCHAR(24) NOT NULL,
  Especie          VARCHAR(40) NOT NULL,
  Edad             INTEGER  NOT NULL,
  Nombre_mascota   VARCHAR(20) NOT NULL,
  PRIMARY KEY(Nombre_niño,Apellido_niño,Coordenadas_niño,Nombre_mascota)
);

create table if not exists Familiares(
  Nombre_niño1 varchar(30) not null,
  Apellido_niño1 varchar(30) not null, 
  Coordenadas_niño1 VARCHAR(50) not null,
  Nombre_niño2 varchar(30) not null,
  Apellido_niño2 varchar(30) not null,
  Coordenadas_niño2 VARCHAR(50) not null,
  Parentesco varchar(3) not null,
  PRIMARY KEY (Nombre_niño1,Apellido_niño1,Coordenadas_niño1,Nombre_niño2,Apellido_niño2,Coordenadas_niño2)
);

############################################################################################################
#####################################          DISPARADORES           ######################################
############################################################################################################


-- Disparador para clasificar a los elfos según su contrato

DELIMITER $$
CREATE TRIGGER clasificarElfos_afterInsert AFTER INSERT ON elfos FOR EACH ROW
BEGIN
    IF (NEW.contrato_completo=TRUE) 
		THEN INSERT INTO elfos_tiempocompleto(NSS) 
		VALUE (NEW.NSS);
        ELSE 
            BEGIN 
            INSERT INTO elfos_tiempoparcial(NSS) 
			VALUE (NEW.NSS);
		END;      
    END IF;
END $$

-- Comprobamos los tipos de contrato para que a cada elfo le corresponda su respectiva función (Dirigir un departamento o realizar tareas)

DELIMITER $$
 create trigger comprobar_contrato_tareas before insert on Asignacion_tareas for each row
  begin
	declare booleano bool;
    select contrato_completo into booleano from elfos where nss=new.nss_elfo;
    if (booleano) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Tiene contrato a tiempo completo, estos no realizan tareas';
	end if;
 end; $$

# Además, comprobaremos que pertenece al departamento que dirigiría

DELIMITER $$
 create trigger comprobar_dirigir before update on Departamentos for each row
   BEGIN
	DECLARE elfo INT;
    declare booleano bool;
    select contrato_completo into booleano from elfos where nss=new.nss_director;
    if (not booleano) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Tiene contrato a tiempo parcial, no puede dirigir un departamento';
	end if;
	select elfos.codigo_departamento INTO elfo
    from elfos INNER JOIN departamentos ON new.NSS_director = Elfos.NSS AND departamentos.codigo = elfos.codigo_departamento;
	if (elfo != new.codigo)
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Este elfo no puede dirigir un departamento al que no pertenece';
	end if;
 END; $$
 
 
-- Crear disparador para comparar la edad del niño con las edades recomendadas del juguete que pide

DROP TRIGGER filtrarPeticion_beforeInsert


DELIMITER $$
CREATE TRIGGER filtrarPeticion_beforeInsert BEFORE INSERT ON peticiones FOR EACH ROW
BEGIN
	DECLARE age INT;
    DECLARE age_max INT; 
    DECLARE age_min INT;
	SELECT calcular_Edad(Fecha_nacimiento) INTO age
	FROM niños
	WHERE Nombre = NEW.Nombre_niño AND Apellido = NEW.Apellido_niño AND Coordenadas = NEW.Coordenadas_niño;
    SELECT Edad_max INTO age_max FROM 
    juguetes where nombre = NEW.Nombre_juguete;
    SELECT Edad_min INTO age_min FROM 
    juguetes where nombre = NEW.Nombre_juguete;
    IF age>age_max OR age<age_min
        THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Edad no apta';
    END IF;
END; 
$$

-- Un juguete no puede ser entregado sin haber sido pedido. Restricción de inclusividad.

DELIMITER $$
 CREATE TRIGGER comprobar_entrega BEFORE INSERT ON Entregas FOR EACH ROW
  BEGIN
  DECLARE aux INT;
	SELECT COUNT(*) INTO aux
    FROM Peticiones
    WHERE NEW.Nombre_niño = Peticiones.Nombre_niño AND NEW.Apellido_niño = Peticiones.Apellido_niño AND NEW.Coordenadas_niño = Peticiones.Coordenadas_niño AND NEW.Nombre_juguete = Peticiones.Nombre_juguete;
    IF (aux<1)
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Este juguete no ha sido pedido, es imposible que haya sido entregado';
	END IF;
 END; $$

-- Disparadores que compruebe que dos familiares viven en la misma localización y que no son la misma persona

DELIMITER $$
CREATE TRIGGER filtrarFamiliar_beforeInsert BEFORE INSERT ON familiares FOR EACH ROW
BEGIN
	IF NEW.Coordenadas_niño1 != NEW.Coordenadas_niño2
     then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No viven juntos';
    end if;
    IF NEW.Nombre_niño1 = NEW.Nombre_niño2 AND  NEW.Apellido_niño1 = NEW.Apellido_niño2 
		then 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Son la misma persona';
    end if;
END; 
$$

DROP TRIGGER filtrarFamiliar_afterInsert;

DELIMITER $$
CREATE TRIGGER filtrarFamiliar_afterInsert AFTER INSERT ON familiares FOR EACH ROW
BEGIN
	DECLARE reps INT;
	SELECT COUNT(*) INTO reps
    FROM Familiares WHERE Nombre_niño1=NEW.Nombre_niño2 AND Apellido_niño1=NEW.Apellido_niño2 AND Coordenadas_niño1=NEW.Coordenadas_niño2 AND 
    Nombre_niño2=NEW.Nombre_niño1 AND Apellido_niño2=NEW.Apellido_niño1 AND Coordenadas_niño2=NEW.Coordenadas_niño1;
    IF reps=1
		then 
		SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT='Su simétrico ya ha sido insertado';
        else
        INSERT IGNORE INTO FamiliaresPendientes(Nombre_niño1,Apellido_niño1,Coordenadas_niño1,Nombre_niño2,Apellido_niño2,Coordenadas_niño2,Parentesco) 
		VALUES (NEW.Nombre_niño2,NEW.Apellido_niño2,NEW.Coordenadas_niño2,NEW.Nombre_niño1,NEW.Apellido_niño1,NEW.Coordenadas_niño1,NEW.Parentesco);
    end if;
	END; 
$$

###########################################################################################################
#####################################         CLAVES AJENAS          ######################################
###########################################################################################################


alter table Elfos
   add constraint ElfosFK1 foreign key (Codigo_departamento)
   references Departamentos(Codigo)
   on delete restrict on update cascade;

alter table Elfos_tiempocompleto
   add constraint Elfos_tc_FK1 foreign key (NSS)
   references Elfos(NSS)
   on delete restrict on update cascade;
   
alter table Elfos_tiempoparcial
   add constraint Elfos_tp_FK1 foreign key (NSS)
   references Elfos(NSS)
   on delete restrict on update cascade;

alter table Asignacion_tareas
   add constraint AsignacionTareasFK1 foreign key (Codigo_tarea)
   references Tareas(Codigo)
   on delete cascade on update cascade;
   
alter table Asignacion_tareas
   add constraint AsignacionTareasFK2 foreign key (NSS_elfo)
   references Elfos_tiempoparcial(NSS)
   on delete cascade on update cascade;

alter table Peticiones
   add constraint PeticionesFK1 foreign key (Nombre_niño,Apellido_niño,Coordenadas_niño)
   references Niños(Nombre,Apellido,Coordenadas)
   on delete cascade on update cascade;
alter table Peticiones
   add constraint PeticionesFK2 foreign key (Nombre_juguete)
   references Juguetes(Nombre)
   on delete cascade on update cascade;

alter table Entregas
   add constraint EntregasFK1 foreign key (Nombre_niño,Apellido_niño,Coordenadas_niño)
   references Niños(Nombre,Apellido,Coordenadas)
   on delete cascade on update cascade;
   
alter table Entregas
   add constraint EntregasFK2 foreign key (Nombre_juguete)
   references Juguetes(Nombre)
   on delete restrict on update cascade;
   
alter table Mascotas
   add constraint MascotasFK foreign key (Nombre_niño,Apellido_niño,Coordenadas_niño)
   references Niños(Nombre,Apellido,Coordenadas)
   on delete cascade on update cascade;
   
alter table Niños
   add constraint NiñosFK1 foreign key (NSS_elfo)
   references Elfos(NSS)
   on delete restrict on update cascade;
   
alter table Familiares
   add constraint FamiliaresFK1 foreign key (Nombre_niño1,Apellido_niño1,Coordenadas_niño1)
   references Niños(Nombre,Apellido,Coordenadas)
   on delete cascade on update cascade;
   
alter table Familiares
   add constraint FamiliaresFK2 foreign key (Nombre_niño2,Apellido_niño2,Coordenadas_niño2)
   references Niños(Nombre,Apellido,Coordenadas)
   on delete cascade on update cascade;

# Todavía no añadimos esta clave ajena
/*
alter table Departamentos
   add constraint DepartamentosFK1 foreign key (NSS_director)
   references Elfos_tiempocompleto(NSS)
   on delete restrict on update cascade;
   */



###########################################################################################################
#####################################        INSERCIÓN DATOS         ######################################
###########################################################################################################

-- Departamentos

ALTER TABLE Departamentos MODIFY COLUMN NSS_director char(20) NULL;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Departamentos sin director.csv'
INTO TABLE Departamentos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(codigo,nombre,@nss_director) 
SET NSS_director = IF(@nss_director="",NULL,@nss_director);

-- Elfos

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Elfos.csv'
INTO TABLE Elfos
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

CREATE TEMPORARY TABLE Directores (
   NSS_director varchar(20) NOT NULL,
   codigo     INT NOT NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Directores.csv'
INTO TABLE Directores
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n';


Update Departamentos
   INNER JOIN Directores ON Departamentos.Codigo = Directores.codigo
   SET Departamentos.NSS_director = Directores.NSS_director;
Drop table directores;
ALTER TABLE Departamentos MODIFY COLUMN NSS_director CHAR(20) NOT NULL;

-- Añadimos la clave ajena que no incluimos previamente
alter table Departamentos
   add constraint DepartamentosFK1 foreign key (NSS_director)
   references Elfos_tiempocompleto(NSS)
   on delete restrict on update cascade;

   
-- Tareas

INSERT INTO Tareas(codigo,descripcion) VALUES (1,'basura');
INSERT INTO Tareas(codigo,descripcion) VALUES (2,'programacion');
INSERT INTO Tareas(codigo,descripcion) VALUES (3,'limpieza');
INSERT INTO Tareas(codigo,descripcion) VALUES (4,'estudio');
INSERT INTO Tareas(codigo,descripcion) VALUES (5,'recogida_regalos');
INSERT INTO Tareas(codigo,descripcion) VALUES (6,'ayuda_Santa');
INSERT INTO Tareas(codigo,descripcion) VALUES (7,'Comida_renos');

-- Asignacion tareas

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Asignacion_Tareas.csv'
IGNORE INTO TABLE asignacion_tareas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

# Las entradas duplicadas que no se insertan en este caso no generarán problemas, pues no se referencian posteriormente

# INSERT INTO Asignacion_tareas(NSS_elfo,Codigo_tarea) VALUES ('107-01-5204',3) # Comprobación de que no permite la asignacion de tareas a elfos con contrato a tiempo completo

-- Niños

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/NinosNeto.csv'
IGNORE INTO TABLE Niños
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- Juguetes

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Juguetes.csv'
INTO TABLE Juguetes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- Peticiones

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PeticionesNeto.csv'
IGNORE INTO TABLE Peticiones
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

# Notemos que las peticiones han de ser todas correctas, para poder crear los datos de entregas correctamente sin tener errores 
# en las claves ajenas y demás

-- Entregas 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Entregas.csv'
IGNORE INTO TABLE Entregas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
# Con las entregas duplicadas ocurre igual que con las asignaciones de tareas duplicadas

-- Familiares

CREATE TABLE FamiliaresPendientes (
  Nombre_niño1 varchar(20) not null,
  Apellido_niño1 varchar(20) not null, 
  Coordenadas_niño1 VARCHAR(30) not null,
  Nombre_niño2 varchar(20) not null,
  Apellido_niño2 varchar(20) not null,
  Coordenadas_niño2 VARCHAR(24) not null,
  Parentesco varchar(3) not null,
  PRIMARY KEY (Nombre_niño1,Apellido_niño1,Coordenadas_niño1,Nombre_niño2,Apellido_niño2,Coordenadas_niño2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Familiares.csv'
IGNORE INTO TABLE Familiares
FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

INSERT IGNORE INTO Familiares
SELECT * FROM FamiliaresPendientes;
DROP TABLE FamiliaresPendientes;

# Para posteriormente insertar más parejas de familiares será necesario volcer a crear la tabla FamiliaresPendientes (línea 432)

-- Mascotas

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Mascotas.csv'
IGNORE INTO TABLE Mascotas
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


###########################################################################################################
#####################################           CONSULTAS            ######################################
###########################################################################################################




/*
	1. Mostrar todos los juguetes que han pedido los niños de una determinada edad junto con el nombre de todos los elfos que se encargan de ellos 
*/

-- Consulta 1
	# Suponemos que la edad que nos interesa es de 10 años
    
    CREATE TEMPORARY TABLE petis_entrs
	SELECT N.Nombre AS Nombre_niño,N.Apellido AS Apellido_niño,N.Coordenadas AS Coordenadas_niño, (SELECT COUNT(*) FROM Peticiones P WHERE P.Nombre_niño = N.Nombre AND P.Apellido_niño = N.Apellido AND
P.Coordenadas_niño = N.Coordenadas) AS Numero_peticiones, (SELECT COUNT(*) FROM Entregas En WHERE En.Nombre_niño = N.Nombre AND En.Apellido_niño = N.Apellido AND
En.Coordenadas_niño = N.Coordenadas) AS Juguetes_recibidos
FROM Niños N;

    SELECT P.Nombre_juguete, E.NSS AS NNS_elfo, E.Nombre, E.Apellido
FROM niños N 
INNER JOIN  Elfos E ON N.NSS_elfo = E.NSS 
INNER JOIN Peticiones P ON 
P.Nombre_niño = N.Nombre AND P.Apellido_niño = N.Apellido AND P.Coordenadas_niño = N.Coordenadas
INNER JOIN petis_entrs PE ON PE.Nombre_niño = N.Nombre AND PE.Apellido_niño = N.Apellido AND
PE.Coordenadas_niño = N.Coordenadas
WHERE PE.Numero_peticiones > 0 AND calcular_Edad(N.Fecha_nacimiento) = 10;

DROP TABLE petis_entrs;

    
/*
	2. Mostrar a los elfos con contrato a tiempo parcial y cuyos niños asociados tienen menos de 16 años, es decir, los que al año próximo seguirán recibiendo regalos; junto con el número de tareas que realizan,
    para decicir si son despedidos y hay que reemplazarlos (ordenamos según el número de tareas que realizan de menos a más). 
    Mostrar, además, el NSS del director del departamento al que pertenece para poder pedirle su opinión.
*/
-- Consulta 2

	SELECT E.*,D.NSS_director, (SELECT COUNT(*) FROM Asignacion_tareas WHERE Asignacion_tareas.NSS_elfo = E.NSS GROUP BY NSS_elfo) AS Numero_tareas
	FROM niños N INNER JOIN  Elfos E ON N.NSS_elfo = E.NSS INNER JOIN Departamentos D ON E.codigo_departamento = D.codigo INNER JOIN Asignacion_tareas ON Asignacion_tareas.NSS_elfo = E.NSS
    WHERE calcular_Edad(N.Fecha_nacimiento) < 16 AND E.contrato_completo=0 ORDER BY Numero_tareas ASC;
    
/*
	3. Mostrar a los elfos a tiempo parcial y a tiempo completo que no realizan ninguna tarea, respectivamente no dirigen ningún departamento
    y además no observan a ningún niño.
*/

-- Consulta 3
  
SELECT Etc.NSS AS NNS_elfo
FROM Elfos_tiempocompleto Etc
WHERE (SELECT COUNT(*) FROM Departamentos D WHERE D.NSS_director = Etc.NSS) = 0
AND (SELECT COUNT(*) FROM Niños N WHERE N.NSS_elfo = Etc.NSS) = 0
UNION
SELECT EtP.NSS AS NNS_elfo
FROM Elfos_tiempoPARCIAL EtP
WHERE (SELECT COUNT(*) FROM Asignacion_tareas A WHERE A.NSS_elfo = Etp.NSS) = 0
AND (SELECT COUNT(*) FROM Niños N WHERE N.NSS_elfo = Etp.NSS) = 0;

###########################################################################################################
#####################################           FUNCIONES            ######################################
###########################################################################################################

-- Función que calcula la edad (redondeando) dada una fecha de nacimiento
# Suponiendo que la entrega se realizará el 25-12-2022
DELIMITER $$ 
CREATE FUNCTION calcular_Edad (fecha_nac DATE) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE edad INT;
	SET edad = round(DATEDIFF('2022-12-25', fecha_nac)/365,0);
	RETURN edad;
END $$

