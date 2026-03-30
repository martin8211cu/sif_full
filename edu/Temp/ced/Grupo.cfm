<cfinclude template="../../Utiles/general.cfm">
<html><!-- InstanceBegin template="/Templates/LMenu04.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>Educaci&oacute;n</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
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
    <td width="100%" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" -->
	<!-- InstanceEndEditable --></td>
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
		  	Mantenimiento de Grupos
		  <!-- InstanceEndEditable -->
		  </td>
          <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
        </tr>
        <tr> 
          <td colspan="3" class="contenido-lbborder">
		  <!-- InstanceBeginEditable name="Mantenimiento2" -->
			<cfquery datasource="#Session.DSN#" name="rsNiveles">
				select convert(varchar, Ncodigo) as Ncodigo, Ndescripcion from Nivel 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				order by Norden
			</cfquery>
			
			<cfquery datasource="#Session.DSN#" name="rsGrado">
				select convert(varchar, b.Ncodigo)
					   + '|' + convert(varchar, b.Gcodigo) as Codigo, 
					   b.Gdescripcion
				from Nivel a, Grado b
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and a.Ncodigo = b.Ncodigo 
				order by a.Norden, b.Gorden
			</cfquery>
			
			<script language="JavaScript" type="text/javascript">
				var gradostext = new Array();
				var grados = new Array();
				var niveles = new Array();
			
				// Esta función únicamente debe ejecutarlo una vez
				function obtenerGrados(f) {
					for(i=0; i<f.FGcodigo.length; i++) {
						var s = f.FGcodigo.options[i].value.split("|");
						// Códigos de los detalles
						niveles[i]= s[0];
						grados[i] = s[1];
						gradostext[i] = f.FGcodigo.options[i].text;
					}
				}
				
				function cargarGrados(csource, ctarget, vdefault, t){
					// Limpiar Combo
					for (var i=ctarget.length-1; i >=0; i--) {
						ctarget.options[i]=null;
					}
					var k = csource.value;
					var j = 0;
					if (t) {
						var nuevaOpcion = new Option("Todos","-1");
						ctarget.options[j]=nuevaOpcion;
						j++;
					}
					if (k != "-1") {
						for (var i=0; i<grados.length; i++) {
							if (niveles[i] == k) {
								nuevaOpcion = new Option(gradostext[i],grados[i]);
								ctarget.options[j]=nuevaOpcion;
								if (vdefault != null && grados[i] == vdefault) {
									ctarget.selectedIndex = j;
								}
								j++;
							}
						}
					} else {
						for (var i=0; i<grados.length; i++) {
							nuevaOpcion = new Option(gradostext[i],grados[i]);
							ctarget.options[i+1]=nuevaOpcion;
						}
					}
					if (!t) {
						var j = ctarget.length;
						nuevaOpcion = new Option("-------------------","");
						ctarget.options[j++]=nuevaOpcion;
						nuevaOpcion = new Option("Crear Nuevo ...","0");
						ctarget.options[j]=nuevaOpcion;
					}
				}
			</script>

			<cfinclude template="../../portlets/pNavegacionCED.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left: 10px">
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td valign="top" width="50%">
						<form action="Grupo.cfm" method="post" name="FiltroGrupo">
							<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
								<tr>
									<td width="50%" nowrap>Nivel 
										<select name="FNcodigo" id="FNcodigo" tabindex="5" onChange="javascript: cargarGrados(this, this.form.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true)">
											<option value="-1">Todos</option>
										  <cfoutput query="rsNiveles"> 
											<option value="#Ncodigo#" <cfif isdefined("Form.FNcodigo") AND (Form.FNcodigo EQ rsNiveles.Ncodigo)>selected</cfif>>#Ndescripcion#</option>
										  </cfoutput> 
										</select>
									</td>
									<td width="50%" nowrap>Grado 
										<select name="FGcodigo" id="FGcodigo" tabindex="5">
										  <cfoutput query="rsGrado"> 
											<option value="#Codigo#">#Gdescripcion#</option>
										  </cfoutput> 
										</select>
									</td>
									<td align="center">
										<input type="submit" name="btnFiltrar" value="Filtrar">
									</td>
								</tr>
							</table>
						</form>
						 <cfset filtro = "">
						 <cfset f1 = "-1">
						 <cfset f2 = "-1">
						 <cfif isdefined("Form.FNcodigo") and Form.FNcodigo NEQ -1>
							<cfset filtro = filtro & " and c.Ncodigo = " & Form.FNcodigo>
							<cfset f1 = Form.FNcodigo>
						 </cfif>
						 <cfif isdefined("Form.FGcodigo") and Form.FGcodigo NEQ -1>
							<cfset filtro = filtro & " and c.Gcodigo = " & Form.FGcodigo>
							<cfset f2 = Form.FGcodigo>
						 </cfif>
						<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="Nivel a, Grado b, Grupo c "/>
							<cfinvokeargument name="columnas" value="'#f1#' as FNcodigo, '#f2#' as FGcodigo, convert(varchar, c.GRcodigo) as GRcodigo, rtrim(a.Ndescripcion) + ' : ' + rtrim(b.Gdescripcion) as Grado, rtrim(c.GRnombre) as GRnombre"/>
							<cfinvokeargument name="desplegar" value="GRnombre"/>
							<cfinvokeargument name="etiquetas" value="Grupo"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value=" a.CEcodigo = #Session.CEcodigo# and a.Ncodigo = b.Ncodigo and b.Ncodigo = c.Ncodigo and b.Gcodigo = c.Gcodigo #filtro# order by a.Norden, b.Gorden, c.GRnombre "/>
							<cfinvokeargument name="align" value="left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="MaxRows" value="15"/>
							<cfinvokeargument name="irA" value="Grupo.cfm"/>
							<cfinvokeargument name="cortes" value="Grado"/>
						</cfinvoke>
					</td>
					<td valign="top">
						<cfinclude  template="formGrupo.cfm"> 
					</td>
				</tr>
			</table>

			<script language="JavaScript" type="text/JavaScript">
				//OcultaTablaEval(document.form1);
				obtenerGrados(document.FiltroGrupo);
				cargarGrados(document.FiltroGrupo.FNcodigo, document.FiltroGrupo.FGcodigo, '<cfif isdefined("Form.FGcodigo")><cfoutput>#Form.FGcodigo#</cfoutput></cfif>', true);
				cargarGrados(document.form1.Ncodigo, document.form1.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsGrupo.Gcodigo#</cfoutput></cfif>', false);
			</script>
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
