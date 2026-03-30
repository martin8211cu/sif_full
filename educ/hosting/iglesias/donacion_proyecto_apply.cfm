
<cfif not isdefined("form.Nuevo")>
	<!---
		Reglas:
			- No se puede borrar un proyecto que tenga compromisos asociados.
			- No se puede borrar un proyecto que tenga donaciones asociadas.
	<cftry>
	--->
	<cfquery datasource="#session.dsn#" name="rsMEDProyecto">
		<cfif isdefined("form.Alta")>
			
			insert MEDProyecto (METSid, Ecodigo, MEDnombre, MEDinicio, MEDfinal, MEDprioridad, MEDmoneda, MEDmeta)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.METSid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDnombre)#">,
				convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDinicio#">,103),
				<cfif isdefined("form.MEDfinal") and len(trim(form.MEDfinal)) gt 0>convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfinal#">,103)<cfelse>null</cfif>, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDprioridad#">,				
				<cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDmeta#">
			)
			
		<cfelseif isdefined("form.Cambio") and isdefined("form.MEDproyecto") and len(trim(form.MEDproyecto)) gt 0>
			
			Update MEDProyecto 
			set MEDnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.MEDnombre)#">, 
				MEDinicio = convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDinicio#">,103),
				MEDfinal = <cfif isdefined("form.MEDfinal") and len(trim(form.MEDfinal)) gt 0>convert(datetime,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MEDfinal#">,103)<cfelse>null</cfif>, 
				MEDprioridad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MEDprioridad#">, 
				MEDmoneda = <cfqueryparam cfsqltype="cf_sql_char"    value="#Trim(form.MEDmoneda)#">, 
				MEDmeta = <cfqueryparam cfsqltype="cf_sql_money"   value="#form.MEDmeta#">
			where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
			
			select MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
			
		<cfelseif isdefined("form.Baja") and isdefined("form.MEDproyecto") and len(trim(form.MEDproyecto)) gt 0>
			
			if not exists (	select 1 from MEDDonacion where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#"> )
			begin
				if not exists ( select 1 from MEDCompromiso where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#"> )
					Delete MEDProyecto 
					where MEDproyecto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEDproyecto#">
				else
					raiserror 40000 'Error borrando registro de MEDProyecto. No se puede borrar el registro porque tiene compromisos asociados.'
			end
			else
				raiserror 40000 'Error borrando registro de MEDProyecto. No se puede borrar el registro porque tiene donaciones asociadas.'
			
		</cfif>
	</cfquery>
	<!---
	<cfcatch>
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cfif>
<cfset params = "">
<cfif isdefined("rsMEDProyecto.MEDproyecto") and len(trim(rsMEDProyecto.MEDproyecto))>
	<cfset params = iif(len(trim(params)) gt 0, DE("&"), DE("?")) & "MEDproyecto=" & rsMEDProyecto.MEDproyecto>
</cfif>
<cflocation url="donacion_proyecto.cfm#params#">