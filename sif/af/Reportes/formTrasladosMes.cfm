<form action="rptTrasladosMes.cfm" method="get" name="form1" style="margin:0px;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="tituloListas">&nbsp;</td></tr>
	  	<tr>
			<td align="center" class="tituloAlterno">Reporte de Traslados por Periodo Mes</td>
		</tr>
	    <tr>
		 	<td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Este reporte muestra Todos los Traslados de Activos Realizados en un Periodo / Mes.</td>
		</tr>
		<tr>
			<td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Indique para cual periodo / mes (requeridos) y para cuales categor&iacute;as desea ver el reporte .</td>
	  	</tr>
		<tr>
			<td class="tituloListas">&nbsp;</td>
	  	</tr>
		<tr>
			<td>&nbsp;</td>
	  	</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%"><strong>Periodo:</strong>&nbsp;</td>
			<td width="80%" ><cf_periodos tabindex="1"></td>

		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%"><strong>Mes:</strong>&nbsp;</td>
			<td width="80%" ><cf_meses tabindex="1"></td>

		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%" nowrap="nowrap"><strong>Categor&iacute;a Desde:</strong>&nbsp;</td>
			<td width="80%" >
				<cf_conlis
					campos="ACcodigodesde, ACcodigodescdesde, ACdescripciondesde"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,20,60"
					title="Lista de Categor&iacute;as"
					tabla="ACategoria"
					columnas="ACcodigo as ACcodigodesde, ACcodigodesc as ACcodigodescdesde, ACdescripcion as ACdescripciondesde"
					filtro="Ecodigo=#SESSION.ECODIGO#"
					desplegar="ACcodigodescdesde, ACdescripciondesde"
					filtrar_por="ACcodigodesc, ACdescripcion"
					etiquetas="Código, Descripción"
					formatos="S,S"
					align="left,left"
					asignar="ACcodigodesde, ACcodigodescdesde, ACdescripciondesde"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
					tabindex="1">
			</td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%" nowrap="nowrap"><strong>Categor&iacute;a Hasta:</strong>&nbsp;</td>
			<td width="80%" >
				<cf_conlis
					campos="ACcodigohasta, ACcodigodeschasta, ACdescripcionhasta"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,20,60"
					title="Lista de Categor&iacute;as"
					tabla="ACategoria"
					columnas="ACcodigo as ACcodigohasta, ACcodigodesc as ACcodigodeschasta, ACdescripcion as ACdescripcionhasta"
					filtro="Ecodigo=#SESSION.ECODIGO# and ACcodigodesc >= $ACcodigodescdesde,varchar$"
					desplegar="ACcodigodeschasta, ACdescripcionhasta"
					filtrar_por="ACcodigodesc, ACdescripcion"
					etiquetas="Código, Descripción"
					formatos="S,S"
					align="left,left"
					asignar="ACcodigohasta, ACcodigodeschasta, ACdescripcionhasta"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
					tabindex="1">
			</td>
		</tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td width="10%" nowrap="nowrap"><strong>Bajar Archivo:</strong>&nbsp;</td>
			<td width="80%" ><input type="checkbox" name="chkArchivo"></td>
		</tr>
	</table>
<cf_botones values="Filtrar" tabindex="1">
</form>
<script language="javascript" type="text/javascript">
	function Cat2MayorCat1(){
		if (objForm.ACcodigodeschasta.getValue().toUpperCase()<objForm.ACcodigodescdesde.getValue().toUpperCase()) this.error = "El valor de la Categoría hasta no puede ser menor que el de la Categoría desde.";
	}
</script>
<cf_qforms>
	<cf_qformsRequiredField name="Periodo">
	<cf_qformsRequiredField name="Mes">
</cf_qforms>
<script language="javascript" type="text/javascript">
	objForm.ACcodigodescdesde.description = "Categoría desde";
</script>