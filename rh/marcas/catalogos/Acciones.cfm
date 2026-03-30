
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Acciones a Seguir"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<script language="JavaScript" type="text/JavaScript">
</script>
  <cfinclude template="/rh/Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfinclude template="Acciones-form.cfm">
				<cf_web_portlet_end>				
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	