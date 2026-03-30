<cfcomponent output="no">

<cffunction name="PosteoPagosCxC" output="false" 	returntype="numeric">
	<cfargument name="Ecodigo" 		     type="numeric" 	default="#session.Ecodigo#">
	<cfargument name="CCTcodigo"  	     type="string" 		default="">
	<cfargument name="Pcodigo" 		     type="string" 		default="">
	<cfargument name="usuario" 		     type="string" 		default="#session.usuario#">
    <cfargument name="SNid" 		     type="string" 		default="">
	<cfargument name="Conexion" 	     type="string" 		default="#session.DSN#">
	<cfargument name="EAid" 		     type="numeric"		default="-1" required="no">
	<cfargument name='PintaAsiento'      type="boolean" 	required='false' default='false'>
    <cfargument name='transaccionActiva' type="boolean" 	required='false' default='false'>
    <cfargument name='INTARC'            type="string" 	    required='false' default=''>
    <cfargument name='IntPresup'         type="string" 	    required='false' default=''>
    <cfargument name='Tb_Calculo'        type="string" 	    required='true' default=''>

	<!--- MEG 05/11/2014 --->
	<!--- Si existe configurado un Repositorio de CFDIs --->
	<cfquery name="getContE" datasource="#Session.DSN#">
		select ERepositorio from Empresa
		where Ereferencia = #Session.Ecodigo#
	</cfquery>
	<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
		<cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
		<cfset dbname = LobjRepo.getnameDB(#session.Ecodigo#)>
		<cfset request.repodbname = "">
	<cfelse>
		<cfset request.repodbname = "">
	</cfif>
	<!--- MEG 05/11/2014 --->
        <cfif #Arguments.transaccionActiva#>
               <cfset sbAplicaProceso(#Arguments.Ecodigo#, #Arguments.CCTcodigo#,#Arguments.Pcodigo#,
			  #session.usuario#, #session.DSN#, #Arguments.EAid#,#Arguments.PintaAsiento#,#arguments.transaccionActiva#,#arguments.INTARC#,#arguments.SNid#,#arguments.Tb_Calculo#,#arguments.IntPresup#)>
         <cfelse>
            <cftransaction>
              <cfset sbAplicaProceso(#Arguments.Ecodigo#, #Arguments.CCTcodigo#, #Arguments.Pcodigo#,
							#session.usuario#, #session.DSN#, #Arguments.EAid#,#Arguments.PintaAsiento#,#arguments.transaccionActiva#,#arguments.INTARC#,#arguments.SNid#,#arguments.Tb_Calculo#,#arguments.IntPresup#)>
		     </cftransaction>
         </cfif>

	<cfreturn 1>
</cffunction>

<cffunction name="sbAfectacionIETU" access="public"  output="false">
	<cfargument name="Oorigen"		type="string"	required="yes" >
	<cfargument name="Ecodigo"		type="numeric"	required="yes" >
	<cfargument name='CCTcodigo'	type='string' 	required='true'>	 <!--- Codigo del movimiento ---->
	<cfargument name='Pcodigo' 		type='string' 	required='true'>	 <!--- Codigo del movimiento ---->
	<cfargument name="Efecha"		type="date"	required="yes" >
	<cfargument name="Eperiodo"		type="numeric"	required="yes" >
	<cfargument name="Emes"			type="numeric"	required="yes" >
	<cfargument name='Conexion' 	type='string' 	required='true'>

	<!---  1) Documentos de Pago --->
	<cfquery name="selectIETUpago" datasource="#Arguments.Conexion#">
		select 	e.Ecodigo as EcodigoPago ,
				1 as TipoPago, 	<!--- CxC --->
				<cf_dbfunction name="sPart"	args="e.CCTcodigo,1,2"> as ReferenciaPago,
				<cf_dbfunction name="sPart"	args="e.Pcodigo,1,20"> as DocumentoPago,

				e.Pfecha as FechaPago,

				sn.SNid,

				e.Mcodigo as McodigoPago,
				e.Ptotal as MontoPago,
				round(e.Ptotal * e.Ptipocambio,2) as MontoPagoLocal,
				0 as ReversarCreacion
			from Pagos e
				inner join SNegocios sn
					 on sn.Ecodigo  = e.Ecodigo
					and sn.SNcodigo = e.SNcodigo
			where e.Ecodigo		= #Arguments.Ecodigo#
			  and e.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and e.Pcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	</cfquery>
	<cfquery name="rsIETUpago" datasource="#Arguments.Conexion#">
		insert into #request.IETUpago# (
				EcodigoPago,TipoPago,ReferenciaPago,DocumentoPago,
				FechaPago,SNid,
				McodigoPago,MontoPago,MontoPagoLocal,
				ReversarCreacion
			)
			values
				(
				    #selectIETUpago.EcodigoPago#,
					#selectIETUpago.TipoPago#,
					'#selectIETUpago.ReferenciaPago#',
					'#selectIETUpago.DocumentoPago#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#selectIETUpago.FechaPago#">,
					#selectIETUpago.SNid#,
					#selectIETUpago.McodigoPago#,
					#selectIETUpago.MontoPago#,
					#selectIETUpago.MontoPagoLocal#,
					#selectIETUpago.ReversarCreacion#
				)
		<cf_dbidentity1 name="rsIETUpago" datasource="#Arguments.Conexion#">
	</cfquery>
	<cf_dbidentity2 name="rsIETUpago" datasource="#Arguments.Conexion#" returnvariable="ID_IETU">

	<!---  2) Documentos Afectados --->
	<cfquery datasource="#Arguments.Conexion#">
		insert into #request.IETUdocs# (
				ID,
				EcodigoDoc,TipoDoc,ReferenciaDoc,DocumentoDoc,
				OcodigoDoc,FechaDoc,
				TipoAfectacion,
				McodigoDoc,MontoAplicadoDoc,MontoBaseDoc,MontoBasePago,MontoBaseLocal,
				TESRPTCid,
				ReversarEnAplicacion
			)
		select 	#ID_IETU#,
				doc.Ecodigo,
				1,	<!--- CxC --->
				<cf_dbfunction name="sPart"	args="doc.CCTcodigo,1,2">,
				<cf_dbfunction name="sPart"	args="doc.Ddocumento,1,20">,
				doc.Ocodigo,
				doc.Dfecha,

				1,	<!--- Cobro por Venta: Aumento IETU --->

				doc.Mcodigo,
				round(d.DPmontodoc + coalesce(d.DPmontoretdoc,0.00),2),

				<!---
					Proporcion aplicado al documento sobre el (Total - Impuestos):
						MontoAplicado / Total * (Total-Impuestos)
				--->
				round((d.DPmontodoc + coalesce(d.DPmontoretdoc,0.00))	*
					coalesce(
						(
							select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
							  from ImpDocumentosCxC
							 where Ecodigo   = doc.Ecodigo
							   and CCTcodigo = doc.CCTcodigo
							   and Documento = doc.Ddocumento
						)
					, 1)
				,2),
				round((d.DPmontodoc + coalesce(d.DPmontoretdoc,0.00))	*
					coalesce(
						(
							select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
							  from ImpDocumentosCxC
							 where Ecodigo   = doc.Ecodigo
							   and CCTcodigo = doc.CCTcodigo
							   and Documento = doc.Ddocumento
						)
					, 1) / d.DPtipocambio
				,2),
				round((d.DPmontodoc + coalesce(d.DPmontoretdoc,0.00))	*
					coalesce(
						(
							select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
							  from ImpDocumentosCxC
							 where Ecodigo   = doc.Ecodigo
							   and CCTcodigo = doc.CCTcodigo
							   and Documento = doc.Ddocumento
						)
					, 1) / d.DPtipocambio * e.Ptipocambio
				,2),

				coalesce(doc.TESRPTCid,
					(
						select min(TESRPTCid) from TESRPTconcepto where CEcodigo=#session.CEcodigo# and TESRPTCcxc=1
					)
				),
				0
		from Pagos e
			inner join DPagos d
				inner join Documentos doc
				 on doc.Ecodigo		= d.Ecodigo
				and doc.CCTcodigo	= d.Doc_CCTcodigo
				and doc.Ddocumento	= d.Ddocumento

			 on d.Ecodigo	= e.Ecodigo
			and d.CCTcodigo	= e.CCTcodigo
			and d.Pcodigo	= e.Pcodigo
		where e.Ecodigo		= #Arguments.Ecodigo#
		  and e.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and e.Pcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	</cfquery>

	<!---  3) Generación de Anticipo de afectación Inmediata --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.IETUdocs# (
					ID,
					EcodigoDoc,TipoDoc,ReferenciaDoc,DocumentoDoc,
					OcodigoDoc,FechaDoc,
					TipoAfectacion,
					McodigoDoc,MontoAplicadoDoc,MontoBaseDoc,MontoBasePago,MontoBaseLocal,
					TESRPTCid,
					ReversarEnAplicacion
				)
			select 	#ID_IETU#,
					Anti.Ecodigo,
					1,	<!--- CxC --->
					<cf_dbfunction name="sPart"	args="Anti.NC_CCTcodigo,1,2">,
					<cf_dbfunction name="sPart"	args="Anti.NC_Ddocumento,1,20">,
					a.Ocodigo,
					a.Pfecha,
					1,	<!--- Anticipo por Venta: Aumento IETU --->
					a.Mcodigo,
					Anti.NC_total,
					Anti.NC_total,
					Anti.NC_total,
					round(Anti.NC_total * a.Ptipocambio,2),
					Anti.NC_RPTCid,
					1
			  from Pagos a
			  	inner join APagosCxC Anti
					on Anti.Ecodigo 	= a.Ecodigo
				   and Anti.CCTcodigo 	= a.CCTcodigo
				   and Anti.Pcodigo		= a.Pcodigo
			 where Anti.Ecodigo		= #Arguments.Ecodigo#
			   and Anti.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			   and Anti.Pcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
			   and Anti.NC_RPTCietu = 3
		</cfquery>
	<cfinvoke component="IETU" method="IETU_Afectacion" >
		<cfinvokeargument name="Ecodigo"	value="#Arguments.Ecodigo#">
		<cfinvokeargument name="Oorigen"	value="#Arguments.Oorigen#">
		<cfinvokeargument name="Efecha"		value="#Arguments.Efecha#">
		<cfinvokeargument name="Eperiodo"	value="#Arguments.Eperiodo#">
		<cfinvokeargument name="Emes"		value="#Arguments.Emes#">
		<cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
	</cfinvoke>
</cffunction>

<cffunction name="sbControlPresupuesto_PagosCxC" access="private">
	<cfargument name="Ecodigo"		type="numeric"	required="yes" >
	<cfargument name="Oorigen"		type="string"	required="yes" >
	<cfargument name="Pcodigo"		type="string"	required="yes" >
	<cfargument name="CCTcodigo"	type="string"	required="yes" >
	<cfargument name="Efecha"		type="date"		required="yes" >
	<cfargument name="Eperiodo"		type="numeric"	required="yes" >
	<cfargument name="Emes"			type="numeric"	required="yes" >
	<cfargument name='Conexion' 	type='string' 	required='true'>
<!--- Control Evento Inicia --->
    <cfargument name='NumeroEvento' type='string'	required='false' default="">
<!--- Control Evento Fin --->


	<!--- Genera los movimientos de Presupuesto en Efectivo (EJERCIDO Y PAGADO) a partir del NAP de las facturas pagadas --->
	<!--- Movimientos de EJERCIDO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
	<cfset rsSQL.Pvalor = getParametro(codigo=1140, conexion="#Arguments.Conexion#")>

	<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>
	<cfif LvarGenerarEjercido>
		<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'EJ')>
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>
	<cfelse>
		<!--- Movimientos de PAGADO: Presupuesto normal --->
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>
	</cfif>

	<cfset varCPCPagado_Anterior = getCPCPagado_Anterior(Arguments.Ecodigo , Arguments.CCTcodigo , Arguments.Pcodigo , Arguments.Eperiodo)>

	<!--- Genera las ejecuciones del Pago a partir del Asiento contable generado --->
	<cfinvoke component	= "PRES_Presupuesto" method= "ControlPresupuestarioINTARC" returnvariable	= "LvarIC">
				<cfinvokeargument name="ModuloOrigen"  		value="#Arguments.Oorigen#"/>
				<cfinvokeargument name="NumeroDocumento" 	value="#Arguments.Pcodigo#"/>
				<cfinvokeargument name="NumeroReferencia" 	value="#Arguments.CCTcodigo#"/>
				<cfinvokeargument name="FechaDocumento" 	value="#Arguments.Efecha#"/>
				<cfinvokeargument name="AnoDocumento"		value="#Arguments.Eperiodo#"/>
				<cfinvokeargument name="MesDocumento"		value="#Arguments.Emes#"/>
				<cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#"/>
				<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Intercompany" 		value="no"/>
				<cfinvokeargument name="BorrarIntPres" 		value="no"/>
<!--- Control Evento Inicia --->
        		<cfinvokeargument name='NumeroEvento' 		value="#Arguments.NumeroEvento#"/>
<!--- Control Evento Fin --->
<!--- Inicio PagoAñoAnteriores--->
        		<cfinvokeargument name='PagoAnoAnteriores' 		value="#varCPCPagado_Anterior#"/>
<!--- Fin PagoAñoAnteriores --->
	</cfinvoke>

	<cfset LvarNAP = LvarIC.NAP>
	<cfif LvarNAP LT 0>
		<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
	</cfif>
	<cfreturn LvarNAP>
</cffunction>

