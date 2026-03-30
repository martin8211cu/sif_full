<cfcomponent>
 	<!---►►►Agregar una nueva Mascara del Socio de Negocio◄◄◄--->
    <cffunction name="AltaSNMascaras" output="false" access="public" returntype="numeric">
		<cfargument name="SNtipo" 		  type="string" required="true"  hint="Tipo Identificacion">
        <cfargument name="SNMDescripcion" type="string" required="true"  hint="Descripcion del Tipo Socio de Negocio">
        <cfargument name="SNMascara" 	  type="string" required="true"  hint="Mascara de la Indentificacion del SN">
        <cfargument name="Conexion" 	  type="string" required="false" hint="Conexion del Data Source">
        <cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfquery name="Ins_SNMascaras" datasource="#Arguments.Conexion#">
        	insert SNMascaras (SNtipo,Ecodigo, SNMDescripcion,SNMascara,fechaalta, BMUsucodigo) values(
           		<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNtipo#" 		  len="1">,
                #Session.Ecodigo#,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNMDescripcion#" len="60">, 
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNMascara#" 	  len="30">, 
            	<cf_dbfunction name="now">, 
                #session.Usucodigo#)
			<cf_dbidentity1>       
        </cfquery>
        	<cf_dbidentity2 name="Ins_SNMascaras">
            <cfreturn Ins_SNMascaras.identity>
	</cffunction>
    <!---►►►Modificar una Mascara de un Socio de Negocio◄◄◄--->
    <cffunction name="CambioSNMascaras" output="false" access="public">
        <cfargument name="SNMid" 		  type="numeric" required="true"  hint="Id de la Mascara">
        <cfargument name="SNtipo" 		  type="string"  required="true"  hint="Tipo Identificacion">
        <cfargument name="SNMDescripcion" type="string"  required="true"  hint="Descripcion del Tipo Socio de Negocio">
        <cfargument name="SNMascara" 	  type="string"  required="true"  hint="Mascara de la Indentificacion del SN">
        <cfargument name="ts_rversion" 	  type="any" 	 required="true"  hint="Marca de Tiempo">
        <cfargument name="Conexion" 	  type="string"  required="false" hint="Conexion del Data Source">
        
        <cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        
        <cf_dbtimestamp datasource="#session.dsn#" table="SNMascaras" redirect="SNMascara.cfm" timestamp="#Arguments.ts_rversion#" field1="SNMid,numeric,#Arguments.SNMid#">
                    
        <cfquery name="Upd_SNMascaras" datasource="#Arguments.Conexion#">
        	update SNMascaras set 
            	SNtipo			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNtipo#" 		  len="1">,
                SNMDescripcion 	= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNMDescripcion#"   len="60">,
                SNMascara 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.SNMascara#" 	      len="30">,
                fechaalta 		= <cf_dbfunction name="now">, 
                BMUsucodigo 	= #session.Usucodigo#
            where SNMid 		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SNMid#">
        </cfquery>
	</cffunction>
     <!---►►►Eliminar una Mascara de un Socio de Negocio◄◄◄--->
    <cffunction name="BajaSNMascaras" output="false" access="public">
        <cfargument name="SNMid" 		  type="numeric" required="true"  hint="Id de la Mascara">
        <cfargument name="ts_rversion" 	  type="any" 	 required="true"  hint="Marca de Tiempo">
        <cfargument name="Conexion" 	  type="string"  required="false" hint="Conexion del Data Source">
        
        <cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        
        <cf_dbtimestamp datasource="#session.dsn#" table="SNMascaras" redirect="SNMascara.cfm" timestamp="#Arguments.ts_rversion#" field1="SNMid,numeric,#Arguments.SNMid#">
        <cfquery name="del_SNMascaras" datasource="#Arguments.Conexion#">
        	select count(1) cantidad from SNegocios where SNMid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SNMid#">
        </cfquery> 
        <cfif del_SNMascaras.cantidad>
        	<cfthrow message="Existen #del_SNMascaras.cantidad# Socios de Negocios que ya está usando la Mascara que desea eliminar.">
        </cfif>        
        <cfquery datasource="#Arguments.Conexion#">
        	delete from SNMascaras            	
            where SNMid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.SNMid#">
        </cfquery>
	</cffunction>
     <!---►►►Obtienen todas las mascaras para los Socios de Negocios◄◄◄--->
    <cffunction name="GetSNMascaras" output="false" access="public" returntype="query">
        <cfargument name="Conexion" 	  type="string"  required="false" hint="Conexion del Data Source">
        
        <cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
                    
        <cfquery name="get_SNMascaras" datasource="#Arguments.Conexion#">
        	select SNMid,SNtipo,SNMDescripcion,SNMascara 
            	from SNMascaras            	
            where Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfreturn get_SNMascaras>
	</cffunction>
</cfcomponent>