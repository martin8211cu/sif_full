<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  06/04/2014                                              --->
<!--- Última Modificación: 16/04/2014    	                          --->
<!--- =============================================================== --->

<cfquery name="rsDocumento" datasource="#session.dsn#">
	SELECT		Mcodigo, TipoCambio
	  FROM		EncArrendamiento
	 WHERE		IDArrend=#Session.IDArrend# AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#session.dsn#">
	SELECT		NumMensualidades, SaldoInsoluto, IVA
	  FROM		DetArrendamiento
	 WHERE		IDArrend=#Session.IDArrend# AND Ecodigo = #Session.Ecodigo#
</cfquery>

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

<cfif rsValidaPagos.Pagos NEQ #session.NumMensualidades#>
	<cfthrow message="El numero de pagos: #rsValidaPagos.Pagos# no corresponde con el detalle: #rsDetalle.NumMensualidades#">
<cfelseif replace(rsValidaSaldo.SInsoluto + rsValidaSaldo.Capital,",","","ALL") NEQ replace(rsDetalle.SaldoInsoluto,",","","ALL")>
	<cfthrow message="El Saldo Insoluto de la tabla: #replace(rsValidaSaldo.SInsoluto + rsValidaSaldo.Capital,",","","ALL")# no corresponde al detalle: #replace(rsDetalle.SaldoInsoluto,",","","ALL")#">
<cfelseif #rsDetalle.IVA# NEQ #tablaIva# >
	<cfthrow message="El IVA de: #rsValidaSaldo.IVA# para el monto:#rsValidaSaldo.PagoMensual# no corresponde al IVA de #rsDetalle.IVA#% del detalle, IVA del documento = #tablaIva#%">
<cfelse>
<cftransaction>
	<cfquery name="rsCargaAmort" datasource="#Session.DSN#">
		
		INSERT INTO 	TablaAmort (IDArrend, Ecodigo, FechaCierreMes, DiasAbarcaCierre,
						NumPago, FechaInicio, FechaPagoBanco, FechaPagoEmpresa, DiasPeriodo,
						SaldoInsoluto, Capital, Intereses, PagoMensual, IVA, Mcodigo, TipoCambio, IntDevengNoCob,
						InteresRestante, Estado, BMUsucodigo)

		SELECT			#session.IDArrend#, #session.Ecodigo#, FechaCierreMes, DiasAbarcaCierre, NumPago, 
						FechaInicio, FechaPagoBanco, FechaPagoPMI, DiasPeriodo, SaldoInsoluto,
                		Capital, Intereses, PagoMensual, IVA,  #rsDocumento.Mcodigo#, #rsDocumento.TipoCambio#, IntDevengNoCob, InteresRestante,
                		0, #session.usucodigo#
		FROM 			#table_name#
	</cfquery>
	<cfquery name="detTabla" datasource="#Session.DSN#">
		UPDATE 			DetArrendamiento
		SET				DetEstado = 1
		WHERE			Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.Ecodigo#"> AND 
                        IDArrend = <cf_jdbcquery_param cfsqltype="cf_sql_integer"  value="#Session.IDArrend#">
	</cfquery>
	<cfoutput>CARGA EXITOSA</cfoutput>
</cftransaction>
</cfif>
