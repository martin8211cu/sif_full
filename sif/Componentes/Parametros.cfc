<cfcomponent>
	<!---►►►►►►►Inicialización del Componente◄◄◄◄◄◄--->
	<cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>
	
	<!---►►Función para obtener un Parametro◄◄ --->
	<cffunction name="Get" access="public" returntype="string" hint="Función para obtener un Parametro">
		<cfargument name="Pcodigo" type="numeric" required="true">
		<cfargument name="Ecodigo" type="numeric" required="no">
        <cfargument name="Default" type="string"  required="no" default="0">
        <cfargument name="pvalor" type="string"  required="no" default="0">
		<cfargument name="conexion" type="string" required="no">
		<cfargument name="mcodigo" 		type="string"  required="false" default="">
		<cfargument name="pdescripcion" type="string"  required="false" default="">	
		
		<CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
			<cfset Arguments.Ecodigo = SESSION.Ecodigo>
		</CFIF>
        
        <CFIF NOT ISDEFINED('Arguments.conexion')>
			<cfset Arguments.conexion = SESSION.dsn>
		</CFIF>
		
		<cfquery datasource="#Arguments.conexion#" name="rsget_val">
			select ltrim(rtrim(Pvalor)) as Pvalor 
				from Parametros
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfif rsget_val.RecordCount and LEN(TRIM(rsget_val.Pvalor))>
			<cfreturn trim(rsget_val.Pvalor)>
		<cfelse>
			<cfif arguments.mcodigo neq "" and arguments.pdescripcion neq "">
				<cfset arguments.pvalor = Arguments.Default>
				<cfset SET( argumentCollection = arguments)>
			</cfif>
			<cfreturn trim(Arguments.Default)>
		</cfif>
	</cffunction>
    <!---►►Funcion para insertar o Actualizar un Parámetros◄◄--->
	<cffunction name="Set" access="public" hint="Funcion para insertar o Actualizar un Parámetros">		
        <cfargument name="pcodigo" 		type="numeric" required="true">
        <cfargument name="mcodigo" 		type="string"  required="true">
        <cfargument name="pdescripcion" type="string"  required="true">
        <cfargument name="pvalor" 		type="string"  required="true">		
        <cfargument name="conexion" 	type="string"  required="no">	
		<cfargument name="Ecodigo" 		type="string"  required="no">	
	
   		<CFIF NOT ISDEFINED('Arguments.conexion')>
			<cfset Arguments.conexion = SESSION.dsn>
		</CFIF>
		<CFIF NOT ISDEFINED('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = SESSION.Ecodigo>
		</CFIF>
        
        <cfquery name="rsCheck" datasource="#Arguments.conexion#">
            select count(1) as cantidad
            from Parametros 
            where Ecodigo = #Arguments.Ecodigo#
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
        </cfquery>
	
		<cfif rsCheck.cantidad eq 0>
            <cfquery datasource="#Arguments.conexion#">
                insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> , 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(session.Usucodigo)#"> 
                    )
            </cfquery>	
        <cfelse>
            <cfquery datasource="#Arguments.conexion#">
                update Parametros set 
                    Pvalor 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">,
                    Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pdescripcion)#">,
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(session.Usucodigo)#"> 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
            </cfquery>			
        </cfif>
		<cfreturn true>
	</cffunction>
	
	<!---►►Funcion para insertar o Actualizar un Parámetros◄◄--->
	<cffunction name="SetRemote" access="remote" hint="Funcion Remota para insertar o Actualizar un Parámetros" returnformat="json" returntype="struct" output="no">		
        <cfargument name="pcodigo" 		type="numeric" required="true">
        <cfargument name="mcodigo" 		type="string"  required="true">
        <cfargument name="pdescripcion" type="string"  required="true">
        <cfargument name="pvalor" 		type="string"  required="true">
        <cfargument name="conexion" 	type="string"  required="no">	
		<cfargument name="Ecodigo" 		type="string"  required="no">	
		
		<CFIF NOT ISDEFINED('Arguments.conexion')>
			<cfset Arguments.conexion = SESSION.dsn>
		</CFIF>
		<CFIF NOT ISDEFINED('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = SESSION.Ecodigo>
		</CFIF>
		
		<cfinvoke method="Set">
			<cfinvokeargument name="pcodigo" 		value="#Arguments.pcodigo#">
			<cfinvokeargument name="mcodigo" 		value="#Arguments.mcodigo#">
			<cfinvokeargument name="pdescripcion" 	value="#Arguments.pdescripcion#">
			<cfinvokeargument name="pvalor" 		value="#Arguments.pvalor#">
			<cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
			<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
		</cfinvoke>
		
		<cfset httpResponse         = structNew ()>
		<cfset httpResponse.success = 200>
		<cfset httpResponse.method  = "Parametros.SetRemote">
		<cfset httpResponse.desc    = "Todo OK">
		
		<cfreturn httpResponse>
	</cffunction>
    
</cfcomponent>