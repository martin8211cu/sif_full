<cfif isdefined('url.paso') and not isdefined('form.paso')>
	<cfset form.paso = url.paso>
</cfif>
<cfinclude template="analisis-salarial2-config.cfm">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td valign="top" style="padding-right: 3px;">
			<cf_web_portlet_start titulo="An&aacute;lisis Salarial" width="100%" border="true">
				<cfinclude template="/home/menu/pNavegacion.cfm">
				<cfinclude template="analisis-salarial2-header.cfm">
				<cfif Form.paso EQ 0>
					<cfinclude template="analisis-salarial2-listaReportes.cfm">
				<cfelseif Form.paso EQ 1>
					<cfinclude template="analisis-salarial2-paso1.cfm">
				<cfelseif Form.paso EQ 2>
					<cfinclude template="analisis-salarial2-paso2.cfm">
				<cfelseif Form.paso EQ 3>
					<cfinclude template="analisis-salarial2-paso3.cfm">
				</cfif>
			<cf_web_portlet_end>
		</td>
		<td width="190" valign="top">
			<cfinclude template="analisis-salarial2-progreso.cfm"><br>
			<cfinclude template="analisis-salarial2-ayuda.cfm">
		</td>
	</tr>
</table>
