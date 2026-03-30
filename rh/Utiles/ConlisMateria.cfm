<!--- Recibe conexion, form, name y desc --->
<cfdump var="#url#">


<script language="JavaScript" type="text/javascript">
function Asignar(id, name,desc) {
	if (window.opener != null) {
		<cfoutput>
		var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}		
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
	<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
</cfif>
<cfif isdefined("Url.Mnombre") and not isdefined("Form.Mnombre")>
	<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(Mcodigo) like '%" & #UCase(Form.Mcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodigo=" & Form.Mcodigo>
</cfif>
<cfif isdefined("Form.Mnombre") and Len(Trim(Form.Mnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Mnombre) like '%" & #UCase(Form.Mnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre=" & Form.Mnombre>
</cfif>
<html>
<head>
<title>Lista de Materias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMaterias" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="Mcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="Mnombre" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.Mnombre")>#Form.Mnombre#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
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
</cfinvoke>
</body>
</html>