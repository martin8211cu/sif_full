<cfquery datasource="#session.DSN#" name="rsReporte">
	select op.TESOPnumero,
	   op.TESOPfechaPago,
	   op.TESOPmontoPago,
		'Nombre' as TESOPbeneficiario,
	   op.TESOPobservaciones,
	   dp.TESDPmoduloOri, dp.TESDPdocumentoOri, dp.TESDPreferenciaOri,
	   dp.Miso4217Ori, dp.TESDPmontoAprobadoOri,
	   dp.Miso4217Pago, dp.TESDPmontoPago
	from TESordenPago op
	  inner join TESdetallePago dp
		 on dp.TESid = op.TESid
		 and dp.TESOPid = op.TESOPid
	where op.TESid = $P{TESid}
	  and op.TESOPestado = 12
</cfquery>

<cfreport format="flashpaper" template="1_CHK001.cfr" query="rsReporte"></cfreport>
