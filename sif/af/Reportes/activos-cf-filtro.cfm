<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_templatecss>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>

			<form name="form1" method="get" style="margin:0;" action="activos-cf.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Centro Funcional:</strong>&nbsp;</td>
						<td><cf_rhcfuncional id="CFpk" tabindex="1"></td>
					</tr>

					<tr>
						<td align="right" valign="middle"></td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input type="checkbox" name="dependencias" id="dependencias" tabindex="1"></td>
									<td ><label for="dependencias">Incluir Centros Funcionales dependientes</label></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td width="10%" align="right"><strong>Periodo:</strong>&nbsp;</td>
						<td width="70%" >
							<cf_periodos tabindex="1">
						</td>
					</tr>
					
					<tr>
						<td width="10%" align="right"><strong>Mes:</strong>&nbsp;</td>
						<td width="70%" >
							<cf_meses tabindex="1">
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Categor&iacute;a:</strong>&nbsp;</td>
						<td rowspan="2"><cf_sifCatClase tabindexCat="1" tabindexClas="1"></td>
					</tr>
					
					<tr>
						<td align="right" valign="middle"><strong>Clase:</strong>&nbsp;</td>
					</tr>
					
					<tr>
						<td align="right" valign="middle"></td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input type="checkbox" name="responsable" id="responsable" tabindex="1"></td>
									<td ><label for="responsable">Responsable Actual</label></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Consultar,Exportar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			objForm.Mes.required = true;
			objForm.Mes.description = 'Mes';
			objForm.Periodo.required = true;
			objForm.Periodo.description = 'Período';
		</script>

	<cf_templatefooter>