<cfset LvarQPTidTag = 1>
<cfloop condition="LvarQPTidTag GT 0">
	<cfinvoke component="sif.QPass.Componentes.QPAplicaMovimientos" returnvariable="LvarQPTidTag" method="AplicaMovimientos">
		<cfinvokeargument name="Conexion" value="minisif">
		<cfinvokeargument name="QPTidTag" value="#LvarQPTidTag#">
	</cfinvoke>
</cfloop>

