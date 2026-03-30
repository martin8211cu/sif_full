<cfcomponent name="RH_Plazas">
	<!--- Función del Alta de Plazas --->
	<cffunction name="Alta" access="public" returntype="numeric">
		<cfargument  name="CFid" 			type="numeric" 	srequired="yes">
		<cfargument  name="RHPcodigo" 		type="string" 	required="yes">
		<cfargument  name="RHPdescripcion" 	type="string" 	required="yes">
		<cfargument  name="Dcodigo" 		type="numeric" 	required="yes">
		<cfargument  name="Ocodigo" 		type="numeric" 	required="yes">
		<cfargument  name="RHPpuesto" 		type="string" 	required="yes">
		<cfargument  name="CFidconta" 		type="numeric" 	required="no" 	default="#Arguments.CFid#">
		<cfargument  name="RHPactiva" 		type="boolean" 	required="no" 	default="false">
		<cfargument  name="RHPresponsable" 	type="boolean" 	required="no" 	default="false">
		<cfargument  name="LTfecha" 		type="Date" 	required="no">
		<cfargument  name="IDInterfaz" 		type="Numeric" 	required="no" 	default="0">
		<cfquery name="chkExists" datasource="#Session.DSN#">
			select 1
			from RHPlazas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RHPcodigo#">
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		</cfquery>
		<cfif chkExists.recordCount GT 0>
			<cfthrow message="El código de plaza ya existe.">
		</cfif>
		<cftransaction>
			<cfquery name="ABC_Plazas" datasource="#session.DSN#">
				insert into RHPlazas ( CFid, Ecodigo, RHPcodigo, RHPdescripcion, Dcodigo, Ocodigo, RHPpuesto, CFidconta, RHPactiva, IDInterfaz )
					 values ( <cfqueryparam value="#Arguments.CFid#" 		   	cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#session.Ecodigo#"      		cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Arguments.RHPcodigo#"       cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#Arguments.RHPdescripcion#"  cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#Arguments.Dcodigo#"         cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Arguments.Ocodigo#"         cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Arguments.RHPpuesto#"       cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#Arguments.CFidconta#" 		cfsqltype="cf_sql_numeric">,
							  <cfif isdefined("Arguments.RHPactiva") and Arguments.RHPactiva EQ TRUE>1<cfelse>0</cfif>,
  							  <cfqueryparam value="#Arguments.IDInterfaz#" 		cfsqltype="cf_sql_numeric" null="#Arguments.IDInterfaz EQ 0#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">									
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Plazas">
			<!--- Crea una Plaza Presupuestaria y la asocia a la plaza de RH creada --->
			<!--- 1. Obtiene la moneda de la empresa --->
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="obtenerMoneda" returnvariable="vMcodigo">
				<cfinvokeargument name="DSN" value="#session.DSN#">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
			</cfinvoke>
			<!--- 2. Inserta la plaza presupuestaria  --->
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarPlaza" returnvariable="vRHPPid">
				<cfinvokeargument name="DSN" value="#session.DSN#">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
				<cfinvokeargument name="RHPPcodigo" value="#Arguments.RHPcodigo#">
				<cfinvokeargument name="RHPPdescripcion" value="#Arguments.RHPdescripcion#">
				<cfinvokeargument name="BMUsucodigo"	value="#session.Usucodigo#">
			</cfinvoke>
			<!--- 3. Asocia la plaza presupuestaria a la plaza de RH --->
			<cfquery datasource="#session.DSN#">
				update RHPlazas
				set RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">
				and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Plazas.identity#">
			</cfquery>
			<!--- 4. Crea un registro de la linea del Tiempo para la plaza presupuestaria --->
			<cfset fechamax = CreateDate(6100, 01, 01)>
			<cfquery datasource="#session.DSN#">
				insert into RHLineaTiempoPlaza( Ecodigo,
												RHPPid,
												RHCid,
												RHMPPid,
												RHTTid,
												RHMPid,
												RHPid,	
												CFidautorizado,
												RHLTPfdesde,
												RHLTPfhasta,
												CFcentrocostoaut,
												RHMPestadoplaza,
												RHMPnegociado,
												RHLTPmonto,
												Mcodigo,
												BMfecha,
												BMUsucodigo )
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">,
						null,
						null,
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Plazas.identity#">,
						<cfqueryparam value="#Arguments.CFid#" cfsqltype="cf_sql_numeric">,
						<cfif isdefined("Arguments.LTfecha") and len(trim(Arguments.LTfecha))>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.LTfecha)#">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechamax#">,
						<cfqueryparam value="#Arguments.CFid#" cfsqltype="cf_sql_numeric">,
						'A',
						'T',
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
			</cfquery>
		</cftransaction>
		<cfif isDefined("Arguments.RHPresponsable") and Arguments.RHPresponsable> 
			<cfset marcarResponsableCF(Arguments.CFid,ABC_Plazas.identity)>
		<cfelse>
			<cfset desmarcarResponsableCF(Arguments.CFid,ABC_Plazas.identity)>
		</cfif>
		<cfreturn ABC_Plazas.identity>
	</cffunction>
	
	<cffunction name="Cambio" access="public">
		<cfargument  name="RHPid" 			type="numeric" 	required="yes">
		<cfargument  name="RHPPid" 			type="numeric" 	required="yes">
		<cfargument  name="RHLTPid"			type="numeric" 	required="yes">
		<cfargument  name="CFid" 			type="numeric" 	required="yes">
		<cfargument  name="RHPcodigo" 		type="string" 	required="yes">
		<cfargument  name="RHPdescripcion" 	type="string" 	required="yes">
		<cfargument  name="Dcodigo" 		type="numeric" 	required="yes">
		<cfargument  name="Ocodigo" 		type="numeric" 	required="yes">
		<cfargument  name="RHPpuesto" 		type="string" 	required="yes">
		<cfargument  name="CFidconta" 		type="numeric" 	required="no" 	default="#Arguments.CFid#">
		<cfargument  name="RHPactiva" 		type="boolean" 	required="no" 	default="false">
		<cfargument  name="RHPresponsable" 	type="boolean" 	required="no" 	default="false">
		<cfargument  name="LTfecha" 		type="Date" 	required="no">
		
		<cftransaction>
		
		<cfquery datasource="#session.DSN#">
			update RHPlazas
			set RHPcodigo = <cfqueryparam value="#Arguments.RHPcodigo#"    cfsqltype="cf_sql_char">, 
				RHPdescripcion = <cfqueryparam value="#Arguments.RHPdescripcion#"    cfsqltype="cf_sql_varchar">, 
				Dcodigo = <cfqueryparam value="#Arguments.Dcodigo#" cfsqltype="cf_sql_integer">, 
				Ocodigo = <cfqueryparam value="#Arguments.Ocodigo#" cfsqltype="cf_sql_integer">,
				RHPpuesto = <cfqueryparam value="#Arguments.RHPpuesto#" cfsqltype="cf_sql_char">,
				CFidconta = <cfqueryparam value="#Arguments.CFidconta#" cfsqltype="cf_sql_numeric">,
				RHPactiva = <cfif isdefined("Arguments.RHPactiva") and Arguments.RHPactiva EQ TRUE>1<cfelse>0</cfif>
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHPid =  <cfqueryparam value="#Arguments.RHPid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfif isdefined("Arguments.RHPPid") and len(trim(Arguments.RHPPid))>
			<cfquery datasource="#session.DSN#">
				update RHPlazaPresupuestaria
				set RHPPcodigo = <cfqueryparam value="#Arguments.RHPcodigo#"    cfsqltype="cf_sql_char">, 
					RHPPdescripcion = <cfqueryparam value="#Arguments.RHPdescripcion#"    cfsqltype="cf_sql_varchar">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPPid =  <cfqueryparam value="#Arguments.RHPPid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>
		
		<cfif isdefined("Arguments.RHLTPid") and len(trim(Arguments.RHLTPid))>
			<cfquery datasource="#session.DSN#">
				update RHLineaTiempoPlaza
				set RHLTPfdesde = <cfif isdefined("Arguments.LTfecha") and len(trim(Arguments.LTfecha))>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Arguments.LTfecha)#">
								  <cfelse>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								  </cfif>
				where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLTPid#">
			</cfquery>
		</cfif>
		
		</cftransaction>
		
		<cfif isDefined("Arguments.RHPresponsable") and Arguments.RHPresponsable> 
			<cfset marcarResponsableCF(Arguments.CFid,Arguments.RHPid)>
		<cfelse>
			<cfset desmarcarResponsableCF(Arguments.CFid,Arguments.RHPid)>
		</cfif>
	</cffunction>
	
	<!--- Función para reasignar la plaza responsable del centro funcional --->
	<cffunction name="marcarResponsableCF" access="public" returntype="void">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="RHPid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			<!--- Asignar esta plaza como responsable del Centro Funcional --->
			update CFuncional set 
				RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPid#">
				, CFuresponsable = null <!--- si se asgina una plaza responsable debe desasignar el 
										usuario responsable --->
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		</cfquery>
	</cffunction>
	
	<!--- Función para desmarcar la plaza responsable del centro funcional --->
	<cffunction name="desmarcarResponsableCF" access="public" returntype="void">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="RHPid" type="numeric" required="yes">
		<cfquery datasource="#session.DSN#">
			<!--- Desdasignar esta plaza como responsable del Centro Funcional --->
			update CFuncional set 
				RHPid = null
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
			  and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPid#">
		</cfquery>
	</cffunction>
</cfcomponent>