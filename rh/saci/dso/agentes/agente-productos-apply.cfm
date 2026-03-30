<cfinclude template="agente-params.cfm">

<cfif isdefined("form.Guardar")>
	
	<cfquery name="rsPaquete" datasource="#session.DSN#">
			select PQcodigo
			from ISBpaquete
	</cfquery>
		
	<cfquery name="rsBorrar" datasource="#session.DSN#">
			Delete ISBagenteOferta
			where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#" null="#Len(form.AGid) Is 0#">
	</cfquery>	

			
	<cfloop query="rsPaquete" startrow="1">

		<cfif isdefined("form.OFC_#Trim(rsPaquete.PQcodigo)#")>

				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select count(1)as existe
					from ISBagenteOferta
					where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPaquete.PQcodigo#" null="#Len(rsPaquete.PQcodigo) Is 0#">
					and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#" null="#Len(form.AGid) Is 0#">
				</cfquery>
				
				<cfif rsVerifica.existe EQ 0>										
					<cfinvoke component="saci.comp.ISBagenteOferta" method="Alta">
						<cfinvokeargument name="AGid" value="#form.AGid#">
						<cfinvokeargument name="PQcodigo" value="#rsPaquete.PQcodigo#">
						<cfinvokeargument name="Habilitado" value="1">
						<cfinvokeargument name="BMusucodigo" value="#session.Usucodigo#">
					</cfinvoke>			
				</cfif>
	
		</cfif>
	</cfloop>	
<cfelseif isdefined("form.Baja") and Form.Baja EQ 1>
	<cfinvoke component="saci.comp.ISBagenteOferta" method="Baja">
		<cfinvokeargument name="AGid" value="#form.AGid#">
		<cfinvokeargument name="PQcodigo" value="#form.PQcodigo#">
	</cfinvoke>
<cfelseif isdefined("form.Cambio") and Form.Cambio EQ 1>
	<cfinvoke component="saci.comp.ISBagenteOferta"
		method="Cambio" 
		AGid="#form.AGid#"
		PQcodigo="#form.PQcodigo#"
		Habilitado="#form.Habilitado#"
	/>	
</cfif>

<cfinclude template="agente-redirect.cfm">
