<!---NUEVO Estado--->
	<cfif IsDefined("form.Nuevo")>
		<cflocation url="EstadoFac.cfm?Nuevo">
	</cfif>

	<cfif isdefined("form.FTfolio")>
		<cfquery name="rsEs" datasource="#session.dsn#">
			select 1 as cantidad 
				from EstadoFact
			where Ecodigo = #session.Ecodigo#
			and FTfolio = 1
		</cfquery>
	</cfif>
	
	<cfif isdefined("Form.Cambio")>
		<cfquery name="rsEs2" datasource="#session.dsn#">
			select 1 as cantidad 
				from EstadoFact
			where Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfset cant = #rsEs2.cantidad#>
	</cfif>
	
	<cfif isdefined("Form.Alta")>
		<cfif isdefined('form.FTfolio') and #rsEs.cantidad# GT 0>
			<cfquery name="rsUpdateOmision" datasource="#session.DSN#">
				update EstadoFact
					set FTfolio = 0
				where Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfif>

		<cfquery name="rsConsulta" datasource="#session.DSN#">
			select 
				FTcodigo 
			from EstadoFact
			where Ecodigo = #session.Ecodigo#
			and FTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FTcodigo#">
		</cfquery>
			
		<cfif rsConsulta.RecordCount LTE 0>
			<cftransaction>
				<cfquery name="insertEstado" datasource="#session.dsn#">
					insert into EstadoFact (FTcodigo,FTdescripcion ,FTPvalorAutomatico, FTfolio, BMfecha , BMUsucodigo ,Ecodigo)
						values(
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.FTcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.FTdescripcion#">,
							<cfif isdefined("form.FTPvalorAutomatico") and len(trim(form.FTPvalorAutomatico))>#form.FTPvalorAutomatico#<cfelse>0</cfif>,
							<cfif isdefined("form.FTfolio")>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
							)
					<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insertEstado" verificar_transaccion="false" returnvariable="FTidEstado">
			</cftransaction>
		<cfelse>
			<cf_errorCode	code = "50160" msg = "El Código que desea insertar ya existe.">
		</cfif>	
		<cflocation url="EstadoFac.cfm?FTidEstado=#FTidEstado#" addtoken="no">
		
	<cfelseif isdefined("Form.Baja") or isdefined ("btnEliminar")>
		<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from EstadoFact
				where Ecodigo = #session.Ecodigo#
				  and FTidEstado in (#form.chk#)
			</cfquery>	
		<cfelseif isdefined("form.FTidEstado") and len(trim(form.FTidEstado)) GT 0>
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from EstadoFact
				where Ecodigo = #session.Ecodigo#
					and FTidEstado  = #form.FTidEstado#
			</cfquery>	
		</cfif>
		<cflocation url="EstadoFac.cfm" addtoken="no">	
	<cfelseif isdefined("Form.Cambio")>
		<cfif #cant# GT 0>
			<cfquery name="rsUpdateOmision" datasource="#session.DSN#">
				update EstadoFact
					set FTfolio = 0
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update EstadoFact
					set 
					FTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.FTcodigo#">,
					FTdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FTdescripcion#">,
					FTfolio  	= <cfif isdefined("form.FTfolio") and len(trim(form.FTfolio))> 1 <cfelse> 0 </cfif>, 
					BMfecha =     <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and FTidEstado 	= #form.FTidEstado#
			</cfquery>
		</cfif>	
	<cflocation url="EstadoFac.cfm?FTidEstado=#form.FTidEstado#&pagenum3=#form.Pagina3#">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="EstadoFac.cfm?FTidEstado=#form.FTidEstado#" addtoken="no">


