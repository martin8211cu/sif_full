<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="3600">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfsetting enablecfoutputonly="yes">

<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">

<cfquery name="rsEquivalencias" datasource="sifinterfaces">
	select EQUempOrigen, EQUempSIF, EQUcodigoSIF from SIFLD_Equivalencia
	where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and CATcodigo = 'CADENA'
</cfquery>

<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.EQUempOrigen>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	

<cf_htmlreportsheaders
	title="Importacion de Cobros y Pagos" 
	filename="ImportaCobrosPagos-#Session.Usucodigo#.xls" 
	ira="ConsCobrosPagosParam.cfm">
<cf_templatecss>

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

<cfset LvarSocioN = ''>
<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
	<cfset LvarSocioN = form.SocioN >
<cfelse>
	<cfset LvarSocioN = 'nada' >
</cfif>

<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
	<cfif  (isdefined("form.Cobros") and len(trim(form.Cobros))) or (isdefined("form.Pagos") and len(trim(form.Pagos))) >
	<cfelse>
	<cfthrow message="Debe seleccionar el check de cobros o pagos">
	</cfif>
</cfif>

<table width="100%" border="1">
	<tr><td colspan="1" align="center"><strong>Reporte de Proceso</strong></td>
	<tr><td colspan="1" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="1" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="1">&nbsp;</td></tr>
</cfoutput>
<cfflush interval="40">

<!--- 1.Seleccionar los registros a procesar. Tienen codigo de Empresa Anterior y deben generar encabezado / Detalle --->
<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces"> <!---sifinterfacessybase--->
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
	from .icts_soin.IE11 a
	where a.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	  and a.Procesado = 'N'
	 	  <cfif isdefined("LvarTipo") and LvarTipo NEQ 'Ambos'>
		  and a.TipoCobroPago = '#LvarTipo#'
	 	  </cfif>
	 	  <cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
		  and a.NumeroSocio = '#LvarSocioN#'
	 	  </cfif>
	  <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
		  and CodigoMonedaPago = '#form.Moneda#'
	  </cfif>
	  and a.FechaTransaccion between #vFechaI# and #vFechaF#
	  and TipoOperacion != '2'
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
		
			<cfquery name="rsDetallesIE11" datasource="sifinterfaces"> <!---sifinterfacessybase--->
			select 
				#LvarID# as LvarID,
				MontoPago,
				CodigoTransaccion,
				Documento,
				MontoPagoDocumento,
				CodigoMonedaDoc,
				BMUsucodigo,
				Case when CodigoTransaccion='AN' then 1 else 0 end as Anticipo,
				MontoRetencion
			from .icts_soin.IE11 a
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
			  and TipoOperacion != '2'
		</cfquery>

	<cftransaction action="begin">
	<cftry>
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
				#rsEquivalencias.EQUcodigoSIF#,
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
		<cfloop query="rsDetallesIE11">
			<cfquery datasource="sifinterfaces">
				insert into ID11 (
							ID,
							MontoPago,
							CodigoTransaccion,
							Documento,
							MontoPagoDocumento,
							CodigoMonedaDoc,
							BMUsucodigo,
							Anticipo,
							MontoRetencion)
				values 		
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDetallesIE11.LvarID#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetallesIE11.MontoPago#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetallesIE11.CodigoTransaccion#">,
			 				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetallesIE11.Documento#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDetallesIE11.MontoPagoDocumento#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetallesIE11.CodigoMonedaDoc#">,
							 <cfif isdefined("rsDetallesIE11.BMUsucodigo") and rsDetallesIE11.BMUsucodigo NEQ ''>
							 	<cfqueryparam cfsqltype="cf_sql_integer" value="#BMUsucodigo#">,
							 <cfelse>
							 	null,
							</cfif>
							 <cfqueryparam cfsqltype="cf_sql_bit" value="#Anticipo#">,
							 <cfif rsDetallesIE11.MontoRetencion EQ ''>
							     null)
							 <cfelse>
							 	<cfqueryparam cfsqltype="cf_sql_money" value="#rsDetallesIE11.MontoRetencion#">)
							</cfif>
			</cfquery>
		</cfloop>


		<!--- Inclusión de movimiento en cola de proceso --->
		<cfquery name="rsIE11" datasource="sifinterfaces">
			select ID, EcodigoSDC
			from IE11
			where EcodigoSDC= #rsEquivalencias.EQUcodigoSIF#
			  and (select count(1) from InterfazBitacoraProcesos where IdProceso = IE11.ID) = 0
			  and (select count(1) from InterfazColaProcesos  	 where IdProceso = IE11.ID) = 0
		</cfquery>
		
		<cfloop query="rsIE11"> 
		
			<cfquery name="rsColaProcesos" datasource="sifinterfaces">
		
				insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion,UsuarioBdInclusion, Cancelar)
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
  				  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
			</cfquery>
		</cfloop>
		
		<cfquery datasource="sifinterfaces">
			update IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsEquivalencias.EQUcodigoSIF#
			and Procesado        =  'N'
		</cfquery>

	<cfcatch>
		<cftransaction action="rollback"/>
		<cfthrow message="Error al insertar #cfcatch.Message#" detail="#cfcatch.Detail#">
	</cfcatch>
	</cftry>
	<cftransaction action="commit"/>			
	</cftransaction>
		
	<!--- Marcar los Registros como procesados --->
	<cftry>
		<cfquery datasource="sifinterfaces"> <!---sifinterfacessybase--->
			update .icts_soin.IE11
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
		
		<cfcatch>
			<cfquery datasource="sifinterfaces">
				delete ID11 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete IE11 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete InterfazColaProcesos where IdProceso = #LvarID# and NumeroInterfaz = 11
			</cfquery>
			<cfthrow message="Error al actualizar la tabla intermedia #cfcatch.Message#" detail="#cfcatch.Detail#">
		</cfcatch>
		</cftry>					

