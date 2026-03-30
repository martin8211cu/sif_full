<!--- IMPORTACION --->
<cfquery name="rsLinea" datasource="#session.dsn#">
	select Linea from #table_name#
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
		
			<cfset columnas =  ListToArray(rsLinea.Linea, ';', true)>	
			<cfset SaldoInicial 	= columnas[1]>
			<cfset CantidadDebitos 	= columnas[2]>
			<cfset TotalDebitos	 	= columnas[3]>
			<cfset CantidadCreditos = columnas[4]>
			<cfset TotalCreditos 	= columnas[5]>
			<cfset SaldoFinal	 	=  replace(columnas[6],",","","ALL")> 
						
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
			
			<cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldofin 	= #SaldoFinal#,
					ECdebitos 	=  #TotalCreditos#,
					ECcreditos 	= #TotalDebitos#,
					ECsaldoini 	= #SaldoInicial#
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>
			
			<!---<cfquery datasource="#session.DSN#">
				update ECuentaBancaria
				set ECsaldoini = ECsaldofin - ECdebitos + ECcreditos
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
			</cfquery>	--->		
			
			<!---<cfif #LSNumberFormat(rsTotales.ECdebitos,',9.00')# neq #LSNumberFormat(TotalDebitos,',9.00')#>
				<cfthrow message="la suma de los Debitos  de los detalles:#LSNumberFormat(rsTotales.ECdebitos,',9.00')#
				 no es igual al total del encabezado en el Total de Debitos: #LSNumberFormat(TotalDebitos,',9.00')#">
			<cfelseif #LSNumberFormat(rsTotales.ECcreditos,'9.00')# neq #LSNumberFormat(TotalCreditos,'9.00')#>
				<cfthrow message="la suma de los Creditos de los detalles: #LSNumberFormat(rsTotales.ECcreditos,'9.00')#
				no es igual al total del encabezado en el Total de Creditos: #LSNumberFormat(TotalCreditos,'9.00')#">
			</cfif>		--->
			
		
		<cfelse><!---demas lineas Detalles--->
			<cfset columnas =  ListToArray(rsLinea.Linea, ';', true)>	
			<cfset FechaMovimiento 	= columnas[1]>
			<cfset FechaRegistro 	= columnas[2]>
			<cfset NoDocumento	 	= columnas[3]>
			<cfset Descripcion 		= columnas[4]>
			<cfset Debitos 			= columnas[5]>
			<cfset Creditos 		= columnas[6]>
			
			<cfif <!---#Creditos# eq 0 and---> #Debitos# gt 0>
				<cfset monto = replace(#Debitos#,",","","ALL")>
				<cfset tipo = 'C'>
			<cfelseif <!---#Debitos# eq 0 and---> #Creditos# gt 0>	
				<cfset monto = replace(#Creditos#,",","","ALL")>
				<cfset tipo = 'D'>
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
					<cfqueryparam cfsqltype="cf_sql_char" value="#NoDocumento#">,
					1.00, 
					 '#tipo#', 
					'N', 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBTEcodigo.BTid#">
					)
			</cfquery>
		</cfif>
	</cfoutput>
</cftransaction>	


