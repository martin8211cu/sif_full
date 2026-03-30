<style type="text/css">
<!--
.pStyle_TESSPmsgRechazo {color: #FF0000}
-->
</style>

<cf_SP_lista tipo="2" irA="solicitudesCPanticipos.cfm">
<cfif NOT isdefined("form.chkCancelados")>
	<table width="100%">
		<tr>		  
			<td align="center">		
				<form name="formRedirec" method="post" action="solicitudesCPanticipos.cfm" style="margin: '0' ">
				  <input name="btnNuevo" type="submit" value="Nuevo" tabindex="2">
				</form>  
			</td>
		</tr>		  
	</table>
</cfif>
