<html>
<head>
<title>Lista de Puestos de RH</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset LvarEmpresa = Session.Ecodigo>

<cfset navegacion = ''>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>
<cfif isdefined("Url.RHPcodigoext") and not isdefined("Form.RHPcodigoext")>
	<cfparam name="Form.RHPcodigoext" default="#Url.RHPcodigoext#">
</cfif>
<cfif isdefined("Url.RHPdescpuesto") and not isdefined("Form.RHPdescpuesto")>
	<cfparam name="Form.RHPdescpuesto" default="#Url.RHPdescpuesto#">
</cfif>
<cfif isdefined("Url.RHMPPid") and not isdefined("Form.RHMPPid")>
	<cfparam name="Form.RHMPPid" default="#Url.RHMPPid#">
</cfif>

<!----Filtro de empresa----->
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<!----========================= TRADUCCION ===========================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"
	returnvariable="BTN_Cerrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"	
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"	
	returnvariable="LB_Descripcion"/>	
	

<script language="JavaScript" type="text/javascript">
function funcAsignar(RHPcodigo,RHPcodigoext,RHPdescpuesto){
	if (window.opener != null) {
		<cfoutput>		
			//Plaza de RH
			window.opener.document.#Url.form#.RHPcodigo.value = RHPcodigo;
			window.opener.document.#Url.form#.RHPcodigoext.value = RHPcodigoext;
			window.opener.document.#Url.form#.RHPdescpuesto.value = RHPdescpuesto;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "empresa=" & LvarEmpresa>
<cfif isdefined("Form.RHMPPid") and Len(Trim(Form.RHMPPid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHMPPid=" & Form.RHMPPid>
</cfif>
<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
</cfif>
<cfif isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigoext=" & Form.RHPcodigoext>
</cfif>
<cfif isdefined("Form.RHPdescpuesto") and Len(Trim(Form.RHPdescpuesto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescpuesto=" & Form.RHPdescpuesto>
</cfif>

<cfoutput>
<br>
<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center">
	<tr>
		<td align="center"><strong><cf_translate key="LB_Puestos_de_RH">Puestos de RH</cf_translate></strong></td>		
	</tr>
	<tr>
		<td>
			<form name="form_filtro" method="post" action="">
				<input type="hidden" name="RHPcodigo" value="<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>#form.RHPcodigo#</cfif>">
				<table width="98%" border="0" cellpadding="1" cellspacing="0" align="center" class="areaFiltro">
					<tr>
						<td>&nbsp;</td>
						<td width="21%" nowrap><strong><cf_translate key="LB_Codigo">C&oacute;digo:</cf_translate>&nbsp;</strong></td>	
						<td width="51%" nowrap><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n:</cf_translate>&nbsp;</strong></td>	
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr class="areaFiltro">
						<td>&nbsp;</td>
						<td width="21%">
							<input type="text" name="RHPcodigoext" value="<cfif isdefined("form.RHPcodigoext") and len(trim(form.RHPcodigoext))>#form.RHPcodigoext#</cfif>" size="10" maxlength="10">
						</td>
						<td width="51%">
							<input type="text" name="RHPdescpuesto" value="<cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>#form.RHPdescpuesto#</cfif>" size="30" maxlength="80">
						</td>
						<td width="12%">
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
						</td>
						<td width="13%">
							<input name="btnCerrar" type="submit" id="btnCerrar" value="#BTN_Cerrar#" onClick="javascript: window.close();">
						</td>
					</tr>
				</table>	
			</form>	
		</td>
	</tr>
	<tr>
		<td align="center">
			<cfquery name="rsPuestos" datasource="#session.DSN#">
				select RHPcodigo, coalesce(ltrim(rtrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo))) as RHPcodigoext, RHPdescpuesto
				from RHPuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
					and RHPactivo = 1					
					<cfif isdefined("form.RHMPPid") and len(trim(form.RHMPPid))>
						and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHMPPid#">
					</cfif>
					<cfif isdefined("form.RHPcodigoext") and len(trim(form.RHPcodigoext))>
						and upper(coalesce(ltrim(rtrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo)))) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.RHPcodigoext)#%">
					</cfif>
					<cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>
						and upper(RHPdescpuesto) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.RHPdescpuesto)#%">
					</cfif>
			</cfquery>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaEduRet">
			  <cfinvokeargument name="query" value="#rsPuestos#"/>
			  <cfinvokeargument name="desplegar" value="RHPcodigoext,RHPdescpuesto"/>
			  <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
			  <cfinvokeargument name="formatos" value=""/>
			  <cfinvokeargument name="align" value="left, left"/>
			  <cfinvokeargument name="ajustar" value=""/>
			  <cfinvokeargument name="irA" value="ConlisPuestos_acciones.cfm"/>
			  <cfinvokeargument name="MaxRows" value="12"/>
			  <cfinvokeargument name="funcion" value="funcAsignar"/>
			  <cfinvokeargument name="fparams" value="RHPcodigo,RHPcodigoext,RHPdescpuesto"/>
			  <cfinvokeargument name="navegacion" value="#navegacion#"/>
			  <cfinvokeargument name="debug" value="N"/>
			  <cfinvokeargument name="showEmptyListMsg" value="yes"/>			 
		  </cfinvoke>				
		</td>
	</tr>
</table>
</cfoutput>
</body>
</html>
