<cfcomponent>

<!--- Inicio Componentes Encabezado --->
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="MIGParcodigo" 			type="string" required="yes">
		<cfargument name="MIGPardescripcion" 	type="string" required="yes">
		<cfargument name="MIGPartipo" 				type="string" required="no">
		<cfargument name="MIGParsubtipo" 			type="string" required="no">
		<cfargument name="MIGParactual" 			type="string" required="no">
<!---		<cfargument name="Dactiva" 						type="numeric" required="yes"> --->

		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGParcodigo) as MIGParcodigo, MIGPardescripcion
			from MIGParametros
			where MIGParcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGParcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		   <cfif rsValida.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGParametros
					(
						CEcodigo,
						Ecodigo,
						MIGParcodigo,
						MIGPardescripcion,
						MIGPartipo,
						MIGParsubtipo,
						MIGParactual,
						Dactiva,
						BMusucodigo,
						FechaAlta
					)
					values(
						#session.CEcodigo#,
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGParcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPardescripcion)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPartipo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGParsubtipo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGParactual#">,
						1,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">

				<!--- Sólo uno con MIGParactual = 'S'. Actualizar MIGParactual para los otros registros --->
				<cfif isdefined('arguments.MIGParactual') and arguments.MIGParactual EQ 'S'>
					<cfquery datasource="#session.dsn#">
							update MIGParametros
							   set MIGParactual = 'N'
							where MIGParcodigo <> '#arguments.MIGParcodigo#'
							  and Ecodigo  = #session.Ecodigo#
							  and MIGParactual = 'S'
					</cfquery>
				</cfif>

			</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGParid">
				<cfset varReturn=#LvarMIGParid#>	
				<cfreturn #varReturn#>
		   <cfelse>
			<cfthrow type="toUser" message="El código del parámetro #rsValida.MIGParcodigo# ya existe para #rsValida.MIGPardescripcion#.">
		   </cfif>

	</cffunction>

	<cffunction access="public" name="CAMBIO">
		<cfargument name="MIGParid" 					type="numeric" required="yes">
		<cfargument name="MIGPardescripcion"	type="string" required="yes">
		<cfargument name="MIGPartipo" 				type="string" required="no">
		<cfargument name="MIGParsubtipo" 			type="string" required="yes">
		<cfargument name="MIGParactual" 			type="string" required="yes">
		<cfargument name="Dactiva" 						type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGParametros 
			    set MIGPardescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPardescripcion)#">,
							MIGPartipo	  		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPartipo)#">,
							MIGParsubtipo	  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGParsubtipo)#">,
							MIGParactual	  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGParactual#">,
							Dactiva		  			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
							BMusucodigo	  		= #session.usucodigo#
			where MIGParid = #arguments.MIGParid#
			  and Ecodigo = #session.Ecodigo#
		</cfquery>

		<cfif isdefined('arguments.MIGParactual') and arguments.MIGParactual EQ 'S'>
			<cfquery name="Upd_Actual_cambio" datasource="#session.dsn#">
					update MIGParametros
					   set MIGParactual = 'N'
					where MIGParid <> #arguments.MIGParid#
					  and Ecodigo  = #session.Ecodigo#
					  and MIGParactual = 'S'
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction access="public" name="Baja">
		<cfargument name="MIGParid" type="numeric" required="yes">
			<cfquery datasource="#session.dsn#" name="delete">
				Delete from MIGParametrosdet 
				where MIGParid = #arguments.MIGParid#
				  and Ecodigo  = #session.Ecodigo#
			</cfquery>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGParametros
				where MIGParid = #arguments.MIGParid#
				  and Ecodigo  = #session.Ecodigo#
			</cfquery>
	</cffunction>
<!--- Fin Componentes Encabezado (MIGParametros) --->

