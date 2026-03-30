<cfcomponent>
	<!--- 
		RESULTADO:
		Retorna true si la ventanilla esta abierta, false de lo contrario
	--->
	<cffunction name="esta_abierta" access="public" returntype="query">
		<cfargument name="id_ventanilla" type="numeric" required="yes" >
		
		<!--- cierra las venyanillas inactivas --->
		<cfset this.cerrar_inactivas() >

		<cfquery name="datos" datasource="#session.tramites.dsn#">
			select va.id_ventanilla, va.id_funcionario 
			from TPVentanillaAbierta va
			where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_ventanilla#">
		</cfquery>
		
		<cfreturn datos >
	</cffunction>	

	<!--- 
		RESULTADO:
		Retorna un query con la lista de ventanillas abiertas por sucursal
	--->
	<cffunction name="ventanillas_abiertas" access="public" returntype="query">
		<cfargument name="id_sucursal" type="numeric" required="yes" >
		
		<!--- cierra las venyanillas inactivas --->
		<cfset this.cerrar_inactivas() >

		<cfquery name="datos" datasource="#session.tramites.dsn#">
			select va.id_ventanilla 
			from TPVentanillaAbierta va
			
			inner join TPVentanilla v
			on v.id_ventanilla = va.id_ventanilla
			
			inner join TPSucursal s
			on s.id_sucursal=v.id_sucursal
			and s.id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_sucursal#">
		</cfquery>
		
		<cfreturn datos >
	</cffunction>	

	<!--- 
		RESULTADO:
		Abre una ventanilla (inserta en TPVentanillasAbiertas )
	--->
	<cffunction name="abrir" access="public">
		<cfargument name="id_funcionario"  type="numeric" required="yes">
		<cfargument name="id_ventanilla" type="numeric" required="yes" >

		<!--- cierra las ventanillas inactivas --->
		<cfset this.cerrar_inactivas() >

		<cfquery datasource="#session.tramites.dsn#">
			insert into TPVentanillaAbierta(id_ventanilla, id_funcionario, ultimo_acceso)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_ventanilla#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
		</cfquery>
	</cffunction>	

	<!--- 
		RESULTADO:
		Cierra una ventanilla (borra de TPVentanillasAbiertas )
	--->
	<cffunction name="cerrar" access="public">
		<cfargument name="id_funcionario"  type="numeric" required="yes">
		<cfargument name="id_ventanilla" type="numeric" required="yes" >

		<cfquery datasource="#session.tramites.dsn#">
			delete TPVentanillaAbierta
			where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_ventanilla#">
			  and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#">
		</cfquery>

	</cffunction>	

	<!--- 
		RESULTADO:
		Actualiza el ultimo acceso de una ventanilla
	--->
	<cffunction name="ping" access="public">
		<cfargument name="id_funcionario"  type="numeric" required="yes">
		<cfargument name="id_ventanilla" type="numeric" required="yes" >
		
		<cfquery datasource="#session.tramites.dsn#">
			update TPVentanillaAbierta
			set ultimo_acceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_ventanilla#">
			  and id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_funcionario#">
		</cfquery>
		
	</cffunction>	

	<!--- 
		RESULTADO:
		Cierra todas las ventanillas con mas de 5 minutos de inactividad
	--->
	<cffunction name="cerrar_inactivas" access="public">
		<!--- ver como usar dbfunction con timediff y pasando el now como parametro --->
		<cfquery datasource="#session.tramites.dsn#">
			delete TPVentanillaAbierta
			<!---where datediff(mi, ultimo_acceso, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ) > 5--->
			where ultimo_acceso < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('n',-5, now())#">
		</cfquery>
	</cffunction>	

</cfcomponent>