<cfif (isdefined("form.submitMenu") and form.submitMenu EQ 1) or isdefined("form.Guardar") or isdefined("form.GuardarContinuar")>

	<cfif form.CTtipoEnvio EQ "1">						
		<cfset CTid = form.CTid>
		<cfset CTtipoEnvio = form.CTtipoEnvio>  
		<cfset CTatencionEnvio = form.CTatencionEnvio> 
		<cfset CTdireccionEnvio = form.CTdireccionEnvio> 
		<cfset CTapdoPostal = form.Papdo> 
		<cfset CTcopiaModo = form.CTcopiaModo> 
		<cfif form.CTcopiaModo EQ "F"  or form.CTcopiaModo EQ "E">
			<cfset CTcopiaDireccion = form.CTcopiaDireccion> 
			<cfset CTcopiaDireccion2 = form.CTcopiaDireccion2> 
			<cfset CTcopiaDireccion3 = form.CTcopiaDireccion3> 
		<cfelse>
			<cfset CTcopiaDireccion = "">
			<cfset CTcopiaDireccion2 = "">
			<cfset CTcopiaDireccion3 = "">
		</cfif>
		<cfset CPid = form.CPid> 
		<cfset LCid = "">
		<cfset CTbarrio= ""> 
		
	<cfelseif  form.CTtipoEnvio EQ "2"> <!--- Si el tipo de envío es Dirección --->
		
		<cfquery datasource="#session.dsn#" name="rsDivPolitica">
			select max(DPnivel) as nivel 
			from DivisionPolitica
			where Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.saci.pais#">
		</cfquery>
		<cfset localidad = "LCid_" & rsDivPolitica.nivel>
		
		<cfset CTid = form.CTid>
		<cfset CTtipoEnvio = form.CTtipoEnvio>  
		<cfset CTatencionEnvio = ""> 
		<cfset CTdireccionEnvio = form.CTdireccionEnvio> 
		<cfset CTapdoPostal = ""> 
		<cfset CTcopiaModo = form.CTcopiaModo> 
		<cfif form.CTcopiaModo EQ "F"  or form.CTcopiaModo EQ "E">
			<cfset CTcopiaDireccion = form.CTcopiaDireccion> 
			<cfset CTcopiaDireccion2 = form.CTcopiaDireccion2> 
			<cfset CTcopiaDireccion3 = form.CTcopiaDireccion3> 
		<cfelse>
			<cfset CTcopiaDireccion = ""> 
			<cfset CTcopiaDireccion2 = "">
			<cfset CTcopiaDireccion3 = "">
		</cfif> 
		<cfset CPid = form.CPid> 
		<cfset LCid = form[localidad]>
		<cfset CTbarrio= form.CTbarrio> 
	
	</cfif>

	<!--- Datos de la Cuenta --->
	<cfquery name="rsCuenta" datasource="#Session.DSN#">
		select a.CTtipoUso
		from ISBcuenta a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
	</cfquery>

	<!--- Si la cuenta que se está modificando es de tipo acceso para agente, averiguar la cuenta de tipo facturacion del agente --->	
	<cfif rsCuenta.CTtipoUso EQ 'A'>
		<cfquery name="rsDatosAgente" datasource="#Session.DSN#">
			select a.CTidFactura
			from ISBagente a
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
			and a.CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		</cfquery>
		<cfif rsDatosAgente.recordCount GT 0>
			<cfset LvarFacturacionAgente = rsDatosAgente.CTidFactura>
		</cfif>
	</cfif>
		
	<cftransaction>
		
		<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Cambio">
			<cfinvokeargument name="CTid" value="#CTid#">
			<cfinvokeargument name="CTtipoEnvio" value="#CTtipoEnvio#">
			<cfinvokeargument name="CTatencionEnvio" value="#CTatencionEnvio#">
			<cfinvokeargument name="CTdireccionEnvio" value="#CTdireccionEnvio#">
			<cfinvokeargument name="CTapdoPostal" value="#CTapdoPostal#">
			<cfinvokeargument name="CTcopiaModo" value="#CTcopiaModo#">
			<cfinvokeargument name="CTcopiaDireccion" value="#CTcopiaDireccion#">
			<cfinvokeargument name="CTcopiaDireccion2" value="#CTcopiaDireccion2#">
			<cfinvokeargument name="CTcopiaDireccion3" value="#CTcopiaDireccion3#">
			<cfinvokeargument name="CPid" value="#CPid#">
			<cfinvokeargument name="LCid" value="#LCid#">
			<cfinvokeargument name="CTbarrio" value="#CTbarrio#">
		</cfinvoke>
		
		<!--- Si la cuenta es de tipo acceso del agente, hay que actualizar también los datos de la cuenta de facturación del agente --->
		<cfif isdefined("LvarFacturacionAgente") and Len(Trim(LvarFacturacionAgente))>
			<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Cambio">
				<cfinvokeargument name="CTid" value="#LvarFacturacionAgente#">
				<cfinvokeargument name="CTtipoEnvio" value="#CTtipoEnvio#">
				<cfinvokeargument name="CTatencionEnvio" value="#CTatencionEnvio#">
				<cfinvokeargument name="CTdireccionEnvio" value="#CTdireccionEnvio#">
				<cfinvokeargument name="CTapdoPostal" value="#CTapdoPostal#">
				<cfinvokeargument name="CTcopiaModo" value="#CTcopiaModo#">
				<cfinvokeargument name="CTcopiaDireccion" value="#CTcopiaDireccion#">
				<cfinvokeargument name="CTcopiaDireccion2" value="#CTcopiaDireccion2#">
				<cfinvokeargument name="CTcopiaDireccion3" value="#CTcopiaDireccion3#">
				<cfinvokeargument name="CPid" value="#CPid#">
				<cfinvokeargument name="LCid" value="#LCid#">
				<cfinvokeargument name="CTbarrio" value="#CTbarrio#">
			</cfinvoke>
		</cfif>
				
	</cftransaction>
	
</cfif>
