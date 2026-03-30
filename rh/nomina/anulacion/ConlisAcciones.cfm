<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_de_Acciones"
	xmlfile="/rh/generales.xml"
	Default="Lista de Acciones"
	returnvariable="vListaAcciones"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Lista_de_Acciones"
	xmlfile="/rh/generales.xml"
	Default="Fecha Rige"
	returnvariable="vFechaRige"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Fecha_Vence"
	xmlfile="/rh/generales.xml"
	Default="Fecha Vence"
	returnvariable="vFechaVence"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Descripcion"
	xmlfile="/rh/generales.xml"
	Default="Descripcion"
	returnvariable="vDescripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Tipo_de_Accion"
	xmlfile="/rh/generales.xml"
	Default="Tipo de Acci&oacute;n"
	returnvariable="vTipoAccion"/>

<html>
<head>
<title><cfoutput>#vListaAcciones#</cfoutput></title>
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

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id, fdesde, fhasta, desc, obs,modificaLT) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p2#.value = fdesde;
		window.opener.document.#Form.f#.#Form.p3#.value = fhasta;
		window.opener.document.#Form.f#.#Form.p4#.value = desc;
		window.opener.document.#Form.f#.#Form.p5#.value = obs;
		window.opener.document.#Form.f#.#Form.p6#.value = modificaLT;
		if (window.opener.calcDays) {
			window.opener.calcDays();
		}
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
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
<cfif isdefined("Form.p4") and Len(Trim(Form.p4)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4>
</cfif>
<cfif isdefined("Form.p5") and Len(Trim(Form.p5)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p5=" & Form.p5>
</cfif>
<cfif isdefined("Form.p6") and Len(Trim(Form.p6)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p6=" & Form.p6>
</cfif>

<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td class="areaFiltro" style="padding-left: 10px; "><strong>#vListaAcciones#</strong></td>
  </tr>
</table>
</cfoutput>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Concat">
<cfquery datasource="#session.dsn#" name="rsListaAccionesInfo">
select RHSPEid, rtrim(b.RHTcodigo)#_Concat#' - '#_Concat# b.RHTdesc as TipoAccion, c.DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHSPEfdesde"> as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="a.RHSPEfhasta"> as Fhasta,
        0 as modificaLT,
        a.RHSPEfdesde as F1
from RHSaldoPagosExceso a, RHTipoAccion b, DLaboralesEmpleado c
where a.Ecodigo = #Session.Ecodigo#
		and a.DEid = #Form.DEid#
		and a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo
		and a.DLlinea = c.DLlinea
		and a.DEid = c.DEid
		and a.Ecodigo = c.Ecodigo
		and a.RHSPEanulado <> 1
		and b.RHTcomportam <> 2 <!--- valida que el comportamiento no sea cese--->
		and c.DLlineaRef is null
		and 0 = (select count(1) from DLaboralesEmpleado x where x.Ecodigo = a.Ecodigo and x.DLlineaRef = c.DLlinea)

UNION
select distinct a.DLlinea as RHSPEid, rtrim(b.RHTcodigo)#_Concat# ' - ' #_Concat# b.RHTdesc as TipoAccion, c.DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHCSdesde"> as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="a.RHCShasta"> as Fhasta,
        1 as modificaLT,
        a.RHCSdesde as F1
from RHControlSaldos a, RHTipoAccion b, DLaboralesEmpleado c
where b.Ecodigo = #Session.Ecodigo#
		and a.DEid = #Form.DEid#
		and a.DLlinea = c.DLlinea
		and a.DEid = c.DEid
		and b.RHTid = c.RHTid
		and b.Ecodigo = c.Ecodigo
		and a.RHCSanulado <> 1
		and a.RHCSsuspendido <> 1
		and b.RHTcomportam <> 2 <!--- valida que el comportamiento no sea cese--->
		and c.DLlineaRef is null
		and 0 = (select count(1) from DLaboralesEmpleado x where x.Ecodigo = b.Ecodigo and x.DLlineaRef = c.DLlinea)
<!---Incapacidades de doble accion--->
UNION
	select RHSPEid, rtrim(e.RHTcodigo)#_Concat#' - '#_Concat# e.RHTdesc #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as TipoAccion, d.DLobs#_Concat# ' REF: ' #_Concat# b.RHTcodigo as DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHSPEfdesde"> as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="d.DLffin"> as Fhasta,
        0 as modificaLT,
        a.RHSPEfdesde as F1
	from   RHSaldoPagosExceso a
		inner join RHTipoAccion b
			on a.RHTid = b.RHTid
			and a.Ecodigo = b.Ecodigo
			and b.RHTcomportam <> 2  <!--- valida que el comportamiento no sea cese--->
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
			and a.DEid = c.DEid
			and a.Ecodigo = c.Ecodigo
		inner join DLaboralesEmpleado d
			on d.Ecodigo = a.Ecodigo
			and d.DLlinea = c.DLlineaRef
		inner join RHTipoAccion e
			on e.RHTid = d.RHTid
			and e.Ecodigo = a.Ecodigo
			and e.RHTcomportam = 5	 <!--- Accion de incapacidad--->
	where a.Ecodigo = #Session.Ecodigo#
			and a.DEid = #Form.DEid#
			and a.RHSPEanulado <> 1
UNION
	select distinct a.DLlinea as RHSPEid, rtrim(e.RHTcodigo)#_Concat# ' - ' #_Concat# e.RHTdesc #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as TipoAccion,
		 d.DLobs #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHCSdesde">  as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="d.DLffin"> as Fhasta,
        1 as modificaLT,
        a.RHCSdesde as F1
	from RHControlSaldos a
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
			and a.DEid = c.DEid
		inner join RHTipoAccion b
			on b.RHTid = c.RHTid
			and b.Ecodigo = c.Ecodigo
			and b.RHTcomportam <> 2 <!--- valida que el comportamiento no sea cese--->
		inner join DLaboralesEmpleado d
				on d.Ecodigo = b.Ecodigo
				and d.DLlinea = c.DLlineaRef
		inner join RHTipoAccion e
			on e.RHTid = d.RHTid
			and e.Ecodigo = b.Ecodigo
			and e.RHTcomportam = 5	 <!--- Accion de incapacidad--->
	where b.Ecodigo = #Session.Ecodigo#
	and a.DEid = #Form.DEid#
	and a.RHCSanulado <> 1
	and a.RHCSsuspendido <> 1
UNION<!--- 20150109 ljimenez se agregan las acciones masivas de vacaciones Racsa ---->
	select RHSPEid, rtrim(e.RHTcodigo)#_Concat#' - '#_Concat# e.RHTdesc #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as TipoAccion, d.DLobs#_Concat# ' REF: ' #_Concat# b.RHTcodigo as DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHSPEfdesde"> as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="d.DLffin"> as Fhasta,
        0 as modificaLT,
        a.RHSPEfdesde as F1
	from   RHSaldoPagosExceso a
		inner join RHTipoAccion b
			on a.RHTid = b.RHTid
			and a.Ecodigo = b.Ecodigo
			and b.RHTcomportam <> 2  <!--- valida que el comportamiento no sea cese--->
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
			and a.DEid = c.DEid
			and a.Ecodigo = c.Ecodigo
		inner join DLaboralesEmpleado d
			on d.Ecodigo = a.Ecodigo
			and d.DLlinea = c.DLlineaRef
		inner join RHTipoAccion e
			on e.RHTid = d.RHTid
			and e.Ecodigo = a.Ecodigo
			and e.RHTcomportam = 3	 <!--- Accion de vacaciones--->
	where a.Ecodigo = #Session.Ecodigo#
			and a.DEid = #Form.DEid#
			and a.RHSPEanulado <> 1

UNION <!--- 20150109 ljimenez se agregan las acciones masivas de vacaciones Racsa ---->
	select distinct a.DLlinea as RHSPEid, rtrim(e.RHTcodigo)#_Concat# ' - ' #_Concat# e.RHTdesc #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as TipoAccion,
		 d.DLobs #_Concat# ' (REF: ' #_Concat# b.RHTcodigo #_Concat# ')' as DLobs,
		<cf_dbfunction name="to_sdateDMY" args="a.RHCSdesde">  as Fdesde,
        <cf_dbfunction name="to_sdateDMY" args="d.DLffin"> as Fhasta,
        1 as modificaLT,
        a.RHCSdesde as F1
	from RHControlSaldos a
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea
			and a.DEid = c.DEid
		inner join RHTipoAccion b
			on b.RHTid = c.RHTid
			and b.Ecodigo = c.Ecodigo
			and b.RHTcomportam <> 2 <!--- valida que el comportamiento no sea cese--->
		inner join DLaboralesEmpleado d
				on d.Ecodigo = b.Ecodigo
				and d.DLlinea = c.DLlineaRef
		inner join RHTipoAccion e
			on e.RHTid = d.RHTid
			and e.Ecodigo = b.Ecodigo
			and e.RHTcomportam = 3	 <!--- Accion de vacaciones--->
	where b.Ecodigo = #Session.Ecodigo#
	and a.DEid = #Form.DEid#
	and a.RHCSanulado <> 1
	and a.RHCSsuspendido <> 1


</cfquery>


<cfquery  dbtype="query" name="rsListaAcciones">
	Select *
    from rsListaAccionesInfo
    order by F1 desc
</cfquery>




<cfinvoke
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaAcciones#"/>
	<cfinvokeargument name="desplegar" value="TipoAccion, DLobs, Fdesde, Fhasta"/>
	<cfinvokeargument name="etiquetas" value="#vTipoAccion#, #vDescripcion#, #vFechaRige#, #vFechaVence#"/>
	<cfinvokeargument name="formatos" value="V,V,D,D"/>
	<cfinvokeargument name="filtro" value=" "/>
	<cfinvokeargument name="align" value="left, left, center, center"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisAcciones.cfm"/>
	<cfinvokeargument name="formName" value="listaAcciones"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHSPEid, Fdesde, Fhasta, TipoAccion, DLobs, modificaLT"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>

</body>
</html>
