<cftransaction>

	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select * 
		from ISBservicio  
		where rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
	</cfquery>
	
	<cfif rsVerifica.recordCount EQ 0>
		
		<cfloop query="rsTipoServi">
			
			<cfquery name="rsTipoServi" datasource="#session.DSN#">
				select TScodigo
				from ISBservicioTipo  
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<!---Agrega el servicio Des-Habilita--->
			<cfinvoke component="saci.comp.ISBservicio" method="Alta">
				<cfinvokeargument name="TScodigo" value="#rsTipoServi.TScodigo#">
				<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
				<cfinvokeargument name="PQinterfaz" value="">
				<cfinvokeargument name="SVcantidad" value="0">
				<cfinvokeargument name="Habilitado" value="false">
			</cfinvoke>
		</cfloop>
		
	<cfelse>
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			update ISBservicio
			set  PQinterfaz =null,
				 SVcantidad =0,
				 Habilitado =0
			where rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
		</cfquery>
	</cfif>
	
	<cfif isdefined("Form.Chk") and ListLen("Form.Chk")gt 0>
	<!---<cfif isdefined("Form.Chk")and len(trim(Form.Chk))>--->
		
		<!---Toma los Id de los tipos de servicios que fueron chequeados--->
		<cfloop index = "TScod" list = "#Form.Chk#" delimiters = ",">
		<cfset servicio = TScod>
			
			<!---Toma el valor de los campos dinámicos de la lista para los campos de PQinterfaz,SVcantidad y Habilitado--->	
			<cfif isdefined("form.I_#servicio#") and len(trim(Evaluate("form.I_#servicio#")))>
				<cfset interfaz = Evaluate("form.I_#servicio#")>
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
				select SVid,TScodigo,PQcodigo 
				from ISBservicio  
				where rtrim(ltrim(TScodigo))=  <cfqueryparam cfsqltype="cf_sql_char" value="#trim(servicio)#">
				and rtrim(ltrim(PQcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.PQcodigo)#">
			</cfquery>
			
			<cfif rsTipo.recordCount gt 0>
				
				<!---Modifica el servicio y  lo Habilita--->
				<cfinvoke component="saci.comp.ISBservicio" method="Cambio" >
					<cfinvokeargument name="TScodigo" value="#servicio#">
					<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
					<cfinvokeargument name="PQinterfaz" value="#interfaz#">
					<cfinvokeargument name="SVcantidad" value="#val(cantidad)#">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>
			<cfelse>
				<!---Agrega el servicio Des-Habilita--->
				<cfinvoke component="saci.comp.ISBservicio" method="Alta"  >
					<cfinvokeargument name="TScodigo" value="#servicio#">
					<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
					<cfinvokeargument name="PQinterfaz" value="#interfaz#">
					<cfinvokeargument name="SVcantidad" value="#val(cantidad)#">
					<cfinvokeargument name="Habilitado" value="true">
				</cfinvoke>
			</cfif>
			
		</cfloop>
	</cfif>

</cftransaction>

