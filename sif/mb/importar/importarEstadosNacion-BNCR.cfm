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
<cfset indiceRsLinea=0>

<cftransaction>
  <cfoutput query="rsLinea">
	<cfif indiceRsLinea NEQ 0 and rsLinea.recordcount NEQ (indiceRsLinea+1)><!--- si NO es la primera linea--->
	<!--- separar datos para procesar --->
		<!--- String to split --->
		<cfset tag_source = rsLinea.Linea>

		<cfset comma_pos = -1>
		<cfset index = 1>
		<cfset tagarray = ArrayNew(1)>
		<cfloop condition= "comma_pos NEQ 0 AND len(tag_source) GT 0">
			<cfset comma_pos = #find(";", tag_source)#>
			<cfif comma_pos NEQ 0>
				<cfif comma_pos EQ 1>
					<cfset tag_source_n = #left(tag_source, comma_pos)#>
				<cfelse>
					<cfset tag_source_n = #left(tag_source, comma_pos-1)#>
				</cfif>
				<cfset tag_source = #removechars(tag_source, 1, comma_pos)#>
				<cfset tagArray[index] = trim(tag_source_n)>
			<cfelseif comma_pos EQ 0 AND len(tag_source) GT 0>
			<cfset tagArray[index] = trim(tag_source)>
			</cfif>
			<cfset index = index+1>
		</cfloop>		
		<!--- Se obtiene array con datos -->
			1 	Oficina
			2 	FechaMovimiento
			3 	NumDocumento
			4 	Debito
			5 	Credito
			6 	Descripcion
		<---                         --->
			<cfset debit=replace(tagArray[4],";","","All")>
			<cfset credit=replace(tagArray[5],";","","All")>
			<cfset tipomov=""><!---- para el tipo de movimiento ya sea Debito o Credito--->
			
			<cfset Oficina			= tagArray[1]>
			<cfset NoDocumento	 	= tagArray[3]>
			<cfset Descripcion	 	= tagArray[6]>
			
			<!--- DEFINIR EL TIPO DE MOVIMIENTO --->
			<cfif len(trim(debit)) GT 0 and len(trim(credit)) EQ 0 ><!--- debito --->
				<cfset tipomov="C"><!---Los Debitos se guardan como Creditos--->
				<cfset monto = replace(trim(debit),",","","ALL")>
				<cfset LvarTotalCreditos = LvarTotalCreditos + monto><!--- obtener total de creditos para actualizar encabezado--->
				
			<cfelseif len(trim(debit)) EQ 0 and len(trim(credit)) GT 0 ><!--- credito --->
				<cfset tipomov="D"><!---Los Creditos se guardan como Debitos --->
				<cfset monto = replace(trim(credit),",","","ALL")>
				<cfset LvarTotalDebitos	= LvarTotalDebitos + monto><!--- obtener total de creditos para actualizar encabezado--->
			<cfelse>	
                <cf_dump var="Error no se pudo determinar si es debito o credito,  linea:#rsLinea.currentRow#">
			</cfif>

			<cfset FechaMovimiento	= replace(tagArray[2],"/","-","All")>
			<cfset Referencia 		= tagArray[6]>
               
<!---<cf_dump var="Oficina:#Oficina#  NoDocumento:#NoDocumento#   Descripcion:#Descripcion#   tipomov:#tipomov#   monto:#monto#   FechaMovimiento:#FechaMovimiento#    Referencia:#Referencia#">--->
			
            <cfif monto lte 0>
                <cf_dump var="Error debito 0 credito en 0,  linea:#rsLinea.currentRow#">
            </cfif>
			
			
			<cfquery datasource="#session.DSN#" name="rsBTEcodigo">
				select b.BTid,a.BTEcodigo    
					from BTransaccionesEq b
						inner join  TransaccionesBanco a
							on a.Bid = b.Bid
							and a.BTEcodigo = b.BTEcodigo
					where b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
						and b.Ecodigo = #session.Ecodigo#
						and a.BTEtipo = '#tipomov#'
			</cfquery>
			
            <cfif len(trim(#rsBTEcodigo.BTid#)) eq 0>
            	<cfquery name="rsBanco" datasource="#session.dsn#">
                    select Bdescripcion from Bancos 
                    where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
                </cfquery>    
                <cf_dump var="falta definir las trassacciones o las trassacciones equivalencias para el banco: #rsBanco.Bdescripcion#">
            </cfif> 
			
			<!--- insertar detalle --->
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
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#rsBTEcodigo.BTEcodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#NoDocumento#">, 
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(FechaMovimiento)#">,  
                        <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#monto#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Referencia#">,
                        1.00, 
                        '#tipomov#', 
                        'N', 
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsBTEcodigo.BTid#" voidNull>
                        )
                </cfquery>
            
                <cfcatch type="any">
                    <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#:  y linea:#rsLinea.currentRow#">
                </cfcatch>
			</cftry>
	</cfif>
		<cfset indiceRsLinea=indiceRsLinea+1><!--- siguiente linea --->
  </cfoutput>
  
	<cfquery datasource="#session.DSN#" name="rsSaldoIni">
		SELECT DISTINCT
			ECsaldoini
		FROM ECuentaBancaria
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
	</cfquery>
	
	<cfif rsSaldoIni.recordcount GT 0>
	
		<!---Formula de saldo final es: (saldoIni+debitos-creditos)--->
		<cfset LvarSaldoFinal=#rsSaldoIni.ECsaldoini# + #LvarTotalDebitos#  -  #LvarTotalCreditos# >
		<!--- ACTUALIZAR ENCABEZADO --->
		<cfquery datasource="#session.DSN#">
			update ECuentaBancaria
			set ECsaldofin 	= #LvarSaldoFinal#,
				ECdebitos 	=   #LvarTotalDebitos#    
				,ECcreditos 	= #LvarTotalCreditos#
				,ECsaldoini 	= #rsSaldoIni.ECsaldoini#
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
		</cfquery>
	<cfelse>
		<cf_dump var="No se encuentra saldo inicial para la cuenta bancaria.">
	</cfif>
	
</cftransaction>	


