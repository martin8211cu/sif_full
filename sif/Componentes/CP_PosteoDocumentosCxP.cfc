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
		<cfargument name='CalcularImpuestos' type="boolean" 	required='false' default='false'>

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
                            month(a.EDfecha) as monthFecha,
                            year(a.EDfecha) as yearFecha,
                            coalesce (a.EDtipocambioFecha, a.EDfecha) as EDtipocambioFecha,
                            coalesce (a.EDtipocambioVal, -1) as EDtipocambioVal,
                            case when b.CPTtipo = 'C' then 'E' else 'S' end as TipoES,
                            b.CPTafectacostoventas as afectacostoventas,
                            b.CPTtipo as CPTtipo,
                            a.EDtotal,
                            a.EDdescuento,
                            a.EDimpuesto,
                            coalesce(a.EDTiEPS,0) as EDTiEPS,
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
                    <cfset LvarIEPSDoc		    = rsDocumento.EDTiEPS>

					<cfset LvarDocref 			= rsDocumento.EDdocref>
					<cfset LvarEDTref = "">
					<cfset LvarEDdocref = "">

					<cfset LvarinsKardex = (rsDocumento.afectacostoventas EQ 0)>

					<cfif numberFormat(LvarImpuestoDoc,"9.99") GT numberFormat(LvarSubtotalDoc,"9.99")>
                    	<cf_errorCode	code = "80019"
                    					msg  = "La suma de los Impuestos es mayor que la cantidad del Subtotal: <BR> SubTotal: @errorDat_1@ <BR> EDimpuesto: @errorDat_2@ <BR>"
                    					errorDat_1="#LvarSubtotalDoc#"
                    					errorDat_2="#LvarImpuestoDoc#"
                    	>
                    </cfif>
					<cfif numberFormat(LvarTotalDoc,"9.99") NEQ numberFormat(LvarSubtotalDoc + LvarImpuestoDoc - LvarDescuentoDoc + LvarIEPSDoc,"9.99")>
                    	<cf_errorCode	code = "51156"
                    					msg  = "El TotalDocumento no corresponde a TotalLineas + Impuesto - DescuentoDoc + LvarIEPSDoc: <BR> @errorDat_1@ <> @errorDat_2@ + @errorDat_3@ - @errorDat_4@ + @errorDat_6@ (@errorDat_5@)"
                    					errorDat_1="#LvarTotalDoc#"
                    					errorDat_2="#LvarSubtotalDoc#"
                    					errorDat_3="#LvarImpuestoDoc#"
                    					errorDat_4="#LvarDescuentoDoc#"
                    					errorDat_6="#LvarIEPSDoc#"
                    					errorDat_5="#LvarSubtotalDoc+LvarImpuestoDoc-LvarDescuentoDoc + LvarIEPSDoc#"
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

	                <cfset CP_CalcularDocumento(Arguments.IDdoc, Arguments.CalcularImpuestos, Arguments.Ecodigo, Arguments.Conexion)>

                    <cfquery name="validaCE" datasource="#Arguments.Conexion#">
                    	select ERepositorio from Empresa where Ereferencia=#Arguments.Ecodigo#
                    </cfquery>
                    <cfquery name="validaCE" datasource="#Arguments.Conexion#">
                        select ERepositorio from Empresa where Ereferencia=#Arguments.Ecodigo#
                    </cfquery>
                    <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1>
                        <!--- Si existe configurado un Repositorio de CFDIs --->
                        <cfif isdefined("session.repoDsn") and session.repoDsn NEQ "">
                            <cfset LobjRepo = createObject( "component","home.Componentes.Repositorio")>
                            <cfset request.repodbname = LobjRepo.getnameDB(#session.Ecodigo#)>
                        <cfelse>
                            <cfset request.repodbname = "RepNoDef">
                        </cfif>
                    </cfif>
                   

                    <cfif isdefined("rsDocumento") and rsDocumento.EDfecha NEQ "" and ((rsDocumento.yearFecha*100) +rsDocumento.monthFecha)  gt ((LvarAnoAux*100)+ LvarMesAux)>
						<cfset LvarMesAux = rsDocumento.monthFecha>
						<cfset LvarAnoAux = rsDocumento.yearFecha>
					</cfif>
                    
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

		<cfquery datasource="#Arguments.Conexion#" name="rsDocEvento">
        	select Ecodigo, CPTcodigo, EDdocumento, SNcodigo
            from EDocumentosCxP
            where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
		<!--- Control de Eventos--->
        <cfinvoke component="sif.Componentes.CG_ControlEvento"
            method	 ="ValidaEvento"
            Origen	 ="CPFC"
            Transaccion="#rsDocEvento.CPTcodigo#"
            Conexion	="#Arguments.conexion#"
            Ecodigo		="#Arguments.Ecodigo#"
            returnvariable	= "varValidaEvento"/>
        <cfset varNumeroEvento = "">
        <cfif varValidaEvento GT 0>
            <cfinvoke component="sif.Componentes.CG_ControlEvento"
                method		= "CG_GeneraEvento"
                Origen		= "CPFC"
                Transaccion	= "#rsDocEvento.CPTcodigo#"
                Documento 	= "#rsDocEvento.EDdocumento#"
                SocioCodigo = "#rsDocEvento.SNcodigo#"
                Conexion	= "#Arguments.Conexion#"
                Ecodigo		= "#Arguments.Ecodigo#"
                returnvariable	= "arNumeroEvento"/>
            <cfif arNumeroEvento[3] EQ "">
            	<cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
            <cfset varNumeroEvento = arNumeroEvento[3]>
		</cfif>

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

		<cfset MovimientosContables (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, Arguments.Conexion, Arguments.EntradasEnRecepcion,varNumeroEvento)>
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

<!--- JMRV inicio --->

<cfquery name="CuentasParaArticulos" datasource="#Arguments.Conexion#">
	select cxp.CFid, cxp.Aid, cxp.DDtipo, i.LIN_IDREF
	from #INTARC# i
		inner join DDocumentosCxP cxp
		on cxp.Linea = i.LIN_IDREF
		and i.LIN_IDREF is not null
		and not (ltrim(rtrim(i.INTREF)) like 'LINIMP%')
			inner join Articulos art
			on cxp.Aid = art.Aid
				inner join Clasificaciones clas
				on clas.Ccodigo = art.Ccodigo
	where i.DOlinea is null
	and cxp.DDtipo = 'A'
	and (cxp.CPDCid is null or cxp.CPDCid <= 0)
</cfquery>


<!--- Tabla Temporal para los CFcuenta de los articulos --->
<cf_dbtemp name="ArticulosCFcuenta" returnvariable="TablaArticulosCFcuenta" datasource="#Arguments.Conexion#">
	<cf_dbtempcol name="Ecodigo" 		type="integer" 		mandatory="yes">
	<cf_dbtempcol name="LIN_IDREF" 		type="numeric" 	    mandatory="yes">
	<cf_dbtempcol name="CFcuenta" 		type="numeric"		mandatory="yes">
</cf_dbtemp>

<cfif isdefined("CuentasParaArticulos") and CuentasParaArticulos.recordCount neq 0>

	<cfloop query="CuentasParaArticulos">
					<!--- Obtiene la cuenta fnComplementoItem(Ecodigo, CFid, SNid, tipoItem, Aid, Cid, ACcodigo, ACid)--->
					<cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
				      	<cfinvokeargument name="Ecodigo" 	value="#Session.Ecodigo#">
						<cfinvokeargument name="CFid" 		value="#CuentasParaArticulos.CFid#">
						<cfinvokeargument name="SNid" 		value= "-1">
						<cfinvokeargument name="tipoItem" 	value="#CuentasParaArticulos.DDtipo#">
						<cfinvokeargument name="Aid"		value="#CuentasParaArticulos.Aid#">
						<cfinvokeargument name="Cid"		value="">
						<cfinvokeargument name="ACcodigo"	value="">
						<cfinvokeargument name="ACid"		value="">
			        </cfinvoke>

					<!--- Revisa la cuenta financiera --->
			        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="Lvar_MsgError">
	       				<cfinvokeargument name="Lprm_CFformato" value="#LvarCFformato#"/>
	                   	<cfinvokeargument name="Lprm_fecha" value="#LvarFechaDoc#"/>
	                   	<cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
	                   	<cfinvokeargument name="Lprm_NoCrear" value="false"/>
	                   	<cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
	                   	<cfinvokeargument name="Lprm_debug" value="false"/>
	                   	<cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
	                   	<cfinvokeargument name="Lprm_DSN" value="#Session.DSN#">
               		</cfinvoke>

				<cfif Lvar_MsgError EQ "NEW" or Lvar_MsgError eq "OLD">

					<!--- trae el id de la cuenta financiera --->
					<cfquery name="rsTraeCuentaAnticipo" datasource="#Arguments.Conexion#">
						select CFcuenta
						from CFinanciera a
                              	inner join CPVigencia b
                               	on b.CPVid = a.CPVid
						where a.Ecodigo   = #session.Ecodigo#
						  and a.CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCFformato#">
					</cfquery>

					<cfquery datasource="#Arguments.Conexion#">
						insert into #TablaArticulosCFcuenta# (Ecodigo, LIN_IDREF, CFcuenta)
						values(#session.Ecodigo#, #CuentasParaArticulos.LIN_IDREF#, #rsTraeCuentaAnticipo.CFcuenta#)
					</cfquery>

				<cfelse>
					<!--- 10010. La cuenta de anticipo a proveedores no es valida. --->
						<cf_errorCode code = "10010" msg = "Error al generar la cuenta de un articulo">
				</cfif>
	</cfloop>
</cfif>



	<!--- Registra la Ejecucion que se hace del Asiento de TODO LO QUE NO VIENE DE COMPRAS --->

	<!--- Inserta las lineas que no son articulos o que son articulos sin distribucion --->
	  	<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(	ModuloOrigen,
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
				select 	INTORI,
                        INTDOC,
                        INTREF,
                        fecha,
                        Periodo,
                        Mes,
                        max(INTLIN),
                        Ccuenta,
                        CFcuenta,
                        CPcuenta,
                        Ocodigo,
                        Mcodigo,
                        sum(MontoOrigen),
                        INTCAM,
                        sum(Monto),
                        mov,
                        PCGDid,
                        sum(cant)
				from (
                        select
                            INTORI,
                            INTDOC,
                            INTREF,
                            #LvarHoy# as fecha,
                            i.Periodo,
                            i.Mes,
                            INTLIN,
                            i.Ccuenta,
                            case  	when cxp.DDtipo = 'A' then isnull(tart.CFcuenta,i.CFcuenta)
                            		else i.CFcuenta
                            end as CFcuenta,
                <!---case
                	when coalesce(i.CFid ,0)>0 then i.CFid
                    else---> cp.CPcuenta as CPcuenta,
                            i.Ocodigo,
                            i.Mcodigo,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen,
                            INTCAM,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto,
                            'E' as mov,
                            <!---,null, null--->
                            i.PCGDid,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * coalesce(i.DDcantidad,0) as cant

					  from  #INTARC# i
						inner join CFinanciera cf
							left join CPresupuesto cp
							   on cp.CPcuenta = cf.CPcuenta
							inner join CtasMayor m
							   on m.Ecodigo	= cf.Ecodigo
							  and m.Cmayor	= cf.Cmayor
						   on cf.CFcuenta = i.CFcuenta

						left join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
						left join #TablaArticulosCFcuenta# tart
							on tart.LIN_IDREF = i.LIN_IDREF
					where i.DOlinea is null
                    and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)  <!--- Condicion para traer solo lineas sin distribucion --->

				)imps
					group by INTORI,
                        INTDOC,
						INTREF,
						fecha,
						Periodo,
						Mes,
						Ccuenta,
						CFcuenta,
                        CPcuenta,
						Ocodigo,
						Mcodigo,
						INTCAM,
						mov,
						PCGDid
		</cfquery>

		<!--- Se obtienen las lineas que son articulos y tienen distribucion o que vienen de contrato y tienen distribucion --->
        <cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
            select 	INTORI,
                    INTDOC,
                    INTREF,
                    fecha,
                    Periodo,
                    Mes,
                    max(INTLIN) as INTLIN,
                    Ocodigo,
                    Mcodigo,
                    sum(MontoOrigen) as MontoOrigen,
                    INTCAM,
                    sum(Monto) as Monto,
                    mov,
                    PCGDid,
                    sum(cant) as cant,
                    CPDCid,
                    Aid,
                    DDdesclinea as LineaDeDescuento,
                    DDtipo as Tipoitem,
                    imps.CFid,
                    imps.Cid,
                    LIN_IDREF,
                    CTDContid
            from (
                    select	INTORI,
                            INTDOC,
                            INTREF,
                            #LvarHoy# as fecha,
                            i.Periodo,
                            i.Mes,
                            i.INTLIN,
                            i.Ocodigo,
                            i.Mcodigo,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen,
                            INTCAM,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto,
                            'E' as mov,
                            i.PCGDid,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * coalesce(i.DDcantidad,0) as cant,
                            cxp.CPDCid,
                            cxp.Aid,
                            cxp.DDdesclinea,
                            cxp.DDtipo,
                            cxp.CFid,
                            cxp.Cid,
                            i.LIN_IDREF,
                            cxp.CTDContid

                      from  #INTARC# i
                            inner join CFinanciera cf
                                    left join CPresupuesto cp
                                       on cp.CPcuenta = cf.CPcuenta
                                    inner join CtasMayor m
                                       on m.Ecodigo	= cf.Ecodigo
                                      and m.Cmayor	= cf.Cmayor
                               on cf.CFcuenta = i.CFcuenta

                    inner join DDocumentosCxP cxp
                    on cxp.Linea = i.LIN_IDREF

                    where i.DOlinea is null

            <!--- Condiciones para traer solo lineas que son articulos con distribucion --->
                    and i.INTDES like '%' + cxp.DDdescripcion
                    and (cxp.DDtipo = 'A' or cxp.CTDContid is not null)<!--- Para las lineas de contrato insertadas directamente en factura y que tienen distribucion --->
                    and cxp.CPDCid is not null
                    and cxp.CPDCid > 0

            )imps
            group by 	INTORI,
                        INTDOC,
                        INTREF,
                        fecha,
                        Periodo,
                        Mes,
                        Ocodigo,
                        Mcodigo,
                        INTCAM,
                        mov,
                        PCGDid,
                        CPDCid,
                        Aid,
                        DDdesclinea,
                        DDtipo,
                        imps.CFid,
                        imps.Cid,
                        LIN_IDREF,
                        CTDContid
        </cfquery>


	<!--- Para cada linea con distribucion --->
	<!---	<cfloop query="rsLineasConDistribucion">

		<!--- Genera la distribucion --->
			<cfinvoke  component="sif.Componentes.PRES_Distribucion"
			   method="GenerarDistribucion"
			   returnVariable="rsDistribucion"
			   CFid="#rsLineasConDistribucion.CFid#"
			   Cid="#rsLineasConDistribucion.Cid#"
			   Aid = "#rsLineasConDistribucion.Aid#"
			   CPDCid="#rsLineasConDistribucion.CPDCid#"
			   Cantidad="#rsLineasConDistribucion.cant#"
			   Aplica = "1"
			   Tipo = "#rsLineasConDistribucion.Tipoitem#"
			   Monto="#rsLineasConDistribucion.Monto#">


		<!--- Almacena la distribucion de linea en la tabla (no aplica para contratos)--->
                    <cfif rsLineasConDistribucion.CTDContid eq "">
			<cfloop query="rsDistribucion">
				<cfinvoke
				component="sif.Componentes.PRES_Distribucion"
				method="insertaDistribucionCxP"
				Linea="#rsLineasConDistribucion.LIN_IDREF#"
				NumeroLineaReferencia="#rsLineasConDistribucion.INTLIN#"
				TipoMovimiento="#rsLineasConDistribucion.mov#"
				LineaDistribucion="#rsDistribucion.NumLineaDistribucion#"
				CFid="#rsDistribucion.CFid#"
				rsDistribucionCuenta="#rsDistribucion.cuenta#">
			</cfloop>
                    </cfif>


	<!--- Inserta cada linea de la distribucion --->
    <cfloop query="rsDistribucion">

        <cfquery name="rs" datasource="#Arguments.Conexion#">
                insert into #request.intPresupuesto#
                        (	ModuloOrigen,
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
                                PCGDid,
                                PCGDcantidad )

                values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTORI#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTDOC#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTREF#">,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.fecha#">,
                                #rsLineasConDistribucion.Periodo#,
                                #rsLineasConDistribucion.Mes#,
                                (#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#,
                                (select Ccuenta from CFinanciera
                                 where CFformato = '#rsDistribucion.cuenta#'),
                                (select CFcuenta from CFinanciera
                                 where CFformato = '#rsDistribucion.cuenta#'),
                                (select CPcuenta from CFinanciera
                                 where CFformato = '#rsDistribucion.cuenta#'),
                                #rsLineasConDistribucion.Ocodigo#,
                                #rsLineasConDistribucion.Mcodigo#,
                                #rsDistribucion.Monto#,
                                1,
                                #rsDistribucion.Monto#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.mov#">,
                                <cfif rsLineasConDistribucion.PCGDid eq "">
                                        null,
                                <cfelse>
                                        #rsLineasConDistribucion.PCGDid#,
                                </cfif>
                                #rsDistribucion.cantidad#
                        )
                </cfquery>

			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->
---->

		<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
           insert into #request.intPresupuesto#
                        (	ModuloOrigen,
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
                                PCGDid,
                                PCGDcantidad )
                    select	INTORI,
                            INTDOC,
                            INTREF,
                            #LvarHoy# as fecha,
                            i.Periodo,
                            i.Mes,
                            i.INTLIN,
							i.Ccuenta,
                       		i.CFcuenta,
                       		cp.CPcuenta,
                            i.Ocodigo,
                            i.Mcodigo,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2) as MontoOrigen,
                            INTCAM,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto,
                            'E' as mov,
                            i.PCGDid,
                            #PreserveSingleQuotes(LvarSignoDB_CR)# * coalesce(i.DDcantidad,0) as cant
                            <!---,cxp.CPDCid,
                            cxp.Aid,
                            cxp.DDdesclinea,
                            cxp.DDtipo,
                            cxp.CFid,
                            cxp.Cid,
                            i.LIN_IDREF,
                            cxp.CTDContid--->

                      from  #INTARC# i
                            inner join CFinanciera cf
                                    left join CPresupuesto cp
                                       on cp.CPcuenta = cf.CPcuenta
                                    inner join CtasMayor m
                                       on m.Ecodigo	= cf.Ecodigo
                                      and m.Cmayor	= cf.Cmayor
                               on cf.CFcuenta = i.CFcuenta

                    inner join DDocumentosCxP cxp
                    on cxp.Linea = i.LIN_IDREF



                    where i.DOlinea is null

            <!--- Condiciones para traer solo lineas que son articulos con distribucion --->
                    and i.INTDES like '%' + cxp.DDdescripcion
                    and (cxp.DDtipo = 'A' or cxp.CTDContid is not null)<!--- Para las lineas de contrato insertadas directamente en factura y que tienen distribucion --->
                    and cxp.CPDCid is not null
                    and cxp.CPDCid > 0

           <!--- )imps
            group by 	INTORI,
                        INTDOC,
                        INTREF,
                        fecha,
                        Periodo,
                        Mes,
                        Ocodigo,
                        Mcodigo,
                        INTCAM,
                        mov,
                        PCGDid,
                        CPDCid,
                        Aid,
                        DDdesclinea,
                        DDtipo,
                        imps.CFid,
                        imps.Cid,
                        LIN_IDREF,
                        CTDContid--->
        </cfquery>
