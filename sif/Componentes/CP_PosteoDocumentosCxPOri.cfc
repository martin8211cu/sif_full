<cfcomponent output="no">
	<cffunction name="PosteoDocumento" access="public" returntype="string" output="no">
		<!---- Definición de Parámetros --->
		<cfargument name='IDdoc' 		type='numeric' 	required='true'>			 	<!--- Codigo del movimiento---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>			 	<!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 			<!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	<!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default="#Session.DSN#">
		<cfargument name='USA_tran' 	type="boolean" 	required='false' default='true'>
		<cfargument name='PintaAsiento' type="boolean" 	required='false' default='false'>
        <cfargument name='EntradasEnRecepcion' type="boolean" 	required='false' default='false' hint="false=Hace la entrada de una vez, true=Hace la entrada en la recepcion de Mecaderia"> 

		<cfset fnCreaTablasTemp(Arguments.Conexion)>
		<cfset LvarPintar = Arguments.PintaAsiento>
        	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from EDocumentosCxP a
			where a.IDdocumento = #Arguments.IDdoc#
		</cfquery>
	
		<cfif rsSQL.cantidad GT 0>
			
			<cf_dbfunction name="now" returnvariable="LvarHoy">
			
			<cfset LvarHoyYYYYMMDD 	= dateformat(createODBCdate(now()), "YYYYMMDD")>
			
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				from DDocumentosCxP a
				where a.IDdocumento = #Arguments.IDdoc#
			</cfquery>

			<cfif rsSQL.cantidad LT 1>
				<cf_errorCode	code = "51153" msg = "No Existen Líneas para el Documento Seleccionado. Proceso Cancelado!">
			</cfif>

			<cfset LvarPI = structNew()>
			<cfset LvarPI.NAP = 0>
			<cfset LvarPI.CPNAPIid = "">
	
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'GN'
				  and Pcodigo = 50
			</cfquery>
            <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
                <cfthrow message="No esta definido el período de Auxiliares. Proceso Cancelado!">
            </cfif>
			<cfset LvarAnoAux = rsSQL.Pvalor>
	
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'GN'
				  and Pcodigo = 60
			</cfquery>
            <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
                <cfthrow message="No esta definido el Mes de Auxiliares. Proceso Cancelado!">
            </cfif>
			<cfset LvarMesAux = rsSQL.Pvalor>

			<cfif len(LvarAnoAux) EQ 0 or len(LvarMesAux) EQ 0>
				<cf_errorCode	code = "51154" msg = "No se han definido los períodos de auxiliar en los parámetros del Sistema. Proceso Cancelado!">
			</cfif>

            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select Pvalor
                from Parametros
                where Ecodigo = #Arguments.Ecodigo# 
                  and Pcodigo = 420
            </cfquery>
            <cfset LvarPcodigo420 = rsSQL.Pvalor>
			<cfif LvarPcodigo420 EQ "">
                <cf_errorCode	code = "51155" msg = "No se ha definido el parámetro de Tipo de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
            </cfif>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo# 
				  and Mcodigo = 'AF'
				  and Pcodigo = 240
			</cfquery>
            <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
                <cfthrow message="No esta definida la cuenta de Activos en Tránsito. Proceso Cancelado!">
            </cfif>
			<cfset LvarCuentaActivos = rsSQL.Pvalor>

            <cf_cboFormaPago TESOPFPtipoId="4" TESOPFPid="#Arguments.IDdoc#" SQL="aplicacion">

			<cfquery datasource="#Arguments.Conexion#">
				update EDocumentosCxP
				   set  EDtipocambioFecha 	= coalesce (EDtipocambioFecha, EDfecha)
				 where IDdocumento	= #Arguments.IDdoc#
			</cfquery>

			<!--- Actualizar el total de la línea redondeando a 2 decimales --->
			<cfquery datasource="#Arguments.Conexion#">
				update DDocumentosCxP
 				   set DDtotallinea	= round(coalesce(DDtotallinea, 0.00), 2)
				     , DDdescalterna	= case when rtrim(DDdescalterna) = '' then null else rtrim(DDdescalterna) end
				 where IDdocumento = #Arguments.IDdoc#
			</cfquery>

			<cflock name="CPPosteoDocumentosCxP#Arguments.Ecodigo#" timeout="20" type="exclusive">
				<!--- Se verifica la existencia del registro por si lo aplicaron durante el candado "lock" --->
				<cfquery datasource="#Arguments.Conexion#" name="rsDocumento">
                    select  a.CPTcodigo,  a.EDdocumento, a.Ecodigo, a.SNcodigo, 
                            a.Mcodigo,    a.Ocodigo, a.EDdocref,
                            a.EDtipocambio, a.EDfecha,  
                            coalesce (a.EDtipocambioFecha, a.EDfecha) as EDtipocambioFecha,
                            coalesce (a.EDtipocambioVal, -1) as EDtipocambioVal,
                            case when b.CPTtipo = 'C' then 'E' else 'S' end as TipoES,
                            b.CPTafectacostoventas as afectacostoventas,
                            b.CPTtipo as CPTtipo,
                            a.EDtotal, 
                            a.EDdescuento,
                            a.EDimpuesto,
                            coalesce(
                                (
                                    select sum(DDtotallinea)
                                      from DDocumentosCxP
                                     where IDdocumento = a.IDdocumento
                                ) 
                            ,0.00) as SubTotal
							,coalesce(
								(
									select sum(DDtotallinea)
									  from DDocumentosCxP
									 inner join Impuestos i
										 on i.Ecodigo = DDocumentosCxP.Ecodigo
										and i.Icodigo = DDocumentosCxP.Icodigo
									 where IDdocumento = a.IDdocumento
									   and i.InoRetencion = 0
									 
								) - a.EDdescuento
							,0.00) as AplicarRetencion
                      from EDocumentosCxP a
                        inner join CPTransacciones b
                        on b.Ecodigo = a.Ecodigo
                        and b.CPTcodigo = a.CPTcodigo
                     where a.IDdocumento	= #Arguments.IDdoc#
				</cfquery>
			
				<cfset LvarLineas = rsDocumento.recordcount>
				<cfif LvarLineas GT 0>
					<cfset LvarEDdocumento  	= rsDocumento.EDdocumento>
					<cfset LvarCPTcodigo    	= rsDocumento.CPTcodigo>
					<cfset LvarCPTtipo 			= rsDocumento.CPTtipo>
					<cfset LvarTipoES  			= rsDocumento.TipoES>
					<cfset LvarMcodigoDoc   	= rsDocumento.Mcodigo>
					<cfset LvarEDtipocambio 	= rsDocumento.EDtipocambio>
					<cfset LvarFechaDoc     	= rsDocumento.EDfecha>
					<cfset LvarOcodigoDoc   	= rsDocumento.Ocodigo>
					<cfset LvarTotalDoc     	= rsDocumento.EDtotal + 0>
					<cfset LvarSubtotalDoc  	= rsDocumento.SubTotal>
					<cfset LvarAplicarRetencion	= rsDocumento.AplicarRetencion>
                    <cfset LvarDescuentoDoc		= rsDocumento.EDdescuento>
                    <cfset LvarImpuestoDoc		= rsDocumento.EDimpuesto>

					<cfset LvarDocref 			= rsDocumento.EDdocref>
					<cfset LvarEDTref = "">
					<cfset LvarEDdocref = "">

					<cfset LvarinsKardex = (rsDocumento.afectacostoventas EQ 0)>

					<cfif numberFormat(LvarTotalDoc,"9.99") NEQ numberFormat(LvarSubtotalDoc + LvarImpuestoDoc - LvarDescuentoDoc,"9.99")>
                    	<cf_errorCode	code = "51156"
                    					msg  = "El TotalDocumento no corresponde a TotalLineas + Impuesto - DescuentoDoc: <BR> @errorDat_1@ <> @errorDat_2@ + @errorDat_3@ - @errorDat_4@ (@errorDat_5@)"
                    					errorDat_1="#LvarTotalDoc#"
                    					errorDat_2="#LvarSubtotalDoc#"
                    					errorDat_3="#LvarImpuestoDoc#"
                    					errorDat_4="#LvarDescuentoDoc#"
                    					errorDat_5="#LvarSubtotalDoc+LvarImpuestoDoc-LvarDescuentoDoc#"
                    	>
                    </cfif>

					<cfquery datasource="#Arguments.Conexion#" name="rsHistoricos">
						select count(1) as Cantidad
						from EDocumentosCP 
						where Ecodigo    = #Arguments.Ecodigo# 
						  and CPTcodigo  = '#rsDocumento.CPTcodigo#' 
						  and Ddocumento = '#rsDocumento.EDdocumento#' 
						  and SNcodigo   = #rsDocumento.SNcodigo#
					</cfquery>
					<cfif rsHistoricos.Cantidad GT 0>
						<cf_errorCode	code = "51646" msg = "Ya existe un documento aplicado en el histórico con ese mismo número de documento. Proceso Cancelado!">
					</cfif>
	
					<cfif len(trim(LvarDocref)) GT 0>				
						<cfquery datasource="#Arguments.Conexion#" name="rsDocumentoECP">
								select
									a.CPTcodigo,
									a.Ddocumento
								from EDocumentosCP a
								where a.Ecodigo = #Arguments.Ecodigo#
								  and a.IDdocumento = #LvarDocref#
						</cfquery>
						<cfif isdefined('rsDocumentoECP') and rsDocumentoECP.recordcount GT 0>
							<cfset LvarEDTref = rsDocumentoECP.CPTcodigo>
							<cfset LvarEDdocref = rsDocumentoECP.Ddocumento>
						</cfif> 
					</cfif>

					<!--- Obtener el vencimiento --->

					<cfquery name="rsSQL" datasource="#Arguments.conexion#">
						select coalesce(c.CPTvencim, 0) as vencimiento
						from EDocumentosCxP a
							inner join CPTransacciones c
								 on c.CPTcodigo = a.CPTcodigo
								and c.Ecodigo   = a.Ecodigo
							inner join VencimientoSociosN b
								 on b.Ecodigo   = a.Ecodigo
								and b.SNcodigo  = a.SNcodigo
								and b.Tcodigo   = a.CPTcodigo
						where a.IDdocumento = #Arguments.IDdoc#
						and b.Mcodigo   = 'CP'
					</cfquery>
					<cfif rsSQL.recordcount EQ 0 or rsSQL.vencimiento EQ 0>
						<cfquery name="rsSQL" datasource="#Arguments.conexion#">
							select coalesce(SNvencompras, 0) as vencimiento
							from EDocumentosCxP a
								inner join SNegocios b
								on a.Ecodigo = b.Ecodigo
								and a.SNcodigo = b.SNcodigo
							where IDdocumento = #Arguments.IDdoc#
						</cfquery>
					</cfif>
	
					<cfset LvarVencimiento = rsSQL.vencimiento>

					<cfquery name="rsSQL" datasource="#Arguments.conexion#">
						select b.Rporcentaje as retencion
						from EDocumentosCxP a
							inner join Retenciones b
							on b.Ecodigo = a.Ecodigo
							and b.Rcodigo = a.Rcodigo
						where a.IDdocumento = #Arguments.IDdoc#
					</cfquery>
					<cfif rsSQL.recordcount GT 0>
						<cfset LvarRetencion = rsSQL.retencion>
					<cfelse>
						<cfset LvarRetencion = 0>
					</cfif>

					<cfquery name="rsSocio" datasource="#Arguments.Conexion#">
						select SNnumero, SNnombre, SNidentificacion
						  from SNegocios
						 where Ecodigo  = #Arguments.Ecodigo#
						   and SNcodigo = #rsDocumento.SNcodigo#
					</cfquery>

					<cfset LvarReferencia = LvarCPTcodigo & " " & rsSocio.SNnumero>
					<cfset LvarINTDES = left("CxP: #trim(rsSocio.SNidentificacion)# #trim(rsSocio.SNnombre)#", 80)> 

					<!--- 
						Obtiene la Moneda de Valuación.
							McodigoValuacion = se obtiene de Parámetros
							Si McodigoValuacion = McodigoLocal
								tcValuacion = 1
							sino Si McodigoOrigen y tcOrigen <> -1
								Si McodigoValuacion = McodigoOrigen
									Si tcValuacion <> -1 Y tcValuacion  <> tcOrigen SE GENERA ERROR
									tcValuacion = tcOrigen
							sino Si tcValuacion = -1
									tcValuacion = se obtiene de Históricos
					--->
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select Mcodigo
						  from Empresas 
						 where Ecodigo = #Arguments.Ecodigo#
					</cfquery>
					<cfset LvarMcodigoLocal = rsSQL.Mcodigo>
					
					<cfquery name="rsMonedaValuacion" datasource="#Arguments.Conexion#">
						select Pvalor 
						from Parametros 
						where Ecodigo = #Arguments.Ecodigo#
						and Pcodigo = 441
					</cfquery>

					<cfif rsMonedaValuacion.recordcount GT 0>
						<cfset LvarMonedaValuacion = rsMonedaValuacion.Pvalor>
					<cfelse>
						<cfset LvarMonedaValuacion = LvarMcodigoLocal>
					</cfif>
			
					<cfif LvarMcodigoDoc EQ LvarMcodigoLocal>
						<cfset LvarTCdocumento = 1>
					<cfelse>
						<cfset LvarTCdocumento = rsDocumento.EDtipocambio>
					</cfif>

					<cfset LvarEDtipocambioFecha = rsDocumento.EDtipocambioFecha>
					
					<cfinvoke 
						component		= "sif.Componentes.IN_PosteoLin" 
						method			= "IN_MonedaValuacion"  
						returnvariable	= "LvarMONEDAS"
			
						Ecodigo			= "#Arguments.Ecodigo#"
						tcFecha			= "#LvarEDtipocambioFecha#"
			
						McodigoOrigen	= "#rsDocumento.Mcodigo#"
						tcOrigen		= "#LvarTCdocumento#"
						tcValuacion		= "#rsDocumento.EDtipocambioVal#"
			
						Conexion		= "#Arguments.Conexion#"
					/>

					<cfset LvarTCvaluacion = LvarMONEDAS.VALUACION.TC>

	                <cfset CP_CalcularDocumento(Arguments.IDdoc, false, Arguments.Ecodigo, Arguments.Conexion)>
    
					<cfif Arguments.USA_tran>	
						<cftransaction>

							<cfset 	PosteoDoc (
										Arguments.IDdoc,
										Arguments.Ecodigo,
										Arguments.usuario,
										Arguments.debug,
										Arguments.Conexion,
										Arguments.EntradasEnRecepcion
							)>
						</cftransaction>
					<cfelse>
						<cfset 	PosteoDoc (
									Arguments.IDdoc,
									Arguments.Ecodigo,
									Arguments.usuario,
									Arguments.debug,
									Arguments.Conexion,
									Arguments.EntradasEnRecepcion
						)>
					</cfif>	
				</cfif>	
			</cflock>
		</cfif>	
	</cffunction>

	<cffunction name="PosteoDoc" access="private" returntype="string" output="no">
		<!---- Definición de Parámetros --->
		<cfargument name='IDdoc' 		type='numeric' 	required='true'>	 			<!--- Codigo del movimiento---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 			<!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 			<!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default="N">	<!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default="#Session.DSN#">
        <cfargument name='EntradasEnRecepcion' type="boolean" 	required='false' default='false' hint="false=Hace la entrada de una vez, true=Hace la entrada en la recepcion de Mecaderia"> 


		<!--- Genera los transportes para Dtipo=Transito --->
		<cfquery name="rsTransito" datasource="#Arguments.Conexion#">
			select distinct 
					d.DDtipo, d.OCTtipo, d.OCTtransporte, d.OCTfechaPartida, d.OCTobservaciones,
					oct.OCTid, oct.OCTestado
			  from DDocumentosCxP d
				left join OCtransporte oct
					 on oct.OCTtipo			= d.OCTtipo
					and oct.OCTtransporte	= d.OCTtransporte
			where d.IDdocumento	= #Arguments.IDdoc#
			  and d.DDtipo		IN ('T','O')
		</cfquery>
		<cfloop query="rsTransito">
			<cfif rsTransito.DDtipo EQ "T">
				<cfif rsTransito.OCTid EQ "">
					<cfquery datasource="#Arguments.Conexion#">
						insert into OCtransporte 
							(
								Ecodigo, OCTtipo, OCTtransporte, OCTestado, OCTfechaPartida, OCTobservaciones
							)
						values (
								#Arguments.Ecodigo#,
								'#rsTransito.OCTtipo#',
								'#rsTransito.OCTtransporte#',
								'T',
								<cfqueryparam cfsqltype="cf_sql_date"		value="#rsTransito.OCTfechaPartida#">,
								'#rsTransito.OCTobservaciones#'
							)
					</cfquery>
				<cfelseif rsTransito.OCTestado NEQ "T">
					<cf_errorCode	code = "50335"
									msg  = "Verificación de 'Producto en Tránsito': el transporte '@errorDat_1@-@errorDat_2@' es para 'Órdenes Comerciales' o está cerrado"
									errorDat_1="#rsTransito.OCTtipo#"
									errorDat_2="#rsTransito.OCTtransporte#"
					>
				</cfif>
			<cfelseif rsTransito.DDtipo EQ "O">
				<cfif rsTransito.OCTtipo EQ "" or rsTransito.OCTtransporte EQ "">
					<cf_errorCode	code = "50336" msg = "Verificación de 'Producto en Órden Comercial de Tránsito': no se registró el Transporte de la Órden Comercial">
				<cfelseif rsTransito.OCTid EQ "">
					<cf_errorCode	code = "50337"
									msg  = "Verificación de 'Producto en Órden Comercial de Tránsito': no existe el Transporte '@errorDat_1@-@errorDat_2@'"
									errorDat_1="#rsTransito.OCTtipo#"
									errorDat_2="#rsTransito.OCTtransporte#"
					>
				<cfelseif rsTransito.OCTestado EQ "C">
					<cf_errorCode	code = "50338"
									msg  = "Verificación de 'Producto en Órden Comercial de Tránsito': el transporte '@errorDat_1@-@errorDat_2@' ya está cerrado"
									errorDat_1="#rsTransito.OCTtipo#"
									errorDat_2="#rsTransito.OCTtransporte#"
					>
				<cfelseif rsTransito.OCTestado NEQ "A">
					<cf_errorCode	code = "50339"
									msg  = "Verificación de 'Producto en Órden Comercial de Tránsito': el transporte '@errorDat_1@-@errorDat_2@' no es para 'Órdenes Comerciales'"
									errorDat_1="#rsTransito.OCTtipo#"
									errorDat_2="#rsTransito.OCTtransporte#"
					>
				</cfif>
			</cfif>
		</cfloop>
		<!--- Fin Transportes para Transito --->

		<cfquery datasource="#Arguments.Conexion#">
			update EDocumentosCxP
			   set  EDtipocambioFecha 	= coalesce (EDtipocambioFecha, EDfecha),
					EDtipocambio		= #LvarTCdocumento#,
					EDtipocambioVal		= #LvarMONEDAS.VALUACION.TC#
			 where IDdocumento			= #Arguments.IDdoc#
		</cfquery>

		<cfset request.INTARC = "#INTARC#">

		<cfset LobjOC.OC_Aplica_CxP (Arguments.Ecodigo, Arguments.IDdoc, LvarAnoAux, LvarMesAux, Arguments.Conexion, CP_impLinea)>

		<cfset MovimientosContables (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, Arguments.Conexion, Arguments.EntradasEnRecepcion)>

		<!--- Obtiene el CFcuenta para utilizarla con el LvarSignoDB_CR --->
		<cfquery datasource="#Arguments.Conexion#">
			update #INTARC#
			   set CFcuenta =
					(
						select min(CFcuenta) 
						  from CFinanciera
						 where Ccuenta = #INTARC#.Ccuenta
					)
			 where CFcuenta IS NULL
		</cfquery>
		<!--- Determina el signo de los montos de DB/CR a Ejecutar --->
		<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
					method				= "fnSignoDB_CR" 	
					returnvariable		= "LvarSignoDB_CR"
					
					INTTIP				= "i.INTTIP"
					Ctipo				= "m.Ctipo"
					CPresupuestoAlias	= "cp"
					
					Ecodigo				= "#rsDocumento.Ecodigo#"
					AnoDocumento		= "#LvarAnoAux#"
					MesDocumento		= "#LvarMesAux#"
		/>

		<cfquery name="rsDOCid" datasource="#Arguments.Conexion#">
			select IDdocumento
			  from EDocumentosCP
			 where SNcodigo		=  #rsDocumento.SNcodigo#
			   and Ddocumento	= '#rsDocumento.EDdocumento#'
			   and CPTcodigo	= '#rsDocumento.CPTcodigo#'
			   and Ecodigo		=  #rsDocumento.Ecodigo#
		</cfquery>
        
	   	<!--- Registra la Ejecucion que se hace del Asiento de TODO LO QUE NO VIENE DE COMPRAS --->
	  	<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					Ccuenta,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					<!---,NAPreferencia,	LINreferencia--->
					PCGDid,
					PCGDcantidad
				)
			select
					INTORI,
					INTDOC,
					INTREF,
					#LvarHoy#,
					i.Periodo,
					i.Mes,
					INTLIN,
					i.Ccuenta,
					i.CFcuenta,
					cp.CPcuenta,
					i.Ocodigo,
					i.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen, 
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto, 
					'E',
					<!---,null, null--->
					PCGDid,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * coalesce(DDcantidad,0)
				
			  from  #INTARC# i
				inner join CFinanciera cf
					left join CPresupuesto cp
					   on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
					   on m.Ecodigo	= cf.Ecodigo
					  and m.Cmayor	= cf.Cmayor
				   on cf.CFcuenta = i.CFcuenta
			where i.DOlinea is null
		</cfquery>	
		<!--- 
			Proceso de Control de Presupuesto para Compras:
				Reserva,Compromete y Ejecuta a la misma cuenta que viene arrastrada desde la SC: 
				Cuenta Especificada o
					Artículo de Inventario:	Centro Funcional Cuenta de Inventario	+ Clasificación Artículo
					Activos Fijos:			Centro Funcional Cuenta de Inversión	+ Tipo Concepto Servicio
					Servicios:				Centro Funcional Cuenta de Gasto		+ Categoria y Clasificación del Activo
					(Servicios se debe Ejecutar la cuenta de la factura)
				Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario:
					Parámetro 548 = 0: Controla el Consumo del Artículo y se hace una Compra de Inventario sin Requisición (Es una compra sin cosumo)
					Parámetro 548 = 1: Controla la Compra  del Artículo y se hace una Compra de Inventario con Requisición y se genera la Requisición (Es un consumo sin compra)
		--->
		<cfset SIN_REQUISICION			= "(select sc.TRcodigo from ESolicitudCompraCM sc where sc.ESidsolicitud = d.ESidsolicitud) is NULL">
		<cfset CON_REQUISICION 			= "(select sc.TRcodigo from ESolicitudCompraCM sc where sc.ESidsolicitud = d.ESidsolicitud) is NOT NULL">
		<cfset CON_REQUISICION_AL_GASTO	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 1 where sc.ESidsolicitud = d.ESidsolicitud) is NOT NULL">
		<cfset CON_REQUISICION_ALMACEN	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 2 where sc.ESidsolicitud = d.ESidsolicitud) is NOT NULL">

		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo	= #session.Ecodigo#
			   and Pcodigo	= 548
		</cfquery>
		<cfset LvarCPconsumoInventario = rsSQL.Pvalor NEQ 1>
		<cfset LvarCPcomprasInventario = NOT LvarCPconsumoInventario>

		<!--- Registra el Descompromiso que se hace de las Ordenes de Compra Referenciadas --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					CFcuenta, CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,	LINreferencia,
					PCGDid, PCGDcantidad
				)
			select 
					INTORI,
					INTDOC,
					INTREF,
					#LvarHoy#,
					i.Periodo,
					i.Mes,
					-INTLIN,
					<!---	OJO: Siempre se descompromete la cuenta comprometida --->
					nap.CFcuenta, nap.CPcuenta,
					nap.Ocodigo,
					nap.Mcodigo,
					<!---	OJO: nap.CPNAPDmontoOri = round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) --->
					<!---	Si se está surtiendo más que la cantidad comprometida, se descompromete el saldo comprometido  --->
					#PreserveSingleQuotes(LvarSignoDB_CR)# * 
						-case 
							when d.DOcontrolCantidad = 0  	<!---	Si no se controla cantidad se descompromete únicamente el mismo monto utilizado --->
							then 
								round(INTMOE, 2)
							else							<!---	de lo contrario se descompromete según la cantidad utilizada en la factura --->
								round(
									case
										when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
										else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
									end
								,2)
						end,
					nap.CPNAPDtipoCambio,

					<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
					round(
					#PreserveSingleQuotes(LvarSignoDB_CR)# * 
							-case 
								when d.DOcontrolCantidad = 0  	
								then 
									round(INTMOE, 2)
								else							
									round(
										case
											when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
											else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
										end
									,2)
							end
					* nap.CPNAPDtipoCambio, 2),
						
					'CC',
					e.NAP, d.DOconsecutivo,
					d.PCGDid, 
					#PreserveSingleQuotes(LvarSignoDB_CR)# * -d.DOcantidad
			from  #INTARC# i
				inner join DOrdenCM d
					inner join EOrdenCM e
				  		on e.EOidorden = d.EOidorden 
				 	inner join CPNAPdetalle nap
						inner join CPresupuesto cp
						   on cp.CPcuenta = nap.CPcuenta
						inner join CFinanciera cf
							inner join CtasMayor m
							   on m.Ecodigo = cf.Ecodigo
							  and m.Cmayor	= cf.Cmayor
						   on cf.CFcuenta = nap.CFcuenta
				  		on nap.Ecodigo = e.Ecodigo 
				  	   and nap.CPNAPnum = e.NAP 
				       and nap.CPNAPDlinea = d.DOconsecutivo 
				 on d.DOlinea = i.DOlinea 
			where i.DOlinea is not null
			<!--- No controlar Presupuesto si Parámetro Control Presupuesto Compras de Inventario es de CONSUMO y la compra no es para consumo, o sea, la SC es SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
		</cfquery>
		 
		<!--- Registra la Ejecucion que se hace de las Ordenes de Compra Referenciadas --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea, 
					CFcuenta, CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					<!---,NAPreferencia,	LINreferencia--->
					PCGDid, PCGDcantidad
				)
			select 
					INTORI,
					INTDOC,
					INTREF,
					#LvarHoy#,
					i.Periodo,
					i.Mes,
					INTLIN,
					cf.CFcuenta, cp.CPcuenta,
					i.Ocodigo,
					i.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen, 
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto, 
					'E',
					<!---,null, null--->
					d.PCGDid,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad
			from  #INTARC# i
				inner join DOrdenCM d
					inner join EOrdenCM e
				  		 on e.EOidorden = d.EOidorden 
				 on d.DOlinea = i.DOlinea 
				inner join CFinanciera cf
					left join CPresupuesto cp
					   on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
					   on m.Ecodigo	= cf.Ecodigo
					  and m.Cmayor	= cf.Cmayor
				   on cf.CFcuenta = 
						<!---	
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
						</cfif>
							when d.CMtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, pero deberia ser la debitada --->
							when d.CMtipo = 'F'									then d.CFcuenta
							else i.CFcuenta
						end
			where i.DOlinea is not null
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
		</cfquery>
		
	   <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 
				INTORI, INTDOC, INTREF, 
				#LvarHoy# as INTFEC, 
				Periodo, Mes 
			from #INTARC# 
			where INTLIN = 1
		</cfquery>
	
		<!--- Inicializa Arguments.Intercompany --->
		<cfquery name="rsIntercompany" datasource="#Arguments.Conexion#">
			select distinct Ecodigo
			  from #INTARC# i,CFinanciera cf
				 where cf.CFcuenta = i.CFcuenta 
		</cfquery>
	
		<cfset LvarIntercompany = rsIntercompany.RecordCount GT 1>
		<cfset LvarPI	 = LobjControl.ControlPresupuestarioIntercompany(	
							rsSQL.INTORI, 
							rsSQL.INTDOC, 
							rsSQL.INTREF,
							rsSQL.INTFEC,
							rsSQL.Periodo,
							rsSQL.Mes,
							 Arguments.Conexion, Arguments.Ecodigo, 
							 -1,false,false,
							 LvarIntercompany
						) >
		
		<cfif LvarPI.NAP GTE 0>
			<!--- El NAP debe incluirse en el Componente de Posteo --->
			<cfset Contabiliza (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, LvarPI.NAP, LvarPI.CPNAPIid, Arguments.Conexion,Arguments.EntradasEnRecepcion )>

		<cfelse>
			<cfif len(trim(rsDOCid.IDdocumento)) gt 0>
				<cfquery datasource="#Arguments.Conexion#">
					update EDocumentosCP
					   set NRP = #abs(LvarPI.NAP)#
					 where IDdocumento =  #rsDOCid.IDdocumento#
				</cfquery>
	
				<cfquery datasource="#Arguments.Conexion#">
					update HEDocumentosCP
					   set NRP = #abs(LvarPI.NAP)#
					 where IDdocumento =  #rsDOCid.IDdocumento#
				</cfquery>
			</cfif>
			<cfquery datasource="#Arguments.Conexion#">
				update EDocumentosCxP
				   set NRP = #abs(LvarPI.NAP)#
				 where IDdocumento =  #Arguments.IDdoc#
			</cfquery>
			
			<cfif Arguments.debug EQ "S">
				<cftransaction action="commit" /> 
			</cfif>

			<cf_dbtemp_deletes>
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarPI.NAP)#">
		</cfif>

		<cfif Arguments.debug EQ "S">
			<cftransaction action="rollback" /> 
		</cfif>
		<cf_dbtemp_deletes>
	</cffunction>
	
	<cffunction name="fnCreaTablasTemp" access="public" returntype="void" output="no" hint="Metodo para crear las tablas temporales de trabajo">
		<cfargument name="Conexion" type="string" required="no" hint="Nombre del DataSource">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('SESSION.DSN')>
        	<CFSET Arguments.Conexion = SESSION.DSN>
        </cfif>

		<cf_dbtemp name="implineaCP3" returnvariable="CP_impLinea" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="iddocumento"    	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="linea"    			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ccuenta"   			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CFcuenta"   		type="numeric">
			<cf_dbtempcol name="ecodigo"    		type="integer"  mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="dicodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="descripcion"   		type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="montoBase"   	 	type="money"  	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float"  	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="impuesto6Decs" 		type="numeric(20,6)"  	mandatory="no">
			<cf_dbtempcol name="creditofiscal"    	type="integer"  mandatory="no">
			<cf_dbtempcol name="icompuesto"    		type="integer"  mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
		</cf_dbtemp>

		<cf_dbtemp name="impdocCP1" returnvariable="CP_impDoc" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="idreg"    			type="numeric" 	mandatory="yes" identity="yes">
			<cf_dbtempcol name="iddocumento"    	type="numeric" 	mandatory="yes">
			<cf_dbtempcol name="ecodigo"    		type="integer" 	mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)" 	mandatory="no">
			<cf_dbtempcol name="dicodigo"    		type="char(5)" 	mandatory="no">
			<cf_dbtempcol name="subtotal"    		type="money" 	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float" 	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money" 	mandatory="no">
			<cf_dbtempcol name="impuestocalc"    	type="money" 	mandatory="no">
			<cf_dbtempcol name="creditofiscal"    	type="integer" 	mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
			<cf_dbtempcol name="fijadousr"    		type="integer" 	mandatory="no">
		</cf_dbtemp>

		<cf_dbtemp name="costoLinCP2" returnvariable="CP_calculoLin" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="iddocumento"    	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="linea"    			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="subtotalLinea"	    type="money"  	mandatory="no">
			<cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="no">
			<cf_dbtempcol name="impuestoBase"    	type="money"  	mandatory="no">
			<cf_dbtempcol name="impuestoCosto"    	type="money"  	mandatory="no">
			<cf_dbtempcol name="impuestoCF"	    	type="money"  	mandatory="no">
			<cf_dbtempcol name="impuestoInterfaz"	type="money"  	mandatory="no">
			<cf_dbtempcol name="otrosCostos"    	type="money"  	mandatory="no">
			<cf_dbtempcol name="costoLinea"	    	type="money"  	mandatory="no">
			<cf_dbtempcol name="totalLinea"	    	type="money"  	mandatory="no">
		</cf_dbtemp>

		<cfset request.CP_impLinea		= CP_impLinea>
		<cfset request.CP_impDoc		= CP_impDoc>
		<cfset request.CP_calculoLin		= CP_calculoLin	>

		<cfset LobjControl	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjOC 		= createObject( "component","sif.oc.Componentes.OC_transito")>
		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")> 
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>

		<cfset LobjControl.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset LobjOC.OC_CreaTablas(Arguments.Conexion)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(session.dsn)> 
		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
	</cffunction>


	<cffunction name="MovimientosContables" access = "private" output	= "no">
			<cfargument name="IDdoc"      type="numeric" required="true">
			<cfargument name="Ecodigo"    type="numeric" required="true">
			<cfargument name="Edocumento" type="string"  required="yes">
			<cfargument name="CPTcodigo"  type="string"  required="yes">
			<cfargument name="Conexion"	  type="string"  required="yes">
            <cfargument name='EntradasEnRecepcion' type="boolean" 	required='false' default='false' hint="false=Hace la entrada de una vez, true=Hace la entrada en la recepcion de Mecaderia"> 


			<!--- Asiento:
					CxP					  precio * cantidad - DDdesclinea
										-	EDdescuento
										+ DDimpuestoCosto	+	DDimpuestoCF
				Descuento Doc	  Se va a prorratear por linea y agregarselo al costo de la linea
				A,O,T,S,F		  precio * cantidad - DDdesclinea
								- EDdescuento_prorrateado
								+ DDimpuestoCosto
				Credito Fiscal	  DDimpuestoCF
			--->
			
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + sum(DDimpuestoCosto+DDimpuestoCF) - EDdescuento --->
			<cfset CP_calculoLin	= request.CP_calculoLin	>
			<cfset CP_implinea		= request.CP_implinea>
			<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, INTCAM, INTMON)
				select 
					'CPFC',
					1,
					a.EDdocumento,
					'#LvarReferencia#',
					b.CPTtipo,
					'#LvarINTDES#',
					<cf_dbfunction name="Date_Format" args="a.EDfecha,YYYYMMDD">,
					#LvarAnoAux#,
					#LvarMesAux#,
					a.Ccuenta,
					a.Mcodigo,
					a.Ocodigo,
					round(a.EDtotal, 2),
					a.EDtipocambio,
					<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc>round(round(a.EDtotal,2) * a.EDtipocambio, 2)<cfelse>round(a.EDtotal, 2)</cfif>
				from EDocumentosCxP a
					inner join CPTransacciones b
					on b.Ecodigo = a.Ecodigo
					and b.CPTcodigo = a.CPTcodigo
				where a.IDdocumento = #Arguments.IDdoc#
				  and a.EDtotal <> 0
			</cfquery>
		
			<!--- 3b. Descuento a nivel del encabezado del Documento (ya va disminuido en costoLinea)--->
			<!---
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE )
				select 
					'CPFC',
					1,
					a.EDdocumento,
					'#LvarReferencia#', 
					<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc>round(a.EDdescuento * a.EDtipocambio,2)<cfelse>a.EDdescuento</cfif>, 
					case when b.CPTtipo = 'D' then 'D' else 'C' end,
					'Descuento al Documento',
					'#LvarHoyYYYYMMDD#',
					a.EDtipocambio,
					#LvarAnoAux#,
					#LvarMesAux#,
					#LvarCuentaDesc#,
					a.Mcodigo,
					a.Ocodigo,
					a.EDdescuento
				from EDocumentosCxP a
					inner join CPTransacciones b
					on  b.Ecodigo   = a.Ecodigo
					and b.CPTcodigo = a.CPTcodigo
				where a.IDdocumento = #Arguments.IDdoc#
				  and a.EDdescuento != 0
			</cfquery>
			--->
            <!---►►Valida la cuenta Contable◄◄--->
            <cfquery datasource="#Arguments.Conexion#" name="rsCuentaError">
				select count(1) cantidad
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and DDtipo <> 'O'
                  and case when DDtipo = 'F' and exists(select 1
													 	 from DOrdenCM do
									 				    where do.DOlinea = b.DOlinea) then
							coalesce((select cf.Ccuenta 
							           from DOrdenCM do
										  inner join CFinanciera cf
										    on cf.CFcuenta = do.CFcuenta
									    where do.DOlinea = b.DOlinea
								       ), #LvarCuentaActivos#
							         )
						else b.Ccuenta end  is null
			</cfquery>
            <cfif rsCuentaError.cantidad GT 0>
            	<cfthrow message="No se pudo recuperar la cuenta Contable de algunas de las lineas">
            </cfif>
			<!---►►3c  Detalle (Artículos o Transito o Servicios o Activos Fijos ). Se considera el impuesto aplicable al costo (credito fiscal = 0)◄◄--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( 
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,  		
					DDcantidad, DOlinea, 		
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid
					)
				select
					'CPFC',			1,			a.EDdocumento,		'#LvarReferencia#', 
					case c.CPTtipo 
						when 'D' then 'C' 
						else 'D' 
					end,
					case
						when b.DDtipo = 'A' then
							'Articulo: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
							                              <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
											             (select min(<cf_dbfunction name="sPart"args="art.Adescripcion;1;70" delimiters=";">) from Articulos art where art.Aid = b.Aid))
						when b.DDtipo = 'T' then
							'Transito: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
														  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
														  (select min(<cf_dbfunction name="sPart"args="art.Adescripcion;1;70"  delimiters=";">) from Articulos art where art.Aid = b.Aid))
						when b.DDtipo = 'S' AND coalesce(rtrim(b.ContractNo),'') <> '' then 
							'OC-D.' #_Cat# rtrim(b.ContractNo) #_Cat# ', Concepto: ' #_Cat# coalesce( 
														<cf_dbfunction name="sPart"args="b.DDdescalterna;1;37"  delimiters=";">, 
														<cf_dbfunction name="sPart"args="b.DDdescripcion;1;37"  delimiters=";">, 
														(select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;37"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						when b.DDtipo = 'S' then
							'Concepto: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
														  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">, 
														  (select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;70"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						when b.DDtipo = 'F' then
							'Activo: ' #_Cat# coalesce(<cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">, 
													   <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">
													   ,' 0' ) 
						else
							coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;80"  delimiters=";">, 
									  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;80"  delimiters=";">)
					end,
					'#LvarHoyYYYYMMDD#',
					#LvarAnoAux#,		#LvarMesAux#,

					<!---Cuenta Contable--->
					case 
						when DDtipo = 'F' and exists(select 1
													 from DOrdenCM do
									 				 where do.DOlinea = b.DOlinea) then
							coalesce(
								(
									select cf.Ccuenta 
							          from DOrdenCM do
										inner join CFinanciera cf
										 on cf.CFcuenta = do.CFcuenta
									 where do.DOlinea = b.DOlinea
									<!---F sin orden de compra: se debería generar la cuenta de inversión --->
								), #LvarCuentaActivos#
							)
						else
							b.Ccuenta
					end ,
					<!---Cuenta Financiera--->
					case
						when DDtipo = 'F' and exists(select 1
													 from DOrdenCM do
									 				 where do.DOlinea = b.DOlinea)then
								(select do.CFcuenta 
							          from DOrdenCM do
									 where do.DOlinea = b.DOlinea
									<!---F sin orden de compra: se debería generar la cuenta de inversión --->
								)
						else
							b.CFcuenta
					end ,
					
					case DDtipo
						when 'A' then
							(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
						when 'T' then
							(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
						when 'S' then
							coalesce((select min(cf.Ocodigo) from CFuncional cf where cf.CFid = b.CFid), #LvarOcodigoDoc#) 
						when 'F' then
							a.Ocodigo
						else
							a.Ocodigo
					end ,
					b.DDcantidad, 
					b.DOlinea,
					case 
						when DDtipo IN ('A','T') 
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case 
						when DDtipo IN ('A','T') 
						then
							round(
                            	co.costoLinea
								<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif> / #LvarTCvaluacion#
							,2)
						else 
							round(
                            	co.costoLinea
                            ,2)
					end as INTMOE,
					case 
						when DDtipo IN ('A','T') 
							then #LvarTCvaluacion#
						when #LvarMcodigoLocal# <> #LvarMcodigoDoc# 
							then a.EDtipocambio
						else 1.00
					end as INTCAM,
                    round(
                        co.costoLinea
						<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
					,2)
					as INTMON,
					b.PCGDid
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and DDtipo <> 'O'
			</cfquery>

			<!--- 3cc  Detalle (Ordenes Comerciales). Se generó en OC_Transito.cfc --->
			<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( 
					INTORI,		INTREL, 		INTDOC, 		INTREF,
					INTTIP,
					INTDES,
					INTFEC,
					Periodo, 	Mes,
					Ccuenta,
					CFcuenta,
					Ocodigo, 		
					Mcodigo, INTMOE, INTCAM, INTMON 
					)
				select
					'CPFC',			1,			'#LvarEDdocumento#',		'#LvarReferencia#', 
					INTTIP,
					OCcontratos	#_CAT# 
						',' #_CAT# 
						case OCPTDtipoMov 
							when 'T' then 'TRANSITO'
							when 'C' then 'COSTO VENTA'
							when 'I' then 'INGRESO'
							when 'E' then 'DST.ENT.INVENTARIO'
							when 'S' then 'ORI.SAL.INVENTARIO'
							else ' ?????'
						end #_CAT# 
						',ART.' #_CAT# 
						(select rtrim(ltrim(art.Acodigo)) #_CAT# ': ' #_CAT# rtrim(ltrim(art.Adescripcion)) from Articulos art where art.Aid = d.Aid ),
					'#LvarHoyYYYYMMDD#',
					#LvarAnoAux#,		#LvarMesAux#,
					(select min(Ccuenta) from CFinanciera cf where cf.CFcuenta = d.CFcuenta),
					d.CFcuenta,
					d.Ocodigo,
					#LvarMonedaValuacion#,
					OCPTDmontoValuacion,
					#LvarTCvaluacion#,
					OCPTDmontoLocal
				from #request.OC_DETALLE# d
			</cfquery>
		
			<cfquery name="rsimpuestoslinea" datasource="#Arguments.Conexion#">
				select 
					icodigo as Icodigo,
					dicodigo as DIcodigo,
					ccuenta as Cuenta,
					CFcuenta,
					round( sum(impuesto) * #LvarEDtipocambio# , 2) 	as MontoLocal, 
					round( sum(impuesto), 2)                     	as MontoOrig, 
					min(porcentaje) as Porcentaje,
					min(il.descripcion) as Descripcion
				from #CP_impLinea# il
				where il.creditofiscal = 1
				group by 
					il.icodigo, 
					il.dicodigo,
					il.ccuenta
				having sum(impuesto) <> 0.00
			</cfquery>

			<cfloop query="rsimpuestoslinea">
				<cfset LvarIcodigo     = rsimpuestoslinea.Icodigo>
				<cfset LvarDIcodigo    = rsimpuestoslinea.DIcodigo>
				<cfset LvarCuenta      = rsimpuestoslinea.Cuenta>
				<cfset LvarCFcuenta    = rsimpuestoslinea.CFcuenta>
				<cfset LvarMontoLocal  = rsimpuestoslinea.MontoLocal>
				<cfset LvarMontoOrig   = rsimpuestoslinea.MontoOrig>
				<cfset LvarPorcentaje  = rsimpuestoslinea.Porcentaje>
				<cfset LvarDescripcion = rsimpuestoslinea.Descripcion>

				<cfif LvarIcodigo eq LvarDIcodigo>
					<cfset LvarDescripcion = "#LvarIcodigo# : #LvarDescripcion# #LvarPorcentaje#%">
				<cfelse>
					<cfset LvarDescripcion = "#LvarIcodigo# - #LvarDIcodigo# : #LvarDescripcion# #LvarPorcentaje#%">
				</cfif>							

				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# ( 
						INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, 
						Ccuenta, 
						<cfif LvarCFcuenta NEQ "">
 							CFcuenta,
						</cfif>
						Mcodigo, Ocodigo, INTMOE)
					select 
						'CPFC',
						1,
						'#LvarEDdocumento#',
						'#LvarReferencia#', 
						#LvarMontoLocal# , 
						<cfif LvarCPTtipo EQ 'D'>'C'<cfelse>'D'</cfif> as INTTIP,
						 <cf_dbfunction name="sPart"args="'#LvarDescripcion#';1;80"  delimiters=";"> as INTDES,
						'#LvarHoyYYYYMMDD#',
						#LvarEDtipocambio#,
						#LvarAnoAux#,
						#LvarMesAux#,
						#LvarCuenta#,
						<cfif LvarCFcuenta NEQ "">
 							#LvarCFcuenta#,
						</cfif>
						#LvarMcodigoDoc#,
						#LvarOcodigoDoc#,
						#LvarMontoOrig#
					from dual
				</cfquery>
			</cfloop>

			<!--- 4) Invocar el Posteo de Lineas de Inventario --->
			<!--- 	 Excluir con OC con Tipo Requisición --->
			<cfquery datasource="#Arguments.Conexion#" name="rsInventario">
				select  b.FPAEid,
                		b.CFComplemento,
                        Coalesce(oc.DSlinea,-1) as DSlinea,
					b.Aid, b.Linea, b.Alm_Aid, b.Dcodigo,
					b.DDcantidad, 
                    	co.costoLinea as CostoOri,
                    (
                        co.costoLinea 
                        <cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
					) as CostoLoc
					,(select min(Ocodigo) from Almacen where Aid = b.Alm_Aid) as Ocodigo
				from EDocumentosCxP a
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						left join DOrdenCM oc
							inner join ESolicitudCompraCM sc
							 on sc.ESidsolicitud = oc.ESidsolicitud
						 on oc.DOlinea = b.DOlinea
					on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo = 'A'
				  and NOT (oc.DOlinea is not null AND sc.TRcodigo is not null)
			</cfquery>
			
            <cfif NOT Arguments.EntradasEnRecepcion>
                <cfloop query="rsInventario">
                <cfif #rsInventario.FPAEid# neq ''>
                    <cfset LvarFPAEid =  #rsInventario.FPAEid#>
                <cfelse>
                    <cfset LvarFPAEid =  0>
                </cfif>
                    <cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="LvarDatosInv">
                        <cfinvokeargument name="Aid" 	       		value="#rsInventario.Aid#"/>							
                        <cfinvokeargument name="Alm_Aid"       		value="#rsInventario.Alm_Aid#"/>
                        <cfinvokeargument name="Dcodigo"       		value="#rsInventario.Dcodigo#"/>
                        <cfinvokeargument name="Tipo_Mov"      		value="E"/>
                        <cfinvokeargument name="Cantidad"      		value="#rsInventario.DDcantidad#"/>
                        <cfinvokeargument name="ObtenerCosto"  		value="false">
                        <cfinvokeargument name="McodigoOrigen" 		value="#LvarMcodigoDoc#">
                        <cfinvokeargument name="CostoOrigen"   		value="#rsInventario.CostoOri#">
                        <cfinvokeargument name="CostoLocal"       	value="#rsInventario.CostoLoc#">
                        <cfinvokeargument name="tcValuacion"      	value="#LvarTCvaluacion#">
                        <cfinvokeargument name="Tipo_ES"       	  	value="#LvarTipoES#">
                        <cfinvokeargument name="Ocodigo" 	      	value="#rsInventario.Ocodigo#"/>							
                        <cfinvokeargument name="Documento" 	      	value="#LvarEDdocumento#"/>							
                        <cfinvokeargument name="FechaDoc" 	      	value="#LvarEDtipocambioFecha#"/>							
                        <cfinvokeargument name="Referencia" 	  	value="CxP"/>							
                        <cfinvokeargument name="insertarEnKardex" 	value="#LvarinsKardex#"/>							
                        <cfinvokeargument name="Conexion"         	value="#Arguments.Conexion#">
                        <cfinvokeargument name="TransaccionActiva"	value="true">
                        <cfinvokeargument name="FPAEid"         	value="#LvarFPAEid#">
                        <cfinvokeargument name="CFComplemento"		value="#rsInventario.CFComplemento#">	
                        <cfinvokeargument name="DSlinea"	 		value="#rsInventario.DSlinea#">
                        <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->					
                    </cfinvoke>	
                </cfloop>
            </cfif>

			<!--- BALANCEO MONEDA OFICINA.  Verifica que el Asiento esté Balanceado en Moneda Local --->
			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 100
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="La cuenta de Ajuste por Redondeo de Monedas no esta Definida. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# 
					( 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						INTTIP, INTDES, 
						<!---CFcuenta,---> 
						Ccuenta, 
						Mcodigo, INTMOE, INTCAM, INTMON
					)
				select 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						case 
							when INTTIP = 'D' 
								then case when INTMON > INTMON2 then 'C' else 'D' end
								else case when INTMON < INTMON2 then 'C' else 'D' end
						end, 
						'Ajuste Redondeo', 
						<!---null, --->
						#LvarCtaBalanceMoneda#, 
						i.Mcodigo, 0, 0, 
						abs(INTMON - INTMON2)
				  from #INTARC# i
				 where INTMON2 IS NOT NULL
				   and INTMON <> INTMON2
			</cfquery>

			<cfquery name="rsVerifica" datasource="#Arguments.Conexion#">
				select 	
					sum(case when INTTIP = 'D' then INTMON else -INTMON end) as Diferencia, 
					sum(0.05) as Permitido, 
					sum(case when INTTIP = 'D' then INTMON end) as Debitos, 
					sum(case when INTTIP = 'C' then INTMON end) as Creditos,
					count(1) as Cantidad
				  from #INTARC#
			</cfquery>

			<cfif rsVerifica.recordcount EQ 0 or rsVerifica.Cantidad EQ 0 or rsVerifica.Permitido LT 0.05>
				<cf_errorCode	code = "51158" msg = "El Asiento Generado está vacio. Proceso Cancelado">
			</cfif>

			<cfset LvarDiferencia = rsVerifica.Diferencia>
			<cfset LvarPermitido  = rsVerifica.Permitido>
			
			<cfif rsVerifica.Diferencia LT 0>
				<cfset LvarDiferencia = LvarDiferencia * -1.00>
			</cfif>

			<cfif LvarDiferencia GT LvarPermitido>
				<font color="##FF0000" style="font-size:18px">
					<cfoutput>
					El Asiento Generado no está balanceado en Moneda Local. <BR>Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!
					</cfoutput>
					<BR><BR><BR>
				</font>

				<!--- Pinta el Asiento Contable --->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="PintaAsiento">
					<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
					<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
					<cfinvokeargument name="Efecha"			value="#LvarFechaDoc#"/>
					<cfinvokeargument name="Oorigen"		value="CPFC"/>
					<cfinvokeargument name="Edocbase"		value="#LvarEDdocumento#"/>
					<cfinvokeargument name="Ereferencia"	value="#LvarCPTcodigo#"/>						
					<cfinvokeargument name="Edescripcion"	value="Documento de CxP: #LvarEDdocumento#"/>
				</cfinvoke>

				<cftransaction action="rollback" />
				<cf_abort errorInterfaz="El Asiento Generado no está balanceado en Moneda Local. Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!">
			</cfif>

			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 200
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="No esta definida la Cuenta Balance Multimoneda. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC#
					( 
						Ocodigo, Mcodigo, INTCAM, 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, 
						INTTIP, INTDES, 
						<!---CFcuenta, --->
						Ccuenta, 
						INTMOE, INTMON
					)
				select 
						Ocodigo, i.Mcodigo, round(INTCAM,10), 
						min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
						min(INTFEC), min(Periodo), min(Mes), 
						'D', 'Balance entre Monedas', 
						<!---null, --->
						#LvarCtaBalanceMoneda#, 
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
	</cffunction>
	
	<cffunction name="Contabiliza" access = "private" output= "no">
		<cfargument name="IDdoc"      type="numeric" required="true">
		<cfargument name="Ecodigo"    type="numeric" required="true">
		<cfargument name="Edocumento" type="string"  required="yes">
		<cfargument name="CPTcodigo"  type="string"  required="yes">
		<cfargument name="NAP"		  type="numeric"  required="yes">
		<cfargument name="CPNAPIid"	  type="numeric"  required="yes">
		<cfargument name="Conexion"	  type="string"  required="yes">
        <cfargument name='EntradasEnRecepcion' type="boolean" 	required='false' default='false' hint="false=Hace la entrada de una vez, true=Hace la entrada en la recepcion de Mecaderia"> 
        
        <!---►►Realizar adquisición de activos fijos, posterior a la aplición de facturas◄◄--->
        <cfquery name="RsPostergarAdquisicion" datasource="#Arguments.Conexion#">
        	select Coalesce(Pvalor,'0') Pvalor from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 15600
        </cfquery>
        <cfif RsPostergarAdquisicion.RecordCount AND RsPostergarAdquisicion.Pvalor EQ 1>
        	<cfset LvarGenerarAdquisicion = FALSE>
        <cfelse>
        	<cfset LvarGenerarAdquisicion = TRUE>
        </cfif>
        
		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#LvarFechaDoc#"/>
			<cfinvokeargument name="Oorigen"		value="CPFC"/>
			<cfinvokeargument name="Edocbase"		value="#LvarEDdocumento#"/>
			<cfinvokeargument name="Ereferencia"	value="#LvarCPTcodigo#"/>						
			<cfinvokeargument name="Edescripcion"	value="Documento de CxP: #LvarEDdocumento#"/>
			<cfinvokeargument name="Ocodigo"		value="#LvarOcodigoDoc#"/>						

			<cfinvokeargument name="NAP"			value="#Arguments.NAP#"/>						
			<cfinvokeargument name="CPNAPIid"		value="#Arguments.CPNAPIid#"/>						
			<cfinvokeargument name="PintaAsiento"	value="#LvarPintar#"/>						
		</cfinvoke>

		<!--- Llenar las estructuras de datos de documentos aplicados de CxP --->
		<cfquery name="PorInsertEDocCP" datasource="#Arguments.Conexion#">
			select 
				Ecodigo,CPTcodigo,EDdocumento,SNcodigo,Mcodigo,Ocodigo,EDtipocambio,EDtotal,EDtotal,EDfecha,EDvencimiento,
				Ccuenta,EDtipocambio,EDusuario,	Rcodigo,CFid,Icodigo,TESRPTCid,TESRPTCietu,id_direccion,EDfechaarribo,folio
			from EDocumentosCxP
			where IDdocumento = #Arguments.IDdoc#
		</cfquery>		
		<cfif len(trim(#PorInsertEDocCP.EDfechaarribo#))>
			<cfset EDvencimientoADD = dateadd('d',#LvarVencimiento#,'#PorInsertEDocCP.EDfechaarribo#')>
		<cfelse>
			<cfset EDvencimientoADD = dateadd('d',#LvarVencimiento#,'#PorInsertEDocCP.EDfecha#')>
		</cfif>
		
		<cfquery name="rsInsertEDocCP" datasource="#Arguments.Conexion#">
			insert into EDocumentosCP (
				Ecodigo,			
				CPTcodigo,			
				Ddocumento,
				SNcodigo,			
				Mcodigo,			
				Ocodigo,
				Dtipocambio,		
				Dtotal,				
				EDsaldo,
				Ccuenta,			
				EDtcultrev,			
				EDusuario,		
				EDtref,				
				EDdocref,	  		
				TESRPTCid,		
				TESRPTCietu,		
				EDtipocambioVal,	
				NAP,		    
				Dfecha,	            
				EDtipocambioFecha,	
				EDmontoretori, 
				Dfechavenc,	
				Dfechaarribo
				<cfif len(trim(#PorInsertEDocCP.Rcodigo#))>,Rcodigo</cfif>		
				<cfif len(trim(#PorInsertEDocCP.Icodigo#))>,Icodigo</cfif>	
				<cfif len(trim(#PorInsertEDocCP.CFid#))>,CFid</cfif>
				<cfif len(trim(#PorInsertEDocCP.id_direccion#))>,id_direccion</cfif>
				,folio
				)
			values(
				#PorInsertEDocCP.Ecodigo#,		
				'#PorInsertEDocCP.CPTcodigo#',		
				'#PorInsertEDocCP.EDdocumento#',		
				#PorInsertEDocCP.SNcodigo#,		 
				#PorInsertEDocCP.Mcodigo#,		 	 
				#PorInsertEDocCP.Ocodigo#,		
				#PorInsertEDocCP.EDtipocambio#,	 
				#PorInsertEDocCP.EDtotal#,		 	 
				#PorInsertEDocCP.EDtotal#,	
				#PorInsertEDocCP.Ccuenta#,		 
				#PorInsertEDocCP.EDtipocambio#,	
				'#PorInsertEDocCP.EDusuario#',		
				<cfif isdefined("LvarEDTref") and len(trim(LvarEDTref)) gt 0>
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarEDTref#">,
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
				</cfif>
				<cfif isdefined("LvarEDdocref") and len(trim(LvarEDdocref)) gt 0>
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarEDdocref#">,
				<cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
				</cfif>
				<cfif isdefined("PorInsertEDocCP.TESRPTCid") and len(trim(PorInsertEDocCP.TESRPTCid)) gt 0> 
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#PorInsertEDocCP.TESRPTCid#">,	     
                 <cfelse>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				</cfif>
			    #PorInsertEDocCP.TESRPTCietu#,   
				 #LvarTCvaluacion#,  			     
				 #Arguments.NAP#,                   
			    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#PorInsertEDocCP.EDfecha#">,
				 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarEDtipocambioFecha#">,       
				 round(#LvarAplicarRetencion#*#LvarRetencion#/100,2)
				<cfif len(trim(#PorInsertEDocCP.EDvencimiento#))>,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#PorInsertEDocCP.EDvencimiento#"><cfelse>,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#EDvencimientoADD#">
				</cfif>
				<cfif len(trim(#PorInsertEDocCP.EDfechaarribo#))>,<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#PorInsertEDocCP.EDfechaarribo#"><cfelse>,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#PorInsertEDocCP.EDfecha#"></cfif>
				<cfif len(trim(#PorInsertEDocCP.Rcodigo#))>,'#PorInsertEDocCP.Rcodigo#'</cfif>
				<cfif len(trim(#PorInsertEDocCP.Icodigo#))>,'#PorInsertEDocCP.Icodigo#'</cfif>  
				<cfif len(trim(#PorInsertEDocCP.CFid#))>,#PorInsertEDocCP.CFid#</cfif>
				<cfif len(trim(#PorInsertEDocCP.id_direccion#))>,#PorInsertEDocCP.id_direccion#</cfif>
				
				<cfif isdefined("PorInsertEDocCP.folio") and len(trim(PorInsertEDocCP.folio)) gt 0>
					 ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#PorInsertEDocCP.folio#">
				<cfelse>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertEDocCP"  verificar_transaccion="no">
		
		<cfif isdefined("rsInsertEDocCP.identity")>
			<cfset LvarLlave = rsInsertEDocCP.identity>
		<cfelse>
			<cf_errorCode	code = "51159" msg = "Error al insertar el Documento en Cuentas x Pagar! (Tabla: EDocumentosCP) Proceso Cancelado!">
		</cfif>	
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into HEDocumentosCP (
				IDdocumento,	Ecodigo, 		CPTcodigo, 		Ddocumento, 		SNcodigo, 
				Mcodigo, 		Ocodigo,		Dtipocambio, 		Dtotal,		EDsaldo,
				Dfecha,			Dfechavenc,		Dfechaarribo,		Ccuenta,		EDtcultrev,
				EDusuario,		Rcodigo,		EDmontoretori,		EDtref,		EDdocref,
				Icodigo,		TESRPTCid,TESRPTCietu,		CFid,
				EDtipocambioFecha, EDtipocambioVal, id_direccion, NAP
				,EDdescuento, EDperiodo, EDmes, IDcontable, EDfechaaplica
			)
			select
				IDdocumento,	Ecodigo, 		CPTcodigo, 		Ddocumento, 		SNcodigo, 
				Mcodigo, 		Ocodigo,		Dtipocambio, 		Dtotal,		EDsaldo,
				Dfecha, 		Dfechavenc,		Dfechaarribo,		Ccuenta,		EDtcultrev,
				EDusuario,		Rcodigo,		EDmontoretori,		EDtref,		EDdocref,
				Icodigo,		TESRPTCid,TESRPTCietu,		CFid,
				EDtipocambioFecha, EDtipocambioVal, id_direccion, NAP
				,#LvarDescuentoDoc#, #LvarAnoAux#, #LvarMesAux#, #LvarIDcontable#, #LvarHoy#
			from EDocumentosCP
			where IDdocumento = #LvarLlave#
		</cfquery>		
        <cfquery name="validaImpuesto" datasource="#Arguments.Conexion#">
        	select count(1) cantidad
			  from EDocumentosCxP a
				inner join DDocumentosCxP b
                	on b.IDdocumento = a.IDdocumento
			where a.IDdocumento = #Arguments.IDdoc#
               and (select count(1) from Impuestos where Ecodigo = a.Ecodigo and Icodigo = b.Icodigo) = 0
        </cfquery>
        <cfif validaImpuesto.cantidad>
        	<cfthrow message="Existen lineas de la Factura con Impuestos Incorrectos">
        </cfif>

		<cfquery datasource="#Arguments.Conexion#">
			insert into DDocumentosCP (
				IDdocumento,	Ecodigo,		Dcodigo, 		CPTcodigo, 		Ddocumento, 
				SNcodigo, 		DDtransref,		DDdocref,		DDcoditem,
				Aid,			DDtipo,			DDcantidad,		DDpreciou, 		DDtotallin, 		DDescripcion,
				DDdescalterna,		
				DDdesclinea,	Ccuenta, 		CFcuenta, 		Icodigo,		CFid, 			DOlinea,
				OCTid, OCid, OCCid, DDid
				,ContractNo, 
				PCGDid,
				FPAEid,
				CFComplemento,
				OBOid
				)
			select
				#LvarLlave#,	a.Ecodigo,		b.Dcodigo, 			a.CPTcodigo,		a.EDdocumento,
				a.SNcodigo,		a.CPTcodigo,	a.EDdocumento,		case when b.Aid is null then b.Cid else b.Aid end,
				b.Alm_Aid,		b.DDtipo,		b.DDcantidad,		b.DDpreciou, 		b.DDtotallinea, 	b.DDdescripcion,
				coalesce(b.DDdescalterna, b.DDdescripcion),
				b.DDdesclinea,	b.Ccuenta,		b.CFcuenta,		b.Icodigo,			b.CFid, 		b.DOlinea,
				oct.OCTid, b.OCid, b.OCCid, b.Linea
				,b.ContractNo,				
				b.PCGDid,
				b.FPAEid,
				b.CFComplemento,
				b.OBOid
			from EDocumentosCxP a
				inner join DDocumentosCxP b
						left join OCtransporte oct
							 on oct.Ecodigo		= b.Ecodigo
							and oct.OCTtipo		= b.OCTtipo
							and oct.OCTtransporte	= b.OCTtransporte
					on b.IDdocumento = a.IDdocumento
			where a.IDdocumento = #Arguments.IDdoc#
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into HDDocumentosCP (
				IDdocumento,	Ecodigo,		Dcodigo, 		CPTcodigo, 		Ddocumento, 
				SNcodigo, 		DDtransref,		DDdocref,		DDcoditem,		
				Aid,			DDtipo,			DDcantidad,		DDpreciou, 		DDtotallin, 		DDescripcion,
				DDdescalterna,
				DDdesclinea,	Ccuenta, 		CFcuenta,		Icodigo,		CFid, 			DOlinea,
				OCTid, OCid, OCCid, DDid,
				ContractNo,
				DDimpuestoCosto, DDimpuestoCF, DDdescdoc
				)
			select
				d.IDdocumento,	Ecodigo,		Dcodigo, 		CPTcodigo, 		Ddocumento, 
				SNcodigo, 		DDtransref,		DDdocref,		DDcoditem,
				Aid,			DDtipo,			DDcantidad,		DDpreciou, 		DDtotallin, 		DDescripcion,
				DDdescalterna,
				DDdesclinea,	Ccuenta, 		CFcuenta, 		Icodigo,		CFid, 			DOlinea,
				OCTid, OCid, OCCid, DDid
				,ContractNo
				,co.impuestoCosto, co.impuestoCF, co.descuentoDoc
			 from DDocumentosCP d
                inner join #CP_calculoLin# co
                     on co.linea		= d.DDid
			where d.IDdocumento = #LvarLlave#
		</cfquery>
		
		<cfquery datasource="#session.dsn#">
			update TESOPformaPago
			   set TESOPFPid 	 = #LvarLlave#
			 where TESOPFPtipoId = 4
			   and TESOPFPid 	 = #Arguments.IDdoc#
		</cfquery>

		<cfquery name="rsfolio" datasource="#Session.DSN#">
			select folio as folio
			from EDocumentosCP
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and IDdocumento =  #LvarLlave#			  
		</cfquery>
		
		
		<cfif isDefined("rsfolio.folio") and Len(Trim(rsfolio.folio)) GT 0 > 
		<cfquery datasource="#session.DSN#">
			update HEDocumentosCP
			set folio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsfolio.folio#">		
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and IDdocumento =  #LvarLlave#			  
		</cfquery>
		</cfif>

		<cfquery name="rsEstado" datasource="#session.dsn#">
			select  FTidEstado 
			from EstadoFact 
			where FTcodigo = '4' <!---Aplicada--->
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update HEDocumentosCP
			set EVestado = #rsEstado.FTidEstado#	
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and IDdocumento =  #LvarLlave#			  
		</cfquery>

		<!---
			/*************************************************************************************/
			/* Inserta en la tabla ImpDocumentosCxP                                              */
			/* todos los impuestos con credito fiscal                                            */
			/* Se verifica que un impuesto en diferentes grupos tenga la misma cuenta financiera */
			/*************************************************************************************/
		--->

		<!--- Verifica que un impuesto en diferentes grupos tenga la misma cuenta financiera --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select dicodigo, count(1) as cantidad
			  from 
			  	(
					select distinct dicodigo, ccuenta
					  from #CP_impLinea# 
					 where creditofiscal = 1
				) IL
			 group by dicodigo
			 having count(1) > 1
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarDIcodigo = rsSQL.dicodigo>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select distinct icodigo
				  from #CP_impLinea# 
				 where creditofiscal = 1
				   and dicodigo = '#LvarDIcodigo#'
			</cfquery>
			<cf_errorCode	code = "51160"
							msg  = "El impuesto con crédito fiscal '@errorDat_1@' debe tener definida la misma Cuenta Financiera en los siguientes grupos de impuestos: @errorDat_2@"
							errorDat_1="#LvarDIcodigo#"
							errorDat_2="#QuotedValueList(rsSQL.icodigo)#"
			>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into ImpDocumentosCxP (
				IDdocumento, Ecodigo, Periodo, Mes,
				TotalFac,
				SubTotalFac,

				Icodigo,
				CcuentaImp,
				MontoCalculado,
				MontoBaseCalc,
				MontoPagado,
				Iporcentaje
			)
			select #LvarLlave#, #Arguments.Ecodigo#, #LvarAnoAux#, #LvarMesAux#,
				   #LvartotalDoc#		as TotalFac,
				   #LvarSubtotalDoc#	as SubTotalFac,

				   dicodigo,
				   min(ccuenta),
				   sum(impuesto)		as MontoCalculado,
				   sum(montoBase) 		as MontoBaseCalc,
				   0					as MontoPagado,
				   avg(porcentaje)
			  from #CP_impLinea# 
			 where creditofiscal = 1
			 group by dicodigo
		</cfquery>

		<!--- 
			Actualiza la cantidad surtida del detalle de la línea de la orden de compra (maximo la cantidad original de la orden de compra).
			Actualiza la cantidad que se recibió de más (en exceso a la cantidad original de la orden de compra).
		--->

		<cfquery name="rsOrdenes" datasource="#Arguments.Conexion#">
			select cp.DOlinea, min(cpt.CPTtipo) as CPTtipo, sum(cp.DDcantidad) as Cantidad, sum(cp.DDtotallinea) as  DDtotallinea
			from DDocumentosCxP cp
				inner join EDocumentosCxP cpe
					on cpe.IDdocumento = cp.IDdocumento
				inner join CPTransacciones cpt
					 on cpt.Ecodigo	  = cpe.Ecodigo
					and cpt.CPTcodigo = cpe.CPTcodigo
			where cp.IDdocumento = #Arguments.IDdoc#
			  and cp.DOlinea is not null
			group by DOlinea
		</cfquery>
		<cfif rsOrdenes.recordcount gt 0>
		<cfloop query="rsOrdenes">
			<cfset LvarDOlinea      = rsOrdenes.DOlinea>
			<cfset LvarCantidadDoc  = rsOrdenes.Cantidad>
			<cfset LvarDDtotallinea = rsOrdenes.DDtotallinea>
			<cfset LvarEsPositivo   = rsOrdenes.CPTtipo EQ "C">

			<!--- DDtotallinea = PrecioUnitario * Cantidad - DescuentoLinea --->
			<cfquery datasource="#Arguments.Conexion#">
				update DOrdenCM
				set 
				<cfif LvarEsPositivo>
					<!--- Documento de Credito (positivo): Factura, ND, etc. --->
					DOcantsurtida = 
							case when DOcontrolCantidad = 1
								then
									case 
										when (DOrdenCM.DOcantsurtida + #LvarCantidadDoc#) >= DOrdenCM.DOcantidad 
											then DOrdenCM.DOcantidad 
											else DOrdenCM.DOcantsurtida + #LvarCantidadDoc#
									end
								else
									  case when coalesce(DOmontoSurtido,0) + #LvarDDtotallinea# >= DOtotal - DOmontodesc then 1 else 0 end
								end
					, DOcantexceso =
							case when DOcontrolCantidad = 1
								then 
									case 
										when (DOrdenCM.DOcantsurtida + #LvarCantidadDoc#) >= DOrdenCM.DOcantidad 
											then DOrdenCM.DOcantsurtida + #LvarCantidadDoc# - DOrdenCM.DOcantidad
											else 0
									end
								else
									0
								end
					 , DOmontoSurtido = coalesce(DOmontoSurtido,0) + #LvarDDtotallinea#
				<cfelse>
					<!--- Documento de Débito (negativo): NC, devolución, etc. --->
					DOcantsurtida = 
							case when DOcontrolCantidad = 1
								then
									case 
										when (DOrdenCM.DOcantsurtida + DOrdenCM.DOcantexceso - #LvarCantidadDoc#) < 0
											then 0
										when (DOrdenCM.DOcantsurtida + DOrdenCM.DOcantexceso - #LvarCantidadDoc#) >= DOrdenCM.DOcantidad 
											then DOrdenCM.DOcantidad 
											else DOrdenCM.DOcantsurtida + DOrdenCM.DOcantexceso - #LvarCantidadDoc#
									end
								else
									  case when coalesce(DOmontoSurtido,0) - #LvarDDtotallinea# >= DOtotal - DOmontodesc then 1 else 0 end
								end
					, DOcantexceso =
							case when DOcontrolCantidad = 1
								then 
									case 
										when (DOrdenCM.DOcantsurtida + DOrdenCM.DOcantexceso - #LvarCantidadDoc#) >= DOrdenCM.DOcantidad 
											then DOrdenCM.DOcantexceso - #LvarCantidadDoc#
											else 0
									end
								else
									0
								end
					 , DOmontoSurtido = 
							case when coalesce(DOmontoSurtido,0) - #LvarDDtotallinea# > 0
								then coalesce(DOmontoSurtido,0) - #LvarDDtotallinea#
								else 0
							end
				</cfif>
			where DOrdenCM.DOlinea = #LvarDOlinea#
			</cfquery>
		</cfloop>
		</cfif>			
		<!--- 6 Insertar en el Histórico de CxP  --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into BMovimientosCxP (
				Ecodigo, CPTcodigo, Ddocumento, CPTRcodigo, DRdocumento, 
				BMfecha, 
				Ccuenta, Ocodigo, SNcodigo, Mcodigo, Dtipocambio, 
				Dtotal, Dfecha, Dvencimiento, IDcontable, 
				BMperiodo, BMmes, 
				EDtcultrev, BMusuario, Rcodigo, BMmontoretori, 
				BMtref, BMdocref, Icodigo,CFid)
			select 
				cp.Ecodigo, cp.CPTcodigo, cp.Ddocumento, cp.CPTcodigo, cp.Ddocumento, 
				<cf_dbfunction name="now">,
				cp.Ccuenta, cp.Ocodigo, cp.SNcodigo, cp.Mcodigo, cp.Dtipocambio, 
				cp.Dtotal, cp.Dfechaarribo, cp.Dfechavenc, #LvarIDcontable#, 
				#LvarAnoAux#, #LvarMesAux#, 
				Dtipocambio, EDusuario, Rcodigo, EDmontoretori, 
				EDtref, EDdocref, Icodigo, CFid
			from EDocumentosCP cp
			where IDdocumento = #LvarLlave#
		</cfquery>

		<!---  6a.) Registrar los artículos en tránsito --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into Transito 
				(
					IDdocumento, DDlinea, Ecodigo, Dcodigo, 
					CPTcodigo, Ddocumento, SNcodigo, DDdocref, 
					Aid, Tcantidad, Trecibido, TcostoLinea,
					Mcodigo, Ttipocambio, TtipocambioVal,
					Tembarque, Tfecha, Tobservacion, Acodigo
				)
			select 
					#LvarLlave#, DDlinea, b.Ecodigo, Dcodigo, 
					CPTcodigo, Ddocumento, SNcodigo, DDdocref, 
					DDcoditem, DDcantidad, 0.00, co.costoLinea, 
					#LvarMcodigoDoc#, #LvarEDtipocambio#, #LvarTCvaluacion#,
					oct.OCTtransporte, oct.OCTfechaPartida, oct.OCTobservaciones, (( select min(art.Acodigo) from Articulos art where art.Aid = b.Aid )) 
			from DDocumentosCP b
                inner join #CP_calculoLin# co
                     on co.linea		= b.DDid
				left join OCtransporte oct
				  on oct.OCTid = b.OCTid
			where b.Ecodigo = #Arguments.Ecodigo#
			  and b.IDdocumento = #LvarLlave#
			  and DDtipo = 'T'
		</cfquery>
	
    	<cfif NOT Arguments.EntradasEnRecepcion>
			<!--- Actualizar el IDcontable del Kardex generado en OC_transito ---> 
            <cfquery name="rsSQL" datasource="#session.dsn#"> 
                update Kardex 
                   set IDcontable = #LvarIDcontable#
                where Kid IN
                    (
                        select Kid
                           from #IDKARDEX#
                    )
            </cfquery> 
        	<cfif LvarGenerarAdquisicion>
                <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AF_AdquisicionActivos" returnvariable="rsFacturas">
                    <cfinvokeargument name="IDdocumento" 	value="#LvarLlave#">
                    <cfinvokeargument name="Ecodigo" 		value="#Session.Ecodigo#">
                    <cfinvokeargument name="Usucodigo"		value="#Session.Usucodigo#">
                    <cfinvokeargument name="Debug" 			value="false">
                </cfinvoke>
            </cfif>
       </cfif>

		<!--- 7) Eliminar el documento de las Tablas sin Postear --->
		<cfquery datasource="#Arguments.Conexion#">
			delete from DDocumentosCxP where IDdocumento = #Arguments.IDdoc#
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">			
			delete from EDocumentosCxP where IDdocumento = #Arguments.IDdoc#
		</cfquery>
	</cffunction>

	<cffunction name="CP_CalcularDocumento" output="no" returntype="boolean" access="public">
		<cfargument name="IDdoc"    			type="numeric" required="yes">
		<cfargument name="CalcularImpuestos"	type="boolean" required="yes">
		<cfargument name="Ecodigo"  			type="numeric" required="yes">
		<cfargument name="Conexion" 			type="string"  required="yes">
		
		<cfif not isdefined("LvarPcodigo420")>
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select Pvalor
                from Parametros
                where Ecodigo = #Arguments.Ecodigo# 
                  and Pcodigo = 420
            </cfquery>
            <cfset LvarPcodigo420 = rsSQL.Pvalor>
			<cfif LvarPcodigo420 EQ "">
                <cf_errorCode	code = "51155" msg = "No se ha definido el parámetro de Tipo de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
            </cfif>
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select  coalesce(a.EDdescuento, 0) as EDdescuento,
                        coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCxP
                                 where IDdocumento = a.IDdocumento
                            ) 
                        ,0.00) as SubTotal
                        ,coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCxP
								 inner join Impuestos i
								 	 on i.Ecodigo = DDocumentosCxP.Ecodigo
								 	and i.Icodigo = DDocumentosCxP.Icodigo
                                 where IDdocumento = a.IDdocumento
								   and i.InoRetencion = 0
								 
                            ) - a.EDdescuento
                        ,0.00) as AplicarRetencion
                         ,   (
                                select count(1)
                                  from DDocumentosCxP
                                 where IDdocumento = a.IDdocumento
                            ) as cantidad
                  from EDocumentosCxP a
                 where a.IDdocumento	= #Arguments.IDdoc#
            </cfquery>
			<cfset LvarLineas = rsSQL.Cantidad>
            <cfset LvarDescuentoDoc = rsSQL.EDdescuento>
            <cfset LvarSubTotalDoc = rsSQL.SubTotal>
            <cfset LvarAplicarRetencion = rsSQL.AplicarRetencion>
		</cfif>        

		<cfif LvarDescuentoDoc GT LvarSubTotalDoc>
        	<cf_errorCode	code = "51000" msg = "El descuento no puede ser mayor al subtotal">
        </cfif>

		<cfset CP_impLinea		= request.CP_impLinea>
		<cfset CP_calculoLin	= request.CP_calculoLin	>

		<cfif LvarLineas GT 0>
			<!--- Prorratear el Descuento a nivel de Documento --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CP_calculoLin# (
					iddocumento, linea, subtotalLinea, 
					descuentoDoc, 
					impuestoInterfaz, 
					impuestoCosto, impuestoCF, otrosCostos, costoLinea, totalLinea
				)
				select 
					IDdocumento, Linea, DDtotallinea, 
					<cfif LvarDescuentoDoc GT 0>round(DDtotallinea * #LvarDescuentoDoc / LvarSubtotalDoc#,2)<cfelse>0</cfif>, 
					DDimpuestoInterfaz,
					0, 0, 0, 0, 0
				from DDocumentosCxP d
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>		
	
			<!--- Ajuste de redondeo por Prorrateo del Descuento --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select sum(descuentoDoc) as descuentoDoc
				  from #CP_calculoLin#
			</cfquery>
			<cfset LvarAjuste = LvarDescuentoDoc - rsSQL.descuentoDoc>
			<cfif LvarAjuste NEQ 0>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select max(descuentoDoc) as mayor
					  from #CP_calculoLin#
				</cfquery>
				<cfif rsSQL.mayor LT -(LvarAjuste)>
					<cf_errorCode	code = "51001" msg = "No se puede prorratear el descuento a nivel de documento">
				</cfif>
	
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select min(linea) as linea
					  from #CP_calculoLin#
					 where descuentoDoc = 
							(
								select max(descuentoDoc)
								  from #CP_calculoLin#
							)
				</cfquery>
	
				<cfquery datasource="#Arguments.Conexion#">
					update #CP_calculoLin#
					   set descuentoDoc = descuentoDoc + #LvarAjuste#
					 where linea = #rsSQL.linea#
				</cfquery>
			</cfif>
			<!---Valida que la cuenta del Impuesto Simple Exista--->
			<cfquery name="ImpSimple" datasource="#Arguments.Conexion#">
				select 
					i.Ccuenta, i.Idescripcion
				from DDocumentosCxP d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>
			<cfif isdefined('ImpSimple') and ImpSimple.recordcount GT 0 and len(ImpSimple.Ccuenta) EQ 0>
				<cf_errorCode	code = "51161"
								msg  = "El impuesto Simple '@errorDat_1@' no tienen definida la Cuenta Contable, Proceso Cancelado!!"
								errorDat_1="#ImpSimple.Idescripcion#"
				>
			</cfif>
			
			<!--- Obtiene los Impuestos Simples --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CP_impLinea# (
					iddocumento, linea, ecodigo,   icodigo,  dicodigo,		descripcion,    ccuenta,		CFcuenta, 		montoBase,
					porcentaje,  creditofiscal, impuesto, icompuesto)
				select 
					IDdocumento, Linea, d.Ecodigo, i.Icodigo, i.Icodigo, 	i.Idescripcion, i.Ccuenta, 		i.CFcuenta, 	DDtotallinea,
					Iporcentaje, Icreditofiscal, 0.00,     0
				from DDocumentosCxP d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>	
				
			<!---Valida que la cuenta del Impuesto Compuesto Exista--->
			<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			<cfquery name="ImpCompuesto" datasource="#Arguments.Conexion#">
				select 
					di.Ccuenta, i.Idescripcion #_Cat# ':' #_Cat# di.DIdescripcion as Idescripcion
				from DDocumentosCxP d
					inner join Impuestos  i
						inner join DImpuestos di
						on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 1
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>
			
			<cfif isdefined('ImpCompuesto') and ImpCompuesto.recordcount GT 0 and len(ImpCompuesto.Ccuenta) EQ 0>
				<cf_errorCode	code = "51162"
								msg  = "El impuesto Compuesto '@errorDat_1@' no tienen definida la Cuenta Contable, Proceso Cancelado!!"
								errorDat_1="#ImpCompuesto.Idescripcion#"
				>
			</cfif>
			<!--- Obtiene los Impuestos Compuestos --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CP_impLinea# (
					iddocumento, linea, ecodigo,	icodigo, 	dicodigo,		descripcion,      ccuenta,		CFcuenta, 		montoBase,
					porcentaje,    		creditofiscal, 		impuesto, icompuesto)
				select 
					IDdocumento, Linea, d.Ecodigo, 	di.Icodigo, di.DIcodigo, 	di.DIdescripcion, di.Ccuenta,	di.CFcuenta,	DDtotallinea,
					di.DIporcentaje,	DIcreditofiscal, 	0.00,     1
				from DDocumentosCxP d
					inner join Impuestos  i
						inner join DImpuestos di
						on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 1
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>
	
			<!--- Parametro 420: Manejo del DescuentoDoc para el Calculo de Impuesto 0=(totalLineas-descuentoDoc)*Iporcentaje, 1=totalLinea*Iporcentaje --->
			<cfif LvarPcodigo420 EQ "0" and LvarDescuentoDoc GT 0>
				<!--- Disminuye el monto Base para Impuestos con el DescuentoDocumento --->
				<cfquery datasource="#Arguments.Conexion#">
					update #CP_impLinea#
					set montoBase = montoBase-
							(
								select descuentoDoc
								  from #CP_calculoLin#
								 where iddocumento	= #CP_impLinea#.iddocumento
								   and linea		= #CP_impLinea#.linea
							)
				</cfquery>
			</cfif>
			
			<!--- Cálculo del Impuesto --->
			<cfquery datasource="#Arguments.Conexion#">
				update #CP_impLinea#
				   set impuesto6Decs	= montoBase * coalesce(porcentaje, 0) / 100.00
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update #CP_impLinea#
				   set impuesto			= round(impuesto6Decs, 2)
			</cfquery>

			<cfquery name="rsAjuste" datasource="#Arguments.Conexion#">
				select iddocumento, dicodigo, sum(impuesto) - sum(impuesto6Decs) as ajusteImpuesto, max(impuesto) as mayor
				  from #CP_impLinea#
				 group by iddocumento, dicodigo
				having sum(impuesto) - sum(impuesto6Decs) <> 0
			</cfquery>
			<cfloop query="rsAjuste">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select min(linea) as linea
					  from #CP_impLinea#
					 where iddocumento	= #rsAjuste.iddocumento#
					   and dicodigo		= '#rsAjuste.dicodigo#'
					   and impuesto		= #rsAjuste.mayor#
				</cfquery>
                <cfif rsSQL.RecordCount>
                    <cfquery datasource="#Arguments.Conexion#">
                        update #CP_impLinea#
                           set impuesto		= round(impuesto - #rsAjuste.ajusteImpuesto#, 2)
                         where iddocumento	= #rsAjuste.iddocumento#
                           and linea		= #rsSQL.linea#
                    </cfquery>
                </cfif>
			</cfloop>
	
			<!--- Mantener el Impuesto que viene de Interfaz --->
			<cfif NOT Arguments.CalcularImpuestos>
				<!--- La diferencia entre el Impuesto que viene de Interfaz y el calculado no puede ser mayor que abs(1) --->
				<cfquery name="rsAjustar" datasource="#Arguments.Conexion#">
					select i.iddocumento, i.linea, sum(i.impuesto) as impuesto, min(c.impuestoInterfaz) as impuestoInterfaz, 
							abs(sum(i.impuesto) - min(c.impuestoInterfaz)) as dif
					  from #CP_impLinea# i
						inner join #CP_calculoLin# c
						   on c.iddocumento	= i.iddocumento
						  and c.linea		= i.linea
					group by i.iddocumento, i.linea
					  having abs(sum(i.impuesto) - min(c.impuestoInterfaz)) > 1
				</cfquery>
				<cfif rsAjustar.dif NEQ "">
					<cf_errorCode	code = "51002"
									msg  = "La diferencia entre el impuesto que viene de interfaz @errorDat_1@ y el impuesto real calculado @errorDat_2@ no es permitida porque es mayor que una unidad"
									errorDat_1="#numberformat(rsAjustar.impuestoInterfaz,",9.99")#"
									errorDat_2="#numberformat(rsAjustar.impuesto,",9.99")#"
					>
				</cfif>
	
				<!--- Los impuestos simples se actualizan con el impuesto de interfaz --->
				<cfquery datasource="#Arguments.Conexion#">
					update #CP_impLinea#
					   set impuesto = round(
									(
										select impuestoInterfaz
										  from #CP_calculoLin#
										 where iddocumento	= #CP_impLinea#.iddocumento
										   and linea		= #CP_impLinea#.linea
									)	
							   ,2)
					 where icompuesto = 0
						and
							(
								select count(1)
								  from #CP_calculoLin#
								 where iddocumento	= #CP_impLinea#.iddocumento
								   and linea		= #CP_impLinea#.linea
								   and impuestoInterfaz is not null
							)	> 0
				</cfquery>
	
				<!--- Los impuestos compuestos debe prorratear el impuesto de interfaz y realizar el Ajuste de redondeo por Prorrateado--->
				<cfquery datasource="#Arguments.Conexion#">
					 update #CP_impLinea#
						set impuesto = 
								round(
									impuesto
									/
									(
										select sum(impuesto)
										  from #CP_impLinea#
										 where iddocumento	= #CP_impLinea#.iddocumento
										   and linea		= #CP_impLinea#.linea
									)
									*
									(
										select impuestoInterfaz
										  from #CP_calculoLin#
										 where iddocumento	= #CP_impLinea#.iddocumento
										   and linea		= #CP_impLinea#.linea
									)
								, 2)
					  where	icompuesto = 1
						and
							(
								select count(1)
								  from #CP_calculoLin#
								 where iddocumento	= #CP_impLinea#.iddocumento
								   and linea		= #CP_impLinea#.linea
								   and impuestoInterfaz is not null
							)	> 0
				</cfquery>
	
				<cfquery name="rsAjustar" datasource="#Arguments.Conexion#">
					select i.iddocumento, i.linea, sum(i.impuesto) - min(c.impuestoInterfaz) as ajuste
					  from #CP_impLinea# i
						inner join #CP_calculoLin# c
						   on c.iddocumento	= c.iddocumento
						  and c.linea		= i.linea
					  where	icompuesto = 1
					group by i.iddocumento, i.linea
					  having sum(i.impuesto) - min(c.impuestoInterfaz) <> 0
				</cfquery>
				<cfloop query="rsAjustar">
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select max(impuesto) as mayor
						  from #CP_impLinea#
						 where iddocumento	= #rsAjustar.iddocumento#
						   and linea		= #rsAjustar.linea#
					</cfquery>
					<cfif rsSQL.mayor LT -(rsAjustar.ajuste)>
						<cf_errorCode	code = "51003" msg = "No se puede prorratear un impuesto compuesto">
					</cfif>
		
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select min(dicodigo) as DIcodigo
						  from #CP_impLinea#
						 where impuesto = 
								(
									select max(impuesto)
									  from #CP_impLinea#
										on iddocumento	= #CP_impLinea#.iddocumento
									   and linea		= #CP_impLinea#.linea
								)
						 where iddocumento	= #rsAjustar.iddocumento#
						   and linea		= #rsAjustar.linea#
					</cfquery>
		
					<cfquery datasource="#Arguments.Conexion#">
						update #CP_impLinea#
						   set impuesto = impuesto + #rsAjustar.ajuste#
						 where iddocumento	= #rsAjustar.iddocumento#
						   and linea		= #rsAjustar.linea#
						   and dicodigo		= '#rsSQL.DIcodigo#'
					</cfquery>
				</cfloop>
			</cfif>
			
			<!--- Calcular el Costo y el Total Neto de la Linea --->
			<cfquery datasource="#Arguments.Conexion#">
				update #CP_calculoLin#
				   set impuestoBase = 
							coalesce((
								select min(montoBase)
								  from #CP_impLinea#
								 where iddocumento	= #CP_calculoLin#.iddocumento
								   and linea		= #CP_calculoLin#.linea
							),0)
					 , impuestoCosto = 
							coalesce((
								select sum(impuesto)
								  from #CP_impLinea#
								 where iddocumento		= #CP_calculoLin#.iddocumento
								   and linea			= #CP_calculoLin#.linea
								   and creditofiscal	= 0
							),0)
					 , impuestoCF = 
							coalesce((
								select sum(impuesto)
								  from #CP_impLinea#
								 where iddocumento		= #CP_calculoLin#.iddocumento
								   and linea			= #CP_calculoLin#.linea
								   and creditofiscal	= 1
							),0)
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update #CP_calculoLin#
				   set costoLinea = subtotalLinea - descuentoDoc + impuestoCosto + otrosCostos
					 , totalLinea = subtotalLinea - descuentoDoc + impuestoCosto + otrosCostos + impuestoCF
			</cfquery>
	
			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select 
					sum(subtotalLinea) 				as subTotal, 
					sum(impuestoCosto + impuestoCF) as impuestos
				from #request.CP_calculoLin	#
			</cfquery>		
	
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxP
				   set EDtotal    = round(#rsSQL.subTotal# + #rsSQL.Impuestos# - EDdescuento,2)
				<cfif Arguments.CalcularImpuestos>
					 , EDimpuesto = round(#rsSQL.impuestos#,2)
				</cfif>
			   where IDdocumento = #Arguments.IDdoc#
				 and Ecodigo = #Session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxP
				   set EDtotal    = 0
					 , EDimpuesto = 0
			   where IDdocumento = #Arguments.IDdoc#
				 and Ecodigo = #Session.Ecodigo#
			</cfquery>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="MostrarAsiento" access="private" output="yes" hint="Mostar Asiento Desbalanceado">
		<cfargument name="rsAsientoF" type="query">
		
		<p>El Asiento Contable se encuenta desbalanceado.</p>
		<p>Lista de Movimientos</p>
		<table>
			<tr>
				<td>Cuenta</td>
				<td>Oficina</td>
				<td>Documento</td>
				<td>Referencia</td>
				<td>Descripcion</td>
				<td>Moneda</td>
				<td>Monto</td>
				<td>Local</td>
			</tr>
			<cfoutput query="rsAsientoF">
				<tr>
					<td>#rsAsiento.Cuenta#</td>
					<td>#rsAsiento.Oficina#</td>
					<td>#rsAsiento.INTDOC#</td>
					<td>#rsAsiento.INTREF#</td>
					<td>#rsAsiento.INTDES#</td>
					<td>#rsAsiento.Moneda#</td>
					<td align="right">#NumberFormat(rsAsiento.INTMOE, "9,00")#</td>
					<td align="right">#NumberFormat(rsAsiento.INTMON, "9,00")#</td>
				</tr>
			</cfoutput>
		</table>
	</cffunction>
</cfcomponent>

