<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInput" datasource="sifinterfaces">
		select 
				 e.ModuloOrigen,
				 e.NumeroDocumento,
				 e.NumeroReferencia,
				 e.FechaDocumento,
				 e.AnoPresupuesto,
				 e.MesPresupuesto,
				 coalesce(e.NAPreversado,-1) as NAPreversado,
				 e.SoloConsultar,

				 d.NumeroLinea,
				 d.TipoMovimiento,
				 d.CuentaFinanciera,
				 d.CodigoOficina,
				 d.CodigoMonedaOrigen,
				 d.MontoOrigen,
				 d.TipoCambio,
				 d.Monto,
				 d.NAPreferencia,
				 d.LINreferencia
		  from IE8 e
		  	inner join ID8 d
				on d.ID = e.ID
		 where e.ID = #GvarID#
	</cfquery>
	<cfif rsInput.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 8=Control de Presupuesto">
	</cfif>
</cftransaction>

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto()>
<cftransaction>
	<cfloop query="rsInput">
		<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
		<cfquery datasource="#session.DSN#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NAPreversado,
					
					NumeroLinea, 
					CuentaFinanciera,
					CodigoOficina,
					TipoMovimiento,		--- RC=Reserva o CC=Compromiso
					CodigoMoneda, 		MontoOrigen, 
					TipoCambio, 		Monto,
					NAPreferencia, 		LINreferencia
				)
			values (
					'#rsInput.ModuloOrigen#',
					'#rsInput.NumeroDocumento#',
					'#rsInput.NumeroReferencia#',
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsInput.FechaDocumento#">,
					#rsInput.AnoPresupuesto#,
					#rsInput.MesPresupuesto#,
					<cfif rsInput.NAPreversado EQ "">null<cfelse>#rsInput.NAPreversado#</cfif>,
	
					#rsInput.NumeroLinea#,
					'#rsInput.CuentaFinanciera#',
					'#rsInput.CodigoOficina#',
					'#rsInput.TipoMovimiento#<cfif rsInput.TipoMovimiento NEQ "E">C</cfif>',
					'#rsInput.CodigoMonedaOrigen#', 	#rsInput.MontoOrigen#,
					#rsInput.TipoCambio#,				#rsInput.Monto#,
					<cfif rsInput.NAPreferencia EQ "">null<cfelse>#rsInput.NAPreferencia#</cfif>,
					<cfif rsInput.LINreferencia EQ "">null<cfelse>#rsInput.LINreferencia#</cfif>
				)
		</cfquery>
	</cfloop>

	<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
	<cfset LvarNAP = LobjControl.ControlPresupuestario(
						rsInput.ModuloOrigen,
						rsInput.NumeroDocumento,
						rsInput.NumeroReferencia,
						rsInput.FechaDocumento,
						rsInput.AnoPresupuesto,
						rsInput.MesPresupuesto,
						#session.DSN#,
						#session.Ecodigo#,
						rsInput.NAPreversado,
						rsInput.SoloConsultar
					)>
	<cfquery name="rsOutput" dbtype="query">
		select 
				NumeroLinea,
				CPCano as AnoPresupuesto,
				CPCmes as MesPresupuesto,
				CuentaPresupuesto,
				CodigoOficina,
				TipoControl,
				CalculoControl,
				TipoMovimiento,
				SignoMovimiento,
				Monto,
				DisponibleAnterior,
				DisponibleGenerado,
				ExcesoGenerado,
				ExcesoConRechazo as ProvocoRechazo
		  from request.rsIntPresupuesto
		 where CPcuenta is not null
	</cfquery>
</cftransaction>

<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<cftransaction>
	<cfquery datasource="sifinterfaces">
		insert into OE8
			(
				ID,
				NAP,
				NRP,
				MSG
			)
		values (
				#GvarID#,
				<cfif LvarNAP GTE 0>
					#LvarNAP#, 0,
				<cfelse>
					-1, #-LvarNAP#,
				</cfif>
				'OK'
			)
	</cfquery>
	<cfloop query="rsOutput">
		<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>
		<cfquery datasource="sifinterfaces">
			insert into OD8
				(
					ID,
					NumeroLinea
			<cfif rsOutput.CuentaPresupuesto NEQ "">
					,
					AnoPresupuesto,
					MesPresupuesto,
					CuentaPresupuesto,
					CodigoOficina,
					TipoControl,
					CalculoControl,
					TipoMovimiento,
					SignoMovimiento,
					MontoMovimiento,
					DisponibleAnterior,
					DisponibleGenerado,
					ExcesoGenerado,
					ProvocoRechazo
			</cfif>
				)
			values (
					#GvarID#,
					#rsOutput.NumeroLinea#
			<cfif rsOutput.CuentaPresupuesto NEQ "">
					,
					#rsOutput.AnoPresupuesto#,
					#rsOutput.MesPresupuesto#,
					'#rsOutput.CuentaPresupuesto#',
					'#rsOutput.CodigoOficina#',
					#rsOutput.TipoControl#,
					#rsOutput.CalculoControl#,
					'#rsOutput.TipoMovimiento#',
					#rsOutput.SignoMovimiento#,
					#rsOutput.Monto#,
					#rsOutput.DisponibleAnterior#,
					#rsOutput.DisponibleGenerado#,
					#rsOutput.ExcesoGenerado#,
					#rsOutput.ProvocoRechazo#
			</cfif>
				)
		</cfquery>
	</cfloop>
</cftransaction>
