<!--- 	Mantenimiento de Etiquetas de Reporte de Transacciones Aplicadas.
 		Creado por Dorian A.G. el 5 de Agosto del 2005. 
--->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfinclude template="CCTrpttranapl-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>
