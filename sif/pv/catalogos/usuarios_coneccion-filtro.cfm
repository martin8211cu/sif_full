<!--- CAMPO POR EL CUAL SE VA A REALIZAR EL FILTRO --->
<cfif isdefined("url.FAlogin") and not isdefined("form.FAlogin") >
	<cfset form.FAlogin = url.FAlogin>
</cfif>

<cfoutput>
<form style="margin: 0" action="usuarios_coneccion.cfm" name="usuarios_coneccion" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
<tr>
	<td colspan="2">
       	<td width="82" align="right"><strong>Login<strong></td>
								
       	<td width="247" align="left"><input type="text" name="FAlogin_F" size="15" maxlength="30" value="<cfif isdefined('form.FAlogin_F')>#form.FAlogin_F#</cfif>"></td>
   			 			
   		<td><input type="submit" name="btnFiltro"  value="Filtrar"></td>
	</td>	
</tr>
 </table>
</form>
</cfoutput>