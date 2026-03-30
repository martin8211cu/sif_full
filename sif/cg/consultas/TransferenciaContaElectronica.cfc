<!--- JMRV. Inicio. --->

<cfcomponent>

	<cffunction name="TraeContaElectronica" access="public" output="no">
		<cfargument name="Conexion"				type="string"  		required="yes">
		<cfargument name="IDcontable"			type="numeric"  	required="yes">
		<cfargument name="Ecodigo"				type="numeric"  	required="yes">
		<cfargument name="IDcontableOri"	type="numeric"  	required="yes">
		
		<cfset EmpresaOrigen = 15><!--- Para sifext, este es el Ecodigo de la empresa origen --->

		<cfquery datasource="#Arguments.Conexion#">
			update PolizasTransferidas 
				set IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontable#">, 
						Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
						fechaAplicacion = getdate()
			where EcodigoOri		= <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
			and 	IDcontableOri	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontableOri#">
		</cfquery>
		<cfquery name="rsTieneRepoOrigen" datasource="asp">
			select * from Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpresaOrigen#">
		</cfquery>
		<cfquery name="rsTieneRepositorio" datasource="asp">
			select * from Empresa where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfif isDefined("rsTieneRepositorio.ERepositorio") and #rsTieneRepositorio.ERepositorio# eq 1
		 and  isDefined("rsTieneRepoOrigen.ERepositorio")  and #rsTieneRepoOrigen.ERepositorio# eq 1>
			<cfquery datasource="#Arguments.Conexion#">
				insert into CERepositorio	(	IdContable,
																		IdDocumento,
																		numDocumento,
																		origen,
																		linea,
																		timbre,
																		rfc,
																		total,
																		archivoXML,
																		archivo,
																		nombreArchivo,
																		extension,
																		xmlTimbrado,
																		Ecodigo,
																		BMUsucodigo)
																		
														select	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontable#"> as IdContable,
																		ce.IdDocumento,
																		ce.numDocumento,
																		ce.origen,
																		ce.linea,
																		ce.timbre,
																		ce.rfc,
																		ce.total,
																		ce.archivoXML,
																		ce.archivo,
																		ce.nombreArchivo,
																		ce.extension,
																		ce.xmlTimbrado,
																		<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
																		ce.BMUsucodigo	

															from 	CERepositorio ce
															where ce.Ecodigo = 15
															and 	ce.IdContable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontableOri#">
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				insert into CEInfoBancariaSAT (	IDcontable,
																				Dlinea,
																				TESDPid,
																				TESOPid,
																				TESTMPtipo,
																				IBSATdocumento,
																				ClaveSAT,
																				CBcodigo,
																				TESOPfechaPago,
																				TESOPtotalPago,
																				IBSATbeneficiario,
																				IBSATRFC,
																				IBSAClaveSATtran,
																				IBSATctadestinotran)
			
															select		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontable#"> as IDcontable,
																				ce.Dlinea,
																				ce.TESDPid,
																				ce.TESOPid,
																				ce.TESTMPtipo,
																				ce.IBSATdocumento,
																				ce.ClaveSAT,
																				ce.CBcodigo,
																				ce.TESOPfechaPago,
																				ce.TESOPtotalPago,
																				ce.IBSATbeneficiario,
																				ce.IBSATRFC,
																				ce.IBSAClaveSATtran,
																				ce.IBSATctadestinotran

																from 		CEInfoBancariaSAT ce
																where ce.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.IDcontableOri#">
			</cfquery>
		</cfif><!--- Las empresas tienen contabilidad electronica --->
	</cffunction>
</cfcomponent>

<!--- JMRV. Fin. --->