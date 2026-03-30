if exists (select 1
            from  sysindexes
           where  id    = object_id('InterfazBitacoraProcesos')
            and   name  = 'Bitacora01'
            and   indid > 0
            and   indid < 255)
   drop index InterfazBitacoraProcesos.Bitacora01
go


if exists (select 1
            from  sysindexes
           where  id    = object_id('InterfazBitacoraProcesos')
            and   name  = 'Bitacora02'
            and   indid > 0
            and   indid < 255)
   drop index InterfazBitacoraProcesos.Bitacora02
go


if exists (select 1
            from  sysindexes
           where  id    = object_id('InterfazColaProcesos')
            and   name  = 'Cola01'
            and   indid > 0
            and   indid < 255)
   drop index InterfazColaProcesos.Cola01
go


if exists (select 1
            from  sysindexes
           where  id    = object_id('InterfazColaProcesosCancelar')
            and   name  = 'Cola01'
            and   indid > 0
            and   indid < 255)
   drop index InterfazColaProcesosCancelar.Cola01
go


if exists (select 1
            from  sysobjects
            where  id = object_id('EO7')
            and    type = 'U')
   drop table EO7
go


if exists (select 1
            from  sysobjects
            where  id = object_id('ID10')
            and    type = 'U')
   drop table ID10
go


if exists (select 1
            from  sysobjects
            where  id = object_id('ID6')
            and    type = 'U')
   drop table ID6
go


if exists (select 1
            from  sysobjects
            where  id = object_id('ID7')
            and    type = 'U')
   drop table ID7
go


if exists (select 1
            from  sysobjects
            where  id = object_id('ID8')
            and    type = 'U')
   drop table ID8
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE1')
            and    type = 'U')
   drop table IE1
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE10')
            and    type = 'U')
   drop table IE10
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE11')
            and    type = 'U')
   drop table IE11
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE12')
            and    type = 'U')
   drop table IE12
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE13')
            and    type = 'U')
   drop table IE13
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE14')
            and    type = 'U')
   drop table IE14
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE15')
            and    type = 'U')
   drop table IE15
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE16')
            and    type = 'U')
   drop table IE16
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE2')
            and    type = 'U')
   drop table IE2
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE3')
            and    type = 'U')
   drop table IE3
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE4')
            and    type = 'U')
   drop table IE4
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE5')
            and    type = 'U')
   drop table IE5
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE6')
            and    type = 'U')
   drop table IE6
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE7')
            and    type = 'U')
   drop table IE7
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE8')
            and    type = 'U')
   drop table IE8
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IE9')
            and    type = 'U')
   drop table IE9
go


if exists (select 1
            from  sysobjects
            where  id = object_id('IdProceso')
            and    type = 'U')
   drop table IdProceso
go


if exists (select 1
            from  sysobjects
            where  id = object_id('Interfaz')
            and    type = 'U')
   drop table Interfaz
go


if exists (select 1
            from  sysobjects
            where  id = object_id('InterfazBitacoraProcesos')
            and    type = 'U')
   drop table InterfazBitacoraProcesos
go


if exists (select 1
            from  sysobjects
            where  id = object_id('InterfazColaProcesos')
            and    type = 'U')
   drop table InterfazColaProcesos
go


if exists (select 1
            from  sysobjects
            where  id = object_id('InterfazColaProcesosCancelar')
            and    type = 'U')
   drop table InterfazColaProcesosCancelar
go


if exists (select 1
            from  sysobjects
            where  id = object_id('InterfazMotor')
            and    type = 'U')
   drop table InterfazMotor
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OD101')
            and    type = 'U')
   drop table OD101
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OD102')
            and    type = 'U')
   drop table OD102
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OD103')
            and    type = 'U')
   drop table OD103
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OD8')
            and    type = 'U')
   drop table OD8
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE101')
            and    type = 'U')
   drop table OE101
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE102')
            and    type = 'U')
   drop table OE102
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE103')
            and    type = 'U')
   drop table OE103
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE110')
            and    type = 'U')
   drop table OE110
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE16')
            and    type = 'U')
   drop table OE16
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE6')
            and    type = 'U')
   drop table OE6
go


if exists (select 1
            from  sysobjects
            where  id = object_id('OE8')
            and    type = 'U')
   drop table OE8
go


/*==============================================================*/
/* Table: EO7                                                   */
/*==============================================================*/
create table EO7 (
     ID                   numeric                        not null,
     NumeroDocRecepcion   varchar(20)                    not null,
     EstadoDocumento      int                            null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_EO7 primary key (ID)
)
go


