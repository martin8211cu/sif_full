<cfif Not IsDefined('Request.TemplateCSS')>
	<cfset Request.TemplateCSS = true>
	<!----- fcastro 2014-12-02 , se debe indicar la direccion completa del server para evitar el problema de la descarga del css---->
	<cfset fullUrlPath = 'http://'><cfif findnocase('HTTPS',ucase(cgi.SERVER_PROTOCOL))><cfset fullUrlPath = 'https://'></cfif>
	<cfset fullUrlPath&=cgi.HTTP_HOST & cgi.CONTEXT_PATH>

	<cfif isdefined('session.sitio.css')>
		<cfif isdefined('form.btnDownload')>
			<cfinclude template="templatecssreport.cfm">
		<cfelseif isdefined('Attributes.skin')>
			<cfoutput><link href="#Evaluate('session.sitio.skin'&Attributes.skin)#" rel="stylesheet" type="text/css"></cfoutput>
    	<cfelse>
			<cfhtmlhead text='<link href="#fullUrlPath##session.sitio.css#" rel="stylesheet" type="text/css">'>
		</cfif>
	</cfif>
	<cfif not isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>