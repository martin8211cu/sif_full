<cf_templateheader title="	Compras">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Importador de Contratos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
				<!----Verificar si esta encendido el parámetro de múltiples contratos---->
				<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
					select Pvalor 
					from Parametros 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
						and Pcodigo = 730 
				</cfquery>
				<form  name="form1" enctype="multipart/form-data"  method="post" action="importar-DContrato.cfm" >
					<table width="100%" border="0">
						<tr>
							<td  valign="top" width="50%">
								<cf_web_portlet_start border="true" titulo="Pasos para la Importación" skin="info1">
									<li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
									<li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
									<li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n..</li><br>
								<cf_web_portlet_end><br><br>
					
								<p><cf_web_portlet_start border="true" titulo="Formato de Archivo de Impresión" skin="info1">
								    El archivo debe ser un archivo plano con el siguiente formato: <br>
								    <br>
								    Separador de columnas: &nbsp; , &nbsp; (coma)<br>
								    Fin de l&iacute;nea: &nbsp; &lt;Enter&gt; &nbsp; (chr(13))<br>
									Si alg&uacute;n campo del archivo viene vacio digite la palabra null <br>
							    <cf_web_portlet_end></p>
								<p><cf_web_portlet_start border="true" titulo="Formato de Archivo de Impresión" skin="info1"><br>
							        <strong>Columnas:</strong><br>
							        <br>
							        1.  Tipo (A - Artículo, S - Servicio) <br>
							        2.  Código del art&iacute;culo o servicio <br>
							        3.  C&oacute;digo de la moneda <br>
							        4.  C&oacute;digo del impuesto <br>
									<cfif rsParametro_MultipleContrato.Pvalor EQ 1>
									5.  Subtotal (Cantidad x precio unitario) <br>
									<cfelse>
							        5.  Monto precio unitario <br>
									</cfif>
							        6.  Monto tipo de cambio <br>
							        7.  Garant&iacute;a en d&iacute;as <br>
							        8.  Descripci&oacute;n (si el campo viene vacio digite el caracter -)<br>
							        9.  Descripci&oacute;n alterna (si el campo viene vacio digite el caracter -)<br>
                                    10. D&iacute;as de entrega<br>
									<cfif rsParametro_MultipleContrato.Pvalor EQ 1>
										11. Unidad de medida <br>
										12. Cantidad (si el campo viene vacio digite el caracter -)<br>
										13. Código del proveedor <br>
									</cfif>
						        <cf_web_portlet_end></p>								<br>
								<br>							
							</td>
							<td  valign="top"width="50%">
								<table width="100%"  border="0">
								  <tr>
									<td   align="center" colspan="2">Importador de los detalles del contrato</td>
								  </tr>								
								  <tr>
									<td  align="right" width="30%">Archivo:</td>
									<td width="70%">
										<input name="archivo" type="file">	
									</td>
								  </tr>
								  <tr>
									<td  colspan="2" align="center" >
										<input type="submit" name="btnRegresar" id="btnRegresar" value="Regresar" onClick="javascipt:deshabilitar();Regresar();">
										<input type="submit" name="btnImportar"  id="btnImportar" value="Importar">
									</td>
								  </tr>
								</table>
								<input  type="hidden" name="ECid"  value="#form.ECid#">	
								<cfif isdefined("Form.ERROR")>
									<cf_web_portlet_start border="true" titulo="Lista de errores (no proceso ningún registro)" skin="info1">
									<cfoutput>#Form.ERROR#</cfoutput>	
									<cf_web_portlet_end>
								</cfif>					
							</td>
						</tr>
					</table>
			</form>
			<cf_qforms>
			<script language="javascript1.2" type="text/javascript">
				function deshabilitar(){
						objForm.archivo.required = false;
				}
				objForm.archivo.required = true;
				objForm.archivo.description="Archivo de importación";	
			
				function Regresar() {
					document.form1.action = 'contratos.cfm';
					document.form1.submit();
				}				
			</script>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>
