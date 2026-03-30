create table QPControl (
qpl_id 			numeric identity primary key,
qpl_origen 		integer not null,
qpl_fecha_ingreso 	datetime not null,
qpl_cant_registros 	integer,
qpl_fecha_caducidad 	datetime,
qpl_total_monto 	money,
qpl_estado 		integer not null,
qpl_fecha_proceso1 	datetime null,
qpl_fecha_proceso2 	datetime null,
qpl_fecha_proceso3 	datetime null
)

alter table QPControl add constraint QPControl_01 CHECK  (qpl_origen in(1,2)) -- 1= SOIN a HSBC. 2= HSBC a SOIN
go


/*
Valores permitidos para el campo qpl_estado
1-Incluido
2-Listo para Procesar por sistema destino
3-Procesado (Espera de Respuesta)
4-En proceso de actualización de datos (para mantener bloqueos de control )
5-Procesado y disponible para actualización de sistema origen
6-Procesado por Sistema Origen

*/
alter table QPControl add constraint QPControl_02 CHECK  (qpl_estado in(1,2,3,4,5,6))
go


create table QPEntrada (
	qpld_id 		numeric identity primary key,
	qpl_id 			numeric not null,
	qpld_tipo_mov 		integer not null,
	qpld_causa 		varchar(20) not null,
	qpld_ente 		integer null,
	qpld_identificacion   	varchar(30) not null,
	qpld_cuenta 		char(15),
	qpld_monto 		money,
	qpld_moneda 		char(3),
	qpld_fecha 		datetime not null,
	qpld_descripcion 	varchar(255) not null,
	qpld_PAN 		varchar(20)
)


/*
Valores para el campo qpld_tipo_mov:
1 =  Bloqueo
2 = Cobro
3 = Modificación de Datos

*/

alter table QPEntrada add constraint QPEntrada_01 CHECK  (qpld_tipo_mov in(1,2,3))
go

create table QPSalida (
	qpdl_id  		numeric primary key,
	qpl_id 			numeric not null,
	qpdl_tipo_mov 		integer not null,
	qpdl_causa 		varchar(20) not null,
	qpdl_ente 		integer not null,
	qpdl_cuenta 		char(15),
	qpdl_monto 		money,
	qpdl_moneda 		char(3),
	qpdl_monto_no_blq 	money,
	qpdl_moneda_no_blq 	char(3),
	qpdl_fecha_blq 		datetime,
	qpdl_cod_error 		char(1),
	qpdl_desc_cod_error 	varchar(255),
	qpdl_lista 		char(2) not null,
	qpdl_cod_bloqueo 	integer,
	qpdl_cod_bloqueo2 	integer,
	qpdl_estado 		integer,
	qpdl_PAN 		varchar(20)

)

alter table QPSalida add constraint QPSalida_01 CHECK  (qpdl_estado in(0,1)) -- 0: No procesado, 1: Procesado
go
