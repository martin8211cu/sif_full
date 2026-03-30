<cfcomponent output="no">

<cffunction name="PosteoPagosCxC" access="public" output="false" returntype="numeric">
	<cfargument name="Ecodigo" 		     type="numeric" 	default="#session.Ecodigo#">
	<cfargument name="CCTcodigo"  	     type="string" 		default="">
	<cfargument name="Pcodigo" 		     type="string" 		default="">
	<cfargument name="Preferencia" 		 type="string" 		default="">
	<cfargument name="usuario" 		     type="string" 		default="#session.Usulogin#">
    <cfargument name="usucodigo" 		 type="string" 		default="#session.Usucodigo#">
    <cfargument name="SNid" 		     type="numeric"		default="0">
	<cfargument name="Conexion" 	     type="string" 		default="#session.DSN#">
	<cfargument name="EAid" 		     type="numeric"		default="-1" required="no">
	<cfargument name='PintaAsiento'      type="boolean" 	required='false' default='false'>
    <cfargument name='transaccionActiva' type="boolean" 	required='false' default='false'>	
    <cfargument name='Anulacion'         type="boolean" 	required='false' default='false'>
    <cfargument name='INTARC'            type="string" 	    required='false' default=''>
    <cfargument name='IntPresup'         type="string" 	    required='false' default=''>    
    <cfargument name='Tb_Calculo'        type="string" 	    required='false' default=''>	    
    <cfargument name='usaCtaSaldoFavor'  type="boolean" 	default='false'>
	<cfargument name='ETC'               type="numeric" 	required='false'  default= "-1" >
    <cfargument name='CC'                type="numeric" 	required='false' default= "0">
    <cfargument name='SinMLibros'        type="boolean" 	required='false' default='false'>
    <cfargument name='Contabilizar'      type="string" 	    required='false' default='todos'>
    <cfargument name="InvocarFacturacionElectronica" 		required="false" default="false"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
    <cfargument name="PrioridadEnvio"    type="numeric" 	required="false"  default="0">
    
 		
    <cfif Arguments.transaccionActiva>
      <cfif isdefined('arguments.CC')>            			
          	<cfset sbAplicaProceso(Arguments.Ecodigo, Arguments.CCTcodigo,Arguments.Pcodigo,Arguments.Preferencia,Arguments.usuario,Arguments.usucodigo, session.DSN, Arguments.EAid, Arguments.PintaAsiento,Arguments.transaccionActiva,arguments.Anulacion,arguments.INTARC,arguments.SNid,arguments.Tb_Calculo,arguments.IntPresup,Arguments.usaCtaSaldoFavor , Arguments.ETC ,Arguments.CC, Arguments.SinMLibros,Arguments.Contabilizar,
          				#Arguments.InvocarFacturacionElectronica#,#Arguments.PrioridadEnvio#)>
    	<cfelse>
      		<cfset sbAplicaProceso(Arguments.Ecodigo, Arguments.CCTcodigo,Arguments.Pcodigo,Arguments.Preferencia,Arguments.usuario,Arguments.usucodigo, session.DSN, Arguments.EAid, Arguments.PintaAsiento,Arguments.transaccionActiva,arguments.Anulacion,arguments.INTARC,arguments.SNid,arguments.Tb_Calculo,arguments.IntPresup,Arguments.usaCtaSaldoFavor , Arguments.ETC,Arguments.SinMLibros,Arguments.Contabilizar,
      					#Arguments.InvocarFacturacionElectronica#,#Arguments.PrioridadEnvio#)>
       </cfif>
     <cfelse>
     	<cfif isdefined('arguments.CC')>    
        	<cftransaction>            			
          		<cfset sbAplicaProceso(Arguments.Ecodigo, Arguments.CCTcodigo, Arguments.Pcodigo,Arguments.Preferencia, Arguments.usuario,Arguments.usucodigo, session.DSN, Arguments.EAid,Arguments.PintaAsiento, Arguments.transaccionActiva,arguments.Anulacion,arguments.INTARC,arguments.SNid,
								 arguments.Tb_Calculo,arguments.IntPresup,Arguments.usaCtaSaldoFavor, Arguments.ETC,Arguments.CC,Arguments.SinMLibros,Arguments.Contabilizar,#Arguments.InvocarFacturacionElectronica#,#Arguments.PrioridadEnvio#)>
         	</cftransaction>
       	<cfelse>
        	<cftransaction>            			
          		<cfset sbAplicaProceso(Arguments.Ecodigo, Arguments.CCTcodigo, Arguments.Pcodigo,Arguments.Preferencia, Arguments.usuario,Arguments.usucodigo, session.DSN, Arguments.EAid,Arguments.PintaAsiento, Arguments.transaccionActiva,arguments.Anulacion,arguments.INTARC,arguments.SNid,
								 arguments.Tb_Calculo,arguments.IntPresup,Arguments.usaCtaSaldoFavor, Arguments.ETC,Arguments.SinMLibros,Arguments.Contabilizar,#Arguments.InvocarFacturacionElectronica#,#Arguments.PrioridadEnvio#)>
         	</cftransaction>
       	</cfif>          
    </cfif>                
    
	<cfreturn 1>
</cffunction>

<cffunction name="sbAfectacionIETU" access="public"  output="false">
	<cfargument name="Oorigen"		type="string"	required="yes" >
	<cfargument name="Ecodigo"		type="numeric"	required="yes" >
	<cfargument name='CCTcodigo'	type='string' 	required='true' hint="Codigo del movimiento">
	<cfargument name='Pcodigo' 		type='string' 	required='true' hint="Codigo del movimiento">
	<cfargument name="Efecha"		type="date"		required="yes" >
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
					'#selectIETUpago.FechaPago#',
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

	<!--- Genera los movimientos de Presupuesto en Efectivo (EJERCIDO Y PAGADO) a partir del NAP de las facturas pagadas --->
	<!--- Movimientos de EJERCIDO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #Arguments.Ecodigo#
		   and Pcodigo = 1140
	</cfquery>
	<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>
	<cfif LvarGenerarEjercido>
		<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'EJ')>
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>
	<cfelse>
		<!--- Movimientos de PAGADO: Presupuesto normal --->
		<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Ecodigo,arguments.Oorigen,Arguments.Pcodigo,Arguments.CCTcodigo,arguments.Efecha,arguments.Eperiodo,arguments.Emes,false,'P')>
	</cfif>
 	<!---  <cfquery datasource="#Arguments.Conexion#" name="debug">
		select * from #request.intarc#
	</cfquery>
    <cf_dump var="#debug#">--->
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
	<cfargument name="Preferencia" 		 type="string" 		default="">
	<cfargument name="usuario" 		     type="string" 		default="#session.Usulogin#">
    <cfargument name="usucodigo" 		 type="string" 		default="#session.Usucodigo#">
	<cfargument name="Conexion" 	     type="string" 		default="#session.DSN#">
	<cfargument name="EAid" 		     type="numeric"		default="-1" required="no">
	<cfargument name='PintaAsiento'      type="boolean" 	required='false' default='false'>
    <cfargument name='transaccionActiva' type="boolean" 	required='false' default='false'>
    <cfargument name='Anulacion'         type="boolean" 	required='false' default='false'>
    <cfargument name='INTARC'            type="string"   	default=''>
    <cfargument name='SNid'              type="numeric"   	default="0">
    <cfargument name='Tb_Calculo'        type="string"   	default=''>
    <cfargument name='IntPresup'         type="string"   	default=''>    
   
    <cfargument name='usaCtaSaldoFavor'  type="boolean" 	required='false' default='false'>
	<cfargument name='ETC'               type="numeric" 	required='false' >
    <cfargument name='CC'                type="numeric" 	required='false' > 
    <cfargument name='SinMLibros'        type="boolean" 	required='false' default='false'>    
    <cfargument name='Contabilizar'      type="string"     	required="false"  default="todos">
    <cfargument name="InvocarFacturacionElectronica" 		required="false" default="true"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
    <cfargument name="PrioridadEnvio"    type="numeric" 	required="false"  default="0">
    
   	

 	<cf_dbfunction name="OP_concat" 	returnvariable="_Cat">
   <cfif isdefined('arguments.Contabilizar') and arguments.Contabilizar neq 'conta' and arguments.Contabilizar neq 'aplica' and  arguments.Contabilizar neq 'todos'>
        <cf_ErrorCode code="-1" msg="EL argumento Contabilizar no tiene ninguno de los siguientes valores:  conta, aplica, todos. Proceso cancelado.">
   </cfif>
   
    <cfif isdefined('arguments.INTARC') and len(trim(arguments.INTARC)) gt 0>
 	   <cfset INTARC = arguments.INTARC>
	</cfif>  
    
    <cfif isdefined('arguments.IntPresup') and len(trim(arguments.IntPresup)) gt 0>
 	   <cfset IntPresup = arguments.IntPresup>
	</cfif>
      
      <cfset CntlDebug = "N">
	<cfset LvarPintar = Arguments.PintaAsiento>

	<!---====Periodo Auxiliar===============--->
    <cfif isdefined('Request.Periodo') and LEN(TRIM(Request.Periodo))>
        <cfquery datasource="#Arguments.Conexion#" name="rsPeriodo">
            select #Request.Periodo# as Periodo
             from dual
        </cfquery> 
    <cfelse> 
        <cfquery datasource="#Arguments.Conexion#" name="rsPeriodo">
            select Pvalor as Periodo
            from Parametros
            where Ecodigo = #Arguments.Ecodigo# 
              and Pcodigo = 50
        </cfquery>
        <cfif rsPeriodo.recordCount EQ 0>
            <cfthrow detail="La empresa no tiene definido un Periodo Auxiliar">
        </cfif>
    </cfif>
	<!---====Mes Auxiliar=====================--->
    <cfif isdefined('Request.Mes') and LEN(TRIM(Request.Mes))>
        <cfquery datasource="#Arguments.Conexion#" name="rsMes">
            select #Request.Mes# as Mes
            from dual
        </cfquery>
    <cfelse>
        <cfquery datasource="#Arguments.Conexion#" name="rsMes">
            select Pvalor as Mes
            from Parametros
            where Ecodigo = #Arguments.Ecodigo# 
              and Pcodigo = 60
        </cfquery>
        <cfif rsMes.recordCount EQ 0>
            <cfthrow detail="La empresa no tiene definido un Mes Auxiliar">
        </cfif>
    </cfif>
  
	<!---====Moneda local de la Empresa========--->
	<cfquery datasource="#Arguments.Conexion#" name="rsMonedaLocal">
		select Mcodigo as MonLoc
		from Empresas
		where Ecodigo = #Arguments.Ecodigo# 
	</cfquery>
	<cfif rsMonedaLocal.recordcount EQ 0>
		<cfthrow detail="La empresa no tiene definida una Moneda Local">
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
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = 110		
	</cfquery>
	<cfquery name="rsCuentaDifCam2" datasource="#Arguments.Conexion#">
		select Pvalor 
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
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
		<cf_errorCode	code = "-1" msg = "El Recibo de Pago indicado no existe! Parametros: Codigo - #Arguments.CCTcodigo#| Pcodigo: #Arguments.Pcodigo# | Ecodigo: #Arguments.Ecodigo#. Proceso Cancelado!">
		<cfreturn 0>
	</cfif> 
    <cf_dbfunction name="to_char"	args="p.Pfecha"  returnvariable="Pfecha">    
    <cf_dbfunction name="to_char"	args="d.Dfecha"  returnvariable="Dfecha"> 
    <cf_dbfunction name="date_format" args="p.Pfecha,dd-mm-yyyy" returnvariable="LvarPfecha">
    <cf_dbfunction name="date_format" args="d.Dfecha,dd-mm-yyyy" returnvariable="LvarDfecha">
    <!--- ABG. Se modifica ya que la comparacion de fechas es erronea --->   
	<!---====Valida Fecha del Cobro contra fecha de Facturas====--->
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
	<!--- Se comenta la validacion pues no valida correctamente las fechas de los pagos y los documentos
	<cfif rsValidaPagos.cantidad gt 0>
		<cf_errorCode	code = "51008" msg = "El documento afectado no puede tener la fecha menor a la fecha del recibo de pago! Proceso Cancelado!">
		<cfreturn 0>
	</cfif>  --->
	<!---Obtiene las Sumatorias de el Pago y los Anticipos--->
	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoTotales" returnvariable="rsAPagosCxCTotal">
		<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
		<cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
		<cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
		<cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
	</cfinvoke> 
    
    <!---Egresos--->
    <!---Obtiene las Sumatorias de los Egresos--->
	<cfinvoke component="sif.Componentes.CC_Egresos" method="CC_GetTotalesEgresos" returnvariable="rsTotalEgresos">
		<cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
		<cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
		<cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
		<cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
		<cfinvokeargument name="Modulo"       	value="CC">
	</cfinvoke> 
    
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
       
	<cfif NumberFormat((rsPagos.Ptotal - rsAPagosCxCTotal.TotalAnticipos - rsAPagosCxCTotal.TotalCubierto + rsTotalEgresos.DiferenciaEnc),',9.00') NEQ 0.00>
    	<cfset RestTotal = rsPagos.Ptotal - rsAPagosCxCTotal.TotalAnticipos - rsAPagosCxCTotal.TotalCubierto + rsTotalEgresos.DiferenciaEnc>

    
        <cf_errorCode	code = "51010"
                    msg  = "El Documento de Pago no se encuentra en Balance: Encabezado: @errorDat_1@ Diferencia:@errorDat_4@ Detalles: @errorDat_2@ Anticipo: @errorDat_3@ La resta del encabezado + la diferencia - el anticipo - el monto del detalle es igual a: @errorDat_5@ !"
                    errorDat_1="#NumberFormat(rsPagos.Ptotal, ',9.00')#"
                    errorDat_2="#NumberFormat(rsAPagosCxCTotal.TotalCubierto, ',9.00')#"
                    errorDat_3="#NumberFormat(rsAPagosCxCTotal.TotalAnticipos, ',9.00')#"
                    errorDat_4="#NumberFormat(rsTotalEgresos.DiferenciaEnc, ',9.00')#"
                    errorDat_5="#NumberFormat((RestTotal),',9.00')#"
        >
        <cfreturn 0>
    </cfif>
  <cfif arguments.Contabilizar eq 'aplica' or arguments.Contabilizar eq 'todos'>
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
 </cfif>       
   <cfif arguments.Contabilizar eq 'conta' or arguments.Contabilizar eq 'todos'>
    <cfif Arguments.transaccionActiva  eq 'false' and len(trim(arguments.INTARC)) eq 0>
    	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
    </cfif>
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

 <!---Obtengo los pagos registrados a este recibo--->
<!--- 
      <cfinvoke component="sif.Componentes.FA_funciones" method="FPagos1" returnvariable="rsFPagos"
         Ecodigo   ="#Arguments.Ecodigo#" 
         FCid      ="#Arguments.CCTcodigo#" 
         CCTcodigo ="#Arguments.CCTcodigo#" 
         Pcodigo   ="#Arguments.Pcodigo#">
      </cfinvoke>
--->

    <cfif arguments.Contabilizar eq 'aplica' and isdefined('arguments.CC') and arguments.CC neq 0>
                  <cfquery name="rsFPagos" datasource="#Arguments.Conexion#">
                    select f.FCid,Ptotal,CCTtipo,Ptipocambio, SNnombre, fc.FCcodigo, fc.FCdesc, f.Mcodigo, f.Pfecha,f.Pusuario,
                       fp.FPdocnumero,
                       fp.FPautorizacion,
                       fp.FPmontoori,
                       fp.FPtc                    
                      from Pagos  f
                       inner join SNegocios sn
                        on sn.SNcodigo = f.SNcodigo
                       and sn.Ecodigo  = f.Ecodigo 
                       inner join PFPagos fp
                         on  fp.Pcodigo = f.Pcodigo
                         and fp.CCTcodigo = f.CCTcodigo                        
                       inner join FCajas fc 
                         on f.FCid    = fc.FCid
                        and f.Ecodigo = fc.Ecodigo 
                       inner join CCTransacciones cc
                          on f.CCTcodigo = cc.CCTcodigo 
                         and f.Ecodigo = cc.Ecodigo
                      where f.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                      and f.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                      and fp.Tipo = 'A'
                </cfquery>              
               <cfif rsFPagos.recordcount> 
                 <cfloop query="rsFPagos">                                    
                    <cfquery datasource="#arguments.conexion#">
					update Documentos
					set Dsaldo =  Dsaldo - #rsFPagos.FPmontoori#
                    where Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPdocnumero#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPautorizacion#">
                    </cfquery>
           
               
                 <!--- Se registra el movimiento en la bitacora ---->   
                 <cfquery datasource="#arguments.conexion#">
		   		   insert into BMovimientos (
					IDcontable,
					Ecodigo,
                    CCTcodigo, Ddocumento, <!---A quien estoy pagando --->
                    CCTRcodigo, DRdocumento,  <!--- Con el documento que estoy pagando, el que es a favor del cliente ---->
					BMfecha, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, 
					Dvencimiento, BMperiodo, BMmes, Ocodigo, BMusuario, 
					Dtotalloc, Dtotalref, Mcodigoref, BMmontoref, BMfactor,BMfechaExpedido					
                    )
				 select 
                    -1,
				   #Arguments.Ecodigo#,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPautorizacion#">,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPdocnumero#">,                   
                   <cf_dbfunction name="to_sdate" args="#now()#">, 
                   a.SNcodigo,
                   #rsFPagos.Mcodigo#,
                   a.Dtipocambio,
                   #rsFPagos.FPmontoori#,
                   <cfqueryparam cfsqltype="cf_sql_date" value="#lsParseDateTime(rsFPagos.Pfecha)#">,
                   <cfqueryparam cfsqltype="cf_sql_date" value="#lsParseDateTime(rsFPagos.Pfecha)#">,
                   #rsPeriodo.Periodo#,
                   #rsMes.Mes#,
                   a.Ocodigo, 
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.Pusuario#">,
                   round(#rsFPagos.FPmontoori# * a.Dtipocambio,2),
                   round(#rsFPagos.FPmontoori#,2),
                   #rsFPagos.Mcodigo#,
                   #rsFPagos.FPmontoori#,
                   #rsFPagos.FPtc#,
                   a.Dfecha
                   from Documentos a
                  	where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    and a.Ddocumento =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPdocnumero#">
                    and a.CCTcodigo  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFPagos.FPautorizacion#">                   
                  </cfquery>  
                </cfloop>
             </cfif><!--- Fin de si encontro pago con documento --->      
  </cfif><!--- fin de si es aplicando y si viene de cobros ----->

 <cfif arguments.Contabilizar eq 'conta' or arguments.Contabilizar eq 'todos'>    
	<cfif isdefined('arguments.CC') and arguments.CC neq 0>
        <!-----Obtengo el id de la caja del Pago ------>
        <cfquery name="rsCaja" datasource="#Arguments.Conexion#">
            select f.FCid,Ptotal,CCTtipo,Ptipocambio, SNnombre, fc.FCcodigo, fc.FCdesc 
              from Pagos  f
               inner join SNegocios sn
                on sn.SNcodigo = f.SNcodigo
               and sn.Ecodigo  = f.Ecodigo 
               inner join FCajas fc 
                 on f.FCid    = fc.FCid
                and f.Ecodigo = fc.Ecodigo 
               inner join CCTransacciones cc
                  on f.CCTcodigo = cc.CCTcodigo 
                 and f.Ecodigo = cc.Ecodigo
              where f.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and f.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfif isdefined('rsCaja') and len(trim(#rsCaja.FCid#)) eq 0>
            <cfthrow message="El recibo #Arguments.Pcodigo#: no tiene definida la caja. ">
        </cfif>
        <cfset arguments.FCid = rsCaja.FCid>
        <cfquery name="rsInfoCaja" datasource="#Arguments.Conexion#">
         select Ccuenta,Ocodigo, FCdesc
           from FCajas a           
           where a.FCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaja.FCid#">		 
        </cfquery> 
        <cfset LvarCuentaCaja= rsInfoCaja.Ccuenta>
		<cfif isdefined('LvarCuentaCaja') and len(trim(#LvarCuentaCaja#)) eq 0>   
            <cfthrow message="No se ha definido la Cuenta para la caja #FCdesc.FCdesc#. Proceso cancelado!">   
        </cfif> 
        <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">
        <cfinvoke component="sif.Componentes.FA_funciones" method="consultaParametro"  returnvariable="rsSQL" 
           Ecodigo ="#Arguments.Ecodigo#"
           Pcodigo ="565"
           Mcodigo ="CG">
        </cfinvoke>
        <cfset LvarCuentaTransitoriaGeneral = rsSQL.valor>
        <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(#LvarCuentaTransitoriaGeneral#)) eq 0>   
            <cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
        </cfif>        
		<cfquery datasource="#Arguments.Conexion#" name="rsTCPagos">
				select Ptipocambio as tc
				from Pagos p							
				where p.Ecodigo 	= #Arguments.Ecodigo#
				  and p.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and p.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">				 
		</cfquery>
		
        <!-----Obtengo los pagos registrados en PFPagos ------>
        <cfquery name="rsFPagos" datasource="#Arguments.Conexion#">
            select FPlinea, f.FCid, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217,    
                #rsTCPagos.tc# AS FPtc, FPmontoori,FPmontolocal,FPfechapago, Tipo, 
                f.FPtc as TC,
                FPmontoori as PagoDoc,         
              case Tipo when 'D' then FPdocnumero 
              			when 'F' then FPdocnumero 
                        when 'E' then 'Efectivo' 
                        when 'A' then FPdocnumero when 'T' then FPautorizacion 
                        when 'C' then FPdocnumero end as docNumero,
              case Tipo when 'E' then 'Efectivo' 
                        when 'T' then 'Tarjeta' 
                        when 'C' then 'Cheque' 
                        when 'D' then 'Deposito'
                        when 'F' then 'Diferencia' 
                        when 'A' then 'Documento' end as Tipodesc,
                        rtrim(coalesce(FPdocnumero,'No')) as FPdocnumero, 
                        FPdocfecha, coalesce(FPBanco,0) as FPBanco,
              case Tipo when 'E' then 
                             #rsInfoCaja.Ccuenta# 
                        when 'T' then 
                             coalesce(FPCuenta,0) 
                        when 'C' then 
                              #rsInfoCaja.Ccuenta#  
                        when 'D' then 
                             coalesce(FPCuenta,0) 
                        when 'F' then 
                             coalesce(FPCuenta,0)      
                        when 'A' then 
                             coalesce(FPCuenta,0)  end as FPCuenta,
                       FPtipotarjeta, FPautorizacion
                from PFPagos f
                inner join Monedas m
                on f.Mcodigo = m.Mcodigo           
                where f.FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCaja.FCid#">
                and f.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                and f.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery> 
        <cfif isdefined('rsFPagos') and rsFPagos.recordcount gt 0>
               
                <cfquery name="rsInfoAsiento" datasource="#session.dsn#">
                 select coalesce(a.Pserie  #_Cat# a.Pdocumento, a.Pcodigo) as documento, 'Caja:' #_Cat# f.FCcodigo as referencia,
                 Plote    
                 from Pagos a
                  inner join FCajas f
                    on a.FCid = f.FCid           
                 where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                </cfquery>       
                
            <cfloop query="rsFPagos"> 
      
                <cfif rsFPagos.Tipo EQ 'T'><!---Pago con Tarjeta ---->
                    <cfinvoke component="sif.Componentes.FA_funciones" method="TarjetaCompuesta"  returnvariable="rsTJCompuesta" 
                        FCid      ="#Arguments.FCid#" 
                        CCTcodigo ="#Arguments.CCTcodigo#"
                        Pcodigo   ="#Arguments.Pcodigo#">
                    </cfinvoke>
                    <cfset ComisionE = 0>
                    <cfset ComisionL = 0>
                     <cfset TipoDecambioTJ = 0>  <!---Guardara el tipo de cambio para cada tarjeta--->
                     <cfset TipoDecambioParaCxC = 0>  <!--- Si esta variable llega a asumir un valor es xq era de una tarjeta compesta que debe generar el cxc --->
                    <cfset LvarTJCompuesta = false>
                    <cfif rsTJCompuesta.FATcompuesta  eq 1>
                        <cfset LvarTJCompuesta = true>
                    </cfif>   
                 
                    <cfinvoke component="sif.Componentes.FA_funciones" method="PagosTarjeta"  returnvariable="rsFPagosTJ" 
                        FCid            ="#Arguments.FCid#" 
                        CCTcodigo       ="#Arguments.CCTcodigo#" 
                        Pcodigo         ="#Arguments.Pcodigo#" 
                        TotalDetalles   ="0" 
                        TJCompuesta     ="#LvarTJCompuesta#"
                        CC              ="#Arguments.CC#"
                        FATid           ="#rsTJCompuesta.FATid#"
                        FPlinea         ="#rsTJCompuesta.FPlinea#">
                        
                    </cfinvoke>                  
                    <cfloop  query="rsFPagosTJ">                    
                        <cfinvoke component="sif.Componentes.FA_funciones" method="ComisionesTJ" returnvariable="rsCom" 
                            INTARC      ="#INTARC#"          
                            Ecodigo     ="#Arguments.Ecodigo#"
                            CCTcodigo   ="#Arguments.CCTcodigo#"  
                            Pcodigo     ="#Arguments.Pcodigo#" 
                            ETdocumento ="#rsInfoAsiento.documento#" 
                            referencia  ="#rsInfoAsiento.referencia#" 
                            CC          ="#Arguments.CC#"
                            FATid       ="#rsFPagosTJ.FATid#" 
                            Total       ="#rsFPagosTJ.PagoDoc#"
                            FPtc        ="#rsFPagosTJ.FPtc#"
                            Mcodigo     ="#rsFPagosTJ.Mcodigo#"
                            FPmontoori  ="#rsFPagosTJ.FPmontoori#"
                            CCTtipo     ="#rsCaja.CCTtipo#"
                            monloc      ="#rsMonedaLocal.MonLoc#"
                            Periodo     ="#rsPeriodo.Periodo#"
                            Mes         ="#rsMes.Mes#"
                            Cuentacaja  ="#rsInfoCaja.Ccuenta#"  
                            Ocodigo     ="#rsInfoCaja.Ocodigo#">
                        </cfinvoke>  
                        <cfset ComisionE = ComisionE + rsCom.ConMonE>
                        <cfset ComisionL = ComisionL + rsCom.ConMonLoc>  
                           <cfset TipoDecambioTJ = rsFPagosTJ.FPtc>  <!---Guardara el tipo de cambio para cada tarjeta--->                   
					      <cfif LvarTJCompuesta eq true and rsFPagosTJ.FATidDcxc eq 1>
                             <cfset TipoDecambioParaCxC = rsFPagosTJ.FPtc><!--- Si entro aqui es xq es la compuesta y debe generar cxc ---> 
                          </cfif>                           
                    </cfloop>
                    
				 <cfif  TipoDecambioParaCxC neq 0 > <!---- Si es diferente a cero es xq fue compuesta y encontro la  tarjeta que va a generar cxc ---> 
                     <cfset TipoDecambioCxC = TipoDecambioParaCxC>
                 <cfelse>
                     <cfset TipoDecambioCxC = TipoDecambioTJ>
 				 </cfif>
					
                    <cfquery name="rs" datasource="#session.dsn#">
                        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES,
                        INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE)
                        values(  'FAFC',   1, '#rsInfoAsiento.documento#', '#rsInfoAsiento.referencia#',
                          round((#rsFPagosTJ.FPmontoori# * #TipoDecambioCxC#) - (#ComisionL#),2) ,  
                                    
                         'D',
                        '#rsInfoAsiento.Plote#' #_Cat# ' - CxC (al emisor):' #_Cat# '#rsFPagosTJ.FATdescripcion#',
                        <cf_dbfunction name="to_char"	args="getdate(),112">,
                        case when #rsMonedaLocal.MonLoc# != #rsFPagosTJ.Mcodigo# then #TipoDecambioCxC# else 1.00 end,
                        #rsPeriodo.Periodo#, #rsMes.Mes#,
                        0,#rsFPagosTJ.CFcuentaCobro#,
                        #rsFPagosTJ.Mcodigo#, #rsInfoCaja.Ocodigo#,                        
                           #rsFPagosTJ.FPmontoori# - (#ComisionE#)
                        ) 
                    </cfquery>
   
                				
                <cfelse>   <!---Otra forma de Pago--->  
                    <cfif rsFPagos.Tipo EQ 'D' or rsFPagos.Tipo EQ 'F'>
						 	
                        <cfinvoke component="sif.Componentes.FA_funciones" method="ObtieneCuenta" returnvariable="CuentaE">  
                            <cfinvokeargument name="Tipo" 			value="#rsFPagos.Tipo#">
                            <cfinvokeargument name="FPCuenta"  		value="#rsFPagos.FPCuenta#">
                            <cfinvokeargument name="FPdocnumero"	value="#rsFPagos.FPdocnumero# ">
                        </cfinvoke>
					</cfif>
                      <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">                  
                    <cfquery datasource="#Arguments.Conexion#">
                        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
                         select
                            'FARE',
                            1,
                            coalesce(a.Pserie #_Cat#  <cf_dbfunction name="to_char" args="a.Pdocumento">, '#Arguments.Pcodigo#'),
                            <cf_dbfunction name="concat" args="'Caja: ',' #rsCaja.FCcodigo# '">,
                            round(#rsFPagos.FPmontoori# * #rsFPagos.TC#,2),					
                             'D',					
                            <cf_dbfunction name="concat" args="'CxC: Recibo ',' #rsFPagos.Tipodesc# ',' #rsFPagos.docNumero# ', ' #mid(rsCaja.SNnombre,1,30)# ' ">,
                            '#DateFormat(rsFPagos.FPfechapago,'dd/mm/yy')#',
                            #rsFPagos.TC#,
                            #rsPeriodo.Periodo#,
                            #rsmes.Mes#,
                            <cfif rsFPagos.Tipo EQ 'E' or  rsFPagos.Tipo EQ 'C'>
                              #LvarCuentaCaja#,
                            <cfelseif rsFPagos.Tipo EQ 'D' or rsFPagos.Tipo EQ 'F'> 
							 #CuentaE.valor#,
							<cfelse>
                             #rsFPagos.FPCuenta#, 
                            </cfif>
                            #rsFPagos.Mcodigo#,
                            a.Ocodigo,
                            round(#rsFPagos.FPmontoori#,2)
                        from Pagos a 
                          <!--- inner join Documentos c
                                on a.Ecodigo = c.Ecodigo
                                and a.Doc_CCTcodigo = c.CCTcodigo
                                and a.Ddocumento = c.Ddocumento    --->             
                        where a.Ecodigo   = #Arguments.Ecodigo#
                          and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                          and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                    </cfquery>              
                </cfif> 
            </cfloop>
        </cfif>  <!---Cierra isdefined('rsFPagos') and rsFPagos.recordcount gt 0--->
          <cfinvoke component="sif.Componentes.balanceAsientos" method="balance_Intarc" returnvariable="balance_status">
				<cfinvokeargument name="Conexion" 			value="#session.dsn#">
				<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
				<cfinvokeargument name="TB_Intarc" 			value="#INTARC# ">
		  </cfinvoke>	       
    </cfif> <!---cierra este if isdefined('arguments.CC') and arguments.CC neq 0--->

   		        
	<cfif rsDPagosICF.Recordcount GT 0>
		<!--- Generar el Asiento Contable por los montos de Impuesto Crédito Fiscal --->
        <!--- Monto original:  (Monto Pagado + Monto Retenido) / Total de Documento * Impuesto   en la moneda de la factura                     ---> 
        <!--- Monto local:     (Monto Pagado + Monto Retenido) / Total de Documento * Impuesto * Factor de Conversion * Tipo de Cambio del pago ---> 
        <cfquery datasource="#Arguments.Conexion#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            
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
            round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2)
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
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        
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
            round( round(( (b.DPmontodoc + b.DPmontoretdoc) / c.TotalFac * (c.MontoCalculado) ) ,2) / b.DPtipocambio * a.Ptipocambio,2)
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
	</cfif> <!---Cierra el rsDPagosICF.Recordcount GT 0--->

	<!--- 
    2) Asiento Contable
    2a) Débito: Monto Recibo de Dinero
    --->
    <cfquery name="rsTipoPago" datasource="#session.dsn#">
         select CCTcktr as tipo from CCTransacciones 
             where Ecodigo = #Arguments.Ecodigo# 
             and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
    </cfquery>
    
    <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
    	select  Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
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
        	<cfinvoke component="sif.Componentes.FA_CuentasTransitorias" method="FA_cuentastransitorias" returnvariable="incos">
                <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>    
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
        <cfif isdefined('arguments.ETC') and len(trim(#arguments.ETC#)) gt 0 and arguments.ETC neq -1> 
     		<cfset LvarTCpago = arguments.ETC>
    	<cfelse>
     		<cfset LvarTCpago = rsDatos.Ptipocambio>
    	</cfif>
       <cfinvoke component="sif.fa.operacion.CostosAuto" method="Cons_CostosIngresos" returnvariable="incos">
            <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>    
            <cfinvokeargument name="SNid"	    value="#arguments.SNid#"/>
            <cfinvokeargument name="incos"	    value="#arguments.Tb_Calculo#"/>
            <cfinvokeargument name="TIPO"	    value="FA"/>
            <cfinvokeargument name="ETtc"	    value="#LvarTCpago#"/>                            
            <cfinvokeargument name="Monloc"	    value="#LvarMonloc#"/>   
            <cfinvokeargument name="CCTcodigo"	value="#Arguments.CCTcodigo#"/>   
            <cfinvokeargument name="Pcodigo"	    value="#Arguments.Pcodigo#"/>
            <cfinvokeargument name="INTARC"	    value="#INTARC#"/>   
		</cfinvoke>    
	</cfif>
   
    <cfif isdefined('rsTipoPago') and rsTipoPago.tipo eq 'P' and arguments.CC EQ 0>
        <!--- 2) Crédito: Documentos Afectados --->
        <cfquery datasource="#Arguments.Conexion#" name="rsKK">
                insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
                    ,2)
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
	<cfelseif  isdefined('arguments.CC') AND arguments.CC EQ 0> <!--- JERM --->
    	<cfquery datasource="#Arguments.Conexion#">
          insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            select 
                'CCRE',
                1,
                coalesce(a.Pserie #_Cat# <cf_dbfunction name="to_char" args="a.Pdocumento">, a.Pcodigo),
                a.CCTcodigo, 
                round(a.Ptotal * a.Ptipocambio,2),
                <cfif Arguments.Anulacion eq 'true'>
                 'C',
                <cfelse>
                 'D',
                </cfif>
                <cf_dbfunction name="concat" args="'CxC: Recibo de Pago ',Pcodigo,'#LvarSocioNegocio#'">,
                '#LvarFechaCar#',
                a.Ptipocambio,
                #rsPeriodo.Periodo#,
                #rsmes.Mes#,
                case when a.Ccuenta is null then b.Ccuenta else a.Ccuenta end as ccuenta,
                a.Mcodigo,
                a.Ocodigo,
                a.Ptotal
            from Pagos a
                 left outer join CuentasBancos b
                    on a.CBid = b.CBid
            where a.Ecodigo = #Arguments.Ecodigo#
              and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
		</cfquery>   
	</cfif>

	
    <cfif rsTotalEgresos.DiferenciaEnc NEQ 0>
        <cfinvoke component="sif.Componentes.CC_Egresos" method="CC_GetDiferencias" returnvariable="rsDiferencias">
            <cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
            <cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
            <cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
            <cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
            <cfinvokeargument name="Modulo"       	value="CC">
        </cfinvoke>    
        <cfloop query="rsDiferencias">
            <!---Diferencias--->
            <cfquery datasource="#Arguments.Conexion#">
                insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
                select 
                    'CCDF',
                    1,
                    coalesce(a.Pserie #_Cat# <cf_dbfunction name="to_char" args="a.Pdocumento">, a.Pcodigo),
                    a.CCTcodigo, 
                    round(#rsDiferencias.COMDmonto# * a.Ptipocambio,2),
                    <cfif Arguments.Anulacion eq 'true'>
                     'C',
                    <cfelse>
                     'D',
                    </cfif>
                    <cf_dbfunction name="concat" args="'CxC: Diferencia ',Pcodigo,'#rsDiferencias.DIFEcodigo#'">,
                    '#LvarFechaCar#',
                    a.Ptipocambio,
                    #rsPeriodo.Periodo#,
                    #rsmes.Mes#,
                    #rsDiferencias.Ccuenta# ccuenta,
                    a.Mcodigo,
                    a.Ocodigo,
                    round(#rsDiferencias.COMDmonto#,2)
                from Pagos a
                where a.Ecodigo = #Arguments.Ecodigo#
                  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
            </cfquery>        
        </cfloop>
	</cfif>
    <cfif rsTotalEgresos.ComisionesEncabezado gt 0>
        <cfinvoke component="sif.Componentes.CC_Egresos" method="CC_InsertaIntarcComisiones">
            <cfinvokeargument name="INTARC" 	    value="#INTARC#">
            <cfinvokeargument name="Conexion" 	    value="#Arguments.Conexion#">
            <cfinvokeargument name="Ecodigo" 	    value="#Arguments.Ecodigo#">
            <cfinvokeargument name="CCTcodigo"      value="#Arguments.CCTcodigo#">
            <cfinvokeargument name="Pcodigo"       	value="#Arguments.Pcodigo#">
            <cfinvokeargument name="Modulo"       	value="CC">
        </cfinvoke> 

		<!--- 2c) Crédito: Comisiones
        <cfquery datasource="#Arguments.Conexion#" name="rsKK">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            select 
            'CCco',
            1,
            b.Pcodigo,
            b.CCTcodigo,
            round(#rsTotalEgresos.ComisionesEncabezado# * b.Ptipocambio,2),
            'C',
            <cf_dbfunction name="concat" args="'CxC: Comision ',b.CCTcodigo,'-',b.Pcodigo,'#LvarSocioNegocio#'">,
            '#LvarFechaCar#',
            case when #rsMonedaLocal.MonLoc# = b.Mcodigo then  1.00 else b.Ptipocambio end,
            #rsPeriodo.Periodo#,
            #rsmes.Mes#,
            b.Ccuenta,
            b.Mcodigo,
            b.Ocodigo,
           <!--- round(#rsTotalEgresos.ComisionesEncabezado#,2) --->
            round(#rsTotalEgresos.ComisionesEncabezado# * b.Ptipocambio,2)
            from Pagos b
            where b.Ecodigo = #Arguments.Ecodigo#
              and b.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and b.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>       --->
    
    </cfif>

   
    <!--- 2b) Débito : Cálculo de la Retención x Documento ---> <!--- JERM --->
    <cfquery datasource="#arguments.Conexion#">
        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
            a.DPmontoretdoc
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

    <!--- 2c) Crédito: Documentos Afectados ---> <!--- JERM --->
    <cfquery datasource="#Arguments.Conexion#" name="rsKK">
  		insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        select 
        'CCRE',
        1,
        a.Ddocumento,
        a.Doc_CCTcodigo,
        <!---Monto del doc + retencion--->
        case when coalesce(a.DPmontoretdoc,0.00) <> 0.00 
          then round((round(a.DPmontodoc,2) + a.DPmontoretdoc - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) / a.DPtipocambio * b.Ptipocambio,2) 
            else round((round(a.DPtotal,2) - coalesce(pp.PPpagointeres, 0) - coalesce(pp.PPpagomora, 0)) * b.Ptipocambio,2) 
        end
        
        <!---+ Comisiones --->
        +	coalesce(round (
                (select sum(
                  case when  VolumenGNCheck 		= 1 then VolumenGN 			else 0 end
                + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		else 0 end
                + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		else 0 end
                + case when  ProntoPagoCheck 		= 1 then ProntoPago 		else 0 end
                + case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente 	else 0 end
                + case when  montoAgenciaCheck 		= 1 then montoAgencia 		else 0 end
                )
            from COMFacturas comf
            where comf.PcodigoE 	= b.Pcodigo
            and   comf.CCTcodigoE	= b.CCTcodigo
            
            and   comf.Ddocumento   = c.Ddocumento
            )   <!--- / comentado el TC xq ya estan colonizadas a.DPtipocambio * b.Ptipocambio--->,2) ,0)
         
        ,
        'C',
        <cf_dbfunction name="concat" args="Coalesce(b.Plote,''); ' - CxC: Pago Documento ';Coalesce(a.Doc_CCTcodigo,'');'-';Coalesce(a.Ddocumento,'');' #LvarSocioNegocio#'" delimiters=";">,
        '#LvarFechaCar#',
        case when #rsMonedaLocal.MonLoc# = b.Mcodigo and #rsMonedaLocal.MonLoc# = a.Mcodigo then 
              1.00
        when #rsMonedaLocal.MonLoc#  = b.Mcodigo and #rsMonedaLocal.MonLoc# <> a.Mcodigo then 				     
              (((a.DPmontodoc + a.DPmontoretdoc) * case when b.Mcodigo = #rsMonedaLocal.MonLoc# then (a.DPmonto/a.DPmontodoc) else b.Ptipocambio end )/(a.DPmontodoc + a.DPmontoretdoc) 
                                             )
        when #rsMonedaLocal.MonLoc# <> b.Mcodigo and #rsMonedaLocal.MonLoc# = a.Mcodigo then 
            1.00
        when #rsMonedaLocal.MonLoc# <> b.Mcodigo and #rsMonedaLocal.MonLoc# <> a.Mcodigo then
              b.Ptipocambio
       end,
        #rsPeriodo.Periodo#,
        #rsmes.Mes#,
        c.Ccuenta,
        c.Mcodigo,
        c.Ocodigo,
        round(
            case 
                when coalesce(a.DPmontoretdoc,0.00) <> 0.00 
               then round(round(a.DPmontodoc,2) + a.DPmontoretdoc - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2) 
                else 
                    round(round(a.DPtotal,2) - coalesce(pp.PPpagointeres,0) - coalesce(pp.PPpagomora,0),2) 
                end
				
				<!---+ Comisiones --->
                +	coalesce((select sum(
                          case when  VolumenGNCheck 		= 1 then VolumenGN 			else 0 end
                        + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		else 0 end
                        + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		else 0 end
                        + case when  ProntoPagoCheck 		= 1 then ProntoPago 		else 0 end
                        + case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente 	else 0 end
                        + case when  montoAgenciaCheck 		= 1 then montoAgencia 		else 0 end
                        )
                    from COMFacturas comf
                    where comf.PcodigoE 	= b.Pcodigo
                    and   comf.CCTcodigoE	= b.CCTcodigo
                   
                    and   comf.Ddocumento   = c.Ddocumento
                     
                	  	) /  b.Ptipocambio ,0) <!---se divide por el TC ya que las comisiones estan en moneda local y se pone en moneda extranjera--->
            ,2)
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
        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
            pp.PPpagointeres
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
        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
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
            pp.PPpagomora
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
        insert into #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo, INTMOE, INTMON, Mcodigo, INTCAM)
        select 
            'CCRE',
            1,
            coalesce(a.Pserie #_Cat# <cf_dbfunction name="to_char" args="a.Pdocumento">, a.Pcodigo),
            a.CCTcodigo,
            <cfif Arguments.Anulacion eq 'true'>
            'D',
            <cfelse>
            'C',
            </cfif>
            <cf_dbfunction name="concat" args="'CxC: ',d.NC_CCTcodigo,'-',d.NC_Ddocumento,'-',a.Pcodigo">,
            '#LvarFechaCar#',
            #rsPeriodo.Periodo#,
            #rsmes.Mes#,
            coalesce (coalesce(d.NC_Ccuenta,sn.SNcuentacxc),<cf_dbfunction name="to_number" args="c.Pvalor">),
            a.Ocodigo,
            coalesce(d.NC_total,0.00),
            round(coalesce(d.NC_total,0.00) * a.Ptipocambio,2),
            a.Mcodigo,
            case when a.Mcodigo <> #rsMonedaLocal.MonLoc# then a.Ptipocambio else 1 end
        from Pagos a
            inner join Parametros c
                on c.Ecodigo = a.Ecodigo
               and c.Pcodigo = 180
            inner join APagosCxC d
                on d.Ecodigo   = a.Ecodigo 
               and d.CCTcodigo = a.CCTcodigo
               and d.Pcodigo   = a.Pcodigo
           inner join SNegocios sn
             on d.SNcodigo = sn.SNcodigo
            and d.Ecodigo  = sn.Ecodigo    
        where a.Ecodigo   = #Arguments.Ecodigo#
          and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
          and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">					  
	</cfquery>
    
      <cfinvoke component="sif.Componentes.balanceAsientos" method="balance_Intarc" returnvariable="balance_status">
            <cfinvokeargument name="Conexion" 			value="#session.dsn#">
            <cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
            <cfinvokeargument name="TB_Intarc" 			value="#INTARC# ">
      </cfinvoke>	      
   
    
    <!--- 3) Asiento de Diferencial Cambiario ---> <!--- JERM --->
    <cfquery datasource="#Arguments.Conexion#">
        insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        select 
            'CCRE',
            1,
            a.Ddocumento,
            a.CCTcodigo, 
            abs( round( (b.DPmontodoc + b.DPmontoretdoc) 
                            * (a.Dtcultrev - (
                                                 ((b.DPmontodoc + b.DPmontoretdoc) *
                                                  case when d.Mcodigo = #rsMonedaLocal.MonLoc# then (b.DPmonto/b.DPmontodoc) else d.Ptipocambio end 
                                                  )
                                                 /(b.DPmontodoc + b.DPmontoretdoc) 
                                             )
                              ) 
                         ,2)
                    )
                 ,
            case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) >= 0 then 'C' else 'D' end,
            'CxC: Diferencial Cambiario:',
            '#LvarFechaCar#',
            1.00,
            #rsPeriodo.Periodo#,
            #rsmes.Mes#,
            a.Ccuenta,
            a.Mcodigo,
            d.Ocodigo,
            0.00
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
    
</cfif>  <!---cierra la condicion para hacer esto solo si se va a contabilizar o aplicacion directa --->	  

   	<cfset sbAplicaProceso2(#Arguments.Ecodigo#, #Arguments.CCTcodigo#,#Arguments.Pcodigo#,#Arguments.Preferencia#,
      #Arguments.usuario#, #Arguments.usucodigo#, #session.DSN#, #Arguments.EAid#,#Arguments.PintaAsiento#,#arguments.transaccionActiva#,#arguments.INTARC#,#arguments.SNid#,#arguments.Tb_Calculo#,#arguments.IntPresup#,#Arguments.usaCtaSaldoFavor#, #Arguments.ETC#, #Arguments.CC#, #Arguments.SinMLibros#, #Arguments.Contabilizar#,#Arguments.InvocarFacturacionElectronica#,#Arguments.PrioridadEnvio#)>

</cffunction>
			
			
<cffunction name="sbAplicaProceso2" access="public">
   	<cfargument name="Ecodigo" 		     type="numeric" 		default="#session.Ecodigo#">
	<cfargument name="CCTcodigo"  	     type="string" 		default="">
	<cfargument name="Pcodigo" 		     type="string" 		default="">
	<cfargument name="Preferencia" 		 type="string" 		default="">
	<cfargument name="usuario" 		     type="string" 		default="#session.Usulogin#">
    <cfargument name="usucodigo" 		 type="string" 		default="#session.Usucodigo#">
	<cfargument name="Conexion" 	     type="string" 		default="#session.DSN#">
	<cfargument name="EAid" 		     type="numeric"		default="-1" required="no">
	<cfargument name='PintaAsiento'      type="boolean" 	required='false' default='false'>
    <cfargument name='transaccionActiva' type="boolean" 	required='false' default='false'>
    <cfargument name='INTARC'            type="string"   	default=''>
    <cfargument name='SNid'              type="numeric"   	default="0">
    <cfargument name='Tb_Calculo'        type="string"   	default=''>
    <cfargument name='IntPresup'         type="string"   	default=''> 
	<cfargument name='usaCtaSaldoFavor'  type="boolean" 	required='false' default='false'>
	<cfargument name='ETC'               type="numeric" 	required='false' >
    <cfargument name='CC'                type="numeric" 	required='false' default="0">
    <cfargument name='SinMLibros'        type="boolean" 	required='false' default='false'>
    <cfargument name='Contabilizar'      type="string" 	    required="false" default="todos">
    <cfargument name="InvocarFacturacionElectronica" 		required="false" default="true"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
    <cfargument name="PrioridadEnvio"    type="numeric" 	required="false"  default="0">

    <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">

    <cfif isdefined('arguments.Contabilizar') and arguments.Contabilizar neq 'conta' and arguments.Contabilizar neq 'aplica' and  arguments.Contabilizar neq 'todos'>
        <cf_errorcode msg="EL argumento Contabilizar no tiene ninguno de los siguientes valores:  conta, aplica, todos. Proceso cancelado.">
   </cfif>


 <cfif arguments.Contabilizar eq 'conta' or arguments.Contabilizar eq 'todos'>   			
	<!---<cflock name="CCPosteoPagosCxC#session.Ecodigo#" timeout="20" type="exclusive">	--->
		<!---- CxC: Perdida por Dif. Cambiario------>   <!--- JERM --->
        <cfquery datasource="#Arguments.Conexion#">
            insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            select 
                'CCRE',
                1,
                a.Ddocumento,
                a.CCTcodigo,
               abs( round( (b.DPmontodoc + b.DPmontoretdoc) 
                                * (a.Dtcultrev - (
                                                     ((b.DPmontodoc + b.DPmontoretdoc) * case when d.Mcodigo = #rsMonedaLocal.MonLoc# then (b.DPmonto/b.DPmontodoc) else d.Ptipocambio end )/(b.DPmontodoc + b.DPmontoretdoc) 
                                                 )
                                  ) 
                             ,2)
                        ),
                case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) < 0 then 'C' else 'D' end,
                case when round( (b.DPmontodoc + b.DPmontoretdoc) * (a.Dtcultrev - (round( (b.DPmontodoc + b.DPmontoretdoc) / b.DPtipocambio * d.Ptipocambio,2) / round(b.DPmontodoc + b.DPmontoretdoc ,2))) ,2) < 0 then <cf_dbfunction name="concat" args="'CxC: Ingreso por Dif. Cambiario Doc ',a.Ddocumento"> else <cf_dbfunction name="concat" args="'CxC: Perdida por Dif. Cambiario Doc:',a.Ddocumento">end,
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
                0.00
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

        <cfquery name="rsBalanceAsientoinferior1" datasource="#arguments.conexion#">
            select 	Ocodigo, sum(case when INTTIP = 'D' then INTMON else -INTMON end) 	as DIF, 
                    sum(0.005) 													as PERMIT,  <!--- 0.005 --->
                    sum(case when INTTIP = 'D' then INTMON end) 				as DBS, 
                    sum(case when INTTIP = 'C' then INTMON end) 				as CRS
              from #request.INTARC#
              group by Ocodigo
        </cfquery>
         
        <cfif  abs(rsBalanceAsientoinferior1.DIF) gt 0.00 and  abs(rsBalanceAsientoinferior1.DIF) lte 1000 and rsBalanceAsientoinferior1.recordcount eq 1>
        	       
		        <cfquery name="rsCuentaAjustePorRedondeo" datasource="#arguments.conexion#">
		            select Pvalor
		            from Parametros
		            where Ecodigo =  #Session.Ecodigo# 
		                and Pcodigo = 100
		        </cfquery> 
		        <cfif rsCuentaAjustePorRedondeo.recordcount eq 0 or !len(trim(rsCuentaAjustePorRedondeo.Pvalor))>
		        	<cf_errorCode	code = "-1" msg = "La cuenta de ajuste por monedas no ha sido definida para la empresa. Proceso Cancelado!">
		        </cfif>

                <cfquery datasource="#Arguments.Conexion#">
                insert into #INTARC#
                    ( 
                        Ocodigo, Mcodigo, INTCAM, 
                        INTORI, INTREL, INTDOC, INTREF, 
                        INTFEC, Periodo, Mes, 
                        INTTIP, INTDES, 
                        CFcuenta, Ccuenta, 
                        INTMOE, INTMON
                    )
               values(                
                        #rsBalanceAsientoinferior1.Ocodigo#, #rsMonedaLocal.MonLoc# , 1, 
                         'CCRE', 1, '#Arguments.Pcodigo#', '#Arguments.CCTcodigo#', 
                        '#LvarFechaCar#', 
                        #rsPeriodo.Periodo#,
                        #rsmes.Mes#,
                        <cfif rsBalanceAsientoinferior1.DIF gt 0>
                          'C',
                        <cfelse>
                          'D',      
                        </cfif>                          
                        'Ajuste por redondeo moneda local', 
                        null, #rsCuentaAjustePorRedondeo.Pvalor#, 
                        abs(#rsBalanceAsientoinferior1.DIF#),
                        abs(#rsBalanceAsientoinferior1.DIF#)
                 )
            </cfquery>

        </cfif>




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
                        INTMOE, INTMON
                    )
                select 
                        Ocodigo, i.Mcodigo, round(INTCAM,10), 
                        min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
                        min(INTFEC), min(Periodo), min(Mes), 
                        'D', 'Balance entre Monedas', 
                        null, #rsCuentaPuente.CuentaPuente#, 
                        -sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
                        -sum(case when INTTIP = 'D' then INTMON else -INTMON end)
                  from #INTARC# i
                 where i.Mcodigo in
                    (
                        select Mcodigo
                          from #INTARC#
                         group by Mcodigo
                        having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
                    )
                group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10)
                having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
            </cfquery>
        </cfif>         
       
        <!--- 
        <cfset sbAfectacionIETU("CCRE", Arguments.Ecodigo, Arguments.CCTcodigo, Arguments.Pcodigo, 
                                #rsPagos.Pfecha#, #rsPeriodo.Periodo#, #rsmes.Mes#,
                                Arguments.conexion)>
   		--->
      

        <cfif LvarPintar>
            <cfset LvarNAP = 0>
        <cfelse>	
            <cfset LvarNAP = sbControlPresupuesto_PagosCxC (
                    Arguments.Ecodigo, "CCRE", Arguments.Pcodigo, Arguments.CCTcodigo,
                    rsPagos.DatePfecha, rsPeriodo.Periodo, rsmes.Mes,
                    Arguments.conexion)>
        </cfif>    
      
          
        <!--- 5) Ejecutar el Genera Asiento --->
        <cfinvoke component="CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
            Ecodigo		    = "#Arguments.Ecodigo#"
            Oorigen 		= "CCRE"
            Eperiodo		= "#rsPeriodo.Periodo#"
            Emes			= "#rsmes.Mes#"
            Efecha			= "#rsPagos.DatePfecha#"
            Edescripcion	= "#LvarDescripcion#"
            Edocbase		= "#Arguments.Pcodigo#"
            Ereferencia		= "#Arguments.CCTcodigo#"
            usuario 		= "#Arguments.usuario#"
            Ocodigo 		= "#rsPagos.Ocodigo#"
            Usucodigo 		= "#Arguments.usucodigo#"          
            NAP				= "#LvarNAP#"
            conexion		= "#Arguments.Conexion#"
            debug			= "false"
            PintaAsiento	= "#LvarPintar#"
            Contabilizar    = "#Arguments.Contabilizar#"/> 

        <cfif Arguments.Contabilizar EQ 'conta'>
        	<cfquery datasource="#session.dsn#">
	        	update BMovimientos
	        		set IDcontable = #retIDcontable#
	        	from Pagos 
	        	where Pagos.Ecodigo   = #Arguments.Ecodigo#
	              and Pagos.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
	              and Pagos.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	              and BMovimientos.CCTcodigo = Pagos.CCTcodigo
	              and BMovimientos.Ecodigo = Pagos.Ecodigo
	              and BMovimientos.Ddocumento = Pagos.Pserie #_Cat# coalesce(Pagos.Pdocumento,Pagos.Pcodigo)
        	</cfquery>
            <cfquery datasource="#session.dsn#">
	        	update BMovimientos
	        		set IDcontable = #retIDcontable#
	        	from Pagos 
	        	where Pagos.Ecodigo   = #Arguments.Ecodigo#
	              and Pagos.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
	              and Pagos.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
	              and BMovimientos.CCTRcodigo = Pagos.CCTcodigo
	              and BMovimientos.Ecodigo = Pagos.Ecodigo
	              and BMovimientos.DRdocumento = Pagos.Pserie #_Cat# coalesce(Pagos.Pdocumento,Pagos.Pcodigo)
                  and coalesce(IDcontable, -1) = -1
        	</cfquery>
            <cfquery datasource="#session.dsn#">
	        	update HPagos
	        		set IDcontable = #retIDcontable#
	        	where HPagos.Ecodigo   = #Arguments.Ecodigo#
	              and HPagos.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
	              and HPagos.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        	</cfquery>
        </cfif>


        <cfinvoke component="IETU" method="IETU_ActualizaIDcontable" >
            <cfinvokeargument name="IDcontable"	value="#retIDcontable#">
            <cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
        </cfinvoke>	        
</cfif>  <!---cierra la condicion para hacer esto solo si se va a contabilizar o aplicacion directa --->

<cfif arguments.Contabilizar eq 'aplica' or arguments.Contabilizar eq 'todos' or arguments.Contabilizar eq 'conta'>         
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

        <cfquery name="rsEsNC" datasource="#Arguments.Conexion#"><!--- pregunta si PfacturaContado es D para meter la referencia ---> 
        select PfacturaContado
		from Pagos 
         where Ecodigo   = #Arguments.Ecodigo#
              and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>    
         
        <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">      
  
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
                IDcontable,
                BMmontoretori
            <cfif Arguments.EAid NEQ -1>
                ,EAid
            </cfif>
                ,BMlote  
              <cfif isdefined('rsEsNC.PfacturaContado') and rsEsNC.PfacturaContado eq 'D'>                      
                ,BMtref
                ,BMdocref 
               </cfif> 
               ,BMfechaExpedido
                )
            select 
                c.Ecodigo, 
                c.CCTcodigo, 
                Coalesce(c.Pserie,'') #_Cat# coalesce(c.Pdocumento,c.Pcodigo,''),  
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
                b.DPmontodoc + b.DPmontoretdoc
                 +	coalesce((select sum(
                          case when  VolumenGNCheck 		= 1 then VolumenGN 			/ COMtipoCambio else 0 end
                        + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		/ COMtipoCambio else 0 end
                        + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		/ COMtipoCambio else 0 end
                        + case when  ProntoPagoCheck 		= 1 then ProntoPago 		/ COMtipoCambio else 0 end
                        + case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente 	/ COMtipoCambio else 0 end
                        + case when  montoAgenciaCheck 		= 1 then montoAgencia 		/ COMtipoCambio else 0 end
                        )
                    from COMFacturas comf
                    where comf.PcodigoE 	= c.Pcodigo
                    and   comf.CCTcodigoE	= c.CCTcodigo
                    and   comf.Ddocumento   = b.Ddocumento
                     
                	) ,0)                
                , 
                a.Mcodigo, 
                b.DPmontodoc, 
                b.DPtipocambio,
                -1,
                DPmontoretdoc
            <cfif Arguments.EAid NEQ -1>	
                ,#Arguments.EAid#
            </cfif>
                ,Coalesce(c.Plote,'')
                <cfif isdefined('rsEsNC.PfacturaContado') and rsEsNC.PfacturaContado eq 'D'>    
                ,c.CCTcodigo 
                ,c.Pcodigo
                </cfif>
                ,fechaExpedido
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
		
        <cfset session.fa.listaFacturasEnviarElectronica = "">
        <cfloop query="rsDPagos">
            <!--- 7) Actualizar el saldo de los documentos que se estan pagando  y el monto acumulado de retenciones --->
			<cfquery datasource="#Arguments.Conexion#" name="rsCostos">
				select Coalesce(sum(abs(  DPmontodoc 
										+ DPmontoretdoc 
										+ case when  VolumenGNCheck 		= 1 then VolumenGN 			/ coalesce(COMtipoCambio,1) else 0 end
										+ case when  VolumenGLRCheck 		= 1 then VolumenGLR 		/ coalesce(COMtipoCambio,1) else 0 end
										+ case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		/ coalesce(COMtipoCambio,1) else 0 end
										+ case when  ProntoPagoCheck 		= 1 then ProntoPago 		/ coalesce(COMtipoCambio,1) else 0 end
										+ case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente 	/ coalesce(COMtipoCambio,1) else 0 end
										+ case when  montoAgenciaCheck 		= 1 then montoAgencia 		/ coalesce(COMtipoCambio,1) else 0 end
                                        ) 
                                     )  
						        ,0) monto      
                                               
				from DPagos c
					left outer join COMFacturas comf
						 on comf.PcodigoE 	= c.Pcodigo
						and comf.CCTcodigoE	= c.CCTcodigo
						and comf.Ddocumento = c.Ddocumento            
				where c.Pcodigo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and c.CCTcodigo     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and c.Ecodigo       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDPagos.Ecodigo#">
				  and c.Doc_CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDPagos.Doc_CCTcodigo#">
				  and c.Ddocumento    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDPagos.Ddocumento#">
			</cfquery>
			
            <cfquery datasource="#Arguments.Conexion#">
                update Documentos 
                set 
                    Dsaldo = Dsaldo - #rsCostos.monto#,
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


            <!--- 
            	Se agrega la funcionalidad de facturación electrónica  
				Se verifica que se esta pagando un documento de factruación
				Se verifica que el documento esta pagado en su totalidad para enviar la factrua a facturación digital
        	--->
        	<cfquery name="rsVerificaDocumentoFA" datasource="#session.dsn#">
        		select b.ETnumero,b.FCid, a.Dsaldo
				from Documentos a
				    inner join ETransacciones b
				    	on a.ETnumero = b.ETnumero
				where a.Ddocumento = '#rsDPagos.Ddocumento#'
					and a.CCTcodigo = '#rsDPagos.Doc_CCTcodigo#'
					and a.Ecodigo = #rsDPagos.Ecodigo#
        	</cfquery>

        	<cfif len(trim(rsVerificaDocumentoFA.ETnumero)) GT 0 and rsVerificaDocumentoFA.Dsaldo EQ 0>
        		<cfquery name="rsFacturaDigital" datasource="#session.dsn#">
		         	select Pvalor as usa from Parametros 
		          	where Pcodigo = 16317  
		            	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" > 
		        </cfquery> 

        		<!--- Invoca El envio a facturacion electronica, unicamente si el parametro asi lo indica, si no es asi, se invoca desde otro lado--->
			    <cfif isDefined("Arguments.InvocarFacturacionElectronica") and Arguments.InvocarFacturacionElectronica NEQ false>
			      	<cfif rsFacturaDigital.usa eq 1>
			        <!--- Invocamos el envio a facturacion electronica WS --->
			          	<cfinvoke  component="sif.Componentes.FA_funciones" method="FacturaElectronica" returnvariable="any">
			              	<cfinvokeargument name="FCid"         value="#rsVerificaDocumentoFA.FCid#">
			              	<cfinvokeargument name="ETnumero"     value="#rsVerificaDocumentoFA.ETnumero#">
			              	<cfinvokeargument name="Ecodigo"      value="#session.Ecodigo#">
			              	<cfinvokeargument name="PrioridadEnvio" value="#Arguments.PrioridadEnvio#">                    
			          	</cfinvoke> 
			          	<cfset session.fa.listaFacturasEnviarElectronica = session.fa.listaFacturasEnviarElectronica & rsVerificaDocumentoFA.ETnumero & "|" & rsVerificaDocumentoFA.FCid & ",">
			        </cfif>
			    </cfif>
			<cfelse>
				<cfset session.fa.listaFacturasEnviarElectronica = "">
        	</cfif>

        </cfloop>
        
        
		<!---Codigo 15836: Manejo de Egresos--->
        <cfquery name="rsManejaEgresos" datasource="#session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo =  #Session.Ecodigo# 
                and Pcodigo = 15836
        </cfquery> 
        <cfif rsManejaEgresos.Pvalor eq 1>
            <cfquery datasource="#Arguments.Conexion#" name="rsComisiones">
                select p.PrebajaComision, 
                		a.Ddocumento, 
                        a.CCTcodigo, 
                        a.Ecodigo,
                        a.SNcodigoAgencia,
                        p.fechaExpedido,
                        p.PtipoSN,
                        a.SNcodigo
                from Pagos p
                	inner join DPagos b
                    	on b.Pcodigo = p.Pcodigo
                        and b.CCTcodigo = p.CCTcodigo
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
            </cfquery>
            <!---Se trabaja en los pagos que NO rebajan comision y que el documento tiene agencia 
			ya que, no se ocupa rebajar la comision, sino mas bien mandarla a la 'olla'--->
            <cfif isdefined ('rsComisiones.PrebajaComision') and #rsComisiones.PrebajaComision# neq 1>
                <cfloop query="rsComisiones">
                    <cfif isdefined ('rsComisiones.SNcodigoAgencia') and len(trim(#rsComisiones.SNcodigoAgencia#))> 
                    	
                        <cfquery name="rsVerificaCOMED" datasource="#Arguments.Conexion#">
                            select COMEDid
                            from COMEDocumentos ce
                            inner join CCTransacciones cct
                            on cct.CCTcodigo = ce.CCTcodigo
                            and cct.Ecodigo  = ce.Ecodigo
                            where Ddocumento = <cfqueryparam value="#rsComisiones.Ddocumento#" cfsqltype="cf_sql_char">
                            and ce.CCTcodigo = <cfqueryparam value="#rsComisiones.CCTcodigo#" cfsqltype="cf_sql_char">
                            and ce.Ecodigo   = <cfqueryparam value="#rsComisiones.Ecodigo#" cfsqltype="cf_sql_integer">
                            and cct.CCTtipo   = <cfqueryparam value="D" cfsqltype="cf_sql_char">
                            and SNcodigo 	 = <cfqueryparam value="#rsComisiones.SNcodigo#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        
                        <cfif len(trim(#rsVerificaCOMED.COMEDid#))>
                            <cfinvoke component="interfacesSoin.Componentes.COM_Invocaciones"  method="invoka719">
                                <cfinvokeargument name="Ddocumento" 	value="#rsComisiones.Ddocumento#">
                                <cfinvokeargument name="CCTcodigo" 		value="#rsComisiones.CCTcodigo#">
                                <cfinvokeargument name="Ecodigo" 		value="#rsComisiones.Ecodigo#">
                                <cfinvokeargument name="Dfechaexpedido"	value="#rsComisiones.fechaExpedido#">
                                <cfinvokeargument name="PtipoSN"		value="#rsComisiones.PtipoSN#">
                                <cfinvokeargument name="Pcodigo"		value="#Arguments.Pcodigo#">
                                <cfinvokeargument name="CCTcodigoE"		value="#Arguments.CCTcodigo#">
                            </cfinvoke>   
                        </cfif>
                    </cfif>
                </cfloop>
            <cfelseif isdefined ('rsComisiones.PrebajaComision') and #rsComisiones.PrebajaComision# eq 1> 
            <!---hasta el momento solo se rebajo la comision de Pronto Pago Cliente, por lo cual debe mandar a la olla todas las demas comisiones--->
                <cfloop query="rsComisiones">
                    <cfif isdefined ('rsComisiones.PtipoSN') and #rsComisiones.PtipoSN# eq '0'> <!---si es socio ---> 
                        <cfinvoke component="interfacesSoin.Componentes.COM_Invocaciones"  method="invoka719">
                            <cfinvokeargument name="Ddocumento" 	value="#rsComisiones.Ddocumento#">
                            <cfinvokeargument name="CCTcodigo" 		value="#rsComisiones.CCTcodigo#">
                            <cfinvokeargument name="Ecodigo" 		value="#rsComisiones.Ecodigo#">
                            <cfinvokeargument name="Dfechaexpedido"	value="#rsComisiones.fechaExpedido#">
                            <cfinvokeargument name="PtipoSN"		value="#rsComisiones.PtipoSN#">
                            <cfinvokeargument name="Pcodigo"		value="#Arguments.Pcodigo#">
                            <cfinvokeargument name="CCTcodigoE"		value="#Arguments.CCTcodigo#">
                        </cfinvoke>   
                    </cfif>
                </cfloop>
            </cfif>
		</cfif>
            
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
    
        <cfif isdefined('Arguments.usaCtaSaldoFavor') and Arguments.usaCtaSaldoFavor eq true>
             <!--- Cuenta Saldos a favor ---> 
            <cfquery name="rsCPNC" datasource="#session.dsn#">
              select Pvalor as ccuenta
                from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="555">
            </cfquery>
            <cfif isdefined('rsCPNC') and rsCPNC.recordcount eq 0>
               <cfthrow message="No existe una cuenta de saldos a favor!">
            </cfif>
        </cfif>	       
	
        <!--- 8) Grabar los Documento de los Anticipo Generado (si Tienen anticipos) --->
        <cfquery datasource="#Arguments.Conexion#">
            insert into Documentos (
                        Ecodigo,  		CCTcodigo, 		Ddocumento, 	Ocodigo, 
                        SNcodigo, 		Mcodigo,   		Ccuenta,    	Rcodigo, 
                        Dtipocambio, 	Dtotal, 		Dsaldo,     	Dfecha, 
                        Dvencimiento, 	Dtcultrev, 		Dusuario, 		Dtref, 
                        Ddocref,      	Dmontoretori, 	Dretporigen, 	Icodigo, 
                        id_direccionFact, EDtipocambioVal, EDtipocambioFecha
                        ,TESRPTCid,TESRPTCietu,DEobservacion,Dlote, DfechaExpedido)
            select 
                        b.Ecodigo , 
                        b.NC_CCTcodigo, 
                        b.NC_Ddocumento, 
                        a.Ocodigo, 
                        coalesce(b.SNcodigo,a.SNcodigo) as SNcodigo,<!---se usa el coalesce xq siempre se sacaba de a por lo cual pueden existir doc antiguos 
                        con los datos el dato en a y no en b--->	 
                        a.Mcodigo,    
                        <cfif isdefined('Arguments.usaCtaSaldoFavor') and Arguments.usaCtaSaldoFavor eq true>
                        #rsCPNC.ccuenta#,
                        <cfelse>
                        b.NC_Ccuenta,
                        </cfif> 
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
                        b.NC_RPTCietu, 
                        a.Pobservaciones,
                        Coalesce(a.Plote,''),
                        a.fechaExpedido
            from Pagos a
                inner join APagosCxC b
                    on a.Ecodigo   = b.Ecodigo 
                   and a.CCTcodigo = b.CCTcodigo
                   and a.Pcodigo   = b.Pcodigo 
            where a.Ecodigo   = #Arguments.Ecodigo#
              and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>	

        <cfquery datasource="#Arguments.Conexion#">
            insert into BMovimientos (
                    Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, 
                    BMfecha, Ccuenta, Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal, 
                    Dfecha, Dvencimiento, BMperiodo, BMmes, BMusuario, 
                    Dtotalloc, Dtotalref
                <cfif Arguments.EAid NEQ -1>
                    ,EAid
                </cfif>
                    ,BMlote
                   <cfif isdefined('rsEsNC.PfacturaContado') and rsEsNC.PfacturaContado eq 'D'> 
                    ,BMtref
                    ,BMdocref 
                    </cfif>
                    ,BMfechaExpedido
                   )
            select 
                    b.Ecodigo, 
                    b.NC_CCTcodigo, 
                    b.NC_Ddocumento,
                    b.CCTcodigo,
                    coalesce(a.Pserie,'') #_Cat# coalesce(a.Pdocumento,a.Pcodigo), 
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
                    ,Coalesce(Plote,'')
                    <cfif isdefined('rsEsNC.PfacturaContado') and rsEsNC.PfacturaContado eq 'D'> 
                    ,a.CCTcodigo
                    ,a.NC_Ddocumento 
                    </cfif>
                    ,fechaExpedido
            from Pagos a
                inner join APagosCxC b
                    on a.Ecodigo   = b.Ecodigo 
                   and a.CCTcodigo = b.CCTcodigo
                   and a.Pcodigo   = b.Pcodigo 
            where a.Ecodigo   = #Arguments.Ecodigo#
              and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>
    
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
                    ,TESRPTCid,TESRPTCietu, Dlote,SNcodigoAgencia,DfechaExpedido
                    ,EDperiodo, EDmes
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
                    ,NC_RPTCid,NC_RPTCietu, d.Dlote, d.SNcodigoAgencia,d.DfechaExpedido
                    ,#rsPeriodo.Periodo#
                    ,#rsMes.Mes#
            from APagosCxC a
                inner join Documentos d
                      on d.Ecodigo      = a.Ecodigo
                     and d.CCTcodigo    = a.NC_CCTcodigo
                     and d.Ddocumento   = a.NC_Ddocumento
            where a.Ecodigo 	= #Arguments.Ecodigo#
              and a.CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfif IsDefined('arguments.CC') and arguments.CC eq 1>
		  	<cfquery name="rsPagosInfo" datasource="#session.dsn#">
			 select FPCuenta as CBid, a.Mcodigo,FPfechapago as Pfecha, b.Pcodigo as Preferencia, FPmontoori as Ptotal,
			 b.Ptipocambio, b.Pobservaciones , b.Ocodigo, a.MLid 
			 from   PFPagos a		
                inner join Pagos b 
                  on a.CCTcodigo = b.CCTcodigo                
                 and a.Pcodigo   = b.Pcodigo				
				where b.Ecodigo   = #Arguments.Ecodigo#
				  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
				  and a.Tipo = 'D'
			</cfquery>
		<cfelse>
			<cfquery name="rsPagosInfo" datasource="#session.dsn#">
			 select CBid, Mcodigo,Pfecha, COALESCE(Preferencia,'Cobro CxC') as Preferencia, Ptotal, Ptipocambio, Pobservaciones , Ocodigo, MLid from 
			  Pagos a							
				where a.Ecodigo   = #Arguments.Ecodigo#
				  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and a.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
			</cfquery>
		</cfif>
		<cfloop query="rsPagosInfo">       
			<cfif isdefined('rsPagosInfo.Pobservaciones') and len(trim(rsPagosInfo.Pobservaciones)) gt 0>
					<cfset Lvarmldescripcion = rsPagosInfo.Pobservaciones>
			<cfelse>
					<cfset Lvarmldescripcion = rsPagosInfo.Preferencia>							
			</cfif>

			<cfif isDefined("PReferencia") and len(trim(PReferencia)) EQ 0>
				<cfset PReferencia = rsPagosInfo.Preferencia>
			<cfelseif not isDefined("Preferencia")>
				<cfset PReferencia = rsPagosInfo.Preferencia>
			</cfif>
			
			<cfif isdefined('rsPagosInfo.CBid') and len(trim(#rsPagosInfo.CBid#)) gt 0 and rsPagosInfo.CBid neq -1>
				<cfquery name="rsBanco" datasource="#session.dsn#">  
					  select b.Bid from  CuentasBancos a 
					   inner join Bancos b 
						   on a.Bid = b.Bid 
						   and a.Ecodigo = b.Ecodigo
						where a.CBid  = #rsPagosInfo.CBid#
					   and a.Ecodigo = #Arguments.Ecodigo#   
				</cfquery>
				<cfquery name="rsBTran" datasource="#session.dsn#">
					select BTid
						from BTransacciones 
					where Ecodigo= #Arguments.Ecodigo# 
					and BTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="DP">
				</cfquery>      
			<CFIF  Arguments.SinMLibros eq false>	 
				<!---Codigo 15833: para determinar si el pago de documentos de CxC cuando el cliente paga por transferencia o depósito debe crear  
				el movimiento en Bancos al aplicarse el pago o el sistema debe validar que el pago ya exista en Bancos--->
				<cfquery name="rsValidarExisteBancos" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo =  #Arguments.Ecodigo# 
					and Pcodigo = 15833
				</cfquery> 			
                        

                <cfset LvarID_Asiento = -1>
                <cfif isDefined("retIDcontable") and len(trim(retIDcontable)) gt 0>
					<cfset LvarID_Asiento = retIDcontable>
				</cfif> 

				<!---si esta encendido el parametro, solo se actualiza el movimiento en libros NO SE INSERTA XQ YA EXISTE--->
				<cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('rsPagosInfo.MLid') and len(trim(rsPagosInfo.MLid)) gt 0>				
                    <cfquery name="rsDocumento" datasource="#session.DSN#">
						Update MLibros
						Set MLutilizado = '2' <!---Utilizado--->
						Where Ecodigo =  #Arguments.Ecodigo#  and 
							MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosInfo.MLid#">
					</cfquery>
				<cfelse>                                 
				   <cfinvoke component="sif.Componentes.MB_InsertaMLibros" method="inserta_mlibros" >
						<cfinvokeargument name="Ecodigo"	  value="#Arguments.Ecodigo#">
						<cfinvokeargument name="Bid"	      value="#rsBanco.Bid#">
						<cfinvokeargument name="BTid"	      value="#rsBTran.BTid#">
						<cfinvokeargument name="CBid"	      value="#rsPagosInfo.CBid#">
						<cfinvokeargument name="Mcodigo"      value="#rsPagosInfo.Mcodigo#">
						<cfinvokeargument name="Ocodigo"      value="#rsPagosInfo.Ocodigo#">
						<cfinvokeargument name="fecha"        value="#rsPagosInfo.Pfecha#">
						<cfinvokeargument name="referencia"   value="#PReferencia#">
						<cfinvokeargument name="documento"    value="#Arguments.Pcodigo#">
						<cfinvokeargument name="tipocambio"   value="#rsPagosInfo.Ptipocambio#">
						<cfinvokeargument name="monto"        value="#rsPagosInfo.Ptotal#">  						                          
						<cfinvokeargument name="IDcontable"	  value="#LvarID_Asiento#">
						<cfinvokeargument name="Periodo"	  value="#rsPeriodo.Periodo#">
						<cfinvokeargument name="Mes"	      value="#rsMes.Mes#">                                                                                    
						<cfinvokeargument name="conexion"	  value="#Arguments.Conexion#">
					   <cfinvokeargument name="Mldescripcion" value="#Lvarmldescripcion#">
				   </cfinvoke>	
				</cfif> 
             </cfif><!--- FIN SinMlibros--->                                          
	       </cfif>
	    </cfloop>		

        <!--- 9 Graba en la tabla Histórica de Pagos. --->
        <cfquery name="rs" datasource="#Arguments.Conexion#">
            insert into HPagos
                (
                    Ecodigo, 
                    CCTcodigo,   
                    Pcodigo,  
                    Ocodigo,  
                    Mcodigo, 
                    Ccuenta, 
                    GSNid, 	  
                    SNcodigo, 
                    CFid, 	  
                    ID, 	 
                    Ptipocambio, 
                    Ptotal, 	
                    Pfecha,   
                    Preferencia, 
                    Pobservaciones, 
                    Pusuario, 
                    Seleccionado, 
                    BMUsucodigo, 
                    CBid,
                    FCid,                       
                    PtipoSN,
                    MLid,
                    Plote,
                    Pexterna,
                    FACid,
                    PesLiquidacion,
                    Pdocumento,
                    Pserie,PfacturaContado
                    ,fechaExpedido
                    ,PrebajaComision
                )
            select 
                    Ecodigo, 
                    CCTcodigo,   
                    Pcodigo,  
                    Ocodigo,  
                    Mcodigo, 
                    Ccuenta, 
                    GSNid, 	  
                    SNcodigo, 
                    CFid, 	  
                    ID, 	 
                    Ptipocambio, 
                    Ptotal, 	
                    Pfecha,   
                    Preferencia, 
                    Pobservaciones, 
                    Pusuario, 
                    Seleccionado, 
                    BMUsucodigo, 
                    CBid,
                    FCid,                      
                    PtipoSN,
                    MLid,
                    Coalesce(Plote,''),
                    Pexterna,
                    FACid,
                    PesLiquidacion,
                    Pdocumento,
                    Pserie,
                    PfacturaContado 
                   ,fechaExpedido 
                   ,PrebajaComision                  
            from Pagos
            where Ecodigo   = #Arguments.Ecodigo#
              and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#"> 
    
          <cf_dbidentity1 verificar_transaccion="false" datasource="#Arguments.Conexion#" name ="rs">
        </cfquery>
        <cf_dbidentity2 verificar_transaccion="false" datasource="#Arguments.Conexion#" name="rs" returnvariable="LvarIdentityrs">

        <!--- 10 Graba en la tabla Histórica de Detalle Pagos. --->
        <cfquery name="rs" datasource="#Arguments.Conexion#">
            insert into HDPagos
                (
                	HPid,
                    Ecodigo,
                    Pcodigo,
                    CCTcodigo,
                    Doc_CCTcodigo,
        			Ddocumento,
        			PPnumero,
        			Mcodigo,
        			Ccuenta,
        			CFid,
        			DPmonto,
        			DPmontodoc,
        			DPtipocambio,
        			DPtotal,
        			DPmontoretdoc,
        			BMUsucodigo,
        			EAid,
        			Rcodigo,
        			idDetalleInterfaz_,
        			TPCcobroDoc
                )
            select 
            		#LvarIdentityrs#,
            		Ecodigo,
                    Pcodigo,
                    CCTcodigo,
                    Doc_CCTcodigo,
        			Ddocumento,
        			PPnumero,
        			Mcodigo,
        			Ccuenta,
        			CFid,
        			DPmonto,
        			DPmontodoc,
        			DPtipocambio,
        			DPtotal,
        			DPmontoretdoc,
        			BMUsucodigo,
        			EAid,
        			Rcodigo,
        			idDetalleInterfaz_,
        			TPCcobroDoc                        
            from DPagos
            where Ecodigo   = #Arguments.Ecodigo#
              and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#"> 
        </cfquery>
 </cfif><!---- Cierre el conndicional de si se hace al aplicar, al contabilizar o a todos ---->     
 
 <cfif arguments.Contabilizar eq 'conta' or arguments.Contabilizar eq 'todos'> 
   
        <cfif LvarNAP GT 0> 
            <cfif not isdefined('LvarIdentityrs') or len(trim(LvarIdentityrs)) eq 0>
               <cfquery name="rsId" datasource="#Arguments.Conexion#">
                select HPid from HPagos 
                where Ecodigo    = #Arguments.Ecodigo# 
                  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
                  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
               </cfquery>	
               <cfif isdefined('rsId.HPid') and len(trim(rsId.HPid)) gt 0>
                 <cfset LvarIdentityrs = rsId.HPid>
               </cfif>
           </cfif>      
            <cfquery datasource="#Arguments.Conexion#">
                update CPNAP
                set IDTablaOrigen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarIdentityrs#">,
                    NombreTablaOrigen = 'HPagos' 
                where Ecodigo   = #Arguments.Ecodigo#
                    and CPNAPnum = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNAP#">
            </cfquery>   
        </cfif>   
            
        <cfquery datasource="#Arguments.Conexion#">
            delete from DPagos 
            where Ecodigo   = #Arguments.Ecodigo# 
              and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#"> 
              and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
        </cfquery>
            
        <cfquery datasource="#Arguments.Conexion#">
            delete from DFiltroPagos 
            where Ecodigo   = #Arguments.Ecodigo# 
              and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#"> 
              and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
        </cfquery>
        
        <!---►►Se borran los Anticipos, estos ya quedaron en Documentos y HDocumentos◄◄--->
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
   </cfif><!---- Cierre el conndicional de si se hace al aplicar, al contabilizar o a todos ---->        
  <!---	</cflock>--->
</cffunction>
</cfcomponent>