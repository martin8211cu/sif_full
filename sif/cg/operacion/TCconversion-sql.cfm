<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
            select Mcodigo 
            from Empresas 
            where Ecodigo = #Session.Ecodigo#
</cfquery>
 
<cfquery name="rsParamConversion" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 660
</cfquery>
		
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo, 
		   Mnombre
	from Monedas
	where Ecodigo = #Session.Ecodigo#
	<cfif rsParamConversion.recordCount EQ 0>
		and Mcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaLocal.Mcodigo#">
	</cfif>
	order by Miso4217
</cfquery>
		
<cfif isdefined("Form.btnModificar")>
	<cftransaction>      
        <cfloop query="rsMonedas">
				<cfset venta    = Evaluate("form.TCambioV_#rsMonedas.Mcodigo#_1")>
				<cfset compra   = Evaluate("form.TCambioC_#rsMonedas.Mcodigo#_1")>
				<cfset promedio = Evaluate("form.TCambioP_#rsMonedas.Mcodigo#_1")>
				 
				<cfquery  name="temp" datasource="#Session.DSN#">
					update HtiposcambioConversion
						set TCcompra = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(compra,',','','all')#">,
						    TCventa = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(venta,',','','all')#">, 
							TCpromedio= <cfqueryparam cfsqltype="cf_sql_money" value="#replace(promedio,',','','all')#">, 
							BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					where Ecodigo = #Session.Ecodigo# 		
						  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#">
						  and Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						  and TCtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
				</cfquery> 
        </cfloop>                
		<cfif rsParamConversion.recordCount EQ 0>
        	<cfset moneda = rsMonedaLocal.Mcodigo>
        <cfelse>
        	<cfset moneda = rsParamConversion.Pvalor>        
        </cfif>
            
        <cfloop query="rsMonedas">
        	<cfif rsMonedas.Mcodigo neq moneda>
					<cfquery name="rsTCH" datasource="#Session.DSN#">
						select TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha
						from HtiposcambioConversionD
						where Ecodigo = #Session.Ecodigo#
						and Speriodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#"> 
						and Smes      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">
						and Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and TCHtipo	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
					</cfquery>
					<cfif rsTCH.TCHvalor eq 0 or rsTCH.recordcount eq 0>
						<cfthrow message="El Tipo de Cambio Historico Presupuestal definido para la moneda #rsMonedas.Mnombre# en el periodo #Form.Speriodo# y mes #Form.Smes#, debe ser mayor a 0. Proceso Cancelado!">
					</cfif>
            </cfif>
        </cfloop>
    </cftransaction>
<cfelseif isdefined('InsertarTC')>

	<cfset SMes= ListFind(LB_Meses,form.Mes)>
	
	<cfquery name="Speriodo" datasource="#Session.DSn#">
			select distinct CPCano 
			from CPmeses 
			where CPPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				  and Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
			
	<cfloop query="rsMonedas">
		<cfquery name="rsTC" datasource="#Session.DSn#">
			select count(1) as cantidad
				from HtiposcambioConversion 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						  and Speriodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Speriodo.CPCano#">
						  and Smes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SMes#">
						  and TCtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
		</cfquery>
	    <cfif rsTC.cantidad eq 0>
			<cfquery name="rsTCH" datasource="#Session.DSn#">
				insert into HtiposcambioConversion (Ecodigo, Speriodo, Smes, TCtipo , Mcodigo,TCcompra,TCventa,TCpromedio,BMfecha, BMUsucodigo) 
						values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Speriodo.CPCano#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#SMes#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="1">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="0">,
								<cfqueryparam cfsqltype="cf_sql_money" value="0">,
								<cfqueryparam cfsqltype="cf_sql_money" value="0">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.usucodigo#">
								)
			</cfquery>	
		<cfelse>
			<cf_errorCode	code = "0" msg  = "Ya existe un Tipo de Cambio Presupuestario para el periodo @errorDat_1@ y mes @errorDat_2@"
								errorDat_1="#Speriodo.CPCano#"
								errorDat_2="#form.Mes#"
				>
		</cfif>
	</cfloop>
</cfif>


<cfif isdefined('form.LvarTCPres')>
	<cfset action="../../presupuesto/parametros/TipoCambioConversionPresupuesto.cfm">
<cfelse>
	<cfset action="TCconversion.cfm">
</cfif>
<cflocation url="#action#">
