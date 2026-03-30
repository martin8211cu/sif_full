<cfsavecontent variable="WhereDEid">
	DEid in (
		<cfif isdefined("form.DEid1") and len(trim(form.DEid1))>
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.DEid1#">
		<cfelse>	
			select DEid from DatosEmpleado where Ecodigo=<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  	</cfif>
	  	)
</cfsavecontent>

<cfset estado=0><!---- Abrir---->
<cfif isDefined("btnCerrar")>
	<cfset estado=1><!---- cerrar ---->
</cfif>
 
<cfif isdefined("form.tipo") and (form.tipo eq 1 or form.tipo eq 0)><!---- habilidades---->
	<cfquery datasource="#session.DSN#">
		update RHCompetenciasEmpleado
		set RHCestado = #estado#
		where #preserveSingleQuotes(WhereDEid)# and tipo = 'H'
	</cfquery>
</cfif>	
<cfif isdefined("form.tipo") and (form.tipo eq 2 or form.tipo eq 0)><!----conocimientos--->
	<cfquery datasource="#session.DSN#">
		update RHCompetenciasEmpleado
		set RHCestado = #estado#
		where #preserveSingleQuotes(WhereDEid)# and tipo = 'C'
	</cfquery>
</cfif>	
<cfif isdefined("form.tipo") and (form.tipo eq 3 or form.tipo eq 0)><!----Experiencia--->
	<cfquery datasource="#session.DSN#">
		update RHExperienciaEmpleado
		set RHEEestado = #estado#
		where #preserveSingleQuotes(WhereDEid)#
	</cfquery>
</cfif>
<cfif isdefined("form.tipo") and (form.tipo eq 4 or form.tipo eq 0)><!-----Estudios realizado---->
	<cfquery datasource="#session.DSN#">
		update RHEducacionEmpleado
		set RHEestado = #estado#
		where #preserveSingleQuotes(WhereDEid)#
	</cfquery>
</cfif>
<cfif isdefined("form.tipo") and (form.tipo eq 5 or form.tipo eq 0)><!--- Publicaciones---->
	<cfquery datasource="#session.DSN#">
		update RHPublicaciones
		set RHPEstado = #estado#
		where #preserveSingleQuotes(WhereDEid)#
	</cfquery>
</cfif>
<cfif isdefined("form.tipo") and (form.tipo eq 6 or form.tipo eq 0)><!---- Idiomas----->
	<cfquery datasource="#session.DSN#">
		update DatosOferentes
		set RHOidiomaAprobado = #estado#
		where 	#preserveSingleQuotes(WhereDEid)#
	</cfquery>
</cfif>
 
<div class="row">
  <div class="col-lg-12">
    <div class="alert alert-dismissable alert-success text-center">
      <button type="button" class="close" data-dismiss="alert">×</button>
      <cf_translate key="MSG_ElProcesoSeEjecutoCorrectamente"><cf_translate key="MSG_ProcesoExitoso" xmlFile="/rh/generales.xml">¡El proceso se ejecutó correctamente!</cf_translate></cf_translate>
    </div>
  </div>
</div>
