<cfcomponent output="false">
	<cffunction name="GetParametro" returntype="string" access="public">
		<cfargument name="codigo" type="string">
		<cfargument name="conexion" type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">

		<cfquery name="rsParametro" datasource="#arguments.conexion#">
			SELECT coalesce(Pvalor,'') Pvalor
			FROM CRCParametros
			WHERE Ecodigo = #arguments.Ecodigo#
				and Pcodigo = '#trim(arguments.codigo)#'
		</cfquery>

		<cfif rsParametro.recordCount gt 0 >
			<cfreturn rsParametro.Pvalor>
		<cfelse>
			<cfreturn ''>
		</cfif>

	</cffunction>


	<cffunction name="GetParametroInfo" returntype="struct" access="public">
		<cfargument name="codigo" type="string">
		<cfargument name="conexion" type="string" required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" type="string" required="false" default="#session.Ecodigo#">
		<cfargument name="descripcion" type="string" required="false" default="">

		<cfquery name="rsParametro" datasource="#arguments.conexion#">
			SELECT coalesce(Pvalor,'') Pvalor, Pcodigo, Pdescripcion
			FROM CRCParametros
			WHERE Ecodigo = #arguments.Ecodigo#
				and Pcodigo = '#trim(arguments.codigo)#'
		</cfquery>

		<cfset paramInfo = structNew()>
		<cfif rsParametro.recordCount gt 0 >
			<cfset paramInfo.codigo      = rsParametro.Pcodigo>
			<cfset paramInfo.valor       = rsParametro.Pvalor>
			<cfset paramInfo.descripcion = rsParametro.Pdescripcion>

			<cfreturn paramInfo>
		<cfelse>
			<cfset paramInfo.codigo      = ''>
			<cfset paramInfo.valor       = ''>
			<cfset paramInfo.descripcion = '#arguments.descripcion#'>
			
			<cfreturn paramInfo>
		</cfif>

	</cffunction>

</cfcomponent>