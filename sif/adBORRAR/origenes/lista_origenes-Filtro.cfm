<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
<cfif isdefined("url.fOorigen") and not isdefined("form.fOorigen") >
	<cfset form.fOorigen = url.fOorigen >
</cfif>

<cfoutput>
<form name="form2" method="post" action="#GetFileFromPath(GetTemplatePath())#">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr> 
		<td align="left" class="fileLabel" nowrap >
			<label for="SNcodigo"><strong>Origen:&nbsp;</strong></label>											  
			<input type="text" name="fOorigen" size="5" maxlength="4" value="<cfif isdefined('form.fOorigen')><cfoutput>#form.fOorigen#</cfoutput></cfif>"  >&nbsp;
		</td>
	  <td width="10%"><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</tr>		
</table>
</form>
</cfoutput>
