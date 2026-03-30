<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body><!---
<h2>Web Service</h2>
<cftry>
<cfinvoke 
 webservice="http://10.7.7.30:8180/isbDB_myproc/services/SOAPHandler/HTTPTransport/urn~3Amycompany~3A/MyUOWorkSpace1/Services/isbDB_myproc/isbDB_myproc?wsdl"
 method="myproc">
	<cfinvokeargument name="t" value="por web svc"/>
	<cfinvokeargument name="RETURN_VALUE" value="enter_value_here"/>
	<cfinvokeargument name="updateCounts" value="enter_value_here"/>
	<cfinvokeargument name="warnings" value="enter_value_here"/>
</cfinvoke>
<cfcatch type="any">
	<cfoutput>#cfcatch.Message# #cfcatch.Detail#</cfoutput>
</cfcatch>
</cftry>
invoqu&eacute; web service.<br />
--->
<hr />
<h2>JMS</h2>
<cftry>
<cfset data = StructNew()>
<cfset data.status = 'SEND'>
<!---<cfset data.topic = 'ISB_TOPIC'>--->
<cfset data.topic = 'UO5_ISB_QUEUE'>
<cfset data.id = Right(GetTickCount(), 5)>
<cfset data.message = '<?xml version="1.0" encoding="UTF-8"?><msg xmlns="http://www.soin.net/isb/prueba1/uo5/chunche"><texto>Hola, Mundo!</texto><color>VERDE</color></msg>'>
<cfset data.asBytes = 'no'>

<cfset SendGatewayMessage('isb in', data)>
<cfcatch type="any">
	<cfoutput>#cfcatch.Message# #cfcatch.Detail#</cfoutput>
</cfcatch>
</cftry>
<cfoutput>Mensaje #data.id# enviado por JMS</cfoutput>
<hr />
</body>
</html>
