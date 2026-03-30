<cfcomponent>
	<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

	<!---►►Función que aplica un documento de importación, Devuelve el tracking generado (EDIid-ETidtracking)◄◄--->
	<cffunction name="aplicarTransaccion" access="public" returntype="string" hint="Función que aplica un documento de importación, Devuelve el tracking generado (EDIid-ETidtracking)">
		<cfargument name="EDIid" 		type="numeric" 	required="yes">
		<cfargument name="ParamAction" 	type="string"	required="yes">
        <cfargument name="Conexion" 	type="string" 	required="no"	hint="Nombre del DataSource">
		
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        <cfset LvarEcodigoCompradora = session.Ecodigo>
        
		<cfset EDIidparam 		= arguments.EDIid>
		<cfset action 			= arguments.ParamAction>
		<cfset trackingGenerado = "">
			
		<!---►►1.1 Obtiene los datos del encabezado del documento a aplicar y verifica que no haya sido aplicado◄◄--->
        <cfquery name="rsEncabezadoDocumento" datasource="#Arguments.Conexion#">
            select edi.EDIid, edi.Ddocumento, edi.EDItipo, edi.Mcodigo, edi.EDItc, edi.EPDid,
                   edi.EDIimportacion, m.Mnombre, sn.SNnombre, ediref.Ddocumento as DdocumentoRef,
                   case when edi.EDItipo = 'F' then 'Factura'
                        when edi.EDItipo = 'N' then 'Nota de Crédito'
                        when edi.EDItipo = 'D' then 'Nota de Débito'
                        else ''
                   end as TipoDocumento, edi.EDIfecha, edi.EDIfechaarribo
            from EDocumentosI edi
                inner join Monedas m
                    on m.Mcodigo = edi.Mcodigo
                inner join SNegocios sn
                    on sn.SNcodigo = edi.SNcodigo
                    and sn.Ecodigo = edi.Ecodigo
                left outer join EDocumentosI ediref
                    on ediref.EDIid = edi.EDIidRef
            where edi.EDIid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
              and edi.EDIestado = 0
        </cfquery>
        
        <cfif rsEncabezadoDocumento.RecordCount eq 0>
            <cf_errorCode	code = "50870" msg = "No se encontró el documento. Verifique que exista y que no haya sido aplicado">
        </cfif>
        
        <!---►►1.2 Verifica que existan líneas en el documento◄◄--->
        <cfquery name="rsDetallesDocumento" datasource="#Arguments.Conexion#">
            select 1
             from DDocumentosI ddi
            where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
        </cfquery>
        
        <cfif rsDetallesDocumento.RecordCount eq 0>
            <cf_errorCode	code = "50871" msg = "No se encontraron líneas en el documento">
        </cfif>
                
        <cfif len(trim(rsEncabezadoDocumento.EPDid)) gt 0>
            <cfquery name="rsVerificaHijos" datasource="#Arguments.Conexion#">
                select count(1) as cantidad
                from EPolizaDesalmacenaje a
                    inner join DDocumentosI b 
                    on b.EPDid = a.EPDid
                where b.EPDid = #rsEncabezadoDocumento.EPDid#
                and a.EPDidpadre is not null
            </cfquery>
        </cfif>
       
	  <!---►►Crea las tablas temporales de trabajo◄◄--->
      <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="fnCreaTablasTemp">
      </cfinvoke>
        
	   <!---►►Inicia la transaccion◄◄--->
       <cftransaction> 
       
        <cfif isdefined("rsVerificaHijos") and rsVerificaHijos.cantidad gt 0>
        	<!--- 1.P Aplica las líneas de fletes, seguros, gastos e impuestos de una póliza --->
				
            <cfquery name="rsLineasPoliza" datasource="#Arguments.Conexion#">
                select DDlinea, DDIconsecutivo, DOlinea, Ucodigo, Aid, DDIcantidad,
                       #LvarOBJ_PrecioU.enSQL_AS("DDIpreciou")#, 
                       DDIporcdesc, DDItotallinea, EPDid, ETidtracking
                from DDocumentosI
                  where EDIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
                    and DDIafecta in (1, 2, 4, 5)
                    and EPDid is not null
            </cfquery>
      
            <cfif rsLineasPoliza.RecordCount gt 0 and len(trim(rsEncabezadoDocumento.EPDid)) eq 0>
                <cf_errorCode	code = "50886" msg = "Se agregaron líneas a una poliza pero el encabezado del documento no tiene una póliza asociada">
            <cfelseif rsLineasPoliza.RecordCount gt 0>
           		
					<!--- 1.1.P Inserta las facturas de gastos, seguros, fletes e impuestos asociadas a la póliza --->
                    <cfinvoke component="polizaDesalmacenaje" method="insertIntoDPolizaByEDIid"> <!--- solo inserta en FacturasPoliza y CMImpuestosPoliza si enentra--->
                        <cfinvokeargument name="EDIid" 			    value="#EDIidparam#"/>
                        <cfinvokeargument name="debug" 				value="false"/>
                        <cfinvokeargument name="incluyeTransaction" value="false"/> 
                    </cfinvoke>
                    
                    <!--- 1.2.P Verifica que los nuevos montos de fletes, seguros y gastos no sean negativos --->
                    
                    <!--- 1.2.1.P Verifica que el nuevo monto de fletes no sea negativo --->
                    <cfquery name="rsNuevoMontoFletes" datasource="#Arguments.Conexion#">
                        select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Fletes
                        from FacturasPoliza b
                        	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea
                            inner join EDocumentosI edi
                            	on edi.EDIid   = ddi.EDIid
                        where b.FPafecta = 1
                          and edi.EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
                    </cfquery>
                
                    <cfif rsNuevoMontoFletes.RecordCount gt 0 and rsNuevoMontoFletes.Fletes lt 0>
                        <cf_errorCode	code = "50887" msg = "El nuevo monto de fletes es negativo">
                    </cfif>
                    
                    <!--- 1.2.2.P Verifica que el nuevo monto de seguros no sea negativo --->
                    <cfquery name="rsNuevoMontoSeguros" datasource="#Arguments.Conexion#">
                        select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Seguros
                         from FacturasPoliza b
                         	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea
                            inner join EDocumentosI edi
                            	on edi.EDIid   = ddi.EDIid
                        where b.FPafecta  = 2
                          and edi.EPDid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
                    </cfquery>
            
                    <cfif rsNuevoMontoSeguros.RecordCount gt 0 and rsNuevoMontoSeguros.Seguros lt 0>
                        <cf_errorCode	code = "50888" msg = "El nuevo monto de seguros es negativo">
                    </cfif>
                    
                    <!--- 1.2.3.P Verifica que el nuevo monto de gastos no sea negativo --->
                    <cfquery name="rsNuevoMontoGastos" datasource="#Arguments.Conexion#">
                        select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Gastos
                        from FacturasPoliza b
                        	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea	
                            inner join EDocumentosI edi
                            	on edi.EDIid = ddi.EDIid
                        where b.FPafecta = 4
                          and edi.EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
                    </cfquery>
                
                    <cfif rsNuevoMontoGastos.RecordCount gt 0 and rsNuevoMontoGastos.Gastos lt 0>
                        <cf_errorCode	code = "50889" msg = "El nuevo monto de gastos es negativo">
                    </cfif>
                    
                    <cfquery name="update" datasource="#Arguments.Conexion#">
                        update EDocumentosI set
                            EDIestado = 10
                        where EDIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
                    </cfquery>
                <!--- Los Documentos asociados a una póliza se aplican en CxP en el cierre de la póliza --->
                <cfreturn trackingGenerado><!--- Se sale de la función pues ya hizo lo que tenía que hacer para una póliza hija --->
            </cfif>
        </cfif>
        <!---************************************************************************************************************************************************************--->

			<cfif rsEncabezadoDocumento.EDIimportacion eq 1>

				<!--- En este query se guardan los datos para generar el seguimiento de trackings --->
				<cfset querySeguimiento = QueryNew("ETidtracking, DDIconsecutivo, Afecta, Descripcion, Monto")>

				<!--- 2. Aplica las líneas de costos --->

				<!--- 2.1. Obtiene la lista de líneas de costos --->
				<cfquery name="rsLineasCostos" datasource="#Arguments.Conexion#">
					select ddi.DDlinea, ddi.DDIconsecutivo, ddi.DOlinea,rtrim(ddi.Ucodigo) Ucodigo, ddi.DDIcantidad,
						   #LvarOBJ_PrecioU.enSQL_AS("ddi.DDIpreciou")#, ddi.DDIporcdesc, ddi.DDItotallinea, ddi.EPDid, ddi.ETidtracking,
						   do.EOidorden, do.DOdescripcion
					from DDocumentosI ddi
						inner join DOrdenCM do
							on do.DOlinea = ddi.DOlinea
					where ddi.EDIid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
					  and ddi.DDIafecta = 3
				</cfquery>
			
				<!--- 2.2. Verifica que el encabezado no tenga una póliza asociada --->
				<cfif rsLineasCostos.RecordCount gt 0 and len(trim(rsEncabezadoDocumento.EPDid)) gt 0>
					<cf_errorCode	code = "50872" msg = "No se pueden agregar líneas de costos a un documento de una póliza">
				</cfif>
			
				<!--- 2.3. Obtiene los ítems en los trackings que se van a afectar por notas de crédito o por notas de débito que se van a distribuir, y los pesos --->
				
				<!--- 2.3.1. Verifica si hay líneas de costos sin tracking asociado --->
				<cfquery name="rsItemsSinTracking" dbtype="query">
					select 1
					from rsLineasCostos
					where ETidtracking is null
				</cfquery>
				
				<!--- 2.3.2. Obtiene los ítems y los pesos --->
				<cfif rsEncabezadoDocumento.EDItipo eq 'N' or (rsEncabezadoDocumento.EDItipo eq 'D' and rsItemsSinTracking.RecordCount gt 0)>
				
					<cfquery name="rsItemsModificarCostosNotas" datasource="#Arguments.Conexion#">
						select eti.ETIiditem, eti.ETidtracking, eti.DOlinea,
							   (eti.ETcostodirecto - eti.ETcostodirectorec)
							   / (select sum(etisuma.ETcostodirecto - etisuma.ETcostodirectorec)
								  from ETrackingItems etisuma
								  where etisuma.ETIcantidad > 0
									and etisuma.ETcantfactura > 0
									and etisuma.ETcostodirecto > 0
									and etisuma.ETIestado = 0
									and etisuma.DOlinea in (select ddisuma.DOlinea
															from DDocumentosI ddisuma
																inner join EDocumentosI edisuma
																	 on edisuma.EDIid   = ddisuma.EDIid
																	and edisuma.Ecodigo = ddisuma.Ecodigo
															  where ddisuma.EDIid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
																and ddisuma.DDIafecta = 3
																and (edisuma.EDItipo  = 'N' or (edisuma.EDItipo = 'D' and ddisuma.ETidtracking is null))
														   )
									and etisuma.DOlinea = eti.DOlinea
									and <cf_dbfunction name="to_char" args="etisuma.ETidtracking"> not in (select epdsuma.EPembarque
																										   from EPolizaDesalmacenaje epdsuma
																										   where epdsuma.EPDestado = 0
																										  )
								 ) as Peso,
							   eti.Ucodigo, eti.Mcodigo, eti.ETtipocambiofac, do.EOidorden
						from ETrackingItems eti
							inner join DOrdenCM do
								on do.DOlinea = eti.DOlinea
						where eti.ETIcantidad > 0
							and eti.ETcantfactura > 0
							and eti.ETcostodirecto > 0
							and eti.ETIestado = 0
							and eti.DOlinea in (select ddi.DOlinea
												from DDocumentosI ddi
													inner join EDocumentosI edi
														on edi.EDIid = ddi.EDIid
														and edi.Ecodigo = ddi.Ecodigo
												where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
													and ddi.DDIafecta = 3
													and (edi.EDItipo = 'N' or (edi.EDItipo = 'D' and ddi.ETidtracking is null))
											   )
							and <cf_dbfunction name="to_char" args="eti.ETidtracking"> not in (select epd.EPembarque
																							   from EPolizaDesalmacenaje epd
																							   where epd.EPDestado = 0
																							  )
						order by eti.DOlinea, (eti.ETcostodirecto - eti.ETcostodirectorec) desc
					</cfquery>
					
					<!--- 2.3.3. Ajuste los pesos en caso de que la suma sea diferente a 1 --->
					<cfset DOlineaActual = "">
					<cfset DOlineaAjustada = false>
					<cfset CalcularMontosAjuste = true>

					<cfloop query="rsItemsModificarCostosNotas">
						<cfif DOlineaActual neq rsItemsModificarCostosNotas.DOlinea>
							<cfset DOlineaActual = rsItemsModificarCostosNotas.DOlinea>
							<cfset DOlineaAjustada = false>
							<cfset CalcularMontosAjuste = true>
						</cfif>
						
						<cfif not DOlineaAjustada>
						
							<cfif CalcularMontosAjuste>
								<cfquery name="rsSumaPesosCostosNotas" dbtype="query">
									select sum(Peso) as PesoTotal
									from rsItemsModificarCostosNotas
									where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DOlineaActual#">
								</cfquery>
								
								<cfset TotalAjuste = 1.00 - rsSumaPesosCostosNotas.PesoTotal>
							</cfif>
							
							<cfif TotalAjuste gt 0>
								<cfset nuevoPeso = rsItemsModificarCostosNotas.Peso + TotalAjuste>
								<cfset QuerySetCell(rsItemsModificarCostosNotas, "Peso", nuevoPeso, rsItemsModificarCostosNotas.CurrentRow)>
								<cfset DOlineaAjustada = true>
								<cfset CalcularMontosAjuste = true>
								<cfset TotalAjuste = 0>
							<cfelseif TotalAjuste lt 0>
								<cfif -1 * TotalAjuste gt rsItemsModificarCostosNotas.Peso>
									<cfset nuevoPeso = 0.00>
									<cfset CalcularMontosAjuste = false>
									<cfset TotalAjuste = TotalAjuste + rsItemsModificarCostosNotas.Peso>
								<cfelse>
									<cfset nuevoPeso = rsItemsModificarCostosNotas.Peso + TotalAjuste>
									<cfset DOlineaAjustada = true>
									<cfset CalcularMontosAjuste = true>
									<cfset TotalAjuste = 0>
								</cfif>
								<cfset QuerySetCell(rsItemsModificarCostosNotas, "Peso", nuevoPeso, rsItemsModificarCostosNotas.CurrentRow)>
							<cfelse>
								<cfset DOlineaAjustada = true>
								<cfset CalcularMontosAjuste = true>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
				
				<!--- 2.4. Verifica si hay que generar un tracking nuevo, y lo genera si es del caso (si por 
						   lo menos una línea de costos no se le asoció un tracking existente y el documento
						   es una factura) --->
				<cfquery name="rsGenerarTrackingNuevo" dbtype="query">
					select EOidorden
					from rsLineasCostos
					where ETidtracking is null
				</cfquery>
				
				<cfif rsGenerarTrackingNuevo.RecordCount gt 0 and rsEncabezadoDocumento.EDItipo eq 'F'>

					<cfinvoke component="sif.Componentes.CM_GeneraTracking" method="generarNumTracking" returnvariable="ETidtrackingNuevo">
						<cfinvokeargument name="CEcodigo" 	value="#session.CEcodigo#"/>
						<cfinvokeargument name="EcodigoASP" value="#session.EcodigoSDC#"/>
						<cfinvokeargument name="Ecodigo" 	value="#session.Ecodigo#"/>
						<cfinvokeargument name="Usucodigo" 	value="#session.Usucodigo#"/>
						<cfinvokeargument name="cncache" 	value="#Arguments.Conexion#"/>
						<cfinvokeargument name="EOidorden" 	value="#rsGenerarTrackingNuevo.EOidorden#"/>
					</cfinvoke>
		
					<cfif ETidtrackingNuevo eq 0>
						<cf_errorCode	code = "50873" msg = "No se pudo generar el tracking">
					<cfelse>
						<cfset trackingGenerado = "#EDIidparam#-#ETidtrackingNuevo#">
					</cfif>
				</cfif>

				<!--- 2.5. Para cada línea de costos hace lo siguiente: --->
				<cfloop query="rsLineasCostos">
				
					<!--- 2.5.1. Verifica que la línea no tenga asociada una póliza --->
					<cfif len(trim(rsLineasCostos.EPDid)) gt 0>
						<cf_errorCode	code = "50874" msg = "No se puede agregar una línea de costos a un documento de una póliza">
					</cfif>
					
					<!--- 2.5.2. Si el documento es tipo factura, o es de tipo nota de débito
								 y la línea tiene un tracking seleccionado, hace lo siguiente: --->
					<cfif rsEncabezadoDocumento.EDItipo eq 'F' or (rsEncabezadoDocumento.EDItipo eq 'D' and len(trim(rsLineasCostos.ETidtracking)) gt 0)>
                        
						<!--- 2.5.2.1. Agrega el ítem al tracking seleccionado o al nuevo --->
						<cfinvoke component="sif.Componentes.CM_GeneraTracking" method="addTrackingItem" returnvariable="insertado">
                                <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
                                <cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/>
							<cfif len(trim(rsLineasCostos.ETidtracking)) gt 0>
								<cfinvokeargument name="ETidtracking" value="#rsLineasCostos.ETidtracking#"/>
							<cfelse>
								<cfinvokeargument name="ETidtracking" value="#ETidtrackingNuevo#"/>
							</cfif>
                                <cfinvokeargument name="DOlinea" 			value="#rsLineasCostos.DOlinea#"/>
                                <cfinvokeargument name="DOdescripcion" 		value="#rsLineasCostos.DOdescripcion#"/>
                                <cfinvokeargument name="ETIcantidad" 		value="#rsLineasCostos.DDIcantidad#"/>
                                <cfinvokeargument name="ETcantfactura" 		value="#rsLineasCostos.DDIcantidad#"/>
                                <cfinvokeargument name="ETcostodirecto" 	value="#rsLineasCostos.DDItotallinea#"/>
                                <cfinvokeargument name="Ucodigo" 			value="#rsLineasCostos.Ucodigo#"/>
                                <cfinvokeargument name="Mcodigo" 			value="#rsEncabezadoDocumento.Mcodigo#"/>
                                <cfinvokeargument name="ETtipocambiofac" 	value="#rsEncabezadoDocumento.EDItc#"/>
                                <cfinvokeargument name="FechaDocumento" 	value="#rsEncabezadoDocumento.EDIfecha#"/>
						</cfinvoke>

						<!--- 2.5.2.2. Verifica que el ítem tenga una cuenta de tránsito asociada, si no tiene notifica el error --->
						<cfinvoke component="sif.Componentes.CM_OrdenCompra"  method="obtenerCuentaTransito" returnvariable="LvarCuentaTransito">
							<cfinvokeargument name="DOlinea" value="#rsLineasCostos.DOlinea#"/>
                            <cfinvokeargument name="Ecodigo" value="#LvarEcodigoCompradora#"/>
						</cfinvoke>
						
						<!--- 2.5.2.3. Hace la afectación al tránsito por la línea de costos --->
						<cfquery name="rsAfectacionTransitoCostos" datasource="#Arguments.Conexion#">
							insert into CMDetalleTransito
								(EDIid, DDlinea, Ecodigo, EOidorden,
								 DOlinea, 
								 DTfechamov,
								 DTmonto,
								 Mcodigo, tipocambio,
								 ETidtracking,
								 CTcuenta,
								 BMUsucodigo,
								 fechaalta, TipoMovimiento)
							values (
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsEncabezadoDocumento.EDIid#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLineasCostos.DDlinea#">,
								   <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLineasCostos.EOidorden#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLineasCostos.DOlinea#">,
								   <cf_dbfunction name="now">,
								   <cfqueryparam cfsqltype="cf_sql_money" 		value="#rsLineasCostos.DDItotallinea#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsEncabezadoDocumento.Mcodigo#">,
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#rsEncabezadoDocumento.EDItc#">,
								   <cfif len(trim(rsLineasCostos.ETidtracking)) gt 0>
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsLineasCostos.ETidtracking#">,
								   <cfelse>
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ETidtrackingNuevo#">,
								   </cfif>
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarCuentaTransito#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
								   <cf_dbfunction name="now">,
								   3
							)
						</cfquery>

						<!--- 2.5.2.4. Guarda el seguimiento de los costos --->
							<cfset QueryAddRow(querySeguimiento, 1)>
						<cfif len(trim(rsLineasCostos.ETidtracking)) gt 0>
							<cfset QuerySetCell(querySeguimiento, "ETidtracking", rsLineasCostos.ETidtracking)>
						<cfelse>
							<cfset QuerySetCell(querySeguimiento, "ETidtracking", ETidtrackingNuevo)>
						</cfif>
							<cfset QuerySetCell(querySeguimiento, "DDIconsecutivo", rsLineasCostos.DDIconsecutivo)>
                            <cfset QuerySetCell(querySeguimiento, "Afecta", "Costos")>
                            <cfset QuerySetCell(querySeguimiento, "Descripcion", rsLineasCostos.DOdescripcion)>
                            <cfset QuerySetCell(querySeguimiento, "Monto", rsLineasCostos.DDItotallinea)>
					
					<!--- 2.5.3. Sino, (cuando es nota de crédito, o nota de débito y no tiene un tracking seleccionado), hace lo siguiente: --->
					<cfelse>
					
						<!--- 2.5.3.1. Obtiene los ítems en los distintos trackings a modificar.
									   Notifica el error si no encontró ninguno --->
						<cfquery name="rsItemsDOlineaModificar" dbtype="query">
							select ETIiditem, DOlinea, Ucodigo, Mcodigo, ETtipocambiofac, EOidorden, Peso, ETidtracking
							from rsItemsModificarCostosNotas
							where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasCostos.DOlinea#">
							order by Peso desc
						</cfquery>

						<cfif rsItemsDOlineaModificar.RecordCount eq 0>
							<cf_errorCode	code = "50877"
											msg  = "No se encontró ningún ítem válido (facturado, disponible y que no se encuentre en una póliza abierta) en ningún tracking que pueda ser modificado por la línea @errorDat_1@"
											errorDat_1="#rsLineasCostos.DDIconsecutivo#"
							>
						</cfif>
						
						<cfset UcodigoCostos 		= rsLineasCostos.Ucodigo>
						<cfset DDIconsecutivoCostos = rsLineasCostos.DDIconsecutivo>
						<cfset DDlineaCostos 		= rsLineasCostos.DDlinea>
						<cfset DDItotallineaCostos 	= rsLineasCostos.DDItotallinea>
						<cfset DDIcantidadCostos 	= rsLineasCostos.DDIcantidad>
						<cfset DOdescripcionCostos 	= rsLineasCostos.DOdescripcion>
						
						<!--- 2.5.3.2. Verifica que el ítem tenga una cuenta de tránsito asociada, si no tiene notifica el error --->
						<cfinvoke component="sif.Componentes.CM_OrdenCompra" method="obtenerCuentaTransito" returnvariable="LvarCuentaTransito">
							<cfinvokeargument name="DOlinea" value="#rsLineasCostos.DOlinea#"/>
                            <cfinvokeargument name="Ecodigo" value="#LvarEcodigoCompradora#"/>
						</cfinvoke>
						
						<!--- Este query guarda las afectaciones que hay que hacerle al tránsito.
							  Se guardan en un query para poder hacer los ajustes antes de insertar
							  a detalle tránsito --->
						<cfset queryAfectacionTransitoCostos = QueryNew("EOidorden, DOlinea, DTmonto, ETidtracking, ETIiditem, Ucodigo, Mcodigo, ETtipocambiofac, Peso")>

						<!--- 2.5.3.3. Para cada ítem encontrado guarda la distribución --->
						<cfloop query="rsItemsDOlineaModificar">
						
							<cfset QueryAddRow(queryAfectacionTransitoCostos, 1)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "EOidorden", rsItemsDOlineaModificar.EOidorden)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "DOlinea", rsItemsDOlineaModificar.DOlinea)>
							<!--- El monto distribuido se redondea a 2 decimales para que lo que se guarda en detalle tránsito sea 
								  equivalente a lo que se guarda en los trackings, ya que en los trackings se guarda en la moneda de
								  la empresa, mientras que en detalle tránsito se guarda en la moneda original --->
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "DTmonto", LSNumberFormat(rsItemsDOlineaModificar.Peso * DDItotallineaCostos, '9.00'))>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "ETidtracking", rsItemsDOlineaModificar.ETidtracking)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "ETIiditem", rsItemsDOlineaModificar.ETIiditem)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "Ucodigo", rsItemsDOlineaModificar.Ucodigo)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "Mcodigo", rsItemsDOlineaModificar.Mcodigo)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "ETtipocambiofac", rsItemsDOlineaModificar.ETtipocambiofac)>
							<cfset QuerySetCell(queryAfectacionTransitoCostos, "Peso", rsItemsDOlineaModificar.Peso)>

						</cfloop>
						
						<!--- 2.5.3.4. Hace los ajustes a los montos distribuidos --->

						<cfquery name="rsSumDTmonto" dbtype="query">
							select sum(DTmonto) as DTmonto
							from queryAfectacionTransitoCostos
						</cfquery>
						<cfset TotalAjuste = DDItotallineaCostos - rsSumDTmonto.DTmonto>
						
						<cfif TotalAjuste neq 0>
							
							<cfset salirCicloAjustes = false>

							<cfloop query="queryAfectacionTransitoCostos">
								<cfif salirCicloAjustes>
									<cfbreak>
								</cfif>
								
								<cfset MontoDistribuido = queryAfectacionTransitoCostos.DTmonto>
								
								<!--- Si hay sobrante --->
								<cfif TotalAjuste lt 0.00>
									<!--- Si el total de ajuste es mayor al monto distribuido de la línea,
										  el monto a ajustar a la línea es igual al monto distribuido --->
									<cfif -1 * TotalAjuste gt MontoDistribuido>
										<cfset nuevoMonto = 0.00>
										<cfset TotalAjuste = TotalAjuste + MontoDistribuido>
									<!--- Sino, el monto a ajustar a la línea es igual al total de ajuste --->
									<cfelse>
										<cfset nuevoMonto = MontoDistribuido + TotalAjuste>
										<cfset TotalAjuste = 0>
										<cfset salirCicloAjustes = true>
									</cfif>
									<cfset QuerySetCell(queryAfectacionTransitoCostos, "DTmonto", nuevoMonto, queryAfectacionTransitoCostos.CurrentRow)>
								<!--- Si no, (faltante) --->
								<cfelseif TotalAjuste gt 0.00>
									<cfset nuevoMonto = MontoDistribuido + TotalAjuste>
									<cfset TotalAjuste = 0>
									<cfset QuerySetCell(queryAfectacionTransitoCostos, "DTmonto", nuevoMonto, queryAfectacionTransitoCostos.CurrentRow)>
									<cfset salirCicloAjustes = true>
								</cfif>
							</cfloop>
						</cfif>
						
						<!--- 2.5.3.5. Inserta a detalle tránsito y a los acumulados en los tracking los montos ajustados y guarda el seguimiento --->
						<cfloop query="queryAfectacionTransitoCostos">

                            
							<!--- 2.5.3.5.1. Actualiza el acumulado de costos en el ítem --->
							<cfinvoke component="sif.Componentes.CM_GeneraTracking" method="actualizarCostoTrackingItem" returnvariable="actualizado">
                                    <cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#"/>
                                    <cfinvokeargument name="Usucodigo" 			value="#session.Usucodigo#"/>
                                    <cfinvokeargument name="ETIiditem" 			value="#queryAfectacionTransitoCostos.ETIiditem#"/>
                                    <cfinvokeargument name="Monto" 				value="#queryAfectacionTransitoCostos.DTmonto#"/>
                                    <cfinvokeargument name="Ucodigo" 			value="#UcodigoCostos#"/>
                                    <cfinvokeargument name="Ucodigoref" 		value="#queryAfectacionTransitoCostos.Ucodigo#"/>
                                    <cfinvokeargument name="Mcodigo" 			value="#rsEncabezadoDocumento.Mcodigo#"/>
								<cfif len(trim(queryAfectacionTransitoCostos.Mcodigo)) gt 0>
									<cfinvokeargument name="Mcodigoref" 		value="#queryAfectacionTransitoCostos.Mcodigo#"/>
								</cfif>
									<cfinvokeargument name="ETtipocambiofac" 	value="#rsEncabezadoDocumento.EDItc#"/>
								<cfif len(trim(queryAfectacionTransitoCostos.ETtipocambiofac)) gt 0>
									<cfinvokeargument name="ETtipocambiofacref" value="#queryAfectacionTransitoCostos.ETtipocambiofac#"/>
								</cfif>
                                    <cfinvokeargument name="TipoDocumento" 		value="#rsEncabezadoDocumento.EDItipo#"/>
                                    <cfinvokeargument name="DOlinea" 			value="#queryAfectacionTransitoCostos.DOlinea#"/>
                                    <cfinvokeargument name="ETIcantidad" 		value="#queryAfectacionTransitoCostos.Peso * DDIcantidadCostos#"/>
                                    <cfinvokeargument name="ETcantfactura" 		value="#queryAfectacionTransitoCostos.Peso * DDIcantidadCostos#"/>
                                    <cfinvokeargument name="FechaDocumento" 	value="#rsEncabezadoDocumento.EDIfecha#"/>
							</cfinvoke>

							<!--- 2.5.3.5.2. Verifica que el nuevo monto de costos no sea negativo, si el documento es una nota de crédito --->
							<cfif rsEncabezadoDocumento.EDItipo eq 'N'>
								<cfquery name="rsNuevoCostoDirecto" datasource="#Arguments.Conexion#">
									select ETcostodirecto - ETcostodirectorec as ETcostodirecto, ETcantfactura, ETIcantidad, ETcostodirectofacorig
									from ETrackingItems
									where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoCostos.ETIiditem#">
								</cfquery>
								
								<cfif rsNuevoCostoDirecto.RecordCount gt 0>
									<cfif rsNuevoCostoDirecto.ETcostodirecto lt 0 or rsNuevoCostoDirecto.ETcostodirectofacorig lt 0>
										<cf_errorCode	code = "50878"
														msg  = "La aplicación de la línea @errorDat_1@, generó un costo directo negativo"
														errorDat_1="#DDIconsecutivoCostos#"
										>
									</cfif>
									<cfif rsNuevoCostoDirecto.ETcantfactura le 0 or rsNuevoCostoDirecto.ETIcantidad le 0>
										<cf_errorCode	code = "50879"
														msg  = "La aplicación de la línea @errorDat_1@, generó una cantidad menor o igual a 0"
														errorDat_1="#DDIconsecutivoCostos#"
										>
									</cfif>
								</cfif>
							</cfif>

							<!--- 2.5.3.5.3. Realiza la afectación al tránsito --->
							<cfquery name="rsAfectacionTransitoCostos" datasource="#Arguments.Conexion#">
								insert into CMDetalleTransito
									(EDIid, DDlinea, Ecodigo, EOidorden,
									 DOlinea, 
									 DTfechamov,
									 DTmonto,
									 Mcodigo, tipocambio,
									 ETidtracking,
									 CTcuenta,
									 BMUsucodigo,
									 fechaalta, TipoMovimiento)
								values (
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EDIid#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#DDlineaCostos#">,
									   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoCostos.EOidorden#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoCostos.DOlinea#">,
									   <cf_dbfunction name="now">,
									   <cfif rsEncabezadoDocumento.EDItipo eq 'N'>
									   <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoCostos.DTmonto * -1.00#">,
									   <cfelse>
									   <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoCostos.DTmonto#">,
									   </cfif>
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.Mcodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_float" value="#rsEncabezadoDocumento.EDItc#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoCostos.ETidtracking#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaTransito#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									   <cf_dbfunction name="now">,
									   3
								)
							</cfquery>
														
							<!--- 2.5.3.5.4. Guarda el seguimiento de los costos --->
							<cfset QueryAddRow(querySeguimiento, 1)>
							<cfset QuerySetCell(querySeguimiento, "ETidtracking", queryAfectacionTransitoCostos.ETidtracking)>
							<cfset QuerySetCell(querySeguimiento, "DDIconsecutivo", DDIconsecutivoCostos)>
							<cfset QuerySetCell(querySeguimiento, "Afecta", "Costos")>
							<cfset QuerySetCell(querySeguimiento, "Descripcion", DOdescripcionCostos)>
							<cfset QuerySetCell(querySeguimiento, "Monto", queryAfectacionTransitoCostos.DTmonto)>
						</cfloop>

					</cfif>
				</cfloop>
				
				<!--- 3. Aplica las líneas de fletes,seguros y gastos que no son de una póliza --->
				
				<!--- 3.1. Obtiene las líneas de fletes, seguros y gastos
						   Verifica que si el documento es NC o ND,
						   que todas las líneas tengan un tracking asociado,
						   y si es Factura, entonces que si no tiene tracking
						   asociado es porque se generó uno nuevo con la factura
						   actual --->
				<cfquery name="rsLineasFletesSeguros" datasource="#Arguments.Conexion#">
					select ddi.DDlinea, ddi.DDIconsecutivo, ddi.DDIcantidad, 
							#LvarOBJ_PrecioU.enSQL_AS("ddi.DDIpreciou")#,
						   ddi.DDIporcdesc, ddi.DDItotallinea, ddi.ETidtracking, ddi.DDIafecta,
						   con.Cdescripcion
					from DDocumentosI ddi
						inner join Conceptos con
							on con.Cid = ddi.Cid
					where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
						and ddi.DDIafecta in (1,2,4)
						and ddi.EPDid is null
						<cfif not isdefined("ETidtrackingNuevo")>
						and ddi.ETidtracking is not null
						</cfif>
				</cfquery>
				
				<cfquery name="rsLineasFletesSegurosTotal" datasource="#Arguments.Conexion#">
					select DDlinea
					 from DDocumentosI
					where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
					  and DDIafecta in (1,2,4)
					  and EPDid is null
				</cfquery>
				
				<cfif rsLineasFletesSeguros.RecordCount neq rsLineasFletesSegurosTotal.RecordCount>
					<cfif rsEncabezadoDocumento.EDItipo eq 'F'>
						<cf_errorCode	code = "50880" msg = "No se pueden aplicar líneas de fletes o seguros sin tracking asociado si la factura no contiene líneas de costos para un tracking nuevo">
					<cfelse>
						<cf_errorCode	code = "50881" msg = "No se pueden aplicar líneas de fletes o seguros sin tracking asociado">
					</cfif>
				</cfif>
				
				<!--- 3.2. Verifica que el encabezado no tenga una póliza asociada --->
				<cfif rsLineasFletesSeguros.RecordCount gt 0 and len(trim(rsEncabezadoDocumento.EPDid)) gt 0>
					<cf_errorCode	code = "50882" msg = "Las lineas no tienen póliza pero el encabezado sí tiene póliza asociada">

				<cfelseif rsLineasFletesSeguros.RecordCount gt 0>
				
					<!--- 3.3. Obtiene los pesos de los ítems de los tracking a modificar
							   (solo obtiene los de los ítems facturados, disponibles y que
							   no estén en una póliza abierta) --->
							   
					<!--- 3.3.1. Obtiene los pesos --->
							
					<cfquery name="rsItemsModificarFletesSeguros" datasource="#Arguments.Conexion#">
						select eti.ETIiditem,
							   eti.ETidtracking,
							   eti.DOlinea,
							   do.EOidorden,
							   eti.ETcostodirecto,
							   (eti.ETcostodirecto + eti.ETcostoindfletes + eti.ETcostoindseg - eti.ETcostodirectorec - eti.ETcostoindfletesrec - eti.ETcostoindsegrec)
							   / (select sum(etisuma.ETcostodirecto + etisuma.ETcostoindfletes + etisuma.ETcostoindseg - etisuma.ETcostodirectorec - etisuma.ETcostoindfletesrec - etisuma.ETcostoindsegrec)
								  from ETrackingItems etisuma
								  where (etisuma.ETidtracking in (select ddisuma.ETidtracking
															  from DDocumentosI ddisuma
															  where ddisuma.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
																  and ddisuma.DDIafecta in (1,2,4)
																  and ddisuma.EPDid is null
																  <cfif not isdefined("ETidtrackingNuevo")>
																  and ddisuma.ETidtracking is not null
																  </cfif>
															 )
											<cfif isdefined("ETidtrackingNuevo")>
											or etisuma.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingNuevo#">
											</cfif>
											)
									  and etisuma.ETidtracking = eti.ETidtracking
									  and etisuma.ETcantfactura > 0
									  and etisuma.ETIcantidad > 0
									  and etisuma.ETcostodirecto > 0
									  and etisuma.ETIestado = 0
									  and <cf_dbfunction name="to_char" args="etisuma.ETidtracking"> not in (select epdsuma.EPembarque
																										 from EPolizaDesalmacenaje epdsuma
																										 where epdsuma.EPDestado = 0
																										)
								 ) as Peso, eti.Mcodigo, eti.ETtipocambiofac
						from ETrackingItems eti
							inner join DOrdenCM do
								on do.DOlinea = eti.DOlinea
						where (eti.ETidtracking in (select ddi.ETidtracking
													from DDocumentosI ddi
													where ddi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
														and ddi.DDIafecta in (1,2,4)
														and ddi.EPDid is null
														<cfif not isdefined("ETidtrackingNuevo")>
														and ddi.ETidtracking is not null
														</cfif>
												   )
								<cfif isdefined("ETidtrackingNuevo")>
								or eti.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingNuevo#">
								</cfif>
								)
							and eti.ETcantfactura > 0
							and eti.ETIcantidad > 0
							and eti.ETcostodirecto > 0
							and eti.ETIestado = 0
							and <cf_dbfunction name="to_char" args="eti.ETidtracking"> not in (select epd.EPembarque
																							   from EPolizaDesalmacenaje epd
																							   where epd.EPDestado = 0
																							  )
						order by eti.ETidtracking, (eti.ETcostodirecto + eti.ETcostoindfletes + eti.ETcostoindseg - eti.ETcostodirectorec - eti.ETcostoindfletesrec - eti.ETcostoindsegrec) desc
					</cfquery>

					<!--- 3.3.2. Ajusta los pesos en caso de que la suma sea diferente a 1 --->
					
					<cfset ETidtrackingActual = "">			<!--- Variable que guarda el último tracking encontrado --->
					<cfset trackingNuevoEncontrado = false>	<!--- Indica si se encontró el tracking generado --->
					<cfset trackingAjustado = false>		<!--- Variable que indica si el tracking actual ya fue ajustado --->
					<cfset CalcularMontosAjuste = true>

					<cfloop query="rsItemsModificarFletesSeguros">

						<!--- Si se encontró un nuevo tracking, hay que ajustar los pesos --->
						<cfif (ETidtrackingActual neq rsItemsModificarFletesSeguros.ETidtracking and len(trim(rsItemsModificarFletesSeguros.ETidtracking)) neq 0) or (not trackingNuevoEncontrado and len(trim(rsItemsModificarFletesSeguros.ETidtracking)) eq 0)>

							<cfif len(trim(rsItemsModificarFletesSeguros.ETidtracking)) eq 0>
								<cfset ETidtrackingActual = ETidtrackingNuevo>
								<cfset trackingNuevoEncontrado = true>
							<cfelse>
								<cfset ETidtrackingActual = rsItemsModificarFletesSeguros.ETidtracking>
							</cfif>
							
							<cfset trackingAjustado = false>
							<cfset CalcularMontosAjuste = true>
						</cfif>
						
						<!--- Si se encontró un nuevo tracking o si falta un determinado monto por ajustar, se ajusta --->
						<cfif not trackingAjustado>
						
							<cfif CalcularMontosAjuste>
								<cfset ETidtrackingDelCicloAFS = rsItemsModificarFletesSeguros.ETidtracking>
							
								<!--- Obtiene el peso total --->
								<cfquery name="rsSumaPesosCostosFletesSeguros" dbtype="query">
									select sum(Peso) as PesoTotal
									from rsItemsModificarFletesSeguros
									<cfif len(trim(ETidtrackingDelCicloAFS)) eq 0>
									where ETidtracking is null
									<cfelse>
									where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingDelCicloAFS#">
									</cfif>
								</cfquery>
								
								<!--- Obtiene el monto que hay que ajustar --->
								<cfset TotalAjuste = 1.00 - rsSumaPesosCostosFletesSeguros.PesoTotal>

							</cfif>
							
							<!--- Si la suma de los pesos es menor a 1.00, se suma el faltante al peso actual --->
							<cfif TotalAjuste gt 0>
								<cfset nuevoPeso = rsItemsModificarFletesSeguros.Peso + TotalAjuste>
								<cfset QuerySetCell(rsItemsModificarFletesSeguros, "Peso", nuevoPeso, rsItemsModificarFletesSeguros.CurrentRow)>
								<cfset trackingAjustado = true>
								<cfset CalcularMontosAjuste = true>
								<cfset TotalAjuste = 0>

							<!--- Si la suma de los pesos es mayor a 1.00, se resta el maximo(sobrante, actual) al peso actual --->
							<cfelseif TotalAjuste lt 0>
								<cfif -1 * TotalAjuste gt rsItemsModificarFletesSeguros.Peso>
									<cfset nuevoPeso = 0.00>
									<cfset CalcularMontosAjuste = false>
									<cfset TotalAjuste = TotalAjuste + rsItemsModificarFletesSeguros.Peso>
								<cfelse>
									<cfset nuevoPeso = rsItemsModificarFletesSeguros.Peso + TotalAjuste>
									<cfset trackingAjustado = true>
									<cfset CalcularMontosAjuste = true>
									<cfset TotalAjuste = 0>
								</cfif>
								<cfset QuerySetCell(rsItemsModificarFletesSeguros, "Peso", nuevoPeso, rsItemsModificarFletesSeguros.CurrentRow)>
							<cfelse>
								<cfset trackingAjustado = true>
								<cfset CalcularMontosAjuste = true>
							</cfif>
						</cfif>
					</cfloop>

					<!--- 3.4. Para cada línea de fletes y seguros que no son de póliza hace lo siguiente: --->
					<cfloop query="rsLineasFletesSeguros">
					
						<!--- 3.4.1. Obtiene los ítems a modificar --->
						<cfquery name="rsItemsTrackingFletesSeguros" dbtype="query">
							select *
							from rsItemsModificarFletesSeguros
							<cfif len(trim(rsLineasFletesSeguros.ETidtracking)) eq 0>
							where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingNuevo#">
							<cfelse>
							where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasFletesSeguros.ETidtracking#">
							</cfif>
						</cfquery>
						
						<!--- 3.4.2. Verifica que haya por lo menos un ítem que se pueda modificar en ese tracking --->
						<cfif rsItemsTrackingFletesSeguros.RecordCount eq 0>
							<cf_errorCode	code = "50883"
											msg  = "No se pudo aplicar la línea @errorDat_1@ ya que ningún ítem ha sido facturado, o todos ya fueron desalmacenados, o todos se encuentran en una póliza abierta"
											errorDat_1="#rsLineasFletesSeguros.DDIconsecutivo#"
							>
						</cfif>
						
						<cfset DDIafectaFS 		= rsLineasFletesSeguros.DDIafecta>
						<cfset DDItotallineaFS 	= rsLineasFletesSeguros.DDItotallinea>
						<cfset DDIconsecutivoFS = rsLineasFletesSeguros.DDIconsecutivo>
						<cfset DDlineaFS 		= rsLineasFletesSeguros.DDlinea>
						<cfset ETidtrackingFS 	= rsLineasFletesSeguros.ETidtracking>
						
						<cfset queryAfectacionTransitoFS = QueryNew("EOidorden, DOlinea, DTmonto, CTcuenta, ETIiditem, Mcodigo, ETtipocambiofac")>
				
						<!--- 3.4.3. Para cada ítem a modificar, hace lo siguiente: --->
						<cfloop query="rsItemsTrackingFletesSeguros">
			
							<!--- 3.4.3.1. Verifica que el ítem tenga una cuenta de tránsito asociada, si no tiene notifica el error --->
							<cfinvoke component="sif.Componentes.CM_OrdenCompra" method="obtenerCuentaTransito" returnvariable="LvarCuentaTransito">
								<cfinvokeargument name="DOlinea" value="#rsItemsTrackingFletesSeguros.DOlinea#"/>
                                <cfinvokeargument name="Ecodigo" value="#LvarEcodigoCompradora#"/>
							</cfinvoke>
					
							
							<!--- 3.4.3.2. Guarda lo que va a insertar al tránsito y a los trackings --->
							<cfset QueryAddRow(queryAfectacionTransitoFS, 1)>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "EOidorden", rsItemsTrackingFletesSeguros.EOidorden)>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "DOlinea", rsItemsTrackingFletesSeguros.DOlinea)>
							<!--- El monto distribuido se redondea a 2 decimales para que lo que se guarda en detalle tránsito sea 
								  equivalente a lo que se guarda en los trackings, ya que en los trackings se guarda en la moneda de
								  la empresa, mientras que en detalle tránsito se guarda en la moneda original --->
							<cfset QuerySetCell(queryAfectacionTransitoFS, "DTmonto", LSNumberFormat(rsItemsTrackingFletesSeguros.Peso * DDItotallineaFS, '9.00'))>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "CTcuenta", LvarCuentaTransito)>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "ETIiditem", rsItemsTrackingFletesSeguros.ETIiditem)>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "Mcodigo", rsItemsTrackingFletesSeguros.Mcodigo)>
							<cfset QuerySetCell(queryAfectacionTransitoFS, "ETtipocambiofac", rsItemsTrackingFletesSeguros.ETtipocambiofac)>
						</cfloop>
						
						<!--- 3.4.4. Hace los ajustes a los montos de lo que va a insertar al tránsito y a los tracking --->

						<cfquery name="rsSumDTmonto" dbtype="query">
							select sum(DTmonto) as DTmonto
							from queryAfectacionTransitoFS
						</cfquery>
						<cfset TotalAjuste = DDItotallineaFS - rsSumDTmonto.DTmonto>
						
						<cfif TotalAjuste neq 0>
							
							<cfset salirCicloAjustes = false>

							<cfloop query="queryAfectacionTransitoFS">
								<cfif salirCicloAjustes>
									<cfbreak>
								</cfif>
								
								<cfset MontoDistribuido = queryAfectacionTransitoFS.DTmonto>
								
								<!--- Si hay sobrante --->
								<cfif TotalAjuste lt 0.00>
									<!--- Si el total de ajuste es mayor al monto distribuido de la línea,
										  el monto a ajustar a la línea es igual al monto distribuido --->
									<cfif -1 * TotalAjuste gt MontoDistribuido>
										<cfset nuevoMonto = 0.00>
										<cfset TotalAjuste = TotalAjuste + MontoDistribuido>
									<!--- Sino, el monto a ajustar a la línea es igual al total de ajuste --->
									<cfelse>
										<cfset nuevoMonto = MontoDistribuido + TotalAjuste>
										<cfset TotalAjuste = 0>
										<cfset salirCicloAjustes = true>
									</cfif>
									<cfset QuerySetCell(queryAfectacionTransitoFS, "DTmonto", nuevoMonto, queryAfectacionTransitoFS.CurrentRow)>
								<!--- Si no, (faltante) --->
								<cfelseif TotalAjuste gt 0.00>
									<cfset nuevoMonto = MontoDistribuido + TotalAjuste>
									<cfset TotalAjuste = 0>
									<cfset QuerySetCell(queryAfectacionTransitoFS, "DTmonto", nuevoMonto, queryAfectacionTransitoFS.CurrentRow)>
									<cfset salirCicloAjustes = true>
								</cfif>
							</cfloop>
						</cfif>
						
						<!--- 3.4.5. Inserta a detalle tránsito los montos ajustados y guarda el seguimiento --->
						<cfloop query="queryAfectacionTransitoFS">
							<!--- Obtiene el factor de conversión de la moneda de la factura
								  a la moneda del ítem en el tracking --->
							<cfinvoke component="sif.Componentes.CM_GeneraTracking" method="obtenerFactorConversionMoneda" returnvariable="factorConversionMonedaFO">
								<cfinvokeargument name="Mcodigo" 		value="#rsEncabezadoDocumento.Mcodigo#"/>
								<cfinvokeargument name="Mcodigoref" 	value="#queryAfectacionTransitoFS.Mcodigo#"/>	
								<cfinvokeargument name="TipoCambio" 	value="#rsEncabezadoDocumento.EDItc#"/>
								<cfinvokeargument name="TipoCambioRef" 	value="#queryAfectacionTransitoFS.ETtipocambiofac#"/>
								<cfinvokeargument name="Fecha" 			value="#rsEncabezadoDocumento.EDIfecha#"/>
								<cfinvokeargument name="UsarTCDoc" 		value="true"/>
							</cfinvoke>

							<!--- 3.4.5.1. Actualiza el monto del ítem en el tracking --->
							<cfquery name="rsDistribucionFletesSeguros" datasource="#Arguments.Conexion#">
								update ETrackingItems
								<!---►►Actualiza el monto de Fletes◄◄--->
								<cfif DDIafectaFS eq 1>
									<cfif rsEncabezadoDocumento.EDItipo eq 'N'>
									set ETcostoindfletes 		= ETcostoindfletes 		  - <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">,
										ETcostoindfletesfacorig = ETcostoindfletesfacorig - <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * factorConversionMonedaFO#">
									<cfelse>
									set ETcostoindfletes		= ETcostoindfletes        + <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">,
										ETcostoindfletesfacorig = ETcostoindfletesfacorig + <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * factorConversionMonedaFO#">
									</cfif>
                                <!---►►Actualiza el monto de Seguros◄◄--->
								<cfelseif DDIafectaFS eq 2>
									<cfif rsEncabezadoDocumento.EDItipo eq 'N'>
									set ETcostoindseg 		 = ETcostoindseg 		- <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">,
										ETcostoindsegfacorig = ETcostoindsegfacorig - <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * factorConversionMonedaFO#">
									<cfelse>
									set ETcostoindseg 		 = ETcostoindseg 		+ <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">,
										ETcostoindsegfacorig = ETcostoindsegfacorig + <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * factorConversionMonedaFO#">
									</cfif>
                                <!---►►Actualiza el monto de Gastos(OJO, la estructura no tienen Monto Origen)◄◄--->
                                <cfelseif DDIafectaFS eq 4>
									<cfif rsEncabezadoDocumento.EDItipo eq 'N'>
									set ETcostoindgastos 	 = ETcostoindgastos 		- <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">
									<cfelse>
									set ETcostoindgastos 	 = ETcostoindgastos 		+ <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * rsEncabezadoDocumento.EDItc#">
									</cfif>
								</cfif>
								where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoFS.ETIiditem#">
							</cfquery>

							<!--- 3.4.5.2. Verifica que el nuevo monto de fletes o seguros no sea negativo, si el documento es una nota de crédito --->
							<cfif rsEncabezadoDocumento.EDItipo eq 'N'>
								<cfquery name="rsNuevoCostoFletesSeguros" datasource="#Arguments.Conexion#">
									select ETcostoindfletes - ETcostoindfletesrec as ETcostoindfletes, ETcostoindseg - ETcostoindsegrec as ETcostoindseg, ETcostoindfletesfacorig, ETcostoindsegfacorig
									from ETrackingItems
									where ETIiditem = <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoFS.ETIiditem#">
								</cfquery>
								
								<cfif rsNuevoCostoFletesSeguros.RecordCount gt 0>
									<cfif rsNuevoCostoFletesSeguros.ETcostoindfletes lt 0 or rsNuevoCostoFletesSeguros.ETcostoindfletesfacorig lt 0>
										<cf_errorCode	code = "50884"
														msg  = "La aplicación de la línea @errorDat_1@, generó un costo indirecto de fletes negativo"
														errorDat_1="#DDIconsecutivoFS#"
										>
									<cfelseif rsNuevoCostoFletesSeguros.ETcostoindseg lt 0 or rsNuevoCostoFletesSeguros.ETcostoindsegfacorig lt 0>
										<cf_errorCode	code = "50885"
														msg  = "La aplicación de la línea @errorDat_1@, generó un costo indirecto de seguros negativo"
														errorDat_1="#DDIconsecutivoFS#"
										>
									</cfif>
								</cfif>
							</cfif>

							<!--- 3.4.5.3. Realiza la afectación al tránsito --->
							<cfquery name="rsAfectacionTransitoFletesSeguros" datasource="#Arguments.Conexion#">
								insert into CMDetalleTransito
									(EDIid, DDlinea, Ecodigo, EOidorden,
									 DOlinea, 
									 DTfechamov,
									 DTmonto,
									 Mcodigo, tipocambio,
									 ETidtracking,
									 CTcuenta,
									 BMUsucodigo,
									 fechaalta, TipoMovimiento)
								values (
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EDIid#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#DDlineaFS#">,
									   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoFS.EOidorden#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoFS.DOlinea#">,
									   <cf_dbfunction name="now">,
									   <cfif rsEncabezadoDocumento.EDItipo eq 'N'>
									   <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto * -1.00#">,
									   <cfelse>
									   <cfqueryparam cfsqltype="cf_sql_money" value="#queryAfectacionTransitoFS.DTmonto#">,
									   </cfif>
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.Mcodigo#">,
									   <cfqueryparam cfsqltype="cf_sql_float" value="#rsEncabezadoDocumento.EDItc#">,
									   <cfif len(trim(ETidtrackingFS)) eq 0>
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingNuevo#">,
									   <cfelse>
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETidtrackingFS#">,
									   </cfif>
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#queryAfectacionTransitoFS.CTcuenta#">,
									   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
									   <cf_dbfunction name="now">,
									   <cfif DDIafectaFS eq 1>
									   1
									   <cfelseif DDIafectaFS eq 2>
									   2
                                       <cfelse>
                                       4
									   </cfif>
								)
							</cfquery>
							
						</cfloop>
					
						<!--- 3.4.6. Guarda el seguimiento de los fletes y seguros --->
						<cfset QueryAddRow(querySeguimiento, 1)>
						<cfif len(trim(ETidtrackingFS)) eq 0>
						<cfset QuerySetCell(querySeguimiento, "ETidtracking", ETidtrackingNuevo)>
						<cfelse>
						<cfset QuerySetCell(querySeguimiento, "ETidtracking", rsLineasFletesSeguros.ETidtracking)>
						</cfif>
						<cfset QuerySetCell(querySeguimiento, "DDIconsecutivo", rsLineasFletesSeguros.DDIconsecutivo)>
						<cfif rsLineasFletesSeguros.DDIafecta eq 1>
							<cfset QuerySetCell(querySeguimiento, "Afecta", "Fletes")>
						<cfelseif rsLineasFletesSeguros.DDIafecta eq 2>
							<cfset QuerySetCell(querySeguimiento, "Afecta", "Seguros")>
                        <cfelseif rsLineasFletesSeguros.DDIafecta eq 4>
							<cfset QuerySetCell(querySeguimiento, "Afecta", "Gastos")>
						</cfif>
						<cfset QuerySetCell(querySeguimiento, "Descripcion", rsLineasFletesSeguros.Cdescripcion)>
						<cfset QuerySetCell(querySeguimiento, "Monto", rsLineasFletesSeguros.DDItotallinea)>
					</cfloop>
				</cfif>
				
				<!--- 4. Aplica las líneas de fletes, seguros, gastos e impuestos de una póliza --->
				
				<cfquery name="rsLineasPoliza" datasource="#Arguments.Conexion#">
					select DDlinea, DDIconsecutivo, DOlinea, Ucodigo, Aid, DDIcantidad,
						   #LvarOBJ_PrecioU.enSQL_AS("DDIpreciou")#, 
						   DDIporcdesc, DDItotallinea, EPDid, ETidtracking
					from DDocumentosI
					where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIidparam#">
						and DDIafecta in (1, 2, 4, 5)
						and EPDid is not null
				</cfquery>
				
				<cfif rsLineasPoliza.RecordCount gt 0 and len(trim(rsEncabezadoDocumento.EPDid)) eq 0>
					<cf_errorCode	code = "50886" msg = "Se agregaron líneas a una poliza pero el encabezado del documento no tiene una póliza asociada">
				<cfelseif rsLineasPoliza.RecordCount gt 0>
				
					<!--- 4.1 Inserta las facturas de gastos, seguros, fletes e impuestos asociadas a la póliza --->
					<cfinvoke component="polizaDesalmacenaje" method="insertIntoDPolizaByEDIid"> <!--- solo inserta en FacturasPoliza y CMImpuestosPoliza si enentra--->
						<cfinvokeargument name="EDIid" 				value="#EDIidparam#"/>
						<cfinvokeargument name="debug" 				value="false"/>
						<cfinvokeargument name="incluyeTransaction" value="false"/> 
					</cfinvoke>
					
					<!--- 4.2. Verifica que los nuevos montos de fletes, seguros y gastos no sean negativos --->
					
					<!--- 4.2.1. Verifica que el nuevo monto de fletes no sea negativo --->
					<cfquery name="rsNuevoMontoFletes" datasource="#Arguments.Conexion#">
						select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Fletes
						 from FacturasPoliza b
                         	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea
                            inner join EDocumentosI edi
                            	on edi.EDIid = ddi.EDIid
						where b.FPafecta = 1
					      and edi.EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
					</cfquery>
				
					<cfif rsNuevoMontoFletes.RecordCount gt 0 and rsNuevoMontoFletes.Fletes lt 0>
						<cf_errorCode	code = "50887" msg = "El nuevo monto de fletes es negativo">
					</cfif>
					
					<!--- 4.2.2. Verifica que el nuevo monto de seguros no sea negativo --->
					<cfquery name="rsNuevoMontoSeguros" datasource="#Arguments.Conexion#">
						select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Seguros
						from FacturasPoliza b
                        	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea
                            inner join EDocumentosI edi
                            	on edi.EDIid = ddi.EDIid
						where b.FPafecta = 2
						  and edi.EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
					</cfquery>
			
					<cfif rsNuevoMontoSeguros.RecordCount gt 0 and rsNuevoMontoSeguros.Seguros lt 0>
						<cf_errorCode	code = "50888" msg = "El nuevo monto de seguros es negativo">
					</cfif>
					
					<!--- 4.2.3. Verifica que el nuevo monto de gastos no sea negativo --->
					<cfquery name="rsNuevoMontoGastos" datasource="#Arguments.Conexion#">
						select coalesce(sum(FMmonto * case when edi.EDItipo = 'N' then -1.00 else 1.00 end),0.00) as Gastos
						from FacturasPoliza b
                        	inner join DDocumentosI ddi
                            	on ddi.DDlinea = b.DDlinea
                            inner join EDocumentosI edi
                            	on edi.EDIid = ddi.EDIid
						  where b.FPafecta = 4
							and edi.EPDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezadoDocumento.EPDid#">
					</cfquery>
				
					<cfif rsNuevoMontoGastos.RecordCount gt 0 and rsNuevoMontoGastos.Gastos lt 0>
						<cf_errorCode	code = "50889" msg = "El nuevo monto de gastos es negativo">
					</cfif>
				</cfif>
				
				<!--- 5. Genera la actividad de seguimiento si el documento no es de una póliza --->
				
				<cfif len(trim(rsEncabezadoDocumento.EPDid)) eq 0>
				
					<!--- 5.1. Obtiene los trackings afectados --->
					<cfquery name="rsTrackingsDocumento" dbtype="query">
						select distinct ETidtracking
						from querySeguimiento
					</cfquery>
					
					<cfset cambioDeLinea = " ">
					
					<!--- 5.2. Para cada tracking encontrado hace lo siguiente: --->
					<cfloop query="rsTrackingsDocumento">
						
						<!--- 5.2.1. Obtiene las líneas del documento asociadas a ese tracking --->
						<cfquery name="rsLineasDocumento" dbtype="query" maxrows="20">
							select DDIconsecutivo, Afecta, Descripcion, Monto
							from querySeguimiento
							where ETidtracking = #rsTrackingsDocumento.ETidtracking#
						</cfquery>
						
						<!--- 5.2.2. Crea el resumen de afectación al tránsito del tracking --->
						<cfset afectacionTracking = "">

						<cfset afectacionTracking = rsEncabezadoDocumento.TipoDocumento & ": " & rsEncabezadoDocumento.Ddocumento & cambioDeLinea>
						<cfset afectacionTracking = afectacionTracking & "Proveedor: " & rsEncabezadoDocumento.SNnombre & cambioDeLinea>
						<cfset afectacionTracking = afectacionTracking & "Moneda: " & rsEncabezadoDocumento.Mnombre & cambioDeLinea>
						<cfif len(trim(rsEncabezadoDocumento.DdocumentoRef)) gt 0>
							<cfset afectacionTracking = afectacionTracking & "Factura Referencia: " & rsEncabezadoDocumento.DdocumentoRef & cambioDeLinea>
						</cfif>
						<cfset afectacionTracking = afectacionTracking & cambioDeLinea>
						<cfset afectacionTracking = afectacionTracking & "Línea - Afecta a - Descripción - Monto" & cambioDeLinea>
						
						<cfloop query="rsLineasDocumento">
							<cfset afectacionTracking = afectacionTracking & rsLineasDocumento.DDIconsecutivo & "	" & rsLineasDocumento.Afecta & "	" & rsLineasDocumento.Descripcion & "	" & rsLineasDocumento.Monto & cambioDeLinea>
						</cfloop>

						<!--- 5.2.1.1 Revisar si se tienen más de 20 lineas --->
						<cfquery name="rsCantLineasDocumento" dbtype="query">
							select count(1) as Cantidad
							from querySeguimiento
							where ETidtracking = #rsTrackingsDocumento.ETidtracking#
						</cfquery>

						<cfif rsCantLineasDocumento.Cantidad GT 20>
							<cfset afectacionTracking = afectacionTracking & " ...(mas)">
						</cfif>
						
                        <cfinclude template="../../Utiles/sifConcat.cfm">
                        <cf_dbdatabase table="DTracking" returnvariable="LvarDTracking" datasource="sifpublica">
                        <cf_dbdatabase table="ETracking" returnvariable="LvarETracking" datasource="sifpublica">
						<!--- 5.2.3. Inserta la actividad de seguimiento --->				
						<cfquery name="insDTracking" datasource="#Arguments.Conexion#">
							insert into #LvarDTracking# (ETidtracking, CEcodigo, EcodigoASP, Ecodigo, cncache, DTactividad, DTtipo, DTfecha, DTfechaincidencia, CRid, DTnumreferencia, ETcodigo, BMUsucodigo, Observaciones)
							select
								ETidtracking,
								CEcodigo,
								EcodigoASP,
								Ecodigo,
								cncache,
								'Aplicación de la ' #_Cat# <cfif rsEncabezadoDocumento.EDItipo eq 'F'>'Factura ' <cfelseif rsEncabezadoDocumento.EDItipo eq 'N'>'Nota de Crédito '<cfelse>'Nota de Débito '</cfif> #_Cat# '#rsEncabezadoDocumento.Ddocumento#',
								'M',
								<cf_dbfunction name="now">,
								<cf_dbfunction name="now">,
								CRid,
								ETnumreferencia,
								ETcodigo,
								#session.Usucodigo#,
								'#afectacionTracking#'
							from #LvarETracking#
							where ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrackingsDocumento.ETidtracking#">
						</cfquery>
					</cfloop>

				</cfif>
                <!--- 1 = Fletes,2 = Seguro,3 = Costo,4-gasto,5 = Impuestos ---->
                <!--- Aplica solo para las transacciones que no están asociadas a una póliza de desalmacenaje --->
                
                <cfif len(trim(rsEncabezadoDocumento.EPDid)) eq 0> <!--- Solo aplica de una vez las transacciones que no estén relacionadas a una póliza de desalmacenaje --->
                    <!---NO IMPLEMENTADO, LINEAS DE COSTO LIGADOS A UN TRACKING--->
                    <cfquery name="rsValida" datasource="#Arguments.Conexion#">
                        select count(1) cantidad 
                         from DDocumentosI
                        where EDIid = #EDIidparam#
                          and DDIafecta = 3 
                          and ETidtracking is NOT null
                    </cfquery>
                    <cfif rsValida.cantidad GT 0>
                        <cfthrow message="No Implementado, lineas de Costo Ligados a un tracking">
                    </cfif>
                    <!---NO IMPLEMENTADO, LINEAS DE SEGURO Y FLETES, SIN LINEAS DE COSTO EN LAS CUALES PRORRATEARLAS(de donde se tomaria la cuenta??)--->
                    
					<!---NO IMPLEMENTADO, FLETES Y SEGURO LIGADOS A TRACKING Y OTRAS LINEAS DE COSTO MESCLADAS--->
                
                	<!---►►GENERACION DE LA CUENTA POR PAGAR◄◄--->
                     
                     <!---►►►►►►Inserta cada una de las lineas de Costo, como linea de la Factura de CXP--->
                     <cfquery name="rsDatosDet" datasource="#Arguments.Conexion#">
                         select 
                            coalesce(ddi.Cid, -1) as Cid,
                            coalesce(do.Alm_Aid, -1) as Alm_Aid, 
                            Coalesce(dcm.Ecodigo,do.Ecodigo) as Ecodigo,
                            
                            ddi.DDIafecta,
                            ddi.DDItipo, 
                            ddi.Aid as Aid, 
                            do.DOlinea, 
                            do.CFid,
                            do.DOalterna, 
                            ddi.DDIcantidad, 
                            ddi.DDIporcdesc, 
                            dt.DTmonto as TotalLinea,
                            ddi.EPDid, 
                            
                            -1 as Dcodigo,
                            -1 as OCTtipo, 
                            -1 as OCTtransporte, 
                            -1 as OCCid, 
                            -1 as OCid, 
                            -1 CFcuenta, 
                            -1 as PCGDid, 
                            -1 as FPAEid, 
                            -1 as OBOid, 
                            -1 as DSespecificacuenta,
                            -1 as Ccuenta,
                            
                            #session.Usucodigo# as BMUsucodigo, 
                            
                            <!---►Descripcion de la linea de CXP---> 
                            case ddi.DDIafecta 
                            	when 1 then 'Fletes:' #_Cat# do.DOdescripcion
                                when 2 then 'Seguro:' #_Cat# do.DOdescripcion
                                when 4 then 'Gasto:'  #_Cat# do.DOdescripcion
                                when 5 then 
                                    (select imp.Idescripcion from Impuestos imp
                                     where imp.Ecodigo = ddi.Ecodigo
                                    and imp.Icodigo = ddi.Icodigo)
                              else do.DOdescripcion end as DOdescripcion, 
                            <!---►Precio Unitario---> 
                            dt.DTmonto / ddi.DDIcantidad as PrecioUnitario, 
                            <!---►Descuento de la linea--->  
                            (dt.DTmonto / ddi.DDIcantidad * coalesce(ddi.DDIporcdesc,0)) / 100 as DescuentoLinea, 
                            <!---►Se coloca el impuesto Excento,para las lineas de impuestos, Fletes, Gasto e Impuestos◄◄--->
                            case when ddi.DDIafecta in (1,2,4,5) then '' else coalesce(ddi.Icodigo, do.Icodigo, null) end as Icodigo,
                            
							<!---►Unidad--->
                            coalesce(ddi.Ucodigo, do.Ucodigo, null) as Ucodigo
                            
                        from DDocumentosI ddi
                        
                       		inner join CMDetalleTransito dt
                            	on dt.DDlinea = ddi.DDlinea
                           
                            inner join DOrdenCM do
                                on do.DOlinea = dt.DOlinea
                                
                            LEFT OUTER JOIN DSolicitudCompraCM dcm
                            	ON dcm.DSlinea = do.DSlinea 
                           
                        where ddi.EDIid = #EDIidparam#
                          and ddi.DDItipo in ('A', 'F','S')
                    </cfquery>
                </cfif>
                
                <!--- Si existe al menos un detalle tipo Artículo, Servicio, Activo: pasa el dato a CxP --->
				<cfif isdefined("rsDatosDet") and rsDatosDet.recordcount gt 0>
                	
					<!---►►Valida que no se hallan Mesclado Empresas◄◄--->
                    <cfquery name="rsEcodigo" dbtype="query">
                    	select Distinct Ecodigo from rsDatosDet
                    </cfquery>
                    <cfif rsEcodigo.RecordCount GT 1>
                    	<cfthrow message="No puede incluir Lineas de Costos de Distintas Empresas">
                    <cfelse>
                    	<cfset LvarEcodigoSolicitante = rsEcodigo.Ecodigo>
                    </cfif>
                	
                    <!---►►Se obtienen los Datos del Encabezado◄◄--->
                    <cfquery name="rsDatosEnc" datasource="#Arguments.Conexion#">
                        select 
                            a.CPcodigo,
                            a.Ddocumento,
                            a.EDItc as EDtipocambio,
                            a.Ocodigo,
                            a.EDIfecha as EDfecha,
                            EDIfechaarribo as EDfechaarribo,
                            a.CPTcodigo,
                            
                             0 as EDdescuento,
                             0 as EDimpuesto,
                            -1 as Rcodigo,
                            -1 as EDdocref,
                            -1 as TESRPTCid,
                            -1 as SNcodigo,
                            -1 as id_direccion,
                            -1 as Ccuenta,
                            -1 as Mcodigo,
                            
                           '#session.Usulogin#' as EDusuario, 
                            #session.Usucodigo# as Usucodigo,
                            
                            <!---►ISO de la Moneda--->
                            (select Miso4217 from Monedas where Mcodigo = a.Mcodigo) as Miso4217,
                            <!---►Total de la Factura--->   
                             Coalesce((select sum(d.DDIcantidad * d.DDIpreciou)
                                        from DDocumentosI d
                                        where d.EDIid = a.EDIid),0) as EDtotal,
                            <!---►Identificación del Socio de Negocio--->
                            Coalesce((select SNidentificacion 
                            			from SNegocios 
                                       where SNcodigo = a.SNcodigo 
                                          and Ecodigo = a.Ecodigo),'') as SNidentificacion
    
                        from EDocumentosI  a
                        where a.EDIid     = #EDIidparam#
                          and a.EDIestado = 0
                    </cfquery>
                        
                    <cfinvoke component="sif.cm.Componentes.CM_Alta_DocumentosCxP" method="fnAltaEncDoc" returnvariable="LvarIDdocumento">
                        <cfinvokeargument name="CPTcodigo" 			value="#rsDatosEnc.CPTcodigo#">
                        <cfinvokeargument name="EDdocumento" 		value="#rsDatosEnc.Ddocumento#">
                        <cfinvokeargument name="SNcodigo" 			value="#rsDatosEnc.SNcodigo#">
                        <cfinvokeargument name="Mcodigo" 			value="#rsDatosEnc.Mcodigo#">
                        <cfinvokeargument name="EDtipocambio" 		value="#rsDatosEnc.EDtipocambio#">
                        <cfinvokeargument name="EDdescuento" 		value="#rsDatosEnc.EDdescuento#">
                        <cfinvokeargument name="EDimpuesto" 		value="#rsDatosEnc.EDimpuesto#">
                        <cfinvokeargument name="EDtotal" 			value="#rsDatosEnc.EDtotal#">
                        <cfinvokeargument name="Ocodigo" 			value="#rsDatosEnc.Ocodigo#">
                        <cfinvokeargument name="Ccuenta" 			value="#rsDatosEnc.Ccuenta#">
                        <cfinvokeargument name="EDfecha" 			value="#rsDatosEnc.EDfecha#">
                        <cfinvokeargument name="Rcodigo" 			value="#rsDatosEnc.Rcodigo#">
                        <cfinvokeargument name="EDusuario" 			value="#rsDatosEnc.EDusuario#">
                        <cfinvokeargument name="EDdocref" 			value="#rsDatosEnc.EDdocref#">
                        <cfinvokeargument name="EDfechaarribo" 		value="#rsDatosEnc.EDfechaarribo#">
                        <cfinvokeargument name="id_direccion" 		value="#rsDatosEnc.id_direccion#">
                        <cfinvokeargument name="TESRPTCid" 			value="#rsDatosEnc.TESRPTCid#">
                        <cfinvokeargument name="Usucodigo" 			value="#rsDatosEnc.Usucodigo#">
                        <cfinvokeargument name="ActivarTran" 		value="false">
                        <cfinvokeargument name="EDAdquirir" 		value="0">
                        <cfinvokeargument name="EDexterno" 			value="1">
                        <cfinvokeargument name="Ecodigo" 			value="#LvarEcodigoSolicitante#">
                        <cfinvokeargument name="SNidentificacion" 	value="#rsDatosEnc.SNidentificacion#">
                        <cfinvokeargument name="Miso4217" 			value="#rsDatosEnc.Miso4217#">
                   </cfinvoke>
                    	
					<!---►►Inserta cada uno de los detalles de la Factura◄◄--->
                    <cfloop query="rsDatosDet">
                    	<cfinvoke component="sif.Componentes.CM_OrdenCompra" method="obtenerCuentaTransito" returnvariable="LvarCuentaTransito">
							<cfinvokeargument name="DOlinea" value="#rsDatosDet.DOlinea#"/>
                            <cfinvokeargument name="Ecodigo" value="#LvarEcodigoSolicitante#"/>
						</cfinvoke>
                    
                        <cfinvoke component="sif.cm.Componentes.CM_Alta_DocumentosCxP" method="fnAltaDetDoc" returnvariable="ResultadoDet">
                       			<cfinvokeargument name="IDdocumento" 		value="#LvarIDdocumento#">
                            <cfif LEN(TRIM(rsDatosDet.Aid))>
                            	<cfinvokeargument name="Aid" 				value="#rsDatosDet.Aid#">
                            </cfif>
                                <cfinvokeargument name="Cid"  				value="#rsDatosDet.Cid#">
                                <cfinvokeargument name="DDdescripcion" 		value="#rsDatosDet.DOdescripcion#">
                                <cfinvokeargument name="DDdescalterna" 		value="#rsDatosDet.DOalterna#">
                             <cfif LEN(TRIM(rsDatosDet.CFid))>
                                <cfinvokeargument name="CFid" 				value="#rsDatosDet.CFid#">
                             </cfif>
                             <cfif LEN(TRIM(rsDatosDet.Alm_Aid))>    
                                <cfinvokeargument name="Alm_Aid" 			value="#rsDatosDet.Alm_Aid#">
                             </cfif>
                                <cfinvokeargument name="Dcodigo" 			value="#rsDatosDet.Dcodigo#">
                                <cfinvokeargument name="DDcantidad" 		value="#rsDatosDet.DDIcantidad#">
                                <cfinvokeargument name="DDpreciou" 			value="#rsDatosDet.PrecioUnitario#"> 
                                <cfinvokeargument name="DDdesclinea" 		value="#rsDatosDet.DescuentoLinea#">
                                <cfinvokeargument name="DDporcdesclin" 		value="#rsDatosDet.DDIporcdesc#"> 
                                <cfinvokeargument name="DDtotallinea" 		value="#rsDatosDet.TotalLinea#"> 
                                <cfinvokeargument name="DDtipo" 			value="#rsDatosDet.DDItipo#"> 
                            
                                <cfinvokeargument name="Ccuenta" 			value="#LvarCuentaTransito#">
                            
                                <cfinvokeargument name="CFcuenta" 			value="#rsDatosDet.CFcuenta#">
                                <cfinvokeargument name="Ecodigo" 			value="#LvarEcodigoSolicitante#"> 
                                <cfinvokeargument name="Icodigo" 			value="#rsDatosDet.Icodigo#">
                                <cfinvokeargument name="BMUsucodigo" 		value="#rsDatosDet.BMUsucodigo#">
                                <cfinvokeargument name="DSespecificacuenta" value="#rsDatosDet.DSespecificacuenta#">
                                <cfinvokeargument name="DDtransito" 		value="0">
                                <cfinvokeargument name="ActivarTran" 		value="false">
                       </cfinvoke>
                    </cfloop>
                </cfif>
			
			</cfif>
			
			<!--- 6. Actualiza el estado del documento a aplicado --->
			<cfif not isdefined("form.chk") or form.chk eq ''>
			<cf_dbtimestamp datasource="#Arguments.Conexion#"
							table="EDocumentosI"
							redirect="#action#"
							timestamp="#form.ts_rversion#"
							field1="EDIid" 
							type1="numeric" 
							value1="#EDIidparam#">
			</cfif>
			<cfquery name="update" datasource="#Arguments.Conexion#">
				update EDocumentosI set
					EDIestado = 10
				 where EDIid = <cfqueryparam value="#EDIidparam#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
		</cftransaction>
		
		<!---7. Inserta a la interfaz 102 si el documento no es de una póliza --->
		<cfif rsEncabezadoDocumento.RecordCount gt 0 and len(trim(rsEncabezadoDocumento.EPDid)) eq 0>
			<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
			<cfset LobjInterfaz.fnProcesoNuevoSoin(102,"EDIid=#EDIidparam#","R")>
		</cfif>

		<cfreturn trackingGenerado>

	</cffunction>
</cfcomponent>