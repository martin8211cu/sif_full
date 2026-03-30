<cfparam name="url.uri" default="/cfmx/home/index.cfm">
<cfif Not IsDefined('acceso_uri')>
    <cfinclude template="/home/check/acceso_uri.cfm">
</cfif>
<cfif isdefined('session.sitio.login') and session.sitio.login NEQ '/home/public/login.cfm' and Len(Trim(session.sitio.login)) NEQ 0 and FileExists(ExpandPath(session.sitio.login)) and acceso_uri(session.sitio.login)>
	<cfif IsDefined("url.errormsg")>
		<cflocation url='/cfmx#session.sitio.login#?uri=#url.uri#&errormsg=#url.errormsg#' addtoken="no">
	<cfelse>
		<cflocation url='/cfmx#session.sitio.login#?uri=#url.uri#' addtoken="no">
	</cfif>
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Login
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">


<link href="login.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="login.js">//</script>

<cfinclude template="login-form.cfm">

</cf_templatearea>
</cf_template>
