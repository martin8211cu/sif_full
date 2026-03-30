<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfset _user_info = sec.infoUsuario("","",1)>
<cfset _password = 'secret'>
<cfset hostname = session.sitio.host>

<cfinclude template="../mailbody.cfm">
<!---
<cfoutput>#sec.__mail_preview2(1,'secret')#</cfoutput>
--->

</body>
</html>
