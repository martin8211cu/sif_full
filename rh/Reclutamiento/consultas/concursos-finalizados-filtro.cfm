<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConcursosFinalizados"
	Default="Concursos Finalizados"
	returnvariable="LB_ConcursosFinalizados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concurso"
	Default="Concurso"
	returnvariable="LB_Concurso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ConcursosFinalizados#">
					<form name="form1" method="get" action="concursos-finalizados.cfm">
					<cfoutput>
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center">
								<cf_web_portlet_start border="true" titulo="#LB_ConcursosFinalizados#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p><cf_translate key="AYUDA_EstaConsultaMuestraUnListadoDeLosConcursosFinalizados">Esta consulta muesta un listado de los concursos finalizados.  
										Si desea consultar un concurso espec&iacute;fico seleccionelo, si no selecciona un concurso la consulta mostrar&aacute; todos los concursos finalizados.</cf_translate></p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td width="10%" align="right" >#LB_Concurso#:&nbsp;</td>
										<td ><cf_rhconcursos></td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
										<td colspan="2" align="center"><input type="submit" name="Consultar" value="#BTN_Consultar#"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</cfoutput>
					</form> 
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>