/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      Sybase AS Enterprise 12.5                    */
/* Created on:     11/11/2003 03:19:34 p.m.                     */
/*==============================================================*/


------------------------------------------------------------------------------------------
-- PASO 1
------------------------------------------------------------------------------------------

/*==============================================================*/
/* Table: ClienteContrato                                       */
/*==============================================================*/
create table ClienteContrato (
     cliente_empresarial  numeric                        not null,
     COcodigo             numeric                        identity,
     COnombre             varchar(255)                   not null,
     COinicio             datetime                       null,
     COfinal              datetime                       null,
     COtexto              text                           null,
     timestamp            timestamp                      null,
     constraint PK_CLIENTECONTRATO primary key (COcodigo)
)
go

/*==============================================================*/
/* Table: ClienteContratoPaquetes                               */
/*==============================================================*/
create table ClienteContratoPaquetes (
     COcodigo             numeric                        not null,
     PAcodigo             numeric                        not null,
     constraint PK_CLIENTECONTRATOPAQUETES primary key (COcodigo, PAcodigo)
)
go

/*==============================================================*/
/* Table: ClienteContratoTarifas                                */
/*==============================================================*/
create table ClienteContratoTarifas (
     COcodigo             numeric                        not null,
     TCcodigo             numeric                        not null,
     COTmeses             tinyint                        not null,
     constraint PK_CLIENTECONTRATOTARIFAS primary key (COcodigo, TCcodigo)
)
go


/*==============================================================*/
/* Table: ClienteContratoRangos                                 */
/*==============================================================*/
create table ClienteContratoRangos (
     COcodigo             numeric                        not null,
     TCcodigo             numeric                        not null,
     CORhasta             numeric                        not null,
     CORdesde             numeric                        not null,
     CORtarifaFija        money                          not null,
     CORtarifaVariable    money                          not null,
     timestamp            timestamp                      null,
     constraint PK_CLIENTECONTRATORANGOS primary key (COcodigo, TCcodigo, CORhasta)
)
go


/*==============================================================*/
/* Table: CuentaFormaPago                                       */
/*==============================================================*/
create table CuentaFormaPago (
     cliente_empresarial  numeric                        not null,
     CFPcodigo            numeric                        identity,
     FPcodigo             numeric                        not null,
     CFPnombre            varchar(60)                    not null,
     CFPdefault           bit                            not null,
     constraint PK_CUENTAFORMAPAGO primary key (CFPcodigo)
)
go


/*==============================================================*/
/* Table: CuentaFormaPagoDatos                                  */
/*==============================================================*/
create table CuentaFormaPagoDatos (
     CFPcodigo            numeric                        not null,
     FPDcodigo            numeric                        not null,
     CFPDvalor            varchar(255)                   not null,
     constraint PK_CUENTAFORMAPAGODATOS primary key (CFPcodigo, FPDcodigo)
)
go


/*==============================================================*/
/* Table: FormaPago                                             */
/*==============================================================*/
create table FormaPago (
     FPcodigo             numeric                        identity,
     FPnombre             varchar(60)                    null,
     FPtipo               char(1)                        null
           constraint CKC_FPTIPO_FORMAPAG check (FPtipo is null or ( FPtipo in ('1') )),
     constraint PK_FORMAPAGO primary key (FPcodigo)
)
go


/*==============================================================*/
/* Table: FormaPagoDatos                                        */
/*==============================================================*/
create table FormaPagoDatos (
     FPcodigo             numeric                        not null,
     FPDcodigo            numeric                        identity,
     FPDnombre            varchar(60)                    not null,
     FPDtipoDato          char(1)                        not null,
     FPDlongitud          tinyint                        not null,
     FPDdecimales         tinyint                        null,
     FPDobligatorio       bit                            not null,
     FPDorden             smallint                       not null,
     constraint PK_FORMAPAGODATOS primary key (FPDcodigo)
)
go


