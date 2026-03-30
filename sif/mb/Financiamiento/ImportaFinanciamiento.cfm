<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre Anterior: Arrendamiento                                           --->
<!--- Fecha:  06/04/2014                                              --->
<!--- =============================================================== --->
<!---  Modificado por: Andres Lara                						  --->
<!---	Nombre: Financiamiento                                         --->
<!---	Fecha: 	02/04/2014              	                          --->
<!--- =============================================================== --->

<!--- VALIDA SALDOS  --->
<cfquery name="rsValidaSaldo" datasource="#session.dsn#">
	SELECT		SaldoInsoluto as SInsoluto, Capital, PagoMensual, IVA
	FROM		#table_name#
	WHERE		NumPago = 1
</cfquery>

<cfquery name="rsValidaTotales" datasource="#session.dsn#">
	SELECT		sum(Capital) as tCapital, sum(Intereses) as tIntereses, sum(PagoMensual) as tPagoMensual
	FROM		#table_name#
</cfquery>

<!--- VALIDA PAGOS  --->
 <cfquery name="rsValidaPagos" datasource="#session.dsn#">
 	SELECT    	count(1) as Pagos
 	FROM		#table_name#
 </cfquery>


<cfset tablaIva=#lsNumberFormat((rsValidaSaldo.IVA / rsValidaSaldo.PagoMensual)*100,"9,999.99")#>
<cfif rsValidaPagos.Pagos NEQ #session.NumPagos#>
	<cfthrow message="El numero de pagos: #rsValidaPagos.Pagos# no corresponde con el detalle: #session.NumPagos#">
<cfelseif lsnumberformat(rsValidaSaldo.SInsoluto,"9,999.9999") NEQ #session.SaldoInsoluto#>
	<cfthrow message="El Saldo Insoluto de la tabla: #lsNumberFormat(rsValidaSaldo.SInsoluto,"9,999.99")# no corresponde al detalle: #session.SaldoInsoluto#">
<cfelseif #session.IVA# NEQ #tablaIva# >
	<cfthrow message="El IVA de: #rsValidaSaldo.IVA# para el monto:#rsValidaSaldo.PagoMensual# no corresponde al IVA de #session.IVA#% del detalle, IVA del documento = #tablaIva#%">
<cfelse>

<cftry>
<cftransaction>
	<cfquery name="rsCargaAmort" datasource="#Session.DSN#">
		--Inserta en la tabla
		insert into 	TablaAmortFinanciamiento (IDFinan, Ecodigo, NumPago, FechaInicio, FechaPagoBanco,FechaPagoPMI,FechaCierre, DiasPeriodo,
						SaldoInsoluto, Capital, Intereses, PagoMensual, IVA, IntDevengNoPag,
						Estado, BMUsucodigo,Origen)

		select			#session.IDFinan#, #session.Ecodigo#, NumPago,
						FechaInicio, FechaPagoBanco, FechaPagoPMI,FechaCierre, DiasPeriodo, SaldoInsoluto,
                		Capital, Intereses, PagoMensual, IVA,IntDevengNoPag,
                		Estado, #session.usucodigo#,'Import'
		from 			#table_name#
	</cfquery>

	<cfquery name="ConsultAExtPag" datasource="#session.DSN#">
		 select count(Estado) as NoIDD
         from TablaAmortFinanciamiento
         where Ecodigo=<cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
		 and IDFinan = #session.IDFinan#
		 and Estado = '1'
 	</cfquery>

	<cfquery name="LlenaTablaSaldo" datasource="#session.DSN#">
	select SaldoInsoluto
	from TablaAmortFinanciamiento
	where Ecodigo=<cf_jdbcquery_param cfsqltype = "cf_sql_integer" value ="#session.Ecodigo#">
	and NumPago = <cf_jdbcquery_param cfsqltype ="cf_sql_integer"  value ="#ConsultAExtPag.NoIDD#">
</cfquery>

	<cfquery name="detTabla" datasource="#Session.DSN#">
		UPDATE 			DetFinanciamiento
		SET				StatusD = 1,
		SaldoInsoluto = <cf_jdbcquery_param cfsqltype = "cf_sql_money" value ="#LlenaTablaSaldo.SaldoInsoluto#">
		WHERE			Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND
                        IDFinan = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.IDFinan#">
	</cfquery>
</cftransaction>
<cfcatch type="Database">
	<cfthrow message= "Error en el n&uacute;mero de pagos, favor de verificar.">
</cfcatch>
</cftry>
</cfif>
