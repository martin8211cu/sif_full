<cfif isdefined("url.botonSel") and not isdefined("form.botonSel")>
	<cfset form.botonSel = url.botonSel >
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top" width="100%">
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr>				
					<cfif isdefined("form.botonSel") and form.botonSel eq 'Buscar' >
						<td width="50%" valign="top" align="center">
							<cfinclude template="listaCuentas.cfm">
						</td>
					<cfelse>
						<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
						<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
						<td width="50%" valign="top" align="center">
							<cfinclude template="CuentaPrincipal_form.cfm">
						</td>
					</cfif>
 				</tr>
			</table>
     </td>
  </tr>
</table>