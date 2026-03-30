<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<cfhttp url="/minisitio/prueba.txt" method="get">
	</cfhttp>
	<cfdump var="#cfhttp#">
	<cfoutput>
	<pre>
		#cfhttp.FileContent#
	</pre>
	</cfoutput>
</body>
</html>
