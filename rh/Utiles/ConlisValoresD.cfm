<html>
<head>
<title><cf_translate  key="LB_ListaDeDetallesDeValores">Lista de Detalles de Valores</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.code") and not isdefined("Form.code")>
	<cfparam name="Form.code" default="#Url.code#">
</cfif>
<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.FRHDCGdescripcion") and not isdefined("Form.FRHDCGdescripcion")>
	<cfparam name="Form.FRHDCGdescripcion" default="#Url.FRHDCGdescripcion#">
</cfif>

<cfif isdefined("Url.FRHDCGcodigo") and not isdefined("Form.FRHDCGcodigo")>
	<cfparam name="Form.FRHDCGcodigo" default="#Url.FRHDCGcodigo#">
</cfif>
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = desc;
		window.close();
		</cfoutput>
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHDCGid") and Len(Trim(Form.RHDCGid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHDCGid=" & Form.RHDCGid>
</cfif>
<cfif isdefined("Form.FRHDCGcodigo") and Len(Trim(Form.FRHDCGcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHDCGcodigo) like '%" & #UCase(Form.FRHDCGcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHDCGcodigo=" & Form.FRHDCGcodigo>
</cfif>
<cfif isdefined("Form.FRHDCGdescripcion") and Len(Trim(Form.FRHDCGdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHDCGdescripcion) like '%" & #UCase(Form.FRHDCGdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHDCGdescripcion=" & Form.FRHDCGdescripcion>
</cfif>

<cfif isdefined("Form.code")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "code=" & Form.code>
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

<cfoutput>
<form name="filtroEmpleado" method="post" action="ConlisValoresD.cfm">
<input type="hidden" name="code" value="#Form.code#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="RHDCGid" value="<cfif isdefined("Form.RHDCGid")>#Form.RHDCGid#</cfif>">
<input type="hidden" name="NTIcodigo" value="<cfif isdefined("Form.NTIcodigo")>#Form.NTIcodigo#</cfif>">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">#LB_CODIGO#</td>
    <td> 
      <input name="FRHDCGcodigo" type="text" id="FRHDCGcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.FRHDCGcodigo")>#Form.FRHDCGcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="FRHDCGdescripcion" type="text" id="FRHDCGdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.FRHDCGdescripcion")>#Form.FRHDCGdescripcion#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHDCatalogosGenerales"/>
	<cfinvokeargument name="columnas" value="RHDCGid, RHDCGcodigo, RHDCGdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHDCGcodigo, RHDCGdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# and RHECGid = #form.code# #filtro# order by RHDCGcodigo, RHDCGdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisValoresD.cfm"/>
	<cfinvokeargument name="formName" value="listaValoresD"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHDCGid, RHDCGcodigo, RHDCGdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
