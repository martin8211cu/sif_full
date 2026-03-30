<cfloop from="2010" to="2013" index="periodo">
	<cfloop from="1" to="12" index="mes">
		<cfinvoke component="sif.componentes.MlibrosDetalle" method="AltaMLibrosDetalle">
			<cfinvokeargument name="MLperiodo" 	value="#periodo#">
			<cfinvokeargument name="MLmes" 		value="#mes#">
		</cfinvoke>
	</cfloop>
</cfloop>