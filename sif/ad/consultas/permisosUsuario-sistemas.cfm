<cfquery name="data" datasource="asp">
	#preservesinglequotes(myquery)#
</cfquery>
<br>
<cfset registros = 0 >
<table width="95%" align="center" cellpadding="3" cellspacing="0" border="0">
		<cfoutput query="data" group="SScodigo">
			<cfset registros = registros + 1 >
			<cfif registros neq 1 >
				<tr  ><td><td height="10"></td></td>
			</cfif>
			
			
			<cfoutput group="Enombre">
				<cfif not (isdefined("form.empresa") and len(trim(form.empresa)))>
				<tr>
					<td bgcolor="##d9d9d9" colspan="3" style="padding:4px;" ><strong>Empresa: #Enombre# </strong></td>
				</tr>
				</cfif>

				<tr>
					<td width="40">&nbsp;</td>
					<td class="tituloListas">Identificaci&oacute;n</td>
					<td class="tituloListas">Usuario</td>
				</tr>
				<cfoutput>
					<tr>
						<td width="40">&nbsp;</td>
						<td>#Pid#</td>
						<td>#Pnombre# #Papellido1# #Papellido2#</td>
					</tr>
				</cfoutput>	
			</cfoutput>	
		</cfoutput>

		<cfoutput>
		<cfif registros eq 0>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center" colspan="5">--- No se encontraron registros ---</td></tr>
			<tr><td>&nbsp;</td></tr>			
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center" colspan="5">--- Fin de la consulta ---</td></tr>
			<tr><td>&nbsp;</td></tr>			
		</cfif>
		</cfoutput>		
</table>		
