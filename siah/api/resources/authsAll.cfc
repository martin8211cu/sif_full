<cfcomponent extends="taffy.core.resource" taffy_uri="/auths/{empresa}">

	<cffunction name="get" access="public" output="false">
		<cfargument name="empresa" type="numeric" />
		<cfargument name="extended" type="boolean" required="false" default="false"/>

		<cftry>
			<cfquery name="rsPermiso" datasource="asp">
				select e.Ereferencia empresa, u.Usucodigo usuario, lower(concat(ltrim(rtrim(p.SScodigo)),'-',ltrim(rtrim(p.SMcodigo)),'-',ltrim(rtrim(p.SPcodigo)))) permisocodigo, p.SPdescripcion permisodescripcion
				from vUsuarioProcesos up
				inner join Empresa e on up.Ecodigo = e.Ecodigo
				inner join Usuario u on up.Usucodigo = u.Usucodigo
				inner join SProcesos p on up.SScodigo = p.SScodigo and up.SMcodigo = p.SMcodigo and up.SPcodigo = p.SPcodigo
				where u.Usucodigo = #arguments.userData.usucodigo#
					and e.Ereferencia = #arguments.empresa#
			</cfquery>
			
			<cfif arguments.extended>
				<cfset result["permisos"] =  queryToArray(rsPermiso)>
			<cfelse>
				<cfset permisos = "">
				<cfloop query="rsPermiso">
					<cfset permisos = listAppend(permisos, rsPermiso.permisocodigo)>
				</cfloop>
				<cfset result["permisos"] = listToArray(permisos)>
			</cfif>
        
		<cfcatch type="Expression">
			<cfset status = 400>
			<cfset result["message"] = "Peticion mal formada">
			<cfset result["errorcode"] = 2>
		</cfcatch>
		<cfcatch type="any">
			<cfset result = structNew()>
			<cfset result["message"] = "#cfcatch.message#">
			<cfset result["errorcode"] = 99>
			<cfreturn representationOf(result).withStatus(500) />
		</cfcatch>
		<cffinally>
			<cfreturn representationOf(result).withStatus(200) />
		</cffinally>
		</cftry>
	</cffunction>

</cfcomponent>