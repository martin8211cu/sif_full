<cfif LvarTipoAnticipo EQ "POS">
	<cf_SP_lista tipo="4" irA="solicitudesAnt#LvarTipoAnticipo#.cfm">
<cfelse>
	<cf_SP_lista tipo="3" irA="solicitudesAnt#LvarTipoAnticipo#.cfm">
</cfif>	
<cfif NOT isdefined("form.chkCancelados")>
	<table width="100%">
		<tr>		  
			<td align="center">		
				<form name="formRedirec" method="post" action="<cfoutput>solicitudesAnt#LvarTipoAnticipo#.cfm</cfoutput>" style="margin: '0' ">
				  <input name="btnNuevo" type="submit" value="Nuevo" tabindex="2">
				</form>  
			</td>
		</tr>		  
	</table>
</cfif>
