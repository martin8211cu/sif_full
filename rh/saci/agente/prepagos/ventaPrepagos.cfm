<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Venta de Prepagos">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td>
		  </tr>
		  <tr>
			<td width="50%" valign="top">
				<cf_web_portlet_start titulo="Venta de Prepagos">
					<cfif isdefined('form.TJid') and form.TJid NEQ ''>
						<cfinclude template="ventaPrepagos-form.cfm">
					<cfelse>
						<cfinclude template="ventaPrepagos-lista.cfm">				
					</cfif>
				<cf_web_portlet_end>
			</td>
			<cfif not isdefined('form.TJid') or form.TJid EQ ''>
				<td width="50%" valign="top">
					<cf_web_portlet_start titulo="Venta R&aacute;pida de Prepagos">
						<cfinclude template="ventaRapidaPrepagos.cfm">
					<cf_web_portlet_end>
				</td>
			</cfif>			
		  </tr>
		</table>
<cf_templatefooter>
