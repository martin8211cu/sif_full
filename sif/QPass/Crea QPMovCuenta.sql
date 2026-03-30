drop table QPMovCuenta
go

drop table QPMovInconsistente
go

alter table QPCausa add QPCMontoVariable bit default 0
go

alter table QPCausa add QPCCargoAdmin bit default 1 -- cuando esté en 0 significa que es un movimiento a favor del cliente
go

alter table QPCausa add QPCMovUso bit default 0
go

alter table QPCausa add  QPCMembresia bit default 0
go

alter table QPventaTags add QPvtaFCobroUltMem datetime null
go



create table QPMovCuenta (
	QPMCid numeric identity primary key,
	QPCid numeric not null,
	QPctaSaldosid numeric not null,
	QPcteid numeric null,
	QPMovid numeric null,
	QPTidTag numeric null,
	QPTPAN varchar(20) null,
	QPMCFInclusion datetime not null,
	QPMCFProcesa datetime null,
	QPMCFAfectacion datetime null,
	Mcodigo numeric(8) not null,
	QPMCMonto money not null,
	QPMCMontoLoc money not null,
	QPMCSaldoMonedaLocal money null,
	QPMCdescripcion varchar(80) null,
	BMFecha datetime not null
)
go

create table QPMovInconsistente (
	Ecodigo  integer not null,
	QPTPAN char(20) null,
	QPMCFInclusion datetime not null,
	QPMCMonto money not null,
	QPMCdescripcion varchar(80) null,
	BMFecha datetime not null
)
go

