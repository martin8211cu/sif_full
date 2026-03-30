<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfreturn true>
	</cffunction>

	<!--- Registro de semanas --->
	<cffunction name="insertSemana" access="remote" returntype="struct">
		<cfargument name="anio" required="false" type="string">
		<cfargument name="semana" required="false" type="string">
		<cfargument name="fechaInicio" required="false" type="string">
		<cfargument name="fechaFin" required="false" type="string">

		<cfquery name="rsValidaExiste" datasource="#Session.dsn#">
			SELECT * FROM CPSemanaPronostico
			WHERE Anio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.anio#">
			AND NoSemana = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.semana#">
			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsValidaExiste.RecordCount GT 0>
			<cfset Local.obj = {MSG='La semana #arguments.semana#, para el año #arguments.anio# ya existe.'}>
		<cfelse>
			<cftransaction>
				<cftry>
					<cfquery name="rsInsertSemana" datasource="#Session.dsn#">
						INSERT INTO CPSemanaPronostico (Ecodigo, Anio, NoSemana, FechaInicio, FechaFin)
						VALUES (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.anio#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.semana#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaInicio#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaFin#">
								)
					</cfquery>
					<cfset Local.obj = {MSG='InsertOK'}>
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<cfif isDefined("cfcatch.detail")>
							<cfset msg = #cfcatch.detail#>
						<cfelse>
							<cfset msg = "">
						</cfif>
						<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde. #msg#'}>
					</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>

		<cfreturn  Local.obj>
	</cffunction>

	<!--- Registro de semanas --->
	<cffunction name="updateSemana" access="remote" returntype="struct">
		<cfargument name="idSemana" required="false" type="string">
		<cfargument name="fechaInicio" required="false" type="string">
		<cfargument name="fechaFin" required="false" type="string">

		<cftransaction>
			<cftry>
				<cfquery name="rsInsertSemana" datasource="#Session.dsn#">
					UPDATE CPSemanaPronostico
					SET FechaInicio = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaInicio#">,
					    FechaFin = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fechaFin#">
					WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  AND IdSemana = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idSemana#">
				</cfquery>
				<cfset Local.obj = {MSG='updateOK'}>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfif isDefined("cfcatch.detail")>
						<cfset msg = #cfcatch.detail#>
					<cfelse>
						<cfset msg = "">
					</cfif>
					<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde. #msg#'}>
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn  Local.obj>
	</cffunction>

	<!--- Registro de semanas --->
	<cffunction name="deleteSemana" access="remote" returntype="struct">
		<cfargument name="idSemana" required="false" type="string">
		<cfargument name="fechaInicio" required="false" type="string">
		<cfargument name="fechaFin" required="false" type="string">

		<cftransaction>
			<cftry>
				<cfquery name="rsInsertSemana" datasource="#Session.dsn#">
					DELETE CPSemanaPronostico
					WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  AND IdSemana = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idSemana#">
				</cfquery>
				<cfset Local.obj = {MSG='deleteOK'}>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfif isDefined("cfcatch.detail")>
						<cfset msg = #cfcatch.detail#>
					<cfelse>
						<cfset msg = "">
					</cfif>
					<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde. #msg#'}>
				</cfcatch>
			</cftry>
		</cftransaction>
		<cfreturn  Local.obj>
	</cffunction>

</cfcomponent>