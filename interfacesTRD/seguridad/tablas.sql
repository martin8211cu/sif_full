-- drop table PMIINT_IE10, PMIINT_ID10
go

create table PMIINT_IE10 (
  sessionid numeric(18) not null,
  FechaRegistro date,
  MensajeError varchar(200) null,
  ID numeric not null,
  EcodigoSDC numeric not null,
  NumeroSocio varchar(10) not null,
  Modulo char(4) not null,
  CodigoTransacion varchar(5) not null,
  Documento varchar(20) not null,
  Estado varchar(2) null,
  CodigoMoneda char(3) not null,
  FechaDocumento datetime not null,
  FechaVencimiento datetime null,
  Facturado char(1) not null,
  Origen char(4) not null,
  VoucherNo varchar(20) not null,
  CodigoConceptoServicio varchar(20) null,
  CodigoRetencion char(2) null,
  CodigoOficina char(10) null,
  CuentaFinanciera char(100) null,
  DiasVencimiento int default 0 not null,
  CodigoDireccionEnvio char(10) null,
  CodigoDireccionFact char(10) null,
  FechaTipoCambio datetime null,
  StatusProceso int default 10 not null
)

alter table PMIINT_IE10 add constraint pk_PMIINT_IE10 primary key (sessionid, ID)
go

create table PMIINT_ID10 (
  sessionid numeric(18) not null,
  FechaRegistro date,
  ID numeric not null,
  Consecutivo int not null,
  TipoItem char(1) not null,
  CodigoItem varchar(20) not null,
  NombreBarco varchar(20) null,
  FechaHoraCarga datetime null,
  FechaHoraSalida datetime null,
  PrecioUnitario money not null,
  CodigoUnidadMedida char(5) not null,
  CantidadTotal numeric(18,5) not null,
  CantidadNeta numeric(18,5) not null,
  CodEmbarque varchar(20) null,
  NumeroBOL varchar(20) not null,
  FechaBOL datetime not null,
  TripNo varchar(20) null,
  ContractNo varchar(20) null,
  CodigoImpuesto char(5) null,
  ImporteImpuesto money default 0 null,
  ImporteDescuento money default 0 null,
  CodigoAlmacen varchar(20) null,
  CodigoDepartamento varchar(10) null,
  PrecioTotal money default 0 not null,
  CentroFuncional char(10) null,
  CuentaFinancieraDet char(100) null,
  OCtransporteTipo char(1) null,
  OCtransporte varchar(20) null,
  OCcontrato char(10) null,
  OCconceptoCompra char(10) null,
  OCconceptoIngreso char(10) null,
  factor float null,
  calculado money null
)
go

alter table PMIINT_ID10 add constraint pk_PMIINT_ID10 primary key (sessionid, ID, Consecutivo)
go

