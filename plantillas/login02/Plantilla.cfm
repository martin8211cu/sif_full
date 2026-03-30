<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<script language="javascript1.2" type="text/javascript" src="/cfmx/plantillas/login02/utiles.js"> </script>
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<link href="/cfmx/plantillas/login02/sif_login02.css" rel="stylesheet" type="text/css">

</head>


<body style="margin:0;">
<cf_templatecss>
<center>
<table border="0" cellspacing="0" cellpadding="0" width="980" align="center" style="margin:0; vertical-align:top; ">
	<tr><td colspan="2">
<div align="left">
              <table border="0" width="980" height="70" cellpadding="0" cellspacing="0" style="background:url(/cfmx/plantillas/portal_asp2/images/temp/01-02.jpg); background-repeat:repeat"  >
				<tr>
                  <td align="center" style="background-image:url(/cfmx/plantillas/login02/images/headerv2.gif); background-repeat:no-repeat;" >
				  <cfif session.Usucodigo>
						<table width="392" border="0" cellspacing="0" cellpadding="0" align="right" >
						  <tr>
							<td width="382" height="33" align="right" valign="bottom"><span class="toprightitems">
								<a style="color: #2B3C6E;" href="/cfmx/home/index.cfm">Inicio</a> |
								<a style="color: #2B3C6E;" href="/cfmx/plantillas/info/nosotros.cfm">Nosotros</a> | 
								<a style="color: #2B3C6E;" href="/cfmx/plantillas/info/productos.cfm">Productos</a> |
								<a style="color: #2B3C6E;" href="/cfmx/plantillas/info/capacitacion.cfm">Capacitaci&oacute;n</a> |
								<a style="color: #2B3C6E;" href="/cfmx/plantillas/info/soporte.cfm">Soporte</a> | 
								<a style="color: #2B3C6E;" href="/cfmx/home/public/logout.cfm">Salir</a>
							<td width="10" align="right" valign="bottom">&nbsp;</td>
						  </tr>
						</table>
					<cfelse>&nbsp;
				  </cfif>

				  </td>
                </tr>
              </table>
</div>
	</td></tr>
	
	 <cfif session.Usucodigo >
		<!--- Indica si esta accesando desde el portal o los sistemas --->
		<!--- De momento solo aqui est adefinida --->
		<!--- Puedes tener los valores: sistema, portal--->
	 	<cfparam name="session.origen" default="sistema"> 
		<!--- a pso no le muestra el menu --->
		<cfquery name="admin" datasource="asp">
			select admin from Usuario where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> and admin=1
		</cfquery>
		<tr><td>
			<cfif admin.recordcount eq 0 >
				<cfset request.mlm_part1 = true>
				<cfinclude template="/home/menu/portlets/menu-content.cfm">
			</cfif> 
		</td></tr>
	</cfif>

  <tr >
	<td valign="top" colspan="2" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0; vertical-align:top;" >
				<tr>
					<td align="left" valign="top">$$HEADER OPTIONAL$$</td>
				</tr>
				<tr>
					<td align="left" valign="top">$$BODY$$</td>
				</tr>
	  	</table>
	</td>
  </tr>

	<tr class="noprint"><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td width="1%" background="/cfmx/plantillas/login02/images/temp/03-01.jpg"><img src="/cfmx/plantillas/login02/images/pixel.gif" width="8" height="24"></td>
			<td width="99%" background="/cfmx/plantillas/login02/images/temp/03-01.jpg"> 
				<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" background="/cfmx/plantillas/login02/images/temp/03-01.jpg">
					<tr> 
						<td><div align="center"><font color="#FFFFFF" size="1" face="Arial, Helvetica, sans-serif"> 
							<a href="/cfmx/home/index.cfm" style="color:#FFFFFF; text-decoration:none" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'">inicio</a> |
							<a href="/cfmx/plantillas/info/nosotros.cfm" style="color:#FFFFFF; text-decoration:none;" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'" >nosotros</a> |
							<a href="/cfmx/plantillas/info/productos.cfm" style="color:#FFFFFF; text-decoration:none" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'">productos</a> |
							<a href="/cfmx/plantillas/info/capacitacion.cfm" style="color:#FFFFFF; text-decoration:none" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'">capacitaci&oacute;n</a> |
							<a href="/cfmx/plantillas/info/soporte.cfm" style="color:#FFFFFF; text-decoration:none" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'">soporte</a> |
							<a href="/cfmx/plantillas/info/contactenos.cfm" style="color:#FFFFFF; text-decoration:none" onMouseOut="this.style.color='#FFFFFF'" onMouseOver="this.style.color='#3399CC'" >cont&aacute;ctenos</a>
							</font></div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>  
	</td></tr>

  <tr>
    <td colspan="2">
		<font size="1" face="Verdana" color="black"> &copy; SOIN, Soluciones Integrales S.A. 2005 </font>
	</td>
  </tr>
</table></center>
<cfif IsDefined('request.mlm_part2')>
	<cfinclude template="/home/menu/portlets/menu-content.cfm">
</cfif>
</body>
</html>
