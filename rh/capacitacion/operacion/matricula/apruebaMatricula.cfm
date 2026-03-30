<!---Esta opción se habilita si se marca el parametro 2109-ParamRH>Modulos>CapayDesa>Activar aprobación de matricula--->
<!------>
<!---<cfset LvarSAporEmpleado=true>--->

<cf_templateheader title="Aprobación de Matricula"> 

 <cf_web_portlet_start border="true" titulo="Aprobación de Matricula" skin="#Session.Preferences.Skin#">
		<cfinclude template="aprobacionMatricula-lista.cfm">
  <cf_web_portlet_end>
<cf_templatefooter>
	

