<!---SML. Modificacion 11/10/2013
Se realizo el cambio del reporte, ya que al exportar a Excel no permitia manipular la informacion,
y a su vez se agrego la opcion de seleccionar mas de una incidencia en el reporte, 
porque originalmente solo se podia obtener el reporte de un solo Concepto de Pago--->

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfset params="">
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif isdefined('form.Btnver')>
			<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde)) GT 0><cfset params= 'Fdesde='& #form.Fdesde#&'&Fhasta='&#form.Fhasta#></cfif>
			<cfif isdefined('form.DEid') and form.DEid GT 0><cfset params = params & '&DEid='&#form.DEid#></cfif>
			<cfif isdefined('form.CIid') and form.CIid GT 0><cfset params = params & '&CIid='&#form.CIid#></cfif>
            <cfif isdefined('form.HorasExtras')><cfset params = params & '&HorasExtras='&#form.HorasExtras#></cfif>
			<cfif isdefined('form.Historico')><cfset params = params & '&Historico='&#form.Historico#></cfif>
            <cfif isdefined('form.CaridList')><cfset params = params & '&CaridList='&#form.CaridList#></cfif>
			<cf_reportWFormat url="/rh/nomina/consultas/IncidenciasEmpleado-Reporte.cfm" orientacion="landscape"
			 regresar="IncidenciasEmpleado.cfm" params="#params#">
        <cfelse>     
            <cfinclude template="IncidenciasEmpleado-Filtro.cfm">
        </cfif>
<cf_templatefooter>