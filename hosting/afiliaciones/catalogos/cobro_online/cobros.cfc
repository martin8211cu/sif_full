<cfcomponent>

<cffunction name="generar_documentos_de_cobro">
	<cfquery datasource="#session.dsn#" name="afiliaciones">
		select a.id_persona, a.id_programa, a.id_vigencia,
			v.tipo_periodo, v.periodicidad, a.costo, a.moneda,
			( select max (fecha_cobro)
			  from sa_cobros x
				where x.id_persona  = a.id_persona
				  and x.id_programa = a.id_programa
				  and x.id_vigencia = a.id_vigencia ) as ultimo_cobro
		from sa_afiliaciones a
			join sa_vigencia v
				on a.id_programa = v.id_programa
				and a.id_vigencia = v.id_vigencia
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and v.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and a.fecha_hasta > getdate()
		  and not exists (
		  	select *
			from sa_cobros c
			where c.id_persona  = a.id_persona
			  and c.id_programa = a.id_programa
			  and c.id_vigencia = a.id_vigencia
			  and (c.fecha_cobro > getdate() or v.tipo_periodo = 'U' ) )
	</cfquery>
	
	<cfloop query="afiliaciones">
		<cfset la_periodicidad = afiliaciones.periodicidad>
		<cfif la_periodicidad is 0>
			<cfset la_periodicidad = 1></cfif>
		<cfif Len(afiliaciones.ultimo_cobro) is 0 Or afiliaciones.tipo_periodo Is 'U'>
			<cfset fecha_cobro = Now()>
		<cfelseif afiliaciones.tipo_periodo is 'S'>
			<cfset fecha_cobro = DateAdd('ww', la_periodicidad, afiliaciones.ultimo_cobro)>
		<cfelseif afiliaciones.tipo_periodo is 'M'>
			<cfset fecha_cobro = DateAdd('m', la_periodicidad, afiliaciones.ultimo_cobro)>
		<cfelse>
			<cfset fecha_cobro = Now()>
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert into sa_cobros (
				id_persona, id_programa, id_vigencia,
				fecha_cobro, importe, moneda,
				CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#afiliaciones.id_persona#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#afiliaciones.id_programa#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#afiliaciones.id_vigencia#">,

				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_cobro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#afiliaciones.costo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#afiliaciones.moneda#">,
		
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
		</cfquery>
	</cfloop>

</cffunction>

</cfcomponent>