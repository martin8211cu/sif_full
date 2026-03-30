<cfif isdefined('url.dele')>
	<cffunction output="true" name="Cierre_Mes" access="public" hint="Retorna Nulo">
		<cfargument name="Ecodigo" type="numeric" required="no">
		<cfargument name="Conexion" type="string" required="no">

		<cfargument name="debug" type="boolean" default="false">

		<cfinvoke component="sif.Componentes.Contabilidad" method="Cierre_Mes"
		Ecodigo="#Arguments.Ecodigo#" Conexion="#Arguments.Conexion#" debug="yes" />

	</cffunction>
</cfif>