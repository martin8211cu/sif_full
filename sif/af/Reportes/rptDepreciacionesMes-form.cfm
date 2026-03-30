<form action="rptDepreciacionesMes.cfm" method="get" name="form1" style="margin:0px;">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" class="tituloAlterno">Reporte de Depreciaci&oacute;n por Periodo Mes</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Este reporte muestra Todas los Depreciaciones de Activos Realizadas en un Periodo / Mes.</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		Indique para cual periodo / mes (requeridos) 
		y para cuales categor&iacute;as desea ver el reporte .</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloListas">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%">
			<strong>Periodo:</strong>&nbsp;
		</td>
		<td width="70%" >
			<cf_periodos tabindex="1">
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%">
			<strong>Mes:</strong>&nbsp;
		</td>
		<td width="70%" >
			<cf_meses tabindex="1">
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%" nowrap="nowrap">
			<strong>Categor&iacute;a Desde:</strong>&nbsp;
		</td>
		<td width="70%" >
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
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%" nowrap="nowrap">
			<strong>Categor&iacute;a Hasta:</strong>&nbsp;
		</td>
		<td width="70%" >
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
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%" nowrap="nowrap">
			<strong>Oficina Desde:</strong>&nbsp;
		</td>
		<td width="70%" >
			<cf_conlis
				campos="Ocodigodesde, Oficodigodesde, Odescripciondesde"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,20,60"
				title="Lista de Oficinas"
				tabla="Oficinas"
				columnas="Ocodigo as Ocodigodesde, Oficodigo as Oficodigodesde, Odescripcion as Odescripciondesde"
				filtro="Ecodigo=#SESSION.ECODIGO#"
				desplegar="Oficodigodesde, Odescripciondesde"
				filtrar_por="Oficodigo, Odescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				align="left,left"
				asignar="Ocodigodesde, Oficodigodesde, Odescripciondesde"
				asignarformatos="S, S, S"
				showEmptyListMsg="true"
				EmptyListMsg="-- No se encontrarón Oficinas --"
				tabindex="1">
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="10%" nowrap="nowrap">
			<strong>Oficina Hasta:</strong>&nbsp;
		</td>
		<td width="70%" >
			<cf_conlis
				campos="Ocodigohasta, Oficodigohasta, Odescripcionhasta"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,20,60"
				title="Lista de Oficinas"
				tabla="Oficinas"
				columnas="Ocodigo as Ocodigohasta, Oficodigo as Oficodigohasta, Odescripcion as Odescripcionhasta"
				filtro="Ecodigo=#SESSION.ECODIGO# and Oficodigo >= $Oficodigodesde,varchar$"
				desplegar="Oficodigohasta, Odescripcionhasta"
				filtrar_por="Oficodigo, Odescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				align="left,left"
				asignar="Ocodigohasta, Oficodigohasta, Odescripcionhasta"
				asignarformatos="S, S, S"
				showEmptyListMsg="true"
				EmptyListMsg="-- No se encontrarón Oficinas --"
				tabindex="1">
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td align="right">
			<input type="checkbox" name="resumido"/>
		</td>
		<td>
			<strong>Resumido</strong>
		</td> 
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td align="right">
			<input type="checkbox" name="Archivo"/>
		</td>
		<td>
			<strong>Bajar a Archivo</strong>
		</td> 
		<td width="10%">&nbsp;</td>
	</tr>
</td>
<cf_botones values="Filtrar" tabindex="1">
</form>
<script language="javascript" type="text/javascript">
	function fnOnValidate(){
		if (objForm.ACcodigodeschasta.getValue()!=''&&objForm.ACcodigodeschasta.getValue().toUpperCase()<objForm.ACcodigodescdesde.getValue().toUpperCase()) objForm.ACcodigodeschasta.throwError("El valor de la Categoría hasta no puede ser menor que el de la Categoría desde.");
		if (objForm.Oficodigohasta.getValue()!=''&&objForm.Oficodigohasta.getValue().toUpperCase()<objForm.Oficodigodesde.getValue().toUpperCase()) objForm.Oficodigohasta.throwError("El valor de la Oficina hasta no puede ser menor que el de la Oficina desde.");
	}
	function fnOnSubmit(){
		objForm.btnFiltrar.obj.disabled=true;
	}
</script>
<cf_qforms onSubmit = "fnOnSubmit" onValidate="fnOnValidate">
	<cf_qformsRequiredField name="Periodo">
	<cf_qformsRequiredField name="Mes">
</cf_qforms>
<script language="javascript" type="text/javascript">
	objForm.ACcodigodescdesde.description = "Categoría desde";
	objForm.Periodo.obj.focus();	
</script>