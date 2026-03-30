<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Relaci&oacute;n de C&aacute;lculo de N&oacute;mina" VSgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

                      
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#nombre_proceso#" >
					<cfset regresar = "RelacionCalculo-lista.cfm">				
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">						
						<tr valign="top"> 
							<td align="center">
								<cfinclude template="ResultadoCalculo-listaForm.cfm">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>