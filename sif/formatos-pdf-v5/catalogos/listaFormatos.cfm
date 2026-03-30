<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<!-- InstanceEndEditable -->
<link href="portlets.css" rel="stylesheet" type="text/css">
<link href="portlets.css" rel="stylesheet" type="text/css">
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
<link href="sif.css" rel="stylesheet" type="text/css">
<link href="sif.css" rel="stylesheet" type="text/css">

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><a href="LogoEmpresas.cfm">[ ir a logos de empresas ]</a> </td>
          <td width="50%">
<div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n del Sistema</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="../jsMenuAD.cfm" ></td>
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
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td width="84" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td colspan="3" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img src="sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Encabezado de Formatos de Impresi&oacute;n<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->

				<script language="JavaScript1.2" type="text/javascript">
					function nuevo(){
						document.lista.action       = "EFormatosImpresion.cfm";
						if(document.lista.Cambio)document.lista.Cambio.value = "";
						document.lista.submit();
					}
					
					function limpiar(){
						document.filtro.fFMT01COD.value = "";
						document.filtro.fFMT01DES.value = "";
						document.filtro.fFMT01TIP.value = -1;
					}
				</script>
				<table width="100%"  border="0" >
				  <tr> 
					<td colspan="2"><cfinclude template="../../portlets/pNavegacionAD.cfm"></td>
				  </tr>
	
				  <tr> 
					<td valign="top" colspan="2">
						<form name="filtro" action="" method="post" >
							<table width="100%" class="areaFiltro">
								<tr>
									<td width="2%"></td>
									<td width="1%">C&oacute;digo:&nbsp;</td>
									<td width="22%"><input name="fFMT01COD" type="text" size="10" maxlength="10" value=""></td>
									<td>Descripci&oacute;n</td>
									<td><input name="fFMT01DES" type="text" size="50" maxlength="50" value=""></td>
									<td>Sistema</td>
									<td>
										<cfquery name="rsTipos" datasource="emperador">
											select FMT00COD, FMT00DES from FMT000 order by FMT00DES
										</cfquery>
										<select name="fFMT01TIP">
											<option value="-1">--- Todos ---</option>
											<cfoutput query="rsTipos">
												<option value="#rsTipos.FMT00COD#" <cfif isdefined("form.fFMT01TIP") and form.fFMT01TIP eq rsTipos.FMT00COD>selected</cfif> >#rsTipos.FMT00DES#</option>
											</cfoutput>
										</select>
									</td>
									<td><input type="submit" name="btnFiltrar" value="Filtrar"></td>
									<td><input type="button" name="btnlimpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
								</tr>

							</table>
						</form>
					</td>
				  </tr>		

				  <tr>
				  	<td colspan="2">
						
						<!--- ============================================================== --->
						<!---  Creacion del filtro --->
						<!--- ============================================================== --->

						<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.FMT01TIP*=b.FMT00COD " >
						
						<cfif isdefined("form.fFMT01COD") and len(trim(form.fFMT01COD)) gt 0  >
							<cfset filtro = filtro & " and upper(FMT01COD) like  " & "'%#ucase(form.fFMT01COD)#%'" >
						</cfif>
						
						<cfif isdefined("form.fFMT01DES") and len(trim(form.fFMT01DES)) gt 0 >
							<cfset filtro = filtro & " and upper(rtrim(FMT01DES)) like upper('%" & form.fFMT01DES & "%')">
						</cfif>
						
						<cfif isdefined("form.fFMT01TIP") and form.fFMT01TIP NEQ "-1" >
							<cfset filtro = filtro & " and FMT01TIP = " & form.fFMT01TIP >
						</cfif>

						<cfset filtro = filtro & " order by FMT00DES, FMT01COD " >
						
						<!--- ============================================================== --->
						<!--- ============================================================== --->
							
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pLista"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="FMT001 a, FMT000 b "/>
							<cfinvokeargument name="columnas" value="FMT01COD, FMT01DES, FMT01TIP, convert(varchar, FMT01FEC, 103) as FMT01FEC, isnull(b.FMT00DES, 'Otros') as FMT00DES"/>
							<cfinvokeargument name="desplegar" value="FMT01COD, FMT01DES"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="filtro" value="#filtro#" />
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="Nuevo" value="EFormatosImpresion.cfm"/>
							<cfinvokeargument name="irA" value="EFormatosImpresion.cfm"/>
							<cfinvokeargument name="Cortes" value="FMT00DES"/>
							<cfinvokeargument name="Conexion" value="emperador"/>
						</cfinvoke>
					</td>
				  </tr>
				  <tr><td colspan="2" align="center"><input type="button" value="Nuevo" onClick="javascript:nuevo();"></td></tr>
				</table>
		   
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
