<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.id#.value = id;
			window.opener.document.#Url.form#.#Url.cod#.value = cod;
			window.opener.document.#Url.form#.#Url.desc#.value = desc;			
			if (window.opener.func#Url.cod#) {window.opener.func#Url.cod#()}		
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.Descripcion") and not isdefined("Form.Descripcion")>
	<cfparam name="Form.Descripcion" default="#Url.Descripcion#">
</cfif>

<cfif isdefined("Url.RHGMcodigo") and not isdefined("Form.RHGMcodigo")>
	<cfparam name="Form.RHGMcodigo" default="#Url.RHGMcodigo#">
</cfif>

<cfif isdefined("Url.quitar") and not isdefined("Form.quitar")>
	<cfparam name="Form.quitar" default="#Url.quitar#">
</cfif>

<cfset navegacion = "">

<html>
<head>
<title>Lista de Cursos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroGrupoMaterias" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo:</strong></td>
		<td> 
			<input name="RHGMcodigo" id="RHGMcodigo" type="text" size="10" maxlength="10" value="<cfif isdefined("Form.RHGMcodigo")>#Form.RHGMcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n:</strong></td>
		<td><input name="Descripcion" type="text" id="Descripcion" size="40" maxlength="80" value="<cfif isdefined("Form.Descripcion")>#Form.Descripcion#</cfif>"> 
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsLista" datasource="#session.DSN#">
	Select RHGMid,RHGMcodigo,Descripcion
	from RHGrupoMaterias 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

 	<cfif isdefined("Form.Descripcion") and Len(Trim(Form.Descripcion)) NEQ 0>
		and upper(Descripcion) like '%#UCase(Form.Descripcion)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Descripcion=" & Form.Descripcion>
	</cfif>	
	<cfif isdefined("Form.RHGMcodigo") and Len(Trim(Form.RHGMcodigo)) NEQ 0>
		and upper(RHGMcodigo) like '%#UCase(Form.RHGMcodigo)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHGMcodigo=" & Form.RHGMcodigo>
	</cfif>	
	<cfif isdefined("Form.quitar") and Len(Trim(Form.quitar)) NEQ 0>
		and RHGMid not in (#Form.quitar#)
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "quitar=" & Form.quitar>
	</cfif>
	
	order by Descripcion
</cfquery>

<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="RHGMcodigo,Descripcion"/> 
	<cfinvokeargument name="etiquetas" value="C&oacute;digo,Grupo"/>
	<cfinvokeargument name="formatos" value="V, V"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N, N"/>
	<cfinvokeargument name="irA" value="conlisGrupoMaterias.cfm"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHGMid,RHGMcodigo,Descripcion"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>

</body>
</html>