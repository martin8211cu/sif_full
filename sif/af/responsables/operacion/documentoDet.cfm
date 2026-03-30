<!--- Registro de Documentos de Responsabilidad Este proceso también existe en Autogestión por lo que se debe definir  
Lvar_Autogestion en falso para los documentos que se incluyen los cuales son incluidos también desde el archivo de 
autogestion, el sql debe recibir siempre la variable que indique para que archivo devolverse, si para el de autogestión o 
para este, pero cuando no la reciba por defecto siempre debe volver a este archivo. --->
<!--- Lvar_Autogestion por defecto en falso para la pantalla de control de responsables --->
<cfset Lvar_Autogestion = false>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinclude template="documento-Translate.cfm">
<cf_templateheader title="Inclusión de Documentos">
    <cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Inclusión de Documentos">
	
       <cf_navegacion name="CRDRid">
		<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
			<cfset Form.btnNuevo = url.btnNuevo>
		</cfif>
		<cfset params=''>
		<cfif isdefined("url.CRDRdocori") and len(trim(url.CRDRdocori))>
			<cfset Form.CRDRdocori=url.CRDRdocori>
		</cfif>
		
		<cfif isdefined("Form.CRDRdocori") and len(trim(Form.CRDRdocori)) or
				isdefined("Form.btnNuevo") and len(trim(Form.btnNuevo))>
			<cfinclude template="documentoDet-form.cfm">
		<cfelse>
			<cfinclude template="documentoDet-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>