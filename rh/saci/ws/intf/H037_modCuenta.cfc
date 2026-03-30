<cfcomponent hint="Ver SACI-03-H037.doc" extends="base">
	<cffunction name="modificacionCuenta" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="SSCCOD" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="Yes">
		<cfargument name="SERIDS" type="string" required="Yes">
		
		<cfset control_inicio( Arguments, 'H037', 'CUECUE= ' & Arguments.CUECUE & ' SERIDS= ' & Arguments.SERIDS)>
		<cftry>
			
			<cfparam name="Arguments.SSCCOD" type="numeric">
			<cfparam name="Arguments.CUECUE" type="numeric">


			 <cfset fecha_date = CreateDateTime(Year(Now()), Month(Now()), Day(Now()),0,0,0)>
			
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="modificacionCuenta_Q">
				select CUECUE,SERIDS,SERCLA, case when VENCOD = 0 then 199 else VENCOD end as VENCOD
				from SSXSSC
				where SSCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SSCCOD#">
			</cfquery>

			
			<cfset LGnumero = getLGnumero(modificacionCuenta_Q.SERCLA)>
			<cfset pqinterfaz = getPQinterfaz(LGnumero)>
			<cfset ISBlogin = getISBlogin(LGnumero)>
			
			<cfquery datasource="#session.dsn#" name="rsAgente">
				select AAinterno
				from ISBagente
				where AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#modificacionCuenta_Q.VENCOD#">
			</cfquery>
			
			<cfif rsAgente.RecordCount is 0>
				<cfthrow message="No existe Agente con AGid = #modificacionCuenta_Q.VENCOD#" errorcode="SIC-0011">
			</cfif>
			
			<cfset control_servicio( 'saci' )>
			
				<cfif rsAgente.AAinterno is 1 and ISBlogin.LGprincipal>			
				
					<cfquery datasource="#session.dsn#" name="update_q">
						update ISBcuenta
						set CUECUE  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#modificacionCuenta_Q.CUECUE#">
						Where CTid = (Select cue.CTid
									From ISBproducto pro
										inner join ISBcuenta cue
										on pro.CTid = cue.CTid
										inner join ISBlogin lo
										on lo.Contratoid = pro.Contratoid 
										Where lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
										and CTtipoUso in ('U','A'))
						select @@rowcount as update_rowcount
					</cfquery>
					<cfif update_q.update_rowcount is 0>
						<cfset control_mensaje( 'ISB-0006', 'No existe Contrato ISBproducto con login #modificacionCuenta_Q.SERCLA#' )>
					</cfif>
					
					<cfquery datasource="#session.dsn#" name="rsContrato">
						Select pro.Contratoid
									From ISBproducto pro
										inner join ISBcuenta cue
										on pro.CTid = cue.CTid
										inner join ISBlogin lo
										on lo.Contratoid = pro.Contratoid 
										Where lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
										and CTtipoUso in ('U','A')
										and CTcondicion = '0'
					</cfquery>
					
					<cfif rsContrato.RecordCount is 0>
						<cfset control_mensaje( 'ISB-0006', 'El Contrato para el login #modificacionCuenta_Q.SERCLA# no existe.' )>
					</cfif> 				
					
					<cfquery datasource="#session.dsn#" name="update_q">
						update ISBproducto
						set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							CNfechaAprobacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_date#">,
							CTidFactura = CTid,
							CTcondicion = '1'
						where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.Contratoid#">
						select @@rowcount as update_rowcount
					</cfquery>
						<cfif update_q.update_rowcount is 0>
						<cfset control_mensaje( 'ISB-0006', 'ISBproducto con CTid #rsContrato.Contratoid#' )>
						</cfif>
					
					<cfquery datasource="#session.dsn#" name="update_lo">
						update ISBlogin
						set LGserids = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERIDS#">
						Where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
						select @@rowcount as update_rowcount
					</cfquery>
					<cfif update_lo.update_rowcount is 0>
						<cfset control_mensaje( 'ISB-0006', 'ISBlogin con SERCLA #modificacionCuenta_Q.SERCLA#' )>
					</cfif>
				</cfif>

				<cfif ISBlogin.LGprincipal>
					<cfquery datasource="#session.dsn#" name="update_q">
						update ISBcuenta
						set CUECUE  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#modificacionCuenta_Q.CUECUE#">
						Where CTid = (Select cue.CTid
									From ISBproducto pro
										inner join ISBcuenta cue
										on pro.CTid = cue.CTid
										inner join ISBlogin lo
										on lo.Contratoid = pro.Contratoid 
										Where lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
										and CTtipoUso in ('U','A'))
						select @@rowcount as update_rowcount
					</cfquery>
				</cfif>			

						<cfquery datasource="#session.dsn#" name="update_lo">
							update ISBlogin
							set LGserids = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERIDS#">
							Where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
							select @@rowcount as update_rowcount
						</cfquery>
							<cfif update_lo.update_rowcount is 0>
								<cfset control_mensaje( 'ISB-0006', 'ISBlogin con SERCLA #modificacionCuenta_Q.SERCLA#' )>
							</cfif>						
						
						<cfquery datasource="#session.dsn#" name="rsContrato">
						Select pro.Contratoid
									From ISBproducto pro
										inner join ISBcuenta cue
										on pro.CTid = cue.CTid
										inner join ISBlogin lo
										on lo.Contratoid = pro.Contratoid 
										Where lo.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
						</cfquery>
												
						<cfquery datasource="#session.dsn#" name="login">
							Select LGserids
								From ISBlogin
								Where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsContrato.Contratoid#">
								and LGprincipal = 1
						</cfquery>
						
						<cfif login.RecordCount gt 0 and Len(trim(login.LGserids)) and Not ISBlogin.LGprincipal>
							<cfquery datasource="SACISIIC" name="update_ssx">
							Update SSXINT
								Set INTPAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#login.LGserids#">
								Where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#modificacionCuenta_Q.SERCLA#">
							</cfquery>					
						</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>