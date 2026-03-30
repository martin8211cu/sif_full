<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 05 de julio del 2005
	Motivo:	Se agregó un nuevo botón para listar nuevas solicitudes a agregar en la orden de pago
		se agregaron las consultas necesarias para agregar las solicitudes a la orden
		lineas 655-707
		paso = 3
----------->

<cf_navegacion name="btnCBidPago">
<cf_navegacion name="TESOPid">
<cf_navegacion name="CBidPago">
<cf_navegacion name="TESMPcodigo">

<cf_navegacion name="chkImprimir" default="0">
<cf_navegacion name="chkImprimir" session>

<cfif IsDefined("form.Baja") OR IsDefined("form.Anular")>
	<!--- Caso especial: Borrar una OP que ya fue emitida: Anular las SPs asociadas: sbRechazarSPaprobada ya tiene cftransaction --->
	<cfquery name="rsOP" datasource="#session.dsn#">
		select  *,TESOPmsgRechazo
		  from TESordenPago
		 where TESid 	= #session.Tesoreria.TESid#
		   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		   and TESOPestado in (10,11)
	</cfquery>
	<!--- Se eliminan los timbres asociados --->
	<cfquery datasource = "#session.dsn#">
		delete from CERepoTMP
		where CEfileId in (
			select r.CEfileId
			from CERepoTMP r
			inner join TESsolicitudPago sp
				on r.ID_Documento = sp.TESSPid
				and r.Origen = 'TES'
				and r.Ecodigo = sp.EcodigoOri
			inner join TESordenPago op
				on op.TESOPid = sp.TESOPid
			where op.TESid 	= #session.Tesoreria.TESid#
				and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		)
	</cfquery>
	<cfif trim(rsOP.TESOPmsgRechazo) NEQ "">
		<cfinvoke 	component		= "sif.tesoreria.Componentes.TESaplicacion"
					method			= "sbRechazarSPaprobada"

					DSN				= "#session.dsn#"
					Ecodigo			= "#session.Ecodigo#"
					TESSPid			= "-1"
					TESOPid			= "#form.TESOPid#"
					TESSPmsgRechazo	= "#rsOP.TESOPmsgRechazo#"
		>
		<cflocation url="ordenesPago.cfm?PASO=0">
	</cfif>
</cfif>

<!--- Si existe configurado un Repositorio de CFDIs --->
<cfquery name="getContE" datasource="#Session.DSN#">
	select ERepositorio from Empresa
	where Ereferencia = #Session.Ecodigo#
</cfquery>

<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
	<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
	<cfset request.repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>
</cfif>

