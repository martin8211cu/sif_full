<cf_templateheader title="Preparaci&oacute;n de Solicitudes de Anticipo"> 
	<cf_navegacion name="Config" navegacion="">	  
		<cfset titulo = 'Configuraci&oacute;n de Parametros de Caja Chica'>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			 <cfinclude template="CCHconfig_form.cfm">			
	  	<cf_web_portlet_end>
<cf_templatefooter>
