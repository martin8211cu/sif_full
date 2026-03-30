/*==============================================================*/
/* Database name:  Database                                     */
/* DBMS name:      Sybase AS Enterprise 12.5                    */
/* Created on:     11/11/2003 03:19:34 p.m.                     */
/*==============================================================*/


------------------------------------------------------------------------------------------
-- PASO 1
------------------------------------------------------------------------------------------

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


/*==============================================================*/
/* Table: ValorFormaPago                                        */
/*==============================================================*/
create table ValorFormaPago (
     VFPcodigo            numeric                        identity,
     FPcodigo             numeric                        not null,
     VFPnombre            varchar(60)                    not null,
     VFPdefault           bit                            not null,
     constraint PK_VALORFORMAPAGO primary key (VFPcodigo)
)
go


/*==============================================================*/
/* Table: ValorFormaPagoDatos                                   */
/*==============================================================*/
create table ValorFormaPagoDatos (
     VFPcodigo            numeric                        not null,
     FPDcodigo            numeric                        not null,
     VFPDvalor            varchar(255)                   not null,
     constraint PK_VALORFORMAPAGODATOS primary key (VFPcodigo, FPDcodigo)
)
go


/*==============================================================*/
/* Table: CuentaFormaPago                                       */
/*==============================================================*/
create table CuentaFormaPago (
     cliente_empresarial  numeric                        not null,
     VFPcodigo            numeric                        not null,
     constraint PK_CUENTAFORMAPAGO primary key (cliente_empresarial, VFPcodigo)
)
go


/*==============================================================*/
/* Table: LocaleConcepto                                        */
/*==============================================================*/
create table LocaleConcepto (
     LOCid                numeric                        identity,
     LOCnombre            varchar(40)                    not null,
     LOCtipo              char(1)                        not null
           constraint CKC_LOCTIPO_LOCALECO check (LOCtipo in ('P','I','V')),
     LOCorden             char(1)                        null
           constraint CKC_LOCORDEN_LOCALECO check (LOCorden is null or ( LOCorden in ('S','V','D') )),
     constraint PK_LOCALECONCEPTO primary key (LOCid)
)
go

/*==============================================================*/
/* Table: LocalePais                                            */
/*==============================================================*/
create table LocalePais (
     LOCid                numeric                        null,
     LOPid                numeric                        identity,
     Ppais                char(2)                        null,
     LOPorden             char(1)                        not null
           constraint CKC_LOPORDEN_LOCALEPA check (LOPorden in ('S','V','D')),
     LOPeliminar          bit                            default 0 not null,
     constraint PK_LOCALEPAIS primary key (LOPid)
)
go


create table LocaleValores (
     LOCid                numeric                        not null,
     LOVid                numeric                        identity,
     LOPid                numeric                        null,
     Icodigo              char(10)                       not null,
     LOVsecuencia         smallint                       not null,
     LOVvalor             char(10)                       not null,
     LOVdescripcion       varchar(40)                    not null,
     constraint PK_LOCALEVALORES primary key (LOVid)
)
go


create table LocalePagina (
     LOPAGid              numeric                        identity,
     LOPAGnombre          varchar(255)                   not null,
     constraint PK_LOCALEPAGINA primary key (LOPAGid)
)
go

/*==============================================================*/
/* Table: LocaleEtiqueta                                        */
/*==============================================================*/
create table LocaleEtiqueta (
     LOEid                numeric                        identity,
     LOEnombre            varchar(40)                    not null,
     LOPAGid              numeric                        null,
     constraint PK_LOCALEETIQUETA primary key (LOEid)
)
go


create table LocaleTraduccion (
     LOEid                numeric                        not null,
     LOTid                numeric                        identity,
     Icodigo              char(10)                       not null,
     LOTdescripcion       varchar(255)                   not null,
     constraint PK_LOCALETRADUCCION primary key (LOTid)
)
go



------------------------------------------------------------------------------------------
-- PASO 2
------------------------------------------------------------------------------------------



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

