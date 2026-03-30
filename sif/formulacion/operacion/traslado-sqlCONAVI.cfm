?<cfset modo = "ALTA">
<!--- -------------------------------------------------- SECCION DE APLICAR ------------------------------------------ --->
<cfif isdefined("Form.btnRechazar")>
	<cfquery name="rsTraslado" datasource="#Session.DSN#">
		select CPDEid
		from CPDocumentoE a
		where a.Ecodigo = #Session.Ecodigo#
			and a.CPPid = #Form.CPPid#
			and a.CPDEtipoDocumento = 'T'
			and a.CPDEaplicado = 0
			and a.CPDEenAprobacion = 1
			and exists(select 1 from CPDocumentoD g where g.CPDEid = a.CPDEid)
	</cfquery>
	<cftransaction>
		<!--- Rechaza el traslado --->
		<cfloop query="rsTraslado">
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="fnRechazarTraslado">
				<cfinvokeargument name="CPDEid" 			value="#rsTraslado.CPDEid#">
				<cfinvokeargument name="CPDEmsgrechazo" 	value="#form.CPDEmsgrechazo#">
			</cfinvoke>
		</cfloop>
		<!--- Cambia estados de las variaciones, estodo rechazada --->
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
			<cfinvokeargument name="FPEEestado" 	value="2">
			<cfinvokeargument name="Filtro" 		value="CPPid = #form.CPPid# and FPEEestado = 5 and FPTVid in (select b.FPTVid from TipoVariacionPres b where b.FPTVid = FPEEstimacion.FPTVid and b.FPTVTipo in(2,3) and b.Ecodigo = #Session.Ecodigo#)">
		</cfinvoke>
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
			<cfinvokeargument name="FPEEestado" 	value="0">
			<cfinvokeargument name="Filtro" 		value="CPPid = #form.CPPid# and FPEEestado = 5 and FPTVid in (select b.FPTVid from TipoVariacionPres b where b.FPTVid = FPEEstimacion.FPTVid and b.FPTVTipo = 1 and b.Ecodigo = #Session.Ecodigo#)">
		</cfinvoke>
	</cftransaction>
