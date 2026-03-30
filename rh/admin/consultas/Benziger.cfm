	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConsultaDeDesviacionBenziger"
			Default="Consulta de Desviación Benziger"
			returnvariable="LB_ConsultaDeDesviacionBenziger"/>	
			
		<cf_web_portlet_start titulo="#LB_ConsultaDeDesviacionBenziger#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<form name="form1" method="post" action="BenzigerRep.cfm">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
				  <tr>
				    <td width="50%" rowspan="5" align="center" valign="top">
						<cf_web_portlet_start border="true" titulo="Desviaci&oacute;n Benziger" skin="info1">
							<div align="justify">
								<p> 
								<cf_translate key="LB_MuestraLaDesviacionQuePresentaElColaboradorConRespectoALaToleranciaDefinidaParaLaUbicacionDeLasHabilidadesEnElPerfilDelPuesto">
								Muestra la desviaci&oacute;n que presenta el colaborador 
								con respecto a la tolerancia definida para la ubicaci&oacute;n de las 
								habilidades en el perfil del puesto
								</cf_translate>
								</p>
							</div>
						<cf_web_portlet_end>
					</td>
					<td colspan="2">&nbsp;</td>
		          </tr>
				  <tr>
					<td align="right" class="fileLabel"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
					<td>
						<cf_rhpuesto tabindex="1">
					</td>
				  </tr>
				  <tr><td colspan="2">&nbsp;</td></tr>
				  <tr>
					<td colspan="2" align="center" class="fileLabel">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Consultar"
							Default="Consultar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Consultar"/>
						<input name="btnConsultar" type="submit" id="btnConsultar" tabindex="1" value="<cfoutput>#BTN_Consultar#</cfoutput>">
					</td>
		          </tr>
				  <tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>	
