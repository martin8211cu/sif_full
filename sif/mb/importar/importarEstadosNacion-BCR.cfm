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

		<cfif rsLinea.currentRow lte 6><!---Primeras 6 lineas no se utiliza--->
			
        <cfelseif rsLinea.currentRow gte rsLinea.RecordCount><!---Ultima Linea actualizaciones--->

            <cfquery datasource="#session.DSN#" name="rsTotales">
				select ECsaldoini 
				from ECuentaBancaria
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
            
            <!---Formula de saldo final es: (saldoIni+debitos-creditos) --->
            <cfset LvarSaldoFinal=#SaldoInicial#+ #LvarTotalDebitos# - #LvarTotalCreditos#>
            
            <cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin 	= #LvarSaldoFinal#,
					ECdebitos 	=  #LvarTotalDebitos#
					,ECcreditos 	=  #LvarTotalCreditos#
					,ECsaldoini 	= #SaldoInicial#
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>

        <cfelseif rsLinea.currentRow eq rsLinea.RecordCount-2><!---Linea saldo Inicial--->
			<cfset columnas =  ListToArray(rsLinea.Linea,chr(9), true)>	
			<cfset cadena 		= columnas[1]>
			<cfset SaldoInicial = replace(columnas[2],",","","ALL")>
            
        <cfelseif rsLinea.currentRow gte rsLinea.RecordCount-6><!---Ultimas 6  Linea Encabezados--->

		<cfelse><!---demas lineas Detalles--->
			<cfset columnas =  ListToArray(rsLinea.Linea,chr(9), true)>	
            
			<cftry>
				<cfset FechaContable 	= columnas[1]>
                <cfset FechaMovimiento 	= columnas[2]>
                <cfset NoDocumento	 	= trim(columnas[3])>
                <cfset Descripcion 		= columnas[4]>
                <cfset Oficina 			= columnas[5]>
                <cfset Dia 				= mid(#FechaMovimiento#,  1, 2 )>
                <cfset Mes 				= mid(#FechaMovimiento#,  4, 2 )>
                <cfset Anno				= mid(#FechaMovimiento#,  7, 2 )>
                <cfset FechaMovimiento	= "20"&#Anno#&"-"&#Mes#&"-"&#Dia#>
                <cfset Referencia 		= mid(#Descripcion#,  1, 25 )>
			    <cfset Referencia2 		= trim(mid(#Descripcion#,  1, 21 )) & "-" & trim(mid(#Descripcion#,23,31))>
                
                <cfset Debitos 	= 0>
                <cfif #findoneof(",",columnas[6])# gt 0>
                    <cfset Debitos 			= replace(columnas[6],",","","ALL")>
                <cfelse>
                    <cfset Debitos 			= columnas[6]>
                </cfif>
                
				<cfset Creditos 	= 0>
                <cfif  len(trim(#Debitos#)) eq 0>
                    <cfif #findoneof(",",  columnas[7])# gt 0>
                        <cfset Creditos 	= replace(columnas[7],",","","ALL")>
                    <cfelse>
                        <cfset Creditos 	= columnas[7]>
                    </cfif>    
                </cfif>

                <cfcatch type="any">
                    <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#:  y linea:#rsLinea.currentRow#">
                </cfcatch>
            </cftry>

            <cfset monto = 0>
            <cfif Debitos lte 0 and Creditos lte 0>
            	<cf_dump var="Error debitos y creditos en 0, debitos:#Debitos# y cred:#Creditos# y linea:#rsLinea.currentRow#">
            </cfif>
            
			<cfif Debitos gt 0>
				<cfset monto = trim(Debitos)>
				<cfset tipo = 'C'> <!---Los Debitos se guardan como Creditos--->
                <cfset LvarTotalCreditos=LvarTotalCreditos + monto>
			<cfelseif Creditos gt 0>	
				<cfset monto = trim(Creditos)>
				<cfset tipo = 'D'> <!---Los Creditos se guardan como Debitos --->
                <cfset LvarTotalDebitos = LvarTotalDebitos + monto>
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
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(FechaMovimiento)#">,  
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#Referencia2#">,
                        1.00, 
                         '#tipo#', 
                        'N', 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsBTEcodigo.BTid#" voidNull>
                        )
                </cfquery>
                
                <cfcatch type="any">
                    <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#: *#monto#* y linea:#rsLinea.currentRow#">
                </cfcatch>
            </cftry>
		</cfif>
	</cfoutput>
</cftransaction>	


