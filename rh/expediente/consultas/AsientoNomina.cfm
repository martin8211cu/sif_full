<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="Asiento de Nómina" 
returnvariable="LB_titulo"/>

<cf_templateheader title="#LB_titulo#"> 
 <cf_web_portlet_start border="true" titulo="#LB_titulo#" skin="#Session.Preferences.Skin#">

			<br/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td width="1%">&nbsp;</td>
				<td width="40%" valign="top">
					<cf_web_portlet_start tipo="mini" titulo="Ayuda" tituloalign="left" wifth="300" height="300">
						<p>
							Este reporte despliega la informacion del Auxiliar Contable de Recursos Humanos, 
							al seleccionar <strong>Resumido</strong> es necesario ingresar el mes y año, 
							si seleccionamos <strong>Detallado</strong> es necesario marcar por centro funcional o por empleado 
							e indicar el tipo de registro.
						</p>
					 <cf_web_portlet_end>
				</td>
				<td align="center" valign="top">
					<cfinclude  template="AsientoNomina-form.cfm">		
				</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>