<cfquery name="rsObtieneFechaSQL" datasource="asp">
	select <cf_dbfunction name='now'> as Fecha
</cfquery>

<cfset LvarDiferenciaHor = datediff('h', rsObtieneFechaSQL.Fecha, now())>
<cfset LvarDiferenciaMin = datediff('n', rsObtieneFechaSQL.Fecha, now()) - (LvarDiferenciaHor * 60)>
<cfset LvarDiferenciaSeg = datediff('s', rsObtieneFechaSQL.Fecha, now()) - (LvarDiferenciaHor * 3600) - (LvarDiferenciaMin * 60)>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Verificar la hora del servidor de aplilcaciones y Servidor de Base de Datos</title>
</head>

<body>

	<p>
		<div align="center">
		<span style="FONT-SIZE: 14pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif; color:#666666">
		<strong>ESTIMADO CLIENTE</strong>
		</span>
		</div> 
	</p>

	<p>&nbsp;
		
	</p>


	<p>
		<div align="center">
		<span style="FONT-SIZE: 14pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		La Hora Actual del Servidor de Aplicaciones es:
		</span>
		</div> 
	</p>


	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#DateFormat(now(), "DD/MM/YYYY")# : #TimeFormat(now(), "HH:mm:ss:sss")#</cfoutput>
		</span>
		</div> 
	</p>

	<p>&nbsp;
		
	</p>


	<p>
		<div align="center">
		<span style="FONT-SIZE: 14pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		La Hora Actual del Servidor de Base de Datos es:
		</span>
		</div> 
	</p>

	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#DateFormat(rsObtieneFechaSQL.Fecha, "DD/MM/YYYY")# : #TimeFormat(rsObtieneFechaSQL.Fecha, "HH:mm:ss:sss")#</cfoutput>
		</span>
		</div> 
	</p>


	<p>&nbsp;
		
	</p>


	<p>
		<div align="center">
		<span style="FONT-SIZE: 14pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		Diferencia de Relojes es:
		</span>
		</div> 
	</p>

	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#numberformat(LvarDiferenciaHor, ",9")#:#numberformat(LvarDiferenciaMin, ",9")#:#numberformat(LvarDiferenciaSeg, ",9")#</cfoutput>
		</span>
		</div> 
	</p>.

	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#numberformat(LvarDiferenciaHor, ",9")#</cfoutput> Horas
		</span>
		</div> 
	</p>
	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#numberformat(LvarDiferenciaMin, ",9")#</cfoutput> Minutos
		</span>
		</div> 
	</p>
	<p>
		<div align="center">
		<span style="FONT-SIZE: 16pt; FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif;">
		<cfoutput>#numberformat(LvarDiferenciaSeg, ",9")#</cfoutput> Segundos
		</span>
		</div> 
	</p>


</body>
</html>
