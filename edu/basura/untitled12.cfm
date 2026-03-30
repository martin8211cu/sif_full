<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<cfset Session.Idioma = "ES_CR">
	<cfoutput>#Request.Translate('RptProgTit01','','/cfmx/edu/Utiles/Reportes.xml','#Session.Idioma#')#</cfoutput>
</body>
</html>
