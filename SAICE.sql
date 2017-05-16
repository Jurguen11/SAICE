﻿--drop table Eventos,Personas,Funcionarios,EF,Correos_p;
--drop table Telefonos_p;
CREATE DOMAIN a_telefono CHAR(9) NOT NULL CONSTRAINT CHK_telefono
CHECK (VALUE SIMILAR TO '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');

CREATE DOMAIN a_correos CHAR(30) NOT NULL CONSTRAINT CHK_correo
CHECK(VALUE SIMILAR TO '[A-z]%@[A-z]%.[A-z]%');

CREATE DOMAIN a_cedula CHAR(9)NOT NULL CONSTRAINT CHK_cedula 
CHECK(VALUE SIMILAR TO '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]');

CREATE DOMAIN a_carnet CHAR(11) NOT NULL CONSTRAINT CHK_carnet 
CHECK (VALUE SIMILAR TO '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]');

--Tabla eventos
 CREATE TABLE Eventos(
	ID_Evento CHAR(7) primary key NOT NULL,
	Nombre VARCHAR(30) NOT NULL,
	Descripcion VARCHAR(100) NULL,
	FechaInicio DATE NOT NULL,
	FechaFinal DATE NOT NULL
                    );

--Tabla personas
 CREATE TABLE Personas(
		cedula a_cedula primary key ,
		Nombre CHAR(30) NOT NULL,
		Apellido1 CHAR(30) NOT NULL,
		Apellido2 CHAR(30) NULL,
		provincia VARCHAR(30) NOT NULL,
		canton VARCHAR(30) NOT NULL,
		distrito VARCHAR(30) NOT NULL,
		detalle VARCHAR(100) NULL
                      );
--Tabla eventos funcionarios
CREATE TABLE Funcionarios(
		cedula a_cedula primary key ,
		carnet char(10) NOT NULL,
		CONSTRAINT FK_cedula_personas_funcionarios FOREIGN KEY (cedula) REFERENCES Personas
                         );
--Tabla eventos funcionarios
CREATE TABLE EF(
	cedula a_cedula ,
	ID_Evento CHAR(7) NOT NULL,
	ROL VARCHAR(30) NOT NULL,
        CONSTRAINT PK_funcionarios_eventos PRIMARY KEY(cedula,ID_evento), 
	CONSTRAINT FK_cedula_Funcionarios_eventos FOREIGN KEY(cedula) REFERENCES Funcionarios,
	CONSTRAINT FK_idEvento_Funcionarios FOREIGN KEY (ID_Evento) REFERENCES Eventos
               );
--Tabla correos personas               
CREATE TABLE Correos_p(
	cedula a_cedula PRIMARY KEY,
	correo a_correos ,
	CONSTRAINT FK_cedula_personas_correos FOREIGN KEY(cedula) REFERENCES Personas
                      );
--Tabla telefonos personas 
CREATE TABLE Telefonos_p(
	cedula a_cedula primary key,
	telefono a_telefono,
	CONSTRAINT FK_cedula_persona_telefonos FOREIGN KEY(cedula) REFERENCES Personas
                        );
--Tabla secciones
CREATE TABLE Secciones(
	Id_secciones char(7) NOT NULL PRIMARY KEY
		      );
--Tabla secciones funcionarios
CREATE TABLE SF(
	Id_secciones char(7) NOT NULL ,
	cedula a_cedula,
	CONSTRAINT PK_funcionario_secciones PRIMARY KEY (Id_secciones,cedula),
	CONSTRAINT FK_id_secciones_funcionarios_secciones FOREIGN KEY(Id_secciones)REFERENCES Secciones,
	CONSTRAINT FK_cedula_funcionarios_secciones FOREIGN KEY(cedula) REFERENCES Funcionarios 
               ); 
--Tabla polizas
CREATE TABLE Polizas(
	ID_Poliza CHAR(7) NOT NULL PRIMARY KEY,
	Descripcion VARCHAR(100) NULL,
	Monto INT NOT NULL,
	Fecha_vencimiento DATE NOT NULL,
	Aseguradora VARCHAR(30) NOT NULL
                    );
