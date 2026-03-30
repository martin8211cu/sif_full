<!---
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
 --->
<!--- DEFINICIONES INICIALES --->

<cfscript>
	bcheck1 = false; 
	bcheck2 = false; 
	bcheck3 = false; 
	bcheck4 = false; 
	bcheck5 = false; 
	bcheck6 = false; 
	bok = false;
</cfscript>

<cfquery name="rsConsulta" datasource="#session.DSN#">
	select *
	from ECuentaBancaria
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
</cfquery>


<!--- VALIDACIONES --->
	<!--- Check1. Validar que exista la Transaccion del banco--->
	<cfquery name="rsCheck1" datasource="#session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists(
			select 1
			from TransaccionesBanco b
			where b.BTEcodigo = substring(a.Linea, 20, 6 )
			  and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
	<cfif bcheck1>
			<!--- Check3. Validar que el monto del documento en la moneda original sea mayor a cero --->
			<cfquery name="rsCheck3" datasource="#session.DSN#">
				select count(1) as check3
				from #table_name#
				where convert(money, substring(Linea, 26, 10)) / 100 < 0.00
			</cfquery>
			<cfset bcheck3 = rsCheck3.check3 LT 1>
			<cfif bcheck3>
				<!--- Check4. Validar que la fecha de los documentos este dentro del rango del Estado de cuenta --->
				<cfquery name="rsCheck6" datasource="#session.DSN#">
					select count(1) as check6
					from #table_name#
					where substring(Linea, 16,4) || substring (Linea, 14,2) || substring(Linea, 12,2) >  <cfqueryparam cfsqltype="cf_sql_char" value="#LsDateformat(rsConsulta.EChasta, 'YYYYMMDD')#">
					or substring(Linea, 16,4) || substring (Linea, 14,2) || substring(Linea, 12,2) < <cfqueryparam cfsqltype="cf_sql_char" value="#LsDateFormat(rsConsulta.ECdesde, 'YYYYMMDD')#">
				</cfquery>
				
				<cfset bcheck6 = rsCheck6.check6 LT 1>
			</cfif><!--- Check3 --->
		<!--- </cfif>Check2 --->
	</cfif><!--- Check1 --->


<!--- ERRORES --->
<cfif not bcheck1>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'Transaccion no Existe' as Error, 
		substring(a.Linea, 20, 6 ) as BTEcodigo
		from #table_name# a
		where not exists(
			select 1
			from TransaccionesBanco b
			where b.BTEcodigo = substring(a.Linea, 20, 6 )
			  and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">) 
	</cfquery>

<cfelseif not bcheck3>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 
		'El monto en moneda original debe ser mayor a 0.00' as Error, 
		substring (Linea, 36, 9) as Documento, 
		convert(money, substring(Linea, 26, 10)) / 100 as DCmontoori
		from #table_name#
		where convert(money, substring(Linea, 26, 10)) / 100 < 0.00
	</cfquery>

<cfelseif not bcheck6>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El documento no esta dentro del rango de fechas del Estado de Cuenta' as Error, 
		substring(Linea, 16,4) || substring (Linea, 14,2) || substring(Linea, 12,2) as DCFecha
		from #table_name#
		where substring(Linea, 16,4) || substring (Linea, 14,2) || substring(Linea, 12,2) >  <cfqueryparam cfsqltype="cf_sql_char" value="#LsDateformat(rsConsulta.EChasta, 'YYYYMMDD')#">
		or substring(Linea, 16,4) || substring (Linea, 14,2) || substring(Linea, 12,2) < <cfqueryparam cfsqltype="cf_sql_char" value="#LsDateFormat(rsConsulta.ECdesde, 'YYYYMMDD')#">
	</cfquery>	
</cfif>

<cfif bcheck6>
	<!--- IMPORTACION --->
	<cfquery name="rsLinea" datasource="#session.DSN#">
		select Linea
		from #table_name#
	</cfquery>

	<cfset consecutivo = 1>
	<cftransaction>
		<cfoutput query="rsLinea">
			<cfset BTEcodigo = mid(rsLinea.Linea, 20, 6 )>
			<cfset Documento = mid(rsLinea.Linea, 36, 9)>
			
			<cfset DCFecha = mid(rsLinea.Linea, 16,4) & mid(rsLinea.Linea, 14,2) & mid(rsLinea.Linea, 12,2)>
			<cfif Isnumeric(mid(Linea, 26, 10))>
				<cfset DCMontoOri= mid(Linea, 26, 10) + 0>
			<cfelse>
				<cfset DCMontoOri=0.00>
			</cfif>
			<cfset DCMontoOri = DCMontoOri / 100>
			
			<cfif Documento eq '000000000'>
				<cfset Documento = LsDateformat(rsConsulta.EChasta, 'YYYYMM') & '-' & consecutivo>
				<cfset consecutivo = consecutivo +1>
			</cfif>
		
				<cfquery datasource="#session.DSN#">
				insert into DCuentaBancaria (ECid, 
											 BTEcodigo,  
											 Documento, 
											 DCfecha, 
											 DCmontoori, 
											 DCmontoloc, 
											 DCReferencia, 
											 DCtipocambio, 
											 DCtipo, 
											 DCconciliado,
											 Ecodigo) 
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#BTEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Documento#">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#DCFecha#">, 
						<cfqueryparam cfsqltype="cf_sql_money" value="#DCMontoOri#">,  
						<cfqueryparam cfsqltype="cf_sql_money" value="#DCMontoOri#">,
						' ', 
						$1.00, 
						b.BTEtipo, 
						'N', 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				from TransaccionesBanco b
				  where b.BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#BTEcodigo#"> 
				  and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">  
			</cfquery>
		</cfoutput>
	
		<cfquery datasource="#session.DSN#">
			update ECuentaBancaria
			set ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori * case when DCtipo = 'D' then 1 else -1 end)
								from DCuentaBancaria
								where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00),
				ECdebitos = coalesce((select sum(case when DCtipo = 'D' then DCmontoori else 0 end)
								from DCuentaBancaria
								where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00),
				ECcreditos = coalesce((select sum(case when DCtipo = 'C' then DCmontoori else 0 end)
								from DCuentaBancaria
								where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00)
								
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
		</cfquery>
	</cftransaction>
</cfif>
