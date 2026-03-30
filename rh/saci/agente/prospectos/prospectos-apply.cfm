<cfset params="">

<cfif isdefined("Form.Descartar")>
 	<cfinvoke component="saci.comp.ISBprospectos" method="Cambio_Estado">
		<cfinvokeargument name="Pquien" value="#form.Pquien_Ant#">
		<cfinvokeargument name="Pprospectacion" value="D">
	</cfinvoke>
</cfif>

<cfif isdefined("Form.Contactado")>
 	<cfinvoke component="saci.comp.ISBprospectos" method="Cambio_Estado">
		<cfinvokeargument name="Pquien" value="#form.Pquien_Ant#">
		<cfinvokeargument name="Pprospectacion" value="C">
	</cfinvoke>
</cfif>


<cfinclude template="prospectos-redirect.cfm">