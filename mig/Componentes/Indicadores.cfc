<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" 					type="numeric" required="yes">
		<cfargument name="MIGMcodigo" 				type="string" required="yes">
		<cfargument name="MIGMnombre" 				type="string" required="yes">
		<cfargument name="Dactiva" 						type="numeric" required="yes">
		<cfargument name="Ucodigo" 						type="string" required="yes">
		<cfargument name="MIGRecodigo" 						type="numeric" required="yes">
		<cfargument name="MIGReidduenno" 				type="numeric" required="yes">
		<cfargument name="MIGPerid" 					type="numeric" required="yes">
		<cfargument name="MIGMnpresentacion" 			type="string" required="no">
		<cfargument name="MIGMdescripcion" 			type="string" required="no">
		<cfargument name="MIGMsequencia" 				type="string" required="no">
		<cfargument name="MIGMperiodicidad" 			type="string" required="no">
		<cfargument name="MIGMtipotolerancia" 		type="string" required="no">
		<cfargument name="MIGMtoleranciainferior" 	type="any" required="no">
		<cfargument name="MIGMtoleranciasuperior" 	type="any" required="no">
		<cfargument name="MIGReidFija" 					type="numeric" required="yes">
		<cfargument name="MIGMtendenciapositiva" 		type="string" required="no">
		<cfargument name="idTramite" 				type="string" required="no" default="N">
		
		<cfargument name="MIGMescorporativo" 		type="string" required="no" default="0">
				<cfquery datasource="#session.dsn#" name="insert">					
						insert into MIGMetricas
						(
							CodFuente,
							MIGMcodigo,
							MIGMnombre, 
							Dactiva, 
							BMusucodigo,
							FechaAlta, 
							<!--- ts_rversion, --->
							Ucodigo, 
							MIGRecodigo,
							MIGPerid, 
							MIGReidduenno, 
<!--- 							MIGMid, --->
							MIGMnpresentacion, 
							MIGMdescripcion, 
							MIGMsequencia, 
							MIGMperiodicidad, 
							MIGMtipotolerancia, 
							MIGMtoleranciainferior, 
							MIGMtoleranciasuperior,
							MIGReidFija,
							MIGMtendenciapositiva,
							Ecodigo,
							CEcodigo,
							MIGMesmetrica,
							MIGMescorporativo,
							idTramite
						)
						values(
							1,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGMcodigo)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnombre#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
							#session.usucodigo#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<!--- #Now()#, --->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGRecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGPerid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReidduenno#">,
