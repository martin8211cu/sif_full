<html>
<head>
<title>Lista de Valoraciones de Puestos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>

<cfif isdefined("Url.FHYERVdescripcion") and not isdefined("Form.FHYERVdescripcion")>
	<cfparam name="Form.FHYERVdescripcion" default="#Url.FHYERVdescripcion#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(valoracioncod, valoraciondesc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = valoracioncod;
		window.opener.document.#Form.f#.#Form.p2#.value = valoraciondesc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.FHYERVdescripcion") and Len(Trim(Form.FHYERVdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FHYERVdescripcion=" & Form.FHYERVdescripcion>
</cfif>

<cfif isdefined("Form.f")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
</cfif>
<cfif isdefined("Form.p1")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
</cfif>
<cfif isdefined("Form.p2")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2>
</cfif>

<cfoutput>
<form name="filtroValoraciones" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr> 
    <td align="right"><strong>Valoraci&oacute;n de Puestos:&nbsp;</strong></td>
    <td>
		<input name="FHYERVdescripcion" type="text" id="FHYERVdescripcion" size="40" maxlength="255" value="<cfif isdefined("Form.FHYERVdescripcion")>#Form.FHYERVdescripcion#</cfif>">
    </td>
    <td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaValoraciones" datasource="#Session.DSN#">
	select a.HYERVid, a.Usucodigo, a.HYERVfechaalta, a.HYERVdescripcion, a.HYERVfecha, a.HYERVusucodigo, a.HYERVfechaaprueba
	from HYERelacionValoracion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.FHYERVdescripcion") and Len(Trim(Form.FHYERVdescripcion)) NEQ 0>
		and upper(a.HYERVdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FHYERVdescripcion)#%">
	</cfif>
	and a.HYERVestado = 1
	order by a.HYERVfecha desc
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaValoraciones#"/>
	<cfinvokeargument name="desplegar" value="HYERVdescripcion, HYERVfecha"/>
	<cfinvokeargument name="etiquetas" value="Valoraci&oacute;n de Puestos, Fecha"/>
	<cfinvokeargument name="align" value="left, center"/>
	<cfinvokeargument name="formatos" value="V, D"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="formName" value="listaValoraciones"/>
	<cfinvokeargument name="MaxRows" value="10"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="HYERVid, HYERVdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
