<cfinclude template="../../Utiles/general.cfm">
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
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="/sif/css/portlets.css" rel="stylesheet" type="text/css">
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
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<link href="/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/sif/js/DHTMLMenu3.5/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/edu/Imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
<cfinclude template="../../portlets/pEmpresas2.cfm"></td>
          <td width="50%">
<div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5">Inventarios</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="../jsMenuIV.cfm" ></td>
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
          <td width="2%"class="Titulo"><img src="/cfmx/edu/Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo"><!-- InstanceBeginEditable name="TituloPortlet" -->Ajustes<!-- InstanceEndEditable --></td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"  class=""><img src="/cfmx/edu/Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder"><!-- InstanceBeginEditable name="Mantenimiento2" -->

<script language="JavaScript1.2" type="text/javascript">
	
	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}

	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}
	
</script>

				<table width="100%"  border="0" >
				  <tr> 
					<td colspan="2"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
				  </tr>
	
				  <tr> 
					<td valign="top" colspan="2">
						<cfinclude template="filtroListaAjuste3.cfm">
					</td>
				  </tr>		

				<tr> 
					<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
				 	<td valign="middle"><b>Seleccionar Todo</b></td>
				</tr>	

				  <tr>
				  	<td colspan="2">
						
						<!--- ============================================================== --->
						<!---  Creacion del filtro --->
						<!--- ============================================================== --->

						<cfset filtro = " EAjustes.Aid = Almacen.Aid  and Ecodigo=#Session.Ecodigo# ">
						
						<cfif isdefined("Form.fAid") AND #Form.fAid# NEQ "all" >
							<cfset filtro = insert(" and EAjustes.Aid = " & #Form.fAid#, #filtro#, Len(#filtro#) ) >
						</cfif>
						
						<cfif isdefined("Form.fEAdocumento") AND #Form.fEAdocumento# NEQ "" >
							<cfset filtro = #filtro# & " and upper(rtrim(EAdocumento)) like upper('%" & #Form.fEAdocumento# & "%')">							
						</cfif>
						
						<cfif isdefined("Form.fEAdescripcion") AND #Form.fEAdescripcion# NEQ "" >
							<cfset filtro = #filtro# & " and upper(rtrim(EAdescripcion)) like upper('%" & #Form.fEAdescripcion# & "%')">							
						</cfif>
						
						<cfif isdefined("Form.fEAfecha") AND #Form.fEAfecha# NEQ "" >
							<cfset filtro = insert(" and EAfecha = convert(datetime, '" & #Form.fEAfecha#, #filtro# & "', 103)", Len(#filtro#) ) >
						</cfif>
						
						<cfif isdefined("Form.fUsuario") AND #Form.fUsuario# NEQ "all" >
							<cfset filtro = insert(" and EAusuario = '" & #Form.fUsuario# & "'", #filtro#, Len(#filtro#) ) >
						</cfif>
						
						<cfset filtro = insert(" order by EAjustes.EAid ", #filtro#, Len(#filtro#) ) >
						
						<!--- ============================================================== --->
						<!--- ============================================================== --->
							
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pLista"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="EAjustes, Almacen"/>
							<cfinvokeargument name="columnas" value="EAid, EAdocumento, convert(varchar(10), EAfecha,103)EAfecha, EAdescripcion, Bdescripcion"/>
							<cfinvokeargument name="desplegar" value="EAdocumento, EAdescripcion, Bdescripcion, EAfecha "/>
							<cfinvokeargument name="etiquetas" value="Documento, Descripci&oacute;n, Almac&eacute;n, Fecha"/>
							<cfinvokeargument name="formatos" value="V, V, V, V"/>
							<cfinvokeargument name="filtro" value="#filtro#" />
							<cfinvokeargument name="align" value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="S"/>
							<cfinvokeargument name="Nuevo" value="Ajustes.cfm"/>
							<cfinvokeargument name="irA" value="Ajustes.cfm"/>
						</cfinvoke>
					</td>
				  </tr>
				</table>
		   
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