<!---							-1,--->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnpresentacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMdescripcion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMsequencia#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMperiodicidad#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMtipotolerancia#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MIGMtoleranciainferior#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MIGMtoleranciasuperior#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReidFija#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMtendenciapositiva#">,
							#session.Ecodigo#,
							#session.CEcodigo#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="I">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMescorporativo#">
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
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfargument name="MIGMnombre" 				type="string" required="yes">
		<cfargument name="Dactiva" 					type="numeric" required="yes">
		<cfargument name="Ucodigo" 					type="string" required="yes">
		<cfargument name="MIGRecodigo" 				type="numeric" required="yes">
		<cfargument name="MIGReidduenno" 			type="numeric" required="yes">
		<cfargument name="MIGPerid" 				type="numeric" required="yes">
		<cfargument name="MIGMnpresentacion" 		type="string" required="no">
		<cfargument name="MIGMdescripcion" 			type="string" required="no">
		<cfargument name="MIGMsequencia" 			type="string" required="no">
		<cfargument name="MIGMperiodicidad" 		type="string" required="no">
		<cfargument name="MIGMtipotolerancia" 		type="string" required="no">
		<cfargument name="MIGMtoleranciainferior" 	type="any" required="no">
		<cfargument name="MIGMtoleranciasuperior" 	type="any" required="no">
		<cfargument name="MIGReidFija" 				type="numeric" required="yes">
		<cfargument name="MIGMtendenciapositiva" 	type="string" required="no">
		<cfargument name="MIGMescorporativo" 		type="string" required="no" default="0">
		<cfargument name="idTramite" 				type="string" required="no" default="N">
		
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGMetricas
				set
					MIGMnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnombre#">
					,Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#"> 
					,Ucodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ucodigo#"> 
					,MIGRecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGRecodigo#">
					,MIGPerid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGPerid#"> 
					,MIGReidduenno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReidduenno#">
				<cfif isdefined ('arguments.MIGMnpresentacion')>
					,MIGMnpresentacion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMnpresentacion#">
				</cfif>
				<cfif isdefined ('arguments.MIGMdescripcion') >
					,MIGMdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMdescripcion#">
				</cfif>
				<cfif isdefined ('arguments.MIGMsequencia')>
					,MIGMsequencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMsequencia#">
				</cfif>
				<cfif isdefined ('arguments.MIGMperiodicidad')>
					,MIGMperiodicidad=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMperiodicidad#">
				</cfif>
				<cfif isdefined ('arguments.MIGMtipotolerancia')>
					,MIGMtipotolerancia=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMtipotolerancia#">
				</cfif>
				<cfif isdefined ('arguments.MIGMtoleranciainferior')> 
					,MIGMtoleranciainferior=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MIGMtoleranciainferior#">
				</cfif>
				<cfif isdefined ('arguments.MIGMtoleranciasuperior')> 
					,MIGMtoleranciasuperior=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.MIGMtoleranciasuperior#">
				</cfif>
					,MIGReidFija=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGReidFija#">
				<cfif isdefined ('arguments.MIGMtendenciapositiva')> 
					,MIGMtendenciapositiva=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMtendenciapositiva#">
				</cfif>
				<cfif isdefined ('arguments.MIGMescorporativo')> 
					,MIGMescorporativo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGMescorporativo#">
				</cfif> 
				<cfif arguments.idTramite NEQ 'N'> 
					,idTramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTramite#">
				<cfelse>
					,idTramite = null
				</cfif> 
				
			where MIGMid=#arguments.MIGMid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGMid" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select MIGMid from MIGMetas
			where MIGMid=#arguments.MIGMid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsValida2" datasource="#session.dsn#">
			select MIGMid from F_Resumen
			where MIGMid=#arguments.MIGMid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfif rsValida.recordCount GT 0 or rsValida2.recordCount GT 0>	
			<cfthrow type="toUser" message="El Indicador no puede ser eliminado porque contiene cálculos realizados e información de metas. Elimine dicha información primero con el botón Borrar Calculados y de la pantalla de Metas">
		<cfelse>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGMetricas
				where MIGMid=#arguments.MIGMid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		</cfif>
	</cffunction>
	
