<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfparam name="form.tipo" default="GASTOS">
<cfif isdefined('url.GELid') and len(trim(url.GELid)) gt 0>
	<cfset id=#url.GELid#>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined ('form.GELid') and  len(trim(form.GELid)) gt 0>
	<cfset id=#form.GELid#>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfset redirecciona = "TransaccionCustodiaP.cfm">

<cfif IsDefined("form.IrLista")>
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>

<!---Aplica Anticipo o Liquidacion--->
<cfif IsDefined("form.btnAplicar")>
	<cfquery name="rsTranCustodio" datasource="#session.dsn#">
		select CCHTCid,CCHTCnumero,CCHTCestado,CCHTCconfirmador,CCHTCfecha,CCHTid,CCHTtipo                      
		  from CCHTransaccionesCProceso
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and CCHTCrelacionada=#id# 
		   and CCHTtipo='#form.tipo#'
	</cfquery>
	<cfif form.tipo eq 'GASTOS'>
		<cfset LvarTipo = 'GASTO'>

		<cfquery name="rsLiquidacion" datasource="#session.dsn#">
			select GELid, GELdescripcion, lq.TESSPid,
					GELtotalGastos, coalesce (GELtotalAnticipos,0) as GELtotalAnticipos, coalesce (GELtotalDevoluciones,0) as GELtotalDevoluciones,
					GELnumero, 
					lq.CCHid, ch.CCHtipo as CCHtipo_caja, ch.CCHcodigo, lq.Mcodigo,
					GELreembolso, GELtipoCambio,
					TESSPid_Adicional
			from GEliquidacion lq
				inner join CCHica ch
					on ch.CCHid = lq.CCHid
			where lq.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and GELid=#id# 
		</cfquery>

		<!---Asociacion de anticipos a liquidacion--->
		<cfquery name="rsConsulaAnt" datasource="#session.dsn#">
			select GEAid,GEADid,GELAtotal
			from  GEliquidacionAnts
			where GELid=#id# 
		</cfquery>
			
		<cfif rsLiquidacion.GELtotalAnticipos neq 0>
			<cfquery name="rsAnticipo" datasource="#session.dsn#">
				select coalesce(GEAtotalOri,0) as GEAtotalOri ,CCHid,c.GEAid,GEADmonto, GEADutilizado
					from GEanticipo a
					inner join GEanticipoDet c
					on a.GEAid=c.GEAid
					where
					<cfif form.tipo eq 'GASTOS'>
					a.GEAid =#rsConsulaAnt.GEAid#
					<cfelse>
					a.GEAid =#id#
					</cfif>
			</cfquery>
			<cfquery name="rsAnticipoUtili" datasource="#session.dsn#">
				select sum(GEADutilizado) as GEADutilizado
					from GEanticipo a
					inner join GEanticipoDet c
					on a.GEAid=c.GEAid
					where
					<cfif form.tipo eq 'GASTOS'>
					a.GEAid =#rsConsulaAnt.GEAid#
					<cfelse>
					a.GEAid =#id#
					</cfif>
			</cfquery>
		</cfif>
		<cfquery name="rsConf" datasource="#session.dsn#">
			select count(1) as cantidad from	GEliquidacionGasto
				where Confirmado = 'S'
				and GELid = #id#
		</cfquery>
		<cfquery name="rsSinConf" datasource="#session.dsn#">
			select count(1) as cantidad from	GEliquidacionGasto
				where Confirmado = 'N'
				and GELid = #id#
		</cfquery>
		<cfif rsConf.cantidad eq 0 and rsSinConf.cantidad gt 0>
			<cf_errorCode	code = "50749" msg = "Debe de confirmar gastos">
		</cfif>

		<cfquery name="rsVerificaConfirmado" datasource="#session.dsn#">
			select count(1) as CantidadN
				from  GEliquidacionGasto 
			where 
			<cfif isdefined ('form.GELid') and form.GELid neq ''> 
				GELid = #GELid#
			<cfelse>
				GELid = #id#
			</cfif>
			and Confirmado='N'
		</cfquery>
		
		<cfif rsVerificaConfirmado.CantidadN GT 0>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La Transacción #rsLiquidacion.GELnumero#')#&errDet=#URLEncodedFormat('Contiene documentos que no han sido confirmados')#" >
		<cfelseif rsVerificaConfirmado.CantidadN EQ 0>
			<cfif rsLiquidacion.GELtotalGastos eq 0 and rsLiquidacion.GELtotalDevoluciones eq 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede aplicar un vale con monto igual o menor a 0')#" >
			</cfif>
		</cfif>
	
		<cfif rsLiquidacion.CCHtipo_caja EQ 2>
			<cftransaction>
				<!---Se ejecuta la Aplicacion/Contabilizacion del Pago Adicional--->
				<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAplicarSPsinOP">
					<cfinvokeargument name="TESSPid"  			value="#rsLiquidacion.TESSPid_adicional#">
					<cfinvokeargument name="GEpagoAdicional"	value="YES">
					<cfinvokeargument name="Referencia"			value="GE.LIQ,Pago Adicional">
					<cfinvokeargument name="Documento"			value="#rsLiquidacion.GELnumero#">
					<cfinvokeargument name="Oorigen"			value="TEGE">
				</cfinvoke>
					
				<!---Actualiza el estado de la SP a pagado por Caja Especial--->
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado = 312
					 where TESSPid = #rsLiquidacion.TESSPid_adicional#
				</cfquery>
				
				<!---Actualiza el estado de la tabla Proceso--->
				<cfquery name="rsCCHTid" datasource="#session.dsn#">
					select CCHTid from CCHTransaccionesProceso where CCHTtipo='GASTO' and CCHTrelacionada=#form.id#
				</cfquery>
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
					<cfinvokeargument name="CCHTid" 			value="#rsCCHTid.CCHTid#"> 
					<cfinvokeargument name="CCHtipo" 			value="#LvarTipo#"> 
					<cfinvokeargument name="CCHTestado"			value="CONFIRMADO">
				 </cfinvoke>	
		
				<!---Actualiza el estado de la tabla custodio--->
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
					<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
					<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO">
				</cfinvoke>
			
				<!--- Creación de la Entrega Efectivo --->				
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
					 <cfinvokeargument name="CCHVestado" 		 value="ENTREGADO">
					 <cfinvokeargument name="GEAid" 	 		 value="">
					 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
					 <cfinvokeargument name="CCHVmontonOrig"     value="#rsLiquidacion.GELreembolso#"> 
					 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsLiquidacion.GELreembolso#">
					 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
				</cfinvoke>
		
				<!--- Crea el Comprobante de Entrega/Salida de Caja Especial de Efectivo --->
				<cfset LvarCCHEMnumero = 
							sbAlta_Movimiento_CajaEspecial (
								rsLiquidacion.CCHid, 'S',
								createodbcdate(now()), 
								rsLiquidacion.Mcodigo, 
								rsLiquidacion.GELreembolso, 
								rsLiquidacion.GELtipoCambio,
								"Pago Adicional GE.Liquidacion #rsLiquidacion.GELnumero#",
								'LIQ', rsLiquidacion.GELid,
								rsTranCustodio.CCHTCid
				)>	
			</cftransaction>

			<cf_navegacion name="GELid">
			<cf_vale_imprimir tipo="Liq" id="#rsLiquidacion.GELid#" location="#redirecciona#">
		<cfelseif rsLiquidacion.CCHtipo_caja EQ 1>
			<cfif rsLiquidacion.GELtotalAnticipos eq rsLiquidacion.GELtotalGastos>
				<cftransaction>
					<!---Actualiza el estado de la tabla custodio--->
					<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
						<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
						<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
					</cfinvoke>
	
					<!---Creación del Vale--->				
					<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
						 <cfinvokeargument name="CCHVestado" 		 value="APLICADO">
						 <cfinvokeargument name="GELid" 	 		 value="#id#">
						 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
						 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
						 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
						 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
					</cfinvoke>

					<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
								method="GEliquidacion_Estado">
						 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
						 <cfinvokeargument name="Es_CCH" 	 		 value="yes">
					</cfinvoke>
				</cftransaction>
				<cf_navegacion name="GELid">
				<cf_vale_imprimir tipo="Liq" id="#rsLiquidacion.GELid#" location="#redirecciona#">
			</cfif>
			<!---Inserción del Vale (tablas)--->
			<cfset netoS = #rsLiquidacion.GELtotalAnticipos# - (#rsLiquidacion.GELtotalGastos# + #rsLiquidacion.GELtotalDevoluciones#)>
			<cfif #netoS# eq 0>
				<cfset saldo = rsAnticipo.GEAtotalOri - rsLiquidacion.GELtotalAnticipos>
				<cfif saldo gt 0>
					<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
						<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsLiquidacion.CCHcodigo# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
					<cfelse>
						<cftransaction>
							<!---Actualiza el estado de la tabla custodio--->
							<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
								<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
								<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
							</cfinvoke>
							
							<cfif isdefined('id') and len(trim(#id#)) gt 0>
								<cfset CCHTid = #id#>
							<cfelse>
								<cfset CCHTid = #GEAid#>
							</cfif>
								
							<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ConfirmaCust">
								 <cfinvokeargument name="CCHTid" 		 value="#CCHTid#">
								 <cfinvokeargument name="CCHTCid" 	 	 value="#rsTranCustodio.CCHTCid#">
								 <cfinvokeargument name="CCHtipo"        value="#LvarTipo#"> 
							</cfinvoke>
							
							<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
								 <cfinvokeargument name="CCHVestado" 		 value="TERMINADO">
								 <cfinvokeargument name="GELid" 	 		 value="#id#"> 
								 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
								 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
								 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsLiquidacion.GELtotalAnticipos#">
								 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
							</cfinvoke>

							<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
										method="GEliquidacion_Estado">
								 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
								 <cfinvokeargument name="Es_CCH" 	 		 value="yes">
							</cfinvoke>
						</cftransaction>
						<cf_navegacion name="GELid">
						<cf_vale_imprimir tipo="Liq" id="#rsLiquidacion.GELid#" location="#redirecciona#">
					</cfif>
				<!---saldo = 0 y ademas es igual al monto de los gastos (tablas)--->	
				<cfelseif saldo eq 0 and #rsLiquidacion.GELtotalAnticipos# eq #rsLiquidacion.GELtotalGastos#>
						<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
							<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsLiquidacion.CCHcodigo# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
						<cfelse>
							<cftransaction>
								<!---Actualiza el estado de la tabla custodio--->
								<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
									<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
									<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
								</cfinvoke>
					
								<!---Creación del Vale--->				
								<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
									 <cfinvokeargument name="CCHVestado" 		 value="TERMINADO">
									 <cfinvokeargument name="GELid" 	 		 value="#id#">
									 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
									 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
									<cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
									 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
								</cfinvoke>
							
								<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
											method="GEliquidacion_Estado">
									 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
									 <cfinvokeargument name="Es_CCH" 	 		 value="yes">
								</cfinvoke>
							</cftransaction>
							<cf_navegacion name="GELid">
							<cf_vale_imprimir tipo="Liq" id="#rsLiquidacion.GELid#" location="#redirecciona#">
							
						</cfif>
				<!---Devolución (Anticipos>Gastos  con devolución de efectivo--->	
				<cfelseif saldo eq 0 and #rsLiquidacion.GELtotalAnticipos# gt #rsLiquidacion.GELtotalGastos# and isdefined ('rsLiquidacion.GELtotalDevoluciones')and #rsLiquidacion.GELtotalDevoluciones# gt 0>
					<cftransaction>
						<cfif #rsLiquidacion.GELtotalAnticipos# eq #rsLiquidacion.GELtotalGastos# + #rsLiquidacion.GELtotalDevoluciones#>
							<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
								 <cfinvokeargument name="CCHVestado" 		 value="APLICADO"/>
								 <cfinvokeargument name="GELid" 	 		 value="#id#"/> 
								 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
								 <cfinvokeargument name="CCHVmontonOrig"     value="#rsLiquidacion.GELtotalAnticipos#"/> 
								<cfinvokeargument name="CCHVmontoAplicado"  value="#rsLiquidacion.GELtotalGastos#"/>
								<cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
							</cfinvoke>
						</cfif>
		
						<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
							<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
							<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
						</cfinvoke>
	
						<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
									method="GEliquidacion_Estado">
							 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
							 <cfinvokeargument name="Es_CCH" 	 		 value="yes">
						</cfinvoke>
					</cftransaction>
				</cfif>
			<!---Reembolso (Anticipo < Gastos) --->
			<cfelseif #netoS# lt 0>
				<cfif isdefined('rsLiquidacion.GELtotalAnticipos') and isdefined('rsLiquidacion.GELtotalGastos') and #rsLiquidacion.GELtotalAnticipos# eq #rsLiquidacion.GELtotalGastos# and isdefined('rsLiquidacion.GELtotalDevoluciones') and len(trim(#rsLiquidacion.GELtotalDevoluciones#)) gt 0>
					<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede procesar la liquidación porque el monto de los gastos es igual al anticipo.') #&errDet=#URLEncodedFormat('')#" >
				<cfelse>
					<cftransaction>
						<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
							<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsLiquidacion.CCHcodigo# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
						<cfelse>
						<!---Actualiza el estado de la tabla custodio--->
								<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
									<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
									<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
								</cfinvoke>
						</cfif>
						<cfif isdefined('id') and len(trim(#id#)) gt 0>
							<cfset CCHTid = #id#>
						</cfif>
						<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ConfirmaCust">
							 <cfinvokeargument name="CCHTid" 		 value="#CCHTid#">
							 <cfinvokeargument name="CCHTCid" 	 	 value="#rsTranCustodio.CCHTCid#">
							 <cfinvokeargument name="CCHtipo"        value="#LvarTipo#"> 
						</cfinvoke>
						<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
									method="GEliquidacion_Estado">
							 <cfinvokeargument name="GELid" 	 		 value="#rsLiquidacion.GELid#">
							 <cfinvokeargument name="Es_CCH" 	 		 value="yes">
						</cfinvoke>
					</cftransaction>
				</cfif>
			<cfelseif #netoS# gt 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede procesar la liquidación porque el monto de los Anticipos es mayor al registrado en gastos y devoluciones.') #&errDet=#URLEncodedFormat('')#" >
			</cfif>
		<cfelse>
			<cfthrow message="Tipo de Caja '#rsLiquidacion.CCHtipo_caja#' no puede realizar Pago Adicional de Liquidacion">
		</cfif>
<!--------------------------------------------------------------------------------------------------------------------------->	
	<cfelse>
		<cfset LvarTipo = 'ANTICIPO'>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select 	coalesce(GEAtotalOri,0) as GEAtotalOri,c.GEAid, a.GEAnumero, GEADmonto, GEADutilizado, GEAmanual,
					a.CCHid, cch.CCHtipo as CCHtipo_caja, a.CPNAPnum, a.Mcodigo, a.GECid as GECid_comision
			  from GEanticipo a
				inner join GEanticipoDet c
					on c.GEAid=a.GEAid
				inner join CCHica cch
					on cch.CCHid=a.CCHid
			 where a.GEAid =#id#
		</cfquery>

		<cftransaction>
			<!---Actualiza el estado de la tabla custodio--->
			<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
				<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
				<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO">
			</cfinvoke>
		
			<!---Actualiza el estado de la tabla Proceso--->
			<cfquery name="rsCCHTid" datasource="#session.dsn#">
				select CCHTid from CCHTransaccionesProceso where CCHTtipo='#form.tipo#' and CCHTrelacionada=#form.id#
			</cfquery>
			<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
				<cfinvokeargument name="CCHTid" 			value="#rsCCHTid.CCHTid#"> 
				<cfinvokeargument name="CCHtipo" 			value="#LvarTipo#"> 
				<cfinvokeargument name="CCHTestado"			value="CONFIRMADO">
			 </cfinvoke>	
			 
			<cfquery name="actualizaAnt" datasource="#session.dsn#">
				update GEanticipo 
				   set GEAestado = 4  
				 where GEAid = #rsAnticipo.GEAid#
			</cfquery>

			<!--- Caja Chica --->
			<cfif rsAnticipo.CCHtipo_caja EQ 1>
				<!---Creación del Vale--->				
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
					 <cfinvokeargument name="CCHVestado" 		 value="POR LIQUIDAR">
					 <cfinvokeargument name="GEAid" 	 		 value="#rsAnticipo.GEAid#">
					 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
					 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
					 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
				</cfinvoke>
			<cfelseif  rsAnticipo.CCHtipo_caja EQ 2>
			<!--- Caja Especial de Efectivo--->
				<!--- Generación de la Solicitud de Pago --->				
				<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 
							method="GEanticipo_generaSP" 
							returnVariable="LvarTESSPid">
					<cfinvokeargument name="GEAid"  			value="#rsAnticipo.GEAid#">
					<cfinvokeargument name="PagoEfectivo"  		value="#rsTranCustodio.CCHTCnumero#">
				</cfinvoke>

				<!--- Esta Anticipo no se aprueba porque ya se generó Presupuesto en la aprobacion, 
					se usa el NAP de la Aprobacion del Anticipo --->
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set NAP = #rsAnticipo.CPNAPnum#
					     , TESOPfechaPago = <cf_dbfunction name="today">
					 where TESSPid = #LvarTESSPid#
				</cfquery>
				<cfif isdefined("rsAnticipo.GECid_comision") and rsAnticipo.GECid_comision NEQ "">
                    <cfquery name="rsComision" datasource="#session.dsn#">
                        select GECnumero
                          from GEcomision
                         where GECid = #rsAnticipo.GECid_comision#
                    </cfquery>
                </cfif>
                <cfif isdefined("rsComision.GECnumero") and rsComision.GECnumero gt 0>
                	<cfset rsAnticipo.GEAnumero = rsAnticipo.GEAnumero&"(#rsComision.GECnumero#)">
                </cfif>
				<!---Se ejecuta la Aplicacion/Contabilizacion del Pago--->
				<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAplicarSPsinOP">
					<cfinvokeargument name="TESSPid"  			value="#LvarTESSPid#">
					<cfinvokeargument name="Referencia"			value="GE.ANT,Pago Anticipo">
					<cfinvokeargument name="Documento"			value="#rsAnticipo.GEAnumero#">
					<cfinvokeargument name="Oorigen"			value="TEGE">
				</cfinvoke>
					
				<!---Actualiza el estado de la SP a pagado por Caja Especial--->
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado = 312
					 where TESSPid = #LvarTESSPid#
				</cfquery>

				<cfset LvarCCHEMnumero = 
							sbAlta_Movimiento_CajaEspecial (
								rsAnticipo.CCHid, 'S',
								createodbcdate(now()), 
								rsAnticipo.Mcodigo, 
								rsAnticipo.GEAtotalOri, 
								rsAnticipo.GEAmanual,
								"Pago GE.Anticipo #rsAnticipo.GEAnumero#",
								'ANT', rsAnticipo.GEAid,
								rsTranCustodio.CCHTCid
				)>	

				<!--- Creación de la Entrega Efectivo --->				
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
					 <cfinvokeargument name="CCHVestado" 		 value="ENTREGADO">
					 <cfinvokeargument name="GEAid" 	 		 value="#rsAnticipo.GEAid#">
					 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
					 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
					 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
				</cfinvoke>
			<cfelse>
				<cfthrow message="Tipo de Caja '#rsAnticipo.CCHtipo_caja#' no puede entregar Anticipos">
			</cfif>
		</cftransaction>
				
		<cf_navegacion name="id">
		<cf_vale_imprimir tipo="Ant" id="#rsAnticipo.GEAid#" location="#redirecciona#">
	</cfif>
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>

<!--- Actualización del estado de la Liquidacion--->
<cfif isdefined ('form.btnRechazar')>
    <cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEliquidacion_Rechazo">
        <cfinvokeargument name="GELid"  	  value="#form.id#">
        <cfinvokeargument name="Tipo"	      value="#form.tipo#">
        <cfinvokeargument name="CCHTCRechazo" value="#form.CCHTCRechazo#">
    </cfinvoke>
    
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>

<!--- Actualización del estado del gasto a confirmado ---->
<cfif isDefined("form.btnConfirmar")>
	<cfquery datasource="#session.DSN#">
		update GEliquidacionGasto 
		set Confirmado = 'N'
		where GELid = #id#
	</cfquery>
		
	<cfquery name="rsVerificaG"datasource="#session.DSN#">
		select count(1) as cantidad
		from GEliquidacionGasto 
		where	GELid = #id#
	</cfquery>
	
	<cfif rsVerificaG.cantidad gt 0>
		<cfif isdefined ('form.chk')>	
			<cfloop list="#form.chk#" delimiters="," index="bb">
				<cfquery datasource="#session.DSN#">
					update GEliquidacionGasto 
					set Confirmado = 'S'
					where GELid = #id#
					and GELGid=#listgetat(bb, 1, '|')#
				</cfquery>
			</cfloop>
		</cfif>	
	<cfelse>
		<cfthrow type="toUser" message="No hay Facturas">
	</cfif>
</cfif>

<cfif isDefined("form.btnRecepcion")>
	<cfparam name="form.TipoCambio" default="1">
	<!--- ABG Si el objeto form.TESFechaRecep existe, la variable es igual a la fecha digitada, si no es igual a now()--->
	<cfif isdefined("form.TESFechaRecep") and trim(form.TESFechaRecep) GT 0>
		<cfset LvarHoy	= LSDateFormat(form.TESFechaRecep,'YYYY/MM/DD')>
    <cfelse>
    	<cfset LvarHoy	= Now()>
    </cfif>
	
	<cfset LvarCCHid 	= listGetAt(cboCajaEfectivo,1,"|")>
	<cfset LvarMonto	= replace(form.monto,",","","ALL")>
	<cfset LvarTC		= replace(form.tipoCambio,",","","ALL")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHid, CCHcodigo, CCHtipo, Mcodigo, CCHdescripcion, CFcuenta, CFcuentaRecepcion,
				Ocodigo,cf.CFid
		  from CCHica ch
		  	inner join CFuncional cf
				on cf.CFid = ch.CFid
		 where ch.CCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCCHid#">
	</cfquery>
	<cfif rsSQL.CCHid EQ "">
		<cfthrow type="toUser" message="La caja id=#LvarCCHid# no esta definida">
	<cfelseif rsSQL.CCHtipo NEQ 2>
			<cfthrow type="toUser" message="La Caja '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#' no está definida para RECEPCION de Efectivo">
	<cfelseif rsSQL.CFcuenta EQ "">
		<cfthrow type="toUser" message="No se ha definido la cuenta de la Caja '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'">
	<cfelseif rsSQL.CFcuentaRecepcion EQ "">
		<cfthrow type="toUser" message="No se ha definido la cuenta transitoria para Recepcion de Efectivo de la Caja '#rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'">
	</cfif>
		
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />
	<cftransaction>
		<cfset LvarCCHEMnumero = 
					sbAlta_Movimiento_CajaEspecial (
						LvarCCHid, 'E', 
						LvarHoy, 
						form.Mcodigo, LvarMonto, LvarTC,
						"Recepción Efectivo: #form.Descripcion#", 
						"","","", form.Depositante
		)>	
        <cfif NOT isdefined("form.GECnumero") OR form.GECnumero EQ "">
        	<cfset varnumdoc= dateformat(now(),"yyyymmdd") & timeformat(now(),"hhmmss")> 
        <cfelse>
        	<cfset varnumdoc=form.GECnumero> 
        </cfif>
        <cfset LvarIntDoc = LvarCCHEMnumero & "(#varnumdoc#)">
        
        <!---
			Modificado: 30/06/2012
			Alejandro Bolaños APH-Mexico ABG
			
			CONTROL DE EVENTOS
		--->	
		<!--- Se valida el control de eventos para la transaccion de Liquidacion Gasto Empleado --->
		<cfinvoke component="sif.Componentes.CG_ControlEvento" 
			method="ValidaEvento" 
			Origen="TEGE"
			Transaccion="GERE"
			Conexion="#session.dsn#"
			Ecodigo="#session.Ecodigo#"
			returnvariable="varValidaEvento"
		/> 	
		<cfset varNumeroEvento = "">
		<cfif varValidaEvento GT 0>
        	<cfif isdefined("form.GECnumero") and len(form.GECnumero)>
	        	<cfset varGECnumero = form.GECnumero>
            <cfelse>
            	<cfset varGECnumero = 0>
            </cfif>
			<cfinvoke component="sif.Componentes.CG_ControlEvento" 
				method="CG_GeneraEvento" 
				Origen="TEGE"
				Transaccion="GERE"
				Documento="#LvarIntDoc#"
				Conexion="#session.dsn#"
				Ecodigo="#session.Ecodigo#"
				returnvariable="arNumeroEvento"
			/> 
			
			<cfif arNumeroEvento[3] EQ "">
				<cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
			</cfif>
			<cfset varNumeroEvento = arNumeroEvento[3]>
			<cfset varIDEvento = arNumeroEvento[4]>
			
			<cfinvoke component="sif.Componentes.CG_ControlEvento" 
				method="CG_RelacionaEvento" 
				IDNEvento="#varIDEvento#"
				Origen="GECM"
				Transaccion="COM"
				Documento="#varGECnumero#"
				Conexion="#session.dsn#"
				Ecodigo="#session.Ecodigo#"
				returnvariable="arRelacionEvento"
			/> 
			 <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
				<cfset varNumeroEvento = arRelacionEvento[4]>
			</cfif>
		</cfif>
    
		<!--- Debito a la cuenta de la Caja --->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
			( 
				INTORI, INTREL, INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta,
				Mcodigo, INTMOE, INTCAM, INTMON,
                NumeroEvento,CFid
			)
			values (
				'TEGE', 1, '#LvarIntDoc#', 'CEE.RECEPCION',
				'#DateFormat(LvarHoy,"YYYYMMDD")#',#year(LvarHoy)#, #month(LvarHoy)#, 
				#rsSQL.Ocodigo#, 
				'D', 
				<cf_dbfunction name="spart" args="'CEE.ENTRADA DE EFECTIVO CAJA #rsSQL.CCHcodigo# - #rsSQL.CCHdescripcion#'|1|80" delimiters="|">, 
				#rsSQL.CFcuenta#, 0,
				#rsSQL.Mcodigo#, #LvarMonto#, #LvarTC#, round(#LvarMonto# * #LvarTC#,2),
                '#varNumeroEvento#',#rsSQL.CFid#
			)			   
		</cfquery>
		<!--- Credito a la cuenta Transitoria de Recepcion de Efectivo --->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
			( 
				INTORI, INTREL, INTDOC, INTREF, 
				INTFEC, Periodo, Mes, Ocodigo, 
				INTTIP, INTDES, 
				CFcuenta, Ccuenta,
				Mcodigo, INTMOE, INTCAM, INTMON,
                NumeroEvento,CFid
			)
			values (
				'TEGE', 1, '#LvarIntDoc#', 'CEE.RECEPCION',
				'#DateFormat(LvarHoy,"YYYYMMDD")#',#year(LvarHoy)#, #month(LvarHoy)#, 
				#rsSQL.Ocodigo#, 
				'C',
				<cf_dbfunction name="spart" args="'CEE.RECEPCION EFECTIVO #LvarCCHEMnumero#: #form.Descripcion#'|1|80" delimiters="|">, 
				#rsSQL.CFcuentaRecepcion#, 0,
				#rsSQL.Mcodigo#, #LvarMonto#, #LvarTC#, round(#LvarMonto# * #LvarTC#,2),
                '#varNumeroEvento#',#rsSQL.CFid#
			)			   
		</cfquery>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo" value="#year(LvarHoy)#"/>
			<cfinvokeargument name="Emes" value="#month(LvarHoy)#"/>
			<cfinvokeargument name="Efecha" value="#LvarHoy#"/>
			<cfinvokeargument name="Oorigen" value="TEGE"/>
			<cfinvokeargument name="Ocodigo" value="#rsSQL.Ocodigo#"/>
			<cfinvokeargument name="Edocbase" value="#LvarCCHEMnumero#"/>
			<cfinvokeargument name="Ereferencia" value="CEE.RECEPCION"/>						
			<cfinvokeargument name="Edescripcion" value="CEE.RECEPCION DE EFECTIVO #LvarCCHEMnumero#: #form.Descripcion#"/>
		</cfinvoke>
	</cftransaction>
	<cf_navegacion name="id">
	<cfset form.chkImprimir = 1>
	<cf_vale_imprimir tipo="Rcp" id="#LvarCCHEMnumero#" location="#redirecciona#" CCHid="#LvarCCHid#">
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>
<cflocation url="TransaccionCustodiaP.cfm?GELid=#id#&tab=2&Det&tipo=GASTOS">

<cffunction name="sbAlta_Movimiento_CajaEspecial" output="false" returntype="numeric">
	<cfargument name="CCHid">
	<cfargument name="tipo">
	<cfargument name="fecha">
	<cfargument name="Mcodigo">
	<cfargument name="monto">
	<cfargument name="tipoCambio">
	<cfargument name="Descripcion">

	<cfargument name="ANT_LIQ_CCH"		default="">
	<cfargument name="id"				default="">

	<cfargument name="CCHTCid_entrega"	default="">
	<cfargument name="Depositante"		default="">
	
	<cfinvoke	component="sif.tesoreria.Componentes.TEScajaChica" 
				method="sbAlta_Movimiento_CajaEspecial"
				returnvariable = "LvarCCHEMnumero"
	>
		 <cfinvokeargument name="CCHid" 	 		value="#Arguments.CCHid#">
		 <cfinvokeargument name="tipo" 	 			value="#Arguments.tipo#">
		 <cfinvokeargument name="fecha" 	 		value="#Arguments.fecha#">
		 <cfinvokeargument name="Mcodigo" 	 		value="#Arguments.Mcodigo#">
		 <cfinvokeargument name="monto" 	 		value="#Arguments.monto#">
		 <cfinvokeargument name="tipoCambio" 		value="#Arguments.tipoCambio#">
		 <cfinvokeargument name="Descripcion" 		value="#Arguments.Descripcion#">
		 <cfinvokeargument name="ANT_LIQ_CCH"  		value="#Arguments.ANT_LIQ_CCH#">
		 <cfinvokeargument name="id" 	 			value="#Arguments.id#">
		 <cfinvokeargument name="CCHTCid_entrega"	value="#Arguments.CCHTCid_entrega#">
		 <cfinvokeargument name="Depositante" 		value="#Arguments.Depositante#">
	</cfinvoke>
	
	<cfreturn LvarCCHEMnumero>
</cffunction>