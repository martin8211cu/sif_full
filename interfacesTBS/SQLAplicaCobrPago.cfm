<cftransaction>
	<!--- Inclusión de movimiento en tablas IE11, ID11 --->
	<cfquery name="rsEncabezado" datasource="sifinterfaces">
		select *
		from PMIINT_IE11
		where sessionid = #session.monitoreo.sessionid#
	</cfquery>
	<cfloop query="rsEncabezado"> 
		<cfquery datasource="sifinterfaces">
			update IdProceso
			set Consecutivo = Consecutivo + 1			
		</cfquery>
	
		<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
			select Consecutivo
			from IdProceso
		</cfquery>
		<cfif rsObtieneSigId.recordcount GT 0>
			<cfset LvarID = rsObtieneSigID.Consecutivo>
		</cfif>
		<!--- graba la tabla IE11 --->
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
				#rsEncabezado.EcodigoSDCSoin#,
				'#rsEncabezado.TipoCobroPago#',
				'#rsEncabezado.CodigoBanco#',  
				'#rsEncabezado.CuentaBancaria#', 
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezado.FechaTransaccion#">, 
				'#rsEncabezado.TipoPago#',         
				'#rsEncabezado.NumeroDocumento#',  
				'#rsEncabezado.NumeroSocio#',      
				'#rsEncabezado.NumeroSocio#',      
				#rsEncabezado.MontoPago#,
				#rsEncabezado.TipoCambio#,
				'#rsEncabezado.CodigoMonedaPago#', 
				1,
				1,
				'-1'
				)
		</cfquery>
		<cfquery name="rsDetalle" datasource="sifinterfaces">
			select *
			from PMIINT_ID11
			where sessionid = #session.monitoreo.sessionid#
			  and ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.ID#">, 
		</cfquery>
		<cfloop query="rsDetalle">
			insert into ID11 (
				ID,
				MontoPago,
				CodigoTransaccion,
				Documento,
				MontoPagoDocumento,
				CodigoMonedaDoc,
				BMUsucodigo,
				Anticipo)
			values (
				#LvarID#,
				#rsDetalle.MontoPago#,
				'#rsDetalle.CodigoTransaccion#',
				'#rsDetalle.Documento#',
				#rsDetalle.MontoPagoDocumento#,
				'#rsDetalle.CodigoMonedaDoc#',
				#rsDetalle.BMUsucodigo#,
				#rsDetalle.Anticipo#,
				)
		</cfloop>
	</cfloop>

	<!--- Inclusión de movimiento en cola de proceso --->
	<cfquery name="rsIE11" datasource="sifinterfaces">
		select ID, EcodigoSDC
		from IE11
		where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin#
		  and ID not in (select IdProceso from InterfazBitacoraProcesos
						 where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11) 
		  and ID not in(select IdProceso from InterfazColaProcesos
						where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11)
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
