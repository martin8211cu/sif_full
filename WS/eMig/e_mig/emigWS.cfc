<cfcomponent>
	<cffunction name="getEstadosPersona" access="remote" output="no" returntype="R_ConsultaEstados">
		<cfargument name="parameters" type="P_CedulaT" required="yes">
		<cfset LvarResult = createObject("component", "R_ConsultaEstados")>
		<cfset LvarResult.Nombre="XXX">
		<cfreturn LvarResult>
	</cffunction>
</cfcomponent>