<html><!-- InstanceBegin template="/Templates/LMenuSDC.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<cf_templatecss>
<cf_templatecss>
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
<cf_templatecss>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">&nbsp;</td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap>&nbsp;</td>
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
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->&nbsp;<!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="/cfmx/sif/imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Bit&aacute;cora de Movimientos<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/sif/imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" --> 
		  
	<script>
		function validar(form){
			var error = false;
			var msg   = "Se presentaron los siguientes errores:\n";
			if (form.PBtabla.value == "" ){
				error = true;
				msg += " - La Tabla es requerida.\n"
			} 

			if (form.llave.value == "" ){
				error = true;
				msg += " - La Llave es requerida."
			} 
			
			if (error){
				alert(msg);
				return false;
			}

			return true;
		}

		function showConlis(id, descr) {
			var ventana = open('conlisTablas.cfm','ventana','left=100,top=100,scrollbars=yes,resizable=yes,width=450,height=300');
			return;
		}
		
		function showConlisR(tabla) {
			if ( document.form1.PBid.value != "" ){
				var ventana = open('conlisRegistros.cfm?tabla=' + tabla,'ventana','left=100,top=100,scrollbars=yes,resizable=yes,width=450,height=300');
			}
			else{
				alert('Debe seleccionar la tabla.')
			}				
			return;
		}

	</script>

	<script language="JavaScript1.2" src="calendar.js"></script>
	
<form name="form1" method="post" action="Consulta.cfm" onSubmit="return validar(this);">
	<table cellspacing="0" cellpadding="0" border="0" width="75%" align="center" >
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap>Tabla:&nbsp;</td>
						<td nowrap>
							<input name="PBtabla" value="" readonly size="30" maxlength="30" >
							<a href="javascript:showConlis()"><img src="vinneta.gif" border='0' /></a>
						</td>

						<td nowrap>Registro:&nbsp;</td>
						<td nowrap>
							<input name="llave" value="" readonly  size="80" maxlength="255">
							<a href="javascript:showConlisR(document.form1.PBtabla.value)"><img src="vinneta.gif" border='0' /></a>
						</td>

						<!---
						<td nowrap>Fecha:&nbsp;</td>
						<td nowrap>	
							<input type="text" name="desde" value="" size="11" maxlength="11" />
							<a href='javascript:showCalendar("document.form1.desde", document.form1.desde)'> 
							<img src="vinneta.gif" border='0' />
							</a > 
						</td>
						--->
					</tr>
				</table>	
			</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input name="btnConsultar" type="submit" value="Procesar" />
				<input name="btnLimpiar"   type="reset" value="Restablecer" />
			</td>
		</tr>
		
		<tr>
			<td>
				<input type="hidden" name="PBid"  value="">
			</td>			
		</tr>

	</table>
</form>		  
		  
		  
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
