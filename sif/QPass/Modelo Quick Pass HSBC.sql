drop table QPassTag
go
drop table QPassLote
go
drop table QPassEstado
go
drop table QPassUsuarioOficina
go
drop table QPassTagMov
go

drop table QPassTrasladoOfi
go
drop table QPassTraslado
go

drop table QPventaConvenio
go
drop table QPventaTags
go
drop table QPcuentaSaldos
go
drop table QPcuentaBanco 
go
drop table QPtipoCliente
go
drop table QPcliente
go

create table QPassLote
(
	QPidLote numeric identity primary key,
	Ecodigo integer not null,
	QPLcodigo char(20) not null,
	QPLdescripcion varchar(100) not null,
	QPLfechaProduccion date null,
	QPLfechaFinVigencia date null,
	BMfecha date not null,
	BMUsucodigo numeric not null,
	ts_rversion timestamp null
)
go
create unique index QPassLote_AK1 on QPassLote ( QPLcodigo, Ecodigo)
go

create table QPassEstado(
	QPidEstado numeric identity primary key,
	Ecodigo integer not null,
	QPEdescripcion varchar(100) not null,
	QPEdisponibleVenta integer default 1,
	QEPvalorDefault numeric default 0,
	ts_rversion timestamp null
)
go

create table QPassUsuarioOficina (
	QPUOid numeric identity primary key,
	Ecodigo integer not null,
	Ocodigo integer not null,
	Usucodigo numeric not null,
	ts_rversion timestamp null
)
go

create index QPassUsuarioOficina_AK1 on QPassUsuarioOficina ( Ecodigo, Ocodigo)
go
create index QPassUsuarioOficina_AK2 on QPassUsuarioOficina ( Usucodigo )
go
create unique index QPassUsuarioOficina_AK3 on QPassUsuarioOficina (Usucodigo, Ocodigo, Ecodigo)
go


/*
	Documentacion de Campo:  Estado de Dispositivo ( QPTEstadoActivacion )

		1: En Banco / Almacen o Sucursal, 
		2:  Recuperado ( En poder del banco por recuperacion )
		3:  En proceso de Venta ( Asignado a Cliente pero no Activado )
		4. Vendido y Activo
		5: Vendido e Inactivo
		6:  Vendido y Retirado
		7: Robado o Extraviado
		8: En traslado sucurcal/PuntoVenta
		9: Asignado a Promotor
		90: Eliminado
*/


create table QPassTag (
	QPTidTag numeric identity primary key,
	QPTNumParte char(20) null,
	QPTFechaProduccion date null,
	QPTNumSerie char(20) not null,
	QPTPAN char(20) null,
	QPTNumLote char(20) null,
	QPTNumPall char(20) null,
	QPTEstadoActivacion int default 1 not null check (QPTEstadoActivacion in (1,2,3,4,5,6,7,8,9,90)) ,
	QPidLote numeric not null,
	QPidEstado numeric not null,
	BMFecha date not null,
	BMusucodigo numeric not null,
	Ecodigo integer not null,
	Ocodigo integer not null,
	ts_rversion timestamp null
)
go


create unique index QPassTag_AK1 on QPassTag ( QPTPAN, Ecodigo )
go
create unique index QPassTag_AK2 on QPassTag ( QPTNumSerie, Ecodigo )
go
create index QPassTag_FK1 on QPassTag ( QPidLote )
go
create index QPassTag_FK2 on QPassTag ( QPidEstado )
go

alter table QPassTag add  constraint FK_QPTag__REFERENCE_QPLote foreign key  (QPidLote) references QPassLote (QPidLote)
go
alter table QPassTag add  constraint FK_QPTag__REFERENCE_QPEstado foreign key  (QPidEstado) references QPassEstado (QPidEstado)
go
alter table QPassTag add  constraint FK_QPTag__REFERENCE_Oficinas foreign key  (Ecodigo, Ocodigo) references Oficinas (Ecodigo, Ocodigo)
go

/*
	Documentacion de Campo:  Tipo Movimiento ( QPTMovTipoMov)

		1: Adquisicion, 
		2. Modificacion de Informacion de Dispositivo

		3: Traslado hacia Oficinas
		4:  Recepcion de Traslado hacia Oficinas		

		5: Traslado a Punto de Ventas

		6: Activacion / Reactivacion  por Venta o por entrega
		7: Inactivacion
		8: Retiro por Robo / Extravio
		9: Recuperacion de TAG por el Banco
		10: Rechazo documento en Recepción de tags.
		11: Asignado a Promotor
		12: Asignado a Encargado

*/

create table QPassTagMov (
	QPTMovid numeric identity primary key,
	QPTidTag numeric,
	QPTMovtipoMov integer, 
	QPTNumParte char(20) null,
	QPTFechaProduccion date null,
	QPTNumSerie char(20) not null,
	QPTPAN char(20) null,
	QPTNumLote char(20) null,
	QPTNumPall char(20) null,
	QPTEstadoActivacion int default 1 ,
	Ecodigo integer not null,
	QPidLote numeric not null,
	QPidEstado numeric not null,
	BMFecha date not null,
	BMusucodigo numeric not null,
	Ocodigo integer null,
	OcodigoDest integer null,
	QPPosid numeric null,
	QPClienteid numeric null,
	QPCuentaid numeric null,
	ts_rversion timestamp null
)
go

