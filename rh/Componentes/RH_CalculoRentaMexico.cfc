<cfcomponent>
	<cffunction name="CalculoRentaMexico" access="public" output="true" >
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="IRcodigo" 			type="string" 	required="yes">
		<cfargument name="RCdesde" 				type="date" 	required="yes">
		<cfargument name="RChasta" 				type="date" 	required="yes">


		<!---ljimenez Modificacion para Mexico inicio--->

		<!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
		<cfquery name="rsHija" datasource="#Session.DSN#">
			select *
				from ImpuestoRenta 
				where IRcodigoPadre = '#arguments.IRcodigo#'
		</cfquery>
		<cfif isdefined("rsHija") and rsHija.RecordCount neq 0>
				<!--- 5.1 Calculo del Impuesto sobre la Renta al salario para cuando es de mexico utilizando tabla a 2 niveles. --->
				<!--- Se utiliza la tabla de renta definida en la empresa, de acuerdo con el rango de fechas --->
				
				<cfquery name="rsdag" datasource="#Session.DSN#">
					update SalarioEmpleado 
						set SErenta = SErenta -	coalesce((	select round(a.DIRmontofijo,2)  
													from EImpuestoRenta b, DImpuestoRenta a
													where b.IRcodigo = '#rsHija.IRcodigo#'
														and b.EIRestado > 0
														and a.EIRid = b.EIRid
														and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
														and round(SalarioEmpleado.SEproyectado,2) >= round(a.DIRinf,2)
														and round(SalarioEmpleado.SEproyectado,2) <= round(a.DIRsup,2)), 0.00)
														
					where SalarioEmpleado.RCNid = #arguments.RCNid#
						and SalarioEmpleado.SEcalculado = 0
				</cfquery>
		</cfif>
		<!---ljimenez Modificacion para Mexico final--->
		<cfreturn>	
	</cffunction>
	
	<cffunction name="fnGetProyeccionImpuesto" access="public" returntype="query">
		<cfargument name="IRcodigo"   			type="string" 	required="yes">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfquery name="rsProyeccion" datasource="#Arguments.conexion#">
			select b.EIRid, b.DIRid, b.DIRinf, b.DIRsup, b.DIRporcentaje, coalesce(b.DIRmontofijo,0) as DIRmontofijo, b.ts_rversion, b.DIRporcexc,
				b.DIRmontoexc, b.BMUsucodigo
			from EImpuestoRenta a
				inner join DImpuestoRenta b
					on b.EIRid = a.EIRid 
			where a.IRcodigo = '#Arguments.IRcodigo#'
				and a.EIRestado > 0
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#"> between a.EIRdesde and a.EIRhasta
				and round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Monto#">,2) >= round(b.DIRinf,2)
				and round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Monto#">,2) <= round(b.DIRsup,2)
                and round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Monto#">,2) > 0
		</cfquery>
		<cfreturn #rsProyeccion#>
	</cffunction>
	
	<cffunction name="fnCalculaImpuestoMarginal" access="public" returntype="numeric">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="IRcodigo" 			type="string">
		<cfargument name="SumarCuotaFija" 		type="boolean" default="true">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Monto')>
			<cfset Arguments.Monto = 1>
       	<!--- Al calcular el margen de impuestos el monto debe de ser igual al monto que se indico este no puede ser sobreescrito --->
		<!---<cfelseif Arguments.Monto EQ 0>
			<cfset Arguments.Monto = 1>--->
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.IRcodigo')>
			<cfset Arguments.IRcodigo = fnGetDato(30).Pvalor>	<!--- Impuesto Renta --->
		</cfif>
		<cfset ProyN1 = fnGetProyeccionImpuesto(Arguments.IRcodigo, Arguments.Monto, Arguments.Fecha, Arguments.Conexion)>
       <cfset DIRinf = ProyN1.DIRinf>
        <cfif len(trim(DIRinf)) eq 0>
        	<cfset DIRinf = 0>
        </cfif>
        <cfset DIRporcentaje = ProyN1.DIRporcentaje>
        <cfif len(trim(DIRporcentaje)) eq 0>
        	<cfset DIRporcentaje = 0>
        </cfif>
		<!--- Calculo del Impuesto sobre el Monto --->
		<cfset lvarImpMarginal = (Arguments.Monto - DIRinf) * (DIRporcentaje / 100)>
        <cfset DIRmontofijo = ProyN1.DIRmontofijo>
        <cfif len(trim(DIRmontofijo)) eq 0>
        	<cfset DIRmontofijo = 0>
        </cfif>
		<cfif Arguments.SumarCuotaFija>
			<cfset lvarImpMarginal = lvarImpMarginal + DIRmontofijo>
		</cfif>
		<cfreturn NumberFormat(lvarImpMarginal,'.99')>	
	</cffunction>
	
	<cffunction name="fnCalculaSubsidio" access="public" returntype="numeric">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="IRcodigo" 			type="string">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.IRcodigo')>
			<cfset IRN1 = fnGetDato(30).Pvalor>	<!--- Impuesto Renta --->
			<!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
			<cfquery name="rsHija" datasource="#Session.DSN#">
				select IRcodigo
					from ImpuestoRenta 
					where IRcodigoPadre = '#IRN1.Pvalor#'
			</cfquery>
			<cfif isdefined("rsHija") and rsHija.RecordCount neq 0>
				<cfset Arguments.IRcodigo = rsHija.IRcodigo>
			</cfif>
		</cfif>
		<cfset ProyN2 = fnGetProyeccionImpuesto(Arguments.IRcodigo, Arguments.Monto, Arguments.Fecha, Arguments.Conexion)>
		<cfif len(trim(ProyN2.DIRmontofijo)) eq 0>
			<cfreturn 0>
		</cfif>
		<cfreturn ProyN2.DIRmontofijo>	
	</cffunction>
	
	 <!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
	<cffunction name="fnGetDato" returntype="query" access="private">
		<cfargument name="Pcodigo" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric">	
		<cfargument name="Conexion" type="string">	
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">  
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfreturn #rs#>
	</cffunction>
	
