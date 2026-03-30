<cf_templateheader title="Compras">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aprobación de Exceso de Tolerancia en Documentos de Recepción'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
			</tr>
			<tr>
				<td>
					<cfinclude template="docsAprobarExcTolerancia-config.cfm">
					<table width="99%" cellpadding="0" cellspacing="0" align="center">
						<!--- Encabezado del documento de recepción --->
						<tr>
							<td class="subTitulo" align="center"><font size="2">Encabezado de Documentos de Recepción</font></td>
						</tr>
						<tr>
							<td align="center"><cfinclude template="docsAprobarExcTolerancia-form.cfm"></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
						<!--- Detalle del documento de recepción --->
						<tr>
							<td class="subTitulo" align="center"><font size="2">Detalle de Documentos de Recepción</font></td>
						</tr>
						<tr>
							<td align="center"><cfinclude template="docsAprobarExcTolerancia-listadet.cfm"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/sinbotones.js"></script>
		<script language="javascript1.2" type="text/javascript">
			//Función para regresar a la lista
			function funcRegresar()
			{
				location.href = 'docsAprobarExcTolerancia-lista.cfm';
			}
			
			//Función para abrir una pantalla de observaciones. Recibe el nombre del formulario, del input
			//y otro parámetro para indicar si la pantalla guarda los cambios en el input original o es solo de lectura
			function info(nombreForm, nombreInput, guardar)
			{
				paramsURL = "?nombreForm=" + nombreForm + "&nombreInput=" + nombreInput + "&guardar=" + guardar;
				open('docsAprobarExcTolerancia-info.cfm' + paramsURL, 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>
