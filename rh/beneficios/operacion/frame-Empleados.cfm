<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>

<script language="javascript" type="text/javascript">
	function selEmpl(emp) {
		document.listaEmpleados.PageNum.value = '1';
		document.listaEmpleados.DEID.value = emp;
		document.listaEmpleados.submit();
	}
</script>

<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td width="9%" align="right"><div align="left">Identificaci&oacute;n</div></td>
    <td width="16%"> 
      <div align="left">
        <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
      </div></td>
    <td width="7%" align="right"><div align="left">Nombre</div></td>
    <td width="48%"> 
      <div align="left">
        <input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
      </div></td>
    <td width="20%" align="center">
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
	<cfinvokeargument name="tabla" value="DatosEmpleado a"/>
	<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion, a.DEapellido1 + ' ' + a.DEapellido2 + ', ' + a.DEnombre as NombreCompleto"/>
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
	<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="funcion" value="selEmpl"/>
	<cfinvokeargument name="fparams" value="DEid"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
