	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Consulta_de_Adelanto_de_Cesantia"
		Default="Consulta de Adelanto de Cesant&iacute;a"
		returnvariable="LB_Titulo"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Consultar"
		Default="Consultar"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Consultar"/>

	<cfoutput>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
						<form name="form1" method="get" action="adelantoCesantia.cfm" style="margin:0;">
							<table width="75%" align="center" cellpadding="2">
								<tr>
									<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Empleado">Empleado</cf_translate>:</strong></td>
									<td><cf_rhempleado></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaDesde">Fecha desde</cf_translate>:</strong></td>
									<td><cf_sifcalendario name="desde"></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaHasta">Fecha hasta</cf_translate>:</strong></td>
									<td><cf_sifcalendario name="hasta"></td>
								</tr>
								<tr>
									<td colspan="2" align="center"><input type="submit" class="btnFiltrar" name="Consultar" value="#LB_Consultar#"></td>
								</tr>
							</table>
						</form>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>
	</cfoutput>