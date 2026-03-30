<cfcomponent hint="Ver SACI-03-H042.doc" extends="base">
	<cffunction name="sincronizaPaquetes" access="public" returntype="void">
		<cfargument name="PQcodigo" type="string" required="yes">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="TipoEvento" type="string" required="yes">
		<cfargument name="CINCAT" type="string" required="yes" default="O">
		<cfargument name="updateCINCAT" type="boolean" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H042', Arguments.PQcodigo )>
		<cftry>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="ISBpaquete">
				select PQnombre, TRANUC, PQtarifaBasica, PQhorasBasica, PQhorasBasica,
				 PQprecioExc, PQtransaccion, CINCAT, PQadelanto, isnull(PQagrupa,2) PQagrupa,
				 isnull(MRcodigoInterfaz,'N') as MRcodigoInterfaz, PQfileconfigura,
				 PQmaxSession
				from ISBpaquete pq
					left join ISBmayoristaRed mred
					on pq.MRidMayorista = mred.MRidMayorista
				where PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PQcodigo#">
			</cfquery>
			<cfif ISBpaquete.RecordCount is 0 and not Arguments.TipoEvento is 'delete' >
				<cfthrow message="El paquete no existe" errorcode="ISB-0013">
			</cfif>
			
			<cfquery datasource="SACISIIC" name="buscatranuc">
				Select * from SSMTRA
				Where TRANUC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.TRANUC#">				
			</cfquery>
				
			<cfif buscatranuc.RecordCount eq 0>
				<cfthrow message="El TRANUC= #ISBpaquete.TRANUC# no existe en la tabla SSMTRA">
			</cfif>
			<cfif Arguments.TipoEvento is 'insert' And Len(ISBpaquete.PQmaxSession) Is 0>			
				<cfset control_servicio( 'acceso' )>
				<!--- Invocar el componente de CISCO --->
				<cfinvoke component="CiscoService" method="createPackage"
					grupo="#ISBpaquete.PQnombre#"
					clave="#ISBpaquete.PQnombre#"
					PQfileconfigura="#ISBpaquete.PQfileconfigura#" />
			</cfif>
			<cfif Len(ISBpaquete.CINCAT) is 0 and  Arguments.TipoEvento is 'update' >
				<cfset control_mensaje( 'ISB-0028', 'El paquete #ISBpaquete.PQcodigo#-#ISBpaquete.PQnombre# no tiene CINCAT.  No se podrá reportar al SIIC' )>
			<cfelse>
				<cfset control_servicio( 'siic' )>
				<!--- Notificación a SIIC de la inclusión del paquete --->
				<cfif Arguments.TipoEvento is 'insert'>
					
							
					
					<cfquery datasource="SACISIIC" name="Alta">
						if not exists (select 1 from SSXCIN
							where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.CINCAT#">) 					
						exec sp_Alta_SSXCIN 
							@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.CINCAT#">,
							@SEVCOD = '09',
							@CINDES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQnombre#">,
							@TRANUC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.TRANUC#">,
							@CINCMI = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQtarifaBasica#">,
							@CINCAH = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQhorasBasica#">,
							@CINHCM = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQtarifaBasica#">,
							@CINECM = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQprecioExc#">,	
							@CINTCD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQtransaccion#">,
							@CINAPA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQadelanto#">,
							@CINTIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.PQagrupa#">,
							@CINCAB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.MRcodigoInterfaz#">
							
					
					</cfquery>
					
					<cfquery datasource="SACISIIC" name="max_cincat">
					 select isnull(max(CINCAT), 0) as CINCAT
    				 from SSXCIN 
					</cfquery>
					 
					<cfif Not Len(max_cincat.CINCAT)>
						<cfthrow message="sp_Alta_SSXCIN - CINCAT no es válido">
					</cfif>	
					<cfquery datasource="#session.dsn#">
						Update ISBpaquete Set CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#max_cincat.CINCAT#">
						Where PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PQcodigo#">	
					</cfquery>
					
				<cfelseif Arguments.TipoEvento is 'update' and (Not Arguments.updateCINCAT)>
					<!--- Modo Cambio --->
					<cfquery datasource="SACISIIC">				
						declare @ts timestamp
						select @ts = timestamp
						from SSXCIN where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.CINCAT#">
						exec sp_Cambio_SSXCIN 
						@CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.CINCAT#">,
						@SEVCOD = '09',
						@CINDES = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQnombre#">,
						@TRANUC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.TRANUC#">,
						@CINCMI = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQtarifaBasica#">,
						@CINCAH = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQhorasBasica#">,
						@CINHCM = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQtarifaBasica#">,
						@CINECM = <cfqueryparam cfsqltype="cf_sql_float" value="#ISBpaquete.PQprecioExc#">,
						@CINTCD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQtransaccion#">,
						@CINAPA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQadelanto#">,
						@CINTIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBpaquete.PQagrupa#">,
						@CINCAB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.MRcodigoInterfaz#">,
						@timestamp = @ts
					</cfquery>
				
				</cfif>								
		
					<cfif Not Arguments.updateCINCAT>
						<cfquery datasource="SACISIIC">
							exec sp_Alta_SSXS01
								@S01ACC = 'S',
								@S01VA1 = 'SSXCIN',
							<cfif Arguments.TipoEvento is 'insert'>
								@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#max_cincat.CINCAT#*A">
							<cfelseif Arguments.TipoEvento is 'update'>
								@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.CINCAT#*C">
							<cfelse> 
								@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CINCAT#*B">
							</cfif>
						</cfquery>
					</cfif>
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>		
		</cfcatch>
		</cftry>		
		
	</cffunction>
</cfcomponent>