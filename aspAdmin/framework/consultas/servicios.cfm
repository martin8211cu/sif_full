<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<cfparam name="url.sistema" default="">
<cfparam name="url.detalle" default="4">

<!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->


<style type="text/css">
<!--
td {
	border: 0px white;
	font-family: Arial, Helvetica, sans-serif;
}
.h1 {
	font-size: small;
	font-weight: bold;
	background-color:#444;
	color:white;
}
.h1 td {
	border-top: 3px double black;
	border-right: 3px none black;
	border-bottom: 3px double black;
	border-left: 3px none black;
}
.h2 {
	font-size: x-small;
	font-weight: bold;
	background-color:white;
	color:black;
}
.h3 {
	font-size: x-small;
	font-weight: bold;
}
.rr1,.rr2 {
	font-size: xx-small;
}
.rr1 { background-color:#ccc; }
.rr2 { background-color:#eee; }
<cfif url.detalle ge 4>
.h3 td {
	border-top: 1px solid black;
}
</cfif>
-->
</style>
<!-- InstanceEndEditable -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><!--- <cfinclude template="../portlets/pEmpresas2.cfm"> ---></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/aspAdmin/framework/jsMenuFM.cfm" ></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->	
	
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="84" align="left" valign="top" nowrap></td> 
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Titulo">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" -->

<cfquery dataSource="sdc" name="data">
	select
		rtrim(a.sistema) as sistema, a.nombre as nombre_sistema,
		rtrim(m.modulo) as modulo, m.nombre as nombre_modulo, facturacion, tarifa, componente, metodo,
		rtrim(s.servicio) as servicio, s.nombre as nombre_servicio, s.menu, s.home, s.agregacion,
			existeRol = 0, null as rol, 
		p.uri, p.tipo_uri, p.tipo_obj, p.titulo,
		s.home_uri, s.home_tipo
	
	from Sistema a, Modulo m, Servicios s, Procesos p
	
	where a.activo = 1
	  and m.sistema =* a.sistema
	  and m.activo = 1
	  and s.modulo =* m.modulo
	  and s.activo = 1
	  and p.servicio =* s.servicio
	  and p.activo = 1
	  <cfif Len(url.sistema) GT 0>
	  	and a.sistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.sistema#" >
	  </cfif>
	
	order by a.orden, upper (a.sistema), m.orden, upper (m.modulo)

</cfquery>

<cfquery dataSource="sdc" name="roles"> 
	select
		rtrim(a.sistema) as sistema,
		rtrim(b.rol) as rol,
		b.nombre as nombre_rol
	from Sistema a, Rol b
	where a.activo = 1
	  and b.activo = 1
	  and b.sistema = a.sistema
	order by case when b.sistema = 'sys' then 0 else 1 end, 1, 2
</cfquery>

<cfquery dataSource="sdc" name="rolsrv"> 
	select
		rtrim(b.rol) as rol,
		rtrim(s.servicio) as servicio
	from Sistema a, Rol b, Servicios s, ServiciosRol sr
	where a.activo = 1
	  and b.activo = 1
	  and b.sistema = a.sistema
	  and sr.rol = b.rol
	  and s.servicio = sr.servicio
	  and s.activo = 1
	  and sr.activo = 1
	order by 1, 2
</cfquery>

<cfquery dataSource="sdc" name="sistemas"> 
	<!--- no se ordena por Sistema.orden porque es para desplegar alfabeticamente en un <select> --->
	select rtrim(sistema) as sistema, nombre
	from Sistema
	where activo = 1
	order by nombre, sistema
</cfquery>

<cfset rolsrvh = ArrayNew(1)>
<cfloop query="rolsrv">
	<cfset ArrayAppend(rolsrvh, Trim(rolsrv.rol) & '@' & rolsrv.servicio)>
</cfloop>
<cfset rolsrvh = ArrayToList(rolsrvh)>

<form name="f" style="margin:0" method="get">
<table border="0"><tr>
<td>
Sistema:
</td><td>
<select name="sistema" onChange="this.form.submit();">
<option value="">[ Todos ]</option>
<cfoutput query="sistemas">
	<option value='#sistemas.sistema#' <cfif url.sistema EQ sistemas.sistema>selected</cfif>>
		#sistemas.nombre#</option>
</cfoutput>
</select>
</td>
<td>Nivel:</td>
<td><select name="detalle" onChange="this.form.submit();">
<option value="1" <cfif url.detalle EQ 1>selected</cfif> >sistema</option>
<option value="2" <cfif url.detalle EQ 2>selected</cfif> >m&oacute;dulo</option>
<option value="3" <cfif url.detalle EQ 3>selected</cfif> >servicio</option>
<option value="4" <cfif url.detalle EQ 4>selected</cfif> >detalle</option>
</select></td></tr></table>
</form>
<table border="1" cellspacing="0" cellpadding="0">
<cfoutput query="data" group="sistema">
	<cfif url.detalle GE 1 and Len(data.sistema) GT 0>
		<cfif url.detalle ge 2 and Len(data.sistema) GT 0>
			<cfif data.CurrentRow GT 0>
				<tr><td colspan="7">&nbsp;</td></tr>
			</cfif>
		</cfif>
		<tr class="h3">
		<td valign="bottom" colspan="7">&nbsp;
		</td>
		<cfset data_sistema = data.sistema>
		<cfloop query="roles">
			<cfif roles.sistema EQ data_sistema or roles.sistema EQ 'sys'>
				<td rowspan="2" align="right" height="10" valign="bottom" width="2%" 
					style="writing-mode:tb-rl;">#roles.nombre_rol#</td>
			</cfif>
		</cfloop>
		</tr>
		<tr class="h1">
		<td valign="bottom" colspan="7"><cfif url.detalle ge 2>Sistema:</cfif>
		#data.sistema# - #data.nombre_sistema#
		</td>
		</tr>
	</cfif>

	<cfoutput group="modulo">
		<cfif url.detalle ge 2 and Len(data.modulo) GT 0>
			<cfif url.detalle ge 3 and Len(data.modulo) GT 0>
				<cfif data.CurrentRow GT 0>
					<tr><td colspan="7">&nbsp;</td></tr>
				</cfif>
			</cfif>
			<tr class="h2">
		    <td width="1%">&nbsp;</td>
		    <td colspan="6"><cfif url.detalle ge 3>M&oacute;dulo:</cfif>
			#data.modulo# - #data.nombre_modulo#
				<cfif data.facturacion EQ '0' and data.tarifa EQ 0>(Gratuito)
				<cfelseif data.facturacion EQ '0'>(Tarifa fija
					 #LSCurrencyFormat( data.tarifa )# USD)
				<cfelseif data.facturacion EQ '1'>(Comisi&oacute;n por servicio)
				<cfelseif data.facturacion EQ '2'>(C&aacute;lculo especial 
					#data.componente#.#data.metodo# )
				<cfelse>Otro
				</cfif>
			  </td>
			  <cfif url.detalle ge 3>
				<cfloop query="roles">
					<cfif roles.sistema EQ data_sistema or roles.sistema EQ 'sys'>
						<td align="center" valign="top" width="2%">&nbsp;</td>
					</cfif>
				</cfloop>
			  </cfif>
		  </tr>
		</cfif>
		
		<cfoutput group="servicio">
			<cfif url.detalle ge 3 and Len(data.servicio) GT 0>
				<tr class="h3">
			  <td width="1%">&nbsp;</td>
			  <td width="1%">&nbsp;</td>
			  <td colspan="5"><cfif url.detalle ge 4>Servicio:</cfif>
				#data.servicio# - #data.nombre_servicio#
				<cfif data.menu EQ 1> (menu)</cfif>
				<cfif data.home EQ 1> (home)</cfif>
				<cfif data.agregacion EQ 0>(Opcional)
					<cfelseif data.agregacion EQ 1>(Fija)
					<cfelseif data.agregacion EQ 2>(Autom&aacute;tica)
					<cfelse>Otra
				</cfif>
			  </td>
			  <cfset data_servicio = data.servicio>
				<cfloop query="roles">
					<cfif roles.sistema EQ data_sistema or roles.sistema EQ 'sys'>
						<td align="center" valign="top" width="2%">
						<cfif ListFind(rolsrvh, roles.rol & '@' & data_servicio) GT 0>x
						<cfelse>&nbsp;</cfif></td>
					</cfif>
				</cfloop>
			  </tr>
			</cfif>
			
			<cfoutput>
				<cfif detalle ge 4 and Len(data.uri) GT 0>
					<tr>
					  <td width="1%">&nbsp;</td>
					  <td width="1%">&nbsp;</td>
					  <td class="rr#data.CurrentRow MOD 2 + 1#" width="1%">
						  <cfif data.tipo_uri EQ data.home_tipo and data.uri EQ data.home_uri>
							  <img src="../imagenes/home-icon.gif" border="0" width="12" height="11">
						  <cfelse>&nbsp;
						  </cfif></td>
					  <td class="rr#data.CurrentRow MOD 2 + 1#">
					  	<cfif Len(data.titulo) GT 0>#data.titulo#<cfelse>[ sin elementos ]</cfif>
					  </td>
					  <td class="rr#data.CurrentRow MOD 2 + 1#">
					  	<cfif data.tipo_uri EQ 'J'>JSP
							<cfelseif data.tipo_uri EQ 'C'>Coldfusion
							<cfelseif data.tipo_uri EQ 'D'>Dynamo
							<cfelse>#data.tipo_uri#
						</cfif></td>
						<td class="rr#data.CurrentRow MOD 2 + 1#">
						<cfif data.tipo_obj EQ 'P'>P&aacute;gina
							<cfelseif data.tipo_obj EQ 'D'>Directorio (sin subdirectorios)
							<cfelseif data.tipo_obj EQ 'S'>Subdirectorios
							<cfelseif data.tipo_obj EQ 'A'>Acci&oacute;n
							<cfelseif data.tipo_obj EQ 'B'>Bot&oacute;n
							<cfelseif data.tipo_obj EQ 'C'>Componente
							<cfelse>#data.tipo_obj#
						</cfif></td>
						<td class="rr#data.CurrentRow MOD 2 + 1#">
							<cfif Len(data.uri) GT 0>#data.uri#<cfelse>-</cfif>
						</td>
						  <cfset data_servicio = data.servicio>
						<cfloop query="roles">
							<cfif roles.sistema EQ data_sistema or roles.sistema EQ 'sys'>
								<td class="rr#data.CurrentRow MOD 2 + 1#" align="center" valign="top" width="2%">
								<cfif ListFind(rolsrvh, roles.rol & '@' & data_servicio) GT 0>x
								<cfelse>&nbsp;</cfif></td>
							</cfif>
						</cfloop>
						</tr>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
</cfoutput>
</table>
<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>