<!---
	Modificado por: Ana Villavicencio
	Fecha: 18 de noviembre del 2005
	Motivo: Agregar Update del saldo final de ECuentaBancaria cuando se hace la importacion.
	
	Modificado por: Ana Villavicencio
	Fecha: 9 de noviembre del 2005
	Motivo: Eliminar validación de documentos repetidos en la importacion de las lineas de detalle del estado de cuenta.
	
	Modificado por: Ana Villavicencio
	Fecha: 19 de octubre del 2005
	Motivo: Se cambio el proceso de importacion de estados de cuenta, solamente se hace consulta la tabla de TransaccionesBanco
			para verificar q se las transacciones existan.
	Importador de Estados de Cuentas Bancarias
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
	where ECid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
</cfquery>



<!--- VALIDACIONES --->
	<!--- Check1. Validar que exista la Transaccion del banco--->
	<cfquery name="rsCheck1" datasource="#session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists(
			select 1
			from TransaccionesBanco b
			where Upper(b.BTEcodigo) = Upper(a.BTEcodigo)
			  and b.Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
	<cfif bcheck1>
		<!--- Check2. Validar que no exista el documento en los estados de cuenta 
		<cfquery name="rsCheck2" datasource="#session.DSN#">
			select count(1) as check2
			from #table_name# a
			where exists(
				select 1 
				from DCuentaBancaria b, TransaccionesBanco c
				where a.BTEcodigo = c.BTEcodigo
				  and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
				  and b.BTid = c.BTid
				  and Upper(b.Documento) = Upper(a.Documento)
			)
		</cfquery>
		<cfset bcheck2 = rsCheck2.check2 LT 1>
		<cfif bcheck2>--->
			<!--- Check3. Validar que el monto del documento en la moneda original sea mayor a cero --->
			<cfquery name="rsCheck3" datasource="#session.DSN#">
				select count(1) as check3
				from #table_name#
				where DCmontoori < 0.00
			</cfquery>
			<cfset bcheck3 = rsCheck3.check3 LT 1>
			<cfif bcheck3>
				<!--- Check4. Validar que el monto del documento en la moneda local sea mayor a cero --->
				<cfquery name="rsCheck4" datasource="#session.DSN#">
					select count(1) as check4
					from #table_name#
					where DCmontoloc < 0.00
				</cfquery>
				<cfset bcheck4 = rsCheck4.check4 LT 1>
				<cfif bcheck4>
					<!--- Check4. Validar que el monto del tipo de cambio sea mayor a cero --->
					<cfquery name="rsCheck5" datasource="#session.DSN#">
						select count(1) as check5
						from #table_name#
						where DCtipocambio < 0.00
					</cfquery>
					<cfset bcheck5 = rsCheck5.check5 LT 1>
					<cfif bcheck5>
						<!--- Check4. Validar que la fecha de los documentos este dentro del rango del Estado de cuenta --->
						<cfquery name="rsCheck6" datasource="#session.DSN#">
							select count(1) as check6
							from #table_name#
							where DCFecha >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsConsulta.EChasta#">
						</cfquery>
						
						<cfset bcheck6 = rsCheck6.check6 LT 1>
					</cfif>
				</cfif><!--- Check4 --->
			</cfif><!--- Check3 --->
		<!--- </cfif>Check2 --->
	</cfif><!--- Check1 --->


<!--- ERRORES --->
<cfif not bcheck1>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'Transaccion no Existe' as Error, BTEcodigo
		from #table_name# a
		where not exists(
			select 1
			from TransaccionesBanco b
			where Upper(b.BTEcodigo) = Upper(a.BTEcodigo)
			  and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">) 
	</cfquery>
<!--- <cfelseif not bcheck2>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'EL documento ya se encuentra en relacionado a un Estado de Cuenta.' as Error, a.Documento
			from #table_name# a
			where exists(
				select 1 
				from DCuentaBancaria b, BTransaccionesEq c, BTransacciones d
				where a.BTEcodigo = c.BTEcodigo
				  and c.BTid = d.BTid
				  and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
				  and b.BTid = d.BTid
				  and Upper(b.Documento) = Upper(a.Documento)
			)
	</cfquery> --->
<cfelseif not bcheck3>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El monto en moneda original debe ser mayor a 0.00' as Error, Documento, DCmontoori
		from #table_name#
		where DCmontoori < 0.00	
	</cfquery>
<cfelseif not bcheck4>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El monto en moneda local debe ser mayor a 0.00' as Error,Documento, DCmontoloc
		from #table_name#
		where DCmontoloc < 0.00	
	</cfquery>
	
<cfelseif not bcheck5>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El monto del tipo de cambio debe ser mayor a 0.00' as Error, DCtipocambio
		from #table_name#
		where DCtipocambio < 0.00
	</cfquery>
<cfelseif not bcheck6>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El documento no esta dentro del rango de fechas del Estado de Cuenta' as Error, DCFecha
		from #table_name#
		where DCFecha >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsConsulta.EChasta#">
	</cfquery>	
</cfif>

<!--- IMPORTACION --->
<cfif bcheck6>
	<cftransaction>
        
	<cfquery name="ERR" datasource="#session.DSN#">
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
									 Ecodigo,
                                     Bid) 
		select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
				a.BTEcodigo,
				Documento, 
				DCFecha, 
				DCmontoori, 
				DCmontoloc, 
				DCReferencia, 
				DCtipocambio, 
				b.BTEtipo, 
				'N', 
				#session.Ecodigo#,
                #rsConsulta.Bid#
		from #table_name# a 
		left outer join TransaccionesBanco b
		  on Upper(b.BTEcodigo) = Upper(a.BTEcodigo) and
		  	 b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">  
	</cfquery>
	<cfquery name="rsUpEstadoCta" datasource="#session.DSN#">
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