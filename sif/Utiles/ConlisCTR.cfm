<html>
<head>
<title>Lista de Cuentas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.autoSubmit") and not isdefined("Form.autoSubmit")>
	<cfparam name="Form.autoSubmit" default="#Url.autoSubmit#">
</cfif>
<cfif isdefined("Url.ctr") and not isdefined("Form.ctr")>
	<cfparam name="Form.ctr" default="#Url.ctr#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.conexion") and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>

<cfif isdefined("Url.F_Cmayor") and not isdefined("Form.F_Cmayor")>
	<cfparam name="Form.F_Cmayor" default="#Url.F_Cmayor#">
</cfif>

<cfset purl = "?a=1">
<cfif isdefined("Form.formulario")>
	<cfset purl = purl & "&formulario=" & #Form.formulario#>
</cfif>
<cfif isdefined("Form.name")>
	<cfset purl = purl & "&name=" & #Form.name#>
</cfif>
<cfif isdefined("Form.desc")>
	<cfset purl = purl & "&desc=" & #Form.desc#>
</cfif>
<cfif isdefined("Form.conexion")>
	<cfset purl = purl & "&conexion=" & #Form.conexion#>
</cfif>
<cfif isdefined("Form.conexion")>
	<cfset purl = purl & "&conexion=" & #Form.conexion#>
</cfif>
<cfif isdefined("Form.autoSubmit")>
	<cfset purl = purl & "&autoSubmit=" & #Form.autoSubmit#>
</cfif>
<cfif isdefined("Form.ctr")>
	<cfset purl = purl & "&ctr=" & #Form.ctr#>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(v1, v2) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Form.formulario#.#Form.name#.value = v1;
			window.opener.document.#Form.formulario#.#Form.desc#.value = v2;
			<cfif isdefined("Form.autoSubmit") and Form.autoSubmit>
				if (window.opener.TraeCTR#Form.ctr#) {
					window.opener.TraeCTR#Form.ctr#(v1);
				}

				window.close();
			</cfif>
			window.close();
		</cfoutput>

	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.F_Cmayor") and Len(Trim(Form.F_Cmayor)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.Cmayor) like '%" & #UCase(Form.F_Cmayor)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cmayor=" & Form.F_Cmayor & #purl#>
</cfif>
<cfif isdefined("Form.F_Cdescripcion") and Len(Trim(Form.F_Cdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.Cdescripcion) like '%" & #UCase(Form.F_Cdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cdescripcion=" & Form.F_Cdescripcion & #purl#>
</cfif>

<cfoutput>
<form style="margin:0; " name="filtroUsuario" method="post" action="#CurrentPage##purl#">

<input type="hidden" name="Ecodigo" value="<cfif isdefined("Form.Ecodigo")>#Form.Ecodigo#</cfif>">
<input type="hidden" name="formulario" value="<cfif isdefined("Form.formulario")>#Form.formulario#</cfif>">
<input type="hidden" name="name" value="<cfif isdefined("Form.name")>#Form.name#</cfif>">
<input type="hidden" name="desc" value="<cfif isdefined("Form.desc")>#Form.desc#</cfif>">
<input type="hidden" name="conexion" value="<cfif isdefined("Form.conexion")>#Form.conexion#</cfif>">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr>
    <td align="right">Cuenta Mayor</td>
    <td>
      <input name="F_Cmayor" type="text" id="F_Cmayor" size="20" maxlength="30" value="<cfif isdefined("Form.F_Cmayor")>#Form.F_Cmayor#</cfif>">
    </td>
    <td align="right">Descripcion</td>
    <td>
      <input name="F_CDescripcion" type="text" id="F_CDescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.F_CDescripcion")>#Form.F_CDescripcion#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar">
    </td>
  </tr>
</table>
</form>
</cfoutput>

					<!---
	filtro="a.cliente_empresarial = #Session.CEcodigo# order by b.Cmayor, b.Cdescripcion"
						--->


<cfinvoke
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N">
	<cfinvokeargument name="tabla" value="Empresas a
								inner join CtasMayor b
								on b.Ecodigo = a.Ecodigo"/>
	<cfinvokeargument name="columnas" value="distinct b.Cmayor, b.Cdescripcion"/>
	<cfinvokeargument name="desplegar" value="Cmayor, Cdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Cuenta Mayor, Descripcion"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="filtro" value="a.cliente_empresarial = #Session.CEcodigo#
											#filtro#
											order by b.Cmayor, b.Cdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="conlisUsuarios.cfm"/>
	<cfinvokeargument name="formName" value="listaUsuarios"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Cmayor, Cdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="conexion" value="#form.conexion#"/>
</cfinvoke>

</body>
</html>