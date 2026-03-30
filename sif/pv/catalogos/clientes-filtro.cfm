<!--- Campos por las cuales se realizará el filtro--->

<cfif isdefined("url.CDCcodigo") and not isdefined("form.CDCcodigo") >
	<cfset form.CDCcodigo = url.CDCcodigo >
</cfif>
<cfif isdefined("url.CDCidentificacion") and not isdefined("form.CDCidentificacion") >
	<cfset form.CDCidentificacion = url.CDCidentificacion >
</cfif>
<cfif isdefined("url.CDCnombre") and not isdefined("form.CDCnombre") >
	<cfset form.CDCnombre = url.CDCnombre >
</cfif>

<cfoutput>
<form style="margin: 0" action="clientes.cfm" name="clientes" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>Identificaci&oacute;n:&nbsp;<strong></td>
								
       	<td width="247" align="left"><input type="text" name="CDCidentificacion_F" size="15" maxlength="30" value="<cfif isdefined('form.CDCidentificacion_F')>#form.CDCidentificacion_F#</cfif>"></td>
   		
		<td width="82" align="right"><strong>Nombre:&nbsp;<strong></td>
								
       	<td width="247" align="left"><input type="text" name="CDCnombre_F" size="30" maxlength="30" value="<cfif isdefined('form.CDCnombre_F')>#form.CDCnombre_F#</cfif>"></td>
   			
   		<td><input type="submit" name="btnFiltro" class="btnFiltrar"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>
