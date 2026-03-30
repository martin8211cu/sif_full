<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="Consulta de Configuraci&oacute;n Contable" 
returnvariable="LB_titulo"/>



<cf_templateheader title="#LB_titulo#"> 
	 <cf_web_portlet_start border="true" titulo="#LB_titulo#" skin="#Session.Preferences.Skin#">
			<br/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td width="1%">&nbsp;</td>
				<td width="40%" valign="top">
					<cf_web_portlet_start tipo="mini" titulo="Ayuda" tituloalign="left" wifth="300" height="300">
						<p><h1>
							<cf_translate key="LB_InformacionDetalle">Esta Consulta despliega la informacion de Configuraci&oacute;n Contable actual de la Empresa</cf_translate>
						</p></h1>
					 <cf_web_portlet_end>
				</td>
				<td align="center" valign="top">
					<cfinclude  template="ConsultaConfigContable-Form.cfm">		
				</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>