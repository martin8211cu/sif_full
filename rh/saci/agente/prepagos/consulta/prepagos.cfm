<cf_templateheader title="Consulta de Tarjetas Prepago">
	
<cf_web_portlet_start titulo="Consulta de Tarjetas Prepago">
	<cfif isdefined('url.TJid_F') and not isdefined('form.TJid_F')>
		<cfset form.TJid_F = url.TJid_F>
	</cfif>
	<cfif isdefined('url.btnFiltrar') and not isdefined('form.btnFiltrar')>
		<cfset form.btnFiltrar = url.btnFiltrar>
	</cfif>	
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfif not isdefined('form.btnFiltrar') and isdefined('form.TJid_F') and form.TJid_F NEQ ''>
			  <tr>
				<td>
					<cfinclude template="prepagos-inf.cfm">
				</td>
			  </tr>		
		<cfelse>
			  <tr>
				<td><cfinclude template="prepagos-filtro.cfm"></td>
			  </tr>
			  <cfif isdefined('form.btnFiltrar')>
				  <tr>
					<td>
						<cfinclude template="prepagos-lista.cfm">
					</td>
				  </tr>
			  </cfif>
		</cfif>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>

