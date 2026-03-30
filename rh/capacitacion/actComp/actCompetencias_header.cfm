<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnProceso"
	Default="En Proceso"
	returnvariable="LB_EnProceso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilitada"
	Default="Habilitada"
	returnvariable="LB_Habilitada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrada"
	Default="Cerrada"
	returnvariable="LB_Cerrada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aplicada"
	Default="Aplicada"
	returnvariable="LB_Aplicada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeRelacionDeCalificacion"
	Default="Registro de Relaci&oacute;n de Calificaci&oacute;n"
	returnvariable="LB_RegistroDeRelacionDeCalificacion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccionDeEvaluadores"
	Default="Selecci&oacute;n de Evaluadores"
	returnvariable="LB_SeleccionDeEvaluadores"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEvaluadores"
	Default="Lista de Evaluadores"
	returnvariable="LB_ListaDeEvaluadores"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AsignacionDeCentrosFuncionales"
	Default="Asignaci&oacute;n de Centros Funcionales"
	returnvariable="LB_AsignacionDeCentrosFuncionales"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"
	returnvariable="LB_ListaDeEmpleados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FinalizarRegistroDeRelacionDeCalificacion"
	Default="Finalizar Registro de Relaci&oacute;n de Calificaci&oacute;n"
	returnvariable="LB_FinalizarRegistroDeRelacionDeCalificacion"/>	
	
<!--- FIN VARIABLES DE TRADUCCION --->
<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<!--- <cfif isdefined("FORM.RHRCid") and len(trim(FORM.RHRCid)) eq 0><cfset FORM.RHRCid = "-1"></cfif>
<cfparam name="FORM.RHRCid" type="numeric" default="-1"> --->
<cfquery name="rs_actCompetencias_header" datasource="#session.DSN#">
	Select 
		RHRCid, 
		RHRCdesc,
		RHRCfdesde,
		RHRCfhasta,
		case RHRCitems
			when 'A' then '#LB_Habilidades#'
			when 'H' then '#LB_Conocimientos#'
			when 'C' then '#LB_Ambos#'
		end RHRCitems
		,case RHRCestado
			when 0 then '#LB_EnProceso#'
			when 10 then '#LB_Habilitada#'
			when 20 then '#LB_Cerrada#'
			when 30 then '#LB_Aplicada#'
		end RHRCestado
	from RHRelacionCalificacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("FORM.RHRCid") and len(trim(FORM.RHRCid)) NEQ 0 and form.RHRCid NEQ ''>
			and RHRCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
		</cfif>
</cfquery>
<cfswitch expression="#FORM.SEL#">
<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeRelacionDeCalificacion></cfcase>
<cfcase value="2"><cfset SECTION.TITLE = LB_SeleccionDeEvaluadores></cfcase>
<cfcase value="3"><cfset SECTION.TITLE = LB_ListaDeEvaluadores></cfcase>
<cfcase value="4"><cfset SECTION.TITLE = LB_AsignacionDeCentrosFuncionales></cfcase>
<cfcase value="5"><cfset SECTION.TITLE = LB_ListaDeEmpleados></cfcase>
<cfcase value="6"><cfset SECTION.TITLE = LB_FinalizarRegistroDeRelacionDeCalificacion></cfcase>
</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion">#SECTION.TITLE#</td>
  </tr>
  <cfif rs_actCompetencias_header.RecordCount gt 0>
  <tr>
    <td class="subtitulo_seccion_small" align="center">#rs_actCompetencias_header.RHRCdesc#&nbsp;Desde&nbsp;#LSDateFormat(rs_actCompetencias_header.RHRCfdesde,'dd/mm/yyyy')#&nbsp;Hasta&nbsp;#LSDateFormat(rs_actCompetencias_header.RHRCfhasta,'dd/mm/yyyy')#</td>
  </tr>
  </cfif>
</table>
</cfoutput>
