<!---NUEVO Detalle--->
<cfif IsDefined("form.NuevoDet")>
	<cflocation url="SeguimientoFact_form.cfm?factura=#form.factura#&CPTcodigo=#form.CPTcodigo#&SNcodigo=#form.SNcodigo#" addtoken="no">
</cfif>

<!---ELIMINAR Detalle--->	
<cfif IsDefined("form.BajaDet")>
	<cfquery datasource="#session.dsn#" name="eliminarDetalle">
		delete from EventosFact where EVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVid#">					
	</cfquery>	
	<cflocation url="SeguimientoFact_form.cfm?documento=#form.documento#&factura=#form.factura#" addtoken="no">
</cfif>
	
<!---MODIFICAR Detalle--->
<cfif IsDefined("form.CambioDet")>
	<cfquery datasource="#session.dsn#" name="actualizar">
		update EventosFact set 
		<cfif isdefined("form.Estado") and len(trim(form.Estado))>
			EVestado			=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Estado#">, 
		</cfif>				
		EVObservacion	=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EVObservacion1#">,
		BMUsucodigo		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		BMfecha			=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		where EVid		=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EVid#">
	</cfquery>
		<cflocation url="SeguimientoFact_form.cfm?factura=#form.factura#&CPTcodigo=#form.CPTcodigo#&SNcodigo=#form.SNcodigo#&EVid=#form.EVid#" addtoken="no">
</cfif>
	
<!---AGREGAR Detalle--->
<cfif IsDefined("form.AltaDet")>
	<cftransaction>
			<cfquery name="rsEstado" datasource="#session.dsn#">
				select  FTidEstado 
				from EstadoFact 
				where FTcodigo = '4' <!---Aplicada--->
			</cfquery>
	
			<cfquery name="rsInsertaEvento" datasource="#session.dsn#">
				insert into EventosFact (Ecodigo,CPTcodigo,EVfactura,SNcodigo,EVestado,EVObservacion,BMUsucodigo,BMfecha)
					values(
						#Session.Ecodigo#,	
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPTcodigo#">,	
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.factura#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,
						<cfif isdefined("form.Estado") and len(trim(form.Estado))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Estado#">,	
						<cfelse>
							#rsEstado.FTidEstado#,	
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EVObservacion1#">,	
						#Session.Usucodigo#,
						<cf_dbfunction name="now">
						)
				<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsertaEvento" verificar_transaccion="false" returnvariable="EVid">
			
		<cfif isdefined("form.Estado") and len(trim(form.Estado))>
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxP
				set EVestado  	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Estado#">		
				where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				 and CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigo#">
				 and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
				 and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			</cfquery>
		
			<cfquery datasource="#session.DSN#" name="rsFolio">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and Pcodigo = 1400
					and Mcodigo = 'FA'
			</cfquery>
			
			<cfquery name="rsEstado" datasource="#Session.DSN#">
				select 
					FTfolio as folio
				from EstadoFact
				where FTidEstado = #form.estado#
			</cfquery>

			<cfif rsEstado.folio eq 1>	
				<cfinvoke component = "sif.Componentes.OriRefNextVal"
						 method   		  = "nextVal"
						 returnvariable  = "LvarSiguienteFolio"
						 ORI             = "CPFC"
						 REF             = "FOLIO"
					/>
					
				<cfquery name="rsVerificaFolio" datasource="#session.dsn#">
					select folio 
					from EDocumentosCxP 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigo#">
						and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
						and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
				</cfquery>
				
				<cfif #len(trim(rsVerificaFolio.folio))# eq 0> 
					<cfquery datasource="#session.DSN#">
						update EDocumentosCxP
						set folio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSiguienteFolio#">		
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CPTcodigo	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPTcodigo#">
							and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.factura#">
							and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
					</cfquery>
				</cfif>
			</cfif>
	</cfif>
</cftransaction>
	<cflocation url="SeguimientoFact_form.cfm?factura=#form.factura#&CPTcodigo=#form.CPTcodigo#&SNcodigo=#form.SNcodigo#" addtoken="no">
</cfif>
