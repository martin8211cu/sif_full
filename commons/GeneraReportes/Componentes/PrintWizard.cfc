
<cfcomponent output="true" >

	<cffunction name="set" access="remote">
		<cfargument name="nombre">
		<cfargument name="cantidad">
		<cfif trim(arguments.nombre) NEQ "" and trim(arguments.cantidad) NEQ "" and arguments.cantidad GT 0>
			<cfset newItem = structNew()>
			<cfset newItem.nombre = #arguments.nombre#>
			<cfset newItem.cantidad = #arguments.cantidad#>
			<cfset arrayAppend(session.listaCarrito, newItem)>
		</cfif>
	</cffunction>

	<cffunction name="getPage" access="remote" returnformat="plain">
		<cfargument name="page">
		<!--- <cfargument name="codigo"> --->
		<cfsavecontent variable="result">
			<div id="rootwizard" class="tabbable tabs-left" style="height:100%;">
				<!---  --->
			</div>
					
		</cfsavecontent>
		<cfreturn result>
	</cffunction>

</cfcomponent>