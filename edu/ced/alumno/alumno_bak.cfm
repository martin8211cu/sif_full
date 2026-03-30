<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
</script>
  <script language="JavaScript" type="text/javascript">
		function switchPages() {
			var DataPage = document.getElementById("TRDatosEmp");
			var ListPage = document.getElementById("TRBuscarEmp");
			if (DataPage.style.display == "") {
				DataPage.style.display = "none";
				ListPage.style.display = "";
			} else {
				DataPage.style.display = "";
				ListPage.style.display = "none";
			}
		}
  </script>
  <link id="webfx-tab-style-sheet" type="text/css" rel="stylesheet" href="../css/tab.webfx.css"/>
  <script type="text/javascript" src="../../js/tabpane/tabpane.js"></script>
<!-- InstanceEndEditable -->
<link href="../../css/portlets.css" rel="stylesheet" type="text/css">
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
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
<script language="JavaScript" src="../../js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
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
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom"> 
	  <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" valign="middle">
		  	<cfset RolActual = 4>
			<cfset Session.RolActual = 4>
			<cfinclude template="../../portlets/pEmpresas2.cfm">
		  </td>
          <td nowrap> 
            <div align="center"><span class="superTitulo">
			<font size="5">
	  <!-- InstanceBeginEditable name="Titulo" --> 
	  		 Administraci&oacute;n del Centro de Estudio
      <!-- InstanceEndEditable -->	
			</font></span></div></td>
        </tr>
        <tr class="area" style="padding-bottom: 3px;"> 
		  <td nowrap style="padding-left: 10px;">
		  <cfinclude template="../../portlets/pminisitio.cfm">
		  </td>
          <td valign="top" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" --> 
	  	<cfinclude template="../jsMenuCED.cfm">
      <!-- InstanceEndEditable -->	
		  </td>
        </tr>
      </table>
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
          <td width="2%"class="Titulo"><img  src="../../Imagenes/sp.gif" width="15" height="15" border="0"></td>
          <td width="3%" class="Titulo" >&nbsp;</td>
          <td width="94%" class="Titulo">
		  <!-- InstanceBeginEditable name="TituloPortlet" -->
		  		Alumnos Activos
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->

<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	  <!--- Cuando ya se ha seleccionado un empleado --->
	  <cfif isdefined("Form.persona") and Len(Trim(Form.persona)) NEQ 0>
	  	  <tr>
		  	<td>
			  <form name="regAlum" action="alumno.cfm" method="post">
			  	<input type="hidden" name="persona" value="<cfif isdefined("Form.persona")>#Form.persona#</cfif>">
				<input type="hidden" name="o" value="">
			  </form>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td align="right" valign="middle">
						<a href="javascript: switchPages();">
							Seleccionar Alumno: <img src="../../Imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0">
						</a>
					</td>
				  </tr>
			  </table>
			</td>
		  </tr>
		  <tr id="TRDatosEmp">
	  	  <td>
		  <cfinclude template="frame-header.cfm">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="tabContent">
				<cfif isDefined("Form.persona") >
					<cfoutput>
						<form name="Regresar" method="post" action="alumno.cfm"> 
							<input type="hidden" name="persona" value="#Form.persona#">
						</form>
					</cfoutput>
					<cfset regresar = "javascript: document.Regresar.submit();">
				</cfif>
				<cfinclude template="../../portlets/pNavegacionCED.cfm">
				</td>
			</tr>
			<tr>
			  <td class="tabContent">
					<cfif tabChoice eq 1>
						<cfinclude template="formAlumno.cfm">
					<cfelseif tabChoice eq 2>
						<cfinclude template="formEncarg.cfm">
					<cfelse>
						<div align="center">
						<b>Este m&oacute;dulo no est&aacute; disponible</b>
						</div>
					</cfif>
			  </td>
			</tr>
		  </table>
		  </td>
		  </tr>
			<tr id="TRBuscarEmp" style="display: none">
			  <td>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr> 
					  <td width="2%"class="Titulo"><img src="/cfmx/edu/Imagenes/sp.gif" width="15" height="15" border="0"></td>
					  <td width="3%" class="Titulo" >&nbsp;</td>
					  <td width="94%" class="Titulo">Consulta de Alumnos</td>
					  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="/cfmx/edu/Imagenes/rt.gif"></td>
					</tr>
					<tr> 
					  <td colspan="3" class="contenido-lbborder">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr valign="top">
								<td><cfinclude template="../../portlets/pNavegacionCED.cfm"></td>
							</tr>
						  <tr valign="top"> 
							<td>&nbsp;</td>
						  </tr>
						  <tr valign="top"> 
							<td align="center">
							  <cfinclude template="filtros/filtroAlumnoh.cfm"> 
							<cfif isdefined("form.btnFiltrar")>
								<cfinclude template="ListaAlumno.cfm">
							</cfif>
							</td>
						  </tr>
						  <tr valign="top"> 
							<td>&nbsp;</td>
						  </tr>
						</table>
					  </td>
					  <td class="contenido-brborder">&nbsp;</td>
					</tr>
				  </table>
			  </td>
			</tr>
		  <!--- Cuando todavía no se ha seleccionado un empleado --->
		  <cfelse>
		   <tr>
	  	  <td>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<!--- <tr> 
				  <td width="2%"class="Titulo"><img src="/cfmx/edu/Imagenes/sp.gif" width="15" height="15" border="0"></td>
				  <td width="3%" class="Titulo" >&nbsp;</td>
				  <td width="94%" class="Titulo">Consulta de Encargados</td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="/cfmx/edu/Imagenes/rt.gif"></td>
				</tr> --->
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td><cfinclude template="../../portlets/pNavegacionCED.cfm"></td>
						</tr>
					  <tr valign="top"> 
						<td>&nbsp;</td>
					  </tr>
					  <tr valign="top"> 
						<td align="center">
						<p class="tituloAlterno">Debe seleccionar un Alumno</p>
						<cfinclude template="filtros/filtroAlumnoh.cfm"> 
						<cfif isdefined("form.btnFiltrar")>
							<cfinclude template="ListaAlumno.cfm">
						</cfif>
						</td>
					  </tr>
					  <tr valign="top">  
						<td>&nbsp;</td>
					  </tr>
					</table>
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
		  </td>
		  </tr>
		  </cfif>
	  </table>
		<!---    
			<cfinclude template="formAlumno.cfm"> 
			<cfinclude template="filtros/filtroAlumnoh.cfm"> 
			<cfinclude template="ListaAlumno.cfm"> --->
			
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