<!--- JMRV fin --->

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

        <!---  Genera desde el  Precompromiso  cuando  la Facturas es Directa --->
        <!--- Valida si viene de una OC --->
        <cfquery name="rsFCD" datasource="#session.dsn#">
        	select COUNT(1) as reg ,CPTcodigo from EDocumentosCxP edcxp
            inner join DDocumentosCxP  ddcxp on edcxp.IDdocumento=ddcxp.IDdocumento
            inner join DOrdenCM doc on doc.DOlinea = ddcxp.DOlinea
            where edcxp.IDdocumento = #Arguments.IDdoc#
            and edcxp.Ecodigo = #session.Ecodigo#
            group by CPTcodigo
        </cfquery>

        <cfset Momentos=0>
            <cfif rsFCD.reg GT 0>
               <cfset Momentos=2>
               <cfquery name="rsTipoTransac" datasource="#Session.DSN#">
                    select CPTcodigo, CPTdescripcion ,CPTtipo
                    from CPTransacciones
                    where Ecodigo = #Session.Ecodigo#
                    and CPTcodigo = '#rsFCD.CPTcodigo#'
                </cfquery>
                <cfif rsTipoTransac.CPTtipo EQ 'D'>
                	<cfset Momentos=0>
                </cfif>
            </cfif>

<!--- JMRV. Inicio. 20/08/2014 Para contratos insertados directamente en la factura --->
            <cfif Momentos neq 2>
                <cfquery name="rsFCD" datasource="#session.dsn#">
                    select COUNT(1) as reg ,CPTcodigo from EDocumentosCxP edcxp
                    inner join DDocumentosCxP  ddcxp on edcxp.IDdocumento=ddcxp.IDdocumento
                    inner join CTDetContrato ctd on ctd.CTDCont = ddcxp.CTDContid
                    where edcxp.IDdocumento = #Arguments.IDdoc#
                    and edcxp.Ecodigo = #session.Ecodigo#
                    group by CPTcodigo
                </cfquery>

                <cfif rsFCD.reg GT 0>
                    <cfset Momentos=2>
                    <cfquery name="rsTipoTransac" datasource="#Session.DSN#">
                         select CPTcodigo, CPTdescripcion ,CPTtipo
                         from CPTransacciones
                         where Ecodigo = #Session.Ecodigo#
                         and CPTcodigo = '#rsFCD.CPTcodigo#'
                    </cfquery>
                    <cfif rsTipoTransac.CPTtipo EQ 'D'>
                        <cfset Momentos=0>
                    </cfif>
                </cfif>
            </cfif>
			<cfif Momentos eq 2>
            <cfquery name="rsFCD" datasource="#session.dsn#">
                select COUNT(1) as reg ,CPTcodigo,ctd.CPDCid,ddcxp.DOlinea from EDocumentosCxP edcxp
                inner join DDocumentosCxP ddcxp on edcxp.IDdocumento=ddcxp.IDdocumento
                inner join CTDetContrato ctd on ctd.CTDCont = ddcxp.CTDContid
                where edcxp.IDdocumento = #Arguments.IDdoc#
                and edcxp.Ecodigo = #session.Ecodigo#
                group by CPTcodigo,ctd.CPDCid,ddcxp.DOlinea
            </cfquery>
            <cfif rsFCD.reg GT 0 and (rsFCD.CPDCid NEQ "" or rsFCD.DOlinea NEQ "")>
                <cfset Momentos=0>
                <cfset MomentosDis=0>
            <cfelseif rsFCD.reg GT 0 and rsFCD.CPDCid EQ "">
                <cfset Momentos=2>
                <cfquery name="rsTipoTransac" datasource="#Session.DSN#">
                     select CPTcodigo, CPTdescripcion ,CPTtipo
                     from CPTransacciones
                     where Ecodigo = #Session.Ecodigo#
                     and CPTcodigo = '#rsFCD.CPTcodigo#'
                </cfquery>
                <cfif rsTipoTransac.CPTtipo EQ 'D'>
                    <cfset Momentos=0>
                </cfif>
            </cfif>
        </cfif>
<!--- JMRV. Fin. --->


		<cfquery name="rsPreComp" datasource="#session.dsn#">
			select Pvalor from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 1390
		</cfquery>

		<!--- Registra el Descompromiso que se hace de las Ordenes de Compra Referenciadas --->
		<cfif Momentos EQ 2 or (isdefined('MomentosDis') and MomentosDis EQ 0)>
		<!---
                Cuando el Monto  de la FAC es mayor al  Monto  de la OC
                1.- Genera el Precompromiso de la diferencia entre la FAC y la OC
                --->
        <cfif rsPreComp.Pvalor NEQ "S">