<cfelseif isdefined("Form.btnAplicar")>
	<cfquery name="rsTraslado" datasource="#Session.DSN#">
		select CPDEid
		from CPDocumentoE a
		where a.Ecodigo = #Session.Ecodigo#
			and a.CPPid = #Form.CPPid#
			and a.CPDEtipoDocumento = 'T'
			and a.CPDEaplicado = 0
			and a.CPDEenAprobacion = 1
			and exists(select 1 from CPDocumentoD g where g.CPDEid = a.CPDEid)
	</cfquery>
	<cfquery datasource="#session.dsn#" name="preInsert">		
		select ED.FPDEid, ED.FPEEid, ED.FPEPid, ED.FPDElinea, (select min(PC.PCGEid) from PCGplanCompras PC where PC.Ecodigo = EE.Ecodigo and PC.CPPid = EE.CPPid) PCGEid,
			EE.CFid, EE.Ecodigo, ED.DPDEdescripcion, ED.DPDEjustificacion, ED.FPAEid, ED.CFComplemento, ED.FPCCid, ED.DPDEfechaIni,
			ED.DPDEfechaFin, ED.Ucodigo, EP.FPCCconcepto, ED.Aid, ED.Cid, ED.FPCid, ED.DPDEObservaciones, ED.Mcodigo, ED.Dtipocambio,
			ED.DPDEcosto, ED.DPDEcosto * ED.Dtipocambio monto, EP.PCGDxCantidad, ED.PCGcuenta, #session.Usucodigo# usucodigo,
			EP.FPEPmultiperiodo, ED.DPDMontoTotalPeriodo, ED.DPDEcantidadPeriodo, EP.PCGDxPlanCompras, ED.OBOid, ED.DPDEcantidad, ED.PCGDid, ED.FPDEid, ED.DPDEcontratacion
		from FPEEstimacion EE 
			inner join FPDEstimacion ED 
				on ED.FPEEid = EE.FPEEid
			inner join FPEPlantilla EP
				on EP.FPEPid = ED.FPEPid
			inner join TipoVariacionPres TV 
				on TV.FPTVid = EE.FPTVid
		where EE.CPPid = #Form.CPPid#
			and FPTVTipo in(1,2,3)
			and FPEEestado = 5
	</cfquery>
	<cfset Request.LobjControl = CreateObject("component", "sif.Componentes.PRES_Presupuesto")>
	<cfset Request.LobjControl.CreaTablaIntPresupuesto()>
	<cftransaction>
	<!---=================Insert las lineas nuevas del plan de compras=========--->	
		<cfloop query="preInsert">
			<!--- Lineas nuevas--->
			<cfif not len(trim(preInsert.PCGDid))>
				<!--- Inserta al detalle plan de compras --->
				<cfinvoke component="sif.Componentes.PlanCompras" method="AltaDPlanCompras" returnvariable="insertDplan">
						<cfinvokeargument name="PCGEid"					value="#preInsert.PCGEid#">
						<cfinvokeargument name="CFid"					value="#preInsert.CFid#">
						<cfinvokeargument name="FPEPid"					value="#preInsert.FPEPid#">
						<cfinvokeargument name="PCGDdescripcion"		value="#preInsert.DPDEdescripcion#">
						<cfinvokeargument name="PCGDjustificacion"		value="#preInsert.DPDEjustificacion#">
						<cfinvokeargument name="FPAEid"					value="#preInsert.FPAEid#">
						<cfinvokeargument name="CFComplemento"			value="#preInsert.CFComplemento#">
						<cfinvokeargument name="FPCCid"					value="#preInsert.FPCCid#">
						<cfinvokeargument name="PCGDfechaIni"			value="#preInsert.DPDEfechaIni#">
						<cfinvokeargument name="PCGDfechaFin"			value="#preInsert.DPDEfechaFin#">
						<cfinvokeargument name="Ucodigo"				value="#preInsert.Ucodigo#">
						<cfinvokeargument name="PCGDtipo"				value="#preInsert.FPCCconcepto#">
						<cfinvokeargument name="Aid"					value="#preInsert.Aid#">
						<cfinvokeargument name="Cid"					value="#preInsert.Cid#">
						<cfinvokeargument name="FPCid"					value="#preInsert.FPCid#">
						<cfinvokeargument name="OBOid"					value="#preInsert.OBOid#">
						<cfinvokeargument name="PCGDobservaciones"		value="#preInsert.DPDEObservaciones#">
						<cfinvokeargument name="Mcodigo"				value="#preInsert.Mcodigo#">
						<cfinvokeargument name="PCGDtipocambio"			value="#preInsert.Dtipocambio#">
						<cfinvokeargument name="PCGDcostoUori"			value="#preInsert.DPDEcosto#">
						<cfinvokeargument name="PCGDcantidad"			value="#iif(preInsert.PCGDxCantidad eq 1,0,preInsert.DPDEcantidadPeriodo)#"><!--- Se ingresa 0 si maneja cantidad 1 si no la maneja, ya que mas adelante se actualiza por medio del componente de presupuesto --->
						<cfinvokeargument name="PCGDcantidadCompras"	value="0">
						<cfinvokeargument name="PCGDcostoOri"			value="#preInsert.DPDMontoTotalPeriodo#">
						<cfinvokeargument name="PCGDautorizado"			value="0"><!--- Se ingresa 0, ya que mas adelante se actualiza por medio del componente de presupuesto --->
						<cfinvokeargument name="PCGDreservado"			value="0">
						<cfinvokeargument name="PCGDcomprometido"		value="0">
						<cfinvokeargument name="PCGDejecutado"			value="0">
						<cfinvokeargument name="PCGcuenta"				value="#preInsert.PCGcuenta#">
						<cfinvokeargument name="PCGDxCantidad"			value="#preInsert.PCGDxCantidad#">
						<cfinvokeargument name="PCGDxPlanCompras"		value="#preInsert.PCGDxPlanCompras#">
                        <cfinvokeargument name="PCGDcontratacion" 		value="#preInsert.DPDEcontratacion#">
						<cfinvokeargument name="Ecodigo" 				value="#session.Ecodigo#">
						<cfinvokeargument name="BMUsucodigo"			value="#session.Usucodigo#">
						<cfinvokeargument name="Conexion" 				value="#session.dsn#">
					</cfinvoke>
				<!--- Inserta al plan multiperido, si es multiperiodo--->
				<cfif preInsert.FPEPmultiperiodo eq 1>
					<cfinvoke component="sif.Componentes.PlanCompras" method="AltaMPlanCompras" returnvariable="insertMulti">
						<cfinvokeargument name="PCGDid" 					value="#insertDplan#">
						<cfinvokeargument name="PCGDcantidadTotal" 			value="#preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDcantidadAnteriores" 	value="0">
						<cfinvokeargument name="PCGDcantidadFuturos" 		value="#preInsert.DPDEcantidad - preInsert.DPDEcantidadPeriodo#">
						<cfinvokeargument name="PCGDcantidad" 				value="#preInsert.DPDEcantidadPeriodo#">
						<cfinvokeargument name="PCGDcostoTotalOri" 			value="#preInsert.DPDEcosto * preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDcostoAnterioresOri" 	value="0">
						<cfinvokeargument name="PCGDcostoFuturosOri" 		value="#preInsert.DPDEcosto  * preInsert.DPDEcantidad -  preInsert.DPDMontoTotalPeriodo#">
						<cfinvokeargument name="PCGDcostoOri" 				value="#preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDautorizadoTotal" 		value="#preInsert.DPDEcosto  * preInsert.DPDEcantidad * preInsert.Dtipocambio#">
						<cfinvokeargument name="PCGDautorizadoAnteriores" 	value="0">
						<cfinvokeargument name="PCGDautorizadoFuturos" 		value="#(preInsert.DPDEcosto  * preInsert.DPDEcantidad -  preInsert.DPDMontoTotalPeriodo) * preInsert.Dtipocambio#">
						<cfinvokeargument name="PCGDautorizado" 			value="#preInsert.DPDMontoTotalPeriodo * preInsert.Dtipocambio#">
						<cfinvokeargument name="Ecodigo" 					value="#session.Ecodigo#">
						<cfinvokeargument name="BMUsucodigo" 				value="#session.Usucodigo#">
						<cfinvokeargument name="Conexion" 					value="#session.dsn#">
					</cfinvoke>
				</cfif>
				<cfquery datasource="#session.dsn#">
					update FPDEstimacion
					  set PCGDid 	 = #insertDplan#
					where FPEEid 	 = #preInsert.FPEEid#
					  and FPEPid 	 = #preInsert.FPEPid#
					  and FPDElinea  = #preInsert.FPDElinea#
					  and PCGDid is null
				</cfquery>
				<cfset LvarPCGDid = insertDplan>
			<!--- Lineas Viejas--->
			<cfelse>
				<cfquery datasource="#session.dsn#">
					update PCGDplanCompras set
						PCGDpendiente = 0,
						PCGDcantidadPendiente = 0,
						PCGDcostoUori  = #preInsert.DPDEcosto#,
						PCGDtipocambio = #preInsert.Dtipocambio#
					where PCGDid 	 = #preInsert.PCGDid#
				</cfquery>
				<cfif preInsert.FPEPmultiperiodo eq 1>
					<cfinvoke component="sif.Componentes.PlanCompras" method="CambioMPlanCompras" returnvariable="updateMulti">
						<cfinvokeargument name="PCGDid" 					value="#preInsert.PCGDid#">
						<cfinvokeargument name="PCGDcantidadTotal" 			value="#preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDcantidadAnteriores" 	value="0">
						<cfinvokeargument name="PCGDcantidadFuturos" 		value="#preInsert.DPDEcantidad - preInsert.DPDEcantidadPeriodo#">
						<cfinvokeargument name="PCGDcantidad" 				value="#preInsert.DPDEcantidadPeriodo#">
						<cfinvokeargument name="PCGDcostoTotalOri" 			value="#preInsert.DPDEcosto * preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDcostoAnterioresOri" 	value="0">
						<cfinvokeargument name="PCGDcostoFuturosOri" 		value="#preInsert.DPDEcosto  * preInsert.DPDEcantidad -  preInsert.DPDMontoTotalPeriodo#">
						<cfinvokeargument name="PCGDcostoOri" 				value="#preInsert.DPDEcantidad#">
						<cfinvokeargument name="PCGDautorizadoTotal" 		value="#preInsert.DPDEcosto  * preInsert.DPDEcantidad * preInsert.Dtipocambio#">
						<cfinvokeargument name="PCGDautorizadoAnteriores" 	value="0">
						<cfinvokeargument name="PCGDautorizadoFuturos" 		value="#(preInsert.DPDEcosto  * preInsert.DPDEcantidad -  preInsert.DPDMontoTotalPeriodo) * preInsert.Dtipocambio#">
						<cfinvokeargument name="PCGDautorizado" 			value="#preInsert.DPDMontoTotalPeriodo * preInsert.Dtipocambio#">
						<cfinvokeargument name="Ecodigo" 					value="#session.Ecodigo#">
						<cfinvokeargument name="BMUsucodigo" 				value="#session.Usucodigo#">
						<cfinvokeargument name="Conexion" 					value="#session.dsn#">
					</cfinvoke>
				</cfif>
				<cfset LvarPCGDid = preInsert.PCGDid>
			</cfif>
			<cfquery datasource="#session.dsn#">
				update CPDocumentoD
				  set PCGDid 	 = #LvarPCGDid#
				where FPDEid 	 = #preInsert.FPDEid#
			</cfquery>
		</cfloop>
		<!--- Aprueba el traslado --->
		<cfloop query="rsTraslado">
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="fnAprobarTraslado">
				<cfinvokeargument name="CPDEid" 			value="#rsTraslado.CPDEid#">
			</cfinvoke>
			<!--- Limpia la tabla temporal para seguir trabajando con los datos faltantes--->
			<cfquery datasource="#session.dsn#">
				delete from #Request.intPresupuesto# 
			</cfquery>
		</cfloop>
		<!--- Cambia estados de las variaciones, estado aprobada --->
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
			<cfinvokeargument name="FPEEestado" 	value="6">
			<cfinvokeargument name="Filtro" 		value="CPPid = #form.CPPid# and FPEEestado = 5 and FPTVid in (select b.FPTVid from TipoVariacionPres b where b.FPTVid = FPEEstimacion.FPTVid and FPTVTipo in(1,2,3) and b.Ecodigo = #Session.Ecodigo#)">
		</cfinvoke>
		<!---  Elimina la tabla tamporal de trabajo --->
		<cfquery datasource="#session.dsn#">
			drop table #Request.intPresupuesto# 
		</cfquery>
        <cfquery datasource="#session.dsn#" name="rsSCs">
            select Dsc.ESidsolicitud, max(Ddoc.CPDEid) CPDEid
            from CPDocumentoD Ddoc
                inner join DSolicitudCompraCM Dsc
                    on Dsc.PCGDid = Ddoc.PCGDid
            where Ddoc.CPDEid  in (#valueList(rsTraslado.CPDEid)#)
             and (select count(1) from PCGDplanComprasMultiperiodo mlt where mlt.PCGDid = Ddoc.PCGDid) > 0
             group by Dsc.ESidsolicitud
        </cfquery>
        <cfloop query="rsSCs">
        	<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="ModificarPCGcompras">
                <cfinvokeargument name="NumeroVariaciacion" 	value="#rsSCs.CPDEid#">
                <cfinvokeargument name="ESidsolicitud" 			value="#rsSCs.ESidsolicitud#">
			</cfinvoke>
        </cfloop>
	</cftransaction>
</cfif>
<cflocation url="Traslados-lista.cfm" addtoken="no">

