<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Correo generado autom&aacute;ticamente por el Sistema de Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfoutput>
	<p> El traslado registrado por un monto de #LSCurrencyFormat(Lvar_MontoOrigen,'none')# fue rechazado por el Centro Funcional
	#Lvar_CFrechazo# por #Lvar_nombrerechazo#.</p>
	<p>
		<strong>Razón de Rechazo&nbsp;:&nbsp;</strong>#form.CPDEmsgrechazo#
	</p>
	<p> Este mensaje es generado autom&aacute;ticamente por el sistema de Presupuesto. Por favor no responda a este mensaje. </p>
</cfoutput>
</body>
</html>
