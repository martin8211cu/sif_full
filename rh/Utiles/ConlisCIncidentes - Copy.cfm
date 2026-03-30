<html>
<head>
<title>Lista de Conceptos de Pago</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif isdefined ('url.omitir') and len(trim(url.omitir)) gt 0>
	<cfparam name="form.omitir" default="#url.omitir#">
</cfif>
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
<cfif isdefined("Url.IncluirTipo") and not isdefined("Form.IncluirTipo")>
	<cfparam name="Form.IncluirTipo" default="#Url.IncluirTipo#">
</cfif>
<cfif isdefined("Url.ExcluirTipo") and not isdefined("Form.ExcluirTipo")>
	<cfparam name="Form.ExcluirTipo" default="#Url.ExcluirTipo#">
</cfif>
<cfif isdefined("Url.IncluirAnticipo") and not isdefined("Form.IncluirAnticipo")>
	<cfparam name="Form.IncluirAnticipo" default="#Url.IncluirAnticipo#">
</cfif>
<cfif isdefined("Url.IncluirChk") and not isdefined("Form.IncluirChk")>
	<cfparam name="Form.IncluirChk" default="#Url.IncluirChk#">
</cfif>
<cfif isdefined("Url.CarreraP") and not isdefined("Form.CarreraP")>
	<cfparam name="Form.CarreraP" default="#Url.CarreraP#">
</cfif>
<cfif isdefined("Url.submit") and not isdefined("Form.submit")>
	<cfparam name="Form.submit" default="#Url.submit#">
</cfif>

<cfif isdefined("Url.onBlur") and not isdefined("Form.onBlur")>
	<cfparam name="Form.onBlur" default="#Url.onBlur#">
</cfif>

<cfif isdefined("Url.CIid") and not isdefined("Form.CIid")>
	<cfparam name="Form.CIid" default="#Url.CIid#">
</cfif>
<cfif isdefined("Url.CIcodigo") and not isdefined("Form.CIcodigo")>
	<cfparam name="Form.CIcodigo" default="#Url.CIcodigo#">
</cfif>
<cfif isdefined("Url.CIdescripcion") and not isdefined("Form.CIdescripcion")>
	<cfparam name="Form.CIdescripcion" default="#Url.CIdescripcion#">
</cfif>
<cfif isdefined("Url.index") and not isdefined("Form.index")>
	<cfparam name="Form.index" default="#Url.index#">
</cfif>


