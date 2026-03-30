<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>

<body>
	<cfset padre = ArrayNew(1)>
	
	<cfloop index="i" from="1" to="10">
		<cfset hijo = ArrayNew(1)>
		<cfset hijo[1] = i*2 >
		<cfset hijo[2] = i*2 +1 >
		<cfset hijo[3] = i*2 +2 >
		<cfset padre[i] = hijo >
	</cfloop>
	

	<cfdump var="#padre#">
<!---	<cfdump var="#padre[5][3]#">
	--->
	
	<cfloop index="i" from="1" to="#ArrayLen(padre)#">

		<cfdump var="#padre[i][1]#">
		<cfdump var="#padre[i][2]#">		
		<cfdump var="#padre[i][3]#">
		<br>
	</cfloop>
</body>
</html>
