<cfcomponent>
	<!--- =========================================== --->
	<!--- SECCION PARA GENERACION DE ASIENTO CONTABLE --->
	<!--- =========================================== --->
	<!---
	NOTA IMPORTANTE:  OJO:
		PARA PODER LLAMAR AL PlanPagos HAY QUE CREAR LA TABLA TEMPORAL INTARC
		USANDO LA FUNCION CreaIntarc del GeneraAsiento , NO SE VALE CREARLA A PATA.
	--->	
	<cffunction name="obtenerPeriodo" returntype="numeric">
		<cfargument name="empresa" required="yes" default="#session.Ecodigo#">
		<!--- Periodo auxiliar --->
		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			  and Pcodigo = 50
		</cfquery>
		<cfif rsPeriodo.recordCount gt 0 and len(trim(rsPeriodo.Pvalor))>
			<cfreturn rsPeriodo.Pvalor >
		<cfelse>
			<cf_errorCode	code = "50966" msg = "El período para auxiliares no está definido.">
		</cfif>
	</cffunction> 

	<cffunction name="obtenerMes" returntype="numeric">
		<cfargument name="empresa" required="yes" default="#session.Ecodigo#">
		<!--- Periodo auxiliar --->
		<cfquery name="rsMes" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			  and Pcodigo = 60
		</cfquery>
		<cfif rsMes.recordCount gt 0 and len(trim(rsMes.Pvalor))>
			<cfreturn rsMes.Pvalor >
		<cfelse>
			<cf_errorCode	code = "50967" msg = "El mes para auxiliares no está definido.">
		</cfif>
	</cffunction> 

	<cffunction name="obtenerOficina" returntype="numeric">
		<cfargument name="empresa" required="yes" default="#session.DSN#">
		<cfargument name="DEid"    required="yes" >

		<!--- Oficina del empleado, segun Centro Funcional --->
		<cfquery name="rsCF" datasource="#session.DSN#">
			select c.Ocodigo
			from LineaTiempo a
		
			inner join RHPlazas b
				on b.RHPid = a.RHPid
				and b.Ecodigo = a.Ecodigo
			
			inner join CFuncional c
				on c.CFid = b.CFid
				and c.Ecodigo = b.Ecodigo
			
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between a.LTdesde and a.LThasta
		</cfquery>
		
		<!--- Si el empleado está cesado, buscar la ultima oficina en la cual estaba --->
		<cfif rsCF.recordCount EQ 0>
			<cfquery name="rsCF" datasource="#Session.DSN#">
				select c.Ocodigo
				from LineaTiempo a
			
				inner join RHPlazas b
					on b.RHPid = a.RHPid
					and b.Ecodigo = a.Ecodigo
				
				inner join CFuncional c
					on c.CFid = b.CFid
					and c.Ecodigo = b.Ecodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				and a.LThasta = (
					select max(x.LThasta)
					from LineaTiempo x
					where x.DEid = a.DEid
					and x.Ecodigo = a.Ecodigo
				)
			</cfquery>
		</cfif>
		
		
		<!---	Comentado por Yu Hui para permitir los pagos de empleados cesados
		<cfif rsCF.recordCount gt 0 and len(trim(rsCF.Ocodigo))>
			<cfreturn rsCF.Ocodigo >
		<cfelse>
			<cf_errorCode	code = "50968" msg = "No se ha obtenido la oficina del empleado.">
		</cfif>
		--->
		<cfif isdefined("rsCF") and rsCF.recordCount NEQ 0>
			<cfreturn rsCF.Ocodigo>
		<cfelse>
			<cf_errorCode	code = "50968" msg = "No se ha obtenido la oficina del empleado.">
		</cfif>
	</cffunction> 

	<cffunction name="obtenerCuentaSocio" returntype="numeric">
		<cfargument name="empresa" 	required="yes" default="#session.Ecodigo#">
		<cfargument name="SNcodigo" required="yes" type="numeric" >

		<cfquery name="rsCuentaSocio" datasource="#session.DSN#">
			select SNcuentacxc as Ccuenta,SNnombre
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
		</cfquery>

		<cfif rsCuentaSocio.recordCount lte 0 or ( isdefined("rsCuentaSocio.Ccuenta") and len(trim(#rsCuentaSocio.Ccuenta#)) eq 0 )>
            <cfthrow message="No ha sido definida la cuenta contable, Cuenta predeterminada para Cuentas por Cobrar del Socio de Negocios:#rsCuentaSocio.SNnombre#">
		<cfelse>
			<cfreturn rsCuentaSocio.Ccuenta >
		</cfif> 
	</cffunction> 
	
	<cffunction name="obtenerCuentaTipo" returntype="numeric">
		<cfargument name="empresa" required="yes" default="#session.Ecodigo#">
		<cfargument name="TDid"    required="yes" type="numeric" >

		<cfquery name="rsCuentaTipo" datasource="#session.DSN#">
			select Ccuenta
			from TDeduccion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empresa#">
			and TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.TDid#">
		</cfquery>
		<cfif rsCuentaTipo.recordCount lte 0 or ( isdefined("rsCuentaTipo.Ccuenta") and len(trim(rsCuentaTipo.Ccuenta)) eq 0 )>
			<cf_errorCode	code = "50201" msg = "No ha sido definida la cuenta contable del Tipo de Deducción.">
		<cfelse>
			<cfreturn rsCuentaTipo.Ccuenta >
		</cfif> 
	</cffunction>

	<cffunction name="insertarINTARC" >
		<cfargument name="empresa" required="yes" default="#session.Ecodigo#">
		<cfargument name="DEid"    type="numeric"   required="yes" >
		<cfargument name="tabla"   type="string" 	required="yes" >
		<cfargument name="INTORI"  type="string" 	required="yes" >
		<cfargument name="INTDOC"  type="string" 	required="yes" >
		<cfargument name="INTREF"  type="string" 	required="yes" >
		<cfargument name="INTMON"  type="numeric" 	required="yes" >
		<cfargument name="INTTIP"  type="string" 	required="yes" >
		<cfargument name="INTDES"  type="string" 	required="yes" >	
		<cfargument name="Ccuenta" type="numeric"	required="yes" >
		<cfargument name="Mcodigo" type="numeric" 	required="yes" >

		<!--- inserta debitos (a cuenta del Socio) --->
		<cfquery datasource="#session.DSN#">
			insert INTO #tabla# ( 	INTORI, <!--- Origen--->
									INTREL, 
									INTDOC, 
									INTREF, 
									INTMON, 
									INTTIP, <!--- D,C--->
									INTDES, 
									INTFEC, 
									INTCAM, 
									Periodo, 
									Mes, 
									Ccuenta, 
									Mcodigo, 
									Ocodigo, 
									INTMOE )
		
			values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.INTORI)#">,									<!--- INTORI --->
					0,																											<!--- INTREL --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INTDOC#">,										<!--- INTDOC --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INTREF#">,										<!--- INTREF --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(arguments.INTMON,',','','all')#">,					<!--- INTMON --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INTTIP#">,										<!--- INTTIP --->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.INTDES#">,										<!--- INTDES --->
					'#DateFormat(now(),'yyyymmdd')#',																			<!--- INTFEC --->
					1,																											<!--- INTCAM --->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#this.obtenerPeriodo(arguments.empresa)#">,					<!--- periodo--->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#this.obtenerMes(arguments.empresa)#">,						<!--- mes	 --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,										<!--- Ccuenta--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,										<!--- Mcodigo--->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#this.obtenerOficina(arguments.empresa, arguments.DEid)#">,	<!--- Oficina --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(arguments.INTMON,',','','all')#">					<!--- INTMON --->
				  )
		</cfquery>
	</cffunction>
	<!--- =========================================== --->
	<!--- =========================================== --->
</cfcomponent>

