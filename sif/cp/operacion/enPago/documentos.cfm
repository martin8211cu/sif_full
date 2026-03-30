<cfset LvarRoot= listLast(CGI.SCRIPT_NAME,"/")>
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cf_navegacion name="CPCid">
		<cfif isdefined("form.CPCid") and len(trim(form.CPCid)) or (isdefined("form.btnNuevo"))  or(isdefined('url.Nuevo')) or (isdefined("form.Nuevo"))
		>
			<cfinclude template="documentos_form.cfm">
		<cfelse>
			<cfinclude template="documentos_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>	