set identity_insert LocaleConcepto on
go
insert into LocaleConcepto(LOCid, LOCnombre, LOCtipo) values (1,'PROVINCIA','P')
go
set identity_insert LocaleConcepto off
go
set identity_insert LocalePais on
go
insert into LocalePais(LOCid, LOPid, Ppais, LOPorden, LOPeliminar) values (1,1,'CR','S',0)
insert into LocalePais(LOCid, LOPid, Ppais, LOPorden, LOPeliminar) values (1,2,'US','S',0)
insert into LocalePais(LOCid, LOPid, Ppais, LOPorden, LOPeliminar) values (1,3,'MX','S',0)
insert into LocalePais(LOCid, LOPid, Ppais, LOPorden, LOPeliminar) values (1,4,'PR','S',1)
-- Se esta definiendo Puerto Rico que Requiere Eliminar el Concepto PROVINCIA
go
set identity_insert LocalePais off
go
set identity_insert LocaleValores on
go
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,01,1,'es',0,'','Provincia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,02,1,'es',1,'1','San Jose')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,03,1,'es',2,'2','Alajuela')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,04,1,'es',3,'3','Cartago')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,05,1,'es',4,'4','Heredia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,06,1,'es',5,'5','Guanacaste')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,07,1,'es',6,'6','Puntarenas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,08,1,'es',7,'7','Limon')

insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,09,2,'es',0,'','Estado')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,10,2,'es',1,'AL','Alabama')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,11,2,'es',2,'AK','Alaska')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,12,2,'es',4,'AZ','Arizona')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,13,2,'es',3,'AR','Arkansas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,14,2,'es',5,'CA','California')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,15,2,'es',6,'NC','Carolina del norte')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,16,2,'es',7,'SC','Carolina del sur')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,17,2,'es',8,'CO','Colorado')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,18,2,'es',9,'CT','Connecticut')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,19,2,'es',10,'ND','Dakota del norte')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,20,2,'es',11,'SD','Dakota del sur')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,21,2,'es',12,'DE','Delaware')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,22,2,'es',13,'DC','District of Columbia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,23,2,'es',14,'FL','Florida')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,24,2,'es',15,'GA','Georgia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,25,2,'es',16,'HI','Hawai')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,26,2,'es',17,'ID','Idaho')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,27,2,'es',18,'IL','Illinois')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,28,2,'es',19,'IN','Indiana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,29,2,'es',20,'IA','Iowa')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,30,2,'es',21,'KS','Kansas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,31,2,'es',22,'KY','Kentucky')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,32,2,'es',23,'LA','Louisiana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,33,2,'es',24,'ME','Maine')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,34,2,'es',25,'MD','Maryland')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,35,2,'es',26,'MA','Massachusetts')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,36,2,'es',27,'MI','Michigan')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,37,2,'es',28,'MN','Minnesota')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,38,2,'es',29,'MS','Mississippi')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,39,2,'es',30,'MO','Missouri')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,40,2,'es',31,'MT','Montana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,41,2,'es',32,'NE','Nebraska')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,42,2,'es',33,'NV','Nevada')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,43,2,'es',34,'NH','New Hampshire')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,44,2,'es',35,'NJ','Nueva Jersey')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,45,2,'es',36,'NY','Nueva York')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,46,2,'es',37,'NM','Nuevo México')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,47,2,'es',38,'OH','Ohio')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,48,2,'es',39,'OK','Oklahoma')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,49,2,'es',40,'OR','Oregón')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,50,2,'es',41,'PA','Pennsylvania')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,51,2,'es',42,'RI','Rhode Island')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,52,2,'es',43,'TN','Tennessee')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,53,2,'es',44,'TX','Texas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,54,2,'es',45,'UT','Utah')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,55,2,'es',46,'VT','Vermont')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,56,2,'es',47,'VA','Virginia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,57,2,'es',48,'WA','Washington')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,58,2,'es',49,'WV','West Virginia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,59,2,'es',50,'WI','Wisconsin')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,60,2,'es',51,'WY','Wyoming')

insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,109,2,'en',0,'','State')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,110,2,'en',1,'AL','Alabama')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,111,2,'en',2,'AK','Alaska')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,112,2,'en',4,'AZ','Arizona')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,113,2,'en',3,'AR','Arkansas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,114,2,'en',5,'CA','California')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,115,2,'en',6,'NC','North Carolina')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,116,2,'en',7,'SC','South Carolina')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,117,2,'en',8,'CO','Colorado')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,118,2,'en',9,'CT','Connecticut')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,119,2,'en',10,'ND','North Dakota')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,120,2,'en',11,'SD','South Dakota')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,121,2,'en',12,'DE','Delaware')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,122,2,'en',13,'DC','District of Columbia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,123,2,'en',14,'FL','Florida')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,124,2,'en',15,'GA','Georgia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,125,2,'en',16,'HI','Hawaii')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,126,2,'en',17,'ID','Idaho')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,127,2,'en',18,'IL','Illinois')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,128,2,'en',19,'IN','Indiana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,129,2,'en',20,'IA','Iowa')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,130,2,'en',21,'KS','Kansas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,131,2,'en',22,'KY','Kentucky')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,132,2,'en',23,'LA','Louisiana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,133,2,'en',24,'ME','Maine')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,134,2,'en',25,'MD','Maryland')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,135,2,'en',26,'MA','Massachusetts')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,136,2,'en',27,'MI','Michigan')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,137,2,'en',28,'MN','Minnesota')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,138,2,'en',29,'MS','Mississippi')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,139,2,'en',30,'MO','Missouri')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,140,2,'en',31,'MT','Montana')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,141,2,'en',32,'NE','Nebraska')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,142,2,'en',33,'NV','Nevada')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,143,2,'en',34,'NH','New Hampshire')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,144,2,'en',35,'NJ','New Jersey')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,145,2,'en',36,'NY','New York')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,146,2,'en',37,'NM','New Mexico')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,147,2,'en',38,'OH','Ohio')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,148,2,'en',39,'OK','Oklahoma')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,149,2,'en',40,'OR','Oregon')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,150,2,'en',41,'PA','Pennsylvania')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,151,2,'en',42,'RI','Rhode Island')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,152,2,'en',43,'TN','Tennessee')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,153,2,'en',44,'TX','Texas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,154,2,'en',45,'UT','Utah')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,155,2,'en',46,'VT','Vermont')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,156,2,'en',47,'VA','Virginia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,157,2,'en',48,'WA','Washington')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,158,2,'en',49,'WV','West Virginia')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,159,2,'en',50,'WI','Wisconsin')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,160,2,'en',51,'WY','Wyoming')

insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,61,3,'es',0,'','Estado')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,62,3,'es',1,'01','Aguascalientes')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,63,3,'es',2,'02','Baja California')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,64,3,'es',3,'03','Baja California Sur')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,65,3,'es',4,'04','Campeche')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,66,3,'es',5,'05','Chiapas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,67,3,'es',6,'06','Chihuahua')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,68,3,'es',7,'07','Coahuila')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,69,3,'es',8,'08','Colima')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,70,3,'es',9,'09','Distrito Federal')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,71,3,'es',10,'10','Durango')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,72,3,'es',11,'11','Guanajuato')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,73,3,'es',12,'12','Guerrero')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,74,3,'es',13,'13','Hidalgo')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,75,3,'es',14,'14','Jalisco')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,76,3,'es',15,'15','México')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,77,3,'es',16,'16','Michoacán')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,78,3,'es',17,'17','Morelos')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,79,3,'es',18,'18','Nayarit')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,80,3,'es',19,'19','Nuevo Le&oacute;n')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,81,3,'es',20,'20','Oaxaca')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,82,3,'es',21,'21','Puebla')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,83,3,'es',22,'22','Querétaro')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,84,3,'es',23,'23','Quintana Roo')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,85,3,'es',24,'24','San Luis Potos&iacute;')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,86,3,'es',25,'25','Sinaloa')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,87,3,'es',26,'26','Sonora')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,88,3,'es',27,'27','Tabasco')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,89,3,'es',28,'28','Tamaulipas')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,90,3,'es',29,'29','Tlaxcala')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,91,3,'es',30,'30','Veracruz')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,92,3,'es',31,'31','Yucatán')
insert into LocaleValores(LOCid, LOVid, LOPid, Icodigo, LOVsecuencia, LOVvalor, LOVdescripcion) values (1,93,3,'es',32,'32','Zacatecas')
go
set identity_insert LocaleValores off
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
     Icodigo              char(10)       default 'es'    not null,
     direccion            varchar(255)                   null,
     direccion1            varchar(255)                   null,
     direccion2            varchar(255)                   null,
     ciudad               varchar(30)                   null,
     provincia            varchar(30)                   null,
     codPostal            varchar(30)                    null,
     telefono             varchar(30)                    null,
     fax                  varchar(30)                    null,
     email                varchar(60)                    null,
     web                  varchar(60)                    null,
     alias_login          char(20)                       null,
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
     Icodigo              char(10)       default 'es'    not null,
     direccion1            varchar(255)                   null,
     direccion2            varchar(255)                   null,
     ciudad               varchar(30)                   null,
     provincia            varchar(30)                   null,
     codPostal            varchar(30)                    null,
     email                varchar(60)                    null
