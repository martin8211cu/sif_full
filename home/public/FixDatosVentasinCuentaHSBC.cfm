<cfif isdefined("session.Usulogin") and len(trim(session.Usulogin))>
	<cfset LvarQPctaBancoid = ''>
    
	<cfquery name="rsTag" datasource="#session.DSN#">
        select QPTidTag
        from QPassTag
        where QPTPAN = '5061040000041625'
    </cfquery>
    
    <cfquery name="rsVenta" datasource="#session.DSN#">
    	select QPcteid, QPvtaTagid, QPctaSaldosid
        from QPventaTags
        where QPTidTag  = #rsTag.QPTidTag# 
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
          and QPctaBancoNum  = '01405012958'
          and QPctaBancoTipo = 'MAESTRA'
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
                    'MAESTRA',
                    '01405012958',
                    '10400102648020119',
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
    
   	Actualización de venta finalizada<br />
    <a href="/cfmx/home/menu/empresa.cfm">Regresar</a><br />
</cfif>