alter table Etiqueta drop constraint FK_ETIQUETA_REFERENCE_IDIOMA
go
drop table Etiqueta
go
drop table Idioma
go

/*==============================================================*/
/* Table: Idioma                                               */
/*==============================================================*/
create table Idioma (
     Iid                  numeric                        identity,
     Icodigo              char(10)                       not null,
     Descripcion          varchar(60)                    not null,
     Inombreloc           varchar(60)                    not null,
     Iactivo              bit                            not null,
     Iid_idioma           numeric                        null,
     Ppais                char(2)                        null,
     constraint PK_IDIOMA primary key (Iid),
     constraint AK_AK_ICODIGO_IDIOMA unique (Icodigo)
)
go
/*==============================================================*/
/* Table: Paquete                                               */
/*==============================================================*/
create table Paquete (
     PAcodigo             numeric                        identity,
     PAcod                varchar(15)                    not null,
     PAdescripcion        varchar(60)                    not null,
     PAtexto              text                           null,
     constraint PK_PAQUETE primary key (PAcodigo)
)
go


/*==============================================================*/
/* Table: PaqueteModulo                                         */
/*==============================================================*/
create table PaqueteModulo (
     PAcodigo             numeric                        not null,
     modulo               char(20)                       not null,
     constraint PK_PAQUETEMODULO primary key (PAcodigo, modulo)
)
go

/*==============================================================*/
/* Table: PaqueteTarifas                                        */
/*==============================================================*/
create table PaqueteTarifas (
     PAcodigo             numeric                        not null,
     TCcodigo             numeric                        not null,
     PTmeses              tinyint                        not null,
     constraint PK_PAQUETETARIFAS primary key (PAcodigo, TCcodigo)
)
go


/*==============================================================*/
/* Table: PaqueteRangoDefault                                   */
/*==============================================================*/
create table PaqueteRangoDefault (
     PAcodigo             numeric                        not null,
     TCcodigo             numeric                        not null,
     PRDhasta             numeric(15)                    not null,
     PRDtarifaFija        money                          not null,
     PRDtarifaVariable    money                          not null,
     constraint PK_PAQUETERANGODEFAULT primary key (PAcodigo, TCcodigo, PRDhasta)
)
go


/*==============================================================*/
/* Table: TipoFuncionario                                       */
/*==============================================================*/
create table TipoFuncionario (
     TFcodigo             numeric                        identity,
     TFdescripcion        varchar(60)                    not null,
     constraint PK_TIPOFUNCIONARIO primary key (TFcodigo)
)
go


/*==============================================================*/
/* Table: TarifaCalculoIndicador                                */
/*==============================================================*/
create table TarifaCalculoIndicador (
     TCcodigo             numeric                        identity,
     TCnombre             varchar(60)                    not null,
     TCtexto              text                           null,
     TCtipoCalculo        char(1)                        not null
           constraint CKC_TCTIPOCALCULO_TARIFACA check (TCtipoCalculo in ('F','S','J')),
     TCsql                text                           null,
     TCcomponente         varchar(40)                    null,
     TCmetodo             varchar(40)                    null,
     modulo               char(20)                       null,
     TCmeses              tinyint                        not null,
     timestamp            timestamp                      null,
     constraint PK_TARIFACALCULOINDICADOR primary key (TCcodigo)
)
go


/*==============================================================*/
/* Table: TarifaRangosDefaults                                  */
/*==============================================================*/
create table TarifaRangosDefaults (
     TCcodigo             numeric                        not null,
     TRDhasta             numeric(15)                    not null,
     TRDtarifaFija        money                          not null,
     TRDtarifaVariable    money                          not null,
     timestamp            timestamp                      null,
     constraint PK_TARIFARANGOSDEFAULTS primary key (TCcodigo, TRDhasta)
)
go