<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc, signo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = desc;
		if (window.opener.document.#Form.f#.negativo) {
			window.opener.document.#Form.f#.negativo.value = signo;
		}
		<cfif (isDefined("Form.onBlur")) and (len(trim(Form.onBlur)) gt 0)>
			window.opener.#Form.onBlur#;
		</cfif>
		</cfoutput>
		window.close();
	}
}
	<cfif isdefined('form.chk')>
		<cfoutput>
		window.opener.document.#Form.f#.chkLista#form.index#.value = '#Form.chk#';
		<cfif isdefined('form.submit') and LEN(TRIM(form.submit))>
		window.opener.document.#Form.f#.submit();
		</cfif>
		</cfoutput>
		window.close();
	</cfif>
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
<cfif isdefined("Form.CIid") and Len(Trim(Form.CIid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CIid=" & Form.CIid>
</cfif>
<cfif isdefined("Form.CIcodigo") and Len(Trim(Form.CIcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(CIcodigo) like '%" & #UCase(Form.CIcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CIcodigo=" & Form.CIcodigo>
</cfif>
<cfif isdefined("Form.CIdescripcion") and Len(Trim(Form.CIdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CIdescripcion) like '%" & #UCase(Form.CIdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CIdescripcion=" & Form.CIdescripcion>
</cfif>

<cfif isdefined ('form.omitir') and len(trim(form.omitir)) gt 0>
	<cfset filtro=filtro & "and CIid not in ("&form.omitir & ")">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CIid  not in" & Form.omitir>
</cfif>
<cfif isdefined("Form.Index") and Len(Trim(Form.Index)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Index=" & Form.Index>
</cfif>

<cfif isdefined("Form.IncluirTipo") and Len(Trim(Form.IncluirTipo)) NEQ 0>
 	<cfset filtro = filtro & " and CItipo in (" & Form.IncluirTipo & ")">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "IncluirTipo=" & Form.IncluirTipo>
</cfif>
<cfif isdefined("Form.ExcluirTipo") and Len(Trim(Form.ExcluirTipo)) NEQ 0>
 	<cfset filtro = filtro & " and CItipo not in (" & Form.ExcluirTipo & ")">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ExcluirTipo=" & Form.ExcluirTipo>
</cfif>
<cfif isdefined("Form.IncluirAnticipo") and Form.IncluirAnticipo NEQ 0>
 	<cfset filtro = filtro & " and CInoanticipo = 1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "IncluirAnticipo=" & Form.IncluirAnticipo>
</cfif>
<cfif isdefined("Form.IncluirChk") and Form.IncluirChk NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "IncluirChk=" & Form.IncluirChk>
</cfif>
<cfif isdefined("Form.CarreraP") and LEN(TRIM(Form.CarreraP)) NEQ 0>
	<cfset filtro = filtro & " and CIcarreracp = " & Form.CarreraP>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CarreraP=" & Form.CarreraP>
</cfif>
<cfif isdefined("Form.onBlur") and Len(Trim(Form.onBlur)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "onBlur=" & Form.onBlur>
</cfif>
<cfif isdefined("Form.submit") and Form.submit NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "submit=" & Form.submit>
</cfif>
<cfoutput>
<form name="filtroCIncidentes" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<cfif isdefined ('form.omitir')>
<input type="hidden" name="omitir" value="#form.omitir#">
</cfif>
<cfif isdefined("Form.IncluirTipo") and Len(Trim(Form.IncluirTipo)) NEQ 0>
	<input type="hidden" name="IncluirTipo" value="#Form.IncluirTipo#">
</cfif>
<cfif isdefined("Form.ExcluirTipo") and Len(Trim(Form.ExcluirTipo)) NEQ 0>
	<input type="hidden" name="ExcluirTipo" value="#Form.ExcluirTipo#">
</cfif>
<cfif isdefined("Form.IncluirAnticipo") and Len(Trim(Form.IncluirAnticipo)) NEQ 0>
	<input type="hidden" name="IncluirAnticipo" value="#Form.IncluirAnticipo#">
</cfif>
<cfif isdefined("Form.IncluirChk") and Len(Trim(Form.IncluirChk)) NEQ 0>
	<input type="hidden" name="IncluirChk" value="#Form.IncluirChk#">
</cfif>
<cfif isdefined("Form.CarreraP") and Len(Trim(Form.CarreraP)) NEQ 0>
	<input type="hidden" name="CarreraP" value="#Form.CarreraP#">
</cfif>
<cfif isdefined("Form.submit") and Len(Trim(Form.submit)) NEQ 0>
	<input type="hidden" name="submit" value="#Form.submit#">
</cfif>
<cfif isdefined("Form.index") and Len(Trim(Form.index)) NEQ 0>
	<input type="hidden" name="index" value="#Form.index#">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_CODIGO"
default="C&oacute;digo"
xmlfile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_DESCRIPCION"
default="Descripci&oacute;n"
xmlfile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="LB_btnBuscar"
default="Filtrar"
xmlfile="/rh/generales.xml"
returnvariable="LB_btnBuscar"/>


<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right"><cfoutput>#LB_CODIGO#:</cfoutput></td>
    <td> 
      <input name="CIcodigo" type="text" id="CIcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.CIcodigo")>#Form.CIcodigo#</cfif>">
    </td>
    <td align="right"><cfoutput>#LB_DESCRIPCION#:</cfoutput></td>
    <td> 
      <input name="CIdescripcion" type="text" id="CIdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.CIdescripcion")>#Form.CIdescripcion#</cfif>">
    </td>
    <td align="center">
	<input type="submit" name="btnBuscar"  id="btnBuscar"value="<cfoutput>#LB_btnBuscar#</cfoutput>">	
    </td>
  </tr>
</table>
<cfif isdefined('form.IncluirChk') and LEN(TRIM(form.IncluirChk))>
	<cfset Lvar_Botones = 'Seleccionar'>
	<cfset Lvar_CHK = 'D'>
<cfelse>
	<cfset Lvar_Botones = ''>
	<cfset Lvar_CHK = 'N'>
</cfif>
</cfoutput>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="CIncidentes"/>
	<cfinvokeargument name="columnas" value="CIid, CIcodigo, CIdescripcion, CInegativo"/>
	<cfinvokeargument name="desplegar" value="CIcodigo, CIdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by CIcodigo, CIdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="conlisCIncidentes.cfm"/>
	<cfinvokeargument name="formName" value="listaCIncidentes"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CIid, CIcodigo, CIdescripcion, CInegativo"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="formName" value="filtroCIncidentes"/>
	<cfinvokeargument name="botones" value="#Lvar_Botones#"/>
	<cfinvokeargument name="checkboxes" value="#Lvar_CHK#"/>
	<cfinvokeargument name="keys" value="CIid"/>
</cfinvoke>
</form>
</body>
</html>
