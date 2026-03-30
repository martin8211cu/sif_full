<cfif isDefined("Form.btnAceptar")>
	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="datos" >		
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="rsDatos" datasource="#Session.DSN#">
			set nocount on
			update MEParametros
			set Pvalor       = <cfif len(trim(pvalor)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#pvalor#"><cfelse>null</cfif>,
				Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pdescripcion#">
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			if @@rowcount = 0 begin
				insert MEParametros (Ecodigo, Mcodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						 'ME',
				         <cfqueryparam cfsqltype="cf_sql_integer" value="#pcodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#pdescripcion#">, 
						 <cfif len(trim(pvalor)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#pvalor#"><cfelse>null</cfif> 
					   )
			end				  
			set nocount off						
		</cfquery>			
		<cfreturn true>
	</cffunction>
	
	<cftry>
		<!--- 1. Paga por Inscripcion --->
		<cfif isdefined("form.pago") ><cfset dato = 1 ><cfelse><cfset dato = 0 ></cfif>	
		<cfset datos(10, 'Cobro en el Registro', dato) >

		<!--- 2. Prpyecto de Cobro  --->
		<cfif isdefined("form.proyecto") and len(trim(form.proyecto)) gt 0 ><cfset dato = form.proyecto ><cfelse><cfset dato = '' ></cfif>	
		<cfset datos(20, 'Id de Proyecto de Cobro', dato) >
	
		<!--- 3. Tabla de Renta --->
		<cfset datos(30, 'Tabla de Impuesto de Renta', form.monto) >
		
		<!--- 4. Tienda Default --->
		<cfif isdefined("form.tienda") ><cfset dato = form.tienda><cfelse><cfset dato = ''></cfif>
		<cfset datos(40, 'Tienda Default', dato)>
	<cfcatch type="any">
		<cflocation url="Parametros.cfm">
	</cfcatch>
	</cftry>
</cfif>
<cflocation url="Parametros.cfm">