<cfoutput>
<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td><strong>Fecha&nbsp;:&nbsp;</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td>
			<!--- Modo Alta --->
			<cf_sifcalendario name="FechaProgramacion" form="fagtproceso" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
		</td>
	</tr>
	<tr>
		<td><strong>Hora&nbsp;:&nbsp;</strong></td>
		<td>&nbsp;&nbsp;</td>
		<td>
			<!--- Modo Alta --->
			<select name="HoraProgramacion" tabindex="1">
				<cfloop from="1" to="12" index="Hora">
					<option value="#Hora#" <cfif Hour(Now()) mod 12 eq Hora>selected</cfif>>#Hora#</option>
				</cfloop>
			</select>
			<select name="MinutosProgramacion" tabindex="1">
				<cfloop from="0" to="45" step="15" index="Minuto">
					<option value="#Minuto#" <cfif Minute(Now()) gte Minuto and Minute(Now()) lt (Minuto + 15)>selected</cfif>>#Minuto#</option>
				</cfloop>
			</select>
			<select name="AMPM" tabindex="1">
				<option value="0"<cfif Hour(Now()) lt 12>selected</cfif>>AM</option>
				<option value="12"<cfif Hour(Now()) gte 12>selected</cfif>>PM</option>
			</select>
		</td>
	</tr>
</table>
</cfoutput>