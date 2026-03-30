<!---►►Componentes para el manejo de Monedas◄◄--->
<cfcomponent hint="Componentes para el manejo de Monedas">

	<!---►►Metodo para Obtener la Información de la Moneda Local◄◄--->
	<cffunction name="getMonedaLocal" returntype="query" access="public" hint="Metodo para Obtener la Información de la Moneda Local">
    	<cfargument name="Conexion" 		type="string" 	required="no" hint="Nombre del dataSource">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" hint="Id de la empresa">
    	
        <cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        
    	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">     
               SELECT Mcodigo
                FROM Empresas
              WHERE Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#"> 
     	</cfquery>
     	<cfreturn get(Arguments.Conexion,Arguments.Ecodigo,rsSQL.Mcodigo)>
   </cffunction>
   
   <!---►►Metodo para Obtener la Información referente a las monedas◄◄--->
   <cffunction name="get" returntype="query" access="public" hint="Metodo para Obtener la Información referente a las monedas">
    	<cfargument name="Conexion" 		type="string" 	required="no" hint="Nombre del dataSource">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" hint="Id de la empresa">
    	<cfargument name="Mcodigo"			type="numeric"  required="no" hint="Codigo de la moneda">
    	
        <cfif not isdefined('Arguments.Ecodigo') or len(trim(Arguments.Ecodigo)) LTE 0 or Arguments.Ecodigo LTE 0>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        
    	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">     
               SELECT Mcodigo,
                   Ecodigo,
                   Mnombre,
                   Msimbolo,
                   Miso4217,
                   BMUsucodigo,
                   ts_rversion
              FROM Monedas
              WHERE 1 = 1
          <cfif isdefined('Arguments.Mcodigo')>
          	and Mcodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Mcodigo#"> 
          </cfif>
          <cfif isdefined('Arguments.Ecodigo')>
          	and Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#"> 
          </cfif>
     	</cfquery>
      <cfreturn rsSQL>
   </cffunction>
</cfcomponent>