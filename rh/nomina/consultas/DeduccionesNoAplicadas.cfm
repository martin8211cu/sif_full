<!--- ReporteLibroSalarios.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfif isdefined("url.CPid") and len(trim(url.CPid)) GT 0>
        	<cfset params= 'CPid='& #url.CPid#>
            <cf_reportWFormat url="/rh/nomina/consultas/DeduccionesNoAplicadasReporte.cfm" orientacion="landscape"
             regresar="DeduccionesNoAplicadas.cfm" params="#params#">
        <cfelse>     
            <cfinclude template="DeduccionesNoAplicadasFiltro.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>