<cfif isdefined('form.ALTA')>
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PTurnos 
			where PTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codTurno#">
	</cfquery>
	<cfif rsExiste.existe>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El código de turno digitado ya existe. Digite otro código.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.turnos"
			method="ALTA"
			PTcodigo="#form.codTurno#"
			PThoraini="#form.hInicial#"
			PThorafin="#form.hFinal#"
			Ecodigo="#form.Ecodigo#"
			MBUsucodigo="#form.MBUsucodigo#"
			returnvariable="LvarId"
		/>
		<cflocation url="turnos.cfm?modo=CAMBIO&PTid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PTurnos"
		redirect="turnos.cfm?modo=CAMBIO&PTid=#form.PTid#"
		timestamp="#form.ts_rversion#"
		field1="PTid" 
		type1="numeric" 
		value1="#form.PTid#"
		field2="Ecodigo" 
		type2="numeric" 
		value2="#form.Ecodigo#">
	<cfquery name="rsExiste" datasource="#session.dsn#">
		select count(1) as existe from PTurnos 
			where PTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codTurno#">
			and PTid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PTid#">
	</cfquery>
	<cfif rsExiste.existe>
		<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			alert("El código de turno digitado ya existe. Digite otro código.");
			history.back(-1);
		</script>
		</cfoutput>
	<cfelse>
		<cfinvoke component="conavi.Componentes.turnos"
			method="CAMBIO"
			PTid="#form.PTid#"
			PTcodigo="#form.codTurno#"
			PThoraini="#form.hInicial#"
			PThorafin="#form.hFinal#"
			Ecodigo="#form.Ecodigo#"
			MBUsucodigo="#form.MBUsucodigo#"
			returnvariable="LvarId"
		/>
		<cflocation url="turnos.cfm?modo=CAMBIO&PTid=#LvarId#">
	</cfif>
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="conavi.Componentes.turnos"
		method="BAJA"
		PTid="#form.PTid#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="turnos.cfm?modo=ALTA">
<cfelse>
	<cflocation url="turnos.cfm?modo=ALTA">
</cfif>