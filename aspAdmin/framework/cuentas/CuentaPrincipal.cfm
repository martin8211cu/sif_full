<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
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
	<link rel="stylesheet" type="text/css" href="/cfmx/sif/framework/css/sec.css">
	<style  type="text/css" >
	iframe.marco {
		width: 100%;
		border: none;
		margin: 0px 0px 0px 0px;
		padding: 0px 0px 0px 0px;
	}
	</style>
	
	<script type="text/javascript">
		var visibleServicio = true;
		function fnMinMax(id,visible) {
			var tr  = document.getElementById("tr"+id);
			var img = document.getElementById("img"+id);
			if (visible == true || visible == false) {
				visibleServicio = visible;
			} else {
				visibleServicio = tr.style.display != "none";
				visibleServicio = !visibleServicio;
			}
			tr.style.display = visibleServicio ? "" : "none";
			img.src = visibleServicio ? "/cfmx/sif/framework/imagenes/w-close.gif" : "/cfmx/sif/framework/imagenes/w-max.gif";
		}

		function fnReload(frameid) {
			frames[frameid].location.reload();
		}

		function recycle(frameid) {
			var args = "";

			if ( (frameid == 'admin') && (frames[frameid].document.form1) ) {
				args = "?cliente_empresarial=" + frames[frameid].document.form1.cliente_empresarial.value;
				frames[frameid].location = (frames[frameid].location.href.indexOf("Recycle") == -1 ? 'listaAdminRecycle.cfm' : 'listaAdmin.cfm') +	args;
			}
			else if(frameid == 'cuenta'){
				open('about:blank', 'admin');
				frames[frameid].location = (frames[frameid].location.href.indexOf("Recycle") == -1 ? 'listaCuentasRecycle.cfm' : 'Cuenta.cfm');
			}
		}
	</script>

		<!---<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Titulo">--->
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
	
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td>
				<cfinclude template="../portlets/pNavegacion2.cfm">
			</td></tr>

			<tr>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr class="<cfoutput>#session.preferences.skin#_thcenter</cfoutput>">
							<td>Cuentas Empresariales</td>
							<td style="text-align: right;">
								<a href="javascript:recycle('cuenta')">
									<img border="0" src="/cfmx/sif/framework/imagenes/w-recycle.gif" alt="Cuentas inactivas" class="icono">
								</a>
								<a href="javascript:fnReload('cuenta')">
									<img border="0" src="/cfmx/sif/framework/imagenes/w-reload.gif" alt="Actualizar" class="icono">
								</a>
								<a href="javascript:fnMinMax('cuenta')">
									<img border="0" src="/cfmx/sif/framework/imagenes/w-close.gif" alt="Abrir/Cerrar" class="icono" id="imgcuenta">
								</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>

			<tr id="trcuenta">
				<td class="boxbody">
					<iframe id="cuenta" name="cuenta" class="marco" src="/cfmx/sif/framework/cuentas/Cuenta.cfm" frameborder="0" width="100%" style="height: 220px; margin-top:0;"></iframe>
				</td>
			</tr>

			<tr><td><hr/></td></tr>

			<tr>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0" >
						<tr class="<cfoutput>#session.preferences.skin#_thcenter</cfoutput>">
							<td>Usuarios administradores</td>
							<td style="text-align: right;">
								<a href="javascript:recycle('admin')">
									<img src="/cfmx/sif/framework/imagenes/w-recycle.gif" alt="Administradores inactivos" class="icono">
								</a>
								<a href="javascript:fnReload('admin')">
									<img src="/cfmx/sif/framework/imagenes/w-reload.gif" alt="Actualizar" class="icono">
								</a>
								<a href="javascript:fnMinMax('admin')">
									<img src="/cfmx/sif/framework/imagenes/w-close.gif" alt="Abrir/Cerrar" class="icono" id="imgadmin">
								</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>

 			<tr id="tradmin">
				<td class="boxbody">
					<iframe id="admin" name="admin" class="marco" src="about:blank" frameborder="0" style="height: 450px">Cargando...</iframe> 
				</td>
			</tr>

		</table>
	
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		<!---</cf_web_portlet>--->
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>