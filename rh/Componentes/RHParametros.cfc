<cfcomponent>	
	<!---►►►►►►►Inicialización del Componente◄◄◄◄◄◄--->
	<cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

	<!---►►►►►►►Funcion para la obtencion de un parametro◄◄◄◄◄◄--->
	<cffunction name="get" returntype="string" output="false">
		<cfargument name="datasource" 	type="string" 	required="no"  hint="Nombre del DataSource">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no"  hint="Codigo Interno de la empresa">
		<cfargument name="Pvalor" 		type="numeric" 	required="yes" hint="Numero del parametro">
		<cfargument name="default" 		type="string"	default="" 	   hint="Valor por defecto, en caso de que no exista el Parametro">
		
		<!---►►►►►►► Si no se envia el DataSource se busca de Session ◄◄◄◄◄◄--->
		<cfif NOT ISDEFINED('Arguments.datasource') AND ISDEFINED('Session.dsn')>
            <cfset Arguments.datasource = Session.dsn>
        </cfif>
        
         <!---►►►►►►► Si no se envia la empresa se busca de Session ◄◄◄◄◄◄--->
		<cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
            <cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
		<cfquery datasource="#Arguments.datasource#" name="get_Pvalor">
			select rtrim(Pvalor) as Pvalor, Pdescripcion
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pvalor#">
		</cfquery>
		<cfif NOT get_Pvalor.RecordCount OR Not Len(get_Pvalor.Pvalor)>
			<cfreturn Arguments.default>
		</cfif>
		<cfreturn get_Pvalor.Pvalor>
	</cffunction>
    
    <!---►►►►►►►Funcion para la Actualizacion de un parametro◄◄◄◄◄◄--->
    <cffunction name="set" returntype="string" output="false">
		<cfargument name="datasource" 	type="string" 	required="no"  hint="Nombre del DataSource">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no"  hint="Codigo Interno de la empresa">
		<cfargument name="Pcodigo" 		type="numeric" 	required="yes" hint="Numero del parametro">
        <cfargument name="Pvalor" 		type="string" 	required="yes" hint="Valor del parametro">
        <cfargument name="Pdescripcion" type="string" 	required="yes" hint="Descripcion del parametro">
		
		<!---►►►►►►► Si no se envia el DataSource se busca de Session ◄◄◄◄◄◄--->
		<cfif NOT ISDEFINED('Arguments.datasource') AND ISDEFINED('Session.dsn')>
            <cfset Arguments.datasource = Session.dsn>
        </cfif>
        
         <!---►►►►►►► Si no se envia la empresa se busca de Session ◄◄◄◄◄◄--->
		<cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
            <cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.datasource#" name="get_Pvalor">
        	select 1
            	from RHParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfif get_Pvalor.RecordCount GT 0>
        	<cfquery name="rsDatos" datasource="#Session.DSN#">
				update RHParametros
				set Pvalor       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.pvalor)#" null="#len(trim(pvalor)) EQ 0#">,
					Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Pdescripcion)#">
				where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
        <cfelse>
        	<cfquery name="rsDatos" datasource="#Session.DSN#">
				insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
				values ( 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
				    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Pdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Pvalor)#" null="#len(trim(Arguments.Pvalor)) EQ 0#">
				)
			</cfquery>
        </cfif>
	</cffunction>
</cfcomponent>