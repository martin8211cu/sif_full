<cfif isdefined("url.DEidentificacion") and not isdefined(form.DEidentificacion)>
	<cfset form.DEidentificacion = url.DEidentificacion >
</cfif>
<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Hist&oacute;ricos por Documento">
	<cfoutput>
		<form name="form1" method="post" action="" style="margin: 0">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
				<tr><td>
					<cf_rhimprime datos="/sif/ccrh/consultas/historicosDocumento-form.cfm" paramsuri="&DEid=#form.DEid#">
					<cfinclude template="historicosDocumento-form.cfm">
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>
	</cfoutput>
<cf_templatefooter>