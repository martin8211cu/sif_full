<cfif isdefined("form.Agregar")>
	<cfinvoke component="saci.comp.ISBlogin" method="AltaForwarding">
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="LGmailForward" value="#form.LGmailFor#">
	</cfinvoke>

<cfelseif isdefined("form.Baja") and form.Baja EQ 1>
	<cfinvoke component="saci.comp.ISBlogin" method="BajaForwarding">
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="LGmailForward" value="#form.LGmailForward#">
	</cfinvoke>

</cfif>
