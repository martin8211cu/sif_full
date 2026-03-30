<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_CODIGO" default="C&oacute;digo" returnvariable="LB_CODIGO" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<html>
<head>
<title><cf_translate  key="LB_ListaDeConocimientos">Lista de Conocimientos</cf_translate></title>
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
<cfif isdefined("Url.FRHCdescripcion") and not isdefined("Form.FRHCdescripcion")>
	<cfparam name="Form.FRHCdescripcion" default="#Url.FRHCdescripcion#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.FRHCcodigo") and not isdefined("Form.FRHCcodigo")>
	<cfparam name="Form.FRHCcodigo" default="#Url.FRHCcodigo#">
</cfif>
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>
<cfif isdefined("Url.inactivos") and not isdefined("Form.inactivos")>
	<cfparam name="Form.inactivos" default="#Url.inactivos#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc,pcid) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = desc;
		window.opener.document.#Form.f#.PCid_RHCid.value = pcid;
		if (window.opener.funcRHCid) {
				window.opener.funcRHCid();
			}
		window.close();
		</cfoutput>
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHCid") and Len(Trim(Form.RHCid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHCid=" & Form.RHCid>
</cfif>
<cfif isdefined("Form.inactivos") and Len(Trim(Form.inactivos)) NEQ 0 and Form.inactivos eq 1>
	<cfset filtro = filtro & " and coalesce(RHCinactivo,0) = 0 ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "inactivos=" & Form.inactivos>
</cfif>


<cfif isdefined("Form.FRHCcodigo") and Len(Trim(Form.FRHCcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHCcodigo) like '%" & #UCase(Form.FRHCcodigo)# & "%'">
</cfif>
<cfif isdefined("Form.FRHCdescripcion") and Len(Trim(Form.FRHCdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHCdescripcion) like '%" & #UCase(Form.FRHCdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHCdescripcion=" & Form.FRHCdescripcion>
</cfif>

<cfif isdefined("Form.inactivos")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "inactivos=" & Form.inactivos>
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
<form name="filtroEmpleado" method="post" action="ConlisConocimientos.cfm">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="inactivos" value="#Form.inactivos#">
<input type="hidden" name="RHCid" value="<cfif isdefined("Form.RHCid")>#Form.RHCid#</cfif>">
<input type="hidden" name="NTIcodigo" value="<cfif isdefined("Form.NTIcodigo")>#Form.NTIcodigo#</cfif>">


<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">#LB_CODIGO#</td>
    <td> 
      <input name="FRHCcodigo" type="text" id="FRHCcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.FRHCcodigo")>#Form.FRHCcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="FRHCdescripcion" type="text" id="FRHCdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.FRHCdescripcion")>#Form.FRHCdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHConocimientos"/>
	<cfinvokeargument name="columnas" value="RHCid, RHCcodigo, RHCdescripcion,PCid"/>
	<cfinvokeargument name="desplegar" value="RHCcodigo, RHCdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHCcodigo, RHCdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisConocimientos.cfm"/>
	<cfinvokeargument name="formName" value="listaConocimientos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHCid, RHCcodigo, RHCdescripcion,PCid"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>

</body>
</html>