</cfoutput>
	

<!--- MODIFICACION PARA IE14--->
<!--- 2.Seleccionar los registros a procesar PARA LA ie14.--->

<cfquery name="rsRegistrosProcesar2" datasource="sifinterfaces"> <!---sifinterfacessybase--->
	select 		EcodigoSDC,   	0 as MontoOrigen, 0 as MontoComision,
			CodigoBanco,  	CuentaBancaria, 	CodigoTransaccion,CodigoMonedaPago,sum(MontoPago) as MontoPago,
                   	FechaTransaccion, 		Conceptoservicio, 0 as IndMovConta, 0 as Estimacion,NumeroDocumento,
					count(1) as CantidadDetalles,TipoCobroPago,TipoPago,NumeroSocio,TipoCambio ,getdate() as FechaAplicacion,									
					'' as Observacion             
	from .icts_soin.IE11 a
	where a.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
	  and a.Procesado = 'N'
	 	  <cfif isdefined("LvarTipo") and LvarTipo NEQ 'Ambos'>
		  and a.TipoCobroPago = '#LvarTipo#'
	 	  </cfif>
	 	  <cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
		  and a.NumeroSocio = '#LvarSocioN#'
	 	  </cfif>
	  <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
		  and CodigoMonedaPago = '#form.Moneda#'
	  </cfif>
	  and a.FechaTransaccion between #vFechaI# and #vFechaF#
	  and TipoOperacion = '2'
	  group by EcodigoSDC,
	    CodigoBanco,
		CuentaBancaria,
		CodigoTransaccion,
		CodigoMonedaPago,
		FechaTransaccion,
		Conceptoservicio,
		NumeroDocumento ,TipoCobroPago,TipoPago,NumeroSocio,TipoCambio
		
</cfquery>

<!--- Ciclo de Procesamiento de los Registros --->
		
