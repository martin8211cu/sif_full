
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	<cfif isDefined("Url.RHCconcurso") and not isDefined("form.RHCconcurso")>
		<cfset form.RHCconcurso = Url.RHCconcurso>
	</cfif>
	<cfif isDefined("Url.RHPCid") and not isDefined("form.RHPCid")>
		<cfset form.RHPCid = Url.RHPCid>
	</cfif>
	<cfif not isdefined("modo")>
		<cfset modo = "ALTA">
	</cfif>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="Evaluaciones-form.cfm">
				</td>	
			</tr>
		</table>	


