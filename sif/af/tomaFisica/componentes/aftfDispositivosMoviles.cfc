<cfcomponent>
	<cffunction name="getDispositivoById" access="public" returntype="query">
		<cfargument name="AFTFid_dispositivo" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_dispositivo, a.AFTFcodigo_dispositivo, a.AFTFnombre_dispositivo, 
				a.AFTFserie_dispositivo, a.AFTFestatus_dispositivo, 
				case coalesce((select min(1) from AFTFHojaConteo b where b.AFTFid_dispositivo = a.AFTFid_dispositivo and b.AFTFestatus_hoja < 3),0)
				when 0 then 1 else 0 end as AFTFinactivar_permitido, ts_rversion
			from AFTFDispositivo a
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and a.AFTFid_dispositivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AFTFid_dispositivo#">
		</cfquery>
		<cfif rs.recordCount neq 1>
			<cf_errorCode	code = "50815" msg = "No se pudo obtener el Dispositvo Móvil, ¡Proceso Cancelado!.">>
		</cfif>
		<cfreturn rs>
	</cffunction>
	<cffunction name="insertDispositivo" access="public" returntype="numeric">
		<cfargument name="AFTFcodigo_dispositivo" type="string" required="yes">
		<cfargument name="AFTFnombre_dispositivo" type="string" required="yes">
		<cfargument name="AFTFserie_dispositivo" type="string" required="yes">
		<cfargument name="AFTFestatus_dispositivo" type="string" required="yes">
		<cftransaction>
			<cfquery name="rs" datasource="#session.dsn#">
				insert into AFTFDispositivo (AFTFcodigo_dispositivo, AFTFnombre_dispositivo, AFTFserie_dispositivo, AFTFestatus_dispositivo, 
					CEcodigo, AFTFfalta, BMUsucodigo)
				values(
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AFTFcodigo_dispositivo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFnombre_dispositivo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFserie_dispositivo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AFTFestatus_dispositivo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
				<cf_dbidentity1>
			</cfquery>
			<cf_dbidentity2 name="rs">
		</cftransaction>
		<cfreturn rs.identity>
	</cffunction>
	<cffunction name="updateDispositivoById" access="public" returntype="string">
		<cfargument name="AFTFid_dispositivo" type="string" required="yes">
		<cfargument name="AFTFcodigo_dispositivo" type="string" required="no" default="">
		<cfargument name="AFTFnombre_dispositivo" type="string" required="no" default="">
		<cfargument name="AFTFserie_dispositivo" type="string" required="no" default="">
		<cfargument name="AFTFestatus_dispositivo" type="string" required="no" default="">
		<cfif len(trim(Arguments.AFTFestatus_dispositivo)) and Arguments.AFTFestatus_dispositivo eq 0>
			<cfquery name="rs" datasource="#session.dsn#">
				select a.AFTFid_dispositivo, a.AFTFcodigo_dispositivo
				from AFTFDispositivo a
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				and <cf_whereinlist column="a.AFTFid_dispositivo" valuelist="#Arguments.AFTFid_dispositivo#">
				and (select count(1) from AFTFHojaConteo b where b.AFTFid_dispositivo = a.AFTFid_dispositivo and b.AFTFestatus_hoja < 3)> 0
			</cfquery>
			<cfif rs.recordcount gt 0>
				<cf_errorCode	code = "50816"
								msg  = "El(Los) dispositvo(s) móvil(es): @errorDat_1@, se encuentra(n) en Hojas de Conteo Activas, ¡Proceso Cancelado!."
								errorDat_1="#ValueList(rs.AFTFcodigo_dispositivo)#"
				>>
			</cfif>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update AFTFDispositivo
			set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				<cfif len(trim(Arguments.AFTFcodigo_dispositivo))>, AFTFcodigo_dispositivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AFTFcodigo_dispositivo#"></cfif>
				<cfif len(trim(Arguments.AFTFnombre_dispositivo))>, AFTFnombre_dispositivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFnombre_dispositivo#"></cfif>
				<cfif len(trim(Arguments.AFTFserie_dispositivo))>, AFTFserie_dispositivo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AFTFserie_dispositivo#"></cfif>
				<cfif len(trim(Arguments.AFTFestatus_dispositivo))>, AFTFestatus_dispositivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AFTFestatus_dispositivo#"></cfif>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and <cf_whereinlist column="AFTFid_dispositivo" valuelist="#Arguments.AFTFid_dispositivo#">
		</cfquery>
		<cfreturn Arguments.AFTFid_dispositivo>
	</cffunction>
	<cffunction name="deleteDispositivoById" access="public" returntype="string">
		<cfargument name="AFTFid_dispositivo" type="string" required="yes">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.AFTFid_dispositivo, a.AFTFcodigo_dispositivo
			from AFTFDispositivo a
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and <cf_whereinlist column="a.AFTFid_dispositivo" valuelist="#Arguments.AFTFid_dispositivo#">
			and (select count(1) from AFTFHojaConteo b where b.AFTFid_dispositivo = a.AFTFid_dispositivo) > 0
		</cfquery>
		<cfif rs.recordcount gt 0>
			<cf_errorCode	code = "50816"
							msg  = "El(Los) dispositvo(s) móvil(es): @errorDat_1@, se encuentra(n) en Hojas de Conteo Activas, ¡Proceso Cancelado!."
							errorDat_1="#ValueList(rs.AFTFcodigo_dispositivo)#"
			>>
		</cfif>
		<cfquery datasource="#session.dsn#">
			delete from AFTFDispositivo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and <cf_whereinlist column="AFTFid_dispositivo" valuelist="#Arguments.AFTFid_dispositivo#">
		</cfquery>
		<cfreturn Arguments.AFTFid_dispositivo>
	</cffunction>
</cfcomponent>

