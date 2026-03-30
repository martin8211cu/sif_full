<cfcomponent name="RH_ControlMarcasCommon">
	<cffunction name="fnGetPagaSeptimo" returntype="boolean">
		<cfargument name="Ecodigo" default="#Session.Ecodigo#">
		<!--- Si en algún momento se decide hacerlo por parámetros
			sería únicamente utilizar esta sección en lugar de la de
			abajo. Solamente revisar los pvalor.
			<cfinvoke component="rh.Componentes.RHParametros" method="get" 
					datasource="#session.dsn#" ecodigo="#session.ecodigo#" pvalor="740"
					returnvariable="Lvar_PagaSeptimo">
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select 1
			from Empresa e
				inner join Direcciones d
				on d.id_direccion = e.id_direccion
				and Ppais = 'GT'
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfquery>
		<cfreturn rs.recordcount GT 0>
	</cffunction>
	<cffunction name="fnGetPagaQ250" returntype="boolean">
		<cfargument name="Ecodigo" default="#Session.Ecodigo#">
		<!--- Si en algún momento se decide hacerlo por parámetros
			sería únicamente utilizar esta sección en lugar de la de
			abajo. Solamente revisar los pvalor.
			<cfinvoke component="rh.Componentes.RHParametros" method="get" 
					datasource="#session.dsn#" ecodigo="#session.ecodigo#" pvalor="750"
					returnvariable="Lvar_PagaQ250"> 
		--->
		<cfquery name="rs" datasource="#session.dsn#">
			select 1
			from Empresa e
				inner join Direcciones d
				on d.id_direccion = e.id_direccion
				and Ppais = 'GT'
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfquery>
		<cfreturn rs.recordcount GT 0>
	</cffunction>
</cfcomponent>