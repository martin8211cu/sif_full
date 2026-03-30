<html>
<head>
<title>Lista de Categor&iacute;as</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
	<cfif isdefined("Url.f") and not isdefined("Form.f")>
		<cfparam name="Form.f" default="#Url.f#">
	</cfif>
	<cfif isdefined("Url.p0") and not isdefined("Form.p0")>
		<cfparam name="Form.p0" default="#Url.p0#">
	</cfif>
	<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
		<cfparam name="Form.p1" default="#Url.p1#">
	</cfif>
	<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
		<cfparam name="Form.p2" default="#Url.p2#">
	</cfif>
	<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
		<cfparam name="Form.p3" default="#Url.p3#">
	</cfif>
	<cfif isdefined("Url.p4") and not isdefined("Form.p4")>
		<cfparam name="Form.p4" default="#Url.p4#">
	</cfif>
	<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
		<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
	</cfif>
	<cfif isdefined("Url.RHPcodigoext") and not isdefined("Form.RHPcodigoext")>
		<cfparam name="Form.RHPcodigoext" default="#Url.RHPcodigoext#">
	</cfif>
	<cfif isdefined("Url.fRHTTcodigo") and not isdefined("Form.fRHTTcodigo")>
		<cfparam name="Form.fRHTTcodigo" default="#Url.fRHTTcodigo#">
	</cfif>
	<cfif isdefined("Url.fRHTTdescripcion") and not isdefined("Form.fRHTTdescripcion")>
		<cfparam name="Form.fRHTTdescripcion" default="#Url.fRHTTdescripcion#">
	</cfif>
	<cfif isdefined("Url.fRHMCcodigo") and not isdefined("Form.fRHMCcodigo")>
		<cfparam name="Form.fRHMCcodigo" default="#Url.fRHMCcodigo#">
	</cfif>
	<cfif isdefined("Url.fRHMCpaso") and not isdefined("Form.fRHMCpaso")>
		<cfparam name="Form.fRHMCpaso" default="#Url.fRHMCpaso#">
	</cfif>

	<!--- Requiere estos cinco parámetros --->
	<cfparam name="Form.f">
	<cfparam name="Form.p0">
	<cfparam name="Form.p1">
	<cfparam name="Form.p2">
	<cfparam name="Form.p3">
	<cfparam name="Form.p4">
	<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
	<script language="JavaScript" type="text/javascript">
		function Asignar(p0,p1,p2,p3,p4) {
			if (window.opener != null) {
				<cfoutput>
				window.opener.document.#Form.f#.#Form.p0#.value = p0;
				window.opener.document.#Form.f#.#Form.p1#.value = p1;
				window.opener.document.#Form.f#.#Form.p2#.value = p2;
				window.opener.document.#Form.f#.#Form.p3#.value = p3;
				window.opener.document.#Form.f#.#Form.p4#.value = p4;
				window.close();
				</cfoutput>
			}
		}
	</script>
	<cfset filtro = "">
	<cfset navegacion = "">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p0=" & Form.p0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4>
	<cfif isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext)) NEQ 0>
		<cfset filtro = filtro & " and upper(coalesce(ltrim(rtrim(RHPcodigoext)),ltrim(rtrim(RHPcodigo)))) = '" & Ucase(Trim(Form.RHPcodigoext)) & "'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigoext=" & Form.RHPcodigoext>
	</cfif>
	<cfif isdefined("Form.fRHTTcodigo") and Len(Trim(Form.fRHTTcodigo)) NEQ 0>
		<cfset filtro = filtro & " and RHTTcodigo like '%" & Form.fRHTTcodigo & "%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHTTcodigo=" & Form.fRHTTcodigo>
	</cfif>
	<cfif isdefined("Form.fRHTTdescripcion") and Len(Trim(Form.fRHTTdescripcion)) NEQ 0>
		<cfset filtro = filtro & " and RHTTdescripcion like '%" & Form.fRHTTdescripcion & "%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHTTdescripcion=" & Form.fRHTTdescripcion>
	</cfif>
	<cfif isdefined("Form.fRHMCcodigo") and Len(Trim(Form.fRHMCcodigo)) NEQ 0>
		<cfset filtro = filtro & " and RHMCcodigo like '%" & Form.fRHMCcodigo & "%'">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHMCcodigo=" & Form.fRHMCcodigo>
	</cfif>
	<cfif isdefined("Form.fRHMCpaso") and Len(Trim(Form.fRHMCpaso)) NEQ 0>
		<cfset filtro = filtro & " and RHMCpaso = " & Form.fRHMCpaso>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHMCpaso=" & Form.fRHMCpaso>
	</cfif>
	<cfoutput>
	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<form name="formfiltrocateg" method="post" action="../estructurasalarial/catalogos/ConlisCateg.cfm" style="margin:0 ">
		<input type="hidden" name="f" value="#Form.f#">
		<input type="hidden" name="p0" value="#Form.p0#">
		<input type="hidden" name="p1" value="#Form.p1#">
		<input type="hidden" name="p2" value="#Form.p2#">
		<input type="hidden" name="p3" value="#Form.p3#">
		<input type="hidden" name="p4" value="#Form.p4#">
		<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
			<input type="hidden" name="RHPcodigo" value="#Form.RHPcodigo#">
		</cfif>
		<cfif isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext)) NEQ 0>
			<input type="hidden" name="RHPcodigoext" value="#Form.RHPcodigoext#">
		</cfif>
		  <tr>
			<td nowrap><strong>&nbsp;</strong></td>
			<td nowrap><strong>Tipo Tabla</strong></td>
			<td nowrap><strong>Descripci&oacute;n</strong></td>
			<td nowrap><strong>Categor&iacute;a</strong></td>
			<td nowrap><strong>Paso</strong></td>
			<td nowrap><strong>&nbsp;</strong></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td><input <cfif isdefined("form.fRHTTcodigo")>value="#form.fRHTTcodigo#"</cfif> type="text" name="fRHTTcodigo" id="fRHTTcodigo" size="10" maxlength="5"></td>
			<td><input <cfif isdefined("form.fRHTTdescripcion")>value="#form.fRHTTdescripcion#"</cfif> type="text" name="fRHTTdescripcion" id="fRHTTdescripcion" size="60" maxlength="80"></td>
			<td><input <cfif isdefined("form.fRHMCcodigo")>value="#form.fRHMCcodigo#"</cfif> type="text" name="fRHMCcodigo" id="fRHMCcodigo" size="10" maxlength="5" onFocus="javascript:this.select();" ></td>
			<td><input <cfif isdefined("form.fRHMCpaso")>value="#form.fRHMCpaso#"</cfif> type="text" name="fRHMCpaso" id="fRHMCpaso" size="10" maxlength="10" onKeyPress="return acceptNum(event)" onFocus="javascript:this.select();" ></td>
			<td><input type="submit" value="Filtrar" name="Filtrar" id="Filtrar"></td>
		  </tr>
	</form>
	</table>
	</cfoutput>
	<cfset filtroPuesto = "">
	<cfset tablaPuesto = "">
	<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
		<cfset filtroPuesto = "and RHCategoriasTipoTabla.RHTCid = RHPuestosCategoria.RHTCid">
		<cfset tablaPuesto = ", RHPuestosCategoria">
	</cfif>
	<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRHRet">
			<cfinvokeargument name="tabla" value="RHCategoriasTipoTabla, RHTTablaSalarial #tablaPuesto#"/>
			<cfinvokeargument name="columnas" value="p0=RHCategoriasTipoTabla.RHTCid, p1=RHTTcodigo, p2=RHTTdescripcion, p3=RHMCcodigo, p4=RHMCpaso"/>
			<cfinvokeargument name="desplegar" value="p1,p2,p3,p4"/>
			<cfinvokeargument name="etiquetas" value="Tipo Tabla, Descripci&oacute;n, Categor&iacute;a, Paso"/>
			<cfinvokeargument name="formatos" value="S,S,S,S"/>
			<cfinvokeargument name="filtro" value="RHTTablaSalarial.Ecodigo = #Session.Ecodigo# #filtro# and RHCategoriasTipoTabla.RHTTid = RHTTablaSalarial.RHTTid #filtroPuesto# order by 2,3,4,5"/>
			<cfinvokeargument name="align" value="left,left,left,left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="ConlisCateg.cfm"/>
			<cfinvokeargument name="formName" value="listacateg"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="p0,p1,p2,p3,p4"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
</body>
</html>
