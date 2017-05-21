
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
	ID_Evento Serial primary key NOT NULL,
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
	ID_Evento Serial NOT NULL,
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
	Id_secciones serial NOT NULL PRIMARY KEY
		      );
--Tabla secciones funcionarios
CREATE TABLE SF(
	Id_secciones Serial NOT NULL ,
	cedula a_cedula,
	CONSTRAINT PK_funcionario_secciones PRIMARY KEY (Id_secciones,cedula),
	CONSTRAINT FK_id_secciones_funcionarios_secciones FOREIGN KEY(Id_secciones)REFERENCES Secciones,
	CONSTRAINT FK_cedula_funcionarios_secciones FOREIGN KEY(cedula) REFERENCES Funcionarios 
               ); 
--Tabla polizas
CREATE TABLE Polizas(
	ID_Poliza Serial NOT NULL PRIMARY KEY,
	Descripcion VARCHAR(100) NULL,
	Monto INT NOT NULL,
	Fecha_vencimiento DATE NOT NULL,
	Aseguradora VARCHAR(30) NOT NULL
                    );
--Tabla estudiantes

CREATE  Estudiantes(
	cedula a_cedula PRIMARY KEY,
	carnet a_carnet,
	ID_Poliza serial NOT NULL,
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
	ID_Empresa Serial NOT NULL PRIMARY KEY,
	Nombre CHAR(30) NOT NULL,
	provincia VARCHAR(30) NOT NULL,
	canton VARCHAR(30) NOT NULL,
	distrito VARCHAR(30) NOT NULL,
	detalle VARCHAR(100) NULL
                    );
--Tabla contactos empresas
CREATE TABLE CE(
	cedula a_cedula,
	ID_Empresa serial NOT NULL,
	CONSTRAINT PK_Contactos_de_empresa PRIMARY KEY(cedula,ID_Empresa),
	CONSTRAINT FK_cedula_contacto_empresa FOREIGN KEY(cedula)REFERENCES Contactos,
	CONSTRAINT FK_id_empresa_de_contacto FOREIGN KEY(ID_Empresa)REFERENCES Empresas
               );         
--Tabla telefonos empresas           
CREATE TABLE Telefonos_E(
		ID_Empresa Serial NOT NULL PRIMARY KEY,
		telefono a_telefono,
		CONSTRAINT FK_id_empresa_telefonos FOREIGN KEY(ID_Empresa) REFERENCES Empresas
                        );
--Tabla correos empresas
CREATE TABLE Correos_E(
	ID_Empresa Serial NOT NULL PRIMARY KEY,
	correo a_correos ,
	CONSTRAINT FK_id_empresa_correos FOREIGN KEY(ID_Empresa) REFERENCES Empresas
                );
                
--Tabla practicas
CREATE TABLE PRACTICAS(
		ID_Practicas Serial NOT NULL PRIMARY KEY,
		Fecha_inicio DATE NOT NULL,
		Fecha_final DATE NOT NULL,
		nota int  NOT NULL,
		estado CHAR(1) NOT NULL,
		cedula a_cedula,
		ID_Empresa serial NOT NULL,
		CONSTRAINT FK_id_empresa_practicas FOREIGN KEY(ID_Empresa) REFERENCES Empresas,
		CONSTRAINT FK_cedula_estudiante_Practicas FOREIGN KEY(cedula) REFERENCES Estudiantes
                      );
--Tabla giras
CREATE TABLE Giras(
	ID_Gira Serial NOT NULL PRIMARY KEY,
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
	Id_secciones Serial NOT NULL,
	ID_Gira serial NOT NULL,
	CONSTRAINT PK_Secciones_Giras PRIMARY KEY(Id_secciones,ID_Gira),
	CONSTRAINT FK_id_secciones_giras FOREIGN KEY(Id_secciones)REFERENCES Secciones,
	CONSTRAINT FK_id_giras_secciones FOREIGN KEY(ID_Gira)REFERENCES Giras
               );
--Tabla estudiantes secciones
CREATE TABLE ES(
	Id_secciones Serial NOT NULL,
	cedula a_cedula,
	CONSTRAINT PK_Estudiantes_secciones PRIMARY KEY(Id_secciones,cedula),
	CONSTRAINT FK_Id_secciones_Estudiantes FOREIGN KEY(Id_secciones) REFERENCES Secciones,
	CONSTRAINT FK_cedula_estudiantes_secciones FOREIGN KEY(cedula)REFERENCES Estudiantes
               );
--Tabla eventos giras funcionarios
CREATE TABLE  GE(
	ID_Giras Serial NOT NULL,
	ID_Empresa serial NOT NULL,
	CONSTRAINT PK_Giras_empresas PRIMARY KEY(ID_Giras,ID_Empresa),
	CONSTRAINT FK_ID_empresa_Giras FOREIGN KEY(ID_Empresa)REFERENCES Empresas,
	CONSTRAINT FK_ID_giras_empresas FOREIGN KEY(ID_Giras)REFERENCES Giras
               ); 

