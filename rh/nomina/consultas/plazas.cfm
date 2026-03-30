<!---
<cfset form.CFpkdesde = 603 >
<cfset form.CFpkhasta = 1 >
<cfset form.mostrarplazas = 'O' >
<cfset form.desplegarnombre = 'NA' > <!--- AN,NA--->
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title> <cf_translate  key="LB_Reporte_de_Empleado_por_Plaza">Reporte de Empleado por Plaza</cf_translate></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<!---<cf_templatecss>--->
	
	<style type="text/css" >
		.empresa{font-size:18px;}
		.reporte{font-size:16px;}
		.tituloListas {	font-weight: bolder;
						vertical-align: middle;
						padding: 2px; background-color:#f5f5f5 }		
		td{ font-size:12px; font-family:Arial, Helvetica, sans-serif;}
	</style>
	
</head>

<body>
<!---
<cf_navegacion name="CFpkdesde" navegacion="">
<cf_navegacion name="CFpkhasta" navegacion="">
<cf_navegacion name="mostrarplazas" navegacion="">
<cf_navegacion name="desplegarnombre" navegacion="">

<cfset paramsuri = ArrayNew (1)>
<cfset ArrayAppend(paramsuri, 'CFpkdesde='         & URLEncodedFormat(form.CFpkdesde))>
<cfset ArrayAppend(paramsuri, 'CFpkhasta='         & URLEncodedFormat(form.CFpkhasta))>
<cfset ArrayAppend(paramsuri, 'mostrarplazas='         & URLEncodedFormat(form.mostrarplazas))>
<cfset ArrayAppend(paramsuri, 'desplegarnombre='         & URLEncodedFormat(form.desplegarnombre))>
--->

<cfif isdefined("url.CFpkdesde") and not isdefined("form.CFpkdesde")>
	<cfset form.CFpkdesde = url.CFpkdesde >
</cfif>
<cfif isdefined("url.CFpkhasta") and not isdefined("form.CFpkhasta")>
	<cfset form.CFpkhasta = url.CFpkhasta >
</cfif>
<cfif isdefined("url.mostrarplazas") and not isdefined("form.mostrarplazas")>
	<cfset form.mostrarplazas = url.mostrarplazas >
</cfif>
<cfif isdefined("url.desplegarnombre") and not isdefined("form.desplegarnombre")>
	<cfset form.desplegarnombre = url.desplegarnombre >
</cfif>
<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
<cfif isdefined("url.desplegarnombre") and not isdefined("form.desplegarnombre")>
	<cfset form.mostrardependencia = url.mostrardependencia>
</cfif>
<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->

<cfset paramsuri = "" >
<cfif isdefined("form.CFpkdesde")>
	<cfset paramsuri = paramsuri & "&CFpkdesde=#form.CFpkdesde#" >
</cfif>
<cfif isdefined("form.CFpkhasta")>
	<cfset paramsuri = paramsuri & "&CFpkhasta=#form.CFpkhasta#" >
</cfif>
<cfif isdefined("form.mostrarplazas")>
	<cfset paramsuri = paramsuri & "&mostrarplazas=#form.mostrarplazas#" >
</cfif>
<cfif isdefined("form.desplegarnombre")>
	<cfset paramsuri = paramsuri & "&desplegarnombre=#form.desplegarnombre#" >
</cfif>
<cfif isdefined("form.mostrardependencia")>
	<cfset paramsuri = paramsuri & "&mostrardependencia=#form.mostrardependencia#" >
</cfif>

<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
<cfif isdefined('form.mostrardependencia') and form.mostrardependencia EQ 'Si'>
	<cf_htmlReportsHeaders irA="plazas-filtro.cfm" FileName="Reporte_Plazas.xls" download="false">
	<!---<cf_rhimprime datos="/rh/nomina/consultas/plazas-form.cfm" objetosform="false" paramsuri="#paramsuri#">--->
<cfelse>
	<cf_htmlReportsHeaders irA="plazas-filtro.cfm" FileName="Reporte_Plazas.xls" print= "false">
</cfif>
<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->

<cfinclude template="plazas-form.cfm">
</body>
</html>
