<!---
/*
** Posteo de Documentos de Cuentas x Cobrar
** Creado por : Marcel de M.
** Fecha: 14 Enero de 2002
**
**
** Modificado por: Ana Villavicencio
** Fecha: 22 de agosto del 2005
** Motivo: se cambio el proceso de asignacion de la cuenta para el encabezado del
** documento. se quita el case para la cuenta en la inserción del encabezado del documento en INTARC
** esta condicion ya se toma en cuenta en el proceso de registro de documentos.
** Modificado por: Rodolfo Jimenez Jara
** Fecha: 06 de Septiembre del 2005
** Motivo: No debe Contabiliza el  Costo de Ventas ni Ajustes si tiene el parámetro en =1
**
** Transformado a CFcomponente por: Óscar Bonilla
** Fecha: 15 de febrero del 2007
** Motivo:	Incorporación de Proceso de Costo de Ventas Pendientes
**			Incorporación de Procesos de Órdenes Comerciales en Tránsito
*/
--->

<cfcomponent>
	<cffunction name="PosteoDocumento" access="public" returntype="string" output="no">
		<cfargument name='EDid' 		type='numeric' 	required='true'>	 <!--- ID Documento ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='USA_tran' 	type="boolean" 	required='false' default='true'>
		<cfargument name='PintaAsiento' type="boolean" 	required='false' default='false'>
		

		<cfset LvarPintar = Arguments.PintaAsiento>
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
			<cfset CreaTablas(Arguments.Conexion)>
			<cfset CalcularDocumento(Arguments.EDid, false, Arguments.Ecodigo, Arguments.Conexion)>
			<cftransaction>
				<cfset 	PosteoDoc (
							Arguments.EDid,
							Arguments.Ecodigo,
							Arguments.usuario,
							Arguments.debug,
							Arguments.Conexion
				)>
			</cftransaction>
		<cfelse>
			<cfset CalcularDocumento(Arguments.EDid, false, Arguments.Ecodigo, Arguments.Conexion)>
			<cfset 	PosteoDoc (
						Arguments.EDid,
						Arguments.Ecodigo,
						Arguments.usuario,
						Arguments.debug,
						Arguments.Conexion
			)>
		</cfif>
	</cffunction>


	<cffunction name="ValidaCfinaciera" output="no" returntype="string" access="private">
		<cfargument name="IDdoc"    			type="numeric" required="yes">
		<cfargument name="Ecodigo"  			type="numeric" required="yes">
		<cfargument name="Conexion" 			type="string"  required="yes">

		<!---JARR agrega la cuenta financiera correcta en base al concepto de la factura --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			UPDATE
			    TA
			SET
			    TA.Ccuenta = TB.Ccuenta
			FROM
				DDocumentosCxC  AS TA
			    INNER JOIN (
						select DD.Cid,
						--DD.CFcuenta,
						CN.Ccuenta,
						CN.Cformato,
						DD.DDlinea
						from DDocumentosCxC DD
						inner join Conceptos CC
						on CC.Cid =DD.Cid
						inner join CContables CN
						on CN.Cformato=CC.Cformato
						where DD.EDid =#Arguments.IDdoc#
						and DD.Ecodigo=#Arguments.Ecodigo#
						) AS TB
			        ON TB.DDlinea = TA.DDlinea
		</cfquery>
		<!---JARR agrega la cuenta financiera correcta en base al concepto de la factura --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			UPDATE
			    TA
			SET
			    TA.CFcuenta = TB.CFcuenta
			FROM
				DDocumentosCxC  AS TA
			    INNER JOIN (
						select DD.Cid,
						--DD.CFcuenta,
						CF.CFcuenta,
						CF.CFformato,
						DD.DDlinea
						from DDocumentosCxC DD
						inner join Conceptos CC
						on CC.Cid =DD.Cid
						inner join CFinanciera CF
						on CF.CFformato=CC.Cformato
						where DD.EDid =#Arguments.IDdoc#
						and DD.Ecodigo=#Arguments.Ecodigo#
						) AS TB
			        ON TB.DDlinea = TA.DDlinea
		</cfquery>
	</cffunction>
	<cffunction name="PosteoDoc" access="private" returntype="string" output="no">
		<!---- Definición de Parámetros --->
		<cfargument name='EDid' 		type='numeric' 	required='true'>	 <!--- ID Documento ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">

			<!--- Validaciones Preposteo --->
			<!--- JARR UPDATE CFinanciera --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from EDocumentosCxC
				 where EDid = #Arguments.EDid#
			</cfquery>
			<cfif rsSQL.Cantidad EQ 0>
				 <cf_errorCode	code = "50994" msg = "El ID del documento indicado no existe. Verifique que el documento exista!">
			</cfif>

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select count(1) as cantidad
				  from DDocumentosCxC
				 where EDid = #Arguments.EDid#
			</cfquery>
			<cfif rsSQL.Cantidad EQ 0>
				 <cf_errorCode	code = "50995" msg = "El documento indicado no tiene detalles. Proceso Cancelado!">
			</cfif>
			<cfquery name="rsSQLtipo" datasource="#Arguments.Conexion#">
				select CCTcodigo,
						EDusuario
				  from EDocumentosCxC
				 where EDid = #Arguments.EDid#
			</cfquery>
			
			<!--- VAlida usaurio ld y tipo nc para cambiar ccontable y cfinanciera facturas --->
			<cfif rsSQLtipo.CCTcodigo EQ 'NC' and rsSQLtipo.EDusuario eq 'InterfazLD'>
				<cfset ValidaCfinaciera(Arguments.EDid,Arguments.Ecodigo, Arguments.Conexion)>
			</cfif>
			
			<!----Cuenta transitoria general ---->
			<cfset LvarCcuentaTransitoriaGeneral = 0>
			<cfset LvarCFcuentaTransitoriaGeneral = 0>
			<cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
				select count(1) as cantidad
				  from EDocumentosCxC a
					inner join DDocumentosCxC b
						 on b.EDid = a.EDid
					inner join CFuncional cf
						 on cf.CFid 	= b.CFid
				where a.EDid	= #Arguments.EDid#
				  and a.Ecodigo = #Arguments.Ecodigo#
				  and cf.CFACTransitoria = 1
			</cfquery><!--- 
			<cfdump var="#rsCuentaTransitoria#">
			<cfabort> --->
			<cfif rsCuentaTransitoria.cantidad GT 0>
				<cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
					select Pvalor as Cuenta
					  from Parametros
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					   and Mcodigo = 'CG'
					   and Pcodigo = 565
				</cfquery>
				<cfset LvarCcuentaTransitoriaGeneral = rsCuentaTransitoria.Cuenta>
				<cfif isdefined('LvarCcuentaTransitoriaGeneral') and len(trim(#LvarCcuentaTransitoriaGeneral#)) eq 0>
					<cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">
				</cfif>
				<cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
					select min(CFcuenta) as CFcuenta
					  from CFinanciera
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					   and Ccuenta = #LvarCcuentaTransitoriaGeneral#
				</cfquery>
				<cfset LvarCFcuentaTransitoriaGeneral = rsCuentaTransitoria.CFcuenta>
			</cfif>

			<!--- Manejo del DescuentoDoc para calculo de Impuestos --->
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select Pvalor
                from Parametros
                where Ecodigo = #Arguments.Ecodigo#
                  and Pcodigo = 420
            </cfquery>
            <cfset LvarPcodigo420 = rsSQL.Pvalor>
			<cfif LvarPcodigo420 EQ "">
                <cf_errorCode	code = "50996" msg = "No se ha definido el parámetro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
            </cfif>
			<!--- Usar Cuenta de Descuentos en CxC --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo = #session.Ecodigo#
				  and Pcodigo = 421
			</cfquery>
            <cfset LvarPcodigo421 = rsSQL.Pvalor>
			<cfif LvarPcodigo421 EQ "">
                <cf_errorCode	code = "50997" msg = "No se ha definido el parámetro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
            </cfif>

			<cfquery name="rsDoc" datasource="#Arguments.Conexion#">
				select
						 a.CCTcodigo
						,b.CCTtipo
						,a.EDdocumento
						,a.SNcodigo
						,a.Ocodigo
						,a.Mcodigo
						,a.EDtipocambio
						,a.EDfecha
						,month(a.EDfecha) as monthFecha
						,year(a.EDfecha) as yearFecha
						,b.CCTafectacostoventas
						,case when b.CCTvencim < 0 then 1 else 0 end as CCTcontado
						,case when CCTtipo = 'D' then 'S' else 'E' end as TipoES
						<!--- tcFecha, si no se digita se supone la fecha del documento --->
						, coalesce(a.EDtipocambioFecha,a.EDfecha) as tcFecha
						<!--- tcValuacion, si es local=1, si es monedaDoc=tipocambioDoc, si es null se toma de historicos con tcFecha --->
						, coalesce(a.EDtipocambioVal, -1) as tcValuacion
						, EDvencimiento, DEdiasVencimiento
						, coalesce((select Rporcentaje from Retenciones where Ecodigo = a.Ecodigo and Rcodigo = a.Rcodigo), 0) as Retencion
						, coalesce(EDMRetencion, 0) as EDMRetencion
						, coalesce(EDdescuento, 0) as EDdescuento
						, coalesce(EDtotal, 0) as EDtotal
						,a.TESRPTCid 
						,a.TESRPTCietu
                        ,a.TimbreFiscal 
						, (
							select coalesce(sum(DDtotallinea),0.00)
							  from DDocumentosCxC
							 where EDid = a.EDid
						  ) as Subtotal
				from EDocumentosCxC a
					inner join CCTransacciones b
						 on b.Ecodigo	= a.Ecodigo
						and b.CCTcodigo	= a.CCTcodigo
					inner join SNegocios sn
						 on sn.Ecodigo	= a.Ecodigo
						and sn.SNcodigo	= a.SNcodigo
				where a.EDid = #Arguments.EDid#
			</cfquery>

			<cfset LvarInsertarKardex = (rsDoc.CCTafectacostoventas NEQ 'N')>
            <cfset LvarDescuentoDoc = rsDoc.EDdescuento>
            <cfset LvarSubTotalDoc = rsDoc.SubTotal>
            <cfset LvarTotalDoc = rsDoc.EDtotal>
			<cfset LvarRetencion = rsDoc.EDMRetencion>

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

			<cfif rsDoc.Mcodigo EQ LvarMcodigoLocal>
				<cfset LvarTCdocumento = 1>
			<cfelse>
				<cfset LvarTCdocumento = rsDoc.EDtipocambio>
			</cfif>

			<cfinvoke
				component		= "sif.Componentes.IN_PosteoLin"
				method			= "IN_MonedaValuacion"
				returnvariable	= "LvarCOSTOS"

				Ecodigo			= "#Arguments.Ecodigo#"
				tcFecha			= "#rsDoc.tcFecha#"

				McodigoOrigen	= "#rsDoc.Mcodigo#"
				tcOrigen		= "#LvarTCdocumento#"
				tcValuacion		= "#rsDoc.tcValuacion#"

				Conexion		= "#Arguments.Conexion#"
			/>

			<!--- DETERMINACION DE LA FECHA DE VENCIMIENTO --->
			<!---
				Prioriodad:
				1) Si es transaccion de CONTADO
				2) Fecha de Vencimiento del Documento
				3) Días de Vencimiento del Documento
				4) Días de Vencimiento de la Transacción
				5) Días de Vencimiento del Socio de Negocios
				6) Cero días
			--->
			<cfset LvarContado = (rsDoc.CCTcontado EQ "1")>
			<cfif LvarContado>
				<cfset LvarFechaVencimiento	= rsDoc.EDvencimiento>
				<cfset LvarDiasVencimiento	= -1>
			<cfelseif rsDoc.EDvencimiento NEQ "">
				<cfset LvarFechaVencimiento	= rsDoc.EDvencimiento>
				<cfset LvarDiasVencimiento	= abs(datediff('d',rsDoc.EDvencimiento,rsDoc.EDfecha))>
			<cfelseif rsDoc.DEdiasVencimiento NEQ "">
				<cfset LvarDiasVencimiento = rsDoc.DEdiasVencimiento>
				<cfset LvarFechaVencimiento	= dateadd('d', LvarDiasVencimiento, rsDoc.EDfecha)>
			<cfelse>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select coalesce(b.CCTvencim,0) = 0 then coalesce(sn.SNvenventas,0) else b.CCTvencim end as DEdiasVencimiento
					from EDocumentosCxC a
						inner join CCTransacciones b
							 on b.Ecodigo	= a.Ecodigo
							and b.CCTcodigo	= a.CCTcodigo
						inner join SNegocios sn
							 on sn.Ecodigo	= a.Ecodigo
							and sn.SNcodigo	= a.SNcodigo
					where a.EDid = #Arguments.EDid#
				</cfquery>
				<cfset LvarDiasVencimiento = rsSQL.DEdiasVencimiento>
				<cfset LvarFechaVencimiento	= dateadd('d', LvarDiasVencimiento, rsDoc.EDfecha)>
			</cfif>

			<cfset LvarAnoAux 				= fnGetParametro (Arguments.Ecodigo, 50,  "Periodo de Auxiliares",Arguments.Conexion)>
			<cfset LvarMesAux 				= fnGetParametro (Arguments.Ecodigo, 60,  "Mes de Auxiliares",Arguments.Conexion)>
			<cfset LvarCuentaDesc 			= fnGetParametro (Arguments.Ecodigo, 70,  "Cuenta Contable para Descuentos de CxC",Arguments.Conexion)>
			<cfset LvarCuentaCaja			= fnGetParametro (Arguments.Ecodigo, 350, "Cuenta Contable de Caja",Arguments.Conexion)>
			<cfset LvarCostoVentaPendiente 	= fnGetParametro (Arguments.Ecodigo, 490, "Dejar pendiente el Costo de Venta para fin de Mes",Arguments.Conexion, "1")>
			<cfset LvarNoContabiliza		= fnGetParametro (Arguments.Ecodigo, 740, "No Contabilizar ni costo de venta ni ajustes",Arguments.Conexion)>

			
            <!---<cfif isdefined("rsDoc") and rsDoc.EDfecha NEQ "" and ((rsDoc.yearFecha*100) +rsDoc.monthFecha)  gt ((LvarAnoAux*100)+ LvarMesAux)>
				<cfset LvarMesAux = rsDoc.monthFecha>
				<cfset LvarAnoAux = rsDoc.yearFecha>
			</cfif>--->       
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				update  EDocumentosCxC
				   set  EDvencimiento		= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaVencimiento#">
					  , DEdiasVencimiento	= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarDiasVencimiento#">

					  , EDtipocambioFecha	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsDoc.tcFecha#">
					  , EDtipocambioVal		= #LvarCostos.VALUACION.TC#
					  , EDtipocambio		= #LvarTCdocumento#

					  , EDusuario			= '#Arguments.usuario#'
				  where EDid = #Arguments.EDid#
			</cfquery>

			<!--- Llenar las tablas de documentos Posteados e históricos de CxC --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into Documentos
					(
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						Ocodigo,
						SNcodigo,
						Mcodigo,
						Dtipocambio,
						Dtotal,
						Dsaldo,
						Dfecha,
						Dvencimiento,
						Ccuenta,
						Dtcultrev,
						Dusuario,
						Rcodigo,
						Dmontoretori,
						Dtref,
						Ddocref,
						Icodigo,

						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid
						,TESRPTCietu
						,TimbreFiscal
						,EDieps
						,EDMRetencion,
						EDfechacontrarecibo
					)
				select
						Ecodigo,
						CCTcodigo,
						EDdocumento,
						Ocodigo,
						SNcodigo,
						Mcodigo,
						EDtipocambio,
						round(EDtotal-isnull(EDMRetencion,0),2),
						<cfif LvarContado>0.00<cfelse>round(EDtotal-isnull(EDMRetencion,0),2)</cfif>,
						EDfecha,
						EDvencimiento,
						Ccuenta,
						EDtipocambio,
						EDusuario,
						Rcodigo,
						#numberFormat(rsDoc.subtotal*rsDoc.retencion/100,"9.99")#,
						EDtref,
						EDdocref,
						Icodigo,

						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid 
						,TESRPTCietu
						,TimbreFiscal
						,EDieps 
						,isnull(EDMRetencion,0)
						,EDfechacontrarecibo 
				   from EDocumentosCxC
				  where EDid = #Arguments.EDid#
			</cfquery>

			<!--- 2b) Llenar Encabezado de documentos Históricos de CxC --->
			<cfquery name="select" datasource="#Arguments.Conexion#">
					select
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						Ocodigo,
						SNcodigo,
						Mcodigo,
						Dtipocambio,
						Dtotal,
						#rsDoc.EDdescuento# as EDdescuento,
						Dsaldo,
						Dfecha,
						Dvencimiento,
						Ccuenta,
						Dtcultrev,
						Dusuario,
						Rcodigo,
						Dmontoretori,
						Dtref,
						Ddocref,
						Icodigo,
						Dreferencia,
						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid 
						,TESRPTCietu
						,TimbreFiscal
						,EDieps
						,round(isnull(EDMRetencion ,0),2)  as EDMRetencion
						,EDfechacontrarecibo
				 from Documentos
				where Ecodigo 		= #Arguments.Ecodigo#
				  and CCTcodigo		= '#rsDoc.CCTcodigo#'
				  and Ddocumento	= '#rsDoc.EDdocumento#'
				  and SNcodigo		= #rsDoc.SNcodigo#
			</cfquery>

			
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into HDocumentos
					(
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						Ocodigo,
						SNcodigo,
						Mcodigo,
						Dtipocambio,
						Dtotal,
						EDdescuento,
						Dsaldo,
						Dfecha,
						Dvencimiento,
						Ccuenta,
						Dtcultrev,
						Dusuario,
						Rcodigo,
						Dmontoretori,
						Dtref,
						Ddocref,
						Icodigo,
						Dreferencia,
						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid
						,TESRPTCietu
						,TimbreFiscal
						,EDieps
						,EDMRetencion
						,EDfechacontrarecibo
					)
				VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.CCTcodigo#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocumento#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.Ocodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.SNcodigo#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Mcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtipocambio#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dtotal#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.EDdescuento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dsaldo#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dfecha#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dvencimiento#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Ccuenta#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtcultrev#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#select.Dusuario#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Rcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dmontoretori#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Dtref#"             voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocref#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#select.Icodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Dreferencia#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidVendedor#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidCobrador#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasVencimiento#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEordenCompra#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEnumReclamo#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select.DEobservacion#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasMoratorio#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionFact#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionEnvio#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.CFid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.EDtipocambioFecha#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.EDtipocambioVal#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.TESRPTCid#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.TESRPTCietu#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="40"  value="#select.TimbreFiscal#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"	            value="#select.EDieps#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"	            value="#select.EDMRetencion#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.EDfechacontrarecibo#"            voidNull>
				)		
				<cf_dbidentity1 name="rsSQL" datasource="#Arguments.Conexion#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 name="rsSQL" datasource="#Arguments.Conexion#" verificar_transaccion="false" returnvariable="LvarHDid">

			<!--- Se genera un Plan de Pagos preliminar con un solo pago --->
			<cfif rsDoc.CCTtipo EQ 'D'>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					insert into PlanPagos
						(
							Ecodigo, CCTcodigo, Ddocumento, PPnumero,
							PPfecha_vence, PPsaldoant, PPprincipal, PPinteres,
							PPpagoprincipal, PPpagointeres, PPpagomora, Mcodigo
						)
					select
							Ecodigo, CCTcodigo, EDdocumento, 1 AS PPnumero,
							EDfecha, EDtotal, EDtotal, 0 as PPinteres,
							0 as PPpagoprincipal, 0 as PPpagointeres, 0 as PPpagomora,  Mcodigo
					  from EDocumentosCxC
					 where EDid = #Arguments.EDid#
				</cfquery>
			</cfif>

			<!--- 3a) Llenar Detalle de documentos Posteados de CxC --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into DDocumentos
					(
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						CCTRcodigo,
						DRdocumento,
						DDlinea,
						DDtotal,
						DDcodartcon,
						DDcantidad,
						DDpreciou,
						DDcostolin,
						DDdesclinea,
						DDtipo,
						DDescripcion,
						DDdescalterna,
						Alm_Aid,
						Dcodigo,
						Ccuenta, CFcuenta,
						CFid,
						Icodigo,
						OCid, OCTid, OCIid,
						DDid,
						DocrefIM,
						CCTcodigoIM,
						cantdiasmora,
						ContractNo,
                        DcuentaT,
                        DesTransitoria,
                        codIEPS,
						DDMontoIEPS,
						afectaIVA,
						Rcodigo
					)
				select
						a.Ecodigo,
						a.CCTcodigo,
						a.EDdocumento,
						a.CCTcodigo,
						a.EDdocumento,
						(
							select count(1)
							  from DDocumentosCxC
							 where EDid 	= b.EDid
							   and DDlinea <= b.DDlinea
						),
						b.DDtotallinea,
						case when b.Aid is null then b.Cid else b.Aid end,
						b.DDcantidad,
						b.DDpreciou,
						0.00,
						b.DDdesclinea,
						b.DDtipo,
						b.DDdescripcion,
						b.DDdescalterna,
						b.Alm_Aid,
						b.Dcodigo,
						b.Ccuenta, b.CFcuenta,
						b.CFid,
						b.Icodigo,
						b.OCid, b.OCTid, OCIid,
						b.DDlinea,
						b.DocrefIM,
						b.CCTcodigoIM,
						b.cantdiasmora,
						b.ContractNo,
                        case when coalesce(cf.CFACTransitoria,0) = 1
							then coalesce(cf.CFcuentatransitoria,#LvarCFcuentaTransitoriaGeneral#)
						end,
                        cf.CFACTransitoria,
                        b.codIEPS,
                        b.DDMontoIEPS,
                        b.afectaIVA,
                        b.Rcodigo
				from DDocumentosCxC b
					inner join EDocumentosCxC a
						on a.EDid = b.EDid
                    left join CFuncional cf
                        on b.CFid= cf.CFid
                        and b.Ecodigo = cf.Ecodigo
				where b.EDid = #Arguments.EDid#
			</cfquery>

			<!--- 3c) Llenar Detalle de documentos Históricos de CxC --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into HDDocumentos
					(
						HDid,
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						CCTRcodigo,
						DRdocumento,
						DDlinea,
						DDtotal,
						DDcodartcon,
						DDcantidad,
						DDpreciou,
						DDcostolin,
						DDdesclinea,
						DDtipo,
						DDescripcion,
						DDdescalterna,
						Alm_Aid,
						Dcodigo,
						Ccuenta, CFcuenta,
						CFid,
						Icodigo,
						OCid, OCTid, OCIid,
						DDid,
						DocrefIM,
						CCTcodigoIM,
						cantdiasmora,
						ContractNo,
                        DcuentaT,
                        DesTransitoria,
						DDimpuesto,
						DDdescdoc,
						codIEPS,
						DDMontoIEPS,
						afectaIVA,
                        Rcodigo
					)
				select
						#LvarHDid#,
						Ecodigo,
						CCTcodigo,
						Ddocumento,
						CCTRcodigo,
						DRdocumento,
						DDlinea,
						DDtotal,
						DDcodartcon,
						DDcantidad,
						DDpreciou,
						DDcostolin,
						DDdesclinea,
						DDtipo,
						DDescripcion,
						DDdescalterna,
						Alm_Aid,
						Dcodigo,
						Ccuenta, CFcuenta,
						CFid,
						Icodigo,
						OCid, OCTid, OCIid,
						DDid,
						DocrefIM,
						CCTcodigoIM,
						cantdiasmora,
						ContractNo,
                        DcuentaT,
                        DesTransitoria,
							(
								select sum(impuesto)
								  from #CC_calculoLin#
								 where DDid	= d.DDid
							)
						,
							(
								select sum(descuentoDoc)
								  from #CC_calculoLin#
								 where DDid	= d.DDid
							),
						codIEPS,
						DDMontoIEPS,
						afectaIVA,
                        Rcodigo
				  from DDocumentos d
				 where Ecodigo 		= #Arguments.Ecodigo#
				   and CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.CCTcodigo#">
				   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.EDdocumento#">
			</cfquery>

			<!--- 4.d.1. Se inserta la informacion de los Impuestos a la tabla ImpDocumentosCxC --->
			
			<cfquery datasource="#Arguments.Conexion#">
				insert into ImpDocumentosCxC
					(
						Ecodigo, CCTcodigo, Documento,
						Periodo, Mes,
						Icodigo,
						Iporcentaje,
						CcuentaImp,
						TotalFac,
						SubTotalFac,
						MontoBaseCalc,
						MontoCalculado,
						MontoPagado
					)
				select #Arguments.Ecodigo#, '#rsDoc.CCTcodigo#', '#rsDoc.EDdocumento#',
					   #LvarAnoAux#, #LvarMesAux#,
					   dicodigo,
					   avg(porcentaje),
					   min(i.ccuenta),
					   #LvarTotalDoc#	- #LvarRetencion#	as TotalFac,
					   #LvarSubtotalDoc#	as SubTotalFac,
					   sum(montoBase) 		as MontoBaseCalc,
					   sum(impuesto)		as MontoCalculado,
					   0					as MontoPagado
				  from #CC_impLinea# i
				  	inner join EDocumentosCxC e
					   on e.EDid = i.EDid
				 group by dicodigo
			</cfquery>
            <!--- valida si inserta IEPS --->
			<cfquery name="validIEPS" datasource="#Arguments.Conexion#">
				SELECT isnull(sum(IEPS),0)as IEPS 
				from #CC_impLinea#
				where codIEPS != '-1' and codIEPS != '0'
			</cfquery>
			
			<cfif isDefined('validIEPS.IEPS') and validIEPS.IEPS GT 0>
				<cfquery datasource="#Arguments.Conexion#">
					insert into ImpIEPSDocumentosCxC 
						(
							Ecodigo, CCTcodigo, Documento,
							Periodo, Mes,
							codIEPS,
							TipoCalculo,
							ValorCalculo,
							CcuentaIEPS,
							TotalFac,
							SubTotalFac,
							MontoBaseCalc,
							MontoCalculado,
							MontoPagado
						)
					select #Arguments.Ecodigo#, '#rsDoc.CCTcodigo#', '#rsDoc.EDdocumento#',
						   #LvarAnoAux#, #LvarMesAux#,
						   codIEPS,
						   imp.TipoCalculo,
						   imp.ValorCalculo,
						   min(i.IEPSCcuenta),
						   #LvarTotalDoc# - #LvarRetencion#	as TotalFac,
						   #LvarSubtotalDoc#	as SubTotalFac,
						   sum(i.montoBase) - sum(i.IEPS) as MontoBaseCalc,
						   sum(i.IEPS)			as MontoCalculado,
						   0					as MontoPagado
					from #CC_impLinea# i
					  	inner join EDocumentosCxC e
						   	on e.EDid = i.EDid
						left join Impuestos imp
							on imp.Ecodigo = #Arguments.Ecodigo#
							and imp.Icodigo = i.codIEPS
					where i.IEPS != 0
					group by codIEPS, imp.TipoCalculo, imp.ValorCalculo
				</cfquery>
            </cfif>
			<!--- Control Evento Inicia --->
            <!--- Busca la transacción y el documento  --->
            <cfquery name="rsTrx" datasource="#Arguments.Conexion#">
                select a.CCTcodigo, a.EDdocumento,a.SNcodigo from EDocumentosCxC a
                where a.EDid = #Arguments.EDid#
                  and a.Ecodigo = #Arguments.Ecodigo#
            </cfquery>
			<!--- Valido el evento --->
            <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "ValidaEvento"
                Origen			= "CCFC"
                Transaccion		= "#rsTrx.CCTcodigo#"
                Conexion		= "#Arguments.Conexion#"
                Ecodigo			= "#Arguments.Ecodigo#"
                returnvariable	= "varValidaEvento"
                />
			<!--- Genera el número de evento si la transacción genera evento --->
            <cfset varNumeroEvento = "">
            <cfif varValidaEvento GT 0>
                <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_GeneraEvento"
                Origen			= "CCFC"
                Transaccion		= "#rsTrx.CCTcodigo#"
                Documento 		= "#rsTrx.EDdocumento#"
                SocioCodigo		= "#rsTrx.SNcodigo#"
                Conexion		= "#Arguments.Conexion#"
                Ecodigo			= "#Arguments.Ecodigo#"
                returnvariable	= "arNumeroEvento"
                />
                <cfif arNumeroEvento[3] EQ "">
                    <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                </cfif>
                <cfset varNumeroEvento = arNumeroEvento[3]>
            </cfif>
        <!--- Control Evento Fin --->

		<!--- Genera el Asiento Contable --->
        <!--- Costo de Ventas requiere que los datos ya estén en facturas aplicadas: Documentos, DDocumentos, HDocumentos, HDDocumentos  --->
        <cfset 	MovimientosContables (Arguments.EDid,Arguments.Ecodigo,Arguments.usuario,Arguments.debug,Arguments.Conexion,varNumeroEvento)>

        <cfset 	Contabiliza (Arguments.EDid,Arguments.Ecodigo,Arguments.usuario,Arguments.debug,Arguments.Conexion,varNumeroEvento)>



		<!--- Insertar en el Histórico de CxC: BMovimientos (requiere que ya este contabilizado) --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into BMovimientos
				(
					Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, BMfecha, Ccuenta, Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento, BMperiodo, BMmes, Dtcultrev, BMusuario, Rcodigo, BMmontoretori, BMtref, BMdocref, Dtotalloc, Dtotalref, Icodigo, Dreferencia, CFid, TimbreFiscal,EDieps,
					IDcontable
				)
			select
					a.Ecodigo, '#rsDoc.CCTcodigo#', a.Ddocumento, '#rsDoc.CCTcodigo#', a.Ddocumento,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					Ccuenta, Ocodigo, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento, #LvarAnoAux#, #LvarMesAux#, Dtipocambio, Dusuario, Rcodigo, Dmontoretori, Dtref, Ddocref, round(Dtotal * Dtipocambio,2), Dtotal, Icodigo, Dreferencia, CFid, TimbreFiscal,EDieps,
					#LvarIDcontable#
			  from Documentos a
			 where Ecodigo 		= #Arguments.Ecodigo#
			   and CCTcodigo 	= '#rsDoc.CCTcodigo#'
			   and Ddocumento 	= '#rsDoc.EDdocumento#'
		</cfquery>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update HDocumentos
			   set EDperiodo=#LvarAnoAux#, EDmes=#LvarMesAux#, IDcontable=#LvarIDcontable#, EDfechaaplica = #createODBCdate(now())#
			 where Ecodigo 		= #Arguments.Ecodigo#
			   and CCTcodigo 	= '#rsDoc.CCTcodigo#'
			   and Ddocumento 	= '#rsDoc.EDdocumento#'
		</cfquery>

