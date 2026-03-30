<html>
<head>
<title>Lista de Area</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
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


<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.NTIcodigo") and not isdefined("Form.NTIcodigo")>
	<cfparam name="Form.NTIcodigo" default="#Url.NTIcodigo#">
</cfif>
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>


<script language="JavaScript" type="text/javascript">
function Asignar(id, tipo, ced, emp) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p3#.value = ced;
		window.opener.document.#Form.f#.#Form.p4#.value = emp;
		if (window.opener.document.#Form.f#.#Form.p2#.options != null) {
			for (var i = 0; i < window.opener.document.#Form.f#.#Form.p2#.options.length; i++) {
				if (window.opener.document.#Form.f#.#Form.p2#.options[i].value == tipo) {
					window.opener.document.#Form.f#.#Form.p2#.options.selectedIndex = i;
				}
			}
		}

		if (window.opener.funcDEid){ window.opener.funcDEid(); }

		</cfoutput>

		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
	<cfset filtro = filtro & " and a.NTIcodigo = '" & Trim(Form.NTIcodigo) & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NTIcodigo=" & Form.NTIcodigo>
</cfif>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
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

<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="DEid" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">
<input type="hidden" name="NTIcodigo" value="<cfif isdefined("Form.NTIcodigo")>#Form.NTIcodigo#</cfif>">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">Identificaci&oacute;n</td>
    <td> 
      <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
    </td>
    <td align="right">Nombre</td>
    <td> 
      <input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="sif.rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="DatosEmpleado a"/>
	<cfinvokeargument name="columnas" value="a.DEid, a.NTIcodigo, a.DEidentificacion, a.DEapellido1 || ' ' || a.DEapellido2 || ', ' || a.DEnombre as NombreCompleto"/>
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
	<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisEmpleados.cfm"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, NombreCompleto"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
