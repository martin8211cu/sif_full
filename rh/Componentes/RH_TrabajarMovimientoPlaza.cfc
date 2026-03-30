<cfcomponent>
	<!--- 
		RESULTADO:
		Devuelve el id de la moneda usada por la empresa.
	--->
	<cffunction name="obtenerMoneda" access="public" returntype="string">
		<cfargument name="DSN" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		
		<cfquery name="moneda" datasource="#arguments.DSN#">
			select Mcodigo
			from Empresas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
				
		<cfreturn moneda.Mcodigo >

	</cffunction>

	<!--- 
		RESULTADO:
		Inserta una plaza presupestaria.
		Devuelve el id de plaza insertado.
	--->
	<cffunction name="insertarPlaza" access="public" returntype="numeric">
		<cfargument name="DSN" 				type="string" 	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		<cfargument name="RHMPPid" 			type="string"  required="no" default="">
		<cfargument name="RHPPcodigo" 		type="string"  	required="yes">
		<cfargument name="RHPPdescripcion"	type="string" 	required="yes">
		<cfargument name="RHPPfechav" 		type="string"  	required="no" default="">
		<cfargument name="Iseleccionable" 	type="string"  required="no" default="">
		<cfargument name="BMUsucodigo"		type="numeric"  required="yes">

		<cfquery name="ins" datasource="#arguments.DSN#">
			insert into RHPlazaPresupuestaria( Ecodigo, 
											   RHMPPid, 
											   RHPPcodigo, 
											   RHPPdescripcion, 
											   RHPPfechav, 
											   Mcodigo, 
											   Iseleccionable, 
											   BMfecha, 
											   BMUsucodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#" null="#len(trim(arguments.RHMPPid)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPdescripcion#">,
 					 <cfif len(trim(arguments.RHPPfechav))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHPPfechav)#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#this.obtenerMoneda(arguments.DSN, arguments.Ecodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iseleccionable#" null="#len(trim(arguments.Iseleccionable)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" >,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#" > )
			<cf_dbidentity1 datasource="#arguments.DSN#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#arguments.DSN#" name="ins" verificar_transaccion="no">
		
		<cfreturn ins.identity >

	</cffunction>
	
	<!--- 
		RESULTADO:
		Inserta un movimiento para una plaza presupestaria.
		Devuelve el id del movimiento insertado.
	--->
	<cffunction name="insertarMovimiento" access="public" returntype="numeric">
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHPPid" 			type="string" 	required="no" default=""> 
		<cfargument name="RHPPcodigo" 		type="string" 	required="no" default=""> 
		<cfargument name="RHPPdescripcion" 	type="string" 	required="no" default=""> 
		<cfargument name="RHMPPid" 			type="string" 	required="no" default=""> 
		<cfargument name="RHCid" 			type="string" 	required="no" default=""> 
		<cfargument name="RHTTid" 			type="string" 	required="no" default=""> 
		<cfargument name="RHTMid" 			type="numeric" 	required="yes"> 
		<cfargument name="RHMPfdesde" 		type="string" 	required="no" default="">  
		<cfargument name="RHMPfhasta" 		type="string" 	required="no" default=""> 
		<cfargument name="RHMPestado" 		type="string" 	required="no" default="P"> 
		<cfargument name="RHMPnegociado" 	type="string" 	required="no" default="T"> 
		<cfargument name="id_tramite" 		type="string" 	required="no" default=""> 
		<cfargument name="RHMPestadoplaza"	type="string" 	required="no" default="A"> 
		<cfargument name="CFidant" 			type="string" 	required="no" default=""> 
		<cfargument name="CFidnuevo" 		type="string" 	required="no" default=""> 
		<cfargument name="CFidcostoant" 	type="string" 	required="no" default=""> 
		<cfargument name="CFidcostonuevo" 	type="string" 	required="no" default=""> 
		<cfargument name="CPcuenta" 		type="string" 	required="no" default=""> 
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.Usucodigo#" > 
		<cfargument name="RHPcodigo" 		type="string" 	required="no"> 
		<cfargument name="RHTMporcentaje" 	type="numeric" 	required="no"> 


		<cfquery name="ins" datasource="#arguments.DSN#">
			insert into RHMovPlaza( Ecodigo, 
									RHPPid, 
									RHPPcodigo, 
									RHPPdescripcion, 
									RHMPPid, 
									RHCid, 
									RHTTid, 
									RHTMid, 
									RHMPfdesde, 
									RHMPfhasta, 
									RHMPestado, 
									RHMPnegociado, 
									RHMPmonto, 
									Mcodigo, 
									id_tramite, 
									RHMPestadoplaza, 
									CFidant, 
									CFidnuevo, 
									CFidcostoant, 
									CFidcostonuevo,
									CPcuenta,	 
									BMfecha, 
									BMUsucodigo,
									RHPcodigo,
									RHTMporcentaje)
		
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#" null="#len(trim(arguments.RHPPid)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPdescripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#" null="#len(trim(arguments.RHMPPid)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#" null="#len(trim(arguments.RHCid)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTTid#" null="#len(trim(arguments.RHTTid)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTMid#" null="#len(trim(arguments.RHTMid)) is 0#">,
					 <cfif len(trim(arguments.RHMPfdesde))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfdesde)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(1900,01,01)#"></cfif>,
					 <cfif len(trim(arguments.RHMPfhasta))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfhasta)#"><cfelse>null</cfif>,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPestado#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPnegociado#">,
					 0,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#this.obtenerMoneda(arguments.DSN, arguments.Ecodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tramite#" null="#len(trim(arguments.id_tramite)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPestadoplaza#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidant#" null="#len(trim(arguments.CFidant)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidnuevo#" null="#len(trim(arguments.CFidnuevo)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidcostoant#" null="#len(trim(arguments.CFidcostoant)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidcostonuevo#" null="#len(trim(arguments.CFidcostonuevo)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPcuenta#" null="#len(trim(arguments.CPcuenta)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" >,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#" >,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHPcodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTMporcentaje#"> 
					  )
			<cf_dbidentity1 datasource="#arguments.DSN#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#arguments.DSN#" name="ins" verificar_transaccion="no">
		
		<!--- Inserta los componentes de la linea del tiempo --->
		<cfif len(trim(arguments.RHPPid)) >
			<cfquery datasource="#arguments.DSN#" name="x">
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#ins.identity#">, 
						ltc.CSid, 
						ltc.Ecodigo, 
						ltc.Cantidad, 
						ltc.Monto, 
						ltc.CFformato, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">
				
				from RHCLTPlaza ltc
				
				inner join RHLineaTiempoPlaza ltp
				on ltp.RHLTPid=ltc.RHLTPid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfdesde)#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
				and ltp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#">
			
				inner join ComponentesSalariales cs
				on cs.CSid=ltc.CSid
				
				where ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfquery datasource="#arguments.DSN#">
				insert into RHCMovPlaza( RHMPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#ins.identity#">, 
						ltc.CSid, 
						ltc.Ecodigo, 
						ltc.Cantidad, 
						ltc.Monto, 
						ltc.CFformato, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">
				
				from RHCLTPlaza ltc
				
				inner join RHLineaTiempoPlaza ltp
				on ltp.RHLTPid=ltc.RHLTPid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.RHMPfdesde#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
				and ltp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#">
			
				inner join ComponentesSalariales cs
				on cs.CSid=ltc.CSid
				
				where ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
		</cfif>
		<cfreturn ins.identity >
	</cffunction>

	<!--- 
		RESULTADO:
		Modifica un movimiento para una plaza presupestaria.
	--->
	<cffunction name="modificarMovimiento" access="public" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" 			type="numeric" 	required="yes" >
		<cfargument name="RHPPid" 			type="string" 	required="no" >
		<cfargument name="RHPPcodigo" 		type="string" 	required="no" >
		<cfargument name="RHPPdescripcion" 	type="string" 	required="no" >
		<cfargument name="RHMPPid" 			type="string" 	required="no" >
		<cfargument name="RHCid" 			type="string" 	required="no" >
		<cfargument name="RHTTid" 			type="string" 	required="no" >
		<cfargument name="RHTMid" 			type="string" 	required="no" >
		<cfargument name="RHMPfdesde" 		type="string" 	required="no" >
		<cfargument name="RHMPfhasta" 		type="string" 	required="no" >
		<cfargument name="RHMPestado" 		type="string" 	required="no" >
		<cfargument name="RHMPnegociado" 	type="string" 	required="no" >
		<cfargument name="RHMPmonto" 		type="string" 	required="no" >
		<cfargument name="id_tramite" 		type="string" 	required="no" >
		<cfargument name="RHMPestadoplaza"	type="string" 	required="no" >
		<cfargument name="CFidant" 			type="string" 	required="no" >
		<cfargument name="CFidnuevo" 		type="string" 	required="no" >
		<cfargument name="CFidcostoant" 	type="string" 	required="no" >
		<cfargument name="CFidcostonuevo" 	type="string" 	required="no" >
		<cfargument name="CPcuenta" 		type="string" 	required="no" >
		<cfargument name="RHPcodigo" 		type="string" 	required="no" >
		<cfargument name="RHTMporcentaje" 	type="numeric" 	required="no">
		
		<cfquery name="ins" datasource="#arguments.DSN#">
			update RHMovPlaza
			set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				<cfif isdefined("arguments.RHTMid") >
					,RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTMid#" null="#len(trim(arguments.RHTMid)) is 0#">
				</cfif>	
				
				<cfif isdefined("arguments.RHPPid") >
					,RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#" null="#len(trim(arguments.RHPPid)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHPPcodigo")>
					,RHPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPcodigo#">
				</cfif>
				<cfif isdefined("arguments.RHPPdescripcion")>
					,RHPPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPPdescripcion#">
				</cfif>
				<cfif isdefined("arguments.RHMPPid")>
					,RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#" null="#len(trim(arguments.RHMPPid)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHCid")>
					,RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCid#" null="#len(trim(arguments.RHCid)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHTTid")>
					,RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTTid#" null="#len(trim(arguments.RHTTid)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHMPfdesde")>
					,RHMPfdesde = <cfif len(trim(arguments.RHMPfdesde))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfdesde)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(1900,01,01)#"></cfif> 
				</cfif>
				<cfif isdefined("arguments.RHMPfhasta")>
					,RHMPfhasta = <cfif len(trim(arguments.RHMPfhasta))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfhasta)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(6100,01,01)#"></cfif> 
				</cfif>
				<cfif isdefined("arguments.RHMPestado")>
					,RHMPestado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPestado#"> 
				</cfif>
				<cfif isdefined("arguments.RHMPnegociado")>
					,RHMPnegociado = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPnegociado#"> 
				</cfif>
				<cfif isdefined("arguments.RHMPmonto") and len(trim(arguments.RHMPmonto)) >
					,RHMPmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(arguments.RHMPmonto,',','','all')#"> 
				</cfif>
				<cfif isdefined("arguments.id_tramite")>
					,id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_tramite#" null="#len(trim(arguments.id_tramite)) is 0#"> 
				</cfif>				
				<cfif isdefined("arguments.RHMPestadoplaza")>
					,RHMPestadoplaza = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.RHMPestadoplaza#"> 
				</cfif>
				<cfif isdefined("arguments.CFidant")>
					,CFidant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidant#" null="#len(trim(arguments.CFidant)) is 0#"> 
				</cfif>
				<cfif isdefined("arguments.CFidnuevo")>
					,CFidnuevo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidnuevo#" null="#len(trim(arguments.CFidnuevo)) is 0#"> 
				</cfif>
				<cfif isdefined("arguments.CFidcostoant")>
					,CFidcostoant = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidcostoant#" null="#len(trim(arguments.CFidcostoant)) is 0#"> 
				</cfif>
				<cfif isdefined("arguments.CFidcostonuevo")>
					,CFidcostonuevo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFidcostonuevo#" null="#len(trim(arguments.CFidcostonuevo)) is 0#">
				</cfif>
				<cfif isdefined("arguments.CPcuenta")>
					,CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPcuenta#" null="#len(trim(arguments.CPcuenta)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHPcodigo")>
					,RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.RHPcodigo#" null="#len(trim(arguments.RHPcodigo)) is 0#">
				</cfif>
				<cfif isdefined("arguments.RHTMporcentaje")>
					,RHTMporcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTMporcentaje#" null="#len(trim(arguments.RHTMporcentaje)) is 0#">
				</cfif>
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
		</cfquery>
		<!--- OBTIENE EL ID DEL COMPONENTE DE SALARIO BASE --->
		<cfquery name="rsSB" datasource="#session.DSN#">
			select CSid
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and CSsalariobase = 1
		</cfquery>
		<cfdump var="#rsSB#">
		<!--- VERIFICA SI LA PLAZA TIENE EL COMPONENTE SALARIAL BASE --->
		<cfquery name="rsSAP" datasource="#session.DSN#">
			select 1
			from RHCMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
			  and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSB.CSid#">
		</cfquery>
		<cfif rsSAP.REcordCount EQ 0>
			<!--- INSERTA EL SALARIO BASE --->
			<cfquery name="rsCatPaso" datasource="#Session.DSN#">
				select RHCPlinea,   coalesce(RHCPlinearef, RHCPlinea) as RHCPlinearef
				from RHCategoriasPuesto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTTid#">
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCid#">
				and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHMPPid#">
			</cfquery>
			<cfquery name="rsMontoTabla" datasource="#Session.DSN#">
				select coalesce(b.RHMCmonto,0) as monto
				from RHCategoriasPuesto a
				inner join RHMontosCategoria b
					on b.RHCid = a.RHCid
				inner join RHVigenciasTabla c
					on c.Ecodigo = a.Ecodigo
					and c.RHVTid = b.RHVTid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCatPaso.RHCPlinea#">
				  and RHVTestado = 'A'
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RHMPfdesde#"> between RHVTfecharige and RHVTfechahasta
			</cfquery>
			<cfquery name="insertSB" datasource="#session.DSN#">
				insert into RHCMovPlaza( RHMPid, CSid, Ecodigo, Cantidad, Monto, BMfecha, BMUsucodigo )
				values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSB.CSid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_money" value="#rsMontoTabla.monto#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>

	</cffunction>

	<!--- 
		RESULTADO:
		Elimina un movimiento para una plaza presupestaria.
	--->
	<cffunction name="eliminarMovimiento" access="public" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" 			type="numeric" 	required="yes" > 

		<!--- Borra los componentes propuestos --->
		<cfset this.eliminarComponente(arguments.DSN, arguments.Ecodigo, arguments.RHMPid ) >

		<!--- Borra los movimientos --->
		<cfquery name="ins" datasource="#arguments.DSN#">
			delete from RHMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
		</cfquery>
	</cffunction>

	<!--- 
		RESULTADO:
		Elimina los componentes propuestos para movimiento de plaza presupestaria.
	--->
	<cffunction name="eliminarComponente" access="public" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" 			type="numeric" 	required="yes" > 

		<cfquery name="ins" datasource="#arguments.DSN#">
			delete from RHCMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
		</cfquery>
	</cffunction>


	<!--- 
		RESULTADO:
		Devuelve la situacion actual de una plaza.
	--->
	<cffunction name="situacionActual" access="public" returntype="query" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHPPid" 			type="string" 	required="yes" > 
		<cfargument name="RHMPfdesde"		type="string" 	required="yes" > 

		<!--- Query Situacion Actual 
			  Se lee de la linea del tiempo para las plazas presupuestarias.
		--->
		<cfquery name="situacion_actual" datasource="#arguments.DSN#">
			select 	coalesce(ltp.RHCid, 0) as RHCid,
					coalesce(ltp.RHMPPid, 0) as RHMPPid,
					coalesce(ltp.RHTTid, 0) as RHTTid,
					ltp.CFidautorizado,
					ltp.CFcentrocostoaut, 
					ltp.RHMPestadoplaza,
				    case ltp.RHMPestadoplaza when 'A' then 'Activo' when 'I' then 'Inactivo' when 'C' then 'Congelado' end as estadodesc, 
					ltp.RHMPnegociado,
				    case ltp.RHMPnegociado when 'N' then 'Negociado' when 'T' then 'Tabla Salarial' end as negociadodesc, 
					ltp.RHLTPmonto,
					ts.RHTTcodigo,
					ts.RHTTdescripcion,
					c.RHCcodigo,
					c.RHCdescripcion,
					mp.RHMPPcodigo,
					mp.RHMPPdescripcion,
					cf1.CFcodigo,
					cf1.CFdescripcion,
					cf2.CFcodigo as CFcodigocc,
					cf2.CFdescripcion as CFdescripcioncc
			from RHLineaTiempoPlaza ltp
			
			left outer join RHTTablaSalarial ts
			on ts.RHTTid = ltp.RHTTid
		
			left outer join RHCategoria c
			on c.RHCid = ltp.RHCid
		
			left outer join RHMaestroPuestoP mp
			on mp.RHMPPid = ltp.RHMPPid
		
			left outer join CFuncional cf1
			on cf1.CFid = ltp.CFidautorizado
		
			left outer join CFuncional cf2
			on cf2.CFid = ltp.CFcentrocostoaut
		
			where ltp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.RHMPfdesde)#"> between ltp.RHLTPfdesde and ltp.RHLTPfhasta
			  and ltp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
		<cfreturn situacion_actual>
		
	</cffunction>
	
	<!--- 
		RESULTADO:
		Inserta un componente salarial para un movimiento a plaza presupestaria.
	--->
	<cffunction name="insertarComponente" access="public" returntype="numeric" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" 			type="numeric" 	required="yes" > 
		<cfargument name="CSid" 			type="string" 	required="yes" > 
		<cfargument name="Cantidad" 		type="string" 	required="no" > 
		<cfargument name="Monto" 			type="string" 	required="yes" > 
		<cfargument name="CFormato"			type="string" 	required="no" > 
		<cfargument name="BMUsucodigo"		type="string" 	required="no" default="#session.Usucodigo#" > 

		<cfquery name="ins" datasource="#arguments.DSN#">
			insert into RHCMovPlaza( RHMPid, CSid, Ecodigo, Cantidad, Monto, CFformato, BMfecha, BMUsucodigo )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CSid#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(arguments.Cantidad, ',', '', 'all')#" null="#len(trim(arguments.Cantidad)) is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#replace(arguments.Monto,',','','all')#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFormato#" null="#len(trim(arguments.CFormato)) is 0#">,
				     <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				     <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#"> )
			<cf_dbidentity1 datasource="#arguments.DSN#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#arguments.DSN#" name="ins" verificar_transaccion="no">
		
		<cfreturn ins.identity >
	</cffunction>
	
	<!--- 
		RESULTADO:
		Modifica un componente salarial para un movimiento a plaza presupestaria.
	--->
	<cffunction name="modificarComponente" access="public" >
		<cfargument name="DSN" 				type="string" 	required="no" default="#session.DSN#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHCMPid" 			type="numeric" 	required="yes" > 
		<cfargument name="RHMPid" 			type="numeric" 	required="yes" > 
		<cfargument name="CSid" 			type="string" 	required="no" > 
		<cfargument name="Cantidad" 		type="string" 	required="no" > 
		<cfargument name="Monto" 			type="string" 	required="yes" > 
		<cfargument name="CFormato"			type="string" 	required="no" > 

		<cfquery datasource="#arguments.DSN#">
			update RHCMovPlaza
			set Ecodigo = Ecodigo
				<cfif isdefined("arguments.CSid") >
					,CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CSid#">
				</cfif>	
				
				<cfif isdefined("arguments.Cantidad") >
					,Cantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Cantidad#" null="#len(trim(arguments.Cantidad)) is 0#">
				</cfif>
				<cfif isdefined("arguments.Monto")>
					,Monto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(arguments.Monto,',','','all')#">
				</cfif>
				<cfif isdefined("arguments.CFormato")>
					,CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CFormato#">
				</cfif>

			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and RHCMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHCMPid#">
			  and RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
		</cfquery>
	</cffunction>
</cfcomponent>