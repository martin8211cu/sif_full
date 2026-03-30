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

<!---Aplica liquidacion--->
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

		<cfquery name="rsResulLiqui" datasource="#session.dsn#">
			select GELdescripcion, TESSPid,GELtotalGastos, coalesce (GELtotalAnticipos,0) as GELtotalAnticipos,coalesce (GELtotalDevoluciones,0) as GELtotalDevoluciones,GELnumero,CCHid       	
			from GEliquidacion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and GELid=#id# 
		</cfquery>
		
		<!---Asociacion de anticipos a liquidacion--->
		<cfquery name="rsConsulaAnt" datasource="#session.dsn#">
			select GEAid,GEADid,GELAtotal
			from  GEliquidacionAnts
			where 
			<cfif form.tipo eq 'GASTOS'>
				GELid=#id# 
			<cfelse>
				GEAid=#id# 
			</cfif>
		</cfquery>
			
			
		<cfif isdefined ('rsResulLiqui.GELtotalAnticipos') and #rsResulLiqui.GELtotalAnticipos# neq 0>
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
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La Transacción #rsResulLiqui.GELnumero#')#&errDet=#URLEncodedFormat('Contiene documentos que no han sido confirmados')#" >
		<cfelseif rsVerificaConfirmado.CantidadN EQ 0>
			<cfif rsResulLiqui.GELtotalGastos eq 0 and rsResulLiqui.GELtotalDevoluciones eq 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede aplicar un vale con monto igual o menor a 0')#" >
			</cfif>
		</cfif>

		<cfif rsResulLiqui.GELtotalAnticipos eq rsResulLiqui.GELtotalGastos>
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
				<cfset saldo = rsAnticipo.GEAtotalOri - rsAnticipoUtili.GEADutilizado - rsResulLiqui.GELtotalAnticipos>
				<cfif saldo eq 0>
					<cfquery name="actualizaAnt" datasource="#session.dsn#">
						update GEanticipo 
						set GEAestado =6  
						where GEAid = #rsConsulaAnt.GEAid#
					</cfquery>
				</cfif>	
						
				<cfquery name="actualizaLiq" datasource="#session.dsn#">
					update GEliquidacion 
					set GELestado =5  
					where GELid = #id#
				</cfquery>
				<cfquery name="actualizaAnt" datasource="#session.dsn#">
					update GEanticipoDet 
					set GEADutilizado =   GEADutilizado +  (select coalesce (GELAtotal,0)
															from GEliquidacionAnts 
															where 
															GELid = #id#
															and GEliquidacionAnts.GEAid = GEanticipoDet.GEAid
															 and GEliquidacionAnts.GEADid = GEanticipoDet.GEADid
															 )									 
					 where 	 GEanticipoDet.GEAid = #rsConsulaAnt.GEAid#
				</cfquery>
			</cftransaction>
			<cf_navegacion name="GELid">
			<cf_vale_imprimir location="#redirecciona#">
		</cfif>
		<!---Inserción del Vale (tablas)--->
		<cfset netoS = #rsResulLiqui.GELtotalAnticipos# - (#rsResulLiqui.GELtotalGastos# + #rsResulLiqui.GELtotalDevoluciones#)>
		<cfif #netoS# eq 0>
			<cfset saldo = rsAnticipo.GEAtotalOri - rsResulLiqui.GELtotalAnticipos>
			<cfif saldo gt 0>
				<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
					<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsResulLiqui.CCHid# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
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
					
					<!---<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
						 <cfinvokeargument name="CCHVestado" 		 value="POR LIQUIDAR">
						 <cfinvokeargument name="GELid" 	 		 value="#id#">
						 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
						 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
						<cfinvokeargument name="CCHVmontoAplicado"   value="#saldo#">
						<cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
					</cfinvoke>--->
					
					<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
						 <cfinvokeargument name="CCHVestado" 		 value="TERMINADO">
						 <cfinvokeargument name="GELid" 	 		 value="#id#"> 
						 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
						 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
						 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsResulLiqui.GELtotalAnticipos#">
						 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
					</cfinvoke>
				
					
					<cfquery name="actualizaLiq" datasource="#session.dsn#">
						update GEliquidacion 
						set GELestado =5  
						where GELid = #id#
					</cfquery>
					<cfquery name="actualizaAnt" datasource="#session.dsn#">
						 update GEanticipoDet 
							set GEADutilizado =   GEADutilizado +  (select coalesce (GELAtotal,0)
															from GEliquidacionAnts 
															where 
															GELid = #id#
															and GEliquidacionAnts.GEAid = GEanticipoDet.GEAid
															 and GEliquidacionAnts.GEADid = GEanticipoDet.GEADid
															 )									 
						where GEanticipoDet.GEAid = #rsConsulaAnt.GEAid#
					</cfquery>
					<cfquery name="DetAnt" datasource="#session.dsn#">
						select GEAtotalOri, sum(GEADutilizado) as GEADutilizado
						from GEanticipo a, GEanticipoDet d
						 where 	a.GEAid = #rsConsulaAnt.GEAid#
						 and a.GEAid = d.GEAid
						group by  	a.GEAid, 	a.GEAtotalOri
					</cfquery>
					
					<cfif #DetAnt.GEAtotalOri# eq #DetAnt.GEADutilizado#>
						<cfquery name="actualizaAnt" datasource="#session.dsn#">
							update GEanticipo 
							set GEAestado =6  
							where GEAid = #rsConsulaAnt.GEAid#
						</cfquery>
					</cfif>
					
					</cftransaction>
					<cf_navegacion name="GELid">
					<cf_vale_imprimir location="#redirecciona#">
				</cfif>
			<!---saldo = 0 y ademas es igual al monto de los gastos (tablas)--->	
			<cfelseif saldo eq 0 and #rsResulLiqui.GELtotalAnticipos# eq #rsResulLiqui.GELtotalGastos#>
					<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
						<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsResulLiqui.CCHid# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
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
						
						
						<cfquery name="actualizaAnt" datasource="#session.dsn#">
							update GEanticipo 
							set GEAestado =6  
							where GEAid = #rsConsulaAnt.GEAid#
						</cfquery>
						
						<cfquery name="actualizaLiq" datasource="#session.dsn#">
							update GEliquidacion 
							set GELestado =5  
							where GELid = #id#
						</cfquery>
						<cfquery name="actualizaAnt" datasource="#session.dsn#">
							update GEanticipoDet 
							set GEADutilizado =   GEADutilizado +  (select coalesce (GELAtotal,0)
																	from GEliquidacionAnts 
																	where 
																	GELid = #id#
																	and GEliquidacionAnts.GEAid = GEanticipoDet.GEAid
																	 and GEliquidacionAnts.GEADid = GEanticipoDet.GEADid
																	 )									 
							 where 	 GEanticipoDet.GEAid = #rsConsulaAnt.GEAid#
						</cfquery>
						</cftransaction>
						<cf_navegacion name="GELid">
						<cf_vale_imprimir location="#redirecciona#">
						
					</cfif>
			<!---Devolución (Anticipos>Gastos  con devolución de efectivo--->	
			<cfelseif saldo eq 0 and #rsResulLiqui.GELtotalAnticipos# gt #rsResulLiqui.GELtotalGastos# and isdefined ('rsResulLiqui.GELtotalDevoluciones')and #rsResulLiqui.GELtotalDevoluciones# gt 0>
				<cfif #rsResulLiqui.GELtotalAnticipos# eq #rsResulLiqui.GELtotalGastos# + #rsResulLiqui.GELtotalDevoluciones#>
					<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
						 <cfinvokeargument name="CCHVestado" 		 value="APLICADO"/>
						 <cfinvokeargument name="GELid" 	 		 value="#id#"/> 
						 <cfinvokeargument name="GEAid" 	 		 value="#rsConsulaAnt.GEAid#">
						 <cfinvokeargument name="CCHVmontonOrig"     value="#rsResulLiqui.GELtotalAnticipos#"/> 
						<cfinvokeargument name="CCHVmontoAplicado"  value="#rsResulLiqui.GELtotalGastos#"/>
						<cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
					</cfinvoke>
				</cfif>

				<cfquery name="actualizaAnt" datasource="#session.dsn#">
					update GEanticipo 
					set GEAestado =6  
					where GEAid = #rsConsulaAnt.GEAid#
				</cfquery>
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
					<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
					<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
				</cfinvoke>
				<cfquery name="actualizaLiq" datasource="#session.dsn#">
					update GEliquidacion 
					set GELestado =5  
					where GELid = #id#
				</cfquery>
				<cfquery name="SELECT" datasource="#session.dsn#">
					select b.GEAestado,a.GELestado 
					from GEliquidacion a
						inner join  GEanticipo b
							on b.GEAid=#rsConsulaAnt.GEAid#
					where GELid=#id#
				</cfquery>
				<cfquery name="actualizaAnt" datasource="#session.dsn#">
					update GEanticipoDet 
						set GEADutilizado =   GEADutilizado +  (select coalesce (GELAtotal,0)
																from GEliquidacionAnts 
																where 
																GELid = #id#
																and GEliquidacionAnts.GEAid = GEanticipoDet.GEAid
																 and GEliquidacionAnts.GEADid = GEanticipoDet.GEADid
																 )									 
						 where 	 GEanticipoDet.GEAid = #rsConsulaAnt.GEAid#
				</cfquery>

			</cfif>
		<!---Reembolso (Anticipo < Gastos) --->
		<cfelseif #netoS# lt 0>
			<cfif isdefined('rsResulLiqui.GELtotalAnticipos') and isdefined('rsResulLiqui.GELtotalGastos') and #rsResulLiqui.GELtotalAnticipos# eq #rsResulLiqui.GELtotalGastos# and isdefined('rsResulLiqui.GELtotalDevoluciones') and len(trim(#rsResulLiqui.GELtotalDevoluciones#)) gt 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede procesar la liquidación porque el monto de los gastos es igual al anticipo.') #&errDet=#URLEncodedFormat('')#" >
			<cfelse>
				<cfif isdefined ('LvarAPImporte') and #LvarAPImporte# eq 'false'>
					<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' La caja  #rsResulLiqui.CCHid# seleccionada') #&errDet=#URLEncodedFormat('NO TIENE EFECTIVO')#" >
				<cfelse>
					<cftransaction>
				<!---Actualiza el estado de la tabla custodio--->
						<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
							<cfinvokeargument name="CCHTCid" 			value="#rsTranCustodio.CCHTCid#"> 
							<cfinvokeargument name="CCHTCestado"		value="CONFIRMADO"/>
						</cfinvoke>
					</cftransaction>
				</cfif>
				<cfif isdefined('id') and len(trim(#id#)) gt 0>
					<cfset CCHTid = #id#>
				</cfif>
				<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="ConfirmaCust">
					 <cfinvokeargument name="CCHTid" 		 value="#CCHTid#">
					 <cfinvokeargument name="CCHTCid" 	 	 value="#rsTranCustodio.CCHTCid#">
					 <cfinvokeargument name="CCHtipo"        value="#LvarTipo#"> 
				</cfinvoke>
				<cfif isdefined ('rsResulLiqui.GELtotalAnticipos') and #rsResulLiqui.GELtotalAnticipos# neq 0>
					<cfset saldo = rsAnticipo.GEAtotalOri - rsAnticipoUtili.GEADutilizado - rsResulLiqui.GELtotalAnticipos>
					<cfif saldo eq 0 >
						<cfquery name="actualizaAnt" datasource="#session.dsn#">
									update GEanticipo 
									set GEAestado =6  
									where GEAid = #rsConsulaAnt.GEAid#
						</cfquery>
					</cfif>
					
					
					<cfquery name="actualizaAnt" datasource="#session.dsn#">
						update GEanticipoDet 
						set GEADutilizado =   GEADutilizado +  (select coalesce (GELAtotal,0)
																from GEliquidacionAnts 
																where 
																GELid = #id#
																and GEliquidacionAnts.GEAid = GEanticipoDet.GEAid
																 and GEliquidacionAnts.GEADid = GEanticipoDet.GEADid
																 )									 
						 where 	 GEanticipoDet.GEAid = #rsConsulaAnt.GEAid#
					</cfquery>
				</cfif>	
					
				<cfquery name="actualizaLiq" datasource="#session.dsn#">
					update GEliquidacion 
					set GELestado =5  
					where GELid = #id#
				</cfquery>
				
			</cfif>
		<cfelseif #netoS# gt 0>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No se puede procesar la liquidación porque el monto de los Anticipos es mayor al registrado en gastos y devoluciones.') #&errDet=#URLEncodedFormat('')#" >
		</cfif>
	<cfelse>
	
	<!---AQUI VAN LAS CONDICIONES DE LOS ANTICIPOS --->	
		
		<cfset LvarTipo = 'ANTICIPO'>
		<cfquery name="rsAnticipo" datasource="#session.dsn#">
			select 	coalesce(GEAtotalOri,0) as GEAtotalOri,c.GEAid,GEADmonto, GEADutilizado,
					a.CCHid, cch.CCHtipo, a.CPNAPnum
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
			<cfif rsAnticipo.CCHtipo EQ 1>
				<!---Creación del Vale--->				
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
					 <cfinvokeargument name="CCHVestado" 		 value="POR LIQUIDAR">
					 <cfinvokeargument name="GEAid" 	 		 value="#rsAnticipo.GEAid#">
					 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
					 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
					 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
				</cfinvoke>
			<cfelseif  rsAnticipo.CCHtipo EQ 2>
			<!--- Caja Especial de Efectivo--->
				<!--- Creación y aplicación de la Solicitud de Pago --->				
				<cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEanticipo_generaSP" returnVariable="LvarTESSPid">
					<cfinvokeargument name="GEAid"  			value="#rsAnticipo.GEAid#">
					<cfinvokeargument name="PagoEfectivo"  		value="#rsTranCustodio.CCHTCnumero#">
				</cfinvoke>

				<cfquery name="actualizaAnt" datasource="#session.dsn#">
					update TESsolicitudPago
					   set NAP = #rsAnticipo.CPNAPnum#
					 where TESSPid = #LvarTESSPid#
				</cfquery>

				<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAplicarSPsinOP">
					<cfinvokeargument name="TESSPid"  			value="#LvarTESSPid#">
				</cfinvoke>
					
				<!--- Creación de la Entrega Efectivo --->				
				<cfinvoke component="sif.tesoreria.Componentes.TESCustodio" method="crearVale">
					 <cfinvokeargument name="CCHVestado" 		 value="ENTREGADO">
					 <cfinvokeargument name="GEAid" 	 		 value="#rsAnticipo.GEAid#">
					 <cfinvokeargument name="CCHVmontonOrig"     value="#rsAnticipo.GEAtotalOri#"> 
					 <cfinvokeargument name="CCHVmontoAplicado"  value="#rsAnticipo.GEADmonto#">
					 <cfinvokeargument name="CCHTid"   			 value="#rsTranCustodio.CCHTid#">			
				</cfinvoke>
			<cfelse>
				<cfthrow message="Tipo de Caja no implementado: #rsAnticipo.CCHtipo#">
			</cfif>
		</cftransaction>
				
		<cf_navegacion name="id">
		<cf_vale_imprimir location="#redirecciona#">
	</cfif>
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>

<!--- Actualización del estado del Anticipo--->
<cfif isdefined ('Rechazar')>
	<cfquery name="rsActualiza" datasource="#session.DSN#">
		update CCHTransaccionesCProceso 
			set 
				CCHTCestado ='CANCELADO',
				CCHTCRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCHTCRechazo#">
		where CCHTCrelacionada =<cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cflocation url="TransaccionCustodiaP.cfm">
</cfif>

<!--- Actualización del estado del gasto a aplicado ---->
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
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(' No hay Facturas')#" >
	</cfif>
</cfif>
<cflocation url="TransaccionCustodiaP.cfm?GELid=#id#&tab=2&Det&tipo=GASTOS">

