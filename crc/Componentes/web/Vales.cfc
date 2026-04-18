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

    <cffunction name="validaVale" access="public" returntype="struct">
        <cfargument name="voucher"      required="true"  type="string">
		<cfargument name="curp"         required="true"  type="string">
		<cfargument name="digital"      required="false"  type="boolean" default=false>
		<cfargument name="amount"      required="false"  type="numeric" default="0">     
        
        <cfset CRCChequearProducto = createObject("component","crc.Componentes.compra.CRCChequearProducto")>
        <cfset CRCChequearProducto.init(this.dsn,this.ecodigo)>
        <cfset qVale = CRCChequearProducto.chequearProducto(
            Tipo_Transaccion="VC",
            Num_Folio=arguments.voucher, 
            digital=arguments.digital,
            Monto=arguments.amount,
            ChequearMonto=arguments.amount gt 0
        )>
        
        <cfif isDefined("qVale.error")>
            <cfthrow message="#qVale.mensaje#"/>
        </cfif>
        <cfif arguments.digital and UCASE(TRIM(qVale.CURP)) neq UCASE(TRIM(arguments.curp))>
            <cfthrow message="CURP no coincide con el vale"/>
        </cfif>
        <cfif TRIM(qVale.Reservado) neq "">
            <cfthrow message="Vale ya reservado"/>
        </cfif>
        <cfset result = structNew()>
        <cfset result["distribuidor"] = qVale.Cliente>
        <cfset result["cuenta"] = qVale.Cuenta>
        <cfset result["cliente"] = qVale.ClienteVale>
        <cfset result["curp"] = qVale.CURP>
        <cfset result["folio"] = qVale.Folio>
        <cfset result["monto"] = qVale.Monto>
        <cfset result["digital"] = left(UCASE(TRIM(qVale.Lote)), 1) eq "W">
        <cfset result["reservado"] = TRIM(qVale.Reservado) neq "">
        <cfreturn result>
    </cffunction>
    
    <cffunction name="reservaVale" access="public" returntype="struct">
        <cfargument name="voucher"      required="true"  type="string">
		<cfargument name="curp"         required="true"  type="string">
		<cfargument name="date"         required="true"  type="string">
		<cfargument name="partials"     required="true"  type="string">
		<cfargument name="client"       required="true"  type="string">
		<cfargument name="amount"       required="true"  type="numeric">     
		<cfargument name="payment_date" required="false"  type="string">
		<cfargument name="digital"      required="false"  type="boolean" default=false>
        
        <cfset qVale = this.validaVale(
            voucher=arguments.voucher, 
            curp=arguments.curp,
            digital=arguments.digital,
            amount=arguments.amount
        )>

        <cfset result = structNew()>
        <cfset result["distribuidor"] = qVale.distribuidor>
        <cfset result["cuenta"] = qVale.cuenta>
        <cfset result["cliente"] = qVale.cliente>
        <cfset result["curp"] = qVale.curp>
        <cfset result["folio"] = qVale.folio>
        <cfset result["monto"] = arguments.amount>
        <cfset result["fecha"] = arguments.date>
        <cfset result["parciales"] = arguments.partials>
        <cfset result["fecha_inicio_pago"] = arguments.payment_date>
        
        <cfset reservado = serializeJSON(result)>

        <cfquery name="qReserva" datasource="#this.DSN#">
            update CRCControlFolio
            set Reservado = '#reservado#'
            where Ecodigo = '#this.ecodigo#' 
                and Numero like '%#arguments.voucher#%'
        </cfquery>

        <cfreturn result>
    </cffunction>
</cfcomponent>