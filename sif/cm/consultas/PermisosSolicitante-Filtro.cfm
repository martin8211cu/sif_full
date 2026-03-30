<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
<cfif isdefined("url.CMScodigoD") and not isdefined("form.CMScodigoD") >
	<cfset form.CMScodigoD = url.CMScodigoD >
</cfif>

<cfif isdefined("url.CMScodigoH") and not isdefined("form.CMScodigoH") >
	<cfset form.CMScodigoH = url.CMScodigoH >
</cfif>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	
	<tr>
	  <td width="27%" nowrap class="fileLabel" ><label for="SNcodigo"><strong>Del Solicitante:</strong></label></td> 
		<td width="27%" nowrap class="fileLabel" >
														  
			<input type="text" name="CMScodigoD" size="20" maxlength="10" value="<cfif isdefined('form.CMScodigoD')><cfoutput>#form.CMScodigoD#</cfoutput></cfif>"  >&nbsp;
		</td>
		<td class="fileLabel" nowrap width="28%">
			<label for="SNcodigo"><strong>Al Solicitante:&nbsp;</strong></label>			&nbsp;
		</td>
		<td class="fileLabel" nowrap><input type="text" name="CMScodigoH" size="20" maxlength="10" value="<cfif isdefined('form.CMScodigoH')>#form.CMScodigoH#</cfif>"  ></td>
		<td width="45%"><input type="submit" name="btnFiltro"  value="Filtrar"><input type="reset" name="btnLimpiar"  value="Limpiar"></td>
	</tr>		
	<tr>
	  <td nowrap class="fileLabel" ><strong>Del Centro Funcional:&nbsp;</strong></td>
	  <td nowrap class="fileLabel" ><strong>
	    <!--- <input type="text" name="fCfdescripcionD" size="40" maxlength="60" value="<cfif isdefined('form.fCfdescripcionD')>#form.fCfdescripcionD#</cfif>" style="text-transform: uppercase;" > --->
		
		<cf_rhcfuncional name="fCFcodigoD" desc="fCFdescripcionD">
	  </strong></td>
	  <td nowrap class="fileLabel" ><strong>Al Centro Funcional:&nbsp;</strong></td>
	  <td nowrap class="fileLabel" ><strong>
        <!--- <input type="text" name="fCfdescripcionH" size="40" maxlength="60" value="<cfif isdefined('form.fCfdescripcionH')>#form.fCfdescripcionH#</cfif>" style="text-transform: uppercase;" > --->
		<cf_rhcfuncional name="fCFcodigoH" desc="fCFdescripcionH">
      </strong></td>
	  <td>&nbsp;</td>
    </tr>
	
</table>
</cfoutput>