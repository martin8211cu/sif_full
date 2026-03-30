<cfcomponent hint="Componentes para el manejo de Centro de Custodias de los Activos Fijos">

	<!---►►Funcion para obtener los centro de custodia◄◄--->
    <cffunction name="get" access="public" returntype="query" hint="Funcion para obtener los centro de custodia">
    	<cfargument name="Conexion" 		type="string" 	required="no" hint="Nombre del dataSource">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" hint="Id de la empresa">
        <cfargument name="Usucodigo" 		type="numeric" 	required="no" hint="Obtener solo los CC a que tienen derecho un Usuario">
    	
        <cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        
        <cfquery name="RSCentros" datasource="#Arguments.Conexion#">
           SELECT a.CRCCid,
                  a.Ecodigo,
               	  a.DEid,
                  a.CRCCcodigo,
               	  a.CRCCdescripcion,
               	  a.CRCCfalta,
                  a.BMUsucodigo,
               	  a.ts_rversion
            from CRCentroCustodia a
            	<cfif isdefined('Arguments.Usucodigo')>
                  inner join CRCCUsuarios b
                    on a.CRCCid  = b.CRCCid 
                </cfif>
            where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              <cfif isdefined('Arguments.Usucodigo')>
               and b.Usucodigo = #Arguments.Usucodigo#
              </cfif>
            order by a.CRCCcodigo
        </cfquery>
        <cfreturn RSCentros>
    </cffunction>
</cfcomponent>