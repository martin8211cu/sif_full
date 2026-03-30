<cfcomponent hint="Componente para el manejo de Pólizas de Desalmacenaje en las Ordenes de compra por importacion">
	
    <!---►►valida q las líneas de la póliza tengan país de origen, código aduanal e impuesto asociado◄◄--->
    <cffunction name="ValidaDPolizaDesalmacenaje" access="public" hint="valida q las líneas de la póliza tengan país de origen, código aduanal e impuesto asociado">
    	<cfargument name="Conexion" type="string"  required="no"  hint="Nombre de la conexion">
        <cfargument name="Ecodigo"  type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="EPDid"    type="numeric" required="yes" hint="Encabzado de la poliza de Desalmacenamiento">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('SESSION.dsn')>
        	<CFSET  Arguments.Conexion = SESSION.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('SESSION.Ecodigo')>
        	<CFSET  Arguments.Ecodigo = SESSION.Ecodigo>
        </cfif>
        
        <cfquery name="rsvalini" datasource="#Arguments.Conexion#">
            SELECT DPDlinea as cod
            FROM DPolizaDesalmacenaje
            WHERE EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPDid#">
              AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            AND (CAid is null
                OR DPDpaisori is null
                OR Icodigo is null)
        </cfquery>
        <cfif rsvalini.recordcount>
            <cf_errorCode	code = "50320" msg = "Verifique que las líneas de la póliza tengan país de origen, código aduanal e impuesto asociados. Proceso cancelado!">
        </cfif>
    </cffunction>
    <!---►►◄◄--->
    <cffunction name="DeleteFacturasGastoItem" access="public" hint="">
    	<cfargument name="Conexion" type="string"  required="no"  hint="Nombre de la conexion">
        <cfargument name="Ecodigo"  type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="EPDid"    type="numeric" required="yes" hint="Encabezado de la poliza de Desalmacenamiento">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('SESSION.dsn')>
        	<CFSET  Arguments.Conexion = SESSION.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('SESSION.Ecodigo')>
        	<CFSET  Arguments.Ecodigo = SESSION.Ecodigo>
        </cfif>
    
        <cfquery name="deletefacturasitem" datasource="#Arguments.Conexion#">
            DELETE from FacturasGastoItem
            WHERE DPDlinea in ( SELECT DPDlinea
                                	FROM DPolizaDesalmacenaje
                                WHERE EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EPDid#">
                                  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">)
        </cfquery>
    </cffunction>
</cfcomponent>