<cffunction name="sbPresupuestoAntsEfectivo_CxC" access="private">
	<cfargument name="Ecodigo">
	<cfargument name="Origen">
	<cfargument name="Pcodigo">
	<cfargument name="CCTcodigo">
	<cfargument name="Fecha">
	<cfargument name="Periodo">
	<cfargument name="Mes">
	<cfargument name="Anulacion">
	<cfargument name="TipoMov">

	<!--- Convierte las Ejecuciones del NAP de CxP a Pagado --->
	<!--- OJO, cuando se implemente Contabilizacion en Recepcion, hay que tomar en cuenta el NAP de la Recepción --->
	<cf_dbfunction name="to_char" args="sp.TESSPnumero" returnVariable="LvarTESSPnumero">
	<cfquery datasource="#session.DSN#">
		insert into #request.intPresupuesto#
			(
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				DocumentoPagado,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				NumeroLinea,
				NumeroLineaID,
				CFcuenta,
				Ocodigo,
				Mcodigo,
				MontoOrigen,
				TipoCambio,
				Monto,
				TipoMovimiento,
				NAPreferencia,	LINreferencia,
				PCGDid,
				PCGDcantidad
			)
		<!--- 'EJ/P:PAGADO' --->
		select  '#Arguments.Origen#',
				e.Pcodigo,
				e.CCTcodigo,
				<cf_dbfunction name="concat" args="'CxC: ';cc.CCTcodigo;'-';cc.Ddocumento" delimiters=";">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">,
				#Arguments.Periodo# as Periodo,
				#Arguments.Mes# as Mes,

				coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
				<cfif Arguments.TipoMov NEQ 'P'>-</cfif>nap.CPNAPnum*100000+nap.CPNAPDlinea as NumeroLineaID,
				nap.CFcuenta,																				<!--- CFuenta --->
				nap.Ocodigo,																				<!--- Oficina --->

					nap.Mcodigo,																				<!--- Mcodigo --->
					<cfif Arguments.Anulacion>-</cfif>round((d.DPmontodoc + d.DPmontoretdoc) / cc.Dtotal * nap.CPNAPDmontoOri,2) as MontoOrigen,
					case when round(d.DPmontodoc + d.DPmontoretdoc,2)!=0.00 then round((d.DPmontodoc + d.DPmontoretdoc) / d.DPtipocambio * e.Ptipocambio,2)/round(d.DPmontodoc + d.DPmontoretdoc,2) else 1 end as TC,
					round(
					<cfif Arguments.Anulacion>-</cfif>round((d.DPmontodoc + d.DPmontoretdoc) / cc.Dtotal * nap.CPNAPDmontoOri,2)
						* case when round(d.DPmontodoc + d.DPmontoretdoc,2)!=0.00 then round((d.DPmontodoc + d.DPmontoretdoc) / d.DPtipocambio * e.Ptipocambio,2)/round(d.DPmontodoc + d.DPmontoretdoc,2) else 1 end
					,2) as MontoLocal,

				'#Arguments.TipoMov#' as Tipo,
				nap.CPNAPnum, nap.CPNAPDlinea,
				nap.PCGDid,
				<cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
			from Pagos e
				inner join DPagos d
					on  d.Ecodigo   = e.Ecodigo
					and d.CCTcodigo = e.CCTcodigo
					and d.Pcodigo   = e.Pcodigo
				inner join HDocumentos cc
					on  cc.Ecodigo    = d.Ecodigo
					and cc.CCTcodigo  = d.Doc_CCTcodigo
					and cc.Ddocumento = d.Ddocumento
				inner join CPNAP nape
					  on nape.Ecodigo				= cc.Ecodigo
					 and nape.CPNAPmoduloOri		= 'CCFC'
					 and nape.CPNAPdocumentoOri		= cc.Ddocumento
					 and nape.CPNAPreferenciaOri	= cc.CCTcodigo
				inner join CPNAPdetalle nap
					  on nap.Ecodigo		= nape.Ecodigo
					 and nap.CPNAPnum		= nape.CPNAPnum
					 and nap.CPNAPDtipoMov = 'E'
			where e.Ecodigo   =   #Arguments.Ecodigo#
			  and e.CCTcodigo =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and e.Pcodigo   =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	</cfquery>
</cffunction>

