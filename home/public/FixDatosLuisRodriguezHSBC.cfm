<cfif isdefined("session.Usulogin") and len(trim(session.Usulogin))>
	<cfset LvarQPctaBancoid = ''>
     
    
	<cfquery name="rsTagActualizar" datasource="#session.DSN#">
        select QPTidTag
        from QPassTag
        where QPTPAN in ('5061040000016809', '5061040000016791', '5061040000016783')
        and Ecodigo = #session.Ecodigo#
    </cfquery>
    <cfdump var="#rsTagActualizar#" label="Tags por Actualizar"><!---<cfabort>--->
    
    <cfloop query="rsTagActualizar">
        <cfquery name="rsVenta" datasource="#session.DSN#">
            select QPcteid, QPvtaTagid, QPctaSaldosid
            from QPventaTags
            where QPTidTag  = #rsTagActualizar.QPTidTag# 
        </cfquery>
        <cfset LvarQPcteid = rsVenta.QPcteid>
        
        <cfquery name="rsMoneda" datasource="#session.DSN#">
            select Mcodigo
            from Monedas
            where Ecodigo = #session.Ecodigo#
            and Miso4217 = 'CRC'
        </cfquery>
        
        <cfset LvarMcodigo = rsMoneda.Mcodigo>
        
        <cfquery name="rsCuentaBanco" datasource="#session.DSN#">
            select QPctaBancoid
            from QPcuentaBanco
            where Ecodigo 		 = #session.Ecodigo#
              and QPctaBancoNum  = '0942604817-4'
        </cfquery>
         <cfset LvarQPctaBancoid = rsCuentaBanco.QPctaBancoid>
    
        <cftransaction>
            <cfif rsCuentaBanco.recordcount eq 0>
                <cfquery name="rsQPcuentaBanco" datasource="#session.DSN#">
                    insert into QPcuentaBanco (
                        Ecodigo,
                        QPctaBancoTipo,
                        QPctaBancoNum,
                        QPctaBancoCC,
                        QPcteid,
                        Mcodigo,       			<!--- Moneda del cliente con el banco --->
                        BMusucodigo,
                        BMFecha
                    )
                   values(
                        #session.Ecodigo#,
                        '',
                        '0942604817-4',
                        '',
                        #LvarQPcteid#,
                        #LvarMcodigo#,
                        #session.Usucodigo#,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                   )
                    <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
                </cfquery>
                <cf_dbidentity2 datasource="#Session.DSN#" name="rsQPcuentaBanco" verificar_transaccion="false" returnvariable="QPctaBancoid">
                <cfset LvarQPctaBancoid = QPctaBancoid>
            </cfif>
            
            <!--- 3 Inserta siempre la tabla de saldos. --->
            <cfquery name="rsParametroModenaSaldo" datasource="#session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = #session.Ecodigo#
                and Pcodigo = 447
            </cfquery>
            <cfif rsParametroModenaSaldo.recordcount eq 0>
                <cfthrow message="Se debe definir la moneda de la cuenta de saldos." detail="Definir la moneda en: Administración del Sistema, Parámetros Adicionales, Parametro Moneda de la Cuenta de Saldos y darle click al botón Aceptar.">
                <cftransaction action="rollback"/>
                <cfabort>
            </cfif>
            
            <cfquery name="rs" datasource="#session.DSN#">
                select QPctaBancoid
                from QPcuentaSaldos
                where QPctaSaldosid = #rsVenta.QPctaSaldosid#
            </cfquery>
            ID de la cuenta de Banco antes de la actualizaci&oacute;n: <cfoutput><cfif isdefined("rs") and len(trim(rs.QPctaBancoid))>#rs.QPctaBancoid#<cfelse>null</cfif></cfoutput><br />
    
    
            <cfquery datasource="#session.DSN#">
                update QPcuentaSaldos 
                set QPctaBancoid = #LvarQPctaBancoid#
                where QPctaSaldosid = #rsVenta.QPctaSaldosid#
            </cfquery>
            
            <cfquery name="rs" datasource="#session.DSN#">
                select QPctaBancoid
                from QPcuentaSaldos
                where QPctaSaldosid = #rsVenta.QPctaSaldosid#
            </cfquery>
            ID de la cuenta de Banco Despu&eacute;s de la actualizaci&oacute;n: <cfoutput>#rs.QPctaBancoid#</cfoutput><br />
            
            <cftransaction action="commit"/>
        </cftransaction>
    </cfloop>
    
    <cfquery name="rsTagAnular" datasource="#session.DSN#">
        select QPTidTag
        from QPassTag
        where QPTPAN = '5061040000016817'
        and Ecodigo = #session.Ecodigo#
    </cfquery>
    
    
    <cfquery name="rs" datasource="#session.DSN#">
    	select QPvtaEstado
        from QPventaTags
        where QPTidTag = #rsTagAnular.QPTidTag#
    </cfquery>
    
    Campo venta anulado antes de la anulación: <cfoutput>#rs.QPvtaEstado#</cfoutput><br />
    
    <cftransaction>
		<cfif rsTagAnular.recordcount gt 0>
            <cfquery datasource="#session.DSN#">
                update QPventaTags
                set QPvtaEstado = 3 <!--- 0 = En proceso, 1 = Aplicada, 2 = Anulada antes de Aplicar, 3 = Anulada despues de Aplicar --->
                where QPTidTag = #rsTagAnular.QPTidTag#
            </cfquery>
			
            <cfquery datasource="#session.DSN#">
                update QPassTag
                set QPTEstadoActivacion = 1
                where QPTidTag = #rsTagAnular.QPTidTag#
            </cfquery>

        </cfif>
        
        <cfquery name="rs" datasource="#session.DSN#">
            select QPvtaEstado
            from QPventaTags
            where QPTidTag = #rsTagAnular.QPTidTag#
        </cfquery>
        
        Campo venta anulado después de la anulación: <cfoutput>#rs.QPvtaEstado#</cfoutput><br />
        
        <!--- se debe eliminar el movimiento de la  Bitácora? --->
        
        <cftransaction action="commit"/>
    </cftransaction>
    
   	Actualización de ventas finalizada, anulación de venta finalizada<br />
    <a href="/cfmx/home/menu/empresa.cfm">Regresar</a><br />
</cfif>