create index QPassTagMov_AK1 on QPassTagMov ( QPTidTag )
go

alter table QPassTagMov add  constraint FK_QPTagMov__REFERENCE_QPTag foreign key  (QPTidTag) references QPassTag (QPTidTag)
go



/* Documento de Traslado ( Relacion de TAGS ) */
create table QPassTraslado (
	QPTid numeric identity primary key,
	Usucodigo numeric not null,
	Ecodigo integer not null,
	OcodigoOri integer not null,
	OcodigoDest integer not null,
	QPTtrasDocumento varchar(30) not null,
	QPTtrasDescripcion varchar(200) null,
	QPTtrasEstado integer not null,  -- 0 Sin Traslado, 1 Trasladado, 2 Aceptado no todos los tags, 3 Aceptado todos los tags
	BMFecha datetime not null,
	ts_rversion timestamp null,
	UsucodigoDestino numeric null,
	QPTFechaAceptacion datetime null
)
go
create unique index QPassTrasladoMov_AK1 on QPassTraslado ( Ecodigo,  QPTtrasDocumento )
go


create table QPassTrasladoOfi (
	QPTOid numeric identity primary key,
	QPTid numeric,
	QPTidTag numeric not null,
	QPTOEstado integer not null, --0 en traslado, 1 aceptado
	BMFecha datetime not null,
	ts_rversion timestamp null
)
go

create index QPassTrasladoOfi_AK1 on QPassTrasladoOfi (QPTid)
go

alter table QPassTrasladoOfi add  constraint FK_QPTrasO__REFERENCE_QPTras foreign key  (QPTid) references QPassTraslado (QPTid)
go




/* ************************************************************************ Modelo de Ventas ********************************************************************************************** */


create table QPtipoCliente (
	QPtipoCteid numeric identity primary key,
	Ecodigo integer not null,
	QPtipoCteCod varchar(20) not null,
	QPtipoCteDes varchar(100) not null,
	QPtipoCteMas varchar(30) not null,
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	ts_rversion timestamp null
)

create index QPtipoCliente_AK1 on QPtipoCliente (Ecodigo,QPtipoCteCod)
go

insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '01', 'Cedula Nacional', 'XX-XXXX-XXXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '02', 'Cedula Residencia ', 'XXX XXXXXXXXXX XXXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '03', 'Cedula Residencia Temp ', 'XXXXXXXXXX XXX X1 XXXXXXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '04', 'Asilado Politico', 'XX 9 XXXXXX XXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '05', 'Pemanente Libre Con.', 'XXX RE XXXXXX XX XXXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '06', 'Residente Rentista', 'XXXX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '07', 'Cedula Refugiado', 'X7X XXX XXXXXXX XX',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '08', 'Pasaporte', '********************',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '09', 'Ident. Unica Extrangeros', '*************',1,getdate()
go
insert into QPtipoCliente (Ecodigo, QPtipoCteCod, QPtipoCteDes, QPtipoCteMas,BMusucodigo, BMFecha) select  1, '10', 'Cedula Juridica', 'X-XXXXXXXXX-XX',1,getdate()
go

create table QPcliente
(
	QPcteid numeric identity primary key,
	QPtipoCteid numeric not  null,
	QPcteDocumento varchar(30) not null,
	QPcteNombre varchar(100) not null,
	QPcteDireccion varchar(254) null,
	QPcteTelefono1 varchar(20) null,
	QPcteTelefono2 varchar(20) null,
	QPcteTelefonoC varchar(20) null,
	QPcteCorreo varchar(100) null,
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	ts_rversion timestamp null,
	Ecodigo integer not null
)
go

create unique index QPcliente_AK1 on QPcliente ( QPcteDocumento, Ecodigo)
go

alter table QPcliente  add  constraint FK_QPcl_REFERENCE_QPtipoCli foreign key  (QPtipoCteid) references QPtipoCliente (QPtipoCteid)
go



create table QPcuentaBanco (
	QPctaBancoid numeric identity primary key,
	Ecodigo integer not null,
	QPctaBancoTipo varchar(10) not null,
	QPctaBancoNum varchar(30) not null,
	QPctaBancoCC varchar(30) not null,
	QPcteid numeric not null, 			-- referencia al cliente
	QPctaBancoEstado numeric null,  		-- esto lo vamos a dejar para manejar estados a futuro
	Mcodigo numeric not null,       			-- Moneda del cliente con el banco
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	ts_rversion timestamp null
)

create index QPcuentaBanco_AK1 on QPcuentaBanco ( Ecodigo, QPctaBancoNum, QPctaBancoTipo)
go
create index QPcuentaBanco_AK2 on QPcuentaBanco ( QPcteid)
go
create  index QPcuentaBanco_AK3 on QPcuentaBanco ( Ecodigo, Mcodigo)
go

