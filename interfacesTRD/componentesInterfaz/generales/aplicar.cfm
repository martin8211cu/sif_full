<!---
	danim, 12-Mar-2007
	Copia los registros de PMIINT_IE10/PMIINT_ID10 a IE10/ID10
--->

<cfquery datasource="sifinterfaces">


declare
	@lastID numeric (18),
	@lastID_IE10 numeric (18),
	@maxID numeric(18)

begin tran

<!--- Genera el ID del Encabezado y Detalle --->
select @maxID = coalesce (max(ID), 0)
from PMIINT_IE10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">

select @lastID = Consecutivo
from IdProceso holdlock

select @lastID_IE10 = coalesce (max(ID), 0)
from IE10

if @lastID is null
	select @lastID = 0

if @lastID_IE10 is not null and @lastID_IE10 > @lastID
	select @lastID = @lastID_IE10

update IdProceso set Consecutivo = Consecutivo + @maxID

<!--- Inserta encabezados en IE10, ajustando el ID al IdProceso.Consecutivo --->
insert into IE10 (ID, BMUsucodigo, 
EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion, CodigoOficina, CuentaFinanciera, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, FechaTipoCambio, StatusProceso)

select
ID + @lastID, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
EcodigoSDC, NumeroSocio, Modulo, CodigoTransacion, Documento, Estado, CodigoMoneda, FechaDocumento, FechaVencimiento, Facturado, Origen, VoucherNo, CodigoConceptoServicio, CodigoRetencion, CodigoOficina, CuentaFinanciera, DiasVencimiento, CodigoDireccionEnvio, CodigoDireccionFact, FechaTipoCambio, StatusProceso

from PMIINT_IE10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
  and MensajeError is null

<!--- Inserta detalles en ID10, ajustando el ID al IdProceso.Consecutivo --->
insert into ID10 (ID, BMUsucodigo, 
Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraSalida, PrecioUnitario, CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, CodigoDepartamento, PrecioTotal, CentroFuncional, CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra,
OCconceptoIngreso,factor)

select
ID + @lastID, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
Consecutivo, TipoItem, CodigoItem, NombreBarco, FechaHoraSalida, coalesce (calculado, PrecioUnitario), CodigoUnidadMedida, CantidadTotal, CantidadNeta, CodEmbarque, NumeroBOL, FechaBOL, TripNo, ContractNo, CodigoImpuesto, ImporteImpuesto, ImporteDescuento, CodigoAlmacen, CodigoDepartamento, coalesce (calculado, PrecioTotal), CentroFuncional, CuentaFinancieraDet, OCtransporteTipo, OCtransporte, OCcontrato, OCconceptoCompra,
OCconceptoIngreso,factor

from PMIINT_ID10 a
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
  and not exists (select 1 from PMIINT_IE10 b 
  					where b.sessionid = a.sessionid
  					and   b.FechaRegistro = a.FechaRegistro
					and   b.ID = a.ID
					and   b.MensajeError is not null)

<!--- Inserta en InterfazColaProcesos, ajustando el ID al IdProceso.Consecutivo --->
insert into InterfazColaProcesos (
	CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
	EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
	FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
	 
select
  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
  10 as NumeroInterfaz,
  ID + @lastID,
  0 as SecReproceso,
  
  EcodigoSDC,
  'E' as OrigenInterfaz,
  'A' as TipoProcesamiento,
  1 as StatusProceso,
  
  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
  0 as Cancelar

from PMIINT_IE10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
  and MensajeError is null

<!--- Rollback de interfaz --->
<!--- rollback   --->
commit

<!--- Borrar datos temporales --->
delete
from PMIINT_ID10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
   or FechaRegistro < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -1, Now())#">

delete
from PMIINT_IE10
where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
  and FechaRegistro = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
   or FechaRegistro < <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', -1, Now())#">

</cfquery>

<cflocation url="index.cfm?botonsel=btnTerminado">