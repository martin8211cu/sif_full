<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript1.2" type="text/javascript" src="utiles.js"> </script>
<link href="/cfmx/plantillas/login02-oracle/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">
</head>

<!---
<cfif isdefined("session.monitoreo.SScodigo") and isdefined("session.monitoreo.SMcodigo")  >
	<cfset nav__SScodigo = session.monitoreo.SScodigo>
	<cfset nav__SMcodigo = session.monitoreo.SMcodigo>
	<cfset nav__SSdescripcion = nav__SScodigo>
	<cfset nav__SMdescripcion = nav__SMcodigo>

	<cfquery datasource="asp" name="nav__query">
		select SSdescripcion, SShomeuri
		from SSistemas
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nav__SScodigo#">
	</cfquery>
	<cfif nav__query.RecordCount><cfset nav__SSdescripcion = nav__query.SSdescripcion></cfif>
	
	<cfquery datasource="asp" name="nav__query">
		select SMdescripcion, SMhomeuri
		from SModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nav__SScodigo#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nav__SMcodigo#">
	</cfquery>
	<cfif nav__query.RecordCount><cfset nav__SMdescripcion = nav__query.SMdescripcion> </cfif>

	<CFDUMP var="#nav__SScodigo#">
	<CFDUMP var="#nav__SMcodigo#">
</cfif>
--->

<body style="margin:0;">

<table border="0" width="980" cellspacing="0" cellpadding="0" align="center">
	<tr style="background-image:url(/cfmx/plantillas/login02-oracle/images/headerv2.gif)" height="82" >
		<td colspan="2" valign="middle" >
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right"></td>
					<td width="15%">&nbsp;</td>
				</tr>
			</table>

		<!---<img src="images/headerv2.gif" width="980" height="82" alt="SOIN - Soluciones Integrales, S.A.">--->
		<!--- anterior:
		<img src="images/header.gif" width="980" height="112" alt="SOIN - Soluciones Integrales, S.A.">
		--->
		</td>
	</tr>
</table>

<table border="0" cellspacing="0" cellpadding="0" width="980" align="center" style="margin:0; ">  
  <tr>
    <td background="images/menuimg.gif" valign="top">&nbsp;</td>
	<td background="images/menuimg.gif" valign="middle" height="20">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/home/menu/index.cfm">INICIO</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/nosotros.cfm">NOSOTROS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/productos.cfm">PRODUCTOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/capacitacion.cfm">CAPACITACI&Oacute;N</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/home/menu/index.cfm">SERVICIOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/soporte.cfm">SOPORTE</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/contactenos.cfm">CONT&Aacute;CTENOS</a></td>
					<td align="center">&nbsp;</td>
				  </tr>
		</table>
	</td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="980" align="center" style="margin:0; vertical-align:top ">
  <tr >
	<td valign="top" colspan="2" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td rowspan="2" align="left" valign="top">$$LEFT OPTIONAL$$
				  </td>
				<td align="left" valign="top">$$HEADER OPTIONAL$$ </td>
				</tr>
				<tr>
				  <td align="left" valign="top">$$BODY$$ </td>
				</tr>
	  	</table>
	</td>
  </tr>

<tr><td colspan="2">&nbsp;</td></tr>
  <tr>
    <td background="images/menuimg.gif" valign="top">&nbsp;</td>
	<td background="images/menuimg.gif" height="20" valign="middle">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="center">&nbsp;</td>
					<td valign="middle" align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/home/menu/index.cfm">INICIO</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/nosotros.cfm">NOSOTROS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/productos.cfm">PRODUCTOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/capacitacion.cfm">CAPACITACI&Oacute;N</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/home/menu/index.cfm">SERVICIOS</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/soporte.cfm">SOPORTE</a></td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;">|</td>
					<td align="center">&nbsp;</td>
					<td align="center" style="color:#000099; font-weight: bold; font-size: 10px;"><a style="color:#000099" href="/cfmx/plantillas/info/contactenos.cfm">CONT&Aacute;CTENOS</a></td>
					<td align="center">&nbsp;</td>
				  </tr>
		</table>
	</td>
  </tr>
  
  
  
  <tr>
    <td colspan="2">
		<font size="1" face="Verdana" color="#FFFFFF">(C)SOIN, Soluciones Integrales S.A. 2003 </font>
	</td>
  </tr>
</table>
</body>
</html>