<cffunction name="sbAplicaProceso" access="public">
   	<cfargument name="Ecodigo" 		     type="numeric" 	default="#session.Ecodigo#">
	<cfargument name="CCTcodigo"  	     type="string" 		default="">
	<cfargument name="Pcodigo" 		     type="string" 		default="">
	<cfargument name="usuario" 		     type="string" 		default="#session.usuario#">
	<cfargument name="Conexion" 	     type="string" 		default="#session.DSN#">
	<cfargument name="EAid" 		     type="numeric"		default="-1" required="no">
	<cfargument name='PintaAsiento'      type="boolean" 	required='false' default='false'>
    <cfargument name='transaccionActiva' type="boolean" 	required='false' default='false'>
    <cfargument name='INTARC'            type="string"   	default=''>
    <cfargument name='SNid'              type="numeric"   	default=''>
    <cfargument name='Tb_Calculo'        type="string"   	default=''>
    <cfargument name='IntPresup'         type="string"   	default=''>

	<!--- Control Evento Inicia --->
    <!---Obtiene el socio de negocios--->
    <cfquery name="rsSocioPago" datasource="#Arguments.Conexion#">
    	select SNcodigo
        from SNegocios
        where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
    </cfquery>
    <!--- Valido el evento --->
    <cfinvoke
        component		= "sif.Componentes.CG_ControlEvento"
        method			= "ValidaEvento"
        Origen			= "CCRE"
        Transaccion		= "#Arguments.CCTcodigo#"
        Conexion		= "#Arguments.Conexion#"
        Ecodigo			= "#Arguments.Ecodigo#"
        returnvariable	= "varValidaEvento"
        />
    <cfset varNumeroEvento = "">
    <cfif varValidaEvento GT 0>
        <cfinvoke
            component		= "sif.Componentes.CG_ControlEvento" method			= "CG_GeneraEvento"
            Origen			= "CCRE" Transaccion		= "#Arguments.CCTcodigo#"  Documento = "#Arguments.Pcodigo#"
            SocioCodigo		= "#rsSocioPago.SNcodigo#" Conexion		= "#Arguments.Conexion#"
            Ecodigo			= "#Arguments.Ecodigo#"  returnvariable	= "arNumeroEvento" />
       <cfif arNumeroEvento[3] EQ "">
            <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
        </cfif>
        <cfset varNumeroEvento = arNumeroEvento[3]>
        <cfset varIDEvento = arNumeroEvento[4]>
        <!--- Genera la relacion con las Facturas Aplicadas --->
        <cfquery name="rsDPagosCxC" datasource="#Arguments.Conexion#">
            select DPid,Doc_CCTcodigo,Ddocumento
            from DPagos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
               and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
               and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>
		
        <cfloop query="rsDPagosCxC">
            <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_RelacionaEvento"
                IDNEvento       = "#varIDEvento#"
                Ecodigo			= "#Arguments.Ecodigo#"
                Origen			= "CCFC"
                Transaccion		= "#rsDPagosCxC.Doc_CCTcodigo#"
                Documento 		= "#rsDPagosCxC.Ddocumento#"
                SocioCodigo		= "#rsSocioPago.SNcodigo#"
                Conexion		= "#Arguments.Conexion#"
                returnvariable	= "arRelacionEvento"
                />
                <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
					<cfset varNumeroEventoDP = arRelacionEvento[4]>
                <cfelse>
                    <cfset varNumeroEventoDP = varNumeroEvento>
                </cfif>
            <cfquery datasource="#Arguments.Conexion#">
                update DPagos
                set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
                 where Ecodigo	= #Arguments.Ecodigo#
                   and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                   and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                   and DPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDPagosCxC.DPid#">
            </cfquery>
        </cfloop>
    </cfif>
 	<!--- Control Evento Fin --->

    <cfif isdefined('arguments.INTARC') and len(trim(arguments.INTARC)) gt 0>
 	   <cfset INTARC = arguments.INTARC>
	</cfif>

    <cfif isdefined('arguments.IntPresup') and len(trim(arguments.IntPresup)) gt 0>
 	   <cfset IntPresup = arguments.IntPresup>
	</cfif>

      <cfset CntlDebug = "N">
	<cfset LvarPintar = Arguments.PintaAsiento>

	<!---====Periodo Auxiliar===============--->
	<cfset rsPeriodo.Periodo = getParametro(codigo=50, conexion="#Arguments.Conexion#",ecodigo=arguments.ecodigo)>
	<cfif rsPeriodo.Periodo EQ "">
		<cfthrow detail="La empresa no tiene definido un Periodo Auxiliar">
	</cfif>
	<cfset varPeriodo = rsperiodo.Periodo>
	<!---====Mes Auxiliar=====================--->
	<cfset rsmes.mes = getParametro(codigo=60, conexion="#Arguments.Conexion#",ecodigo=arguments.ecodigo)>
	<cfif rsmes.mes EQ "">
		<cfthrow detail="La empresa no tiene definido un Mes Auxiliar">
	</cfif>
	<cfset varmes = rsmes.mes>
	<!---====Moneda local de la Empresa========--->
	<cfquery datasource="#Arguments.Conexion#" name="rsMonedaLocal">
		select Mcodigo as MonLoc
		from Empresas
		where Ecodigo = #Arguments.Ecodigo#
	</cfquery>
	<cfif rsMonedaLocal.recordcount EQ 0>
		<cfthrow detail="La empresa no tiene definida una Moneda Local">
	</cfif>
	<cfset varmonedaloc = rsMonedaLocal.MonLoc>
	<!---====Cuenta Contable de Retenciones====--->
	<cfquery datasource="#Arguments.Conexion#" name="rsCuentaRet">
		select Pvalor as CuentaRet
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = 150
	</cfquery>
	<cfif rsCuentaRet.recordcount EQ 0>
		<cfthrow detail="La empresa no tiene definida una Cuenta Contable de Retenciones">
	</cfif>
	<!---====Cuenta contable multimoneda=====--->
	<cfquery datasource="#Arguments.Conexion#" name="rsCuentaPuente">
		select Pvalor as CuentaPuente
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = 200
	</cfquery>
	<cfif rsCuentaPuente.recordCount EQ 0>
		<cfthrow detail="La empresa no tiene definida una Cuenta Multimoneda">
	</cfif>
	<!---====Cuenta de Interes Corriente=====--->
	<cfquery datasource="#Arguments.Conexion#" name="rsCuentaInteresCorriente">
		select Pvalor as CuentaInteresCorriente
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = 550
	</cfquery>
	 <cfif rsCuentaInteresCorriente.recordcount LT 1 or len(trim(rsCuentaInteresCorriente.CuentaInteresCorriente)) eq 0>
		<cf_errorCode	code = "51004" msg = "No se ha definido la Cuenta de Interes Corriente! Proceso Cancelado!">
		<cfreturn 0>
	<cfelseif not isnumeric(rsCuentaInteresCorriente.CuentaInteresCorriente)>
		<cf_errorCode	code = "51005" msg = "El valor Cuenta de Interes Corriente no es un dígito numérico! Proceso Cancelado!">
		<cfreturn 0>
	</cfif>
	<!---====Cuenta de Interes Moratorio=====--->
	<cfquery datasource="#Arguments.Conexion#" name="rsCuentaInteresMoratorio">
		select Pvalor as CuentaInteresMoratorio
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = 560
	</cfquery>
	<cfif rsCuentaInteresMoratorio.recordcount LT 1 or len(trim(rsCuentaInteresMoratorio.CuentaInteresMoratorio)) eq 0>
		<cf_errorCode	code = "51006" msg = "No se ha definido la Cuenta de Interes Moratorio! Proceso Cancelado!">
		<cfreturn 0>
	<cfelseif not isnumeric(rsCuentaInteresMoratorio.CuentaInteresMoratorio)>
		<cf_errorCode	code = "51007" msg = "El valor Cuenta de Interes Moratorio no es un dígito numérico! Proceso Cancelado!">
		<cfreturn 0>
	</cfif>
	<!---======Diferencial Cambiario========--->
	<cfquery name="rsCuentaDifCam1" datasource="#Arguments.Conexion#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 110
	</cfquery>
	<cfquery name="rsCuentaDifCam2" datasource="#Arguments.Conexion#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = 120
	</cfquery>
	<!---======Valida que el Documento de cobro Exista==========--->
	 	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoEncabezado" returnvariable="rsPagos">
			<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
			<cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
			<cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
			<cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
		</cfinvoke>
    <cfif rsPagos.recordCount LT 1>
		<cf_errorCode	code = "51009" msg = "El Recibo de Pago indicado no existe! Proceso Cancelado!">
		<cfreturn 0>
	</cfif>
       	<cf_dbfunction name="to_char"	args="p.Pfecha"  returnvariable="Pfecha">
        <cf_dbfunction name="to_char"	args="d.Dfecha"  returnvariable="Dfecha">
        <cf_dbfunction name="date_format" args="p.Pfecha,dd-mm-yyyy" returnvariable="LvarPfecha">
        <cf_dbfunction name="date_format" args="d.Dfecha,dd-mm-yyyy" returnvariable="LvarDfecha">

	<!--- ABG. Se modifica ya que la comparacion de fechas es erronea --->
	<!---====Valida Fecha del Cobro contra fecha de Facturas====--->
	<cfif getValidaPagos(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo) GT 0>
		<cf_errorCode	code = "51008" msg = "El documento afectado no puede tener la fecha menor a la fecha del recibo de pago! Proceso Cancelado!">
		<cfreturn 0>
	</cfif>
	<!---Obtiene las Sumatorias de el Pago y los Anticipos--->
	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoTotales" returnvariable="rsAPagosCxCTotal">
		<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
		<cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
		<cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
		<cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
	</cfinvoke>

	<cflock name="CCPosteoPagosCxC#session.Ecodigo#" timeout="20" type="exclusive">

	<!----======= valida si hay que concatenar el Socio de Negocio a las polizas  =======--->
		<cfquery name="rsConcatenar" datasource="#Arguments.Conexion#">
			select coalesce(Pvalor,'0') as valor
			from Parametros
			Where Ecodigo =  #Arguments.Ecodigo#
				and Pcodigo = 2920
		</cfquery>
		<cfif rsConcatenar.valor eq '1'>
			<cfset LvarSocioNegocio ="-SN:#rsPagos.SNnumero#">
		<cfelse>
			<cfset LvarSocioNegocio ="">
		</cfif>
		<cfset LvarFecha     = now()>
		<cfset LvarFechaCar  = DateFormat(now(), 'DD/MM/YYYY')>
		<cfset LvarFechaCar  = right(LvarFechaCar, 4) & mid(LvarFechaCar, 4, 2) & left(LvarFechaCar, 2)>
		<cfset LvarDescripcion = "Pagos CxC: "&Arguments.CCTcodigo&" "&Arguments.Pcodigo>
	<!---===Valida que el Documento este balaneado=====--->
	<cfif NumberFormat((#rsPagos.Ptotal# - #rsAPagosCxCTotal.TotalAnticipos# - #rsAPagosCxCTotal.TotalCubierto#),',9.00') NEQ 0.00>
		<cfset RestTotal = #rsPagos.Ptotal# - #rsAPagosCxCTotal.TotalAnticipos# - #rsAPagosCxCTotal.TotalCubierto#>
		<cf_errorCode	code = "51010"
						msg  = "El Documento de Pago no se encuentra en Balance: Encabezado: @errorDat_1@ Detalles: @errorDat_2@ Anticipo: @errorDat_3@ La resta del encabezado - el anticipo - el monto del detalle es igual a: @errorDat_4@ !"
						errorDat_1="#NumberFormat(rsPagos.Ptotal, ',9.00')#"
						errorDat_2="#NumberFormat(rsAPagosCxCTotal.TotalCubierto, ',9.00')#"
						errorDat_3="#NumberFormat(rsAPagosCxCTotal.TotalAnticipos, ',9.00')#"
						errorDat_4="#NumberFormat((RestTotal),',9.00')#"
		>
		<cfreturn 0>
	</cfif>
<!---<!---Valida que el Anticipo no exista en en Histórico de Documentos de CxC, busca por HDocumentos_AK01  Ddocumento, CCTcodigo, Ecodigo--->
		<cfquery name="rsValidaH" datasource="#Arguments.Conexion#">
			select Anti.NC_CCTcodigo, Anti.NC_Ddocumento
			 from Pagos a
				inner join APagosCxC Anti
					 on a.Ecodigo   = Anti.Ecodigo
					and a.CCTcodigo = Anti.CCTcodigo
					and a.Pcodigo	= Anti.Pcodigo
				inner join HDocumentos b
					 on b.Ddocumento = Anti.NC_Ddocumento
					and b.CCTcodigo  = Anti.NC_CCTcodigo
					and b.Ecodigo  	 = a.Ecodigo
			 where a.Ecodigo = #Arguments.Ecodigo#
		       and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		       and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfif isdefined("rsValidaH") and rsValidaH.recordcount GT 0>
				<cfset ErrorAnti = ''>
			<cfloop query="rsValidaH">
				<cfset ErrorAnti &= rsValidaH.NC_CCTcodigo &' '& rsValidaH.NC_Ddocumento &','>
			</cfloop>
				<cfthrow message="Los siguiente Anticipos ya existen en el histórico de Documentos de CxC(HDocumentos):<br>" detail="#mid(ErrorAnti,1,len(ErrorAnti)-1)#">
			<cf_abort errorInterfaz="">
		</cfif>--->
<!---Valida que el Anticipo no exista en los Documentos de CxC, busca por Documentos_PK Ecodigo, CCTcodigo, Ddocumento--->
		<cfquery name="rsValida" datasource="#Arguments.Conexion#">
			select Anti.NC_CCTcodigo, Anti.NC_Ddocumento
			 from Pagos a
				inner join APagosCxC Anti
					 on a.Ecodigo   = Anti.Ecodigo
					and a.CCTcodigo = Anti.CCTcodigo
					and a.Pcodigo	= Anti.Pcodigo
				inner join Documentos b
					 on b.Ddocumento = Anti.NC_Ddocumento
					and b.CCTcodigo  = Anti.NC_CCTcodigo
					and b.Ecodigo  	 = a.Ecodigo
			 where a.Ecodigo = #Arguments.Ecodigo#
		       and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		       and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfif isdefined("rsValida") and rsValida.recordcount GT 0>
				<cfset ErrorAnti = ''>
			<cfloop query="rsValida">
				<cfset ErrorAnti &= rsValida.NC_CCTcodigo &' '& rsValida.NC_Ddocumento &','>
			</cfloop>
				<cfthrow message="Los siguiente Anticipos ya existen en los Documentos de CxC (Documentos):<br>" detail="#mid(ErrorAnti,1,len(ErrorAnti)-1)#">
		</cfif>

		<cfif #Arguments.transaccionActiva#  eq 'false' and len(trim(#arguments.INTARC#)) eq 0>
        	  <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
        </cfif>

<cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#Arguments.Conexion#"></cfinvoke>

	<cfquery name="rsDPagos" datasource="#Arguments.Conexion#">
		select distinct a.Ecodigo, a.Doc_CCTcodigo, a.Ddocumento
		from  DPagos  a
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	</cfquery>
	<cfquery name="rsDPagosICF" datasource="#Arguments.Conexion#">
		select distinct a.Ecodigo, a.Doc_CCTcodigo, a.Ddocumento
		from  DPagos  a
			inner join ImpDocumentosCxC b
				on  b.Ecodigo   = a.Ecodigo
				and b.CCTcodigo = a.Doc_CCTcodigo
				and b.Documento = a.Ddocumento
		where a.Ecodigo = #Arguments.Ecodigo#
		  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	</cfquery>

	<cfquery name="rsDPagosPP" datasource="#Arguments.Conexion#">
		select a.Ecodigo, a.Doc_CCTcodigo, a.Ddocumento, a.PPnumero, a.DPmontodoc,  coalesce(a.DPmontoretdoc,0.00) as DPmontoretdoc
		from DPagos a
		where a.Ecodigo   = #Arguments.Ecodigo#
		  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		  and a.PPnumero is not null
	</cfquery>
	<!--- IEPS COMPONENTE --->
	<cfset LvarIEPSCxC = PagoIEPSCxC (
							Arguments.Ecodigo, Arguments.CCTcodigo, Arguments.Pcodigo, Arguments.Conexion, Arguments.INTARC)>
	<!--- IEPS COMPONENTE FIN --->
	
			<cfif rsDPagosICF.Recordcount GT 0>
				<!--- Generar el Asiento Contable por los montos de Impuesto Crédito Fiscal --->
				<!--- Monto original:  (Monto Pagado + Monto Retenido) / Total de Documento * Impuesto   en la moneda de la factura                     --->
				<!--- Monto local:     (Monto Pagado + Monto Retenido) / Total de Documento * Impuesto * Factor de Conversion * Tipo de Cambio del pago --->
				<cfquery datasource="#Arguments.Conexion#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
					select
					'CCFC',
					1,
					c.Documento,
					c.CCTcodigo ,
					round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
					d.CCTtipo,
					i.Idescripcion,
					<cf_dbfunction name="to_sdate" args="#now()#">,
					a.Ptipocambio / b.DPtipocambio,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					c.CcuentaImp,
					b.Mcodigo,
					doc.Ocodigo,
					round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2),
            b.NumeroEvento,a.CFid
					from Pagos a
						inner join DPagos  b
							inner join Documentos doc
								inner join CCTransacciones d
								on  d.Ecodigo    = doc.Ecodigo
								and d.CCTcodigo  = doc.CCTcodigo
								inner join ImpDocumentosCxC c
									inner join Impuestos i
									on c.Ecodigo = i.Ecodigo
									and c.Icodigo = i.Icodigo
									and i.CcuentaCxCAcred is not null
								on  c.Ecodigo = doc.Ecodigo
								and c.CCTcodigo  = doc.CCTcodigo
								and c.Documento = doc.Ddocumento
							on doc.Ecodigo = b.Ecodigo
							and doc.CCTcodigo = b.Doc_CCTcodigo
							and doc.Ddocumento = b.Ddocumento
						on a.Ecodigo = b.Ecodigo
						and a.CCTcodigo = b.CCTcodigo
						and a.Pcodigo = b.Pcodigo
					where a.Ecodigo = #Arguments.Ecodigo#
					  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and c.TotalFac <> 0.00
					  and c.MontoCalculado <> 0
				</cfquery>

				<!--- El impuesto se traslada en moneda local, al tipo de cambio del pago --->
				<!--- Monto local:     (Monto Pagado + Monto Retenido) / Total de Documento * Impuesto * Factor de Conversion * Tipo de Cambio del pago --->
				<cfquery datasource="#Arguments.Conexion#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
					select
					'CCFC',
					1,
					c.Documento,
					c.CCTcodigo ,
					round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
					case when d.CCTtipo = 'D' then 'C' else 'D' end,
					i.Idescripcion,
					<cf_dbfunction name="to_sdate" args="#now()#">,
					1,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					coalesce(i.CcuentaCxCAcred,i.Ccuenta),
					#rsMonedaLocal.MonLoc#,
					a.Ocodigo,
					round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
            b.NumeroEvento,a.CFid
					from Pagos a
						inner join DPagos  b
							inner join ImpDocumentosCxC c
								inner join CCTransacciones d
								on d.Ecodigo = c.Ecodigo
								and d.CCTcodigo = c.CCTcodigo

								inner join Impuestos i
								on  i.Ecodigo  = c.Ecodigo
								and i.Icodigo  = c.Icodigo
								and i.CcuentaCxCAcred is not null

							on c.Ecodigo = b.Ecodigo
							and c.CCTcodigo = b.Doc_CCTcodigo
							and c.Documento = b.Ddocumento

						on  b.Ecodigo   = a.Ecodigo
						and b.CCTcodigo = a.CCTcodigo
						and b.Pcodigo   = a.Pcodigo

					where a.Ecodigo 	= #Arguments.Ecodigo#
					  and a.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and c.TotalFac <> 0.00
					  and c.MontoCalculado <> 0
				</cfquery>
				<!--- fin --->
			</cfif>
			<!---
			2) Asiento Contable
			2a) Débito: Monto Recibo de Dinero
			--->
            <cfquery name="rsTipoPago" datasource="#session.dsn#">
                 select CCTcktr as tipo from CCTransacciones
                     where Ecodigo = #session.Ecodigo#
                     and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
            </cfquery>

            <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
             select  Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>
            <cfset LvarMonloc = rsMonedaLoc.Mcodigo>

           <cfquery name="rsDatos" datasource="#session.dsn#">
            select Ptipocambio, Ddocumento ,Doc_CCTcodigo
            from Pagos e
                 inner join DPagos p
                   on e.CCTcodigo  = p.CCTcodigo
                   and e.Pcodigo   = p.Pcodigo
			where e.Ecodigo   =   #Arguments.Ecodigo#
			  and e.CCTcodigo =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and e.Pcodigo   =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
           </cfquery>

            <cfquery name="rsEsTransitoria" datasource="#session.dsn#">
	                select b.DesTransitoria
	            		from Pagos e
	                 inner join DPagos p
	                   on e.CCTcodigo  = p.CCTcodigo
	                   and e.Pcodigo   = p.Pcodigo
	                 inner join DDocumentos b
	                 on p.Doc_CCTcodigo = b.CCTcodigo
	                 and p.Ddocumento = b.Ddocumento
				where e.Ecodigo   =   #Arguments.Ecodigo#
				  and e.CCTcodigo =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and e.Pcodigo   =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and b.DesTransitoria = 1
            </cfquery>

        	<cfif isdefined('rsEsTransitoria') and len(trim(#rsEsTransitoria.DesTransitoria#)) gt 0>
              <cfif rsEsTransitoria.DesTransitoria eq 1>
                 <cfinvoke component="sif.componentes.FA_CuentasTransitorias" method="FA_cuentastransitorias" returnvariable="incos">
                       <cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
                       <cfinvokeargument name="conexion"	Value="#session.dsn#"/>
                       <cfinvokeargument name="SNid"	    value="#arguments.SNid#"/>
                       <cfinvokeargument name="incos"	    value="#arguments.Tb_Calculo#"/>
                       <cfinvokeargument name="TIPO"	    value="CO"/>
                       <cfinvokeargument name="ETtc"	    value="#rsDatos.Ptipocambio#"/>
                       <cfinvokeargument name="Monloc"	    value="#LvarMonloc#"/>
                       <cfinvokeargument name="CCTcodigo"	value="#Arguments.CCTcodigo#"/>
                       <cfinvokeargument name="Pcodigo"	    value="#Arguments.Pcodigo#"/>
                       <cfinvokeargument name="Ddocumento"	value="#rsDatos.Ddocumento#"/>
                       <cfinvokeargument name="INTARC"	    value="#INTARC#"/>
                 </cfinvoke>
               </cfif>
            </cfif>
            <cfif rsDatos.recordcount GT 0>
	            <cfinvoke component="sif.fa.operacion.CostosAuto" method="Cons_CostosIngresos" returnvariable="incos">
	                       <cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
	                       <cfinvokeargument name="SNid"	    value="#arguments.SNid#"/>
	                       <cfinvokeargument name="incos"	    value="#arguments.Tb_Calculo#"/>
	                       <cfinvokeargument name="TIPO"	    value="FA"/>
	                       <cfinvokeargument name="ETtc"	    value="#rsDatos.Ptipocambio#"/>
	                       <cfinvokeargument name="Monloc"	    value="#LvarMonloc#"/>
	                       <cfinvokeargument name="CCTcodigo"	value="#Arguments.CCTcodigo#"/>
	                       <cfinvokeargument name="Pcodigo"	    value="#Arguments.Pcodigo#"/>
	                       <cfinvokeargument name="INTARC"	    value="#INTARC#"/>
				</cfinvoke>
			</cfif>
			
            <cfif isdefined('rsTipoPago') and rsTipoPago.tipo eq 'P'>
                <!--- 2) Crédito: Documentos Afectados --->
     			<cfquery datasource="#Arguments.Conexion#" name="rsKK">
                        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
                        select
                        'CCRE',
                        1,
                        a.Ddocumento,
                        a.Doc_CCTcodigo,
                        case when coalesce(a.DPmontoretdoc,0.00) <> 0.00
                            then round((a.DPmontodoc + a.DPmontoretdoc - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) / a.DPtipocambio * b.Ptipocambio,2)
                            else round((a.DPtotal - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) * b.Ptipocambio,2)
                        end,
                        'D',
                        <cf_dbfunction name="concat" args="'CxC: Pago con Tarjeta :',b.Preferencia">,
                        '#LvarFechaCar#',
                        case when round(a.DPmontodoc + a.DPmontoretdoc,2) <> 0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * b.Ptipocambio,2) / round(a.DPmontodoc + a.DPmontoretdoc,2) else 1 end,
                        #rsPeriodo.Periodo#,
                        #rsmes.Mes#,
                        case when b.CobroCRC = 1 then c.Ccuenta else b.Ccuenta end,
                        c.Mcodigo,
                        b.Ocodigo,
                        round(
                            case
                                when coalesce(a.DPmontoretdoc,0.00) <> 0.00
                                then round(a.DPmontodoc + a.DPmontoretdoc - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2)
                                else
                                    round(a.DPmontodoc - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2)
                                end
                            ,2),
						a.NumeroEvento,b.CFid
                        from Pagos b
                            inner join DPagos a

                                inner join Documentos c
                                on a.Ecodigo = c.Ecodigo
                                and a.Doc_CCTcodigo = c.CCTcodigo
                                and a.Ddocumento = c.Ddocumento

                                left outer join PlanPagos pp
                                on pp.Ecodigo = a.Ecodigo
                                and pp.CCTcodigo = a.Doc_CCTcodigo
                                and pp.Ddocumento = a.Ddocumento
                                and pp.PPnumero = a.PPnumero

                            on a.Ecodigo = b.Ecodigo
                            and a.CCTcodigo = b.CCTcodigo
                            and a.Pcodigo = b.Pcodigo
                        where b.Ecodigo = #Arguments.Ecodigo#
                          and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                          and b.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					</cfquery>
           <cfelse>
			<cfquery datasource="#Arguments.Conexion#" name="rsLL">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid) 
				select distinct
					'CCRE',
					1,
					a.Pcodigo,
					a.CCTcodigo,
					round(a.Ptotal * a.Ptipocambio,2),
					'D',
					<cf_dbfunction name="concat" args="'CxC: Recibo de Pago ',b.Pcodigo,'#LvarSocioNegocio#'">,
					'#LvarFechaCar#',
					a.Ptipocambio,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					case when a.CobroCRC = 1 then c.Ccuenta else a.Ccuenta end,
					a.Mcodigo,
					a.Ocodigo,
					a.Ptotal,
    				<cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEvento#">,
                    a.CFid
				from Pagos a
				inner join DPagos b
				inner join Documentos c
					on 	b.Ecodigo       = c.Ecodigo
						and b.Doc_CCTcodigo = c.CCTcodigo
						and b.Ddocumento    = c.Ddocumento
					on  a.Ecodigo = b.Ecodigo
						and a.CCTcodigo = b.CCTcodigo
						and a.Pcodigo = b.Pcodigo
				where a.Ecodigo = #Arguments.Ecodigo#
				  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
			</cfquery>
			
		   </cfif>
		   
			<!--- 2b) Débito : Cálculo de la Retención x Documento --->
			<cfquery datasource="#arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
					'CCRE',
					1,
					a.Ddocumento,
					a.Doc_CCTcodigo,
					round(a.DPmontoretdoc * case when round(a.DPmontodoc + a.DPmontoretdoc,2) <> 0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * b.Ptipocambio,2) / round(a.DPmontodoc + a.DPmontoretdoc,2) else 1 end,2),
					'D',
					<cf_dbfunction name="concat" args="'CxC: Retención Documento ',a.Doc_CCTcodigo,'-',a.Ddocumento">,
					'#LvarFechaCar#',
					case when round(a.DPmontodoc + a.DPmontoretdoc,2) <> 0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * b.Ptipocambio,2) / round(a.DPmontodoc + a.DPmontoretdoc,2) else 1 end,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					#rsCuentaRet.CuentaRet#,
					c.Mcodigo,
					b.Ocodigo,
					a.DPmontoretdoc,
    				a.NumeroEvento,
                    b.CFid
				from Pagos b
					inner join DPagos a
						inner join Documentos c
						on 	a.Ecodigo       = c.Ecodigo
						and a.Doc_CCTcodigo = c.CCTcodigo
						and a.Ddocumento    = c.Ddocumento
					on  a.Ecodigo = b.Ecodigo
					and a.CCTcodigo = b.CCTcodigo
					and a.Pcodigo = b.Pcodigo
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and b.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and c.Rcodigo is not null
			</cfquery>

			<!--- 2c) Crédito: Documentos Afectados --->
			<cfquery datasource="#Arguments.Conexion#" name="rsKK">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
				'CCRE',
				1,
				a.Ddocumento,
				a.Doc_CCTcodigo,
				case when coalesce(a.DPmontoretdoc,0.00) <> 0.00
					then round((a.DPmontodoc + a.DPmontoretdoc - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) / a.DPtipocambio * b.Ptipocambio,2)
					else round((a.DPtotal - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) * b.Ptipocambio,2)
				end,
				'C',
				<cf_dbfunction name="concat" args="'CxC: Pago Documento ',a.Doc_CCTcodigo,'-',a.Ddocumento,'#LvarSocioNegocio#'">,
				'#LvarFechaCar#',
				case when round(a.DPmontodoc + a.DPmontoretdoc,2) <> 0.00 then round((a.DPmontodoc + a.DPmontoretdoc) / a.DPtipocambio * b.Ptipocambio,2) / round(a.DPmontodoc + a.DPmontoretdoc,2) else 1 end,
				#rsPeriodo.Periodo#,
				#rsmes.Mes#,
				c.Ccuenta,
				c.Mcodigo,
				b.Ocodigo,
				round(
					case
						when coalesce(a.DPmontoretdoc,0.00) <> 0.00
						then round(a.DPmontodoc + a.DPmontoretdoc - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2)
						else
							round(a.DPmontodoc - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2)
						end
					,2),
    				a.NumeroEvento,b.CFid

				from Pagos b
					inner join DPagos a

						inner join Documentos c
						on a.Ecodigo = c.Ecodigo
						and a.Doc_CCTcodigo = c.CCTcodigo
						and a.Ddocumento = c.Ddocumento

						left outer join PlanPagos pp
						on pp.Ecodigo = a.Ecodigo
						and pp.CCTcodigo = a.Doc_CCTcodigo
						and pp.Ddocumento = a.Ddocumento
						and pp.PPnumero = a.PPnumero

					on a.Ecodigo = b.Ecodigo
					and a.CCTcodigo = b.CCTcodigo
					and a.Pcodigo = b.Pcodigo
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and b.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
			</cfquery>


			<!--- 2c-1) Crédito: Documentos Afectados - interes corriente --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
					'CCRE',
					1,
					a.Ddocumento,
					a.Doc_CCTcodigo,
					round(pp.PPpagointeres / a.DPtipocambio * b.Ptipocambio,2),
					'C',
					<cf_dbfunction name="concat" args="'CxC: Interes Corriente Documento ',a.Doc_CCTcodigo ,'-',a.Ddocumento">,
					'#LvarFechaCar#',
					round(pp.PPpagointeres / a.DPtipocambio * b.Ptipocambio,2) / round(pp.PPpagointeres,2),
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					#rsCuentaInteresCorriente.CuentaInteresCorriente#,
					c.Mcodigo,
					b.Ocodigo,
					pp.PPpagointeres,
    				a.NumeroEvento,b.CFid
				from Pagos b
					inner join DPagos a
						inner join Documentos c
						on a.Ecodigo = c.Ecodigo
						and a.Doc_CCTcodigo = c.CCTcodigo
						and a.Ddocumento = c.Ddocumento

						inner join PlanPagos pp
						on pp.Ecodigo = a.Ecodigo
						and pp.CCTcodigo = a.Doc_CCTcodigo
						and pp.Ddocumento = a.Ddocumento
						and pp.PPnumero = a.PPnumero

					on a.Ecodigo = b.Ecodigo
					and a.CCTcodigo = b.CCTcodigo
					and a.Pcodigo = b.Pcodigo
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and b.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and pp.PPpagointeres is not null
				  and round(pp.PPpagointeres,2) <> 0
			</cfquery>

			<!--- 2c -2) Crédito: Documentos Afectados - interes mora --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
					'CCRE',
					1,
					a.Ddocumento,
					a.Doc_CCTcodigo,
					round(pp.PPpagomora / a.DPtipocambio * b.Ptipocambio,2),
					'C',
					<cf_dbfunction name="concat" args="'CxC: Inters Moratorio Documento ',a.Doc_CCTcodigo ,'-',a.Ddocumento">,
					'#LvarFechaCar#',
					round(pp.PPpagomora / a.DPtipocambio * b.Ptipocambio,2) / round(pp.PPpagomora,2),
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					#rsCuentaInteresMoratorio.CuentaInteresMoratorio#,
					c.Mcodigo,
					b.Ocodigo,
					pp.PPpagomora,
    				a.NumeroEvento,
                    b.CFid
				from Pagos b
					inner join DPagos a
						inner join Documentos c
						on a.Ecodigo = c.Ecodigo
						and a.Doc_CCTcodigo = c.CCTcodigo
						and a.Ddocumento = c.Ddocumento

						inner join PlanPagos pp
						on  pp.Ecodigo    = a.Ecodigo
						and pp.CCTcodigo  = a.Doc_CCTcodigo
						and pp.Ddocumento = a.Ddocumento
						and pp.PPnumero   = a.PPnumero

					on a.Ecodigo = b.Ecodigo
					and a.CCTcodigo = b.CCTcodigo
					and a.Pcodigo = b.Pcodigo
				where b.Ecodigo = #Arguments.Ecodigo#
				  and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and b.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and pp.PPpagomora is not null
				  and round(pp.PPpagomora,2) <> 0
			</cfquery>

			<!--- 2d) Crédito: Anticipos  --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, INTMOE, INTMON, Mcodigo, INTCAM, NumeroEvento,CFid)
					select
						'CCRE',
						1,
						a.Pcodigo,
						a.CCTcodigo,
						'C',
						<cf_dbfunction name="concat" args="'CxC: ',d.NC_CCTcodigo,'-',d.NC_Ddocumento,'-',a.Pcodigo">,
						'#LvarFechaCar#',
						#rsPeriodo.Periodo#,
						#rsmes.Mes#,
						coalesce (d.NC_Ccuenta,<cf_dbfunction name="to_number" args="c.Pvalor">),
						a.Ocodigo,
						coalesce(d.NC_total,0.00),
						round(coalesce(d.NC_total,0.00) * a.Ptipocambio,2),
						a.Mcodigo,
						case when a.Mcodigo <> #rsMonedaLocal.MonLoc# then a.Ptipocambio else 1 end,
    					<cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEvento#">,
						a.CFid
					from Pagos a
						inner join Parametros c
							on c.Ecodigo = a.Ecodigo
					  	   and c.Pcodigo = 180
						inner join APagosCxC d
							on d.Ecodigo   = a.Ecodigo
						   and d.CCTcodigo = a.CCTcodigo
						   and d.Pcodigo   = a.Pcodigo
					where a.Ecodigo   = #Arguments.Ecodigo#
					  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				</cfquery>

			<!--- 3) Asiento de Diferencial Cambiario --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
					'CCRE',
					1,
					a.Ddocumento,
					a.CCTcodigo,
					     abs( round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2)),
					case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) >= 0 then 'C' else 'D' end,
					'CxC: Diferencial Cambiario:',
					'#LvarFechaCar#',
					1.00,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					a.Ccuenta,
					a.Mcodigo,
					d.Ocodigo,
					0.00,
    				b.NumeroEvento,d.CFid
				from Pagos d
					inner join DPagos b
							inner join Documentos a
							on  a.Ecodigo    = b.Ecodigo
							and a.CCTcodigo  = b.Doc_CCTcodigo
							and a.Ddocumento = b.Ddocumento

					on  b.Ecodigo   = d.Ecodigo
					and b.CCTcodigo = d.CCTcodigo
					and b.Pcodigo   = d.Pcodigo

				where d.Ecodigo   = #Arguments.Ecodigo#
				  and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and d.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and a.Mcodigo <> #rsMonedaLocal.MonLoc#
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
				select
					'CCRE',
					1,
					a.Ddocumento,
					a.CCTcodigo,
					     abs( round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2)),
					case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) < 0 then 'C' else 'D' end,
					case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) < 0 then <cf_dbfunction name="concat" args="'CxC: Ingreso por Dif. Cambiario Doc ',a.Ddocumento"> else <cf_dbfunction name="concat" args="'CxC: Perdida por Dif. Cambiario Doc',a.Ddocumento">end,
					'#LvarFechaCar#',
					1,
					#rsPeriodo.Periodo#,
					#rsmes.Mes#,
					case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) < 0
						then #rsCuentaDifCam1.Pvalor#
						else #rsCuentaDifCam2.Pvalor#
					end,
					a.Mcodigo,
					d.Ocodigo,
					0.00,
    				b.NumeroEvento,d.CFid
				from Pagos d
						inner join DPagos b
								inner join Documentos a
								on  a.Ecodigo    = b.Ecodigo
								and a.CCTcodigo  = b.Doc_CCTcodigo
								and a.Ddocumento = b.Ddocumento
						on  b.Ecodigo   = d.Ecodigo
						and b.CCTcodigo = d.CCTcodigo
						and b.Pcodigo   = d.Pcodigo
				where d.Ecodigo   =   #Arguments.Ecodigo#
				  and d.CCTcodigo =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and d.Pcodigo   =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and a.Mcodigo   <>  #rsMonedaLocal.MonLoc#
			</cfquery>
			<!--- 4) Balance por Moneda --->
			<cfset LvarBalancear = true>
			<cfquery name="rsBalXMonedaOficina" datasource="#arguments.conexion#">
				select 	sum(case when INTTIP = 'D' then INTMON else -INTMON end) 	as DIF,
						sum(0.005) 													as PERMIT,  <!--- 0.005 --->
						sum(case when INTTIP = 'D' then INTMON end) 				as DBS,
						sum(case when INTTIP = 'C' then INTMON end) 				as CRS
				  from #request.INTARC#
			</cfquery>
			<cfif rsBalXMonedaOficina.PERMIT EQ "" or rsBalXMonedaOficina.PERMIT EQ 0 >
			   <cf_errorCode	code = "51078" msg = "El Asiento Generado está vacío. Proceso Cancelado!">
			</cfif>

			<cfif abs(rsBalXMonedaOficina.DIF) GT rsBalXMonedaOficina.PERMIT>
				<cfif not LvarPintar>
					<cf_errorCode	code = "51079"
								msg  = "El Asiento Generado no está balanceado en Moneda Local. Debitos=@errorDat_1@, Creditos=@errorDat_2@. Proceso Cancelado!"
								errorDat_1="#numberFormat(rsBalXMonedaOficina.DBS,",9.00")#"
								errorDat_2="#numberFormat(rsBalXMonedaOficina.CRS,",9.00")#"
					>
				</cfif>
				<cfset LvarBalancear = false>
			</cfif>

			<cfif LvarBalancear>
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC#
						(
							Ocodigo, Mcodigo, INTCAM,
							INTORI, INTREL, INTDOC, INTREF,
							INTFEC, Periodo, Mes,
							INTTIP, INTDES,
							CFcuenta, Ccuenta,
							INTMOE, INTMON, NumeroEvento,CFid
						)
					select
							Ocodigo, i.Mcodigo, round(INTCAM,10),
							min(INTORI), min(INTREL), min(INTDOC), min(INTREF),
							min(INTFEC), min(Periodo), min(Mes),
							'D', 'Balance entre Monedas',
							null, #rsCuentaPuente.CuentaPuente#,
							-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
							-sum(case when INTTIP = 'D' then INTMON else -INTMON end),
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEvento#">,i.CFid
					  from #INTARC# i
					 where i.Mcodigo in
						(
							select Mcodigo
							  from #INTARC#
							 group by Mcodigo
							having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
						)
					group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10),i.CFid
					having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
				</cfquery>
			</cfif>