--Tabla estudiantes
CREATE TABLE  Estudiantes(
	cedula a_cedula PRIMARY KEY,
	carnet a_carnet,
	ID_Poliza CHAR(7) NOT NULL,
	CONSTRAINT FK_polizas_estudiantes FOREIGN KEY(ID_Poliza) REFERENCES Polizas	
                        );       
--Tabla contactos
CREATE TABLE Contactos(
	cedula a_cedula PRIMARY KEY ,
	Puesto VARCHAR(30) NOT NULL,
	CONSTRAINT FK_cedula_estudiantes_contactos FOREIGN KEY(cedula)REFERENCES Estudiantes
                      );
--Tabla empresas
CREATE TABLE Empresas(
	ID_Empresa CHAR(7) NOT NULL PRIMARY KEY,
	Nombre CHAR(30) NOT NULL,
	provincia VARCHAR(30) NOT NULL,
	canton VARCHAR(30) NOT NULL,
	distrito VARCHAR(30) NOT NULL,
	detalle VARCHAR(100) NULL
                    );
--Tabla contactos empresas
CREATE TABLE CE(
	cedula a_cedula,
	ID_Empresa CHAR(7) NOT NULL,
	CONSTRAINT PK_Contactos_de_empresa PRIMARY KEY(cedula,ID_Empresa),
	CONSTRAINT FK_cedula_contacto_empresa FOREIGN KEY(cedula)REFERENCES Contactos,
	CONSTRAINT FK_id_empresa_de_contacto FOREIGN KEY(ID_Empresa)REFERENCES Empresas
               );         
--Tabla telefonos empresas           
CREATE TABLE Telefonos_E(
	ID_Empresa CHAR(7) NOT NULL PRIMARY KEY,
	telefono a_telefono,
	CONSTRAINT FK_id_empresa_telefonos FOREIGN KEY(ID_Empresa) REFERENCES Empresas
                        );
--Tabla correos empresas
CREATE TABLE Correos_E(
	ID_Empresa CHAR(7) NOT NULL PRIMARY KEY,
	correo a_correos ,
	CONSTRAINT FK_id_empresa_correos FOREIGN KEY(ID_Empresa) REFERENCES Empresas
                );
                
--Tabla practicas
CREATE TABLE PRACTICAS(
		ID_Practicas VARCHAR(7) NOT NULL PRIMARY KEY,
		Fecha_inicio DATE NOT NULL,
		Fecha_final DATE NOT NULL,
		nota int  NOT NULL,
		estado CHAR(1) NOT NULL,
		cedula a_cedula,
		ID_Empresa CHAR(7) NOT NULL,
		CONSTRAINT FK_id_empresa_practicas FOREIGN KEY(ID_Empresa) REFERENCES Empresas,
		CONSTRAINT FK_cedula_estudiante_Practicas FOREIGN KEY(cedula) REFERENCES Estudiantes
                      );
--Tabla giras
CREATE TABLE Giras(
	ID_Gira CHAR(7) NOT NULL PRIMARY KEY,
	Fecha_inicio DATE NOT NULL,
	Fecha_final DATE NOT NULL,
	costo INT NOT NULL,
	duracion TIME NOT NULL,
	provincia VARCHAR(30) NOT NULL,
	canton VARCHAR(30) NOT NULL,
	distrito VARCHAR(30) NOT NULL,
	detalle VARCHAR(100) NULL
                  );
--Tabla secciones grupos
CREATE TABLE SG(
	Id_secciones CHAR(7) NOT NULL,
	ID_Gira CHAR(7) NOT NULL,
	CONSTRAINT PK_Secciones_Giras PRIMARY KEY(Id_secciones,ID_Gira),
	CONSTRAINT FK_id_secciones_giras FOREIGN KEY(Id_secciones)REFERENCES Secciones,
	CONSTRAINT FK_id_giras_secciones FOREIGN KEY(ID_Gira)REFERENCES Giras
               );
