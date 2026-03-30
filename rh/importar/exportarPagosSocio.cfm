<cfquery  name="ERR" datasource="#session.DSN#">
	<!--- Deducciones --->
	select  'Deduccion' as concepto,
			'' as tipo_carga,
			rtrim(TDcodigo) #_Cat#' - ' #_Cat# td.TDdescripcion as concepto, 
			dae.DEidentificacion as id, 
			dae.DEapellido1 #_Cat#' ' #_Cat# dae.DEapellido2 #_Cat#' ' #_Cat# dae.DEnombre as nombre , 
			a.DCvalor as monto
	from DeduccionesCalculo a, DeduccionesEmpleado de, TDeduccion td, SNegocios sn, DatosEmpleado dae, CalendarioPagos cp
	where cp.CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.planilla#">
	and cp.CPid = a.RCNid
	and de.DEid=a.DEid
	and de.Did=a.Did
	and td.TDid = de.TDid
	and sn.SNcodigo = de.SNcodigo
	and sn.Ecodigo = de.Ecodigo
	and dae.DEid = a.DEid
    and sn.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#"> 
	and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	
	union
	
	<!--- cargas sociales --->
	select  'Carga Social' as tipo,
			case when a.CCvaloremp = 0 or a.CCvaloremp is null then 'Patrono' else 'Empleado' end as tipo_carga,  
			rtrim(c.DCcodigo) #_Cat#' - ' #_Cat# c.DCdescripcion as concepto, 
			de.DEidentificacion as id, 
			de.DEapellido1 #_Cat#' ' #_Cat# de.DEapellido2 #_Cat#' ' #_Cat# de.DEnombre as nombre,
			case when a.CCvaloremp = 0 or a.CCvaloremp is null then a.CCvalorpat else a.CCvaloremp end as monto
	from CargasCalculo a, CargasEmpleado ce, DCargas c, SNegocios sn, DatosEmpleado de, CalendarioPagos cp
	where cp.CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.planilla#">
	 and cp.CPid = a.RCNid
	 and ce.DClinea = a.DClinea 
	 and ce.DEid = a.DEid
	 and c.DClinea = ce.DClinea
	 and sn.Ecodigo = c.Ecodigo
	 and sn.SNcodigo = c.SNcodigo
     and sn.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#"> 
	 and sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	 and de.DEid = a.DEid
	order by 1,2, 3, 4
</cfquery>


