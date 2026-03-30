<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="MIGProcodigo" 				type="string" required="yes">
		<cfargument name="Dactiva" 						type="numeric" required="no">
		<cfargument name="MIGPronombre" 				type="string" required="yes">
		<cfargument name="id_unidad_medida"				type="any" required="no">
		<cfargument name="MIGProSegid" 				    type="any"    required="no">
		<cfargument name="MIGProSegid2" 				type="any"    required="no">
		<cfargument name="MIGProSegid3" 				type="any"    required="no">
		<cfargument name="MIGProLinid" 					type="any"    required="no">
		<cfargument name="MIGProLinid2" 				type="any"    required="no">
		<cfargument name="MIGProLinid3" 				type="any"    required="no">
		<cfargument name="MIGProlinea5" 				type="any"    required="no">
		<cfargument name="MIGProLinid4" 				type="any"    required="no">
		<cfargument name="MIGProplanta" 				type="any"    required="no">
		<cfargument name="MIGProesproducto" 			type="string" required="yes">
		<cfargument name="MIGProesnuevo" 				type="numeric" required="yes">
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGProductos
					(
						cod_fuente,
						MIGProcodigo,
						MIGPronombre, 
						Dactiva, 
						BMusucodigo,
						FechaAlta, 
						<!--- ts_rversion, --->
						id_unidad_medida,
						MIGProSegid,
						MIGProSegid2, 
						MIGProSegid3, 
						MIGProLinid, 
						MIGProLinid2, 
						MIGProLinid3, 
						MIGProLinid4,
						MIGProlinea5, 
						MIGProplanta,
						MIGProesproducto,
						MIGProesnuevo,
						Ecodigo,
						CEcodigo 
						
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGProcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPronombre#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- #Now()#, --->
						'#arguments.id_unidad_medida#',
						#arguments.MIGProSegid#,
						#arguments.MIGProSegid2#,
						#arguments.MIGProSegid3#,
						#arguments.MIGProLinid#,
						#arguments.MIGProLinid2#,
						#arguments.MIGProLinid3#,
						#arguments.MIGProLinid4#,
						'#arguments.MIGProlinea5#',
						'#arguments.MIGProplanta#',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProesproducto#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGProesnuevo#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGProid">
			<cfset varReturn=#LvarMIGProid#>	
			<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGProid" 					type="numeric" required="yes">
		<cfargument name="Dactiva" 						type="numeric" required="no">
		<cfargument name="MIGPronombre" 				type="string" required="yes">
		<cfargument name="id_unidad_medida"				type="string" required="no">
		<cfargument name="MIGProSegid" 				    type="any"    required="no">
		<cfargument name="MIGProSegid2" 				type="any"    required="no">
		<cfargument name="MIGProSegid3" 				type="any"    required="no">
		<cfargument name="MIGProLinid" 					type="any"    required="no">
		<cfargument name="MIGProLinid2" 				type="any"    required="no">
		<cfargument name="MIGProLinid3" 				type="any"    required="no">
		<cfargument name="MIGProlinea5" 				type="any"    required="no">
		<cfargument name="MIGProLinid4" 				type="any"    required="no">
		<cfargument name="MIGProplanta" 				type="any"    required="no">
		<cfargument name="MIGProesproducto" 			type="string" required="yes">
		<cfargument name="MIGProesnuevo" 				type="numeric" required="yes">

		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGProductos
				set
					MIGPronombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPronombre#">
				<cfif isdefined ('arguments.Dactiva')>	
					,Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">
				</cfif>
				<cfif isdefined ('arguments.id_unidad_medida')>
					,id_unidad_medida='#arguments.id_unidad_medida#'					
				</cfif>
				<cfif isdefined ('arguments.MIGProSegid')>
					,MIGProSegid=#arguments.MIGProSegid#		
				</cfif>
				<cfif isdefined ('arguments.MIGProSegid2')>
					,MIGProSegid2=#arguments.MIGProSegid2#
				</cfif>
				<cfif isdefined ('arguments.MIGProSegid3')>
					,MIGProSegid3=#arguments.MIGProSegid3#
				</cfif>
				<cfif isdefined ('arguments.MIGProLinid')>
					,MIGProLinid=#arguments.MIGProLinid#
				</cfif>
				<cfif isdefined ('arguments.MIGProLinid2')>
					,MIGProLinid2=#arguments.MIGProLinid2#
				</cfif>
				<cfif isdefined ('arguments.MIGProLinid3')>
					,MIGProLinid3=#arguments.MIGProLinid3#
				</cfif>
				<cfif isdefined ('arguments.MIGProLinid4')>
					,MIGProLinid4=#arguments.MIGProLinid4#
				</cfif>
				<cfif isdefined ('arguments.MIGProlinea5') >
					,MIGProlinea5='#arguments.MIGProlinea5#'
				</cfif>
				<cfif isdefined('arguments.MIGProplanta')>
					,MIGProplanta='#arguments.MIGProplanta#'
				</cfif>
				<cfif isdefined ('arguments.MIGProesproducto') >					
					,MIGProesproducto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProesproducto#">
				</cfif>
				<cfif isdefined ('arguments.MIGProesnuevo')>
					,MIGProesnuevo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGProesnuevo#">
				</cfif>
			where MIGProid=#arguments.MIGProid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGProid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			update MIGProductos
			set Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="0">
			where MIGProid=#arguments.MIGProid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>