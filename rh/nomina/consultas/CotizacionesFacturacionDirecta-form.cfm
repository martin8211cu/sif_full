




<!---<cf_dump var="#form#">--->

<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.CPid") and len(trim(url.CPid))>
	<cfset form.CPid = url.CPid>
</cfif>

<cfset PeriodoPago = LSParseDateTime('01/#mes#/#periodo#')>

<cfquery name="rsDatosEncabezado" datasource="asp">
	select a.CEcodigo, 
		   a.Mcodigo, 
		   a.Enumero,
		   a.Ereferencia,
		   a.Eidresplegal,
		   
		   a.Enombre as nombreEmpresa,
		   a.Etelefono1 as tel1Empresa, 
		   a.Etelefono2 as tel2Empresa, 
		   a.Efax as faxEmpresa, 
		   a.Eidentificacion as NoPatronal,
		   a.Eactividad as actividad,
		   a.Enumlicencia as NIT,
		   c.direccion1 as direccion1Empresa,
		   c.direccion2 as direccion2Empresa,
		   c.ciudad as ciudadEmpresa,
		   c.estado as estadoEmpresa,
		   
		   b.CEnombre as nombreCEmpresa,
		   b.CEtelefono1 as tel1CEmpresa, 
		   b.CEtelefono2 as tel2CEmpresa, 
		   b.CEfax as faxCEmpresa, 
		   e.direccion1 as direccion1CEmpresa,
		   e.direccion2 as direccion2CEmpresa,
		   e.ciudad as ciudadCEmpresa,
		   e.estado as estadoCEmpresa,
		   
		   
		   '#LSDateFormat(now(),'dd/mm/yyyy')#' as FechaEmision,
		   '' as Ruta,
		   1 as CorrPlanilla,
		   0 as Hoja,<!---consecutivo de hoja--->
		   '' as IVA,
		   '#LSDateFormat(PeriodoPago,'mmm-yyyy')#' as PeriodoPago
		   
	from Empresa a
	
	inner join CuentaEmpresarial b
	on b.CEcodigo = a.CEcodigo
	
	inner join Direcciones c
		on c.id_direccion = a.id_direccion	
		
	inner join Direcciones e
		on e.id_direccion = b.id_direccion	
		
	where a.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<cfinvoke component="rh.Componentes.RH_ReporteSS_Salvador" method="RH_ReporteSS_Salvador" returnvariable="rsDatosEmpleado">
	<cfinvokeargument name="periodo" value="#form.periodo#">
	<cfinvokeargument name="mes" value="#form.mes#">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
	<cfinvokeargument name="masivo" value="0">	
</cfinvoke>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CotizacionesFacturacionDirecta" Default="Reporte de Pago Mensual de Cotizaciones con Facturaci&oacute;n Directa." returnvariable="LB_CotizacionesFacturacionDirecta"/>

<cfinclude template="CotizacionesFacturacionDirecta-rep.cfm">