go

alter table dbo.Empresa
modify cedula varchar(20) null, cedula_tipo char(1) null
go

alter table dbo.Empresa
drop constraint CKC_CEDULA_TIPO_EMPRESA 
go

update dbo.Empresa
	set TIcodigo=case when cedula_tipo ='J' then 'JUR' else 'CED' end, identificacion=cedula
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
     Icodigo              char(10)       default 'es'    not null,
     Pdireccion1            varchar(255)                   null,
     Pdireccion2            varchar(255)                   null,
     Pweb                 varchar(60)                    null,
     Pciudad              varchar(30)                   null,
     Pprovincia           varchar(30)                   null,
     PcodPostal           varchar(30)                    null,
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
     Icodigo              char(10)       default 'es'    not null,
     Pdireccion1            varchar(255)                   null,
     Pdireccion2            varchar(255)                   null,
     Pciudad              varchar(30)                   null,
     Pprovincia           varchar(30)                   null,
     PcodPostal           varchar(30)                    null,
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
   add constraint FK_CUENTACL_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
go


alter table CuentaClienteEmpresarial
   add constraint FK_CUENTACL_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_TIPOIDEN foreign key (TIcodigo)
      references TipoIdentificacion (TIcodigo)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
go


alter table Empresa
   add constraint FK_EMPRESA_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
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
   add constraint FK_USUARIOE_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
go

alter table UsuarioEmpresarial
   add constraint FK_USUARIOE_REFERENCE_TIPOFUNC foreign key (TFcodigo)
      references TipoFuncionario (TFcodigo)
go


alter table Usuario
   add constraint FK_USUARIO_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
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


alter table ValorFormaPago
   add constraint FK_VALORFOR_REFERENCE_FORMAPAG foreign key (FPcodigo)
      references FormaPago (FPcodigo)
go

alter table ValorFormaPagoDatos
   add constraint FK_VALORFOD_REFERENCE_FORMAPAD foreign key (FPDcodigo)
      references FormaPagoDatos (FPDcodigo)
go


alter table ValorFormaPagoDatos
   add constraint FK_VALORFOR_REFERENCE_VALORFOR foreign key (VFPcodigo)
      references ValorFormaPago (VFPcodigo)
go

alter table CuentaFormaPago
   add constraint FK_CUENTAFO_REFERENCE_CUENTACL foreign key (cliente_empresarial)
      references CuentaClienteEmpresarial (cliente_empresarial)
go


alter table FormaPagoDatos
   add constraint FK_FORMAPAG_REFERENCE_FORMAPAG foreign key (FPcodigo)
      references FormaPago (FPcodigo)
go

alter table CuentaFormaPago
   add constraint FK_CUENTAFO_REFERENCE_VALORFOR foreign key (VFPcodigo)
      references ValorFormaPago (VFPcodigo)
go


alter table LocalePais
   add constraint FK_LOCALEPA_REFERENCE_LOCALECO foreign key (LOCid)
      references LocaleConcepto (LOCid)
go


alter table LocalePais
   add constraint FK_LOCALEPA_REFERENCE_PAIS foreign key (Ppais)
      references Pais (Ppais)
go

alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_LOCALECO foreign key (LOCid)
      references LocaleConcepto (LOCid)
go


alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
go


alter table LocaleValores
   add constraint FK_LOCALEVA_REFERENCE_LOCALEPA foreign key (LOPid)
      references LocalePais (LOPid)
go

alter table LocaleEtiqueta
   add constraint FK_LOCALEET_REFERENCE_LOCALEPA foreign key (LOPAGid)
      references LocalePagina (LOPAGid)
go

alter table LocaleTraduccion
   add constraint FK_LOCALETR_REFERENCE_IDIOMA foreign key (Icodigo)
      references Idioma (Icodigo)
go


alter table LocaleTraduccion
   add constraint FK_LOCALETR_REFERENCE_LOCALEET foreign key (LOEid)
      references LocaleEtiqueta (LOEid)
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


