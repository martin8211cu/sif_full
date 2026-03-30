<cfset parametros = '' >
<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
	<cfset parametros = parametros & "&f_identificacion=#form.f_identificacion#" >
</cfif>
<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
	<cfset parametros = parametros & "&f_asociado=#form.f_asociado#" >
</cfif>
<cfif isdefined("form.pagenNum_lista0") and len(trim(form.pagenNum_lista0)) >
	<cfset parametros = parametros & "&pagenNum_lista0=#form.pagenNum_lista0#" >
</cfif>

<cfinvoke component="rh.asoc.Componentes.RH_PagoExtraordinario" method="init" returnvariable="pago">
<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">
<cfif isdefined("form.Aplicar")>
	<!--- 0. Obtiene datos necesarios para los calculos --->
	<cfset fecha = LSdateformat(now(), 'dd/mm/yyyy') >
	<cfset monto = replace(form.ACCRPEmonto, ',', '', 'all') >
	<cfset data_credito = plan.obtenerCredito( form.ACCAid, session.DSN ) >

	<cftransaction >
		<!--- 1. Registra el pago ordinario para el credito en la tabla de pagos --->
		<cfset pago.insertarPago( form.ACCAid, fecha, monto ) >
		
		<!--- 2. Inserta un registro en la tabla de plan de pagos, para reflejar el pago --->
		<cfset plan.insertarPlan(	form.ACCAid,
									data_credito.ACCTcapital,
									LSDateFormat(data_credito.ACCTfechaInicio, 'dd/mm/yyyy'),
									fecha,
									data_credito.ACCTcapital-data_credito.ACCTamortizado,
									0,
									0,
									monto,
									0,
									0,
									0,
									'S',
									'E',
									plan.obtenerMoneda(session.Ecodigo, session.DSN),
									'',
									'',
									data_credito.ACCAperiodicidad,
									'',
									'',
									fecha ) >
		
		<!--- 3. actualiza el campo de amortizacion para el credito  --->
		<cfset plan.actualizarAmortizacion(form.ACCAid, monto, session.DSN) >
		
		<!--- 4. regenera el plan de pagos para ajustar el monto de las cuotas --->	
		<cfset plan.crearPlan(	form.ACCAid,
								true,
								session.usucodigo,
								session.Ecodigo,
								session.DSN ) >
		
	</cftransaction>

	<cfset parametros = parametros & "&ACCAid=#form.ACCAid#&ok=ok&monto=#monto#" >

<!---
<cfelseif isdefined("form.CAMBIO")>
	<!--- modifica datos de un pago ordinario para un credito --->
	<cfset pago.modificarPago(arguments.ACCRPEid, arguments.ACCAid, arguments.ACCRPEfecha, arguments.ACCRPEmonto) >

<cfelseif isdefined("form.BAJA")>
	<!--- elimina un pago extraordinario para un credito --->
	<cfset pago.eliminarPago(arguments.ACCRPEid) >

<cfelseif isdefined("form.REGRESAR")>
	<cflocation url="pagoextraordinario-lista.cfm?1=1#parametros#" >
--->	
	
</cfif>

<cflocation url="pagoextraordinario.cfm?ACAid=#form.ACAid##parametros#" >