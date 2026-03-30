<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
        <cftransaction>
            <cfquery name="insert" datasource="#Session.DSN#">
                insert into HtiposcambioConversionE(Ecodigo,TCHcodigo,TCHdescripcion) 
                values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TCHcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TCHdescripcion#">
                )
                <cf_dbidentity1 datasource="#session.DSN#">	
            </cfquery>	
            <cf_dbidentity2 datasource="#session.DSN#" name="insert">
            
            <cfquery name="rsMonedas" datasource="#Session.DSN#">
                select Mcodigo
                 from Monedas
                where Ecodigo = #Session.Ecodigo#
                order by Miso4217
            </cfquery>
            
            <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
                select Mcodigo 
                from Empresas 
                where Ecodigo = #Session.Ecodigo#
            </cfquery>
            
            <cfif not isdefined("form.McodigoD") and len(trim(form.McodigoD)) eq 0>
            	<cfset form.McodigoD = rsMonedaLocal.Mcodigo>
            </cfif>
            
            <cfloop query="rsMonedas">
                <cfif rsMonedas.Mcodigo neq form.McodigoD>
                    <cfquery name="insertD" datasource="#Session.DSN#">
                        insert into HtiposcambioConversionD(TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha,BMUsucodigo,TCHtipo) 
                        values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SperiodoD#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SmesD#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="0">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
                        #Session.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHtipo#">
                        )
                    </cfquery>                
                </cfif>
            </cfloop>
        
    	</cftransaction>
		<cfset var = insert.identity>	   
    	<cfset modo="CAMBIO">
        
    <cfelseif isdefined("Form.Baja")>
        <cftransaction>
            <cfquery name="deleteD" datasource="#session.DSN#">
                delete from HtiposcambioConversionD
                where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
                and  TCHid = <cfqueryparam value="#form.TCHid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <cfquery name="deleteE" datasource="#session.DSN#">
                delete from HtiposcambioConversionE
                where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
                and  TCHid = <cfqueryparam value="#form.TCHid#" cfsqltype="cf_sql_numeric">
            </cfquery>
        </cftransaction>
    	<cfset modo="BAJA">
    
    <cfelseif isdefined("Form.Cambio")>
    	<cftransaction>
            <cfquery name="update" datasource="#Session.DSN#">
                update HtiposcambioConversionE set
                TCHcodigo = <cfqueryparam value="#Form.TCHcodigo#" cfsqltype="cf_sql_varchar">,
                TCHdescripcion = <cfqueryparam value="#Form.TCHdescripcion#" cfsqltype="cf_sql_varchar">
                where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
                and  TCHid = <cfqueryparam value="#form.TCHid#" cfsqltype="cf_sql_numeric">
            </cfquery> 
            <cfset var = form.TCHid>
        </cftransaction>
    	<cfset modo="CAMBIO">
        
    <cfelseif isdefined("Form.CambioTC")>
    	<cfquery name="rsMonedas" datasource="#Session.DSN#">
            select Mcodigo
             from Monedas
            where Ecodigo = #Session.Ecodigo#
            order by Miso4217
        </cfquery>
        
        <cfquery name="rsTCambioD" datasource="#Session.DSN#">
            select *
             from HtiposcambioConversionD
            where Ecodigo = #Session.Ecodigo#
            and TCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHid#">
            and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SperiodoD#">
            and Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SmesD#">
			and TCHtipo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHtipo#">
        </cfquery>
        
        <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
            select Mcodigo 
            from Empresas 
            where Ecodigo = #Session.Ecodigo#
        </cfquery>
        
        <cfif not isdefined("form.McodigoD") and len(trim(form.McodigoD)) eq 0>
            <cfset form.McodigoD = rsMonedaLocal.Mcodigo>
        </cfif>
            
        <cfloop query="rsMonedas">
			<cfif rsMonedas.Mcodigo neq form.McodigoD>
				<cfset valor = Evaluate("form.TCambio_#rsMonedas.Mcodigo#")>
                <cfif rsTCambioD.recordcount gt 0>
                    <cfquery name="insertD" datasource="#Session.DSN#">
                        update HtiposcambioConversionD set 
                        TCHvalor     = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(valor,',','','all')#">, 
                        BMfecha      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
                        BMUsucodigo  = #Session.Usucodigo#
                        where TCHid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHid#">
                        and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                        and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SperiodoD#">
                        and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SmesD#">
                        and Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and TCHtipo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHtipo#">
                    </cfquery>
                <cfelse>
                    <cfquery name="insertD" datasource="#Session.DSN#">
                        insert into HtiposcambioConversionD(TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha,BMUsucodigo,TCHtipo) 
                        values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHid#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SperiodoD#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SmesD#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#replace(valor,',','','all')#">, 
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
                        #Session.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHtipo#">
                        )
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
        <cfset var = form.TCHid>
        <cfset modo="CAMBIO">
    </cfif>
</cfif>
<cfoutput>
	<cfif isdefined('LvarTCHpresupuesto')>				
		<cfset actionTCH="../../presupuesto/parametros/TCHistoricos.cfm">
	<cfelse>
		<cfset actionTCH="TCHistoricos.cfm">		
	</cfif>
	<cfif modo eq 'CAMBIO'>		
		<cflocation url="#actionTCH#?TCHid=#var#&modo=CAMBIO&Speriodo=#form.SperiodoD#&Smes=#form.SmesD#&Mcodigo=#form.McodigoD#&tab=#form.TCHtipo#">
	<cfelse>
		<cflocation url="#actionTCH#?Speriodo=#form.SperiodoD#&Smes=#form.SmesD#&Mcodigo=#form.McodigoD#&tab=#form.TCHtipo#">
	</cfif>
</cfoutput>