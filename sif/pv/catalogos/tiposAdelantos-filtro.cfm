<!--- CAMPOR POR EL CUAL SE REALIZARÁ EL FILTRO--->
<cfif isdefined("url.Descripcion") and not isdefined("form.Descripcion") >
	<cfset form.Descripcion = url.Descripcion >
</cfif>

<cfoutput>
<form style="margin: 0" action="tiposAdelantos.cfm" name="tiposAdelantos" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>Descripci&oacute;n<strong></td>
								
       	<td width="247" align="left"><input type="text" name="Descripcion_F" size="30" maxlength="30" value="<cfif isdefined('form.Descripcion_F')>#form.Descripcion_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>
