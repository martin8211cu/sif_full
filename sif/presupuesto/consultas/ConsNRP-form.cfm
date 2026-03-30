<cfinclude template="../common/NRP-form.cfm">
<cfif isdefined("LvarExit")><cfexit></cfif>
  <tr>
    <td align="center">
	<cfif isdefined('url.ERROR_NRP')>
		<input type="submit" name="btnRegresar" value="Regresar" onClick="javascript: window.location.href ='<cfoutput>#CGI.HTTP_REFERER#</cfoutput>';">
	<cfelse>
		<cf_navegacion name="btnFiltrar" default="" session>
		<form name="form1nrp" method="post" action="ConsNRP.cfm">
			<input name="btnFiltrar" value="<cfoutput>#form.btnFiltrar#</cfoutput>" type="hidden">
			<input name="btnRegresar" value="Regresar" type="submit">
		</form>
	</cfif>
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</table>
