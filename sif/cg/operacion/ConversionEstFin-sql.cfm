<cfif isdefined("Form.btnGenerar")>
	<cftransaction>
		<cfset UltimoPeriodo = Form.Speriodo>
        <cfset UltimoMes = Form.Smes - 1>
        <cfif UltimoMes EQ 0>
            <cfset UltimoPeriodo = Form.Speriodo - 1>
            <cfset UltimoMes = 12>
        </cfif>
            
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
            select Mcodigo, Mnombre
            from Monedas
            where Ecodigo = #Session.Ecodigo#
            <cfif rsParamConversion.recordCount EQ 0>
                and Mcodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedaLocal.Mcodigo#">
            </cfif>
            order by Miso4217
        </cfquery>
    		
		<cfif isdefined('Form.UtilizaTCpres') and Form.UtilizaTCpres eq 'S'>
			<cfset ListTCContaPres = "0,1">
		<cfelse>
			<cfset ListTCContaPres = "0">			
		</cfif>
			
          <cfloop query="rsMonedas">
		  	<cfloop list=#ListTCContaPres# index="LvarTIPO">
				<cfset compra   = Evaluate("form.TCambioC_#rsMonedas.Mcodigo#_#LvarTIPO#")>
				<cfset venta    = Evaluate("form.TCambioV_#rsMonedas.Mcodigo#_#LvarTIPO#")>
				<cfset promedio = Evaluate("form.TCambioP_#rsMonedas.Mcodigo#_#LvarTIPO#")>
				 
				<cfif LvarTipo EQ "0">
					<cfset LvarLblTipo = "Contable">
				<cfelse>
					<cfset LvarLblTipo = "Presupuestal">
				</cfif>

                <cfif compra eq 0>
                    <cfthrow message="El Tipo de Cambio #LvarLblTipo# de Compra para la moneda #rsMonedas.Mnombre# en el periodo #Form.Speriodo# y mes #Form.Smes#, debe ser mayor a 0. Proceso Cancelado!">
                </cfif>
                <cfif venta eq 0>
                    <cfthrow message="El Tipo de Cambio #LvarLblTipo# de Venta para la moneda #rsMonedas.Mnombre# en el periodo #Form.Speriodo# y mes #Form.Smes#, debe ser mayor a 0. Proceso Cancelado!">
                </cfif>
                <cfif promedio eq 0>
                    <cfthrow message="El Tipo de Cambio #LvarLblTipo# Promedio para la moneda #rsMonedas.Mnombre# en el periodo #Form.Speriodo# y mes #Form.Smes#, debe ser mayor a 0. Proceso Cancelado!">
                </cfif>
				
				<cfquery datasource="#Session.DSN#">
					delete from HtiposcambioConversion
					where Ecodigo  = #Session.Ecodigo#
					  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#">
					  and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">
					  and Mcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
					  and TCtipo =  #LvarTIPO#
				</cfquery>
				
				<cfquery datasource="#Session.DSN#">
					insert into HtiposcambioConversion (Ecodigo, Speriodo, Smes, Mcodigo, TCcompra, TCventa,TCpromedio, BMfecha, BMUsucodigo,TCtipo)
					values (
						#Session.Ecodigo#, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#replace(compra,',','','all')#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#replace(venta,',','','all')#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#replace(promedio,',','','all')#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 					
						#Session.Usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTIPO#">
					)
				</cfquery>
			</cfloop>
        </cfloop>
        
        
		<cfif rsParamConversion.recordCount EQ 0>
        	<cfset moneda = rsMonedaLocal.Mcodigo>
        <cfelse>
        	<cfset moneda = rsParamConversion.Pvalor>        
        </cfif>
		
		<cfquery name="rsTCHcmayor" datasource="#Session.DSN#">
			select m.TCHid,
				   ( select TCHdescripcion 
				     from HtiposcambioConversionE htc 
						WHERE htc.TCHid = m.TCHid 
						and htc.Ecodigo = m.Ecodigo
				    ) as TCHdescripcion
			from CtasMayor m
			where m.Ecodigo = #Session.Ecodigo#
			and coalesce(m.TCHid,-1) <> -1
			and (
					(select count(1) 
				     from HtiposcambioConversionD 
					 where TCHid = m.TCHid 
						  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#"> 
						  and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#"> 
						  and TCHtipo = 0) = 0
					 or
					(select count(1) 
					 from HtiposcambioConversionD 
					 where TCHid = m.TCHid 
					 	  and Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#"> 
						  and Smes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#"> 
						  and TCHtipo = 0 
						  and TCHvalor=0) > 0
				 )
		</cfquery>
		<cfif rsTCHcmayor.recordcount gt 0>
			<cfloop query="rsMonedas">
				<cfif rsMonedas.Mcodigo neq moneda>
					<cfloop list="0,1" index="LvarTIPO">
						<cfloop query="rsTCHcmayor">
							<cfquery name="rsTCH" datasource="#Session.DSN#">
								select TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha
								from HtiposcambioConversionD
								where Ecodigo = #Session.Ecodigo#
								and Speriodo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Speriodo#"> 
								and Smes      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Smes#">
								and Mcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
								and TCHtipo	  = #LvarTIPO#
								and TCHid = #rsTCHcmayor.TCHid# 
							</cfquery>
							<cfif rsTCH.TCHvalor eq 0 or rsTCH.recordcount eq 0>
								<cfif LvarTipo EQ "0">
									<cfset LvarLblTipo = "Contable">
								<cfelse>
									<cfset LvarLblTipo = "Presupuestal">
								</cfif>
								<cfthrow message="El Tipo de Cambio Historico #LvarLblTipo# en #rsTCHcmayor.TCHdescripcion# definido para la moneda #rsMonedas.Mnombre# en el periodo #Form.Speriodo# y mes #Form.Smes#, debe ser mayor a 0. Proceso Cancelado!">
							</cfif>
						</cfloop>
					</cfloop>	
				</cfif>
			</cfloop>
		</cfif>				            
	
		<cfinvoke component="sif.Componentes.CG_EstadosFinancieros" method="CG_ConversionEF">
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="Mcodigo" value="#Form.Mcodigo#"/>
			<cfinvokeargument name="Ccuenta" value="#Form.CCuentaDifCambAsi#"/>
			<cfinvokeargument name="PeriodoCerrado" value="#UltimoPeriodo#"/>
			<cfinvokeargument name="MesCerrado" value="#UltimoMes#"/>
			<cfinvokeargument name="Periodo" value="#Form.Speriodo#"/>
			<cfinvokeargument name="Mes" value="#Form.Smes#"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
			<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
		</cfinvoke> 
	</cftransaction>

<cfelseif isdefined("Form.btnActualizar")>

	<cfquery name="revParametros" datasource="#Session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 660
	</cfquery>

	<cfif revParametros.recordcount EQ 1>
		<cfquery datasource="#Session.DSN#">
			update Parametros
			set 
				Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo#">,
				BMUsucodigo = #Session.Usucodigo#
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 660
		</cfquery>

	<cfelse>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor, BMUsucodigo)
			values (
				#Session.Ecodigo#, 
				660, 
				'CG', 
				'Conversión de Moneda de Estados Financieros', 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo#">, 
				#Session.Usucodigo#
			)
		</cfquery>
	</cfif>
</cfif>

<cflocation url="ConversionEstFin.cfm">