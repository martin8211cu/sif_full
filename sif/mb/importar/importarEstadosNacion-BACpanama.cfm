<!--- IMPORTACION --->
<cfquery name="rsLinea" datasource="#session.dsn#">
	select Linea from #table_name#
</cfquery>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select *
	from ECuentaBancaria
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
</cfquery>

<cfset LvarTotalCreditos=0>
<cfset LvarTotalDebitos	=0>

<cftransaction>
	<cfoutput query="rsLinea">

		<cfif rsLinea.currentRow eq 2><!---Primeras 5 lineas no se utiliza--->
			<cfset columnas 	=  ListToArray(rsLinea.Linea, ',', true)>	
			<cfset SaldoInicial	= columnas[5]>

		<cfelseif rsLinea.currentRow lte 4><!---Primeras 4 lineas no se utiliza--->

        <cfelseif rsLinea.currentRow EQ rsLinea.RecordCount><!---Ultima Linea Encabezados--->
                       
            <!---Formula de saldo final es: (saldoIni+debitos-creditos) Pero como hay q darle vuelta a los movimientos del importador se usan (saldoIni+creditos-debitos) --->
            <cfset LvarSaldoFinal=#SaldoInicial#+#LvarTotalDebitos#-#LvarTotalCreditos#>
            
            <cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin 	= #LvarSaldoFinal#,
					ECdebitos 	=  #LvarTotalDebitos#
					,ECcreditos 	= #LvarTotalCreditos#
					,ECsaldoini 	= #SaldoInicial#
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
       
       
        <cfelseif rsLinea.currentRow gte rsLinea.RecordCount-14><!---Ultimas 14  Linea Encabezados--->
        
		<cfelse><!---demas lineas Detalles--->
			<cfset columnas =  ListToArray(rsLinea.Linea, ',', true)>	
			<cfset Fecha 		= columnas[1]>
			<cfset Transaccion	= trim(columnas[2])>
			<cfset Codigo	 	= columnas[3]>
			<cfset Referencia 	= columnas[4]>
			<cfset Debitos 		= replace(columnas[5],",","","ALL")>
			<cfset Creditos 	= replace(columnas[6],",","","ALL")>
            
            <cfset monto = 0>
            
            <cfif #Debitos# lte 0 and #Creditos# lte 0>
            	<cf_dump var="Error debitos y creditos en 0, debitos:#Debitos# y cred:#Creditos# en la linea:#rsLinea.currentRow# y la descripcion:#Referencia#">
            </cfif>
            
			<cfif Debitos gt 0>
				<cfset monto = trim(Debitos)>
				<cfset tipo = 'C'> <!---Los Debitos se guardan como Creditos--->
                <cfset LvarTotalCreditos=LvarTotalCreditos + monto>
			<cfelseif Creditos gt 0>	
				<cfset monto = trim(Creditos)>
				<cfset tipo = 'D'> <!---Los Creditos se guardan como Debitos --->
                <cfset LvarTotalDebitos=LvarTotalDebitos + monto>
			</cfif>	
			
			<cfquery datasource="#session.DSN#" name="rsBTEcodigo">
				select b.BTid,a.BTEcodigo    
					from BTransaccionesEq b
						inner join  TransaccionesBanco a
							on a.Bid = b.Bid
							and a.BTEcodigo = b.BTEcodigo
					where b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
						and b.Ecodigo = #session.Ecodigo#
						and a.BTEtipo = '#tipo#'
			</cfquery>
			
            <cfif len(trim(#rsBTEcodigo.BTid#)) eq 0>
            	<cfquery name="rsBanco" datasource="#session.dsn#">
                    select Bdescripcion from Bancos 
                    where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
                </cfquery>    
                <cf_dump var="falta definir las trassacciones o las trassacciones equivalencias para el banco: #rsBanco.Bdescripcion#">
            </cfif> 
			
			<cfquery datasource="#session.DSN#">
				insert into DCuentaBancaria (ECid, 
										 BTEcodigo,  
										 Documento, 
										 DCmontoori, 
										 DCfecha, 
										 DCmontoloc, 
										 DCReferencia, 
										 DCtipocambio, 
										 DCtipo, 
										 DCconciliado,
										 Ecodigo,
										 Bid,
										 BTid
										 ) 
				values(						 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsBTEcodigo.BTEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Transaccion#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Fecha)#">,  
					<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Referencia#">,
					1.00, 
					 '#tipo#', 
					'N', 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsBTEcodigo.BTid#" voidNull>
					)
			</cfquery>
		</cfif>
	</cfoutput>
</cftransaction>	


