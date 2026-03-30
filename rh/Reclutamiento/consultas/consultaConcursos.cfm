<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="Consulta de Concursos">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ConsultadeConcursos"
				Default="Consulta de Concursos"
				returnvariable="LB_ConsultadeConcursos"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ConsultadeConcursos#">
					<form name="form1" method="post" action="consultaConcursos-resultado.cfm" style="margin:0;" onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ConsultadeConcursos#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_ReporteInformacionDetalladaDeCursos">
											Esta consulta despliega un listado de personas que participaron y fueron elegibles en un concurso para determinado puesto										</cf_translate>
										.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="100%" align="center" cellpadding="2" cellspacing="0" >
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Curso">Puesto</cf_translate>:&nbsp;</td>
										<td>
										<cf_rhpuesto>
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Fecha" xmlFile="/rh/generales.xml">Fecha</cf_translate>&nbsp;:</td>
										<td>
											<cf_sifcalendario name="fecha">
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
										
											<cfoutput>
												<input type="submit" name="Consultar" value="#BTN_Consultar#" tabindex="1">&nbsp;
												<input type="reset" name="btnLimpiar" value="#BTN_Limpiar#" tabindex="1">
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>		
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	<cfoutput>
	function validar(form){
	var mensaje = '';
	if ( form.RHPcodigo.value == '' ){
	mensaje += ' - <cf_translate key="MSG_CampoCodigoPuestoRequerido">El campo Código de Puesto es requerido</cf_translate>.\n';
	}
	
	if ( mensaje != '' ){
	mensaje = ' <cf_translate key="LB_SePresentaronLosSiguientesErrores" XmlFile="/rh/generales.xml">Se presentaron los siguiente errores</cf_translate>:\n' + mensaje;
	alert(mensaje);
	return false;
	}
	
	return true;
	}
	</cfoutput>
	
</script>