<!---   <cfset sbAfectacionIETU("CCRE", Arguments.Ecodigo, Arguments.CCTcodigo, Arguments.Pcodigo,
							#rsPagos.Pfecha#, #rsPeriodo.Periodo#, #rsmes.Mes#,
							Arguments.conexion)> --->

				<cfif LvarPintar>
					<cfset LvarNAP = 0>
				<cfelse>
					<cfset LvarNAP = sbControlPresupuesto_PagosCxC (
							Arguments.Ecodigo, "CCRE", Arguments.Pcodigo, Arguments.CCTcodigo,
							rsPagos.DatePfecha, rsPeriodo.Periodo, rsmes.Mes,
							Arguments.conexion
	<!--- Control Evento Inicia --->
    						,'#varNumeroEvento#'
	<!--- Control Evento Fin --->
							)>

				</cfif>

				<!--- 5) Ejecutar el Genera Asiento --->
				 <cfinvoke component="CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
					Oorigen 		= "CCRE"
					Eperiodo		= "#rsPeriodo.Periodo#"
					Emes			= "#rsmes.Mes#"
					Efecha			= "#rsPagos.DatePfecha#"
					Edescripcion	= "#LvarDescripcion#"
					Edocbase		= "#Arguments.Pcodigo#"
					Ereferencia		= "#Arguments.CCTcodigo#"
					usuario 		= "#Arguments.usuario#"
					Ocodigo 		= "#rsPagos.Ocodigo#"
					Usucodigo 		= "#session.Usucodigo#"
					NAP				= "#LvarNAP#"
					conexion		= "#Arguments.Conexion#"
					debug			= "false"
					PintaAsiento	= "#LvarPintar#"
<!--- Control Evento Inicia --->
        			NumeroEvento	= "#varNumeroEvento#"
