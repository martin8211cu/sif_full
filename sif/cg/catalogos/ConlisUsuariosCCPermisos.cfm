<html>
<head>
<title>Lista de Usuarios por Concepto Contable</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.Cconcepto") and not isdefined("Form.Cconcepto")>
	<cfset Form.Cconcepto = Url.Cconcepto>
</cfif>
<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfset Form.form = Url.form>
</cfif>
<cfif isdefined("Url.usuario") and not isdefined("Form.usuario")>
	<cfset Form.usuario = Url.usuario>
</cfif>
<cfif isdefined("Url.nombre") and not isdefined("Form.nombre")>
	<cfset Form.nombre = Url.nombre>
</cfif>
<cfif isdefined("Url.fIdentificacion") and not isdefined("Form.fIdentificacion")>
	<cfset Form.fIdentificacion = Url.fIdentificacion>
</cfif>
<cfif isdefined("Url.Papellido1") and not isdefined("Form.Papellido1")>
	<cfset Form.Papellido1 = Url.Papellido1>
</cfif>
<cfif isdefined("Url.Papellido2") and not isdefined("Form.Papellido2")>
	<cfset Form.Papellido2 = Url.Papellido2>
</cfif>
<cfif isdefined("Url.Pnombre") and not isdefined("Form.Pnombre")>
	<cfset Form.Pnombre = Url.Pnombre>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.Cconcepto") and Len(Trim(Form.Cconcepto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Cconcepto=" & Form.Cconcepto>
</cfif>
<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.usuario") and Len(Trim(Form.usuario)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "usuario=" & Form.usuario>
</cfif>
<cfif isdefined("Form.nombre") and Len(Trim(Form.nombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombre=" & Form.nombre>
</cfif>

<cfif isdefined("Form.fIdentificacion") and Len(Trim(Form.fIdentificacion)) NEQ 0>
	<cfset filtro = filtro & " and b.Pid like '%" & UCase(Form.fIdentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fIdentificacion=" & Form.fIdentificacion>
</cfif>
<cfif isdefined("Form.Papellido1") and Len(Trim(Form.Papellido1)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.Papellido1) like '%" & UCase(Form.Papellido1) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Papellido1=" & Form.Papellido1>
</cfif>
<cfif isdefined("Form.Papellido2") and Len(Trim(Form.Papellido2)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.Papellido2) like '%" & UCase(Form.Papellido2) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Papellido2=" & Form.Papellido2>
</cfif>
<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.Pnombre) like '%" & UCase(Form.Pnombre) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pnombre=" & Form.Pnombre>
</cfif>

<!--- Lista de Usuarios Autorizados --->
<cfquery name="rsUsuariosAutorizados" datasource="#Session.DSN#">
	select distinct Usucodigo from UsuarioConceptoContableE  
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	and Cconcepto = <cfqueryparam value="#Form.Cconcepto#" cfsqltype="cf_sql_integer"> 
</cfquery>

<cfif rsUsuariosAutorizados.recordCount GT 0>
	<cfset filtro = filtro & " and a.Usucodigo not in (#ValueList(rsUsuariosAutorizados.Usucodigo, ',')#)">
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function Asignar(valor1, valor2) {
		window.opener.document.<cfoutput>#Form.form#.#Form.usuario#</cfoutput>.value = valor1;
		window.opener.document.<cfoutput>#Form.form#.#Form.nombre#</cfoutput>.value = valor2;		
		window.close();
	}
	function limpiarCampos() {
		document.conlis.fIdentificacion.value = '';	
		document.conlis.Papellido1.value = '';
		document.conlis.Papellido2.value = '';
		document.conlis.Pnombre.value = '';
	}
</script>

<cfoutput>
	<form name="filtroUsuario" method="post" action="#GetFileFromPath(GetTemplatePath())#">
		<cfif isdefined("Form.Cconcepto") and Len(Trim(Form.Cconcepto))>
			<input type="hidden" name="Cconcepto" value="#Form.Cconcepto#">
		</cfif>
		<cfif isdefined("Form.form") and Len(Trim(Form.form))>
			<input type="hidden" name="form" value="#Form.form#">
		</cfif>
		<cfif isdefined("Form.usuario") and Len(Trim(Form.usuario))>
			<input type="hidden" name="usuario" value="#Form.usuario#">
		</cfif>
		<cfif isdefined("Form.nombre") and Len(Trim(Form.nombre))>
			<input type="hidden" name="nombre" value="#Form.nombre#">
		</cfif>
		<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
			  <td class="tituloListas" nowrap>Identificaci&oacute;n</td> 
			  <td class="tituloListas">1&ordf; Apellido</td>
			  <td class="tituloListas">2&ordf; Apellido</td>
			  <td class="tituloListas">Nombre</td>
			  <td class="tituloListas">&nbsp;</td>
			</tr>
			
			<!--- Filtros --->
			<tr>
			  <td><input name="fIdentificacion" type="text" size="20" maxlength="60" value="<cfif isdefined("Form.fIdentificacion")>#Form.fIdentificacion#</cfif>"></td>
			  <td><input name="Papellido1" type="text" size="20" maxlength="10" value="<cfif isdefined("Form.Papellido1")>#Form.Papellido1#</cfif>"></td> 
			  <td><input name="Papellido2" type="text" size="20" maxlength="10" value="<cfif isdefined("Form.Papellido2")>#Form.Papellido2#</cfif>"></td>
			  <td><input name="Pnombre" type="text" size="20" maxlength="50" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>"></td>
			  <td nowrap>
				  <input type="submit" name="Filtrar" value="Filtrar">
				  <input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiarCampos();">
			  </td>
			</tr>
		</table>
	</form>
	</cfoutput>
	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="Usuario a, DatosPersonales b, vUsuarioProcesos c"/>
		<cfinvokeargument name="columnas" value="distinct a.Usucodigo, 
													   a.CEcodigo, b.Pid as fIdentificacion,
													   b.Pnombre, b.Papellido1, b.Papellido2,
													   {fn concat( {fn concat( {fn concat( {fn concat( b.Pnombre ,   ' ')}  , b.Papellido1 )} ,  ' ' )} , b.Papellido2 )} as Nombre, 
													  (case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as Estado"/>
			<cfinvokeargument name="desplegar" value="fIdentificacion, Nombre"/>
			<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre Completo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="a.datos_personales = b.datos_personales 
												  and a.Usucodigo = c.Usucodigo 
												  and c.Ecodigo = #Session.EcodigoSDC#
												  and a.CEcodigo = #Session.CEcodigo#
												  and a.Uestado = 1 
												  and a.Utemporal = 0
												  #filtro#
												  order by b.Papellido1, b.Papellido2, b.Pnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
		<cfinvokeargument name="formName" value="listaUsuarios"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="Usucodigo, Nombre"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="Conexion" value="asp"/>
	</cfinvoke>

</body>
</html>
