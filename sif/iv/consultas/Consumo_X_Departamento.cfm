<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo = #session.Ecodigo#
	order by Dcodigo
</cfquery>
<cf_templateheader title="	Consumo por Departamento">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Consumo por Departamento'>
			<cfoutput>
				<form style="margin:0;" action="Consumo_X_Departamento_main.cfm" name="consulta" method="post">
					<table width="100%" cellpadding="0" cellspacing="1">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="right" nowrap>Departamento Inicial:&nbsp;</td>
							<td>
								<cf_conlis
									campos="depini, DeptocodigoIni, DdescripcionIni"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,8,24"
									title="Lista de Departamentos"
									tabla="Departamentos"
									columnas="Dcodigo as depini, Deptocodigo as DeptocodigoIni, Ddescripcion as DdescripcionIni"
									filtro="Ecodigo=#session.Ecodigo# order by 2"
									desplegar="DeptocodigoIni, DdescripcionIni"
									filtrar_por="Deptocodigo, Ddescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="depini, DeptocodigoIni, DdescripcionIni"
									form="consulta"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Departamentos --"
									tabindex="1">
							
							</td>
							<td align="right" nowrap>Departamento Final:&nbsp;</td>
							<td>
								<cf_conlis
									campos="depfin, DeptocodigoFin, DdescripcionFin"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,8,24"
									title="Lista de Departamentos"
									tabla="Departamentos"
									columnas="Dcodigo as depfin, Deptocodigo as DeptocodigoFin, Ddescripcion as DdescripcionFin"
									filtro="Ecodigo=#session.Ecodigo# order by 2"
									desplegar="DeptocodigoFin, DdescripcionFin"
									filtrar_por="Deptocodigo, Ddescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="depfin, DeptocodigoFin, DdescripcionFin"
									form="consulta"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Departamentos --"
									tabindex="1">
							
							</td>
						</tr>
						<tr>
							<td width="1%" nowrap align="right">Fecha Desde:&nbsp;</td>
							<td width="1%" nowrap><cf_sifcalendario tabindex="1" name="FechaDes" form="consulta"></td>
							<td width="1%" nowrap align="right">Fecha Hasta:&nbsp;</td>
							<td nowrap><cf_sifcalendario tabindex="1" name="FechaHas" form="consulta"></td>
						</tr>
						<tr>
							<td width="1%" align="right" nowrap>Documento:&nbsp;</td>
							<td nowrap>
								<input type="text" id="ERdocumento" name="ERdocumento" maxlength="20"  tabindex="1"
								<cfif isdefined("form.ERdocumento") and len(trim(form.ERdocumento)) and form.ERdocumento GT 0>
									value="#form.ERdocumento#"
								</cfif>
								 />
							</td>
						</tr>	
						<tr><td>&nbsp;</td></tr>
						<tr><td colspan="4" align="center"><input type="submit" name="Consultar" value="Consultar" tabindex="1"></td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</form>
			</cfoutput>
		<cf_web_portlet_end>	
	<cf_templatefooter>
<cf_qforms form="consulta">
<script language="javascript" type="text/javascript">
	document.consulta.depini.focus();
	objForm.depini.required = 'true';
	objForm.depini.description = 'Departamento Inicial';
	objForm.depfin.required = 'true';
	objForm.depfin.description = 'Departamento Final';
</script>