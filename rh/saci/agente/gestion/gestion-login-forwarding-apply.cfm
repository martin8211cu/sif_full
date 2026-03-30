<cfif isdefined("form.Agregar")>

	<cfinvoke component="saci.comp.ISBmailForward" method="Alta">
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="LGmailForward" value="#form.LGmailFor#">
	</cfinvoke>

<cfelseif isdefined("form.Baja") and form.Baja EQ 1>
	<cfinvoke component="saci.comp.ISBmailForward" method="Baja">
		<cfinvokeargument name="LGnumero" value="#form.logg#">
		<cfinvokeargument name="LGmailForward" value="#form.LGmailForward#">
	</cfinvoke>

</cfif>

<cfinclude template="gestion-redirect.cfm">
