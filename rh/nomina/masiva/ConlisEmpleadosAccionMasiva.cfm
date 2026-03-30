<!----==================== TRADUCCION ========================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Empleados"
	Default="Lista de Empleados"	
	returnvariable="LB_Lista_de_Empleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre_Completo"
	Default="Nombre Completo"	
	returnvariable="LB_Nombre_Completo"/>	
 
	
<html>
<head>
<title><cfoutput>#LB_Lista_de_Empleados#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<!---<cf_dump var = "#url#">--->
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.pd_acciondesde") and not isdefined("Form.pd_acciondesde")>
	<cfparam name="Form.pd_acciondesde" default="#Url.pd_acciondesde#">
</cfif>
<cfif isdefined("Url.pd_accionhasta") and not isdefined("Form.pd_accionhasta")>
	<cfparam name="Form.pd_accionhasta" default="#Url.pd_accionhasta#">
</cfif>
<cfif isdefined("Url.po_form") and not isdefined("Form.po_form")>
	<cfparam name="Form.po_form" default="#Url.po_form#">
</cfif>
<cfif isdefined("url.empresa")>
	<cfparam name="Form.Empresas" default="#Url.Empresa#">
</cfif>

<!---<cf_dump var = "#url.empresa#">
--->
<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, tipo, ced, emp, usucodigo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#po_form#.DEid.value = id;
		window.opener.document.#po_form#.DEidentificacion.value = trim(ced);
		window.opener.document.#po_form#.Nombre.value = emp;
		if (window.opener.document.#po_form#.DEid.options != null) {
			for (var i = 0; i < window.opener.document.#po_form#.DEidentificacion.options.length; i++) {
				if (window.opener.document.#po_form#.DEidentificacion.options[i].value == tipo) {
					window.opener.document.#po_form#.DEidentificacion.options.selectedIndex = i;
				}
			}
		}
		</cfoutput>

		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.pd_acciondesde") and Len(Trim(Form.pd_acciondesde)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "pd_acciondesde=" & Form.pd_acciondesde>
</cfif>
<cfif isdefined("Form.pd_accionhasta") and Len(Trim(Form.pd_accionhasta)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "pd_accionhasta=" & Form.pd_accionhasta>
</cfif>
<cfif isdefined("Form.po_form") and Len(Trim(Form.po_form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "po_form=" & Form.po_form>
</cfif>


<cfoutput>
<form name="filtroEmpleado" method="post" action="">

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">#LB_Identificacion#</td>
    <td> 
      <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
    </td>
    <td align="right"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
    <td> 
      <input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEmpleados" datasource="#Session.DSN#">
	select	distinct a.DEid, 
			a.NTIcodigo, 
			a.DEidentificacion, 
			{fn concat({fn concat({fn concat({ fn concat(a.DEapellido1 , ' ') },a.DEapellido2)}, ' ')},a.DEnombre) } as NombreCompleto
	from DatosEmpleado a
		inner join LineaTiempo b
			on a.DEid = b.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.pd_acciondesde)#"> <= b.LThasta
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.pd_accionhasta)#"> >= b.LTdesde
			
			inner join RHLineaTiempoPlaza c
				on b.RHPid = c.RHPid
				and c.RHMPnegociado = 'T'
	where a.Ecodigo in (<cfif isdefined ('Empresas') and len(trim(Empresas))>
    						#Empresas#
                        <cfelse>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        </cfif>)
		<cfif isdefined("form.FDEidentificacion") and len(trim(form.FDEidentificacion))>
			and upper(a.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FDEidentificacion)#%">
		</cfif>
		<cfif isdefined("form.FDEnombre") and len(trim(form.FDEnombre))>
			and (upper(a.DEnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FDEnombre)#%">
			or upper(a.DEapellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FDEnombre)#%">
			or upper(a.DEapellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FDEnombre)#%">)
		</cfif>
	order by a.DEidentificacion, NombreCompleto
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEmpleados#"/>	
	<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
	<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre_Completo#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisEmpleados.cfm"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>	
	<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, NombreCompleto"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showemptylistmsg" value="true"/>
</cfinvoke>

</body>
</html>
