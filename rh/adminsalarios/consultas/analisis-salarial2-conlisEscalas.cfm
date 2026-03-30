<html>
<head>
<title>Lista de Escalas</title>
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

<cfif isdefined("Url.FEScodigo") and not isdefined("Form.FEScodigo")>
	<cfparam name="Form.FEScodigo" default="#Url.FEScodigo#">
</cfif>
<cfif isdefined("Url.FESdescripcion") and not isdefined("Form.FESdescripcion")>
	<cfparam name="Form.FESdescripcion" default="#Url.FESdescripcion#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(escalaid, escaladesc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = escalaid;
		window.opener.document.#Form.f#.#Form.p2#.value = escaladesc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.FEScodigo") and Len(Trim(Form.FEScodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FEScodigo=" & Form.FEScodigo>
</cfif>
<cfif isdefined("Form.FESdescripcion") and Len(Trim(Form.FESdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FESdescripcion=" & Form.FESdescripcion>
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
<form name="filtroEscala" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr>
    <td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
    <td>
		<input name="FEScodigo" type="text" id="EScodigo" size="10" maxlength="10" value="<cfif isdefined("Form.FEScodigo")>#Form.FEScodigo#</cfif>">
    </td>
    <td align="right"><strong>Escala Salarial:&nbsp;</strong></td>
    <td>
		<input name="FESdescripcion" type="text" id="FESdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.FESdescripcion")>#Form.FESdescripcion#</cfif>">
    </td>
    <td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEscala" datasource="#Session.DSN#">
	select a.ESid, a.EScodigo, a.ESdescripcion, rtrim(a.EScodigo) || ' ' || a.ESdescripcion as EscalaSalarial,
		   a.ESfdesde, a.ESfhasta, a.ESreferencia, a.EStipo, a.ESporcinc, a.ESdescaumento, a.fechaalta
	from RHEscalaSalHAY a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.ESestado = 10
	<cfif isdefined("Form.FEScodigo") and Len(Trim(Form.FEScodigo))>
	   and upper(a.EScodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Form.FEScodigo)#%">
	</cfif>
	<cfif isdefined("Form.FESdescripcion") and Len(Trim(Form.FESdescripcion))>
	   and upper(a.ESdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FESdescripcion)#%">
	</cfif>
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEscala#"/>
	<cfinvokeargument name="desplegar" value="EScodigo, ESdescripcion"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Escala Salarial"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="formName" value="listaEscalas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="ESid, EscalaSalarial"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
