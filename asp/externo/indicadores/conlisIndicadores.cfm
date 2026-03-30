<script language="JavaScript" type="text/javascript">
	function Asignar(indicador,nombre_indicador) {
		window.opener.document.form1.indicador_detalle.value=indicador;
		window.opener.document.form1.indicador_detalle_nombre.value=nombre_indicador;
		window.close();
	}

</script>

<cfif isdefined("url.indicador") and not isdefined("form.indicador")>
	<cfparam name="form.indicador" default="#url.indicador#">
</cfif>
<cfif isdefined("url.nombre_indicador") and not isdefined("form.nombre_indicador")>
	<cfparam name="form.nombre_indicador" default="#url.nombre_indicador#">
</cfif>

<cfset filtro = '' >
<cfset navegacion = '' >

<cfif isdefined("form.indicador") and Len(Trim(form.indicador)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "indicador=" & form.indicador>
</cfif>

<cfif isdefined("form.nombre_indicador") and Len(Trim(form.nombre_indicador)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombre_indicador=" & Form.nombre_indicador>
</cfif>

<html>
<head>
<title>Lista de Indicadores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfoutput>
<form style="margin:0; " name="filtro" method="post" action="conlisIndicadores.cfm">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<tr>
			<td ><strong>Indicador:&nbsp;</strong></td>
			<td><input name="indicador" type="text" size="15" maxlength="10" onFocus="this.select();" value="<cfif isdefined('form.indicador') and len(trim(form.indicador)) >#form.indicador#</cfif>"></td>
			<td ><strong>Nombre:&nbsp;</strong></td>
			<td><input name="nombre_indicador" type="text" size="60" maxlength="255" onFocus="this.select();" value="<cfif isdefined('form.nombre_indicador') and len(trim(form.nombre_indicador)) >#form.nombre_indicador#</cfif>"></td>
			<td width="1%" ><input type="submit" name="Filtrar" value="Filtrar"></td>
		</tr>
	</tr>
</table>
</form>

	<cfquery name="rsLista" datasource="asp">
		select indicador, nombre_indicador
		from Indicador
		where 1 = 1

		<cfif isdefined("form.indicador") and Len(Trim(form.indicador)) NEQ 0>
			and upper(rtrim(ltrim(indicador))) like '%#UCase(trim(form.indicador))#%'
		</cfif>
		
		<cfif isdefined("form.nombre_indicador") and Len(Trim(form.nombre_indicador)) NEQ 0>
			and upper(rtrim(ltrim(nombre_indicador))) like '%#UCase(trim(form.nombre_indicador))#%'
		</cfif>

		order by indicador
	</cfquery>

</cfoutput>
<cfinvoke 
 component="commons.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="indicador, nombre_indicador"/>
	<cfinvokeargument name="etiquetas" value="Indicador, Nombre"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisIndicador.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="indicador,nombre_indicador"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="asp"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="ShowEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>