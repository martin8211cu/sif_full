<form action="rptDepositoAjustePeaje.cfm" method="post" name="form1" style="margin:0px;" onSubmit="return validar(this);">
<table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="40%" align="left" >
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cf_web_portlet_start border="true" titulo="Reporte de Peajes" skin="info1">
							<p>En éste reporte se muestra la información referente a  Depósitos y ajustes por peajes por rango de Peajes / Tipo de transacciones /  Fechas /Documento. 
							Para poder realizar la consulta se debe haber seleccionado  todas las casillas, únicamente el documento no es necesario. 
							El reporte muestra  la fecha, tipo de transacción, documento, descripción, monto, moneda.</p>
							<p align="justify">&nbsp;</p>
						<cf_web_portlet_end>
					</td>
				</tr>
			</table>
		</td>
		<td valign="top" width="60%" align="left">
						
			<table align="right" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td nowrap="nowrap" align="center" colspan="7">
						<strong>Peajes:&nbsp;</strong>&nbsp;
					</td>
				</tr>
				<tr>
					<td nowrap align="right" colspan="5">
						<strong>Desde:&nbsp;&nbsp;</strong>
					</td>
					<td colspan="2">
						<cf_conlis
							campos="Pidincio, Pcodigoincio, Pdescripcionincio"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,40"
							title="Lista de Peajes"
							tabla="Peaje"
							columnas="Pid as Pidincio, Pcodigo as Pcodigoincio, Pdescripcion as Pdescripcionincio"
							filtro="Ecodigo=#SESSION.ECODIGO# order by Pid"
							desplegar="Pcodigoincio, Pdescripcionincio"
							filtrar_por="Pcodigo, Pdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="Pidincio, Pcodigoincio, Pdescripcionincio"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Peajes --"
							tabindex="1">					
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right" colspan="5">
						<strong>Hasta:&nbsp;&nbsp;</strong>
					</td>
					<td>
						<cf_conlis
							campos="Pidfinal, Pcodigofinal, Pdescripcionfinal"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,40"
							title="Lista de Peajes"
							tabla="Peaje"
							columnas="Pid as Pidfinal, Pcodigo as Pcodigofinal, Pdescripcion as Pdescripcionfinal"
							filtro="Ecodigo=#SESSION.ECODIGO# order by Pid"
							desplegar="Pcodigofinal, Pdescripcionfinal"
							filtrar_por="Pcodigo, Pdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="Pidfinal, Pcodigofinal, Pdescripcionfinal"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Peajes --"
							tabindex="1">					
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="center" colspan="7"><strong>Tipo de Transacción bancaria:&nbsp;</strong></td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right" colspan="5"><strong>Desde:&nbsp;&nbsp;</strong></td>
					<td>
														
							<cf_conlis
							campos="BTidinicio, BTcodigoinicio, BTdescripcioninicio"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,40"
							title="Lista de Tipo de Transacción bancaria"
							tabla="BTransacciones"
							columnas="BTid as BTidinicio, BTcodigo as BTcodigoinicio, BTdescripcion as BTdescripcioninicio"
							filtro="Ecodigo=#SESSION.ECODIGO# order by BTid"
							desplegar="BTcodigoinicio, BTdescripcioninicio"
							filtrar_por="BTcodigo, BTdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="BTidinicio, BTcodigoinicio, BTdescripcioninicio"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontro Tipo de Transacción bancaria --"
							tabindex="1">					
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap" align="right" colspan="5"><strong>Hasta:&nbsp;&nbsp;</strong></td>
					<td>
					
						<cf_conlis
							campos="BTidfinal, BTcodigofinal, BTdescripcionfinal"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,40"
							title="Lista de Tipo de Transacción bancaria"
							tabla="BTransacciones"
							columnas="BTid as BTidfinal, BTcodigo as BTcodigofinal, BTdescripcion as BTdescripcionfinal"
							filtro="Ecodigo=#SESSION.ECODIGO# order by BTid"
							desplegar="BTcodigofinal, BTdescripcionfinal"
							filtrar_por="BTcodigo, BTdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="BTidfinal, BTcodigofinal, BTdescripcionfinal"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontro Tipo de Transacción bancaria --"
							tabindex="1">
													
						
					</td>
				</tr>
				<tr>
					<td align="right" width="25%" nowrap colspan="5"><strong>Fecha Desde:&nbsp;&nbsp;</strong></td>
					<td colspan="5"><cf_sifcalendario name="Fechadesde" tabindex="1"></td>
				</tr>
				<tr>
					<td align="right" colspan="5"><strong>Fecha Hasta:&nbsp;&nbsp;</strong></td>
					<td colspan="5"><cf_sifcalendario name="Fechahasta" tabindex="1"></td>
				</tr>
				<tr>
					<td align="right" colspan="5"><strong>Documento:&nbsp;&nbsp;</strong></td>
					<td colspan="5"><input type="text" name="documento" id="documento"/> </td>
				</tr>
				
				<tr>
					<td colspan="7">
						<cf_botones values="Filtrar,Limpiar" tabindex="1">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
			
			
</form>

	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.Pcodigoincio.description = "Peaje inicial";
		objForm.Pcodigofinal.description = "Peaje final";
		objForm.BTcodigoinicio.description = "tipo de transacción inicial";
		objForm.BTcodigofinal.description = "tipo de transacción final";
		objForm.Fechadesde.description = "Fecha de Inicio";
		objForm.Fechahasta.description = "Fecha Final";
		
		objForm.Pcodigoincio.required = true;
		objForm.Pcodigofinal.required = true;
		objForm.BTcodigoinicio.required = true;
		objForm.BTcodigofinal.required = true;
		objForm.Fechadesde.required = true;
		objForm.Fechahasta.required = true;
		
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (fnFechaYYYYMMDD(document.form1.Fechadesde.value) > fnFechaYYYYMMDD(document.form1.Fechahasta.value))
		{
			alert ("La Fecha Inicial debe ser menor a la Fecha Final");
			return false;
		}
	
	}    


</script>



	


