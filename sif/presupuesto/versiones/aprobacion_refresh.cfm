<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Avance de la Aprobacion</title>
</head>
<body onLoad="setTimeout('window.location.reload()',2*1000);">
<cfif isdefined("url.MesesAnt")>
	<cfset request.CFaprobacion_MesesAnt = true>
</cfif>

<cfparam name="session.CFaprobacion.Avance" default="0">
<cfparam name="session.CPresupuestoControl.Avance" default="0">
<cfparam name="session.CFaprobacion.Total" default="0">
<cfparam name="session.CPresupuestoControl.Total" default="0">
<cfdump var="#session.CFaprobacion#">

<cfif session.CFaprobacion.Paso LT 8>
	<cfset LvarAvance8 = "0">
<cfelseif session.CFaprobacion.Paso EQ 8>
	<cfif session.CPresupuestoControl.Avance NEQ 0>
		<cfset LvarAvance50 = "#NumberFormat(round(session.CPresupuestoControl.Avance/session.CPresupuestoControl.Total*10000)/100,"0.00")#">
	<cfelse>
		<cfset LvarAvance50 = "0">
	</cfif>
<cfelse>
	<cfset LvarAvance50 = "100">
</cfif>
<cfoutput>
<script language="javascript">
<cfif session.CFaprobacion.Paso LT 0>
	<cfset LvarAvance=0>
<cfelseif session.CFaprobacion.Paso GTE 9>
	<cfset LvarAvance=100>
<cfelse>
	<cfset LvarAvance=NumberFormat(round(session.CFaprobacion.Paso/9*100),"0.00")>
</cfif>
window.parent.document.getElementById("Paso").value = "AVANCE #LvarAvance#% <cfif session.CFaprobacion.Paso GTE 1 and session.CFaprobacion.Paso LTE 9>(PASO #session.CFaprobacion.Paso# de 9)</cfif>";
window.parent.document.getElementById("spnAvance").style.width = " " + "#LvarAvance#%";
<cfloop index="i" from="0" to="9">
	<cfif i LT session.CFaprobacion.Paso>
		<cfif i EQ 50>
			window.parent.document.getElementById("Paso#i#").value = "TERMINADO (#session.CPresupuestoControl.Total# de #session.CPresupuestoControl.Total#)";
		<cfelse>
			window.parent.document.getElementById("Paso#i#").value = "TERMINADO";
		</cfif>
	<cfelseif i EQ session.CFaprobacion.Paso>
		<cfif session.CFaprobacion.Paso EQ 50>
			window.parent.document.getElementById("Paso#i#").value = "PROCESANDO... #LvarAvance8#% (#session.CPresupuestoControl.Avance# de #session.CPresupuestoControl.Total#)";
		<cfelse>
			window.parent.document.getElementById("Paso#i#").value = "<< PROCESANDO >>";
		</cfif>
	<cfelse>
		window.parent.document.getElementById("Paso#i#").value = "-";
	</cfif>
</cfloop>
</script>			
<cfif session.CFaprobacion.Paso EQ 10>
	<script language="javascript">
		parent.location.href="cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=<cfoutput>#abs(LvarNAP)#</cfoutput>";
	</script>
<cfelseif session.CFaprobacion.Paso EQ 11>
	<cfif isdefined("request.CFaprobacion_MesesAnt")>
		<cfset LvarCFM = "aprobacion_MesesAnt.cfm">
	<cfelse>
		<cfset LvarCFM = "aprobacion.cfm">
	</cfif>
	<script language="javascript">
		alert("La Aprobación de la Version terminó con éxito");
		parent.location.href="#LvarCFM#";
	</script>
<cfelseif session.CFaprobacion.Paso EQ -1>
	<cfset Request.ErrorId = session.CFaprobacion.ErrorId>
	<cfset Request.Error.Backs = 1>
	<cfinclude template="/home/public/error/display.cfm">
</cfif>
</cfoutput>
</body>
</html>
