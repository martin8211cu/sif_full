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

<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.po_form") and not isdefined("Form.po_form")>
	<cfparam name="Form.po_form" default="#Url.po_form#">
</cfif>
<cfif isdefined('url.REid') and not isdefined('form.REid')>
	<cfparam name="form.REid" default="#url.REid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, tipo, ced, emp, usucodigo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#po_form#.#prefijo#DEid.value = id;
		window.opener.document.#po_form#.#prefijo#DEidentificacion.value = trim(ced);
		window.opener.document.#po_form#.#prefijo#Nombre.value = emp;
		if (window.opener.document.#po_form#.FDEid.options != null) {
			for (var i = 0; i < window.opener.document.#po_form#.DEidentificacion.options.length; i++) {
				if (window.opener.document.#po_form#.#prefijo#DEidentificacion.options[i].value == tipo) {
					window.opener.document.#po_form#.#prefijo#DEidentificacion.options.selectedIndex = i;
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
<cfif isdefined("Form.po_form") and Len(Trim(Form.po_form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "po_form=" & Form.po_form>
</cfif>


<cfoutput>
<form name="filtroEmpleado" method="post" action="">

<table width="98%" border="0" cellpadding="2" cellspacing="0">
	<tr><td class="tituloAlterno" colspan="5"><cfoutput>#LB_Lista_de_Empleados#</cfoutput></td></tr>
  <tr class="tituloListas"> 
    <td >#LB_Identificacion#</td>
   
    <td ><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
	<td>&nbsp;</td>
	</tr>
	<tr  class="tituloListas">
	 <td> 
      <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
    </td>	
    <td> 
      <input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
    </td>
    <td align="center">
		<cf_botones names="btnBuscar" values="#BTN_Filtrar#">
      <!--- <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#"> --->
    </td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEmpleados" datasource="#Session.DSN#">
	select de.NTIcodigo,de.DEid as DEid, 
		de.DEidentificacion as DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat( de.DEnombre, ' ' )}, de.DEapellido1 )},  ' ' )}, de.DEapellido2)} as Nombre
	from RHGruposRegistroE gr
	inner join RHCFGruposRegistroE gcf
		on gcf.Ecodigo = gr.Ecodigo
		and gcf.GREid = gr.GREid
		
	inner join RHRegistroEvaluacion rel
		on rel.REid = gr.REid
		
	inner join RHPlazas rhp
		on rhp.Ecodigo = gcf.Ecodigo
		and rhp.CFid = gcf.CFid	

	inner join CFuncional cf
		on cf.Ecodigo = rhp.Ecodigo
		and cf.CFid = rhp.CFid

	inner join LineaTiempo lt
		on lt.Ecodigo = rhp.Ecodigo
		and lt.RHPid = rhp.RHPid
		and getDate() between lt.LTdesde and lt.LThasta

	inner join RHPuestos rhpu
		on rhpu.Ecodigo = lt.Ecodigo
		and rhpu.RHPcodigo = lt.RHPcodigo

	inner join DatosEmpleado de
		on de.Ecodigo = rhpu.Ecodigo
		and de.DEid = lt.DEid
		<cfif isdefined('form.FDEnombre') and LEN(TRIM(form.FDEnombre))>
		and upper(rtrim( convert (varchar(255), {fn concat({fn concat({fn concat({fn concat( de.DEnombre, ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2)}) )) like '%#Ucase(form.FDEnombre)#%'
		</cfif>
		<cfif isdefined('form.FDEidentificacion') and LEN(TRIM(form.FDEidentificacion))>
		and upper(rtrim( convert (varchar(255), de.DEidentificacion))) like '%#Ucase(form.FDEidentificacion)#%'
		</cfif>

	where gr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	   and rel.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">

union
	select de2.NTIcodigo,de2.DEid as DEid, de2.DEidentificacion as DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat( de2.DEnombre, ' ' )}, de2.DEapellido1 )},  ' ' )}, de2.DEapellido2)} as Nombre								
		from RHRegistroEvaluacion rel2
			inner join RHEmpleadoRegistroE ere2
				on ere2.REid = rel2.REid
			inner join DatosEmpleado de2
				on de2.DEid = ere2.DEid
				<cfif isdefined('form.FDEnombre') and LEN(TRIM(form.FDEnombre))>
				and upper(rtrim( convert (varchar(255), {fn concat({fn concat({fn concat({fn concat( de2.DEnombre, ' ' )}, de2.DEapellido1 )}, ' ' )}, de2.DEapellido2)}) )) like '%#Ucase(form.FDEnombre)#%'
				</cfif>
				<cfif isdefined('form.FDEidentificacion') and LEN(TRIM(form.FDEidentificacion))>
				and upper(rtrim( convert (varchar(255), de2.DEidentificacion))) like '%#Ucase(form.FDEidentificacion)#%'
				</cfif>
				
			inner join LineaTiempo lt2
				on lt2.Ecodigo=de2.Ecodigo
				and lt2.DEid=de2.DEid
				and lt2.LTid = (select max(lt3.LTid) from LineaTiempo lt3 where lt3.DEid = lt2.DEid and lt3.LTdesde = (select max(lt4.LTdesde) from LineaTiempo lt4 where lt4.DEid = lt3.DEid))
		where rel2.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEmpleados#"/>	
	<cfinvokeargument name="desplegar" value="DEidentificacion, Nombre"/>
	<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre_Completo#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisEmpleados.cfm"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>	
	<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, Nombre"/>	
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showemptylistmsg" value="true"/>
</cfinvoke>

</body>
</html>
