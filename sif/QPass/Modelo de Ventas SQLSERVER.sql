/*
drop table QPCausaxConvenio
drop table QPCausaxMovimiento
drop table QPMovimiento
drop table QPCausa*/

alter table QPventaConvenio add QPvtaConvTipo int null --1=PostPago, 2=Prepago
go

alter table QPassTag add QPTlista char(1) null
go 

alter table QPassTag add constraint contrain_01 check(QPTlista in ('B','G','N'))
go 

alter table QPcliente add QPCente numeric null
go 

alter table QPcuentaSaldos add QPctaSaldosLista integer null
go 

/* 
QPctaSaldosLista Maneja los siguiente estados

	1: VIP
	2: Normal
	3: Gris
	4: Negra
	5: Cuenta no Encontrada
	6: Cuenta Inactiva
	7: Cuenta Cerrada
*/
alter table QPcuentaSaldos add constraint contrainQPCS_01 check(QPctaSaldosLista in (1,2,3,4,5,6,7))
go 


alter table QPPromotor add QPPPuntoSeguro integer null -- 1=seguro, 2=inseguro
go 

alter table QPventaTags add QPvtaEstado integer default 0 --	QPvtaEstado:  0 = En proceso, 1 = Aplicada, 2 = Anulada antes de Aplicar, 3 = Anulada despues de Aplicar
go


create table QPCausa (
	QPCid numeric identity primary key,
	QPCcodigo varchar(20) not null,
	QPCdescripcion varchar(254) not null,
	QPCmonto money not null,
	QPCCuentaContable varchar(100) null,
	Mcodigo numeric(8) not null,
	Ecodigo integer not null,
	BMFecha datetime not null,
	BMUsucodigo numeric not null,
	ts_rversion timestamp null
)

create index QPCausa_AK1 on QPCausa ( Ecodigo, QPCcodigo)
go
alter table QPCausa add  constraint FK_QPCausa_REF_Monedas foreign key  (Mcodigo) references Monedas (Mcodigo)
go



create table QPCausaxConvenio(
	QPvtaConvid numeric not null,
	QPCid numeric not null,
	Ecodigo integer not null,	
	BMFecha datetime not null,
	BMUsucodigo numeric not null,
	ts_rversion timestamp null
)

create unique index QPCausaxConvenio_PK on QPCausaxConvenio ( QPvtaConvid, QPCid, Ecodigo)
go

alter table QPCausaxConvenio add  constraint FK_QPCxCON_REF_QPvtaC foreign key  (QPvtaConvid) references QPventaConvenio (QPvtaConvid)
go

alter table QPCausaxConvenio add  constraint FK_QPCxCON_REF_QPCau foreign key  (QPCid) references QPCausa (QPCid)
go


create table QPMovimiento(
	QPMovid numeric identity primary key,
	QPMovCodigo varchar(20) not null,
	QPMovDescripcion varchar(254) not null,
	Ecodigo integer not null,	
	BMFecha datetime not null,
	BMUsucodigo numeric not null,
	ts_rversion timestamp null
)

create index QPMovimiento_AK1 on QPMovimiento ( Ecodigo, QPMovCodigo)
go


create table QPCausaxMovimiento(
	QPCid numeric not null,
	QPMovid numeric not null,
	QPCcuenta varchar(100) not null,
	Ecodigo integer not null,	
	BMFecha datetime not null,
	BMUsucodigo numeric not null,
	ts_rversion timestamp null
)

create index QPCausaxMovimiento_AK1 on QPCausaxMovimiento ( QPCid)
go

create index QPCausaxMovimiento_AK2 on QPCausaxMovimiento ( QPMovid)
go

alter table QPCausaxMovimiento add  constraint FK_QPCxMov_REF_QPCau foreign key  (QPCid) references QPCausa (QPCid)
go

alter table QPCausaxMovimiento add  constraint FK_QPCxMov_REF_QPMov foreign key  (QPMovid) references QPMovimiento (QPMovid)
go


create table QPParametros (
	Ecodigo         	int not null,
	Pcodigo         	int not null,
	Mcodigo         	char(2) null,
	Pdescripcion    	varchar(100) not null,
	Pvalor          	varchar(100) null,
	BMUsucodigo  		numeric null,
	ts_rversion     	timestamp null
)

create unique index QPParametros_PK1 on QPParametros ( Ecodigo, Pcodigo )
go


create table QPVtaContrato
(
	QPVtaContid  	numeric identity primary key,
	QPvtaTagid   	numeric not null,
	QPVtaCcontrato  text not null,
	Ecodigo 	int not null,
	BMFecha 	datetime not null,
	BMUsucodigo 	numeric not null,
	ts_rversion 	timestamp null
)
go

alter table QPVtaContrato add  constraint FK_QPVtaCon_R_QPventaT foreign key  (QPvtaTagid) references QPventaTags (QPvtaTagid)
go