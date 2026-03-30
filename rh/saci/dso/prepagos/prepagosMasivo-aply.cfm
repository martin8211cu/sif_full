<cfif IsDefined("form.Asignar")>	
	<cfif isdefined('form.AGidp_mas') and form.AGidp_mas NEQ ''>
		<cftransaction>
			<!--- Insercion en la bitacora de Prepago --->
			<cfinvoke component="saci.comp.ISBbitacoraPrepago"
					method="AltaRango">
				<cfinvokeargument name="prefijo" value="#form.prefijo#">				
				<cfinvokeargument name="rangoIni" value="#form.tarIni#">
				<cfinvokeargument name="rangoFin" value="#form.tarFin#">	
				<cfinvokeargument name="TJestado" value="A">					
				<cfinvokeargument name="BPobs" value="Asignación del agente con id: #form.AGidp_mas# por parte del usuario DSO">
			</cfinvoke>  
			
			<!--- Cambio del Estado --->
			<cfinvoke component="saci.comp.ISBprepago"
				method="AsignaAgenteRango" >
				<cfinvokeargument name="prefijo" value="#form.prefijo#">				
				<cfinvokeargument name="rangoIni" value="#form.tarIni#">
				<cfinvokeargument name="rangoFin" value="#form.tarFin#">	
				<cfinvokeargument name="AGid" value="#form.AGidp_mas#">
			</cfinvoke>
		</cftransaction>
	</cfif>
<cfelseif IsDefined("form.Activar")>
	<cftransaction>
		<!--- Insercion en la bitacora de Prepago --->
		<cfinvoke component="saci.comp.ISBbitacoraPrepago"
				method="AltaRango">
			<cfinvokeargument name="prefijo" value="#form.prefijo#">				
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">	
			<cfinvokeargument name="TJestado" value="1">
			<cfinvokeargument name="BPobs" value="Activación de la tarjeta por parte del usuario DSO">
		</cfinvoke> 	
		
		<!--- Cambio del Estado --->
		<cfinvoke component="saci.comp.ISBprepago"
			method="CambioEstadoRango" >
			<cfinvokeargument name="prefijo" value="#form.prefijo#">				
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">				
			<cfinvokeargument name="TJestado" value="1">
		</cfinvoke> 
	</cftransaction>
<cfelseif IsDefined("form.Bloquear")>
	<cftransaction>
		<!--- Insercion en la bitacora de Prepago --->
		<cfinvoke component="saci.comp.ISBbitacoraPrepago"
				method="AltaRango">
			<cfinvokeargument name="prefijo" value="#form.prefijo#">				
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">	
			<cfinvokeargument name="TJestado" value="5">
			<cfinvokeargument name="BPobs" value="Bloqueo de la tarjeta por parte del usuario DSO">
		</cfinvoke> 		
		
		<!--- Cambio del Estado --->	
		<cfinvoke component="saci.comp.ISBprepago"
			method="CambioEstadoRango" >
			<cfinvokeargument name="prefijo" value="#form.prefijo#">
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">				
			<cfinvokeargument name="TJestado" value="5">
		</cfinvoke> 
	</cftransaction>		
<cfelseif IsDefined("form.Anular")>	
	<cftransaction>
		<!--- Insercion en la bitacora de Prepago --->
		<cfinvoke component="saci.comp.ISBbitacoraPrepago"
				method="AltaRango">
			<cfinvokeargument name="prefijo" value="#form.prefijo#">				
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">	
			<cfinvokeargument name="TJestado" value="6">
			<cfinvokeargument name="BPobs" value="Anulación de la tarjeta por parte del usuario DSO">
		</cfinvoke> 		
		<!--- Cambio del Estado --->	
		<cfinvoke component="saci.comp.ISBprepago"
			method="CambioEstadoRango" >
			<cfinvokeargument name="prefijo" value="#form.prefijo#">
			<cfinvokeargument name="rangoIni" value="#form.tarIni#">
			<cfinvokeargument name="rangoFin" value="#form.tarFin#">				
			<cfinvokeargument name="TJestado" value="6">
		</cfinvoke> 
	</cftransaction>		
</cfif>		

<cfinclude template="prepagos-redirect.cfm">