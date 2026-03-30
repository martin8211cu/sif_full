<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
	  <cf_web_portlet_start titulo="Lista de Acciones de Personal">
			<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
			
			<cfif isdefined("Url.RHTid") and not isdefined("Form.RHTid")>
				<cfparam name="Form.RHTid" default="#Url.RHTid#">
			</cfif>
			<cfif isdefined("Url.RHTcodigo") and not isdefined("Form.RHTcodigo")>
				<cfparam name="Form.RHTcodigo" default="#Url.RHTcodigo#">
			</cfif>
			<cfif isdefined("Url.RHTdesc") and not isdefined("Form.RHTdesc")>
				<cfparam name="Form.RHTdesc" default="#Url.RHTdesc#">
			</cfif>

			<cfset filtro = "">
			<cfset navegacion = "">
			<cfif isdefined("Form.RHTid") and Len(Trim(Form.RHTid)) NEQ 0>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTid=" & Form.RHTid>
			</cfif>
			<cfif isdefined("Form.RHTcodigo") and Len(Trim(Form.RHTcodigo)) NEQ 0>
				<cfset filtro = filtro & " and upper(a.RHTcodigo) like '%" & #UCase(Form.RHTcodigo)# & "%'">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTcodigo=" & Form.RHTcodigo>
			</cfif>
			<cfif isdefined("Form.RHTdesc") and Len(Trim(Form.RHTdesc)) NEQ 0>
				<cfset filtro = filtro & " and upper(a.RHTdesc) like '%" & #UCase(Form.RHTdesc)# & "%'">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTdesc=" & Form.RHTdesc>
			</cfif>
			
			<cfoutput>
			<form name="filtroTipoAccion" method="post" action="#CurrentPage#">
				<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				  <tr> 
					<td align="right">C&oacute;digo</td>
					<td> 
					  <input name="RHTcodigo" type="text" id="RHTcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.RHTcodigo")>#Form.RHTcodigo#</cfif>">
					</td>
					<td align="right">Descripci&oacute;n</td>
					<td> 
					  <input name="RHTdesc" type="text" id="RHTdesc" size="40" maxlength="80" value="<cfif isdefined("Form.RHTdesc")>#Form.RHTdesc#</cfif>">
					</td>
					<td align="center">
					  <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
					</td>
				  </tr>
				</table>
			</form>
			</cfoutput>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="RHTipoAccion a"/>
				<cfinvokeargument name="columnas" value="a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTindefinido, substring( RHTdesc, 1, 16) as descTrunck,revisar=1"/>
				<cfinvokeargument name="desplegar" value="RHTcodigo, RHTdesc"/>
				<cfinvokeargument name="etiquetas" value="Tipo de Acción, Nombre de Acción"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.RHTcodigo, a.RHTdesc"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="SQLdefinicion.cfm"/>
				<cfinvokeargument name="formName" value="listaTipoAccion"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="fparams" value="RHTid, RHTcodigo, RHTdesc, RHTindefinido"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		  </td>
        </tr>
      </table>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->