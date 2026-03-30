<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>

<cfset param = ''>
<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo))>
	<cfset form.RHPcodigo = url.RHPcodigo>
	<cfset param = "&Opcion=1">
</cfif>

<cfif isdefined("form.RHPcodigo")and len(trim(form.RHPcodigo))>
	<cfset param= param & "&RHPcodigo=#form.RHPcodigo#">
</cfif>
<cfif isdefined("form.CFid") and len(trim(form.CFid))>
	<cfset param= param & "&CFid=#form.CFid#">
</cfif>

<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfset form.CFid = url.CFid>	
</cfif>

<cf_web_portlet_start titulo="Indicador de Capacitación">
	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_rhimprime datos="/rh/capacitacion/consultas/IndicadorCapacitacion/IndCapacitacion-rep.cfm" paramsuri="#param#">

	<cfinclude template="IndCapacitacion-rep.cfm">
	
	<center>
		<form action="IndCapacitacionFiltro.cfm">
			<input type="submit" value="Regresar">
		</form>
	</center>

<cf_web_portlet_end>
<cf_templatefooter>