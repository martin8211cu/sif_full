<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
<cfif isdefined("url.CMScodigoD") and not isdefined("form.CMScodigoD") >
	<cfset form.CMScodigoD = url.CMScodigoD >
</cfif>

<cfif isdefined("url.CMScodigoH") and not isdefined("form.CMScodigoH") >
	<cfset form.CMScodigoH = url.CMScodigoH >
</cfif>

<cfif isdefined("url.CMSnombre") and not isdefined("form.CMSnombre") >
	<cfset form.CMSnombre = url.CMSnombre >
</cfif>

<cfif isdefined("url.CMSestado") and not isdefined("form.CMSestado") >
	<cfset form.CMSestado = url.CMSestado >
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo") >
	<cfset form.CFcodigo = url.CFcodigo >
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr> 
		<td align="right" class="fileLabel" nowrap >
			<label for="SNcodigo"><strong>Del Solicitante:&nbsp;</strong></label>											  
			<input type="text" name="CMScodigoD" size="20" maxlength="10" value="<cfif isdefined('form.CMScodigoD')><cfoutput>#form.CMScodigoD#</cfoutput></cfif>"  >&nbsp;
		</td>
		<td align="right" class="fileLabel" nowrap width="24%">
			<label for="SNcodigo"><strong>Al Solicitante:&nbsp;</strong></label>
			<input type="text" name="CMScodigoH" size="20" maxlength="10" value="<cfif isdefined('form.CMScodigoH')><cfoutput>#form.CMScodigoH#</cfoutput></cfif>"  >&nbsp;
		</td>
		<td  nowrap width="24%">	
			<label for="fESnumeroH"><strong>Nombre:&nbsp;</strong></label>
			<input type="text" name="CMSnombre" size="40" maxlength="120" value="<cfif isdefined('form.CMSnombre')><cfoutput>#form.CMSnombre#</cfoutput></cfif>"  > &nbsp;
		</td>
		<td class="fileLabel" nowrap width="19%">
			<label for="LEstado"><strong>Estado:&nbsp;</strong></label>
			<select name="LEstado" id="LEstado">
				<option value="" >- No especificado -</option>
				<option value="0" <cfif isdefined('form.CMSestado') and form.CMSestado EQ 0>selected</cfif>>Activo</option>
				<option value="1" <cfif isdefined('form.CMSestado') and form.CMSestado EQ 5>selected</cfif>>Inactivo</option>
			</select>
		</td>
		<td width="8%"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</tr>		
</table>
</cfoutput>