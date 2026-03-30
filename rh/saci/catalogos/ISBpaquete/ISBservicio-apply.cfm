<cffunction name="soloEmail" output="true" returntype="boolean" access="private">
	<cfset existeSoloEmail = false>
	
	<cfif ListLen("form.Chk") EQ 1 and form.Chk EQ 'MAIL'>
		<cfset existeSoloEmail = true>
	</cfif>
	
	<cfreturn existeSoloEmail>
</cffunction>

<cftransaction>
	<cfif isdefined("form.Cambio") or isdefined("form.Alta")>
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select * 
			from ISBservicio  
			where rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
		</cfquery>
		
		<cfif rsVerifica.recordCount EQ 0>
			
			<cfquery name="rsTipoServi" datasource="#session.DSN#">
				select TScodigo
				from ISBservicioTipo  
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>	
			<cfloop query="rsTipoServi">
				<!---Agrega el servicio Des-Habilita--->
				<cfinvoke component="saci.comp.ISBservicio" method="Alta">
					<cfinvokeargument name="TScodigo" value="#rsTipoServi.TScodigo#">
					<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
					<cfinvokeargument name="PQinterfaz" value="">
					<cfinvokeargument name="SVcantidad" value="0">
					<cfinvokeargument name="SVminimo" value="0">
					<cfinvokeargument name="Habilitado" value="false">
				</cfinvoke>
			</cfloop>
			
		<cfelse>
			
			<cfquery name="rsVerifica" datasource="#session.DSN#">
				update ISBservicio
				set  PQinterfaz = null,
					 SVcantidad = 0,
					 SVminimo = 0,
					 Habilitado = 0
				where rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
			</cfquery>

		</cfif>
		
		
		<cfif isdefined("form.Chk") and ListLen("form.Chk")gt 0>
		<!---<cfif isdefined("form.Chk")and len(trim(form.Chk))>--->
			<cfset cantMin = 0>
			<cfset soloEmail = soloEmail()>
			
			<!---Toma los Id de los tipos de servicios que fueron chequeados--->
			<cfloop index = "TScod" list = "#form.Chk#" delimiters = ",">
			<cfset servicio = TScod>
				
				<!---Toma el valor de los campos dinámicos de la lista para los campos de PQinterfaz,SVcantidad y Habilitado--->	
				<cfif isdefined("form.PQcodigo_#servicio#") and len(trim(Evaluate("form.PQcodigo_#servicio#")))>
					<cfset interfaz = Evaluate("form.PQcodigo_#servicio#")>
				<cfelse>
					<cfset interfaz = "">
				</cfif>
				<cfif isdefined("form.C_#servicio#") and len(trim(Evaluate("form.C_#servicio#")))>
					<cfset cantidad = Evaluate("form.C_#servicio#")>
				</cfif>
				<cfif isdefined("form.H_#servicio#") and len(trim(Evaluate("form.H_#servicio#")))>
					<cfset habilitado = 1>
				</cfif>
					
					
				<!---Valor por defecto de la variable cantidad en caso de que no este definida--->
				<cfparam name="interfaz" default="">
				<cfparam name="cantidad" default="0">
				<cfparam name="habilitado" default="0">
				
				<cfquery name="rsTipo" datasource="#session.DSN#">
					select TScodigo,PQcodigo 
					from ISBservicio  
					where rtrim(ltrim(TScodigo))=  <cfqueryparam cfsqltype="cf_sql_char" value="#trim(servicio)#">
					and rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
				</cfquery>
				
				<cfif servicio EQ 'MAIL'>
					<cfif soloEmail>
						<cfset cantMin = 1>
					<cfelse>
						<cfset cantMin = 0>
					</cfif>
				<cfelseif servicio EQ 'ACCS'>
					<cfset cantMin = 1>
				<cfelseif servicio EQ 'CABM'>
					<cfset cantMin = 1>				
				</cfif>				
								
				
								
				<cfif rsTipo.recordCount gt 0>
					<!---Modifica el servicio y  lo Habilita--->
					<cfinvoke component="saci.comp.ISBservicio" method="Cambio" >
						<cfinvokeargument name="TScodigo" value="#servicio#">
						<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
						<cfinvokeargument name="PQinterfaz" value="#interfaz#" >
						<cfinvokeargument name="SVcantidad" value="#val(cantidad)#">
						<cfinvokeargument name="SVminimo" value="#val(cantMin)#">	
						<cfinvokeargument name="Habilitado" value="true">
					</cfinvoke>
				<cfelse>
					<!---Agrega el servicio Des-Habilita--->
					<cfinvoke component="saci.comp.ISBservicio" method="Alta"  >
						<cfinvokeargument name="TScodigo" value="#servicio#">
						<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
						<cfinvokeargument name="PQinterfaz" value="#interfaz#">
						<cfinvokeargument name="SVcantidad" value="#val(cantidad)#">
						<cfinvokeargument name="SVminimo" value="#val(cantMin)#">						
						<cfinvokeargument name="Habilitado" value="false">
					</cfinvoke>
				</cfif>
				
			</cfloop>		
		</cfif>
					
	</cfif>
</cftransaction>
