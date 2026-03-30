<cfcomponent output="false" displayname="Vales" 
    extends="crc.Componentes.CRCBase" 
    hint="Componente para manejo de vales"
>
    
    <cffunction name="init" access="public" output="no" returntype="Vales" hint="constructor del componente con parametros de entradas primarios">  
        <cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
        <cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >      
        <cfset Super.init(arguments.DSN, arguments.Ecodigo)>

        <cfreturn this>
    </cffunction>

    <cffunction name="obtenerVales" access="public" returntype="struct">
        <cfargument name="CUENTAID" required="true" type="string">
        <cfargument name="ESTADO" required="false" default="" type="string">
        <cfargument name="SEARCH" required="false" default="" type="string">
        <cfargument name="PageNumber" required="false" type="string" default="1">
        <cfargument name="PageSize" required="false" type="string" default="10">

        <cfquery name="qMetadataQuery" datasource="#this.DSN#">
            SELECT COUNT(*) AS TotalRecords
            from CRCControlFolio
            where CRCCuentasid = #arguments.CUENTAID#
                and Lote like 'W%'
            <cfif structKeyExists(arguments, "ESTADO") and arguments.ESTADO neq "">
                and Estado = '#arguments.ESTADO#'
            </cfif>
            <cfif structKeyExists(arguments, "SEARCH") and arguments.SEARCH neq "">
                and (Numero like '%#arguments.SEARCH#%' 
                        or Cliente like '%#arguments.SEARCH#%' 
                        or CURP like '%#arguments.SEARCH#%'
                )
            </cfif>
        </cfquery>

        <cfset total = this.db.queryRowToStruct(qMetadataQuery, 1)>

        <cfset metadata = {
            TotalRecords = total.TotalRecords,
            TotalPages = ceiling(total.TotalRecords / arguments.PageSize),
            PageNumber = arguments.PageNumber,
            PageSize = arguments.PageSize
        }>


        <cfquery name="qVales" datasource="#this.DSN#">
            select id, CRCCuentasid, Lote, Numero, Estado, FechaHasta, FechaExpiracion, createdat, Cliente, CURP, Monto, Direccion
            from CRCControlFolio
            where CRCCuentasid = #arguments.CUENTAID#
                and Lote like 'W%'
            <cfif structKeyExists(arguments, "ESTADO") and arguments.ESTADO neq "">
                and Estado = '#arguments.ESTADO#'
            </cfif>
            <cfif structKeyExists(arguments, "SEARCH") and arguments.SEARCH neq "">
                and (Lote like '%#arguments.SEARCH#%' 
                        or Numero like '%#arguments.SEARCH#%' 
                        or Cliente like '%#arguments.SEARCH#%' 
                        or CURP like '%#arguments.SEARCH#%'
                )
            </cfif>
            order by Numero desc
            OFFSET (#PageNumber# - 1) * #PageSize# ROWS 
            FETCH NEXT #PageSize# ROWS ONLY
        </cfquery>

        <cfset data = this.db.queryToArray(qVales)>

        <cfset sreturn =  structNew()>
        <cfset sreturn.metadata = metadata>
        <cfset sreturn.items = data>

        <cfreturn sreturn>
    </cffunction>

    <cffunction name="obtenerVale" access="public" returntype="struct">
        <cfargument name="NUMERO" required="true" type="string">

        <cfquery name="qVale" datasource="#this.DSN#">
            select id, CRCCuentasid, Lote, Numero, Estado, FechaHasta, FechaExpiracion, createdat, Cliente, CURP, Monto, Direccion
            from CRCControlFolio
            where Lote like 'W%'
                and Numero like '%#arguments.NUMERO#%'
        </cfquery>
        <cfset data = this.db.queryRowToStruct(qVale, 1)>

        <cfreturn data>
    </cffunction>
    
    <cffunction name="cancelarVale" access="public" returntype="struct">
        <cfargument name="NUMERO" required="true" type="string">

        <cfquery name="qVale" datasource="#this.DSN#">
            update CRCControlFolio
            set Estado = 'X'
            where Lote like 'W%'
                and Numero like '%#arguments.NUMERO#%'
        </cfquery>

        <cfquery name="qVale" datasource="#this.DSN#">
            select id, CRCCuentasid, Lote, Numero, Estado, FechaHasta, FechaExpiracion, createdat, Cliente, CURP, Monto, Direccion
            from CRCControlFolio
            where Lote like 'W%'
                and Numero like '%#arguments.NUMERO#%'
        </cfquery>
        <cfset data = this.db.queryRowToStruct(qVale, 1)>

        <cfreturn data>
    </cffunction>

    <cffunction name="crearVale" access="public" returntype="struct">
        <cfargument name="CUENTAID"  required="true"  type="string" >
        <cfargument name="CLIENTE"  required="true"  type="string" >
        <cfargument name="CURP"  required="true"  type="string" >
        <cfargument name="MONTO"  required="true"  type="numeric" >
        <cfargument name="DIRECCION"  required="true"  type="string" >

        <cfquery name="qCuenta" datasource="#this.DSN#">
            select id, Numero
            from CRCCuentas
            where id = #arguments.CUENTAID#
        </cfquery>

        <cfif qCuenta.recordCount eq 0>
            <cfthrow message="La cuenta no existe."/>
        </cfif>

        <cfset var loc = structNew()>
        <cfset loc.lote = "W" & RIGHT('0000000' & '#qCuenta.Numero#', 7)>
        <cfset loc.prenumero ="#DateFormat(now(),'YYMM')#0">
		<cfquery name="rsMaxConsecutivoFolio" datasource="#this.DSN#">
			select cast(right( COALESCE(max(Numero),0),4) as integer) as consecutivo
			from CRCControlFolio where Numero like '#loc.prenumero#%' and Ecodigo = #this.Ecodigo#
		</cfquery>
        <cfset loc.numfolio = rsMaxConsecutivoFolio.consecutivo>
        <cfset loc.numfolio = loc.numfolio + 1>
        <cfset loc.strNumero = "0000#loc.numfolio#">
        <cfset loc.numero="#loc.prenumero##right(loc.strNumero,4)#">

        <cfquery name="insertaFolio" datasource="#this.DSN#">
             INSERT INTO CRCControlFolio
                (CRCCuentasid, Lote, Numero, Estado, Ecodigo, FechaExpiracion, createdat, Cliente, CURP, Monto, Direccion)
            VALUES
                (#arguments.CUENTAID#, 
                 '#loc.lote#', 
                 '#loc.numero#',
                 'A', 
                 #this.Ecodigo#,
                 DATEADD(DAY, 30, GETDATE()), 
                 GETDATE(),
                 '#arguments.CLIENTE#',
                 '#arguments.CURP#',
                 #arguments.MONTO#,
                 '#arguments.DIRECCION#'
                )
        </cfquery>
        <cfquery name="qFolio" datasource="#this.DSN#">
            select id, CRCCuentasid, Lote, Numero, Estado, FechaHasta, FechaExpiracion, createdat, Cliente, CURP, Monto, Direccion
            from CRCControlFolio
            where CRCCuentasid = #arguments.CUENTAID#
                and Numero = #loc.numero#
                and Ecodigo = #this.Ecodigo#
        </cfquery>
        <cfset data = this.db.queryRowToStruct(qFolio, 1)>
        <cfreturn data>
    </cffunction>
</cfcomponent>