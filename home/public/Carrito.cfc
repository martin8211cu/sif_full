
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

	<cffunction name="getList" access="remote" returnformat="plain">
		<cfsavecontent variable="result">
			<cfoutput>
				<cfloop array="#session.listaCarrito#" index="item">
					<tr>
				    	<td>#item.nombre#</td>
				    	<td>#item.cantidad#</td>
				    </tr>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		<cfreturn result>
	</cffunction>

</cfcomponent>

