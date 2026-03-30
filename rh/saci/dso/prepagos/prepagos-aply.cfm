<cfif IsDefined("form.Asignar")>	
	<cfif isdefined('form.AGidp') and form.AGidp NEQ '' and (isdefined('form.TJid') and len(trim(form.TJid)))>
		<cfif isdefined('form.TJestado') and form.TJestado EQ '0'>
			<cftransaction>
				<cfinvoke component="saci.comp.ISBprepago"
					method="AsignaAgente" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="AGid" value="#form.AGidp#">
				</cfinvoke>
				
				<!--- Insercion en la bitacora de Prepago --->
				<cfinvoke component="saci.comp.ISBbitacoraPrepago"
						method="Alta" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="TJlogin" value="#form.TJlogin#">
					<cfinvokeargument name="BPobs" value="Asignación del agente con id: #form.AGidp# por parte del usuario DSO">
				</cfinvoke>  			
			</cftransaction>	
		<cfelse>
			<cfthrow message="Error, la tarjeta no esta en estado 0.Generada para la asignación del agente">
		</cfif>
	</cfif>
<cfelseif IsDefined("form.Activar")>
	<cfif isdefined('form.TJid') and form.TJid NEQ ''>
		<cfif isdefined('form.TJestado') and ((form.TJestado EQ '0') or (form.TJestado EQ '5'))>
			<cftransaction>
				<cfinvoke component="saci.comp.ISBprepago"
					method="CambioEstado" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="TJestado" value="1">
				</cfinvoke> 

				<!--- Insercion en la bitacora de Prepago --->
				<cfinvoke component="saci.comp.ISBbitacoraPrepago"
						method="Alta" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="TJlogin" value="#form.TJlogin#">
					<cfinvokeargument name="BPobs" value="Activación de la tarjeta por parte del usuario DSO">
				</cfinvoke>  			
			</cftransaction>				
		<cfelse>
			<cfthrow message="Error, la tarjeta no esta en estado 0.Generada o en estado 5.Desactivada para su activación">
		</cfif>
	<cfelse>
		<cfthrow message="Error, la tarjeta no existe o no se ha seleccionado">				
	</cfif>
<cfelseif IsDefined("form.Bloquear")>
	<cfif isdefined('form.TJid') and form.TJid NEQ ''>
		<cfif isdefined('form.TJestado') and form.TJestado EQ '1'>
		
			<cfquery name="rsEventoPrepago" datasource="#session.DSN#">
				select count(1) as cant
				from ISBeventoPrepago 
				where TJid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TJid#" null="#Len(form.TJid) Is 0#">
			</cfquery>

			<cfif isdefined('rsEventoPrepago') and rsEventoPrepago.cant EQ 0>
				<cftransaction>
					<cfinvoke component="saci.comp.ISBprepago"
						method="CambioEstado" >
						<cfinvokeargument name="TJid" value="#form.TJid#">
						<cfinvokeargument name="TJestado" value="5">
					</cfinvoke> 
					
					<!--- Insercion en la bitacora de Prepago --->
					<cfinvoke component="saci.comp.ISBbitacoraPrepago"
							method="Alta" >
						<cfinvokeargument name="TJid" value="#form.TJid#">
						<cfinvokeargument name="TJlogin" value="#form.TJlogin#">
						<cfinvokeargument name="BPobs" value="Bloqueo de la tarjeta por parte del usuario DSO">
					</cfinvoke>  			
				</cftransaction>						
			<cfelse>
				<cfthrow message="Error, la tarjeta ya posee tráfico asociado, por tal motivo no permite la desactivación.">
			</cfif>
		<cfelse>
			<cfthrow message="Error, la tarjeta no esta en estado 1.Activa para su desactivación">
		</cfif>
	<cfelse>
		<cfthrow message="Error, la tarjeta no existe o no se ha seleccionado">				
	</cfif>
<cfelseif IsDefined("form.Anular")>	
	<cfif isdefined('form.TJid') and form.TJid NEQ ''>
		<cfif isdefined('form.TJestado') and ((form.TJestado EQ '1') or (form.TJestado EQ '2'))>
			<cftransaction>
				<cfinvoke component="saci.comp.ISBprepago"
					method="CambioEstado" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="TJestado" value="6">
				</cfinvoke>  
				
				<!--- Insercion en la bitacora de Prepago --->
				<cfinvoke component="saci.comp.ISBbitacoraPrepago"
						method="Alta" >
					<cfinvokeargument name="TJid" value="#form.TJid#">
					<cfinvokeargument name="TJlogin" value="#form.TJlogin#">
					<cfinvokeargument name="BPobs" value="Anulación de la tarjeta por parte del usuario DSO">
				</cfinvoke>  			
			</cftransaction>					
		<cfelse>
			<cfthrow message="Error, la tarjeta no esta en estado 1.Activa o en estado 2.Utilizada para su anulación">
		</cfif>
	<cfelse>
		<cfthrow message="Error, la tarjeta no existe o no se ha seleccionado">		
	</cfif>
</cfif>

<cfinclude template="prepagos-redirect.cfm">
