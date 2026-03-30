<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfinclude template="../../../portlets/pNavegacion.cfm">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		
<cfoutput>
	<form name="form1" method="post" action="Adq_Dep_Fiscal_sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Reporte</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap="nowrap" align="right">
							<strong>Categor&iacute;a Desde:</strong>&nbsp;
						</td>
						<td  >
							<cf_conlis
								campos="codigodesde, ACinicio, ACdescripciondesde"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								tabla="ACategoria"
								columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="ACinicio, ACdescripciondesde"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigodesde, ACinicio, ACdescripciondesde"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Categor&iacute;a Hasta:</strong>&nbsp;
						</td>
						<td  >
							<cf_conlis
								campos="codigohasta, AChasta, ACdescripcionhasta"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								tabla="ACategoria"
								columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="AChasta, ACdescripcionhasta"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigohasta, AChasta, ACdescripcionhasta"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">
						</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Centro Funcional Desde:&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFidinicio, CFcodigo as CFcodigoinicio, CFdescripcion as CFdescripcioninicio"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigoinicio, CFdescripcioninicio"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Centro Funcional Hasta:&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFidfinal, CFcodigo as CFcodigofinal, CFdescripcion as CFdescripcionfinal"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigofinal, CFdescripcionfinal"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right"><strong>Activo desde:&nbsp;</strong></td>
						<td>
							<cf_sifactivo name="AidDesde" placa="AplacaDesde" desc="AdescripcionDesde" tabindex="1"
							frame="frocupacionDesde" form= "form1">
						</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right"><strong>Activo hasta:&nbsp;</strong></td>
						<td>
							<cf_sifactivo name="AidHasta" placa="AplacaHasta" desc="AdescripcionHasta" tabindex="1"
								frame="frocupacionHasta" form= "form1">
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Per&iacute;odo:</strong>&nbsp;</td>
						<td><cf_periodos name="periodoInicial" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Mes:</strong>&nbsp;</td>
						<td><cf_meses name="mesInicial" tabindex="1"></td>
					</tr>
                    <tr>
						<td align="right"><strong>Depreciacion:</strong>&nbsp;</td>
						<td>
                       		<select name="FDepreciacion" tabindex="1" style="width: 135px;" >
								<option value="11">Normal</option>
								<option value="12">Acelerada</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2"><cf_botones values="Generar,Exportar" names="Generar,Exportar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	objForm.ACinicio.required=true;
	objForm.ACinicio.description='Categoría Desde';
	objForm.AChasta.required=true;
	objForm.AChasta.description='Categoría Hasta';
	objForm.FDepreciacion.required=true;
	objForm.FDepreciacion.description='Depreciacion';
</script>
