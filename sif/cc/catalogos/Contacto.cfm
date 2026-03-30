<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_web_portlet_start titulo="Registro Contacto">
	<cfinclude template="Contacto_form.cfm">
<cf_web_portlet_end>
