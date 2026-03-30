<cfcomponent>
	<cffunction name="fnGetCIncidentesDLimite" returntype="query">
		<cfargument name="CIid"  	type="numeric" required="yes">
		<cfargument name="Ecodigo"  type="numeric">
		<cfargument name="Conexion" type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="rsCIncidentesDLimite" datasource="#Arguments.Conexion#">
			select CIid, CIcantidad, CItipo, CIdia, CImes, CIrango, CIcalculo, CIsprango, CIspcantidad, CImescompleto
			from CIncidentesDLimite
			where 1=1
				<cfif isdefined('Arguments.CIid')>
					and CIid = #Arguments.CIid#
				</cfif>
				<cfif isdefined('Arguments.Ecodigo')>
					and Ecodigo = #Arguments.Ecodigo#
				</cfif>
		</cfquery>
		
		<cfreturn rsCIncidentesDLimite>
	</cffunction>
   
	
	<cffunction name="fnAltaCIncidentesDLimite" returntype="numeric">
		<cfargument name="CIid"  			type="numeric" 	required="yes">
		<cfargument name="CIcantidad"  		type="numeric" 	default="-1">
		<cfargument name="CItipo"  			type="string" 	required="yes">
		<cfargument name="CIcalculo"  		type="string">
		<cfargument name="CIdia"  			type="any">
		<cfargument name="CImes"  			type="any">
		<cfargument name="CIrango"  		type="any">
		<cfargument name="CIspcantidad"  	type="any">
        <cfargument name="CImescompleto"  	type="any" default="0">
        <cfargument name="CIsprango"  		type="any" default="">
		<cfargument name="Usuario"  		type="numeric">
		<cfargument name="Ecodigo"  		type="numeric">
		<cfargument name="Conexion" 		type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.CIspcantidad')> 
			<cfset Arguments.CIspcantidad = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIrango')> 
			<cfset Arguments.CIrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIdia') > 
			<cfset Arguments.CIdia = "null">
        <cfelseif isdefined('Arguments.CIdia') and len(#Arguments.CIdia#) EQ 0>
        	<cfset Arguments.CIdia = "null">
		</cfif>
		<cfif not isdefined('Arguments.CImes')> 
			<cfset Arguments.CImes = "null">
       	<cfelseif isdefined('Arguments.CImes') and len(#Arguments.CImes#) EQ 0>
        	<cfset Arguments.CImes = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIrango')> 
			<cfset Arguments.CIrango = "null">
		<cfelseif isdefined('Arguments.CIrango') and len(#Arguments.CIrango#) EQ 0>
        	<cfset Arguments.CIrango = "null">
        </cfif>
		<cfif not isdefined('Arguments.CIsprango')> 
			<cfset Arguments.CIsprango = "null">
        <cfelseif isdefined('Arguments.CIsprango') and len(#Arguments.CIsprango#) EQ 0>
        	<cfset Arguments.CIsprango = "null">
        </cfif>
		<cfif not isdefined('Arguments.CIcalculo')> 
			<cfset Arguments.CIcalculo = "null">
		</cfif>
        
    <!---				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,--->
		<cfquery name="rsAltaFVariablesDinamicas" datasource="#Arguments.Conexion#">
			insert into CIncidentesDLimite(CIid, CIcantidad,CItipo, CIdia, CImes,  CIrango, CIcalculo, CIsprango, CIspcantidad, CImescompleto, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Arguments.CIcantidad)#">,
                <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CItipo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIdia#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CImes#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIrango#">,
           		<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#Arguments.CIcalculo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIsprango#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIspcantidad#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CImescompleto#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			)
		</cfquery>
		<cfreturn #Arguments.CIid#> 
	</cffunction>
	
     
    
	<cffunction name="fnCambioCIncidentesDLimite" returntype="numeric">
		<cfargument name="CIid"  			type="numeric" 	required="yes">
		<cfargument name="CIcantidad"  		type="numeric" 	default="-1">
		<cfargument name="CItipo"  			type="string" 	required="yes">
		<cfargument name="CIcalculo"  		type="string">
		<cfargument name="CIdia"  			type="any">
		<cfargument name="CImes"  			type="any">
		<cfargument name="CIrango"  		type="any">
		<cfargument name="CIspcantidad"  	type="any">
        <cfargument name="CImescompleto"  	type="any" default="0">
        <cfargument name="CIsprango"  		type="any" default="">
		<cfargument name="Usuario"  		type="numeric">
		<cfargument name="Ecodigo"  		type="numeric">
		<cfargument name="Conexion" 		type="string">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usuario')>
			<cfset Arguments.Usuario = session.usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.CIspcantidad')> 
			<cfset Arguments.CIspcantidad = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIrango')> 
			<cfset Arguments.CIrango = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIdia') > 
			<cfset Arguments.CIdia = "null">
        <cfelseif isdefined('Arguments.CIdia') and len(#Arguments.CIdia#) EQ 0>
        	<cfset Arguments.CIdia = "null">
		</cfif>
		<cfif not isdefined('Arguments.CImes')> 
			<cfset Arguments.CImes = "null">
       	<cfelseif isdefined('Arguments.CImes') and len(#Arguments.CImes#) EQ 0>
        	<cfset Arguments.CImes = "null">
		</cfif>
		<cfif not isdefined('Arguments.CIrango')> 
			<cfset Arguments.CIrango = "null">
		<cfelseif isdefined('Arguments.CIrango') and len(#Arguments.CIrango#) EQ 0>
        	<cfset Arguments.CIrango = "null">
        </cfif>
		<cfif not isdefined('Arguments.CIsprango')> 
			<cfset Arguments.CIsprango = "null">
        <cfelseif isdefined('Arguments.CIsprango') and len(#Arguments.CIsprango#) EQ 0>
        	<cfset Arguments.CIsprango = "null">
        </cfif>
		<cfif not isdefined('Arguments.CIcalculo')> 
			<cfset Arguments.CIcalculo = "null">
		</cfif>
        
		<cfquery datasource="#Arguments.Conexion#">
			update CIncidentesDLimite set 
				CIcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Arguments.CIcantidad)#">,
				CIspcantidad = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIspcantidad#">,
				CItipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CItipo#">,
				CIcalculo = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#Arguments.CIcalculo#">,
				CIdia = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIdia#">,
				CImes = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CImes#">,
				CImescompleto = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CImescompleto#">,
				CIrango = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIrango#">,
				CIsprango = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CIsprango#">,
				<!---Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,--->
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
		</cfquery>
		<cfreturn #Arguments.CIid#>
	</cffunction>
</cfcomponent>