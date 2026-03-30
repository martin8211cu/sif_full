<!---
	<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
		<cfoutput>
		<tr><td align="center" class="superTitulo" colspan="3">#data.PCnombre#</td></tr>
		<tr><td align="center" colspan="3" ><strong><font size="2">#data.PCdescripcion#</font></strong></td></tr>
		<tr><td align="center" colspan="3" >&nbsp;</td></tr>
		</cfoutput>
	
		<cfoutput query="data" group="PPparte">
			<tr><td colspan="3" width="99%" style="padding-left:3; " valign="top">#data.PPpregunta#</td></tr>
			<cfoutput group="PPnumero">
				<!--- PINTA LA PREGUNTA --->
				<cfset pinto = false >
				<cfoutput>
				<tr>
					<cfif data.PPtipo neq 'E' and not pinto >
						<td width="1%" nowrap align="right" valign="top">#data.PPnumero#.</td>
						<td colspan="2" width="99%" style="padding-left:3; " valign="top">#data.PPpregunta#</td>
						<cfset pinto = true>
					</cfif>
				</tr>
				</cfoutput>

				<cfoutput>
				<cfif data.PPtipo eq 'U' >
						<tr>
							<td></td>
							<td colspan="2">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td align="1%" ><input style="border:0;" type="radio" name="p_#data.PPid#" value="#data.PRid#"></td>
										<td width="99%"><font size="2">#data.PRtexto#</font></td>
									</tr>
								</table>
							</td>
						</tr>
				<cfelseif data.PPtipo eq 'M'>
						<tr>
							<td></td>
							<td colspan="2">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="1%"><input style="border:0;" type="checkbox" name="p_#data.PPid#" value="#data.PRid#"></td>
										<td align="left"><font size="2">#data.PRtexto#</font></td>
									</tr>
								</table>
							</td>
						</tr>
				<cfelseif data.PPtipo eq 'D'>
						<tr>
							<td></td>
							<td colspan="2"><textarea name="p_#data.PPid#" cols="80" rows="5"></textarea></td>
						</tr>
				<cfelseif data.PPtipo eq 'V'>
					<cfset index = 1 >
					<tr>
						<td></td>
						<td width="1%" ><input type="text" size="7" maxlength="7" name="p_#data.PPid#_#index#" value=""></td>
						<td width="99%" style="padding-left:3px;"><font size="2">#data.PRtexto#</font></td>
					</tr>
					<cfset index = index + 1 >
				<cfelseif data.PPtipo eq 'O'>
						<tr>
							<td></td>
							<td ></td>
							<td><font size="2">#data.PRtexto#</font></td>
						</tr>
				</cfif>
				</cfoutput>
					</tr>
					
				<tr><td colspan="3">&nbsp;</td></tr>

			</cfoutput>
		</cfoutput>	
	</table>
--->	
