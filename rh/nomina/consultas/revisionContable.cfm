<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>Recursos Humanos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

		<style type="text/css">
			.empresa{ font-weight:bold; font-size:16px; font-family:Arial, Helvetica, sans-serif; }
			td{	font-family:Arial, Helvetica, sans-serif; font-size:12px;}
			.tituloListas { background-color:#f5f5f5; font-weight:bold; font-size:12px; font-family:Verdana, Arial, Helvetica, sans-serif; }
			.titulo { font-weight:bold; font-size:14px; font-family:Arial, Helvetica, sans-serif; }
		</style>
	</head>
	
	<body>
		<cf_navegacion name="RCNid" navegacion="">
		
		<cfset paramsuri = ArrayNew (1)>
		<cfset ArrayAppend(paramsuri, 'RCNid=' & URLEncodedFormat(form.RCNid))>

		<cfinclude template="revisionContable-form.cfm">
	</body>
</html>

