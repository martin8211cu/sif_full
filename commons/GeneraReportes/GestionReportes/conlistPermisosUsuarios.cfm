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
function Asignar<cfoutput>#index#</cfoutput>(Usucodigo,usuario) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.Usucodigo<cfoutput>#form.index#</cfoutput>.value = Usucodigo;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.usuario<cfoutput>#form.index#</cfoutput>.value = usuario;
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pnombre=" & Form.Pnombre>
</cfif>
<cfif isdefined("Form.Papellido1") and Len(Trim(Form.Papellido1)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Papellido1=" & Form.Papellido1>
</cfif>
<cfif isdefined("Form.Papellido2") and Len(Trim(Form.Papellido2))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Papellido2=" & Form.Papellido2>
</cfif>

<html>
<head>
<title>Lista de Usuarios</title>
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
		<td width="8%" align="right" nowrap><strong>Nombre:</strong></td>
		<td width="26%">
			<input name="Pnombre" type="text" id="Pnombre" size="40" maxlength="60" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="9%" align="right" nowrap><strong>Apellidos:</strong></td>
		<td width="38%" nowrap>
			<input name="Papellido1" type="text" id="Papellido1" size="30" maxlength="60" value="<cfif isdefined("Form.Papellido1")>#Form.Papellido1#</cfif>" onFocus="javascript:this.select();">
			<input name="Papellido2" type="text" id="Papellido2" size="30" maxlength="60" value="<cfif isdefined("Form.Papellido2")>#Form.Papellido2#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td width="19%">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<cfquery name="lista" datasource="#session.DSN#">
	SELECT distinct u.Usucodigo, u.Usulogin, UPPER(b.Pnombre) + ' ' + UPPER(b.Papellido1) + ' ' + UPPER(b.Papellido2) as usuario
	FROM Usuario u
		INNER JOIN DatosPersonales b on u.datos_personales = b.datos_personales
		INNER JOIN vUsuarioProcesos a ON a.Usucodigo = u.Usucodigo
		INNER JOIN Empresas d ON d.EcodigoSDC = a.Ecodigo
		AND d.Ecodigo = #session.Ecodigo#
	WHERE CEcodigo = #session.CEcodigo#
		AND Uestado = 1
		AND NOT EXISTS (SELECT Usucodigo
					FROM RT_ReportePermiso rp
					WHERE rp.Usucodigo = u.Usucodigo AND rp.RPTId = <cfqueryparam cfsqltype="cf_sql_integer" value="#varRPTId#">)
	<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
		and upper(Pnombre) like '%#UCase(Form.Pnombre)#%'
	</cfif>
	<cfif isdefined("Form.Papellido1") and Len(Trim(Form.Papellido1)) NEQ 0>
		and upper(Papellido1) like '%#UCase(Form.Papellido1)#%'
	</cfif>
	<cfif isdefined("Form.Papellido2") and Len(Trim(Form.Papellido2)) NEQ 0>
		and upper(Papellido2) like '%#UCase(Form.Papellido2)#%'
	</cfif>
</cfquery>

<cfinvoke
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="query" value="#lista#"/>
	<cfinvokeargument name="desplegar" value="usuario,"/>
	<cfinvokeargument name="etiquetas" value="Usuario"/>
	<cfinvokeargument name="formatos" value="V"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisPermisosUsuarios.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar#index#"/>
	<cfinvokeargument name="fparams" value="Usucodigo,usuario"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="keys" value="Usucodigo"/>

</cfinvoke>
</body>
</html>