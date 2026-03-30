<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
 
<body>
<cfif isdefined("Form")>
	form:<cfdump var="#form#">
</cfif>
oscar:<cfdump var="#form.oscar#">

<br>
	<cfloop index="i" from="1" to="2">
		<cfloop index="j" from="1" to="2">
		<cfoutput>#i# #j# --- #Evaluate("Form.Hola#i#_#j#")#<br></cfoutput>
		</cfloop>
	</cfloop>
<cfabort>
<cflocation url="Fomr1.cfm">
</body>
</html>
