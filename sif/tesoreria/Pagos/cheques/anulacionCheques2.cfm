<!---------
	Impresion Especial de Cheques
	
	Permite anular un cheque de solicitudes de pago manual sin reversar los movimientos contables ni presupuestarios
	Se realiza un movimiento contable a una cuenta de balance indicada
----------->
<cfset GvarAnulacionEspecial = true>
<cfinclude template="anulacionCheques.cfm">