alter table QPcuentaBanco add  constraint FK_QPcue_REFERENCE_QPcli foreign key  (QPcteid) references QPcliente (QPcteid)
go

create table QPventaConvenio(
	QPvtaConvid numeric identity primary key,
	QPvtaConvCod varchar (20) not null,
	QPvtaConvDesc varchar (100) not null,
	Ecodigo integer not null,
	QPvtaConvFecIni datetime not null,
	QPvtaConvFecFin datetime not null,
	QPvtaConvPrecioTag money not null,
	QPvtaConvMembrecia money not null,
	QPvtaConvFrecuencia integer not null check (QPvtaConvFrecuencia in(1,2,3,4,6)),  		-- 1: Mensual, 2:Bimensual, 3: Trimestral, 4: Semestral, 6:Anual
	QPvtaConvCambio Money not null,   		-- Monto a Cambiar luego de N Cuotas
	QPvtaConvCuotasCambio integer not null,  	--Numero de Cuotas para aplicar el cambio en QPvtaConvCambio
	QPvtaConvPrecioReinstal money not null,
	QPvtaConvPrecioRepos money not null,
	QPvtaConvPrecioControv money not null,
	Mcodigo numeric not null,				-- Moneda del Tipo de Convenio
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	QPvtaConvFact image null,
	QPvtaConvCont image null,
	ts_rversion timestamp null
)




create index QPventaConvenio_AK1 on QPventaConvenio ( Ecodigo, QPvtaConvCod)
go
create index QPventaConvenio_AK2 on QPventaConvenio ( Ecodigo, Mcodigo)
go


insert QPventaConvenio 
(QPvtaConvCod, QPvtaConvDesc, Ecodigo, QPvtaConvFecIni, QPvtaConvFecFin, QPvtaConvPrecioTag, QPvtaConvMembrecia, QPvtaConvFrecuencia, QPvtaConvCambio, QPvtaConvCuotasCambio, QPvtaConvPrecioReinstal, QPvtaConvPrecioRepos, QPvtaConvPrecioControv, Mcodigo, BMusucodigo, BMFecha)
select  '6', 'Semestral', 1, '18991231', '18991231', 20, 1, 6, 1, 1, 10, 20, 50, 2, 11499, getdate()



create table QPcuentaSaldos (
	QPctaSaldosid numeric identity primary key,
	Ecodigo integer not null,
	QPctaSaldosSaldo money not null,
	QPctaBancoid numeric null,   			-- hace referencia a la cuenta de banco
	QPctaSaldosTipo integer not null check (QPctaSaldosTipo in(1,2,3)),		-- 1=PostPago, 2=Prepago, 3-TopUp
	Mcodigo  numeric not null,			-- Moneda de Cuenta de Saldos
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	ts_rversion timestamp null
)

create index QPcuentaBanco_AK1 on QPcuentaSaldos ( QPctaBancoid)
go
create index QPcuentaBanco_AK2 on QPcuentaSaldos ( Ecodigo, Mcodigo)
go

alter table QPcuentaSaldos add  constraint FK_QPcueS_REFERENCE_QPcueB foreign key  (QPctaBancoid) references QPcuentaBanco (QPctaBancoid)
go

create table QPventaTags(
	QPvtaTagid numeric identity primary key,
	Ecodigo integer not null,
	QPTidTag numeric not null,				-- hace referencia al tag
	QPcteid numeric null, 					-- hace referencia a la table de Clientes
	QPctaSaldosid numeric not null,  			-- hace referencia a la table de Saldos de grupos de Tags
	QPvtaConvid numeric not null,
	QPvtaTagPlaca varchar(20) null, 			-- Placa asociada al TAG.
	QPvtaTagCont image null,
	QPvtaTagFact image null,
	QPvtaTagFecha datetime not null,			-- Fecha de la venta
	Ocodigo integer not null,
	BMusucodigo numeric not null,
	BMFecha datetime not null,
	ts_rversion timestamp null
)

create index QPventaTags_AK1 on QPventaTags (QPTidTag)
go
create index QPventaTags_AK2 on QPventaTags ( QPcteid)
go
create index QPventaTags_AK3 on QPventaTags (QPctaSaldosid)
go
create index QPventaTags_AK4 on QPventaTags (QPvtaTagPlaca, Ecodigo)
go
create index QPventaTags_AK5 on QPventaTags ( Ecodigo, Ocodigo)
go

alter table QPventaTags add  constraint FK_QPvT_REFERENCE_QPTAG foreign key  (QPTidTag) references QPassTag (QPTidTag)
go
alter table QPventaTags add  constraint FK_QPvT_REFERENCE_QPcli foreign key  (QPcteid) references QPcliente (QPcteid)
go
alter table QPventaTags add  constraint FK_QPvT_REFERENCE_QPcS foreign key  (QPctaSaldosid) references QPcuentaSaldos (QPctaSaldosid)
go