/*==============================================================*/
/* Table: ID10                                                  */
/*==============================================================*/
create table ID10 (
     ID                   numeric                        not null,
     Consecutivo          int                            not null,
     TipoItem             char(1)                        not null
           constraint CKC_TIPOITEM_ID10 check (TipoItem in ('A','S','F')),
     CodigoItem           varchar(20)                    not null,
     NombreBarco          varchar(20)                    null,
     FechaHoraCarga       datetime                       null,
     FechaHoraSalida      datetime                       null,
     PrecioUnitario       money                          not null,
     CodigoUnidadMedida   char(5)                        not null,
     CantidadTotal        numeric(18,2)                  not null,
     CantidadNeta         numeric(18,2)                  not null,
     CodEmbarque          varchar(20)                    null,
     NumeroBOL            varchar(20)                    null,
     FechaBOL             datetime                       null,
     TripNo               varchar(20)                    null,
     ContractNo           varchar(20)                    null,
     CodigoImpuesto       char(5)                        null,
     ImporteImpuesto      money                          default 0.00 null,
     ImporteDescuento     money                          default 0.00 null,
     CodigoAlmacen        varchar(20)                    null,
     CodigoDepartamento   varchar(10)                    null,
     CentroFuncional      char(10)                       null,
     CuentaFinancieraDet  char(100)                      null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_ID10 primary key (ID, Consecutivo)
)
go


/*==============================================================*/
/* Table: ID6                                                   */
/*==============================================================*/
create table ID6 (
     ID                   numeric                        not null,
     LineaSolicitud       smallint                       not null,
     TipoBien             char(1)                        default 'A' not null
           constraint CKC_TIPOBIEN_ID6 check (TipoBien in ('A','S')),
     CodigoArticulo       char(15)                       null,
     CodigoAlmacen        char(20)                       null,
     CodigoServicio       char(10)                       null,
     CodigoCategoria      char(10)                       null,
     CodigoClase          char(10)                       null,
     DescripcionBien      varchar(255)                   not null,
     DescripcionAlterna   varchar(1024)                  null,
     CantidadSolicitada   float                          not null,
     CodigoUnidadMedida   char(5)                        not null,
     CodigoImpuesto       char(5)                        not null,
     PrecioUnitario       money                          not null,
     TotalLinea           money                          not null,
     FechaRequerida       datetime                       null,
     Observaciones        varchar(255)                   null,
     CodigoCentroFuncional char(10)                       null,
     CuentaFinanciera     varchar(100)                   null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_ID6 primary key (ID, LineaSolicitud)
)
go


/*==============================================================*/
/* Table: ID7                                                   */
/*==============================================================*/
create table ID7 (
     ID                   numeric                        not null,
     LineaDocRecepcion    integer                        not null,
     NumeroOrdenCompra    numeric                        not null,
     LineaOrdenCompra     integer                        not null,
     CodigoArticulo       char(15)                       null,
     CodigoServicio       char(10)                       null,
     TipoItem             char(1)                        null,
     CantidadRecibida     float                          not null,
     CodigoUnidadMedida   char(5)                        not null,
     PrecioUnitario       money                          not null,
     DescuentoLinea       money                          null,
     TotalLinea           money                          null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_ID7 primary key (ID, LineaDocRecepcion)
)
go


/*==============================================================*/
/* Table: ID8                                                   */
/*==============================================================*/
create table ID8 (
     ID                   numeric                        not null,
     NumeroLinea          integer                        not null,
     TipoMovimiento       char(1)                        not null
           constraint CKC_TIPOMOVIMIENTO_ID8 check (TipoMovimiento in ('R','C','E')),
     CuentaFinanciera     varchar(100)                   not null,
     CodigoOficina        varchar(10)                    not null,
     CodigoMonedaOrigen   char(3)                        not null,
     MontoOrigen          money                          not null,
     TipoCambio           float                          not null,
     Monto                money                          not null,
     NAPreferencia        numeric                        null,
     LINreferencia        integer                        null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_ID8 primary key (ID, NumeroLinea)
)
go


