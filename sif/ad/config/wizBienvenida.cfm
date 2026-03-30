	<cfquery name="rsConfig" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=5
	</cfquery>
<!--- Se comenta para evitar error de configuracion, TODO --->
<!--- <cf_templateheader title="Configuración General de SIF"> --->
	<table width="100%" border="0" cellpadding="4" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="frame-header.cfm">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<cfinclude template="wizBienvenidaForm.cfm">
			</td>
		</tr>
	</table>
<!--- <cf_templatefooter> --->
