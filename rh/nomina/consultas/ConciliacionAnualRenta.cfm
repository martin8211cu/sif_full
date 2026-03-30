<!--- CertificadoTrabajoIGSS.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="ConciliacionAnualRenta-etiquetas.cfm">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfif isdefined("url.EIRid") and len(trim(url.EIRid)) GT 0>
            <cf_reportWFormat url="/rh/nomina/consultas/ConciliacionAnualRenta-Rep.cfm"
             regresar="ConciliacionAnualRenta.cfm" params="EIRid=#url.EIRid#">
        <cfelse>     
            <cfinclude template="ConciliacionAnualRenta-filtro.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>