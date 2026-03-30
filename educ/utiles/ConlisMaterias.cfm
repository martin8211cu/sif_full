<!--- Recibe conexion, form, name y desc --->

<cfif isdefined("Url.conSubmit") and not isdefined("Form.conSubmit")>
	<cfparam name="Form.conSubmit" default="#Url.conSubmit#">
</cfif>
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfparam name="Form.tipo" default="#Url.tipo#">
</cfif>
<cfif isdefined("Url.quitar") and not isdefined("Form.quitar")>
	<cfparam name="Form.quitar" default="#Url.quitar#">
</cfif>
<cfif isdefined("Url.filtroExtra") and not isdefined("Form.filtroExtra")>
	<cfparam name="Form.filtroExtra" default="#Url.filtroExtra#">
</cfif>
<cfif isdefined("Url.Mcodificacion_filtro") and not isdefined("Form.Mcodificacion_filtro")>
	<cfparam name="Form.Mcodificacion_filtro" default="#Url.Mcodificacion_filtro#">
</cfif>
<cfif isdefined("Url.Mnombre_filtro") and not isdefined("Form.Mnombre_filtro")>
	<cfparam name="Form.Mnombre_filtro" default="#Url.Mnombre_filtro#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.quitar") and Len(Trim(Form.quitar)) NEQ 0>
	<cfset filtro = filtro & " and Mcodigo not in (" & #Form.quitar# & ")">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "quitar=" & Form.quitar>
</cfif>
<cfif isdefined("Form.filtroExtra") and Len(Trim(Form.filtroExtra)) NEQ 0>
	<cfset filtro = filtro & #Form.filtroExtra#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtroExtra=" & Form.filtroExtra>
</cfif>
<cfif isdefined("Form.tipo") and Len(Trim(Form.tipo)) NEQ 0>
	<cfset filtro = filtro & " and Mtipo='" & #UCase(Form.tipo)# & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tipo=" & Form.tipo>
</cfif>
<cfif isdefined("Form.Mcodificacion_filtro") and Len(Trim(Form.Mcodificacion_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(Mcodificacion) like '%" & #UCase(Form.Mcodificacion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mcodificacion_filtro=" & Form.Mcodificacion_filtro>
</cfif>
<cfif isdefined("Form.Mnombre_filtro") and Len(Trim(Form.Mnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Mnombre) like '%" & #UCase(Form.Mnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Mnombre_filtro=" & Form.Mnombre_filtro>
</cfif>

<html>
<head>
<title>Lista de Materias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
<form name="materia_lista" method="post" style="margin: 0">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="Mcodificacion_filtro" type="text" id="Mcodificacion_filtro" size="15" maxlength="15" value="<cfif isdefined("Form.Mcodificacion_filtro")>#Form.Mcodificacion_filtro#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="Mnombre_filtro" type="text" id="Mnombre_filtro" size="50" maxlength="50" value="<cfif isdefined("Form.Mnombre_filtro")>#Form.Mnombre_filtro#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Materia"/>
	<cfinvokeargument name="columnas" value="convert(varchar, Mcodigo) as Mcodigo, Mcodificacion, Mnombre"/>
	<cfinvokeargument name="desplegar" value="Mcodificacion, Mnombre"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
			Ecodigo = #Session.Ecodigo# 			
				and Mactivo = 1
				#filtro# 
			Order by Mnombre"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisMaterias.cfm"/>
	<cfinvokeargument name="formName" value="listaMaterias"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Mcodificacion,Mnombre,Mcodigo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
</body>
</html>

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,cod) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.cod#.value = cod;
			window.opener.document.#Url.form#.#Url.name#.value = name;		
			window.opener.document.#Url.form#.#Url.desc#.value = desc;

			<cfif isdefined('form.conSubmit') and form.conSubmit EQ "S">		
				window.opener.document.#Url.form#.submit();
			</cfif>			
		</cfoutput>
		
		window.close();
	}
}
</script>