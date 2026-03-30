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

		<cfif rsLinea.currentRow lte 7><!---Primeras 7 lineas no se utiliza--->

		<cfelseif rsLinea.currentRow eq 8><!---Aqui esta el saldo inicial--->
			
			<cfset SaldoInicial 	= replace(mid(rsLinea.Linea,  16, 40 ),",","","ALL")>
            
        <cfelseif rsLinea.currentRow gte rsLinea.RecordCount><!---Ultima Linea actualizaciones--->

            <cfquery datasource="#session.DSN#" name="rsTotales">
				select ECsaldoini 
				from ECuentaBancaria
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
            
            <!---Formula de saldo final es: (saldoIni+debitos-creditos)--->
            <cfset LvarSaldoFinal=#SaldoInicial# + #LvarTotalDebitos#  -  #LvarTotalCreditos# >
            
            <cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin 	= #LvarSaldoFinal#,
					ECdebitos 	=   #LvarTotalDebitos#    
					,ECcreditos 	= #LvarTotalCreditos#
					,ECsaldoini 	= #SaldoInicial#
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>

            
        <cfelseif rsLinea.currentRow gte rsLinea.RecordCount-4><!---Ultimas 4  Linea Encabezados No se usuan--->

		<cfelse><!---demas lineas Detalles--->
			<cftry>

				<cfset Dia 				= mid(rsLinea.Linea,  5, 2 )>
                <cfset Mes 				= mid(rsLinea.Linea,  7, 2 )>
                <cfset Anno				= mid(rsLinea.Linea,  9, 2 )>
                <cfset NoDocumento	 	= trim(mid(rsLinea.Linea,  16, 8 ))>
                <cfset Descripcion	 	= trim(mid(rsLinea.Linea,  25, 36 ))>
                <cfset monto 			= replace(mid(rsLinea.Linea,  62, 18 ),",","","ALL")>
                <cfset DebitoCredito	= mid(rsLinea.Linea,  81, 1 )>
                <cfset FechaMovimiento	= "20"&#Anno#&"-"&#Mes#&"-"&#Dia#>
                <cfset Referencia 		= mid(#Descripcion#,  1, 25 )>
               
                <cfcatch type="any">
                    <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#:  y linea:#rsLinea.currentRow#">
                </cfcatch>
            
            </cftry> 
               
			<cfset monto= rtrim(monto)>
            <cfif monto lte 0>
                <cf_dump var="Error debito 0 credito en 0,  linea:#rsLinea.currentRow#">
            </cfif>
            
            <cfif DebitoCredito eq "-">
                <cfset tipo = 'C'> <!---Los Debitos se guardan como Creditos--->
                <cfset LvarTotalCreditos=LvarTotalCreditos+monto>
            <cfelseif DebitoCredito eq "+">	
                <cfset tipo = 'D'> <!---Los Creditos se guardan como Debitos --->
                <cfset LvarTotalDebitos=LvarTotalDebitos+monto>
            <cfelse>	
                <cf_dump var="Error no se pudo determinar si es debito o credito,  linea:#rsLinea.currentRow#">
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

			<cftry>
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
                        <cfqueryparam cfsqltype="cf_sql_char" value="#NoDocumento#">, 
                        <cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(FechaMovimiento)#">,  
                        <cfqueryparam cfsqltype="cf_sql_money" value="#monto#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#Referencia#">,
                        1.00, 
                         '#tipo#', 
                        'N', 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsBTEcodigo.BTid#" voidNull>
                        )
                </cfquery>
            
                <cfcatch type="any">
                    <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#:  y linea:#rsLinea.currentRow#">
                </cfcatch>
			</cftry>            
		</cfif>
	</cfoutput>
</cftransaction>	


