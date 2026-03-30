<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfreturn true>
	</cffunction>

	<cffunction name="getInfoMovimientosBancarios" access="remote" returntype="struct">
		<cfargument name="idMovimientos" required="true" type="string">
		<cftry>
			<cfquery name="rsGetInfoMB" datasource="#Session.dsn#">
				SELECT * FROM EMovimientos
				WHERE EMid IN (#arguments.idMovimientos#)
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.ecodigo#">
			</cfquery>
			<cfset varDocumentos = "">
			<cfset total = 0>
			<cfloop query="#rsGetInfoMB#">
				<cfif varDocumentos EQ "">
					<cfset varDocumentos = "#TRIM(rsGetInfoMB.EMdocumento)# (#LSNumberFormat(rsGetInfoMB.EMtotal,',9.00')#)">
				<cfelse>
					<cfset varDocumentos = varDocumentos&",  #TRIM(rsGetInfoMB.EMdocumento)# (#LSNumberFormat(rsGetInfoMB.EMtotal,',9.00')#)">
				</cfif>
			</cfloop>
			<cfif rsGetInfoMB.RecordCount gt 0>
				<cfif rsGetInfoMB.RecordCount GT 1>
					<cfset mensaje = "¿Está seguro de aplicar los documentos: #varDocumentos#?">
				<cfelse>
					<cfset mensaje = "¿Está seguro de aplicar el documento: #varDocumentos#?">
				</cfif>
				<cfset Local.obj = {MSG='operacionOK', INFO=#mensaje#}>
			<cfelse>
				<cfset Local.obj = {MSG='No existe información para los movimientos bancarios!'}>
			</cfif>
			<cfcatch type="any">
				<cfif isDefined("cfcatch.detail")>
					<cfset msg = #cfcatch.detail#>
					<cfelse>
						<cfset msg = "">
					</cfif>
					<cfset Local.obj = {MSG='Ha ocurrido un error, intente más tarde. #msg#'}>
			</cfcatch>
		</cftry>
		<cfreturn  Local.obj>
	</cffunction>
</cfcomponent>