<!--- JMRV inicio --->

	<!--- Para las lineas que no son articulos o que son articulos sin distribucion --->
    <cfquery name="rs" datasource="#Arguments.Conexion#">
            insert into #request.intPresupuesto#
                    (	ModuloOrigen,
                        NumeroDocumento,
                        NumeroReferencia,
                        FechaDocumento,
                        AnoDocumento,
                        MesDocumento,
                        NumeroLinea,
                        CFcuenta,
                        CPcuenta,
                        Ocodigo,
                        Mcodigo,
                        MontoOrigen,
                        TipoCambio,
                        Monto,
                        TipoMovimiento,
                        <!---,NAPreferencia,LINreferencia--->
                        PCGDid,
                        PCGDcantidad )
				select	INTORI,
                        INTDOC,
                        INTREF,
                        #LvarHoy#,
                        i.Periodo,
                        i.Mes,
                        INTLIN + ( 100000 * cxp.IDdocumento),
                        cf.CFcuenta,
                        cp.CPcuenta,
                        i.Ocodigo,
                        i.Mcodigo,
                        case
                            when i.INTMOE > d.DOtotal
                                    then round(i.INTMOE - d.DOtotal, 2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
                        end as MontoOrigen,
                        INTCAM,
                        case
                            when i.INTMOE > d.DOtotal
                                    then round((i.INTMOE - d.DOtotal)*INTCAM, 2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
                        end as Monto,
                        'RC',
                        <!---,null, null--->
                        d.PCGDid,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad

				from  #INTARC# i
					inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
					    on cf.CFcuenta=cf.CFcuenta

				where i.DOlinea is not null
                and d.CTDContid is null <!--- no aplica para contratos --->
                and cxp.CTDContid is null <!--- no aplica para contratos --->
				and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)

				and cf.CFcuenta =
                    <!---
                    OJO: Siempre se ejecuta la cuenta debitada excepto:
                            Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
             --->
                    case
                    <cfif LvarCPcomprasInventario>
                            when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
                            when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
                    </cfif>
                            when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
                            when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
                            <!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
                            when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
                            when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
                            else i.CFcuenta
                    end
            <!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
                    and i.INTMOE > d.DOtotal
            <cfif LvarCPconsumoInventario>
              and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
            </cfif>
        </cfquery>


		<!--- Trae las lineas que son articulos con distribucion --->
			<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
				select	INTORI,
                        INTDOC,
                        INTREF,
                        #LvarHoy# as fecha,
                        i.Periodo,
                        i.Mes,
                        INTLIN + ( 100000 * cxp.IDdocumento) as INTLIN,
                        i.Ocodigo,
                        i.Mcodigo,
                        case
                            when i.INTMOE > d.DOtotal
                                    then round(i.INTMOE - d.DOtotal, 2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
                        end as MontoOrigen,
                        INTCAM,
                        case
                            when i.INTMOE > d.DOtotal
                                    then round((i.INTMOE - d.DOtotal)*INTCAM, 2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
                        end as Monto,
                        'RC' as mov,
                        d.PCGDid,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant,
                        cxp.CPDCid,
                        cxp.Aid,
                        cxp.CFid,
                        cxp.Cid,
                        cxp.DDdesclinea as LineaDeDescuento,
                        cxp.DDtipo as Tipoitem,
                        i.LIN_IDREF

				from  #INTARC# i
					inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
					    on cf.CFcuenta=cf.CFcuenta

				where i.DOlinea is not null
                and d.CTDContid is null <!--- no aplica para contratos --->
                and cxp.CTDContid is null <!--- no aplica para contratos --->
				and i.INTDES like '%' + cxp.DDdescripcion
				and cxp.DDtipo = 'A' <!--- Solo articulos --->
				and cxp.CPDCid is not null
				and cxp.CPDCid > 0

				and cf.CFcuenta =
							<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
							case
							<cfif LvarCPcomprasInventario>
								when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
								when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
							</cfif>
								when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
								when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
								<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
								when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
								when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
								else i.CFcuenta
							end
				<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
					and i.INTMOE > d.DOtotal
				<cfif LvarCPconsumoInventario>
				  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>


	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">

		<!--- Genera la distribucion --->
        <cfinvoke  component="sif.Componentes.PRES_Distribucion"
           method="GenerarDistribucion"
           returnVariable="rsDistribucion"
           CFid="#rsLineasConDistribucion.CFid#"
           Cid="#rsLineasConDistribucion.Cid#"
           Aid = "#rsLineasConDistribucion.Aid#"
           CPDCid="#rsLineasConDistribucion.CPDCid#"
           Cantidad="#rsLineasConDistribucion.cant#"
           Aplica = "1"
           Tipo = "#rsLineasConDistribucion.Tipoitem#"
           Monto="#rsLineasConDistribucion.Monto#">


		<!--- Inserta cada linea de la distribucion --->
			<cfloop query="rsDistribucion">

            <cfquery name="rs" datasource="#Arguments.Conexion#">
                    insert into #request.intPresupuesto#
                            (	ModuloOrigen,
                                NumeroDocumento,
                                NumeroReferencia,
                                FechaDocumento,
                                AnoDocumento,
                                MesDocumento,
                                NumeroLinea,
                                CFcuenta,
                                CPcuenta,
                                Ocodigo,
                                Mcodigo,
                                MontoOrigen,
                                TipoCambio,
                                Monto,
                                TipoMovimiento,
                                PCGDid,
                                PCGDcantidad,
								CFid )

                values 	(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTORI#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTDOC#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTREF#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.fecha#">,
                            #rsLineasConDistribucion.Periodo#,
                            #rsLineasConDistribucion.Mes#,
                            (#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#,
                            (select CFcuenta from CFinanciera
                             where CFformato = '#rsDistribucion.cuenta#'),
                            (select CPcuenta from CFinanciera
                             where CFformato = '#rsDistribucion.cuenta#'),
                            #rsDistribucion.Ocodigo#,
                            #rsLineasConDistribucion.Mcodigo#,
                            #rsDistribucion.Monto#,
                            1,
                            #rsDistribucion.Monto#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.mov#">,
                            <cfif rsLineasConDistribucion.PCGDid eq "">
                                    null,
                            <cfelse>
                                    #rsLineasConDistribucion.PCGDid#,
                            </cfif>
                            #rsDistribucion.cantidad#,
							#rsDistribucion.CFid#)
        	</cfquery>
			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->

	</cfif><!--- Precompromiso NEQ S --->



		<!---
                Cuando la FAC incluye impuesto
                1.- Genera el Compromiso  del impuesto
                2.- Genera el Devengado del Monto de la FAC
                --->
	<cfquery name="rs" datasource="#Arguments.Conexion#">
        insert into #request.intPresupuesto#
                (	ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento,
                    AnoDocumento,
                    MesDocumento,
                    NumeroLinea,
                    CFcuenta,
                    CPcuenta,
                    Ocodigo,
                    Mcodigo,
                    MontoOrigen,
                    TipoCambio,
                    Monto,
                    TipoMovimiento,
                    <!---,NAPreferencia,LINreferencia--->
                    PCGDid,
                    PCGDcantidad
                        )
                select INTORI,
                        INTDOC,
                        INTREF,
                        fecha,
                        Periodo,
                        Mes,
                        max(linea),
                        CFcuenta,
                        CPcuenta,
                        Ocodigo,
                        Mcodigo,
                        sum(round(MontoOrigen,2)) as MontoOrigen,
                        INTCAM,
                        sum(round(Monto,2)) as Monto,
                        mov,
                        PCGDid,
                        sum(cant)
                from (
                        select
                            INTORI,
                            INTDOC,
                            INTREF,
                            #LvarHoy# as fecha,
                            i.Periodo,
                            i.Mes,
                            INTLIN + ( 100000 * cxp.IDdocumento) + 20000 as linea,
                            imp.CFcuenta,
                            cp.CPcuenta,
                            i.Ocodigo,
                            i.Mcodigo,
                            <!---round(cxp.DDtotallinea * imp.Iporcentaje /100,2) as MontoOrigen,--->
                            round(INTMOE,2) as MontoOrigen,
                            INTCAM,
                            <!---round(cxp.DDtotallinea * imp.Iporcentaje /100,2) as Monto, --->
                            round(INTMON,2) as Monto,
                            'CC' as mov,
                            <!---,null, null--->
                            d.PCGDid,
                            isnull(#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad,0) as cant

                        from  #INTARC# i
                                inner join DDocumentosCxP cxp
                                        on cxp.Linea = i.LIN_IDREF
                                inner join Impuestos imp
                                        on imp.Icodigo = cxp.Icodigo
                                        and imp.Ecodigo = cxp.Ecodigo
                                        and imp.Icompuesto = 0
                                left join DOrdenCM d
                                        inner join EOrdenCM e
                                                 on e.EOidorden = d.EOidorden
                                 on d.DOlinea = cxp.DOlinea
                                inner join CFinanciera cf
                                        inner join CPresupuesto cp
                                           on cp.CPcuenta = cf.CPcuenta
                                        inner join CtasMayor m
                                           on m.Ecodigo	= cf.Ecodigo
                                          and m.Cmayor	= cf.Cmayor
                                on cf.CFcuenta=cf.CFcuenta

                        where
                                 cf.CFcuenta =
                                                <!---
                                                OJO: Siempre se ejecuta la cuenta debitada excepto:
                                                        Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
                                         --->
                                                case
                                                <cfif LvarCPcomprasInventario>
                                                        when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
                                                        when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
                                                </cfif>
                                                        when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
                                                        when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
                                                        <!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
                                                        when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
                                                        when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
                                                        else i.CFcuenta
                                                end
                        <!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
                        <cfif LvarCPconsumoInventario>
                          and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
                        </cfif>
                        and imp.Iporcentaje > 0
                        and ltrim(rtrim(i.INTREF)) like 'LINIMP%'
                        and imp.Icreditofiscal = 1
				)imps
				group by INTORI,
						INTDOC,
						INTREF,
						fecha,
						Periodo,
						Mes,
						CFcuenta,
						CPcuenta,
						Ocodigo,
						Mcodigo,
						INTCAM,
						mov,
						PCGDid
			</cfquery>



        <!---
                Cuando el Monto  de la FAC es mayor al  Monto  de la OC
                1.- Genera el Compromiso  de la diferencia entre la FAC y la OC
                2.- Genera el Devengado del Monto de la FAC

		<!--- Para las lineas que no son articulos o que son articulos sin distribucion --->
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
					(	ModuloOrigen,
						NumeroDocumento,
						NumeroReferencia,
						FechaDocumento,
						AnoDocumento,
						MesDocumento,
						NumeroLinea,
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
						INTLIN + ( 100000 * cxp.IDdocumento) + 10000,
						cf.CFcuenta,
						cp.CPcuenta,
						i.Ocodigo,
						i.Mcodigo,
						case
							when i.INTMOE > d.DOtotal
								then round(i.INTMOE - d.DOtotal, 2)
							else
								#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
						end as MontoOrigen,
						INTCAM,
						case
							when i.INTMOE > d.DOtotal
								then round((i.INTMOE - d.DOtotal)*INTCAM, 2)
							else
								#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
						end as Monto,
						'CC',
						<!---,null, null--->
						d.PCGDid,
						#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad

				from  #INTARC# i
					inner join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
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
					on cf.CFcuenta=cf.CFcuenta

				where i.DOlinea is not null
				and (cxp.CPDCid is null or cxp.CPDCid = 0 or i.INTDES not like '%' + cxp.DDdescripcion)

				and cf.CFcuenta =
							<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
							case
							<cfif LvarCPcomprasInventario>
								when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
								when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
							</cfif>
								when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
								when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
								<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
								when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
								when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
								else i.CFcuenta
							end
				<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
					and i.INTMOE > (d.DOpreciou - DOmontodesc + d.DOimpuestoCosto) <!---d.DOtotal---> <!---SML Modificacion para que considere los impuestos y los descuentos de la orden de compra--->
				<cfif LvarCPconsumoInventario>
				  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>

		<!--- Trae las lineas que son articulos con distribucion --->
			<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
				select	INTORI,
                        INTDOC,
                        INTREF,
                        #LvarHoy# as fecha,
                        i.Periodo,
                        i.Mes,
                        INTLIN + ( 100000 * cxp.IDdocumento) + 10000 as INTLIN,
                        i.Ocodigo,
                        i.Mcodigo,
                        case
                                when i.INTMOE > d.DOtotal
                                        then round(i.INTMOE - d.DOtotal, 2)
                                else
                                        #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
                        end as MontoOrigen,
                        INTCAM,
                        case
                                when i.INTMOE > d.DOtotal
                                        then round((i.INTMOE - d.DOtotal)*INTCAM, 2)
                                else
                                        #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
                        end as Monto,
                        'CC' as mov,
                        d.PCGDid,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant,
                        cxp.CPDCid,
                        cxp.Aid,
                        cxp.DDdesclinea as LineaDeDescuento,
                        cxp.DDtipo as Tipoitem,
                        i.LIN_IDREF

				from  #INTARC# i
					inner join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
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
					on cf.CFcuenta=cf.CFcuenta

				where i.DOlinea is not null
				and i.INTDES like '%' + cxp.DDdescripcion
				and cxp.DDtipo = 'A' <!--- Solo articulos --->
				and cxp.CPDCid is not null
				and cxp.CPDCid <> 0

				and cf.CFcuenta =
                        <!---
                        OJO: Siempre se ejecuta la cuenta debitada excepto:
                                Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
                        --->
                        case
                        <cfif LvarCPcomprasInventario>
                                when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
                                when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
                        </cfif>
                                when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
                                when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
                                <!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
                                when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
                                when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
                                else i.CFcuenta
                        end
				<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
					and i.INTMOE > d.DOtotal
				<cfif LvarCPconsumoInventario>
				  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
				</cfif>
			</cfquery>


	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">

			<!--- Obtiene la distribucion --->
				<cfinvoke
				component="sif.Componentes.PRES_Distribucion"
				method="ObtenerDistribucion"
				rsLineasConDistribucion="#rsLineasConDistribucion#"
				returnVariable="rsDistribucion">


			<!--- Inserta cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

                                    <cfquery name="rs" datasource="#Arguments.Conexion#">
                                            insert into #request.intPresupuesto#
                                                    (	ModuloOrigen,
                                                            NumeroDocumento,
                                                            NumeroReferencia,
                                                            FechaDocumento,
                                                            AnoDocumento,
                                                            MesDocumento,
                                                            NumeroLinea,
                                                            CFcuenta,
                                                            CPcuenta,
                                                            Ocodigo,
                                                            Mcodigo,
                                                            MontoOrigen,
                                                            TipoCambio,
                                                            Monto,
                                                            TipoMovimiento,
                                                            PCGDid,
                                                            PCGDcantidad
                                                    )

                                    values 	(   <cfqueryparam cfsqltype="cf_sql_char" value="#rsLineasConDistribucion.INTORI#">,
                                                    <cfqueryparam cfsqltype="cf_sql_char" value="#rsLineasConDistribucion.INTDOC#">,
                                                    <cfqueryparam cfsqltype="cf_sql_char" value="#rsLineasConDistribucion.INTREF#">,
                                                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.fecha#">,
                                                    #rsLineasConDistribucion.Periodo#,
                                                    #rsLineasConDistribucion.Mes#,
                                                    (#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#,
                                                    (select CFcuenta from CFinanciera
                                                     where CFformato = '#rsDistribucion.cuenta#'),
                                                    (select CPcuenta from CFinanciera
                                                     where CFformato = '#rsDistribucion.cuenta#'),
                                                    #rsLineasConDistribucion.Ocodigo#,
                                                    #rsLineasConDistribucion.Mcodigo#,
                                                    #rsDistribucion.MontoOrigen#,
                                                    #rsLineasConDistribucion.INTCAM#,
                                                    #rsDistribucion.Monto#,
                                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.mov#">,
                                                    <cfif rsLineasConDistribucion.PCGDid eq "">
                                                            null,
                                                    <cfelse>
                                                            #rsLineasConDistribucion.PCGDid#,
                                                    </cfif>
                                                    #rsDistribucion.cantidad#
                                                )
                                    </cfquery>
			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->--->


		<!---
                Cuando el Monto de la FAC es menor al  Monto de la OC
                1.- Genera la Reversa del Compromiso de la OC
                2.- Genera el Devengado del Monto de la FAC
                --->


	<!--- Para las lineas que no son articulos o que son articulos sin distribucion --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,
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
				-INTLIN,
				<!---	OJO: Siempre se descompromete la cuenta comprometida --->
				nap.CFcuenta,
				nap.CPcuenta,
				nap.Ocodigo,
				nap.Mcodigo,
				<!---	OJO: nap.CPNAPDmontoOri = round(a.DOtotal-a.DOmontodesc+a.DOimpuestoCosto, 2) --->
				<!---	Si se está surtiendo más que la cantidad comprometida, se descompromete el saldo comprometido  --->
				#PreserveSingleQuotes(LvarSignoDB_CR)# *
                    -case
                        when d.DOcontrolCantidad = 0  	<!---Si no se controla cantidad se descompromete únicamente el mismo monto utilizado --->
                        	then round(INTMOE, 2)
                        <!---when i.INTMON < d.DOtotal then round(d.DOtotal -i.INTMON,2) --->
                        else <!---	de lo contrario se descompromete según la cantidad utilizada en la factura --->
                            round(case
                            		when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
                            		else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
                            	  end ,2)
                    end as MontoOrigen,
				nap.CPNAPDtipoCambio,
			<!---	round( #PreserveSingleQuotes(LvarSignoDB_CR)# *
                    -case
                        when d.DOcontrolCantidad = 0 then round(INTMON, 2)
                        <!---when i.INTMON < d.DOtotal then round(d.DOtotal -i.INTMON,2)--->
                        else
                            case
                                    when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
                                    else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
                                  end
                    end
				* nap.CPNAPDtipoCambio, 2) as MontoLocal,
				1,--->
				<!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
				round( #PreserveSingleQuotes(LvarSignoDB_CR)# *
                    -case
                        when d.DOcontrolCantidad = 0 then round(INTMON, 2)
                        <!---when i.INTMON < d.DOtotal then round(d.DOtotal -i.INTMON,2)--->
                        else
                            case
                                    when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
                                    else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
                                  end
                    end
				* nap.CPNAPDtipoCambio, 2) as MontoLocal,
				'CC',
				e.NAP,
				d.DOconsecutivo,
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

			left join DDocumentosCxP cxp
			on cxp.Linea = i.LIN_IDREF

			where i.DOlinea is not null
            and d.CTDContid is null <!--- No trae lineas de contratos --->
			and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)

			<!---and i.INTMON < d.DOtotal--->
			<!--- No controlar Presupuesto si Parámetro Control Presupuesto Compras de Inventario es de CONSUMO y la compra no es para consumo, o sea, la SC es SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
   			</cfif>


            <!--- Reversa el compromiso de las lineas de contratos que vienen de ordenes de compra y no tienen distribucion --->
                union
                select
                    INTORI,
                    INTDOC,
                    INTREF,
                    #LvarHoy#,
                    i.Periodo,
                    i.Mes,
                    -INTLIN,
                    <!--- --nap.CFcuenta, --->
                    null,
                    nap.CPcuenta,
                    nap.Ocodigo,
                    nap.Mcodigo,
                    -case
                        when d.DOcontrolCantidad = 0 then round(INTMOE, 2) <!---	Si no se controla cantidad se descompromete únicamente el mismo monto utilizado --->
                        else					           				   <!---	de lo contrario se descompromete según la cantidad utilizada en la factura --->
                            round( case
                                        when (d.DOmontoSurtido + (i.INTMOE * i.INTCAM)) >= d.DOtotal then round((d.DOtotal - d.DOmontoSurtido)<!---/e.EOtc--->,2)
                                        else i.INTMOE
                                    end ,2)
                    end,
                    i.INTCAM,
				<!---	  round(
                        -case
                        when d.DOcontrolCantidad = 0 then round(INTMOE, 2) <!---	Si no se controla cantidad se descompromete únicamente el mismo monto utilizado --->
                        else					          				   <!---	de lo contrario se descompromete según la cantidad utilizada en la factura --->
                             case
                                        when (d.DOmontoSurtido + (i.INTMOE * i.INTCAM)) >= d.DOtotal then ((d.DOtotal - d.DOmontoSurtido)<!---/e.EOtc--->)
                                        else i.INTMOE
                                    end
                        end
                    * i.INTCAM, 2),
					1,--->
                    <!--- DesReserva y DesCompromiso y Anulaciones: Cuando es en moneda extranjera, se debe utilizar: MONTO_LOCAL = round(FORMULA_MONTO_ORIGEN * TIPO_CAMBIO,2) --->
                    round(
                        -case
                        when d.DOcontrolCantidad = 0 then round(INTMOE, 2) <!---	Si no se controla cantidad se descompromete únicamente el mismo monto utilizado --->
                        else					          				   <!---	de lo contrario se descompromete según la cantidad utilizada en la factura --->
                             case
                                        when (d.DOmontoSurtido + (i.INTMOE * i.INTCAM)) >= d.DOtotal then ((d.DOtotal - d.DOmontoSurtido)<!---/e.EOtc--->)
                                        else i.INTMOE
                                    end
                        end
                    * i.INTCAM, 2),
                    'CC',
                    ct.NAP,
                    ctd.CTDCconsecutivo * 10000 + ctd.CTDCconsecutivo,
                    d.PCGDid,
                    -d.DOcantidad

		from  #INTARC# i
                inner join DDocumentosCxP cxp
                on cxp.Linea = i.LIN_IDREF
                    inner join DOrdenCM d
                       inner join EOrdenCM e
                       on e.EOidorden = d.EOidorden
                        inner join CTDetContrato ctd
                        on ctd.CTDCont = d.CTDContid
                         inner join CTContrato ct
                         on ct.CTContid = ctd.CTContid
                            inner join CPNAPdetalle nap
                                    inner join CPresupuesto cp
                                    on cp.CPcuenta = nap.CPcuenta
                                      <!--- --inner join CFinanciera cf
                                        --inner join CtasMayor m
                                        --on m.Ecodigo = cf.Ecodigo
                                        --and m.Cmayor	= cf.Cmayor
                                      --on cf.CFcuenta = nap.CFcuenta --->
                            on nap.Ecodigo = e.Ecodigo
                            and nap.CPNAPnum = ct.NAP
                            and nap.CPNAPDlinea = ctd.CTDCconsecutivo * 10000 + ctd.CTDCconsecutivo
                    on d.DOlinea = i.DOlinea

                    where i.DOlinea is not null
                    and d.CTDContid is not null
                    and i.INTDES like '%' + cxp.DDdescripcion
                    and (cxp.CPDCid is null or cxp.CPDCid <= 0)

                    <!---and i.INTMON < d.DOtotal--->
                    <!--- No controlar Presupuesto si Parámetro Control Presupuesto Compras de Inventario es de CONSUMO y la compra no es para consumo, o sea, la SC es SIN Requisición --->
                    <cfif LvarCPconsumoInventario>
                      and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
                    </cfif>

            <!--- Reversa el compromiso de las lineas de contratos directas sin distribucion --->

               union
                select
                    INTORI,
                    INTDOC,
                    INTREF,
                    #LvarHoy#,
                    i.Periodo,
                    i.Mes,
                    -INTLIN,
                    <!--- --nap.CFcuenta, --->
                    null,
                    nap.CPcuenta,
                    nap.Ocodigo,
                    nap.Mcodigo,
                    - i.INTMOE,
                    i.INTCAM,
                    - round(i.INTMOE * i.INTCAM,2),
                    'CC',
                    ct.NAP,
                    ctd.CTDCconsecutivo * 10000 + ctd.CTDCconsecutivo,
                    cxp.PCGDid,
                    - i.DDcantidad

		from  #INTARC# i

                  inner join DDocumentosCxP cxp
                  on cxp.Linea = i.LIN_IDREF
                    inner join CTDetContrato ctd
                    on ctd.CTDCont = cxp.CTDContid
                      inner join CTContrato ct
                      on ct.CTContid = ctd.CTContid
                        inner join CPNAPdetalle nap
                          inner join CPresupuesto cp
                          on cp.CPcuenta = nap.CPcuenta
                           <!---  --inner join CFinanciera cf
                              --inner join CtasMayor m
                              --on m.Ecodigo = cf.Ecodigo
                              --and m.Cmayor = cf.Cmayor
                            --on cf.CFcuenta = nap.CFcuenta --->
                        on nap.Ecodigo = ct.Ecodigo
                        and nap.CPNAPnum = ct.NAP
                        and nap.CPNAPDlinea = ctd.CTDCconsecutivo * 10000 + ctd.CTDCconsecutivo

                where i.DOlinea is null
                and i.INTDES like '%' + cxp.DDdescripcion
                and cxp.CTDContid is not null
                and (cxp.CPDCid is null or cxp.CPDCid <= 0)
	</cfquery>


	<!--- Para las lineas que son articulos con distribucion (o contratos que vienen de ordenes de compra)--->
		<!---- Encontramos cada una de las lineas --->
		<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
                    select
                        INTORI as ModuloOrigen,
                        INTDOC as NumeroDocumento,
                        INTREF as NumeroReferencia,
                        #LvarHoy# as FechaDocumento,
                        i.Periodo as AnoDocumento,
                        i.Mes as MesDocumento,
                        INTLIN,
                        <!---case
                            when i.INTMOE > d.DOtotal then d.DOtotal
                            when i.INTMOE < d.DOtotal and d.DOcantidad = i.DDcantidad then d.DOtotal
                            else i.INTMOE
                        end--->
						i.INTMOE as MontoOrigen,
                       <!--- case
                                when i.INTMOE > d.DOtotal then round(d.DOtotal * i.INTCAM,2)
                                when i.INTMOE < d.DOtotal and d.DOcantidad = i.DDcantidad then  round(d.DOtotal * i.INTCAM,2)
                                else round(i.INTMOE * i.INTCAM,2)
                        end--->
						i.INTMON as Monto,
                        i.INTCAM as TipoCambio,
                        e.EOtc as TipoCambioOrden,
                        'CC' as TipoMovimiento,
                        case
                            when d.CTDContid is not null then ct.NAP
                            else e.NAP
                        end as NAP,
                        d.PCGDid as PCGDid,
                        i.DDcantidad as cant,
                        cxp.CPDCid,
                        cxp.Aid,
                        cxp.CFid,
                        cxp.Cid,
                        cxp.DDtipo as Tipoitem,
                        case
                            when d.CTDContid is not null then ctd.CTDCconsecutivo
                            else d.DOconsecutivo
                        end as DOconsecutivo,
                        d.DOcantidad,
                        d.DOcantsurtida,
                        d.CTDContid, <!--- Para contratos --->
						i.CFcuenta,
						cp.CPcuenta
                        from  #INTARC# i
						inner join CFinanciera cf
                                    left join CPresupuesto cp
                                       on cp.CPcuenta = cf.CPcuenta
                                    inner join CtasMayor m
                                       on m.Ecodigo	= cf.Ecodigo
                                      and m.Cmayor	= cf.Cmayor
                               on cf.CFcuenta = i.CFcuenta
                        inner join DOrdenCM d
                            inner join EOrdenCM e
                            on e.EOidorden = d.EOidorden
                         on d.DOlinea = i.DOlinea

                        left join DDocumentosCxP cxp
                        on cxp.Linea = i.LIN_IDREF
                            left join CTDetContrato ctd
                            on d.CTDContid = ctd.CTDCont
                                left join CTContrato ct
                                on ctd.CTContid = ct.CTContid

                        where i.DOlinea is not null
                        and i.INTDES like '%' + cxp.DDdescripcion
                        and (cxp.DDtipo = 'A' or d.CTDContid is not null)<!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
                        and cxp.CPDCid is not null
                        and cxp.CPDCid > 0

                        <cfif LvarCPconsumoInventario>
                          and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
                        </cfif>


                <!--- Para las lineas que se insertan directas y vienen de contratos. --->
                        union
                        select
                            INTORI as ModuloOrigen,
                            INTDOC as NumeroDocumento,
                            INTREF as NumeroReferencia,
                            #LvarHoy# as FechaDocumento,
                            i.Periodo as AnoDocumento,
                            i.Mes as MesDocumento,
                            INTLIN,
                            i.INTMOE as MontoOrigen,
                            round(i.INTMOE * i.INTCAM,2) as Monto,
                            i.INTCAM as TipoCambio,
                            ct.CTtipoCambio as TipoCambioOrden,
                            'CC' as TipoMovimiento,
                            ct.NAP as NAP,
                            cxp.PCGDid as PCGDid,
                            i.DDcantidad as cant,
                            cxp.CPDCid,
                            cxp.Aid,
                            cxp.CFid,
                            cxp.Cid,
                            cxp.DDtipo as Tipoitem,
                            ctd.CTDCconsecutivo  as DOconsecutivo,
                            i.DDcantidad,
                            i.DDcantidad as DOcantsurtida,
                            cxp.CTDContid, <!--- Para contratos --->
							i.CFcuenta,
							cp.CPcuenta
                            from  #INTARC# i
							inner join CFinanciera cf
                                    left join CPresupuesto cp
                                       on cp.CPcuenta = cf.CPcuenta
                                    inner join CtasMayor m
                                       on m.Ecodigo	= cf.Ecodigo
                                      and m.Cmayor	= cf.Cmayor
                               on cf.CFcuenta = i.CFcuenta
                              inner join DDocumentosCxP cxp
                              on cxp.Linea = i.LIN_IDREF
                                inner join CTDetContrato ctd
                                on cxp.CTDContid = ctd.CTDCont
                                  inner join CTContrato ct
                                  on ctd.CTContid = ct.CTContid

                            where i.DOlinea is null
                            and i.INTDES like '%' + cxp.DDdescripcion
                            and cxp.CTDContid is not null
                            and cxp.CPDCid is not null
                            and cxp.CPDCid > 0
			</cfquery>

	<cfset Consecutivo = 1>
	<cfset OConsecutivo = ''>
	<!----Para cada una de las lineas --->
	<cfloop query="rsLineasConDistribucion">


					<cfif OConsecutivo NEQ '' and OConsecutivo NEQ rsLineasConDistribucion.DOconsecutivo>
						  <cfset Consecutivo = 1>
					</cfif>
                   <!--- Genera la distribucion --->
				   <cfif rsLineasConDistribucion.Tipoitem EQ 'A'>
                   		<cfinvoke  component="sif.Componentes.PRES_Distribucion"
                       		method="GenerarDistribucion"
	                        returnVariable="rsDistribucion"
	                        CFid="#rsLineasConDistribucion.CFid#"
                  		    Cid="#rsLineasConDistribucion.Cid#"
  		                    Aid = "#rsLineasConDistribucion.Aid#"
      		                CPDCid="#rsLineasConDistribucion.CPDCid#"
                       		Cantidad="#rsLineasConDistribucion.cant#"
                       		Aplica = "1"
                       		Tipo = "#rsLineasConDistribucion.Tipoitem#"
                       		Monto="#rsLineasConDistribucion.Monto#">

					<!--- Para cada linea de la distribucion --->
                  <!--- --->
                        <!--- Obtiene los datos de NAP --->

						<cfloop query="rsDistribucion">
                        <!--- Para Contratos --->
						    <cfif isdefined("rsLineasConDistribucion.CTDContid") and rsLineasConDistribucion.CTDContid neq "">
                             	<cfquery name="DatosNAP" datasource="#session.DSN#">
	                                select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
    	                            from CPNAPdetalle
        	                        where Ecodigo = #session.Ecodigo#
            	                    and CPNAPnum	= #rsLineasConDistribucion.NAP#
                	                and CPNAPDlinea	= (#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#
                    	        </cfquery>
                        	<!--- Para lineas que no vienen de contratos --->
                        	<cfelse>
                            	<cfquery name="DatosNAP" datasource="#session.DSN#">
	                                select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
    	                            from CPNAPdetalle
        	                        where Ecodigo = #session.Ecodigo#
            	                    and CPNAPnum	= #rsLineasConDistribucion.NAP#
                	                and CPNAPDlinea	= (#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#
                    	        </cfquery>
                        	 </cfif>


					             <!--- Inserta la linea de la distribucion --->
                			    <cfquery name="rs" datasource="#session.DSN#">
			                        insert into #request.intPresupuesto#(
            		                    ModuloOrigen,
		                                NumeroDocumento,
        		                        NumeroReferencia,
                		                FechaDocumento,
		                                AnoDocumento,
        		                        MesDocumento,
                		                NumeroLinea,
                        		        CFcuenta,
                                		CPcuenta,
		                                Ocodigo,
        		                        Mcodigo,
                		                MontoOrigen,
                        		        TipoCambio,
                                		Monto,
		                                TipoMovimiento,
        		                        NAPreferencia,
                		                LINreferencia,
                        		        PCGDid,
		                                PCGDcantidad
        			                )
						           values 	(
			 							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
				                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
                				        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
				                        <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
                					     #rsLineasConDistribucion.AnoDocumento#,
				                        #rsLineasConDistribucion.MesDocumento#,
										- ((#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#),
										 <cfif isdefined("rsLineasConDistribucion.CTDContid") and rsLineasConDistribucion.CTDContid neq "">
											(select CFcuenta from CFinanciera
											 where CFformato = '#rsDistribucion.cuenta#'),
										<cfelse>
											null,
										</cfif>
										(select CPcuenta from CFinanciera
										 where CFformato = '#rsDistribucion.cuenta#'),
										#DatosNAP.Ocodigo#,
										#DatosNAP.Mcodigo#,
										case
											when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < #rsDistribucion.Monto#
													 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
											when #rsLineasConDistribucion.DOcantsurtida# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
													 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
											else - #rsDistribucion.Monto#
										end,
										1,
										case
											when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < #rsDistribucion.Monto#
													 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
											when #rsLineasConDistribucion.DOcantsurtida# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
													 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
											else - #rsDistribucion.Monto#
										end,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
										#rsLineasConDistribucion.NAP#,  <!---NAPreferencia--->
										#DatosNAP.CPNAPDlinea#,     <!---LINreferencia--->
										<cfif rsLineasConDistribucion.PCGDid eq "">
												null,
										<cfelse>
												#rsLineasConDistribucion.PCGDid#,
										</cfif>
										- #rsDistribucion.cantidad# )
								</cfquery>
                       	  </cfloop> <!---cierra loop distribución--->
					<cfelse>
                        <cfif isdefined("rsLineasConDistribucion.CTDContid") and rsLineasConDistribucion.CTDContid neq "">
                             <cfquery name="DatosNAP" datasource="#session.DSN#">
                                select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto, CPcuenta
                                from CPNAPdetalle
                                where Ecodigo = #session.Ecodigo#
                                and CPNAPnum	= #rsLineasConDistribucion.NAP#
                                and CPNAPDlinea	= (#rsLineasConDistribucion.DOconsecutivo# * 10000) + #Consecutivo#
                            </cfquery>
                        <!--- Para lineas que no vienen de contratos --->
                        <cfelse>
                            <cfquery name="DatosNAP" datasource="#session.DSN#">
                                select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto, CPcuenta
                                from CPNAPdetalle
                                where Ecodigo = #session.Ecodigo#
                                and CPNAPnum	= #rsLineasConDistribucion.NAP#
                                and CPNAPDlinea	= (#rsLineasConDistribucion.DOconsecutivo# * 10000) + #Consecutivo#
                            </cfquery>
                         </cfif>

						 <cfset Consecutivo = Consecutivo + 1>
						 <cfset OConsecutivo = #rsLineasConDistribucion.DOconsecutivo#>


						<!--- Inserta la linea de la distribucion --->
							<cfquery name="rs" datasource="#session.DSN#">
								insert into #request.intPresupuesto#(
										ModuloOrigen,
										NumeroDocumento,
										NumeroReferencia,
										FechaDocumento,
										AnoDocumento,
										MesDocumento,
										NumeroLinea,
										CFcuenta,
										CPcuenta,
										Ocodigo,
										Mcodigo,
										MontoOrigen,
										TipoCambio,
										Monto,
										TipoMovimiento,
										NAPreferencia,
										LINreferencia,
										PCGDid,
										PCGDcantidad
								)
				   		values 	(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
								#rsLineasConDistribucion.AnoDocumento#,
								#rsLineasConDistribucion.MesDocumento#,
								- ((#rsLineasConDistribucion.INTLIN# * 10000) + #rsLineasConDistribucion.INTLIN#),
								<cfif isdefined("rsLineasConDistribucion.CTDContid") and rsLineasConDistribucion.CTDContid neq "">
									<!---(select CFcuenta from CFinanciera
									 where CFformato = --->'#rsLineasConDistribucion.CFcuenta#',
								<cfelse>
									null,
								</cfif>
								 '#rsLineasConDistribucion.CPcuenta#',
								#DatosNAP.Ocodigo#,
								#DatosNAP.Mcodigo#,
								case
									when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < #rsLineasConDistribucion.Monto#
											 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									when #rsLineasConDistribucion.DOcantsurtida# + #rsLineasConDistribucion.cant# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
											 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									else - #rsLineasConDistribucion.Monto#
								end,
								1,
								case
									when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < #rsLineasConDistribucion.Monto#
											 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									when #rsLineasConDistribucion.DOcantsurtida# + #rsLineasConDistribucion.cant# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
											 then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
									else - #rsLineasConDistribucion.Monto#
								end,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
								#rsLineasConDistribucion.NAP#, 	<!---NAPreferencia--->
								#DatosNAP.CPNAPDlinea#,    	<!---LINreferencia--->
								<cfif rsLineasConDistribucion.PCGDid eq "">
										null,
								<cfelse>
										#rsLineasConDistribucion.PCGDid#,
								</cfif>
								- #rsLineasConDistribucion.cant# )

						</cfquery>
					</cfif>
          <!---  </cfloop> <!--- rsDistribucion --->--->
        </cfloop>


<!--- Ahora necesitamos eliminar las lineas de exceso cuando la OC vino de una SC y se cumple que SC < OC --->

	<!--- Para las lineas que no son articulos o que son articulos sin distribucion (Eliminar OC - SC) (no aplica para contratos)--->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia,
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
					-(9000 + INTLIN),
					nap.CFcuenta,
					nap.CPcuenta,
					nap.Ocodigo,
					nap.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# *
	                    -case
	                        when d.DOcontrolCantidad = 0
	                        then
	                            round(nap.CPNAPDmontoOri, 2)
	                        else
	                            round(  case
	                                        when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad
	                                                then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
	                                        else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
	                                  	end ,2)
	                    end,
					nap.CPNAPDtipoCambio,
					round(
					#PreserveSingleQuotes(LvarSignoDB_CR)# *
	                    -case
	                        when d.DOcontrolCantidad = 0
	                        then
	                            round(nap.CPNAPDmontoOri, 2)
	                        else
	                            round( case
	                                        when (d.DOcantsurtida + i.DDcantidad) >= d.DOcantidad
	                                                then (nap.CPNAPDmonto-nap.CPNAPDutilizado)/nap.CPNAPDtipoCambio
	                                        else (nap.CPNAPDmontoOri / d.DOcantidad) * i.DDcantidad
	                                   end ,2)
	                    end
					* nap.CPNAPDtipoCambio, 2),
					'CC',
					e.NAP,
					d.DOconsecutivo + 9000,
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
				       and nap.CPNAPDlinea = (9000 + d.DOconsecutivo)
				 on d.DOlinea = i.DOlinea

			left join DDocumentosCxP cxp
			on cxp.Linea = i.LIN_IDREF

			where i.DOlinea is not null
			and (cxp.CPDCid is null or cxp.CPDCid <= 0)
            and d.CTDContid is null <!--- no aplica para contratos --->

			<!---and i.INTMON < d.DOtotal--->
			<!--- No controlar Presupuesto si Parámetro Control Presupuesto Compras de Inventario es de CONSUMO y la compra no es para consumo, o sea, la SC es SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
   			</cfif>
		</cfquery>



	<!--- Para las lineas que son articulos con distribucion (Eliminar OC - SC) --->

	<!---- Encontramos cada una de las lineas --->
	<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
    select
        INTORI as ModuloOrigen,
        INTDOC as NumeroDocumento,
        INTREF as NumeroReferencia,
        #LvarHoy# as FechaDocumento,
        i.Periodo as AnoDocumento,
        i.Mes as MesDocumento,
        INTLIN,
        case
                when i.INTMON > d.DOtotal then d.DOtotal
                when i.INTMON < d.DOtotal and d.DOcantidad = i.DDcantidad then d.DOtotal
                else i.INTMON
        end as MontoOrigen,
        round(case
                when i.INTMON > d.DOtotal then d.DOtotal
                when i.INTMON < d.DOtotal and d.DOcantidad = i.DDcantidad then d.DOtotal
                else i.INTMON
        end * i.INTCAM,2) as Monto,
        i.INTCAM as TipoCambio,
        e.EOtc as TipoCambioOrden,
        'CC' as TipoMovimiento,
        e.NAP,
        d.PCGDid as PCGDid,
        i.DDcantidad as cant,
        cxp.CPDCid,
        cxp.Aid,
        cxp.CFid,
        cxp.Cid,
        cxp.DDtipo as Tipoitem,
        d.DOconsecutivo,
        d.DOcantidad,
        d.DOcantsurtida

        from  #INTARC# i
                inner join DOrdenCM d
                    inner join EOrdenCM e
                    on e.EOidorden = d.EOidorden
            	on d.DOlinea = i.DOlinea
    	inner join DSolicitudCompraCM sol
            on sol.ESidsolicitud = d.ESidsolicitud
            and sol.DSlinea = d.DSlinea

        left join DDocumentosCxP cxp
        on cxp.Linea = i.LIN_IDREF

        where i.DOlinea is not null
        and d.CTDContid is null <!--- no aplica para contratos --->
        and d.ESidsolicitud is not null
        and i.INTDES like '%' + cxp.DDdescripcion
        and cxp.DDtipo = 'A'
        and cxp.CPDCid is not null
        and cxp.CPDCid > 0
        and sol.DStotallinest < d.DOtotal

        <cfif LvarCPconsumoInventario>
          and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
        </cfif>
    </cfquery>


	<!----Para cada una de las lineas --->
	<cfloop query="rsLineasConDistribucion">

		<!--- Genera la distribucion --->
        <cfinvoke  component="sif.Componentes.PRES_Distribucion"
           method="GenerarDistribucion"
           returnVariable="rsDistribucion"
           CFid="#rsLineasConDistribucion.CFid#"
           Cid="#rsLineasConDistribucion.Cid#"
           Aid = "#rsLineasConDistribucion.Aid#"
           CPDCid="#rsLineasConDistribucion.CPDCid#"
           Cantidad="#rsLineasConDistribucion.cant#"
           Aplica = "1"
           Tipo = "#rsLineasConDistribucion.Tipoitem#"
           Monto="#rsLineasConDistribucion.Monto#">


			<!--- Para cada linea de la distribucion --->
			<cfloop query="rsDistribucion">

    		<!--- Obtiene los datos de NAP del complemento --->
            <cfquery name="DatosNAPComplemento" datasource="#session.DSN#">
                    select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
                    from CPNAPdetalle
                    where CPNAPnum	= #rsLineasConDistribucion.NAP#
                    and CPNAPDlinea	= (#rsLineasConDistribucion.DOconsecutivo# * 10000) + #rsDistribucion.NumLineaDistribucion#
            </cfquery>

    		<!--- Obtiene los datos de NAP --->
            <cfquery name="DatosNAP" datasource="#session.DSN#">
                    select Ocodigo,Mcodigo,CPNAPDtipoCambio,CPNAPDlinea, CPNAPDutilizado, CPNAPDmonto
                    from CPNAPdetalle
                    where CPNAPnum	= #rsLineasConDistribucion.NAP#
                    and CPNAPDlinea	= ((#rsLineasConDistribucion.DOconsecutivo# + 9000) * 10000) + #rsDistribucion.NumLineaDistribucion#
            </cfquery>



            <!--- Inserta la linea de la distribucion --->
    		<cfquery name="rs" datasource="#session.DSN#">
            insert into #request.intPresupuesto#(
                    ModuloOrigen,
                    NumeroDocumento,
                    NumeroReferencia,
                    FechaDocumento,
                    AnoDocumento,
                    MesDocumento,
                    NumeroLinea,
                    CFcuenta,
                    CPcuenta,
                    Ocodigo,
                    Mcodigo,
                    MontoOrigen,
                    TipoCambio,
                    Monto,
                    TipoMovimiento,
                    NAPreferencia,
                    LINreferencia,
                    PCGDid,
                    PCGDcantidad)
        values (    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.ModuloOrigen#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroDocumento#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.NumeroReferencia#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.FechaDocumento#">,
                    #rsLineasConDistribucion.AnoDocumento#,
                    #rsLineasConDistribucion.MesDocumento#,
                    - (((#rsLineasConDistribucion.INTLIN# + 9000) * 10000) + #rsDistribucion.NumLineaDistribucion#),
                    (select CFcuenta from CFinanciera
                     where CFformato = '#rsDistribucion.cuenta#'),
                    (select CPcuenta from CFinanciera
                     where CFformato = '#rsDistribucion.cuenta#'),
                    #DatosNAP.Ocodigo#,
                    #DatosNAP.Mcodigo#,
                    case
                        when #rsDistribucion.Monto# > (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#) then
                            case
                                when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < (#rsDistribucion.Monto# - (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#))
                                         then - round((#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)/#rsLineasConDistribucion.TipoCambio#,2)
                                when #rsLineasConDistribucion.DOcantsurtida# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
                                         then - round((#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)/#rsLineasConDistribucion.TipoCambio#,2)
                                else - round(#rsDistribucion.Monto# - (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#),2)
                            end
                        else 0
                    end,
                    #rsLineasConDistribucion.TipoCambio#,
                    case
                        when #rsDistribucion.Monto# > (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#) then
                            case
                                when (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#) < (#rsDistribucion.Monto# - (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#))
                                         then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
                                when #rsLineasConDistribucion.DOcantsurtida# + #rsDistribucion.cantidad# = #rsLineasConDistribucion.DOcantidad# and #rsLineasConDistribucion.DOcantsurtida# <> 0
                                         then - (#DatosNAP.CPNAPDmonto# - #DatosNAP.CPNAPDutilizado#)
                                else - (#rsDistribucion.Monto# - (#DatosNAPComplemento.CPNAPDmonto# - #DatosNAPComplemento.CPNAPDutilizado#))
           					end
                        else 0
                    end,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.TipoMovimiento#">,
                    #rsLineasConDistribucion.NAP#, 	<!---NAPreferencia--->
                    #DatosNAP.CPNAPDlinea#,    		<!---LINreferencia--->
                    <cfif rsLineasConDistribucion.PCGDid eq "">
                            null,
                    <cfelse>
                            #rsLineasConDistribucion.PCGDid#,
                    </cfif>
                    case
                            when #rsDistribucion.Monto# > #DatosNAPComplemento.CPNAPDmonto# then
                                    - #rsDistribucion.cantidad#
                            else 0
                    end
                )
			</cfquery>

			</cfloop> <!--- rsDistribucion --->
		</cfloop><!--- rsLineasConDistribucion --->
	</cfif><!--- Momento = 2 --->


	<!--- Registra la Ejecucion que se hace de las Ordenes de Compra Referenciadas --->

	<!--- Cuando la linea no es una articulo o es un articulo sin distribucion --->
         <cfquery name="rsConTraslado" datasource="#Arguments.Conexion#">
            select distinct a.CFid,b.CFid,b.CTDContid,isnull(d.CFid,c.CFid),CambioCF,IDdocumento
            from DDocumentosCxP a
                inner join #INTARC# i
                    on a.Linea = i.LIN_IDREF
                inner join DOrdenCM b
                    on a.DOlinea = b.DOlinea
                inner join CTDetContrato c
                    on c.CTDCont = b.CTDContid
                left join CTDetContratoAgr d
                    on c.CTDCont = d.IdAgrSuf
                    where (a.CPDCid is null or a.CPDCid <= 0)
        </cfquery>
 <!---Inicia Traslados automaticos sin Distribución RVD--->
        <cfif rsConTraslado.recordcount GTE 1 and (isdefined("rsConTraslado.CambioCF") and rsConTraslado.CambioCF EQ 1)> <!---Si Check Cambio CF esta activo--->
 			<!---Inicia Quita $$$ de la cuenta Origen--->
    		<cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        -LIN_IDREF,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
                    isnull(detAgr.CPcuenta,c.CPcuenta) as CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
            		as MontoOrigen,
					INTCAM,
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia
					from  CPresupuestoPeriodo,#INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
				inner join DOrdenCM d
				inner join EOrdenCM e
					on e.EOidorden = d.EOidorden
					on d.DOlinea = i.DOlinea
                inner join CTDetContrato c
                	on c.CTDCont = d.CTDContid
            	left join CTDetContratoAgr detAgr
                	on c.CTDCont = detAgr.IdAgrSuf
				inner join CFinanciera cf
				inner join CPresupuesto cp
				   on cp.CPcuenta = cf.CPcuenta
				inner join CtasMayor m
				   on m.Ecodigo	= cf.Ecodigo
				  and m.Cmayor	= cf.Cmayor
				on cf.CFcuenta=cf.CFcuenta
			where i.DOlinea is not null
            and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
			and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)
				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
            and cxp.CambioCF = 1
	</cfquery>
	<!---Termina Quita $$$ de la cuenta Origen--->
    <!---Inicia Traspado de $$$ a la cuenta Destino--->
    <cfquery name="rsLinea" datasource="#Session.DSN#">
		select max(NumeroLinea) as numLin from #Request.intPresupuesto#
    </cfquery>
	<cfset numLin = rsLinea.numLin + 1>
    <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        cxp.Linea,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
            		as MontoOrigen,
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia
					from  CPresupuestoPeriodo,#INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
				inner join DOrdenCM d
				inner join EOrdenCM e
					on e.EOidorden = d.EOidorden
					on d.DOlinea = i.DOlinea
				inner join CFinanciera cf
				inner join CPresupuesto cp
				   on cp.CPcuenta = cf.CPcuenta
				inner join CtasMayor m
				   on m.Ecodigo	= cf.Ecodigo
				  and m.Cmayor	= cf.Cmayor
				on cf.CFcuenta=cf.CFcuenta
			where i.DOlinea is not null
            and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
			and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)
				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
            and cxp.CambioCF = 1
	</cfquery>
  </cfif>
  <!---Termina Traspado de $$$ a la cuenta Destino--->
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
                        case
                            when cxp.DDtotallinea > d.DOtotal  then
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
                        end
					as MontoOrigen,
					INTCAM,
	                    case
	                        when cxp.DDtotallinea > d.DOtotal  then
	                                round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2) * round(INTCAM,2),2)
	                        else
	                                #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
	                    end
					as Monto,
					'E',
					<!---,null, null--->
					d.PCGDid,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad

			from  #INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
				on cf.CFcuenta=cf.CFcuenta

			where i.DOlinea is not null
			and (cxp.CPDCid is null or cxp.CPDCid <= 0 or i.INTDES not like '%' + cxp.DDdescripcion)

				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
		</cfquery>


	<!--- Trae las lineas que son articulos y tienen distribucion --->
		<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
			select	INTORI,
                    INTDOC,
                    INTREF,
                    #LvarHoy# as fecha,
                    i.Periodo,
                    i.Mes,
                    INTLIN,
                    i.Ocodigo,
                    i.Mcodigo,
                    case
                        when cxp.DDtotallinea > d.DOtotal  then
                                #PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2)
                        else
                                #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
                    end
                    as MontoOrigen,
                    INTCAM,
                        case
                            when cxp.DDtotallinea > d.DOtotal  then
                                    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal * INTCAM,2),2)
                            else
                                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
                        end
                    as Monto,
                    'E' as mov,
                    d.PCGDid,
                    #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant,
                    cxp.CPDCid,
                    cxp.Aid,
                    cxp.CFid,
                    cxp.Cid,
                    cxp.DDdesclinea as LineaDeDescuento,
                    cxp.DDtipo as Tipoitem,
                    i.LIN_IDREF,
                    d.DOcantidad,
                    d.DOcantsurtida,
                    e.NAP as CPNAPnum,
                    d.DOconsecutivo,
                    d.CTDContid

			from  #INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
				on cf.CFcuenta=cf.CFcuenta

			where i.DOlinea is not null

			and i.INTDES like '%' + cxp.DDdescripcion
			and (cxp.DDtipo = 'A' or d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
			and cxp.CPDCid is not null
			and cxp.CPDCid > 0

				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
            and cxp.CambioCF <> 1
		</cfquery>



	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">
			<cfif rsLineasConDistribucion.Tipoitem EQ 'A'>

				<!--- Genera la distribucion --->
				<cfinvoke  component="sif.Componentes.PRES_Distribucion"
				   method="GenerarDistribucion"
				   returnVariable="rsDistribucion"
				   CFid="#rsLineasConDistribucion.CFid#"
				   Cid="#rsLineasConDistribucion.Cid#"
				   Aid = "#rsLineasConDistribucion.Aid#"
				   CPDCid="#rsLineasConDistribucion.CPDCid#"
				   Cantidad="#rsLineasConDistribucion.cant#"
				   Aplica = "1"
				   Tipo = "#rsLineasConDistribucion.Tipoitem#"
				   Monto="#rsLineasConDistribucion.Monto#">


				<!--- Almacena la distribucion de linea en la tabla (no aplica para contratos)--->
				<cfif rsLineasConDistribucion.CTDContid eq "">
					<cfloop query="rsDistribucion">
							<cfinvoke
						component="sif.Componentes.PRES_Distribucion"
						method="insertaDistribucionCxP"
						Linea="#rsLineasConDistribucion.LIN_IDREF#"
						NumeroLineaReferencia="#rsLineasConDistribucion.INTLIN#"
						TipoMovimiento="#rsLineasConDistribucion.mov#"
						LineaDistribucion="#rsDistribucion.NumLineaDistribucion#"
						CFid="#rsDistribucion.CFid#"
						rsDistribucionCuenta="#rsDistribucion.cuenta#">
					</cfloop>
				</cfif>


				<!--- Inserta cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

					<!--- Inserta las lineas que son articulos con distribucion --->
					<cfquery name="rs" datasource="#Arguments.Conexion#">
							  insert into #request.intPresupuesto#
                                            ( ModuloOrigen,
                                                NumeroDocumento,
                                                NumeroReferencia,
                                                FechaDocumento,
                                                AnoDocumento,
                                                MesDocumento,
                                                NumeroLinea,
                                                CFcuenta,
                                                CPcuenta,
                                                Ocodigo,
                                                Mcodigo,
                                                MontoOrigen,
                                                TipoCambio,
                                                Monto,
                                                TipoMovimiento,
                                                PCGDid,
                                                PCGDcantidad
                                            )

                                 values    ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTORI#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTDOC#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTREF#">,
                                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.fecha#">,
                                                #rsLineasConDistribucion.Periodo#,
                                                #rsLineasConDistribucion.Mes#,
                                                (#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#,
                                                (select CFcuenta from CFinanciera
                                                where CFformato = '#rsDistribucion.cuenta#'),
                                                (select CPcuenta from CFinanciera
                                                where CFformato = '#rsDistribucion.cuenta#'),
                                               #rsDistribucion.Ocodigo#,
                                               #rsLineasConDistribucion.Mcodigo#,
                                               #rsDistribucion.Monto#,
                                               1,
                                               #rsDistribucion.Monto#,
                                               <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.mov#">,
                                               <cfif rsLineasConDistribucion.PCGDid eq "">
                                                       null,
                                               <cfelse>
                                                       #rsLineasConDistribucion.PCGDid#,
                                               </cfif>
                                               #rsDistribucion.cantidad#
                                            )
					</cfquery>

				</cfloop>  <!---cierra loop rsDistribucion --->
			</cfif>
		</cfloop><!----cierra loop lineas con distribución--->

		 <!---Para Articulos con distribucion--->
        	<cfquery name="rsTrasladoArticulos" datasource="#Arguments.Conexion#">
				select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        -INTLIN,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
<!---                    i.Periodo*100+i.Mes as PeriodoMes,--->
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
            		<!---case
			           when cxp.DDtotallinea > d.DOtotal  then--->
            	           <!--- #PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2)
			           else--->
		                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(pres.MontoOrigen,2)
			        <!---end--->
            		as MontoOrigen,
					INTCAM,
                   <!--- case
				        when cxp.DDtotallinea > d.DOtotal  then
                		    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal * 1.00,2),2)
                       else--->
			                -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(pres.Monto,2)
            		 <!---end--->
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia,
                    CambioCF
                    from  CPresupuestoPeriodo,#INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
				inner join DOrdenCM d
					inner join EOrdenCM e
				  		 on e.EOidorden = d.EOidorden
				 on d.DOlinea = i.DOlinea
				inner join CFinanciera cf
                	inner join #request.intPresupuesto# pres
                    	on cf.CFcuenta = pres.CFcuenta
					inner join CPresupuesto cp
					   on cp.CPcuenta  = cf.CPcuenta
					inner join CtasMayor m
					   on m.Ecodigo	= cf.Ecodigo
					  and m.Cmayor	= cf.Cmayor
				on cf.CFcuenta=cf.CFcuenta
			where i.DOlinea is not null
			and i.INTDES like '%' + cxp.DDdescripcion
			and (cxp.DDtipo = 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
			and cxp.CPDCid is not null
			and cxp.CPDCid > 0
            and pres.TipoMovimiento = 'CC'
            and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
				and cf.CFcuenta in(
                	select CFcuenta from #request.intPresupuesto#
                	where TipoMovimiento = 'CC')
                    and cxp.CambioCF = 1
		</cfquery>
        <!---Inicia Traslados de Articulos con distribución--->
		<cfquery name="rsInsertarTablaIntPresupuestoTrasladoArticulo" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        -1*((INTLIN*100000)+cp.CPcuenta),
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
<!---                    i.Periodo*100+i.Mes as PeriodoMes,--->
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
            		<!---case
			           when cxp.DDtotallinea > d.DOtotal  then--->
            	           <!--- #PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2)
			           else--->
		                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(pres.MontoOrigen,2)
			        <!---end--->
            		as MontoOrigen,
					INTCAM,
                   <!--- case
				        when cxp.DDtotallinea > d.DOtotal  then
                		    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal * 1.00,2),2)
                       else--->
			                #PreserveSingleQuotes(LvarSignoDB_CR)# * round(pres.Monto,2)
            		 <!---end--->
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia
					from  CPresupuestoPeriodo,#INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
				inner join DOrdenCM d
					inner join EOrdenCM e
				  		 on e.EOidorden = d.EOidorden
				 on d.DOlinea = i.DOlinea
				inner join CFinanciera cf
                	inner join #request.intPresupuesto# pres
                    	on cf.CFcuenta = pres.CFcuenta
					inner join CPresupuesto cp
					   on cp.CPcuenta  = cf.CPcuenta
					inner join CtasMayor m
					   on m.Ecodigo	= cf.Ecodigo
					  and m.Cmayor	= cf.Cmayor
				on cf.CFcuenta=cf.CFcuenta
			where i.DOlinea is not null
			and i.INTDES like '%' + cxp.DDdescripcion
			and (cxp.DDtipo = 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
			and cxp.CPDCid is not null
			and cxp.CPDCid > 0
            and pres.TipoMovimiento = 'CC'
            and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
				and cf.CFcuenta in(
                	select CFcuenta from #request.intPresupuesto#
                	where TipoMovimiento = 'CC')
             and cxp.CambioCF = 1
			</cfquery>
			<cfquery name="rsLinea" datasource="#Session.DSN#">
                select max(NumeroLinea) as numLin from #Request.intPresupuesto#
            </cfquery>
			<cfset numLin = rsLinea.numLin + 1>
            <cfquery name="rsInsertarTablaIntPresupuestoTrasladoArticulo" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select distinct
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        #numLin#,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
                           #PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea,2)
            		as MontoOrigen,
					INTCAM,
                		    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea * 1.00,2),2)
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia
				from  CPresupuestoPeriodo,#INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
                inner join #TablaArticulosCFcuenta# tmpArticulos
                	on tmpArticulos.LIN_IDREF = i.LIN_IDREF
				inner join DOrdenCM d
					inner join EOrdenCM e
				  		 on e.EOidorden = d.EOidorden
				 on d.DOlinea = i.DOlinea
				inner join CFinanciera cf
					inner join CPresupuesto cp
					   on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
					   on m.Ecodigo	= cf.Ecodigo
					  and m.Cmayor	= cf.Cmayor
				on cf.CFcuenta=tmpArticulos.CFcuenta
			where i.DOlinea is not null
			and i.INTDES like '%' + cxp.DDdescripcion
			and (cxp.DDtipo = 'A' and d.CTDContid is not null)
			and cxp.CPDCid is not null
			and cxp.CPDCid > 0
            and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
            and cxp.CambioCF = 1
			</cfquery>
    		<cfquery name="rsLinea" datasource="#Session.DSN#">
               select max(NumeroLinea) as numLin from #request.intPresupuesto#
            </cfquery>
			<cfset numLin = rsLinea.numLin + 1>
        	<cfquery name="rsEjecutadoArticulos" datasource="#Arguments.Conexion#">
                insert into #request.intPresupuesto#
                    (	ModuloOrigen,
                        NumeroDocumento,
                        NumeroReferencia,
                        FechaDocumento,
                        AnoDocumento,
                        MesDocumento,
                        NumeroLinea,
                        CFcuenta,
                        CPcuenta,
                        Ocodigo,
                        Mcodigo,
                        MontoOrigen,
                        TipoCambio,
                        Monto,
                        TipoMovimiento,
                        PCGDid,
                        PCGDcantidad
                    )
                   select distinct
                        INTORI,
                        INTDOC,
                        INTREF,
                        #LvarHoy# as fecha,
                        i.Periodo,
                        i.Mes,
                        #numLin#,
                        cf.CFcuenta,
                        cp.CPcuenta,
                        i.Ocodigo,
                        i.Mcodigo,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea,2)
                        as MontoOrigen,
                        INTCAM,
                        round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea * INTCAM,2),2)
                        as Monto,
                        'E' as mov,
                        d.PCGDid,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * cxp.DDcantidad as cant
                            from  CPresupuestoPeriodo,#INTARC# i
                    inner join DDocumentosCxP cxp
                        on cxp.Linea = i.LIN_IDREF
                    inner join #TablaArticulosCFcuenta# tmpArticulos
                        on tmpArticulos.LIN_IDREF = i.LIN_IDREF
                    inner join DOrdenCM d
                        inner join EOrdenCM e
                             on e.EOidorden = d.EOidorden
                     on d.DOlinea = i.DOlinea
                    inner join CFinanciera cf
                        inner join CPresupuesto cp
                           on cp.CPcuenta = cf.CPcuenta
                        inner join CtasMayor m
                           on m.Ecodigo	= cf.Ecodigo
                          and m.Cmayor	= cf.Cmayor
                    on cf.CFcuenta=tmpArticulos.CFcuenta
                where i.DOlinea is not null
                and i.INTDES like '%' + cxp.DDdescripcion
                and (cxp.DDtipo = 'A' and d.CTDContid is not null)
                and cxp.CPDCid is not null
                and cxp.CPDCid > 0
                 and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                        and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                        and CPPestado = 1
                <cfif LvarCPconsumoInventario>
                  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
                </cfif>
                and cxp.CambioCF = 1
		</cfquery>
		<!--- Inserta las lineas que no son articulos con distribucion --->
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				(	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					PCGDid,
					PCGDcantidad
				)
				select	INTORI,
        			INTDOC,
		            INTREF,
        			#LvarHoy# as fecha,
		            i.Periodo,
        			i.Mes,
			        INTLIN,
					cf.CFcuenta,
					cp.CPcuenta,
            		i.Ocodigo,
			        i.Mcodigo,
            		case
			           when cxp.DDtotallinea > d.DOtotal  then
            	            #PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal,2)
			           else
		                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
			        end
            		as MontoOrigen,
					INTCAM,
                    case
				        when cxp.DDtotallinea > d.DOtotal  then
                		    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(d.DOtotal * INTCAM,2),2)
                        else
			                #PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
            		end
					as Monto,
                    'E' as mov,
					d.PCGDid,
                    #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant
					from  #INTARC# i
					inner join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
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
									on cf.CFcuenta=cf.CFcuenta

					where i.DOlinea is not null

					and i.INTDES like '%' + cxp.DDdescripcion
					and (cxp.DDtipo <> 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
					and cxp.CPDCid is not null
					and cxp.CPDCid > 0

					and cf.CFcuenta =
								<!---
									OJO: Siempre se ejecuta la cuenta debitada excepto:
										Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
								 --->
								case
								<cfif LvarCPcomprasInventario>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
								</cfif>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
									<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
									when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
									when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
									else i.CFcuenta
								end
					<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
								<cfif LvarCPconsumoInventario>
								  and NOT (d.CMtipo != 'A' AND #SIN_REQUISICION#)
								</cfif>
                                and cxp.CambioCF <> 1
		</cfquery>

<!---Traslado de Servicios con distribución--->
		<cfquery name="rsTrasladoServiciosDistribucion" datasource="#Arguments.Conexion#">
				select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        -INTLIN,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
	                 -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
            		as MontoOrigen,
					INTCAM,
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2)
					as Monto,
                    null as NAPreferencia,
					null as LINreferencia,
                    CambioCF
					from  CPresupuestoPeriodo,#INTARC# i
					inner join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
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
									on cf.CFcuenta=cf.CFcuenta
					where i.DOlinea is not null
					and i.INTDES like '%' + cxp.DDdescripcion
					and (cxp.DDtipo <> 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
					and cxp.CPDCid is not null
					and cxp.CPDCid > 0
                    and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
					and cf.CFcuenta =
								<!---
									OJO: Siempre se ejecuta la cuenta debitada excepto:
										Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
								 --->
								case
								<cfif LvarCPcomprasInventario>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
								</cfif>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
									<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
									when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
									when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
									else i.CFcuenta
								end
					<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
								<cfif LvarCPconsumoInventario>
								  and NOT (d.CMtipo != 'A' AND #SIN_REQUISICION#)
								</cfif>
                                and cxp.CambioCF = 1
		</cfquery>
        <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        -INTLIN,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
                    -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMOE,2)
            		as MontoOrigen,
					INTCAM,
					 -#PreserveSingleQuotes(LvarSignoDB_CR)# * round(INTMON,2) as Monto,
                    null as NAPreferencia,
					null as LINreferencia
					from  CPresupuestoPeriodo,#INTARC# i
					inner join DDocumentosCxP cxp
						on cxp.Linea = i.LIN_IDREF
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
									on cf.CFcuenta=cf.CFcuenta
					where i.DOlinea is not null
					and i.INTDES like '%' + cxp.DDdescripcion
					and (cxp.DDtipo <> 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
					and cxp.CPDCid is not null
					and cxp.CPDCid > 0
                    and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
					and cf.CFcuenta =
								<!---
									OJO: Siempre se ejecuta la cuenta debitada excepto:
										Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
								 --->
								case
								<cfif LvarCPcomprasInventario>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
								</cfif>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
									<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
									when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
									when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
									else i.CFcuenta
								end
					<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
								<cfif LvarCPconsumoInventario>
								  and NOT (d.CMtipo != 'A' AND #SIN_REQUISICION#)
								</cfif>
                                and cxp.CambioCF = 1
			</cfquery>
            <cfquery name="rsLinea" datasource="#Session.DSN#">
                	select max(NumeroLinea) as numLin from #Request.intPresupuesto#
                </cfquery>
				<cfset numLin = rsLinea.numLin + 1>
            <cfquery name="rsInsertarTablaIntPresupuesto" datasource="#Session.DSN#">
				insert into #Request.intPresupuesto# (
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					NumeroLinea,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					TipoMovimiento,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					NAPreferencia,
					LINreferencia
				)
               select distinct
                	'PRCO' as ModuloOrigen,
        			INTDOC as NumTraslado,
		            'Traslado' as NumeroReferencia,
        			#LvarHoy# as CPDEfechaDocumento,
		            i.Periodo as CPCano,
        			i.Mes as CPCmes,
			        #numLin#,
                    CPresupuestoPeriodo.CPPid,
                    i.Periodo,
        			i.Mes,
					cp.CPcuenta,
            		i.Ocodigo,
                    'T',
			        CPresupuestoPeriodo.Mcodigo,
                    #PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea,2) as MontoOrigen,
					INTCAM,
           		    round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea * 1.00,2),2) as Monto,
                    null as NAPreferencia,
					null as LINreferencia
                    from  #INTARC# i,CPresupuestoPeriodo,DDocumentosCxP cxp
                	inner join CFinanciera cf
                          on cf.CFcuenta = cxp.CFcuenta
                    inner join CPresupuesto cp
						  on cp.CPcuenta = cf.CPcuenta
					inner join CtasMayor m
						  on m.Ecodigo	= cf.Ecodigo
						  and m.Cmayor	= cf.Cmayor
					inner join DOrdenCM d
                    	on d.DOlinea = cxp.DOlinea
					inner join EOrdenCM e
				  		on e.EOidorden = d.EOidorden
					where cxp.DOlinea is not null
                    and i.DOlinea = cxp.DOlinea
				and i.INTDES like '%' + cxp.DDdescripcion
					and (cxp.DDtipo <> 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
					and cxp.CPDCid is not null
					and cxp.CPDCid > 0
                    and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                    and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                    and CPPestado = 1
					and cf.CFcuenta =
								<!---
									OJO: Siempre se ejecuta la cuenta debitada excepto:
										Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
								 --->
								case
								<cfif LvarCPcomprasInventario>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
								</cfif>
									when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
									when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
									<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
									when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
									when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
									else cxp.CFcuenta
								end
					<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
								<cfif LvarCPconsumoInventario>
								  and NOT (d.CMtipo != 'A' AND #SIN_REQUISICION#)
								</cfif>
                                and cxp.CambioCF = 1
			</cfquery>
            <cfquery name="rsLinea" datasource="#Session.DSN#">
               	select max(NumeroLinea) as numLin from #request.intPresupuesto#
            </cfquery>
				<cfset numLin = rsLinea.numLin + 1>
        	<cfquery name="rsEjecutadoServicioDistribucion" datasource="#Arguments.Conexion#">
				insert into #request.intPresupuesto#
                    (	ModuloOrigen,
                        NumeroDocumento,
                        NumeroReferencia,
                        FechaDocumento,
                        AnoDocumento,
                        MesDocumento,
                        NumeroLinea,
                        CFcuenta,
                        CPcuenta,
                        Ocodigo,
                        Mcodigo,
                        MontoOrigen,
                        TipoCambio,
                        Monto,
                        TipoMovimiento,
                        PCGDid,
                        PCGDcantidad
                    )
                   select distinct
                        INTORI,
                        INTDOC,
                        INTREF,
                        #LvarHoy# as fecha,
                        i.Periodo,
                        i.Mes,
                        #numLin#,
                        cf.CFcuenta,
                        cp.CPcuenta,
                        i.Ocodigo,
                        i.Mcodigo,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea,2)
                        as MontoOrigen,
                        INTCAM,
                        round(#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea * INTCAM,2),2) as Monto,
                        'E' as mov,
                        d.PCGDid,
                        #PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant
                        from  #INTARC# i,CPresupuestoPeriodo,DDocumentosCxP cxp
                        inner join CFinanciera cf
                              on cf.CFcuenta = cxp.CFcuenta
                        inner join CPresupuesto cp
                              on cp.CPcuenta = cf.CPcuenta
                        inner join CtasMayor m
                              on m.Ecodigo	= cf.Ecodigo
                              and m.Cmayor	= cf.Cmayor
                        inner join DOrdenCM d
                            on d.DOlinea = cxp.DOlinea
                        inner join EOrdenCM e
                            on e.EOidorden = d.EOidorden
                        where cxp.DOlinea is not null
                         and i.DOlinea = cxp.DOlinea
                    and i.INTDES like '%' + cxp.DDdescripcion
                        and (cxp.DDtipo <> 'A' and d.CTDContid is not null) <!--- Encontramos las lineas de contrato que vienen de una OC y tienen distribucion --->
                        and cxp.CPDCid is not null
                        and cxp.CPDCid > 0
                        and (i.Periodo*100+i.Mes >= CPresupuestoPeriodo.CPPanoMesDesde
                        and i.Periodo*100+i.Mes <= CPresupuestoPeriodo.CPPanoMesHasta)
                        and CPPestado = 1
                        and cf.CFcuenta =
                                    <!---
                                        OJO: Siempre se ejecuta la cuenta debitada excepto:
                                            Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
                                     --->
                                    case
                                    <cfif LvarCPcomprasInventario>
                                        when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
                                        when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
                                    </cfif>
                                        when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
                                        when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
                                        <!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
                                        when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
                                        when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
                                        else cxp.CFcuenta
                                    end
                        <!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
                                    <cfif LvarCPconsumoInventario>
                                      and NOT (d.CMtipo != 'A' AND #SIN_REQUISICION#)
                                    </cfif>
                                     and cxp.CambioCF = 1
		</cfquery>

		<!--- Creamos el Devengado por un monto DDtotallinea - DOtotal (FAC > OC) --->
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
					9000 + INTLIN,
					cf.CFcuenta, cp.CPcuenta,
					i.Ocodigo,
					i.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea - d.DOtotal,2) as MontoOrigen,
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(cxp.DDtotallinea - d.DOtotal,2) * INTCAM, 2) as Monto,
					'E',
					<!---,null, null--->
					d.PCGDid,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad

			from  #INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
				on cf.CFcuenta=cf.CFcuenta

			where i.DOlinea is not null
			and (cxp.CPDCid is null or cxp.CPDCid <= 0)
			and cxp.DDtotallinea > d.DOtotal

				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
		</cfquery>


	<!--- Trae las lineas que son articulos y tienen distribucion --->
		<cfquery name="rsLineasConDistribucion" datasource="#Arguments.Conexion#">
			select	INTORI,
					INTDOC,
					INTREF,
					#LvarHoy# as fecha,
					i.Periodo,
					i.Mes,
					INTLIN + 9000 as INTLIN,
					i.Ocodigo,
					i.Mcodigo,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(cxp.DDtotallinea - d.DOtotal,2) as MontoOrigen,
					INTCAM,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * round(round(cxp.DDtotallinea - d.DOtotal,2) * INTCAM, 2) as Monto,
					'E' as mov,
					d.PCGDid,
					#PreserveSingleQuotes(LvarSignoDB_CR)# * d.DOcantidad as cant,
					cxp.CPDCid,
					cxp.Aid,
					cxp.CFid,
					cxp.Cid,
					cxp.DDdesclinea as LineaDeDescuento,
					cxp.DDtipo as Tipoitem,
					i.LIN_IDREF,
                    d.CTDContid

			from  #INTARC# i
				inner join DDocumentosCxP cxp
					on cxp.Linea = i.LIN_IDREF
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
				on cf.CFcuenta=cf.CFcuenta

			where i.DOlinea is not null
			and i.INTDES like '%' + cxp.DDdescripcion
			and (cxp.DDtipo = 'A' or d.CTDContid is not null)
			and cxp.CPDCid is not null
			and cxp.CPDCid > 0
			and cxp.DDcantidad = d.DOcantidad
			and cxp.DDtotallinea > d.DOtotal

				and cf.CFcuenta =
						<!---
							OJO: Siempre se ejecuta la cuenta debitada excepto:
								Compra de Articulos de Inventario con DOlinea sin Requisición o con Requisición y entrada a Almacen
						 --->
						case
						<cfif LvarCPcomprasInventario>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #SIN_REQUISICION#			then -1/0 	<!--- OJO: Cuando cambian a Articulo y no es requisición hay que armar la cuenta inventario del CF --->
						</cfif>
							when d.CMtipo =  'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then d.CFcuenta
							when d.CMtipo <> 'A' AND cxp.DDtipo = 'A' AND #CON_REQUISICION_ALMACEN#	then -1/0 	<!--- OJO: Cuando cambian a Articulo y es con requisición al almacen hay que la cuenta inventario del CF --->
							<!---	ACTIVOS FIJOS: Ejecucion a la cuenta de Inversion, no la cuenta debitada Activo Fijos en Transito --->
							when d.CMtipo =  'F' AND cxp.DDtipo = 'F'								then d.CFcuenta
							when d.CMtipo <> 'F' AND cxp.DDtipo = 'F'								then i.CFcuenta	<!--- Creo que esta malo porque la cuenta debitada es la de Transito, pero en las pruebas de la Nacion construyó la cuenta de Inversion del CF --->
							else i.CFcuenta
						end
			<!--- Únicamente no se Controla Presupuesto cuando el Parámetro Tipo de Control de Presupuesto para Compras de Artículos de Inventario es para CONSUMO y es compra SIN Requisición --->
			<cfif LvarCPconsumoInventario>
			  and NOT (d.CMtipo = 'A' AND #SIN_REQUISICION#)
			</cfif>
		</cfquery>


	<!--- Para cada linea con distribucion --->
		<cfloop query="rsLineasConDistribucion">


		<!--- Obtiene la distribucion --->
		<cfinvoke  component="sif.Componentes.PRES_Distribucion"
			   method="GenerarDistribucion"
			   returnVariable="rsDistribucion"
			   CFid="#rsLineasConDistribucion.CFid#"
			   Cid="#rsLineasConDistribucion.Cid#"
			   Aid = "#rsLineasConDistribucion.Aid#"
			   CPDCid="#rsLineasConDistribucion.CPDCid#"
			   Cantidad="#rsLineasConDistribucion.cant#"
			   Aplica = "1"
			   Tipo = "#rsLineasConDistribucion.Tipoitem#"
			   Monto="#rsLineasConDistribucion.Monto#">


		<!--- Almacena la distribucion de linea en la tabla --->
                    <cfif rsLineasConDistribucion.CTDContid eq "">
			<cfloop query="rsDistribucion">
				<cfinvoke
				component="sif.Componentes.PRES_Distribucion"
				method="insertaDistribucionCxP"
				Linea="#rsLineasConDistribucion.LIN_IDREF#"
				NumeroLineaReferencia="#rsLineasConDistribucion.INTLIN#"
				TipoMovimiento="#rsLineasConDistribucion.mov#"
				LineaDistribucion="#rsDistribucion.NumLineaDistribucion#"
				CFid="#rsDistribucion.CFid#"
				rsDistribucionCuenta="#rsDistribucion.cuenta#">
			</cfloop>
                    </cfif>

			<!--- Inserta cada linea de la distribucion --->
				<cfloop query="rsDistribucion">

                        <!--- Inserta las lineas que son articulos con distribucion --->
                        <cfquery name="rs" datasource="#Arguments.Conexion#">
                                insert into #request.intPresupuesto#
                                            (	ModuloOrigen,
                                                NumeroDocumento,
                                                NumeroReferencia,
                                                FechaDocumento,
                                                AnoDocumento,
                                                MesDocumento,
                                                NumeroLinea,
                                                CFcuenta,
                                                CPcuenta,
                                                Ocodigo,
                                                Mcodigo,
                                                MontoOrigen,
                                                TipoCambio,
                                                Monto,
                                                TipoMovimiento,
                                                PCGDid,
                                                PCGDcantidad
                                            )

                                 values    (	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTORI#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTDOC#">,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.INTREF#">,
                                                <cfqueryparam cfsqltype="cf_sql_date" value="#rsLineasConDistribucion.fecha#">,
                                                #rsLineasConDistribucion.Periodo#,
                                                #rsLineasConDistribucion.Mes#,
                                                (#rsLineasConDistribucion.INTLIN# * 10000) + #rsDistribucion.NumLineaDistribucion#,
                                                (select CFcuenta from CFinanciera
                                                where CFformato = '#rsDistribucion.cuenta#'),
                                                (select CPcuenta from CFinanciera
                                                where CFformato = '#rsDistribucion.cuenta#'),
                                               #rsDistribucion.Ocodigo#,
                                               #rsLineasConDistribucion.Mcodigo#,
                                               #rsDistribucion.Monto#,
                                               1,
                                               #rsDistribucion.Monto#,
                                               <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLineasConDistribucion.mov#">,
                                               <cfif rsLineasConDistribucion.PCGDid eq "">
                                                       null,
                                               <cfelse>
                                                       #rsLineasConDistribucion.PCGDid#,
                                               </cfif>
                                               #rsDistribucion.cantidad#
                                            )
                                </cfquery>
			</cfloop> <!--- rsDistribucion --->
		</cfloop> <!--- rsLineasConDistribucion --->

<!--- JMRV fin --->
		<cfquery name="rsIntercompany" datasource="#Arguments.Conexion#">
			select distinct Ecodigo
			  from #INTARC# i,CFinanciera cf
				 where cf.CFcuenta = i.CFcuenta
		</cfquery>

	   <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select
				INTORI, INTDOC, INTREF,
				#LvarHoy# as INTFEC,
				Periodo, Mes,*
			from #INTARC#
			where INTLIN = 1
		</cfquery>
		<!--- <cfquery datasource="#Arguments.Conexion#" name="rsDocEvento2">
        	select Ecodigo, CPTcodigo, EDdocumento, SNcodigo
            from EDocumentosCxP
            where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery> --->
		<!--- Inicializa Arguments.Intercompany --->
		<cfquery name="rsIntercompany" datasource="#Arguments.Conexion#">
			select distinct Ecodigo
			  from #INTARC# i,CFinanciera cf
				 where cf.CFcuenta = i.CFcuenta
		</cfquery>
		<!--- <CFdump var="#rsDocEvento#">--->
		<!--- <CF_dumptable var="#INTARC#">  --->

		<cfset LvarIntercompany = rsIntercompany.RecordCount GT 1>
		<cfset LvarPI	 = LobjControl.ControlPresupuestarioIntercompany(
							rsSQL.INTORI,
							rsSQL.INTDOC,
							rsSQL.INTREF,
							rsSQL.INTFEC,
							rsSQL.Periodo,
							rsSQL.Mes,
							 Arguments.Conexion, Arguments.Ecodigo,Momentos,
							 -1,false,false,
							 LvarIntercompany
<!---Control Evento Inicia--->
							 ,false,varNumeroEvento
<!---Control Evento Fin--->
						) >


		<cfif LvarPI.NAP GTE 0>
			<!--- El NAP debe incluirse en el Componente de Posteo --->
			<cfset Contabiliza (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, LvarPI.NAP, LvarPI.CPNAPIid, Arguments.Conexion,Arguments.EntradasEnRecepcion,varNumeroEvento)>

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

			<!---<cfif Arguments.debug EQ "S"> ---><!---SML. 13/06/2014 Lo comente, ya que cuando se genera un NRP solo muestra el mensaje pero no registra el NRP--->
				<cftransaction action="commit" />
			<!---</cfif>--->

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
            <cf_dbtempcol name="diotdicodigo"  		type="char(3)"  mandatory="no">
			<cf_dbtempcol name="descripcion"   		type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="montoBase"   	 	type="money"  	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float"  	mandatory="no">
			<cf_dbtempcol name="porcjeIeps"    		type="float" 	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="IEPS"    			type="money"  	mandatory="no">  <!--- Cambio ieps--->
			<cf_dbtempcol name="Escalonado"   		type="numeric">
			<cf_dbtempcol name="impuesto6Decs" 		type="numeric(20,6)"  	mandatory="no">
			<cf_dbtempcol name="creditofiscal"    	type="integer"  mandatory="no">
			<cf_dbtempcol name="icompuesto"    		type="integer"  mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
			<cf_dbtempcol name="ddtipo"    			type="char(1)"  	mandatory="no">
		</cf_dbtemp>

		<cf_dbtemp name="impdocCP1" returnvariable="CP_impDoc" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="idreg"    			type="numeric" 	mandatory="yes" identity="yes">
			<cf_dbtempcol name="iddocumento"    	type="numeric" 	mandatory="yes">
			<cf_dbtempcol name="ecodigo"    		type="integer" 	mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)" 	mandatory="no">
			<cf_dbtempcol name="dicodigo"    		type="char(5)" 	mandatory="no">
            <cf_dbtempcol name="diotdicodigo"  		type="char(3)"  mandatory="no">
			<cf_dbtempcol name="subtotal"    		type="money" 	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float" 	mandatory="no">
			<cf_dbtempcol name="porcjeIeps"    		type="float" 	mandatory="no">
			<cf_dbtempcol name="IEPS"    			type="money"  	mandatory="no">  <!--- Cambio ieps--->
			<cf_dbtempcol name="Escalonado"   		type="numeric">
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
			<cf_dbtempcol name="IEPS"    			type="money"  	mandatory="no">  <!--- Cambio ieps--->
			<cf_dbtempcol name="CostoIEPS"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="Escalonado"   		type="numeric">
			<cf_dbtempcol name="otrosCostos"    	type="money"  	mandatory="no">
			<cf_dbtempcol name="costoLinea"	    	type="money"  	mandatory="no">
			<cf_dbtempcol name="totalLinea"	    	type="money"  	mandatory="no">
			<cf_dbtempcol name="ddtipo"    			type="char(1)"  	mandatory="no">
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
            <cfargument name='NumeroEvento' type='string' required="no">


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
			
			<!---- Validar si la factura solo contiene lineas de remision, es una factura de remision------>
			<cfquery name="rsEsDocumentoRemision" datasource="#session.dsn#">
				select count(*) as totalRemisiones from EDocumentosCxP e
					inner join DDocumentosCxP d
					on e.IDdocumento = d.IDdocumento
					left outer join DDocumentosCPR dcpr
					on dcpr.DFacturalinea = d.Linea
					where dcpr.DFacturalinea is not null
					and e.IDdocumento = #Arguments.IDdoc#
					and e.Ecodigo = #Session.Ecodigo#
			</cfquery>

			<!--- Socio de negocio del documento ---->
			<cfquery name="rsSNDocumento" datasource="#session.dsn#">
				select e.SNcodigo from EDocumentosCxP e
					where e.IDdocumento = #Arguments.IDdoc#
					and e.Ecodigo = #Session.Ecodigo#
			</cfquery>
			
			<!--- Buscar cuenta de socio de negocio de tipo Remision (RM)--->
			<cfquery name = "rsCuentaSocio" datasource="#session.dsn#">
			    select 
					t.CPTcodigo	as Tcodigo,
					c.CFcuenta as CFcuenta, 
					c.Ccuenta as Ccuenta,
					c.CFformato	as CFformato
				from SNCPTcuentas stc
					inner join CPTransacciones t
						on t.Ecodigo   = stc.Ecodigo
						and t.CPTcodigo = stc.CPTcodigo
					inner join CFinanciera c
						on c.CFcuenta = stc.CFcuenta
						and c.Ecodigo  = stc.Ecodigo
				where stc.Ecodigo  = #Session.Ecodigo#
				and stc.SNcodigo = #rsSNDocumento.SNcodigo#
				and t.CPTcodigo = 'RM'
			</cfquery>

			<cfset CP_calculoLin	= request.CP_calculoLin	>
			<cfset CP_implinea		= request.CP_implinea>
			<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, INTCAM, INTMON, NumeroEvento
					<!--- Contabilidad Electronica Inicia --->
					, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->)
				select
					'CPFC',
					1,
					a.EDdocumento,
					'#LvarReferencia#',
					b.CPTtipo,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarINTDES#" len="80">,
					<cf_dbfunction name="Date_Format" args="a.EDfecha,YYYYMMDD">,
					#LvarAnoAux#,
					#LvarMesAux#,
					a.Ccuenta,
					a.Mcodigo,
					a.Ocodigo,
					round(a.EDtotal, 2),
					a.EDtipocambio,
					<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc>round(round(a.EDtotal,2) * a.EDtipocambio, 2)<cfelse>round(a.EDtotal, 2)</cfif>
                    ,'#Arguments.NumeroEvento#'<!--- ,a.CFid --->
					<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CPTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
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

			<cfquery datasource="#Arguments.Conexion#" name="rsValidCPDCid"> <!----Valida si existen registros con distribución--->
				select CPDCid, Aid, Cid, d.CFid, d.DDtipo, costoLinea as Monto, DDcantidad, e.IDdocumento, d.Linea
				from EDocumentosCxP e
				inner join DDocumentosCxP d
				 inner join #CP_calculoLin# co
                             on co.linea		= d.Linea
						 on e.IDdocumento = d.IDdocumento
				where e.IDdocumento = #Arguments.IDdoc#
				and (CPDCid > 0 or CTDContid is not null)
				and d.DDtipo != 'A'
			</cfquery>


			<cfif rsValidCPDCid.recordcount GT 0>
				<cfloop query="rsValidCPDCid">
					<cfinvoke  component="sif.Componentes.PRES_Distribucion"
			   			method="GenerarDistribucion"
						returnVariable="rsDistribucion"
					    CFid="#rsValidCPDCid.CFid#"
					    Cid="#rsValidCPDCid.Cid#"
					    Aid = "#rsValidCPDCid.Aid#"
					    CPDCid="#rsValidCPDCid.CPDCid#"
				    	Cantidad="#rsValidCPDCid.DDcantidad#"
					    Aplica = "1"
					    Tipo = "#rsValidCPDCid.DDtipo#"
					    Monto="#rsValidCPDCid.Monto#">



					<cfloop query="rsDistribucion">
						<cfquery datasource="#Arguments.Conexion#" name="rsReg">
							insert into #INTARC# (
								INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
								Periodo, Mes,
								Ccuenta, CFcuenta, Ocodigo,
								DDcantidad,
								LIN_IDREF, DOlinea,
								Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
								NumeroEvento,CFid
							<!--- Contabilidad Electronica Inicia --->
								, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
							<!--- Contabilidad Electronica Fin --->
							)
							select distinct
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
								(select f.Ccuenta from CFinanciera f
									inner join CContables c on f.Ccuenta = c.Ccuenta
									where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDistribucion.Cuenta#">
										and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">),
								<!---Cuenta Financiera--->
								(select CFcuenta from CFinanciera f
									where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDistribucion.Cuenta#">
										and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">),
								case DDtipo
									when 'A' then
										(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
									when 'T' then
										(select min(e.Ocodigo) from Almacen e where e.Aid = b.Alm_Aid)
									when 'S' then
										coalesce((select min(cf.Ocodigo) from CFuncional cf where cf.CFid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDistribucion.CFid#">), #LvarOcodigoDoc#)
									when 'F' then
										a.Ocodigo
									else
										a.Ocodigo
								end ,
								b.DDcantidad,
								b.Linea, b.DOlinea,
								case
									when DDtipo IN ('A','T')
										then #LvarMonedaValuacion#
									else	a.Mcodigo
								end as Mcodigo,
								case
									when DDtipo IN ('A','T')
										then
										round(
		                            	#rsDistribucion.Monto#
										<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif> / #LvarTCvaluacion#
										,2)
								else
								round(
            		                	#rsDistribucion.Monto#
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
            			            #rsDistribucion.Monto#
									<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
								,2)
								as INTMON,
								b.PCGDid
            				    ,'#Arguments.NumeroEvento#',
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucion.CFid#">
			                    <!--- Contabilidad Electronica Inicia --->
									, 1 <!--- Linea de Gasto u Otro --->
									, a.EDdocumento, a.CPTcodigo, a.SNcodigo
								<!--- Contabilidad Electronica Fin --->
							from EDocumentosCxP a
							inner join CPTransacciones c
								 on c.Ecodigo = a.Ecodigo
								and c.CPTcodigo = a.CPTcodigo
							inner join DDocumentosCxP b
                	       <!---inner join #CP_calculoLin# co
                             on co.linea		= b.Linea--->
								 on b.IDdocumento = a.IDdocumento
							where a.IDdocumento = #Arguments.IDdoc#
								  and Linea = #rsValidCPDCid.Linea#
								  and DDtipo <> 'O'
					  </cfquery>
				  </cfloop> <!---cierra loop distribución--->
				</cfloop>
			</cfif>


			<!---►►Artículos con o sin contrato pero con distribución)◄◄--->
			<!---<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,
					DDcantidad,
					LIN_IDREF, DOlinea,
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
					NumeroEvento,CFid
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
					b.Linea, b.DOlinea,
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
                ,'#Arguments.NumeroEvento#',
					case
						when b.DDtipo = 'A' then
                        	coalesce(b.CFComplemento,0)
                    end
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and DDtipo = 'A'
				  and CPDCid is not null and CPDCid > 0
			</cfquery>--->

            <!--- Agregar detalle de la linea de la factura que no sean de remision ----->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,
					DDcantidad,
					LIN_IDREF, DOlinea,
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
					NumeroEvento,CFid
					<!--- Contabilidad Electronica Inicia --->
						, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->
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
						when b.DDtipo = 'F' and exists(select 1
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
						when b.DDtipo = 'F' and exists(select 1
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

					case b.DDtipo
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
					b.Linea, b.DOlinea,
					case
						when b.DDtipo IN ('A','T')
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case
						when b.DDtipo IN ('A','T')
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
						when b.DDtipo IN ('A','T')
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
                ,'#Arguments.NumeroEvento#',
					case
						when b.DDtipo = 'A' then
                        	coalesce(b.CFComplemento,0)
                    end
					<!--- Contabilidad Electronica Inicia --->
						, 1 <!--- Linea de Gasto u Otro --->
						, a.EDdocumento, a.CPTcodigo, a.SNcodigo
					<!--- Contabilidad Electronica Fin --->
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				    left outer join DDocumentosCPR dcpr
			        on dcpr.DFacturalinea = b.Linea
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo <> 'O' and b.DDtipo <> 'A'
				  and (b.CTDContid is null or b.CTDContid < 1)
				  and dcpr.DFacturalinea is null
				  and (b.CPDCid is null or b.CPDCid = 0)
 				<!---  and CPDCid is not null and CPDCid > 0--->
			</cfquery>

            <!--- Agregar detalle de la linea de la factura(lineas de tipo remision) ----->
			<!--- Las lineas de tipo remision, deben afectar la cuenta transitoria de compras(excepcion),
			    en caso de no existir la definida en los parametros, en caso de no existir,
				tomar la  cuenta que tiene la remision--->
			<cfquery datasource="#session.DSN#" name = "rsDocumentoData">
				select * from EDocumentosCxP where
			    IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
			</cfquery>
			<cfset cfinanciera = 0>
			<cfset ccontable = 0>
			<cfquery datasource="#Arguments.Conexion#" name="rsCuentaExcepcion">
			    select cuenta.CFcuenta, cuenta.Ccuenta from SNCPTcuentas sncuenta
					inner join CFinanciera cuenta
					on sncuenta.CFcuenta = cuenta.CFcuenta
					where sncuenta.CPTcodigo = 'RM' and
					sncuenta.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDocumentoData.SNcodigo#">
			</cfquery>
			<cfif rsCuentaExcepcion.RecordCount GT 0>
			    <cfset cfinanciera = #rsCuentaExcepcion.CFcuenta#>
			    <cfset ccontable = #rsCuentaExcepcion.Ccuenta#>
			<cfelse>
			    <cfquery datasource="#Arguments.Conexion#" name="rsCuentaParametro">
			        select cfi.CFcuenta, cfi.Ccuenta from CFinanciera cfi
							where cfi.CFcuenta = (select par.Pvalor from Parametros par
							where par.Pcodigo = 1710 and par.Ecodigo = #Arguments.Ecodigo#)
			    </cfquery>
				<cfset cfinanciera = #rsCuentaParametro.CFcuenta#>
			    <cfset ccontable = #rsCuentaParametro.Ccuenta#>
			</cfif>
            <cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,
					DDcantidad,
					LIN_IDREF, DOlinea,
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
					NumeroEvento,CFid
					<!--- Contabilidad Electronica Inicia --->
						, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->
					)
				select distinct
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
					<cfif ccontable GT 0>
					    #ccontable#
					<cfelse>
					    b.Ccuenta
					</cfif>,
					<!---Cuenta Financiera--->
					<cfif cfinanciera GT 0>
					    #cfinanciera#
					<cfelse>
					    b.cFcuenta
					</cfif>,
					case b.DDtipo
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
					b.Linea, b.DOlinea,
					case
						when b.DDtipo IN ('A','T')
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case
						when b.DDtipo IN ('A','T')
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
						when b.DDtipo IN ('A','T')
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
                ,'#Arguments.NumeroEvento#',
					case
						when b.DDtipo = 'A' then
                        	coalesce(b.CFComplemento,0)
                    end
					<!--- Contabilidad Electronica Inicia --->
						, 1 <!--- Linea de Gasto u Otro --->
						, a.EDdocumento, a.CPTcodigo, a.SNcodigo
					<!--- Contabilidad Electronica Fin --->
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
						left outer join DDocumentosCPR dcpr
			            on dcpr.DFacturalinea = b.Linea
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo <> 'O' and b.DDtipo <> 'A'
				  and (b.CTDContid is null or b.CTDContid < 1)
				  and dcpr.DFacturalinea is not null
 				<!---  and CPDCid is not null and CPDCid > 0--->
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,
					DDcantidad,
					LIN_IDREF, DOlinea,
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
					NumeroEvento,CFid
					<!--- Contabilidad Electronica Inicia --->
						, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->
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
						when b.DDtipo = 'F' and exists(select 1
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
						when b.DDtipo = 'F' and exists(select 1
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

					case b.DDtipo
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
					b.Linea, b.DOlinea,
					case
						when b.DDtipo IN ('A','T')
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case
						when b.DDtipo IN ('A','T')
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
						when b.DDtipo IN ('A','T')
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
                ,'#Arguments.NumeroEvento#',
					case
						when b.DDtipo = 'A' then
                        	coalesce(b.CFComplemento,0)
                    end
				<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CPTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo = 'A'
				<!---  and CPDCid is not null and CPDCid > 0--->
			</cfquery>

			<!---►►3c  Detalle (Artículos o Transito o Servicios o Activos Fijos ). Se considera el impuesto aplicable al costo (credito fiscal = 0)◄◄--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
					INTORI,INTREL,INTDOC,INTREF,INTTIP,INTDES,INTFEC,
					Periodo, Mes,
					Ccuenta, CFcuenta, Ocodigo,
					DDcantidad,
					LIN_IDREF, DOlinea,
					Mcodigo, INTMOE, INTCAM, INTMON ,PCGDid,
					NumeroEvento,CFid <!---SML--->
					<!--- Contabilidad Electronica Inicia --->
						, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->
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
						when b.DDtipo = 'F' and exists(select 1
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
						when b.DDtipo = 'F' and exists(select 1
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
					<!--- Valor del Ocodigo --->
					case b.DDtipo
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
					b.Linea, b.DOlinea,
					case
						when b.DDtipo IN ('A','T')
							then #LvarMonedaValuacion#
							else	a.Mcodigo
					end as Mcodigo,
					case
						when b.DDtipo IN ('A','T')
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
						when b.DDtipo IN ('A','T')
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
                ,'#Arguments.NumeroEvento#',
					case
						when b.DDtipo = 'A' then
                        	coalesce(b.CFComplemento,0)
                        else coalesce(b.CFid,0)<!--- SML--->
                    end
				<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CPTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
				from EDocumentosCxP a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo <> 'O' and b.DDtipo <> 'A'
				  and (CPDCid is null or CPDCid = 0)
				  and (CTDContid is not null and CTDContid > 0)
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
					Mcodigo, INTMOE, INTCAM, INTMON ,NumeroEvento)
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
                    ,'#Arguments.NumeroEvento#'
				from #request.OC_DETALLE# d
			</cfquery>

<!--- Se obtiene el ieps para agregarlo en la intarc --->

			<cfquery name="rsimpIepslinea" datasource="#Arguments.Conexion#">
				select
					icodigo as Icodigo,
					dicodigo as DIcodigo,
					ccuenta as Cuenta,
					CFcuenta as CFcuenta,
					round( sum(IEPS) * #LvarEDtipocambio# , 2) 	as MontoLocal,
					round( sum(IEPS), 2)                     	as MontoOrig,
					min(porcjeIeps) as Porcentaje,
					min(il.descripcion) as Descripcion,
					max(linea) as linea
				from #CP_impLinea# il
				where il.IEPS >0
				and il.creditofiscal = 1
				group by
				il.icodigo,
					il.dicodigo,
					il.ccuenta,
					il.CFcuenta
			</cfquery>

			<cfloop query="rsimpIepslinea">
				<cfset LvarIcodigo     = rsimpIepslinea.Icodigo>
				<cfset LvarDIcodigo    = rsimpIepslinea.DIcodigo>
				<cfset LvarCuenta      = rsimpIepslinea.Cuenta>
				<cfset LvarCFcuenta    = rsimpIepslinea.CFcuenta>
				<cfset LvarMontoLocal  = rsimpIepslinea.MontoLocal>
				<cfset LvarMontoOrig   = rsimpIepslinea.MontoOrig>
				<cfset LvarPorcentaje  = rsimpIepslinea.Porcentaje>
				<cfset LvarDescripcion = rsimpIepslinea.Descripcion>
				<cfset LvarLinea = rsimpIepslinea.linea>

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
						Mcodigo, Ocodigo, INTMOE,NumeroEvento,LIN_IDREF)

					select
						'CPFC',
						1,
						'#LvarEDdocumento#',
						'LINIMP #LvarReferencia#',
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
                        ,'#Arguments.NumeroEvento#',
						#LvarLinea#
					from dual
				</cfquery>

			</cfloop>
 <!--- -------------------------------------------->

<!--- Se obtienen los impuestos para el insert en la intarc --->
			<cfquery name="rsimpuestoslinea" datasource="#Arguments.Conexion#">
				select
					icodigo as Icodigo,
					dicodigo as DIcodigo,
					ccuenta as Cuenta,
					CFcuenta as CFcuenta,
					round( sum(impuesto) * #LvarEDtipocambio# , 2) 	as MontoLocal,
					round( sum(impuesto), 2)                     	as MontoOrig,
					min(porcentaje) as Porcentaje,
					min(il.descripcion) as Descripcion,
					max(linea) as linea
				from #CP_impLinea# il
				where il.creditofiscal = 1
				group by
					il.icodigo,
					il.dicodigo,
					il.ccuenta,
					il.CFcuenta
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
				<cfset LvarLinea = rsimpuestoslinea.linea>

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
						Mcodigo, Ocodigo, INTMOE,NumeroEvento,LIN_IDREF)

					select
						'CPFC',
						1,
						'#LvarEDdocumento#',
						'LINIMP #LvarReferencia#',
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
                        ,'#Arguments.NumeroEvento#',
						#LvarLinea#
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
					,(select min(Ocodigo) from Almacen where Aid = b.Alm_Aid) as Ocodigo, oc.Ucodigo
				from EDocumentosCxP a
					inner join DDocumentosCxP b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						left join DOrdenCM oc
							left join ESolicitudCompraCM sc
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
                        <cfinvokeargument name="Usucodigo"         	value="#session.Usucodigo#"><!--- Usuario --->
                        <cfinvokeargument name="NumeroEvento"		value="#Arguments.NumeroEvento#">
						<cfinvokeargument name="Ucodigo"			value="#rsInventario.Ucodigo#">
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
						Mcodigo, INTMOE, INTCAM, INTMON,NumeroEvento
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
                        ,'#Arguments.NumeroEvento#'
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
                    <cfinvokeargument name="NumeroEvento"	value="#Arguments.NumeroEvento#"/>
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
						INTMOE, INTMON, NumeroEvento
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
                        ,'#Arguments.NumeroEvento#'
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
<!--- Control Evento Inicia --->
        <cfargument name='NumeroEvento' type='string' required='false'>
<!--- Control Evento Fin --->

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
<!--- Control Evento Inicia --->
        	<cfinvokeargument name='NumeroEvento' 	value="#Arguments.NumeroEvento#"/>
<!--- Control Evento Fin --->
		</cfinvoke>

		<!--- Llenar las estructuras de datos de documentos aplicados de CxP --->
		<cfquery name="PorInsertEDocCP" datasource="#Arguments.Conexion#">
			select
				t.Ecodigo,t.CPTcodigo,t.EDdocumento,t.SNcodigo,t.Mcodigo,t.Ocodigo,t.EDtipocambio,t.EDtotal,t.EDtotal,t.EDfecha,t.EDvencimiento,
				t.Ccuenta,t.EDtipocambio,t.EDusuario,	t.Rcodigo,t.CFid,t.Icodigo,t.TESRPTCid,t.TESRPTCietu,t.id_direccion,t.EDfechaarribo,t.folio,t.EDTiEPS,t.FolioReferencia,
				t.EDretencionVariable, t.TimbreFiscal,t.EDdocref,t.IDdocumento,
				case  when t.EDdocref is null then
				0
				else
				isnull((select r.EDsaldo from EDocumentosCP r where r.IDdocumento = t.EDdocref),0)
				end as SaldoRef
			from EDocumentosCxP t
			where t.IDdocumento = #Arguments.IDdoc#
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
				,folio,EDTiEPS,FolioReferencia
				,EDretencionVariable
				,TimbreFiscal
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
				</cfif>,
				<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#PorInsertEDocCP.EDTiEPS#">,
				'#PorInsertEDocCP.FolioReferencia#'
				<cfif isdefined("PorInsertEDocCP.EDretencionVariable") and len(trim(PorInsertEDocCP.EDretencionVariable)) gt 0>
					 ,<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#PorInsertEDocCP.EDretencionVariable#">
				<cfelse>
					,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
				</cfif>
				<cfif isdefined("PorInsertEDocCP.TimbreFiscal") and len(trim(PorInsertEDocCP.TimbreFiscal)) gt 0>
					 ,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#PorInsertEDocCP.TimbreFiscal#">
				<cfelse>
					,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
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
				,EDdescuento, EDperiodo, EDmes, IDcontable, EDfechaaplica,EDTiEPS,EDretencionVariable, FolioReferencia, TimbreFiscal
			)
			select
				IDdocumento,	Ecodigo, 		CPTcodigo, 		Ddocumento, 		SNcodigo,
				Mcodigo, 		Ocodigo,		Dtipocambio, 		Dtotal,		EDsaldo,
				Dfecha, 		Dfechavenc,		Dfechaarribo,		Ccuenta,		EDtcultrev,
				EDusuario,		Rcodigo,		EDmontoretori,		EDtref,		EDdocref,
				Icodigo,		TESRPTCid,TESRPTCietu,		CFid,
				EDtipocambioFecha, EDtipocambioVal, id_direccion, NAP
				,#LvarDescuentoDoc#, #LvarAnoAux#, #LvarMesAux#, #LvarIDcontable#, #LvarHoy#,EDTiEPS,EDretencionVariable, FolioReferencia, TimbreFiscal
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
				IDdocumento,Ecodigo,Dcodigo,CPTcodigo,Ddocumento,
				SNcodigo,DDtransref,DDdocref,DDcoditem,
				Aid,DDtipo,DDcantidad,DDpreciou,DDtotallin,DDescripcion,
				DDdescalterna,
				DDdesclinea,Ccuenta,CFcuenta,Icodigo,CFid,DOlinea,
				OCTid, OCid, OCCid, DDid
				,ContractNo,
				PCGDid,
				FPAEid,
				CFComplemento,
				OBOid,UsucodigoModifica,codIEPS,DDMontoIeps,
                                CPDCid,CTDContid
				)
			select
				#LvarLlave#,a.Ecodigo,b.Dcodigo,a.CPTcodigo,a.EDdocumento,
				a.SNcodigo,a.CPTcodigo,	a.EDdocumento,case when b.Aid is null then b.Cid else b.Aid end,
				b.Alm_Aid,b.DDtipo,b.DDcantidad,b.DDpreciou, b.DDtotallinea,b.DDdescripcion,
				coalesce(b.DDdescalterna, b.DDdescripcion),
				b.DDdesclinea,	b.Ccuenta,b.CFcuenta,b.Icodigo,b.CFid,b.DOlinea,
				oct.OCTid, b.OCid, b.OCCid, b.Linea
				,b.ContractNo,
				b.PCGDid,
				b.FPAEid,
				b.CFComplemento,
				b.OBOid, b.UsucodigoModifica,b.codIEPS,b.DDMontoIeps,
                                b.CPDCid, b.CTDContid
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
				IDdocumento,Ecodigo,Dcodigo,CPTcodigo,Ddocumento,
				SNcodigo,DDtransref,DDdocref,DDcoditem,
				Aid,DDtipo,DDcantidad,DDpreciou,DDtotallin,DDescripcion,
				DDdescalterna,
				DDdesclinea,Ccuenta,CFcuenta,Icodigo,CFid,DOlinea,
				OCTid, OCid, OCCid, DDid,
				ContractNo,
				DDimpuestoCosto, DDimpuestoCF, DDdescdoc, UsucodigoModifica,codIEPS,DDMontoIeps,DDCostoIEPS,
                                CPDCid,CTDContid
				)
			select
				d.IDdocumento,Ecodigo,Dcodigo,CPTcodigo,Ddocumento,
				SNcodigo,DDtransref,DDdocref,DDcoditem,
				Aid,d.DDtipo,DDcantidad,DDpreciou,DDtotallin,DDescripcion,
				DDdescalterna,
				DDdesclinea,Ccuenta,CFcuenta,Icodigo,CFid,DOlinea,
				OCTid, OCid, OCCid, DDid
				,ContractNo
				,co.impuestoCosto, co.impuestoCF, co.descuentoDoc, d.UsucodigoModifica,d.codIEPS,d.DDMontoIeps,co.CostoIEPS,
                                d.CPDCid,d.CTDContid
			 from DDocumentosCP d
                inner join #CP_calculoLin# co
                     on co.linea		= d.DDid
			where d.IDdocumento = #LvarLlave#
		</cfquery>
		<!--- Se agrego el insert automatico para generar Aplicacion de Documentos a Favor para NC con DorREf --->
		<!--- Empieza Cambio NC relacion automatica Agosto 2020 --->

		<cfif isdefined('PorInsertEDocCP') and  PorInsertEDocCP.RecordCount gt 0 
		and PorInsertEDocCP.CPTcodigo EQ 'NC' and PorInsertEDocCP.EDdocref gt 0
		and PorInsertEDocCP.SaldoRef gt 0 and  PorInsertEDocCP.EDtotal lte PorInsertEDocCP.SaldoRef>
			<!--- Encabezado --->
			<cfquery name="InsertAplicaD" datasource="#session.DSN#">
				insert into EAplicacionCP (ID, Ecodigo, CPTcodigo, Ddocumento, SNcodigo, Mcodigo,  EAtipocambio, EAtotal, EAselect,
						EAfecha, EAusuario )
				select a.IDdocumento,a.Ecodigo,a.CPTcodigo,a.Ddocumento,a.SNcodigo,a.Mcodigo,a.Dtipocambio,a.Dtotal,0,getdate(),'#Session.usuario#'
				from EDocumentosCP a
				where a.IDdocumento = #LvarLlave#
			</cfquery>
			<!--- Detalle --->
			<cfquery name="InsertAplicaD" datasource="#session.DSN#">
				insert into DAplicacionCP (ID , Ecodigo, SNcodigo, DAidref, DAtransref, DAdocref, DAmonto, DAtotal ,
								   DAmontodoc, DAtipocambio)
				select #LvarLlave#,Ecodigo,SNcodigo,IDdocumento,CPTcodigo,Ddocumento,#PorInsertEDocCP.EDtotal#,
				#PorInsertEDocCP.EDtotal#,#PorInsertEDocCP.EDtotal#,#PorInsertEDocCP.EDtipocambio#
				from EDocumentosCP a
				where a.IDdocumento = #PorInsertEDocCP.EDdocref#
			</cfquery>
		</cfif> <!--- Termina if Cambio NC--->
		
		<!--- Termina Cambio NC relacion automatica Agosto 2020 --->
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
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and FTcodigo = '4' <!---Aplicada--->
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


		<!---- Se obtiene la transaccion ---->

		<cfquery name ="rsTTransaccion" datasource ="#session.dsn#">
			select CPTcodigo
			from EDocumentosCP
			where IDdocumento = #LvarLlave#
		</cfquery>
		<cfset rCPTcodigo = #rsTTransaccion.CPTcodigo#>

		<!--- Insercion de el Impuesto  ------>

		<cfquery datasource="#Arguments.Conexion#">
			insert into ImpDocumentosCxP (
				IDdocumento, Ecodigo, Periodo, Mes,
				TotalFac,
				SubTotalFac,
				CPTcodigo,
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
				   '#rCPTcodigo#' 		as CPTcodigo,
				   dicodigo,
				   min(ccuenta),
				   sum(impuesto)		as MontoCalculado,
				   sum(montoBase) 		as MontoBaseCalc,
				   0					as MontoPagado,
				   avg(porcentaje)
			  from #CP_impLinea#
			 where creditofiscal = 1
			 and IEPS = 0
			 group by dicodigo
		</cfquery>

<!---- Inicia Adecuacion DIOT ---->
		<!--- Se obtiene el tipo de cambio. Es el nombre que se le da al valor de moneda de origen --->
		<cfquery name="tipCambIva" datasource="#Arguments.Conexion#">
			select Dtipocambio, Rcodigo,
			case when coalesce(EDretporigen,0)>0 then EDretporigen
				 when coalesce(EDmontoretori,0)>0 then EDmontoretori
			     when coalesce(EDretencionVariable,0)>0 then EDretencionVariable
			else 0 end as MontoRetIVA
			from HEDocumentosCP
			where IDdocumento = #LvarLlave#
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>

        <cfquery  name="rsIvaDiot" datasource="#Arguments.Conexion#">
			select ddcp.Icodigo,id.DIOTivacodigo from DDocumentosCP ddcp
			inner join ImpuestoDIOT id on  ddcp.Ecodigo=id.Ecodigo and id.Icodigo=ddcp.Icodigo
			where IDdocumento= #LvarLlave#
			and ddcp.Ecodigo=#Arguments.Ecodigo#
		</cfquery>
		<!---<cf_dumptable var="#tipCambIva#">--->
<!--- <cfif rsIvaDiot.RecordCount GT 0> *****TO DO********* --->

		<!--- Se insertan los valores necesarios para la tabla DIOT_Control --->
		<cfquery datasource="#Arguments.Conexion#">
            insert into DIOT_Control
                      (Ecodigo, SNcodigo, Oorigen, TablaOrigen, CampoId, Documento, Icodigo, DIOTivacodigo, IPeriodo, IMes, OMontoBaseIVA,
					   OIVAAcreditable, OIVAPagado, LMontoBaseIVA, LIVAAcreditable, LIVAPagado, TipoCambioIVA, Usucodigo, BMUsucodigo, ts_rversion,
					    MontoRetIVA, DocRefPago, SaldoLin, Pagado)
            select 	#Arguments.Ecodigo#,
        			(select SNcodigo from EDocumentosCP where IDdocumento = #LvarLlave# and Ecodigo = #Arguments.Ecodigo#),
            		'CPFC',
            		'HEDocumentosCP',
        		 	#LvarLlave#,
                    (select Ddocumento from EDocumentosCP where IDdocumento = #LvarLlave# and Ecodigo = #Arguments.Ecodigo#),
        		 	dicodigo,
					DIOTivacodigo,
        		 	#LvarAnoAux#,
        		 	#LvarMesAux#,
			   		sum(montoBase) as SubTotalFac,
				   	sum(impuesto) as MontoCalculado,
				   	0,
			  	 	sum(montoBase) * #tipCambIva.Dtipocambio#,
				   	sum(impuesto) * #tipCambIva.Dtipocambio#,
				   	0,
				   	#tipCambIva.Dtipocambio#,
				   	#session.Usucodigo#,
				   	#session.Usucodigo#,
				   	#Now()#,
					case when dicodigo ='IVA16' then
							#tipCambIva.MontoRetIVA#
						else 0 end as MontoRetIVA,
					'#rCPTcodigo#',
					sum(montoBase) * #tipCambIva.Dtipocambio#,
					0
		  	from #CP_impLinea# a
			inner join ImpuestoDIOT  b on b.Icodigo=a.dicodigo and a.Ecodigo = b.Ecodigo
		 	where IEPS = 0
		 	group by dicodigo,DIOTivacodigo
		</cfquery>
		<!--- Se actualiza Monto  Retención  IVA para retenciones compuestas--->
		<cfif tipCambIva.Rcodigo GT 0>
			<cfquery name="RetComp" datasource="#session.dsn#">
				select RcodigoDet from RetencionesComp
				where Ecodigo = #session.Ecodigo#
				and Rcodigo = '#tipCambIva.Rcodigo#'
			</cfquery>
			<cfif RetComp.RecordCount GT 0>
				<cfloop query="RetComp">
					<cfquery name="pctjeRet" datasource="#session.dsn#">
						select Rporcentaje from Retenciones
						where Ecodigo = #session.Ecodigo#
						and Rcodigo = '#RetComp.RcodigoDet#'
						and Rdescripcion like 'IVA%'
					</cfquery>
					<cfif pctjeRet.Rporcentaje GT 0>
						<cfset porcentaje = pctjeRet.Rporcentaje/100>
						<cfquery datasource="#session.dsn#">
							update DIOT_Control
							set MontoRetIVA = (OMontoBaseIVA * #porcentaje#)
							where Ecodigo = #session.Ecodigo#
							and CampoId = #LvarLlave#
							and Icodigo = 'IVA16'
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<!---- Se inserta en la tabla de impuestos IEPS ---->
		<cfquery datasource="#Arguments.Conexion#">
			insert into ImpIEPSDocumentosCxP ( 
				IDdocumento, Ecodigo, Periodo, Mes,
				TotalFac,
				SubTotalFac,
				CPTcodigo,
				codIEPS,
				CcuentaImpIeps,
				MontoCalculadoIeps,
				MontoBaseCalc,
				MontoPagadoIeps,
				Iporcentaje
			)
			select #LvarLlave#, #Arguments.Ecodigo#, #LvarAnoAux#, #LvarMesAux#,
				   #LvartotalDoc#		as TotalFac,
				   #LvarSubtotalDoc#	as SubTotalFac,
				   '#rCPTcodigo#' 		as cpt,
				   dicodigo,
				   min(a.ccuenta),
				   sum(coalesce(a.IEPS,0)) as MontoCalculado,
				   sum(a.montoBase) - sum(a.IEPS) as MontoBaseCalc,
				   0					 as MontoPagado,
				   avg(porcjeIeps)
			  from #CP_impLinea# a
			  inner join Impuestos b
			  on a.dicodigo = b.Icodigo
			  and b.ieps = 1
			  and b.Ecodigo = #session.Ecodigo#
			 where creditofiscal = 1
			 and porcentaje = 0
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
			  and b.DDtipo = 'T'
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
		<cfquery name="validaCE" datasource="#Arguments.Conexion#">
            select ERepositorio from Empresa where Ereferencia=#Arguments.Ecodigo#
        </cfquery>
        <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1>

            <cfquery name="rsDatos" datasource="#session.DSN#">
                SELECT distinct  #LvarIDcontable#, dco.Dlinea,op.IDdocumento,dco.CFcuenta CFcuentaA,sn.CFcuentaCxP,snc.CFcuenta,
					dco.CEtipoLinea,dco.CEdocumentoOri,dco.CEtranOri,dco.CESNB, sn.SNidentificacion, op.Dtotal
                FROM HEDocumentosCP op
			      INNER JOIN DContables dco
			                    on dco.IDcontable = #LvarIDcontable#
			                    and dco.Ddocumento = op.Ddocumento
                INNER JOIN SNegocios sn
                    on op.SNcodigo = sn.SNcodigo
			      left join SNCPTcuentas snc
			    on op.Ecodigo = snc.Ecodigo
			    and op.CPTcodigo = snc.CPTcodigo
			    and sn.SNcodigo = snc.SNcodigo
                    and op.Ecodigo = sn.Ecodigo
                where op.IDdocumento = #LvarLlave#
			     and (dco.CFcuenta = ISNULL(ISNULL(sn.CFcuentaCxP,snc.CFcuenta),(select CFcuenta from CFinanciera where Ccuenta = sn.SNcuentacxp and CFmovimiento = 'S')) or dco.CFcuenta = COALESCE(snc.CFcuenta,sn.CFcuentaCxP))
            </cfquery>

              <!--- Envía al Repositorio de  CFDI --->
            <cfloop query="rsDatos">
                <cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="RepositorioCFDIs" >
                    <cfinvokeargument name="idDocumento" 	value="#Arguments.IDdoc#">
                    <cfinvokeargument name="idContable" 	value="#LvarIDcontable#">
                    <cfinvokeargument name="idLineaP" 		value="#rsDatos.Dlinea#">
                    <cfinvokeargument name="Origen" 		value="CPFC">
					<cfif rsDatos.CEtipolinea neq "">
						<cfinvokeargument name='tipoLinea' 		value="#rsDatos.CEtipoLinea#">
					</cfif>
			        <cfinvokeargument name='documentoOri'	value="#rsDatos.CEdocumentoOri#">
			        <cfinvokeargument name='tranOri'		value="#rsDatos.CEtranOri#">
			        <cfif rsDatos.CESNB neq "">
						<cfinvokeargument name='SNB' 			value="#rsDatos.CESNB#">
					</cfif>	
			        <cfinvokeargument name='rfc' 			value="#rsDatos.SNidentificacion#">
			        <cfinvokeargument name='total' 			value="#rsDatos.Dtotal#">
			        <cfinvokeargument name="idDocumentoH" 	value="#LvarLlave#">
				</cfinvoke>
            </cfloop>
        </cfif>
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
                        ,coalesce((
                            	select sum(COALESCE(DDMontoIeps,0))
                            	from DDocumentosCxP
                            	where IDdocumento = a.IDdocumento)
                        ,0) as IEPS
                  from EDocumentosCxP a
                 where a.IDdocumento	= #Arguments.IDdoc#
            </cfquery>
			<cfset LvarLineas = rsSQL.cantidad>
            <cfset LvarDescuentoDoc = rsSQL.EDdescuento>
            <cfset LvarSubTotalDoc = rsSQL.SubTotal>
            <cfset LvarAplicarRetencion = rsSQL.AplicarRetencion>
            <cfset LvarIEPS = rsSQL.IEPS>
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
					impuestoCosto, impuestoCF, otrosCostos, costoLinea, totalLinea,CostoIEPS,IEPS,Escalonado
				)
				select
					IDdocumento, Linea, DDtotallinea,
					<cfif LvarDescuentoDoc GT 0>round(DDtotallinea * #LvarDescuentoDoc / LvarSubtotalDoc#,2)<cfelse>0</cfif>,
					DDimpuestoInterfaz,
					0, 0, 0, 0, 0, 0,COALESCE(DDMontoIeps,0),
					case when(COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1)then 1
						 when i.IEscalonado = 0 then 1
	 					 else 0 end as NAFectaIVa
				from DDocumentosCxP d
					 left join Conceptos e
				    on e.Cid = d.Cid
					 left join Articulos f
					on f.Aid= d.Aid
					 left join Impuestos i
					on d.codIEPS = i.Icodigo
					and i.Ecodigo = d.Ecodigo
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
					porcentaje,  creditofiscal, impuesto, icompuesto,IEPS)
				select
					IDdocumento, Linea, d.Ecodigo, i.Icodigo, i.Icodigo,
					i.Idescripcion, i.Ccuenta, 		i.CFcuenta, 	DDtotallinea,
					Iporcentaje, Icreditofiscal, 0.00, 0, 0
				from DDocumentosCxP d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0
				where d.IDdocumento = #Arguments.IDdoc#
			</cfquery>

	<!--- Valores del IEPS ---->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CP_impLinea# (
					iddocumento, linea, ecodigo,   icodigo,  dicodigo,		descripcion,    ccuenta,		CFcuenta, 		montoBase,
					porcjeIeps,  creditofiscal, impuesto, icompuesto,IEPS,Escalonado,porcentaje)
				select
					IDdocumento, Linea, d.Ecodigo, i.Icodigo, i.Icodigo, 	i.Idescripcion, i.Ccuenta, 		i.CFcuenta, 	DDtotallinea,
					ValorCalculo, Icreditofiscal, 0.00, 0, coalesce(DDMontoIeps,0) as DDMontoIeps,
					case when(COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1)then 1
						 when i.IEscalonado = 0 then 1
	 					 else 0 end as NAFectaIVa , 0
				from DDocumentosCxP d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.codIEPS
					and i.Icompuesto = 0
					left join Conceptos e
					on e.Cid = d.Cid
					left join Articulos f
					on f.Aid= d.Aid
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
					porcentaje,    		creditofiscal, 		impuesto, icompuesto,IEPS)
				select
					IDdocumento, Linea, d.Ecodigo, 	di.Icodigo, di.DIcodigo, 	di.DIdescripcion, di.Ccuenta,	di.CFcuenta,	DDtotallinea,
					di.DIporcentaje,	DIcreditofiscal, 	0.00,     1,0
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

	<!--- Valores del IEPS --->

			<cfquery datasource="#Arguments.Conexion#">
				insert into #CP_impLinea# (
					iddocumento, linea, ecodigo,	icodigo, 	dicodigo,		descripcion,      ccuenta,		CFcuenta, 		montoBase,
					porcjeIeps,    		creditofiscal, 		impuesto, icompuesto,IEPS,Escalonado,porcentaje)
				select
					IDdocumento, Linea, d.Ecodigo, 	di.Icodigo, di.DIcodigo, 	di.DIdescripcion, di.Ccuenta,	di.CFcuenta,	DDtotallinea,
					di.DIporcentaje,	DIcreditofiscal, 	0.00,     1,coalesce(DDMontoIeps,0) as DDMontoIeps,
					case when(COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1)then 1
						 when i.IEscalonado = 0 then 1
	 					 else 0 end as NAFectaIVa,0
				from DDocumentosCxP d
					inner join Impuestos  i
						inner join DImpuestos di
						on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.codIEPS
					and i.Icompuesto = 1
					left join Conceptos e
					on e.Cid = d.Cid
					left join Articulos f
					on f.Aid= d.Aid
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

				<!--- cambio ieps --->
					<cfquery datasource="#session.dsn#">
						update #CP_impLinea#
						set montoBase = montoBase + isnull(
								(
									select IEPS
									  from #CP_calculoLin#
									 where iddocumento	= #CP_impLinea#.iddocumento
									   and linea	    = #CP_impLinea#.linea
									   and Escalonado   = 0
								),0)
					</cfquery>
			<cfelse>

					<cfquery datasource="#session.dsn#">
						update #CP_impLinea#
						set montoBase = montoBase + isnull(
								(
									select IEPS
									  from #CP_calculoLin#
									 where iddocumento	= #CP_impLinea#.iddocumento
									   and linea	= #CP_impLinea#.linea
									   and Escalonado   = 0
								),0)
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
						and IEPS = 0
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
						and IEPS = 0
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
					 , CostoIEPS =
					 		coalesce((
								select sum(IEPS)
								  from #CP_impLinea#
								 where iddocumento		= #CP_calculoLin#.iddocumento
								   and linea			= #CP_calculoLin#.linea
								   and creditofiscal	= 0
							),0)
					 , IEPS =
					 		coalesce((
								select sum(IEPS)
								  from #CP_impLinea#
								 where iddocumento		= #CP_calculoLin#.iddocumento
								   and linea			= #CP_calculoLin#.linea
								   and creditofiscal	= 1
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
				   set costoLinea = subtotalLinea - descuentoDoc + impuestoCosto + otrosCostos + CostoIEPS
					 , totalLinea = subtotalLinea - descuentoDoc + impuestoCosto + otrosCostos + CostoIEPS + impuestoCF + IEPS
			</cfquery>

			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select
					sum(subtotalLinea) 				  as subTotal,
					sum(impuestoCosto + impuestoCF)   as impuestos,
					sum(coalesce(IEPS,0) + CostoIEPS) as TiEPS
				from #request.CP_calculoLin	#
			</cfquery>


			<cfquery datasource="#session.DSN#">
				update EDocumentosCxP
				   set EDtotal    = round(#rsSQL.subTotal# + #rsSQL.Impuestos# - EDdescuento + #rsSQL.TiEPS# ,2)
				   	   ,EDTiEPS   = round(CAST(#rsSQL.TiEPS# as money),2)
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
					 , EDTiEPS    = 0
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

