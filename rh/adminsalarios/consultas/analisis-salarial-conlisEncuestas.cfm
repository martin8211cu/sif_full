<html>
<head>
<title>Lista de Encuestas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>
<cfif isdefined("Url.p4") and not isdefined("Form.p4")>
	<cfparam name="Form.p4" default="#Url.p4#">
</cfif>
<cfif isdefined("Url.p5") and not isdefined("Form.p5")>
	<cfparam name="Form.p5" default="#Url.p5#">
</cfif>
<cfif isdefined("Url.p6") and not isdefined("Form.p6")>
	<cfparam name="Form.p6" default="#Url.p6#">
</cfif>
<cfif isdefined("Url.p7") and not isdefined("Form.p7")>
	<cfparam name="Form.p7" default="#Url.p7#">
</cfif>
<cfif isdefined("Url.p8") and not isdefined("Form.p8")>
	<cfparam name="Form.p8" default="#Url.p8#">
</cfif>

<cfif isdefined("Url.FEEnombre") and not isdefined("Form.FEEnombre")>
	<cfparam name="Form.FEEnombre" default="#Url.FEEnombre#">
</cfif>
<cfif isdefined("Url.FEdescripcion") and not isdefined("Form.FEdescripcion")>
	<cfparam name="Form.FEdescripcion" default="#Url.FEdescripcion#">
</cfif>
<cfif isdefined("Url.FETdescripcion") and not isdefined("Form.FETdescripcion")>
	<cfparam name="Form.FETdescripcion" default="#Url.FETdescripcion#">
</cfif>
<cfif isdefined("Url.FMnombre") and not isdefined("Form.FMnombre")>
	<cfparam name="Form.FMnombre" default="#Url.FMnombre#">
</cfif>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(empresacod, encuestacod, tipocod, monedacod, empresa, encuesta, tipo, moneda) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = empresacod;
		window.opener.document.#Form.f#.#Form.p2#.value = encuestacod;
		window.opener.document.#Form.f#.#Form.p3#.value = tipocod;
		window.opener.document.#Form.f#.#Form.p4#.value = monedacod;
		window.opener.document.#Form.f#.#Form.p5#.value = empresa;
		window.opener.document.#Form.f#.#Form.p6#.value = encuesta;
		window.opener.document.#Form.f#.#Form.p7#.value = tipo;
		window.opener.document.#Form.f#.#Form.p8#.value = moneda;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.FEEnombre") and Len(Trim(Form.FEEnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FEEnombre=" & Form.FEEnombre>
</cfif>
<cfif isdefined("Form.FEdescripcion") and Len(Trim(Form.FEdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FEdescripcion=" & Form.FEdescripcion>
</cfif>
<cfif isdefined("Form.FETdescripcion") and Len(Trim(Form.FETdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FETdescripcion=" & Form.FETdescripcion>
</cfif>
<cfif isdefined("Form.FMnombre") and Len(Trim(Form.FMnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FMnombre=" & Form.FMnombre>
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
<cfif isdefined("Form.p3")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
</cfif>
<cfif isdefined("Form.p4")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4>
</cfif>
<cfif isdefined("Form.p5")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p5=" & Form.p5>
</cfif>
<cfif isdefined("Form.p6")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p6=" & Form.p6>
</cfif>
<cfif isdefined("Form.p7")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p7=" & Form.p7>
</cfif>
<cfif isdefined("Form.p8")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p8=" & Form.p8>
</cfif>

<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="p5" value="#Form.p5#">
<input type="hidden" name="p6" value="#Form.p6#">
<input type="hidden" name="p7" value="#Form.p7#">
<input type="hidden" name="p8" value="#Form.p8#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr> 
    <td><strong>Empresa</strong></td>
    <td><strong>Encuesta</strong></td>
    <td><strong>Tipo de Organizaci&oacute;n</strong></td>
    <td><strong>Moneda</strong></td>
  </tr>
  <tr>
    <td>
		<input name="FEEnombre" type="text" id="FEEnombre" size="25" maxlength="255" value="<cfif isdefined("Form.FEEnombre")>#Form.FEEnombre#</cfif>">
    </td>
    <td>
		<input name="FEdescripcion" type="text" id="FEdescripcion" size="25" maxlength="255" value="<cfif isdefined("Form.FEdescripcion")>#Form.FEdescripcion#</cfif>">
    </td>
    <td>
		<input name="FETdescripcion" type="text" id="FETdescripcion" size="25" maxlength="255" value="<cfif isdefined("Form.FETdescripcion")>#Form.FETdescripcion#</cfif>">
    </td>
    <td>
		<input name="FMnombre" type="text" id="FMnombre" size="25" maxlength="255" value="<cfif isdefined("Form.FMnombre")>#Form.FMnombre#</cfif>">
    </td>
  </tr>
  <tr>
    <td colspan="4" align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEncuestas" datasource="#Session.DSN#">
	select distinct b.EEid, b.Eid, b.ETid, f.Mcodigo, d.EEnombre, c.Edescripcion, e.ETdescripcion, f.Mnombre
	from RHEncuestadora a
		inner join EncuestaSalarios b
		   on b.EEid = a.EEid
		inner join Encuesta c
		   on c.Eid = b.Eid
		<cfif isdefined("Form.FEdescripcion") and Len(Trim(Form.FEdescripcion)) NEQ 0>
		   and upper(c.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FEdescripcion)#%">
		</cfif>
		inner join EncuestaEmpresa d
		   on d.EEid = a.EEid
		<cfif isdefined("Form.FEEnombre") and Len(Trim(Form.FEEnombre)) NEQ 0>
		   and upper(d.EEnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FEEnombre)#%">
		</cfif>
		inner join EmpresaOrganizacion e
		   on e.ETid = a.ETid
		<cfif isdefined("Form.FETdescripcion") and Len(Trim(Form.FETdescripcion)) NEQ 0>
		   and upper(e.ETdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FETdescripcion)#%">
		</cfif>
		inner join Monedas f
		   on f.Mcodigo = b.Moneda
		<cfif isdefined("Form.FMnombre") and Len(Trim(Form.FMnombre)) NEQ 0>
		and upper(Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FMnombre)#%">
		</cfif>
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEncuestas#"/>
	<cfinvokeargument name="desplegar" value="EEnombre, Edescripcion, ETdescripcion, Mnombre"/>
	<cfinvokeargument name="etiquetas" value="Empresa, Encuesta, Tipo de Organizaci&oacute;n, Moneda"/>
	<cfinvokeargument name="align" value="left, left, left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="formName" value="listaEncuestas"/>
	<cfinvokeargument name="MaxRows" value="10"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="EEid, Eid, ETid, Mcodigo, EEnombre, Edescripcion, ETdescripcion, Mnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
