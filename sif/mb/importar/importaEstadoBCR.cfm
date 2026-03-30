<!--- IMPORTACION --->
<cfquery name="rsLinea" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select *
	from ECuentaBancaria
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
</cfquery>

<cftransaction>
	<cfoutput query="rsLinea">

		<cfif rsLinea.currentRow EQ 1><!---Primera linea no se utiliza--->
			
		<cfelseif rsLinea.currentRow EQ rsLinea.RecordCount><!---Ultima Linea Encabezados--->
		
			<cfset TotalDeDebitos 	= mid(rsLinea.Linea,  8, 18 )>
			<cfset TotalDeCreditos 	= mid(rsLinea.Linea, 31, 18 )>
			<cfset SaldoIni 		= mid(rsLinea.Linea, 50, 18 )>			
			<cfset SaldoActual 		= mid(rsLinea.Linea, 69, 18 )>			
		<!---	<cfset TipoDeRegistro = mid(rsLinea.Linea, 1, 2 )>
			<cfset CantidadDeDebitos = mid(rsLinea.Linea, 3, 5 )>
			<cfset CantidadDeCreditos = mid(rsLinea.Linea, 26, 5 )>
			<cfset SignoSaldoActual = mid(rsLinea.Linea, 49, 1 )>
			<cfset SignoSaldoDisponible = mid(rsLinea.Linea, 68, 1 )>
			<cfset SaldoDisponible = mid(rsLinea.Linea, 69, 18 )>
			<cfset DebitosEnTransito = mid(rsLinea.Linea, 87, 18 )>
			<cfset CreditosEnTransito = mid(rsLinea.Linea, 105,18 )>
			<cfset SaldoProtegido = mid(rsLinea.Linea, 123, 18 )>
			<cfset SobregiroAutorizado = mid(rsLinea.Linea, 141, 18 )>
			<cfset Filler = mid(rsLinea.Linea, 159, 2 )>	--->
			
			<cfquery datasource="#session.DSN#" name="rsTotales">
				select  
				  ECsaldoini + coalesce((select sum(DCmontoori * case when DCtipo = 'D' then 1 else -1 end)
									from DCuentaBancaria
									where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00) as ECsaldofin,
					 coalesce((select sum(case when DCtipo = 'D' then DCmontoori else 0 end)
									from DCuentaBancaria
									where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00) as ECdebitos,
					 coalesce((select sum(case when DCtipo = 'C' then DCmontoori else 0 end)
									from DCuentaBancaria
									where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00) as ECcreditos
				from ECuentaBancaria
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
			
		<!---	<cfif #rsTotales.ECsaldofin# neq #SaldoActual#>
				<cfthrow message="la suma de los Saldos de los detalles no es igual al total del encabezado en el saldo final">
			<cfelseif #rsTotales.ECdebitos# neq #TotalDeDebitos#>
				<cfthrow message="la suma de los Debitos de los detalles no es igual al total del encabezado en el Total de Debitos">
			<cfelseif #rsTotales.ECcreditos# neq #TotalDeCreditos#>
				<cfthrow message="la suma de los Creditos de los detalles no es igual al total del encabezado en el Total de Creditos">
			</cfif>			--->
			
			<cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin = #SaldoActual#,
					ECsaldoini = #SaldoIni#,
					ECdebitos =  #TotalDeCreditos# ,
					ECcreditos = #TotalDeDebitos# 
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin = ECsaldofin /100,
					ECdebitos =  ECdebitos / 100 ,
					ECcreditos = ECcreditos /100 ,
					ECsaldoini = ECsaldoini /100
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
			<!---<cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldoini = ECsaldofin - ECdebitos + ECcreditos
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>			--->
		
		<cfelse><!---demas lineas Detalles--->
			<cfset TipoDeRegistro 		= mid(rsLinea.Linea, 1, 2 )>
			<cfset FechaDeRegistro 		= mid(rsLinea.Linea, 3, 8 )>
			<cfset FechaContable 		= mid(rsLinea.Linea, 11, 8 )>
			<cfset OficinaDeLaCuenta 	= mid(rsLinea.Linea, 19, 3 )>
			<cfset NumeroDeCuenta 		= mid(rsLinea.Linea, 22, 7 )>
			<cfset DigitoDeLacuenta 	= mid(rsLinea.Linea, 29, 1 )>
			<cfset BTEcodigo  			= mid(rsLinea.Linea, 30, 2 )> <!---TipoDeTransaccion--->
			<cfset OficinaDeRegistro 	= mid(rsLinea.Linea, 32, 30 )>
			<cfset CodigoDeCausa 		= mid(rsLinea.Linea, 62, 4 )>
			<cfset DescripcionDeCausa 	= mid(rsLinea.Linea, 66, 20 )>
			<cfset DescripcionAdicional = mid(rsLinea.Linea, 86, 30 )>
			<cfset NumeroDeDocumento 	= mid(rsLinea.Linea, 116, 8 )>
			<cfset MontoDeLaTransaccion = mid(rsLinea.Linea, 124, 16 )>
			
			<cfset MontoDeLaTransaccion = MontoDeLaTransaccion / 100>

			<cf_dbfunction name="date_format"   args="#FechaDeRegistro#°YYYY-MM-DD HH:MI:SS" returnVariable="LvarFecha"	delimiters="°">
			<cfquery datasource="#session.DSN#" name="rsBTEcodigo">
				select b.BTid, a.BTEtipo 
					from BTransaccionesEq b
						inner join  TransaccionesBanco a
							on a.Bid = b.Bid
							and a.BTEcodigo = b.BTEcodigo
					where b.BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#BTEcodigo#"> 
						and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
						and b.Ecodigo = #session.Ecodigo#
			</cfquery>		 
			<cfset LvarFecha = createdate(mid(FechaDeRegistro,5,4),mid(FechaDeRegistro,3,2),mid(FechaDeRegistro,1,2))>
			
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
										 BTid) 
				values(						 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#BTEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Mid(NumeroDeDocumento, REFind('0*',NumeroDeDocumento,1,true).POS[1]+REFind('0*',NumeroDeDocumento,1,true).LEN[1],len(NumeroDeDocumento)-REFind('0*',NumeroDeDocumento,1,true).LEN[1])#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#MontoDeLaTransaccion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#MontoDeLaTransaccion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Mid(NumeroDeDocumento, REFind('0*',NumeroDeDocumento,1,true).POS[1]+REFind('0*',NumeroDeDocumento,1,true).LEN[1],len(NumeroDeDocumento)-REFind('0*',NumeroDeDocumento,1,true).LEN[1])#">,
					<!---$--->1.00, 
					 '#rsBTEcodigo.BTEtipo#', 
					'N', 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					1,
					#rsBTEcodigo.BTid#
					)
					
			</cfquery>
		
		</cfif>
	</cfoutput>
</cftransaction>	


