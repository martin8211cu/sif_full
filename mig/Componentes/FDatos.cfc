<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">		
		<cfargument name="cod_fuente" 			type="numeric" required="yes">
		<cfargument name="MIGMid" 				type="numeric" required="yes">
		<cfargument name="Dcodigo" 				type="any"    required="no">
		<cfargument name="MIGProid" 			type="any"    required="no">
		<cfargument name="MIGCueid" 			type="any"    required="no">
		<cfargument name="id_moneda" 			type="any"    required="no">
		<cfargument name="Periodo" 				type="numeric" required="no">
		<cfargument name="Pfecha" 				type="date"    required="yes">
		<cfargument name="Valor" 				type="any" required="yes">
		<cfargument name="Lote" 				type="numeric" required="no" default="0">
		<cfargument name="id_atr_dim4" 			type="string" required="no">
		<cfargument name="id_atr_dim5" 			type="string" required="no">
		<cfargument name="Periodo_Tipo" 		type="string" required="no">
		<cfargument name="id_moneda_origen" 	type="any"    required="no">
		<cfargument name="valor_moneda_origen" 	type="numeric" required="no">
			<cfquery datasource="#session.dsn#" name="insert">
					insert into F_Datos
					(
						Ecodigo
						,CEcodigo
						,cod_fuente
						,MIGMid
						,Dcodigo
						,MIGProid
						,MIGCueid
						,id_moneda
						,Periodo
						,Pfecha
						,control
						,fecha_registro
						,valor
						,Lote
						,BMusucodigo
						,id_atr_dim4
						,id_atr_dim5
						,Periodo_Tipo
						,id_moneda_origen
						,valor_moneda_origen
					)
					values(
						#session.Ecodigo#
						,#session.CEcodigo#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(arguments.cod_fuente)#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(arguments.MIGMid)#">
						,#trim(arguments.Dcodigo)#
						,#trim(arguments.MIGProid)#
						,#trim(arguments.MIGCueid)#
						,#trim(arguments.id_moneda)#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(arguments.Periodo)#">
						,<cfqueryparam cfsqltype="cf_sql_date" value="#trim(LSparseDateTime(arguments.Pfecha))#">
						,1
						,<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						,<cfqueryparam cfsqltype="cf_sql_float" value="#trim(arguments.Valor)#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Lote#">
						,#session.usucodigo#
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id_atr_dim4#" null="#trim(arguments.id_atr_dim4) EQ ''#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id_atr_dim5#" null="#trim(arguments.id_atr_dim5) EQ ''#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Periodo_Tipo#">
						,#arguments.id_moneda_origen#
						,<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.valor_moneda_origen#">						
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="Lvarid_datos">
			<cfset varReturn=#Lvarid_datos#>
			<cfreturn #varReturn#>
	</cffunction>
	
	
	<cffunction access="public" name="Cambio">		
		<cfargument name="id_datos" 	type="numeric" required="yes">
		<cfargument name="Pfecha" 		type="date"  required="no">
		<cfargument name="Valor" 		type="any" required="no">
		<cfargument name="valor_moneda_origen" type="numeric" required="no">
		<cfargument name="Lote" 		type="numeric" required="no">
		<cfargument name="Periodo" 		type="numeric" required="no">			
	
			<cfquery datasource="#session.dsn#" name="insert">
					Update F_Datos 
					set 
							BMusucodigo=#session.usucodigo#
							,control=1
						<cfif isdefined("arguments.Pfecha") and trim(arguments.Pfecha) NEQ "">
							,Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#trim(LSparseDateTime(arguments.Pfecha))#">											
						</cfif>
						<cfif isdefined("arguments.Lote") and trim(arguments.Lote) NEQ "">
							,Lote=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Lote#">
						</cfif>
						<cfif isdefined("arguments.Valor") and trim(arguments.Valor) NEQ "">
							,valor=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Valor#">
						</cfif>
						<cfif isdefined("arguments.valor_moneda_origen")>
							,valor_moneda_origen=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.valor_moneda_origen#">
						</cfif>
						<cfif isdefined ("arguments.Periodo")>
							,Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(arguments.Periodo)#">
						</cfif>
					where id_datos = #arguments.id_datos#
					and Ecodigo=#session.Ecodigo#	
				</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="id_datos" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from F_Datos
			where id_datos=#arguments.id_datos#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>
	
</cfcomponent>