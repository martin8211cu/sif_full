<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>
		var descAnt = opener.#Url.form#.#Url.desc#.value;
		opener.#Url.form#.#Url.name#.value = name;
		opener.#Url.form#.#Url.desc#.value = desc;
		if (descAnt != opener.#Url.form#.#Url.desc#.value && opener.ClearPlaza) {
			opener.ClearPlaza();
		}
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.NPcodigo") and not isdefined("Form.NPcodigo")>
	<cfparam name="Form.NPcodigo" default="#Url.NPcodigo#">
</cfif>
<cfif isdefined("Url.NPdescripcion") and not isdefined("Form.NPdescripcion")>
	<cfparam name="Form.NPdescripcion" default="#Url.NPdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.NPcodigo") and Len(Trim(Form.NPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(NPcodigo) like '%" & #UCase(Form.NPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NPcodigo=" & Form.NPcodigo>
</cfif>
<cfif isdefined("Form.NPdescripcion") and Len(Trim(Form.NPdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(NPdescripcion) like '%" & #UCase(Form.NPdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NPdescripcion=" & Form.NPdescripcion>
</cfif>
<html>
<head>
<title>Lista de Puestos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="NPcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.NPcodigo")>#Form.NPcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="NPdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.NPdescripcion")>#Form.NPdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="NProfesional"/>
	<cfinvokeargument name="columnas" value="convert(varchar,NPcodigo) NPcodigo, NPdescripcion"/>
	<cfinvokeargument name="desplegar" value="NPcodigo, NPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisNivel.cfm"/>
	<cfinvokeargument name="formName" value="listaNivel"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="NPcodigo, NPdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>