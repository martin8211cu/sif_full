<cftransaction>
	<cfif isdefined("form.btnGuardar")>
		<!--- Esta transacción debe insertar el registro de totales de formulación antes del monto solicitado por moneda, en caso de que no exista, 
			además debe actualizar este total al final de la transacción --->
			<!--- Obtiene los meses del Periodo --->
			<cfquery name="qry_meses" datasource="#session.dsn#">
				select 	m.CPCano, m.CPCmes
				from CPmeses m
				where m.Ecodigo 	= #session.ecodigo#
				  and m.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			</cfquery>

			<cfloop query="qry_meses">
				<!--- Inserta CVFormulacionTotales si no existen --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select count(1) as cantidad from CPTipoCambioProyectadoMes
					 where Ecodigo = #session.ecodigo#
					   and CPCano  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
					   and CPCmes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
					   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CPTipoCambioProyectadoMes
						(Ecodigo,CPCano,CPCmes,Mcodigo,CPTipoCambioCompra,CPTipoCambioVenta,CPTipoCambioCompraTmp,CPTipoCambioVentaTmp)
						values(
							#session.ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
							0, 0,
							<cfqueryparam cfsqltype="cf_sql_money" value="#evaluate('form.Compra_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#evaluate('form.Venta_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">
						)				
					</cfquery>
				<cfelse>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CPTipoCambioProyectadoMes
						   set CPTipoCambioCompraTmp	= <cfqueryparam cfsqltype="cf_sql_money" value="#evaluate('form.Compra_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">
							 , CPTipoCambioVentaTmp		= <cfqueryparam cfsqltype="cf_sql_money" value="#evaluate('form.Venta_#qry_meses.CPCano#_#qry_meses.CPCmes#')#">
					 where Ecodigo = #session.ecodigo#
					   and CPCano  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
					   and CPCmes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
					   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfquery>
				</cfif>

			</cfloop>
	<cfelseif isdefined("form.btnAplicar") OR isdefined("form.btnAplicar_Variacion")>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CPTipoCambioProyectadoMes
				   set CPTipoCambioCompra 		= CPTipoCambioCompraTmp
					 , CPTipoCambioVenta		= CPTipoCambioVentaTmp
			 where Ecodigo = #session.ecodigo#
			   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVFormulacionMonedas
				   set CVFMtipoCambio = 
				   		(select 
							case 
								when p.Ecodigo is null
									then null
								when my.Ctipo='A' or my.Ctipo='G' 
									then p.CPTipoCambioVenta
									else p.CPTipoCambioCompra
							end
						   from CPTipoCambioProyectadoMes p, 
						   		CVPresupuesto c
						   		inner join CVMayor my
									on my.Ecodigo	= c.Ecodigo
								   and my.CVid		= c.CVid
								   and my.Cmayor	= c.Cmayor
						  where p.Ecodigo = CVFormulacionMonedas.Ecodigo
						    and p.CPCano  = CVFormulacionMonedas.CPCano
						    and p.CPCmes  = CVFormulacionMonedas.CPCmes
						    and p.Mcodigo = CVFormulacionMonedas.Mcodigo

							and c.Ecodigo 	= CVFormulacionMonedas.Ecodigo
							and c.CVid	 	= CVFormulacionMonedas.CVid
							and c.CVPcuenta	= CVFormulacionMonedas.CVPcuenta
						)
				 where Ecodigo = #session.ecodigo#
				   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				   and exists 
				   		(select 1
						   from CVersion v
						  where v.Ecodigo 		= CVFormulacionMonedas.Ecodigo
						    and v.CVid 			= CVFormulacionMonedas.CVid
							and v.CVaprobada 	= 0
						)
			</cfquery>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CVFormulacionTotales
				   set CVFTmontoSolicitado = 
				   		(select sum(CVFMtipoCambio * (CVFMmontoBase + CVFMajusteUsuario + CVFMajusteFinal))
						   from CVFormulacionMonedas f
						  where f.Ecodigo 	= CVFormulacionTotales.Ecodigo
						    and f.CVid	  	= CVFormulacionTotales.CVid
						    and f.CPCano  	= CVFormulacionTotales.CPCano
						    and f.CPCmes  	= CVFormulacionTotales.CPCmes
						    and f.CVPcuenta	= CVFormulacionTotales.CVPcuenta
						    and f.Ocodigo	= CVFormulacionTotales.Ocodigo
						)
				 where Ecodigo = #session.ecodigo#
				   and exists 
				   		(select 1
						   from CVFormulacionMonedas f, CVersion v
						  where f.Ecodigo 	= CVFormulacionTotales.Ecodigo
						    and f.CVid	  	= CVFormulacionTotales.CVid
						    and f.CPCano  	= CVFormulacionTotales.CPCano
						    and f.CPCmes  	= CVFormulacionTotales.CPCmes
						    and f.CVPcuenta	= CVFormulacionTotales.CVPcuenta
						    and f.Ocodigo	= CVFormulacionTotales.Ocodigo
						    and f.Mcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
						    and v.Ecodigo 	= f.Ecodigo
						    and v.CVid 		= f.CVid
							and v.CVaprobada = 0
						)
			</cfquery>
	<cfelseif isdefined("form.btnRestaurar")>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				update CPTipoCambioProyectadoMes
				   set CPTipoCambioCompraTmp	= CPTipoCambioCompra
					 , CPTipoCambioVentaTmp		= CPTipoCambioVenta
			 where Ecodigo = #session.ecodigo#
			   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			</cfquery>
	<cfelseif isdefined("form.btnProyectar")>
		<cfset LvarAnoMes = listToArray(form.mesesProyeccion)>
		<cfset LvarAno = LvarAnoMes[1]>
		<cfset LvarMes = LvarAnoMes[2]>
		<cfquery name="qry_meses" datasource="#session.dsn#">
			select 	m.CPCano, m.CPCmes
			from CPmeses m
			where m.Ecodigo 	= #session.ecodigo#
			  and m.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			  and m.CPCano*100 + m.CPCmes >= #LvarAno*100+LvarMes#
			order by CPCano, CPCmes
		</cfquery>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select CPTipoCambioCompraTmp, CPTipoCambioVentaTmp
			  from CPTipoCambioProyectadoMes
			 where Ecodigo = #session.ecodigo#
			   and CPCano  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAno#">
			   and CPCmes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMes#">
			   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		</cfquery>

		<cfset LvarCambioCompra = rsSQL.CPTipoCambioCompraTmp>
		<cfset LvarCambioVenta  = rsSQL.CPTipoCambioVentaTmp>
		<cfif LvarCambioCompra EQ 0 or LvarCambioVenta EQ 0>
			<cf_errorCode	code = "50544"
							msg  = "No se ha digitado el Tipo de Cambio de compra o venta inicial de la Proyeccion (@errorDat_1@-@errorDat_2@)"
							errorDat_1="#LvarAno#"
							errorDat_2="#LvarMes#"
			>
		</cfif>
			<cfloop query="qry_meses">
				<cfif qry_meses.currentRow GT 1>
					<cfif form.tipoProyeccion EQ 1>
						<cfset LvarCambioCompra = LvarCambioCompra + form.montoProyeccion>
						<cfset LvarCambioVenta  = LvarCambioVenta + form.montoProyeccion>
					<cfelse>
						<cfset LvarCambioCompra = LvarCambioCompra * (1 + form.montoProyeccion/100)>
						<cfset LvarCambioVenta  = LvarCambioVenta  * (1 + form.montoProyeccion/100)>
					</cfif>
					<cfset LvarCambioCompra = round(LvarCambioCompra*100)/100>
					<cfset LvarCambioVenta  = round(LvarCambioVenta *100)/100>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select count(1) as cantidad from CPTipoCambioProyectadoMes
						 where Ecodigo = #session.ecodigo#
						   and CPCano  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
						   and CPCmes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
						   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
					</cfquery>
					<cfif rsSQL.cantidad EQ 0>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							insert into CPTipoCambioProyectadoMes
							(Ecodigo,CPCano,CPCmes,Mcodigo,CPTipoCambioCompra,CPTipoCambioVenta,CPTipoCambioCompraTmp,CPTipoCambioVentaTmp)
							values(
								#session.ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
								0, 0,
								<cfqueryparam cfsqltype="cf_sql_money" value="#LvarCambioCompra#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#LvarCambioVenta#">
							)				
						</cfquery>
					<cfelse>
						<cfquery name="rsSQL" datasource="#session.dsn#">
							update CPTipoCambioProyectadoMes
							   set CPTipoCambioCompraTmp	= <cfqueryparam cfsqltype="cf_sql_money" value="#LvarCambioCompra#">
								 , CPTipoCambioVentaTmp		= <cfqueryparam cfsqltype="cf_sql_money" value="#LvarCambioVenta#">
						 where Ecodigo = #session.ecodigo#
						   and CPCano  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCano#">
						   and CPCmes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#qry_meses.CPCmes#">
						   and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
	</cfif>
	<cfif isdefined("form.btnAplicar_Variacion")>
		<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
			select Mcodigo
			  from Empresas 
			 where Ecodigo = #session.ecodigo#
		</cfquery>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
		<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select CPPfechaDesde as CPPdesde
			  from CPresupuestoPeriodo
			 where Ecodigo = #session.ecodigo#
			   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>

			<!--- Determina tipos de cambio Variados --->
			<cfquery name="rsVariacion" datasource="#session.dsn#">
				select 	cm.Ecodigo, cm.CPPid, cm.CPCano, cm.CPCmes, cm.CPcuenta, cm.Ocodigo, cm.Mcodigo, 
						CPCMid, CPCMpresupuestado, CPCMmodificado, CPCMtipoCambioAplicado, CPCMmontoLocalVariacion,
						case 
							when my.Ctipo in ('A','G') 
								then p.CPTipoCambioVentaTmp
								else p.CPTipoCambioCompraTmp
						end as NuevoTipoCambio,
						cpc.CPCPtipoControl,
						cpc.CPCPcalculoControl
				  from CPControlMoneda cm
					inner join CPresupuesto cp
						inner join CtasMayor my
							on my.Ecodigo = cp.Ecodigo
							and my.Cmayor = cp.Cmayor
						inner join CPCuentaPeriodo cpc
							on cpc.Ecodigo 		= cp.Ecodigo
							and cpc.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							and cpc.CPcuenta	= cp.CPcuenta
						on cp.CPcuenta = cm.CPcuenta
					inner join Monedas m
						on m.Mcodigo = cm.Mcodigo
					inner join CPTipoCambioProyectadoMes p
						on p.Ecodigo = cm.Ecodigo
					   and p.CPCano  = cm.CPCano
					   and p.CPCmes  = cm.CPCmes
					   and p.Mcodigo = cm.Mcodigo
				 where cm.Ecodigo 	= #session.ecodigo#
				   and cm.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				   and not exists(select 1 from Empresas where Ecodigo = cm.Ecodigo and Mcodigo = cm.Mcodigo)
				   and cm.CPCMtipoCambioAplicado <> 						
				   		case 
							when my.Ctipo in ('A','G') 
								then p.CPTipoCambioVentaTmp
								else p.CPTipoCambioCompraTmp
						end 
					and cm.CPCano*100+cm.CPCmes >= #LvarAuxAnoMes#
				order by cm.Ecodigo, cm.CPPid, cm.CPCano, cm.CPCmes, cm.CPcuenta, cm.Ocodigo, cm.Mcodigo
			</cfquery>

			<cfif rsVariacion.recordCount GT 0>
				<cfset LvarFecha = createdate(rsVariacion.CPCano,rsVariacion.CPCmes,1)>
	
				<!--- Incluir el documento de Variación Cambiaria --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select max(CPVTEnumero) as CPVTEnumero
					  from CPVariacionTipoCambioE
					 where Ecodigo = #session.ecodigo#
				</cfquery>
				<cfif rsSQL.CPVTEnumero EQ "">
					<cfset LvarCPVTEnumero = 1>
				<cfelse>
					<cfset LvarCPVTEnumero = rsSQL.CPVTEnumero + 1>
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into CPVariacionTipoCambioE
						(Ecodigo, CPVTEnumero, CPPid, CPVTEfecha, Usucodigo)
					values (#session.Ecodigo#, #LvarCPVTEnumero#, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">, 
						#session.Usucodigo#)
				</cfquery>
	
				<!--- Crea la tabla temporal para Control de Presupuesto --->
				<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
				<cfset LobjControl.CreaTablaIntPresupuesto(session.dsn,false,false,true)>
	
				<!--- Procesa cada Variacion --->
				<cfloop query="rsVariacion">
					<cfset LvarVariacion = (rsVariacion.CPCMpresupuestado + rsVariacion.CPCMmodificado) * (rsVariacion.NuevoTipoCambio - rsVariacion.CPCMtipoCambioAplicado)>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into CPVariacionTipoCambioD
							(Ecodigo, CPVTEnumero, CPVTDlinea, CPCMid, 
							 CPVTDtipoCambioAnterior, CPVTDtipoCambioAplicado, 
							 CPVTDpresupuestado, CPVTDmodificado,
							 CPVTDmontoLocalVariacion)
						values(
							#session.Ecodigo#, #LvarCPVTEnumero#, #rsVariacion.currentRow#, #rsVariacion.CPCMid#, 
							#rsVariacion.CPCMtipoCambioAplicado#, #rsVariacion.NuevoTipoCambio#,
							#rsVariacion.CPCMpresupuestado#, 	  #rsVariacion.CPCMmodificado#,
							#LvarVariacion#
							)
					</cfquery>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update 	CPControlMoneda
						   set 	CPCMmontoLocalVariacion = CPCMmontoLocalVariacion + #LvarVariacion#,
								CPCMtipoCambioAplicado = #rsVariacion.NuevoTipoCambio#
						 where Ecodigo 	= #session.ecodigo#
						   and CPCMid = #rsVariacion.CPCMid#
					</cfquery>
	
					<cfquery datasource="#session.DSN#">
						insert into #request.intPresupuesto#
							(
								ModuloOrigen,
								NumeroDocumento,
								NumeroReferencia,
								FechaDocumento,
								AnoDocumento,
								MesDocumento,
								
								NumeroLinea, 
								CPPid, CPCanoMes, CPCano, CPCmes, CPcuenta, Ocodigo,
								TipoControl, CalculoControl,
								TipoMovimiento, SignoMovimiento,
								Mcodigo, 	MontoOrigen, 
								TipoCambio, Monto,
								NAPreferencia, LINreferencia
							)
						values ('PRFO', '#LvarCPVTEnumero#', 'VARIACION', 
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFecha#">, 
								#datePart('YYYY',LvarFecha)#, #datePart('M',LvarFecha)#,
								
								#rsVariacion.currentRow#,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">,
								#rsVariacion.CPCano*100+rsVariacion.CPCmes#,
								#rsVariacion.CPCano#, #rsVariacion.CPCmes#, #rsVariacion.CPcuenta#, #rsVariacion.Ocodigo#,
								#rsVariacion.CPCPtipoControl#, #rsVariacion.CPCPcalculoControl#, 
								'VC', 1, 
								#rsMonedaLocal.Mcodigo#, #LvarVariacion#,
								1, #LvarVariacion#,
								null, null
								)
					</cfquery>
				</cfloop>

				<cfset LvarNAP = LobjControl.ControlPresupuestario("PRFO", LvarCPVTEnumero, "VARIACION", now(), datepart("YYYY",rsPeriodo.CPPdesde), datepart("M",rsPeriodo.CPPdesde))>
				<cfif LvarNAP GTE 0>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CPVariacionTipoCambioE
						   set NAP = #LvarNAP#
						where Ecodigo = #session.Ecodigo#
						  and CPVTEnumero = #LvarCPVTEnumero#
					</cfquery>
				<cfelse>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update CPVariacionTipoCambioE
						   set NRP = #abs(LvarNAP)#
						where Ecodigo = #session.Ecodigo#
						  and CPVTEnumero = #LvarCPVTEnumero#
					</cfquery>
				</cfif>
			</cfif>
	</cfif>
</cftransaction>
<cfif isdefined("LvarNAP") AND LvarNAP LT 0>
	<cflocation url="../consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
<cfelse>
	<cflocation url="tiposCambio.cfm?CPPid=#form.CPPid#&Mcodigo=#form.Mcodigo#">
</cfif>


