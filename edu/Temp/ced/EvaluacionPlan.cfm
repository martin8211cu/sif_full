<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenu04.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
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
    <td width="154" rowspan="2" align="center" valign="top"><img src="../../Imagenes/logo.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> 
	  <!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" rowspan="2" valign="middle">
		  	<cfset RolActual = 0>
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
        <tr class="area"> 
          <td valign="bottom" nowrap> 
	  <!-- InstanceBeginEditable name="MenuJS" --> 
            <cfinclude template="../jsMenuCED.cfm">
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
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->Titulo1<!-- InstanceEndEditable --></td>
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
		  <!-- InstanceBeginEditable name="TituloPortlet" -->Plan 
            de Evaluaci&oacute;n<!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  
			<table width="100%" border="0" cellpadding="2" cellspacing="2">
		  		<tr><td>
					<cfinclude template="../../portlets/pNavegacionCED.cfm">
				</td></tr>		
				<tr>
					<td valign="top"><cfinclude template="formEvaluacionPlan.cfm"></td>
				</tr>
				<tr>
					<td>
						<cfif isdefined('form.EPcodigo') and form.EPcodigo NEQ "">

							<cfif #rsFormLineas.lineas# gt 0>
								<cfinvoke 
								 component="educ.Componentes.pListas"
								 method="pLista"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="EvaluacionPlanConcepto epc, EvaluacionPlan ep, EvaluacionConcepto ec"/>
									<cfinvokeargument name="columnas" value="epc.EPcodigo, epc.EPCcodigo, epc.EPCnombre, ECnombre, convert(varchar, epc.EPCporcentaje) + '%' as EPCporcentaje"/>
									<cfinvokeargument name="desplegar" value="EPCnombre, ECnombre, EPCporcentaje"/>
									<cfinvokeargument name="etiquetas" value="Nombre, Concepto de Evaluaci&oacute;n, Porcentaje"/>
									<cfinvokeargument name="formatos" value="V, V, V"/>
									<cfinvokeargument name="filtro" value="epc.EPcodigo=ep.EPcodigo and epc.EPcodigo=#form.EPcodigo# and epc.ECcodigo=ec.ECcodigo" />
									<cfinvokeargument name="align" value="left, left, right"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="n"/>
									<cfinvokeargument name="irA" value="EvaluacionPlan.cfm"/>
								</cfinvoke>
							</cfif>	
						<cfelse>
							<cfif not isdefined('Form.NuevoL')>
							<cflocation addtoken="no" url='listaEvaluacionPlan.cfm'>
							</cfif>	
						</cfif>
					</td>
				</tr>
		  	</table>
			
		   
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
