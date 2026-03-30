<cfif IsDefined("form.Asignar")>	
	<cfif isdefined('form.AGidp') and form.AGidp NEQ ''>
		<cfinvoke component="saci.comp.ISBsobres"
			method="Asigna_Agente" >
			<cfinvokeargument name="Snumero" value="#form.Snumero#">
			<cfinvokeargument name="AGid" value="#form.AGidp#">
		</cfinvoke>
	</cfif>
<cfelseif IsDefined("form.Anular")>
	<cfinvoke component="saci.comp.ISBsobres"
		method="cambioEstado" >
		<cfinvokeargument name="Snumero" value="#form.Snumero#">
		<cfinvokeargument name="Sestado" value="2">
	</cfinvoke> 			
</cfif>

<cfinclude template="ISBsobres-redirect.cfm">