<cfcomponent extends="taffy.core.resource" taffy_uri="/auth/{empresa}/{identificador}">

	<cffunction name="get" access="public" output="false">
		<cfargument name="empresa" type="numeric" />
		<cfargument name="identificador" type="string" />

		<cftry>
			<cfset result = structNew()>
			<cfset status = 200>
			<cfquery name="rsPermiso" datasource="asp">
				select e.Ereferencia empresa, u.Usucodigo usuario, lower(concat(ltrim(rtrim(p.SScodigo)),'.',ltrim(rtrim(p.SMcodigo)),'.',ltrim(rtrim(p.SPcodigo)))) permisocodigo, p.SPdescripcion permisodescripcion
				from vUsuarioProcesos up
				inner join Empresa e on up.Ecodigo = e.Ecodigo
				inner join Usuario u on up.Usucodigo = u.Usucodigo
				inner join SProcesos p on up.SScodigo = p.SScodigo and up.SMcodigo = p.SMcodigo and up.SPcodigo = p.SPcodigo
				where u.Usucodigo = #arguments.userData.usucodigo#
					and e.Ereferencia = #arguments.empresa#
					and lower(concat(ltrim(rtrim(p.SScodigo)),'-',ltrim(rtrim(p.SMcodigo)),'-',ltrim(rtrim(p.SPcodigo)))) = lower('#arguments.identificador#')
			</cfquery>
			
			<cfset result["haspermission"] = (rsPermiso.recordCount gt 0)>

			<cfif rsPermiso.recordCount lt 1>
				<cfset result["message"] = "Permiso inexistente">
				<cfset result["errorcode"] = 4>
				<cfset status = 403>
			</cfif>
            
		<cfcatch type="Expression">
			<cfset status = 400>
			<cfset result["message"] = "Peticion mal formada">
			<cfset result["errorcode"] = 2>
		</cfcatch>
		<cfcatch type="any">			
			<cfset result["message"] = "#cfcatch.message#">
			<cfset result["errorcode"] = 99>
			<cfset status = 500>
			<cfreturn representationOf(result).withStatus(status) />
		</cfcatch>
		<cffinally>
			<cfreturn representationOf(result).withStatus(status) />
		</cffinally>
		</cftry>
	</cffunction>

	
</cfcomponent>