</cfcomponent>

<!----
<cfcomponent>
	<cffunction name="CalculoRentaMexico" access="public" output="true" >
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="IRcodigo" 			type="string" 	required="yes">
		<cfargument name="RCdesde" 				type="date" 	required="yes">
		<cfargument name="RChasta" 				type="date" 	required="yes">


		<!---ljimenez Modificacion para Mexico inicio--->

		<!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
		<cfquery name="rsHija" datasource="#Session.DSN#">
			select *
				from ImpuestoRenta 
				where IRcodigoPadre = '#arguments.IRcodigo#'
		</cfquery>
		<cfif isdefined("rsHija") and rsHija.RecordCount neq 0>
				<!--- 5.1 Calculo del Impuesto sobre la Renta al salario para cuando es de mexico utilizando tabla a 2 niveles. --->
				<!--- Se utiliza la tabla de renta definida en la empresa, de acuerdo con el rango de fechas --->
				
				<cfquery name="rsdag" datasource="#Session.DSN#">
					update SalarioEmpleado 
						set SErenta = SErenta -	coalesce((	select round(a.DIRmontofijo,2)  
													from EImpuestoRenta b, DImpuestoRenta a
													where b.IRcodigo = '#rsHija.IRcodigo#'
														and b.EIRestado > 0
														and a.EIRid = b.EIRid
														and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
														and round(SalarioEmpleado.SEproyectado,2) >= round(a.DIRinf,2)
														and round(SalarioEmpleado.SEproyectado,2) <= round(a.DIRsup,2)), 0.00)
														
					where SalarioEmpleado.RCNid = #arguments.RCNid#
						and SalarioEmpleado.SEcalculado = 0
				</cfquery>
		</cfif>
		<!---ljimenez Modificacion para Mexico final--->
		<cfreturn>	
	</cffunction>
	
	<cffunction name="fnGetProyeccionImpuesto" access="public" returntype="query">
		<cfargument name="IRcodigo"   			type="string" 	required="yes">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="Conexion" 			type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfquery name="rsProyeccion" datasource="#Arguments.conexion#">
			select b.EIRid, b.DIRid, b.DIRinf, b.DIRsup, b.DIRporcentaje, coalesce(b.DIRmontofijo,0) as DIRmontofijo, b.ts_rversion, b.DIRporcexc,
				b.DIRmontoexc, b.BMUsucodigo
			from EImpuestoRenta a
				inner join DImpuestoRenta b
					on b.EIRid = a.EIRid 
			where a.IRcodigo = '#Arguments.IRcodigo#'
				and a.EIRestado > 0
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#"> between a.EIRdesde and a.EIRhasta
				and round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Monto#">,2) >= round(b.DIRinf,2)
				and round(<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.Monto#">,2) <= round(b.DIRsup,2)
		</cfquery>
		<cfreturn rsProyeccion>
	</cffunction>
	
	<cffunction name="fnCalculaImpuestoMarginal" access="public" returntype="numeric">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="IRcodigo" 			type="string">
		<cfargument name="SumarCuotaFija" 		type="boolean" default="true">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Monto')>
			<cfset Arguments.Monto = 1>
		<cfelseif Arguments.Monto EQ 0>
			<cfset Arguments.Monto = 1>
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.IRcodigo')>
			<cfset Arguments.IRcodigo = fnGetDato(30).Pvalor>	<!--- Impuesto Renta --->
		</cfif>
		<cfset ProyN1 = fnGetProyeccionImpuesto(Arguments.IRcodigo, Arguments.Monto, Arguments.Fecha, Arguments.Conexion)>
		<!--- Calculo del Impuesto sobre el Monto --->
		<cfset lvarImpMarginal = (Arguments.Monto - ProyN1.DIRinf) * (ProyN1.DIRporcentaje / 100)>
		<cfif Arguments.SumarCuotaFija>
			<cfset lvarImpMarginal = lvarImpMarginal + ProyN1.DIRmontofijo>
		</cfif>
		<cfreturn NumberFormat(lvarImpMarginal,'.99')>	
	</cffunction>
	
	<cffunction name="fnCalculaSubsidio" access="public" returntype="numeric">
		<cfargument name="Monto" 				type="numeric" 	required="yes">
		<cfargument name="Fecha" 				type="date">
		<cfargument name="IRcodigo" 			type="string">
		<cfargument name="Conexion" 			type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>
		<cfif not isdefined('Arguments.IRcodigo')>
			<cfset IRN1 = fnGetDato(30).Pvalor>	<!--- Impuesto Renta --->
			<!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
			<cfquery name="rsHija" datasource="#Session.DSN#">
				select IRcodigo
					from ImpuestoRenta 
					where IRcodigoPadre = '#IRN1.Pvalor#'
			</cfquery>
			<cfif isdefined("rsHija") and rsHija.RecordCount neq 0>
				<cfset Arguments.IRcodigo = rsHija.IRcodigo>
			</cfif>
		</cfif>
		<cfset ProyN2 = fnGetProyeccionImpuesto(Arguments.IRcodigo, Arguments.Monto, Arguments.Fecha, Arguments.Conexion)>
		<cfif len(trim(ProyN2.DIRmontofijo)) eq 0>
			<cfreturn 0>
		</cfif>
		<cfreturn ProyN2.DIRmontofijo>	
	</cffunction>
	
	 <!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
	<cffunction name="fnGetDato" returntype="query" access="private">
		<cfargument name="Pcodigo" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric">	
		<cfargument name="Conexion" type="string">	
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">  
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfreturn #rs#>
	</cffunction>
	
</cfcomponent>
--->