<cfoutput query="rsRegistrosProcesar2">
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

		<cftransaction action="begin"> 
		<cftry>
		<cfquery datasource="sifinterfaces">
			insert into IE14(
					ID,
					EcodigoSDC,
					MontoOrigen,
					MontoComision,
					CodigoBancoDestino,
					CuentaBancariaDestino,
					TipoMovimientoDestino,
					CodigoMonedaDestino,
					MontoDestino,
					FechaValor,
					IndMovConta,
					Estimacion,
					NumeroDocumento,
					ConceptoComision,
					FechaAplicacion,
					Observacion,
					Procesado)
			values (#LvarID#,
					#rsEquivalencias.EQUcodigoSIF#,	
					#rsRegistrosProcesar2.MontoOrigen#,
					#rsRegistrosProcesar2.MontoComision#,					                    '#rsRegistrosProcesar2.CodigoBanco#',
					'#rsRegistrosProcesar2.CuentaBancaria#',			
	                '#rsRegistrosProcesar2.CodigoTransaccion#',
					'#rsRegistrosProcesar2.CodigoMonedaPago#', 
					#rsRegistrosProcesar2.MontoPago#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar2.FechaTransaccion#">,		                    '#rsRegistrosProcesar2.IndMovConta#',			
					#rsRegistrosProcesar2.Estimacion#,
					'#rsRegistrosProcesar2.NumeroDocumento#' ,
	                '#rsRegistrosProcesar2.Conceptoservicio#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar2.FechaAplicacion#">,	
					'#rsRegistrosProcesar2.Observacion#',
					'S')
			</cfquery>

		
		<!--- Inclusión de movimiento en cola de proceso --->
		<cfquery name="rsIE14" datasource="sifinterfaces">
			select ID, EcodigoSDC	
				from IE14
			where EcodigoSDC= #rsEquivalencias.EQUcodigoSIF#
			  and (select count(1) from InterfazBitacoraProcesos where IdProceso = IE14.ID) = 0
			  and (select count(1) from InterfazColaProcesos  	 where IdProceso = IE14.ID) = 0
		</cfquery>
			<cfloop query="rsIE14"> 
			<cfquery name="rsColaProcesos2" datasource="sifinterfaces">
				insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion,UsuarioBdInclusion, Cancelar)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=14>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE14.ID#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE14.EcodigoSDC#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
  				  <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
			</cfquery>
		</cfloop>

		<cfquery datasource="sifinterfaces">
			update IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsEquivalencias.EQUcodigoSIF#
			and Procesado        =  'N'
		</cfquery>
		
		<cfcatch>
			<cftransaction action="rollback"/>
			<cfthrow message="Error al insertar en Interfaz 14 #cfcatch.Message#" detail="#cfcatch.Detail#">
		</cfcatch>
		</cftry>
		<cftransaction action="commit"/>
		</cftransaction>	
		
		<cftry>
		<!--- Marcar los Registros como procesados --->
		<cfquery datasource="sifinterfaces"> <!---sifinterfacessybase--->
			update .icts_soin.IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsRegistrosProcesar2.EcodigoSDC#
			and TipoCobroPago    =  '#rsRegistrosProcesar2.TipoCobroPago#'
			and CodigoBanco      =  '#rsRegistrosProcesar2.CodigoBanco#'
			and CuentaBancaria   =  '#rsRegistrosProcesar2.CuentaBancaria#'
			and FechaTransaccion =   <cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar2.FechaTransaccion#">
			and TipoPago         =  '#rsRegistrosProcesar2.TipoPago#'
			and NumeroDocumento  =  '#rsRegistrosProcesar2.NumeroDocumento#'
			and NumeroSocio      =  '#rsRegistrosProcesar2.NumeroSocio#'
			and CodigoMonedaPago =  '#rsRegistrosProcesar2.CodigoMonedaPago#'
			and Procesado        =  'N'
            and TipoOperacion = '2'
		</cfquery>
		
		<cfcatch>
			<cfquery datasource="sifinterfaces">
				delete IE14 where ID = #LvarID#
			</cfquery>
			<cfquery datasource="sifinterfaces">
				delete InterfazColaProcesos where IdProceso = #LvarID# and NumeroInterfaz = 14
			</cfquery>
			<cfthrow message="Error al actualizar los registros de la tabla Intermedia #cfcatch.Message#" detail="#cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfoutput>
<!---</cfloop>
</cfif>  cierra el loop de empresas--->
<cfoutput>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9" align="center"><strong>Fin.</strong></td>
</cfoutput>
</table>
<cfabort>

