<!-- Consultas -->
<cfoutput>
<form action="interfazSoin10-lista.cfm" method="post"  name="frequisicion" style="margin:0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td width="8">&nbsp;</td>  
			<td valign="baseline"><strong>Origen</strong></td>
			<td width="8">&nbsp;</td>  			
			<td valign="baseline"><strong>Documento</strong></td>
			<td width="8">&nbsp;</td>  			
			<td valign="baseline"><strong>Moneda</strong></td>
			<td width="8">&nbsp;</td>  
			<td><strong>Fecha</strong></td>
		</tr>
		<tr>
			<td width="8">&nbsp;</td>
			<td>
				<select name="Modulo" tabindex="1" >
					<option value=""   >Todos</option>
					<option value="CC" <cfif isdefined("form.Modulo") and form.Modulo eq 'CC'> selected</cfif>>Cuentas Por Cobrar</option>
					<option value="CP" <cfif isdefined("form.Modulo") and form.Modulo eq 'CP'> selected</cfif>>Cuentas Por Pagar</option>
				</select>
			</td>
			<td width="8">&nbsp;</td>
			<td>
				<input type="text" name="Documento" <cfif isdefined("form.Documento") and len(form.Documento)>value="#form.Documento#"</cfif> size="20" maxlength="20" value="" style="text-transform: uppercase;" >
			</td>			
			<td width="8">&nbsp;</td>
			<td>
				<input type="text" name="CodigoMoneda" <cfif isdefined("form.CodigoMoneda") and len(form.CodigoMoneda)>value="#form.CodigoMoneda#"</cfif> size="3" maxlength="3" value="" style="text-transform: uppercase;" >
			</td>
			
			
			<td width="8">&nbsp;</td>  
			<td>
				<cfif isdefined("form.FechaDocumento") and len(form.FechaDocumento)>
					<cf_sifcalendario form="frequisicion" name="FechaDocumento" value="#form.FechaDocumento#">
				<cfelse>
					<cf_sifcalendario form="frequisicion" name="FechaDocumento">
				</cfif>
			</td>
			<td align="center">
				<input type="submit" name="btnFiltro"  value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>