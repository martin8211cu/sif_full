<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Correo generado autom&aacute;ticamente por el Sistema de Presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--- Requiere 
	Lvar_nombrefrom, 
	Lvar_CFOrigen, 
	Lvar_CFDestino, 
	Lvar_MontoOrigen, 
	Lvar_ruta --->
<cfparam name="Lvar_nombrefrom" type="string">
<cfparam name="Lvar_CFOrigen" type="string">
<cfparam name="Lvar_CFDestino" type="string">
<cfparam name="Lvar_MontoOrigen" type="numeric">
<cfparam name="Lvar_ruta" type="string" default="http://#session.sitio.host#/cfmx/sif/presupuesto/operacion/traslado-aprobacion-lista.cfm?seleccionar_Ecodigo=#session.Ecodigo#">
</head>
<body>
<cfoutput>
	<p> El traslado registrado por un monto de #LSCurrencyFormat(Lvar_MontoOrigen,'none')# se asigno al Centro Funcional
	#Lvar_CFOrigen# a los siguientes funcionarios para que realicen la correspondiente aprobación:
	<ul>
		<cfloop query="rsAprobadores">
			<li>#nombre#</li>
		</cfloop>
	</ul>
	</p>
	<p> Este mensaje es generado autom&aacute;ticamente por el sistema de Presupuesto. Por favor no responda a este mensaje. </p>
</cfoutput>
</body>
</html>
