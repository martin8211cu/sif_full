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
    <cfargument name='esCancelacion' type="boolean" 	required='false' default='false'>
		<cfargument name='esDevolucion' type="boolean" 	required='false' default='false'>

		<cfset fnCreaTablasTemp(Arguments.Conexion)>
		<cfset LvarPintar = Arguments.PintaAsiento>
		<cfset LvarEsCancelacion = Arguments.esCancelacion>
		<cfset LvarEsDevolucion = Arguments.esDevolucion>
		<cfset LvarIDDocumento = Arguments.IDdoc>

		<cfif LvarEsDevolucion eq true>
		    <cfset LvarEsCancelacion = false>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from EDocumentosCPR a
			where a.IDdocumento = #Arguments.IDdoc#
		</cfquery>

		<cfif rsSQL.cantidad GT 0>

			<cf_dbfunction name="now" returnvariable="LvarHoy">

			<cfset LvarHoyYYYYMMDD 	= dateformat(createODBCdate(now()), "YYYYMMDD")>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				from DDocumentosCPR a
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
                <cf_errorCode	code = "51155" msg = "No se ha definido el parámetro de Tipo de Manejo del Descuento a Nivel de Documento para Remisión!">
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
				update EDocumentosCPR
				   set  EDtipocambioFecha 	= coalesce (EDtipocambioFecha, EDfecha)
				 where IDdocumento	= #Arguments.IDdoc#
			</cfquery>

			<!--- Actualizar el total de la línea redondeando a 2 decimales --->
			<cfquery datasource="#Arguments.Conexion#">
				update DDocumentosCPR
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
                            coalesce(a.EDTiEPS,0) as EDTiEPS,
                            coalesce(
                                (
                                    select sum(DDtotallinea)
                                      from DDocumentosCPR
                                     where IDdocumento = a.IDdocumento
                                )
                            ,0.00) as SubTotal
							,coalesce(
								(
									select sum(DDtotallinea)
									  from DDocumentosCPR
									 inner join Impuestos i
										 on i.Ecodigo = DDocumentosCPR.Ecodigo
										and i.Icodigo = DDocumentosCPR.Icodigo
									 where IDdocumento = a.IDdocumento
									   and i.InoRetencion = 0

								) - a.EDdescuento
							,0.00) as AplicarRetencion
                      from EDocumentosCPR a
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
						from EDocumentosCPR a
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
							from EDocumentosCPR a
								inner join SNegocios b
								on a.Ecodigo = b.Ecodigo
								and a.SNcodigo = b.SNcodigo
							where IDdocumento = #Arguments.IDdoc#
						</cfquery>
					</cfif>

					<cfset LvarVencimiento = rsSQL.vencimiento>

					<cfquery name="rsSQL" datasource="#Arguments.conexion#">
						select b.Rporcentaje as retencion
						from EDocumentosCPR a
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
					<cfset LvarINTDES = left("Remisi&oacute;n: #trim(rsSocio.SNidentificacion)# #trim(rsSocio.SNnombre)#", 80)>

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
                <cf_errorCode	code = "51155" msg = "No se ha definido el parámetro de Tipo de Manejo del Descuento a Nivel de Documento para Remisión!">
            </cfif>
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select  coalesce(a.EDdescuento, 0) as EDdescuento,
                        coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCPR
                                 where IDdocumento = a.IDdocumento
                            )
                        ,0.00) as SubTotal
                        ,coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCPR
								 inner join Impuestos i
								 	 on i.Ecodigo = DDocumentosCPR.Ecodigo
								 	and i.Icodigo = DDocumentosCPR.Icodigo
                                 where IDdocumento = a.IDdocumento
								   and i.InoRetencion = 0

                            ) - a.EDdescuento
                        ,0.00) as AplicarRetencion
                         ,   (
                                select count(1)
                                  from DDocumentosCPR
                                 where IDdocumento = a.IDdocumento
                            ) as cantidad
                        ,coalesce((
                            	select sum(COALESCE(DDMontoIeps,0))
                            	from DDocumentosCPR
                            	where IDdocumento = a.IDdocumento)
                        ,0) as IEPS
                  from EDocumentosCPR a
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				from DDocumentosCPR d
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
				update EDocumentosCPR
				   set EDtotal    = round(#rsSQL.subTotal# + #rsSQL.Impuestos# - EDdescuento + #rsSQL.TiEPS# ,2)
				   	   ,EDTiEPS   = round(#rsSQL.TiEPS#,2)
				<cfif Arguments.CalcularImpuestos>
					 , EDimpuesto = round(#rsSQL.impuestos#,2)
				</cfif>
			   where IDdocumento = #Arguments.IDdoc#
				 and Ecodigo = #Session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update EDocumentosCPR
				   set EDtotal    = 0
					 , EDimpuesto = 0
					 , EDTiEPS    = 0
			   where IDdocumento = #Arguments.IDdoc#
				 and Ecodigo = #Session.Ecodigo#
			</cfquery>
		</cfif>

		<cfreturn true>
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
            from EDocumentosCPR
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

		<cfquery datasource="#Arguments.Conexion#">
			update EDocumentosCPR
			   set  EDtipocambioFecha 	= coalesce (EDtipocambioFecha, EDfecha),
					EDtipocambio		= #LvarTCdocumento#,
					EDtipocambioVal		= #LvarMONEDAS.VALUACION.TC#
			 where IDdocumento			= #Arguments.IDdoc#
		</cfquery>

		<cfset request.INTARC = "#INTARC#">

		<cfset LobjOC.OC_Aplica_CxP (Arguments.Ecodigo, Arguments.IDdoc, LvarAnoAux, LvarMesAux, Arguments.Conexion, CP_impLinea)>

		<cfset MovimientosContables (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, Arguments.Conexion, Arguments.EntradasEnRecepcion,varNumeroEvento)>
 
    <cfset Contabiliza (Arguments.IDdoc, Arguments.Ecodigo, LvarEDdocumento, LvarCPTcodigo, 0, 0, 
		  Arguments.Conexion,Arguments.EntradasEnRecepcion,varNumeroEvento)>

		<cfif Arguments.debug EQ "S">
			<cftransaction action="rollback" />
		</cfif>
		<cf_dbtemp_deletes>
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
			<cfset CP_calculoLin	= request.CP_calculoLin	>
			<cfset CP_implinea		= request.CP_implinea>
			<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

            <!---??Valida la cuenta Contable??--->
            <cfquery datasource="#Arguments.Conexion#" name="rsCuentaError">
				select count(1) cantidad
				from EDocumentosCPR a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCPR b
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
				from EDocumentosCPR e
				inner join DDocumentosCPR d
				 inner join #CP_calculoLin# co
                             on co.linea		= d.Linea
						 on e.IDdocumento = d.IDdocumento
				where e.IDdocumento = #Arguments.IDdoc#
				and CPDCid > 0
				and CTDContid is not null
				and d.DDtipo != 'A'
			</cfquery>

      <!--- Para el caso de cargos (debito), se toma la cuenta de concepto de servicios ---->
			<cfset cfinanciera = 0>
			<cfset ccontable = 0>
			<cfquery datasource="#Arguments.Conexion#" name="rsCuentaConceptoServicios">
					select cfin.CFcuenta, cfin.Ccuenta from Conceptos con
					inner join CFinanciera cfin
					on con.Cformato = cfin.CFformato
					and con.Ecodigo = cfin.Ecodigo
					where con.Ccodigo = 'COMPRAS'
					and con.Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			<cfif rsCuentaConceptoServicios.RecordCount GT 0>
			    <cfset cfinanciera = #rsCuentaConceptoServicios.CFcuenta#>
			    <cfset ccontable = #rsCuentaConceptoServicios.Ccuenta#>
			</cfif>
			<!----JARR remisiones       ---->
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
					'CPRM',			1,			a.EDdocumento,		'#LvarReferencia#',
					<cfif LvarEsCancelacion eq false>
					    case c.CPTtipo
								when 'D' then 'C'
								else 'D'
							end
					<cfelse>
					    case c.CPTtipo
								when 'D' then 'D'
								else 'C'
							end
			    </cfif>,
					case
						when b.DDtipo = 'S' AND coalesce(rtrim(b.ContractNo),'') <> '' then
							'OC-D.' #_Cat# rtrim(b.ContractNo) #_Cat# ', Concepto: ' #_Cat# coalesce(
														<cf_dbfunction name="sPart"args="b.DDdescalterna;1;37"  delimiters=";">,
														<cf_dbfunction name="sPart"args="b.DDdescripcion;1;37"  delimiters=";">,
														(select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;37"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						when b.DDtipo = 'S' then
							'Conceptottt: ' #_Cat# coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;70"  delimiters=";">,
														  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;70"  delimiters=";">,
														  (select min(<cf_dbfunction name="sPart"args="con.Cdescripcion;1;70"  delimiters=";">) from Conceptos con where con.Cid = b.Cid ))
						else
							coalesce( <cf_dbfunction name="sPart"args="b.DDdescalterna;1;80"  delimiters=";">,
									  <cf_dbfunction name="sPart"args="b.DDdescripcion;1;80"  delimiters=";">)
					end,
					'#LvarHoyYYYYMMDD#',
					#LvarAnoAux#,		#LvarMesAux#,

					<!---Cuenta Contable--->
					#ccontable# as Ccuenta,
					<!---Cuenta Financiera--->
					#cfinanciera# as CFcuenta,
					case b.DDtipo
						when 'S' then
							coalesce((select min(cf.Ocodigo) from CFuncional cf where cf.CFid = b.CFid), #LvarOcodigoDoc#)
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
				from EDocumentosCPR a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCPR b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo <> 'O' and b.DDtipo <> 'A'
				  and (CTDContid is null or CTDContid < 1)
			</cfquery>

      <!--- Para el caso de abono (credito) buscar cuenta financiera por excepcion del socio,
			  en caso contrario se asigna la de parametros[cuenta pendiente de factura (Remision)] --->
			<cfquery datasource="#session.DSN#" name = "rsDocumentoData">
					select * from EDocumentosCPR where
					  IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
				</cfquery>
		  <cfset cfinanciera = 0>
			<cfset ccontable = 0>
			<cfset cuentaDesc = ''>
			<cfquery datasource="#Arguments.Conexion#" name="rsCuentaExcepcion">
			    select cuenta.CFcuenta, cuenta.Ccuenta, cuenta.CFdescripcion from SNCPTcuentas sncuenta
					inner join CFinanciera cuenta
					on sncuenta.CFcuenta = cuenta.CFcuenta
					where sncuenta.CPTcodigo = 'RM' and
					sncuenta.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDocumentoData.SNcodigo#">
			</cfquery>
			<cfif rsCuentaExcepcion.RecordCount GT 0>
			    <cfset cfinanciera = #rsCuentaExcepcion.CFcuenta#>
			    <cfset ccontable = #rsCuentaExcepcion.Ccuenta#>
					<cfset cuentaDesc = #rsCuentaExcepcion.CFdescripcion#>
			<cfelse>
			    <cfquery datasource="#Arguments.Conexion#" name="rsCuentaParametro">
			        select cfi.CFcuenta, cfi.Ccuenta, cfi.CFdescripcion from CFinanciera cfi
							where cfi.Ccuenta = (select top 1 par.Pvalor from Parametros par
							where par.Pcodigo = 1710 and par.Ecodigo = #Arguments.Ecodigo#)
			    </cfquery>
					<cfset cfinanciera = #rsCuentaParametro.CFcuenta#>
			    <cfset ccontable = #rsCuentaParametro.Ccuenta#>
					<cfset cuentaDesc = #rsCuentaParametro.CFdescripcion#>
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
				select
					'CPRM',			1,			a.EDdocumento,		'#LvarReferencia#',
					<cfif LvarEsCancelacion eq false>
					    case c.CPTtipo
								when 'D' then 'D'
								else 'C'
							end
					<cfelse>
					    case c.CPTtipo
								when 'D' then 'C'
								else 'D'
							end
			    </cfif>,
					'#cuentaDesc#',
					'#LvarHoyYYYYMMDD#',
					#LvarAnoAux#,		#LvarMesAux#,

					<!---Cuenta Contable--->
					#ccontable# as Ccuenta,
					<!---Cuenta Financiera--->
					#cfinanciera# as CFcuenta,
					#LvarOcodigoDoc# ,
					1,
					0, 0,
					a.Mcodigo as Mcodigo,
					SUM(round(co.costoLinea, 2)) as INTMOE,
					case
						when #LvarMcodigoLocal# <> #LvarMcodigoDoc#
							then a.EDtipocambio
						else 1.00
					end as INTCAM,
                    SUM(round(
                        co.costoLinea
						<cfif LvarMcodigoLocal NEQ LvarMcodigoDoc> * a.EDtipocambio </cfif>
					,2))
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
				from EDocumentosCPR a
					inner join CPTransacciones c
						 on c.Ecodigo = a.Ecodigo
						and c.CPTcodigo = a.CPTcodigo
					inner join DDocumentosCPR b
                        inner join #CP_calculoLin# co
                             on co.linea		= b.Linea
						 on b.IDdocumento = a.IDdocumento
				where a.IDdocumento = #Arguments.IDdoc#
				  and b.DDtipo <> 'O' and b.DDtipo <> 'A'
				  and (CTDContid is null or CTDContid < 1)
 				group by a.IDdocumento, a.EDDocumento, c.CPTtipo, b.DDtipo, 
				a.Mcodigo, b.PCGDid, b.CFComplemento, a.CPTcodigo, a.SNcodigo
			</cfquery>

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
    <cfargument name='NumeroEvento' type='string' required='false'>

        <!---►►Realizar adquisición de activos fijos, posterior a la aplición de facturas◄◄--->
        <cfquery name="RsPostergarAdquisicion" datasource="#Arguments.Conexion#">
        	select Coalesce(Pvalor,'0') Pvalor from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 15600
        </cfquery>
        <cfif RsPostergarAdquisicion.RecordCount AND RsPostergarAdquisicion.Pvalor EQ 1>
        	<cfset LvarGenerarAdquisicion = FALSE>
        <cfelse>
        	<cfset LvarGenerarAdquisicion = TRUE>
        </cfif>

    <cfset remisionCancelacion = "">
		<cfif LvarEsCancelacion>
		    <cfset remisionCancelacion = "_Canc">
		</cfif>
		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#LvarFechaDoc#"/>
			<cfinvokeargument name="Oorigen"		value="CPFC"/>
			<cfinvokeargument name="Edocbase"		value="#LvarEDdocumento##remisionCancelacion#"/>
			<cfinvokeargument name="Ereferencia"	value="#LvarCPTcodigo#"/>
			<cfinvokeargument name="Edescripcion"	value="Documento de Remisi&oacute;n: #LvarEDdocumento##remisionCancelacion#"/>
			<cfinvokeargument name="Ocodigo"		value="#LvarOcodigoDoc#"/>
			<cfinvokeargument name="NAP"			value="#Arguments.NAP#"/>
			<cfinvokeargument name="CPNAPIid"		value="#Arguments.CPNAPIid#"/>
			<cfinvokeargument name="PintaAsiento"	value="#LvarPintar#"/>
      <cfinvokeargument name='NumeroEvento' 	value="#Arguments.NumeroEvento#"/>
		</cfinvoke>

    <!--- 
		  LvarIDcontable es el id(IDContable) de la poliza en la tabla EContable, que retorna el componente
			sif.Componentes.CG_GeneraAsiento y el metodo GeneraAsiento
		--->
		<cfif LvarIDcontable GT 0>
		  <cfquery datasource="#Arguments.Conexion#">
				update EDocumentosCPR
				  set EVestado = 1
				  where IDdocumento =  #Arguments.IDdoc#
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update EDocumentosCPR
				  set IDContable = #LvarIDcontable#
				  where IDdocumento =  #Arguments.IDdoc#
			</cfquery>
		</cfif>

		<cfif LvarEsCancelacion>
		    <cfquery datasource="#session.DSN#">
					update EDocumentosCPR set EVestado = 2
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
					and Ecodigo =  #Session.Ecodigo#
				</cfquery>
		</cfif>

		<cfif LvarEsDevolucion>
		    <cfquery datasource="#session.DSN#">
					update EDocumentosCPR set EVestado = 1
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
					and Ecodigo =  #Session.Ecodigo#
				</cfquery>
				<cfquery datasource="#session.DSN#" name = "rsDocumentoData">
					select * from EDocumentosCPR where
					  IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
				</cfquery>
				<cfquery datasource="#session.DSN#" name = "rsSNdata">
					select SNid, SNcodigo, SNnombre, SNidentificacion, DEidVendedor, DEidCobrador, 
					  SNcuentacxp, SNvenventas, SNvencompras
					  from SNegocios a, EstadoSNegocios b
					  where a.Ecodigo = #Session.Ecodigo#
						and a.ESNid = b.ESNid
						and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDocumentoData.SNcodigo#">
				</cfquery>
				
				<!--- INSERTAR CABECERA NOTA CREDITO --->
				<cfquery datasource="#session.DSN#" name = "rsInsertNCDocumento">
				  insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, Mcodigo, SNcodigo, Ocodigo, Ccuenta, 
					EDtipocambio, EDimpuesto, EDporcdescuento, EDdescuento, EDtotal, EDfecha, EDusuario, EDselect, Interfaz, 
					EDvencimiento, EDfechaarribo, BMUsucodigo, TESRPTCid, TESRPTCietu, EDAdquirir, EDTiEPS) 
					select 
					#Session.Ecodigo#,
					'NC',
					CONCAT('NC_', remision.EDdocumento),
					remision.Mcodigo,
					remision.SNcodigo,
					remision.Ocodigo,
					remision.Ccuenta,
					remision.EDtipocambio,
					remision.EDimpuesto,
					remision.EDporcdescuento,
					remision.EDdescuento,
					remision.EDtotal,
					GETDATE(),
					'#Session.usuario#',
					remision.EDselect,
					remision.Interfaz,
					DATEADD(DAY, #rsSNData.SNvencompras#, GETDATE()),
					GETDATE(),
					#session.Usucodigo#,
					remision.TESRPTCid,
					remision.TESRPTCietu,
					remision.EDAdquirir,
					remision.EDTiEPS
					from EDocumentosCPR remision
					where remision.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
					and remision.Ecodigo =  #Session.Ecodigo#
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertNCDocumento" returnvariable="IdEDocCP">
				
				<!--- INSERTAR DETALLES NOTA CREDITO --->
				<cftransaction>
				<cfquery datasource="#session.DSN#" name = "rsDetallesNC">
				  select ddcpr.linea as lineaDetRem
					from DDocumentosCPR ddcpr
				  where ddcpr.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
				</cfquery>
				
				<cfloop query = "rsDetallesNC">
				    <cfquery datasource="#session.DSN#" name = "rsInsertNCDocDet">
							INSERT INTO DDocumentosCxP
							(IDdocumento, Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta, Aid,
								DOlinea, CFid, DDdescripcion, DDdescalterna, DDcantidad, DDpreciou,
								DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, DDtransito, DDembarque, 
								DDfembarque, DDobservaciones, BMUsucodigo, Icodigo, Ucodigo, OCTtipo, 
								OCTtransporte, OCTfechaPartida, OCTobservaciones, OCCid, OCid, ContractNo, 
								DDimpuestoInterfaz, CFcuenta, CFComplemento, FPAEid, OBOid, PCGDid, 
								DSespecificacuenta, UsucodigoModifica, CPDCid, CTDContid, CambioCF, codIEPS, DDMontoIeps)
								select #IdEDocCP#, ddcpr.Cid, ddcpr.Alm_Aid, ddcpr.Ecodigo, ddcpr.Dcodigo, ddcpr.Ccuenta, ddcpr.Aid,
									ddcpr.DOlinea, ddcpr.CFid, ddcpr.DDdescripcion, ddcpr.DDdescalterna, ddcpr.DDcantidad, ddcpr.DDpreciou,
									ddcpr.DDdesclinea, ddcpr.DDporcdesclin, ddcpr.DDtotallinea, ddcpr.DDtipo, ddcpr.DDtransito, ddcpr.DDembarque, 
									ddcpr.DDfembarque, ddcpr.DDobservaciones, ddcpr.BMUsucodigo, ddcpr.Icodigo, ddcpr.Ucodigo, ddcpr.OCTtipo, 
									ddcpr.OCTtransporte, ddcpr.OCTfechaPartida, ddcpr.OCTobservaciones, ddcpr.OCCid, ddcpr.OCid, ddcpr.ContractNo, 
									ddcpr.DDimpuestoInterfaz, ddcpr.CFcuenta, ddcpr.CFComplemento, ddcpr.FPAEid, ddcpr.OBOid, ddcpr.PCGDid, 
									ddcpr.DSespecificacuenta, ddcpr.UsucodigoModifica, ddcpr.CPDCid, ddcpr.CTDContid, ddcpr.CambioCF, 
									ddcpr.codIEPS, ddcpr.DDMontoIeps
								from DDocumentosCPR ddcpr where ddcpr.linea = #rsDetallesNC.lineaDetRem#
								SELECT SCOPE_IDENTITY() as lineaNC
						</cfquery>
						
						<cfquery datasource="#session.DSN#" name = "rsUpdateNCDocLinea">
						    update DDocumentosCPR set DFacturalinea = #rsInsertNCDocDet.lineaNC#
								where linea = #rsDetallesNC.lineaDetRem#
						</cfquery>
				</cfloop>
				</cftransaction>
		</cfif>
		<!--- Llenar las estructuras de datos de documentos aplicados de Remisión --->
		<cfquery name="PorInsertEDocCP" datasource="#Arguments.Conexion#">
			select
				Ecodigo,CPTcodigo,EDdocumento,SNcodigo,Mcodigo,Ocodigo,EDtipocambio,EDtotal,EDtotal,EDfecha,EDvencimiento,
				Ccuenta,EDtipocambio,EDusuario,	Rcodigo,CFid,Icodigo,TESRPTCid,TESRPTCietu,id_direccion,EDfechaarribo,folio,EDTiEPS,FolioReferencia,
				EDretencionVariable, TimbreFiscal
			from EDocumentosCPR
			where IDdocumento = #Arguments.IDdoc#
		</cfquery>
		<cfif len(trim(#PorInsertEDocCP.EDfechaarribo#))>
			<cfset EDvencimientoADD = dateadd('d',#LvarVencimiento#,'#PorInsertEDocCP.EDfechaarribo#')>
		<cfelse>
			<cfset EDvencimientoADD = dateadd('d',#LvarVencimiento#,'#PorInsertEDocCP.EDfecha#')>
		</cfif>

    <cfquery name="validaImpuesto" datasource="#Arguments.Conexion#">
        	select count(1) cantidad
			  from EDocumentosCPR a
				inner join DDocumentosCPR b
                	on b.IDdocumento = a.IDdocumento
			where a.IDdocumento = #Arguments.IDdoc#
               and (select count(1) from Impuestos where Ecodigo = a.Ecodigo and Icodigo = b.Icodigo) = 0
    </cfquery>
    <cfif validaImpuesto.cantidad>
      <cfthrow message="Existen lineas de la Factura con Impuestos Incorrectos">
    </cfif>

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

		<!---
			Actualiza la cantidad surtida del detalle de la línea de la orden de compra (maximo la cantidad original de la orden de compra).
			Actualiza la cantidad que se recibió de más (en exceso a la cantidad original de la orden de compra).
		--->
		<cfquery name="rsOrdenes" datasource="#Arguments.Conexion#">
			select cp.DOlinea, min(cpt.CPTtipo) as CPTtipo, sum(cp.DDcantidad) as Cantidad, sum(cp.DDtotallinea) as  DDtotallinea
			from DDocumentosCPR cp
				inner join EDocumentosCPR cpe
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

	</cffunction>

</cfcomponent>