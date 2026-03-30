	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDePuestos"
	Default="Consulta de Puestos"
	returnvariable="LB_ConsultaDePuestos"/>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ConsultaDePuestos#'>		
		<cfoutput>
		<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		<form method="post" action="../catalogos/PuestosReport.cfm" name="form1" onSubmit="return Valida()">
			<input name="bandera" type="hidden">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>				
				<tr>
					<td width="42%" align="right" nowrap>
						<strong>
							<cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;
						</strong>
					</td>
					<td width="58%" >
						<cf_rhpuesto tabindex="1">
					</td>
				</tr>
				<tr>
					<td align="right"><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
					<td><cf_rhcfuncional form="form1" codigosize='15' size='40' tabindex="1"></td>
				</tr>
				<tr>
					<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
					<td>
						<select name="formato" tabindex="1">
							<option value="FlashPaper">FlashPaper</option>
							<option value="pdf">Adobe PDF</option>
							<option value="HTML">HTML</option>
						</select>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
				  <td colspan="2" align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Consultar"
						Default="Consultar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Consultar"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>

				  	<input type="submit" class="btnFiltrar" name="Consultar" value="#BTN_Consultar#"  id="Consultar" tabindex="1">
					<input type="button"class="btnlimpiar" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: limpiar();" tabindex="1">
				</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<!--- <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>
			<input type="hidden" name="#BTN_Regresar#" value="/rh/admin/consultas/ReportePuestos.cfm" >  --->
			
		 </form>
		 </cfoutput>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DebeSeleccionarUnPuestoParaConsultar"
			Default="Debe seleccionar un puesto para consultar"
			returnvariable="MSG_DebeSeleccionarUnPuestoParaConsultar"/>
		<script language="JavaScript" type="text/javascript">		 
			function Valida(){		
				if(document.form1.RHPcodigo.value == ''){
					alert("<cfoutput>#MSG_DebeSeleccionarUnPuestoParaConsultar#</cfoutput>");
					return false;
				}
			}
			function limpiar(){
				document.form1.RHPcodigo = '';
			}
		</script>	
		<cf_web_portlet_end>
	<cf_templatefooter>	
