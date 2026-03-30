<cf_templateheader title="Consulta de Tarjetas Prepago">
	
<cf_web_portlet_start titulo="Consulta de Tarjetas Prepago">
	<cfinclude template="prepagos-params.cfm">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<cfif not isdefined('form.btnFiltrar') and isdefined('form.TJid') and form.TJid NEQ ''>
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
						<hr>
					</td>
				  </tr>				
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

