<!--- ReporteLibroSalarios.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfif isdefined("url.Fdesde") and len(trim(url.Fdesde)) GT 0>
        	<cfset params= 'Fdesde='& #url.Fdesde#&'&Fhasta='&#url.Fhasta#>
            <cfif isdefined('url.CFid') and url.CFid GT 0><cfset params = params & '&CFid='&#url.CFid#></cfif>
			<cfif isdefined('url.RHTPid') and url.RHTPid GT 0><cfset params = params & '&RHTPid='&#url.RHTPid#></cfif>
			<cfif isdefined('url.chkdependencias') and url.chkdependencias GT 0><cfset params = params & '&chkdependencias='&#url.chkdependencias#></cfif>
			<cfif isdefined('url.DEid') and url.DEid GT 0><cfset params = params & '&DEid='&#url.DEid#></cfif>
			<cfif isdefined('url.DEid') and url.DEid GT 0><cfset params = params & '&DEid='&#url.DEid#></cfif>
			<cfif isdefined('url.DEid1') and url.DEid1 GT 0><cfset params = params & '&DEid1='&#url.DEid1#></cfif>
			<cfif isdefined('url.DEidentificacion') and url.DEidentificacion GT 0><cfset params = params & '&DEidentificacion='&#url.DEidentificacion#></cfif>
			<cfif isdefined('url.DEidentificacion1') and url.DEidentificacion1 GT 0><cfset params = params & '&DEidentificacion1='&#url.DEidentificacion1#></cfif>
            <cf_reportWFormat url="/rh/nomina/consultas/ReporteLibroSalariosReporte.cfm" orientacion="landscape"
             regresar="ReporteLibroSalarios.cfm" params="#params#">
        <cfelse>     
            <cfinclude template="ReporteLibroSalariosFiltroCR.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>