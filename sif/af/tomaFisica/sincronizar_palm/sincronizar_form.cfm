<body>
<form name="form1" enctype="multipart/form-data" action="sincronizar_apply.cfm" method="post">
	<table align="center">
		<tr>
			<td>

				<strong>Preparación de Datos de Conteo</strong><BR>
				Sincronizar Datos de Conteo del SIF a la Palm:<BR>
				(Empleados, Activos, Centros de Costos y Hojas de Conteo en blanco)<BR>
				<strong>Dispositivo (Handheld):</strong><BR>
				<cf_conlis maxrowsquery="200"
					campos="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
					size="0,20,34"
					desplegables="N,S,S"
					modificables="N,S,N"
					asignar="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
					asignarformatos="I,S,S" 
					columnas="AFTFid_dispositivo, AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
					tabla="AFTFDispositivo"
					filtro="CEcodigo = #session.CEcodigo# and AFTFestatus_dispositivo = 1" 
					desplegar="AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
					formatos="S,S"
					align="left,left"
					etiquetas="C&oacute;digo, Descripci&oacute;n" 
					filtrar_por="AFTFcodigo_dispositivo, AFTFnombre_dispositivo" 
					tabindex="1" 
					title="Lista de Dispositivos"
					/>			
			</td>
			<td align="center">
				<input type="submit" value="Download"
						name="btnDownload"
						 onclick="if (document.form1.AFTFid_dispositivo.value == '') {alert('Debe indicar Dispositivo'); return false;}"
				>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<strong>Registrar Hojas de Conteo</strong><BR>
				Sincronizar Datos de Conteo de la Palm al SIF:<BR>
				(Hojas de Conteo llenas y Activos nuevos)<BR>
				<strong>Archivo (HHSIF_<cfoutput>#dateFormat(now(),"YYYYMMDD")#</cfoutput>.xml):</strong><BR>
				<input 	type="file" name="txtFile"
						value="HHSIF_<cfoutput>#dateFormat(now(),"YYYYMMDD")#</cfoutput>.xml"
						size="60"
				>
			</td>
			<td align="center">
				<input type="submit" value="Upload"
						name="btnUpload" id="btnUpload"
						 onclick="if (document.form1.txtFile.value == '') {alert('Debe Archivo XML'); return false;}"
				>
				</td>
		</tr>
	</table>
</form>
</body>