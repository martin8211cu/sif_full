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
				  <!-- InstanceBeginEditable name="TituloPortlet" --> 
            Lista de Contratos de Facturaci&oacute;n
			<!-- InstanceEndEditable -->
				  </td>
				  <td width="1%" valign="top" nowrap bgcolor="#ADADCA"><img src="../../Imagenes/rt.gif"></td>
				</tr>
				<tr> 
				  <td colspan="3" class="contenido-lbborder">
				  <!-- InstanceBeginEditable name="Mantenimiento2" -->
		<cfquery datasource="#Session.Edu.DSN#" name="rsBibliotecas">
				set nocount on
				declare @id numeric
				if not exists ( select 1 from BibliotecaCentroE BCE, MABiblioteca MAB
					where BCE.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and MAB.id_biblioteca = BCE.id_biblioteca
				)
				begin
					insert into MABiblioteca (nombre_biblio)
					values('Biblioteca')
				
					select @id = @@identity
					
					insert into BibliotecaCentroE (CEcodigo, id_biblioteca)
					values(<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,@id)
				end
				else  
					select 1
				set nocount off
		</cfquery>
		<cfif isdefined("Url.CEcontrato") and not isdefined("Form.CEcontrato")>
			<cfparam name="Form.CEcontrato" default="#Url.CEcontrato#">
		</cfif>
		<cfif not isdefined("Url.RegresarURL")>
			<cfset Session.Edu.RegresarUrl = "/cfmx/edu/ced/MenuCED.cfm">
		<cfelse>
			<cfset Session.Edu.RegresarUrl = Url.RegresarURL>
		</cfif>
		<cfinclude template="../../portlets/pNavegacionCED.cfm">
		<!--- <cfset Session.Edu.RegresarUrl = "listaBiblioteca.cfm"> --->
		<!-- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 25/06/2003 -->
		<form name="filtroContrato" method="post" action="listaContratos.cfm">
			<table width="100%" border="0" class="areaFiltro" cellpadding="0" cellspacing="0">
			  <tr> 
				  <td nowrap align="right">Contrato</td>
				<td nowrap><input name="CEcontrato" type="text" id="CEcontrato" size="60" onFocus="this.select()" maxlength="20" value="<cfif isdefined("Form.CEcontrato") AND Form.CEcontrato NEQ ""><cfoutput>#Form.CEcontrato#</cfoutput></cfif>"></td>
				<td align="center" nowrap><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
			  </tr>
			</table>
		</form>
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("Form.CEcontrato") AND Form.CEcontrato NEQ "">
			<cfset filtro = "and upper(rtrim(CEcontrato)) like upper('%" & #Trim(Form.CEcontrato)# & "%')">
			<cfset navegacion = "CEcontrato=" & Form.CEcontrato>
		</cfif>				
		<cfinvoke 
		 component="edu.Componentes.pListas"
		 method="pListaEdu"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="ContratoEdu CE "/>
			<cfinvokeargument name="columnas" value=" CEcontrato, substring(CEtitular,1,50) as CEtitular, substring(CEdescripcion,1,50) as CEdescripcion ,'listaContratos.cfm' as RegresarURL "/>
			<cfinvokeargument name="desplegar" value="CEcontrato ,CEdescripcion, CEtitular "/>
			<cfinvokeargument name="etiquetas" value="Contrato, Descripcin, Titular "/>
			<cfinvokeargument name="formatos" value="V,V,V"/>
			<cfinvokeargument name="filtro" value=" CE.CEcodigo = #Session.Edu.CEcodigo#  #filtro# order by CEcontrato "/>
			<cfinvokeargument name="align" value="left,left,left"/>
			<cfinvokeargument name="ajustar" value="N,N,N"/>
			<cfinvokeargument name="irA" value="Contratos.cfm"/>
			<cfinvokeargument name="botones" value="Nuevo"/>
			<cfinvokeargument name="corte" value=""/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
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