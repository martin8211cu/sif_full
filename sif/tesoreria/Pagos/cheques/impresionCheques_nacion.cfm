<cfif NOT isdefined("url.NACION")>
	<cfabort>
</cfif>
<cfquery name="rsLote" datasource="#session.dsn#">
	SELECT
		cb.CBcodigo,
		mp.Miso4217, mp.Mnombre,
		cfcr.CFformato 		as ECuenta, 
		cfcr.CFdescripcion 	as ECuentaDes
	  FROM TEScontrolFormulariosL cfl 
		INNER JOIN CuentasBancos cb 
			INNER JOIN Monedas mp
				ON mp.Mcodigo = cb.Mcodigo
			INNER JOIN CFinanciera cfcr
				ON cfcr.CFcuenta = (select min(CFcuenta) from CFinanciera WHERE Ecodigo=cb.Ecodigo AND Ccuenta = cb.Ccuenta)
		 ON cb.CBid = cfl.CBid 
	 WHERE cfl.TESid	= #session.Tesoreria.TESid# 
	   AND cfl.TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
	   AND cfl.TESCFLestado	= 1 	 	/* En Impresion */ 
</cfquery>

<cfquery name="rsDatos" datasource="#session.dsn#">
	SELECT
		cfd.TESCFDnumFormulario as NumCheque,
		op.TESOPfechaPago,
		op.TESOPbeneficiario,
		op.TESOPtotalPago,
		op.TESOPobservaciones,
		
		TESDPdocumentoOri,
		TESDPmontoPago, 
		cfdb.CFformato 		as DCuenta, 
		cfdb.CFdescripcion 	as DCuentaDes
		
	  FROM TEScontrolFormulariosL cfl 
		INNER JOIN TEScontrolFormulariosD cfd 
			INNER JOIN TESordenPago op 
				LEFT JOIN TESendoso e 
					 ON e.TESid 	= op.TESid 
					AND e.TESEcodigo = op.TESEcodigo 
				INNER JOIN CuentasBancos cb 
					 ON cb.CBid = op.CBidPago 
				 ON op.TESOPid 	= cfd.TESOPid 
			INNER JOIN TESdetallePago dp 
				LEFT JOIN CFinanciera cfdb 
					ON cfdb.CFcuenta = dp.CFcuentaDB 
				 ON dp.TESOPid 	= cfd.TESOPid 
			 ON cfd.TESid 	 	= cfl.TESid 
			AND cfd.CBid 	 	= cfl.CBid 
			AND cfd.TESMPcodigo	= cfl.TESMPcodigo 
			AND cfd.TESCFLid	= cfl.TESCFLid 
	 WHERE cfl.TESid	= #session.Tesoreria.TESid# 
	   AND cfl.TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
	   AND cfl.TESCFLestado	= 1 	 	/* En Impresion */ 
	 ORDER BY cfd.TESCFDnumFormulario 
</cfquery>

<cfquery name="rsqCheques" dbtype="query">
	select count(distinct NumCheque) as cantidad
	 		, min (NumCheque) as PrimerCheque
	  from rsDatos
</cfquery>

<cfquery name="rsLoteT" datasource="#session.dsn#">
	select count(1) as cantidad
	  from TEScontrolFormulariosD cfd
	where cfd.TESid			= #session.Tesoreria.TESid#
	  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESCFLid#">
	  and cfd.TESCFDestado	= 0
</cfquery>

<cfif rsqCheques.cantidad NEQ rsLoteT.cantidad>
	<cf_errorCode	code = "50764"
					msg  = "La cantidad de cheques a imprimir (@errorDat_1@) no coincide con la cantidad de formularios en el Lote (@errorDat_2@). Se debe revisar con PSO el SQL en el Tipo de Formato de Impresión."
					errorDat_1="#rsqCheques.cantidad#"
					errorDat_2="#rsLoteT.cantidad#"
	>
</cfif>

<cfquery name="rsIdioma" datasource="#session.dsn#">
	select CBidioma
	  from TEScontrolFormulariosL l
		inner join CuentasBancos c
			on c.CBid = l.CBid
	 where TESCFLid = #TESCFLid#
		and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
</cfquery>

<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	<cfif rsIdioma.CBidioma NEQ -1>
		// Cambio de Idioma
		var LvarIdioma = null;
		try
		{
			<cfoutput>
			window.parent.document.all.Imprime1.setIdiomaNacion(#rsIdioma.CBidioma#);
			</cfoutput>
			LvarIdioma = true;
		}
		catch (e)
		{
			alert("El soinPrintDocs.ocx no corresponde a la versión especial para la Nacion");
			alert(e.description);
			LvarIdioma = false;
		}
		if (LvarIdioma)
		{
	</cfif>
		
		<cfloop query="rsLote">
			// NacionIni(	ByVal vNUMFILSQL As Integer, ByVal vNumCheque As Integer, ByVal vTOTCHEQUES As Integer,
			//				ByVal vBanco, vMonedaISO, vMoneda, vCuenta, vCuentaDes)
			window.parent.document.all.Imprime1.NacionIni(
							#rsDatos.RecordCount#, 
							#rsqCheques.PrimerCheque#, 
							#rsqCheques.Cantidad#, 
							"#rsLote.CBcodigo#", 
							"#rsLote.Miso4217#", 
							"#rsLote.Mnombre#", 
							"#trim(rsLote.ECuenta)#", 
							"#trim(rsLote.ECuentaDes)#",
							"#session.Usulogin#"
						);
		</cfloop>
		<cfloop query="rsDatos">
			//NacionDatos(  ByVal pNumeroCheque As String, _
			//				ByVal pFecha As String, _
			//				ByVal pBeneficiario As String, _
			//				ByVal pMonto As String, _
			//				ByVal pObservaciones As String, _
			//				ByVal pDocumentoDet As String, _
			//				ByVal pMontoDet As String, _
			//				ByVal pDcuenta As String, _
			//				ByVal pDcuentaDes As String _
			//			)
			<cfset LvarObservaciones = trim(replace(replace(rsDatos.TESOPobservaciones,chr(10)," ","ALL"),chr(13)," ","ALL"))>
			window.parent.document.all.Imprime1.NacionDatos(
					"#rsDatos.NumCheque#",
					"#dateFormat(rsDatos.TESOPfechaPago,"YYYY-MM-DD")#",
					"#rsDatos.TESOPbeneficiario#",
					"#rsDatos.TESOPtotalPago#",
					"#LvarObservaciones#",
					
					"#rsDatos.TESDPdocumentoOri#",
					"#rsDatos.TESDPmontoPago#",
					"#trim(rsDatos.DCuenta)#",
					"#trim(rsDatos.DCuentaDes)#"
				)
		</cfloop>
		window.parent.document.all.Imprime1.DatosFin();
	<cfif rsIdioma.CBidioma NEQ -1>
		}
	</cfif>
</script>
</cfoutput>
