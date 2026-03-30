<cfcomponent>
	
	<cffunction name="obtenerPuestoRH" access="public" output="true" returntype="string">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPPid" type="string" required="yes">

		<cfset puesto = '' >
		<cfif len(arguments.RHMPPid) gt 0 >
			<cfquery name="rsPuesto" datasource="#session.DSN#">
				select min(RHPcodigo) as codigo
				from RHPuestos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#">
			</cfquery>
			<cfset puesto = rsPuesto.codigo >
		</cfif>
		<cfif len(trim(puesto)) is 0 >
			<cfquery name="rsPuesto" datasource="#session.DSN#">
				select min(RHPcodigo) as codigo
				from RHPuestos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfset puesto = rsPuesto.codigo >
		</cfif>
		<cfif len(trim(puesto)) is 0  >
			<cfquery name="rsError" datasource="#session.DSN#">
				select RHMPPcodigo as codigo, RHMPPdescripcion as descripcion
				from RHMaestroPuestoP
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and RHMPPid = <cfif len(arguments.RHMPPid) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPPid#"><cfelse>0</cfif>
			</cfquery>
			<cfif rsError.recordcount gt 0 >
				<cfthrow message="No se han asociado puestos (RH) al puesto maestro #trim(rsError.codigo)# - #trim(rsError.descripcion)#." >
			<cfelse>
				<cfthrow message="No se han definido puestos para Recursos Humanos." >
			</cfif>
		</cfif>			
		<cfreturn puesto >		
	</cffunction>

	<cffunction name="obtenerPlazaRH" access="public" output="true" returntype="query">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHPPid" type="numeric" required="yes">

		<!--- Plazas asociadas a la plaza presupuestaria --->
		<!--- Se supone que esta relacion es 1:1, pero puede ser 1:N --->
		<!--- Cuando es 1:N, solo una puede estar activa, las demas inactivas --->
		<!--- Este select esta ordenado de manera que cuando es 1:N, la plaza activa
			  quede de primera, para sacar un copia en el centro funcional nuevo --->
		<cfquery name="plazas" datasource="#arguments.conexion#">
			select RHPid
			from RHPlazas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#">
			order by RHPactiva desc
		</cfquery>
		<cfreturn plazas >
	</cffunction>

	<!--- RESULTADO
		  Inserta un registro en la linea del tiempo a partir de un movimiento de plaza.
		  Devuelve el id de Linea de Tiempo insertado.
		  *** Ver si es la mejor opcion hacerlo asi, pues es un insert/select
	--->
	<cffunction name="insertaLineaTiempo" access="public" output="true" returntype="numeric">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="RHPid" type="numeric" required="yes">		
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="debug" type="boolean" required="no" default="false">

		<cfquery name="ltplaza" datasource="#Arguments.conexion#">
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


			select  Ecodigo,
					RHPPid,
					RHCid,
					RHMPPid,
					RHTTid,
					RHMPid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPid#">,
					CFidnuevo,
					RHMPfdesde,
					coalesce(RHMPfhasta, '61000101'),
					CFidcostonuevo,
					RHMPestadoplaza,
					RHMPnegociado,
					RHMPmonto,
					Mcodigo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">

			from RHMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
			<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.conexion#" name="ltplaza" verificar_transaccion="no">

		<cfreturn ltplaza.identity >
	</cffunction>	

	<!--- RESULTADO
		  Inserta componentes en la linea del tiempo para un movimiento especifico.
		  *** Ver si es la mejor opcion hacerlo asi, pues es un insert/select
	--->
	<cffunction name="insertaComponentesLT" access="public" output="true" >
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="LTPid" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="RHMPid" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="debug" type="boolean" required="no" default="false">
	
		<cfquery datasource="#Arguments.conexion#">
			insert RHCLTPlaza( RHLTPid, 
							   CSid, 
							   Ecodigo, 
							   Cantidad, 
							   Monto, 
							   CFformato, 
							   BMfecha, 
							   BMUsucodigo )
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.LTPid#">,
				   CSid, 
				   Ecodigo, 
				   coalesce(Cantidad, 0), 
				   Monto, 
				   CFformato, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
			from RHCMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
			  and Monto != 0.00
		</cfquery>
	</cffunction>

	<!--- RESULTADO
			Devuelve un query con las plazas y personas vigentes para una plaza presupuestaria 
			en el intervalo de tiempo de un movimiento.
	--->
	<cffunction name="plazasActivas" access="public" output="true" returntype="query">
		<cfargument name="conexion"  		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 	 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHPPid" 	 		type="numeric" 	required="yes">
		<cfargument name="desde" 	 		type="date" 	required="yes">
		<cfargument name="hasta" 	 		type="date" 	required="no" default="#createdate(6100,01,01)#">
		<cfargument name="mostrarcesados"  	type="boolean" 	required="no" default="true">
		<cfargument name="Usucodigo" 		type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="debug" 	 		type="boolean" 	required="no" default="false">

		<cfquery name="plazas" datasource="#arguments.conexion#">
			select 	p.RHPcodigo, 
				   	p.RHPdescripcion,  
				   	de.DEidentificacion,
				   	de.DEnombre, 
				   	de.DEapellido1, 
				   	de.DEapellido2,
					lt.LTid,
					lt.DEid, 
					lt.Tcodigo, 
					lt.RHTid, 
					lt.RHPid, 
					lt.RHPcodigo as RHPpuesto, 
					lt.RVid, 
					lt.RHJid, 
					lt.RHCPlinea, 
					lt.LTdesde, 
					lt.LThasta, 
					lt.LTporcplaza, 
					lt.LTsalario, 
					lt.LTporcsal, 
					lt.CPid, 
					lt.IEid, 
					lt.TEid, 
					lt.Mcodigo				   
			
			from RHPlazaPresupuestaria pp
						
			inner join RHPlazas p
			on p.RHPPid=pp.RHPPid
				
			inner join LineaTiempo lt
			on lt.RHPid = p.RHPid
						
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.desde#"> <= lt.LThasta
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.hasta#"> >= lt.LTdesde
						
			inner join DatosEmpleado de
			on de.DEid = lt.DEid
						
			where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and pp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPPid#">

			<cfif not arguments.mostrarcesados >
			  and not exists(	select 1
								from LineaTiempo lt2
				
								inner join RHTipoAccion ta
								on ta.RHTid=lt2.RHTid
								and RHTcomportam = 2
				
								where lt2.DEid = lt.DEid
				
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.desde#"> <= lt2.LThasta
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.hasta#"> >= lt2.LTdesde )
			</cfif>								
			
			order by de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, lt.LTdesde
		</cfquery>

		<cfreturn plazas >
	</cffunction>

	<!--- RESULTADO:
		  Obtiene la cuenta de presupuesto para cada uno de los componentes de la Plaza Presupuestaria, en 
		  el registro insertado en su linea del tiempo.
	--->
	<cffunction name="obtenerCuenta" access="public" output="true" >
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHLTPid" type="numeric" required="yes">
		<cfargument name="RHPPid" type="numeric" required="yes">
		<cfargument name="RHMPPid" type="string" required="no">
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="debug" type="boolean" required="no" default="false">

		<!--- 1. Version Base de datos con Java --->
		<!--- 1.1 Cambio de ? --->
		<cfquery datasource="#arguments.conexion#">
			update RHCLTPlaza 
			set CFformato = CGAplicarMascara(cf.CFcuentac,cs.CScomplemento) 
			
			from RHCLTPlaza a
			
			inner join ComponentesSalariales cs
			on cs.CSid=a.CSid
			
			inner join RHLineaTiempoPlaza b
			on b.RHLTPid=a.RHLTPid
			
			inner join CFuncional cf
			on cf.CFid=b.CFidautorizado
			
			where a.RHLTPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>	

		<!--- 1.2 Cambio de * --->
		<cfquery datasource="#arguments.conexion#">
			update RHCLTPlaza 
			set CFformato = CGAplicarMascara2(a.CFformato, pp.Complemento, '*') 
			
			from RHCLTPlaza a
			
			inner join RHLineaTiempoPlaza b
			on b.RHLTPid=a.RHLTPid
			
			inner join RHPlazaPresupuestaria pp
			on pp.RHPPid=b.RHPPid
			
			where a.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>	
		
		<!--- 1.3 Cambio de ! --->
		<cfquery datasource="#arguments.conexion#">
			update RHCLTPlaza 
			set CFformato = CGAplicarMascara2(a.CFformato, mp.Complemento, '!')
			
			from RHCLTPlaza a
			
			inner join RHLineaTiempoPlaza b
			on b.RHLTPid=a.RHLTPid
			
			inner join RHMaestroPuestoP mp
			on mp.RHMPPid=b.RHMPPid
			
			where a.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>	
		
		<!--- 1.4 Determina el CPcuenta asociado al CFformato --->
		<!---
		<cfquery name="componentes" datasource="#arguments.conexion#">
			select distinct CFformato
			from RHCLTPlaza
			where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
		</cfquery>

		<cfloop query="componentes">
			<cfquery name="rsCPFormato" datasource="#arguments.conexion#">
				select CGExtraerNivelesP(a.CFformato,(select PCEMnivelesP
													from  PCEMascaras m
													where m.PCEMid = v.PCEMid)) as CPformato
				from RHCLTPlaza a
				
				inner join RHLineaTiempoPlaza b
				on b.RHLTPid=a.RHLTPid
				
				inner join CPVigencia v
				on  v.Cmayor = substring(a.CFformato,1,4)
				and v.Ecodigo = a.Ecodigo
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between v.CPVdesde and v.CPVhasta
				and charindex('-',a.CFformato)-1 > 0
				
				where a.CFformato is not null
				  and ltrim(rtrim(a.CFformato))!= ''
				  and a.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
				  and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(componentes.CFformato)#">
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>		
			<cfquery name="rsCPcuenta" datasource="#arguments.conexion#">
				select CPcuenta 
				from CPresupuesto 
				where CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsCPFormato.CPformato)#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfif rsCPcuenta.recordcount gt 0 and len(trim(rsCPcuenta.CPcuenta)) >
				<cfquery datasource="#arguments.conexion#">
					update RHCLTPlaza
					set CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPcuenta.CPcuenta#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHLTPid#">
					and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(componentes.CFformato)#">
				</cfquery>
			</cfif>
		</cfloop>
		--->
	</cffunction>

	<!--- RESULTADO:
		  Genera la linea del tiempo para una plaza presupuestaria.
		  Hace lo siguiente (en resumen):
		  		1. Genera cortes en la linea del tiempo.
				2. Genera las Plazas de RH
				3. Genera Acciones de Personal
	--->
	<cffunction name="AplicaMovimientoPlaza" access="public" output="true" returntype="numeric">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHMPid" type="numeric" required="yes">		<!--- Accion en Proceso --->
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="debug" type="boolean" required="no" default="false">


		<!--- Lectura de datos del movimiento --->	
		<cfquery name="data" datasource="#Arguments.conexion#">
			select 	RHMPid,
					RHPPid,
					RHPPcodigo,
					RHPPdescripcion,
					coalesce(RHMPPid, 0) as RHMPPid,
					RHCid,
					RHTTid,
					RHTMid,
					RHMPfdesde,
					RHMPfhasta,
					RHMPnegociado,
					RHMPestadoplaza,
					id_tramite,
					CFidant,
					CFidnuevo,
					CFidcostoant,
					CFidcostonuevo,
					RHTMporcentaje
			from RHMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
		</cfquery>

		<cfif data.recordCount EQ 0>
			<cfthrow message="Error! El movimiento para la plaza no existe.">
			<cfabort>
		</cfif>
		<cfif len(trim(data.RHTMid)) is 0 >
			<cfthrow message="Error! El Tipo de Movimiento no existe.">
			<cfabort>
		</cfif>
		
		<!--- Comportamiento del Movimiento --->
		<cfquery name="dataComp" datasource="#Arguments.conexion#">
			select 	RHTMcodigo, 
					RHTMdescripcion, 
					RHTMcomportamiento, 
					modfechahasta,
					modtabla, 
					modcategoria, 
					modestadoplaza, 
					modcfuncional, 
					modcentrocostos, 
					modcomponentes, 
					modindicador, 
					modpuesto,
					RHTid
			from RHTipoMovimiento
			where RHTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHTMid#">
		</cfquery>	

		<cfif dataComp.recordCount EQ 0>
			<cfthrow message="Error! El Tipo de Movimiento no existe">
			<cfabort>
		</cfif>

		<!--- Variables Globales --->
		<cfset vRHPPid = IIf( len(trim(data.RHPPid)), DE(data.RHPPid), DE(0) ) >
		<cfset vComportamiento = dataComp.RHTMcomportamiento >
		<cfset vLTPid = 0 >
		
		<!--- Quitar las horas de las fechas del movimiento --->
		<cfset LvarTemp = LSDateFormat(data.RHMPfdesde, 'dd/mm/yyyy')>
		<cfset Fdesde = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfif Len(Trim(data.RHMPfhasta))>
			<cfset LvarTemp = LSDateFormat(data.RHMPfhasta, 'dd/mm/yyyy')>
			<cfset Fhasta = CreateDate(ListGetAt(LvarTemp, 3, '/'), ListGetAt(LvarTemp, 2, '/'), ListGetAt(LvarTemp, 1, '/'))>
		<cfelse>
			<cfset Fhasta = CreateDate(6100, 01, 01)>
		</cfif>
		
		<cfif Arguments.debug>
			<cfquery name="rsLTAntes" datasource="#Arguments.conexion#">
				select * 
				from RHLineaTiempoPlaza 
				where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
				order by RHLTPfdesde
			</cfquery>
			<cfdump var="#rsLTAntes#" label="LineaTiempo despues">
		</cfif>
		
		<!--- PROCESO --->

		<!--- ===================================================================== --->
		<!--- CREAR PLAZA PRESUPUESTARIA [COMPORTAMIENTO:10]  --->
		<!--- Para este tipo de comportamiento se debe hacer lo siguiente:
				3. Generar las Plazas de RH (RHPlazas) [pendiente: DE DONDE SE TOMA EL PUESTO?]
			  	1. Crear la Plaza Presupuestaria [completado]
				2. Crear la Linea del Tiempo para la plaza generada. [completado]
		--->
		<!--- ===================================================================== --->
		<cfif vComportamiento EQ 10 >
			<!--- 4. Crea la Plaza para RH (RHPlazas) --->
			<!--- 4.1 Recupera los datos del Centro Funcional --->
			<!--- De donde se toma el RHPpuesto??? --->
			<cfset vRHPid = 0 >
			<cfif len(trim(data.CFidnuevo))>
				<cfquery name="centrof" datasource="#session.DSN#">
					select Dcodigo, Ocodigo
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFidnuevo#">
				</cfquery>
				
				<!--- Puesto RH --->
				<!--- i. Selecciona el min RHPcodigo asociado al Puesto Presupuestario  --->
				<cfset puesto = this.obtenerPuestoRH( arguments.conexion, arguments.Ecodigo, data.RHMPPid ) >
				<cfquery name="plazarh" datasource="#session.DSN#">
					insert into RHPlazas ( Ecodigo, 
										   RHPpuesto, 
										   Dcodigo, 
										   Ocodigo, 
										   CFid, 
										   RHPcodigo,
										   RHPdescripcion,
										   RHPporcentaje )
					values( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#centrof.Dcodigo#" null="#len(trim(centrof.Dcodigo)) is 0#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#centrof.Ocodigo#" null="#len(trim(centrof.Ocodigo)) is 0#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFidnuevo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.RHPPcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.RHPPdescripcion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHTMporcentaje#"> ) 									   
					<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.conexion#" name="plazarh" verificar_transaccion="no">
				<cfset vRHPid = plazarh.identity >
			</cfif>
			<cfif vRHPid eq 0>
				<cfthrow message="No existen Plazas(RH) asociadas a la Plaza Presupuestaria.">
			</cfif>

			<!--- 1. Inserta Plaza Presupuestaria --->
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarPlaza" returnvariable="rvRHPPid">
				<cfinvokeargument name="DSN" 				value="#arguments.conexion#" >
				<cfinvokeargument name="Ecodigo" 			value="#arguments.Ecodigo#" >
				<cfinvokeargument name="RHPPcodigo" 		value="#data.RHPPcodigo#" >
				<cfinvokeargument name="RHPPdescripcion"	value="#data.RHPPdescripcion#" >
				<cfinvokeargument name="BMUsucodigo"		value="#arguments.Usucodigo#" >
				<cfif len(trim(data.RHMPPid)) and data.RHMPPid neq 0 >
					<cfinvokeargument name="RHMPPid" value="#data.RHMPPid#" >
				</cfif>
			</cfinvoke>
			<cfset vRHPPid = rvRHPPid >
			
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" >
				<cfinvokeargument name="RHMPid"			 value="#arguments.RHMPid#" >
				<cfinvokeargument name="RHPPid" 		 value="#vRHPPid#" >
				<cfinvokeargument name="RHPPcodigo" 	 value="" >
				<cfinvokeargument name="RHPPdescripcion" value="" >
			</cfinvoke>
			
			<!--- Asocia la Plaza Presupuestaria con la Plaza de RH --->
			<cfquery datasource="#session.DSN#">
				update RHPlazas
				set RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
				where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>

			<!--- 2. Inserta Linea de Tiempo para la plaza --->
			<cfset vLTPid = this.insertaLineaTiempo( arguments.conexion, arguments.Ecodigo, arguments.RHMPid, vRHPid, arguments.Usucodigo ) >
			
			<!--- 3. Inserta los componentes asociados al movimiento --->
			<cfset this.insertaComponentesLT( arguments.conexion, arguments.Ecodigo, vLTPid, arguments.RHMPid, arguments.Usucodigo ) >


			<!--- Asocia la plaza creada al Movimiento y pone estado de aprobado --->
			<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" >
				<cfinvokeargument name="RHMPid"			 value="#arguments.RHMPid#" >
				<cfinvokeargument name="RHMPestado" 	 value="A" >
			</cfinvoke>		
			
			<!--- Asocia la Plaza de RH a la Linea del Tiempo de la Plaza Presupuestaria --->
			<!---
			<cfquery datasource="#session.DSN#">
				update RHLineaTiempoPlaza
				set RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#plazarh.identity#">
				where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vLTPid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			--->

			<cfif Arguments.debug>
				<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
					select * 
					from RHLineaTiempoPlaza 
					where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
					order by RHLTPfdesde
				</cfquery>
				<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
			</cfif>

			<cfreturn vRHPPid >
		</cfif>
		<!--- =============================================== --->			

		<!--- ===================================================================== --->
		<!--- MODIFICAR ATRIBUTO DE LA PLAZA PRESUPUESTARIA [COMPORTAMIENTO:20]  --->
		<!--- MODIFICAR ESTADO DE LA PLAZA PRESUPUESTARIA [COMPORTAMIENTO:30]  --->
		<!--- ===================================================================== --->


		<!--- MODIFICAR ESTADO DE LA PLAZA PRESUPUESTARIA [COMPORTAMIENTO:30]  --->
		<!--- Para este tipo de comportamiento se debe validar lo siguiente:
			  	1. Validar la vigencia de empleados en las plazas (RHPlazas) 
				   asociadas a la plaza presupuestaria. Si los hay no se puede
				   aplicar el movimiento.
		--->
		<cfif vComportamiento EQ 30 >
			<cfset validar = this.plazasActivas( arguments.conexion, arguments.Ecodigo, data.RHPPid, fdesde, fhasta, true, arguments.Usucodigo ) >
			<cfif validar.recordcount gt 0>
				<cfset mensaje = IIF( data.RHMPestadoplaza eq 'I', DE('Inactivar'), DE('Congelar') ) >
				<cfthrow message="Error! No se puede #mensaje# la plaza, pues tiene asociados plazas y empleados vigentes.">
			</cfif>
		</cfif>

		<!--- Plazas asociadas a la plaza presupuestaria --->
		<!--- Se supone que esta relacion es 1:1, pero puede ser 1:N --->
		<!--- Cuando es 1:N, solo una puede estar activa, las demas inactivas --->
		<!--- Este select esta ordenado de manera que cuando es 1:N, la plaza activa
			  quede de primera, para sacar un copia en el centro funcional nuevo --->

		<cfset plazas = this.obtenerPlazaRH( arguments.Conexion, arguments.Ecodigo, data.RHPPid ) >
		<cfset vRHPid = plazas.RHPid > <!--- recupera la primer plaza del query, que es la activa --->
		<cfset vPlazas = valuelist(plazas.RHPid) >	

		<cfif  len(vRHPid) is 0>
			<cfthrow message="No existen Plazas(RH) asociadas a la Plaza Presupuestaria.">
		</cfif>

		<!--- Las demás Acciones --->
		<cfquery name="LT1" datasource="#Arguments.conexion#">
			select RHLTPid as id1, RHLTPfdesde as fechatrab1
			from RHLineaTiempoPlaza 
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between RHLTPfdesde and RHLTPfhasta
		</cfquery>
		<cfset id1 = LT1.id1>
		<cfset fechatrab1 = LT1.fechatrab1>
		<!--- Validar que tenga un corte vigente en la Linea del Tiempo --->
		<cfif len(trim(id1)) is 0 or len(trim(fechatrab1)) is 0>
			<cfthrow message="Error! La Plaza Presupuestaria no tiene un corte en la Línea del Tiempo Vigente. Por favor verifique las fechas Desde y Hasta del Movimiento.">
			<cfabort>
		</cfif>

		<cfquery name="LT2" datasource="#Arguments.conexion#">
			select RHLTPid as id2, RHLTPfhasta as fechatrab2
			from RHLineaTiempoPlaza 
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#"> between RHLTPfdesde and RHLTPfhasta
		</cfquery>
		<cfset id2 = LT2.id2>
		<cfset fechatrab2 = LT2.fechatrab2>
		
		<cfif Arguments.debug>
			<cfoutput>fechatrab1: #fechatrab1#</cfoutput><br>
			<cfoutput>fechatrab2: #fechatrab2#</cfoutput><br>
		</cfif>
		
		<!--- Validar que tenga un corte vigente en la Linea del Tiempo --->
		<cfif Len(trim(fechatrab2)) eq 0>
			<cfthrow message="Error! La Plaza Presupuestaria no tiene un corte en la Línea del Tiempo Vigente. Por favor verifique las fechas Desde y Hasta del Movimiento.">
			<cfabort>
		</cfif>

        <!--- Inserta el movimiento final --->
		<cfif Len(fechatrab2) And (DateCompare(fechatrab2, CreateDate(6100, 01, 01)) EQ 0 OR id1 EQ id2)>
			<cfquery name="LTiempo" datasource="#Arguments.conexion#">
				select 1 
				from RHLineaTiempoPlaza a 
				where a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
				and RHLTPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
			</cfquery>
			<cfif LTiempo.recordCount EQ 0>
				<cfquery name="insLineaTiempo2" datasource="#Arguments.conexion#">
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
					select 	Ecodigo,
							RHPPid,
							RHCid,
							RHMPPid,
							RHTTid,
							RHMPid,
							RHPid,
							CFidautorizado,
						   	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">, 
							CFcentrocostoaut,
							RHMPestadoplaza,
							RHMPnegociado,
							RHLTPmonto,
							Mcodigo,
							BMfecha,
							BMUsucodigo
					from RHLineaTiempoPlaza
					where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
					and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
					and RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
					<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo2" verificar_transaccion="no">

				<cfquery name="insDLineaTiempo2" datasource="#Arguments.conexion#">
					insert into RHCLTPlaza( RHLTPid, Ecodigo, CSid, Monto, Cantidad, CFformato, BMfecha, BMUsucodigo )
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insLineaTiempo2.identity#">, 
						b.Ecodigo,
						b.CSid, 
						b.Monto, 
						b.Cantidad, 
						b.CFformato,
						b.BMfecha,
						b.BMUsucodigo
					
					from RHLineaTiempoPlaza a
					
					inner join  RHCLTPlaza b
					on b.RHLTPid = a.RHLTPid
					and b.Monto != 0.00
					
					where a.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
					and a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
					and a.RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
				</cfquery>
			</cfif>
		
        <!--- Actualizo el corte Posterior --->
		<cfelse>
			<cfquery name="updLineaTiempo2" datasource="#Arguments.conexion#">
				update RHLineaTiempoPlaza 
					set RHLTPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#"> 
				where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
				and RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab2#">
				and not exists (
					select 1 
					from RHLineaTiempoPlaza b 
					where b.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
					and b.RHLTPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Fhasta)#">
				)
			</cfquery>
		</cfif>

        <!--- Actualizo el Corte anterior --->
		<cfquery name="updLineaTiempo" datasource="#Arguments.conexion#">
			update RHLineaTiempoPlaza 
				set RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, Fdesde)#">
			where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id1#">
			and RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and RHLTPfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechatrab1#">
		</cfquery>

        <!--- Borrar La linea del Tiempo que esta dentro del tiempo de la Accion --->
        <!--- Borra Detalles --->
		<cfquery name="updDLineaTiempo" datasource="#Arguments.conexion#">
			delete RHCLTPlaza
			where exists (
				select 1
				from RHLineaTiempoPlaza a
				where a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
				and a.RHLTPfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
				and a.RHLTPfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
				and a.RHLTPid = RHCLTPlaza.RHLTPid
			)
		</cfquery>
              
        <!--- Borra la Linea --->
		<cfquery name="delLTiempo" datasource="#Arguments.conexion#">
			delete RHLineaTiempoPlaza
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and RHLTPfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			and RHLTPfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
		</cfquery>

        <!--- Inserto el movimiento en la Linea de Tiempo --->
		<cfquery name="insLineaTiempo3" datasource="#Arguments.conexion#">
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
			select 	Ecodigo,
					RHPPid,
					RHCid,
					RHMPPid,
					RHTTid,
					RHMPid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPid#">,
					CFidnuevo,
					RHMPfdesde,
					coalesce(RHMPfhasta, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">),
					CFidcostonuevo,
					RHMPestadoplaza,
					RHMPnegociado,
					RHMPmonto,
					Mcodigo,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">			
			from RHMovPlaza
			where RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHMPid#">
			<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.conexion#" name="insLineaTiempo3" verificar_transaccion="no">
		<cfset vRHLTPid = insLineaTiempo3.identity >

		<cfquery name="insDLineaTiempo3" datasource="#Arguments.conexion#">
			insert into RHCLTPlaza( RHLTPid, Ecodigo, CSid, Monto, Cantidad, CFformato, BMfecha, BMUsucodigo )
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHLTPid#">,
				   a.Ecodigo,
				   a.CSid, 
				   a.Monto,
				   coalesce(a.Cantidad, 0),
				   a.CFformato,
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
			from RHCMovPlaza a
			
			inner join ComponentesSalariales cs
			on cs.CSid = a.CSid
			
			where a.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHMPid#">
			  and a.Monto != 0.00
		</cfquery>

    	<!--- borrar el registro infinito cuando se genera otro corte infinito --->
		<cfquery name="chkLTiempo" datasource="#Arguments.conexion#">
    		select 1 
    		from RHLineaTiempoPlaza a
    		where a.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and a.RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			and a.RHLTPid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
		</cfquery>

		<cfif DateCompare(fechatrab2, CreateDate(6100, 01, 01)) EQ 0 and chkLTiempo.recordCount>
			<cfquery name="chkLTiempo2" datasource="#Arguments.conexion#">
				select 1
				from RHLineaTiempoPlaza
				where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				and RHLTPfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">
			</cfquery>
			<cfif chkLTiempo2.recordCount>
				<cfquery name="delDLineaTiempo" datasource="#Arguments.conexion#">
                    delete RHCLTPlaza
                    where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				</cfquery>
				<cfquery name="delLineaTiempo" datasource="#Arguments.conexion#">
                    delete RHLineaTiempoPlaza
                    where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id2#">
				</cfquery>
			</cfif>
		</cfif>

		<cfif Arguments.debug>
			<cfquery name="rsLTDespues" datasource="#Arguments.conexion#">
				select * 
				from RHLineaTiempoPlaza 
				where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
				order by RHLTPfdesde
			</cfquery>
			<cfdump var="#rsLTDespues#" label="LineaTiempo Final">
			<cfabort>		
		</cfif>
		
		<!--- ================================================================================== --->
		<!--- ACCIONES DE PERSONAL --->
		<!--- ================================================================================== --->		
		<cfif dataComp.modcfuncional eq 1 >
			<cfif not len(trim(dataComp.RHTid)) >
				<cfthrow message="Error! No se ha definido el tipo de acci&oacute;n que va a generar la aplicaci&oacute;n del movimiento.<br /> Por favor revise la configuraci&oacute;n del tipo de movimiento.">
			</cfif>
			
			
			<cfif len(trim(vPlazas))>	<!--- Plazas Afectadas --->

				<!---================================================================================= --->
				<!--- CAMBIO DE CENTRO FUNCIONAL --->
				<!--- Comportamiento:
						1.	Inactivar plaza de RH
						2.	Crear una plaza identica, para el centro funcional nuevo
						3.	Traer las personas que son afectadas por el movimiento.
						4. 	Verificar el porcentaje de ocupacion de la plaza por esos empleados.
							4.1.	Si porcentaje de ocupacion es 100%:
										4.1.1.	Generar la accion, con la nueva plaza y el Ocodigo, Dcodigo del nuevo centro funcional.
							4.2.	Si el porcentaje de ocupacion es menor a 100%:
										4.2.1.	Generar la accion para cada una de las personas con un porcentaje de aplicacion en la 
												plaza con el centro funcional viejo. La accion es con la nueva plaza y el Ocodigo, 
												Dcodigo del nuevo centro funcional.	
				--->
				<!---================================================================================= --->
				<cfif dataComp.modcfuncional eq 1 > <!--- CAMBIA CENTRO FUNCIONAL --->
					<!--- 1. Inactivar plaza de RH --->
					<cfquery datasource="#arguments.conexion#">
						update RHPlazas
						set RHPactiva = 0
						where RHPid in (#vPlazas#)
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#" >
					</cfquery>
					
					<!--- 2. Crear una plaza identica, para el centro funcional nuevo --->
					<!--- 2.1 Recupera el Dcodigo y Ocodigo del nuevo centro funcional --->
					<cfquery name="datacf" datasource="#arguments.conexion#">
						select Dcodigo, Ocodigo
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#" >
						  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFidnuevo#">
					</cfquery>
					
					<!--- 2.2 Inserta la plaza con el nuevo centro funcional --->
					<cfquery name="plazanueva" datasource="#arguments.conexion#">
						insert into RHPlazas( Ecodigo, 
											  RHPpuesto, 
											  Dcodigo, 
											  Ocodigo, 
											  CFid, 
											  RHPPid, 
											  RHPdescripcion, 
											  RHPcodigo, 
											  RHPactiva, 
											  BMUsucodigo )
						select Ecodigo, 
							   RHPpuesto, 
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#datacf.Dcodigo#">, 
							   <cfqueryparam cfsqltype="cf_sql_integer" value="#datacf.Ocodigo#">,
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFidnuevo#">, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">,
							   RHPdescripcion, 
							   RHPcodigo, 
							   1, 
							   BMUsucodigo
						from RHPlazas
						where RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#" >
						<cf_dbidentity1 datasource="#Arguments.conexion#" verificar_transaccion="no">
					</cfquery>
					<cf_dbidentity2 datasource="#Arguments.conexion#" name="plazanueva" verificar_transaccion="no">
					
					<!--- 2.3 Asocia al registro de la linea del tiempo [vRHLTPid] a la plaza creada --->
					<cfquery datasource="#session.DSN#">
						update RHLineaTiempoPlaza
						set RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#plazanueva.identity#">
						where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHLTPid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					</cfquery>
	
					<!--- 3. Genera las Acciones: --->
					<!--- Debe ser una accion con la nueva plaza generada y Dcodigo|Ocodigo del nuevo centro funcional --->
					<!---<cfset dataAccion = plazasActivas( arguments.conexion, arguments.Ecodigo, data.RHPPid, fdesde, fhasta, false, arguments.Usucodigo ) >--->
					
					<!--- ENCABEZADO DE LA ACCION --->
					<!--- Este query en buena teoria no deberia tener muchos registros, pues una plaza presupuestaria la tiene
						  solo una persona, salvo en el caso cuando es porcentaje compartido y que igual no deberian ser muchos.	
					 --->

					<cfquery datasource="#arguments.conexion#" name="accion">
						insert into RHAcciones( DEid, 
												RHTid, 
												Ecodigo, 
												Tcodigo, 
												RVid, 
												RHJid, 
												RHMPid, 
												RHCPlinea, 
												Dcodigo, 
												Ocodigo, 
												RHPid, 
												RHPcodigo, 
												DLfvigencia, 
												DLffin, 
												DLsalario, 
												Usucodigo, 
												Ulocalizacion, 
												RHAporc, 
												RHAporcsal, 
												IEid, 
												TEid, 
												Mcodigo, 
												Indicador_de_Negociado )
						select 	lt.DEid, 
								lt.RHTid, 
								lt.Ecodigo, 
								lt.Tcodigo, 
								lt.RVid, 
								lt.RHJid, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">,
								lt.RHCPlinea, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#datacf.Dcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#datacf.Ocodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPid#">, 
								lt.RHPcodigo, 
								case when lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#"> then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#"> else lt.LTdesde end,
								case when lt.LThasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#"> then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#"> else lt.LThasta end,
								lt.LTsalario, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								'00', 
								lt.LTporcplaza, 
								lt.LTporcsal, 
								lt.IEid, 
								lt.TEid, 
								lt.Mcodigo, 
								case when mp.RHMPnegociado = 'N' then 1 else 0 end
								
						from LineaTiempo lt
						
						inner join RHPlazas p
						on p.RHPid = lt.RHPid
						and p.Ecodigo = lt.Ecodigo
						--and p.RHPactiva = 1
						
						inner join RHPlazaPresupuestaria pp
						on pp.RHPPid = p.RHPPid
						and pp.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
						
						inner join RHMovPlaza mp
						on mp.RHPPid = pp.RHPPid
						and mp.RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
						
						where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fdesde#"> <= lt.LThasta
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fhasta#"> >= lt.LTdesde
						
						order by lt.DEid, lt.LTdesde
					</cfquery>
						
					<cfquery datasource="#arguments.conexion#" >
						insert into RHDAcciones( RHAlinea, 
												 CSid, 
												 RHDAunidad, 
												 RHDAmontobase, 
												 RHDAmontores, 
												 Usucodigo, 
												 Ulocalizacion, 
												 BMUsucodigo )

						select a.RHAlinea, 
							   dlt.CSid, 
							   dlt.DLTunidades, 
							   dlt.DLTmonto, 
							   0, 
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							   '00',
							   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						from DLineaTiempo dlt
						
						inner join LineaTiempo lt
						on lt.LTid = dlt.LTid
						
						inner join RHAcciones a
						on a.DEid=lt.DEid
						and RHMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPid#">
						and a.DLfvigencia between lt.LTdesde and lt.LThasta
					</cfquery>
				</cfif> <!--- CAMBIA CENTRO FUNCIONAL --->
			</cfif> <!--- Plazas Afectadas --->
			<!---================================================================================= --->		
		</cfif>
		
		<!--- ==================================================================================== --->
		<!--- Calculo del CPcuenta para los componentes del movimiento insertado en la Linea del Tiempo --->
		<!--- ==================================================================================== --->
		<!--- 1. Version Base de datos con Java --->
		<cfset obtenerCuenta( arguments.conexion, arguments.Ecodigo, vRHLTPid, data.RHPPid, data.RHMPPid ) >
		
		<!--- 2. Version componente ColdFusion --->
		<!---
		<cfobject component="sif.Componentes.AplicarMascara" name="Obj_CFormato">		
		<cfquery name="componentes" datasource="#arguments.conexion#">
			select b.RHCLTPid, b.CSid, cf.CFcuentac
			from RHCLTPlaza b

			inner join RHLineaTiempoPlaza a
			on a.RHLTPid=b.RHLTPid
			
			inner join CFuncional cf
			on cf.CFid = a.CFidautorizado
			
			where b.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHLTPid#">
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfquery name="PPcomplemento" datasource="#arguments.conexion#">
			select Complemento
			from RHPlazaPresupuestaria
			where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHPPid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfquery name="MPcomplemento" datasource="#arguments.conexion#">
			select Complemento
			from RHMaestroPuestoP
			where RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.RHMPPid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfif len(trim( componentes.CFcuentac )) > <!--- es el mismo para todos los componentes, por eso se hace fuera del loop --->
			<cfloop query="componentes"	>
				<cfset vCFformato =''>
				<cfset vCPformato = '' > 
				<!---Sustituye el comodín ? ---->
				<cfquery name="CScomplemento" datasource="#arguments.conexion#">
					select CScomplemento as complemento
					from ComponentesSalariales
					where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#componentes.CSid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
				<cfset vCFformato = Obj_CFormato.AplicarMascara(componentes.CFcuentac, trim(CScomplemento.complemento) )>
				<!---Sustituye el comodín * ---->
				<cfset vCFformato = Obj_CFormato.AplicarMascara(vCFformato, trim(PPcomplemento.Complemento),'*')>
				<!---Sustituye el comodín ! ---->
				<cfset vCFformato = Obj_CFormato.AplicarMascara(vCFformato, trim(MPcomplemento.Complemento),'!')>
				
				<!----///////////////// PARA PRESUPUESTO /////////////////////////----->
				<cfif len(trim(vCFformato))>			
					<cfset vn_posicionInicial = Find('-', vCFformato,0)><!---Posicion del primer - que separa la cuenta de mayor--->
					<cfif vn_posicionInicial NEQ 0>
						<cfset vs_cuentaMayor = Mid(vCFformato, 1, vn_posicionInicial-1)><!----Separar la cuenta de mayor del CFformato---->
						<cfif FindOneOf('*?!',vs_cuentaMayor,1) EQ 0><!---Si no se encontro ningun caracter de comodin en la cuenta mayor---->
							<cfquery name="rsNiveles" datasource="#session.DSN#">
								select PCEMnivelesP
								from CPVigencia vig
									inner join PCEMascaras mas
									 on	mas.PCEMid = vig.PCEMid
								where vig.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vs_cuentaMayor#">
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between CPVdesde and CPVhasta
							</cfquery>
	
							<cfif isdefined("rsNiveles") and rsNiveles.RecordCount neq 0 and len(trim(rsNiveles.PCEMnivelesP))>
								<cfset vCPformato = Obj_CFormato.ExtraerNivelesP(vCFformato, rsNiveles.PCEMnivelesP)>
							</cfif>
						</cfif>
					</cfif>
				</cfif>	
				
				<cfquery name="rsCPcuenta" datasource="#arguments.conexion#">
					select CPcuenta 
					from CPresupuesto 
					where CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(vCPformato)#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
				<cfquery datasource="#arguments.conexion#">
					update RHCLTPlaza
					set CPcuenta = <cfif len(trim(rsCPcuenta.CPcuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPcuenta.CPcuenta#"><cfelse>null</cfif>,
						CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(vCFformato)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					  and RHCLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#componentes.RHCLTPid#">
				</cfquery>
			</cfloop>
		</cfif>
		--->
		
		<!--- ==================================================================================== --->

		<!--- Pone estado de aprobado al movimiento --->
		<cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="modificarMovimiento" >
			<cfinvokeargument name="RHMPid"			 value="#arguments.RHMPid#" >
			<cfinvokeargument name="RHMPestado" 	 value="A" >
		</cfinvoke>			

		<cfreturn data.RHPPid >
	</cffunction>
</cfcomponent>