<!---           -----------------------------------------------------------------------------------------------------      --->
<!--- Inicio Componentes Detalle (MIGParametrosdet) --->
	<cffunction access="public" name="AltaDet" returntype="numeric">
		<cfargument name="MIGParid" 					type="numeric" required="yes">
		<cfargument name="Pfechainicial" 			type="date" required="yes">
		<cfargument name="Pfechafinal" 				type="date" required="yes">
		<cfargument name="Valorcalificacion" 	type="string" required="yes">
		<cfargument name="Peso" 							type="string" required="no" default="0">


			<!---  

			<cfdump var="#form#">
			<cf_dump var="#URL#">
		--->

		<cfquery name="rsValidaFecha" datasource="#session.dsn#">
			Select distinct FECHA, Pfechainicial, Pfechafinal
			 From MIGParametrosdet
			 inner join D_PERIODO
                                 on (D_PERIODO.FECHA = MIGParametrosdet.Pfechainicial
                                 or  D_PERIODO.FECHA = MIGParametrosdet.Pfechafinal)
                                And D_PERIODO.FECHA >= #LSparseDateTime(arguments.Pfechainicial)#
                                And D_PERIODO.FECHA <= #LSparseDateTime(arguments.Pfechafinal)#
			  Where MIGParametrosdet.MIGParid = #arguments.MIGParid#
		</cfquery>

		<cfif #LSparseDateTime(arguments.Pfechainicial)# GT #LSparseDateTime(arguments.Pfechafinal)#>
			<cfthrow type="toUser" message="La fecha final #form.Pfechafinal# debe ser mayor a la fecha inicial #form.Pfechainicial#.">
		<cfelseif rsValidaFecha.recordCount NEQ 0>
			<cfthrow type="toUser" message="El rango de fechas del #form.Pfechainicial# al #form.Pfechafinal# coincide con otra definición de rangos.">
		</cfif>
		<cfif rsValidaFecha.recordCount NEQ 0>
			<cfthrow type="toUser" message="El rango de fechas del #form.Pfechainicial# al #form.Pfechafinal# coincide con otra definición de rangos.">
		</cfif>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGParametrosdet
					(
						MIGParid,
						Pfechainicial,
						Pfechafinal,
						Valorcalificacion,
						Peso,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						Ecodigo,
						CEcodigo
					)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGParid#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(arguments.Pfechainicial)#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(arguments.Pfechafinal)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Valorcalificacion#">, 
<!--- 						<cfif isdefined ('form.Valorcalificacion') and len(trim(form.Valorcalificacion)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Valorcalificacion#">,
						<cfelse>
							0,
						</cfif>
--->
						<!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Peso#">, --->
						<cfif isdefined ('form.Peso') and len(trim(form.Peso)) gt 0>
							<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Peso#">,
						<cfelse>
							0,
						</cfif>	
						1,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="MIGPardetid">
			<cfset varReturn=#MIGPardetid#>
			<cfreturn #varReturn#>
	</cffunction>


	<cffunction access="public" name="CambioDet">
		<cfargument name="MIGPardetid" 				type="numeric" required="yes">
		<cfargument name="MIGParid" 					type="numeric" required="yes">
		<cfargument name="Pfechainicial" 			type="date" required="yes">
		<cfargument name="Pfechafinal" 				type="date" required="yes">
		<cfargument name="Valorcalificacion" 	type="numeric" required="yes">
		<cfargument name="Peso" 							type="numeric" required="no">

		<cfquery name="rsValidaFechaUpd" datasource="#session.dsn#">
			Select distinct FECHA, Pfechainicial, Pfechafinal
			 From MIGParametrosdet
			 inner join D_PERIODO
                                 on (D_PERIODO.FECHA = MIGParametrosdet.Pfechainicial
                                 or  D_PERIODO.FECHA = MIGParametrosdet.Pfechafinal)
                                And D_PERIODO.FECHA >= #LSparseDateTime(arguments.Pfechainicial)#
                                And D_PERIODO.FECHA <= #LSparseDateTime(arguments.Pfechafinal)#
			  Where MIGParametrosdet.MIGParid = #arguments.MIGParid#
                            and MIGPardetid <> #arguments.MIGPardetid#
		</cfquery>

		<cfif #LSparseDateTime(arguments.Pfechainicial)# GT #LSparseDateTime(arguments.Pfechafinal)#>
			<cfthrow type="toUser" message="La fecha final #form.Pfechafinal# debe ser mayor a la fecha inicial #form.Pfechainicial#.">
		<cfelseif rsValidaFechaUpd.recordCount NEQ 0>
			<cfthrow type="toUser" message="El rango de fechas del #form.Pfechainicial# al #form.Pfechafinal# coincide con otra definición de rangos.">
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update MIGParametrosdet
				   set Pfechainicial 	   = <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(arguments.Pfechainicial)#">
					,Pfechafinal	   = <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(arguments.Pfechafinal)#">
					,Valorcalificacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Valorcalificacion#">
					,Peso		   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Peso#">
					,BMusucodigo	   = #session.usucodigo#
				where MIGPardetid=#arguments.MIGPardetid#
				  and Ecodigo=#session.Ecodigo#
			</cfquery>
		</cfif>

	</cffunction>

	<cffunction access="public" name="BajaDet">
		<cfargument name="MIGPardetid" 		type="numeric" required="yes">
		<cfquery datasource="#session.dsn#" name="delete">
			Delete from MIGParametrosdet 
			where MIGPardetid=#arguments.MIGPardetid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>
<!--- Fin Componentes Detalle (MIGParametrosdet) --->

</cfcomponent>