set identity_insert Idioma on
go
insert into Idioma (Iid, Icodigo, Descripcion, Inombreloc, Iactivo) values (1,'es','Espanol','Spanish',1)
insert into Idioma (Iid, Icodigo, Descripcion, Inombreloc, Iactivo) values (2,'en','Ingles','English',1)
insert into Idioma (Iid, Icodigo, Descripcion, Inombreloc, Iactivo, Iid_idioma, Ppais) values (3,'es_CR','Espanol de Costa Rica','Spanish (CR)',1,1,'CR')
go
set identity_insert Idioma off
go

insert into TipoIdentificacion values ('JUR','Cedula Juridica')
update TipoIdentificacion set TInombre='Cedula Fisica' where TIcodigo='CED'
go

go

------------------------------------------------------------------------------------------
-- PASO 2
------------------------------------------------------------------------------------------

/*==============================================================*/
/* Table: CuentaClienteEmpresarial                              */
/*==============================================================*/
alter table dbo.CuentaClienteEmpresarial 
add
     TIcodigo             char(3)        default 'JUR'   not null,
     identificacion       varchar(60)    default '0'     not null,
     razon_social         varchar(100)                   null,
     Ppais                char(2)        default 'CR'    not null,
     Iid                  numeric        default 1       not null,
     direccion            varchar(255)                   null,
     ciudad               varchar(255)                   null,
     provincia            varchar(255)                   null,
     codPostal            varchar(60)                    null,
     telefono             varchar(30)                    null,
     fax                  varchar(30)                    null,
     email                varchar(60)                    null,
     web                  varchar(60)                    null,
     ambitoLogin          char(1)                        null
           constraint CKC_AMBITOLOGIN_CUENTACL check (ambitoLogin is null or ( ambitoLogin in ('P','C') ))
go
update dbo.CuentaClienteEmpresarial set razon_social=descripcion
go
alter table dbo.CuentaClienteEmpresarial drop descripcion
go
alter table dbo.CuentaClienteEmpresarial
modify
     nombre               varchar(100)                   not null,
     razon_social         varchar(100)                   not null
go
alter table dbo.CuentaClienteEmpresarial
replace
     fecha                default getdate()
go

/*==============================================================*/
/* Table: Empresa                                               */
/*==============================================================*/
alter table dbo.Empresa 
add
     TIcodigo             char(3)        default 'JUR'   not null,
     identificacion       varchar(60)    default '0'     not null,
     fecha                datetime    default '20000101' not null,
     Ppais                char(2)        default 'CR'    not null,
     Iid                  numeric        default 1       not null,
     ciudad               varchar(255)                   null,
     provincia            varchar(255)                   null,
     codPostal            varchar(60)                    null,
     email                varchar(60)                    null
go

update dbo.Empresa
	set TIcodigo=case when cedula_tipo ='J' then 'JUR' else 'CED' end, identificacion=cedula
go

alter table dbo.Empresa 
drop constraint CKC_CEDULA_TIPO_EMPRESA
go

alter table dbo.Empresa 
replace
     fecha                default getdate()
go

/*==============================================================*/
/* Table: Usuario                                               */
/*==============================================================*/
alter table dbo.Usuario
add
     Iid                  numeric                        default 1 not null,
     Pweb                 varchar(60)                    null,
     Pciudad              varchar(255)                   null,
     Pprovincia           varchar(255)                   null,
     PcodPostal           varchar(60)                    null,
     Usucliente_empresarial numeric                      default -1 not null
go
alter table dbo.Usuario
replace Pid default '0'
go
create trigger trinsUsuario
	 on Usuario
	for insert, update

as

declare
	@cta varchar(10),
    @ulogin varchar(30),
	@uid numeric(18),
	@loc char(2),
	@d datetime

set nocount on
set rowcount 1

