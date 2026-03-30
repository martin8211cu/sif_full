<html>
<head>
<title>Lista de Usuarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/sif/css/sif.css" rel="stylesheet" type="text/css">
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

<cfif isdefined("Url.roles") and not isdefined("Form.roles")>
	<cfparam name="Form.roles" default="#Url.roles#">
</cfif>
<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
</cfif>
<cfif isdefined("Url.Usulogin") and not isdefined("Form.Usulogin")>
	<cfparam name="Form.Usulogin" default="#Url.Usulogin#">
</cfif>
<cfif isdefined("Url.Usunombre") and not isdefined("Form.Usunombre")>
	<cfparam name="Form.Usunombre" default="#Url.Usunombre#">
</cfif>


<script language="JavaScript" type="text/javascript">
function Asignar(p1, p2, p3, p4) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#.value = p1;
			window.opener.document.#Form.f#.#Form.p2#.value = p2;
			window.opener.document.#Form.f#.#Form.p3#.value = p3;
			window.opener.document.#Form.f#.#Form.p4#.value = p4;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<cfif len(trim(Form.Ecodigo))>
	<cfset filtro = filtro & " d.consecutivo = #Form.Ecodigo#">
</cfif>
<cfif len(trim(Form.roles))>
	<cfset arrayroles = ListToArray(Form.roles)>
	<cfset aux = "">
	<cfset listaroles = "">
	<cfloop index="i" from="1" to="#ArrayLen(arrayroles)#">
		<cfset listaroles = listaroles & aux & "'" & arrayroles[i] & "'">
		<cfset aux = ",">
	</cfloop>
	<cfset filtro = filtro & " and a.rol in (#Replace(listaroles, ' ', '', 'all')#)">
</cfif>

<cfif isdefined("Form.roles") and Len(Trim(Form.roles)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "roles=" & Form.roles>
</cfif>
<cfif isdefined("Form.Ecodigo") and Len(Trim(Form.Ecodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ecodigo=" & Form.Ecodigo>
</cfif>
<cfif isdefined("Form.Usulogin") and Len(Trim(Form.Usulogin)) NEQ 0>
	<cfset filtro = filtro & " and upper(f.Usulogin) like '%" & #UCase(Form.Usulogin)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usulogin=" & Form.Usulogin>
</cfif>
<cfif isdefined("Form.Usunombre") and Len(Trim(Form.Usunombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(e.Papellido1 + ' ' + e.Papellido2 + ', ' + e.Pnombre) like '%" & #UCase(Form.Usunombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usunombre=" & Form.Usunombre>
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
<form style="margin:0; " name="filtroUsuario" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="roles" value="<cfif isdefined("Form.roles")>#Form.roles#</cfif>">
<input type="hidden" name="Ecodigo" value="<cfif isdefined("Form.Ecodigo")>#Form.Ecodigo#</cfif>">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">Indentificaci&oacute;n</td>
    <td> 
      <input name="Usulogin" type="text" id="Usulogin" size="20" maxlength="30" value="<cfif isdefined("Form.Usulogin")>#Form.Usulogin#</cfif>">
    </td>
    <td align="right">Nombre</td>
    <td> 
      <input name="Usunombre" type="text" id="Usunombre" size="40" maxlength="80" value="<cfif isdefined("Form.Usunombre")>#Form.Usunombre#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="sif.rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N">
	<cfinvokeargument name="tabla" value="UsuarioPermiso a, UsuarioEmpresa b, Empresa c, EmpresaID d, UsuarioEmpresarial e, Usuario f"/>
	<cfinvokeargument name="columnas" value="distinct 
											   convert(varchar, e.Usucodigo) as Usucodigo,
											   e.Ulocalizacion,
											   f.Usulogin, 
											   e.Papellido1 + ' ' + e.Papellido2 + ' ' + e.Pnombre as Usunombre"/>
	<cfinvokeargument name="desplegar" value="Usulogin, Usunombre"/>
	<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="filtro" value="#filtro#
												and a.Ecodigo = b.Ecodigo
												and a.cliente_empresarial = b.cliente_empresarial
												and a.Usucodigo = b.Usucodigo
												and a.Ulocalizacion = b.Ulocalizacion
												and b.Ecodigo = c.Ecodigo
												and c.Ecodigo = d.Ecodigo
												and b.Usucodigo = e.Usucodigo
												and b.Ulocalizacion = e.Ulocalizacion
												and b.cliente_empresarial = e.cliente_empresarial
												and e.Usucodigo = f.Usucodigo
												and e.Ulocalizacion = f.Ulocalizacion
												and f.Usutemporal = 0
												and f.activo = 1
												order by f.Usulogin"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="conlisUsuarios.cfm"/>
	<cfinvokeargument name="formName" value="listaUsuarios"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Usucodigo, Ulocalizacion, Usulogin, Usunombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
