<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prueba del servidor de correos</title>
</head>

<body>


<cfset host = "205.160.173.19">
<cfset host = "mexexchclt">
<cfset host = "148.243.230.158">

<!--- <cfset from = "aramirezv@pmicim.com"> --->
<cfset from = "servicedesk@pmicim.com">
<cfset to = "danim@soin.co.cr">
<!--- <cfset to = "danim@soin.co.cr"> --->

<cfoutput>
Server: #host#<br />
From: #from#<br />
To: #to#<br />
</cfoutput>
Enviando...<br />


<br />

<cfflush>

<cfmail server="#host#" from="#from#" to="#to#" subject="Prueba" spoolenable="no" debug="yes" >
Esto es una prueba
</cfmail>

<cfoutput>
ok<br />

</cfoutput>


</body>
</html>
