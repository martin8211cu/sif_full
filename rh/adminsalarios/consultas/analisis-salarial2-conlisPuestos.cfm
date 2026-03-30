<html>
<head>
<title>Lista de Puestos</title>
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

<cfif isdefined("Url.FRHPcodigo") and not isdefined("Form.FRHPcodigo")>
	<cfparam name="Form.FRHPcodigo" default="#Url.FRHPcodigo#">
</cfif>
<cfif isdefined("Url.FRHPdescpuesto") and not isdefined("Form.FRHPdescpuesto")>
	<cfparam name="Form.FRHPdescpuesto" default="#Url.FRHPdescpuesto#">
</cfif>
<cfif isdefined("Url.EEid") and not isdefined("Form.EEid")>
	<cfparam name="Form.EEid" default="#Url.EEid#">
</cfif>
<cfif isdefined("Url.HYERVid") and not isdefined("Form.HYERVid")>
	<cfparam name="Form.HYERVid" default="#Url.HYERVid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(puestocod, puestodesc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = puestocod;
		window.opener.document.#Form.f#.#Form.p2#.value = puestodesc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.FRHPcodigo") and Len(Trim(Form.FRHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHPcodigo=" & Form.FRHPcodigo>
</cfif>
<cfif isdefined("Form.FRHPdescpuesto") and Len(Trim(Form.FRHPdescpuesto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHPdescpuesto=" & Form.FRHPdescpuesto>
</cfif>
<cfif isdefined("Form.EEid") and Len(Trim(Form.EEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EEid=" & Form.EEid>
</cfif>
<cfif isdefined("Form.HYERVid") and Len(Trim(Form.HYERVid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HYERVid=" & Form.HYERVid>
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
<form name="filtroPuesto" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="EEid" value="#Form.EEid#">
<input type="hidden" name="HYERVid" value="#Form.HYERVid#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr>
    <td align="right"><strong>C&oacute;digo</strong></td>
    <td>
		<input name="FRHPcodigo" type="text" id="RHPcodigo" size="10" maxlength="10" value="<cfif isdefined("Form.FRHPcodigo")>#Form.FRHPcodigo#</cfif>">
    </td>
    <td align="right"><strong>Descripci&oacute;n</strong></td>
    <td>
		<input name="FRHPdescpuesto" type="text" id="FRHPdescpuesto" size="40" maxlength="80" value="<cfif isdefined("Form.FRHPdescpuesto")>#Form.FRHPdescpuesto#</cfif>">
    </td>
    <td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaPuestos" datasource="#Session.DSN#">
	select distinct a.Ecodigo, b.RHPcodigo, b.RHPdescpuesto
	from RHEncuestaPuesto a
		inner join RHPuestos b
		   on b.Ecodigo = a.Ecodigo
		   and b.RHPcodigo = a.RHPcodigo
		<cfif isdefined("Form.FRHPcodigo") and Len(Trim(Form.FRHPcodigo))>
		   and upper(b.RHPcodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Form.FRHPcodigo)#%">
		</cfif>
		<cfif isdefined("Form.FRHPdescpuesto") and Len(Trim(Form.FRHPdescpuesto))>
		   and upper(b.RHPdescpuesto) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FRHPdescpuesto)#%">
		</cfif>
		inner join HYDRelacionValoracion c
		   on c.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.HYERVid#">
		   and c.Ecodigo = b.Ecodigo
		   and c.RHPcodigo = b.RHPcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaPuestos#"/>
	<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescpuesto"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Puesto"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="formName" value="listaPuestos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHPcodigo, RHPdescpuesto"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
