<cfif IsDefined("form.Vender")>	
 	<cfinvoke component="saci.comp.ISBprepago"
		method="CambioEstado" >
		<cfinvokeargument name="TJid" value="#form.TJid#">
		<cfinvokeargument name="TJestado" value="1">
	</cfinvoke>
</cfif>

<cflocation url="ventaPrepagos.cfm">