/*==============================================================*/
/* Table: IE1                                                   */
/*==============================================================*/
create table IE1 (
     ID                   numeric                        not null,
     CodigoArticulo       char(15)                       not null,
     DescripcionArticulo  varchar(80)                    not null,
     CodigoUnidadMedida   char(5)                        not null,
     CodigoClasificacion  char(5)                        not null,
     CodigoArticuloAlterno char(20)                       null,
     CodigoMarca          char(10)                       null,
     CodigoModelo         char(10)                       null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE1 check (Imodo in ('A','B','C')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE1 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE10                                                  */
/*==============================================================*/
create table IE10 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     NumeroSocio          varchar(10)                    not null,
     Modulo               char(4)                        not null
           constraint CKC_MODULO_IE10 check (Modulo in ('CC','CP')),
     CodigoTransacion     varchar(5)                     not null,
     Documento            varchar(20)                    not null,
     Estado               varchar(2)                     null,
     CodigoMoneda         char(3)                        not null,
     FechaDocumento       datetime                       not null,
     FechaVencimiento     datetime                       null,
     DiasVencimiento      int                            default 0 not null,
     Facturado            char(1)                        default 'F' not null,
     Origen               char(4)                        not null,
     VoucherNo            varchar(20)                    not null,
     CodigoRetencion      char(2)                        null,
     CodigoOficina        char(10)                       null,
     CuentaFinanciera     char(100)                      null,
     CodigoConceptoServicio char(10)                       null,
     CodigoDireccionEnvio char(10)                       null,
     CodigoDireccionFact  char(10)                       null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE10 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE11                                                  */
/*==============================================================*/
create table IE11 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     TipoCobroPago        char(1)                        not null
           constraint CKC_TIPOCOBROPAGO_IE11 check (TipoCobroPago in ('C','P')),
     CodigoBanco          varchar(20)                    not null,
     CuentaBancaria       varchgar(20)                   not null,
     FechaTransaccion     datetime                       not null,
     TipoPago             char(1)                        not null
           constraint CKC_TIPOPAGO_IE11 check (TipoPago in ('C','T','E','D')),
     NumeroDocumento      char(20)                       not null,
     NumeroSocio          varchar(10)                    not null,
     NumeroSocioDocumento varchar(10)                    not null,
     CodigoTransaccion    varchar(5)                     null,
     Documento            varchar(20)                    not null,
     MontoPago            money                          not null,
     MontoPagoDocumento   money                          not null,
     TipoCambio           float                          not null,
     CodigoMonedaPago     char(3)                        not null,
     CodigoMonedaDoc      char(3)                        null,
     TransaccionOrigen    varchar(20)                    not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE11 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE12                                                  */
/*==============================================================*/
create table IE12 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     ModuloOrigen         char(4)                        not null
           constraint CKC_MODULOORIGEN_IE12 check (ModuloOrigen in ('CC','CP')),
     CodigoMonedaOrigen   char(3)                        not null,
     NumeroSocioDocOrigen varchar(10)                    not null,
     CodigoTransacionOrig varchar(5)                     not null,
     DocumentoOrigen      varchar(20)                    not null,
     MontoOrigen          money                          not null,
     ModuloDestino        char(4)                        not null
           constraint CKC_MODULODESTINO_IE12 check (ModuloDestino in ('CC','CP')),
     CodigoMonedaDestino  char(3)                        not null,
     NumeroSocioDocDestino varchar(10)                    not null,
     CodigoTransacionDest varchar(5)                     not null,
     DocumentoDestino     varchar(20)                    not null,
     MontoDestino         money                          not null,
     TipoCambio           float                          not null,
     FechaAplicacion      datetime                       not null,
     TransaccionOrigen    varchar(20)                    not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE12 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE13                                                  */
/*==============================================================*/
create table IE13 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     ModuloOrigen         char(4)                        not null
           constraint CKC_MODULOORIGEN_IE13 check (ModuloOrigen in ('CC','CP')),
     FechaAplicacion      datetime                       not null,
     NumeroSocio          varchar(10)                    not null,
     CodigoTransaccion    varchar(5)                     not null,
     Documento            varchar(20)                    not null,
     CodigoMoneda         char(3)                        not null,
     MontoEliminado       money                          not null,
     TransaccionOrigen    varchar(20)                    not null,
     Observacion          varchar(100)                   null,
     CodigoTransaccionElim varchar(5)                     null,
     DocumentoEliminacion varchar(20)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE13 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE14                                                  */
/*==============================================================*/
create table IE14 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     CodigoBancoOrigen    varchar(20)                    null,
     CuentaBancariaOrigen varchar(20)                    null,
     TipoMovimientoOrigen char(2)                        null,
     CodigoMonedaOrigen   char(3)                        null,
     MontoOrigen          money                          not null,
     MontoComision        money                          not null,
     CodigoBancoDestino   varchar(20)                    not null,
     CuentaBancariaDestino varchar(20)                    not null,
     TipoMovimientoDestino char(2)                        not null,
     CodigoMonedaDestino  char(3)                        not null,
     MontoDestino         money                          not null,
     FechaValor           datetime                       null,
     Observacion          varchar(100)                   null,
     FechaAplicacion      datetime                       null,
     ConceptoComision     char(5)                        null,
     NumeroDocumento      varchar(20)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE14 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE15                                                  */
/*==============================================================*/
create table IE15 (
     ID                   numeric                        not null,
     CuentaPresupuesto    char(100)                      not null,
     FechaDesde           datetime                       not null,
     FechaHasta           datetime                       null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE15 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE16                                                  */
/*==============================================================*/
create table IE16 (
     ID                   numeric                        not null,
     NumeroLinea          integer                        not null,
     CuentaFinanciera     varchar(100)                   not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE16 primary key (ID, NumeroLinea)
)
go


/*==============================================================*/
/* Table: IE2                                                   */
/*==============================================================*/
create table IE2 (
     ID                   numeric                        not null,
     CodigoClasificacion  char(5)                        not null,
     DescripcionClasificacion varchar(80)                    not null,
     ComisionPorVenta     numeric(5,2)                   not null,
     ComplementoCtaF      varchar(100)                   null,
     CodigoPadre          char(5)                        null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE2 check (Imodo in ('A','B','C')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE2 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE3                                                   */
/*==============================================================*/
create table IE3 (
     ID                   numeric                        not null,
     CodigoCategoria      char(10)                       not null,
     DescripcionCategoria varchar(60)                    not null,
     VidaUtil             int                            not null,
     VidaUtilPorCategoria char(1)                        not null
           constraint CKC_VIDAUTILPORCATEGO_IE3 check (VidaUtilPorCategoria in ('S','N')),
     MetodoDepreciacion   int                            not null,
     MascaraPlaca         char(20)                       not null,
     ComplementoCtaF      varchar(100)                   null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE3 check (Imodo in ('A','B','C')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE3 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE4                                                   */
/*==============================================================*/
create table IE4 (
     ID                   numeric                        not null,
     CodigoCategoria      char(10)                       not null,
     CodigoClase          char(10)                       not null,
     DescripcionClase     varchar(60)                    not null,
     VidaUtil             int                            not null,
     Depreciable          char(1)                        not null
           constraint CKC_DEPRECIABLE_IE4 check (Depreciable in ('S','N')),
     Revaluable           char(1)                        not null
           constraint CKC_REVALUABLE_IE4 check (Revaluable in ('S','N')),
     CtaSuperavit         char(100)                      not null,
     CtaAdquisicion       char(100)                      not null,
     CtaRevaluacion       char(100)                      not null,
     CtaDepreciacionAcumRev char(100)                      not null,
     CtaDepreciacionAcum  char(100)                      not null,
     TipoValorResidual    char(1)                        not null
           constraint CKC_TIPOVALORRESIDUAL_IE4 check (TipoValorResidual in ('M','P')),
     ValorResidual        money                          not null,
     ComplementoCtaF      varchar(100)                   null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE4 check (Imodo in ('A','B','C')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE4 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE5                                                   */
/*==============================================================*/
create table IE5 (
     ID                   numeric                        not null,
     CodigoProveedor      char(10)                       not null,
     NombreProveedor      varchar(255)                   not null,
     NumeroIdentificacion char(30)                       not null,
     TipoPersona          char(1)                        not null
           constraint CKC_TIPOPERSONA_IE5 check (TipoPersona in ('F','J')),
     Telefono             varchar(30)                    null,
     Fax                  varchar(30)                    null,
     Mail                 varchar(100)                   null,
     Direccion            varchar(255)                   null,
     DiasVencimiento      int                            null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE5 check (Imodo in ('A','B','C','D')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE5 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE6                                                   */
/*==============================================================*/
create table IE6 (
     ID                   numeric                        not null,
     TipoSolicitud        char(5)                        not null,
     CodigoCentroFuncional char(10)                       not null,
     CodigoSolicitante    char(10)                       not null,
     CodigoMoneda         char(3)                        not null,
     TipoCambio           float                          not null,
     FechaSolicitud       datetime                       not null,
     NumeroSolicitud      numeric                        null,
     Observaciones        varchar(255)                   null,
     TotalEstimado        money                          null,
     TipoOrdenCompra      char(5)                        null,
     Retencion            char(2)                        null,
     CodigoProveedor      char(10)                       null,
     PlazoCredito         integer                        null,
     PorcentajeAnticipo   numeric(5,2)                   null,
     Imodo                char(1)                        default 'A' not null
           constraint CKC_IMODO_IE6 check (Imodo in ('A','B')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE6 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE7                                                   */
/*==============================================================*/
create table IE7 (
     ID                   numeric                        not null,
     TipoDocumento        char(5)                        not null,
     FechaRecepcion       datetime                       null,
     CodigoProveedor      char(10)                       not null,
     DocumentoReferencia  char(25)                       null,
     FechaDocumento       datetime                       not null,
     CodigoAlmacen        char(20)                       null,
     CodigoCentroFuncional varchar(10)                    null,
     CodigoTransaccion    char(2)                        not null,
     CodigoMoneda         char(5)                        not null,
     TipoCambio           float                          not null,
     TotalDescuento       money                          null,
     TotalImpuestos       money                          null,
     Observaciones        text                           null,
     Periodo              int                            null,
     Mes                  int                            null,
     NumeroDocRecepcion   varchar(20)                    null,
     Imodo                char(1)                        default 'A' null
           constraint CKC_IMODO_IE7 check (Imodo is null or ( Imodo in ('A','B','C') )),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE7 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE8                                                   */
/*==============================================================*/
create table IE8 (
     ID                   numeric                        not null,
     ModuloOrigen         char(4)                        not null,
     NumeroDocumento      varchar(20)                    not null,
     NumeroReferencia     varchar(25)                    not null,
     FechaDocumento       datetime                       not null,
     AnoPresupuesto       int                            not null,
     MesPresupuesto       int                            not null,
     NAPreversado         numeric                        null,
     SoloConsultar        bit                            default 0 not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE8 primary key (ID)
)
go


/*==============================================================*/
/* Table: IE9                                                   */
/*==============================================================*/
create table IE9 (
     ID                   numeric                        not null,
     EcodigoSDC           numeric                        not null,
     Identificacion       char(30)                       not null,
     TipoSocio            char(1)                        not null
           constraint CKC_TIPOSOCIO_IE9 check (TipoSocio in ('C','P','A')),
     Nombre               varchar(255)                   not null,
     Direccion            varchar(255)                   null,
     Telefono             varchar(30)                    null,
     Fax                  varchar(30)                    null,
     Email                varchar(100)                   null,
     MoraloFisica         char(1)                        not null
           constraint CKC_MORALOFISICA_IE9 check (MoraloFisica in ('F','J')),
     Vencimiento_dias_Compras int                            null,
     Vencimiento_dias_Ventas int                            null,
     NumeroSocio          char(10)                       not null,
     CuentaCxC            varchar(100)                   null,
     CuentaCxP            varchar(100)                   null,
     CodigoPaisISO        char(2)                        null,
     CertificadoISO       int                            default 0 null,
     Plazo_Entrega_dias   int                            null,
     Plazo_Credito_dias   int                            null,
     CodigoSocioSistemaOrigen varchar(25)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IE9 primary key (ID)
)
go


/*==============================================================*/
/* Table: IdProceso                                             */
/*==============================================================*/
create table IdProceso (
     IdProceso            numeric                        identity,
     Consecutivo          numeric                        null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_IDPROCESO primary key (IdProceso)
)
lock datarows
with
    identity_gap = 10
go


/*==============================================================*/
/* Table: Interfaz                                              */
/*==============================================================*/
create table Interfaz (
     NumeroInterfaz       integer                        not null,
     Descripcion          varchar(80)                    not null,
     OrigenInterfaz       char(1)                        not null
           constraint CKC_ORIGENINTERFAZ_INTERFAZ check (OrigenInterfaz in ('E','S')),
     TipoProcesamiento    char(1)                        not null
           constraint CKC_TIPOPROCESAMIENTO_INTERFAZ check (TipoProcesamiento in ('A','S')),
     Componente           varchar(80)                    not null,
     Activa               bit                            not null,
     MinutosRetardo       integer                        null,
     ejecutarSpFinal      char(1)                        default 'N' not null
           constraint CKC_EJECUTARSPFINAL_INTERFAZ check (ejecutarSpFinal in ('S','N')),
     FechaActivacion      datetime                       null,
     FechaActividad       datetime                       null,
     NumeroEjecuciones    integer                        null,
     Ejecutando           smallint                       null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_INTERFAZ primary key (NumeroInterfaz)
)
go


/*==============================================================*/
/* Table: InterfazBitacoraProcesos                              */
/*==============================================================*/
create table InterfazBitacoraProcesos (
     IdBitacora           numeric                        identity,
     CEcodigo             numeric                        not null,
     NumeroInterfaz       integer                        not null,
     IdProceso            numeric                        not null,
     SecReproceso         integer                        default 0 not null,
     EcodigoSDC           numeric                        not null,
     OrigenInterfaz       char(1)                        not null
           constraint CKC_ORIGENINTERFAZ_INTERFAZB check (OrigenInterfaz in ('E','S')),
     TipoProcesamiento    char(1)                        not null
           constraint CKC_TIPOPROCESAMIENTO_INTERFAB check (TipoProcesamiento in ('A','S','0')),
     StatusProceso        integer                        not null
           constraint CKC_STATUSPROCESO_INTERFAZ check (StatusProceso in (1,2,3,4,10,11,12,5)),
     FechaInclusion       datetime                       not null,
     UsucodigoInclusion   numeric                        null,
     UsuarioBdInclusion   varchar(32)                    null,
     FechaInicioProceso   datetime                       null,
     FechaFinalProceso    datetime                       null,
     MsgError             varchar(255)                   null,
     MsgErrorStack        text                           null,
     ParametrosSOIN       varchar(255)                   null,
     TipoMovimientoSOIN   varchar(20)                    null,
     UsucodigoCancela     numeric                        null,
     FechaCancelacion     datetime                       null,
     MsgCancelacion       varchar(255)                   null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_INTERFAZBITACORAPROCESOS primary key (IdBitacora)
)
go


/*==============================================================*/
/* Index: Bitacora02                                            */
/*==============================================================*/
create index Bitacora02 on InterfazBitacoraProcesos (
CEcodigo ASC,
NumeroInterfaz ASC,
IdProceso ASC,
SecReproceso ASC
)
go


/*==============================================================*/
/* Index: Bitacora01                                            */
/*==============================================================*/
create index Bitacora01 on InterfazBitacoraProcesos (
CEcodigo ASC,
EcodigoSDC ASC
)
go


/*==============================================================*/
/* Table: InterfazColaProcesos                                  */
/*==============================================================*/
create table InterfazColaProcesos (
     CEcodigo             numeric                        not null,
     NumeroInterfaz       integer                        not null,
     IdProceso            numeric                        not null,
     SecReproceso         integer                        default 0 not null,
     EcodigoSDC           numeric                        not null,
     OrigenInterfaz       char(1)                        not null
           constraint CKC_ORIGENINTERFAZ_INTERFAZC check (OrigenInterfaz in ('E','S')),
     TipoProcesamiento    char(1)                        not null
           constraint CKC_TIPOPROCESAMIENTO_INTERFAC check (TipoProcesamiento in ('A','S')),
     StatusProceso        integer                        not null
           constraint CKC_STATUSPROCESO_INTERFAZ2 check (StatusProceso in (1,2,3,4,10,11,5)),
     FechaInclusion       datetime                       default getdate() not null,
     UsucodigoInclusion   numeric                        null,
     UsuarioBdInclusion   varchar(32)                    null,
     FechaInicioProceso   datetime                       null,
     FechaFinalProceso    datetime                       null,
     MsgError             varchar(255)                   null,
     MsgErrorStack        text                           null,
     ParametrosSOIN       varchar(255)                   null,
     TipoMovimientoSOIN   varchar(20)                    null,
     FechaActivacion      datetime                       null,
     FechaActividad       datetime                       null,
     Cancelar             bit                            default 0 not null,
     UsucodigoCancela     numeric                        null,
     FechaCancelacion     datetime                       null,
     MsgCancelacion       varchar(255)                   null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_INTERFAZCOLAPROCESOS primary key (CEcodigo, NumeroInterfaz, IdProceso, SecReproceso)
)
go


/*==============================================================*/
/* Index: Cola01                                                */
/*==============================================================*/
create index Cola01 on InterfazColaProcesos (
NumeroInterfaz ASC,
EcodigoSDC ASC
)
go


/*==============================================================*/
/* Table: InterfazColaProcesosCancelar                          */
/*==============================================================*/
create table InterfazColaProcesosCancelar (
     CEcodigo             numeric                        not null,
     NumeroInterfaz       integer                        not null,
     IdProceso            numeric                        not null,
     SecReproceso         integer                        default 0 not null,
     UsucodigoCancela     numeric                        null,
     FechaCancelacion     datetime                       null,
     MsgCancelacion       varchar(255)                   null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_INTERFAZCOLAPROCESOSCANCELA primary key (CEcodigo, NumeroInterfaz, IdProceso, SecReproceso)
)
go


/*==============================================================*/
/* Index: Cola01                                                */
/*==============================================================*/
create index Cola01 on InterfazColaProcesosCancelar (
NumeroInterfaz ASC
)
go


/*==============================================================*/
/* Table: InterfazMotor                                         */
/*==============================================================*/
create table InterfazMotor (
     CEcodigo             numeric                        not null,
     Activo               bit                            default 0 not null,
     urlServidorMotor     varchar(255)                   null,
     spFinal              varchar(255)                   null,
     MsgError             varchar(255)                   null,
     FechaActivacion      datetime                       null,
     FechaActividad       datetime                       null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_INTERFAZMOTOR primary key (CEcodigo)
)
go


/*==============================================================*/
/* Table: OD101                                                 */
/*==============================================================*/
create table OD101 (
     ID                   numeric                        not null,
     LineaDocRecepcion    numeric                        not null,
     TipoItem             char(1)                        default 'A' not null
           constraint CKC_TIPOITEM_OD101 check (TipoItem in ('A','S','F')),
     CodigoItem           char(15)                       not null,
     CantidadRecibida     float                          not null,
     PrecioUnitario       money                          not null,
     CodigoUnidadMedida   char(5)                        not null,
     CodigoImpuesto       char(5)                        not null,
     CodigoAlmacen        char(20)                       null,
     NumeroSolicitudCompra numeric                        null,
     LineaSolcitudCompra  integer                        null,
     NumeroOrdenCompra    numeric                        not null,
     LineaOrdenCompra     integer                        not null,
     NAP_OC               numeric                        not null,
     MontoLineaNAP_OC     money                          not null,
     Plazo_OC             integer                        default 0 not null,
     Cantidad_OC          float                          not null,
     CantidadReclamada    float                          null,
     CodigoUnidadMedida_OC char(5)                        not null,
     CuentaFinanciera_OC  char(100)                      null,
     PorcentajeImpuesto   float                          not null,
     PorcentajeImpuestoRecuperable float                          not null,
     PorcentajeImpuesto_OC float                          null,
     PorcentajeImpuestoRec_OC float                          null,
     Precio_reclamo       money                          null,
     CuentaFinanciera_Transito char(100)                      null,
     PorcentajeDescuento_OC float                          null,
     PorcentajeDescuento_Doc float                          null,
     CantidadExcedida     float                          null,
     MontoSeguros         money                          null,
     MontoImpuestos       money                          null,
     MontoDiferenciaImpuestos money                          null,
     CMSid                numeric                        null,
     PorcentajeDiferenciaImpuestos float                          null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OD101 primary key (ID, LineaDocRecepcion)
)
go


/*==============================================================*/
/* Table: OD102                                                 */
/*==============================================================*/
create table OD102 (
     ID                   numeric                        not null,
     LineaDocTransaccion  numeric                        not null,
     SecDistribucionLinea integer                        default 1 not null,
     TipoItem             char(1)                        default 'A' not null
           constraint CKC_TIPOITEM_OD102 check (TipoItem in ('A','S','F')),
     CodigoItem           char(15)                       null,
     Cantidad             float                          not null,
     PrecioUnitario       money                          not null,
     CodigoUnidadMedida   char(5)                        null,
     CodigoImpuesto       char(5)                        null,
     CodigoAlmacen        char(20)                       null,
     NumeroSolicitudCompra numeric                        null,
     LineaSolcitudCompra  integer                        null,
     NumeroOrdenCompra    numeric                        null,
     LineaOrdenCompra     integer                        null,
     NAP_OC               numeric                        null,
     MontoLineaNAP_OC     money                          null,
     Plazo_OC             integer                        default 0 null,
     Cantidad_OC          float                          null,
     CodigoUnidadMedida_OC char(5)                        null,
     CuentaFinanciera_OC  char(100)                      null,
     PorcentajeImpuesto   float                          null,
     PorcentajeImpuestoRecuperable float                          null,
     CuentaFinanciera_Transito char(100)                      null,
     CantidadReclamada    float                          null,
     PrecioFactura        money                          null,
     PorcentajeDescuento_OC float                          null,
     PorcentajeDescuento_Doc float                          null,
     MontoDistribuido     money                          null,
     CantidadExcedida     float                          null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OD102 primary key (ID, LineaDocTransaccion, SecDistribucionLinea)
)
go


/*==============================================================*/
/* Table: OD103                                                 */
/*==============================================================*/
create table OD103 (
     ID                   numeric                        not null,
     LineaDocDevolucion   numeric                        not null,
     TipoItem             char(1)                        default 'A' not null
           constraint CKC_TIPOITEM_OD103 check (TipoItem in ('A','S','F')),
     CodigoItem           char(15)                       not null,
     CantidadDevuelta     float                          not null,
     PrecioUnitario       money                          not null,
     CodigoUnidadMedida   char(5)                        not null,
     CodigoImpuesto       char(5)                        not null,
     CodigoAlmacen        char(20)                       null,
     NumeroSolicitudCompra numeric                        null,
     LineaSolcitudCompra  integer                        null,
     NumeroOrdenCompra    numeric                        not null,
     LineaOrdenCompra     integer                        not null,
     NAP_OC               numeric                        not null,
     MontoLineaNAP_OC     money                          not null,
     Plazo_OC             integer                        default 0 not null,
     Cantidad_OC          float                          not null,
     CodigoUnidadMedida_OC char(5)                        not null,
     CuentaFinanciera_OC  char(100)                      null,
     PorcentajeImpuesto   float                          not null,
     PorcentajeImpuestoRecuperable float                          not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OD103 primary key (ID, LineaDocDevolucion)
)
go


/*==============================================================*/
/* Table: OD8                                                   */
/*==============================================================*/
create table OD8 (
     ID                   numeric                        not null,
     NumeroLinea          integer                        not null,
     AnoPresupuesto       int                            not null,
     MesPresupuesto       int                            not null,
     CuentaPresupuesto    varchar(100)                   not null,
     CodigoOficina        varchar(10)                    not null,
     TipoControl          tinyint                        not null,
     CalculoControl       tinyint                        not null,
     TipoMovimiento       char(2)                        not null
           constraint CKC_TIPOMOVIMIENTO_OD8 check (TipoMovimiento in ('RC','CC','E')),
     SignoMovimiento      smallint                       not null,
     MontoMovimiento      money                          not null,
     DisponibleAnterior   money                          not null,
     DisponibleGenerado   money                          not null,
     ExcesoGenerado       money                          not null,
     ProvocoRechazo       bit                            default 0 not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OD8 primary key (ID, NumeroLinea)
)
go


/*==============================================================*/
/* Table: OE101                                                 */
/*==============================================================*/
create table OE101 (
     ID                   numeric                        not null,
     NumeroDocRecepcion   varchar(20)                    not null,
     FechaRecepcion       datetime                       not null,
     FechaDocumento       datetime                       not null,
     CodigoProveedor      char(10)                       not null,
     TipoDocumentoCXP     char(2)                        null,
     CodigoMoneda         char(5)                        not null,
     TipoCambio           float                          not null,
     DescuentoDoc         money                          default 0.00 not null,
     ImpuestoDoc          money                          default 0.00 not null,
     Observaciones        text                           null,
     PlazoOC              integer                        null,
     NumeroEmbarque       varchar(20)                    null,
     NumeroPolizaDes      varchar(20)                    null,
     Modo                 char(1)                        default 'R' not null
           constraint CKC_MODO_OE101 check (Modo in ('R')),
     NoAsiento            varchar(20)                    null,
     LoginUsuario         varchar(30)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE101 primary key (ID)
)
go


/*==============================================================*/
/* Table: OE102                                                 */
/*==============================================================*/
create table OE102 (
     ID                   numeric                        not null,
     NumeroDocTransaccion varchar(20)                    not null,
     FechaTransaccion     datetime                       not null,
     FechaDocumento       datetime                       not null,
     CodigoProveedor      char(10)                       not null,
     TipoDocumentoCXP     char(2)                        null,
     CodigoMoneda         char(5)                        not null,
     TipoCambio           float                          not null,
     DescuentoDoc         money                          default 0.00 not null,
     ImpuestoDoc          money                          default 0.00 not null,
     Observaciones        text                           null,
     PlazoOC              integer                        null,
     NumeroEmbarque       varchar(20)                    null,
     NumeroPolizaDes      varchar(20)                    null,
     Modo                 char(1)                        default 'R' not null
           constraint CKC_MODO_OE102 check (Modo in ('R','C')),
     LoginUsuario         varchar(30)                    null,
     TipoCambioRegistro   float                          null,
     NoAsiento            varchar(20)                    null,
     NumeroDocRef         varchar(20)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE102 primary key (ID)
)
go


/*==============================================================*/
/* Table: OE103                                                 */
/*==============================================================*/
create table OE103 (
     ID                   numeric                        not null,
     NumeroDocDevolucion  varchar(20)                    not null,
     FechaDevolucion      datetime                       not null,
     FechaDocumento       datetime                       not null,
     CodigoProveedor      char(10)                       not null,
     TipoDocumentoCXP     char(2)                        null,
     CodigoMoneda         char(5)                        not null,
     TipoCambio           float                          not null,
     DescuentoDoc         money                          default 0.00 not null,
     ImpuestoDoc          money                          default 0.00 not null,
     Observaciones        text                           null,
     PlazoOC              integer                        null,
     NumeroEmbarque       varchar(20)                    null,
     NumeroPolizaDes      varchar(20)                    null,
     Modo                 char(1)                        default 'R' not null
           constraint CKC_MODO_OE103 check (Modo in ('R')),
     LoginUsuario         varchar(30)                    null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE103 primary key (ID)
)
go


/*==============================================================*/
/* Table: OE110                                                 */
/*==============================================================*/
create table OE110 (
     ID                   numeric                        not null,
     contraparte_id       int                            null,
     compania_prop_id     int                            null,
     concepto_id          int                            null,
     llave_soin_tbs       numeric                        null,
     fecha_vencimiento    datetime                       null,
     monto                money                          null,
     iva                  money                          null,
     retencion            money                          null,
     pago_cobro           char(1)                        null
           constraint CKC_PAGO_COBRO_OE110 check (pago_cobro is null or ( pago_cobro in ('P','R') )),
     aux_origen           char(2)                        null
           constraint CKC_AUX_ORIGEN_OE110 check (aux_origen is null or ( aux_origen in ('CC','CP') )),
     tipo_documento       char(2)                        null,
     usuario_creacion     char(3)                        null,
     moneda               varchar(8)                     null,
     documento            varchar(20)                    null,
     nombre_largo         varchar(40)                    null,
     comentarios          text                           null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE110 primary key (ID)
)
go


/*==============================================================*/
/* Table: OE16                                                  */
/*==============================================================*/
create table OE16 (
     ID                   numeric                        not null,
     NumeroLinea          integer                        not null,
     CuentaFinanciera     varchar(100)                   not null,
     Resultado            tinyint                        not null
           constraint CKC_RESULTADO_OE16 check (Resultado in (1,2,3)),
     MSG                  varchar(255)                   not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE16 primary key (ID, NumeroLinea)
)
go


/*==============================================================*/
/* Table: OE6                                                   */
/*==============================================================*/
create table OE6 (
     ID                   numeric                        not null,
     NumeroSolicitud      numeric                        null,
     NAP                  numeric                        null,
     NRP                  numeric                        null,
     NAPcancelacion       numeric                        null,
     EstadoResultante     char(1)                        default 'R' not null
           constraint CKC_ESTADORESULTANTE_OE6 check (EstadoResultante in ('A','R','C')),
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE6 primary key (ID)
)
go


/*==============================================================*/
/* Table: OE8                                                   */
/*==============================================================*/
create table OE8 (
     ID                   numeric                        not null,
     NAP                  numeric                        not null,
     NRP                  numeric                        not null,
     MSG                  varchar(255)                   not null,
     BMUsucodigo          numeric                        null,
     ts_rversion          timestamp                      null,
     constraint PK_OE8 primary key (ID)
)
go


alter table ID10
   add constraint FK_ID10_REFERENCE_IE10 foreign key (ID)
      references IE10 (ID)
go


alter table ID6
   add constraint FK_ID6_REFERENCE_IE6 foreign key (ID)
      references IE6 (ID)
go


alter table ID7
   add constraint FK_ID7_REFERENCE_IE7 foreign key (ID)
      references IE7 (ID)
go


alter table ID8
   add constraint FK_ID8_REFERENCE_IE8 foreign key (ID)
      references IE8 (ID)
go


alter table InterfazColaProcesos
   add constraint FK_INTERFAZ_REF_COLA__INTERFAZ foreign key (NumeroInterfaz)
      references Interfaz (NumeroInterfaz)
go


alter table InterfazColaProcesosCancelar
   add constraint FK_INTERFAZ_REFERENCE_INTERFAZ foreign key (CEcodigo, NumeroInterfaz, IdProceso, SecReproceso)
      references InterfazColaProcesos (CEcodigo, NumeroInterfaz, IdProceso, SecReproceso)
go


alter table OD101
   add constraint FK_OD101_REFERENCE_OE101 foreign key (ID)
      references OE101 (ID)
go


alter table OD102
   add constraint FK_OD102_REFERENCE_OE102 foreign key (ID)
      references OE102 (ID)
go


alter table OD103
   add constraint FK_OD103_REFERENCE_OE103 foreign key (ID)
      references OE103 (ID)
go


alter table OD8
   add constraint FK_OD8_REFERENCE_OE8 foreign key (ID)
      references OE8 (ID)
go


if exists (select 1
          from sysobjects
          where id = object_id('S_IdProceso_Nextval')
          and type = 'P')
   drop procedure S_IdProceso_Nextval
go



create procedure S_IdProceso_Nextval
@nextval numeric = 0 output
as
begin
    begin tran
        insert into IdProceso
            (Consecutivo)
        values (0)
        select @nextval = @@identity
        delete from IdProceso
         where IdProceso = @nextval
        select @nextval AS ID
    commit tran
end
go


