<!---<table  border="0" align="center">
	<tr>
		<cfif modo EQ "CAMBIO" >
			<tr valign="top"> 
				<td valign="top">
						<tr valign="baseline"> 
							<td nowrap align="left" valign="top">
								<cfinclude template="MetricasEspecialesFiltros.cfm">
							</td>
						</tr>
					
				</td></tr>
		</cfif>
	</tr>
</table> --->	

<table cellpadding="0" cellspacing="0" border="0" align="center">
<tr valign="baseline"> 
	<td nowrap><strong>Agrupar por:</strong></td>
	<td nowrap>&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr valign="baseline"> 
	<td nowrap align="center">
		
		<cfinclude template="MetricasEspecialesFiltros.cfm">
		
	</td>
</tr>
</table>