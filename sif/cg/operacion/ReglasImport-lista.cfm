<cfif isdefined("Url.filtro_PCREIdescripcion")>
	<cfparam name="Form.filtro_PCREIdescripcion" default="#Url.filtro_PCREIdescripcion#">
</cfif>
<cfif isdefined("Url.filtro_PCREIfecha")>
	<cfparam name="Form.filtro_PCREIfecha" default="#Url.filtro_PCREIfecha#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.filtro_PCREIdescripcion") and Len(Trim(Form.filtro_PCREIdescripcion))>
	<cfset navegacion = navegacion & Iif(Len(Trim(Form.filtro_PCREIdescripcion)), DE("&"), DE("")) & "filtro_PCREIdescripcion=" & Form.filtro_PCREIdescripcion>
</cfif>
<cfif isdefined("Form.filtro_PCREIfecha") and Len(Trim(Form.filtro_PCREIfecha))>
	<cfset navegacion = navegacion & Iif(Len(Trim(Form.filtro_PCREIfecha)), DE("&"), DE("")) & "filtro_PCREIfecha=" & Form.filtro_PCREIfecha>
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.PCREIid, a.PCREIdescripcion, a.PCREIfecha
	from PCReglasEImportacion a
	where a.Ecodigo = #Session.Ecodigo#
	and a.PCREestado = 0
	<cfif isdefined("Form.filtro_PCREIdescripcion") and Len(Trim(Form.filtro_PCREIdescripcion))>
		and upper(a.PCREIdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(Form.filtro_PCREIdescripcion))#%">
	</cfif>
	<cfif isdefined("Form.filtro_PCREIfecha") and Len(Trim(Form.filtro_PCREIfecha))>
		and a.PCREIfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.filtro_PCREIfecha)#">
	</cfif>
	order by a.PCREIfecha
</cfquery>

<script language="javascript" type="text/javascript">
	function funcAplicar() {
		if (document.listaReglas.chk) {
			if (document.listaReglas.chk.value) {
				return (document.listaReglas.chk.checked);
			} else {
				for (var i=0; i<document.listaReglas.chk.length; i++) {
					if (document.listaReglas.chk[i].checked) return true;
				}
			}
		}
		return false;
	}

</script>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
  	<td>
		<cfoutput>
			<form name="listaFiltros" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
			  <tr>
				<td class="fileLabel" align="right">
					Descripci&oacute;n
				</td>
				<td>
					<input type="text" name="filtro_PCREIdescripcion" size="40" value="<cfif isdefined("Form.filtro_PCREIdescripcion")>#Form.filtro_PCREIdescripcion#</cfif>">
				</td>
				<td class="fileLabel" align="right">
					Fecha
				</td>
				<td>
					<cfif isdefined("Form.filtro_PCREIfecha")>
						<cfset fecha = Form.filtro_PCREIfecha>
					<cfelse>
						<cfset fecha = "">
					</cfif>
					<cf_sifcalendario form="listaFiltros" name="filtro_PCREIfecha" value="#fecha#">
				</td>
				<td align="center">
					<input type="submit" name="butFiltrar" value="Filtrar" onclick="if (window.funcFiltrar) funcFiltrar();  this.form.submit();">
				</td>
			  </tr>
			</table>
			</form>
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="PCREIdescripcion, PCREIfecha"/>
			<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha"/>
			<cfinvokeargument name="formatos" value="V,D"/>
			<cfinvokeargument name="align" value="left, center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="ReglasImport.cfm"/>
			<cfinvokeargument name="checkboxes" value="N"/>
			<cfinvokeargument name="keys" value="PCREIid"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="formName" value="listaReglas"/>
			<cfinvokeargument name="botones" value="Importar"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="PageIndex" value="1"/>
		</cfinvoke>
	</td>
  </tr>
  <tr>
  	<td>&nbsp;</td>
  </tr>
</table>

