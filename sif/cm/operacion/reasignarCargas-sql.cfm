<cfif isdefined("Procesar")>
	<cftransaction>
		<!--- Registrar en bitácora el movimiento --->
		<cfquery name="insBitacora" datasource="#Session.DSN#">
			insert into BMComprador (Ecodigo, CMCidorig, CMCidnuevo, BMCtipo, ESidsolicitud, BMCfecha, Usucodigo)
			select 
				Ecodigo, 
				CMCid, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.CMCid#">, 
				0, 
				ESidsolicitud, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from ESolicitudCompraCM
			where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		</cfquery>
		
		<!--- Actualizar el nuevo comprador en la solicitud --->
		<cfquery datasource="#session.DSN#">
			update ESolicitudCompraCM
			 set CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
			where ESidsolicitud in (#form.rb#) 
		</cfquery>
	</cftransaction>
</cfif>