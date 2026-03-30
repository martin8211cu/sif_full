<cfif isdefined("url.fCMScodigo") and len(url.fCMScodigo) and not isdefined("form.fCMScodigo")>
	<cfset form.fCMScodigo = url.fCMScodigo>
</cfif>
<cfif isdefined("url.fCMSnombre") and len(url.fCMSnombre) and not isdefined("form.fCMSnombre")>
	<cfset form.fCMSnombre = url.fCMSnombre>
</cfif>

<cfoutput>
<form style="margin: 0" action="solicitantes.cfm" name="fsolicitante" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  		<tr> 
    		<td class="fileLabel" nowrap width="1%">
				<strong>C&oacute;digo:&nbsp;</strong>
    		  	<input type="text" name="fCMScodigo" size="10" maxlength="20" value="<cfif isdefined('form.fCMScodigo')>#form.fCMScodigo#</cfif>">
			</td>
    		<td class="fileLabel" nowrap width="1%">
					<strong>Nombre:&nbsp;</strong>
    		 	 <input type="text" name="fCMSnombre" size="40" maxlength="100" value="<cfif isdefined('form.fCMSnombre')>#form.fCMSnombre#</cfif>">
			</td>
			<td align="right">
				<input type="submit" name="btnFiltro"  value="Filtrar">
			</td>
		</tr>
	</table>
</form>
</cfoutput>