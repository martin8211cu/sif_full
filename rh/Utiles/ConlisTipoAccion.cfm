<html>
<head>
<title><cf_translate  key="LB_ListaDeTiposDeAcciones">Lista de Tipos de Acciones</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
<cfif isdefined("Url.p5") and not isdefined("Form.p5")>
	<cfparam name="Form.p5" default="#Url.p5#">
</cfif>
<cfif isdefined("Url.ag") and not isdefined("Form.ag")>
	<cfparam name="Form.ag" default="#Url.ag#">
</cfif>

<cfif isdefined("Url.RHTid") and not isdefined("Form.RHTid")>
	<cfparam name="Form.RHTid" default="#Url.RHTid#">
</cfif>
<cfif isdefined("Url.RHTcodigo") and not isdefined("Form.RHTcodigo")>
	<cfparam name="Form.RHTcodigo" default="#Url.RHTcodigo#">
</cfif>
<cfif isdefined("Url.RHTdesc") and not isdefined("Form.RHTdesc")>
	<cfparam name="Form.RHTdesc" default="#Url.RHTdesc#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, acc, pmax, plazofijo, comportam, cambioempr) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = acc;
		window.opener.document.#Form.f#.#Form.p4#.value = pmax;
		window.opener.document.#Form.f#.#Form.p5#.value = comportam;
		if (window.opener.hideControls) {
			window.opener.hideControls(plazofijo, 1, 2);
			<!--- SI NO ES CAMBIO DE EMPRESA se oculta el campo de Empresa --->
			if (comportam != '9') {
				window.opener.hideControls('0', 3);
			} else {
				window.opener.hideControls(cambioempr, 3);
			}
		}
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.ag") and Len(Trim(Form.ag)) NEQ 0>
	<cfset filtro = filtro & " and RHTautogestion = 1">
</cfif>
<cfif isdefined("Form.RHTid") and Len(Trim(Form.RHTid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTid=" & Form.RHTid>
</cfif>
<cfif isdefined("Form.RHTcodigo") and Len(Trim(Form.RHTcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.RHTcodigo) like '%" & #UCase(Form.RHTcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTcodigo=" & Form.RHTcodigo>
</cfif>
<cfif isdefined("Form.RHTdesc") and Len(Trim(Form.RHTdesc)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHTdesc) like '%" & #UCase(Form.RHTdesc)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTdesc=" & Form.RHTdesc>
</cfif>

<cfif isdefined("form.f") and len(trim(form.f))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f >
</cfif>
<cfif isdefined("form.p1") and len(trim(form.p1))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1 >
</cfif>
<cfif isdefined("form.p2") and len(trim(form.p2))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2 >
</cfif>
<cfif isdefined("form.p3") and len(trim(form.p3))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3 >
</cfif>
<cfif isdefined("form.p4") and len(trim(form.p4))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4 >
</cfif>
<cfif isdefined("form.ag") and len(trim(form.ag))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ag=" & Form.ag >
</cfif>

<cfoutput>
<form name="filtroTipoAccion" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="p5" value="#Form.p5#">
<cfif isdefined("Form.ag")>
<input type="hidden" name="ag" value="#Form.ag#">
</cfif>

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
      <input name="RHTcodigo" type="text" id="RHTcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.RHTcodigo")>#Form.RHTcodigo#</cfif>">
    </td>
    <td align="right">#LB_DESCRIPCION#</td>
    <td> 
      <input name="RHTdesc" type="text" id="RHTdesc" size="40" maxlength="80" value="<cfif isdefined("Form.RHTdesc")>#Form.RHTdesc#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
    </td>
  </tr>
</table>
</form>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoDeAccion"
Default="Tipo de Acción&oacute;n"
returnvariable="LB_TipoDeAccion"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_NombreDeAccion"
Default="Nombre de Acción"
returnvariable="LB_NombreDeAccion"/>

</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHTipoAccion a, RHUsuarioTipoAccion b"/>
	<cfinvokeargument name="columnas" value="a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa"/>
	<cfinvokeargument name="desplegar" value="RHTcodigo, RHTdesc"/>
	<cfinvokeargument name="etiquetas" value="#LB_TipoDeAccion#,#LB_NombreDeAccion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo#
											and a.RHTcomportam not in (7, 8)
											and a.Ecodigo = b.Ecodigo
											and a.RHTid  = b.RHTid 
											and b.Usucodigo = #Session.Usucodigo#
											#filtro#
											union
											select a.RHTid, rtrim(a.RHTcodigo) as RHTcodigo, a.RHTdesc, a.RHTpfijo, a.RHTpmax, a.RHTcomportam, a.RHTcempresa
											from RHTipoAccion a
											where a.Ecodigo = #Session.Ecodigo#
											  and a.RHTcomportam not in (7, 8)
											  #filtro#
											  and not exists(select 1 from RHUsuarioTipoAccion u where u.RHTid = a.RHTid)
											order by 2,3"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisTipoAccion.cfm"/>
	<cfinvokeargument name="formName" value="listaTipoAccion"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHTid, RHTcodigo, RHTdesc, RHTpmax, RHTpfijo, RHTcomportam, RHTcempresa"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>


</body>
</html>
