
<cfoutput>
<form method="post" name="form1" action="GestionTarjeta_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td nowrap align="right">
				<strong>Nombre y Apellidos:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNnombre#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Identificaci&oacute;n:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNidentificacion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Fecha Nacimiento:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#DateFormat(rsCuenta.SNFechaNacimiento,'dd/mm/yyyy')#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Fecha Alta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#DateFormat(rsCuenta.SNFecha,'dd/mm/yyyy')#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Tel&eacute;fono:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNtelefono#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Correo Electr&oacute;nico:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNemail#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right" valign="top" style="padding: 5px;">
				<strong>Direcci&oacute;n 1:&nbsp;</strong>
			</td>
			<td>
				<!---
				<cfset max = 49>
				<cfif cambio>
					<cfif len(rsCuenta.sndireccion) gt max>
						<cfloop index="i" from="1" to="#len(rsCuenta.sndireccion)#" step="#max#">
							<input type="text" value="<cfif cambio>#Mid(rsCuenta.sndireccion,i,max)#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</cfloop>
					<cfelse>
						<input type="text" value="<cfif cambio>#rsCuenta.sndireccion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
					</cfif>
				<cfelse>
					<input type="text" value="" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				</cfif>
				--->
				<input type="text" value="<cfif cambio>#rsCuenta.dirDireccion1#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Direcci&oacute;n 2:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.dirdireccion2#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Ciudad:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.dirciudad#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Estado:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.direstado#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>C&oacute;digo Postal:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.dircodPostal#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Pa&iacute;s:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.dirppais#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Limite de Cr&eacute;dito</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#LSCurrencyFormat(rsCuenta.MontoAprobado)#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
	</table>
</form>
</cfoutput>