------------------Funciones agregar-----------

--Agregar eventos
create or replace Function insertar_eventos(
<<<<<<< HEAD:Base de datos/SAICE.sql
	E_ID_Evento Serial NOT NULL,
=======
	E_ID_Evento CHAR(7),
>>>>>>> 2af9f0ab5ef60d84b9d00174aba7b779260ad34e:SAICE.sql
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

--------------------------CRUD de estudiantes-----------------------------------------------
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
	p_detalle VARCHAR(100),
	p_poliza int
	
)returns void as
$BODY$
Begin
	raise notice 'Insertando';
	insert into personas values (p_cedula,p_Nombre,p_Apellido1,p_Apellido2,p_provincia,p_canton,p_distrito,p_detalle);
	insert into telefonos_p values(p_cedula,p_telefono);
	insert into correos_p values(p_cedula,p_correos);
	insert into Estudiantes values (p_cedula,p_carnet,p_poliza);
	raise notice 'Se inserto Estudiante';
end $BODY$
language plpgsql;

--Funcion que se encarga de eliminar un estudiante
		CREATE OR REPLACE FUNCTION eliminarEstudiante
		( 
			p_cedula a_cedula
		) RETURNS VOID
		AS
		$BODY$
		BEGIN
			delete  from Estudiantes where cedula=p_cedula;
			delete  from correos_p where cedula=p_cedula;
			delete  from telefonos_p where cedula=p_cedula;
			delete  from personas where cedula=p_cedula;
		END;
		$BODY$ 
		LANGUAGE plpgsql;


--Se encarga de recuperar los estudiantes
 
select p.cedula,p.nombre,p.apellido1,p.apellido2,p.provincia,
p.canton,p.distrito,p.detalle,e.carnet,e.id_poliza,t.telefono,cp.correo from personas
p inner join estudiantes e on e.cedula=p.cedula inner join 
correos_p cp on cp.cedula=p.cedula inner join telefonos_p t on t.cedula=p.cedula;

select actualizarEstudiante('2015-110180','1-111-111',
			'8637-4844','landresf3638@hotmail.com',
			'Andres','adawda','Calderon','Alajuela',
			'San Ramon','Piedades Sur','Estudiante',1);
---Funcion que se encarga de modificar un estudiante
CREATE OR REPLACE FUNCTION actualizarEstudiante
		( 
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
			p_detalle VARCHAR(100),
			p_poliza int
		) RETURNS VOID
		AS
		$BODY$
		BEGIN
			update  Personas  set 
				nombre=p_nombre,
				apellido1=p_Apellido1,
				apellido2=p_Apellido2,
				provincia=p_provincia,
				canton=p_canton,
				distrito=p_distrito,
				detalle=p_detalle
				where cedula=p_cedula;
			
			update correos_p set correo=p_correos where cedula=p_cedula;
			update telefonos_p  set telefono=p_telefono where cedula=p_cedula;
			update Estudiantes set id_poliza=p_poliza where cedula=p_cedula;
		END;
		$BODY$ 
		LANGUAGE plpgsql;





select * from polizas
select * from Estudiantes
select * from personas 
select * from correos_p 

select p.cedula,p.nombre,p.apellido1,p.apellido2,p.provincia,p.canton,p.distrito,p.detalle,e.carnet,e.id_poliza from personas p inner join estudiantes e on e.cedula=p.cedula
insert into polizas(descripcion,monto,fecha_vencimiento,aseguradora)values('awdadw','5000','08-08-2018','INS'),
									('awdadw','10000','08-08-2018','INS'),
									('awdadw','15000','08-08-2018','INS'),										
select insertar_Estudiante('2015-110180','2-122-193','8637-4844','landresf12@hotmail.com','Andres ','Hernandez','Calderon','Alajuela','San Ramon','Piedades Sur','Estudiante','1');
select insertar_Estudiante('2015-111111','2-321-321','8637-4845','landresf12@hotmail.com','Luis','Fernandez','Matamoros','Alajuela','San Ramon','Piedades Sur','Estudiante');
select insertar_Estudiante('2015-121212','2-745-217','8637-4846','landresf12@hotmail.com','Luis Andres','Fernandez','Calderon','Alajuela','San Ramon','Piedades Sur','Estudiante');   

select eliminarEstudiante('2-122-193');

drop function actualizarEstudiante()
select actualizarEstudiante('2015-110180','1-111-111',
			'8637-4844','landresf3638@hotmail.com',
			'Andres','adawda','Calderon','Alajuela',
			'San Ramon','Piedades Sur','Estudiante','1');