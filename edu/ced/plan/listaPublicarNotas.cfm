<!-- InstanceBegin template="/Templates/LMenuCED.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cfinclude template="../../Utiles/general.cfm">
<cf_template>
	<cf_templatearea name="title">
		Educaci&oacute;n
	</cf_templatearea>
	<cf_templatearea name="body">
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

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr> 
			<td valign="top">
				<cfset RolActual = 4>
				<cfset Session.RolActual = 4>
				<cfinclude template="../../portlets/pEmpresas2.cfm">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
				  <!-- InstanceBeginEditable name="TituloPortlet" -->Publicaci&oacute;n 
            de Notas para Cursos Lectivos<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		  <!--- Rodolfo Jimnez Jara, Soluciones Integrales S.A., Centroamerica, Costa Rica, 13/12/2002 --->
		<cfif isdefined("Url.SPEdescripcion") and not isdefined("Form.SPEdescripcion")>
			<cfparam name="Form.SPEdescripcion" default="#Url.SPEdescripcion#">
		</cfif>
		<cfset Session.Edu.RegresarUrl = "/cfmx/edu/ced/MenuCED.cfm">
		<cfinclude template="../../portlets/pNavegacionCED.cfm">
		<cfset Session.Edu.RegresarUrl = "listaPublicarNota.cfm">
		<form name="filtroPublicarNotas" method="post" action="ListaPublicarNotas.cfm">
			<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
			  <tr> 
				<td nowrap align="right">Curso Lectivo</td>
				<td nowrap><input name="SPEdescripcion" type="text" id="SPEdescripcion" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.SPEdescripcion") AND Form.SPEdescripcion NEQ ""><cfoutput>#Form.SPEdescripcion#</cfoutput></cfif>"></td>
				<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
			  </tr>
			</table>
		</form>
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("Form.SPEdescripcion") AND Form.SPEdescripcion NEQ "">
			<cfset filtro = "and upper(rtrim(SPEdescripcion)) like upper('%" & #Trim(Form.SPEdescripcion)# & "%')">
			<cfset navegacion = "SPEdescripcion=" & Form.SPEdescripcion>
		</cfif>				
		<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="SubPeriodoEscolar a, PeriodoEscolar b, Nivel c, PeriodoVigente d"/>
			<cfinvokeargument name="columnas" value="convert(varchar,a.PEcodigo) as PEcodigo, convert(varchar,a.SPEcodigo) as SPEcodigo, a.SPEorden, substring(a.SPEdescripcion,1,50) as SPEdescripcion, convert(varchar,a.SPEfechafin,103) as SPEfechafin, convert(varchar,a.SPEfechainicio,103) as SPEfechainicio , c.Ndescripcion + ' : ' + b.PEdescripcion as PEdescripcion, case when d.PEevaluacion is not null then 'Vigente' else '' end as Vigente"/>
			<cfinvokeargument name="desplegar" value="SPEdescripcion, SPEfechainicio, SPEfechafin, Vigente "/>
			<cfinvokeargument name="etiquetas" value="Nombre del Curso Lectivo, Fecha de Inicio, Fecha de T rmino, Vigente"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value=" c.CEcodigo = #Session.Edu.CEcodigo# and a.PEcodigo = b.PEcodigo and b.Ncodigo = c.Ncodigo and b.Ncodigo *= d.Ncodigo and a.PEcodigo *= d.PEcodigo and a.SPEcodigo *= d.SPEcodigo #filtro# order by c.Norden, b.PEorden, a.SPEorden"/>
			<cfinvokeargument name="align" value="left,left,left,center"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N"/>
			<cfinvokeargument name="irA" value="PublicarNotas.cfm"/>
			<cfinvokeargument name="cortes" value="PEdescripcion"/>
			<!--- <cfinvokeargument name="botones" value="Nuevo"/> --->
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="navegacion" value="#navegacion#" />
		</cfinvoke>
          <!-- InstanceEndEditable -->
				  </td>
				  <td class="contenido-brborder">&nbsp;</td>
				</tr>
			  </table>
			 </td>
		  </tr>
		</table>

	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->