--Tabla estudiantes secciones
CREATE TABLE ES(
	Id_secciones CHAR(7) NOT NULL,
	cedula a_cedula,
	CONSTRAINT PK_Estudiantes_secciones PRIMARY KEY(Id_secciones,cedula),
	CONSTRAINT FK_Id_secciones_Estudiantes FOREIGN KEY(Id_secciones) REFERENCES Secciones,
	CONSTRAINT FK_cedula_estudiantes_secciones FOREIGN KEY(cedula)REFERENCES Estudiantes
               );
--Tabla eventos giras funcionarios
CREATE TABLE  GE(
	ID_Giras CHAR(7) NOT NULL,
	ID_Empresa CHAR(7) NOT NULL,
	CONSTRAINT PK_Giras_empresas PRIMARY KEY(ID_Giras,ID_Empresa),
	CONSTRAINT FK_ID_empresa_Giras FOREIGN KEY(ID_Empresa)REFERENCES Empresas,
	CONSTRAINT FK_ID_giras_empresas FOREIGN KEY(ID_Giras)REFERENCES Giras
               ); 

------------------Funciones agregar-----------

--Agregar eventos
create or replace Function insertar_eventos(
	E_ID_Evento CHAR(7),
	E_Nombre VARCHAR(30),
	E_Descripcion VARCHAR(100),
	E_FechaInicio DATE,
	E_FechaFinal DATE
)returns void as
$BODY$
Begin
	raise notice 'Insertando Evento';
	insert into Eventos values (E_ID_Evento,E_Nombre,E_Descripcion,E_FechaInicio,E_FechaFinal);
	raise notice 'Se inserto evento';
end $BODY$
language plpgsql;

---Agregar personas
create or replace Function insertar_personas(
	p_cedula a_cedula,
	p_telefono a_telefono,
	p_correos a_correos,
	p_Nombre CHAR(30),
	p_Apellido1 CHAR(30),
	p_Apellido2 CHAR(30),
	p_provincia VARCHAR(30),
	p_canton VARCHAR(30),
	p_distrito VARCHAR(30),
	p_detalle VARCHAR(100)
)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	insert into telefonos_p values(p_cedula,p_telefono);
	insert into correos_p values(p_cedula,p_correos);
	insert into personas values (p_cedula,p_Nombre,p_Apellido1,p_Apellido2,p_provincia,p_canton,p_distrito,p_detalle);
	raise notice 'Se inserto persona';
end $BODY$
language plpgsql;


--Agregar funcionarios
create or replace function insertar_funcionario(
	p_carnet a_carnet,
	p_cedula a_cedula,
	p_telefono a_telefono,
	p_correos a_correos,
	p_Nombre CHAR(30),
	p_Apellido1 CHAR(30),
	p_Apellido2 CHAR(30),
	p_provincia VARCHAR(30),
	p_canton VARCHAR(30),
	p_distrito VARCHAR(30),
	p_detalle VARCHAR(100)
)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	insert into telefonos_p values(p_cedula,p_telefono);
	insert into correos_p values(p_cedula,p_correos);
	insert into personas values (p_cedula,p_Nombre,p_Apellido1,p_Apellido2,p_provincia,p_canton,p_distrito,p_detalle);
	insert into funcionarios values (p_cedula,p_carnet);
	raise notice 'Se inserto Funcionario';
end $BODY$
language plpgsql;


--Agregar Estudiantes falta al insertar que lleve conexion de polizas
create or replace function insertar_Estudiante(
	p_carnet a_carnet,
	p_cedula a_cedula,
	p_telefono a_telefono,
	p_correos a_correos,
	p_Nombre CHAR(30),
	p_Apellido1 CHAR(30),
	p_Apellido2 CHAR(30),
	p_provincia VARCHAR(30),
	p_canton VARCHAR(30),
	p_distrito VARCHAR(30),
	p_detalle VARCHAR(100)
)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	insert into telefonos_p values(p_cedula,p_telefono);
	insert into correos_p values(p_cedula,p_correos);
	insert into personas values (p_cedula,p_Nombre,p_Apellido1,p_Apellido2,p_provincia,p_canton,p_distrito,p_detalle);
	insert into Estudiantes values (p_cedula,p_carnet);
	
	raise notice 'Se inserto Estudiante';
