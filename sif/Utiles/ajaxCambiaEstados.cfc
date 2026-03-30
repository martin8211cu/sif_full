<cfcomponent output="true">
<!---
	Autor: Ing. Oscar Orlando Parrales Villanueva
	Fecha: 02/06/2017
	Descripcion: Componente para actualizar el contenido
				 del combo de Estados en Oficinas a través
				 del codigo del Pais dado por el SAT.
				 (Ver catalogo del SAT CSATEstados)
 --->
	<cffunction name="getOptions" access="remote" output="true">
		<cfargument name="ClavePais" type="string" default="MEX"/>
		<cfargument name="EstadoD" type="string" default=""/>

		<cfquery name="rsCSATPclave" datasource="#session.dsn#">
			Select CSATPclave from Pais where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ClavePais#">
		</cfquery>

		<cfif rsCSATPclave.RecordCount gt 0 and trim(rsCSATPclave.CSATPclave) neq ''>

			<cfquery name="rsEstados" datasource="#session.dsn#">
				Select
					CSATcodigo,
					CSATdescripcion
				from CSATEstados
				where Pclave = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCSATPclave.CSATPclave#">
			</cfquery>

			<cfoutput query="rsEstados">
				<option value="#CSATdescripcion#" <cfif Arguments.EstadoD eq CSATdescripcion>selected</cfif>>#CSATdescripcion#</option>
			</cfoutput>
		</cfif>
	</cffunction>

</cfcomponent>