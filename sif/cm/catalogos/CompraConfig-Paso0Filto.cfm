<!---Establecimiento de la navegacion --->
<cfif isdefined("url.CMTScodigo") and not isdefined("form.CMTScodigo") >
	<cfset form.CMTScodigo = url.CMTScodigo >
</cfif>

<cfif isdefined("url.CMTSdescripcion") and not isdefined("form.CMTSdescripcion") >
	<cfset form.CMTSdescripcion = url.CMTSdescripcion >
</cfif>

<cfif isdefined("url.LTipos") and not isdefined("form.LTipos") >
	<cfset form.LTipos = url.LTipos >
</cfif>

<cfoutput>
<form style="margin: 0" action="compraConfig.cfm" name="fsolicitudes" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
		<tr> 
			<td align="right" class="fileLabel" nowrap width="1%"><label for="CMTScodigo"><strong>C&oacute;digo:&nbsp;</strong></label><input type="text" name="CMTScodigo" size="20" maxlength="100" value="<cfif isdefined('form.CMTScodigo')>#form.CMTScodigo#</cfif>"  ></td>
			<td align="right" class="fileLabel" nowrap width="1%"><label for="CMTSdescripcion"><strong>Descripci&oacute;n:&nbsp;</strong></label><input type="text" name="CMTSdescripcion" size="20" maxlength="100" value="<cfif isdefined('form.CMTSdescripcion')>#form.CMTSdescripcion#</cfif>"  ></td>
			
			<td align="right" class="fileLabel" nowrap width="1%"><label for="fTipoSolicitud"><strong>Tipo:&nbsp;</strong></label>
				<select name="LTipos" id="LTipos">
					<option value="Todos" 		<cfif isdefined('form.LTipos') and form.LTipos EQ ''>			selected</cfif>>Todos</option>
					<option value="Artículo" 	<cfif isdefined('form.LTipos') and form.LTipos EQ 'Artículo'>	selected</cfif>>Artículo</option>
					<option value="Servicio"	<cfif isdefined('form.LTipos') and form.LTipos EQ 'Servicio'>	selected</cfif>>Servicio</option>
					<option value="Activo" 		<cfif isdefined('form.LTipos') and form.LTipos EQ 'Activo'>		selected</cfif>>Activo</option>
					<option value="Obras" 		<cfif isdefined('form.LTipos') and form.LTipos EQ 'Obras'>		selected</cfif>>Obras en Contrucción</option>
				</select>
		  </td>
			<td>&nbsp;&nbsp;<input type="submit" name="btnFiltro" class="btnFiltrar"  value="Filtrar"></td>
		</tr>
	</table>
</form>
</cfoutput>