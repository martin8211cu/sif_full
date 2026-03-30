<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<cfif isdefined("FORM.RHRSid") and len(trim(FORM.RHRSid)) eq 0><cfset FORM.RHRSid = "-1"></cfif>
<cfparam name="FORM.RHRSid" type="numeric" default="-1">
<cfquery name="rs_evaluacion_header" datasource="#session.DSN#">
	select RHRSdescripcion, RHRSinicio,RHRSfin
	from RHRelacionSeguimiento 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRSid#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConfiguracionDeSeguimiento"
	Default="Configuraci&oacute;n de Seguimiento"
	returnvariable="LB_RegistroDeLaRelacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Asignacion_De_Objetivos_Conocimientos"
	Default="Asignaci&oacute;n de Objetivos o Conocimientos"
	returnvariable="LB_Asignacion_De_Objetivos_Conocimientos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AsignacionDeEvaluadores"
	Default="Asignaci&oacute;n de Evaluadores"
	returnvariable="LB_AsignacionDeEvaluadores"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ProgresoDeRelaciones"
	Default="Progreso de Relaciones"
	returnvariable="LB_ProgresoDeEvaluaciones"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Relaciones_de_Seguimiento"
	Default="Relaciones de Seguimiento"
	returnvariable="LB_Evaluaciones_Generadas"/>


<cfswitch expression="#FORM.SEL#">
<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeLaRelacion></cfcase>
<cfcase value="2"><cfset SECTION.TITLE = LB_Asignacion_De_Objetivos_Conocimientos></cfcase>
<cfcase value="3"><cfset SECTION.TITLE = LB_AsignacionDeEvaluadores></cfcase>
<cfcase value="4"><cfset SECTION.TITLE = LB_Evaluaciones_Generadas></cfcase>
<cfcase value="5"><cfset SECTION.TITLE = LB_ProgresoDeEvaluaciones></cfcase>

</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion" valign="middle"><strong style="font-size:14px;" >#SECTION.TITLE#</strong></td>
  </tr>

  <cfif rs_evaluacion_header.RecordCount gt 0>
  <tr>
    <td></td>
	<td class="subtitulo_seccion" ><strong>
		#rs_evaluacion_header.RHRSdescripcion#&nbsp;<cf_translate key="LB_Vigencia">Vigencia</cf_translate>&nbsp;#LSDateFormat(rs_evaluacion_header.RHRSinicio,'dd/mm/yyyy')# &nbsp; - &nbsp;#LSDateFormat(rs_evaluacion_header.RHRSfin,'dd/mm/yyyy')#
		</strong>
	</td>
  </tr>
  </cfif>

</table>
</cfoutput>
