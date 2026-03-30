<!--- CAMPOS POR LOS CUALES SE REALIZARÁ EL FILTRO--->
<cfif isdefined("url.FATcodigo") and not isdefined("form.FATcodigo") >
	<cfset form.FATcodigo = url.FATcodigo >
</cfif>
<cfif isdefined("url.FATdescripcion") and not isdefined("form.FATdescripcion") >
	<cfset form.FATdescripcion = url.FATdescripcion >
</cfif>

<cfoutput>
<form style="margin: 0" action="tarjetas_cred.cfm" name="tarjetas" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>C&oacute;digo<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FATcodigo_F" size="15" maxlength="30" value="<cfif isdefined('form.FATcodigo_F')>#form.FATcodigo_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Tarjeta<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FATdescripcion_F" size="30" maxlength="30" value="<cfif isdefined('form.FATdescripcion_F')>#form.FATdescripcion_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>
