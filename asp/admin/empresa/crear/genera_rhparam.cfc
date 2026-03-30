<cfcomponent>
<!--- Parametrizar RH --->
<cffunction name="copiar" output="false" returntype="void">
	<cfargument name="dsori" type="string" hint="datasource origen">
	<cfargument name="dsdst" type="string" hint="datasource destino">
	<cfargument name="Eori" type="numeric" hint="Ereferencia(Ecodigo int) origen">
	<cfargument name="Edst" type="numeric" hint="Ereferencia(Ecodigo int) destino">
	<cfargument name="CEdst" type="numeric" hint="CEcodigo destino">
<!---
/* Script aplica para empresa de Costa Rica        */
/* las tablas listadas a continuación corresponde  */
/* a las que deberían ser copiadas a las otras     */
/* Servidor: 10.7.7.241,5000                       */
/* base de datos:  aspweb                          */
/* Ecodigo origen: <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
--->
<!--- Este script asume que ambos estan en el mismo servidor y son sybase o mssqlserver --->
<cfset dbori = Application.dsinfo[dsori].schema & '.'>

<cfquery datasource="#dsdst#">
insert into RHJornadas (
	Ecodigo, RHJcodigo, RHJdescripcion, RHJsun, RHJmon, RHJtue,
	RHJwed, RHJthu, RHJfri, RHJsat, RHJhoraini, RHJhorafin,
	RHJhorainicom, RHJhorafincom, RHJhoradiaria, RHJmarcar, BMUsucodigo, RHJhorasemanal,
	RHJdiassemanal, RHJornadahora, RHJtipo, RHJjsemanal, RHJdiaini, RHJfraccionesExtras,
	RHJminutosExtras, RHJincAusencia, RHJincHJornada, RHJincExtraA, RHJincExtraB, RHJincFeriados,
	RHJhorasJornada, RHJhorasExtraA, RHJhorasExtraB, RHJrebajaocio)
select 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, RHJcodigo, RHJdescripcion, RHJsun, RHJmon, RHJtue,
	RHJwed, RHJthu, RHJfri, RHJsat, RHJhoraini, RHJhorafin,
	RHJhorainicom, RHJhorafincom, RHJhoradiaria, RHJmarcar, BMUsucodigo, RHJhorasemanal,
	RHJdiassemanal, RHJornadahora, RHJtipo, RHJjsemanal, RHJdiaini, RHJfraccionesExtras,
	RHJminutosExtras, RHJincAusencia, RHJincHJornada, RHJincExtraA, RHJincExtraB, RHJincFeriados,
	RHJhorasJornada, RHJhorasExtraA, RHJhorasExtraB, RHJrebajaocio
from #dbori#.RHJornadas
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into RegimenVacaciones (
	Ecodigo, RVcodigo, Descripcion, RVfecha,
	Usucodigo, Ulocalizacion, BMUsucodigo)
select 
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, RVcodigo, Descripcion, RVfecha,
	Usucodigo, Ulocalizacion, BMUsucodigo
from #dbori#.RegimenVacaciones
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into DRegimenVacaciones (
	RVid, DRVcant, DRVdias, Usucodigo, Ulocalizacion,
	DRcantcomp, DRVdiasenf, DRVdiasadic, BMUsucodigo, DRVdiasvericomp)
select
	c.RVid, a.DRVcant, a.DRVdias, a.Usucodigo, a.Ulocalizacion,
	a.DRcantcomp, a.DRVdiasenf, a.DRVdiasadic, a.BMUsucodigo, a.DRVdiasvericomp
from #dbori#.DRegimenVacaciones a
	join #dbori#.RegimenVacaciones b
		on b.RVid = a.RVid
	join RegimenVacaciones c
		on b.RVcodigo = c.RVcodigo
		and b.Descripcion = c.Descripcion
		and b.RVfecha = c.RVfecha
where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into RHConfigReportePuestos (
	Ecodigo, CRPohabilidad, CRPoconocim, CRPomision, CRPoobj, CRPoespecif,
	CRPoencab, CRPoubicacion, BMusuario, BMfecha, BMusumod, BMfechamod,
	CRPeini, CRPehabilidad, CRPeconocim, CRPemision, CRPeobjetivo, CRPeespecif,
	CRPeencab, CRPeubicacion, CRPihabilidad, CRPiconocimi, CRPimision, CRPiobj,
	CRPiespecif, CRPiencab, CRPiubicacion, BMUsucodigo, CRPepie, CRPipie)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, CRPohabilidad, CRPoconocim, CRPomision, CRPoobj, CRPoespecif,
	CRPoencab, CRPoubicacion, BMusuario, BMfecha, BMusumod, BMfechamod,
	CRPeini, CRPehabilidad, CRPeconocim, CRPemision, CRPeobjetivo, CRPeespecif,
	CRPeencab, CRPeubicacion, CRPihabilidad, CRPiconocimi, CRPimision, CRPiobj,
	CRPiespecif, CRPiencab, CRPiubicacion, BMUsucodigo, CRPepie, CRPipie
from #dbori#.RHConfigReportePuestos
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into RHTPuestos (
	Ecodigo, RHTPcodigo, RHTPdescripcion, BMusuario, BMfecha, 
	BMusumod, BMfechamod, RHTinfo, BMUsucodigo)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, RHTPcodigo, RHTPdescripcion, BMusuario, BMfecha, 
	BMusumod, BMfechamod, RHTinfo, BMUsucodigo
from #dbori#.RHTPuestos
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into RHPuestosExternos (
	Ecodigo, RHPEcodigo, RHPEdescripcion, BMUsucodigo)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	RHPEcodigo, RHPEdescripcion, BMUsucodigo
from #dbori#.RHPuestosExternos
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
<!--- CIncidentes con CIcuentac = null --->
insert into CIncidentes (
	Ecodigo, CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo,
	CIcantmin, CIcantmax, Usucodigo, Ulocalizacion, CInorealizado, CInorenta,
	CInocargas, CInodeducciones, CIvacaciones, CIredondeo, CIafectasalprom,
	CInocargasley, CIafectacomision, CItipoexencion, CIexencion, Mcodigo, monedasel,
	BMUsucodigo, CSid, Ccuenta, Cformato)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo,
	CIcantmin, CIcantmax, Usucodigo, Ulocalizacion, CInorealizado, CInorenta,
	CInocargas, CInodeducciones, CIvacaciones, CIredondeo, CIafectasalprom,
	CInocargasley, CIafectacomision, CItipoexencion, CIexencion,
		(select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">), monedasel,
	BMUsucodigo, CSid, Ccuenta, Cformato
from #dbori#.CIncidentes
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into CIncidentesD (
	CIid, CIcantidad, CItipo, CIcalculo, CIdia, CImes, BMUsucodigo, CIrango)
select
	c.CIid, a.CIcantidad, a.CItipo, a.CIcalculo, a.CIdia, a.CImes, a.BMUsucodigo, a.CIrango
from #dbori#.CIncidentesD a
	join #dbori#.CIncidentes b
		on b.CIid = a.CIid
	join CIncidentes c
		on b.CIcodigo = c.CIcodigo
		and b.CIdescripcion = c.CIdescripcion
		and b.CIfactor = c.CIfactor
		and b.CItipo = c.CItipo
where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into TDeduccion (
	Ecodigo, TDcodigo, TDdescripcion, Usucodigo, Ulocalizacion, TDfecha,
	TDobligatoria, TDprioridad, TDparcial, TDordmonto, TDordfecha, BMUsucodigo,
	TDfinanciada, Ccuenta, CFcuenta, cuentaint, CFcuentaint, TDesrenta,
	SNcodigo, Mcodigo, monedasel)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	TDcodigo, TDdescripcion, Usucodigo, Ulocalizacion, TDfecha,
	TDobligatoria, TDprioridad, TDparcial, TDordmonto, TDordfecha, BMUsucodigo,
	TDfinanciada, Ccuenta, CFcuenta, cuentaint, CFcuentaint, TDesrenta,
	null as SNcodigo,
	case when Mcodigo is null then null else (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">) end,
	monedasel
from #dbori#.TDeduccion
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into ECargas (
	Ecodigo, ECcodigo, ECdescripcion, Usucodigo, Ulocalizacion, ECfecha, ECauto, BMUsucodigo, ECprioridad)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	ECcodigo, ECdescripcion, Usucodigo, Ulocalizacion, ECfecha, ECauto, BMUsucodigo, ECprioridad
from #dbori#.ECargas
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<cfquery datasource="#dsdst#">
insert into DCargas(
	ECid, Ecodigo, SNcodigo, DCcodigo, DCmetodo, DCdescripcion,
	DCvaloremp, DCvalorpat, DCprovision, DCnorenta, DCtipo, SNreferencia,
	DCcuentac, DCtiporango, DCrangomin, DCrangomax, Mcodigo, monedasel, BMUsucodigo)
select
	ecD.ECid,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	null as SNcodigo, dcO.DCcodigo, dcO.DCmetodo, dcO.DCdescripcion,
	dcO.DCvaloremp, dcO.DCvalorpat, dcO.DCprovision, dcO.DCnorenta, dcO.DCtipo, dcO.SNreferencia,
	dcO.DCcuentac, dcO.DCtiporango, dcO.DCrangomin, dcO.DCrangomax,
	case when Mcodigo is null then null else (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">) end,
	dcO.monedasel, dcO.BMUsucodigo
from #dbori#.DCargas dcO
	join ECargas ecD
		on  ecD.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
	join #dbori#.ECargas ecO
		on  ecO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
		and ecO.ECcodigo = ecD.ECcodigo
where dcO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
  and ecO.ECid = dcO.ECid
</cfquery>

<!---RHTipoAccion --->
<cfquery datasource="#dsdst#">
insert into RHTipoAccion 
(Ecodigo, RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, RHTpmax, RHTcomportam, RHTposterior, RHTautogestion, RHTindefinido, RHTcempresa, RHTctiponomina, RHTcregimenv, RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, RHTccomp, RHTcsalariofijo, RHTccatpaso, RHTvisible, RHTcjornada, RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, RHTnoretroactiva, RHTcuentac,
CIncidente1,
CIncidente2,
RHTcantdiascont, RHTnocargasley, RHTliquidatotal)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	RHTcodigo, RHTdesc, RHTpaga, RHTpfijo, RHTpmax, RHTcomportam, RHTposterior, RHTautogestion, RHTindefinido, RHTcempresa, RHTctiponomina, RHTcregimenv, RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, RHTccomp, RHTcsalariofijo, RHTccatpaso, RHTvisible, RHTcjornada, RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, RHTnoretroactiva, '0010',
	CIncidente1 = (select a.CIid from CIncidentes a, #dbori#.CIncidentes b where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#"> and a.CIcodigo = b.CIcodigo and b.CIid = acc.CIncidente1),
	CIncidente2 = (select a.CIid from CIncidentes a, #dbori#.CIncidentes b where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#"> and a.CIcodigo = b.CIcodigo and b.CIid = acc.CIncidente2),
	RHTcantdiascont, RHTnocargasley, RHTliquidatotal
from #dbori#.RHTipoAccion acc
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<!---ConceptosTipoAccion--->
<cfquery datasource="#dsdst#">
insert into ConceptosTipoAccion 
	(CIid, RHTid, Usucodigo, Ulocalizacion, CTAsalario)
select
	CIid  = (select a.CIid from CIncidentes a, #dbori#.CIncidentes b where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#"> and a.CIcodigo = b.CIcodigo and b.CIid = cta.CIid),
	RHTid = (select a.RHTid from RHTipoAccion a, #dbori#.RHTipoAccion b where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#"> and a.RHTcodigo = b.RHTcodigo and b.RHTid = cta.RHTid),
	1,         Ulocalizacion, CTAsalario
from #dbori#.ConceptosTipoAccion cta, #dbori#.RHTipoAccion z
where z.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
  and z.RHTid = cta.RHTid
</cfquery>
<!---RHComponentesAgrupados--->
<cfquery datasource="#dsdst#">
insert into RHComponentesAgrupados 
(Ecodigo, RHCAcodigo, RHCAdescripcion, RHCAmComponenteExclu, RHCAorden, BMUsucodigo)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	RHCAcodigo, RHCAdescripcion, RHCAmComponenteExclu, RHCAorden, BMUsucodigo
from #dbori#.RHComponentesAgrupados
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
</cfquery>
<!---ComponentesSalariales--->
<cfquery datasource="#dsdst#">
insert into ComponentesSalariales
	(Ecodigo, CAid, CScodigo, CSdescripcion, CSusatabla, CSsalariobase, CIid, BMUsucodigo,
	CScomplemento, CSorden, CSpagohora, CSpagodia)
select
	<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,
	c.RHCAid, a.CScodigo, a.CSdescripcion, a.CSusatabla, a.CSsalariobase, a.CIid, a.BMUsucodigo,
	a.CScomplemento, a.CSorden, a.CSpagohora, a.CSpagodia
from #dbori#.ComponentesSalariales a
	join #dbori#.RHComponentesAgrupados b
		on b.RHCAid = a.CAid
	join RHComponentesAgrupados c
		on b.RHCAcodigo = c.RHCAcodigo
where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Eori#">
  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">
</cfquery>
<!---TiposNomina--->
<cfquery datasource="#dsdst#">
INSERT INTO TiposNomina
( Ecodigo, Tcodigo, Mcodigo, Tdescripcion, Ttipopago ) 
select
  <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'SE',    (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">), 'Semanal',    0

INSERT INTO TiposNomina
( Ecodigo, Tcodigo, Mcodigo, Tdescripcion, Ttipopago ) 
select
  <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'BI',    (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">), 'Bisemanal',  1

INSERT INTO TiposNomina
( Ecodigo, Tcodigo, Mcodigo, Tdescripcion, Ttipopago ) 
select
  <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'QU',    (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">), 'Quincenal',  2

INSERT INTO TiposNomina
( Ecodigo, Tcodigo, Mcodigo, Tdescripcion, Ttipopago ) 
select
  <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">,     'ME',    (select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">), 'Mensual',    3

</cfquery>
<cfquery datasource="#dsdst#">
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 5)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 5, 'Parametrización ya Definida', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 7)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 7, 'Configuración de Pago de Nómina', '1')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 20)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 20, 'Interfaz con Contabilidad', '1')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 25)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 25, 'Asiento Contable Unificado', '1')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 30)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 30, 'Tabla de Impuesto de Renta',  'IRCRC')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 40)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 40, 'Cantidad de días máximo para Tipo de Pago Semanal', '7')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 50)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 50, 'Cantidad de días máximo para Tipo de Pago Bisemanal', '14')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 60)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 60, 'Cantidad de días máximo para Tipo de Pago Quincenal', '15')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 70)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 70, 'Cantidad de días máximo para Tipo de Pago Mensual', '30')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 80)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 80, 'Cantidad de días para Cálculo de Nómina Mensual', '26')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 90)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 90, 'Indicador de Días de No Pago por Tipo de Nómina', 'N')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 110)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 110, 'Redondeo a Monto', '0.00')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 120)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 120, 'Tipo de Redondeo', '2')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 130)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 130, 'Salario mínimo mensual', '0.00')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 140)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) select  <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 140, 'Cuenta Contable de Renta', convert(varchar,(select min(Ccuenta) from CContables where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Cformato = '2000-01-0004'))
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 150)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 150, 'Cuenta Contable de Pagos no Realizados', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 160)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 160, 'Cantidad de Periodos para Calculo Salario Promedio', '12')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 161)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 161, 'Tipo de periodo', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 170)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 170, 'Enviar Correo de Boleta de Pago al Administrador', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 180)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 180, 'Usuario Administrador',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 190)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 190, 'Cuenta de Correo (DE:) en boleta de Pago', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 200)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 200, 'Numero de Planilla', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 210)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 210, 'Consecutivo de Archivo de Planilla', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 250)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 250, 'Aplica Renta por Tipo Empleado', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 255)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 255, 'Tipo de Cálculo de Renta',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 260)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 260, 'Días antes para asignar Vacaciones', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 270)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 270, 'Procesa Días de Enfermedad', 'N')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 280)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 280, 'Fecha de última corrida del proceso de asignación de Vacaciones', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 300)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 300, 'Número Patronal para reporte Seguro Social', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 310)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 310, 'Script de exportación del Seguro Social', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 320)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 320, 'Script de exportación del Instituto Nacional de Seguros', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 330)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 330, 'Calcular comisiones con salario base', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 340)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 340, 'Incidencia para rebajo de salario por calculo de comisiones',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 350)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 350, 'Incidencia para salario base',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 360)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 360, 'Incidencia para ajuste de salario base',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 370)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 370, 'Script de importación de Comisiones',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 380)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 380, 'Incidencia por Salarios Recibidos',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 390)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 390, 'Script de exportación de registro de Pago de Nómina',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 400)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 400, 'Requerir Centro Funcional de Contrabilización', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 410)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 410, 'Sucursal Adscrita CCSS',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 420)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 420, 'Número de Póliza del INS',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 430)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 430, 'Fecha de Corte en Cálculo de Cesantía (Boleta)', null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 450)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 450, 'Activar Benziger', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 460)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 460, 'Acción de Nombramiento para Reclutamiento y Selección',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 470)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 470, 'Acción de Cambio para Reclutamiento y Selección',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 480)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 480, 'Autorización de Marcas', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 490)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 490, 'Contabilización de Gastos por Mes', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 500)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 500, 'Cuenta de Pasivo para Contabilización de Gastos por Mes',  null)
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 520)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 520, 'CentroCostos equivale a Centro Funcional', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 530)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 530, 'Sincroniza Componentes Salariales con Conceptos de Pago', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 540)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 540, 'Validar Planilla Presupuestaria', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 550)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 550, 'Mostrar Desgloce de Incidencias en Boleta de Pago', '0')
if not exists(select 1 from RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#"> and Pcodigo = 560)     insert RHParametros(Ecodigo, Pcodigo, Pdescripcion, Pvalor) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Edst#">, 560, 'Permite modificar Datos de Empleado en Autogestión', '0')
</cfquery>

</cffunction>
</cfcomponent>