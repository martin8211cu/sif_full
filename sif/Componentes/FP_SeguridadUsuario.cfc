<cffunction name="Alta"  access="public" returntype="numeric">
	<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
	<cfargument name="Ecodigo" 		    type="numeric" 	required="no" default="#session.Ecodigo#">
	<cfargument name="Usucodigo" 		type="numeric"	required="yes">
	<cfargument name="CFid"  			type="numeric"  required="yes">
	<cfargument name="FPSUestimar"  	type="numeric"  required="no" default="0">
	<cfargument name="BMUsucodigo"      type="numeric" 	required="no" default="#Session.Usucodigo#">
	
	<cfquery datasource="#Arguments.Conexion#" name="rsAltaUsuario">
		insert into FPSeguridadUsuario
		(Ecodigo, Usucodigo, CFid, FPSUestimar, BMUsucodigo)
		values
		(
		<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.FPSUestimar#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
		)
		<cf_dbidentity1>
	</cfquery>
		  <cf_dbidentity2 name="rsAltaUsuario">
		  <cfreturn #rsAltaUsuario.identity#>
</cffunction>

<cffunction name="Baja"  access="public" returntype="numeric">
	<cfargument name="Conexion" 	    type="string"  	required="no" default="#session.dsn#">
	<cfargument name="FPSUid" 			type="numeric"  required="yes">
		
	<cfquery datasource="#Arguments.Conexion#" name="rsBajaPlanillaConcep">
		delete from FPSeguridadUsuario
		where
		FPSUid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPSUid#">
	</cfquery>
	<cfreturn #Arguments.FPSUid#>
</cffunction>

<cffunction name="fnGetCFs"  access="public" returntype="query">
	<cfargument name="Usucodigo" 		type="numeric"  required="yes">
	<cfargument name="orderby" 	    	type="string"  	required="no" default="CFcodigo,CFdescripcion">
	<cfargument name="Conexion" 	    type="string"  	required="no">
	<cfargument name="Ecodigo" 			type="numeric"  required="no">
			
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>	
	
	<cfset pathCFid = "">
	
	<cfquery name="ResponableCentrosFuncionales" datasource="#Arguments.Conexion#">
		select count(1) as responsable
			from CFuncional
		where CFuresponsable = #Arguments.Usucodigo#
		 and Ecodigo = #Arguments.Ecodigo#
	</cfquery>

	<cfif ResponableCentrosFuncionales.responsable gt 0>
		<cfquery name="CentrosFuncionalesResponsable" datasource="#Arguments.Conexion#">
			select CFid, CFcodigo
			from CFuncional c
			where c.CFuresponsable = #Arguments.Usucodigo#
			and c.Ecodigo = #Arguments.Ecodigo#
			union
			select b.CFid, b.CFcodigo
			from FPSeguridadUsuario a
				inner join CFuncional b
					on b.CFid = a.CFid
			where a.Usucodigo = #Arguments.Usucodigo#
				and a.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfset pathCFid = fnGetHijosCF(CentrosFuncionalesResponsable)>
	<cfelse>
		<cfquery name="CentrosFuncionalesAutorizados" datasource="#Arguments.Conexion#">
			 select b.CFid, b.CFcodigo, b.CFdescripcion
				from FPSeguridadUsuario a
					inner join CFuncional b
						on b.CFid = a.CFid
			where a.Usucodigo = #Arguments.Usucodigo#
			 and a.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif CentrosFuncionalesAutorizados.recordcount eq 0>
			<cfset pathCFid = "-1">
		<cfelse>
			<cfset pathCFid = valuelist(CentrosFuncionalesAutorizados.CFid)>
		</cfif>
	</cfif>
	
	<cfquery name="CentrosFuncionales" datasource="#Arguments.Conexion#">
		 select CFid, CFcodigo, CFdescripcion
			from CFuncional
		where Ecodigo = #Arguments.Ecodigo#
			and CFid in(#pathCFid#)
		 order by #orderby#
	</cfquery>
		
	<cfreturn CentrosFuncionales>
</cffunction>

<cffunction name="fnGetHijosCF"  access="public" returntype="string">
	<cfargument name="query" 			type="query"  	required="yes">
	<cfargument name="Conexion" 	    type="string"  	required="no">
	<cfargument name="Ecodigo" 			type="numeric"  required="no">
	
	<cfif not isdefined('Arguments.Conexion')>
		<cfset Arguments.Conexion = session.dsn>
	</cfif>
	<cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>	
	<cfquery datasource="#Arguments.Conexion#" name="rsCFHijos">
		select CFid
		from CFuncional
		where Ecodigo = #Arguments.Ecodigo#
		and(
		<cfloop query="Arguments.query">
			 CFpath = '#trim(Arguments.query.CFcodigo)#'     	   or  <!---Unico------>
				 CFpath like '#trim(Arguments.query.CFcodigo)#/%'   or  <!---inicio----->
				 CFpath like '%/#trim(Arguments.query.CFcodigo)#'   or  <!---Final------>
				 CFpath like '%/#trim(Arguments.query.CFcodigo)#/%'     <!---En medio--->
				 
			<cfif Arguments.query.currentrow neq Arguments.query.recordcount>
				or
			</cfif>
		</cfloop>
		)
	</cfquery>
	<cfif rsCFHijos.recordcount eq 0>
		<cfreturn "-1">
	</cfif>
	
	<cfreturn valuelist(rsCFHijos.CFid)>
</cffunction>