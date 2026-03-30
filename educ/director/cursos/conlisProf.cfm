<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(cod) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.cod#.value = cod;
			<cfif isdefined('Url.btn') and Url.btn NEQ ''>
				window.opener.document.#Url.form#.#Url.btn#.value = 1;			
			</cfif>
			window.opener.document.#Url.form#.submit();			
		</cfoutput>
		
		window.close();
	}
}
</script>

<cfif isdefined("Url.Pnombre_filtro") and not isdefined("Form.Pnombre_filtro")>
	<cfparam name="Form.Pnombre_filtro" default="#Url.Pnombre_filtro#">
</cfif>

<cfset navegacion = "">
<cfset filtro = "">
<cfif isdefined('Url.quitar') and Url.quitar NEQ ''>
	<cfoutput>
		<cfset filtro = filtro & " and DOpersona not in (#Url.quitar#)">
	</cfoutput>
</cfif>
<cfif isdefined("Form.Pnombre_filtro") and Len(Trim(Form.Pnombre_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) like '%" & #UCase(Form.Pnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pnombre_filtro=" & Form.Pnombre_filtro>
</cfif>

<html>
<head>
<title>Lista de Profesor</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../css/educ.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfoutput>
<form name="materia_lista" method="post" style="margin: 0">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="10%" align="right"><strong>
	  Nombre</strong></td>
		<td> 
			<input name="Pnombre_filtro" type="text" id="Pnombre_filtro" size="100" maxlength="100" value="<cfif isdefined("Form.Pnombre_filtro")>#Form.Pnombre_filtro#</cfif>">
		</td>
	    <td align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
	</tr>	
</table>
</form>
</cfoutput>

<cfinvoke 
 component="educ.componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="Docente"/>
	<cfinvokeargument name="columnas" value="
		convert(varchar,DOpersona) as DOpersona
		, Pid
		, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as NombreProf"/>
	<cfinvokeargument name="desplegar" value="NombreProf,Pid"/>
	<cfinvokeargument name="etiquetas" value="Profesor, Identificación"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				Ecodigo=#session.Ecodigo#
				#filtro# 
			Order by NombreProf"/>
	<cfinvokeargument name="align" value="left,left"/>
	<cfinvokeargument name="ajustar" value="N,N"/>
	<cfinvokeargument name="irA" value="conlisProf.cfm"/>
	<cfinvokeargument name="formName" value="listaAlumnos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="DOpersona"/>
	<cfinvokeargument name="debug" value="N"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>