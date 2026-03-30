<!-- Consultas -->
<cfoutput>
<form action="Transformacion-lista.cfm" method="post"  name="frequisicion" style="margin:0">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
		<tr>
			<td width="8">&nbsp;</td>  
			<td valign="baseline"><strong>Transporte</strong></td>
			<td width="8">&nbsp;</td>  
			<td valign="baseline"><strong>Documento</strong></td>
			<td width="87">&nbsp;</td>  			
			<td valign="baseline"><strong>Descripci&oacute;n</strong></td>
			<td width="4">&nbsp;</td>  
			<td><strong>Fecha</strong></td>
		</tr>
		<tr>
			<td width="8">&nbsp;</td>
			<td>
				<cfparam name="form.OCTtipoF"			default="">
				<cfparam name="form.OCTtransporteF"		default="">
				<cfparam name="form.OCTTdocumentoF"		default="">
				<cfparam name="form.OCTTobservacionesF"	default="">
				<cfparam name="form.OCTTfechaF"			default="">
				<select name="OCTtipoF">
					<option value=""></option>
					<option value="B" <cfif form.OCTtipoF EQ "B">selected</cfif>>Barco</option>
					<option value="A" <cfif form.OCTtipoF EQ "A">selected</cfif>>Avión</option>
					<option value="T" <cfif form.OCTtipoF EQ "T">selected</cfif>>Terrestre</option>
					<option value="F" <cfif form.OCTtipoF EQ "F">selected</cfif>>Ferrocarril</option>
					<option value="O" <cfif form.OCTtipoF EQ "F">selected</cfif>>Otro</option>
				</select>
				<input type="text" name="OCTtransporteF" size="15" maxlength="20" value="#form.OCTtransporteF#" style="text-transform: uppercase;">
			</td>
			<td width="8">&nbsp;</td>
			<td>
				<input type="text" name="OCTTdocumentoF" value="#form.OCTTdocumentoF#" size="15" maxlength="20" value="" style="text-transform: uppercase;"  >
			</td>
			<td width="87">&nbsp;</td>
			<td>
				<input type="text" name="OCTTobservacionesF" value="#form.OCTTobservacionesF#" size="30" maxlength="80" value="" style="text-transform: uppercase;"  >
			</td>
			<td width="4">&nbsp;</td>  
			<td>
				<cfif len(form.OCTTfechaF)>
					<cf_sifcalendario form="frequisicion" name="OCTTfechaF" value="#form.OCTTfechaF#">
				<cfelse>
					<cf_sifcalendario form="frequisicion" name="OCTTfechaF">
				</cfif>
			</td>
			<td align="center">
				<input type="submit" name="btnFiltro"  value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>