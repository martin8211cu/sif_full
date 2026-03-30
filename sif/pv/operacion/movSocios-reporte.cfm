
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"> <cfoutput>#pNavegacion#</cfoutput>

		<cf_rhimprime datos="/sif/pv/operacion/movSocios-reporte-form.cfm" paramsuri="&CDCcodigo=#url.CDCcodigo#&FAX14DOC=#url.FAX14DOC#&SNcodigo=#url.SNcodigo#&CCTcodigo=#url.CCTcodigo#&chk=#url.chk#&FABmotivo=#url.Fabmotivo#" >

		<cfinclude template="movSocios-reporte-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>