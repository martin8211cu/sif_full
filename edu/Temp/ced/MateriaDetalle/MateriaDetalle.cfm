<cfinclude template="../../recurso/Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenu04.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<link href="../../recurso/css/estilos.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../../recurso/js/utilesMonto.js"></script>
<!-- InstanceEndEditable -->
<link href="../../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../../../js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/javascript">
	// Funciones para el Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../recurso/portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" rowspan="2" valign="middle">
		  	<cfset RolActual = 0>
			<cfinclude template="../../../portlets/pEmpresas2.cfm">
			</td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
              Administraci&oacute;n del Centro de Estudio<!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td valign="bottom" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" -->
	  	  <cfinclude template="../../recurso/js/jsMenuCED.cfm">
      <!-- InstanceEndEditable -->	
		  </td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
	<cfif isdefined("Session.CEcodigo")>
		<cfoutput>
		<table class="area" width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td><hr></td>
			</tr>
			<tr>
				<td align="right"><font color="##009900" size="2"><strong><a href="/minisitio/#Session.CEcodigo#/f#Session.CEcodigo#.html">Ir a P&aacute;gina Web de #rsPagWebCollege.CEnombre#</a></strong></font></td>
			</tr>
		</table>
		</cfoutput>
	</cfif>
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td align="left" valign="top" nowrap></td>
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr> 
    <td valign="top" nowrap>
		<cfinclude template="/sif/menu.cfm">
	</td>
    <td valign="top" width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="2%"class="Titulo"><img  src="../../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Detalle de Materia<!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0>
				<cfset arreglo = ListToArray(Form.datos,"|")>
				<cfparam name="Form.Tipo" default="#arreglo[1]#">
				<cfparam name="Form.CodAct" default="#arreglo[2]#">
				<cfparam name="Form.Mconsecutivo" default="#arreglo[3]#">
				<cfparam name="Form.PEcodigo" default="#arreglo[4]#">
				<cfparam name="Form.modo" default="CAMBIO">
			</cfif>

			<cfif isdefined("Url.Mconsecutivo") and not isdefined("Form.Mconsecutivo")>
				<cfparam name="Form.Mconsecutivo" default="#Url.Mconsecutivo#">
			<cfelseif not isdefined("Form.Mconsecutivo")>
				<cfparam name="Form.Mconsecutivo" default="0">
			</cfif>
			<cfif isdefined("Url.Tipo") and not isdefined("Form.Tipo")>
				<cfparam name="Form.Tipo" default="#Url.Tipo#">
			</cfif>
			<cfif isdefined("Url.CodAct") and not isdefined("Form.CodAct")>
				<cfparam name="Form.CodAct" default="#Url.CodAct#">
			</cfif>

			<cfif isdefined("Form.Cambio")>
				<cfset modo="CAMBIO">
			<cfelse>
				<cfif not isdefined("Form.modo")>
					<cfset modo="ALTA">
				<cfelseif Form.modo EQ "CAMBIO">
					<cfset modo="CAMBIO">
				<cfelse>
					<cfset modo="ALTA">
				</cfif>
			</cfif>
			
			<cfset Session.RegresarURL = "Materias.cfm?Mconsecutivo=#Form.Mconsecutivo#">

		  	  <cfinclude template="../../recurso/portlets/pNavegacionCED.cfm">
			  <cfinclude template="formMateriaDetalle.cfm">
          <!-- InstanceEndEditable -->
		  </td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table>
	 </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
