<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="Activos por Factura">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>Activos por Factura</cfoutput>">
			<br />
			<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top">
					<table width="90%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="300">
								<cf_web_portlet_start border="true" titulo="Consulta de Activos por Factura" skin="info1">
									<p align="justify"> En esta consulta se muestra la informaci&oacute;n de todos los activos según la placa, empleado responsable,
											n&uacute;mero de serie o n&uacute;mero de factura solicitado. Este reporte
											se puede generar en formato xls-,
											mejorando su presentaci&oacute;n y aumentando as&iacute; su utilidad
											y eficiencia en el traslado de datos.
									</p>
								<cf_web_portlet_end>
						   </td>
						</tr>
				  </table>
				</td>
				<td valign="top">
					<form name="form1" method="post" action="activosPorFactura_sql.cfm">
						<table>
							<tr>
								<td align="left" valign="baseline" nowrap><strong>Placa:</strong></td>
								<td align="left" valign="baseline" nowrap><cf_sifactivo name="placa" tabindex="1" permitir_retirados="true"></td>
							</tr>
														<tr>
								<td valign="baseline" nowrap><strong>Responsable:</strong></td>
								<td valign="baseline" nowrap>
									<cf_conlis title="LISTA DE EMPLEADOS"
									campos = "DEid, DEidentificacion, DEnombreTodo"
									desplegables = "N,S,S"
									modificables = "N,S,N"
									size = "0,8,25"
									asignar="DEid, DEidentificacion, DEnombreTodo"
									asignarformatos="S,S,S"
									tabla="DatosEmpleado"
									columnas="DEid, DEidentificacion, DEnombre +' '+ DEapellido1 +' '+ DEapellido2 as DEnombreTodo,DEnombre,DEapellido1,DEapellido2"
									filtro="Ecodigo = #Session.Ecodigo#"
									desplegar="DEidentificacion, DEnombre,DEapellido1,DEapellido2"
									etiquetas="Identificacin,Nombre,DEapellido1,DEapellido2"
									formatos="S,S,S,S"
									align="left,left,left,left"
									showEmptyListMsg="true"
									EmptyListMsg=""
									form="form1"
									name="responsable"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="DEidentificacion,DEnombre,DEapellido1,DEapellido2"
									index="1"
									fparams="DEid"/>
								</td>
							</tr>
							<tr>
								<td valign="baseline" nowrap><strong>Numero de Serie:</strong></td>
								<td valign="baseline" nowrap><input type="text" name="numSerie" id="numSerie" size="%50"/></td>
							</tr>
							<tr>
								<td valign="baseline" nowrap><strong>Factura:</strong></td>
								<td valign="baseline" nowrap><input type="text" name="factura" id="factura" size="%50"/></td>
							</tr>
						</table>
						<br />
						<table>
						</table>
						<br />
						<table>
							
						</table>
						<br />
						<table>
							
						</table>
						<br />
						<cf_botones values="Consultar" tabindex="1">
					</form>
				</td>
			  </tr>
		  </table>
		  <cf_qforms>
		  <script language="javascript">
			<!--
				//validaciones con qforms
				//requiere el Aid
				objForm.Aid.description="Placa";
				objForm.Periodoini.description="Periodo Inicial";
				objForm.Periodofin.description="Periodo Final";
				objForm.Aid.required=true;
				function _validatePeriodos(){
					var vp1 = objForm.Periodoini.getValue();
					var vp2 = objForm.Periodofin.getValue();
					if (vp1>0&&(vp1<1900||vp1>2100)) objForm.Periodoini.throwError("El valor el Periodo Inicial debe ser mayor que 1900 y menor que 2100, o lo puede dejar en 0 inidicando que desea todos.");
					if (vp2>0&&(vp2<1900||vp2>2100)) objForm.Periodofin.throwError("El valor el Periodo Final debe ser mayor que 1900 y menor que 2100, o lo puede dejar en 0 inidicando que desea todos.");
				}
				objForm.onValidate=_validatePeriodos;
			-->
		  </script>
		  <br />
		<cf_web_portlet_end>
	<cf_templatefooter>
