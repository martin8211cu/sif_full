<html>
<head>
<title><cf_translate  key="LB_ListaDeHabilidades">Lista de Habilidades</cf_translate></title>
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
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.FRHHdescripcion") and not isdefined("Form.FRHHdescripcion")>
	<cfparam name="Form.FRHHdescripcion" default="#Url.FRHHdescripcion#">
</cfif>
<cfif isdefined("Url.FRHHcodigo") and not isdefined("Form.FRHHcodigo")>
	<cfparam name="Form.FRHHcodigo" default="#Url.FRHHcodigo#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc, pcid, rhhubicB) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#.value = id;
			window.opener.document.#Form.f#.#Form.p2#.value = cod;
			window.opener.document.#Form.f#.#Form.p3#.value = desc;
			
			window.opener.document.#Form.f#.PCid_#Form.name#.value = pcid;
			window.opener.document.#Form.f#.RHHubicacionB_#Form.name#.value = rhhubicB;
			
			if (window.opener.func#trim(form.name)#) {
				window.opener.func#trim(form.name)#();
			}
			
			window.close();
		</cfoutput>
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHHid") and Len(Trim(Form.RHHid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHHid=" & Form.RHHid>
</cfif>
<cfif isdefined("Form.FRHHcodigo") and Len(Trim(Form.FRHHcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHHcodigo) like '%" & #UCase(Form.FRHHcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHHcodigo=" & Form.FRHHcodigo>
</cfif>
<cfif isdefined("Form.FRHHdescripcion") and Len(Trim(Form.FRHHdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHHdescripcion) like '%" & #UCase(Form.FRHHdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FRHHdescripcion=" & Form.FRHHdescripcion>
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
<cfif isdefined("Form.name")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "name=" & Form.name>
</cfif>


<cfoutput>
<form name="filtroEmpleado" method="post" action="ConlisHabilidades.cfm">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="name" value="#Form.name#">

<input type="hidden" name="RHHid" value="<cfif isdefined("Form.RHHid")>#Form.RHHid#</cfif>">
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
      <input name="FRHHcodigo" type="text" id="FRHHcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.FRHHcodigo")>#Form.FRHHcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="FRHHdescripcion" type="text" id="FRHHdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.FRHHdescripcion")>#Form.FRHHdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHHabilidades"/>
	<cfinvokeargument name="columnas" value="RHHid, RHHcodigo, RHHdescripcion, PCid, RHHubicacionB"/>
	<cfinvokeargument name="desplegar" value="RHHcodigo, RHHdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHHcodigo, RHHdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisHabilidades.cfm"/>
	<cfinvokeargument name="formName" value="listaHabilidades"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHHid, RHHcodigo, RHHdescripcion, PCid, RHHubicacionB"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
