<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfoutput>
		#GetTemplatePath()#<br>
		#GetDirectoryFromPath(GetTemplatePath())#<br>
		#ExpandPath("/")#<br>
		#len(ExpandPath("/"))#<br>
<strong>		#Replace(GetDirectoryFromPath(CGI.SCRIPT_NAME),'/cfmx','')#<br>
</strong>		#GetBaseTemplatePath()#<br>
	</cfoutput>
	<cfdump var="#cgi#">
</body>
</html>
