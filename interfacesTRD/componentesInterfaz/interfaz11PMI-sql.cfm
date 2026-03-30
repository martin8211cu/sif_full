<!--- Por el momento prueba.... --->

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">


<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

<cfquery name="rsEmpresa" datasource="sifinterfaces">
	select Ecodigo, CodICTS, EcodigoSDC
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>
<cfsetting enablecfoutputonly="yes">

<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">

<cfquery name="rsEmpresaSeleccionada" datasource="sifinterfaces">
	select 
		Ecodigo,
		CodICTS,
		EcodigoSDCSoin
	from int_ICTS_SOIN
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- 1.Seleccionar los registros a procesar --->
<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces">
	select 
		EcodigoSDC,   
		TipoCobroPago,
		CodigoBanco,  
		CuentaBancaria, 
		FechaTransaccion, 
		TipoPago,         
		NumeroDocumento,  
		NumeroSocio,      
		CodigoMonedaPago, 
		TipoCambio,
		TransaccionOrigen,
		sum(MontoPago) as MontoPago
	from IE11 a
	where a.EcodigoSDC = #rsEmpresaSeleccionada.CodICTS#
	  and a.StatusProceso = 1
	  and a.FechaTransaccion between #vFechaI# and #vFechaF#
	  group by 	
		EcodigoSDC,   
		TipoCobroPago,
		CodigoBanco,  
		CuentaBancaria, 
		FechaTransaccion, 
		TipoPago,         
		NumeroDocumento,  
		NumeroSocio,      
		CodigoMonedaPago,
		TipoCambio,
		TransaccionOrigen
</cfquery>

<!--- Ciclo de Procesamiento de los Registros --->
<cfoutput query="rsRegistrosProcesar">
	<cftransaction>

	<cfquery datasource="sifinterfaces">
		update IdProceso
		set Consecutivo = Consecutivo + 1			
	</cfquery>

	<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
		select Consecutivo
		from IdProceso
	</cfquery>

	<cfset LvarID = rsObtieneSigId.consecutivo>

	<!--- 2. Insertar en IE11 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->

	<cfquery datasource="sifinterfaces">
		insert into IE11(
			ID,
			EcodigoSDC,
			TipoCobroPago,
			CodigoBanco,
			CuentaBancaria,
			FechaTransaccion,
			TipoPago,
			NumeroDocumento,
			NumeroSocio,    
			NumeroSocioDocumento,
			MontoPago,
			TipoCambio,           
			CodigoMonedaPago,   
			TransaccionOrigen,
			StatusProceso,
			ConDetalle
		)
		values (
			#LvarID#,
			#rsEmpresaSeleccionada.EcodigoSDCSoin#,
			'#rsRegistrosProcesar.TipoCobroPago#',
			'#rsRegistrosProcesar.CodigoBanco#',  
			#rsRegistrosProcesar.CuentaBancaria#, 
			#rsRegistrosProcesar.FechaTransaccion#, 
			'#rsRegistrosProcesar.TipoPago#',         
			'#rsRegistrosProcesar.NumeroDocumento#',  
			'#rsRegistrosProcesar.NumeroSocio#',      
			'#rsRegistrosProcesar.NumeroSocio#',      
			#rsRegistrosProcesar.MontoPago#
			#rsRegistrosProcesar.TipoCambio#
			'#rsRegistrosProcesar.CodigoMonedaPago#', 
			'#rsRegistrosProcesar.TransaccionOrigen#', 
			1,
			1
			)
	</cfquery>
			

	<!--- Copiar los detalles de IE11 a ID11 con el ID nuevo encontrado --->

	<cfquery datasource="sifinterfaces">
		insert into ID11 (
			ID,
		  	MontoPago,
			CodigoTransaccion,
			Documento,
			MontoPagoDocumento,
			CodigoMonedaDoc,
			BMUsucodigo,
			NumeroDocumento)
		select 
			#LvarNuevoID#,
		  	MontoPago,
			CodigoTransaccion,
			Documento,
			MontoPagoDocumento,
			CodigoMonedaDoc,
			BMUsucodigo,
		from IE11 a
		where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
		  and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
		  and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
		  and CuentaBancaria   =  #rsRegistrosProcesar.CuentaBancaria#
		  and FechaTransaccion =  #rsRegistrosProcesar.FechaTransaccion#
		  and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
		  and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
		  and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
		  and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
		  and StatusProceso    = 1

	</cfquery>

	<cfquery datasource="sifinterfaces">
		update IE11
		set StatusProceso = 10
		where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
		  and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
		  and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
		  and CuentaBancaria   =  #rsRegistrosProcesar.CuentaBancaria#
		  and FechaTransaccion =  #rsRegistrosProcesar.FechaTransaccion#
		  and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
		  and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
		  and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
		  and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
		  and StatusProceso    = 1
	</cfquery>

	</cftransaction>
</cfoutput>
