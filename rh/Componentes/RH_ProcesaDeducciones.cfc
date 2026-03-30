<cfcomponent>
	<cffunction name="ProcesaDeducciones" access="public" output="true" >
		<cfargument name="conexion" 			type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="debug"   				type="boolean" 	required="no" default="false">
		
		<cfset vDEid = ''>
		<cfset vSEliquido = 0 >
		<cfset vTDid = 0 > 
		<cfset vTDprioridad = 0 >
		<cfset vTDcodigo = '' >
		<cfset vTDparcial = 0 >
		<cfset vTDordmonto = 0 >
		<cfset vTDordfecha = 0 >
		<cfset vDid = 0 >
		<cfset vDCvalor = 0 >
		
		<!---CarolRS - Parametro RH de subsidio salario de Mexico --->
		<cfquery datasource="#arguments.conexion#" name="rsDeduccion">	
		select Pvalor as TDid,Pdescripcion  from RHParametros where Pcodigo = 2033 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfquery name="data1" datasource="#arguments.conexion#">
			select a.DEid, a.SEliquido
			from SalarioEmpleado a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.SEcalculado = 0
			  and a.SEliquido < 0.00
		</cfquery>
		
		<cfloop query="data1">
			<cfset vDEid = data1.DEid >
			<cfset vSEliquido = data1.SEliquido >

			<cfquery name="data2" datasource="#arguments.conexion#">
				 select distinct b.TDid, b.TDprioridad, b.TDcodigo, b.TDparcial, b.TDordmonto, b.TDordfecha
				 from DeduccionesCalculo a, DeduccionesEmpleado de, TDeduccion b
				 where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
				   and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				   and de.Did = a.Did
				   and b.TDid = de.TDid
				   and b.TDobligatoria = 0
				order by b.TDprioridad desc
			</cfquery>
			<cfloop query="data2">
				<cfset vTDid = data2.TDid>
				<cfset vTDprioridad = data2.TDprioridad>
				<cfset vTDcodigo = data2.TDcodigo>
				<cfset vTDparcial = data2.TDparcial>
				<cfset vTDordmonto = data2.TDordmonto>
				<cfset vTDordfecha = data2.TDordfecha>
				
				<cfif vTDordmonto eq 1 >
					<cfquery name="data3" datasource="#arguments.conexion#">
						select a.Did, a.DCvalor
						from DeduccionesCalculo a, DeduccionesEmpleado de
						where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
						  and de.Did = a.Did
						  and de.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vTDid#">
						  <cfif isdefined("rsDeduccion.TDid") and len(trim(rsDeduccion.TDid))>
						  and de.TDid  <> #rsDeduccion.TDid#
						  </cfif>
						order by a.DCvalor asc
					</cfquery>
				<cfelseif vTDordmonto eq 2 >
					<cfquery name="data3" datasource="#arguments.conexion#">
						select a.Did, a.DCvalor
						from DeduccionesCalculo a, DeduccionesEmpleado de
						where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
						  and de.Did = a.Did
						  and de.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vTDid#">
						  <cfif isdefined("rsDeduccion.TDid") and len(trim(rsDeduccion.TDid))>
						  and de.TDid <> #rsDeduccion.TDid#
						  </cfif>
						order by a.DCvalor desc
					</cfquery>
				<cfelseif vTDordfecha eq 1 >
					<cfquery name="data3" datasource="#arguments.conexion#">
						select a.Did, a.DCvalor
						from DeduccionesCalculo a, DeduccionesEmpleado de
						where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
						  and de.Did = a.Did
						  and de.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vTDid#">
						  <cfif isdefined("rsDeduccion.TDid") and len(trim(rsDeduccion.TDid))>
						  and de.TDid <> #rsDeduccion.TDid#
						  </cfif>
						order by de.Dfechaini asc
					</cfquery>
				<cfelse>					
					<cfquery name="data3" datasource="#arguments.conexion#">
						select a.Did, a.DCvalor
						from DeduccionesCalculo a, DeduccionesEmpleado de
						where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
						  and de.Did = a.Did
						  and de.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vTDid#">
						  <cfif isdefined("rsDeduccion.TDid") and len(trim(rsDeduccion.TDid))>
						  and de.TDid  <>  #rsDeduccion.TDid#
						  </cfif>
						order by de.Dfechaini desc
					</cfquery>
				</cfif>
				
				
				<cfloop query="data3">
					<cfset vDid = data3.Did >
					<cfset vDCvalor = data3.DCvalor >

					<cfif vTDparcial eq 1 and abs(vSEliquido) lt vDCvalor >
						<cfset vDCvalor = abs(vSEliquido) >
					</cfif>
					<!--- Actualizar el monto de la deduccion en el calculo --->
					<cfquery datasource="#arguments.conexion#">
						update DeduccionesCalculo
						set DCvalor = DCvalor - <cfqueryparam cfsqltype="cf_sql_money" value="#vDCvalor#">
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
						  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDid#">
						  <cfif isdefined("rsDeduccion.TDid") and len(trim(rsDeduccion.TDid))>
						  	and Did not in (Select distinct Did from DeduccionesEmpleado where TDid = #rsDeduccion.TDid#)  
						  </cfif>
					</cfquery>
					
					<!--- Actualizar el monto del Liquido en SalarioEmpleado --->
					<cfquery datasource="#arguments.conexion#">
						update SalarioEmpleado
						set SEdeducciones = SEdeducciones - <cfqueryparam cfsqltype="cf_sql_money" value="#vDCvalor#">, 
							SEliquido = SEliquido + <cfqueryparam cfsqltype="cf_sql_money" value="#vDCvalor#">
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDEid#">
					</cfquery>
					
					<!--- Actualizar el Salario Liquido --->
					<cfset vSEliquido = vSEliquido + vDCvalor >
	
					<cfif vSEliquido gte 0 >
						<!--- El salario liquido es positivo o cero, ya se completo el proceso para el empleado --->
						<cfbreak>
					</cfif>
				</cfloop>
	
	    		<!--- Cuando el salario liquido es positivo o cero, no debe procesarse ninguna otra deduccion --->
				<cfif vSEliquido gte 0 >
					<cfbreak>
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn>
	</cffunction>		
</cfcomponent>