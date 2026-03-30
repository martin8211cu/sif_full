

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Asiento de Acumulacion de Cesant&iacute;a" skin="#Session.Preferences.Skin#"> 
					<form name="form1" method="get" action="asientoAcumulacion.cfm" onSubmit="javascript: return validar();">
					<table width="100%">
						<tr>
				    		<td width="16%" align="right" nowrap> <strong><cf_translate xmlfile="/rh/generales.xml"  key="LB_CalendarioDePago">Calendario de Pago</cf_translate>:</strong></td>							
							<td>
								<cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true">
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:</strong></td>
							<td>
								<cf_rhempleado size="80" tabindex="1"> 
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<input type="submit" name="Reporte" value="Reporte" >
							</td>
						</tr>
					</table>
					</form>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
	
	<script language="javascript1.2" type="text/javascript">
		function validar(){
			if( document.form1.CPid.value == '' ){
				alert('Se presentaron los siguientes errores:\n - El Calendario de Pagos es requerido.')
				return false;
			}
			return true;
		}
	</script> 
	
<cf_templatefooter>