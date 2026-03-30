<!--- Attributes --->
<cfparam name="Attributes.secure"   type="string"  default="yes">
<cfif ListFind('yes,no,login,home',Attributes.secure) is 0>
	<cf_errorCode	code = "50704"
					msg  = "Atributo secure invalido para cf_ssl: @errorDat_1@"
					errorDat_1="#Attributes.secure#"
	>
</cfif>

<cfparam name="Attributes.action"   type="string"  default="redirect">
<cfif ListFind('redirect,check',Attributes.action) is 0>
	<cf_errorCode	code = "50705"
					msg  = "Atributo action invalido para cf_ssl: @errorDat_1@"
					errorDat_1="#Attributes.action#"
	>
</cfif>

<!--- Verificar si es seguro segun ssl_todo y ssl_login --->
<cfif session.sitio.ssl_todo Or (Attributes.secure is 'login' and session.sitio.ssl_login) Or (Attributes.secure is 'home' and session.sitio.ssl_home)>
	<cfset Attributes.secure = 'yes'>
</cfif>
<!--- Adonde esperamos que nos regrese --->
<cfif not IsDefined('session.sitio.ssl_return')>
	<cfset session.sitio.ssl_return = session.sitio.host>
</cfif>

<cfif Attributes.secure is 'yes'>
	<cfset RequiredProtocol = 'https:'>
	<cfset RequiredHostname = session.sitio.ssl_dominio>
<cfelse>
	<cfset RequiredProtocol = 'http:'>
	<cfset RequiredHostname = session.sitio.ssl_return>
</cfif>

<cfif Attributes.action is 'redirect'>
	<cfparam name="Attributes.url"      type="string">
	<cfif Left(Attributes.url,1) NEQ '/' and Len(Attributes.url) Neq 0>
		<cfset Attributes.url = GetDirectoryFromPath(CGI.SCRIPT_NAME) & Attributes.url>
	</cfif>
	<cfif Attributes.secure is 'yes'>
		<cfif Find('?',Attributes.url) Is 0>
			<cfset Attributes.url = Attributes.url & '?'>
		<cfelse>
			<cfset Attributes.url = Attributes.url & '&'>
		</cfif>
		<cfset Attributes.url = Attributes.url & 'ssl_return=#session.sitio.ssl_return#'>
	</cfif>
	<cfset destination = "#RequiredProtocol#//#RequiredHostname##Attributes.url#">
	<cfoutput>
		<html><head><meta http-equiv="refresh" content="0; URL=#destination#">
		<script type="text/javascript">
			location.href = '#JSStringFormat(destination)#';
		</script>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head></html>
	</cfoutput>
	<cfabort><!---
	<cfif Attributes.secure is 'yes'>
		<cflocation url = "#destination#" addtoken="no">
	<cfelse>
		<cfoutput>
		<html><head><meta http-equiv="refresh" content="0; URL=#destination#">
		<script type="text/javascript">
			location.href = '#JSStringFormat(destination)#';
		</script>
		</head></html>
		</cfoutput>
		<cfabort>
	</cfif>--->
<cfelseif Attributes.action is 'check'>
	<cfoutput>
		<script type="text/javascript">
		<!--
			if (location.protocol != '#JSStringFormat(RequiredProtocol)#' || location.hostname != '#JSStringFormat(RequiredHostname)#') {
				location.href = '#JSStringFormat(RequiredProtocol)#//#JSStringFormat(RequiredHostname)##JSStringFormat(CGI.SCRIPT_NAME)#';
			}
		//-->
		</script>
	</cfoutput>
</cfif>


