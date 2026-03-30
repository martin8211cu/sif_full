<html>
<head>
<title>Lista de Beneficios por Empleado</title>
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
<cfif isdefined("Url.p9") and not isdefined("Form.p9")>
	<cfparam name="Form.p9" default="#Url.p9#">
</cfif>
<cfif isdefined("Url.p10") and not isdefined("Form.p10")>
	<cfparam name="Form.p10" default="#Url.p10#">
</cfif>

<cfif isdefined("Url.BElinea") and not isdefined("Form.BElinea")>
	<cfparam name="Form.BElinea" default="#Url.BElinea#">
</cfif>
<cfif isdefined("Url.Bcodigo") and not isdefined("Form.Bcodigo")>
	<cfparam name="Form.Bcodigo" default="#Url.Bcodigo#">
</cfif>
<cfif isdefined("Url.Bdescripcion") and not isdefined("Form.Bdescripcion")>
	<cfparam name="Form.Bdescripcion" default="#Url.Bdescripcion#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
function Asignar(id, cod, desc, mon, monto, porc, tercero, sociocod, socionum, sociodesc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = cod;
		window.opener.document.#Form.f#.#Form.p3#.value = desc;
		<!--- Es un combo --->
		for (var i=0; i<window.opener.document.#Form.f#.#Form.p4#.length; i++) {
			if (window.opener.document.#Form.f#.#Form.p4#.options[i].value == mon) {
				window.opener.document.#Form.f#.#Form.p4#.selectedIndex = i;
				break;
			}
		}
		window.opener.document.#Form.f#.#Form.p5#.value = fm(monto, 2);
		window.opener.document.#Form.f#.#Form.p6#.value = fm(porc, 2);
		window.opener.document.#Form.f#.#Form.p7#.value = tercero;
		window.opener.document.#Form.f#.#Form.p8#.value = sociocod;
		window.opener.document.#Form.f#.#Form.p9#.value = socionum;
		window.opener.document.#Form.f#.#Form.p10#.value = sociodesc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfloop collection="#Form#" item="i">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "#i#=" & Form[i]>
</cfloop>

<cfoutput>
<form name="filtroBeneficio" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="p5" value="#Form.p5#">
<input type="hidden" name="p6" value="#Form.p6#">
<input type="hidden" name="p7" value="#Form.p7#">
<input type="hidden" name="p8" value="#Form.p8#">
<input type="hidden" name="p9" value="#Form.p9#">
<input type="hidden" name="p10" value="#Form.p10#">
<input type="hidden" name="DEid" value="#Form.DEid#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">C&oacute;digo</td>
    <td> 
      <input name="Bcodigo" type="text" id="Bcodigo" size="20" maxlength="60" value="<cfif isdefined("Form.Bcodigo")>#Form.Bcodigo#</cfif>">
    </td>
    <td align="right">Descripci&oacute;n</td>
    <td> 
      <input name="Bdescripcion" type="text" id="Bdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.Bdescripcion")>#Form.Bdescripcion#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select a.BElinea, a.DEid, a.Bid, a.Mcodigo, a.SNcodigo, a.BEfdesde, a.BEfhasta, a.BEmonto, a.BEporcemp, a.BEactivo, a.fechainactiva, a.BMUsucodigo, a.fechaalta, 
		   b.Bcodigo, b.Bdescripcion, b.Btercero, c.SNnumero, c.SNnombre
	from RHBeneficiosEmpleado a
		
		inner join RHBeneficios b
			on a.Ecodigo = b.Ecodigo
			and a.Bid = b.Bid
			and b.Brequierereg = 1
		
		left outer join SNegocios c
			on a.Ecodigo = c.Ecodigo
			and a.SNcodigo = c.SNcodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	<cfif isdefined("Form.Bcodigo") and Len(Trim(Form.Bcodigo)) NEQ 0>
		and upper(b.Bcodigo) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Form.Bcodigo)#%">
	</cfif>
	<cfif isdefined("Form.Bdescripcion") and Len(Trim(Form.Bdescripcion)) NEQ 0>
		and upper(b.Bdescripcion) like <cfqueryparam cfsqltype="cf_sql_char" value="%#UCase(Form.Bdescripcion)#%">
	</cfif>
	order by b.Bcodigo, b.Bdescripcion
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="LvarResult">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="Bcodigo, Bdescripcion"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#CurrentPage#"/>
	<cfinvokeargument name="formName" value="listaBeneficio"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="BElinea, Bcodigo, Bdescripcion, Mcodigo, BEmonto, BEporcemp, Btercero, SNcodigo, SNnumero, SNnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>


</body>
</html>
