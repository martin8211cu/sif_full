<html>
<head>
<title>Lista de Entidades</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.conexion") and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>
<cfif isdefined("Url.MEEid2") and not isdefined("Form.MEEid2")>
	<cfparam name="Form.MEEid2" default="#Url.MEEid2#">
</cfif>
<cfif isdefined("Url.MEEidentificacion2") and not isdefined("Form.MEEidentificacion2")>
	<cfparam name="Form.MEEidentificacion2" default="#Url.MEEidentificacion2#">
</cfif>
<cfif isdefined("Url.MEEnombre2") and not isdefined("Form.MEEnombre2")>
	<cfparam name="Form.MEEnombre2" default="#Url.MEEnombre2#">
</cfif>
<cfif isdefined("Url.METRid") and not isdefined("Form.METRid")>
	<cfparam name="Form.METRid" default="#Url.METRid#">
</cfif>

<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif Form.METRid neq "-1">
	<cfset filtro = "a.METRid = #Form.METRid#">
</cfif>

<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(c.MEEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(c.MEEapellido1 + ' ' + c.MEEapellido2 + ', ' + c.MEEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>

<cfoutput>

<script language="JavaScript" type="text/javascript">
	function Asignar(lMEEid2, lMEEidentificacion2, lMEEnombre2) {
		if (window.opener != null) {
			window.opener.document.#Form.form#.#Form.MEEid2#.value = lMEEid2;
			window.opener.document.#Form.form#.#Form.MEEidentificacion2#.value = lMEEidentificacion2;
			window.opener.document.#Form.form#.#Form.MEEnombre2#.value = lMEEnombre2;
			window.close();
		}
	}
</script>

<form name="filtroEmpleado">
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
	<td>
	  <input type="hidden" name="form" id="form" value="#Form.form#">
	  <input type="hidden" name="conexion" id="conexion" value="#Form.conexion#">
	  <input type="hidden" name="MEEid2" id="MEEid2" value="#Form.MEEid2#">
	  <input type="hidden" name="MEEidentificacion2" id="MEEidentificacion2" value="#Form.MEEidentificacion2#">
	  <input type="hidden" name="MEEnombre2" id="MEEnombre2" value="#Form.MEEnombre2#">
	  <input type="hidden" name="METRid" id="METRid" value="#Form.METRid#">
	</td>
  </tr>
</table>
</form>

</cfoutput>

<cfif Form.METRid neq "-1">
	<cfinvoke 
	 component="sif.me.Componentes.pListas"
	 method="pListaME"
	 returnvariable="pListaME">
		<cfinvokeargument name="tabla" value="MERelacionesPermitidas a, METipoEntidad b, MEEntidad c"/>
		<cfinvokeargument name="columnas" value="convert(varchar, c.MEEid) as MEEid2, c.MEEidentificacion, c.MEEapellido1 + ' ' + c.MEEapellido2 + ' ' + c.MEEnombre as NombreCompleto, b.METEid, b.METEdesc, a.METRid, a.MERPdescripcion"/>
		<cfinvokeargument name="desplegar" value="MEEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
		<cfinvokeargument name="formatos" value="S,S"/>
		<cfinvokeargument name="filtro" value="#filtro# and a.METEidrel = b.METEid and b.METEid = c.METEid order by c.MEEapellido1, c.MEEapellido2, c.MEEnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="conlisMEEntidadRel.cfm"/>
		<cfinvokeargument name="formName" value="listaEntidades"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="MEEid2, MEEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
<cfelse>
	<cfinvoke 
	 component="sif.me.Componentes.pListas"
	 method="pListaME"
	 returnvariable="pListaME">
		<cfinvokeargument name="tabla" value="MEEntidad c"/>
		<cfinvokeargument name="columnas" value="convert(varchar, c.MEEid) as MEEid2, c.MEEidentificacion, c.MEEapellido1 + ' ' + c.MEEapellido2 + ' ' + c.MEEnombre as NombreCompleto"/>
		<cfinvokeargument name="desplegar" value="MEEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
		<cfinvokeargument name="formatos" value="S,S"/>
		<cfinvokeargument name="filtro" value="1=1 #filtro# order by c.MEEapellido1, c.MEEapellido2, c.MEEnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="conlisMEEntidadRel.cfm"/>
		<cfinvokeargument name="formName" value="listaEntidades"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="MEEid2, MEEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
</cfif>

</body>
</html>
