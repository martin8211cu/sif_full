<!--- ReporteLibroSalariosAut.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfif (isdefined("url.Fdesde") and len(trim(url.Fdesde)) GT 0) or isdefined('url.formatoImp')>
        	<cfset params= 'Fdesde='& #url.Fdesde#&'&Fhasta='&#url.Fhasta#>
			<cfif isdefined('url.formatoImp')><cfset params = params & '&formatoImp='&#url.formatoImp#></cfif>
			<cfif isdefined('url.Folio')><cfset params = params & '&Folio='&#url.Folio#></cfif>
			<cfif isdefined('url.Cantidad')><cfset params = params & '&Cantidad='&#url.Cantidad#></cfif>
            <cfif isdefined('url.DEid') and url.DEid GT 0><cfset params = params & '&DEid='&#url.DEid#></cfif>
			<cfif isdefined('url.DEid1') and url.DEid1 GT 0><cfset params = params & '&DEid1='&#url.DEid1#></cfif>
			<cfif isdefined('url.DEidentificacion') and url.DEidentificacion GT 0><cfset params = params & '&DEidentificacion='&#url.DEidentificacion#></cfif>
			<cfif isdefined('url.DEidentificacion1') and url.DEidentificacion1 GT 0><cfset params = params & '&DEidentificacion1='&#url.DEidentificacion1#></cfif>
            <cf_reportWFormat url="/rh/nomina/consultas/ReporteLibroSalariosAutReporte.cfm" orientacion="Landscape"
             regresar="ReporteLibroSalariosAut.cfm" params="#params#">
        <cfelse>     
            <cfinclude template="ReporteLibroSalariosAutFiltro.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>