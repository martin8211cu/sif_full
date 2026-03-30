<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<cfif isdefined("FORM.RHEEID") and len(trim(FORM.RHEEID)) eq 0><cfset FORM.RHEEID = "-1"></cfif>
<cfparam name="FORM.RHEEID" type="numeric" default="-1">
<cfquery name="rs_evaluacion_header" datasource="#session.DSN#">
	select RHEEdescripcion, RHEEfdesde
	from RHEEvaluacionDes 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLaRelacion"
	Default="Registro de la Relaci&oacute;n"
	returnvariable="LB_RegistroDeLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AsignacionDeEmpleados"
	Default="Asignaci&oacute;n de Empleados"
	returnvariable="LB_AsignacionDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"
	returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AsignacionDeEvaluadores"
	Default="Asignaci&oacute;n de Evaluadores"
	returnvariable="LB_AsignacionDeEvaluadores"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluadores"
	Default="Lista de Evaluadores"
	returnvariable="LB_ListaDeEvaluadores"/>



<cfswitch expression="#FORM.SEL#">
<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeLaRelacion></cfcase>
<cfcase value="2"><cfset SECTION.TITLE = LB_AsignacionDeEmpleados></cfcase>
<cfcase value="3"><cfset SECTION.TITLE = LB_ListaDeEmpleados></cfcase>
<cfcase value="4"><cfset SECTION.TITLE = LB_AsignacionDeEvaluadores></cfcase>
<cfcase value="5"><cfset SECTION.TITLE = LB_ListaDeEvaluadores></cfcase>
</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion">#SECTION.TITLE#</td>
  </tr>
  <cfif rs_evaluacion_header.RecordCount gt 0>
  <tr>
    <td class="subtitulo_seccion_small" align="center">#rs_evaluacion_header.RHEEdescripcion#&nbsp;<cf_translate key="LB_Vigencia">Vigencia</cf_translate>&nbsp;#LSDateFormat(rs_evaluacion_header.RHEEfdesde,'dd/mm/yyyy')#</td>
  </tr>
  </cfif>
</table>
</cfoutput>
