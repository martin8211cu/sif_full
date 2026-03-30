<cfcomponent>
	<cfset rsFPCCconcepto = QueryNew("ID","VarChar")>
	<cfset QueryAddRow(rsFPCCconcepto, 10)>
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "1", 1)> <!---Otros--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "2", 2)> <!---Concepto Salarial--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "3", 3)> <!---Amortización de prestamos--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "4", 4)> <!---Financiamiento--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "5", 5)> <!---Patrimonio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "6", 6)> <!---Ventas--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "F", 7)> <!---Activos--->
	<cfset ListFPCCconcepto = left(ValueList(rsFPCCconcepto.ID), LEN(ValueList(rsFPCCconcepto.ID))-3)> 
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "S", 8)> <!---Servicio--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "A", 9)> <!---Articulos de Inventario--->
	<cfset QuerySetCell(rsFPCCconcepto, "ID", "P", 10)><!---Obras en Proceso--->
	<cfset ListFPCCconceptoALL = ValueList(rsFPCCconcepto.ID)> 
	
	<!---=================GenerarPlanCompras: Genera plan de compras=======--->
	<cffunction name="GenerarPlanCompras"  	access="public" returntype="boolean">
		<cfargument name="CPPid" 			type="numeric"	required="yes">
		<cfargument name="CVid" 			type="numeric"	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">
		<cfargument name="FPEEestado" 		type="numeric"	required="no" default="5">
		<cfargument name="FPEEid" 			type="numeric"	required="no">
				
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsLineasDetalle">
			select c.CFid, b.FPEPid, b.DPDEdescripcion, b.DPDEjustificacion, b.FPAEid, b.CFComplemento, b.FPCCid,
				b.Ucodigo, c.FPCCconcepto, b.Aid, Cid, FPCid,b.OBOid, b.DPDEObservaciones, b.Mcodigo, b.Dtipocambio,
				b.DPDEcosto, b.PCGcuenta, c.FPEPmultiperiodo, b.PCGDid,d.FPTVTipo,c.PCGDxCantidad,c.PCGDxPlanCompras, 
				min(b.DPDEfechaIni) DPDEfechaIni, 
				Max(b.DPDEfechaFin) DPDEfechaFin,
				sum(b.DPDEcantidadPeriodo) DPDEcantidadPeriodo,
				sum(b.DPDEcantidad) DPDEcantidad,
				sum(b.DPDMontoTotalPeriodo) DPDMontoTotalPeriodo ,
				b.DPDEcontratacion, b.DPDEmontoMinimo
			from FPEEstimacion a
				inner join FPDEstimacion b
					on b.FPEEid = a.FPEEid
				inner join FPEPlantilla c
					on b.FPEPid = c.FPEPid
				inner join TipoVariacionPres d
					on d.FPTVid = a.FPTVid
			where a.CPPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			and a.FPEEestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEestado#">
			and a.Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		   <cfif isdefined('Arguments.FPEEid') and len(trim(Arguments.FPEEid))>
			and a.FPEEid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
		   </cfif>
			and FPCCconcepto = 'A' and c.CFid is not null <!---Suministros con CF que compra configurado--->
			and (coalesce(b.DPDEmontoajuste,0) <> 0 or b.PCGDid is null)
			group by c.CFid, b.FPEPid, b.DPDEdescripcion, b.DPDEjustificacion, b.FPAEid, b.CFComplemento, b.FPCCid,
				b.Ucodigo, c.FPCCconcepto, b.Aid, Cid, FPCid,b.OBOid, b.DPDEObservaciones, b.Mcodigo, b.Dtipocambio,
				b.DPDEcosto, b.PCGcuenta, c.FPEPmultiperiodo, b.PCGDid,d.FPTVTipo,c.PCGDxCantidad,c.PCGDxPlanCompras,
				b.DPDEcontratacion,b.DPDEmontoMinimo
			
			UNION ALL
			
			select a.CFid, b.FPEPid, b.DPDEdescripcion, b.DPDEjustificacion, b.FPAEid, b.CFComplemento, b.FPCCid,
				b.Ucodigo, c.FPCCconcepto, b.Aid, b.Cid, b.FPCid,b.OBOid, b.DPDEObservaciones, b.Mcodigo, b.Dtipocambio,
				b.DPDEcosto, b.PCGcuenta, c.FPEPmultiperiodo, b.PCGDid,d.FPTVTipo,c.PCGDxCantidad,c.PCGDxPlanCompras,
				b.DPDEfechaIni, 
				b.DPDEfechaFin,
				b.DPDEcantidadPeriodo,
				b.DPDEcantidad,
				b.DPDMontoTotalPeriodo,
				b.DPDEcontratacion,
				b.DPDEmontoMinimo
			from FPEEstimacion a
				inner join FPDEstimacion b
					on b.FPEEid = a.FPEEid
				inner join FPEPlantilla c
					on b.FPEPid = c.FPEPid
				inner join TipoVariacionPres d
					on d.FPTVid = a.FPTVid
			where a.CPPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPPid#">
			and a.FPEEestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEestado#">
			and a.Ecodigo 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		   <cfif isdefined('Arguments.FPEEid') and len(trim(Arguments.FPEEid))>
				and a.FPEEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid#">
		   </cfif>
			and (FPCCconcepto <>  'A' or c.CFid is null) <!---no sea Suministros o sea suministro pero sin CF que compra configurado--->
			and (coalesce(b.DPDEmontoajuste,0) <> 0 or b.PCGDid is null)
		</cfquery>
		<cfif rsLineasDetalle.recordcount gt 0>
			<cfif rsLineasDetalle.FPTVTipo eq -1><!--- Presupuesto Ordinario --->
				<cfset LvarPCGEid = AltaEPlanCompras(Arguments.CPPid,Arguments.Ecodigo,Arguments.BMUsucodigo,Arguments.Conexion)>
			<cfelse><!--- Variacion Presupuestal --->
				<cfset LvarPCGEid = GetEPlanCompras(Arguments.CPPid,Arguments.Ecodigo,Arguments.Conexion).PCGEid>
			</cfif>
			<cfloop query="rsLineasDetalle">
				<!--- Detalle al plan de compra --->
				<cfif rsLineasDetalle.FPTVTipo eq -1><!--- Presupuesto Ordinario --->
					<cfset LvarPCGDid = AltaDPlanCompras(
						LvarPCGEid,rsLineasDetalle.CFid, 
						rsLineasDetalle.FPEPid,
						rsLineasDetalle.DPDEdescripcion, 
						rsLineasDetalle.DPDEjustificacion, 
						rsLineasDetalle.FPAEid, 
						rsLineasDetalle.CFComplemento, 
						rsLineasDetalle.FPCCid, 
						rsLineasDetalle.DPDEfechaIni, 
						rsLineasDetalle.DPDEfechaFin,
						rsLineasDetalle.Ucodigo, 
						rsLineasDetalle.FPCCconcepto, 
						rsLineasDetalle.Aid, 
						rsLineasDetalle.Cid, 
						rsLineasDetalle.FPCid, 
						rsLineasDetalle.OBOid, 
						rsLineasDetalle.DPDEObservaciones, 
						rsLineasDetalle.Mcodigo, 
						rsLineasDetalle.Dtipocambio,
						rsLineasDetalle.DPDEcosto,<!--- PCGDcostoUori --->
						rsLineasDetalle.DPDEcantidadPeriodo,<!--- PCGDcantidad --->
						0<!--- PCGDcantidadCompras --->,
						rsLineasDetalle.DPDMontoTotalPeriodo<!--- PCGDcostoOri --->,
						rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio<!--- PCGDautorizado --->,
						0<!--- PCGDreservado --->,
						0<!--- PCGDcomprometido --->,
						0<!--- PCGDejecutado --->,
				
						rsLineasDetalle.PCGcuenta<!--- PCGcuenta --->,
						rsLineasDetalle.PCGDxCantidad,
						rsLineasDetalle.PCGDxPlanCompras,
						rsLineasDetalle.DPDEcontratacion,
						rsLineasDetalle.DPDEmontoMinimo,
						Arguments.Ecodigo, 
						Arguments.BMUsucodigo, 
						Arguments.Conexion)>
					<!--- Detalle al plan de compra multiperiodo --->
					<cfif rsLineasDetalle.FPEPmultiperiodo eq 1>
						<cfset AltaMPlanCompras(
							LvarPCGDid, <!---PCGDid--->
							rsLineasDetalle.DPDEcantidad, <!---PCGDcantidadTotal--->
							0, <!---PCGDcantidadAnteriores--->
							rsLineasDetalle.DPDEcantidad - rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidadFuturos--->
							rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidad--->
							rsLineasDetalle.DPDEcosto * rsLineasDetalle.DPDEcantidad, <!--- PCGDcostoTotalOri --->
							0,<!--- PCGDcostoAnterioresOri --->
							rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoFuturosOri --->
							rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoOri --->
							rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoTotal --->
							0, <!--- PCGDautorizadoAnteriores --->
							(rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo) * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoFuturos --->
							rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizado --->
							Arguments.Ecodigo, Arguments.BMUsucodigo, Arguments.Conexion)>
					</cfif>
				<cfelse><!--- Variacion Presupuestal --->
					<cfif len(trim(rsLineasDetalle.PCGDid)) gt 0><!--- Linea Vieja --->
						<cfset LvarPCGDid = CambioDPlanCompras(
							rsLineasDetalle.PCGDid,
							LvarPCGEid,
							rsLineasDetalle.CFid, 
							rsLineasDetalle.FPEPid,
							rsLineasDetalle.DPDEdescripcion, 
							rsLineasDetalle.DPDEjustificacion, 
							rsLineasDetalle.FPAEid, 
							rsLineasDetalle.CFComplemento, 
							rsLineasDetalle.FPCCid, 
							rsLineasDetalle.DPDEfechaIni,
							rsLineasDetalle.DPDEfechaFin,
							rsLineasDetalle.Ucodigo, 
							rsLineasDetalle.FPCCconcepto, 
							rsLineasDetalle.Aid, 
							rsLineasDetalle.Cid, 
							rsLineasDetalle.FPCid,
							rsLineasDetalle.OBOid,  
							rsLineasDetalle.DPDEObservaciones, 
							rsLineasDetalle.Mcodigo, 
							rsLineasDetalle.Dtipocambio,
							rsLineasDetalle.DPDEcosto<!--- PCGDcostoUori --->, 
							rsLineasDetalle.DPDEcantidadPeriodo<!--- PCGDcantidad --->, 
							0<!--- PCGDcantidadCompras --->,
							rsLineasDetalle.DPDMontoTotalPeriodo<!--- PCGDcostoOri --->,
							rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio<!--- PCGDautorizado --->,
							0<!--- PCGDreservado --->,
							0<!--- PCGDcomprometido --->,
							0<!--- PCGDejecutado --->, 
			
							rsLineasDetalle.PCGcuenta<!--- PCGcuenta --->,
							rsLineasDetalle.PCGDxCantidad,
							rsLineasDetalle.PCGDxPlanCompras,
							rsLineasDetalle.DPDEcontratacion,
							rsLineasDetalle.DPDEmontoMinimo,
							Arguments.Ecodigo, Arguments.BMUsucodigo, Arguments.Conexion)>
						<cfif rsLineasDetalle.FPEPmultiperiodo eq 1>
							<cfset CambioMPlanCompras(
								LvarPCGDid, <!---PCGDid--->
								rsLineasDetalle.DPDEcantidad, <!---PCGDcantidadTotal--->
								0, <!---PCGDcantidadAnteriores--->
								rsLineasDetalle.DPDEcantidad - rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidadFuturos--->
								rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidad--->
								rsLineasDetalle.DPDEcosto * rsLineasDetalle.DPDEcantidad, <!--- PCGDcostoTotalOri --->
								0,<!--- PCGDcostoAnterioresOri --->
								rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoFuturosOri --->
								rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoOri --->
								rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoTotal --->
								0, <!--- PCGDautorizadoAnteriores --->
								(rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo) * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoFuturos --->
								rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizado --->
								Arguments.Ecodigo, Arguments.BMUsucodigo, Arguments.Conexion)>
						</cfif>
						<!--- Formatea el monto y cantidad pendiente del detalle  al plan de compra--->
						<cfquery datasource="#Arguments.Conexion#">
							update PCGDplanCompras set 
							PCGDpendiente = 0,
							PCGDcantidadPendiente = 0
							where PCGDid = #LvarPCGDid#
						</cfquery>
					<cfelse><!--- Linea Nueva --->
						<cfset LvarPCGDid = AltaDPlanCompras(LvarPCGEid,rsLineasDetalle.CFid, rsLineasDetalle.FPEPid,
							rsLineasDetalle.DPDEdescripcion, rsLineasDetalle.DPDEjustificacion, rsLineasDetalle.FPAEid, rsLineasDetalle.CFComplemento, 
							rsLineasDetalle.FPCCid, rsLineasDetalle.DPDEfechaIni, rsLineasDetalle.DPDEfechaFin,rsLineasDetalle.Ucodigo, 
							rsLineasDetalle.FPCCconcepto, rsLineasDetalle.Aid, rsLineasDetalle.Cid, rsLineasDetalle.FPCid, rsLineasDetalle.OBOid,
							rsLineasDetalle.DPDEObservaciones, rsLineasDetalle.Mcodigo, rsLineasDetalle.Dtipocambio,
							rsLineasDetalle.DPDEcosto<!--- PCGDcostoUori --->, rsLineasDetalle.DPDEcantidadPeriodo<!--- PCGDcantidad --->, 
							0<!--- PCGDcantidadCompras --->,rsLineasDetalle.DPDMontoTotalPeriodo<!--- PCGDcostoOri --->,rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio<!--- PCGDautorizado --->,0<!--- PCGDreservado --->,
							0<!--- PCGDcomprometido --->,0<!--- PCGDejecutado --->, rsLineasDetalle.PCGcuenta<!--- PCGcuenta --->,rsLineasDetalle.PCGDxCantidad,rsLineasDetalle.PCGDxPlanCompras,rsLineasDetalle.DPDEcontratacion,rsLineasDetalle.DPDEmontoMinimo,
							Arguments.Ecodigo, Arguments.BMUsucodigo, Arguments.Conexion)>
						<cfif rsLineasDetalle.FPEPmultiperiodo eq 1>
							<cfset AltaMPlanCompras(
								LvarPCGDid, <!---PCGDid--->
								rsLineasDetalle.DPDEcantidad, <!---PCGDcantidadTotal--->
								0, <!---PCGDcantidadAnteriores--->
								rsLineasDetalle.DPDEcantidad - rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidadFuturos--->
								rsLineasDetalle.DPDEcantidadPeriodo, <!---PCGDcantidad--->
								rsLineasDetalle.DPDEcosto * rsLineasDetalle.DPDEcantidad, <!--- PCGDcostoTotalOri --->
								0,<!--- PCGDcostoAnterioresOri --->
								rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoFuturosOri --->
								rsLineasDetalle.DPDMontoTotalPeriodo, <!--- PCGDcostoOri --->
								rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoTotal --->
								0, <!--- PCGDautorizadoAnteriores --->
								(rsLineasDetalle.DPDEcosto  * rsLineasDetalle.DPDEcantidad -  rsLineasDetalle.DPDMontoTotalPeriodo) * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizadoFuturos --->
								rsLineasDetalle.DPDMontoTotalPeriodo * rsLineasDetalle.Dtipocambio, <!--- PCGDautorizado --->
								Arguments.Ecodigo, Arguments.BMUsucodigo, Arguments.Conexion)>
						</cfif>
					</cfif>
				</cfif>
				<cfquery datasource="#Arguments.Conexion#" name="rsCPformato">	
					select CPformato ,CPVid
						from PCGcuentas 
					where PCGcuenta = #rsLineasDetalle.PCGcuenta#
				</cfquery>
				<cfif rsCPformato.Recordcount EQ 0 or NOT LEN(TRIM(rsCPformato.CPformato))>
					<cfthrow message="Error recuperando el formato de la cuenta Presupuestal. (PCGcuenta=#rsLineasDetalle.PCGcuenta#)">
				</cfif>

				<cfquery datasource="#Arguments.Conexion#" name="rsCPcuenta">	
					select CPcuenta 
						from CPresupuesto 
					where CPVid 	= #rsCPformato.CPVid#
					  and Ecodigo 	= #Arguments.Ecodigo#
					  and Cmayor 	= <cf_dbfunction name="sPart" args="'#rsCPformato.CPformato#',1,4">
					  and CPformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCPformato.CPformato#">
				</cfquery>
				<cfif rsCPcuenta.RecordCount EQ 0>
					<cfthrow message="La cuenta Presupuestal #rsCPformato.CPformato# aun no ha sido creada.">
				</cfif>
				<cfquery datasource="#Arguments.Conexion#">
					Update PCGcuentas
						set CPcuenta = #rsCPcuenta.CPcuenta#
					where PCGcuenta = #rsLineasDetalle.PCGcuenta#
				</cfquery>
				<cfquery name="RM" datasource="#Arguments.Conexion#">
					select * from  PCGDplanCompras
					where PCGDid = #LvarPCGDid#
				</cfquery>
			</cfloop>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<!---=================AltaEPlanCompras: Inserta el encabezado al plan de compras=======--->
	<cffunction name="AltaEPlanCompras"  	access="public" returntype="numeric">
		<cfargument name="CPPid" 			type="numeric"	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsAltaEPlanCompras">
			insert into PCGplanCompras(Ecodigo,CPPid,BMUsucodigo)
			values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CPPid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaEPlanCompras">
		<cfreturn #rsAltaEPlanCompras.identity#>
	</cffunction>
	
	<!---=================GetEPlanCompras: Obetiene el encabezado al plan de compras=======--->
	<cffunction name="GetEPlanCompras"  	access="public" returntype="query">
		<cfargument name="CPPid" 			type="numeric"	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlanCompras">
			select PCGEid, Ecodigo, CPPid, BMUsucodigo, ts_rversion 
			from PCGplanCompras
			where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">
			  and CPPid	  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CPPid#">
		</cfquery>
		<cfreturn #rsEPlanCompras#>
	</cffunction>
	
	<!---=================BajaEPlanCompras: Elimina el encabezado al plan de compras=======--->
	<cffunction name="BajaEPlanCompras"  	access="public" returntype="void">
		<cfargument name="PCGEid" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select count(1) as cantidad from PCGDplanCompras where PCGEid = #Arguments.PCGEid#
		</cfquery>
		
		<cfif rsDetalles.cantidad eq 0>
			<cfquery datasource="#Arguments.Conexion#">
				delete from PCGplanCompras 
				where PCGEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGEid#">
			</cfquery>
		<cfelse>
			<cfthrow message="El Encabezado al Plan de Compras posee dependencia con registros al detalle plan de compras.">
		</cfif>
	</cffunction>
	
	<!---=================AltaDPlanCompras: Inserta el detalle al plan de compras=======--->
	<cffunction name="AltaDPlanCompras"  			access="public" returntype="numeric">
		<cfargument name="PCGEid" 					type="numeric"  required="yes">
		<cfargument name="CFid" 					type="numeric"  required="yes">
		<cfargument name="FPEPid" 					type="numeric"  required="yes">
		<cfargument name="PCGDdescripcion" 			type="string"	required="yes">
		<cfargument name="PCGDjustificacion"		type="string"	required="yes">
		<cfargument name="FPAEid"					type="numeric"	required="yes">
		<cfargument name="CFComplemento"			type="string"	required="yes">
		<cfargument name="FPCCid"					type="numeric"	required="no">
		<cfargument name="PCGDfechaIni"				type="string"	required="no">
		<cfargument name="PCGDfechaFin"				type="string"	required="no">
		<cfargument name="Ucodigo"					type="string"	required="no">
		<cfargument name="PCGDtipo"					type="string"	required="no">
		<cfargument name="Aid"						type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="Cid"						type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="FPCid"					type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="OBOid"					type="string"	required="no">
		<cfargument name="PCGDobservaciones"		type="string"	required="no">
		<cfargument name="Mcodigo"					type="numeric"	required="yes">
		<cfargument name="PCGDtipocambio"			type="any"		required="yes">
		<cfargument name="PCGDcostoUori"			type="any"		required="yes">
		<cfargument name="PCGDcantidad"				type="numeric"	required="yes">
		<cfargument name="PCGDcantidadCompras"		type="numeric"	required="no" default="0">
		<cfargument name="PCGDcostoOri"				type="any"		required="no" default="0">
		<cfargument name="PCGDautorizado"			type="any"		required="no" default="0">
		<cfargument name="PCGDreservado"			type="any"		required="no" default="0">
		<cfargument name="PCGDcomprometido"			type="any"		required="no" default="0">
		<cfargument name="PCGDejecutado"			type="any"		required="no" default="0">
		<cfargument name="PCGcuenta"				type="numeric"	required="no">
		<cfargument name="PCGDxCantidad"			type="numeric"	required="yes">
		<cfargument name="PCGDxPlanCompras"			type="numeric"	required="yes">
		<cfargument name="PCGDcontratacion"			type="string"	required="no">
		<cfargument name="PCGDmontoMinimo"			type="any"		required="no" default="null">
		<cfargument name="Ecodigo" 					type="numeric"  required="no">
		<cfargument name="BMUsucodigo"				type="numeric"	required="no">
		<cfargument name="Conexion" 				type="string"  	required="no">
	
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<!---Se valida Encabezado al Plan de Compras--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlanCompras">
			select count(1) as cantidad from PCGplanCompras where PCGEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCGEid#">
		</cfquery>
		<cfif rsEPlanCompras.cantidad EQ 0>
			<cfthrow message="El Encabezado al Plan de Compras no existe.">
		</cfif>
		<!---Se valida Plantilla--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlantilla">
			select FPEPdescripcion,FPCCconcepto from FPEPlantilla where FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
		</cfquery>
		<cfif rsEPlantilla.recordcount EQ 0>
			<cfthrow message="La plantilla de Estimación de Ingreso y Egreso no existe.">
		</cfif>
		<!---Se valida Actividad--->
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select count(1) as cantidad from FPActividadE where FPAEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPAEid#">
		</cfquery>
		<cfif rsActividad.cantidad EQ 0>
			<cfthrow message="La Actividad no existe.">
		</cfif>
		<!---Se valida Clasificacion--->
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select count(1) as cantidad from FPCatConcepto where FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCCid#">
		</cfquery>
		<cfif rsActividad.cantidad EQ 0>
			<cfthrow message="La Clasificacion no existe.">
		</cfif>
		<!---Se valida el concepto de Ingreso o egreso para el caso de Plantillas de Activo, concepto salarial y otros--->
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.FPCid')>
				<cfthrow message="El Conceptos de Ingresos y Egreso es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsConcepto">
				select FPCCid,FPCdescripcion from FPConcepto where FPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCid#">
			</cfquery>
			<cfif rsConcepto.recordcount EQ 0>
				<cfthrow message="El Conceptos de Ingreso y Egreso no existe.">
			</cfif>
			<cfset Arguments.FPCCid = rsConcepto.FPCCid>
			<cfif not isRelated(Arguments.Conexion, Arguments.FPCCid,Arguments.FPEPid)>
				<cfthrow message="El Conceptos #rsConcepto.FPCdescripcion# no esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#">
			</cfif>
		</cfif>	
		<!---Valida el Articulo para el caso de plantillas de Inventario--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Aid')>
				<cfthrow message="El Articulo es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsArticulo">
				select a.Ccodigo, a.Adescripcion, b.Cdescripcion
					from Articulos a 
						inner join Clasificaciones b
							on a.Ecodigo = b.Ecodigo
							and a.Ccodigo = b.Ccodigo
				where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#">
			</cfquery>
			<cfif rsArticulo.recordcount EQ 0>
				<cfthrow message="El Articulo no existe.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion" maxrows="1">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and FPCCconcepto = 'A'
				  and FPCCTablaC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsArticulo.Ccodigo#">
				  order by FPCCid
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El Articulo '#rsArticulo.Adescripcion#'-Clasificación '#rsArticulo.Cdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Articulo: #rsArticulo.Adescripcion#<br>Clasificacion: #rsArticulo.Cdescripcion#">
			</cfif>
		</cfif>	
		<!---Valida el concepto de servicio para el caso de plantillas de servicios--->
		<cfif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Cid')>
				<cfthrow message="El Concepto de servicio es requerido.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsServicio">
				select a.CCid, a.Cdescripcion, b.CCdescripcion
					from Conceptos a 
						inner join CConceptos b
							on a.CCid = b.CCid
				where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
			</cfquery>
			<cfif rsServicio.recordcount EQ 0>
				<cfthrow message="El concepto de servicio no existe.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and FPCCconcepto 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
				  and FPCCTablaC 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsServicio.CCid#">
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El concepto del servicio '#rsServicio.Cdescripcion#'-Clasificación '#rsServicio.CCdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#." detail="<br>Servicio: #rsServicio.Cdescripcion#<br>Clasificacion: #rsServicio.CCdescripcion#">
			</cfif>
		</cfif>
		<!---Valida que la Obra Exista--->
		<cfif ListFind('P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.OBOid')>
				<cfthrow message="La Obra es requerida. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsObra">
				select count(1) cantidad
					from OBobra 
				where OBOid = #Arguments.OBOid#
			</cfquery>
			<cfif rsObra.cantidad EQ 0>
				<cfthrow message="La Obra no existe. Proceso cancelado.">
			</cfif>
		</cfif>
		<cfif not isdefined('Arguments.PCGDfechaIni') or not len(trim(Arguments.PCGDfechaIni))>
			<cfset Arguments.PCGDfechaIni = "null">
		</cfif> 
		<cfif not isdefined('Arguments.PCGDfechaFin') or not len(trim(Arguments.PCGDfechaFin))>
			<cfset Arguments.PCGDfechaFin = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Aid') or not len(trim(Arguments.Aid))>
			<cfset Arguments.Aid = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Cid') or not len(trim(Arguments.Cid))>
			<cfset Arguments.Cid = "null">
		</cfif>
		<cfif not isdefined('Arguments.FPCid') or not len(trim(Arguments.FPCid))>
			<cfset Arguments.FPCid = "null">
		</cfif>
		<cfif not isdefined('Arguments.OBOid') or not len(trim(Arguments.OBOid))>
			<cfset Arguments.OBOid = "null">
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="rsAltaDPlanCompras">
		   insert into PCGDplanCompras(Ecodigo,PCGEid,CFid,FPEPid,PCGDdescripcion,PCGDjustificacion,FPAEid,CFComplemento,
		   FPCCid,PCGDfechaIni,PCGDfechaFin,Ucodigo,PCGDtipo,Aid,Cid,FPCid,OBOid, PCGDobservaciones,
		   Mcodigo,PCGDtipocambio,PCGDcostoUori,PCGDcantidad,
		   PCGDcantidadCompras,PCGDcostoOri,PCGDautorizado,PCGDreservado,PCGDcomprometido,PCGDejecutado,
		   PCGcuenta,BMUsucodigo,PCGDxCantidad,PCGDxPlanCompras,PCGDcontratacion,PCGDmontoMinimo)
			values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGEid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPEPid#">,
					SUBSTR('#trim(Arguments.PCGDdescripcion)#',1,case when length('#trim(Arguments.PCGDdescripcion)#')> 256 then 256 else length('#trim(Arguments.PCGDdescripcion)#') end ),
					SUBSTR('#trim(Arguments.PCGDjustificacion)#',1,case when length('#trim(Arguments.PCGDjustificacion)#')> 256 then 256 else length('#trim(Arguments.PCGDjustificacion)#') end ),
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPAEid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#trim(Arguments.CFComplemento)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCCid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.PCGDfechaIni#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.PCGDfechaFin#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#trim(Arguments.Ucodigo)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#trim(Arguments.PCGDtipo)#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Aid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Cid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPCid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.OBOid#">,
					'#trim(Arguments.PCGDobservaciones)#',
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Mcodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDtipocambio#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoUori#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidad#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadCompras#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoOri#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizado#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDreservado#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcomprometido#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDejecutado#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGcuenta#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDxCantidad#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDxPlanCompras#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#trim(Arguments.PCGDcontratacion)#" null="#NOT LEN(TRIM(Arguments.PCGDcontratacion))#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDmontoMinimo#" null="#NOT LEN(TRIM(Arguments.PCGDmontoMinimo))#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsAltaDPlanCompras">
		<cfreturn #rsAltaDPlanCompras.identity#>
	</cffunction>
	
	<!---=================CambioDPlanCompras: Modifica el detalle al plan de compras=======--->
	<cffunction name="CambioDPlanCompras"  			access="public" returntype="numeric">
		<cfargument name="PCGDid" 					type="numeric"  required="yes">
		<cfargument name="PCGEid" 					type="numeric"  required="yes">
		<cfargument name="CFid" 					type="numeric"  required="yes">
		<cfargument name="FPEPid" 					type="numeric"  required="yes">
		<cfargument name="PCGDdescripcion" 			type="string"	required="yes">
		<cfargument name="PCGDjustificacion"		type="string"	required="yes">
		<cfargument name="FPAEid"					type="numeric"	required="yes">
		<cfargument name="CFComplemento"			type="string"	required="yes">
		<cfargument name="FPCCid"					type="numeric"	required="no">
		<cfargument name="PCGDfechaIni"				type="string"	required="no">
		<cfargument name="PCGDfechaFin"				type="string"	required="no">
		<cfargument name="Ucodigo"					type="string"	required="no">
		<cfargument name="PCGDtipo"					type="string"	required="no">
		<cfargument name="Aid"						type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="Cid"						type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="FPCid"					type="string"	required="no"><!--- Numeric, se pasa a string para cuando viene de BD(null)--->
		<cfargument name="OBOid"					type="string"	required="no">
		<cfargument name="PCGDobservaciones"		type="string"	required="no">
		<cfargument name="Mcodigo"					type="numeric"	required="yes">
		<cfargument name="PCGDtipocambio"			type="any"		required="yes">
		<cfargument name="PCGDcostoUori"			type="any"		required="yes">
		<cfargument name="PCGDcantidad"				type="numeric"	required="yes">
		<cfargument name="PCGDcantidadCompras"		type="numeric"	required="no">
		<cfargument name="PCGDcostoOri"				type="any"		required="no">
		<cfargument name="PCGDautorizado"			type="any"		required="no">
		<cfargument name="PCGDreservado"			type="any"		required="no">
		<cfargument name="PCGDcomprometido"			type="any"		required="no">
		<cfargument name="PCGDejecutado"			type="any"		required="no">
		<cfargument name="PCGcuenta"				type="numeric"	required="no">
		<cfargument name="PCGDxCantidad"			type="numeric"	required="yes">
		<cfargument name="PCGDxPlanCompras"			type="numeric"	required="yes">
		<cfargument name="PCGDcontratacion"			type="string"	required="no">
		<cfargument name="PCGDmontoMinimo"			type="any"		required="no" default="null">
		<cfargument name="Ecodigo" 					type="numeric"  required="no">
		<cfargument name="BMUsucodigo"				type="numeric"	required="no">
		<cfargument name="Conexion" 				type="string"  	required="no">
	
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<!---Se valida Encabezado al Plan de Compras--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlanCompras">
			select count(1) as cantidad from PCGplanCompras where PCGEid = #Arguments.PCGEid#
		</cfquery>
		<cfif rsEPlanCompras.cantidad EQ 0>
			<cfthrow message="El Encabezado al Plan de Compras no existe. Proceso cancelado.">
		</cfif>
		<!---Se valida Plantilla--->
		<cfquery datasource="#Arguments.Conexion#" name="rsEPlantilla">
			select FPEPdescripcion,FPCCconcepto from FPEPlantilla where FPEPid = #Arguments.FPEPid#
		</cfquery>
		<cfif rsEPlantilla.recordcount EQ 0>
			<cfthrow message="La plantilla de Estimación de Ingreso y Egreso no existe. Proceso cancelado.">
		</cfif>
		<!---Se valida Actividad--->
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select count(1) as cantidad from FPActividadE where FPAEid = #Arguments.FPAEid#
		</cfquery>
		<cfif rsActividad.cantidad EQ 0>
			<cfthrow message="La Actividad no existe. Proceso cancelado.">
		</cfif>
		<!---Se valida Clasificacion--->
		<cfquery datasource="#Arguments.Conexion#" name="rsActividad">
			select count(1) as cantidad from FPCatConcepto where FPCCid = #Arguments.FPCCid#
		</cfquery>
		<cfif rsActividad.cantidad EQ 0>
			<cfthrow message="La Clasificacion no existe. Proceso cancelado.">
		</cfif>
		<!---Se valida el concepto de Ingreso o egreso para el caso de Plantillas de Activo, concepto salarial y otros--->
		<cfif ListFind(ListFPCCconcepto,rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.FPCid')>
				<cfthrow message="El Conceptos de Ingresos y Egreso es requerido. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsConcepto">
				select FPCCid,FPCdescripcion from FPConcepto where FPCid = #Arguments.FPCid#
			</cfquery>
			<cfif rsConcepto.recordcount EQ 0>
				<cfthrow message="El Conceptos de Ingreso y Egreso no existe. Proceso cancelado.">
			</cfif>
			<cfset Arguments.FPCCid = rsConcepto.FPCCid>
			<cfif not isRelated(Arguments.Conexion, Arguments.FPCCid,Arguments.FPEPid)>
				<cfthrow message="El Conceptos #rsConcepto.FPCdescripcion# no esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#. Proceso cancelado.">
			</cfif>
		</cfif>	
		<!---Valida el Articulo para el caso de plantillas de Inventario--->
		<cfif ListFind('A',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Aid')>
				<cfthrow message="El Articulo es requerido. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsArticulo">
				select a.Ccodigo, a.Adescripcion, b.Cdescripcion
					from Articulos a 
						inner join Clasificaciones b
							on a.Ecodigo = b.Ecodigo
							and a.Ccodigo = b.Ccodigo
				where a.Aid = #Arguments.Aid#
			</cfquery>
			<cfif rsArticulo.recordcount EQ 0>
				<cfthrow message="El Articulo no existe. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion" maxrows="1">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo = #Arguments.Ecodigo#
				  and FPCCconcepto = 'A'
				  and FPCCTablaC = #rsArticulo.Ccodigo#
				  order by FPCCid
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El Articulo '#rsArticulo.Adescripcion#'-Clasificación '#rsArticulo.Cdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos. Proceso cancelado.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#. Proceso cancelado." detail="<br>Articulo: #rsArticulo.Adescripcion#<br>Clasificacion: #rsArticulo.Cdescripcion#">
			</cfif>
		</cfif>	
		<!---Valida el concepto de servicion para el caso de plantillas de servicios--->
		<cfif ListFind('S,P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.Cid')>
				<cfthrow message="El Concepto de servicio es requerido. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsServicio">
				select a.CCid, a.Cdescripcion, b.CCdescripcion
					from Conceptos a 
						inner join CConceptos b
							on a.CCid = b.CCid
				where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#">
			</cfquery>
			<cfif rsServicio.recordcount EQ 0>
				<cfthrow message="El concepto de servicio no existe. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsClasificacion">
				select FPCCid,FPCCdescripcion 
					from FPCatConcepto 
				where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.Ecodigo#">
				  and FPCCconcepto  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEPlantilla.FPCCconcepto#">
				  and FPCCTablaC 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsServicio.CCid#">
			</cfquery>
			<cfif rsClasificacion.recordCount EQ 0>
				<cfthrow message="El concepto del servicio '#rsServicio.Cdescripcion#'-Clasificación '#rsServicio.CCdescripcion#' no esta Configurada en ninguna Clasificación de Conceptos de Ingresos y Egresos. Proceso cancelado.">
			</cfif>
			<cfloop query="rsClasificacion">
				<cfif isRelated(Arguments.Conexion, rsClasificacion.FPCCid,Arguments.FPEPid)>
					<cfset Arguments.FPCCid = rsClasificacion.FPCCid>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif not isdefined('Arguments.FPCCid')>
				<cfthrow message="Ningunas de las la Clasificaciónes de Ingresos y Egresos esta ligado a la plantilla #rsEPlantilla.FPEPdescripcion#. Proceso cancelado." detail="<br>Servicio: #rsServicio.Cdescripcion#<br>Clasificacion: #rsServicio.CCdescripcion#">
			</cfif>
		</cfif>
		<!---Valida que la Obra Exista--->
		<cfif ListFind('P',rsEPlantilla.FPCCconcepto)>
			<cfif not isdefined('Arguments.OBOid')>
				<cfthrow message="La Obra es requerida. Proceso cancelado.">
			</cfif>
			<cfquery datasource="#Arguments.Conexion#" name="rsObra">
				select count(1) cantidad
					from OBobra 
				where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.OBOid#">
			</cfquery>
			<cfif rsObra.cantidad EQ 0>
				<cfthrow message="La Obra no existe. Proceso cancelado.">
			</cfif>
		</cfif>
		
		<cfif not isdefined('Arguments.PCGDfechaIni')>
			<cfset Arguments.PCGDfechaIni = "null">
		</cfif> 
		<cfif not isdefined('Arguments.PCGDfechaFin')>
			<cfset Arguments.PCGDfechaFin = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Aid') or not len(trim(Arguments.Aid))>
			<cfset Arguments.Aid = "null">
		</cfif> 
		<cfif not isdefined('Arguments.Cid') or not len(trim(Arguments.Cid))>
			<cfset Arguments.Cid = "null">
		</cfif>
		<cfif not isdefined('Arguments.FPCid') or not len(trim(Arguments.FPCid))>
			<cfset Arguments.FPCid = "null">
		</cfif>
		<cfif not isdefined('Arguments.OBOid') or not len(trim(Arguments.OBOid))>
			<cfset Arguments.OBOid = "null">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
		   update PCGDplanCompras set
			   Ecodigo 					= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#" >,
			   PCGEid					= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.PCGEid#" >,
			   CFid						= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#" >,
			   FPEPid					= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPEPid#" >,
			   PCGDdescripcion			= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rtrim(Arguments.PCGDdescripcion)#" >,
			   PCGDjustificacion		= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rtrim(Arguments.PCGDjustificacion)#" >,
			   FPAEid					= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FPAEid#" >,
			   CFComplemento			= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Arguments.CFComplemento)#" >,
			   FPCCid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCCid#" voidnull>,
			   <cfif Arguments.PCGDfechaIni NEQ "">
				   PCGDfechaIni				= <cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.PCGDfechaIni#">,
			   </cfif>
			    <cfif Arguments.PCGDfechaFin NEQ "">
				   PCGDfechaFin				= <cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.PCGDfechaFin#">,
				</cfif>
			   Ucodigo					= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#trim(Arguments.Ucodigo)#" voidnull>,
			   PCGDtipo					= <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Arguments.PCGDtipo)#" >,
			   Aid						= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Aid#" voidnull>,
			   Cid						= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Cid#" voidnull>,
			   FPCid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.FPCid#" voidnull>,
			   OBOid					= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.OBOid#" voidnull>,
			   PCGDobservaciones		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#trim(Arguments.PCGDobservaciones)#" voidnull>,
			   Mcodigo					= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Mcodigo#">,
			   PCGDtipocambio			= <cfqueryparam cfsqltype="cf_sql_money" 			value="#Arguments.PCGDtipocambio#">,
			   PCGDcostoUori			= <cfqueryparam cfsqltype="cf_sql_money" 			value="#Arguments.PCGDcostoUori#">,
			   PCGDcantidad				= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.PCGDcantidad#">,
			   PCGDcostoOri				= <cfqueryparam cfsqltype="cf_sql_money" 			value="#Arguments.PCGDcostoOri#">,
			   PCGDautorizado			= <cfqueryparam cfsqltype="cf_sql_money" 			value="#Arguments.PCGDautorizado#">,
			   PCGcuenta				= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.PCGcuenta#">,
			   BMUsucodigo				= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#" voidnull>,
			   PCGDxCantidad			= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.PCGDxCantidad#">,
			   PCGDxPlanCompras			= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.PCGDxPlanCompras#">,
			   PCGDcontratacion			= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#trim(Arguments.PCGDcontratacion)#" voidnull>,
		  	   PCGDmontoMinimo		 	= <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDmontoMinimo#" voidnull>
		   where PCGDid 				= <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.PCGDid#">
		</cfquery>
		<cfreturn #Arguments.PCGDid#>
	</cffunction>
	
	<!---=================BajaDPlanCompras: Elimina el detalle al plan de compras=======--->
	<cffunction name="BajaDPlanCompras"  	access="public" returntype="void">
		<cfargument name="PCGDid" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			delete from PCGDplanCompras 
			where PCGDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#" name="rsDetalles">
			select count(1) as cantidad from PCGDplanComprasMultiperiodo where PCGDid = #Arguments.PCGEid#
		</cfquery>
		
		<cfif rsDetalles.cantidad eq 0>
			<cfquery datasource="#Arguments.Conexion#">
				delete from PCGplanCompras 
				where PCGEid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGEid#">
			</cfquery>
		<cfelse>
			<cfthrow message="El Detalle al Plan de Compras posee dependencia con registros al plan de compras multiperiodo, Proceso cancelado.">
		</cfif>
	</cffunction>
	
	<!---=================AltaMPlanCompras: Inserta al plan de compras para gobierno multiperiodo=======--->
	<cffunction name="AltaMPlanCompras"  			access="public" returntype="numeric">
		<cfargument name="PCGDid" 					type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadTotal" 		type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadAnteriores" 	type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadFuturos" 		type="numeric" 	required="yes">
		<cfargument name="PCGDcantidad" 			type="numeric" 	required="yes">
		<cfargument name="PCGDcostoTotalOri" 		type="any" 		required="no">
		<cfargument name="PCGDcostoAnterioresOri" 	type="any" 		required="no">
		<cfargument name="PCGDcostoFuturosOri" 		type="any" 		required="no">
		<cfargument name="PCGDcostoOri" 			type="any" 		required="no">
		<cfargument name="PCGDautorizadoTotal" 		type="any" 		required="no">
		<cfargument name="PCGDautorizadoAnteriores" type="any" 		required="no">
		<cfargument name="PCGDautorizadoFuturos" 	type="any" 		required="no">
		<cfargument name="PCGDautorizado" 			type="any" 		required="no">
		<cfargument name="Ecodigo" 					type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 				type="string" 	required="no">
		<cfargument name="Conexion" 				type="string"  	required="no">
		
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<!---Se valida Detalle al Plan de Compras--->
		<cfquery datasource="#Arguments.Conexion#" name="rsDPlanCompras">
			select count(1) as cantidad from PCGDplanCompras where PCGDid = #Arguments.PCGDid#
		</cfquery>
		<cfif rsDPlanCompras.cantidad EQ 0>
			<cfthrow message="El Detalle al Plan de Compras no existe. Proceso cancelado.">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoTotalOri')>
			<cfset Arguments.PCGDcostoTotalOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoAnterioresOri')>
			<cfset Arguments.PCGDcostoAnterioresOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoFuturosOri')>
			<cfset Arguments.PCGDcostoFuturosOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoOri')>
			<cfset Arguments.PCGDcostoOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoTotal')>
			<cfset Arguments.PCGDautorizadoTotal = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoAnteriores')>
			<cfset Arguments.PCGDautorizadoAnteriores = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoFuturos')>
			<cfset Arguments.PCGDautorizadoFuturos = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizado')>
			<cfset Arguments.PCGDautorizado = "null">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into PCGDplanComprasMultiperiodo(PCGDid,PCGDcantidadTotal,PCGDcantidadAnteriores,PCGDcantidadFuturos,
   				PCGDcantidad,PCGDcostoTotalOri,PCGDcostoAnterioresOri,PCGDcostoFuturosOri,PCGDcostoOri,PCGDautorizadoTotal,
   				PCGDautorizadoAnteriores,PCGDautorizadoFuturos,PCGDautorizado,BMUsucodigo)
			values(	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadTotal#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadAnteriores#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadFuturos#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidad#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoTotalOri#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoAnterioresOri#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoFuturosOri#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoOri#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizadoTotal#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizadoAnteriores#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizadoFuturos#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizado#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			)
		</cfquery>
		<cfreturn #Arguments.PCGDid#>
	</cffunction>
	
	<!---=================CambioMPlanCompras: Modifica al plan de compras para gobierno multiperiodo=======--->
	<cffunction name="CambioMPlanCompras"  			access="public" returntype="numeric">
		<cfargument name="PCGDid" 					type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadTotal" 		type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadAnteriores" 	type="numeric" 	required="yes">
		<cfargument name="PCGDcantidadFuturos" 		type="numeric" 	required="yes">
		<cfargument name="PCGDcantidad" 			type="numeric" 	required="yes">
		<cfargument name="PCGDcostoTotalOri" 		type="any" 		required="no">
		<cfargument name="PCGDcostoAnterioresOri" 	type="any" 		required="no">
		<cfargument name="PCGDcostoFuturosOri" 		type="any" 		required="no">
		<cfargument name="PCGDcostoOri" 			type="any" 		required="no">
		<cfargument name="PCGDautorizadoTotal" 		type="any" 		required="no">
		<cfargument name="PCGDautorizadoAnteriores" type="any" 		required="no">
		<cfargument name="PCGDautorizadoFuturos" 	type="any" 		required="no">
		<cfargument name="PCGDautorizado" 			type="any" 		required="no">
		<cfargument name="Ecodigo" 					type="numeric" 	required="no">
		<cfargument name="BMUsucodigo" 				type="string" 	required="no">
		<cfargument name="Conexion" 				type="string"  	required="no">
		
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset  Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<!---Se valida Detalle al Plan de Compras--->
		<cfquery datasource="#Arguments.Conexion#" name="rsDPlanCompras">
			select count(1) as cantidad from PCGDplanCompras where PCGDid = #Arguments.PCGDid#
		</cfquery>
		<cfif rsDPlanCompras.cantidad EQ 0>
			<cfthrow message="El Detalle al Plan de Compras no existe. Proceso cancelado.">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoTotalOri')>
			<cfset Arguments.PCGDcostoTotalOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoAnterioresOri')>
			<cfset Arguments.PCGDcostoAnterioresOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoFuturosOri')>
			<cfset Arguments.PCGDcostoFuturosOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDcostoOri')>
			<cfset Arguments.PCGDcostoOri = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoTotal')>
			<cfset Arguments.PCGDautorizadoTotal = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoAnteriores')>
			<cfset Arguments.PCGDautorizadoAnteriores = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizadoFuturos')>
			<cfset Arguments.PCGDautorizadoFuturos = "null">
		</cfif>
		<cfif not isdefined('Arguments.PCGDautorizado')>
			<cfset Arguments.PCGDautorizado = "null">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			update  PCGDplanComprasMultiperiodo
			set 
				PCGDcantidadTotal 		 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadTotal#">,
				PCGDcantidadFuturos 	 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidadFuturos#">,
				PCGDcantidad			 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDcantidad#">,
				PCGDcostoTotalOri		 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoTotalOri#">,
				PCGDcostoFuturosOri 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoFuturosOri#">,
				PCGDcostoOri 			 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDcostoOri#">,
				PCGDautorizadoTotal 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizadoTotal#">,
				PCGDautorizadoFuturos 	 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizadoFuturos#">,
				PCGDautorizado 			 = <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.PCGDautorizado#">,
				BMUsucodigo				 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			where PCGDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDid#">
		</cfquery>
		<cfreturn #Arguments.PCGDid#>
	</cffunction>

	<!---=================BajaMPlanCompras: Elimina al plan de compras para gobierno multiperiodo=======--->
	<cffunction name="BajaMPlanCompras"  	access="public" returntype="void">
		<cfargument name="PCGDid" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 		type="string"  	required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			delete from PCGDplanComprasMultiperiodo 
			where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PCGDid#">
		</cfquery>
	</cffunction>
	
	<!---Verifica si una Clasificacion de Ingreso y Egreso esta relacionado a una plantilla--->
	<cffunction name="isRelated" access="public" returntype="boolean">
		<cfargument name="Conexion"  type="string"    required="no">
		<cfargument name="FPCCid"  	 type="numeric"   required="yes">
		<cfargument name="FPEPid"    type="numeric"   required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsisRelated">
			select count(1) as cantidad 
			from FPDPlantilla 
			where FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCCid#">
			  and FPEPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEPid#">
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#" name="isSon">
			select FPCCidPadre 
			from FPCatConcepto 
			where FPCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPCCid#"> 
			  and FPCCidPadre is not null
		</cfquery>
		<cfif rsisRelated.cantidad>
			<cfreturn true>
		<cfelseif isSon.recordcount GT 0>
			<cfreturn isRelated(Arguments.Conexion,isSon.FPCCidPadre,Arguments.FPEPid)>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
		<!----Obtiene las lineas del plan de compras para insertarlos en la solicitud----->
	<cffunction name="GetDetallePlanCompra"  access="public" returntype="query">
		<cfargument name="Conexion" 		type="string"  	required="no">
		<cfargument name="PCGDid" 			type="numeric" 	required="no">
		<cfargument name="PCGDtipo" 		type="string"   required="no">
		<cfargument name="CFid" 	    	type="numeric" 	required="no">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">	
		<cfargument name="ModuloOrigen" 	type="string" 	required="no" default="">
		<cfargument name="Fecha" 			type="date" 	required="no" default="#now()#">
		<cfargument name="Mcodigo" 			type="numeric" 	required="no">	
		<cfargument name="Descripcion" 		type="string" 	required="no">	
		<cfargument name="Actividad" 		type="string" 	required="no">

		<cfargument name="Obra"   		    type="numeric" 	required="no">
		<cfargument name="ObraDes"   		type="string" 	required="no">	
		<cfargument name="Proyecto" 		type="numeric" 	required="no">
		<cfargument name="ProyectoDes" 		type="string" 	required="no">		
		<cfargument name="GEconceptoGasto" 	type="boolean" 	required="no" default="false">	
		<cfargument name="viatico" 			type="numeric" 	required="no">
		<cfargument name="CPformato" 		type="string" 	required="no">	
		<cfargument name="VerTodo" 			type="string" 	required="no" default = "N">	
        <cfif not isdefined('Arguments.Conexion') or not len(trim(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or not len(trim(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfinvoke component="PRES_Presupuesto" method="rsCPresupuestoPeriodo" returnvariable="rsSQL">
			<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
			<cfinvokeargument name="ModuloOrigen" 	value="#Arguments.ModuloOrigen#">
			<cfinvokeargument name="FechaDocumento" value="#Arguments.Fecha#">
			<cfinvokeargument name="AnoDocumento" 	value="#DateFormat(Arguments.Fecha,"YYYY")#">
			<cfinvokeargument name="MesDocumento" 	value="#DateFormat(Arguments.Fecha,"MM")#">
		</cfinvoke>
		<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
		<!---<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>--->

		<cfquery name="Detalle" datasource="#Arguments.Conexion#">		   
		Select 
		    a.PCGDid,
			a.Cid,
			a.Aid,
			a.OBOid,
			a.FPCCid,
			a.FPAEid,			
			a.CFComplemento,
			a.OBOid,
			Ob.OBOcodigo,
			Ob.OBOdescripcion,
			Op.OBPcodigo,			
			Op.OBPdescripcion,
			a.PCGDxCantidad,
			a.CFid,
			a.Ucodigo,
			'<label style="font-weight:normal" title="'#_Cat#coalesce(c.Adescripcion, a.PCGDdescripcion)#_Cat#'">' #_Cat#<cf_dbfunction name='sPart' args='coalesce(c.Adescripcion, a.PCGDdescripcion)|1|50' delimiters="|">#_Cat#'</label>' #_Cat# case when <cf_dbfunction name="length"	args="coalesce(c.Adescripcion, a.PCGDdescripcion)"> > 50 then '...' else '' end as PCGDdescripcion,                               
			a.PCGDdescripcion as Descripcion,
			c.Adescripcion as ADescripcion,
			case when a.PCGDtipo =  'A' then c.Adescripcion  else a.PCGDdescripcion end as DescripcionSolicitud,
			<cf_dbfunction name='sPart' args='coalesce(c.Adescripcion, a.PCGDdescripcion)|1|50' delimiters="|">#_Cat#'</label>' #_Cat# case when <cf_dbfunction name="length"	args="coalesce(c.Adescripcion, a.PCGDdescripcion)"> > 50 then '...' else '' end as PCGDdescripciona,
			a.PCGDcostoOri, 			
			a.PCGDcostoUori,
			a.PCGDtipo,                                          
			coalesce(b.PCGDcantidadTotal,a.PCGDcantidad) as PCGDcantidadTotal,   
			<!------------ Requisicion------------------->
			(coalesce(a.PCGDcantidad,0) - coalesce(a.PCGDcantidadConsumo,0)) as MaxReqCant,
			<!------------ Periodo sencillo-------------->
			(coalesce(a.PCGDcantidad,0) - coalesce(a.PCGDcantidadCompras,0)) as PeriodoMCantidad,
			(coalesce(a.PCGDautorizado,0)- (coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0))) as PeriodoMUnit,	
			<!-------------Multiperiodo ----------------->		
			(coalesce(b.PCGDcantidadTotal,0) - coalesce(b.PCGDcantidadAnteriores,0) - coalesce(a.PCGDcantidadCompras,0)) as MultiCantidad,
			(coalesce(b.PCGDautorizadoTotal,0)- coalesce(b.PCGDautorizadoAnteriores,0) <!---- coalesce(a.PCGDautorizado,0)---> - (coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0))) as MultiMUnit,     
			<!------------------------------------------->
			a.PCGDcantidad,                                              
			a.PCGDcantidadCompras,
			a.PCGDreservado,
			a.PCGDcomprometido,
			a.PCGDejecutado,
			a.PCGcuenta,
			coalesce(b.PCGDcantidadAnteriores,0)    as PCGDcantidadAnteriores, 
			coalesce(b.PCGDautorizadoAnteriores ,0) as PCGDautorizadoAnteriores,                                    
			coalesce(b.PCGDautorizadoTotal,a.PCGDautorizado) as PCGDautorizadoTotal,    
			(coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0)) as TotalConsumido,
			a.PCGDautorizado - (coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0)) as Disponible,
			a.PCGDautorizado,
			a.Mcodigo,
			pcg.CFformato,
			pcg.CPformato			     
	  from PCGDplanCompras a 
	  left join PCGDplanComprasMultiperiodo b 
			 on a.PCGDid = b.PCGDid 
	  inner join PCGplanCompras EPC
			 on EPC.PCGEid = a.PCGEid	  	 
	  left outer join Articulos c 
		     on c.Aid = a.Aid
	  left outer join OBobra Ob
		     on a.OBOid = Ob.OBOid
	  left outer join OBproyecto Op
		     on Ob.OBPid = Op.OBPid 
	<cfif isdefined('Arguments.GEconceptoGasto') and  #Arguments.GEconceptoGasto#>	
		inner join GEconceptoGasto cg
		     on a.Cid = cg.Cid
	</cfif> 
		inner join PCGcuentas pcg
			on a.PCGcuenta = pcg.PCGcuenta
	   where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">
		   and EPC.CPPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#rsSQL.CPPid#">
		<cfif isdefined('Arguments.PCGDtipo') and  len(trim(Arguments.PCGDtipo))>
		  and a.PCGDtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PCGDtipo#"> 
		</cfif>
		<cfif isdefined('Arguments.PCGDid')>
		  and a.PCGDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.PCGDid#"> 
		</cfif>
		<cfif isdefined('Arguments.CFid')>
		  and a.CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.CFid#"> 
		</cfif> 
		<cfif isdefined('Arguments.Mcodigo')>
		  and a.Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#"> 
		</cfif> 
		<cfif isdefined('Arguments.viatico') and  len(trim(#Arguments.viatico#)) and  #Arguments.viatico# eq 1 >	
			and a.Cid in (select  distinct c.Cid  from GEPlantillaViaticos b inner join GEconceptoGasto c on b.gecid = c.gecid where b.Ecodigo=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">)
		</cfif> 
		<cfif isdefined('Arguments.Descripcion') and isdefined('Arguments.PCGDtipo') and Arguments.PCGDtipo eq 'A' >
		  and upper(c.Adescripcion) like upper('%#Arguments.Descripcion#%')
		<cfelseif isdefined('Arguments.Descripcion') and isdefined('Arguments.PCGDtipo') and Arguments.PCGDtipo neq 'A' >
		  and upper(a.PCGDdescripcion) like upper('%#Arguments.Descripcion#%')
		</cfif>  
		<cfif isdefined('Arguments.Actividad')>
		  and upper(a.CFComplemento) like upper('%#Arguments.Actividad#%')
		</cfif> 
		<cfif isdefined('Arguments.CPformato')>
		  and upper(pcg.CPformato) like upper('%#Arguments.CPformato#%')
		</cfif> 
		<cfif isdefined('Arguments.Proyecto')>
		  and upper(Op.OBPcodigo) like upper('%#Arguments.Proyecto#%')
		</cfif> 
		<cfif isdefined('Arguments.ProyectoDes')>
		  and upper(Op.OBPdescripcion) like upper('%#Arguments.ProyectoDes#%')
		</cfif> 
		
		<cfif isdefined('Arguments.Obra')>
		  and upper(Ob.OBOcodigo) like upper('%#Arguments.Obra#%')
		</cfif>  
		<cfif isdefined('Arguments.ObraDes')>
		  and upper(Ob.OBOdescripcion) like upper('%#Arguments.ObraDes#%')
		</cfif>  
		<cfif isdefined('VerTodo') and #Arguments.VerTodo# eq "S" >	
				and (a.PCGDautorizado - (coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0) + coalesce(a.PCGDpendiente,0))) > 0 	
				and (a.PCGDautorizado <> (coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0)))				
		<cfelse>
				and (a.PCGDautorizado - (coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0) + coalesce(a.PCGDpendiente,0))) > 0 	
				and (a.PCGDautorizado <> (coalesce(a.PCGDreservado,0) + coalesce(a.PCGDcomprometido,0) + coalesce(a.PCGDejecutado,0)+ coalesce(a.PCGDpendiente,0)))
		</cfif> 
		
		</cfquery>
		<cfreturn Detalle>
	</cffunction>
</cfcomponent>
