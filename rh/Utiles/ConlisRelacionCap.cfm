<html>
<head>
<title>Lista de Relaciones de Capacitaci&oacute;n</title>
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

<cfif isdefined("Url.fRHEECdescripcion") and not isdefined("Form.fRHEECdescripcion")>
	<cfparam name="Form.fRHEECdescripcion" default="#Url.fRHEECdescripcion#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = desc;
		window.close();
		</cfoutput>
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.f") and Len(Trim(Form.f)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
</cfif>

<cfif isdefined("Form.p1") and Len(Trim(Form.p1)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
</cfif>

<cfif isdefined("Form.p2") and Len(Trim(Form.p2)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2>
</cfif>

<cfif isdefined("Form.p3") and Len(Trim(Form.p3)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
</cfif>

<cfif isdefined("Form.fRHEECdescripcion") and Len(Trim(Form.fRHEECdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHEECdescripcion) like '%" & #UCase(Form.fRHEECdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHEECdescripcion=" & Form.fRHEECdescripcion>
</cfif>

<cfif isdefined("Form.p3") and Len(Trim(Form.p3)) NEQ 0>
 	<cfset filtro = filtro & " and RHEECestado in (#Form.p3#) ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
</cfif>

<cfoutput>
<form name="filtroEmpleado" method="post" action="ConlisRelacionCap.cfm">
<input type="hidden" name="f" value="<cfif isdefined("Form.f")>#Form.f#</cfif>">
<input type="hidden" name="p1" value="<cfif isdefined("Form.p1")>#Form.p1#</cfif>">
<input type="hidden" name="p2" value="<cfif isdefined("Form.p2")>#Form.p2#</cfif>">
<input type="hidden" name="p3" value="<cfif isdefined("Form.p3")>#Form.p3#</cfif>">

<input type="hidden" name="fRHEECdescripcion" value="<cfif isdefined("Form.fRHHCdescripcion")>#Form.fRHHCdescripcion#</cfif>">
<input type="hidden" name="RHEECid" value="<cfif isdefined("Form.RHEECid")>#Form.RHEECid#</cfif>">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">Descripci&oacute;n</td>
    <td> 
      <input name="fRHEECdescripcion" type="text" id="fRHEECdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.fRHEECdescripcion")>#Form.fRHEECdescripcion#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHEEvaluacionCap"/>
	<cfinvokeargument name="columnas" value="RHEECid, RHEECdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHEECdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Relación de Capacitación"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHEECdescripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisRelacionCap.cfm"/>
	<cfinvokeargument name="formName" value="listaRelacionCap"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHEECid, RHEECdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
