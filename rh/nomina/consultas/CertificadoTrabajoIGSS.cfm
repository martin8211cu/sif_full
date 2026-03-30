<!--- CertificadoTrabajoIGSS.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfif isdefined("url.DEid") and len(trim(url.DEid)) GT 0>
            <cf_reportWFormat url="/rh/nomina/consultas/CertificadoTrabajoIGSSReporte.cfm"
             regresar="CertificadoTrabajoIGSS.cfm" params="DEid=#url.DEid#">
        <cfelse>     
            <cfinclude template="CertificadoTrabajoIGSSFiltro.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>