<!---*******************************--->	
	<cffunction access="public" name="UpdateType">
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfargument name="MIGMtipodetalle" type="string" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			Update MIGMetricas set MIGMtipodetalle='#arguments.MIGMtipodetalle#'
			where MIGMid=#arguments.MIGMid#
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="AltaDetalleAccion" returntype="any">
		<cfargument name="MIGMid"	type="numeric" required="yes">
		<cfargument name="MIGESTid" type="string" required="no" default="">
		<cfargument name="MIGAEID"  type="string" required="no" default="">
		<cfargument name="CEcodigo" type="numeric" required="no">
		<cfargument name="Ecodigo" 	type="numeric" required="no">
		
		<cfreturn 'hola'>	 
	</cffunction>
	<cffunction access="public" name="AltaDetalle" returntype="any">
		<cfargument name="MIGMid"	type="numeric" required="yes">
		<cfargument name="IGESTid" type="string" required="no" default="">
		<cfargument name="MIGOEid" 	type="string" required="no" default="">
		<cfargument name="MIGFCid" 	type="string" required="no" default="">
		<cfargument name="CEcodigo" type="numeric" required="no">
		<cfargument name="Ecodigo" 	type="numeric" required="no">
		<cfargument name="CodFuente" type="numeric" required="yes">
		
		<cfparam name="MIGIdetactual" default="1"><!---REVISAR QUE VALOR VA EN EESTE CAMPO--->
		<cfparam name="MIGIdetid" default="">
		<cfparam name="fechaActual" default="#now()#">
		
		<cfquery name="rsCambio" datasource="#session.DSN#">
			select * from MIGIndicadorDetalle
			where MIGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">
			<cfif len(trim(arguments.MIGESTid))>
				and MIGEstid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGESTid#">
			</cfif>
			<cfif len(trim(arguments.MIGOEid))>
				and MIGOEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGOEid#">
			</cfif>
			<cfif len(trim(arguments.MIGFCid))>
				and MIGFCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGFCid#">
			</cfif>
			and MIGIdetactual  = 1
		</cfquery>
		
		<cfif rsCambio.recordCount EQ 0><!---si no existe(identico al actual) lo modifica o lo agrega--->
		
			<cfquery name="rsDetalle" datasource="#session.DSN#">
				select * from MIGIndicadorDetalle
				where MIGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">
				and MIGIdetactual  = 1
			</cfquery>
		
			<cfif rsDetalle.recordCount GT 0>
				<cfquery datasource="#session.dsn#" name="insert">
					Update MIGIndicadorDetalle 
					set MIGIdetactual =0 
					,MIGIdetfechafinal=<cfqueryparam cfsqltype="cf_sql_date" value="#fechaActual#"> 
					where MIGIdetid=#rsDetalle.MIGIDETid#
				</cfquery>
			</cfif>
			
				<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGIndicadorDetalle (MIGMid,MIGEstid,MIGOEid,MIGFCid,CEcodigo,BMusucodigo,Ecodigo,CodFuente,MIGIdetactual,FechaAlta,MIGIdetfechafinal,MIGIdetfechainicio)
					values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">
					
					<cfif len(trim(arguments.MIGESTid))>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGESTid#">
					<cfelse>
						,null
					</cfif>
					
					<cfif len(trim(arguments.MIGOEid))>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGOEid#">
					<cfelse>
						,null
					</cfif>
					
					<cfif len(trim(arguments.MIGFCid))>
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGFCid#">
					<cfelse>
						,null
					</cfif>
					
					,#session.CEcodigo#
					,#session.usucodigo#
					,#session.Ecodigo#
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CodFuente#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#MIGIDETActual#">
					,#now()#
					,<cfqueryparam cfsqltype="cf_sql_date" value="01/01/6000">
					,<cfqueryparam cfsqltype="cf_sql_date" value="#fechaActual#"> 
					)
				</cfquery>
		<cfelse>
		
				<cfquery datasource="#session.dsn#" name="insert">
					Update MIGIndicadorDetalle 
					set MIGIdetactual =1
					<cfif len(trim(arguments.MIGESTid))>
						,MIGEstid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGESTid#">
					</cfif>
					<cfif len(trim(arguments.MIGOEid))>
						,MIGOEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGOEid#">
					</cfif>
					<cfif len(trim(arguments.MIGFCid))>
						,MIGFCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGFCid#">
					</cfif>
					where MIGIdetid=#rsCambio.MIGIDETid#
				</cfquery>
		</cfif>
		
		
		<cfreturn #MIGIDETid#>
		
	</cffunction>
	
	
	<cffunction access="public" name="BajaFiltros">
		<cfargument name="MIGMid" type="numeric" required="yes">
		<cfargument name="MIGMidindicador" type="numeric" required="yes">
		<cfargument name="MIGMdetalleid" type="string" required="no" default="">
		
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGFiltrosindicadores
			where MIGMid=#arguments.MIGMid#
			and MIGMidindicador = #arguments.MIGMidindicador#
			
			<cfif len(trim(arguments.MIGMdetalleid))>
			and MIGMdetalleid = #arguments.MIGMdetalleid#
			</cfif>
			
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>
	
	<cffunction access="public" 	name="AltaFiltros" returntype="numeric">
		<cfargument name="MIGMid" 	type="numeric" required="yes">
		<cfargument name="MIGMidindicador" type="numeric" required="yes">
		<cfargument name="tipo" 	type="string" required="yes">
		<cfargument name="valor" 	type="numeric" required="yes">
		<cfargument name="CEcodigo" type="numeric" required="no">
		<cfargument name="Ucodigo" 	type="numeric" required="no" >
		<cfargument name="Ecodigo" 	type="numeric" required="no">
		
			<cfif isdefined('arguments.MIGMid') and len(trim(arguments.MIGMid))>
				<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGFiltrosindicadores
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
						MIGMidindicador
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
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMidindicador#">
					) 
					
				</cfquery>
				<cfset varReturn=1>

			<cfelse>
				<cfset varReturn=-1>
			</cfif>
				
			<cfreturn #varReturn#>
		
	</cffunction>

</cfcomponent>