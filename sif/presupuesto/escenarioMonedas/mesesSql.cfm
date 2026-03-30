<cftransaction>
<cfif isdefined("form.AltaMes")>
	<cfquery name="select_cpmes" datasource="#session.dsn#">
		select 1
		from CPmeses
		where Ecodigo = #session.ecodigo#
			and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">
			and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">
	</cfquery>
	<cfif select_cpmes.RecordCount eq 0>
		<cfquery name="alta_cpmes" datasource="#session.dsn#">
			insert INTO CPmeses 
			(Ecodigo, CPCano, CPCmes)
			values (
				#session.ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">				
			)
		</cfquery>
	</cfif>
	<cfquery name="alta_mes" datasource="#session.dsn#">
		insert INTO CVTipoCambioEscenarioMes 
		(Ecodigo, CVTid, CPCano, CPCmes, Mcodigo, CPTipoCambioCompra, CPTipoCambioVenta)
		values (
			#session.ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.CPTipoCambioCompra#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#form.CPTipoCambioVenta#">
		)
	</cfquery>
	<cfif GDebug><h1>Alta Exitosa! CVTid = <cfoutput>#form.cvtid#</cfoutput></h1><br><cfquery name="rsdebug" datasource="#session.dsn#">select * from CVTipoCambioEscenarioMes where Ecodigo = #Session.Ecodigo#	and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#"></cfquery><cfdump var="#rsdebug#"></cfif>
	<cfset Form.CPCmes = "">
<cfelseif isdefined("form.CambioMes")>
	<cfquery name="cambio_mes" datasource="#session.dsn#">
		update CVTipoCambioEscenarioMes 
		set CPTipoCambioCompra = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CPTipoCambioCompra#">,
			CPTipoCambioVenta = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CPTipoCambioVenta#">
		where Ecodigo = #session.ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">
			and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">
			and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">
	</cfquery>
	<cfif GDebug><h1>Cambio Exitoso! CVTid = <cfoutput>#form.cvtid#</cfoutput></h1><br><cfquery name="rsdebug" datasource="#session.dsn#">select * from CVTipoCambioEscenarioMes where Ecodigo = #Session.Ecodigo#	and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#"></cfquery><cfdump var="#rsdebug#"></cfif>
	<cfset Form.CPCmes = "">
<cfelseif isdefined("form.BajaMes")>
	<cfquery name="baja_mes" datasource="#session.dsn#">
		delete from CVTipoCambioEscenarioMes 
		where Ecodigo = #session.ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">
			and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcano#">
			and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cpcmes#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">
	</cfquery>
	<cfset Form.CPCmes = "">
	<cfif GDebug><h1>Baja Exitosa!</cfif>
<cfelseif isdefined("form.btnProyectar")>
	<cfset LvarAno = form.cpcano>
	<cfset LvarMes = form.cpcmes>
	<cfset LvarCambioCompra = form.CPTipoCambioCompra>
	<cfset LvarCambioVenta = form.CPTipoCambioVenta>
	<cfloop index="i" from="1" to="#form.mesesProyeccion#">
		<cfset LvarMes = LvarMes + 1>
		<cfif form.tipoProyeccion EQ 1>
			<cfset LvarCambioCompra = LvarCambioCompra + form.montoProyeccion>
			<cfset LvarCambioVenta  = LvarCambioVenta + form.montoProyeccion>
		<cfelse>
			<cfset LvarCambioCompra = LvarCambioCompra * (1 + form.montoProyeccion/100)>
			<cfset LvarCambioVenta  = LvarCambioVenta  * (1 + form.montoProyeccion/100)>
		</cfif>
		<cfif LvarMes GT 12>
			<cfset LvarMes = 1>
			<cfset LvarAno = LvarAno + 1>
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from CVTipoCambioEscenarioMes 
			where Ecodigo = #session.ecodigo#
				and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">
				and CPCano = #LvarAno#
				and CPCmes = #LvarMes#
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">
		</cfquery>

		<cfif rsSQL.cantidad EQ 0>
			<cfquery name="select_cpmes" datasource="#session.dsn#">
				select 1
				from CPmeses
				where Ecodigo = #session.ecodigo#
					and CPCano = #LvarAno#
					and CPCmes = #LvarMes#
			</cfquery>
			<cfif select_cpmes.RecordCount eq 0>
				<cfquery name="alta_cpmes" datasource="#session.dsn#">
					insert INTO CPmeses 
					(Ecodigo, CPCano, CPCmes)
					values (
						#session.ecodigo#,
						#LvarAno#,
						#LvarMes#	
					)
				</cfquery>
			</cfif>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				insert INTO CVTipoCambioEscenarioMes 
					(Ecodigo, CVTid, CPCano, CPCmes, Mcodigo, CPTipoCambioCompra, CPTipoCambioVenta)
				values (
					#session.ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">,
					#LvarAno#,
					#LvarMes#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">,
					#LvarCambioCompra#,
					#LvarCambioVenta#
				)
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVTipoCambioEscenarioMes 
				set CPTipoCambioCompra = #LvarCambioCompra#,
					CPTipoCambioVenta = #LvarCambioVenta#
				where Ecodigo = #session.ecodigo#
					and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">
					and CPCano = #LvarAno#
					and CPCmes = #LvarMes#
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mcodigo#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
</cftransaction>