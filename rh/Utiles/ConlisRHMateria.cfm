<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id, name, sigla) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.id#.value = id;
			window.opener.document.#Url.form#.#Url.name#.value = name;
			window.opener.document.#Url.form#.#Url.sigla#.value = sigla;
			if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}		
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.Msiglas") and not isdefined("Form.Msiglas")>
	<cfparam name="Form.Msiglas" default="#Url.Msiglas#">
</cfif>
<cfif isdefined("Url.Mnombre") and not isdefined("Form.Mnombre")>
	<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
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
<form name="filtroMaterias" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>Descripci&oacute;n:</strong></td>
		<td><input name="Mnombre" type="text" id="Mnombre" size="40" maxlength="80" value="<cfif isdefined("Form.Mnombre")>#Form.Mnombre#</cfif>"> 
		</td>
		<td align="right"><strong>Siglas:</strong></td>
		<td> 
			<input name="Msiglas" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.Msiglas")>#Form.Msiglas#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsLista" datasource="#session.DSN#">
	Select Mcodigo,Mnombre,Msiglas
	from RHMateria
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	<cfif isdefined("Form.Mnombre") and Len(Trim(Form.Mnombre)) NEQ 0>
		and upper(Mnombre) like '%#UCase(Form.Mnombre)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre=" & Form.Mnombre>
	</cfif>	
	<cfif isdefined("Form.Msiglas") and Len(Trim(Form.Msiglas)) NEQ 0>
		and upper(Msiglas) like '%#UCase(Form.Msiglas)#%'
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Msiglas=" & Form.Msiglas>
	</cfif>	
	<cfif isdefined("Form.quitar") and Len(Trim(Form.quitar)) NEQ 0>
		and Mcodigo not in (#Form.quitar#)
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "quitar=" & Form.quitar>
	</cfif>	
</cfquery>

<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="Mnombre,Msiglas"/> 
	<cfinvokeargument name="etiquetas" value="Materia, Sigla"/>
	<cfinvokeargument name="formatos" value="V, V"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N, N"/>
	<cfinvokeargument name="irA" value="conlisRHMateria.cfm"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Mcodigo, Mnombre, Msiglas"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>

</body>
</html>



<!--- </cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="Materia"/>
	<cfinvokeargument name="columnas" value="Mcodigo, Mcodificacion, Mnombre"/>
	<cfinvokeargument name="desplegar" value="Mcodificacion, Mnombre"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisMateria.cfm"/>
	<cfinvokeargument name="formName" value="listaMateria"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Mcodigo, Mcodificacion, Mnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke> --->