<!--- Control Evento Fin --->
				/>
				<cfinvoke component="IETU" method="IETU_ActualizaIDcontable" >
					<cfinvokeargument name="IDcontable"	value="#retIDcontable#">
					<cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
				</cfinvoke>

                <!--- Timbrado  de  CFDI  de Pagos   ---->
				<cfset timbrePago = timbraPago(#Arguments.CCTcodigo#,#Arguments.Pcodigo#)>
                <cfset insertaInfoBancaria(Arguments.Pcodigo)>
				<cfset InsertaCFDI(retIDcontable,Arguments.Pcodigo,Arguments.Ecodigo,Arguments.CCTcodigo)>

				<!--- Inserta monto pagado por impuestos Credito Fiscal en la tabla ImpDocumentosCxCMov --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into ImpDocumentosCxCMov (
						CCTcodigo,
						Documento,
						Icodigo,
						Ecodigo,
						Fecha,
						MontoPagado,
						TipoPago,
						DocumentoPago,
						Periodo,
						Mes,
						CcuentaAC,
						BMUsucodigo,
						BMFecha,
						TpoCambio,
						MontoPagadoLocal
					)
					select	b.CCTcodigo,
						b.Documento,
						b.Icodigo,
						b.Ecodigo,
						x.Pfecha,
						round(( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * (b.MontoCalculado) ) ,2),
						a.CCTcodigo,
						a.Pcodigo,
						#rsPeriodo.Periodo#,
						#rsmes.Mes#,
						coalesce(i.CcuentaCxCAcred,i.Ccuenta),
						b.BMUsucodigo,
						<cf_dbfunction name="now">,
						x.Ptipocambio / a.DPtipocambio,
						round( round(( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * (b.MontoCalculado) ) ,2) * x.Ptipocambio / a.DPtipocambio ,2)
					from Pagos x
						inner join DPagos  a
							inner join ImpDocumentosCxC b
								inner join Impuestos i
								on  i.Ecodigo = b.Ecodigo
								and i.Icodigo = b.Icodigo
							on  b.Ecodigo       = a.Ecodigo
							and b.CCTcodigo     = a.Doc_CCTcodigo
							and b.Documento     = a.Ddocumento
						on  a.Ecodigo = x.Ecodigo
						and a.CCTcodigo = x.CCTcodigo
						and a.Pcodigo   = x.Pcodigo
					where x.Ecodigo   = #Arguments.Ecodigo#
					  and x.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and x.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and b.TotalFac <> 0
					  and b.MontoCalculado <> 0
				</cfquery>
				<!--- Inserta monto pagado por IEPS Credito Fiscal en la tabla ImpIEPSDocumentosCxCMov --->
						<cfquery datasource="#Arguments.Conexion#">
							insert into ImpIEPSDocumentosCxCMov (
								CCTcodigo,
								Documento,
								codIEPS,
								Ecodigo,
								Fecha,
								MontoPagado,
								TipoPago,
								DocumentoPago,
								Periodo,
								Mes,
								CcuentaAC,
								BMUsucodigo,
								BMFecha,
								TpoCambio,
								MontoPagadoLocal
								)
							select	b.CCTcodigo,
								b.Documento,
								b.codIEPS,
								b.Ecodigo,
								x.Pfecha,
								round(( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * (b.MontoCalculado) ) ,2),
								a.CCTcodigo,
								a.Pcodigo,
								#rsPeriodo.Periodo#,
								#rsmes.Mes#,
								coalesce(i.CcuentaCxCAcred,i.Ccuenta),
								b.BMUsucodigo,
								<cf_dbfunction name="now">,
								x.Ptipocambio / a.DPtipocambio,
								round( round(( (a.DPmontodoc + a.DPmontoretdoc) / b.TotalFac * (b.MontoCalculado) ) ,2) * x.Ptipocambio / a.DPtipocambio ,2)
							from Pagos x
								inner join DPagos  a
									inner join ImpIEPSDocumentosCxC b
										inner join Impuestos i
										on  i.Ecodigo = b.Ecodigo
										and i.Icodigo = b.codIEPS
									on  b.Ecodigo       = a.Ecodigo
									and b.CCTcodigo     = a.Doc_CCTcodigo
									and b.Documento     = a.Ddocumento
								on  a.Ecodigo = x.Ecodigo
								and a.CCTcodigo = x.CCTcodigo
								and a.Pcodigo   = x.Pcodigo
							where x.Ecodigo   = #Arguments.Ecodigo#
							  and x.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
							  and x.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
							  and b.TotalFac <> 0
							  and b.MontoCalculado <> 0
						</cfquery>

				<cfloop query="rsDPagosICF">
					<cfquery datasource="#Arguments.Conexion#">
						update ImpDocumentosCxC
						set MontoPagado =
							coalesce(MontoPagado,0)
							+  round(
								round( ( (
									select sum(a.DPmontodoc + a.DPmontoretdoc)
									from  DPagos  a
									where a.Ecodigo = #Arguments.Ecodigo#
									  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
									  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
									  and a.Ecodigo   = ImpDocumentosCxC.Ecodigo
									  and a.Doc_CCTcodigo = ImpDocumentosCxC.CCTcodigo
									  and a.Ddocumento =  ImpDocumentosCxC.Documento
								)
								/ ImpDocumentosCxC.TotalFac ),2)
								* (ImpDocumentosCxC.MontoCalculado), 2)
						where ImpDocumentosCxC.Ecodigo = #rsDPagosICF.Ecodigo#
						  and ImpDocumentosCxC.CCTcodigo = '#rsDPagosICF.Doc_CCTcodigo#'
						  and ImpDocumentosCxC.Documento = '#rsDPagosICF.Ddocumento#'
						  and ImpDocumentosCxC.TotalFac <> 0
						  and ImpDocumentosCxC.MontoCalculado <> 0
					</cfquery>

				</cfloop>

				<cfloop query="rsDPagosPP">
					<cfquery datasource="#Arguments.Conexion#">
						update PlanPagos
						set PPfecha_pago = <cf_dbfunction name="now">,
							PPpagoprincipal = PlanPagos.PPpagoprincipal + #rsDPagosPP.DPmontodoc# + #rsDPagosPP.DPmontoretdoc# - PlanPagos.PPpagointeres - PlanPagos.PPpagomora
						where PlanPagos.Ecodigo    =  #rsDPagosPP.Ecodigo#
						  and PlanPagos.CCTcodigo  = '#rsDPagosPP.Doc_CCTcodigo#'
						  and PlanPagos.Ddocumento = '#rsDPagosPP.Ddocumento#'
						  and PlanPagos.PPnumero   =  #rsDPagosPP.PPnumero#
					</cfquery>
				</cfloop>

				<!--- Cambio Mauricio Esquivel... 19/1/2005.  Ajuste del Plan de Pagos cuando se paga parcialmente el documento --->
				<cfset InsertaPlanPagos(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo)>

				<!--- 6) Insertar en el Histrico de CxC --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into BMovimientos (
						Ecodigo, CCTcodigo, Ddocumento,
						CCTRcodigo, DRdocumento,
						BMfecha, Ccuenta, Ocodigo,
						SNcodigo, Mcodigo, Dtipocambio,
						Dtotal,
						Dfecha, Dvencimiento, BMperiodo, BMmes,
						BMusuario,
						Dtotalloc,
						Dtotalref,
						Mcodigoref,
						BMmontoref,
						BMfactor,
						Timbrefiscal,
						IDcontable
					<cfif Arguments.EAid NEQ -1>
						,EAid
					</cfif>
						)
					select
						c.Ecodigo,
						c.CCTcodigo,
						c.Pcodigo,
						b.Doc_CCTcodigo, b.Ddocumento,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
						a.Ccuenta, c.Ocodigo,
						a.SNcodigo, c.Mcodigo, c.Ptipocambio,
						b.DPtotal,
						c.Pfecha,
						c.Pfecha,
						#rsPeriodo.Periodo#,
						#rsmes.Mes#,
						a.Dusuario,
						round(b.DPtotal * c.Ptipocambio,2),
						b.DPmontodoc + b.DPmontoretdoc,
						a.Mcodigo,
						b.DPmontodoc,
						b.DPtipocambio,
						'#timbrePago#',
						#retIDcontable#
					<cfif Arguments.EAid NEQ -1>
						,#Arguments.EAid#
					</cfif>
					from Pagos c
						inner join DPagos b
							inner join Documentos a
							on  a.Ecodigo    =  b.Ecodigo
							and a.CCTcodigo  =  b.Doc_CCTcodigo
							and a.Ddocumento = b.Ddocumento
						on  b.Ecodigo   = c.Ecodigo
						and b.CCTcodigo = c.CCTcodigo
						and b.Pcodigo   = c.Pcodigo
					where c.Ecodigo   = #Arguments.Ecodigo#
					  and c.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and c.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				</cfquery>
				<cfloop query="rsDPagos">
					<!--- 7) Actualizar el saldo de los documentos que se estan pagando  y el monto acumulado de retenciones --->
					<cfquery datasource="#Arguments.Conexion#">
						update Documentos
						set
							Dsaldo = Dsaldo -
								coalesce((
									select sum(abs(DPmontodoc + DPmontoretdoc))
									from DPagos c
									where c.Ecodigo       = #Arguments.Ecodigo#
									  and c.Pcodigo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
									  and c.CCTcodigo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
									  and c.Ecodigo       = Documentos.Ecodigo
									  and c.Doc_CCTcodigo = Documentos.CCTcodigo
									  and c.Ddocumento    = Documentos.Ddocumento
								  ) , 0.00),
							Dretporigen = coalesce(Dretporigen, 0.00) +
								coalesce((
									select sum(abs(c.DPmontoretdoc))
									from DPagos c
									where c.Ecodigo       = #Arguments.Ecodigo#
									  and c.Pcodigo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
									  and c.CCTcodigo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
									  and c.Ecodigo       = Documentos.Ecodigo
									  and c.Doc_CCTcodigo = Documentos.CCTcodigo
									  and c.Ddocumento    = Documentos.Ddocumento
								) , 0.00)
						where Documentos.Ecodigo    =  #rsDPagos.Ecodigo#
						  and Documentos.CCTcodigo  = '#rsDPagos.Doc_CCTcodigo#'
						  and Documentos.Ddocumento = '#rsDPagos.Ddocumento#'
					</cfquery>
				</cfloop>

				<cfset getVerificaNegativos(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo) >

				<!--- 8) Grabar los Documento de los Anticipo Generado (si Tienen anticipos) --->
				<cfset InsertaAnticipo(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,Arguments.usuario)>

					<cfquery datasource="#Arguments.Conexion#">
						insert into BMovimientos (
								Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento,
								BMfecha, Ccuenta, Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal,
								Dfecha, Dvencimiento, BMperiodo, BMmes, BMusuario,
								Dtotalloc, Dtotalref
							<cfif Arguments.EAid NEQ -1>
								,EAid
							</cfif>
							   )
						select
								b.Ecodigo,
								b.NC_CCTcodigo,
								b.NC_Ddocumento,
								b.CCTcodigo,
								b.Pcodigo,
								<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
								b.NC_Ccuenta,
								a.Ocodigo,
								a.SNcodigo,
								a.Mcodigo,
								a.Ptipocambio,
								b.NC_total,
								a.Pfecha,
								a.Pfecha,
								#rsPeriodo.Periodo#,
								#rsmes.Mes#,
								'#Arguments.usuario#',
								round(b.NC_total*a.Ptipocambio,2),
								b.NC_total
							  <cfif Arguments.EAid NEQ -1>
								,#Arguments.EAid#
							  </cfif>
						from Pagos a
							inner join APagosCxC b
								on a.Ecodigo   = b.Ecodigo
							   and a.CCTcodigo = b.CCTcodigo
							   and a.Pcodigo   = b.Pcodigo
						where a.Ecodigo   = #Arguments.Ecodigo#
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
						  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					</cfquery>

					<!--- inserta HDocumentos --->
					<cfset varinsertHDocumentos = insertHDocumentos(CCTcodigo = #Arguments.CCTcodigo#, Pcodigo = #Arguments.Pcodigo#, Ecodigo = #Arguments.Ecodigo#, Conexion = #Arguments.Conexion#)>

					<cfif varValidaEvento GT 0>
	                    <cfset varANevento = AnticipoEvento(CCTcodigo = #Arguments.CCTcodigo#, Pcodigo = #Arguments.Pcodigo#, Ecodigo = #Arguments.Ecodigo#, Conexion = #Arguments.Conexion#)>
                    </cfif>

                    <cfquery name="rsPagosInfo" datasource="#session.dsn#">
                     select CBid, Mcodigo, Pobservaciones, Pfecha, Preferencia, Ptotal, Ptipocambio from
                      Pagos a
						where a.Ecodigo   = #Arguments.Ecodigo#
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
						  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                    </cfquery>
                    <cfif isdefined('rsPagosInfo') and len(trim(#rsPagosInfo.Preferencia#)) gt 0>
                      <cfset PReferencia = rsPagosInfo.Preferencia>
					<cfelse>
                      <cfset PReferencia = 'Cobro CxC'>
                    </cfif>
			    <cfif isdefined('rsPagosInfo.CBid') and len(trim(#rsPagosInfo.CBid#)) gt 0 and rsPagosInfo.CBid neq -1 and left(Arguments.Pcodigo,4) neq 'CRC-'>
                       <cfquery name="rsBanco" datasource="#session.dsn#">
                          select b.Bid from  CuentasBancos a
                           inner join Bancos b on a.Bid = b.Bid and a.Ecodigo = b.Ecodigo
                            where a.CBid  = #rsPagosInfo.CBid# and a.Ecodigo = #Arguments.Ecodigo#
                       </cfquery>
                       <cfquery name="rsBTran" datasource="#session.dsn#">
                         select BTid from BTransacciones where Ecodigo= #Arguments.Ecodigo# and BTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="DP">
                       </cfquery>

						<cfquery name="rsBTran" datasource="#Arguments.Conexion#">
        				        select BTid, BTtipo
        				        from BTransacciones
        				        where Ecodigo= #Arguments.Ecodigo#
        				        and BTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="DP">
        				</cfquery>

                       <cfinvoke component="sif.componentes.MB_InsertaMLibros" method="inserta_mlibros" >
                            <cfinvokeargument name="Ecodigo"	 value="#Arguments.Ecodigo#">
                            <cfinvokeargument name="Bid"	     value="#rsBanco.Bid#">
                            <cfinvokeargument name="BTid"	     value="#rsBTran.BTid#">
                            <cfinvokeargument name="CBid"	     value="#rsPagosInfo.CBid#">
                            <cfinvokeargument name="Mcodigo"     value="#rsPagosInfo.Mcodigo#">
                            <cfinvokeargument name="fecha"       value="#rsPagosInfo.Pfecha#">
                            <cfinvokeargument name="referencia"  value="#PReferencia#">
                            <cfinvokeargument name="documento"   value="#Arguments.Pcodigo#">
                            <cfinvokeargument name="tipocambio"  value="#rsPagosInfo.Ptipocambio#">
                            <cfinvokeargument name="monto"       value="#rsPagosInfo.Ptotal#">
                            <cfinvokeargument name="IDcontable"	 value="#retIDcontable#">
                            <cfinvokeargument name="Periodo"	 value="#rsPeriodo.Periodo#">
                            <cfinvokeargument name="Mes"	     value="#rsMes.Mes#">
                            <cfinvokeargument name="conexion"	 value="#Arguments.Conexion#">
                            <cfinvokeargument name="descripcion" value="Cobros-CxC">
                            <cfinvokeargument name="tipomov"    value="#rsBTran.BTtipo#">
                       </cfinvoke>
                 </cfif>

                <!--- 9 Graba en la tabla Histórica de Pagos. --->
                <cfquery datasource="#Arguments.Conexion#">
                	insert into HPagos
                    	(
                        	Ecodigo, CCTcodigo, Pcodigo, Ocodigo, Mcodigo, Ccuenta, GSNid, SNcodigo,
                            CFid, ID, Ptipocambio, Ptotal, Pfecha, Preferencia, Pobservaciones, Pusuario,
                            Seleccionado, BMUsucodigo, CBid
                        )
                	select
                    		Ecodigo, CCTcodigo, Pcodigo, Ocodigo, Mcodigo, Ccuenta, GSNid, SNcodigo, CFid, ID,
                            Ptipocambio, Ptotal, Pfecha, Preferencia, Pobservaciones, Pusuario, Seleccionado, BMUsucodigo, CBid
                    from Pagos
                    where Ecodigo   = #Arguments.Ecodigo#
				      and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                </cfquery>

				<!--- <cfset InsertaCFDI(retIDcontable,Arguments.Pcodigo,Arguments.Ecodigo,Arguments.CCTcodigo)> --->
				
				
				<cfquery datasource="#Arguments.Conexion#">
					delete from DPagos
					where Ecodigo  = #Arguments.Ecodigo#
					 and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					 and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				</cfquery>

				<cfquery datasource="#Arguments.Conexion#">
					delete from DFiltroPagos
					where Ecodigo   = #Arguments.Ecodigo#
					  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				</cfquery>
				<!---Se borran los Anticipos, estos ya quedaron en Documentos y HDocumentos--->
				<cfquery datasource="#Arguments.Conexion#">
					delete from APagosCxC
					where Ecodigo    = #Arguments.Ecodigo#
					  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				</cfquery>

				<cfquery datasource="#Arguments.Conexion#">
					delete from Pagos
					where Ecodigo    = #Arguments.Ecodigo#
					  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				</cfquery>
          </cflock>
</cffunction>

<!--- FUNCIONES LOCALES --->

<cffunction name="getVerificaNegativos" output="no" returntype="void">
	<cfargument name="Conexion"	type="string" 	required="yes">
	<cfargument name="Ecodigo"	type="numeric" 	required="yes">
	<cfargument name="CCTcodigo"	type="string" 	required="yes">
	<cfargument name="Pcodigo"	type="string" 	required="yes">

				<cfquery datasource="#Arguments.Conexion#" name="rsVerificaNegativos">
					select a.Dsaldo, a.Ecodigo, a.CCTcodigo, a.Ddocumento, a.SNcodigo, s.SNnombre
					from DPagos b
						inner join Documentos a
								inner join SNegocios s
								on s.Ecodigo = a.Ecodigo
								and s.SNcodigo = a.SNcodigo
						on a.Ecodigo = b.Ecodigo
						and a.CCTcodigo = b.Doc_CCTcodigo
						and a.Ddocumento = b.Ddocumento
					where b.Ecodigo   = #Arguments.Ecodigo#
					  and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
					  and b.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					  and a.Dsaldo    <= -0.01
				</cfquery>
				<cfif rsVerificaNegativos.Recordcount GT 1>
					<cfset LvarMensajeNegativos = "Documentos quedan Negativos: ">
					<cfloop query="rsVerificaNegativos">
						<cfset LvarMensajeNegativos = LvarMensajeNegativos & " #rsVerificaNegativos.CCTcodigo# #rsVerificaNegativos.Ddocumento# #rsVerificaNegativos.SNnombre#">
					</cfloop>

                     <cftransaction action="rollback" />
					<cfthrow message="#LvarMensajeNegativos#">
					<cfreturn 0>
				</cfif>
</cffunction>

<cffunction name="InsertaAnticipo" output="no" returntype="void">
	<cfargument name="Conexion"	type="string" 	required="yes">
	<cfargument name="Ecodigo"	type="numeric" 	required="yes">
	<cfargument name="CCTcodigo"	type="string" 	required="yes">
	<cfargument name="Pcodigo"	type="string" 	required="yes">
	<cfargument name="usuario"	type="string" 	required="yes">

					<cfquery datasource="#Arguments.Conexion#">
						insert into Documentos (
									Ecodigo,  		CCTcodigo, 		Ddocumento, 	Ocodigo,
									SNcodigo, 		Mcodigo,   		Ccuenta,    	Rcodigo,
									Dtipocambio, 	Dtotal, 		Dsaldo,     	Dfecha,
									Dvencimiento, 	Dtcultrev, 		Dusuario, 		Dtref,
									Ddocref,      	Dmontoretori, 	Dretporigen, 	Icodigo,
									id_direccionFact, EDtipocambioVal, EDtipocambioFecha
									,TESRPTCid,TESRPTCietu)
						select
									b.Ecodigo ,
									b.NC_CCTcodigo,
									b.NC_Ddocumento,
									a.Ocodigo,
									a.SNcodigo,
									a.Mcodigo,
									b.NC_Ccuenta,
									null,
									a.Ptipocambio,
									b.NC_total,
									b.NC_total,
									a.Pfecha,
									a.Pfecha,
									a.Ptipocambio,
									'#Arguments.usuario#',
									a.CCTcodigo,
									a.Pcodigo,
									null,
									null,
									null,
									b.id_direccion,
									a.Ptipocambio,
									a.Pfecha,
									b.NC_RPTCid,
									b.NC_RPTCietu
						from Pagos a
							inner join APagosCxC b
								on a.Ecodigo   = b.Ecodigo
							   and a.CCTcodigo = b.CCTcodigo
							   and a.Pcodigo   = b.Pcodigo
						where a.Ecodigo   = #Arguments.Ecodigo#
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
						  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					</cfquery>
</cffunction>

<cffunction name="InsertaPlanPagos" output="no" returntype="void">
	<cfargument name="Conexion"	type="string" 	required="yes">
	<cfargument name="Ecodigo"	type="numeric" 	required="yes">
	<cfargument name="CCTcodigo"	type="string" 	required="yes">
	<cfargument name="Pcodigo"	type="string" 	required="yes">

	<cfquery datasource="#Arguments.Conexion#">
		insert into PlanPagos (
			Ecodigo, CCTcodigo, Ddocumento,
			PPnumero, PPfecha_vence, PPsaldoant,
			PPprincipal, PPinteres, PPpagoprincipal,
			PPpagointeres, PPpagomora, PPfecha_pago,
			Mcodigo, PPtasa, PPtasamora, BMUsucodigo)
		select distinct
			p.Ecodigo, p.CCTcodigo, p.Ddocumento,
			p.PPnumero + 1, p.PPfecha_vence, p.PPsaldoant - p.PPpagoprincipal,
			p.PPsaldoant - p.PPpagoprincipal, 0.00,      0.00,
			0.00, 0.00,  null,
			p.Mcodigo, p.PPtasa, p.PPtasamora, p.BMUsucodigo
		from DPagos a
			inner join PlanPagos pp
				on  pp.Ecodigo    = a.Ecodigo
				and pp.CCTcodigo  = a.Doc_CCTcodigo
				and pp.Ddocumento = a.Ddocumento
				and pp.PPnumero   = a.PPnumero
			inner join PlanPagos p
				on  p.Ecodigo    = pp.Ecodigo
				and p.CCTcodigo  = pp.CCTcodigo
				and p.Ddocumento = pp.Ddocumento
				and p.PPnumero = (
						select max(p1.PPnumero)
						from PlanPagos p1
						where p1.Ecodigo = p.Ecodigo
						  and p1.CCTcodigo = p.CCTcodigo
						  and p1.Ddocumento = p.Ddocumento)
				and p.PPsaldoant - p.PPpagoprincipal > 0
		where a.Ecodigo    = #Arguments.Ecodigo#
		  and a.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and a.Pcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		  and a.PPnumero   is not null
	</cfquery>

</cffunction>

<cffunction name="getValidaPagos" output="no" returntype="numeric">
	<cfargument name="Conexion"	type="string" 	required="yes">
	<cfargument name="Ecodigo"	type="numeric" 	required="yes">
	<cfargument name="CCTcodigo"	type="string" 	required="yes">
	<cfargument name="Pcodigo"	type="string" 	required="yes">

	<cfquery datasource="#Arguments.Conexion#" name="rsValidaPagos">
		select count(1) as cantidad
		from Pagos p
			inner join DPagos dp
					inner join Documentos d
					on d.Ecodigo = dp.Ecodigo
					and d.CCTcodigo = dp.Doc_CCTcodigo
					and d.Ddocumento = dp.Ddocumento
			on dp.Ecodigo = p.Ecodigo
			and dp.CCTcodigo = p.CCTcodigo
			and dp.Pcodigo = p.Pcodigo
		where p.Ecodigo 	= #Arguments.Ecodigo#
		  and p.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		  and p.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		  and p.Pfecha < d.Dfecha
	</cfquery>
	<cfreturn rsValidaPagos.cantidad>
</cffunction>

<cffunction name="getCPCPagado_Anterior" output="no" returntype="string">
	<cfargument name="Ecodigo"	type="numeric" 	required="yes">
	<cfargument name="CCTcodigo"	type="string" 	required="yes">
	<cfargument name="Pcodigo"	type="string" 	required="yes">
	<cfargument name="Eperiodo"	type="numeric" 	required="yes">

	<cfquery name="rsNAP" datasource="#session.DSN#">
              select  nape.CPNAPnum as NAP
              from Pagos e
                  inner join DPagos d
                      on  d.Ecodigo   = e.Ecodigo
                      and d.CCTcodigo = e.CCTcodigo
                      and d.Pcodigo   = e.Pcodigo
                  inner join HDocumentos cc
                      on  cc.Ecodigo    = d.Ecodigo
                      and cc.CCTcodigo  = d.Doc_CCTcodigo
                      and cc.Ddocumento = d.Ddocumento
                  inner join CPNAP nape
                        on nape.Ecodigo				= cc.Ecodigo
                       and nape.CPNAPmoduloOri		= 'CCFC'
                       and nape.CPNAPdocumentoOri		= cc.Ddocumento
                       and nape.CPNAPreferenciaOri	= cc.CCTcodigo
                  inner join CPNAPdetalle nap
                        on nap.Ecodigo		= nape.Ecodigo
                       and nap.CPNAPnum		= nape.CPNAPnum
                       and nap.CPNAPDtipoMov = 'E'
              where e.Ecodigo   =   #Arguments.Ecodigo#
                and e.CCTcodigo =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                and e.Pcodigo   =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
      </cfquery>

	<cfif rsNAP.recordcount gt 0>
            <cfquery name ="rsNAPsAnosAnteriores" datasource="#Session.DSN#">
                select  top 1 (d.CPNAPnum)
                from Documentos cxc
                    inner join CPNAP n
                          on n.Ecodigo				= cxc.Ecodigo
                         and n.CPNAPmoduloOri		= 'CCFC'
                         and n.CPNAPdocumentoOri	= cxc.Ddocumento
                         and n.CPNAPreferenciaOri	= cxc.CCTcodigo
                         and n.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Eperiodo#">
                    inner join CPNAPdetalle d
                         on d.Ecodigo		= n.Ecodigo
                        and d.CPNAPnum		= n.CPNAPnum
                        and d.CPNAPDtipoMov	in ('E','E2')
                where cxc.Ecodigo		= #Arguments.Ecodigo#
                  and cxc.Dsaldo		> 0
                  and cxc.Dtotal		> 0
                  and d.CPNAPnum = #Arguments.NAP#
                group by d.CPNAPnum
            </cfquery>
	</cfif>
	<cfif rsNAP.recordcount gt 0 and rsNAPsAnosAnteriores.recordcount GTE 1>
    	<cfset varCPCPagado_Anterior = "1">
    <cfelse>
    	<cfset varCPCPagado_Anterior = "0">
    </cfif>
	<cfreturn varCPCPagado_Anterior>
</cffunction>
	<cffunction name="timbraPago" output="false">
		<cfargument name="CCtcodigo" type="string"   required="yes" default="-1">
		<cfargument name="Pcodigo"   type="string"   required="yes" default="-1">
		<cfquery name="rsTimbra" datasource="#session.dsn#">
			select ClaveSAT from CCTransacciones
			where Ecodigo =#session.Ecodigo#
			and CCTcodigo ='#Arguments.CCTcodigo#'
		</cfquery>
		<!--- Obtiene la informacion del pago --->
		<cfset lVarPMetPago = "">
		<cfquery name="rsPagoInfo" datasource="#session.dsn#">
			SELECT PMetPago
			FROM Pagos
			WHERE UPPER(Pcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(arguments.Pcodigo)#">
			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif isDefined("rsPagoInfo.PMetPago") AND #rsPagoInfo.PMetPago# NEQ "">
			<cfset lVarPMetPago = #TRIM(rsPagoInfo.PMetPago)#>
		</cfif>
		<cfset timbrePago = "">
		<cfif isdefined('rsTimbra') and rsTimbra.ClaveSAT EQ 'P' AND lVarPMetPago EQ "PPD">
			<cfset timbrar = 1>
		<cfelse> 
			<cfset timbrar  =0>	
		</cfif>
		<cfquery name="rsdocsrel" datasource="#session.dsn#">
			select count(Ddocumento) docsrel from Pagos ep
			inner join DPagos dp on ep.Ecodigo=dp.Ecodigo and ep.CCTcodigo=dp.CCTcodigo and ep.Pcodigo=dp.Pcodigo
			where ep.Ecodigo = #session.Ecodigo#
			  and ep.Pcodigo = '#Arguments.Pcodigo#'
		</cfquery>
		<cfif timbrar EQ 1 and rsdocsrel.docsrel GT 0>
			<cfinvoke component="rh.Componentes.GeneraCFDIs" method="obtenerCFDI">
				<cfinvokeargument name="ReciboPago" value = "#Arguments.Pcodigo#">
			</cfinvoke>					
			<cfquery name="rsPagoTimbrado" datasource="#session.dsn#">
				select * from FA_CFDI_Emitido
				where Ecodigo = #session.Ecodigo# and docPago ='#Arguments.Pcodigo#'
				and stsTimbre=1
			</cfquery>
			<cfset session.DocPago =  #Arguments.Pcodigo#>
			<cfset timbrePago = rsPagoTimbrado.timbre>
			<cfinclude template="/sif/fa/operacion/ImpresionMFECCO.cfm"> 
		</cfif>
		<cfreturn timbrePago>
	</cffunction>
<cffunction name="InsertaCFDI" output="no">
	<cfargument name="IDcontable"	type="numeric" 	required="yes">
    <cfargument name="Pcodigo"		type="string" 	required="yes">
    <cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
    <cfargument name="CCTcodigo" 	type="string" 	default="#session.DSN#">

	<!--- MEG 05/11/2014 --->
	<!--- Envía al Repositorio de  CFDI --->
	<cfquery name="getContE" datasource="#Session.DSN#">
		select ERepositorio from Empresa
		where Ereferencia = #Session.Ecodigo#
	</cfquery>
	<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
		<!--- <cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
		<cfset dbname = LobjRepo.getnameDB(#session.Ecodigo#)> --->
		<cfset request.repodbname = "">
	<cfelse>
		<cfset request.repodbname = "">
	</cfif>

	<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
		<cfquery name="rsLineaBanco" datasource="#session.DSN#">
			SELECT top 1 dco.IDcontable, dco.Dlinea,
	         	   CASE WHEN cct.CCTcktr = 'C' THEN 'CHK'
	                     WHEN cct.CCTcktr = 'T' THEN 'TRM'
	                END as TipoPago,p.Pcodigo,
	                p.Pfecha,p.Ptotal,e.Enombre,e.Eidentificacion,
	                CASE WHEN cct.CCTcktr = 'T' THEN ceb.Clave
	                END as CodCtaDestino,
	                CASE WHEN cct.CCTcktr = 'T' THEN cb.CBcodigo
	                END as CtaDestino
	         FROM Pagos p
	                INNER JOIN CCTransacciones cct ON cct.CCTcodigo = p.CCTcodigo and cct.Ecodigo = p.Ecodigo
	                LEFT JOIN SNegocios sn ON sn.SNcodigo = p.SNcodigo and sn.Ecodigo = p.Ecodigo
	                INNER JOIN Empresa e ON e.Ereferencia = p.Ecodigo
	                INNER JOIN CuentasBancos cb ON cb.Ccuenta = p.Ccuenta and cb.Ecodigo = p.Ecodigo
	                INNER JOIN Bancos ban ON ban.Bid = cb.Bid
	                LEFT JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
	                LEFT JOIN DContables dco ON dco.Ccuenta = p.Ccuenta
   				 	  AND dco.IDcontable = #Arguments.IDcontable#
   				 	  AND dco.Ddocumento = p.Pcodigo
	         WHERE p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	    </cfquery>
		<cfquery name="rsDetalles" datasource="#session.DSN#">
			SELECT distinct #Arguments.IDcontable#, dco.Dlinea,op.HDid, op.Ddocumento,op.CCTcodigo,a.Pcodigo,
				op.SNcodigo, sn.SNidentificacion, op.Dtotal, op.Dtipocambio, op.Mcodigo
			FROM Pagos a
			inner join DPagos b on a.Pcodigo = b.Pcodigo
			inner join HDocumentos op on b.Ddocumento = op.Ddocumento
			INNER JOIN HDDocumentos dp on dp.HDid	= op.HDid
			INNER JOIN SNegocios sn on op.SNcodigo = sn.SNcodigo and op.Ecodigo = sn.Ecodigo
			INNER JOIN DContables dco ON dco.Ccuenta = sn.SNcuentacxc
				and dco.IDcontable = #Arguments.IDcontable#
				and dco.Ddocumento = op.Ddocumento
			where op.Ecodigo 	= #Arguments.Ecodigo#
				<!--- and op.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#"> --->
				and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>
		
		<cfif rsLineaBanco.recordCount gt 0 and rsLineaBanco.Dlinea neq "">
			<cfloop query="rsDetalles">
				<cfset varNumDoc = #Ddocumento#>
				<cfquery name="rsRepoB" datasource="#session.DSN#">
					insert into #request.repodbname#CERepositorio(
					IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML, archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
					TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
					CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
					select top 1
						#IDcontable#,#HDid#,'#Arguments.Pcodigo#', 'CCRE', #rsLineaBanco.Dlinea#, '#timbrePago#',
						<cfif isdefined("rsPagoTimbrado.xmlTimbrado")>
							'#rsPagoTimbrado.xmlTimbrado#'
						<cfelse>
							''
						</cfif>,
						rep.archivoXML, rep.archivo, rep.nombreArchivo, rep.extension, #session.Ecodigo#,#session.Usucodigo#, 
						rep.TipoComprobante, rep.Serie, #rsDetalles.Mcodigo#, #rsDetalles.Dtipocambio#,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineaBanco.TipoPago#" null="#Len(trim(rsLineaBanco.TipoPago)) Is 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalles.SNidentificacion#" null="#Len(trim(rsDetalles.SNidentificacion)) Is 0#">,
						round(#rsDetalles.Dtotal#,2),
						rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
					from #request.repodbname#CERepositorio  rep
					where ltrim(rtrim(rep.CEdocumentoOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ddocumento)#">
						<!--- and ltrim(rtrim(rep.CEtranOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(CCTcodigo)#"> --->
						and rep.CESNB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(SNcodigo)#">
						and rep.Ecodigo = #Session.Ecodigo#
						and rep.origen = 'CCFC'
				</cfquery>
				<cfquery name="rsRepo" datasource="#session.DSN#">
					insert into #request.repodbname#CERepositorio(
					IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML, archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
					TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
					CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
					select top 1
						#IDcontable#,#HDid#,'#Arguments.Pcodigo#', 'CCRE', #Dlinea#, '#timbrePago#',
						<cfif isdefined("rsPagoTimbrado.xmlTimbrado")>
							'#rsPagoTimbrado.xmlTimbrado#'
						<cfelse>
							''
						</cfif>,
						rep.archivoXML, rep.archivo, rep.nombreArchivo, rep.extension, #session.Ecodigo#,#session.Usucodigo#, 
						rep.TipoComprobante, rep.Serie, #rsDetalles.Mcodigo#, #rsDetalles.Dtipocambio#,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsLineaBanco.TipoPago#" null="#Len(trim(rsLineaBanco.TipoPago)) Is 0#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDetalles.SNidentificacion#" null="#Len(trim(rsDetalles.SNidentificacion)) Is 0#">,
						round(#rsDetalles.Dtotal#,2),
						rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
					from #request.repodbname#CERepositorio  rep
					where ltrim(rtrim(rep.CEdocumentoOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ddocumento)#">
						<!--- and ltrim(rtrim(rep.CEtranOri)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(CCTcodigo)#"> --->
						and rep.CESNB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(SNcodigo)#">
						and rep.Ecodigo = #Session.Ecodigo#
						and rep.origen = 'CCFC'
				</cfquery>
			</cfloop>
		</cfif>

	</cfif>
	<!--- MEG 05/11/2014 --->
</cffunction>

<cffunction name="insertaInfoBancaria" output="no">
        <cfargument name="Pcodigo"	type="string" 	required="yes">
<!---SML. 05/11/2014. Inicio Modificacion para agregar la informacion Bancaria para las Polizas del SAT--->

				<cfquery name="rsInfoBancaria" datasource="#session.DSN#">
                	SELECT dco.IDcontable, dco.Dlinea,
                    	   CASE WHEN cct.CCTcktr = 'C' THEN 'CHK'
                                WHEN cct.CCTcktr = 'T' THEN 'TRM'
                           END as TipoPago,p.Pcodigo,
                           p.Pfecha,p.Ptotal,e.Enombre,e.Eidentificacion,
                           CASE WHEN cct.CCTcktr = 'T' THEN ceb.Clave
                           END as CodCtaDestino,
                           CASE WHEN cct.CCTcktr = 'T' THEN cb.CBcodigo
                           END as CtaDestino
                    FROM Pagos p
                           INNER JOIN CCTransacciones cct ON cct.CCTcodigo = p.CCTcodigo
                           LEFT JOIN SNegocios sn ON sn.SNcodigo = p.SNcodigo and sn.Ecodigo = p.Ecodigo
                           INNER JOIN Empresa e ON e.Ereferencia = p.Ecodigo
                           INNER JOIN CuentasBancos cb ON cb.Ccuenta = p.Ccuenta
                           INNER JOIN Bancos ban ON ban.Bid = cb.Bid
                           LEFT JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
                           LEFT JOIN DContables dco ON dco.Ccuenta = p.Ccuenta
                		   AND dco.IDcontable = #retIDcontable# AND dco.Ddocumento = p.Pcodigo
                    WHERE p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                </cfquery>

			 
				<cfquery name="getContE" datasource="#Session.DSN#">
					select ERepositorio from Empresa
					where Ereferencia = #Session.Ecodigo#
				</cfquery>

				<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1" and rsInfoBancaria.recordCount gt 0>
					<cfif trim(rsInfoBancaria.Eidentificacion) EQ "">
				        <cf_errorCode	code = "80006" msg = "No se ha registrado el RFC de la Empresa">
				    </cfif>


					<cftry>
						<cfquery name="insInfoBancaria" datasource="#session.DSN#">
							INSERT INTO CEInfoBancariaSAT(IDcontable,Dlinea,
															TESTMPtipo,IBSATdocumento,
															TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
															IBSAClaveSATtran,IBSATctadestinotran)
							SELECT dco.IDcontable, dco.Dlinea,
								CASE WHEN cct.CCTcktr = 'C' THEN 'CHK'
										WHEN cct.CCTcktr = 'T' THEN 'TRM'
								END as TipoPago,p.Pcodigo,
								p.Pfecha,p.Ptotal,e.Enombre,e.Eidentificacion,
								CASE WHEN cct.CCTcktr = 'T' THEN ceb.Clave
								END as CodCtaDestino,
								CASE WHEN cct.CCTcktr = 'T' THEN cb.CBcodigo
								END as CtaDestino
							FROM Pagos p
								INNER JOIN CCTransacciones cct ON cct.CCTcodigo = p.CCTcodigo and cct.Ecodigo = p.Ecodigo
								LEFT JOIN SNegocios sn ON sn.SNcodigo = p.SNcodigo and sn.Ecodigo = p.Ecodigo
								INNER JOIN Empresa e ON e.Ereferencia = p.Ecodigo
								INNER JOIN CuentasBancos cb ON cb.Ccuenta = p.Ccuenta and cb.Ecodigo = p.Ecodigo
								INNER JOIN Bancos ban ON ban.Bid = cb.Bid
								LEFT JOIN CEBancos ceb ON ceb.Id_Banco = ban.CEBSid
								LEFT JOIN DContables dco ON dco.Ccuenta = p.Ccuenta
											AND dco.IDcontable = #retIDcontable# AND dco.Ddocumento = p.Pcodigo
							WHERE p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
						</cfquery>
					<cfcatch type="any">
					</cfcatch>
					</cftry>
	          </cfif>
                <!---SML. 05/11/2014. Inicio Modificacion para agregar la informacion Bancaria para las Polizas del SAT--->
</cffunction>

    <cffunction name="AnticipoEvento" output="no">
        <cfargument name="CCTcodigo"	type="string" 	required="yes">
        <cfargument name="Pcodigo"		type="string" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
        <cfargument name="Conexion" 	type="string" 	default="#session.DSN#">

        <!--- Genera el Numero de Evento para el Anticipo --->
        <cfquery name="rsAnticipoEV" datasource="#arguments.conexion#">
            select b.NC_CCTcodigo,
                b.NC_Ddocumento,
                a.SNcodigo
            from Pagos a
                inner join APagosCxC b
                    on a.Ecodigo   = b.Ecodigo
                   and a.CCTcodigo = b.CCTcodigo
                   and a.Pcodigo   = b.Pcodigo
            where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
              and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>

        <cfif rsAnticipoEV.recordcount GT 0 and rsAnticipoEV.NC_Ddocumento NEQ "">
            <cfinvoke component="sif.Componentes.CG_ControlEvento"
                method		= "CG_GeneraEvento"
                Origen		= "CCFC"
                Transaccion	= "#rsAnticipoEV.NC_CCTcodigo#"
                Documento 	= "#rsAnticipoEV.NC_Ddocumento#"
                SocioCodigo = "#rsAnticipoEV.SNcodigo#"
                Conexion	= "#Arguments.Conexion#"
                Ecodigo		= "#Arguments.Ecodigo#"
                returnvariable	= "arNumeroEventoAN"
            />
            <cfif arNumeroEventoAN[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
        </cfif>
    </cffunction>

	<cffunction name="PagoIEPSCxC" output="false" >
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name='CCTcodigo'	type='string' 	required='true'>	 <!--- Codigo del movimiento ---->
		<cfargument name='Pcodigo' 		type='string' 	required='true'>
		<cfargument name='conexion'		type='string' 	default="#session.DSN#">
		<cfargument name='INTARC'            type="string" 	    required='false' default=''>

		<cfquery name="rsDPagosICFIEPS" datasource="#Arguments.Conexion#">
			select distinct a.Ecodigo, a.Doc_CCTcodigo, a.Ddocumento
			from  DPagos  a
				inner join ImpIEPSDocumentosCxC b
					on  b.Ecodigo   = a.Ecodigo
					and b.CCTcodigo = a.Doc_CCTcodigo
					and b.Documento = a.Ddocumento
			where a.Ecodigo = #Arguments.Ecodigo#
			  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>

		<cfif rsDPagosICFIEPS.Recordcount GT 0>
    		<!--- IEPS Por TRASLADAR --->
    	        <cfquery datasource="#Arguments.Conexion#">
    	        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
    	        select
    	        'CCFC',
    	        1,
    	        c.Documento,
    	        c.CCTcodigo ,
    	        round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
    	        d.CCTtipo,
    	        i.Idescripcion,
    	        <cf_dbfunction name="to_sdate" args="#now()#">,
    	        a.Ptipocambio / b.DPtipocambio,
    	        #varPeriodo#,
    	        #varMes#,
    	        c.CcuentaIEPS,
    	        b.Mcodigo,
    	        doc.Ocodigo,
    	        round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2),
    	        b.NumeroEvento,a.CFid
    	        from Pagos a
    	            inner join DPagos  b
    	                inner join Documentos doc
    	                    inner join CCTransacciones d
    	                    on  d.Ecodigo    = doc.Ecodigo
    	                    and d.CCTcodigo  = doc.CCTcodigo
    	                    inner join ImpIEPSDocumentosCxC c
    	                        inner join Impuestos i
    	                        on c.Ecodigo = i.Ecodigo
    	                        and c.codIEPS = i.Icodigo
    	                        and i.CcuentaCxCAcred is not null
    	                    on  c.Ecodigo = doc.Ecodigo
    	                    and c.CCTcodigo  = doc.CCTcodigo
    	                    and c.Documento = doc.Ddocumento
    	                on doc.Ecodigo = b.Ecodigo
    	                and doc.CCTcodigo = b.Doc_CCTcodigo
    	                and doc.Ddocumento = b.Ddocumento
    	            on a.Ecodigo = b.Ecodigo
    	            and a.CCTcodigo = b.CCTcodigo
    	            and a.Pcodigo = b.Pcodigo
    	        where a.Ecodigo = #Arguments.Ecodigo#
    	          and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
    	          and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
    	          and c.TotalFac <> 0.00
    	          and c.MontoCalculado <> 0
    	    </cfquery>
    	     <!--- IEPS --->
    	    <cfquery datasource="#Arguments.Conexion#">
    	        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento,CFid)
    	        select
    	        'CCFC',
    	        1,
    	        c.Documento,
    	        c.CCTcodigo ,
    	        round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
    	        case when d.CCTtipo = 'D' then 'C' else 'D' end,
    	        <cf_dbfunction name="concat" args="i.Idescripcion,'(Trasladado)'">,
    	        <cf_dbfunction name="to_sdate" args="#now()#">,
    	        1,
    	        #varPeriodo#,
    	        #varMes#,
    	        coalesce(i.CcuentaCxCAcred,i.Ccuenta),
    	        #varMonedaLoc#,
    	        a.Ocodigo,
    	        round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2),
    	        b.NumeroEvento,a.CFid
    	        from Pagos a
    	            inner join DPagos  b
    	                inner join ImpIEPSDocumentosCxC c
    	                    inner join CCTransacciones d
    	                    on d.Ecodigo = c.Ecodigo
    	                    and d.CCTcodigo = c.CCTcodigo

    	                    inner join Impuestos i
    	                    	on  i.Ecodigo  = c.Ecodigo
    	                    	and i.Icodigo  = c.codIEPS
    	                    	and i.CcuentaCxCAcred is not null

    	                on c.Ecodigo = b.Ecodigo
    	                and c.CCTcodigo = b.Doc_CCTcodigo
    	                and c.Documento = b.Ddocumento

    	            on  b.Ecodigo   = a.Ecodigo
    	            and b.CCTcodigo = a.CCTcodigo
    	            and b.Pcodigo   = a.Pcodigo

    	        where a.Ecodigo 	= #Arguments.Ecodigo#
    	          and a.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
    	          and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
    	          and c.TotalFac <> 0.00
    	    </cfquery>
    	    <!--- fin IEPS --->
    	</cfif>

    	<cfloop query="rsDPagosICFIEPS">
			<!--- IEPS --->
			<cfquery datasource="#Arguments.Conexion#">
				update ImpIEPSDocumentosCxC
					set MontoPagado =
						coalesce(MontoPagado,0)
						+  round(
							round( ( (
								select sum(a.DPmontodoc + a.DPmontoretdoc)
								from  DPagos  a
								where a.Ecodigo = #Arguments.Ecodigo#
								  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
								  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
								  and a.Ecodigo   = ImpIEPSDocumentosCxC.Ecodigo
								  and a.Doc_CCTcodigo = ImpIEPSDocumentosCxC.CCTcodigo
								  and a.Ddocumento =  ImpIEPSDocumentosCxC.Documento
								)
							/ ImpIEPSDocumentosCxC.TotalFac ),2)
							* (ImpIEPSDocumentosCxC.MontoCalculado), 2)
				where ImpIEPSDocumentosCxC.Ecodigo = #rsDPagosICF.Ecodigo#
				  and ImpIEPSDocumentosCxC.CCTcodigo = '#rsDPagosICF.Doc_CCTcodigo#'
				  and ImpIEPSDocumentosCxC.Documento = '#rsDPagosICF.Ddocumento#'
				  and ImpIEPSDocumentosCxC.TotalFac <> 0
				  and ImpIEPSDocumentosCxC.MontoCalculado <> 0
			</cfquery>
		</cfloop>
	</cffunction>

	<cffunction name="validaAnticipo" output="no">
		<cfargument name="CCTcodigo"	type="string" 	required="yes">
        <cfargument name="Pcodigo"		type="string" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
        <cfargument name="Conexion" 	type="string" 	default="#session.DSN#">

		<cfquery name="rsValida" datasource="#Arguments.Conexion#">
			select Anti.NC_CCTcodigo, Anti.NC_Ddocumento
			 from Pagos a
				inner join APagosCxC Anti
					 on a.Ecodigo   = Anti.Ecodigo
					and a.CCTcodigo = Anti.CCTcodigo
					and a.Pcodigo	= Anti.Pcodigo
				inner join Documentos b
					 on b.Ddocumento = Anti.NC_Ddocumento
					and b.CCTcodigo  = Anti.NC_CCTcodigo
					and b.Ecodigo  	 = a.Ecodigo
			 where a.Ecodigo = #Arguments.Ecodigo#
		       and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
		       and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfif isdefined("rsValida") and rsValida.recordcount GT 0>
				<cfset ErrorAnti = ''>
			<cfloop query="rsValida">
				<cfset ErrorAnti &= rsValida.NC_CCTcodigo &' '& rsValida.NC_Ddocumento &','>
			</cfloop>
				<cfthrow message="Los siguiente Anticipos ya existen en los Documentos de CxC (Documentos):<br>" detail="#mid(ErrorAnti,1,len(ErrorAnti)-1)#">
		</cfif>
	</cffunction>

	<cffunction name="Control_Evento">
		<!---Obtiene el socio de negocios--->
	    <cfquery name="rsSocioPago" datasource="#Arguments.Conexion#">
	    	select SNcodigo
	        from SNegocios
	        where SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
	        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	    </cfquery>

	    <!--- Valido el evento --->
	    <cfinvoke
	        component		= "sif.Componentes.CG_ControlEvento"
	        method			= "ValidaEvento"
	        Origen			= "CCRE"
	        Transaccion		= "#Arguments.CCTcodigo#"
	        Conexion		= "#Arguments.Conexion#"
	        Ecodigo			= "#Arguments.Ecodigo#"
	        returnvariable	= "varValidaEvento"
	        />
	    <cfset varNumeroEvento = "">
	    <cfif varValidaEvento GT 0>
	        <cfinvoke
	            component		= "sif.Componentes.CG_ControlEvento"
	            method			= "CG_GeneraEvento"
	            Origen			= "CCRE"
	            Transaccion		= "#Arguments.CCTcodigo#"
	            Documento 		= "#Arguments.Pcodigo#"
	            SocioCodigo		= "#rsSocioPago.SNcodigo#"
	            Conexion		= "#Arguments.Conexion#"
	            Ecodigo			= "#Arguments.Ecodigo#"
	            returnvariable	= "arNumeroEvento"
	            />
	       <cfif arNumeroEvento[3] EQ "">
	            <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
	        </cfif>
	        <cfset varNumeroEvento = arNumeroEvento[3]>
	        <cfset varIDEvento = arNumeroEvento[4]>
	        <!--- Genera la relacion con las Facturas Aplicadas --->
	        <cfquery name="rsDPagosCxC" datasource="#Arguments.Conexion#">
	            select DPid,Doc_CCTcodigo,Ddocumento
	            from DPagos
	            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	               and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
	               and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	        </cfquery>
	        <cfloop query="rsDPagosCxC">
	            <cfinvoke
	                component		= "sif.Componentes.CG_ControlEvento"
	                method			= "CG_RelacionaEvento"
	                IDNEvento       = "#varIDEvento#"
	                Ecodigo			= "#Arguments.Ecodigo#"
	                Origen			= "CCFC"
	                Transaccion		= "#rsDPagosCxC.Doc_CCTcodigo#"
	                Documento 		= "#rsDPagosCxC.Ddocumento#"
	                SocioCodigo		= "#rsSocioPago.SNcodigo#"
	                Conexion		= "#Arguments.Conexion#"
	                returnvariable	= "arRelacionEvento"
	                />
	                <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
						<cfset varNumeroEventoDP = arRelacionEvento[4]>
	                <cfelse>
	                    <cfset varNumeroEventoDP = varNumeroEvento>
	                </cfif>
	            <cfquery datasource="#Arguments.Conexion#">
	                update DPagos
	                set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
	                 where Ecodigo	= #Arguments.Ecodigo#
	                   and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
	                   and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	                   and DPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDPagosCxC.DPid#">
	            </cfquery>
	        </cfloop>
	    </cfif>
	</cffunction>

	<cffunction name="ValFechaCobFac" output="no">
		<cfquery datasource="#Arguments.Conexion#" name="rsValidaPagos">
			select count(1) as cantidad
			from Pagos p
				inner join DPagos dp
						inner join Documentos d
						on d.Ecodigo = dp.Ecodigo
						and d.CCTcodigo = dp.Doc_CCTcodigo
						and d.Ddocumento = dp.Ddocumento
				on dp.Ecodigo = p.Ecodigo
				and dp.CCTcodigo = p.CCTcodigo
				and dp.Pcodigo = p.Pcodigo
			where p.Ecodigo 	= #Arguments.Ecodigo#
			  and p.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			  and p.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
			  and p.Pfecha < d.Dfecha
		</cfquery>
		<cfif rsValidaPagos.cantidad gt 0>
			<cf_errorCode	code = "51008" msg = "El documento afectado no puede tener la fecha menor a la fecha del recibo de pago! Proceso Cancelado!">
			<cfreturn 0>
		</cfif>
	</cffunction>

	<cffunction name="insertHDocumentos" output="no">
		<cfargument name="CCTcodigo"	type="string" 	required="yes">
        <cfargument name="Pcodigo"		type="string" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
        <cfargument name="Conexion" 	type="string" 	default="#session.DSN#">
		<cfquery datasource="#Arguments.Conexion#">
						insert into HDocumentos
							(
								Ecodigo, CCTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo,
								Ccuenta, Rcodigo, Icodigo, Dtipocambio, Dtotal, Dsaldo,
								Dfecha, Dvencimiento, DfechaAplicacion, Dtcultrev, Dusuario,
								Dtref, Ddocref, Dmontoretori, Dretporigen, Dreferencia,
								DEidVendedor, DEidCobrador, id_direccionFact, id_direccionEnvio,
								CFid, DEdiasVencimiento, DEordenCompra, DEnumReclamo, DEobservacion,
								DEdiasMoratorio, BMUsucodigo, EDtipocambioVal, EDtipocambioFecha
								,TESRPTCid,TESRPTCietu
							)
						select
								d.Ecodigo, d.CCTcodigo, d.Ddocumento, d.Ocodigo, d.SNcodigo, d.Mcodigo,
								d.Ccuenta, d.Rcodigo, d.Icodigo, d.Dtipocambio, d.Dtotal, d.Dsaldo,
								d.Dfecha, d.Dvencimiento, d.DfechaAplicacion, d.Dtcultrev, d.Dusuario,
								d.Dtref, d.Ddocref, d.Dmontoretori, d.Dretporigen, d.Dreferencia,
								d.DEidVendedor, d.DEidCobrador, d.id_direccionFact, d.id_direccionEnvio,
								d.CFid, d.DEdiasVencimiento, d.DEordenCompra, d.DEnumReclamo, d.DEobservacion,
								d.DEdiasMoratorio, d.BMUsucodigo,
								d.EDtipocambioVal, d.EDtipocambioFecha
								,NC_RPTCid,NC_RPTCietu
						from APagosCxC a
							inner join Documentos d
								  on d.Ecodigo      = a.Ecodigo
								 and d.CCTcodigo    = a.NC_CCTcodigo
								 and d.Ddocumento   = a.NC_Ddocumento
						where a.Ecodigo 	= #Arguments.Ecodigo#
						  and a.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
						  and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
					</cfquery>
	</cffunction>

	<cffunction name="Parametros" output="no">
		<!---====Periodo Auxiliar===============--->
		<cfquery datasource="#Arguments.Conexion#" name="rsPeriodo">
			select Pvalor as Periodo
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 50
		</cfquery>
		<cfif rsPeriodo.recordCount EQ 0>
			<cfthrow detail="La empresa no tiene definido un Periodo Auxiliar">
		<cfelse>
			<cfset varPeriodo = rsPeriodo.Periodo>
		</cfif>
		<!---====Mes Auxiliar=====================--->
		<cfquery datasource="#Arguments.Conexion#" name="rsMes">
			select Pvalor as Mes
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 60
		</cfquery>
		<cfif rsMes.recordCount EQ 0>
			<cfthrow detail="La empresa no tiene definido un Mes Auxiliar">
		<cfelse>
			<cfset varMes = rsMes.Mes>
		</cfif>
		<!---====Moneda local de la Empresa========--->
		<cfquery datasource="#Arguments.Conexion#" name="rsMonedaLocal">
			select Mcodigo as MonLoc
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsMonedaLocal.recordcount EQ 0>
			<cfthrow detail="La empresa no tiene definida una Moneda Local">
		<cfelse>
			<cfset varMonedaLocal = rsMonedaLocal.MonLoc>
		</cfif>
		<!---====Cuenta Contable de Retenciones====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaRet">
			select Pvalor as CuentaRet
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 150
		</cfquery>
		<cfif rsCuentaRet.recordcount EQ 0>
			<cfthrow detail="La empresa no tiene definida una Cuenta Contable de Retenciones">
		<cfelse>
			<cfset varCuentaRet = rsCuentaRet.CuentaRet>
		</cfif>
		<!---====Cuenta contable multimoneda=====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaPuente">
			select Pvalor as CuentaPuente
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 200
		</cfquery>
		<cfif rsCuentaPuente.recordCount EQ 0>
			<cfthrow detail="La empresa no tiene definida una Cuenta Multimoneda">
		<cfelse>
			<cfset varCuentaPuente = rsCuentaPuente.CuentaPuente>
		</cfif>
		<!---====Cuenta de Interes Corriente=====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaInteresCorriente">
			select Pvalor as CuentaInteresCorriente
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 550
		</cfquery>
		 <cfif rsCuentaInteresCorriente.recordcount LT 1 or len(trim(rsCuentaInteresCorriente.CuentaInteresCorriente)) eq 0>
			<cf_errorCode	code = "51004" msg = "No se ha definido la Cuenta de Interes Corriente! Proceso Cancelado!">
			<cfreturn 0>
		<cfelseif not isnumeric(rsCuentaInteresCorriente.CuentaInteresCorriente)>
			<cf_errorCode	code = "51005" msg = "El valor Cuenta de Interes Corriente no es un dígito numérico! Proceso Cancelado!">
			<cfreturn 0>
		<cfelse>
			<cfset varCuentaInteresCorriente = rsCuentaInteresCorriente.CuentaInteresCorriente>
		</cfif>
		<!---====Cuenta de Interes Moratorio=====--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCuentaInteresMoratorio">
			select Pvalor as CuentaInteresMoratorio
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 560
		</cfquery>
		<cfif rsCuentaInteresMoratorio.recordcount LT 1 or len(trim(rsCuentaInteresMoratorio.CuentaInteresMoratorio)) eq 0>
			<cf_errorCode	code = "51006" msg = "No se ha definido la Cuenta de Interes Moratorio! Proceso Cancelado!">
			<cfreturn 0>
		<cfelseif not isnumeric(rsCuentaInteresMoratorio.CuentaInteresMoratorio)>
			<cf_errorCode	code = "51007" msg = "El valor Cuenta de Interes Moratorio no es un dígito numérico! Proceso Cancelado!">
			<cfreturn 0>
		<cfelse>
			<cfset varCuentaInteresMoratorio = rsCuentaInteresMoratorio.CuentaInteresMoratorio>
		</cfif>
		<!---======Diferencial Cambiario========--->
		<cfquery name="rsCuentaDifCam1" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 110
		</cfquery>
		<cfif rsCuentaDifCam1.recordcount GT 0>
			<cfset varCuentaDifCam1 = rsCuentaDifCam1.Pvalor>
		</cfif>
		<cfquery name="rsCuentaDifCam2" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			  and Pcodigo = 120
		</cfquery>
		<cfif rsCuentaDifCam2.recordcount GT 0>
			<cfset varCuentaDifCam2 = rsCuentaDifCam2.Pvalor>
		</cfif>
	</cffunction>
	<cffunction name="getParametro" returntype="string">
		<cfargument name="codigo" type="string" required="true">
		<cfargument name="Ecodigo" type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" required="false" default="#session.dsn#">
		<cfset result = "">
		<cfquery datasource="#Arguments.Conexion#" name="rsParametro">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = #arguments.codigo#
		</cfquery>
		<cfif rsParametro.recordCount gt 0>
			<cfreturn rsParametro.Pvalor>
		</cfif>
		<cfreturn result>
	</cffunction>
</cfcomponent>
