<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
		document.form1.CumpleHasta.value = '';
	}
</script>
<cfoutput>
	<form method="get" name="form1" action="EmpleInactivos-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_EmpleadosInactivos"
								Default="Empleados Inactivos"
								returnvariable="LB_EmpleadosInactivos"/> 
								
								<cf_web_portlet_start border="true" titulo="#LB_EmpleadosInactivos#" skin="info1">
									<div align="justify">
									  <p>
									  <cf_translate  key="LB_EnEsteReporteMuestraUnaListaDeEmpleadosInactivosAHoyOPorFecha">
									  En &eacute;ste reporte 
									  muestra una lista de empleados inactivos a hoy o por fecha. El filtro de fecha desde, si se utiliza sacará los inactivos a esa fecha. Se ordena por: Centro Funcional y fecha.
									  </cf_translate>
									  </p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						
						
					  <tr>
						<td><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   
						<tr>
							<td align="left" nowrap>
							  	<cf_rhcfuncional tabindex="1">
							</td>
							<td align="center">&nbsp;</td>
							<td align="center">
								
							</td>
						</tr>
												
						<tr>
						  <td><strong><cf_translate  key="LB_FechaHasta">Fecha Hasta</cf_translate>:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>

								<cf_sifcalendario tabindex="2" name="CumpleHasta" value="#fecha#">
							</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
						  <td><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<select name="formato" tabindex="3">
                                	<option value="FlashPaper"><cf_translate  key="CMB_FlashPaper">FlashPaper</cf_translate></option>
                                	<option value="pdf"><cf_translate  key="CMB_PDF">PDF</cf_translate></option>
                                	<!--- <option value="Excel"><cf_translate  key="CMB_Excel">Excel</cf_translate></option> --->
                              	</select>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>																						
						<tr>
							<td align="center" colspan="3">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Generar"
								Default="Generar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Generar"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Limpiar"
								Default="Limpiar"
								XmlFile="/rh/generales.xml"
								returnvariable="BTN_Limpiar"/>

							
							
							<input type="submit" value="#BTN_Generar#" name="Reporte" tabindex="4">
							<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="5" onClick="javascript:limpiar();"></td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
