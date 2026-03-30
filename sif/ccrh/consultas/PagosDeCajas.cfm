<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Cuentas por Cobrar Empleados- Consulta de Documentos Provenientes de Cajas
	</cf_templatearea>
	
	<cf_templatearea name="body">
			
			<cfoutput>
			<form name="form1" method="post" action="" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
					</tr>
					<tr><td>
						<cfinclude template="PagosDeCaja-form.cfm">
					</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>
		
	</cf_templatearea>
</cf_template>
