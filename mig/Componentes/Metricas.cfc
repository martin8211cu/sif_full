<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGMcodigo" type="string" required="yes">
		<cfargument name="MIGMnombre" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="Ucodigo" type="string" required="no">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfargument name="MIGMdescripcion" type="string" required="no">
		<cfargument name="MIGMnpresentacion" type="string" required="no">
		<cfargument name="MIGMsequencia" type="numeric" required="no">
		<cfargument name="MIGMperiodicidad" type="string" required="no">
		<cfargument name="MIGMtipodetalle" type="string" required="no">
		<cfargument name="idTramite" type="string" required="no" default="N">
		
				<cfquery datasource="#session.dsn#" name="insert">
						insert into MIGMetricas
						(
							CEcodigo,
							Ecodigo,						
							CodFuente,
							Ucodigo,
							MIGRecodigo,
													
							MIGMcodigo,
							MIGMnombre,
							MIGMnpresentacion,
							MIGMdescripcion,
							MIGMsequencia,
							MIGMperiodicidad,
							Dactiva,
							BMusucodigo,
							FechaAlta,
							<!--- ts_rversion, --->
							MIGMesmetrica,
							idTramite																		
						)
						values(
							#session.CEcodigo#,
							#session.Ecodigo#,
							1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReid#">,												
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGMcodigo)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnpresentacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMdescripcion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMsequencia#">	,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMperiodicidad#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,						
							#session.usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="M">
							<cfif arguments.idTramite NEQ 'N'> 
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTramite#">
							<cfelse>
								,null
							</cfif> 										
						) 
						<cf_dbidentity1 datasource="#session.DSN#" name="insert">
					</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGMid">
				<cfset varReturn=#LvarMIGMid#>	
				<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGMnombre" type="string" required="yes">
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfargument name="Ucodigo" type="string" required="no">
		<cfargument name="MIGReid" type="numeric" required="yes">
		<cfargument name="MIGMdescripcion" type="string" required="no">
		<cfargument name="MIGMnpresentacion" type="string" required="no">
		<cfargument name="MIGMsequencia" type="numeric" required="no">
		<cfargument name="MIGMcalculo" type="string" required="no">
		<cfargument name="MIGMperiodicidad" type="string" required="no">
		<cfargument name="MIGMtipodetalle" type="string" required="no">
		<cfargument name="Dactiva" type="numeric" required="no">
		<cfargument name="idTramite" type="string" required="no" default="N">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGMetricas
				set 
				MIGMnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnombre#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">
			<cfif isdefined ('arguments.Ucodigo')>
				,Ucodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ucodigo#">
			</cfif>
				,MIGRecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReid#">
				,BMusucodigo=#session.usucodigo#
			<cfif isdefined ('arguments.MIGMdescripcion')>
				,MIGMdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMdescripcion#">
			</cfif>
			<cfif isdefined ('arguments.MIGMnpresentacion')>
				,MIGMnpresentacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnpresentacion#">
			</cfif>
			<cfif isdefined ('arguments.MIGMsequencia')>
				,MIGMsequencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMsequencia#">	
			</cfif>
			<cfif isdefined ('arguments.MIGMcalculo')>
				,MIGMcalculo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMcalculo#">
			</cfif>
			<cfif isdefined ('arguments.MIGMperiodicidad') >
				,MIGMperiodicidad=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGMperiodicidad)#"/>
			</cfif>
			<cfif isdefined ('arguments.MIGMtipodetalle') >
				,MIGMtipodetalle=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMtipodetalle#">			
			</cfif>	
			<cfif arguments.idTramite NEQ 'N'> 
				,idTramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTramite#">
			<cfelse>
				,idTramite = null
			</cfif> 								
			where MIGMid=#arguments.MIGMid#	
			and Ecodigo=#session.Ecodigo#
			and CEcodigo=#session.CEcodigo#
				
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGMid" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#Session.DSN#">
			select a.MIGMid, b.MIGMcodigo
			from MIGFiltrosmetricas a
				inner join MIGMetricas b
					on a.MIGMid=b.MIGMid
					and a.Ecodigo=b.Ecodigo
			where a.MIGMid=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MIGMid#" >
			and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
		
		<cfquery name="rsValida2" datasource="#session.dsn#">
			select MIGMid from F_Datos
			where MIGMid=#arguments.MIGMid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfif rsValida.recordCount GT 0 or rsValida2.recordCount GT 0>	
			<cfthrow type="toUser" message="La Métrica no puede ser eliminada ya que tiene información relacionada. Se debe eliminar el filtro de la Métrica y los Datos Variables de las Métricas">
		<cfelse>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGMetricas
				where MIGMid=#arguments.MIGMid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			
		</cfif>
	</cffunction>
	
	
	<cffunction access="public" name="UpdateType">
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfargument name="MIGMTIPODETALLE" type="string" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			Update MIGMetricas set MIGMtipodetalle='#arguments.MIGMtipodetalle#'
			where MIGMid=#arguments.MIGMid#
		</cfquery>
	</cffunction>
	
	
	<cffunction access="public" name="BajaCalculados">
		<cfargument name="MIGMid" type="numeric" required="yes">

		<cftransaction>
			<cfquery datasource="#session.dsn#">
				delete from F_Resultados
				where MIGMid=#arguments.MIGMid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			
			<cfquery datasource="#session.dsn#">
				delete from F_Resumen
				where MIGMid=#arguments.MIGMid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
				
			<cfquery datasource="#session.dsn#">
				DELETE FROM F_INDICADOR
				 WHERE F_INDICADOR.ID_INDICADOR = (
		                                        Select D_INDICADOR.ID_INDICADOR
		                                          From MIGMetricas
		                                            inner join Empresas
		                                                    on Empresas.Ecodigo = MIGMetricas.Ecodigo
		                                            inner join D_INDICADOR
		                                                    on D_INDICADOR.INDICADOR_CODIGO = MIGMetricas.MIGMcodigo
		                                                   And D_INDICADOR.COD_FUENTE       = MIGMetricas.Ecodigo
		                                                   And D_INDICADOR.COD_FUENTE_EMP   = Empresas.EcodigoSDC
		                                         where MIGMetricas.MIGMid = #arguments.MIGMid#
		                                           and MIGMetricas.Ecodigo = #session.Ecodigo#
																					)

			</cfquery>
		</cftransaction>
	</cffunction>
	
	<cffunction access="public" name="BajaFiltros">
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGFiltrosmetricas
			where MIGMid=#arguments.MIGMid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>
	
	
	
	
	<cffunction access="public" 	name="AltaFiltros" returntype="numeric">
		<cfargument name="MIGMid" 	type="numeric" required="yes">
		<cfargument name="tipo" type="string" required="yes">
		<cfargument name="valor" 	type="numeric" required="yes">
		<cfargument name="CEcodigo" type="numeric" required="no">
		<cfargument name="Ucodigo" 	type="numeric" required="no" >
		<cfargument name="Ecodigo" 	type="numeric" required="no">
		
			<cfif isdefined('arguments.MIGMid') and len(trim(arguments.MIGMid))>
				<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGFiltrosmetricas
					(
						MIGMid,
						CEcodigo,						
						Ecodigo,
						MIGMtipodetalle,
						MIGMdetalleid,
						MIGFmvalor,
						Dactiva,
						BMusucodigo,
						FechaAlta
					)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">,
						#session.CEcodigo#,
						#session.Ecodigo#,
						'#tipo#',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">,
						0,
						1,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
					
				</cfquery>
				<cfset varReturn=1>

			<cfelse>
				<cfset varReturn=-1>
			</cfif>
				
			<cfreturn #varReturn#>
		
	</cffunction>


	<cffunction access="public" name="BajaFiltrosVariables">
		<cfargument name="MIGMid"	type="numeric" required="yes">
		<cfargument name="MIGMidderivada"	type="numeric" required="yes">
		<cfargument name="MIGMdetalleid" 	type="string" required="no" default="">
		
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGFiltrosderivadas
			where MIGMid=#arguments.MIGMid#
			and MIGMidderivada = #arguments.MIGMidderivada#
			
			<cfif len(trim(arguments.MIGMdetalleid))>
			and MIGMdetalleid = #arguments.MIGMdetalleid#
			</cfif>
			
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

	<cffunction access="public" 	name="AltaFiltrosVariables" returntype="numeric">
		<cfargument name="MIGMid" 	type="numeric" required="yes">
		<cfargument name="MIGMidderivada" type="numeric" required="yes">
		<cfargument name="tipo" 	type="string" required="yes">
		<cfargument name="valor" 	type="string" required="yes">
		<cfargument name="CEcodigo" type="numeric" required="no">
		<cfargument name="Ucodigo" 	type="numeric" required="no" >
		<cfargument name="Ecodigo" 	type="numeric" required="no">
		
			<cfif isdefined('arguments.MIGMid') and len(trim(arguments.MIGMid))>
				<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGFiltrosDerivadas
					(
						MIGMid,
						CEcodigo,						
						Ecodigo,
						MIGMtipodetalle,
						MIGMdetalleid,
						MIGFmvalor,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						MIGMidderivada
					)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">,
						#session.CEcodigo#,
						#session.Ecodigo#,
						'#tipo#',
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">,
						'',
						1,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMidderivada#">
					) 
					
				</cfquery>
				<cfset varReturn=1>

			<cfelse>
				<cfset varReturn=-1>
			</cfif>
				
			<cfreturn #varReturn#>
		
	</cffunction>
</cfcomponent>