while (1=1) begin
	select @uid = null, @loc = null
	select @uid = Usucodigo, @loc = Ulocalizacion
		from Usuario
		where Usucuenta = '000-0000'
	if @uid is null break

	while (1=1) begin
		select @cta
			= char(rand() * 10 + 48)
			+ char(rand() * 10 + 48)
			+ char(rand() * 10 + 48)
			+ '-'
			+ char(rand() * 10 + 48)
			+ char(rand() * 10 + 48)
			+ char(rand() * 10 + 48)
			+ char(rand() * 10 + 48)
		if not exists (select * from Usuario where Usucuenta = @cta)
			break
	end

	update Usuario
	set Usucuenta = @cta
	where @uid = Usucodigo
	  and @loc = Ulocalizacion
	  and Usucuenta = '000-0000'
end

while (1=1) begin
	select @uid = null, @loc = null
	select @uid = Usucodigo, @loc = Ulocalizacion
		from Usuario
		where Usulogin = '*' and Usueplogin = '*'
	if @uid is null break

	while (1=1) begin
		select @ulogin
			= char(rand() * 26 + 97)
			+ char(rand() * 26 + 97)
			+ char(rand() * 26 + 97)
			+ char(rand() * 26 + 97)
			+ char(rand() * 26 + 97)
			+ '-'
			+ char(rand() * 8 + 50)
			+ char(rand() * 8 + 50)
		if not exists (select * from Usuario where Usulogin = @ulogin)
			break
	end

	update Usuario
	set Usulogin = @ulogin,
        Usueplogin = @ulogin
	where @uid = Usucodigo
	  and @loc = Ulocalizacion
	  and Usulogin = '*' and Usueplogin = '*'
end

set rowcount 0

go
/*==============================================================*/
/* Table: UsuarioEmpresarial                                    */
/*==============================================================*/
alter table UsuarioEmpresarial
add
     TFcodigo             numeric                        null,
     Iid                  numeric       default 1        not null,
     Pciudad              varchar(255)                   null,
     Pprovincia           varchar(255)                   null,
     PcodPostal           varchar(60)                    null,
     Pweb                 varchar(60)                    null
go
alter table UsuarioEmpresarial
replace     Pid                  default '0'
go
alter table UsuarioEmpresarial
replace     TIcodigo             default 'CED'
go
alter table UsuarioEmpresarial
replace     Ppais                default 'CR'
go


------------------------------------------------------------------------------------------
-- PASO 3
------------------------------------------------------------------------------------------


alter table CuentaClienteEmpresarial
   add constraint FK_CUENTACL_REFERENCE_TIPOIDEN foreign key (TIcodigo)
      references TipoIdentificacion (TIcodigo)
go


alter table CuentaClienteEmpresarial
   add constraint FK_CUENTACL_REFERENCE_IDIOMA foreign key (Iid)
      references Idioma (Iid)
go


alter table CuentaClienteEmpresarial
   add constraint FK_CUENTACL_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
go


alter table CuentaFormaPago
   add constraint FK_CUENTAFO_REFERENCE_CUENTACL foreign key (cliente_empresarial)
      references CuentaClienteEmpresarial (cliente_empresarial)
go


alter table CuentaFormaPago
   add constraint FK_CUENTAFO_REFERENCE_FORMAPA2 foreign key (FPcodigo)
      references FormaPago (FPcodigo)
go


alter table CuentaFormaPagoDatos
   add constraint FK_CUENTAFO_REFERENCE_CUENTAFO foreign key (CFPcodigo)
      references CuentaFormaPago (CFPcodigo)
go


alter table CuentaFormaPagoDatos
   add constraint FK_CUENTAFO_REFERENCE_FORMAPAG foreign key (FPDcodigo)
      references FormaPagoDatos (FPDcodigo)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_TIPOIDEN foreign key (TIcodigo)
      references TipoIdentificacion (TIcodigo)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_IDIOMA foreign key (Iid)
      references Idioma (Iid)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
go


alter table FormaPagoDatos
   add constraint FK_FORMAPAG_REFERENCE_FORMAPAG foreign key (FPcodigo)
      references FormaPago (FPcodigo)
go


