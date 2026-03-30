<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdate(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2))>

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

<cfoutput>
<cfset LvarTipo = ''>
<cfif isdefined("form.Cobros") and len(trim(form.Cobros))>
	<cfset LvarTipo = 'C'>
</cfif>
<cfif isdefined("form.Pagos") and len(trim(form.Pagos))>
	<cfset LvarTipo = 'P'>
</cfif>
<cfif isdefined("form.Cobros") and len(trim(form.Cobros)) and isdefined("form.Pagos") and len(trim(form.Pagos))>
	<cfset LvarTipo = 'Ambos'>
</cfif>

<table width="100%" border="1">
	<tr><td colspan="1" align="center"><strong>Reporte de Proceso</strong></td>
	<tr><td colspan="1" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="1" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="1">&nbsp;</td></tr>
</cfoutput>
<cfflush interval="40">



<!--- 1.Seleccionar los registros a procesar. Tienen codigo de Empresa Anterior y deben generar encabezado / Detalle --->
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
		sum(MontoPago) as MontoPago,
		count(1) as CantidadDetalles
	from IE11 a
	where a.EcodigoSDC = #rsEmpresaSeleccionada.CodICTS#
	  and a.Procesado = 'N'
	 	  <cfif isdefined("LvarTipo") and LvarTipo NEQ 'Ambos'>
		  and a.TipoCobroPago = '#LvarTipo#'
	 	  </cfif>
	  <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
		  and CodigoMonedaPago = '#form.Moneda#'
	  </cfif>
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
		TipoCambio

</cfquery>

<!--- Ciclo de Procesamiento de los Registros --->
		<cftransaction> 
<cfoutput query="rsRegistrosProcesar">
	<tr><td colspan="1" align="left">Procesando Documento: #CuentaBancaria# / #NumeroDocumento# Fecha: #LsDateFormat(FechaTransaccion,'dd/mm/yyyy')#. #NumberFormat(CantidadDetalles, ",9.00")# Registros </td>
		<cfquery datasource="sifinterfaces">
			update IdProceso
			set Consecutivo = Consecutivo + 1			
		</cfquery>
	
		<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
			select Consecutivo
			from IdProceso
		</cfquery>
	
		<cfset LvarID = rsObtieneSigId.consecutivo>
		<tr><td colspan="1" align="left">ID: #LvarID#</td>

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
				StatusProceso,
				ConDetalle,
				TransaccionOrigen
			)
			values (
				#LvarID#,
				#rsEmpresaSeleccionada.EcodigoSDCSoin#,
				'#rsRegistrosProcesar.TipoCobroPago#',
				'#rsRegistrosProcesar.CodigoBanco#',  
				'#rsRegistrosProcesar.CuentaBancaria#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">, 
				'#rsRegistrosProcesar.TipoPago#',         
				'#rsRegistrosProcesar.NumeroDocumento#',  
				'#rsRegistrosProcesar.NumeroSocio#',      
				'#rsRegistrosProcesar.NumeroSocio#',      
				#rsRegistrosProcesar.MontoPago#,
				#rsRegistrosProcesar.TipoCambio#,
				'#rsRegistrosProcesar.CodigoMonedaPago#', 
				1,
				1,
				'-1'
				)
		</cfquery>

		<!--- 2. Insertar en IE11 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->
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
				Anticipo)
			select 
				#LvarID#,
				MontoPago,
				CodigoTransaccion,
				Documento,
				MontoPagoDocumento,
				CodigoMonedaDoc,
				BMUsucodigo,
				Case when CodigoTransaccion='AN' then 1 else 0 end
			from IE11 a
			where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
			  and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
			  and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
			  and CuentaBancaria   =  '#rsRegistrosProcesar.CuentaBancaria#'
			  and FechaTransaccion = <cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">
			  and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
			  and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
			  and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
			  and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
			  and Procesado    =  'N'
		</cfquery>




<!--- Inclusión de movimiento en cola de proceso --->

		<cfquery name="rsIE11" datasource="sifinterfaces">
			select ID, EcodigoSDC
			from IE11
			where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin#
			  and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11) 
			  and ID not in(select IdProceso from InterfazColaProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11)
		</cfquery>
		<cfloop query="rsIE11"> 
			<cfquery name="rsColaProcesos" datasource="sifinterfaces">
		
				insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion, Cancelar)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=11>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE11.ID#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE11.EcodigoSDC#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
			</cfquery>
		</cfloop>


		<!--- Marcar los Registros como procesados --->
		<cfquery datasource="sifinterfaces">
			update IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
			and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
			and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
			and CuentaBancaria   =  '#rsRegistrosProcesar.CuentaBancaria#'
			and FechaTransaccion =   <cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">
			and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
			and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
			and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
			and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
			and Procesado        =  'N'
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsEmpresaSeleccionada.EcodigoSDCSoin#
			and Procesado        =  'N'
		</cfquery>
		</cfoutput>
</cftransaction>		
<cfoutput>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9" align="center"><strong>Fin.</strong></td>
</cfoutput>
</table>
<cfabort>

