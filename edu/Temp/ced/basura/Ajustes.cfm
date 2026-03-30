<cfinclude template="../../Utiles/general.cfm">

<cfif isdefined("Form.chk") AND isdefined("form.Aplicar") >
	<cfset datos = ArrayNew(1)>
	<cfloop index = "index" list = "#Form.chk#" delimiters = ",">
		<cfset i = 1>
		<cfloop index = "index1" list = "#index#" delimiters = "|">
			<cfset datos[i] = index1>
			<cfset i = i + 1>
		</cfloop>
		
		<cftry>
			<cfstoredproc procedure="IN_AjusteInventario" datasource="#session.DSN#">
				<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@ID"      value="#datos[5]#" type="in">
				<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Ecodigo" value="#Session.Ecodigo#" type="in">
				<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@usuario" value="#Session.usuario#" type="in">
				<cfprocparam cfsqltype="cf_sql_char"    dbvarname="@debug"   value="N" type="in">
			</cfstoredproc>
			<cfcatch type="database">
				<cfset params = "errType=0&errMsg=" & UrlEncodedFormat(cfcatch.Detail)>
				<cflocation addtoken="no" url="../../errorPages/BDerror.cfm?#params#">
				<cfabort>
			</cfcatch>
		</cftry>
	</cfloop>
	<cflocation addtoken="no" url="listaAjuste.cfm">	
</cfif>	


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
	  <script language="JavaScript" src="../../js/calendar.js"></script>
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



			<div align="center">
				<table border="0" width="100%">		
					<tr> 
						<td >
						    <cfoutput>
								<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
									<tr align="left"> 
										<td><a href="#Session.root#">SIF</a></td>
										<td>|</td>
										<td nowrap><a href="#Session.rutaIV#MenuIV.cfm">Inventarios</a></td>
										<td>|</td>
										<td width="100%"><a href="#Session.rutaIV#operacion/listaAjuste.cfm">Regresar</a></td>
									 </tr>
								</table>
							</cfoutput>
						</td>
					</tr>
					
					<tr>
						<td>
							<cfinclude template="formAjustes.cfm">
						</td>
					</tr>
					
					<tr>
						<td>
							<cfif isdefined('Form.EAid') and Form.EAid NEQ "">
							<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pLista"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="DAjustes a, Articulos b"/>
								<cfinvokeargument name="columnas" value="a.EAid, a.DALinea, b.Adescripcion, a.DAcantidad, a.DAcosto, (case a.DAtipo when 1 then 'Salida' when 0 then 'Entrada' end) as Tipo"/>
								<cfinvokeargument name="desplegar" value="Adescripcion, Tipo, DAcantidad, DAcosto"/>
								<cfinvokeargument name="etiquetas" value="Art&iacute;culo, Tipo, Cantidad, Costo"/>
								<cfinvokeargument name="formatos" value="V, V, M, M"/>
								<cfinvokeargument name="filtro" value="a.Aid = b.Aid and a.EAid = #form.EAid# order by b.Adescripcion" />
								<cfinvokeargument name="align" value="left, left, rigth, right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="n"/>
								<cfinvokeargument name="irA" value="Ajustes.cfm"/>
							</cfinvoke>
							<cfelse>
								<cfif not isdefined('Form.NuevoL')>
								<cflocation addtoken="no" url='listaAjuste.cfm'>
								</cfif>	
							</cfif>
						</td>
					</tr>
					
				</table>	
			</div>			
		  
            <!-- InstanceEndEditable --></td>
          <td class="contenido-brborder">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