<cftransaction>
	<cfif IsDefined("form.btnCBidPago")>
		<cfset form.PASO = 10>
		<cfset LvarCBidPago = listFirst(form.CBidPago)>
		<cfset sbInicializaTiposCambio(form.TESOPid,LvarCBidPago,false)>
	<cfelseif IsDefined("form.Cambio")>
		<cfset form.PASO = 10>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="TESordenPago"
				redirect="ordenesPago.cfm"
				timestamp="#form.ts_rversion#"
				field1="TESOPid"
				type1="numeric"
				value1="#form.TESOPid#"
		>
		<cfif isdefined("form.TESDPid")>
			<cfloop index="LvarID" list="#form.TESDPid#">
				<cfquery name="rsDP" datasource="#session.dsn#">
					select 	dp.Miso4217Ori, op.Miso4217Pago, me.Miso4217 as Miso4217Empresa,
							cpc.CPCid, cpc.TESDPmontoSolicitadoOri as CPCoriginal, cpc.CPClocal
					  from 	TESdetallePago dp
							inner join TESordenPago op
							   on op.TESid 	 = dp.TESid
							  and op.TESOPid = dp.TESOPid
							inner join Empresas e
								inner join Monedas me
								   on me.Ecodigo = e.Ecodigo
								  and me.Mcodigo = e.Mcodigo
							   on e.Ecodigo = op.EcodigoPago
						    left join TESdetallePagoCPC cpc
								inner join CPCesion c on c.CPCid = cpc.CPCid
								inner join Monedas mc on mc.Mcodigo = c.Mcodigo
						       on TESDPidNew		= dp.TESDPid
						      and mc.Miso4217		<> dp.Miso4217Ori
						      and me.Miso4217		in (dp.Miso4217Ori,mc.Miso4217)
						      and op.Miso4217Pago	in (dp.Miso4217Ori,mc.Miso4217)
					 where dp.TESid = #session.Tesoreria.TESid#
					   and dp.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
					   and dp.TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and dp.TESDPestado in (10,11)
				</cfquery>

				<cfif rsDP.CPCid NEQ "">
					<cfset LvarMO = replace(evaluate("form.TESDPmontoAprobadoOri_#LvarID#"),",","","ALL")>
					<cfset LvarTCP = form.TESOPtipoCambioPago>

					<cfif rsDP.Miso4217Ori EQ rsDP.Miso4217Empresa>
						<cfset LvarTC  = 1>
					<cfelse>
						<cfset LvarTC = abs(rsDP.CPClocal / rsDP.CPCoriginal)>
					</cfif>
					<cfif rsDP.Miso4217Ori EQ rsDP.Miso4217Pago>
						<cfset LvarFC  = 1>
					<cfelse>
						<cfset LvarFC = LvarTC / LvarTCP>
					</cfif>
					<cfset LvarMP = LvarMO * LvarFC>
				<cfelse>
					<cfset LvarMO = replace(evaluate("form.TESDPmontoAprobadoOri_#LvarID#"),",","","ALL")>
					<cfset LvarMP = replace(evaluate("form.TESDPmontoPago_#LvarID#"),",","","ALL")>
					<cfif isnumeric(LvarMO) and LvarMO NEQ 0 AND isnumeric(LvarMP) AND LvarMP NEQ 0>
						<cfset LvarTCP = form.TESOPtipoCambioPago>
						<cfif rsDP.Miso4217Ori EQ rsDP.Miso4217Pago>
							<cfset LvarFC  = 1>
						<cfelse>
							<cfset LvarFC  = LvarMP / LvarMO>
						</cfif>
						<cfif rsDP.Miso4217Ori EQ rsDP.Miso4217Empresa>
							<cfset LvarTC  = 1>
						<cfelse>
							<cfset LvarTC  = LvarFC * LvarTCP>
						</cfif>
					<cfelse>
						<cfset LvarFC = replace(evaluate('form.TESDPfactorConversion_#LvarID#'),",","","ALL")>
						<cfset LvarTC = replace(evaluate('form.TESDPtipoCambioOri_#LvarID#'),",","","ALL")>
						<cfset LvarMP = 0>
					</cfif>
				</cfif>

				<cfquery datasource="#session.dsn#">
					update TESdetallePago
						set TESDPfechaPago 			= <cfqueryparam cfsqltype="cf_sql_date"  value="#LSparseDateTime(form.TESOPfechaPago)#">
						  , TESDPfactorConversion	= <cfqueryparam cfsqltype="cf_sql_float" value="#LvarFC#">
						  , TESDPtipoCambioOri		= <cfqueryparam cfsqltype="cf_sql_float" value="#LvarTC#">
						  , TESDPmontoPago			= <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#LvarMP#">
					 where TESid = #session.Tesoreria.TESid#
					   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
					   and TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESDPestado in (10,11)
				</cfquery>
			</cfloop>
			<cfset sbAfectacionesTC(form.TESOPid)>
		</cfif>
		<cfquery name="rsTotTESDP" datasource="#session.dsn#">
			select coalesce(sum(TESDPmontoPago),0) as total
			  from TESdetallePago
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESDPestado in (10,11)
			   and RlineaId is null
		</cfquery>
		<!--- JARR mayo2020 and RlineaId is null evita restar retenciones al modificar ordenpago --->
		<cfquery datasource="#session.dsn#">
			update 	TESordenPago
				set TESOPtotalPago		= <cfqueryparam cfsqltype="cf_sql_money" 		value="#rsTotTESDP.total#">
				  , TESOPtipoCambioPago	= <cfqueryparam cfsqltype="cf_sql_float" 		value="#form.TESOPtipoCambioPago#">
				  , TESOPfechaPago  	= <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LSparseDateTime(form.TESOPfechaPago)#">
				  , TESOPobservaciones	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#replace(form.TESOPobservaciones,Chr(13),' ')#">
				  , TESOPinstruccion	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.TESOPinstruccion#">
				  , TESEcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.TESEcodigo#" null="#form.TESEcodigo EQ ''#">
				  , TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.TESMPcodigo#" null="#form.TESMPcodigo EQ ''#">
				  <cfif isDefined("form.conceptoCIE")>
					, TESOPConceptoCIE	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.conceptoCIE#" null="#form.conceptoCIE EQ ''#">
				  </cfif>
				  <cfif isDefined("form.convenioCIE")>
				  	, TESOPConvenioCIE	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.convenioCIE#" null="#form.convenioCIE EQ ''#">
				   </cfif>
				   <cfif isDefined("form.referenciaCIE")>
				  	, TESOPReferenciaCIE	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.referenciaCIE#" null="#form.referenciaCIE EQ ''#">
				   </cfif>
				  <cfif form.TRH EQ '1'>
				  	<cfset LvarTPidNULL = false>
				  <cfelseif form.TRH EQ '2'>
				  	<cfset LvarTPidNULL = (form.TESTPid EQ '')>
				  <cfelse>
				  	<cfset LvarTPidNULL = true>
				  </cfif>
				  , TESTPid				= <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#form.TESTPid#" null="#LvarTPidNULL#">
				  , TESOPbeneficiarioSuf = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.TESOPbeneficiarioSuf#" null="#form.TESOPbeneficiarioSuf EQ ''#">
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
	<cfelseif IsDefined("form.Baja")>
		<cfset form.PASO = 0>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set TESSPestado 		= 2

				 , TESOPid	 		= null
				 , CBid	 			= null
				 , TESMPcodigo	 	= null
				 , SNid	 			= null
				 , EcodigoSP	 	= null
				 , TESOPfechaPago	= null

			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESSPestado in (10,11)
		</cfquery>
		<cfquery name="infoDetpago" datasource="#session.dsn#">
			select top 1 * from TESdetallePago
			 where TESid 	= #session.Tesoreria.TESid#
				   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
				   and TESDPestado in (10,11)
		</cfquery>
		<cfquery name="infoDetMonto" datasource="#session.dsn#">
			select sum(abs(isnull(TESDPmontoAprobadoOri,0) )) as DevolAprobado from TESdetallePago
			 where TESid 	= #session.Tesoreria.TESid#
				   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
				   and TESDPestado in (10,11)
				   and RlineaId is null
		</cfquery>
		<!--- Solo resta el monto de las lineas de detalle de la Orden de Compra --->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCP 
				set TESDPaprobadoPendiente=TESDPaprobadoPendiente-#infoDetMonto.DevolAprobado#
			where Ddocumento like '#infoDetpago.TESDPdocumentoOri#'        
	            and   IDdocumento= #infoDetpago.TESDPidDocumento#
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set  TESDPestado  			= 2
				  , TESOPid 				= null
				  , TESDPfechaPago 			= null
				  , EcodigoPago				= null
				  , TESDPmontoAprobadoLocal = null
				  , TESDPtipoCambioOri		= null
				  , TESDPfactorConversion	= null
				  , TESDPmontoPago			= null
				  , TESDPmontoPagoLocal 	= null
			 where TESid 	= #session.Tesoreria.TESid#
			   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESDPestado in (10,11)
		</cfquery>
		<!--- <cfquery datasource="#session.dsn#">
			delete FROM TESdetallePago
			where TESid 	= #session.Tesoreria.TESid#
			and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		</cfquery> --->
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set  TESOPestado 			= 13	/* TESOPestado = 13:  Anulado */
				  , TESOPmsgRechazo			= 'ORDEN DE PAGO ELIMINADA'
				  , TESOPfechaCancelacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  , UsucodigoCancelacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			 where TESid 	= #session.Tesoreria.TESid#
			   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
		<!--- Se eliminan los timbres asociados --->
		<cfquery datasource = "#session.dsn#">
			delete from CERepoTMP
			where CEfileId in (
				select r.CEfileId
				from CERepoTMP r
				inner join TESsolicitudPago sp
					on r.ID_Documento = sp.TESSPid
					and r.Origen = 'TES'
					and r.Ecodigo = sp.EcodigoOri
				inner join TESordenPago op
					on op.TESOPid = sp.TESOPid
				where op.TESid 	= #session.Tesoreria.TESid#
					and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			)
		</cfquery>
	<cfelseif IsDefined("form.AAprobar")>
		<cfset form.PASO = 0>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
				set TESOPestado  = 11
				<cfif isDefined("form.referenciaCIE")>
				  	, TESOPReferenciaCIE	= <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.referenciaCIE#" null="#form.referenciaCIE EQ ''#">
				</cfif>
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESOPestado = 10
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set TESSPestado  = 11
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESSPestado = 10
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
				set TESDPestado  = 11
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESDPestado = 10
		</cfquery>
		<cftransaction action="commit" />

		<!--- Se envia a la Cola de Interfaz --->
		<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
		<cfset LobjInterfaz.fnProcesoNuevoSoin(150,"TESOPid=#form.TESOPid#","E")> <!--- E=Enviar a Emitir --->
		<cftransaction action="commit" />

		<!--- Impresión de la OP --->
		<cfif isdefined("Session.Tesoreria.ordenesPagoIrLista") and len(Session.Tesoreria.ordenesPagoIrLista) GT 0>
			<cfif Session.Tesoreria.ordenesPagoIrLista EQ "ordenesPagoManual.cfm">
				<cf_OP_imprimir location="#Session.Tesoreria.ordenesPagoIrLista#">
			<cfelse>
				<cf_OP_imprimir location="../Solicitudes/#Session.Tesoreria.ordenesPagoIrLista#">
			</cfif>
		</cfif>
		<cf_OP_imprimir location="ordenesPago.cfm?PASO=#Form.PASO#">
	<cfelseif IsDefined("form.btnEmitir_Seleccionados")>
		<!--- Emisión multiple de ordenes de pago --->
		<cfset form.PASO = 0>
		<cfif isdefined("form.chk")>
			<cfloop index="LvarID" list="#form.chk#">
				<cfquery datasource="#session.dsn#">
					update TESordenPago
						set TESOPestado  = 11
					 where TESid = #session.Tesoreria.TESid#
					   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESOPestado = 10
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
						set TESSPestado  = 11
					 where TESid = #session.Tesoreria.TESid#
					   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESSPestado = 10
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESdetallePago
						set TESDPestado  = 11
					 where TESid = #session.Tesoreria.TESid#
					   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESDPestado = 10
				</cfquery>
				<cftransaction action="commit" />

				<!--- Se envia a la Cola de Interfaz --->
				<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
				<cfset LobjInterfaz.fnProcesoNuevoSoin(150,"TESOPid=#LvarID#","E")> <!--- E=Enviar a Emitir --->
				<cftransaction action="commit" />
			</cfloop>
			<cflocation url="ordenesPago.cfm?PASO=#Form.PASO#">
		</cfif>
	<cfelseif IsDefined("form.btnBorrarDet") and len(trim(form.btnBorrarDet))>
		<cfset form.PASO = 10>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set TESSPestado 		= 2

				 , TESOPid	 		= null
				 , CBid	 			= null
				 , TESMPcodigo	 	= null
				 , SNid	 			= null
				 , EcodigoSP	 	= null
				 , TESOPfechaPago	= null

			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarDet#">
			   and TESSPestado in (10,11)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set  TESDPestado  			= 2
				  , TESOPid 				= null
				  , TESDPfechaPago 			= null
				  , EcodigoPago				= null
				  , TESDPmontoAprobadoLocal = null
				  , TESDPtipoCambioOri		= null
				  , TESDPfactorConversion	= null
				  , TESDPmontoPago			= null
				  , TESDPmontoPagoLocal 	= null
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarDet#">
			   and TESDPestado  in (10,11)
		</cfquery>
		<cfquery name="rsTotTESDP" datasource="#session.dsn#">
			select coalesce(sum(TESDPmontoPago*TESDPfactorConversion),0) as total
			  from TESdetallePago
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESDPestado in (10,11)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set TESOPtotalPago = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotTESDP.total#">
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
		<cfset LvarCBidPago = listFirst(form.CBidPago)>
		<cfif LvarCBidPago EQ ""><cfset LvarCBidPago=-1></cfif>
		<cfset sbInicializaTiposCambio(form.TESOPid,LvarCBidPago,true,true)>
	<cfelseif isdefined("form.btnVolver")>
			<cfset form.PASO = 10>
	<cfelseif isdefined("form.btnSeleccionarSP")>
		<cfset form.PASO = 10>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EcodigoPago,TESOPfechaPago, CBidPago, TESMPcodigo, TESOPestado
			from TESordenPago
			where TESid = #session.Tesoreria.TESid#
			  and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		</cfquery>

		<cfif isdefined("form.chk")>
			<cfloop index="LvarID" list="#form.chk#">
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado  = #rsOrden.TESOPestado#

						 , TESOPid 			= #form.TESOPid#
						 , CBid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.CBidPago#" null="#rsOrden.CBidPago EQ ''#">
						 , TESMPcodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOrden.TESMPcodigo#" null="#rsOrden.TESMPcodigo EQ ''#">
						 , SNid =
							case when SNcodigoOri is not null then
								(
									select <cfif IsDefined("form.chkSNCorporativo")>coalesce(SNidCorporativo,SNid)<cfelse>SNid</cfif>
									  from SNegocios sn
									 where sn.Ecodigo	= TESsolicitudPago.EcodigoOri
									   and sn.SNcodigo	= TESsolicitudPago.SNcodigoOri
								)
							end
						 , EcodigoSP 		= <cfif IsDefined("form.chkSNCorporativo")>0<cfelse>EcodigoOri</cfif>
						 , TESOPfechaPago 	= TESSPfechaPagar

					 where TESid = #session.Tesoreria.TESid#
					   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESSPestado  = 2
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESdetallePago
					   set     TESDPestado	= #rsOrden.TESOPestado#
							 , TESOPid 		= #form.TESOPid#
							 , EcodigoPago	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrden.EcodigoPago#" null="#rsOrden.EcodigoPago EQ ''#">
							 , TESDPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#rsOrden.TESOPfechaPago#">
					 where TESid = #session.Tesoreria.TESid#
					   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESOPid is null
					   and TESDPestado  = 2
				</cfquery>
			</cfloop>

			<cfset LvarCBidPago = rsOrden.CBidPago>
			<cfif LvarCBidPago EQ ""><cfset LvarCBidPago=-1></cfif>
			<cfset sbInicializaTiposCambio(form.TESOPid,LvarCBidPago,true,true)>
		</cfif>
	<cfelseif IsDefined("form.Nuevo")>
		<!--- Tratar como form.nuevo --->
		<cfset form.PASO = 0>
	<!--- solicitudesCP_lista1Sel.cfm --->
	<cfelseif IsDefined("form.btnSeleccionar") OR IsDefined("form.btnSiguiente")>
		<cfset session.Tesoreria.CBidPagar = form.CBidPagar>
		<cfset session.Tesoreria.TESMPcodigoPagar = form.TESMPcodigo>

		<cfif IsDefined("form.btnSeleccionar")>
			<cfset form.PASO = 1>
		<cfelse>
			<cfset form.PASO = 2>
		</cfif>
		<cfif isdefined("form.chk")>
			<cfloop index="LvarID" list="#form.chk#">
				<cfset LvarID = trim(LvarID)>
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado  = 10

					     , TESOPid 			= null
					     , CBid 			=
						 	CASE
						 		WHEN CBidPago IS NOT NULL THEN CBidPago
						 		ELSE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CBidPagar#">
						 	END
						 , TESMPcodigo		=
						 	CASE
						 		WHEN TESMPcodigoPago IS NOT NULL THEN TESMPcodigoPago
						 		ELSE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#" null="#form.TESMPcodigo EQ ""#">
						 	END
						 <!--- , CBid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPagar#">
						 , TESMPcodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#" null="#form.TESMPcodigo EQ ""#"> --->
						 , SNid 			=
							case when SNcodigoOri is not null
								then (
									select <cfif IsDefined("form.chkSNCorporativo")>coalesce(SNidCorporativo,SNid)<cfelse>SNid</cfif>
									  from SNegocios sn
									 where sn.Ecodigo	= TESsolicitudPago.EcodigoOri
									   and sn.SNcodigo	= TESsolicitudPago.SNcodigoOri
								)
							end
						 , EcodigoSP 		= <cfif IsDefined("form.chkSNCorporativo")>0<cfelse>EcodigoOri</cfif>
						 , TESOPfechaPago 	= TESSPfechaPagar

					 where TESid = #session.Tesoreria.TESid#
					  and TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarID#">
					   and TESSPestado  = 2
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update TESdetallePago
					   set TESDPestado = 10
					     , TESOPid = null
					 where TESid = #session.Tesoreria.TESid#
					  and TESSPid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarID#">
					   and TESOPid is null
					   and TESDPestado  = 2
				</cfquery>
			</cfloop>
		</cfif>
	<!--- solicitudesCP_lista2Gen.cfm --->
	<cfelseif IsDefined("form.btnCambiarSel")>
		<cfset form.PASO = 2>
		<cfif isdefined("TESSPid")>
			<cfloop index="LvarID" list="#form.TESSPid#">
				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago

					  <cfset LvarTESMPcodigo = #evaluate('form.TESMPcodigo_#LvarID#')#>
					   set CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.CBid_#LvarID#')#">
						 , TESMPcodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTESMPcodigo#" null="#LvarTESMPcodigo EQ ""#">
						 , TESOPfechaPago 	= <cfqueryparam cfsqltype="cf_sql_date"  value="#LSParseDatetime(evaluate('form.TESOPfechaPago_#LvarID#'))#">

					 where TESid = #session.Tesoreria.TESid#
					   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
					   and TESOPid is null
					   and TESSPestado  = 10
				</cfquery>
			</cfloop>
		</cfif>
	<cfelseif IsDefined("form.btnBorrarSel") and len(trim(form.btnBorrarSel))>
		<cfset form.PASO = 2>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
			   set TESSPestado 		= 2

				 , TESOPid	 		= null
				 , CBid	 			= null
				 , TESMPcodigo	 	= null
				 , SNid	 			= null
				 , EcodigoSP	 	= null
				 , TESOPfechaPago	= null

			 where TESid = #session.Tesoreria.TESid#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarSel#">
			   and TESOPid is null
			   and TESSPestado  = 10
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set  TESDPestado  			= 2
				  , TESOPid 				= null
				  , TESDPfechaPago 			= null
				  , EcodigoPago				= null
				  , TESDPmontoAprobadoLocal = null
				  , TESDPtipoCambioOri		= null
				  , TESDPfactorConversion	= null
				  , TESDPmontoPago			= null
				  , TESDPmontoPagoLocal 	= null
			 where TESid = #session.Tesoreria.TESid#
			   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.btnBorrarSel#">
			   and TESOPid is null
			   and TESDPestado  = 10
		</cfquery>
	<cfelseif IsDefined("form.btnBorrarTodos") and #form.btnBorrarTodos# EQ 'OK'>
	<!--- QUITA TODAS LAS SOLICITUDES DE PAGO --->
	<cfset form.PASO = 2>
	<cfif isdefined("form.TESSPID")>
		<cfloop index="LvarID" list="#form.TESSPID#">
			<cfquery datasource="#session.dsn#">
				update TESsolicitudPago
				   set TESSPestado 		= 2

					 , TESOPid	 		= null
					 , CBid	 			= null
					 , TESMPcodigo	 	= null
					 , SNid	 			= null
					 , EcodigoSP	 	= null
					 , TESOPfechaPago	= null

				 where TESid = #session.Tesoreria.TESid#
				   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
				   and TESOPid is null
				   and TESSPestado  = 10
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update TESdetallePago
				   set  TESDPestado  			= 2
					  , TESOPid 				= null
					  , TESDPfechaPago 			= null
					  , EcodigoPago				= null
					  , TESDPmontoAprobadoLocal = null
					  , TESDPtipoCambioOri		= null
					  , TESDPfactorConversion	= null
					  , TESDPmontoPago			= null
					  , TESDPmontoPagoLocal 	= null
				 where TESid = #session.Tesoreria.TESid#
				   and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
				   and TESOPid is null
				   and TESDPestado  = 10
			</cfquery>
		</cfloop>
	</cfif>
	<cfelseif IsDefined("form.btnGenerarSel")>
		<cfset form.PASO = 0>
		<cfif isdefined("TESSPid")>
			<cf_whereInList Column="sp.TESSPid" ValueList="#form.TESSPid#" returnVariable="LvarTESSPid_In_List">
			<cfquery name="rsMonedas" datasource="#session.dsn#">
				select distinct mo.Miso4217
				  from TESsolicitudPago sp
					inner join CuentasBancos cb
						 on cb.CBid = sp.CBid
					inner join Monedas mo
						 on mo.Ecodigo	= sp.EcodigoOri
						and mo.Mcodigo	= sp.McodigoOri
				 where sp.TESid 	= #session.Tesoreria.TESid#
				   and #LvarTESSPid_In_List#
				   and sp.TESOPid 	is null
				   and TESSPestado  = 10
				   and not exists (
						select 1
						  from Monedas m
						 where m.Ecodigo = cb.Ecodigo
						   and m.Miso4217 = mo.Miso4217
					)
			</cfquery>
			<cfif rsMonedas.recordCount>
				<cf_errorCode	code = "50752"
								msg  = "La empresa de Pago no tiene definidas las siguientes Monedas: @errorDat_1@"
								errorDat_1="#ValueList(rsMonedas.Miso4217)#"
				>
			</cfif>

			<cfquery name="rsTESSP" datasource="#session.dsn#">
				select distinct
							sp.TESOPfechaPago, coalesce(sp.CPCid,0) as CPCid,
							sp.CBid, sp.TESMPcodigo,
							cb.Ecodigo, mp.Miso4217,
							sp.EcodigoSP,

							sn.SNid, coalesce(sn.SNidCorporativo, sn.SNid) as SNidP,
							sp.SNcodigoOri,
							sp.TESBid,
							sp.CDCcodigo,

							case
								when sp.SNcodigoOri	is not null then 'S'
								when sp.TESBid		is not null then 'B'
								when sp.CDCcodigo	is not null then 'C'
							end as BeneficiarioTipo,

							case
								when sp.SNcodigoOri	is not null then sn.SNidentificacion
								when sp.TESBid		is not null then tb.TESBeneficiarioId
								when sp.CDCcodigo	is not null then cd.CDCidentificacion
							end as BeneficiarioID,

							case
								when sp.SNcodigoOri	is not null then coalesce(sn.SNnombrePago, sn.SNnombre)
								when sp.TESBid		is not null then tb.TESBeneficiario
								when sp.CDCcodigo	is not null then cd.CDCnombre
							end as Beneficiario,

							ep.Mcodigo as McodigoEmpresa, mp.Mcodigo as McodigoPago

							, sp.TESOPbeneficiarioSuf

							, cpc.SNidDestino								as CPCSNid
							, snCpc.SNidentificacion 						as CPCbeneficiarioID
							, coalesce(snCpc.SNnombrePago, snCpc.SNnombre) 	as CPCbeneficiario
							, sp.TESSPnumero
				  from TESsolicitudPago sp
					inner join CuentasBancos cb
						inner join Monedas mp
							 on mp.Ecodigo	= cb.Ecodigo
							and mp.Mcodigo	= cb.Mcodigo
						inner join Empresas ep
							 on ep.Ecodigo	= cb.Ecodigo
						 on cb.CBid = sp.CBid

					left join SNegocios sn
						 on sn.Ecodigo 	= sp.EcodigoOri
						and sn.SNcodigo = sp.SNcodigoOri
					left join TESbeneficiario tb
						on tb.TESBid = sp.TESBid
					left join ClientesDetallistasCorp cd
						on cd.CDCcodigo = sp.CDCcodigo

					left join CPCesion cpc
						inner join SNegocios snCpc
							on snCpc.SNid = cpc.SNidDestino
						on cpc.CPCid = sp.CPCid
				 where sp.TESid 	= #session.Tesoreria.TESid#
				   and #LvarTESSPid_In_List#
				   and sp.TESOPid 	is null
				   and TESSPestado  = 10
				order by sp.TESSPnumero asc, sp.TESOPfechaPago, sp.CBid, sp.TESMPcodigo, sn.SNid
			</cfquery>

			<!--- Nota: en la consulta rsTESSP repite algunas filas de solicitudes agrupadas, pues tiene distinc
						en el select pero ordena por la columna TESSPnumero la cual no esta en el select debido a esto
						repite filas en la consulta--->
			<!--- variables temporales para no repetir los registros--->
			<cfset validacionTMP="">
			<cfset validacionoldTMP="validacion de columnas repetidas">

			<cfoutput query="rsTESSP">

				<!--- almacenar temporalmente los datos para compararlos conlos datos anteriores--->
				<cfset validacionTMP="#rsTESSP.Beneficiario##rsTESSP.BeneficiarioID##rsTESSP.BeneficiarioTipo##rsTESSP.CBid##rsTESSP.CDCcodigo#">
				<cfset validacionTMP=validacionTMP&"#rsTESSP.CPCbeneficiario##rsTESSP.CPCbeneficiarioID##rsTESSP.CPCid##rsTESSP.CPCSNid##rsTESSP.Ecodigo#">
				<cfset validacionTMP=validacionTMP&"#rsTESSP.EcodigoSP##rsTESSP.McodigoEmpresa##rsTESSP.McodigoPago##rsTESSP.Miso4217##rsTESSP.SNcodigoOri#">
				<cfset validacionTMP=validacionTMP&"#rsTESSP.SNid##rsTESSP.SNidP##rsTESSP.TESBid##rsTESSP.TESMPcodigo##rsTESSP.TESOPbeneficiarioSuf##rsTESSP.TESOPfechaPago#">

				<cfif validacionTMP NEQ validacionoldTMP>

				<!--- Obtiene las diferentes TESOPobservaciones --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select TESSPnumero, TESOPobservaciones
					  from TESsolicitudPago sp
					 where TESid 			= #session.Tesoreria.TESid#
					   and #LvarTESSPid_In_List#
					   and TESOPid 			is null
					   and TESSPestado  	= 10

					   and <cf_dbfunction name="to_char" args="TESOPobservaciones" isNumber="no"> is not null

					 <cfif rsTESSP.BeneficiarioTipo EQ 'S'>
					   and SNid		 = #rsTESSP.SNid#
					<cfelseif rsTESSP.BeneficiarioTipo EQ 'B'>
					   and TESBid 	 = #rsTESSP.TESBid#
					<cfelse>
					   and CDCcodigo = #rsTESSP.CDCcodigo#
					</cfif>
					   and TESOPfechaPago	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESSP.TESOPfechaPago#">
					   and coalesce(CPCid,0)= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESSP.CPCid#">
					   and CBid				= #rsTESSP.CBid#
					 <cfif rsTESSP.TESOPbeneficiarioSuf NEQ "">
					   and TESOPbeneficiarioSuf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESSP.TESOPbeneficiarioSuf#">
					 <cfelse>
					   and coalesce(TESOPbeneficiarioSuf,'') = ''
					 </cfif>
					 order by TESSPnumero asc
				</cfquery>
				<cfset LvarTESOPobservaciones = "">
				<cfloop query="rsSQL">
					<cfif trim(rsSQL.TESOPobservaciones) NEQ "">
						<!---
						<cfset LvarTESOPobservaciones = LvarTESOPobservaciones & "SP.#rsSQL.TESSPnumero#: " & trim(rsSQL.TESOPobservaciones) & URLDecode(URLEncodedFormat(chr(13)))>
						--->
						<cfset LvarTESOPobservaciones = LvarTESOPobservaciones & "SP.#rsSQL.TESSPnumero#: " & trim(rsSQL.TESOPobservaciones) & ' '>
					</cfif>
				</cfloop>

				<!--- Obtiene las diferentes TESOPinstruccion --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select TESSPnumero, TESOPinstruccion
					  from TESsolicitudPago sp
					 where TESid 			= #session.Tesoreria.TESid#
					   and #LvarTESSPid_In_List#
					   and TESOPid 			is null
					   and TESSPestado  	= 10

					   and TESOPinstruccion is not null

					 <cfif rsTESSP.BeneficiarioTipo EQ 'S'>
					   and SNid		 = #rsTESSP.SNid#
					<cfelseif rsTESSP.BeneficiarioTipo EQ 'B'>
					   and TESBid 	 = #rsTESSP.TESBid#
					<cfelse>
					   and CDCcodigo = #rsTESSP.CDCcodigo#
					</cfif>
					   and TESOPfechaPago	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESSP.TESOPfechaPago#">
					   and coalesce(CPCid,0)= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESSP.CPCid#">
					   and CBid				= #rsTESSP.CBid#
					 <cfif rsTESSP.TESOPbeneficiarioSuf NEQ "">
					   and TESOPbeneficiarioSuf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESSP.TESOPbeneficiarioSuf#">
					 <cfelse>
					   and coalesce(TESOPbeneficiarioSuf,'') = ''
					 </cfif>
					 order by TESOPinstruccion
				</cfquery>

				<cfset LvarTESOPinstruccion = "">
				<cfloop query="rsSQL">
					<cfif trim(rsSQL.TESOPinstruccion) NEQ "" AND NOT findNoCase(",#trim(rsSQL.TESOPinstruccion)#,",",#LvarTESOPinstruccion#,")>
						<cfset LvarTESOPinstruccion = LvarTESOPinstruccion & trim(rsSQL.TESOPinstruccion) & ", ">
					</cfif>
				</cfloop>
				<cfif len(LvarTESOPinstruccion) GT 40>
					<cfset LvarTESOPinstruccion = mid(LvarTESOPinstruccion,1,40)>
				<cfelseif len(LvarTESOPinstruccion) GT 2>
					<cfset LvarTESOPinstruccion = mid(LvarTESOPinstruccion,1,len(LvarTESOPinstruccion)-2)>
				</cfif>


				<!--- Genera la OP --->
				<cflock type="exclusive" name="TesOrdPago#session.Tesoreria.TESid#" timeout="3">
					<cfquery name="rsTESOP" datasource="#session.dsn#">
						select coalesce(max(TESOPnumero)+1,1) as SiguienteOP
						  from TESordenPago
						 where TESid = #session.Tesoreria.TESid#
					</cfquery>

				<!--- Se obtiene la cuenta destino DEFAULT  --->
				<!--- SN - SNidP --->
				<!--- Contado - TESBid --->
				<cfquery name="rsGetCtaDestinoDefault" datasource="#session.dsn#">
					SELECT TOP 1 t.TESTPid
					FROM TEStransferenciaP t
					WHERE t.TESTPestado = 1 <!--- 1: Default --->
						and t.TESid = #session.Tesoreria.TESid#
					<cfif rsTESSP.BeneficiarioTipo EQ 'S'>
						<!--- SN --->
						AND SNidP = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsTESSP.SNidP#">
					<cfelseif rsTESSP.BeneficiarioTipo EQ 'B'>
					<!--- Contado --->
						AND TESBid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsTESSP.TESBid#">
					</cfif>
				</cfquery>
					<cfquery name="insert" datasource="#session.dsn#">
						insert into TESordenPago
								(
								 TESid         ,
								 TESOPnumero   ,
								 TESOPestado   ,
								 SNid, SNidP,
								 TESBid,
								 CDCcodigo,
									TESOPbeneficiarioId, TESOPbeneficiario,
								 TESOPfechaPago,
								 CBidPago,
								 TESMPcodigo,
								 EcodigoPago, Miso4217Pago,
								 TESOPfechaGeneracion,
								 UsucodigoGenera
								, TESOPobservaciones
								, TESOPinstruccion
								, TESOPbeneficiarioSuf
								<cfif isDefined("rsGetCtaDestinoDefault") AND rsGetCtaDestinoDefault.recordCount GT 0>
									 , TESTPid
								 </cfif>
								<cfif isDefined("form.conceptoCIE")>
									,TESOPConceptoCIE
								</cfif>
								<cfif isDefined("form.convenioCIE")>
									,TESOPConvenioCIE
								</cfif>
								<cfif isDefined("form.referenciaCIE")>
				  					, TESOPReferenciaCIE	
				   				</cfif>
								)
						values (
								 #session.Tesoreria.TESid#,
								 #rsTESOP.SiguienteOP#,
								 10,
								 <cfif rsTESSP.CPCid NEQ '0'>
									#rsTESSP.CPCSNid#, #rsTESSP.CPCSNid#, null, null,
								 <cfelseif rsTESSP.BeneficiarioTipo EQ 'S'>
									#rsTESSP.SNid#, #rsTESSP.SNidP#, null, null,
								<cfelseif rsTESSP.BeneficiarioTipo EQ 'B'>
									null, null, #rsTESSP.TESBid#, null,
								<cfelse>
									null, null, null, #rsTESSP.CDCcodigo#,
								</cfif>
								 <cfif rsTESSP.CPCid EQ '0'>
									 <cfif trim(rsTESSP.BeneficiarioID) EQ "">null<cfelse>'#rsTESSP.BeneficiarioID#'</cfif>,
									 <cfif trim(rsTESSP.Beneficiario) EQ "">null<cfelse>'#rsTESSP.Beneficiario#'</cfif>,
								 <cfelse>
									 <cfif trim(rsTESSP.CPCbeneficiarioID) EQ "">null<cfelse>'#rsTESSP.CPCbeneficiarioID#'</cfif>,
									 <cfif trim(rsTESSP.CPCbeneficiario) EQ "">null<cfelse>'#rsTESSP.CPCbeneficiario#'</cfif>,
								 </cfif>
								 <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESSP.TESOPfechaPago#">,
								 #rsTESSP.CBid#,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESSP.TESMPcodigo#" null="#rsTESSP.TESMPcodigo EQ ''#">,
								 #rsTESSP.Ecodigo#, '#rsTESSP.Miso4217#',
								 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								 #session.usucodigo#
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTESOPobservaciones#"			null="#LvarTESOPobservaciones EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTESOPinstruccion#"			null="#LvarTESOPinstruccion EQ ""#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESSP.TESOPbeneficiarioSuf#"	null="#rsTESSP.TESOPbeneficiarioSuf EQ ""#">
								<cfif isDefined("rsGetCtaDestinoDefault") AND rsGetCtaDestinoDefault.recordCount GT 0>
									 ,<cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsGetCtaDestinoDefault.TESTPid#">
								 </cfif>
								 <cfif isDefined("form.conceptoCIE")>
									, <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.conceptoCIE#" null="#form.conceptoCIE EQ ''#">
								</cfif>
								<cfif isDefined("form.convenioCIE")>
									, <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.convenioCIE#" null="#form.convenioCIE EQ ''#">
								</cfif>
								<cfif isDefined("form.referenciaCIE")>	
								    , <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.referenciaCIE#" null="#form.referenciaCIE EQ ''#">
								</cfif>
								)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESOPid">
				</cflock>

				<cfquery datasource="#session.dsn#">
					update TESsolicitudPago
					   set TESSPestado	= 10
						 , TESOPid 		= #LvarTESOPid#
					 where TESid 			= #session.Tesoreria.TESid#
					   and #REPLACE(LvarTESSPid_In_List,"sp.TESSPid","TESSPid","ALL")#
					   and TESOPid 			is null
					   and TESSPestado  	= 10

					 <cfif rsTESSP.BeneficiarioTipo EQ 'S'>
					   and SNid		 = #rsTESSP.SNid#
					<cfelseif rsTESSP.BeneficiarioTipo EQ 'B'>
					   and TESBid 	 = #rsTESSP.TESBid#
					<cfelse>
					   and CDCcodigo = #rsTESSP.CDCcodigo#
					</cfif>
					   and TESOPfechaPago	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESSP.TESOPfechaPago#">
					   and coalesce(CPCid,0)= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTESSP.CPCid#">
					   and CBid				= #rsTESSP.CBid#
					 <cfif rsTESSP.TESOPbeneficiarioSuf NEQ "">
					   and TESOPbeneficiarioSuf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTESSP.TESOPbeneficiarioSuf#">
					 <cfelse>
					   and coalesce(TESOPbeneficiarioSuf,'') = ''
					 </cfif>
				</cfquery>

				<cfquery datasource="#session.dsn#">
					update TESdetallePago
					   set TESDPestado	= 10
						 , TESOPid 		= #LvarTESOPid#
						 , EcodigoPago	= #rsTESSP.Ecodigo#
						 , TESDPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#rsTESSP.TESOPfechaPago#">
					 where exists(
							select 1
							  from TESsolicitudPago sp
							 where sp.TESid 			= #session.Tesoreria.TESid#
							   and #LvarTESSPid_In_List#
							   and sp.TESOPid 			= #LvarTESOPid#
							   and sp.TESSPestado  		= 10

							   and TESdetallePago.TESSPid	= sp.TESSPid
							)
				</cfquery>

				<cfset sbInicializaTiposCambio(LvarTESOPid,rsTESSP.CBid,true)>
				</cfif>
				<cfset validacionoldTMP=validacionTMP>
			</cfoutput>
		</cfif>
	<cfelseif IsDefined("form.btnEmitirManual")>
		<cfset form.PASO = 0>
		<cfif Form.testmptipo EQ 1>
			<!--- TIPO MEDIO PAGO "CHEQUE" --->
			<cfset LvarSigFormulario = listToArray(form.TESCFT)>
			<cfset LvarIniFormulario = LvarSigFormulario[1]>
			<cfset LvarSigFormulario = LvarSigFormulario[3]>
			<!--- ANULA FORMULARIOS ANTES --->
			<cfif LvarSigFormulario NEQ -1>
				<cfloop index="LvarNum" from="#LvarSigFormulario#" to="#form.TESCFDnumFormulario-1#">
					<cfquery datasource="#session.dsn#">
						insert into TEScontrolFormulariosD
							(
								 TESid
								,CBid
								,TESMPcodigo
								,TESCFDnumFormulario
								,TESOPid
								,TESCFLid
								,TESCFDestado
								,UsucodigoEmision
								,TESCFDfechaEmision
								,TESCFDfechaGeneracion
								,BMUsucodigo
								,TESCFDfechaAnulacion
								,TESCFDmsgAnulacion
							)
							values (
								 #session.Tesoreria.TESid#
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
								,#LvarNum#
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
								,null
								,3	/* Anulados */
								,#session.Usucodigo#
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 	<!--- TESCFDfechaEmision --->
								,<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaGeneracionManual)#">
								,#session.Usucodigo#
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDmsgAnulacion#">
							)
					</cfquery>

					<cfquery name="rsAnular" datasource="#session.dsn#">
						select min(TESCFEid) as TESCFEid from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1
					</cfquery>
					<cfquery datasource="#session.dsn#">
						insert into TEScontrolFormulariosB
							(
								TESid, CBid, TESMPcodigo, TESCFDnumFormulario,
								TESCFBultimo, UsucodigoCustodio,
								TESCFBfecha, TESCFEid, TESCFLUid, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
							)
						values
							(
								#session.Tesoreria.TESid#
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
								,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
								,#LvarNum#
								,1
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								,#rsAnular.TESCFEid#
								,NULL
								,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
					</cfquery>

				</cfloop>
			</cfif>

			<!--- GENERA FORMULARIO REGISTRADO --->
			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosD
					(
						 TESid
						,CBid
						,TESMPcodigo
						,TESCFDnumFormulario
						,TESOPid
						,TESCFLid
						,TESCFDestado
						,UsucodigoEmision
						,TESCFDfechaEmision
						,TESCFDfechaGeneracion
						,BMUsucodigo
					)
					values (
						 #session.Tesoreria.TESid#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
						,#form.TESOPid#
						,null
						,1	/* Impresos */
						,#session.Usucodigo#
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 	<!--- TESCFDfechaEmision --->
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(form.FechaGeneracionManual)#">
						,#session.Usucodigo#
					)
			</cfquery>

			<cfquery   name="rsInsert" datasource="#session.dsn#">
				select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
						,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEimpreso = 1) as TESCFEid

				  from TEScontrolFormulariosD
				 where TESid				= #session.Tesoreria.TESid#
				   and CBid					= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				   and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				   and TESCFDnumFormulario	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
				   and TESCFDestado			= 1
			</cfquery>


			<cfquery datasource="#session.dsn#">
				insert into TEScontrolFormulariosB
					(
						TESid, CBid, TESMPcodigo, TESCFDnumFormulario,
						TESCFBultimo, UsucodigoCustodio,
						TESCFBfecha, TESCFEid, TESCFLUid, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
					)
				values (
						#rsInsert.TESid#,
						#rsInsert.CBid#,
						<cfqueryparam value="#rsInsert.TESMPcodigo#" cfsqltype="cf_sql_char">,
						#rsInsert.TESCFDnumFormulario#
						,1,#session.Usucodigo#
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						,#rsInsert.TESCFEid#
						,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						,#session.Usucodigo#
						,#session.Usucodigo#
					)

			</cfquery>

			<cfif isdefined("Form.chkEntrega")>
				<!--- ACTUALIZA INFORMACION DE ENTREGA --->
				<cfquery datasource="#session.dsn#">
					update TEScontrolFormulariosD
						set TESCFDestado = 2,

							TESCFDentregadoId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDentregadoId#">,
							TESCFDentregado   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESCFDentregado#">,
							TESCFDentregadoFecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.TESCFDentregadoFecha)#">,

							TESCFDfechaEntrega = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							UsucodigoEntrega = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					 where TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumformulario#">
					   and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				</cfquery>
				<!--- ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
				<cfquery datasource="#session.DSN#">
					update TEScontrolFormulariosB
					   set TESCFBultimo = 0
					where TESid				   = #session.Tesoreria.TESid#
					   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
				</cfquery>
				<!--- INSERTA UN REGISTRO CON LE MOVIMIENTO REALIZADO EN LA BITACORA DE FORMULARIOS --->
				<cfquery datasource="#session.dsn#">
					insert into TEScontrolFormulariosB
						(
							TESid, CBid, TESMPcodigo,TESCFDnumFormulario,
							TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
						)
					select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							,(select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEentregado = 1)
							,NULL
							,1
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					  from TEScontrolFormulariosD
					 where TESid			   = #session.Tesoreria.TESid#
					   and CBid				   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESMPcodigo		   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					   and TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
				</cfquery>
			</cfif>

			<cfif LvarSigFormulario NEQ -1>
				<!--- LIBERA EL BLOQUE DE FORMULARIOS --->
				<cfquery datasource="#session.dsn#">
					update TEScontrolFormulariosT
					   set TESCFTimprimiendo = 0
						 , TESCFTultimo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
					 where TESid			= #session.Tesoreria.TESid#
					   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
					   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
					   and TESCFTnumInicial	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIniFormulario#">
				</cfquery>
			</cfif>
		<cfelse>
			<!--- TIPO MEDIO PAGO "TRANSFERENCIA" --->
			<cfquery name="insert" datasource="#session.dsn#">
				insert into TEStransferenciasD
					(
						 TESid
						,CBid
						,TESMPcodigo
						,TESOPid
						,TESTLid
						,TESTDreferencia
						,TESTDestado
						,UsucodigoEmision
						,TESTDfechaEmision
						,TESTDfechaGeneracion
						,BMUsucodigo
					)
					values (
						 #session.Tesoreria.TESid#
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
						,NULL
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTreferencia#">
						,1	/* Impreso o generado o manual (Registrado) */
						,#session.Usucodigo#
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 	<!--- TESTDfechaEmision --->
						,<cfqueryparam cfsqltype="cf_sql_date" 		value="#LSParseDateTime(form.FechaGeneracionManual)#">
						,#session.Usucodigo#
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarTESTDid">
		</cfif>

		<cfquery datasource="#session.dsn#">
			update TESordenPago
				set  TESOPestado  = 110
					,TESOPfechaEmision = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,UsucodigoEmision  = #session.Usucodigo#
					,TESOPfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.TESOPfechaPago)#">
				<cfif form.TESTMPtipo EQ 1>
					,TESOPobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESOPobservaciones#" null="#form.TESOPobservaciones EQ ''#">
					,TESCFDnumFormulario = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario#">
				<cfELSE>
					,TESTDid = #LvarTESTDid#
				</cfif>
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESsolicitudPago
				set TESSPestado  = 110
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESSPestado in (10,11)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
				set TESDPestado  = 110
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
			   and TESDPestado in (10,11)
		</cfquery>

		<cfset Contabilizar = true>
		<cfif Form.TESTMPtipo EQ 1>
			<!----Contabiliza la entrega de los cheques segun parametro 5001--->
			<cfquery datasource="#session.dsn#" name="rsContabiliza">
				Select Pvalor
				  from Parametros
				 where Ecodigo = #Session.Ecodigo#
				   and Pcodigo = 5001
			</cfquery>
			<cfset ContabilizarEntrega = (trim(rsContabiliza.Pvalor) EQ '1')>
			<cfif ContabilizarEntrega>
				<cfif isdefined("Form.chkEntrega")>
					<cfset Contabilizar = true>
					<cfquery datasource="#session.dsn#">
						update TESordenPago
						   set TESOPfechaPago = <cf_dbfunction name="today">
						 where TESOPid = #form.TESOPid#
					</cfquery>
				<cfelse>
					<cfset Contabilizar = false>
				</cfif>
			</cfif>
        </cfif>

		<cfif Contabilizar>
            <cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion"
                        method="sbAplicarOrdenPago">
                <cfinvokeargument name="TESOPid" value="#form.TESOPid#"/>
            </cfinvoke>
        </cfif>

		<cftransaction action="commit" />

		<cfif isdefined('rsForm.FMT01CODemail') and len(trim(#rsForm.FMT01CODemail#))>
			<cfif NOT isdefined('Reimpresion') AND rsForm.FMT01CODemail NEQ "">
				<cfoutput>
				<cf_popup
					url="/cfmx/sif/Utiles/cfreportesCarta.cfm?toEmail=true&Ecodigo=#Session.Ecodigo#&FMT01COD=#rsform.FMT01CODemail#&Conexion=#Session.DSN#&TESid=#session.tesoreria.TESid#&CBid=#rsform.CBid#&TESTCFid=#rsform.TESTCFid#&TESMPcodigo=#rsform.TESMPcodigo#"
					link="Notificación de Pago"
					boton="false" width="800" height="600" left="0" top="0" resize="yes" ejecutar="true"
					scrollbars="yes"
				>
				</cfoutput>
				<cfexit>
			</cfif>
		</cfif>

		<!--- Impresión de la OP --->
		<cfif isdefined("Session.Tesoreria.ordenesPagoIrLista") and len(Session.Tesoreria.ordenesPagoIrLista) GT 0>
			<cfif Session.Tesoreria.ordenesPagoIrLista EQ "ordenesPagoManual.cfm">
				<cf_OP_imprimir location="#Session.Tesoreria.ordenesPagoIrLista#">
			<cfelse>
				<cf_OP_imprimir location="../Solicitudes/#Session.Tesoreria.ordenesPagoIrLista#">
			</cfif>
		</cfif>

		<cf_OP_imprimir location="ordenesPago.cfm?PASO=#Form.PASO#">
	</cfif>
</cftransaction>


<cfif Form.PASO EQ 10 AND isdefined("Form.TESOPid")>
	<cflocation url="ordenesPago.cfm?PASO=10&TESOPid=#Form.TESOPid#">
<cfelseif Form.PASO EQ 3 and isdefined("Form.TESOPid")>
	<cflocation url="ordenesPago.cfm?PASO=#Form.PASO#&TESOPid=#Form.TESOPid#">
<cfelse>
	<cfif isdefined("Session.Tesoreria.ordenesPagoIrLista") and len(Session.Tesoreria.ordenesPagoIrLista) GT 0>
		<cfif Session.Tesoreria.ordenesPagoIrLista EQ "ordenesPagoManual.cfm">
			<cflocation url="#Session.Tesoreria.ordenesPagoIrLista#">
		<cfelse>
			<cflocation url="../Solicitudes/#Session.Tesoreria.ordenesPagoIrLista#">
		</cfif>
	</cfif>
	<cflocation url="ordenesPago.cfm?PASO=#Form.PASO#">
</cfif>

<cffunction name="sbInicializaTiposCambio" access="private" output="false">
	<cfargument name="TESOPid"	required="yes" type="numeric">
	<cfargument name="CBidPago" 		required="yes" type="numeric">
	<cfargument name="forzar" 			type="boolean" default="no" >
	<cfargument name="soloNULLs"		type="boolean" default="no" >

	<cfif Arguments.CBidPago LTE 0>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set EcodigoPago				= null
				 , TESDPmontoAprobadoLocal 	= 0
				 , TESDPtipoCambioOri 		= 1
				 , TESDPfactorConversion 	= 0
				 , TESDPmontoPago 			= 0
				 , TESDPmontoPagoLocal 		= 0
			 where TESid 			= #session.Tesoreria.TESid#
			   and TESOPid 			= #Arguments.TESOPid#
			   and TESDPestado in (10,11)
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update TESordenPago
			   set CBidPago				= null
				 , TESMPcodigo  		= null
				 , EcodigoPago			= null
				 , Miso4217Pago			= null
				 , TESOPtotalPago 		= 0
				 , TESOPtipoCambioPago 	= 1
			 where TESid 			= #session.Tesoreria.TESid#
			   and TESOPid 			= #Arguments.TESOPid#
			   and TESOPestado in (10,11)
		</cfquery>
		<cfreturn>
	</cfif>

	<cfquery name="rsNuevaCBid" datasource="#session.dsn#">
		select cb.CBid as CBidPago, ep.Ecodigo as EcodigoPago, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago
		  from CuentasBancos cb
		  	inner join Monedas mp
				on mp.Mcodigo = cb.Mcodigo
			inner join Empresas ep
				inner join Monedas mep
					on mep.Mcodigo = ep.Mcodigo
				on ep.Ecodigo = cb.Ecodigo
		 where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBidPago#">
	</cfquery>

	<cfif Arguments.forzar>
		<cfquery name="rsViejaCBid" datasource="#session.dsn#">
			select op.CBidPago, op.TESOPfechaPago,
					case when coalesce(op.TESOPtipoCambioPago,0) = 0 then 1 else op.TESOPtipoCambioPago end as TESOPtipoCambioPago
			  from TESordenPago op
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
		<cfif Arguments.soloNULLs>
			<cfset LvarCambiarTCpago = rsViejaCBid.TESOPtipoCambioPago EQ 0>
		<cfelse>
			<cfset LvarCambiarTCpago = true>
		</cfif>
		<cfset LvarCambiarTCori  = true>
	<cfelse>
		<cfquery name="rsViejaCBid" datasource="#session.dsn#">
			select 	cb.CBid as CBidPago, op.TESOPfechaPago,
					case when coalesce(op.TESOPtipoCambioPago,0) = 0 then 1 else op.TESOPtipoCambioPago end as TESOPtipoCambioPago,
					ep.Ecodigo as EcodigoPago, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago, mep.Mcodigo as McodigoEmpresaPago
			  from TESordenPago op
				  inner join CuentasBancos cb
					inner join Monedas mp
						on mp.Mcodigo = cb.Mcodigo
					inner join Empresas ep
						inner join Monedas mep
							on mep.Mcodigo = ep.Mcodigo
						on ep.Ecodigo = cb.Ecodigo
					on cb.CBid = op.CBidPago
			 where TESid = #session.Tesoreria.TESid#
			   and TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESOPid#">
			   and TESOPestado in (10,11)
		</cfquery>
		<cfif rsViejaCBid.CBidPago EQ "">
			<cfset LvarCambiarTCpago = true>
			<cfset LvarCambiarTCori  = true>
		<cfelse>
			<cfset LvarCambiarTCpago = rsViejaCBid.Miso4217EmpresaPago NEQ rsNuevaCBid.Miso4217EmpresaPago or rsViejaCBid.Miso4217Pago NEQ rsNuevaCBid.Miso4217Pago>
			<cfset LvarCambiarTCori  = rsViejaCBid.Miso4217EmpresaPago NEQ rsNuevaCBid.Miso4217EmpresaPago>
		</cfif>
	</cfif>

	<cfif rsViejaCBid.TESOPfechaPago EQ "">
		<cfset LvarFecha = now()>
	<cfelse>
		<cfset LvarFecha = rsViejaCBid.TESOPfechaPago>
	</cfif>

	<cfif LvarCambiarTCpago>
		<cfif rsNuevaCBid.Miso4217Pago EQ rsNuevaCBid.Miso4217EmpresaPago>
			<cfset LvarTCpago = 1>
		<cfelse>
			<cfquery name="rsTipoCambio" datasource="#session.dsn#">
				select tc.TCventa as TipoCambio
				  from Monedas m
					  inner join Htipocambio tc
						 on tc.Ecodigo 	= m.Ecodigo
						and tc.Mcodigo	= m.Mcodigo
						and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
						and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
				 where m.Ecodigo 	= #rsNuevaCBid.EcodigoPago#
				   and m.Miso4217 	= '#rsNuevaCBid.Miso4217Pago#'
			</cfquery>
			<cfif rsTipoCambio.TipoCambio NEQ "">
				<cfset LvarTCpago = rsTipoCambio.TipoCambio>
			<cfelse>
				<cfset LvarTCpago = 1>
			</cfif>
		</cfif>
	<cfelse>
		<cfif rsNuevaCBid.Miso4217Pago EQ rsNuevaCBid.Miso4217EmpresaPago>
			<cfset LvarTCpago = 1>
		<cfelse>
			<cfset LvarTCpago = rsViejaCBid.TESOPtipoCambioPago>
		</cfif>
	</cfif>

	<cfif LvarCambiarTCori>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set TESDPtipoCambioOri =
			   		case
						when Miso4217Ori = '#rsNuevaCBid.Miso4217EmpresaPago#' 	then 1.0000
						when Miso4217Ori = '#rsNuevaCBid.Miso4217Pago#' 		then #LvarTCpago#
						when
							(
								select d.CPCid
								  from TESdetallePagoCPC d
								  	inner join CPCesion c on c.CPCid = d.CPCid
									inner join Monedas mc on mc.Mcodigo = c.Mcodigo
								 where TESDPidNew = TESdetallePago.TESDPid
								   and mc.Miso4217 							<> TESdetallePago.Miso4217Ori
								   and '#rsNuevaCBid.Miso4217EmpresaPago#'	in (TESdetallePago.Miso4217Ori,mc.Miso4217)
								   and '#rsNuevaCBid.Miso4217Pago#'			in (TESdetallePago.Miso4217Ori,mc.Miso4217)
							) is not null
							then (select CPClocal/TESDPmontoSolicitadoOri from TESdetallePagoCPC where TESDPidNew = TESdetallePago.TESDPid)
						else
							coalesce (
							(
								select top 1 tc.TCventa
								  from Monedas m
									  inner join Htipocambio tc
										 on tc.Ecodigo 	= m.Ecodigo
										and tc.Mcodigo	= m.Mcodigo
										and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
										and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
								 where m.Ecodigo 	= #rsNuevaCBid.EcodigoPago#
								   and m.Miso4217 	= TESdetallePago.Miso4217Ori
								order by tc.Hfecha desc
							)
							, 0)
			   		end
			 where TESid 			= #session.Tesoreria.TESid#
			   and TESOPid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESOPid#">
			   and TESDPestado		in (10,11)
			   and RlineaId 		IS NULL
			   <cfif Arguments.soloNULLs>
			   and TESDPtipoCambioOri is NULL
			   </cfif>
		</cfquery>
		<cfset sbAfectacionesTC(Arguments.TESOPid)>
	</cfif>

	<cfif LvarCambiarTCpago OR LvarCambiarTCori>
		<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set TESDPmontoAprobadoLocal 	= TESDPmontoAprobadoOri * TESDPtipoCambioOri
			<cfif LvarTCpago EQ 0>
				 , TESDPfactorConversion 	= 0
				 , TESDPmontoPago 			= 0
				 , TESDPmontoPagoLocal 		= 0
			<cfelse>
				 , TESDPfactorConversion 	= coalesce(TESDPtipoCambioOri / #LvarTCpago#, 0)
				 , TESDPmontoPago 			= coalesce(TESDPmontoAprobadoOri * TESDPtipoCambioOri / #LvarTCpago#, 0)
				 , TESDPmontoPagoLocal 		= coalesce(TESDPmontoAprobadoOri * TESDPtipoCambioOri, 0)
			</cfif>
			 where TESid 			= #session.Tesoreria.TESid#
			   and TESOPid 			= #Arguments.TESOPid#
			   and TESDPestado 	in (10,11)
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsTotal">
			select coalesce(sum(TESDPmontoPago), 0) as Total
			  from TESdetallePago
			 where TESid 			= #session.Tesoreria.TESid#
			   and TESOPid 			= #Arguments.TESOPid#
			   and TESDPestado in (10,11)
			   and RlineaId is null
		</cfquery>
	</cfif>

   	<cfif rsViejaCBid.CBidPago NEQ Arguments.CBidPago>
		<cfquery datasource="#session.dsn#" name="rsTESmedioPago">
			select TESMPcodigo
			  from TESmedioPago mp
			 where mp.TESid	= #session.Tesoreria.TESid#
			   and mp.CBid	= #Arguments.CBidPago#
		</cfquery>
	</cfif>

	<cfquery datasource="#session.dsn#">
		update TESordenPago
		   set CBidPago			= #Arguments.CBidPago#
		   	<cfif rsViejaCBid.CBidPago NEQ Arguments.CBidPago>
				<cfif rsTESmedioPago.recordCount EQ 1>
				 , TESMPcodigo = '#rsTESmedioPago.TESMPcodigo#'
				<cfelse>
				 , TESMPcodigo = null
				</cfif>
			</cfif>
			 , EcodigoPago		= #rsNuevaCBid.EcodigoPago#
			 , Miso4217Pago		= '#rsNuevaCBid.Miso4217Pago#'
		<cfif LvarCambiarTCpago OR LvarCambiarTCori>
			 , TESOPtotalPago 		= #rsTotal.Total#
			 , TESOPtipoCambioPago 	= #LvarTCpago#
		</cfif>
		 where TESid 			= #session.Tesoreria.TESid#
		   and TESOPid 			= #Arguments.TESOPid#
		   and TESOPestado in (10,11)
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update TESdetallePago
		   set EcodigoPago		= #rsNuevaCBid.EcodigoPago#
		 where TESid 			= #session.Tesoreria.TESid#
		   and TESOPid 			= #Arguments.TESOPid#
		   and TESDPestado in (10,11)
	</cfquery>
</cffunction>

<!--- Sincroniza el TC de las retenciones que debe ser el del documento --->
<cffunction name="sbAfectacionesTC" access="private" output="false">
	<cfargument name="TESOPid"	required="yes" type="numeric">

	<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set TESDPtipoCambioOri =
			   		(
						select TESDPtipoCambioOri
						  from TESdetallePago doc
						 where doc.TESDPid = TESdetallePago.RlineaId
					)
		 where TESid 			= #session.Tesoreria.TESid#
		   and TESOPid 			= #Arguments.TESOPid#
		   and TESDPestado 	in (10,11)
		   and RlineaId 	IS NOT  NULL
	</cfquery>

	<cfquery datasource="#session.dsn#">
			update TESdetallePago
			   set TESDPtipoCambioOri =
			   		(
						select TESDPtipoCambioOri
						  from TESdetallePago doc
						 where doc.TESDPid = TESdetallePago.MlineaId
					)
		 where TESid 			= #session.Tesoreria.TESid#
		   and TESOPid 			= #Arguments.TESOPid#
		   and TESDPestado 	in (10,11)
		   and MlineaId 	IS NOT  NULL
	</cfquery>
</cffunction>


