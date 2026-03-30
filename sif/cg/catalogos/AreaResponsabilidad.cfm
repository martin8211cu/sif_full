<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegación del form por tabs para que tenga un orden lógico.
 --->

<cf_templateheader title="&Aacute;reas de Responsabilidad">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="&Aacute;reas de Responsabilidad">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<cfset modo = "ALTA">
		<cfset navegacion = "SL=1">
		<cfset colsAdicionales = "">
		<cfset currentPage = GetFileFromPath(GetTemplatePath())>
		
		<cfif isdefined("Url.tab") and Len(Trim(Url.tab))>
			<cfparam name="form.tab" default="#Url.tab#">
		<cfelse>
			<cfparam name="form.tab" default="1">
		</cfif>
		<cfif isdefined("Url.CGARid") and Len(Trim(Url.CGARid))>
			<cfparam name="Form.CGARid" default="#Url.CGARid#">
		</cfif>
		<cfif isdefined("Url.PageNum_lista1") and Len(Trim(Url.PageNum_lista1))>
			<cfparam name="Form.PageNum_lista1" default="#Url.PageNum_lista1#">
		</cfif>
		<cfif isdefined("Url.fCGARcodigo") and Len(Trim(Url.fCGARcodigo))>
			<cfparam name="Form.fCGARcodigo" default="#Url.fCGARcodigo#">
		</cfif>
		<cfif isdefined("Url.fCGARdescripcion") and Len(Trim(Url.fCGARdescripcion))>
			<cfparam name="Form.fCGARdescripcion" default="#Url.fCGARdescripcion#">
		</cfif>
		<cfif isdefined("Url.fCGARresponsable") and Len(Trim(Url.fCGARresponsable))>
			<cfparam name="Form.fCGARresponsable" default="#Url.fCGARresponsable#">
		</cfif>
		
		<cfif isdefined("Form.CGARid") and Len(Trim(Form.CGARid)) and not isdefined("form.Nuevo")>
			<cfset modo = "CAMBIO">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "CGARid=" & Form.CGARid>
		</cfif>
		<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARcodigo=" & Form.fCGARcodigo>
			<cfset colsAdicionales = colsAdicionales & ", '" & Form.fCGARcodigo & "' as fCGARcodigo">
		</cfif>
		<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARdescripcion=" & Form.fCGARdescripcion>
			<cfset colsAdicionales = colsAdicionales & ", '" & Form.fCGARdescripcion & "' as fCGARdescripcion">
		</cfif>
		<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fCGARresponsable=" & Form.fCGARresponsable>
			<cfset colsAdicionales = colsAdicionales & ", '" & Form.fCGARresponsable & "' as fCGARresponsable">
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td><cfinclude template="AreaResponsabilidad-form.cfm"></td>
		  </tr>
		  <cfif modo EQ "CAMBIO">
		  <tr>
			<td align="right">
				<input type="button" id="btnFiltros" name="btnFiltros" value="Mostrar Filtros" onclick="javascript: showList();" tabindex="3" />
			</td>
		  </tr>
		  <tr id="trTabs" <cfif isdefined("Url.SL")>style="display: none;"</cfif>>
			<td><cfinclude template="AreaResponsabilidad-formDet.cfm"></td>
		  </tr>
		  </cfif>
		  <!---<tr id="trLista" <cfif modo EQ "CAMBIO" and not isdefined("Url.SL")>style="display: none;"</cfif>>--->
		  <tr>
			<td><cfinclude template="AreaResponsabilidad-lista.cfm"></td>
		  </tr>
		  <tr  id="trLista" >
			<td>&nbsp;</td>
		  </tr>
		</table>
		
		<script type="text/javascript">
			<!--
			<cfif modo EQ "CAMBIO">
			function tab_set_current (n) {
				<cfoutput>
				location.href = "#currentPage#?tab="+n+"&CGARid=#form.CGARid#";
				</cfoutput>
			}
			</cfif>

			function showList() {
				var a = document.getElementById("trLista");
				var b = document.getElementById("trTabs");
				var c = document.getElementById("btnFiltros");
				if (a && b) {
					if (a.style.display == "") {
						a.style.display = "none";
						b.style.display = "";
						c.value = "Mostrar Filtros";
					} else {
						a.style.display = "";
						b.style.display = "none";
						c.value = "Ocultar Filtros";
					}
				}
			}
			//-->
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>