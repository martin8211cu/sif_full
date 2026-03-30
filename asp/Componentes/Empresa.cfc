
<cfcomponent>
		<cffunction name="AltaEmpresaERP" access="public" returntype="any" hint="Agregar una empresa en ERP">
            <cfargument name="CEcodigo" 		type="numeric" 	required="yes">
            <cfargument name="Cid" 				type="numeric"	required="yes">
            <cfargument name="Mcodigo" 			type="numeric"	required="yes">
            <cfargument name="Enombre" 			type="string"	required="yes">
            <cfargument name="Etelefono1" 		type="string"	required="no" default=""> 
            <cfargument name="Etelefono2" 		type="string"	required="no" default=""> 
            <cfargument name="Efax" 			type="string"	required="no" default=""> 
            <cfargument name="Eidentificacion" 	type="string"	required="no" default=""> 
          	<cfargument name="BMUsucodigo" 		type="numeric"	required="yes">
            <cfargument name="Elogo" 			type="any"		required="no" default=""> 
            <cfargument name="Enumero" 			type="string"	required="no" default="">
            <cfargument name="Eactividad" 		type="string"	required="no" default=""> 
            <cfargument name="Enumlicencia" 	type="string"	required="no" default=""> 
            <cfargument name="Eidresplegal" 	type="string"	required="no" default=""> 
            <cfargument name="Conexion" 		type="string"	required="no" default="asp"> 
            <cfargument name="TransaccionAtiva" type="boolean"  required="no" default="false" >
         
            
           
            <!--- Inserta la direccion --->
            <cf_direccion action="readform" name="data" Conexion="#Arguments.Conexion#">
            <cf_direccion action="insert" name="data" data="#data#" Conexion="#Arguments.Conexion#">
            
            <cfquery name="rsMaxEmpresa" datasource="#Arguments.Conexion#">
                select coalesce(max(Ereferencia), 0)+1 as Ereferencia
                from Empresa		
            </cfquery>

			<cfif Arguments.TransaccionAtiva >
               <cfset AltaEmpresaERPLogica(Arguments)>
            <cfelse>
                <cftransaction>
                     <cfset AltaEmpresaERPLogica(Arguments)>
                </cftransaction>
            </cfif> 
        <cfreturn rs>
    </cffunction>
    
    <cffunction name="AltaEmpresaERPLogica" access="private"> 
        <cfargument name="Arguments" type="any"  required="no">
    	<cfquery name="rs" datasource="#Arguments.Conexion#">
            insert INTO  Empresa (CEcodigo, id_direccion, Cid, Mcodigo, Enombre, Etelefono1, Etelefono2, Efax, Ereferencia, Eidentificacion, BMfecha, BMUsucodigo, Elogo, Enumero, Eactividad, Enumlicencia, Eidresplegal)
            values ( 
                    <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#Arguments.CEcodigo#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#data.id_direccion#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Enombre#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Etelefono1#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Etelefono2#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Efax#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_integer" 	value="#rsMaxEmpresa.Ereferencia#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Eidentificacion#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_timestamp"value="#Now()#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_blob" 	value="#Arguments.Elogo#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Enumero#" voidnull>
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Eactividad#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Enumlicencia#">
                    , <cf_jdbcquery_param 	cfsqltype="cf_sql_varchar" 	value="#Arguments.Eidresplegal#">
                    )
            <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rs">
        
        <cfif isdefined('form.escorporativa') and  form.escorporativa EQ 1>
        <cfquery datasource="#Arguments.Conexion#">
            update CuentaEmpresarial
            set Ecorporativa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
            where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
        </cfquery>
    </cfif>

    <cfif Not IsDefined('form.auditar')>
        <cfinvoke component="asp.admin.bitacora.catalogos.PBitacoraEmp.activar" method="inactivarEmpresa" Ecodigo="#rs.identity#" Conexion="#Arguments.Conexion#"/>
    </cfif>

    <!--- Averiguar Codigo de Referencia, Moneda y Cache para la Empresa --->
    <cfquery name="rsNewEmpresa" datasource="#Arguments.Conexion#">
        select b.Ccache, a.Ereferencia, a.Enombre, c.Mnombre, Msimbolo, Miso4217
        from Empresa a, Caches b, Moneda c
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
        and a.Cid = b.Cid
        and a.Mcodigo = c.Mcodigo
    </cfquery>

    <cfset cache = rsNewEmpresa.Ccache>

    <cfquery name="rsFindMoneda" datasource="#cache#">
        Select Mcodigo
        from Monedas
        where Miso4217=<cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
    </cfquery>
        
    <!--- NO existe la moneda en la base de datos de referencia --->		
    <cfif isdefined('rsFindMoneda') and rsFindMoneda.recordCount EQ 0>

            <!--- Insertar moneda en la base de datos referencia --->
            <cfquery name="rsMoneda" datasource="#cache#">
                insert INTO  Monedas(Ecodigo, Mnombre, Msimbolo, Miso4217)
                values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Mnombre#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Msimbolo#">,
                         <cfqueryparam cfsqltype="cf_sql_char" value="#rsNewEmpresa.Miso4217#">
                )
                <cf_dbidentity1 datasource="#cache#">
            </cfquery>
            <cf_dbidentity2 datasource="#cache#" name="rsMoneda">
    
            <cfquery name="rsFindEmpresa" datasource="#cache#">
                Select Ecodigo
                from Empresas
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewEmpresa.Ereferencia#">
            </cfquery>	
            
            <!--- NO existe la Empresa en la base de datos de referencia --->		
            
         
            
            <cfif isdefined('rsFindEmpresa') and rsFindEmpresa.recordCount EQ 0>
                <!--- Insertar la empresa en la base de datos referencia --->
                <cfquery name="rsEmpresa" datasource="#cache#">
                    insert INTO  Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC)
                    values ( 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNewEmpresa.Ereferencia#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.identity#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNewEmpresa.Enombre#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="00">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cache#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,	
                         <cfif isdefined('session.Ulocalizacion')>
                            <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
                         <cfelse>
                            null,
                         </cfif>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.identity#">
                    )
                </cfquery>
            </cfif>
        </cfif>
    </cffunction>
    
</cfcomponent>







