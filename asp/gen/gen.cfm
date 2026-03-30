<cfinclude template="env.cfm" >

<cfparam name="url.code" default="">
<cfparam name="url.path" default="">
<cfparam name="url.pack" default="">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head><title>Generacion de SQL</title>
<link href="gen.css" rel="stylesheet" type="text/css" /></head>
<body>

<h1>Resultado de la generacion</h1>
<cfoutput>
<table border="0" >
<!-- Informar datos generales -->
<tr><td>Tabla</td><td>#HTMLEditFormat(url.code)#</td></tr>
<tr><td>Directorio</td><td>#HTMLEditFormat(session.pdm.path)#</td></tr>

</table></cfoutput>

<br />
	<cfinclude template="gencfm.cfm" />
</body></html>

</jsp:root>