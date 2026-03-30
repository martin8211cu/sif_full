<link href="STYLE.CSS" rel="stylesheet" type="text/css">
<cfparam name="FORM.SEL" type="numeric">
<cfif isdefined("FORM.RHVPid") and len(trim(FORM.RHVPid)) eq 0><cfset FORM.RHVPid = "-1"></cfif>
<cfparam name="FORM.RHVPid" type="numeric" default="-1">
<cfquery name="rs_valoracion_header" datasource="#session.DSN#">
	select RHVPdescripcion, RHVPfdesde,RHVUsaPropuestos
	from RHValoracionPuesto 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.ECODIGO#">
	and RHVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHVPid#">
</cfquery>

<cfset VARUsaPropuestos = rs_valoracion_header.RHVUsaPropuestos>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLaValoracion"
	Default="Registro de la Valoraci&oacute;n"
	returnvariable="LB_RegistroDeLaValoracion"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Clasificacion_de_grados_por_puesto"
	Default="Clasificaci&oacute;n de grados por puesto"
	returnvariable="LB_Clasificacion_de_grados_por_puesto"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Equilibrio_Interno"
	Default="Equilibrio Interno"
	returnvariable="LB_Equilibrio_Interno"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Equilibrio_Externo"
	Default="Equilibrio Externo (Opcional) "
	returnvariable="LB_Equilibrio_Externo"/>    
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestosPropuestos"
	Default="Puestos Propuestos"
	returnvariable="LB_PuestosPropuestos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Analisis_comparativo"
	Default="An&aacute;lisis comparativo"
	returnvariable="LB_Analisis_comparativo"/>
    
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_Final"
	Default="Reporte Final"
	returnvariable="LB_Reporte_Final"/>

<cfswitch expression="#FORM.SEL#">
<cfcase value="1"><cfset SECTION.TITLE = LB_RegistroDeLaValoracion></cfcase>
<cfcase value="2"><cfset SECTION.TITLE = LB_Clasificacion_de_grados_por_puesto></cfcase>
<cfcase value="3"><cfset SECTION.TITLE = LB_Equilibrio_Interno></cfcase>
<cfcase value="4"><cfset SECTION.TITLE = LB_Equilibrio_Externo></cfcase>
<cfcase value="5"><cfset SECTION.TITLE = LB_Analisis_comparativo></cfcase>
<cfcase value="6"><cfset SECTION.TITLE = LB_Reporte_Final></cfcase>



</cfswitch>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="2" width="1%"><img src="/cfmx/rh/imagenes/number#FORM.SEL#_32.gif"></td>
	<td class="subtitulo_seccion">#SECTION.TITLE#</td>
  </tr>
  <cfif rs_valoracion_header.RecordCount gt 0>
  <tr>
    <td class="subtitulo_seccion_small" align="center">#rs_valoracion_header.RHVPdescripcion#&nbsp;<cf_translate key="LB_Vigencia">Vigencia</cf_translate>&nbsp;#LSDateFormat(rs_valoracion_header.RHVPfdesde,'dd/mm/yyyy')#</td>
  </tr>
  </cfif>
</table>
</cfoutput>
