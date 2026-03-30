<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
<cfif isdefined("url.fOorigen") and not isdefined("form.fOorigen") >
	<cfset form.fOorigen = url.fOorigen >
</cfif>

<cfif isdefined("url.fCconcepto") and not isdefined("form.fCconcepto") >
	<cfset form.fCconcepto = url.fCconcepto >
</cfif>

<cfif isdefined("url.fCdescripcion") and not isdefined("form.fCdescripcion") >
	<cfset form.fCdescripcion = url.fCdescripcion >
</cfif>

<cfif isdefined("url.CMSestado") and not isdefined("form.CMSestado") >
	<cfset form.CMSestado = url.CMSestado >
</cfif>

<cfif isdefined("url.CFcodigo") and not isdefined("form.CFcodigo") >
	<cfset form.CFcodigo = url.CFcodigo >
</cfif>

<cfoutput>
<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#">
<table width="95%" border="1" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr> 
		<td align="right" class="fileLabel" nowrap width="14%" >
			<label for="SNcodigo"><strong>Origen:&nbsp;</strong></label>											  
			<input type="text" name="fOorigen" size="4" maxlength="4" value="<cfif isdefined('form.fOorigen')><cfoutput>#form.fOorigen#</cfoutput></cfif>"  >&nbsp;
		</td>
		<td align="right" class="fileLabel" nowrap width="14%">
			<label for="SNcodigo"><strong>Lote:&nbsp;</strong></label>
			<input type="text" name="fCconcepto" size="3" maxlength="5" value="<cfif isdefined('form.fCconcepto')><cfoutput>#form.fCconcepto#</cfoutput></cfif>"  >&nbsp;
		</td>
		<td  nowrap width="24%">	
			<label for="fESnumeroH"><strong>Descripci&oacute;n:&nbsp;</strong></label>
			<input type="text" name="fCdescripcion" size="35" maxlength="50" value="<cfif isdefined('form.fCdescripcion')><cfoutput>#form.fCdescripcion#</cfoutput></cfif>"  > &nbsp;
		</td>
	  <td width="8%"><input type="submit" name="btnFiltro"  value="Filtrar" class="btnFiltrar"></td>
	</tr>		
</table>
</form>
</cfoutput>