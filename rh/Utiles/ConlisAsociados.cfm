<html>
<head>
<title><cf_translate key="LB_ListadeEmpleados">Lista de Asociados</cf_translate></title>
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
<cfif isdefined("Url.p6") and not isdefined("Form.p6")>
	<cfparam name="Form.p6" default="#Url.p6#">
</cfif>
<cfif isdefined("Url.p7") and not isdefined("Form.p7")>
	<cfparam name="Form.p7" default="#Url.p7#">
</cfif>
<cfif isdefined("Url.p8") and not isdefined("Form.p8")>
	<cfparam name="Form.p8" default="#Url.p8#">
</cfif>

<cfif isdefined("Url.shid") and not isdefined("Form.shid")>
	<cfparam name="Form.shid" default="#Url.shid#">
</cfif>
<cfif isdefined("Url.valus") and not isdefined("Form.valus")>
	<cfparam name="Form.valus" default="#Url.valus#">
</cfif>
<cfif isdefined("Url.valcomp") and not isdefined("Form.valcomp")>
	<cfparam name="Form.valcomp" default="#Url.valcomp#">
</cfif>
<cfif isdefined("Url.valemp") and not isdefined("Form.valemp")>
	<cfparam name="Form.valemp" default="#Url.valemp#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.ACAid") and not isdefined("Form.ACAid")>
	<cfparam name="Form.ACAid" default="#Url.ACAid#">
</cfif>
<cfif isdefined("Url.NTIcodigo") and not isdefined("Form.NTIcodigo")>
	<cfparam name="Form.NTIcodigo" default="#Url.NTIcodigo#">
</cfif>
<cfif isdefined("Url.CFid") and not isdefined("Form.CFid")>
	<cfparam name="Form.CFid" default="#Url.CFid#">
</cfif>
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, tipo, ced, emp, asoc, tcodigo, tipopago) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p3#.value = trim(ced);
		window.opener.document.#Form.f#.#Form.p4#.value = emp;
		window.opener.document.#Form.f#.#Form.p6#.value = asoc;		
		window.opener.document.#Form.f#.#Form.p7#.value = tcodigo;
		window.opener.document.#Form.f#.#Form.p8#.value = tipopago;
		if (window.opener.document.#Form.f#.#Form.p2#.options != null) {
			for (var i = 0; i < window.opener.document.#Form.f#.#Form.p2#.options.length; i++) {
				if (window.opener.document.#Form.f#.#Form.p2#.options[i].value == tipo) {
					window.opener.document.#Form.f#.#Form.p2#.options.selectedIndex = i;
				}
			}
		}
		
		if (window.opener.funcACAid){ window.opener.funcACAid(); }
		var funcName = 'window.opener.func'+id;
		if (eval(funcName)){ eval(funcName)(); }

		</cfoutput>

		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.shid") and Len(Trim(Form.shid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "shid=" & Form.shid>
</cfif>
<cfif isdefined("Form.valus") and Len(Trim(Form.valus)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valus=" & Form.valus>
</cfif>
<cfif isdefined("Form.valcomp") and Len(Trim(Form.valcomp)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valcomp=" & Form.valcomp>
</cfif>
<cfif isdefined("Form.valemp") and Len(Trim(Form.valemp)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valemp=" & Form.valemp>
</cfif>
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.ACAid") and Len(Trim(Form.ACAid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ACAid=" & Form.ACAid>
</cfif>
<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NTIcodigo=" & Form.NTIcodigo>
</cfif>
<!--- El centro funcional puede ir vacio --->
<cfif isdefined("Form.CFid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFid=" & Form.CFid>
</cfif>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
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
<cfif isdefined("Form.p5")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p5=" & Form.p5>
</cfif>
<cfif isdefined("Form.p6")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p6=" & Form.p6>
</cfif>
<cfif isdefined("Form.p7")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p7=" & Form.p7>
</cfif>
<cfif isdefined("Form.p8")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p8=" & Form.p8>
</cfif>

<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="p5" value="#Form.p5#">
<input type="hidden" name="p6" value="#Form.p6#">
<input type="hidden" name="p7" value="#Form.p7#">
<input type="hidden" name="p8" value="#Form.p8#">
<input type="hidden" name="shid" value="<cfif isdefined("Form.shid")>#Form.shid#</cfif>">
<input type="hidden" name="valus" value="<cfif isdefined("Form.valus")>#Form.valus#</cfif>">
<input type="hidden" name="valcomp" value="<cfif isdefined("Form.valcomp")>#Form.valcomp#</cfif>">
<input type="hidden" name="valemp" value="<cfif isdefined("Form.valemp")>#Form.valemp#</cfif>">
<input type="hidden" name="DEid" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">
<input type="hidden" name="ACAid" value="<cfif isdefined("Form.ACAid")>#Form.ACAid#</cfif>">
<input type="hidden" name="NTIcodigo" value="<cfif isdefined("Form.NTIcodigo")>#Form.NTIcodigo#</cfif>">
<cfif isdefined("Form.CFid")>
<input type="hidden" name="CFid" value="#Form.CFid#">
</cfif>
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
  <tr> 
    <td align="right"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
    <td> 
      <input name="FDEidentificacion" type="text" id="FDEidentificacion" tabindex="1" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
    </td>
    <td align="right"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
    <td> 
      <input name="FDEnombre" type="text" id="FDEnombre" tabindex="1" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
    </td>
    <td align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>

      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEmpleados" datasource="#Session.DSN#">
	select a.DEid,
			b.ACAid, 
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   coalesce(( select Tcodigo from LineaTiempo lt where lt.Ecodigo=a.Ecodigo and lt.DEid=a.DEid and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta), '') as Tcodigo,
			coalesce(( select tn.Ttipopago from LineaTiempo lt, TiposNomina tn where lt.Ecodigo=a.Ecodigo and lt.DEid=a.DEid and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta and tn.Ecodigo=lt.Ecodigo and tn.Tcodigo=lt.Tcodigo), 0) as Ttipopago,		   
		   {fn concat ( {fn concat ( {fn concat ( {fn concat (  a.DEapellido1  , ' ' )}, a.DEapellido2 )}, ', ' )}, a.DEnombre )} as NombreCompleto
	from DatosEmpleado a, ACAsociados b
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and b.DEid=a.DEid
	  and b.ACAestado=1
	<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
		and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.NTIcodigo)#">
	</cfif>
	<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
		and upper(a.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FDEidentificacion)#%">
	</cfif>
	<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
		and upper({fn concat ( {fn concat ( {fn concat ( {fn concat ( a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FDEnombre)#%">
	</cfif>
	order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEmpleados#"/>
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
	<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisAsociados.cfm"/>
	<cfinvokeargument name="formName" value="listaAsociados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, NombreCompleto,ACAid,Tcodigo,Ttipopago"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