alter table Idioma
   add constraint FK_IDIOMA_IDIOMA_PA_PAIS foreign key (Ppais)
      references Pais (Ppais)
go


alter table Idioma
   add constraint FK_IDIOMA_IDIOMA_IDIOMA foreign key (Iid_idioma)
      references Idioma (Iid)
go


alter table UsuarioEmpresarial
   add constraint FK_USUARIOE_REFERENCE_IDIOMA foreign key (Iid)
      references Idioma (Iid)
go

alter table UsuarioEmpresarial
   add constraint FK_USUARIOE_REFERENCE_TIPOFUNC foreign key (TFcodigo)
      references TipoFuncionario (TFcodigo)
go


alter table Usuario
   add constraint FK_USUARIO_REFERENCE_IDIOMA foreign key (Iid)
      references Idioma (Iid)
go


alter table PaqueteTarifas
   add constraint FK_PAQUETET_REFERENCE_PAQUETE foreign key (PAcodigo)
      references Paquete (PAcodigo)
go

alter table PaqueteTarifas
   add constraint FK_PAQUETET_REFERENCE_TARIFACA foreign key (TCcodigo)
      references TarifaCalculoIndicador (TCcodigo)
go


alter table PaqueteRangoDefault
   add constraint FK_PAQUETER_REFERENCE_PAQUETET foreign key (PAcodigo, TCcodigo)
      references PaqueteTarifas (PAcodigo, TCcodigo)
go


alter table PaqueteModulo
   add constraint FK_PAQUETEM_REFERENCE_PAQUETE foreign key (PAcodigo)
      references Paquete (PAcodigo)
go


alter table PaqueteModulo
   add constraint FK_PAQUETEM_REFERENCE_MODULO foreign key (modulo)
      references Modulo (modulo)
go

alter table TarifaCalculoIndicador
   add constraint FK_TARIFACA_REFERENCE_MODULO foreign key (modulo)
      references Modulo (modulo)
go


alter table TarifaRangosDefaults
   add constraint FK_TARIFARA_REFERENCE_TARIFACA foreign key (TCcodigo)
      references TarifaCalculoIndicador (TCcodigo)
go


alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_LOCALECO foreign key (LOCcodigo)
      references LocaleConcepto (LOCcodigo)
go


alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
go


alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_IDIOMA foreign key (Iid)
      references Idioma (Iid)
go


alter table ClienteContrato
   add constraint FK_CLIENTEC_REFERENCE_CUENTACL foreign key (cliente_empresarial)
      references CuentaClienteEmpresarial (cliente_empresarial)
go


alter table ClienteContratoPaquetes
   add constraint FK_CONTRATO_REFERENCE_CONTRAT2 foreign key (COcodigo)
      references ClienteContrato (COcodigo)
go


alter table ClienteContratoPaquetes
   add constraint FK_CLIENTEC_REFERENCE_PAQUETE foreign key (PAcodigo)
      references Paquete (PAcodigo)
go


alter table ClienteContratoTarifas
   add constraint FK_COT_REFERENCE_CO foreign key (COcodigo)
      references ClienteContrato (COcodigo)
go


alter table ClienteContratoTarifas
   add constraint FK_CLIENTEC_REFERENCE_TARIFACA foreign key (TCcodigo)
      references TarifaCalculoIndicador (TCcodigo)
go


alter table ClienteContratoRangos
   add constraint FK_COR_REFERENCE_COT foreign key (COcodigo, TCcodigo)
      references ClienteContratoTarifas (COcodigo, TCcodigo)
go



------------------------------------------------------------------------------------------
-- PASO 4
------------------------------------------------------------------------------------------

alter table dbo.UsuarioPassword
   drop constraint PK_USUARIOPASSWORD
go

alter table UsuarioPassword 
add Usucliente_empresarial numeric default -1 not null

go

alter table UsuarioPassword 
add constraint PK_USUARIOPASSWORD primary key (Usucliente_empresarial, Usulogin)

go


