
<cfif IsDefined("form.quitar") and form.quitar NEQ '-1'>	
  	<cfinvoke component="saci.comp.ISBproducto"	method="Ocultar" >
		<cfinvokeargument name="Contratoid" value="#form.quitar#">
		<cfinvokeargument name="CNconsultar" value="0">
	</cfinvoke>
</cfif>

<cfinclude template="seguimiento-redirect.cfm">