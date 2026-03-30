<!----///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	El conlis devuelve el Usucodigo y el nombre del usuario en un campo usuario+index (Nombre + apellido1 + apellido2)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////----->
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario = url.formulario>
<cfelse>
	<cfset form.formulario = form1>
</cfif>
<cfif isdefined("url.index") and not isdefined("form.index")>
	<cfset form.index = url.index>
</cfif>
<cfif isdefined('url.RPTId')>
	<cfset varRPTId = #url.RPTId#>
</cfif>
<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar<cfoutput>#index#</cfoutput>(SRcodigo,SScodigo) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.SRcodigo<cfoutput>#form.index#</cfoutput>.value = SRcodigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.SScodigo<cfoutput>#form.index#</cfoutput>.value = SScodigo;
		window.close();
	}
}
</script>

<cfset navegacion = "">

<cfif isdefined("Form.Rol") and Len(Trim(Form.Rol)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SRcodigo=" & Form.Rol>
</cfif>
<cfif isdefined("Form.Descripcion") and Len(Trim(Form.Descripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SRdescripcion=" & Form.Descripcion>
</cfif>

<html>
<head>
<title>Lista de Roles</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroCursos" method="post">
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
	<cfif Len(Trim(index))>
		<input type="hidden" name="index" value="#index#">
	</cfif>
	<tr>
		<td width="8%" align="right" nowrap><strong>Rol:</strong></td>
		<td width="26%">
			<input name="Rol" type="text" id="Rol" size="40" maxlength="60" value="<cfif isdefined("Form.Rol")>#Form.Rol#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="9%" align="right" nowrap><strong>Descripci&oacuten:</strong></td>
		<td width="38%" nowrap>
			<input name="Descripcion" type="text" id="Descripcion" size="30" maxlength="60" value="<cfif isdefined("Form.Descripcion")>#Form.Descripcion#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="19%">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinclude template="../../../sif/Utiles/sifConcat.cfm">

<cfquery name="rsRoles" datasource="sifcontrol">
	SELECT UPPER(SRcodigo) as SRcodigo
	FROM RT_ReportePermiso
	WHERE SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
	AND RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#varRPTId#">
</cfquery>

	<cfset listRoles = "">

	<cfloop query="rsRoles">
		<cfset listRoles = ListAppend(listRoles,"'"&rsRoles.SRcodigo&"'")>
	</cfloop>

<cfquery name="lista" datasource="asp">
	SELECT UPPER(SScodigo) as SScodigo,UPPER(SRcodigo) as SRcodigo,UPPER(SRdescripcion) as SRdescripcion
	FROM SRoles
	WHERE SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
	<cfif isdefined('rsRoles') and rsRoles.RecordCount GT 0>
		AND UPPER(SRcodigo) NOT IN (#preservesinglequotes(listRoles)#)
	</cfif>
	<cfif isdefined("Form.Rol") and Len(Trim(Form.Rol)) NEQ 0>
		AND UPPER(SRcodigo) like '%#UCase(Form.Rol)#%'
	</cfif>
	<cfif isdefined("Form.Descripcion") and Len(Trim(Form.Descripcion)) NEQ 0>
		AND UPPER(SRdescripcion) like '%#UCase(Form.Descripcion)#%'
	</cfif>
</cfquery>

<cfinvoke
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#lista#"/>
	<cfinvokeargument name="desplegar" value="SRcodigo,SRdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Rol,Descripcion"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisPermisosRoles.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar#index#"/>
	<cfinvokeargument name="fparams" value="SRcodigo,SScodigo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="keys" value="SRcodigo"/>

</cfinvoke>
</body>
</html>