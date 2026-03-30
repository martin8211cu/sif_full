﻿<!--- VARIABLES DE TRADUCCION --->
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
	Key="LB_Aprobacion"
	Default="Aprobaci&oacute;n"
	returnvariable="LB_Aprobacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Vigencia"
	Default="Vigencia"
	returnvariable="LB_Vigencia"/>
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<cfif isdefined("FORM.RHRCid") and len(trim(FORM.RHRCid)) eq 0><cfset FORM.RHRCid = "-1"></cfif>
<cfparam name="FORM.RHRCid" type="numeric" default="-1">
<cfquery name="rs_evaluacion_header" datasource="#session.DSN#">
	select RHRCdescripcion, RHRCfecha
	from RHRelacionCap 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
</cfquery>
<cfswitch expression="#FORM.SEL#">
<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeLaRelacion></cfcase>
<cfcase value="2"><cfset SECTION.TITLE = LB_AsignacionDeEmpleados></cfcase>
<cfcase value="3"><cfset SECTION.TITLE = LB_ListaDeEmpleados></cfcase>
<cfcase value="4"><cfset SECTION.TITLE = LB_Aprobacion></cfcase>
</cfswitch>
<cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
			<td class="subtitulo_seccion">#SECTION.TITLE#</td>
		</tr>
		<cfif rs_evaluacion_header.RecordCount gt 0>
			<tr>
				<td class="subtitulo_seccion_small" align="center">
					#rs_evaluacion_header.RHRCdescripcion#&nbsp;#LB_Vigencia#&nbsp;#LSDateFormat(rs_evaluacion_header.RHRCfecha,'dd/mm/yyyy')#
				</td>
			</tr>
		</cfif>
	</table>
</cfoutput>
