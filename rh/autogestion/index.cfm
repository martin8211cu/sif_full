<cfparam name="Session.modulo" default="autogestion">
<cfparam name="Session.Idioma" default="">
<cfif isdefined("Form.Idioma")>
	<cfset Session.Idioma = Form.idioma>
</cfif>
<cfset Session.modulo = 'autogestion'>
<cflocation url='/cfmx/plantillas/autogestion/index.cfm' addtoken="no">