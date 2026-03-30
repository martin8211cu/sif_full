<cfif not isdefined("form.Nuevo")>
	<!---
		Reglas:
			- Activo: El Compromiso está activo mientras no se cese.
		
			- Sobre la Actualización de Compromisos que tengan Donaciones Asociadas:
				No se actualizar Compromisos que tengan Donaciones Asociadas
			 
			- Sobre el Borrado: 
				No se puede borrar Compromisos que tengan Donaciones Asociadas
				
			-Cese: Al cese de un compromiso se actualiza la fecha de cese y se pone inactivo
	<cftry>
	--->
	<cfquery datasource="#session.dsn#" name="rsMEDCompromiso">
		<cfif isdefined("form.Alta")>
			
			insert MEDCompromiso 
			(MEEid, MEDproyecto, MEDtipo_periodo, MEDperiodo, MEDimporte, MEDmoneda, MEDultima, MEDsiguiente, MEDfechaini, MEDfechafin, MEDactivo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtipo_periodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDperiodo#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDimporte#">,
				<cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">,
				null, 
				convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDsiguiente#">,103),
				getdate(),
				<cfif isdefined(form.MEDfechafin) and len(trim(form.MEDfechafin)) gt 0>convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfechafin#">,103)<cfelse>null</cfif>, 
				1
			)
			
		<cfelseif isdefined("form.Cambio") and isdefined("form.MEDcompromiso") and len(trim(form.MEDcompromiso)) gt 0>

			Update MEDCompromiso 
			set MEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEEid#">,
				MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">,
				MEDtipo_periodo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.MEDtipo_periodo#">,
				MEDperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDperiodo#">,
				MEDimporte = <cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDimporte#">,
				MEDmoneda = <cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">,
				MEDultima = null, 
				MEDsiguiente = convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDsiguiente#">,103),
				MEDfechaini = getdate(),
				MEDfechafin = <cfif isdefined(form.MEDfechafin) and len(trim(form.MEDfechafin)) gt 0>convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfechafin#">,103)<cfelse>null</cfif>, 
				MEDactivo = 1
			where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">

			select MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">
			
		<cfelseif isdefined("form.Baja") and isdefined("form.MEDcompromiso") and len(trim(form.MEDcompromiso)) gt 0>
			
			if not exists (	select 1 from MEDDonacion where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#"> )
			begin
				Delete MEDCompromiso
				where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">
			end
			else
				raiserror 40000 'Error borrando registro de MEDCompromiso. No se puede borrar el registro porque tiene compromisos asociadas.'
			
		<cfelseif isdefined("form.Cese") and isdefined("form.MEDcompromiso") and len(trim(form.MEDcompromiso)) gt 0>
			
			Update MEDCompromiso 
			set MEDsiguiente = null,
				MEDfechafin = getdate(),
				MEDactivo = 0
			where MEDcompromiso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDcompromiso#">
			
		</cfif>
	</cfquery>
	<!---
	<cfcatch>
		<cfinclude template="../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	--->
</cfif>
<cfset params = "">
<cfif isdefined("rsMEDCompromiso.MEDcompromiso") and len(trim(rsMEDCompromiso.MEDcompromiso))>
	<cfset params = iif(len(trim(params)) gt 0, DE("&"), DE("?")) & "MEDcompromiso=" & rsMEDCompromiso.MEDcompromiso>
</cfif>
<cflocation url="donacion_compromiso.cfm#params#">