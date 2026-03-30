<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<table  width="100%"cellpadding="2" cellspacing="0" border="0">
		<tr><td>
			<cf_gestion-traficoList
				tipoFiltro="1">
		</td></tr>
	</table>
<cf_templatefooter>


