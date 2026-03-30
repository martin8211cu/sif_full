<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>$$TITLE$$</title>
	<link rel="stylesheet" type="text/css" href="style.css">
</head>

<body leftmargin=0 topmargin=0 marginheight="0" marginwidth="0" bgcolor="#ffffff">
<!--- Encabezado --->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td background="images/main_logo_back.gif" width="70%"><img src="images/main01.jpg" width="518" height="128"></td>
	  <td background="images/main_logo_back.gif" width="30%" valign="middle">
	  	<table width="100%"  border="0" cellspacing="0" cellpadding="0" style=" margin-top:10px">
		  <cfoutput>
		  <cfif isdefined("session.Enombre") and len(trim(session.Enombre)) gt 0>
		  <tr>
			<td align="center" style="font:Verdana; font-size:34px; font-weight:bolder; color:##FFFFFF; text-transform:uppercase;" >#session.Enombre#</td>
		  </tr>
		  </cfif>
		  <tr>
			<td align="center" style="font:Verdana; font-size:22px; font-weight:bolder; color:##FFFFFF; text-transform:uppercase;" >Autogesti&oacute;n</td>
		  </tr>
		  </cfoutput>
		</table>
	  </td>
	</tr>
</table>
<!--- Menú Horizontal --->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr>
	<td height="29" background="images/mb_r1_c2.gif">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td><cf_boton texto="Inicio" index="100" link="/cfmx/sif/index.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Nosotros" index="101" link="/cfmx/plantillas/info/nosotros.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Productos" index="101" link="/cfmx/plantillas/info/productos.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Capacitaci&oacute;n" index="101" link="/cfmx/plantillas/info/capacitacion.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Cont&aacute;ctenos" index="101" link="/cfmx/plantillas/info/contactenos.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Salir" index="110" link="/cfmx/home/public/logout.cfm" 
		td_image_1="mb_r1_c1.gif|mb_r1_c1.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td width="100%" valign="middle"><cfinclude template="pubica.cfm"></td>
	  </tr>
	</table>
	</td>
</tr>
</table>
<!--- HEADER LEFT Y BODY --->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2">$$HEADER OPTIONAL$$</td>
  </tr>
  <tr>
    <td valign="top">$$LEFT OPTIONAL$$</td>
	<td width="100%" valign="top">$$BODY$$</td>
  </tr>
</table>
<!--- PIE DE PÁGINA --->
<cfoutput>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
	<td nowrap valign="middle" align="left" height="29" background="images/mb_r1_c2.gif" width="100%" style="font-family:Tahoma; font-size:12px; color:##FFFFFF; font-weight:bold;">Copyright &copy;2004 <cfif isdefined("session.Enombre") and len(trim(session.Enombre)) gt 0>#session.Enombre#</cfif>, Todos los derechos reservados.</td>
		<td><cf_boton texto="Inicio" index="200" link="/cfmx/sif/index.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Nosotros" index="201" link="/cfmx/plantillas/info/nosotros.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Productos" index="201" link="/cfmx/plantillas/info/productos.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Capacitaci&oacute;n" index="201" link="/cfmx/plantillas/info/capacitacion.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Contactenos" index="201" link="/cfmx/plantillas/info/contactenos.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
		<td><cf_boton texto="Salir" index="210" link="/cfmx/home/public/logout.cfm" 
		td_image_1="mb_r1_c2.gif|mb_r1_c2.gif|26|29"
		td_image_2="mb_r1_c2.gif|mb_r1_c2.gif|0|29|middle|Tahoma|12|##FFFFFF|bold"
		td_image_3="mb_r1_c2.gif|mb_r1_c2.gif|7|29"
		doevents="false"></td>
  </tr>
</table>
</cfoutput>

</body>

</html>
