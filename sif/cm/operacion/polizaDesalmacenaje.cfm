<cf_templateheader title="Polizas de Desalmacenaje">
	<cf_web_portlet_start titulo='Polizas de desalmacenaje'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm"> 
		<cfinclude template="polizaDesalmacenaje-config.cfm">
		<cfinclude template="polizaDesalmacenaje-dbcommon.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
		  		<td>
					<cfif (isdefined("modo") and lcase(modo) eq "lista")>
						<br><cfinclude template="polizaDesalmacenaje-filtro.cfm">
						<br><cfinclude template="polizaDesalmacenaje-lista.cfm"><br>
					<cfelse>
						<br><cfinclude template="polizaDesalmacenaje-form.cfm"><br>
					</cfif>
				</td>
			</tr>
		</table>
	 <cf_web_portlet_end>
<cf_templatefooter>