end $BODY$
language plpgsql;


--Insertae Giras
create or replace function insertar_Giras(
	g_ID_Gira CHAR(7),
	g_Fecha_inicio varchar(50),
	g_Fecha_final varchar(50),
	g_costo INT,
	g_duracion varchar(30),
	g_provincia VARCHAR(30) ,
	g_canton VARCHAR(30) ,
	g_distrito VARCHAR(30) ,
	g_detalle VARCHAR(100) 

)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	insert into giras values (g_ID_Gira,cast (g_Fecha_inicio as date),cast (g_Fecha_final as date),g_costo,cast(g_duracion as time),g_provincia,g_canton,g_distrito,g_detalle);	
	raise notice 'Se inserto Gira';
end $BODY$
language plpgsql;


--Insertae Polizas
create or replace function insertar_Polizas(
	
	p_ID_Poliza CHAR(7),
	p_Descripcion VARCHAR(100),
	p_Monto INT,
	p_Fecha_vencimiento varchar(30),
	p_Aseguradora VARCHAR(30)

)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	
	insert into polizas values (p_ID_Poliza,p_Descripcion,p_Monto,cast(p_Fecha_vencimiento as date),p_Aseguradora);	
	raise notice 'Se inserto Poliza';
end $BODY$
language plpgsql;




----------Modificar-------------

--Modificar giras
CREATE OR REPLACE FUNCTION modificar_giras
(
	g_ID_Gira CHAR(7),
	g_Fecha_inicio varchar(50),
	g_Fecha_final varchar(50),
	g_costo INT,
	g_duracion varchar(30),
	g_provincia VARCHAR(30) ,
	g_canton VARCHAR(30) ,
	g_distrito VARCHAR(30) ,
	g_detalle VARCHAR(100) 

) RETURNS VOID
AS
$BODY$
BEGIN
    update giras set
	ID_gira=g_ID_Gira,
	Fecha_inicio=cast(g_Fecha_inicio as date),
	Fecha_final=cast(g_Fecha_final as date),
	costo=g_costo,
	duracion=cast (g_duracion as time),
	provincia=g_provincia,
	canton=g_canton,
	distrito=g_distrito,
	detalle=g_detalle 

    where ID_gira=g_ID_Gira;
END;
$BODY$
LANGUAGE plpgsql;

--Modificar polizas
CREATE OR REPLACE FUNCTION modificar_polizas
(
	p_ID_Poliza CHAR(7),
	p_Descripcion VARCHAR(100),
	p_Monto INT,
	p_Fecha_vencimiento varchar(30),
	p_Aseguradora VARCHAR(30)

) RETURNS VOID
AS
$BODY$
BEGIN
    update polizas set
	ID_Poliza=p_ID_Poliza,
	Descripcion=p_Descripcion,
	Monto=p_Monto,
	Fecha_vencimiento=cast(p_Fecha_vencimiento as date),
	Aseguradora=p_Aseguradora

    where ID_poliza=p_ID_poliza;
END;
$BODY$
LANGUAGE plpgsql;


--borrado de giras
CREATE OR REPLACE FUNCTION borrar_giras
(
	g_ID_Gira CHAR(7)
) RETURNS VOID
AS
$BODY$
BEGIN
    delete from giras where id_gira=g_id_gira;
END;
$BODY$
LANGUAGE plpgsql;

--borrado polizas
CREATE OR REPLACE FUNCTION borrar_polizas
(
	p_ID_poliza CHAR(7)
) RETURNS VOID
AS
$BODY$
BEGIN
    delete from polizas where id_poliza=p_id_poliza;
END;
$BODY$
LANGUAGE plpgsql;
