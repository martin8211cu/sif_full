<cfif not isdefined('session.tramites.id_ventanilla') or
      Len(session.tramites.id_ventanilla) EQ 0 >
	
	<!---<cfparam name="form.id_ventanilla" type="numeric">--->
	<!---<cfparam name="form.password"      type="string">--->
	
	<cfquery datasource="tramites_cr" name="buscar" maxrows="1">
		select p.id_persona, f.id_funcionario, f.id_inst, 
			v.id_ventanilla, s.id_sucursal
		from TPPersona p
			left join TPFuncionario f
				on p.id_persona = f.id_persona
		    left join TPRFuncionarioVentanilla rel
				on f.id_funcionario = rel.id_funcionario
				left join TPVentanilla v
					on v.id_ventanilla = rel.id_ventanilla
					left join TPSucursal s
						on s.id_sucursal = v.id_sucursal
		where p.identificacion_persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.datos_personales.id#">
	</cfquery>
	
	<cfset session.tramites = StructNew()>
	<cfif buscar.RecordCount EQ 1>
		<cfset session.tramites.id_persona  = buscar.id_persona >
		<cfset session.tramites.id_funcionario = buscar.id_funcionario>
		<cfset session.tramites.id_inst  = buscar.id_inst >
		<cfset session.tramites.id_sucursal  = buscar.id_sucursal >
		<cfset session.tramites.id_ventanilla  = buscar.id_ventanilla >
	<cfelse>
		<cfset session.tramites.id_persona  = "" >
		<cfset session.tramites.id_funcionario = "">
		<cfset session.tramites.id_inst  = "" >
		<cfset session.tramites.id_sucursal = "" >
		<cfset session.tramites.id_ventanilla  = "" >
	</cfif>
	
</cfif>
