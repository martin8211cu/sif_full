<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
		<cf_templatecss>
		<cfoutput>#pNavegacion#</cfoutput>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="transaccionCambio.cfm">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<cf_web_portlet_start border="true" titulo="Consulta de Transacciones de Cambio de Categor&iacute;a-Clase" skin="info1">
							<p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n de todos los activos a los que se le cambio su categor&iacute;a, clase o ambas para el per&iacute;odo- mes solicitados.</p>
						<cf_web_portlet_end>
					</td>
					<td valign="top" width="50%">
						<table align="center" width="100%" cellpadding="2" cellspacing="0">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td align="right" width="45%"><strong>Per&iacute;odo:</strong>&nbsp;</td>
								<td ><cf_periodos name="periodo" tabindex="1"></td>
							</tr>
							<tr>
								<td align="right"><strong>Mes:</strong>&nbsp;</td>
								<td ><cf_meses name="mes" tabindex="1"></td>
							</tr>
							
							<tr>
								<td align="right"><strong>Categor&iacute;a:</strong>&nbsp;</td>
								<td rowspan="2"><cf_sifcatclase></td>
							</tr>
							<tr>
								<td align="right"><strong>Clase:</strong>&nbsp;</td>
							</tr>

							<tr>
								<td align="right"></td>
								<td >
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="middle" width="1%"><input type="checkbox" name="exportar" value="ok" /></td>
											<td valign="middle">Exportar a archivo</td>
										</tr>
									</table>
								</td>
							</tr>
		
							<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>
		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			objForm.periodo.required = true;
			objForm.periodo.description = 'Período';
			objForm.mes.required = true;
			objForm.mes.description = 'Mes';
		</script>
	<cf_templatefooter>