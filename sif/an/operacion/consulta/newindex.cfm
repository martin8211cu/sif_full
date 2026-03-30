<cf_templateheader title="Calcular Anexos">
	<cf_web_portlet_start titulo="Consulta de Anexos">
		<cfinclude template="/home/menu/pNavegacion.cfm">

		<table width="950" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					<cfif isdefined("Form.ACid") and len(trim(Form.ACid))>
						<cfinclude template="ConsultaAnexos-form.cfm">
					<cfelse>
						<cfinclude template="ConsultaAnexos.cfm">
					</cfif>										
				</td>				
			</tr>
		</table>		
			
	<cf_web_portlet_end>
<cf_templatefooter>

