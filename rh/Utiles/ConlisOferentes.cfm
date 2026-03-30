<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_ListaDeOferentes = t.Translate('LB_ListaDeOferentes','Lista de DatosOferentes')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_NombreCompleto = t.Translate('LB_NombreCompleto','Nombre Completo','/rh/generales.xml')>
<cfset LB_Filtrar = t.Translate('LB_Filtrar','Filtrar','/rh/generales.xml')>
 
<html>
<head>
<title><cfoutput>#LB_ListaDeOferentes#</cfoutput></title>
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

<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>
<cfif isdefined("Url.p4") and not isdefined("Form.p4")>
	<cfparam name="Form.p4" default="#Url.p4#">
</cfif>


<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfparam name="Form.RHOid" default="#Url.RHOid#">
</cfif>
 

<cfif isdefined("Url.fRHOidentificacion") and not isdefined("Form.fRHOidentificacion")>
	<cfparam name="Form.fRHOidentificacion" default="#Url.fRHOidentificacion#">
</cfif>
<cfif isdefined("Url.fNombreCompleton") and not isdefined("Form.fNombreCompleton")>
	<cfparam name="Form.fNombreCompleton" default="#Url.fNombreCompleton#">
</cfif>

<cfparam name="form.fRHOidentificacion" default="">
<cfparam name="form.fNombreCompleton" default="">

<script language="JavaScript" type="text/javascript">
function Asignar(id,ced, emp) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p3#.value = ced;
		window.opener.document.#Form.f#.#Form.p4#.value = emp;

		if (window.opener.funcRHOid){ window.opener.funcRHOid(); }

		</cfoutput>

		window.close();
	}
}
</script>
<cf_dbfunction name="op_concat" returnvariable="concat"/>
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHOid") and Len(Trim(Form.RHOid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOid=" & Form.RHOid>
</cfif>

<cfif isdefined("Form.fRHOidentificacion") and Len(Trim(Form.fRHOidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and ltrim(rtrim(a.RHOidentificacion)) like '%" & Trim(Form.fRHOidentificacion) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOidentificacion=" & Form.fRHOidentificacion>
</cfif>

<cfif isdefined("Form.fNombreCompleton") and Len(Trim(Form.fNombreCompleton)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.RHOapellido1 #concat#' ' #concat# a.RHOapellido2 #concat# a.RHOnombre) like '%" & Trim(Ucase(Form.fNombreCompleton)) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOidentificacion=" & Form.fRHOidentificacion>
</cfif>


<cfif isdefined("Form.f")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
</cfif>
<cfif isdefined("Form.p1")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
</cfif>
<cfif isdefined("Form.p3")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
</cfif>
<cfif isdefined("Form.p4")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4>
</cfif>

<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="RHOid" value="<cfif isdefined("Form.RHOid")>#Form.RHOid#</cfif>">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">#LB_Identificacion#:</td>
	<td><input name="fRHOidentificacion" type="text" value="#form.fRHOidentificacion#" size="20"></td>
    <td align="right">#LB_NombreCompleto#:</td>
	<td><input name="fNombreCompleton" type="text" value="#form.fNombreCompleton#" size="40"></td>
    <td align="center"> 
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#LB_Filtrar#">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="DatosOferentes a"/>
	<cfinvokeargument name="columnas" value="a.RHOid, a.RHOidentificacion, {fn concat({fn concat({fn concat({fn concat(a.RHOapellido1 , ' ' )}, a.RHOapellido2 )}, ' ' )}, a.RHOnombre )}as NombreCompleto"/>
	<cfinvokeargument name="desplegar" value="RHOidentificacion, NombreCompleto"/>
	<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" coalesce(a.RHAprobado,0) = 1 and a.DEid is null #filtro# 
    and coalesce(a.RHOlistanegra,0) = 0 order by a.RHOidentificacion, a.RHOapellido1, a.RHOapellido2, a.RHOnombre"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisOferentes.cfm"/>
	<cfinvokeargument name="formName" value="listaOferentes"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHOid, RHOidentificacion, NombreCompleto"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