<!---
********************************************
DOCUMENTOS DE COBRO DE INTERESES MORATORIOS:
********************************************
Un Documento de Cobro de Intereses Moratorios es una ND que se le cobra al cliente con los DIAS ADICIONALES
de morosidad de todos aquellos documentos morosos que tenga al momento de generación.  Cada línea de
detalle del Documento de Cobro de Intereses Moratorios es una referencia al Documento Moroso.
--->
		 <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select DocrefIM, CCTcodigoIM, cantdiasmora
					  from DDocumentosCxC
					 where Ecodigo = #Arguments.Ecodigo#
					   and EDid    = #Arguments.EDid#
					   and CCTcodigoIM IS NOT NULL
					   and DocrefIM IS NOT NULL
					   and coalesce(cantdiasmora,0) > 0
		 </cfquery>
<!---
	  DEdiasMoratorio = Dias Calculados de Interes Moratorio
	  Actualiza el Encabezado del Documento Moroso relacionado:
	  a los días ya cobrados se le incrementa los días cobrados
	  con el documento actual
--->
		
		<cfloop query="rsSQL">
			<cfquery datasource="#Arguments.Conexion#">
				update HDocumentos
				   set DEdiasMoratorio = DEdiasMoratorio + #rsSQL.cantdiasmora#
				 where Ddocumento      = '#rsSQL.DocrefIM#'
				   and CCTcodigo       = '#rsSQL.CCTcodigoIM#'
				   and Ecodigo         = #Arguments.Ecodigo#
			</cfquery>
		</cfloop>
		<!--- Eliminar el documento de las Tablas sin Postear --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			delete from DDocumentosCxC
			 where EDid = #Arguments.EDid#
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			delete from EDocumentosCxC
			 where EDid = #Arguments.EDid#
		</cfquery>

		<!--- Actualizar el IDcontable del Kardex --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update Kardex
			   set IDcontable = #LvarIDcontable#
			 where Kid IN
				(
					select Kid
					   from #IDKARDEX#
				)
		</cfquery>

		<cfif #Arguments.debug# EQ 'S'>
			<cftransaction action="rollback" />
		</cfif>
        <cfquery name="validaCE" datasource="#Arguments.Conexion#">
            select ERepositorio from Empresa where Ereferencia=#Arguments.Ecodigo#
        </cfquery>
        <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1>
            <cfquery name="rsDatos" datasource="#session.DSN#">
				SELECT distinct  #LvarIDcontable#, hecc.Ddocumento, dco.Dlinea,
					dco.CEtipoLinea,dco.CEdocumentoOri,dco.CEtranOri,dco.CESNB, sn.SNidentificacion, hecc.Dtotal
                FROM HDocumentos hecc
			    INNER JOIN DContables dco
			        on dco.IDcontable = #LvarIDcontable#
			        and dco.Ddocumento = hecc.Ddocumento
                INNER JOIN SNegocios sn
                    on hecc.SNcodigo = sn.SNcodigo
			    left join SNCCTcuentas snc
			      on hecc.Ecodigo = snc.Ecodigo
			      and hecc.CCTcodigo = snc.CCTcodigo
			      and sn.SNcodigo = snc.SNcodigo
                    and hecc.Ecodigo = sn.Ecodigo
			    where hecc.HDid = #LvarHDid#
			     and (dco.CFcuenta = COALESCE(snc.CFcuenta, sn.CFcuentaCxC) or dco.CFcuenta = COALESCE(sn.CFcuentaCxC,snc.CFcuenta))
				 and dco.CEtipoLinea is not null
            </cfquery>


            <!--- Envía al Repositorio de  CFDI --->
             <cfloop query="rsDatos">
                <cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="RepositorioCFDIs" >
                    <cfinvokeargument name="idDocumento" 	value="#Arguments.EDid#">
                    <cfinvokeargument name="idContable" 	value="#LvarIDcontable#">
                    <cfinvokeargument name="Origen" 		value="CCFC">
                    <cfinvokeargument name="idLineaP" 		value="#rsDatos.Dlinea#">
					<cfinvokeargument name='tipoLinea' 			value="#rsDatos.CEtipoLinea#">
			        <cfinvokeargument name='documentoOri'			value="#rsDatos.CEdocumentoOri#">
			        <cfinvokeargument name='tranOri'				value="#rsDatos.CEtranOri#">
			        <cfinvokeargument name='SNB' 					value="#rsDatos.CESNB#">
			        <cfinvokeargument name='rfc' 			value="#rsDatos.SNidentificacion#">
			        <cfinvokeargument name='total' 			value="#rsDatos.Dtotal#">
			        <cfinvokeargument name="idDocumentoH" 	value="#LvarHDid#">
                </cfinvoke>
            </cfloop>
        </cfif>
	</cffunction>



	<cffunction name="MovimientosContables" access="private" returntype="string" output="no">
		<!---- Definición de Parámetros --->
		<cfargument name='EDid' 		type='numeric' 	required='true'>	 <!--- ID Documento ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
        <cfargument name='NumeroEvento' type='string'   required='no'>

		<!--- 4.a. Débito a Cuenta por Cobrar --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo
					, Mcodigo, INTMOE, INTCAM, INTMON
    				,NumeroEvento,CFid
				<!--- Contabilidad Electronica Inicia --->
					, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
				<!--- Contabilidad Electronica Fin --->
				)
			select
					'CCFC',
					1,
					a.EDdocumento,
					a.CCTcodigo,
					case when b.CCTtipo = 'D' then 'D' else 'C' end,
					<cfif LvarContado>
						<cf_dbfunction name="concat" args="'Transacción Contado ' + c.SNidentificacion"	delimiters="+" conexion="#Arguments.Conexion#">,
					<cfelse>
						<cf_dbfunction name="concat" args="'CxC: Socio ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#">,
					</cfif>
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					a.Ccuenta,
					a.Ocodigo,

					a.Mcodigo,
					a.EDtotal,
					a.EDtipocambio,
					round(a.EDtotal * a.EDtipocambio,2),
    				'#Arguments.NumeroEvento#',a.CFid
				<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CCTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
			from EDocumentosCxC a
				inner join CCTransacciones b
					 on b.Ecodigo = a.Ecodigo
					and b.CCTcodigo = a.CCTcodigo
				inner join SNegocios c
					 on c.Ecodigo = a.Ecodigo
					and c.SNcodigo = a.SNcodigo
			where a.EDid = #Arguments.EDid#
			  and a.Ecodigo = #Arguments.Ecodigo#
			  and a.EDtotal != 0
		</cfquery>

		<cfif LvarPcodigo421 NEQ "I">
			<!--- 4.b. Debito a Cuenta de Descuento del Documento --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into #INTARC#
					(
						INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo
						, Mcodigo, INTMOE, INTCAM, INTMON
    					,NumeroEvento,CFid
					<!--- Contabilidad Electronica Inicia --->
						, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
					<!--- Contabilidad Electronica Fin --->
					)
				select
						'CCFC',
						1,
						a.EDdocumento,
						a.CCTcodigo,
						case when b.CCTtipo = 'D' then 'D' else 'C' end,
						'Descuento al Documento',
						'#dateFormat(now(),"YYYYMMDD")#',
						#LvarAnoAux#,
						#LvarMesAux#,
						#LvarCuentaDesc#,
						a.Ocodigo,

						a.Mcodigo,
						a.EDdescuento,
						a.EDtipocambio,
						round(a.EDdescuento * a.EDtipocambio,2),
    					'#Arguments.NumeroEvento#',a.CFid
					<!--- Contabilidad Electronica Inicia --->
						, 1 <!--- Linea de Gasto u Otro --->
						, a.EDdocumento, a.CCTcodigo, a.SNcodigo
					<!--- Contabilidad Electronica Fin --->
			   from EDocumentosCxC a
					inner join CCTransacciones b
						 on b.Ecodigo	= a.Ecodigo
						and b.CCTcodigo	= a.CCTcodigo
			  where a.EDid		= #Arguments.EDid#
				and a.Ecodigo	= #Arguments.Ecodigo#
				and a.EDdescuento != 0
			</cfquery>
		</cfif>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

		<!--- 4.c. Credito al Ingreso (Detalle Cuenta de Artículos o Servicios) --->
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo
					, Mcodigo, INTMOE, INTCAM, INTMON
    				,NumeroEvento,CFid
				<!--- Contabilidad Electronica Inicia --->
					, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
				<!--- Contabilidad Electronica Fin --->
				)
			select
					'CCFC',
					1,
					a.EDdocumento,
					a.CCTcodigo,
					<cfif rsDoc.CCTtipo EQ "D">'C'<cfelse>'D'</cfif>,
					case
						when b.DDtipo = 'O' then
						   case when coalesce(cf.CFACTransitoria,0) = 1 then
                                <cf_dbfunction name="concat" args="'Cuenta transitoria: '+'OC-D.'+(select OCcontrato from OCordenComercial where OCid = b.OCid)+','+'INGRESO,ART.'+(select rtrim(ltrim(Acodigo))+ ': '+ rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, Adescripcion))) from Articulos where Aid = b.Aid)" delimiters="+">
                            else
                               <cf_dbfunction name="concat" args="'OC-D.'+(select OCcontrato from OCordenComercial where OCid = b.OCid)+','+'INGRESO,ART.'+(select rtrim(ltrim(Acodigo))+ ': '+ rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, Adescripcion))) from Articulos where Aid = b.Aid)" delimiters="+">
                            end
						when b.DDtipo = 'A' then
                           case when coalesce(cf.CFACTransitoria,0) = 1 then
							   <cf_dbfunction name="concat" args="'Cuenta transitoria: '+'Articulo: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select art.Adescripcion from Articulos art where art.Aid = b.Aid ) )))" delimiters="+">
                             else
                              <cf_dbfunction name="concat" args="'Articulo: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select art.Adescripcion from Articulos art where art.Aid = b.Aid ) )))" delimiters="+">
                              end
						when b.DDtipo = 'T' then
                           case when coalesce(cf.CFACTransitoria,0) = 1 then
							   <cf_dbfunction name="concat" args="'Cuenta transitoria: '+ 'Transito: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select art.Adescripcion from Articulos art where art.Aid = b.Aid ) )))" delimiters="+">
                             else
                              <cf_dbfunction name="concat" args="'Transito: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select art.Adescripcion from Articulos art where art.Aid = b.Aid ) )))" delimiters="+">
                             end
						when b.DDtipo = 'S' AND coalesce(rtrim(b.ContractNo),'') <> '' then
                           case when coalesce(cf.CFACTransitoria,0) = 1 then
							  <cf_dbfunction name="concat" args="'Cuenta transitoria: '+ 'OC-D.' + rtrim(b.ContractNo) + ', Concepto: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select con.Cdescripcion from Conceptos con where con.Cid = b.Cid ) )))" delimiters="+">
                            else
                             <cf_dbfunction name="concat" args="'OC-D.' + rtrim(b.ContractNo) + ', Concepto: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select con.Cdescripcion from Conceptos con where con.Cid = b.Cid ) )))" delimiters="+">
                            end
						when b.DDtipo = 'S' then
                           case when coalesce(cf.CFACTransitoria,0) = 1 then
							 <cf_dbfunction name="concat" args="'Cuenta transitoria: '+'Concepto: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select con.Cdescripcion from Conceptos con where con.Cid = b.Cid ) )))" delimiters="+">
                            else
                             <cf_dbfunction name="concat" args="'Concepto: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion, ( select con.Cdescripcion from Conceptos con where con.Cid = b.Cid ) )))" delimiters="+">
                            end
						when b.DDtipo = 'F' then
                            case when coalesce(cf.CFACTransitoria,0) = 1 then
							  <cf_dbfunction name="concat" args="'Cuenta transitoria: '+'Activo: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion )))" delimiters="+">
                            else
                              <cf_dbfunction name="concat" args="'Activo: ' + rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion )))" delimiters="+">
                            end
						else
                           case when coalesce(cf.CFACTransitoria,0) = 1 then
							'Cuenta transitoria: ' #_Cat# rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion)))
                           else
                             rtrim(ltrim(coalesce(b.DDdescalterna, b.DDdescripcion)))
                           end

					end,
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					case when coalesce(cf.CFACTransitoria,0) = 1
						then coalesce((select Ccuenta from CFinanciera where CFcuenta=cf.CFcuentatransitoria),#LvarCcuentaTransitoriaGeneral#)
						else b.Ccuenta
					end,
					case when coalesce(cf.CFACTransitoria,0) = 1
						then coalesce(cf.CFcuentatransitoria,#LvarCFcuentaTransitoriaGeneral#)
						else b.CFcuenta
					end,
					coalesce(cf.Ocodigo, a.Ocodigo),
					a.Mcodigo,
					cal.ingresoLinea + cal.descuentoDoc,
					a.EDtipocambio,
					round((cal.ingresoLinea+cal.descuentoDoc)*a.EDtipocambio,2),
    				'#Arguments.NumeroEvento#',a.CFid
				<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CCTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
			from EDocumentosCxC a
					inner join DDocumentosCxC b
						inner join #request.CC_calculoLin# cal
						   on cal.EDid = b.EDid
						  and cal.DDid = b.DDlinea
						 left join CFuncional cf
						   on cf.Ecodigo 	= b.Ecodigo
						  and cf.CFid 		= b.CFid
					   on b.EDid = a.EDid
					  and b.DDtipo in ('A','S','O')
					  and b.DDtotallinea != 0
					inner join CCTransacciones c
					   on c.Ecodigo		= a.Ecodigo
					  and c.CCTcodigo	= a.CCTcodigo
			where a.EDid	= #Arguments.EDid#
			  and a.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<!--- 4.d. Procesa Impuestos JARR---RETENCIONES--->
		

			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo,
									Mcodigo, INTMOE, INTCAM, INTMON
    								,NumeroEvento,CFid 
                                 )
			select
					'CCFC',
					1,
					'#rsDoc.EDdocumento#',
					'#rsDoc.CCTcodigo#',
					'D',
					'Retención:'+ r.Icodigo +'-'+  r.Idescripcion,
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#, #LvarMesAux#,
					r.CcuentaCxC ,
					f.CFcuenta,
					#rsDoc.Ocodigo#,
					#rsDoc.Mcodigo#,
					sum( round( ((isnull(dc.DDCantidad,0) * isnull(dc.DDPreciou,0)) - isnull(dc.DDdesclinea,0)) * (isnull(r.Iporcentaje,0) / 100) ,2) ) as sumRetencion,
					#rsDoc.EDtipoCambio#,
					sum(round( round( ((isnull(dc.DDCantidad,0) * isnull(dc.DDPreciou,0)) - isnull(dc.DDdesclinea,0)) * (isnull(r.Iporcentaje,0) / 100) ,2)*#rsDoc.EDtipoCambio#,2) ) as sumRetencion,
    				'#Arguments.NumeroEvento#',dc.CFid
				from DDocumentosCxC dc
					inner join IMPUESTOS r
						on dc.Rcodigo = r.Icodigo
						and r.Ecodigo = dc.Ecodigo
						and r.IRetencion=1
					left outer join CFinanciera f
						on f.CCuenta = r.CcuentaCxC
						and f.Ecodigo = dc.Ecodigo
					where dc.Rcodigo is not null
					and dc.EDid = #Arguments.EDid#
					and dc.Ecodigo= #Arguments.Ecodigo#
				group by r.CcuentaCxC , r.Icodigo, r.Idescripcion,f.CFcuenta,dc.CFid
			</cfquery>
			<!--- JARR obtenemos el total de la retencion--->
			<cfquery name="rsSQL1" datasource="#Arguments.Conexion#">
			select sum( round( ((isnull(dc.DDCantidad,0) * isnull(dc.DDPreciou,0)) - isnull(dc.DDdesclinea,0)) * (isnull(r.Iporcentaje,0) / 100) ,2) ) as sumRetencion
				from DDocumentosCxC dc
					inner join IMPUESTOS r
						on dc.Rcodigo = r.Icodigo
						and r.Ecodigo = dc.Ecodigo
						and r.IRetencion=1
					left outer join CFinanciera f
						on f.CCuenta=r.CcuentaCxC
						and f.Ecodigo = dc.Ecodigo
					where dc.Rcodigo is not null
					and dc.EDid = #Arguments.EDid#
					and dc.Ecodigo= #Arguments.Ecodigo#
			</cfquery>

		<cfset LvarSUMret = rsSQL1.sumRetencion>

		<!--- 4.d.2. Credito a Impuestos --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo,
									Mcodigo, INTMOE, INTCAM, INTMON
    								,NumeroEvento,CFid 
                                 )
			select
					'CCFC',
					1,
					'#rsDoc.EDdocumento#',
					'#rsDoc.CCTcodigo#',
					<cfif rsDoc.CCTtipo EQ "D">'C'<cfelse>'D'</cfif>,
					i.descripcion,
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#, #LvarMesAux#,
					i.ccuenta, i.CFcuenta,
					#rsDoc.Ocodigo#,
					#rsDoc.Mcodigo#,
					sum(i.impuesto),
					#rsDoc.EDtipoCambio#,
					sum(round(i.impuesto*#rsDoc.EDtipoCambio#,2)),
    				'#Arguments.NumeroEvento#',e.CFid
			from #CC_impLinea# i
            inner join DDocumentosCxC e
               on e.EDid=i.EDid and i.DDid=e.DDlinea and i.ecodigo=e.Ecodigo
			group by
					i.descripcion, i.ccuenta,i.CFcuenta,e.NumeroEvento,e.CFid
	<!--- Control Evento Fin --->
		</cfquery>
		<!--- Si linea Socio Retenciones si el doc tiene retencion--->
		<cfif LvarSUMret GT 0>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo
					, Mcodigo, INTMOE, INTCAM, INTMON
    				,NumeroEvento,CFid
				<!--- Contabilidad Electronica Inicia --->
					, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
				<!--- Contabilidad Electronica Fin --->
				)
			select
					'CCFC',
					1,
					a.EDdocumento,
					a.CCTcodigo,
					'C',
					<cf_dbfunction name="concat" args="'CxC: Socio ' + c.SNidentificacion" delimiters="+" conexion="#Arguments.Conexion#">,
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#,
					#LvarMesAux#,
					a.Ccuenta,
					a.Ocodigo,
					a.Mcodigo,
					#LvarSUMret#,
					a.EDtipocambio,
					round(#LvarSUMret# * a.EDtipocambio,2),
    				'#Arguments.NumeroEvento#',a.CFid
				<!--- Contabilidad Electronica Inicia --->
					, 1 <!--- Linea de Gasto u Otro --->
					, a.EDdocumento, a.CCTcodigo, a.SNcodigo
				<!--- Contabilidad Electronica Fin --->
				from EDocumentosCxC a
					inner join CCTransacciones b
						 on b.Ecodigo = a.Ecodigo
						and b.CCTcodigo = a.CCTcodigo
					inner join SNegocios c
						 on c.Ecodigo = a.Ecodigo
						and c.SNcodigo = a.SNcodigo
				where a.EDid = #Arguments.EDid#
				  and a.Ecodigo = #Arguments.Ecodigo#
				  and a.EDtotal != 0
			</cfquery>
		</cfif>
		<!--- Termina linea Socio Retenciones si el doc tiene retencion--->

		<!--- <cf_dumptable var="#INTARC#"> --->
		<cfquery name="rsValidaIEPS" datasource="#Arguments.Conexion#">
		select count(1) from #CC_impLinea# i
            inner join DDocumentosCxC e
               on e.EDid=i.EDid and i.DDid=e.DDlinea and i.ecodigo=e.Ecodigo
			group by  
					i.descripcion, i.ccuenta,i.CFcuenta,e.NumeroEvento,e.CFid
		</cfquery>
		<cfif rsValidaIEPS.recordCount GT 0>
				<!--- 4.d.2. Credito a Impuestos --->
	<!--- IEPS --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo, 
									Mcodigo, INTMOE, INTCAM, INTMON
    								,NumeroEvento,CFid 
                                 )
			select  'CCFC',
					1,
					'#rsDoc.EDdocumento#', 
					'#rsDoc.CCTcodigo#',
					<cfif rsDoc.CCTtipo EQ "D">'C'<cfelse>'D'</cfif>,
					imp.Idescripcion,
					'#dateFormat(now(),"YYYYMMDD")#',
					#LvarAnoAux#, #LvarMesAux#,
					i.IEPSCcuenta, i.IEPSCFcuenta,
					#rsDoc.Ocodigo#, 
					#rsDoc.Mcodigo#,
					sum(i.IEPS),
					#rsDoc.EDtipoCambio#, 
					sum(round(i.IEPS*#rsDoc.EDtipoCambio#,2)),
    				'#Arguments.NumeroEvento#',e.CFid
			from #CC_impLinea# i
            inner join DDocumentosCxC e
               on e.EDid=i.EDid and i.DDid=e.DDlinea and i.ecodigo=e.Ecodigo
            inner join Impuestos imp
            	on e.codIEPS = imp.Icodigo and i.ecodigo = imp.Ecodigo
            group by e.codIEPS, i.IEPSCcuenta, i.IEPSCFcuenta, imp.Idescripcion, e.CFid 
		</cfquery>
		</cfif>
		<!--- 5) Registrar movimiento de Ingreso en Ordenes Comerciales --->
		<cfset LobjOC.OC_Aplica_Ingreso(#Arguments.Ecodigo#, #Arguments.EDid#, #LvarAnoAux#, #LvarMesAux#, Arguments.Conexion)>

		<!--- 6) Costo de Ventas --->
		<cfif LvarCostoVentaPendiente EQ "0">
			<!--- COSTO VENTAS Articulos --->
			<cfset CxC_AplicaCostoVenta (Arguments.Ecodigo, rsDoc.CCTcodigo, rsDoc.EDdocumento, LvarAnoAux, LvarMesAux, Arguments.Conexion, Arguments.NumeroEvento)>
			<!--- COSTO VENTAS Ordenes Comerciales --->
			<cfset LobjOC.OC_Aplica_CostoVenta (Arguments.Ecodigo, rsDoc.CCTcodigo, rsDoc.EDdocumento, LvarAnoAux, LvarMesAux, Arguments.Conexion)>
		<cfelse>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				insert into CCVProducto
					(
						Ecodigo, CCTcodigo,  Ddocumento,
						SNcodigo,  Dfecha,   CCVPusuario, CCVPfecha,
						Aid, Alm_Aid, Ocodigo, Dcodigo,
						CCVPcantidad, CCVPpreciouloc, CCVPpreciouori,
						CCVPestado, CCVPperiodo, CCVPmes,

						DDtipo
					)
				select	a.Ecodigo, a.CCTcodigo, a.Ddocumento,
						a.SNcodigo, a.Dfecha, a.Dusuario,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						b.DDcodartcon, b.Alm_Aid, a.Ocodigo, b.Dcodigo,
						b.DDcantidad,
						round(b.DDtotal*a.Dtipocambio,2),
						b.DDtotal,
						0, #LvarAnoAux#, #LvarMesAux#,

						b.DDtipo
				from DDocumentos b
					inner join Documentos a
						on a.Ecodigo	= b.Ecodigo
					   and a.CCTcodigo	= b.CCTcodigo
					   and a.Ddocumento	= b.Ddocumento
				where b.Ecodigo		= #Arguments.Ecodigo#
				  and b.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.CCTcodigo#">
				  and b.Ddocumento	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDoc.EDdocumento#">
				  and b.DDtipo 		in ('A','O')
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="Contabiliza" access="private" returntype="string" output="no">
		<!---- Definición de Parámetros --->
		<cfargument name='EDid' 		type='numeric' 	required='true'>	 <!--- ID Documento ---->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='usuario' 		type='string' 	required='true'>	 <!--- Codigo del usuario ---->
		<cfargument name='debug' 		type='string' 	required='false' default	= "N">	 <!--- Ejecutra el debug S= si  N= no---->
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
<!--- Control Evento Inicia --->
        <cfargument name='NumeroEvento' type='string' required='false'>
<!--- Control Evento Fin --->

<!---<cf_dump var="#Arguments.NumeroEvento#">--->

		<!--- Genera el Asiento Contable --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
			<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
			<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
			<cfinvokeargument name="Efecha"			value="#rsDOC.EDfecha#"/>
			<cfinvokeargument name="Oorigen"		value="CCFC"/>
			<cfinvokeargument name="Edocbase"		value="#rsDoc.EDdocumento#"/>
			<cfinvokeargument name="Ereferencia"	value="#rsDoc.CCTcodigo#"/>
			<cfinvokeargument name="Edescripcion"	value="Documento de CxC: #rsDoc.EDdocumento#"/>
			<cfinvokeargument name="Ocodigo"		value="#rsDoc.Ocodigo#"/>
			<cfinvokeargument name="PintaAsiento"	value="#LvarPintar#"/>
<!--- Control Evento Inicia --->
        	<cfinvokeargument name='NumeroEvento' 	value="#Arguments.NumeroEvento#"/>
<!--- Control Evento Fin --->

		</cfinvoke>
	</cffunction>

	<cffunction name="CreaTablas" access="public" returntype="void" output="no">
		<cfargument name="Conexion" type="string" required="yes">

		<cf_dbtemp name="CC_impLin2" returnvariable="CC_impLinea" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="EDid"    	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="DDid"    			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ccuenta"   			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CFcuenta"   		type="numeric">
			<cf_dbtempcol name="ecodigo"    		type="integer"  mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="dicodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="descripcion"   		type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="montoBase"   	 	type="money"  	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float"  	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="IEPS"    			type="money"  	mandatory="no"><!--- cambio ieps --->
			<cf_dbtempcol name="ValorCalculo"		type="numeric" 	mandatory="no">
			<cf_dbtempcol name="TipoCalculo"  		type="integer" 	mandatory="no">
			<cf_dbtempcol name="afectaIVA" 			type="integer" 	mandatory="no">
			<cf_dbtempcol name="IEPSCcuenta"   		type="numeric"  mandatory="no">
			<cf_dbtempcol name="IEPSCFcuenta"   	type="numeric"  mandatory="no"> 
			<cf_dbtempcol name="codIEPS" 			type="varchar(5)" 	mandatory="no"><!--- FIN CAMBIO IEPS --->
			<cf_dbtempcol name="icompuesto"    		type="integer"  mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
		</cf_dbtemp>

		<cf_dbtemp name="CC_calLin1" returnvariable="CC_calculoLin" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="EDid"    	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="DDid"    			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="subtotalLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuestoBase"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="yes">
			<cf_dbtempcol name="IEPS"    			type="money"  	mandatory="no">	<!--- cambio ieps --->
			<cf_dbtempcol name="impuestoInterfaz" 	type="money"  	mandatory="no">
			<cf_dbtempcol name="ingresoLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="totalLinea"	    	type="money"  	mandatory="yes">
		</cf_dbtemp>

		<cfset request.CC_impLinea		= CC_impLinea>
		<cfset request.CC_calculoLin	= CC_calculoLin>

 		<cfset LobjOC 		= createObject( "component","sif.oc.Componentes.OC_transito")>
		<cfset LobjINV 		= createObject( "component","sif.Componentes.IN_PosteoLin")>
		<cfset LobjPRES 	= createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>

		<cfset INTARC 		= LobjCONTA.CreaIntarc(Arguments.Conexion)>
		<cfset INTPRES 		= LobjPRES.CreaTablaIntPresupuesto(Arguments.Conexion)>
		<cfset IDKARDEX 	= LobjINV.CreaIdKardex(Arguments.Conexion)>
		<cfset OC_DETALLE 	= LobjOC.OC_CreaTablas(Arguments.Conexion)>
	</cffunction>

	<cffunction name="CxC_AplicaCostoVenta" access	= "private" returntype	= "string" output	= "no">
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='CCTcodigo'	type='string' 	required='true'>	 <!--- Codigo del movimiento---->
		<cfargument name='Ddocumento'	type='string' 	required='true'>	 <!--- Numero Documento---->
		<cfargument name="Periodo"		type="numeric"	required="yes">
		<cfargument name="Mes"			type="numeric"	required="yes">

		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
        <cfargument name='NumeroEvento' type='string' required='no'>

		<cfif NOT isdefined("LvarNoContabiliza")>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 740
			</cfquery>
			<cfset LvarNoContabiliza = rsSQL.Pvalor>

			<cfset INTARC 		= request.INTARC>
			<cfset INTPRES 		= request.INTPRESUPUESTO>
			<cfset IDKARDEX 	= request.IDKARDEX>
			<cfset OC_DETALLE 	= request.OC_DETALLE>
		</cfif>

		<cfquery name = "rsEDocumentoCxC" datasource="#Arguments.Conexion#">
			select e.Mcodigo, e.Dtipocambio, e.Ocodigo
				 , coalesce (e.EDtipocambioVal, e.Dtipocambio) 	as tcValuacion
				 , coalesce (e.EDtipocambioFecha, e.Dfecha)		as tcFecha
				 , t.CCTtipo, t.CCTafectacostoventas
			  from Documentos e
					inner join CCTransacciones t
					   on t.CCTcodigo = e.CCTcodigo
			 where e.Ecodigo 	= <cfqueryparam cfsqltype	= "cf_sql_integer" value	= "#Arguments.Ecodigo#">
			   and e.CCTcodigo 	= <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.CCTcodigo#">
			   and e.Ddocumento = <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.Ddocumento#">
		</cfquery>

		<cfif rsEDocumentoCxC.CCTtipo EQ "D">
			<cfset LvarTipoES = "S">
		<cfelse>
			<cfset LvarTipoES = "E">
		</cfif>

		<cfif rsEDocumentoCxC.CCTafectacostoventas EQ 0>
			<cfset LvarKardex = true>
		<cfelse>
			<cfset LvarKardex = false>
		</cfif>

		<!---
			1. COSTO VENTAS ARTICULOS
				Actualiza Inventarios

				DB Inventario
					CR Costo Ventas
		--->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from DDocumentos d
			 where d.Ecodigo 	= <cfqueryparam cfsqltype	= "cf_sql_integer" value	= "#Arguments.Ecodigo#">
			   and d.CCTcodigo 	= <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.CCTcodigo#">
			   and d.Ddocumento = <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.Ddocumento#">
			   and d.DDtipo = 'A'
		</cfquery>

		<cfif rsSQL.cantidad GT 0>
			<cfquery name="rsArticulos" datasource="#Arguments.Conexion#">
				select
						d.DDcodartcon as Aid, d.Alm_Aid
						, d.DDlinea, d.Dcodigo
						, d.DDcantidad, t.CCTtipo, t.CCTafectacostoventas
				  from DDocumentos d
						inner join Documentos e
							inner join CCTransacciones t
							   on t.CCTcodigo = e.CCTcodigo
						   on e.Ecodigo		= d.Ecodigo
						  and e.CCTcodigo	= d.CCTcodigo
						  and e.Ddocumento	= d.Ddocumento
				 where d.Ecodigo 	= <cfqueryparam cfsqltype	= "cf_sql_integer" value	= "#Arguments.Ecodigo#">
				   and d.CCTcodigo 	= <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.CCTcodigo#">
				   and d.Ddocumento = <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.Ddocumento#">
				   and d.DDtipo = 'A'
			</cfquery>
			<cfloop query="rsArticulos">
				<cfif LvarTipoES EQ "S">
					<cfset LvarObtenerCosto	= true>
					<cfset LvarCostoOrigen	= 0>
					<cfset LvarCostoLocal	= 0>
				<cfelse>
					<!---
					<cf_errorCode	code = "50998" msg = "No se ha implementado notas de credito a inventarios">
					<cfset LvarObtenerCosto	= false>
					<cfset LvarCostoOrigen	= CostoOriginalDeLaVenta>
					<cfset LvarCostoLocal	= CostoOriginalDeLaVenta*rsEDocumentoCxC.Dtipocambio>
					--->
					<cfset LvarObtenerCosto	= true>
					<cfset LvarCostoOrigen	= 0>
					<cfset LvarCostoLocal	= 0>
				</cfif>

                <!---►►Se agrega la Solida al Kardex◄◄--->
				<cfinvoke component="sif.Componentes.IN_PosteoLin"  method="IN_PosteoLin"  returnvariable="LvarCOSTOS">
               		<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
					<cfinvokeargument name="Aid" 				value="#rsArticulos.Aid#">
					<cfinvokeargument name="Alm_Aid" 			value="#rsArticulos.Alm_Aid#">
					<cfinvokeargument name="Tipo_Mov" 			value="S">
					<cfinvokeargument name="Tipo_ES" 			value="#LvarTipoES#">
					<cfinvokeargument name="Cantidad" 			value="#rsArticulos.DDcantidad#">
					<cfinvokeargument name="ObtenerCosto" 		value="#LvarObtenerCosto#">
					<cfinvokeargument name="CostoOrigen" 		value="#LvarCostoOrigen#">
					<cfinvokeargument name="CostoLocal" 		value="#LvarCostoLocal#">
					<cfinvokeargument name="McodigoOrigen" 		value="#rsEDocumentoCxC.Mcodigo#">
					<cfinvokeargument name="tcOrigen" 			value="#rsEDocumentoCxC.Dtipocambio#">
					<cfinvokeargument name="tcValuacion" 		value="#rsEDocumentoCxC.tcValuacion#">
					<cfinvokeargument name="FechaDoc" 			value="#rsEDocumentoCxC.tcFecha#">
					<cfinvokeargument name="Dcodigo" 			value="#rsArticulos.Dcodigo#">
					<cfinvokeargument name="Ocodigo" 			value="#rsEDocumentoCxC.Ocodigo#">
					<cfinvokeargument name="TipoCambio" 		value="1">
					<cfinvokeargument name="Referencia" 		value="CxC">
					<cfinvokeargument name="TipoDoc" 			value="#Arguments.CCTcodigo#">
					<cfinvokeargument name="Documento" 			value="#Arguments.Ddocumento#">
					<cfinvokeargument name="insertarEnKardex" 	value="#LvarKardex#">
                    <cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#">
					<cfinvokeargument name="Debug" 				value="false">
					<cfinvokeargument name="transaccionactiva" 	value="true">
					<cfinvokeargument name="usucodigo" 	value="1">
                </cfinvoke>

				<cfif LvarTipoES EQ "S">
					<cfset LvarCOSTOS.VALUACION.Costo 	= -(LvarCOSTOS.VALUACION.Costo)>
					<cfset LvarCOSTOS.LOCAL.Costo 		= -(LvarCOSTOS.LOCAL.Costo)>
				</cfif>
				<cfset LvarCOSTOS.ORIGEN.Costo 		= round(LvarCOSTOS.LOCAL.Costo / rsEDocumentoCxC.Dtipocambio * 100) / 100>

				<!--- Actualizar el Costo de Linea en la tabla del Detalle del Documento de CxC (EN MONDEDA LOCAL) --->
				<cfquery datasource="#Arguments.Conexion#">
					update DDocumentos
					   set DDcostolin = #LvarCOSTOS.VALUACION.Costo#
					 where Ecodigo 		= <cfqueryparam cfsqltype	= "cf_sql_integer" value	= "#Arguments.Ecodigo#">
					   and CCTcodigo	= <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.CCTcodigo#">
					   and Ddocumento 	= <cfqueryparam cfsqltype	= "cf_sql_varchar" value	= "#Arguments.Ddocumento#">
					   and DDlinea 		= #rsArticulos.DDlinea#
				</cfquery>
				<!--- <cf_dump var="#Arguments#"> --->
				<cfif LvarNoContabiliza EQ "0">
					<!--- Débito a Inventario (Articulos) (EN MONDEDA DE VALUACION) --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
							Mcodigo, INTMOE, INTCAM, INTMON, NumeroEvento
						)
						select
							'CCFC',
							1,
							'#Arguments.Ddocumento#',
							'#Arguments.CCTcodigo#',
							<cfif LvarTipoES EQ "S">'D'<cfelse>'C'</cfif>,
							'Inventario Artículo ' + a.Acodigo,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							#Arguments.Periodo#,
							#Arguments.Mes#,
							c.IACinventario,
							#rsEDocumentoCxC.Ocodigo#,
							#LvarCOSTOS.VALUACION.Mcodigo#,
							#LvarCOSTOS.VALUACION.Costo#,
							#LvarCOSTOS.VALUACION.TC#,
							#LvarCOSTOS.LOCAL.Costo#,
							<cfif #Arguments.NumeroEvento# EQ ''>null<cfelse>#Arguments.NumeroEvento#</cfif>
						from Existencias e
							inner join Articulos a
								on a.Aid = e.Aid
							inner join IAContables c
								on c.IACcodigo = e.IACcodigo
						where e.Aid 	= #rsArticulos.Aid#
						  and e.Alm_Aid = #rsArticulos.Alm_Aid#
					</cfquery>

					<!--- Crédito a Costo de Ventas (Articulos) (EN MONDEDA DE VALUACION) --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
							Mcodigo, INTMOE, INTCAM, INTMON, NumeroEvento
						)
						select
							'CCFC',
							1,
							'#Arguments.Ddocumento#',
							'#Arguments.CCTcodigo#',
							<cfif LvarTipoES EQ "S">'C'<cfelse>'D'</cfif>,
							'Costo Venta Artículo ' + a.Acodigo,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
							#Arguments.Periodo#,
							#Arguments.Mes#,
							c.IACcostoventa,
							#rsEDocumentoCxC.Ocodigo#,
							#LvarCOSTOS.VALUACION.Mcodigo#,
							#LvarCOSTOS.VALUACION.Costo#,
							#LvarCOSTOS.VALUACION.TC#,
							#LvarCOSTOS.LOCAL.Costo#,
                            <cfif #Arguments.NumeroEvento# EQ ''>null<cfelse>#Arguments.NumeroEvento#</cfif>
						from Existencias e
							inner join Articulos a
								on a.Aid = e.Aid
							inner join IAContables c
								on c.IACcodigo = e.IACcodigo
						where e.Aid 	= #rsArticulos.Aid#
						  and e.Alm_Aid = #rsArticulos.Alm_Aid#
					</cfquery>
				</cfif>
			</cfloop>
		</cfif> <!--- Fin COSTO VENTAS ARTICULOS --->
	</cffunction>

	<cffunction name="fnGetParametro" returntype="string" access="private">
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name='Pcodigo'		type='string' 	required='true'>
		<cfargument name='Pdescripcion'	type='string' 	required='true'>
		<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
		<cfargument name='Pdefault'		type='string' 	required='no' default="°°">

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = #Arguments.Pcodigo#
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cfif Arguments.Pdefault EQ "°°">
				<cf_errorCode	code = "50999"
								msg  = "No se ha definido el Parámetro: @errorDat_1@ - @errorDat_2@"
								errorDat_1="#Arguments.Pcodigo#"
								errorDat_2="#Arguments.Pdescripcion#"
				>
			<cfelse>
				<cfreturn Arguments.Pdefault>
			</cfif>
		</cfif>
		<cfreturn rsSQL.Pvalor>
	</cffunction>

	<cffunction name="CxC_AplicaCostoVenta_Pendientes" access	= "public" returntype="void" output="no">
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
		<cfargument name="Periodo"			type="numeric"	required="yes">
		<cfargument name="Mes"				type="numeric"	required="yes">
		<cfargument name="CCTcodigo"		type="string"	required="yes">
		<cfargument name="Ddocumento"		type="string"	required="yes">

		<cfargument name='Conexion' 		type='string' 	required='false' default	= "#Session.DSN#">

		<cfquery name="rsCCVProductoP" datasource="#Arguments.Conexion#">
			select distinct cv.CCTcodigo, cv.Ddocumento, coalesce(dd.EDtipocambioFecha, dd.Dfecha) as Fecha, dd.Ocodigo
			  from CCVProducto cv
				inner join DDocumentos cc
					inner join Documentos dd
						 on dd.Ecodigo		= cc.Ecodigo
						and dd.CCTcodigo	= cc.CCTcodigo
						and dd.Ddocumento	= cc.Ddocumento
					on cc.Ecodigo	 	= cv.Ecodigo
				   and cc.CCTcodigo	 	= cv.CCTcodigo
				   and cc.Ddocumento 	= cv.Ddocumento
				   and cc.DDtipo 		= cv.DDtipo
				   and cc.DDcodartcon	= cv.Aid
			 where cv.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			   and cv.DDtipo 		= 'A'		<!--- Articulos --->
			   and cv.CCVPestado	= 0			<!--- Pendientes --->
			<cfif Arguments.Ddocumento NEQ "">
			   and cv.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
			   and cv.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
			</cfif>
		</cfquery>

		<cfloop query="rsCCVProductoP">
			<cftransaction>
				<cftry>
					<cfset CxC_AplicaCostoVenta (Arguments.Ecodigo, rsCCVProductoP.CCTcodigo, rsCCVProductoP.Ddocumento, Arguments.Periodo, Arguments.Mes, Arguments.Conexion)>

					<!--- Genera el Asiento Contable --->
					<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento"
								method			= "GeneraAsiento"
								returnvariable	= "LvarIDcontable"
					>
						<cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
						<cfinvokeargument name="Eperiodo"		value="#Arguments.Periodo#"/>
						<cfinvokeargument name="Emes"			value="#Arguments.Mes#"/>
						<cfinvokeargument name="Efecha"			value="#rsCCVProductoP.Fecha#"/>
						<cfinvokeargument name="Oorigen"		value="CCCV"/>
						<cfinvokeargument name="Edocbase"		value="#rsCCVProductoP.Ddocumento#"/>
						<cfinvokeargument name="Ereferencia"	value="rsCCVProductoP.CCTcodigo"/>
						<cfinvokeargument name="Edescripcion"	value="Costo de Ventas Pendientes CxC de Inventarios"/>
						<cfinvokeargument name="Ocodigo"		value="#rsCCVProductoP.Ocodigo#"/>
					</cfinvoke>

					<cfquery datasource="#Arguments.conexion#">
						update CCVProducto
						   set 	CCVPestado	= 1,
						   		CCVPmsg		= 'OK'
						 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						   and CCTcodigo	= '#rsCCVProductoP.CCTcodigo#'
						   and Ddocumento 	= '#rsCCVProductoP.Ddocumento#'
						   and DDtipo 		= 'A'		<!--- Articulos de Inventario --->
						   and CCVPestado	= 0			<!--- Pendientes --->
					</cfquery>

					<!--- Actualizar el IDcontable del Kardex --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						update Kardex
						   set IDcontable = #LvarIDcontable#
						where Kid IN
							(
								select Kid
								   from #request.IDKARDEX#
							)
					</cfquery>
				<cfcatch type="any">
					<cftransaction action="rollback"/>
					<cfif Arguments.Ddocumento NEQ "">
						<cfrethrow>
					</cfif>
					<cfset LvarMSG = cfcatch.Message>
					<cftry>
						<cfinvoke component="home.public.error.stack_trace" method="fnGetStackTrace" LprmError="#cfcatch#" returnvariable="LvarError"></cfinvoke>
						<cfset LvarPto1 = find(" at /", LvarError)>
						<cfset LvarPto2 = find(".cf",LvarError,LvarPto1)>
						<cfset LvarPto3 = find(" ",LvarError,LvarPto2)>
						<cfset LvarError = "(" & mid(LvarError, LvarPto1+1, LvarPto3 - LvarPto1-1) & ")">
						<cfset LvarMSG = "#LvarMSG# #LvarError#">
					<cfcatch type="any"></cfcatch>
					</cftry>
					<cfquery datasource="#Arguments.conexion#">
						update CCVProducto
						   set CCVPmsg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMSG#">
						 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						   and CCTcodigo	= '#rsCCVProductoP.CCTcodigo#'
						   and Ddocumento 	= '#rsCCVProductoP.Ddocumento#'
						   and DDtipo 		= 'A'		<!--- Articulos de Inventario --->
						   and CCVPestado	= 0			<!--- Pendientes --->
					</cfquery>
					<cftransaction action="commit"/>
				</cfcatch>
				</cftry>
			</cftransaction>
		</cfloop>
	</cffunction>


	<cffunction name="CalcularDocumento" output="no" returntype="boolean" access="public">
		<cfargument name="IDdoc"    			type="numeric" required="yes">
		<cfargument name="CalcularImpuestos"	type="boolean" required="yes">
		<cfargument name="Ecodigo"  			type="numeric" required="yes">
		<cfargument name="Conexion" 			type="string"  required="yes">

		<!--- Validaciones Preposteo --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from EDocumentosCxC
			 where EDid = #Arguments.IDdoc#
		</cfquery>
		<cfif rsSQL.Cantidad EQ 0>
			 <cf_errorCode	code = "50994" msg = "El ID del documento indicado no existe. Verifique que el documento exista!">
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			  from DDocumentosCxC
			 where EDid = #Arguments.IDdoc#
		</cfquery>
		<cfif rsSQL.Cantidad EQ 0>
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxC
				   set 	EDtotal    	= 0,
				   		EDieps		= 0,
					  	EDimpuesto 	= 0
			   where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfif not isdefined("LvarPcodigo420")>
				<cfset CreaTablas(Arguments.Conexion)>
				<!--- Manejo del DescuentoDoc para calculo de Impuestos --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Pvalor
					from Parametros
					where Ecodigo = #Arguments.Ecodigo#
					  and Pcodigo = 420
				</cfquery>
				<cfset LvarPcodigo420 = rsSQL.Pvalor>
				<cfif LvarPcodigo420 EQ "">
					<cf_errorCode	code = "50996" msg = "No se ha definido el parámetro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
				</cfif>
				<!--- Usar Cuenta de Descuentos en CxC --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo = #session.Ecodigo#
					  and Pcodigo = 421
				</cfquery>
				<cfset LvarPcodigo421 = rsSQL.Pvalor>
				<cfif LvarPcodigo421 EQ "">
					<cf_errorCode	code = "50997" msg = "No se ha definido el parámetro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
				</cfif>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select  coalesce(a.EDdescuento, 0) as EDdescuento,
							coalesce(
								(
									select sum(DDtotallinea)
									  from DDocumentosCxC
									 where EDid = a.EDid
								)
							,0.00) as SubTotal,
							<!--- cambio ieps --->
							coalesce(
								(
									select sum(DDMontoIEPS)
									  from DDocumentosCxC
									 where EDid = a.EDid
								) 
							,0.00) as IEPS
					  from EDocumentosCxC a
					 where a.EDid	= #Arguments.IDdoc#
				</cfquery>
				<cfset LvarDescuentoDoc = rsSQL.EDdescuento>
				<cfset LvarSubTotalDoc = rsSQL.SubTotal>
				<cfset LvarIEPS = rsSQL.IEPS>
			</cfif>        
	
			<cfif LvarDescuentoDoc GT LvarSubTotalDoc>
				<cf_errorCode	code = "51000" msg = "El descuento no puede ser mayor al subtotal">
			</cfif>

			<cfset CC_impLinea		= request.CC_impLinea>
			<cfset CC_calculoLin	= request.CC_calculoLin>	
	
			<cfif Arguments.CalcularImpuestos>
				<cfquery datasource="#Arguments.Conexion#">
					update DDocumentosCxC
					   set DDimpuestoInterfaz = NULL
					 where EDid = #Arguments.IDdoc#
				</cfquery>
			</cfif>

			<!--- Prorratear el Descuento a nivel de Documento --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CC_calculoLin# (
					EDid, DDid, subtotalLinea,
					descuentoDoc,
					impuestoInterfaz,
					impuesto, impuestoBase, ingresoLinea, totalLinea, IEPS
				)
				select
					EDid, DDlinea, DDtotallinea,
					<cfif LvarDescuentoDoc GT 0>round(DDdesclinea,2)<cfelse>0</cfif>,
					DDimpuestoInterfaz,
					0, 0, 0, 0, DDMontoIEPS
				from DDocumentosCxC d
				where d.EDid = #Arguments.IDdoc#
			</cfquery>


			<!--- Ajuste de redondeo por Prorrateo del Descuento --->
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select sum(descuentoDoc) as descuentoDoc
				  from #CC_calculoLin#
			</cfquery>
			<cfset LvarAjuste = LvarDescuentoDoc - rsSQL.descuentoDoc>
			<cfif LvarAjuste NEQ 0>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select max(descuentoDoc) as mayor
					  from #CC_calculoLin#
				</cfquery>
				<cfif rsSQL.mayor LT -(LvarAjuste)>
					<cf_errorCode	code = "51001" msg = "No se puede prorratear el descuento a nivel de documento">
				</cfif>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select min(DDid) as DDid
					  from #CC_calculoLin#
					 where descuentoDoc =
							(
								select max(descuentoDoc)
								  from #CC_calculoLin#
							)
				</cfquery>

				<cfquery datasource="#Arguments.Conexion#">
					update #CC_calculoLin#
					   set descuentoDoc = descuentoDoc + #LvarAjuste#
					 where DDid = #rsSQL.DDid#
				</cfquery>
			</cfif>

			<!--- Obtiene los Impuestos Simples --->
			<!--- IVA --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CC_impLinea# (
					EDid, DDid, ecodigo,   icodigo,  dicodigo, codIEPS,
					descripcion,    
					ccuenta,CFcuenta,IEPSCcuenta,IEPSCFcuenta,
					montoBase,
					porcentaje, impuesto, IEPS, icompuesto, ValorCalculo,TipoCalculo, afectaIVA)
				select 
					EDid, DDlinea, d.Ecodigo, i.Icodigo, i.Icodigo, d.codIEPS,
					<cf_dbfunction name="concat" args="i.Icodigo, ': ', i.Idescripcion">, 
					coalesce(i.CcuentaCxC, i.Ccuenta),
					coalesce(i.CFcuentaCxC,i.CFcuenta),
					coalesce(ii.CcuentaCxC, ii.Ccuenta),
					coalesce(ii.CFcuentaCxC,ii.CFcuenta),
					DDtotallinea,
					i.Iporcentaje, 0.00, DDMontoIEPS, 0, ii.ValorCalculo, ii.TipoCalculo, d.afectaIVA
				from DDocumentosCxC d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0
					left join Impuestos  ii
					 on ii.Ecodigo = d.Ecodigo
					and ii.Icodigo = d.codIEPS
					and ii.Icompuesto = 0
				where d.EDid = #Arguments.IDdoc#
			</cfquery>

			<!--- Obtiene los Impuestos Compuestos --->
			<!--- IVA --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #CC_impLinea# (
					EDid, DDid, 	ecodigo,	icodigo, 	dicodigo, codIEPS,	
					descripcion,      
					ccuenta,
					CFcuenta,IEPSCcuenta,IEPSCFcuenta,
					montoBase,
					porcentaje, impuesto, IEPS, icompuesto, ValorCalculo, TipoCalculo, afectaIVA)
				select 
					EDid, DDlinea, 	d.Ecodigo, 	di.Icodigo, di.DIcodigo, d.codIEPS,
					<cf_dbfunction name="concat" args="i.Icodigo, '-' , di.DIcodigo, ': ', di.DIdescripcion">, 
					coalesce(i.CcuentaCxC,  di.Ccuenta),	
					coalesce(i.CFcuentaCxC, di.CFcuenta),
					coalesce(ii.CcuentaCxC,  dii.Ccuenta),	
					coalesce(ii.CFcuentaCxC, dii.CFcuenta),
					DDtotallinea,
					di.DIporcentaje, 0.00, DDMontoIEPS, 1, ii.ValorCalculo, ii.TipoCalculo, d.afectaIVA
				from DDocumentosCxC d
					inner join Impuestos  i
						inner join DImpuestos di
						on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 1
					left join Impuestos ii
						inner join DImpuestos dii
						on dii.Ecodigo = ii.Ecodigo
						and dii.Icodigo = ii.Icodigo
					on ii.Ecodigo = d.Ecodigo
					and ii.Icodigo = d.codIEPS
					and ii.Icompuesto = 1

				where d.EDid = #Arguments.IDdoc#
			</cfquery>

			<!--- Parametro 420: Manejo del DescuentoDoc para el Calculo de Impuesto 0=(totalLineas-descuentoDoc)*Iporcentaje, 1=totalLinea*Iporcentaje --->
			<cfif LvarPcodigo420 EQ "0" and LvarDescuentoDoc GT 0>
				<!--- Disminuye el monto Base para Impuestos con el DescuentoDocumento --->
				<cfquery datasource="#Arguments.Conexion#">
					update #CC_impLinea#
					set montoBase = 
						case afectaIVA <!--- 0 = afecta, 1 = no afecta --->
							WHEN 1 then
								montoBase - (select descuentoDoc
								  				from #CC_calculoLin#
								 				where EDid	= #CC_impLinea#.EDid
								   				and DDid	= #CC_impLinea#.DDid
											)
							WHEN 0 then
								montoBase - (select descuentoDoc
								  				from #CC_calculoLin#
								 				where EDid	= #CC_impLinea#.EDid
								   				and DDid	= #CC_impLinea#.DDid
											) + isnull(
												(
													select IEPS
													  from #CC_calculoLin#
													 where EDid	= #CC_impLinea#.EDid
													   and DDid	= #CC_impLinea#.DDid
												),0)
							ELSE
								CASE 
									WHEN isnull((select IEPS from #CC_calculoLin# where EDid	= #CC_impLinea#.EDid and DDid	= #CC_impLinea#.DDid),0) > 0
									THEN montoBase - (select descuentoDoc 
														from 	#CC_calculoLin# 
														where 	EDid	= #CC_impLinea#.EDid 
														and 	DDid	= #CC_impLinea#.DDid) + isnull((select 	IEPS
													  													from 	#CC_calculoLin#
													 													where 	EDid	= #CC_impLinea#.EDid
													   													and 	DDid	= #CC_impLinea#.DDid
																										),0)
									ELSE montoBase - (select descuentoDoc 
														from 	#CC_calculoLin# 
														where 	EDid	= #CC_impLinea#.EDid 
														and 	DDid	= #CC_impLinea#.DDid)
								END
							END
				</cfquery>
			</cfif>

			<cfquery datasource="#session.dsn#">
					update #CC_impLinea#
				set montoBase = 
					case afectaIVA  <!--- 0 = afecta, 1 = no afecta --->
						WHEN 0 THEN
							montoBase + isnull((select IEPS
												  from #CC_calculoLin#
												 where EDid	= #CC_impLinea#.EDid
												   and DDid	= #CC_impLinea#.DDid),0)
						WHEN 1 THEN 
							montoBase
						ELSE
							CASE 
								WHEN isnull((select IEPS
												  from #CC_calculoLin#
												 where EDid	= #CC_impLinea#.EDid
												   and DDid	= #CC_impLinea#.DDid),0) > 0
								THEN montoBase + isnull((select IEPS
												  from #CC_calculoLin#
												 where EDid	= #CC_impLinea#.EDid
												   and DDid	= #CC_impLinea#.DDid),0)
								ELSE
									montoBase
							END
						END
			</cfquery>

			<!--- Cálculo del Impuesto --->
			<cfquery datasource="#Arguments.Conexion#">
				update #CC_impLinea#
				   set impuesto = round(montoBase * coalesce(porcentaje, 0) / 100.00, 2) where porcentaje != ''
			</cfquery> 
			<!--- Mantener el Impuesto que viene de Interfaz --->
			<cfif NOT Arguments.CalcularImpuestos>
				<!--- La diferencia entre el Impuesto que viene de Interfaz y el calculado no puede ser mayor que abs(1) --->
				<cfquery name="rsAjustar" datasource="#Arguments.Conexion#">
					select i.EDid, i.DDid, sum(i.impuesto) as impuesto, min(c.impuestoInterfaz) as impuestoInterfaz,
							abs(sum(i.impuesto) - min(c.impuestoInterfaz)) as dif
					  from #CC_impLinea# i
						inner join #CC_calculoLin# c
						   on c.EDid	= i.EDid
						  and c.DDid	= i.DDid
					group by i.EDid, i.DDid
					  having abs(sum(i.impuesto) - min(c.impuestoInterfaz)) > 1
				</cfquery>
				<cfif rsAjustar.dif NEQ "">
					<cf_errorCode	code = "51002"
									msg  = "La diferencia entre el impuesto que viene de interfaz @errorDat_1@ y el impuesto real calculado @errorDat_2@ no es permitida porque es mayor que una unidad"
									errorDat_1="#numberformat(rsAjustar.impuestoInterfaz,",9.99")#"
									errorDat_2="#numberformat(rsAjustar.impuesto,",9.99")#"
					>
				</cfif>

				<!--- Los Impuestos simples se actualizan con el impuesto de interfaz --->
				<cfquery datasource="#Arguments.Conexion#">
					update #CC_impLinea#
					   set impuesto = round(
									(
										select impuestoInterfaz
										  from #CC_calculoLin#
										 where EDid	= #CC_impLinea#.EDid
										   and DDid	= #CC_impLinea#.DDid
									)
							   ,2)
					 where icompuesto = 0
						and
							(
								select count(1)
								  from #CC_calculoLin#
								 where EDid	= #CC_impLinea#.EDid
								   and DDid	= #CC_impLinea#.DDid
								   and impuestoInterfaz is not null
							)	> 0
				</cfquery>

				<!--- Los Impuestos compuestos debe prorratear el impuesto de interfaz y realizar el Ajuste de redondeo por Prorrateado--->
				<cfquery datasource="#Arguments.Conexion#">
					 update #CC_impLinea#
						set impuesto =
								round(
									impuesto
									/
									(
										select sum(impuesto)
										  from #CC_impLinea#
										 where EDid	= #CC_impLinea#.EDid
										   and DDid	= #CC_impLinea#.DDid
									)
									*
									(
										select impuestoInterfaz
										  from #CC_calculoLin#
										 where EDid	= #CC_impLinea#.EDid
										   and DDid	= #CC_impLinea#.DDid
									)
								, 2)
					  where	icompuesto = 1
						and
							(
								select count(1)
								  from #CC_calculoLin#
								 where EDid	= #CC_impLinea#.EDid
								   and DDid	= #CC_impLinea#.DDid
								   and impuestoInterfaz is not null
							)	> 0
				</cfquery>

				<cfquery name="rsAjustar" datasource="#Arguments.Conexion#">
					select i.EDid, i.DDid, sum(i.impuesto) - min(c.impuestoInterfaz) as ajuste
					  from #CC_impLinea# i
						inner join #CC_calculoLin# c
						   on c.EDid	= c.EDid
						  and c.DDid	= i.DDid
					  where	icompuesto = 1
					group by i.EDid, i.DDid
					  having sum(i.impuesto) - min(c.impuestoInterfaz) <> 0
				</cfquery>
				<cfloop query="rsAjustar">
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select max(impuesto) as mayor
						  from #CC_impLinea#
						 where EDid	= #rsAjustar.EDid#
						   and DDid	= #rsAjustar.DDid#
					</cfquery>
					<cfif rsSQL.mayor LT -(rsAjustar.ajuste)>
						<cf_errorCode	code = "51003" msg = "No se puede prorratear un impuesto compuesto">
					</cfif>

					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select min(dicodigo) as DIcodigo
						  from #CC_impLinea#
						 where impuesto =
								(
									select max(impuesto)
									  from #CC_impLinea#
										on EDid	= #CC_impLinea#.EDid
									   and DDid	= #CC_impLinea#.DDid
								)
						 where EDid	= #rsAjustar.EDid#
						   and DDid	= #rsAjustar.DDid#
					</cfquery>

					<cfquery datasource="#Arguments.Conexion#">
						update #CC_impLinea#
						   set impuesto = impuesto + #rsAjustar.ajuste#
						 where EDid	= #rsAjustar.EDid#
						   and DDid	= #rsAjustar.DDid#
						   and dicodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.DIcodigo#">
					</cfquery>
				</cfloop>
			</cfif>

			<!--- Calcular el Ingreso y el Total Neto de la Linea --->
			<cfquery datasource="#Arguments.Conexion#">
				update #CC_calculoLin#
				   set impuestoBase =
							coalesce((
								select min(montoBase)
								  from #CC_impLinea#
								 where EDid	= #CC_calculoLin#.EDid
								   and DDid	= #CC_calculoLin#.DDid
							),0)
					 , impuesto =
							coalesce((
								select sum(impuesto)
								  from #CC_impLinea#
								 where EDid	= #CC_calculoLin#.EDid
								   and DDid	= #CC_calculoLin#.DDid
							),0)
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update #CC_calculoLin#
				   set ingresoLinea	= subtotalLinea
							<cfif LvarPcodigo421 EQ "I">
							 - descuentoDoc
							</cfif>
					 , totalLinea	= subtotalLinea - descuentoDoc + impuesto
			</cfquery>

			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select
					sum(subtotalLinea) 	as subTotal,
					sum(impuesto)		as Impuestos,
					isnull(sum(IEPS),0)	as IEPS
				from #request.CC_calculoLin#
			</cfquery>		
<!--- 	<cfquery name="test2" datasource="#session.dsn#">
		select 
					*
				from #request.CC_calculoLin#
	</cfquery>
	<cf_dump var=#test2#> --->
			<cfquery datasource="#session.DSN#">
				update EDocumentosCxC
				   set EDtotal    = round(#rsSQL.subTotal# + #rsSQL.Impuestos# + #rsSQL.IEPS#,2),
				       EDieps	  = round(#rsSQL.IEPS#,2)

				<cfif Arguments.CalcularImpuestos>
					 , EDimpuesto = round(#rsSQL.Impuestos#,2)
				</cfif>
			   where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdoc#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		</cfif>
<!--- <cfquery name="test3" datasource="#session.dsn#">
	select * from EdocumentosCxC
</cfquery>
<cf_dump var=#test3#> --->
		<cfreturn true>
	</cffunction>
</cfcomponent>


