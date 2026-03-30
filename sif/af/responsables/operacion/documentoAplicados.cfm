<!--- 
	Registro de Documentos de Responsabilidad. Este proceso también existe en Autogestión 
	por lo que se debe definir Lvar_Autogestion en falso para los documentos que se incluyen
	los cuales son incluidos también desde el archivo de autogestion, el sql debe recibir 
	siempre la variable que indique para que archivo devolverse, si para el de autogestión o 
	para este, pero cuando no la reciba por defecto siempre debe volver a este archivo.
	
	Lvar_Autogestion por defecto en falso para la pantalla de control de responsables 
--->

<cfset Lvar_Autogestion = false>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfset Titulo="Recuperación de Documentos Aplicados">
<cf_templateheader title="#Titulo#">
	<cf_web_portlet_start titulo="#Titulo#">
		<cfflush interval="32">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("url.CRDRid") and len(trim(url.CRDRid))>
			<cfset Form.CRDRid = url.CRDRid>
		</cfif>
		<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
			<cfset Form.btnNuevo = url.btnNuevo>
		</cfif>
		<cfif isdefined("Form.CRDRid") and len(trim(Form.CRDRid))>
			<cfinclude template="documentoAplicados-form.cfm">
		<cfelse>
			<cfinclude template="documentoAplicados-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>