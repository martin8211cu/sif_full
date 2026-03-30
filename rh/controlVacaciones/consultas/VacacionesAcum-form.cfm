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
	}
</script>
<cfoutput>
	<form method="post" name="form1" action="VacacionesAcum-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_VacacionesAcumuladas"
								Default="Vacaciones Acumuladas por Per&iacute;odo"
								returnvariable="LB_VacacionesAcumuladas"/> 
								
								<cf_web_portlet_start border="true" titulo="#LB_VacacionesAcumuladas#" skin="info1">
									<div align="justify">
									  <p>
									  <cf_translate  key="LB_Ayuda">
									  	Este reporte muestra el acumulado de vacaciones por per&iacute;odo.	<br/>
										Indicando a su vez el monto general a pagar<br/> 
										por concepto de vacaciones agrupado por per&iacute;odo 
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
						<td><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   
						<tr>
							<td  colspan="3" align="left" nowrap>
							  	<cf_rhempleado>
							</td>

						</tr>
												
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
