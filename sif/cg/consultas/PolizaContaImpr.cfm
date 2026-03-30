
<html>
<head>
<title>Balance General</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<cfif isdefined("url.IDcontable") and not isdefined("form.IDcontable") >
	<cfset form.IDcontable = url.IDcontable >
</cfif>
<cfif isdefined("url.Tabla") and not isdefined("form.Tabla") >
	<cfset form.Tabla = url.Tabla >
</cfif>
<cfinclude template="formPolizaConta.cfm">
</body>
</html>
