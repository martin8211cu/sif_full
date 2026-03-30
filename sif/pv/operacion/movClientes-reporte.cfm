
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> <cfoutput>#pNavegacion#</cfoutput>

		<cf_rhimprime datos="/sif/pv/operacion/movClientes-reporte-form.cfm" paramsuri="&CDCcodigo=#url.CDCcodigo#&FAX14DOC=#url.FAX14DOC#&CDCcodigodest=#url.CDCcodigodest#&chk=#url.chk#&FABmotivo=#url.Fabmotivo#" >

		<cfinclude template="movClientes-reporte-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>