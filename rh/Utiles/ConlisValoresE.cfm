<html>
<head>
<title><cf_translate  key="LB_ListaDeEncabezadosDeValores">Lista de Encabezados de Valores</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.FRHECGdescripcion") and not isdefined("Form.FRHECGdescripcion")>
	<cfparam name="Form.FRHECGdescripcion" default="#Url.FRHECGdescripcion#">
</cfif>

<cfif isdefined("Url.FRHECGcodigo") and not isdefined("Form.FRHECGcodigo")>
	<cfparam name="Form.FRHECGcodigo" default="#Url.FRHECGcodigo#">
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
		if (window.opener.ResetValorD) window.opener.ResetValorD();
		window.close();
		</cfoutput>
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHECGid") and Len(Trim(Form.RHECGid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHECGid=" & Form.RHECGid>
</cfif>
<cfif isdefined("Form.FRHECGcodigo") and Len(Trim(Form.FRHECGcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHECGcodigo) like '%" & #UCase(Form.FRHECGcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHECGcodigo=" & Form.FRHECGcodigo>
</cfif>
<cfif isdefined("Form.FRHECGdescripcion") and Len(Trim(Form.FRHECGdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHECGdescripcion) like '%" & #UCase(Form.FRHECGdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHECGdescripcion=" & Form.FRHECGdescripcion>
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
<form name="filtroEmpleado" method="post" action="ConlisValoresE.cfm">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="RHECGid" value="<cfif isdefined("Form.RHECGid")>#Form.RHECGid#</cfif>">
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
      <input name="FRHECGcodigo" type="text" id="FRHECGcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.FRHECGcodigo")>#Form.FRHECGcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="FRHECGdescripcion" type="text" id="FRHECGdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.FRHECGdescripcion")>#Form.FRHECGdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHECatalogosGenerales"/>
	<cfinvokeargument name="columnas" value="RHECGid, RHECGcodigo, RHECGdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHECGcodigo, RHECGdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHECGcodigo, RHECGdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisValoresE.cfm"/>
	<cfinvokeargument name="formName" value="listaValoresE"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHECGid, RHECGcodigo, RHECGdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
