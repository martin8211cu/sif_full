<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TituloPreparacionSolicitudesAnticipo" default = "Preparaci&oacute;n de Solicitudes de Anticipo" returnvariable="LB_TituloPreparacionSolicitudesAnticipo" xmlfile = "CCHconfig.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConfiguracionParametrosCajaChica" default = "Configuraci&oacute;n de Parametros de Caja Chica" returnvariable="LB_ConfiguracionParametrosCajaChica" xmlfile = "CCHconfig.xml">


<cf_templateheader title="#LB_TituloPreparacionSolicitudesAnticipo#"> 
	<cf_navegacion name="Config" navegacion="">	  
		<cfset titulo = '#LB_ConfiguracionParametrosCajaChica#'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			 <cfinclude template="CCHconfig_form.cfm">			
	  	<cf_web_portlet_end>
<cf_templatefooter>
