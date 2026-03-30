<!--- Componente: CC_AplicaDocCompensacion --->
<cfcomponent>
<cf_dbfunction name="OP_concat" returnvariable="_Cat"> 
	<!--- Método: CC_AplicaDocCompensacion: Postea Una Transacción de Neteo de Documentos de CxC y CxP --->
	<cffunction name="CC_AplicaDocCompensacion" access="public" returntype="boolean">
		<cfargument name="idDocCompensacion" type="numeric" 	required="true">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" 		type="numeric" 	required="false" default="#Session.Usucodigo#">
		<cfargument name="Usulogin" 		type="string" 	required="false" default="#Session.Usulogin#">
		<cfargument name="Conexion" 		type="string" 	required="false" default="#Session.dsn#">
		<cfargument name="Debug" 			type="boolean"	required="false" default="false">
		<!--- Las siguientes variables son locales a esta función, por definición de lenguaje deben estar juntas en esta sección y no debe haber otro tipo de
			código que no sea la propia definición de las mismas hasta que termine la defnición de todas.
		--->
		<cfset var myResult=false>
		<cfset var lvCCTcodigo="">
		<cfset var lvPeriodo=0>
		<cfset var lvMes=0>
		<cfset var lvDocCompensacion=0>
		<cfset var lvError=0>
		<cfset var lvFecha=Now()>
		<cfset var lvDescripcion="Documento de Neteo">
		<cfset var lvBalance=0.00><!--- utilizada en el punto a. --->
		<cfset var Lvar_Contabiliza = true>
		<cfset var lvMonLoc = 0>

		<!--- <cfset Arguments.Debug = true> --->

		<!--- No se crea la tabla temporal asiento porque no es necesario en este nuevo diseño, ya que el componente GeneraAsiento en su método GeneraAsiento
		nos va a devolver el IDcontable, en una variable, y este componente se encarga de crear la tabla. --->
		<!--- Carga variables iniciales --->
		<cfquery name="rsMonLoc" datasource="#Arguments.Conexion#">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsMonLoc.recordcount and len(trim(rsMonLoc.Mcodigo)) and isNumeric(rsMonLoc.Mcodigo) and rsMonLoc.Mcodigo>
			<cfset lvMonLoc = rsMonLoc.Mcodigo>
		<cfelse>
			<cf_errorCode	code = "50969" msg = "CC_AplicaDocCompensacion: Error, No se ha definido la Moneda de la Empresa! Proceso Cancelado!">
		</cfif>
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select Pvalor as Periodo
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 50
		</cfquery>
		<cfif rsPeriodo.recordcount and len(trim(rsPeriodo.Periodo)) and isNumeric(rsPeriodo.Periodo) and rsPeriodo.Periodo>
			<cfset lvPeriodo = rsPeriodo.Periodo>
		<cfelse>
			<cf_errorCode	code = "50970" msg = "CC_AplicaDocCompensacion: Error, No se ha definido el parámetro de Periodo para los sistemas Auxiliares! Proceso Cancelado!">
		</cfif>
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select Pvalor as Mes
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 60
		</cfquery>
		<cfif rsMes.recordcount and len(trim(rsMes.Mes)) and isNumeric(rsMes.Mes) and rsMes.Mes>
			<cfset lvMes = rsMes.Mes>
		<cfelse>
			<cf_errorCode	code = "50971" msg = "CC_AplicaDocCompensacion: Error, No se ha definido el parámetro de Mes para los sistemas Auxiliares! Proceso Cancelado!">
		</cfif>
		<cfquery name="rsDocCompensacion" datasource="#Arguments.Conexion#">
			select CCTcodigo, DocCompensacion, Dfechadoc, Mcodigo, Ocodigo, TipoNeteoDocs
			from DocCompensacion
			where idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsDocCompensacion.recordcount>
			<cfif len(trim(rsDocCompensacion.DocCompensacion)) and len(trim(rsDocCompensacion.DocCompensacion))>
				<cfset lvDocCompensacion = rsDocCompensacion.DocCompensacion>
			<cfelse>
				<cf_errorCode	code = "50972" msg = "CC_AplicaDocCompensacion: Error, No se ha definido el documento de neteo para el documento de neteo! Proceso Cancelado!">
			</cfif>
			<cfif len(trim(rsDocCompensacion.CCTcodigo)) and len(trim(rsDocCompensacion.CCTcodigo))>
				<cfset lvCCTcodigo = rsDocCompensacion.CCTcodigo>
			<cfelse>
				<cf_errorCode	code = "50973" msg = "CC_AplicaDocCompensacion: Error, No se ha definido el tipo de transacción para el documento de neteo! Proceso Cancelado!">
			</cfif>
			<cfif len(trim(rsDocCompensacion.Dfechadoc)) and len(trim(rsDocCompensacion.Dfechadoc))>
				<cfset lvFecha = rsDocCompensacion.Dfechadoc>
			<cfelse>
				<cf_errorCode	code = "50974" msg = "CC_AplicaDocCompensacion: Error, No se ha definido la fecha del documento de neteo! Proceso Cancelado!">
			</cfif>
			<cfset lvDescripcion = lvDescripcion & ' ' & rsDocCompensacion.DocCompensacion>
			<cfset LvarMcodigo = rsDocCompensacion.Mcodigo>
			<cfset LvarOcodigo = rsDocCompensacion.Ocodigo>

			<cfset LvarTipoNeteoDocs = rsDocCompensacion.TipoNeteoDocs>
			<cfif LvarTipoNeteoDocs EQ 0>
				<cfset LvarTipoNeteoDocs = DeterminarTipoCompensacionDocs(Arguments.idDocCompensacion)>
				<cfif LvarTipoNeteoDocs EQ -1>
					<cfthrow message="Hay una mezcla de Tipos de Documento incorrecta para netear">
				</cfif>
			<cfelse>
				<cfset LvarTipoNeteoMSG = VerificarTipoNeteoDocs(Arguments.idDocCompensacion)>
				<cfif LvarTipoNeteoMSG NEQ "">
					<cfthrow message="#LvarTipoNeteoMSG#">
				</cfif>
			</cfif>
		<cfelse>
			<cf_errorCode	code = "50975" msg = "CC_AplicaDocCompensacion: Error, No se ha definido el documento de neteo! Proceso Cancelado!">
		</cfif>

		<cfif Arguments.debug>
			<cfoutput>
				<h1>Variables Cargadas Antes de Iniciar el Proceso:</h1>
				myResult = #myResult#<br>
				lvCCTcodigo = #lvCCTcodigo#<br>
				lvPeriodo = #lvPeriodo#<br>
				lvMes = #lvMes#<br>
				lvDocCompensacion = #lvDocCompensacion#<br>
				lvError = #lvError#<br>
				lvFecha = #lvFecha#<br>
				lvDescripcion = #lvDescripcion#<br>
			</cfoutput>
		</cfif>

		<!---
			Calculo de Retención:
				Si no es de anticipo lo deja en CERO
				Si no tiene retención lo deja en CERO
				Si se digitó monto se respeta
				Si no tiene monto, lo calcula con base en monto a netear:
					DmontoDoc = Dmonto / (1 - Porcentaje)
					DmontoRet = DmontoDoc * Porcetaje
					DmontoRet = Dmonto / (1 - Porcentaje) * Porcentaje
		--->

		<!--- Retencion CxC: join por Ecodigo, CCTcodigo, Ddocumento --->
		<cfquery datasource="#Arguments.Conexion#">
			<cfif LvarTipoNeteoDocs NEQ 2>
				update DocCompensacionDCxC
				   set DmontoRet = 0
				 where idDocCompensacion = #Arguments.idDocCompensacion#
			<cfelse>
				update DocCompensacionDCxC
				   set DmontoRet =
				   		case
							when (
									select d.Rcodigo
									  from Documentos d
									 where d.Ecodigo	= DocCompensacionDCxC.Ecodigo
									   and d.CCTcodigo	= DocCompensacionDCxC.CCTcodigo
									   and d.Ddocumento	= DocCompensacionDCxC.Ddocumento
								  ) is null	then 0
							when DmontoRet = 0 then
								coalesce(
									(
										select DocCompensacionDCxC.Dmonto / (1 - r.Rporcentaje/100) * r.Rporcentaje/100
										  from Documentos d
											inner join Retenciones r
												 on r.Ecodigo = d.Ecodigo
												and r.Rcodigo = d.Rcodigo
										 where d.Ecodigo	= DocCompensacionDCxC.Ecodigo
										   and d.CCTcodigo	= DocCompensacionDCxC.CCTcodigo
										   and d.Ddocumento	= DocCompensacionDCxC.Ddocumento
									), 0)
							else DmontoRet
						end
				where idDocCompensacion = #Arguments.idDocCompensacion#
			</cfif>
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			<cfif LvarTipoNeteoDocs NEQ 3>
				update DocCompensacionDCxP
				   set DmontoRet = 0
				where idDocCompensacion = #Arguments.idDocCompensacion#
			<cfelse>
				update DocCompensacionDCxP
				   set DmontoRet =
				   		case
							when (
									select d.Rcodigo
									  from EDocumentosCP d
									 where d.IDdocumento = DocCompensacionDCxP.idDocumento
								  ) is null	then 0
							when DmontoRet = 0 then
								coalesce(
									(
										select DocCompensacionDCxP.Dmonto / (1 - r.Rporcentaje/100) * r.Rporcentaje/100
										  from EDocumentosCP d
											inner join Retenciones r
												 on r.Ecodigo = d.Ecodigo
												and r.Rcodigo = d.Rcodigo
										 where d.IDdocumento = DocCompensacionDCxP.idDocumento
									), 0)
							else DmontoRet
						end
				where idDocCompensacion = #Arguments.idDocCompensacion#
			</cfif>
		</cfquery>

		<!---
		a. verificar que los documentos estén balanceados
			La suma de los documentos de CxC a netear
			Debe corresponder a la suma de los documentos de CxP a netear
			La diferencia debe estar reflejada en el encabezado.
			Se debe considerar que el tipo de transacción es significativo en
			ambos sistemas.
			La suma de debitos - creditos en CxC
			debe ser igual a la suma de creditos - debitos en CxP
			Si hay una diferencia, debe corresponder al monto del encabezado
		b.1. Verificar que los documentos tengan un saldo >= al monto que se aplica
		b.2. No se puede afectar el mismo documento mas de una vez
		c. Afectar el asiento contable, saldos de documentos y las tablas de bitacora.
			c.1.
				A los documentos de CxC, se les hace un movimiento contable con transaccion contraria
				al signo de la transaccion, en la cuenta del documento
			c.2.
				A los documentos de CxP se les hace un movimiento contable con transaccion contraria
				al signo de la transaccion en la cuenta del documento
			c.3.
				Si existe diferencia en los totales, se debe generar el documento del encabezado
				como un documento a favor en CxC. Para esto se utiliza el tipo de transaccion
				el numero del documento y el monto del encabezado.
			c.4.
				Se afectan los saldos de los documentos por el monto de la tabla de detalles.
			c.5.
				Se afectan las tablas de bitacora de movimientos de CxP y CxC
			c.6.
				Se invoca la generación del asiento contable.
		--->
		<!--- a. Balance de las tablas de detalle y encabezado --->
		<!--- La siguiente suma siempre debe de ser 0.00 --->
		<cfquery name="rsBalance1" datasource="#Arguments.Conexion#">
			select sum(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end) as Balance
			from DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
				inner join CCTransacciones b <cf_dbforceindex name="PK_CCTRANSACCIONES">
					on b.CCTcodigo = a.CCTcodigo
					and b.Ecodigo = a.Ecodigo
			where a.idDocCompensacion =#Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsBalance1.recordcount and len(rsBalance1.Balance) GT 0>
			<cfset lvBalance = lvBalance + rsBalance1.Balance>
		</cfif>
		<cfquery name="rsBalance2" datasource="#Arguments.Conexion#">
			select sum(a.Dmonto * case when b.CPTtipo = 'D' then 1 else -1 end) as Balance
			from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
				inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
					on a.idDocCompensacion = aa.idDocCompensacion
				inner join CPTransacciones b <cf_dbforceindex name="PK_CPTRANSACCIONES">
					on b.CPTcodigo = a.CPTcodigo
					and b.Ecodigo = aa.Ecodigo
			where aa.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsBalance2.recordcount and len(rsBalance2.Balance) GT 0>
			<cfset lvBalance = lvBalance + rsBalance2.Balance>
		</cfif>
		<cfquery name="rsBalance3" datasource="#Arguments.Conexion#">
			select coalesce(a.Dmonto * case when b.CCTtipo = 'D' then 1 else -1 end, 0.00) as Balance
			from DocCompensacion a
				inner join CCTransacciones b
					on b.CCTcodigo = a.CCTcodigo
					and b.Ecodigo = a.Ecodigo
			where a.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsBalance3.recordcount and len(rsBalance3.Balance) GT 0>
			<cfset lvBalance = lvBalance + rsBalance3.Balance>
		</cfif>
		<cfif lvBalance Neq 0.00>
			<cf_errorCode	code = "50976" msg = "CC_AplicaDocCompensacion: Error, Los documentos no están balanceados! Proceso Cancelado!">
		</cfif>
		<!--- b. Verificar que los documentos tengan un saldo >= al monto que se aplica --->
		<!--- Existencia de los Documentos de CxC --->
		<cfquery name="rsDocCompensacionDCxC" datasource="#Arguments.Conexion#">
			select count(1) as CantidadDocNeteo
			from DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
			where idDocCompensacion = #Arguments.idDocCompensacion#
			and not exists (
				select 1 from Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
				where b.Ecodigo = a.Ecodigo
				and b.CCTcodigo = a.CCTcodigo
				and b.Ddocumento = a.Ddocumento
			)
		</cfquery>
		<cfif rsDocCompensacionDCxC.CantidadDocNeteo gt 0>
			<cf_errorCode	code = "50977" msg = "CC_AplicaDocCompensacion: Existen Documentos Inconsistentes en la Transaccion de CxC. Proceso Cancelado!">
		</cfif>
		<!--- Saldos de Documentos de CxC --->
		<cfquery name="rsDocCompensacionDCxC" datasource="#Arguments.Conexion#">
			select 1
			from DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
				inner join Documentos b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
					 on b.Ecodigo = a.Ecodigo
					and b.CCTcodigo = a.CCTcodigo
					and b.Ddocumento = a.Ddocumento
					and b.Dsaldo < (a.Dmonto+a.DmontoRet)
			where a.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsDocCompensacionDCxC.recordcount>
			<cfthrow  message="CC_AplicaDocCompensacion: Existen Documentos con Saldo menor al monto a Eliminar en CxC. Proceso Cancelado!">
		</cfif>

		<!--- Existencia de los Documentos de CxP --->
		<cfquery name="rsDocCompensacionDCxP" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from DocCompensacionDCxP a
			where idDocCompensacion = #Arguments.idDocCompensacion#
			and not exists (
				select 1
				from EDocumentosCP b
				where a.idDocumento = b.IDdocumento
			)
		</cfquery>
		<cfif rsDocCompensacionDCxP.cantidad gt 0>
			<cf_errorCode	code = "50978" msg = "CC_AplicaDocCompensacion: Existen Documentos Inconsistentes en la Transaccion de CxP. Proceso Cancelado!">
		</cfif>
		<!--- Saldos de Documentos de CxP --->
		<cfquery name="rsDocCompensacionDCxP" datasource="#Arguments.Conexion#">
			select 1
			from DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
				inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
					on b.IDdocumento = a.idDocumento
					and b.EDsaldo < (a.Dmonto+a.DmontoRet)
			where a.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsDocCompensacionDCxP.recordcount>
			<cf_errorCode	code = "50979" msg = "CC_AplicaDocCompensacion: Existen Documentos con Saldo menor al monto a Eliminar en CxP. Proceso Cancelado!">
		</cfif>
		<!--- Obtiene el Tipo de Cambio de la moneda del neteo --->
		<cfset TC = 1>
		<cfquery name="rsTC" datasource="#Arguments.Conexion#">
			select Mcodigo, Dfechadoc
			from DocCompensacion
			where idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<cfif rsTC.recordcount>
			<cfset TC = getTipoCambio(rsTC.Mcodigo, rsTC.Dfechadoc, Arguments.Conexion, Arguments.Ecodigo)>
		</cfif>

		<!--- Creación de la tabla INTARC, El nombre de la tabla para utilizarla en los quieres es guardado en la variable #INTARC# --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC" conexion="#Arguments.Conexion#"/>
		<!--- Creación de la tabla INTpresupuesto #INTpresupusto# --->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC" conexion="#Arguments.Conexion#"/>
		<cfif Lvar_Contabiliza>
			<cfquery name="rsCuentaIngDifCambiario" datasource="#Arguments.Conexion#">
				select p.Pvalor as CuentaIngDifCam
				from Parametros p
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 110
			</cfquery>
			<cfset LvarCuentaIngDifCambiario = rsCuentaIngDifCambiario.CuentaIngDifCam>

			<cfquery name="rsCuentaGasDifCambiario" datasource="#Arguments.Conexion#">
				select p.Pvalor as CuentaGasDifCam
				from Parametros p
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 120
			</cfquery>
			<cfset LvarCuentaGasDifCambiario = rsCuentaGasDifCambiario.CuentaGasDifCam>
		</cfif>

		<cfquery name="rsCuentabalancemultimoneda" datasource="#Arguments.Conexion#">
			select p.Pvalor as Pvalor
			from Parametros p
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 200
		</cfquery>
		<cfif isdefined("rsCuentabalancemultimoneda") and rsCuentabalancemultimoneda.recordcount gt 0>
			<cfset LvarCuentabalancemultimoneda = rsCuentabalancemultimoneda.Pvalor>
		<cfelse>
			<cf_errorCode	code = "50980" msg = "No se ha definido la Cuenta de Balance Multimoneda.">
		</cfif>

		<cftransaction>
			<!--- Solo se contabiliza cuando interactua mas de una cuenta --->
			 <cfif Lvar_Contabiliza>
				 <cfset contabilizarNeteo(Arguments.Ecodigo, arguments.conexion, lvFecha, lvPeriodo, lvMes, idDocCompensacion, lvMonLoc, Debug, lvCCTcodigo, lvDescripcion, lvDocCompensacion)>
			 </cfif>

			<!--- Insertar en el Histórico (Bitacora de movimientos) de CxC --->
			<!---
				Mcodigo = Moneda Pago = Mcodigoref = Moneda Documento	===> BMfactor = 1
				Dtotal			= Monto Pagado (sin Retención) Moneda Pago
				Dtotalloc		= Monto Pagado (sin Retención) Moneda Local
				Dtotalref		= Monto Aplicado (Pagado+Retención) Moneda Doc
				BMmontoretori	= Monto Retención
				BMmontoref		= Monto Pagado (sin Retención) Moneda Doc
			--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into BMovimientos (
						Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento,
						BMfecha, SNcodigo,
						Dfecha, Dvencimiento, BMperiodo, BMmes, Ocodigo, BMusuario,

						Mcodigo, Dtipocambio, Dtotal, Dtotalloc,
						Mcodigoref, Dtotalref, BMmontoretori, BMmontoref, BMfactor

						<cfif isdefined("IDcontable")>, IDcontable</cfif>)
				select 	a.Ecodigo, c.CCTcodigo, c.DocCompensacion, a.CCTcodigo, a.Ddocumento,
						<cf_dbfunction name="now">, a.SNcodigo,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lvFecha#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lvFecha#">,
						#lvPeriodo#, #lvMes#, a.Ocodigo, '#Arguments.Usulogin#',

						c.Mcodigo, a.Dtcultrev, b.Dmonto, round(b.Dmonto * a.Dtcultrev,2),
						a.Mcodigo, (b.Dmonto+b.DmontoRet), b.DmontoRet, b.Dmonto, 1

						<cfif isdefined("IDcontable")>, #IDcontable#</cfif>
				from DocCompensacionDCxC b <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
					inner join Documentos a <cf_dbforceindex name="PK_DOCUMENTOS">
						on a.Ecodigo = b.Ecodigo
						and a.CCTcodigo = b.CCTcodigo
						and a.Ddocumento = b.Ddocumento
					inner join DocCompensacion c <cf_dbforceindex name="PK_DocCompensacion">
						on c.idDocCompensacion = b.idDocCompensacion
				where b.idDocCompensacion = #Arguments.idDocCompensacion#
			</cfquery>

			<!--- Insertar en el Histórico (Bitacora de movimientos) de CxP --->
			<!---
				Mcodigo = Moneda Pago = Mcodigoref = Moneda Documento	===> BMfactor = 1
				Dtotal			= Monto Pagado (sin Retención) Moneda Pago
				BMmontoref		= Monto Aplicado (Pagado+Retención) Moneda Doc
				BMmontoretori	= Monto Retención
			--->
			<cfquery datasource="#Arguments.Conexion#">
				insert into BMovimientosCxP (
						Ecodigo, CPTcodigo, Ddocumento, CPTRcodigo, DRdocumento, BMfecha, Ccuenta, Ocodigo, SNcodigo,
						Dfecha, Dvencimiento, BMperiodo, BMmes, BMusuario,

						Mcodigo, Dtipocambio, Dtotal,
						Mcodigoref, BMmontoref, BMmontoretori, BMfactor

						<cfif isdefined("IDcontable")>, IDcontable</cfif>)
				select 	a.Ecodigo, c.CCTcodigo, c.DocCompensacion, a.CPTcodigo, a.Ddocumento, <cf_dbfunction name="now">, a.Ccuenta, a.Ocodigo, a.SNcodigo,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lvFecha#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lvFecha#">,
						#lvPeriodo#, #lvMes#, '#Arguments.Usulogin#',

						c.Mcodigo, a.EDtcultrev, b.Dmonto,
						a.Mcodigo, (b.Dmonto+b.DmontoRet), b.DmontoRet, 1

						<cfif isdefined("IDcontable")>, #IDcontable#</cfif>
				from DocCompensacionDCxP b <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
					inner join EDocumentosCP a <cf_dbforceindex name="PK_EDOCUMENTOSCP">
						on a.IDdocumento = b.idDocumento
					inner join DocCompensacion c <cf_dbforceindex name="PK_DocCompensacion">
						on c.idDocCompensacion = b.idDocCompensacion
				where b.idDocCompensacion = #Arguments.idDocCompensacion#
			</cfquery>

	<!--- MEG 17/04/2015 --->
	<!--- Envía al Repositorio de  CFDI --->
	<!--- Si existe configurado un Repositorio de CFDIs --->
			<cfquery name="getContE" datasource="#Session.DSN#">
				select ERepositorio from Empresa
				where Ereferencia = #Session.Ecodigo#
			</cfquery>
			<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
				<cfquery datasource="#Arguments.Conexion#" name="rsDContable">
					select Dlinea,dc.*
					from DContables dc
					inner join (
						SELECT b.CCTcodigo + ' ' + r.numDocumento numDocumento,r.Ecodigo
						FROM DocCompensacionDCxC b
						inner join Documentos a
							on a.Ecodigo = b.Ecodigo
							and a.CCTcodigo = b.CCTcodigo
							and a.Ddocumento = b.Ddocumento
						inner join DocCompensacion c
							on c.idDocCompensacion = b.idDocCompensacion
						inner join CERepositorio r
							on a.Ddocumento = r.numDocumento
							and r.origen = 'CCFC'
							and b.idDocCompensacion = #Arguments.idDocCompensacion#
						union all
						SELECT b.CPTcodigo + ' ' + r.numDocumento numDocumento,r.Ecodigo
						FROM  DocCompensacionDCxP b
						inner join EDocumentosCP a
							on a.IDdocumento = b.idDocumento
						inner join DocCompensacion c
							on c.idDocCompensacion = b.idDocCompensacion
						inner join CERepositorio r
							on a.Ddocumento = r.numDocumento
							and r.origen = 'CPFC'
							and b.idDocCompensacion = #Arguments.idDocCompensacion#
					) rep
						on dc.Ddocumento = rep.numDocumento
						and dc.Ecodigo = rep.Ecodigo
					where dc.IDcontable = #IDcontable#
						and (
							dc.Ccuenta in (select SNcuentacxc FROM SNegocios AS b)
							or dc.Ccuenta in (select b.SNcuentacxp FROM SNegocios AS b)
							or dc.Ccuenta in (select b.Ccuenta FROM CECuentasCFDI AS b)
						)
				</cfquery>
				<cfloop query="rsDContable">
					<cfquery name="rsInsDContableCC" datasource="#Session.DSN#">
						insert into CERepositorio(
							IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
		                	archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
							TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
							CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
						select dc.IDcontable, rep.IdDocumento, rep.numDocumento,
							'CCND', #rsDContable.Dlinea#, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
		                    	rep.extension, #session.Ecodigo#,#session.Usucodigo#,
		                    	rep.TipoComprobante,rep.Serie,
		                    	rep.Mcodigo,
		                    	rep.TipoCambio,
		                    	rep.CEMetPago,
		                    	rep.rfc,
		                    	rep.total,
							rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
						from DContables dc
						inner join (
							SELECT r.*,b.CCTcodigo + ' ' + r.numDocumento DDocumento
							FROM DocCompensacionDCxC b
							inner join Documentos a
								on a.Ecodigo = b.Ecodigo
								and a.CCTcodigo = b.CCTcodigo
								and a.Ddocumento = b.Ddocumento
							inner join DocCompensacion c
								on c.idDocCompensacion = b.idDocCompensacion
							inner join CERepositorio r
								on a.Ddocumento = r.numDocumento
								and r.origen = 'CCFC'
								and b.idDocCompensacion = #Arguments.idDocCompensacion#
						) rep
							on dc.Ddocumento = rep.DDocumento
							and dc.Ecodigo = rep.Ecodigo
						where dc.IDcontable = #IDcontable#
							and (
								dc.Ccuenta in (select SNcuentacxc FROM SNegocios AS b)
								or dc.Ccuenta in (select b.SNcuentacxp FROM SNegocios AS b)
								or dc.Ccuenta in (select b.Ccuenta FROM CECuentasCFDI AS b)
							)
					</cfquery>
					<cfquery name="rsInsDContableCP" datasource="#Session.DSN#">
						insert into CERepositorio(
							IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
		                	archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
							TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
							CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
						select dc.IDcontable, rep.IdDocumento, rep.numDocumento,
							'CPND', #rsDContable.Dlinea#, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
		                    	rep.extension, #session.Ecodigo#,#session.Usucodigo#,
		                    	rep.TipoComprobante,rep.Serie,
		                    	rep.Mcodigo,
		                    	rep.TipoCambio,
		                    	rep.CEMetPago,
		                    	rep.rfc,
		                    	rep.total,
							rep.CEtipoLinea,rep.CESNB,rep.CEtranOri,rep.CEdocumentoOri,rep.Miso4217
						from DContables dc
						inner join (
							SELECT r.*,b.CPTcodigo + ' ' + r.numDocumento DDocumento
							FROM  DocCompensacionDCxP b
							inner join EDocumentosCP a
								on a.IDdocumento = b.idDocumento
							inner join DocCompensacion c
								on c.idDocCompensacion = b.idDocCompensacion
							inner join CERepositorio r
								on a.Ddocumento = r.numDocumento
								and r.origen = 'CPFC'
								and b.idDocCompensacion = #Arguments.idDocCompensacion#
						) rep
							on dc.Ddocumento = rep.DDocumento
							and dc.Ecodigo = rep.Ecodigo
						where dc.IDcontable = #IDcontable#
							and (
								dc.Ccuenta in (select SNcuentacxc FROM SNegocios AS b)
								or dc.Ccuenta in (select b.SNcuentacxp FROM SNegocios AS b)
								or dc.Ccuenta in (select b.Ccuenta FROM CECuentasCFDI AS b)
							)
					</cfquery>
				</cfloop>
			</cfif>
	<!--- Fin ContabilidadElectronica --->
			<!--- Actualizar el saldo de los documentos afectados en CxC --->
			<cfquery datasource="#Arguments.Conexion#">
				update Documentos
				set Dsaldo = Dsaldo -
						coalesce((
							select sum(c.Dmonto+c.DmontoRet)
							from DocCompensacionDCxC c
							  where c.idDocCompensacion = #Arguments.idDocCompensacion#
								and c.Ecodigo 		   = Documentos.Ecodigo
								and c.CCTcodigo 	   = Documentos.CCTcodigo
								and c.Ddocumento 	   = Documentos.Ddocumento
								and c.Ecodigo = #Arguments.Ecodigo#), 0.00)
				where (select count(1)
				        from DocCompensacionDCxC b
					  where b.idDocCompensacion    = #Arguments.idDocCompensacion#
						and Documentos.Ecodigo    = b.Ecodigo
						and Documentos.CCTcodigo  = b.CCTcodigo
						and Documentos.Ddocumento = b.Ddocumento
						and b.Ecodigo = #Arguments.Ecodigo#
						) > 0
			</cfquery>

			<!--- Actualizar el saldo de los documentos afectados en CxP --->
			<cfquery datasource="#Arguments.Conexion#">
				update EDocumentosCP
				set EDsaldo = EDsaldo -
						coalesce((
							select sum(c.Dmonto+c.DmontoRet)
							from DocCompensacionDCxP c
							 where c.idDocCompensacion = #Arguments.idDocCompensacion#
								and c.idDocumento = EDocumentosCP.IDdocumento
								and c.CPTcodigo   = EDocumentosCP.CPTcodigo
								and c.Ddocumento  = EDocumentosCP.Ddocumento
								and EDocumentosCP.Ecodigo = #Arguments.Ecodigo#), 0.00)
				where (select count(1)
				from DocCompensacionDCxP b
				where b.idDocCompensacion = #Arguments.idDocCompensacion#
					and EDocumentosCP.IDdocumento = b.idDocumento
					and EDocumentosCP.CPTcodigo   = b.CPTcodigo
					and EDocumentosCP.Ddocumento  = b.Ddocumento
					and EDocumentosCP.Ecodigo     = #Arguments.Ecodigo#
					) > 0

			</cfquery>

			<!--- Actualiza el Documento de Neteo --->
			<cfquery datasource="#Arguments.Conexion#">
				update DocCompensacion
				set Aplicado = 1
				where idDocCompensacion = #Arguments.idDocCompensacion#
			</cfquery>

			<cfif Arguments.Debug>
				<cfif Lvar_Contabiliza>
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					 select * from #INTARC#
					</cfquery>
					<cfdump var="#rsDebug#">
				<cfelse>
					<cfdump var="#rsCheckContabiliza#">
					<h2>No Contabilizó porque todas las cuentas son iguales.</h2>
				</cfif>
				<cftransaction action="rollback"/>
				<cf_abort errorInterfaz="">
			</cfif>
		</cftransaction>
		<cfreturn myResult>
	</cffunction>
	<cffunction name="contabilizarNeteo" access="private" returntype="any" output="false">
		<cfargument name="Ecodigo" 			type="numeric" 	required="false">
		<cfargument name="Conexion" 		type="string" 	required="true">
		<cfargument name="lvFecha"  		type="date" 	required="true">
		<cfargument name="lvPeriodo"  		type="numeric" 	required="true">
		<cfargument name="lvMes"  			type="numeric" 	required="true">
		<cfargument name="idDocCompensacion" type="numeric" 	required="true">
		<cfargument name="lvMonLoc" 		type="numeric" 	required="true">
		<cfargument name="Debug" 			type="boolean"  required="false">
		<cfargument name="lvCCTcodigo" 		type="string" 	required="true">
		<cfargument name="lvDescripcion" 	type="string" 	required="true">
		<cfargument name="lvDocCompensacion"	type="string" 	required="true">

		<!--- Control Evento Inicia --->
        <!--- Busca la transacción y el documento  --->
        <cfquery name="rsNeteo" datasource="#Arguments.Conexion#">
        	select a.CCTcodigo,a.SNcodigo,a.DocCompensacion
            from DocCompensacion a
			where a.Ecodigo = #Arguments.Ecodigo#
			  and a.idDocCompensacion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocCompensacion#">
        </cfquery>

        <!--- Valido el evento --->
        <cfinvoke
            component		= "sif.Componentes.CG_ControlEvento"
            method			= "ValidaEvento"
            Origen			= "CCND"
            Transaccion		= "#rsNeteo.CCTcodigo#"
            Conexion		= "#Arguments.Conexion#"
            Ecodigo			= "#Arguments.Ecodigo#"
            returnvariable	= "varValidaEvento"
            />
        <cfset varNumeroEvento = "">
        <cfif varValidaEvento GT 0>
            <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_GeneraEvento"
                Origen			= "CCND"
                Transaccion		= "#rsNeteo.CCTcodigo#"
                Documento 		= "#rsNeteo.DocCompensacion#"
                SocioCodigo		= "#rsNeteo.SNcodigo#"
                Conexion		= "#Arguments.Conexion#"
                Ecodigo			= "#Arguments.Ecodigo#"
                returnvariable	= "arNumeroEvento"
                />
        	<cfif arNumeroEvento[3] EQ "">
                <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
            </cfif>
            <cfset varNumeroEvento = arNumeroEvento[3]>
            <cfset varIDEvento = arNumeroEvento[4]>

            <!---Genera Relacion con Detalle de documentos CxC--->
            <cfquery name="rsDocCompensacionDCxC" datasource="#Arguments.Conexion#">
                select a.idDocCompensacion, a.idDetalle, a.Ecodigo, b.CCTcodigo,
                	b.Ddocumento, b.SNcodigo
                 from DocCompensacionDCxC a
                 inner join Documentos b
                 on a.Ecodigo = b.Ecodigo
                 and a.CCTcodigo = b.CCTcodigo
                 and a.Ddocumento = b.Ddocumento
                 where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                 and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocCompensacion#">
            </cfquery>
            <cfloop query="rsDocCompensacionDCxC">
                <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_RelacionaEvento"
                IDNEvento       = "#varIDEvento#"
                Origen			= "CCFC"
                Transaccion		= "#rsDocCompensacionDCxC.CCTcodigo#"
                Documento 		= "#rsDocCompensacionDCxC.Ddocumento#"
                SocioCodigo		= "#rsDocCompensacionDCxC.SNcodigo#"
                Conexion		= "#Arguments.Conexion#"
                Ecodigo			= "#Arguments.Ecodigo#"
                returnvariable	= "arRelacionEvento"
                />
                <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
					<cfset varNumeroEventoDP = arRelacionEvento[4]>
                <cfelse>
                    <cfset varNumeroEventoDP = varNumeroEvento>
                </cfif>
                <cfquery datasource="#Arguments.Conexion#">
                    update DocCompensacionDCxC
                    set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
                     where idDocCompensacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocCompensacionDCxC.idDocCompensacion#">
                       and idDetalle  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocCompensacionDCxC.idDetalle#">
                </cfquery>
            </cfloop>
			<!---Detalle de documentos CxP--->
            <cfquery name="rsDocCompensacionDCxP" datasource="#Arguments.Conexion#">
                select a.idDocCompensacion, a.idDetalle, b.Ecodigo, b.CPTcodigo,
                b.Ddocumento, b.SNcodigo
                from DocCompensacionDCxP a
                inner join EDocumentosCP b
                on a.idDocumento = b.IDdocumento
                where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDocCompensacion#">
            </cfquery>
            <cfloop query="rsDocCompensacionDCxP">
                <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_RelacionaEvento"
                IDNEvento       = "#varIDEvento#"
                Origen			= "CPFC"
                Transaccion		= "#rsDocCompensacionDCxP.CPTcodigo#"
                Documento 		= "#rsDocCompensacionDCxP.Ddocumento#"
                SocioCodigo		= "#rsDocCompensacionDCxP.SNcodigo#"
                Conexion		= "#Arguments.Conexion#"
                Ecodigo			= "#Arguments.Ecodigo#"
                returnvariable	= "arRelacionEvento"
                />

                <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
					<cfset varNumeroEventoDP = arRelacionEvento[4]>
                <cfelse>
                    <cfset varNumeroEventoDP = varNumeroEvento>
                </cfif>

                <cfquery datasource="#Arguments.Conexion#">
                    update DocCompensacionDCxP
                    set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
                    where idDocCompensacion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocCompensacionDCxP.idDocCompensacion#">
                       and idDetalle  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocCompensacionDCxP.idDetalle#">
                </cfquery>
            </cfloop>
        </cfif>
        <!--- Control Evento Fin --->

		<cfquery name="rsDocCompensacion" datasource="#Arguments.Conexion#">
			select Ocodigo
			from DocCompensacion
			where idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
		<!--- VALIDACION DE IMPUESTOS, SE AGREGA VALIDACION PARA SABER CUANDO VALIDAR CXC - ABG--->
        <cfquery name="rsValidaModuloNeteoCxC" datasource="#Arguments.Conexion#">
        	select count(1) as Cuenta
            from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
                inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
                on a.idDocCompensacion = aa.idDocCompensacion
            where aa.idDocCompensacion = #Arguments.idDocCompensacion#
        </cfquery>
        <cfif rsValidaModuloNeteoCXC.recordcount GT 0 and rsValidaModuloNeteoCxC.Cuenta GT 0>
            <cfquery name="rsValidaImpuesto" datasource="#Arguments.Conexion#">
                  select i.Idescripcion,i.CcuentaCxC, i.CcuentaCxCAcred
                    from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
                        inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
                            on a.idDocCompensacion = aa.idDocCompensacion
                        inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
                            on b.Ecodigo = a.Ecodigo
                            and b.CCTcodigo = a.CCTcodigo
                            and b.Ddocumento = a.Ddocumento
                        inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
                            on cc.CCTcodigo = b.CCTcodigo
                            and cc.Ecodigo = b.Ecodigo
                        inner join ImpDocumentosCxC fi
                            on  fi.Ecodigo     = b.Ecodigo
                            and fi.CCTcodigo   = b.CCTcodigo
                            and fi.Documento  = b.Ddocumento
                        inner join Impuestos i
                            on  i.Ecodigo = fi.Ecodigo
                            and i.Icodigo = fi.Icodigo
                    where aa.idDocCompensacion = #Arguments.idDocCompensacion#
            </cfquery>
            <cfif not (len(trim(rsValidaImpuesto.CcuentaCxC))or len(trim(rsValidaImpuesto.CcuentaCxCAcred)))>
                <cf_errorCode	code = "51679" msg = "No se han definido las facturas cliente o facturas Cliente Acreditadas para el impuesto: @errorDat_1@."
                                errorDat_1="#rsValidaImpuesto.Idescripcion#">
            </cfif>
		</cfif>

		<cfif TC NEQ 1.00>
		<!--- Afectar Diferencial Cambiario de los documentos --->
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    					,NumeroEvento
	<!--- Control Evento Fin --->
						,CFid)
				select 	'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CCTtipo = 'D' then 'D' else 'C' end,
						<cf_dbfunction name="concat" args="'CxC: Diferencial Cambiario ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						b.Ccuenta,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                    	round(
							round(a.Dmonto+a.DmontoRet,2)
						* (#TC# - b.Dtcultrev), 2)
	<!--- Control Evento Inicia --->
    					,a.NumeroEvento
	<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
						on b.Ecodigo = a.Ecodigo
						and b.CCTcodigo = a.CCTcodigo
						and b.Ddocumento = a.Ddocumento
					inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
						on cc.CCTcodigo = b.CCTcodigo
						and cc.Ecodigo = b.Ecodigo
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and 	round(
				  			round(a.Dmonto+a.DmontoRet,2)
						* (#TC# - b.Dtcultrev), 2) <> 0.00
			</cfquery>

<!--- Afecta cuentas por pagar ---->

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    					,NumeroEvento
	<!--- Control Evento Fin --->
						,CFid)
				select 'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CPTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CPTtipo = 'D' then 'D' else 'C' end,
						<cf_dbfunction name="concat" args="'CxP: Diferencial Cambiario ' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						b.Ccuenta,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                        round(
							round(a.Dmonto+a.DmontoRet,2)
						* (#TC# - b.EDtcultrev), 2)
	<!--- Control Evento Inicia --->
    					,a.NumeroEvento
	<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
						on b.IDdocumento = a.idDocumento
					inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
						on cc.CPTcodigo = b.CPTcodigo
						and cc.Ecodigo = b.Ecodigo
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and 	round(
				  			round(a.Dmonto+a.DmontoRet,2)
						* (#TC# - b.EDtcultrev), 2) <> 0.00
			</cfquery>
		</cfif>

		<!--- AFECTAR CONTABILIDAD POR IMPUESTOS CRÉDITO FISCAL ---------------------------------------------------------------------->
			<!--- a. Diferencial Cambiario por Impuesto Crédito Fiscal de Facturas de CxC --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
						<!--- Control Evento Inicia --->
    					,NumeroEvento
						<!--- Control Evento Fin --->
						,CFid)
				select 	'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CCTtipo = 'D' then 'C' else 'D' end,
						<cf_dbfunction name="concat" args="'CxC: Diferencial Cambiario ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						i.CcuentaCxC,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                        round(
							round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
						* (#TC# - b.Dtcultrev), 2)
						<!--- Control Evento Inicia --->
    					,a.NumeroEvento
						<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
						on b.Ecodigo = a.Ecodigo
						and b.CCTcodigo = a.CCTcodigo
						and b.Ddocumento = a.Ddocumento
					inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
						on cc.CCTcodigo = b.CCTcodigo
						and cc.Ecodigo = b.Ecodigo
					inner join ImpDocumentosCxC fi
						on  fi.Ecodigo     = b.Ecodigo
						and fi.CCTcodigo   = b.CCTcodigo
						and fi.Documento  = b.Ddocumento
					inner join Impuestos i
						on  i.Ecodigo = fi.Ecodigo
						and i.Icodigo = fi.Icodigo
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and 	round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)	* (#TC# - b.Dtcultrev), 2) <> 0
			</cfquery>
			<!--- a. Diferencial Cambiario por Impuesto Crédito Fiscal de Facturas de CxC IEPS --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    					,NumeroEvento
	<!--- Control Evento Fin --->
						,CFid)
				select 	'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CCTtipo = 'D' then 'C' else 'D' end,
						<cf_dbfunction name="concat" args="'CxC: Diferencial Cambiario ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						i.CcuentaCxC,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                        round(
							round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
						* (#TC# - b.Dtcultrev), 2)
	<!--- Control Evento Inicia --->
    					,a.NumeroEvento
	<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
						on b.Ecodigo = a.Ecodigo
						and b.CCTcodigo = a.CCTcodigo
						and b.Ddocumento = a.Ddocumento
					inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
						on cc.CCTcodigo = b.CCTcodigo
						and cc.Ecodigo = b.Ecodigo
					inner join ImpIEPSDocumentosCxC fi
						on  fi.Ecodigo     = b.Ecodigo
						and fi.CCTcodigo   = b.CCTcodigo
						and fi.Documento  = b.Ddocumento
					inner join Impuestos i
						on  i.Ecodigo = fi.Ecodigo
						and i.Icodigo = fi.codIEPS
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and 	round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2) * (#TC# - b.Dtcultrev), 2) <> 0
			</cfquery>

			<!--- b. Diferencial Cambiario por Impuesto Crédito Fiscal de Facturas de CxP --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    					,NumeroEvento
	<!--- Control Evento Fin --->
    					,CFid
						)
				select 'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CPTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CPTtipo = 'D' then 'C' else 'D' end,
						<!--- 'CxP: Diferencial Cambiario ' + b.CPTcodigo + ' ' + b.Ddocumento, --->
						<cf_dbfunction name="concat" args="'CxP:  ' + i.Idescripcion + ' : ' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						i.Ccuenta,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                        round(
							round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
						* (#TC# - b.EDtcultrev), 2)
	<!--- Control Evento Inicia --->
    					,a.NumeroEvento
	<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
						on b.IDdocumento = a.idDocumento
					inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
						on cc.CPTcodigo = b.CPTcodigo
						and cc.Ecodigo = b.Ecodigo

					inner join ImpDocumentosCxP fi
						on fi.IDdocumento = a.idDocumento
					inner join Impuestos i
						on  i.Ecodigo = fi.Ecodigo
						and i.Icodigo = fi.Icodigo

				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and	round(
							round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
						* (#TC# - b.EDtcultrev), 2) <> 0
			</cfquery>

	<!--- b. Diferencial Cambiario por IEPS Crédito Fiscal de Facturas de CxP --->

<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# (
						INTORI, INTREL, INTDOC, INTREF,
						INTTIP, INTDES, INTFEC,
						Periodo, Mes, Ccuenta,
						Mcodigo, Ocodigo,
						INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    					,NumeroEvento
	<!--- Control Evento Fin --->
    					,CFid
						)
				select 'CCND',
						1,
						<cf_dbfunction name="sPart"		args="b.CPTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       					<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
						case when cc.CPTtipo = 'D' then 'C' else 'D' end,
						<!--- 'CxP: Diferencial Cambiario ' + b.CPTcodigo + ' ' + b.Ddocumento, --->
						<cf_dbfunction name="concat" args="'CxP:  ' + i.Idescripcion + ' : ' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
						'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
						#arguments.lvPeriodo#,
						#arguments.lvMes#,
						i.Ccuenta,
						b.Mcodigo,
						b.Ocodigo,
						0.00, 1.00,
                        round(
							round((a.Dmonto+a.DmontoRet) * coalesce(fi.MontoCalculadoIeps,0) / fi.TotalFac,2)
						* (#TC# - b.EDtcultrev), 2)
	<!--- Control Evento Inicia --->
    					,a.NumeroEvento
	<!--- Control Evento Fin --->
    					,aa.CFid
				from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
					inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
						on a.idDocCompensacion = aa.idDocCompensacion
					inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
						on b.IDdocumento = a.idDocumento
					inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
						on cc.CPTcodigo = b.CPTcodigo
						and cc.Ecodigo = b.Ecodigo

					inner join ImpIEPSDocumentosCxP fi
						on fi.IDdocumento = a.idDocumento
					inner join Impuestos i
						on  i.Ecodigo = fi.Ecodigo
						and i.Icodigo = fi.codIEPS

				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				  and coalesce(fi.MontoCalculadoIeps,0) != 0
			</cfquery>


	<!----------------------Fin del ieps---------------------------------->

			<!--- / Afectar contabilidad por Impuestos Crédito Fiscal --->

			<!--- Ingreso o Gasto por Diferencial cambiario --->
			<cfset LvarINTTIP = "C">
			<cfset LvarCuentaDifCambiario = LvarCuentaIngDifCambiario>
			<cfset LvarINTMON = 0>

			<cfquery name="rsMontoIngGasto" datasource="#Arguments.Conexion#">
				select sum(INTMON * case INTTIP when 'D' then 1.00 else -1.00 end) as Monto
				from #INTARC#
			</cfquery>

			<cfif rsMontoIngGasto.recordcount GT 0 and rsMontoIngGasto.Monto NEQ 0>
				<cfset LvarINTMON = rsMontoIngGasto.Monto>
			</cfif>

			<cfif LvarINTMON LT 0>
				<cfset LvarINTTIP = "D">
				<cfif len(trim(LvarINTMON)) eq 0>
					<cfset LvarINTMON = 0>
				</cfif>
				<cfset LvarINTMON = -1 * LvarINTMON>
				<cfset LvarCuentaDifCambiario = LvarCuentaGasDifCambiario>
			</cfif>
			<cfset LvarINTMON = round(LvarINTMON*100)/100>

			<cfif LvarINTMON NEQ 0.00>
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    						,NumeroEvento
	<!--- Control Evento Fin --->
						)
					values ('CCND',
							1,
							<cf_dbfunction name="sPart"		args="'#arguments.lvDocCompensacion#';1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="'#arguments.lvCCTcodigo#';1;25" delimiters=";">,
							'#LvarINTTIP#',
							'Diferencial Cambiario ',
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentaDifCambiario#,
							#LvarMcodigo#,
							#LvarOcodigo#,
							0.00, 1.00,
                            #NumberFormat(LvarINTMON, '0.00')#
    						,'#varNumeroEvento#'
							)
				</cfquery>
			</cfif>

			<!--- c. Afectar el asiento contable, saldos de documentos y las tablas de bitacora. --->

			<!--- Afectar contabilidad por Impuestos Crédito Fiscal --->
				<!--- a. Reversión Impuesto Crédito Fiscal de Facturas de CxC --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
							<!--- Control Evento Inicia --->
    						,NumeroEvento
							<!--- Control Evento Fin --->
    						,CFid
							)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC: ' + i.Idescripcion + ' : ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							i.CcuentaCxC,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
							<!--- Control Evento Inicia --->
    						a.NumeroEvento
							<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>

<!--- a. Reversión Impuesto Crédito Fiscal de Facturas de CxC IEPS--->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
							<!--- Control Evento Inicia --->
    						,NumeroEvento
							<!--- Control Evento Fin --->
    						,CFid
							)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC:  ' + i.Idescripcion + ' : ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							i.CcuentaCxC,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
	<!--- Control Evento Inicia --->
    						a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo
						inner join ImpIEPSDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>

				<!--- ** --->
				<cfquery name="rsImpuestosCxC" datasource="#Arguments.Conexion#">
					select
							fi.CCTcodigo,
							fi.Documento,
							fi.Icodigo,
							fi.Ecodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END MontoPagado,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END MontoPagadoLocal,
							aa.CCTcodigo as CCTcodigoNeteo,
							aa.DocCompensacion as DocCompensacion,
							cc.CCTtipo,
							i.Idescripcion,
							i.CcuentaCxCAcred,
							b.Ocodigo
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo  = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo  = b.Ecodigo
						inner join ImpDocumentosCxC fi
							on  fi.Ecodigo    = b.Ecodigo
							and fi.CCTcodigo  = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>
				<!--- PAGO IVA --->
				<cfloop query="rsImpuestosCxC">
					<!--- Actualizar Monto Pagado --->
					<cfquery datasource="#Arguments.Conexion#">
						update ImpDocumentosCxC
						set MontoPagado  = MontoPagado + #MontoPagado#,
						    MontoCalculado = MontoCalculado - #MontoPagado#
						where Ecodigo    = #Ecodigo#
						  and CCTcodigo  = '#CCTcodigo#'
						  and Documento  = '#Documento#'
						  and Icodigo    = '#Icodigo#'
					</cfquery>
					<!--- Inserta Monto Pagado en Tabla de Detalle --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into ImpDocumentosCxCMov
						(
							CCTcodigo, Documento, Icodigo, Ecodigo,
							Fecha, MontoPagado,
							TipoPago, DocumentoPago,
							CcuentaAC, Periodo, Mes,
							BMUsucodigo, BMFecha, TpoCambio,
							MontoPagadoLocal
						)
						select
							'#CCTcodigo#', '#Documento#', '#Icodigo#', #Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvFecha#">, #MontoPagado#,
							'#CCTcodigoNeteo#', '#DocCompensacion#',
							#CcuentaCxCAcred#, #arguments.lvPeriodo#, #arguments.lvMes#,
							#session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, #TC#,
							#MontoPagadoLocal#
						from dual
					</cfquery>

					<!--- Traslado de Impuestos CxC  Contabilizacion --->
					<!--- IVA --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta,
								Mcodigo, Ocodigo,
								INTMOE, INTCAM, INTMON
								<!--- Control Evento Inicia --->
    							,NumeroEvento
								<!--- Control Evento Fin --->
								)
						select 	'CCND' as INTORI,
								1 as INTREL,
								<cf_dbfunction name="sPart"		args="'#CCTcodigo#' #_Cat# ' ' #_Cat# '#Documento#';1;20" delimiters=";"> as INTDOC,
       							<cf_dbfunction name="sPart"		args="'#CCTcodigoNeteo#' #_Cat# ' ' #_Cat# '#DocCompensacion#';1;25" delimiters=";"> as INTrEF,
								<cfif CCTtipo EQ 'C'>'D'<cfelse>'C'</cfif> as INTTIP,
								'CxC: #Idescripcion# : #CCTcodigo# #Documento# (Acreditada)' as INTDES,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								#CcuentaCxCAcred#,
								#arguments.lvMonLoc#,
								#Ocodigo#,
                            	#MontoPagadoLocal#,
								1,
								#MontoPagadoLocal#
    							,'#varNumeroEvento#'
						from dual
					</cfquery>
				</cfloop>
			<!--- IEPS --->
				<cfquery name="rsIEPSCxC" datasource="#Arguments.Conexion#">
					select
							fi.CCTcodigo,
							fi.Documento,
							fi.codIEPS,
							fi.Ecodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END MontoPagado,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END MontoPagadoLocal,
							aa.CCTcodigo as CCTcodigoNeteo,
							aa.DocCompensacion as DocCompensacion,
							cc.CCTtipo,
							i.Idescripcion,
							i.CcuentaCxCAcred,
							b.Ocodigo
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo
						inner join ImpIEPSDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>
				<cfloop query="rsIEPSCxC">
					<!--- Actualizar Monto Pagado --->
					<cfquery datasource="#Arguments.Conexion#">
						update ImpIEPSDocumentosCxC
						set MontoPagado = MontoPagado + #MontoPagado#,
						    MontoCalculado = MontoCalculado - #MontoPagado#
						where Ecodigo    = #Ecodigo#
						  and CCTcodigo  = '#CCTcodigo#'
						  and Documento = '#Documento#'
						  and codIEPS    = '#codIEPS#'
					</cfquery>

					<!--- Inserta Monto Pagado en Tabla de Detalle --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into ImpIEPSDocumentosCxCMov
						(
							CCTcodigo, Documento, codIEPS, Ecodigo,
							Fecha, MontoPagado,
							TipoPago, DocumentoPago,
							CcuentaAC, Periodo, Mes,
							BMUsucodigo, BMFecha, TpoCambio,
							MontoPagadoLocal
						)
						select
							'#CCTcodigo#', '#Documento#', '#codIEPS#', #Ecodigo#,
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvFecha#">, #MontoPagado#,
							'#CCTcodigoNeteo#', '#DocCompensacion#',
							#CcuentaCxCAcred#, #arguments.lvPeriodo#, #arguments.lvMes#,
							#session.Usucodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, #TC#,
							#MontoPagadoLocal#
						from dual
					</cfquery>

                    <!--- IEPS --->

					<!--- Traslado de Impuestos CxC  Contabilizacion --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta,
								Mcodigo, Ocodigo,
								INTMOE, INTCAM, INTMON
								<!--- Control Evento Inicia --->
    							,NumeroEvento
								<!--- Control Evento Fin --->
								)
						select 	'CCND' as INTORI,
								1 as INTREL,
								<cf_dbfunction name="sPart"		args="'#CCTcodigo#' #_Cat# ' ' #_Cat# '#Documento#';1;20" delimiters=";"> as INTDOC,
       							<cf_dbfunction name="sPart"		args="'#CCTcodigoNeteo#' #_Cat# ' ' #_Cat# '#DocCompensacion#';1;25" delimiters=";"> as INTrEF,
								<cfif CCTtipo EQ 'C'>'D'<cfelse>'C'</cfif> as INTTIP,
								'CxC: #Idescripcion# : #CCTcodigo# #Documento# (Acreditada)' as INTDES,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								#CcuentaCxCAcred#,
								#arguments.lvMonLoc#,
								#Ocodigo#,
                            	#MontoPagado#,
								1,
								#MontoPagadoLocal#
    							,'#varNumeroEvento#'
					</cfquery>
				</cfloop>

				<!--- Balance Multimoneda CxC --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
    							,CFid
						)

					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'C' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC: ' + i.Idescripcion + ' :' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
                            CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
	<!--- Control Evento Inicia --->
    						a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo


					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>
                <!--- IEPS --->
				<!--- Balance Multimoneda CxC --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
							<!--- Control Evento Inicia --->
    						,NumeroEvento
							<!--- Control Evento Fin --->
    						,CFid
							)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'C' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC: ' + i.Idescripcion + ' :' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
                            CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
							<!--- Control Evento Inicia --->
    						a.NumeroEvento
							<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo
						inner join ImpIEPSDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>


                <!--- ----------------------------------------------------------- --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
							<!--- Control Evento Inicia --->
    						,NumeroEvento
							<!--- Control Evento Fin --->
    						,CFid
							)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC: ' + i.Idescripcion + ' :' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							#lvmonloc#,
							b.Ocodigo,
                            round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2) * #TC#, 2),
							1,
                            round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo


					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>

                <!--- IEPS --->
                <cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
							<!--- Control Evento Inicia --->
    						,NumeroEvento
							<!--- Control Evento Fin --->
    						,CFid
							)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxC: ' + i.Idescripcion + ' :' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							#lvmonloc#,
							b.Ocodigo,
                            round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2) * #TC#, 2),
							1,
                            round(round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2) * #TC#, 2)
							<!--- Control Evento Inicia --->
    						,a.NumeroEvento
							<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones  cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo
						inner join ImpIEPSDocumentosCxC fi
							on  fi.Ecodigo     = b.Ecodigo
							and fi.CCTcodigo   = b.CCTcodigo
							and fi.Documento  = b.Ddocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS
					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>

				<!--- b. Reversión Impuesto Crédito Fiscal de Facturas de CxP --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
								,CFid
                           )
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_Cat# ' ' #_Cat# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_Cat# ' ' #_Cat# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CPTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxP:  ' + i.Idescripcion + ' : ' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							i.Ccuenta,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
                            CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
	<!--- Control Evento Inicia --->
    						a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo

					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>


				<!--- **IMPUESTOS* --->
				<cfquery name="rsImpuestosCxP" datasource="#Arguments.Conexion#">
					select
						b.CPTcodigo,
						b.Ddocumento,
						fi.Icodigo,
						fi.Ecodigo,
						CASE
							WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
							ELSE 0
					    END MontoPagado,
						CASE
							WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
							ELSE 0
					    END MontoPagadoLocal,
						aa.CCTcodigo as CCTcodigoNeteo,
						aa.DocCompensacion as DocCompensacion,
						cc.CPTtipo,

						i.Idescripcion,
						i.CcuentaCxPAcred,
						b.Ocodigo,
						a.idDocumento

					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento

						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo

					where aa.idDocCompensacion =  #Arguments.idDocCompensacion#
				</cfquery>



				<cfloop query="rsImpuestosCxP">
					<!--- Actualizar Monto Pagado CxP--->
					<cfquery datasource="#Arguments.Conexion#">
						update ImpDocumentosCxP
						set MontoPagado = MontoPagado + #MontoPagado#,
						    MontoCalculado = MontoCalculado - #MontoPagado#
						where IDdocumento = #idDocumento#
							and Icodigo    = '#Icodigo#'
							and	Ecodigo    = #Ecodigo#
					</cfquery>



				<!--- Inserta Monto Pagado en Tabla de Detalle CxP--->
					<cfquery datasource="#Arguments.Conexion#">

						insert into ImpDocumentosCxPMov
						(
							IDdocumento, Icodigo, Ecodigo, Fecha,
							MontoPagado, CPTcodigo, Ddocumento, CPTpago,
							CcuentaAC, Periodo, Mes, BMUsucodigo,
							BMFecha, TpoCambio, MontoPagadoLocal)
						select #idDocumento#, '#Icodigo#', #Ecodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#LvFecha#">,
								#MontoPagado#, '#CCTcodigoNeteo#', '#DocCompensacion#', 0,
								#CcuentaCxPAcred#, #arguments.lvPeriodo#, #arguments.lvMes#, #session.Usucodigo#,
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, #TC#, #MontoPagadoLocal#
						from dual
					</cfquery>

				<!--- Traslado Impuestos CxP  Contabilizacion --->
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta,
								Mcodigo, Ocodigo,
								INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
								)
						select 	'CCND' as INTORI,
								1 as INTREL,
								<cf_dbfunction name="sPart"		args="'#CPTcodigo#' #_Cat# ' ' #_Cat# '#Ddocumento#';1;20" delimiters=";"> as INTDOC,
       							<cf_dbfunction name="sPart"		args="'#CCTcodigoNeteo#' #_Cat# ' ' #_Cat# '#DocCompensacion#';1;25" delimiters=";"> as INTrEF,
								<cfif CPTtipo EQ 'C'>'D'<cfelse>'C'</cfif> as INTTIP,
								'CxP: #Idescripcion# : #CCTcodigo# #Ddocumento# (Acreditada)' as INTDES,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								#CcuentaCxPAcred#,
								#arguments.lvMonLoc#,
								#Ocodigo#,
                                #MontoPagadoLocal#,
								1,
								#MontoPagadoLocal#
    							,'#varNumeroEvento#'
						from dual
					</cfquery>
		</cfloop>
					<!--- Montos para la DIOT --->

				<cfquery name="rsPagoDiot" datasource="#Arguments.Conexion#">
					select fi.Icodigo,fi.Ecodigo,a.idDocumento,
					round((a.Dmonto+a.DmontoRet) * (fi.OIVAAcreditable + fi.OIVAPagado) / b.Dtotal, 2) as MontoPagado
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo
						inner join DIOT_Control fi
							on fi.CampoId = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo
					where aa.idDocCompensacion =  #Arguments.idDocCompensacion#
					and a.CPTcodigo <> 'AN'
				</cfquery>

				<cfloop query="rsPagoDiot">
					<cfquery datasource="#Arguments.Conexion#">
						update DIOT_Control
						   set OIVAPagado = OIVAPagado + #rsPagoDiot.MontoPagado#,
						   	   OIVAAcreditable = OIVAAcreditable - #rsPagoDiot.MontoPagado#,
						   	   LIVAPagado = LIVAPagado + (#rsPagoDiot.MontoPagado# * TipoCambioIVA),
						   	   LIVAAcreditable = LIVAAcreditable - (#rsPagoDiot.MontoPagado# * TipoCambioIVA),
						   	   BMUsucodigo = #session.Usucodigo#,
						   	   ts_rversion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						where Icodigo     = '#rsPagoDiot.Icodigo#'
						  and Ecodigo     = #rsPagoDiot.Ecodigo#
						  and CampoId  = #rsPagoDiot.idDocumento#
					</cfquery>
				</cfloop>


<!--- ** IEPS ** --->
				<cfquery name="rsImpuestosIepsCxP" datasource="#Arguments.Conexion#">
					select
						b.CPTcodigo,
						b.Ddocumento,
						fi.codIEPS,
						fi.Ecodigo,

						round((a.Dmonto+a.DmontoRet) * fi.MontoCalculadoIeps / fi.TotalFac , 2) as MontoPagadoIeps,
						round(
							round((a.Dmonto+a.DmontoRet) * fi.MontoCalculadoIeps / fi.TotalFac , 2)
						* #TC#, 2) as MontoPagadoLocalIeps,

						aa.CCTcodigo as CCTcodigoNeteo,
						aa.DocCompensacion as DocCompensacion,
						cc.CPTtipo,

						ie.Idescripcion as Idescripcionieps,
						ie.CcuentaCxPAcred as CcuentaACIeps,
						b.Ocodigo,
						a.idDocumento

					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpIEPSDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento

						inner join Impuestos ie
							on  ie.Ecodigo = fi.Ecodigo
							and ie.Icodigo = fi.codIEPS

					where aa.idDocCompensacion =  #Arguments.idDocCompensacion#
				</cfquery>



				<cfloop query="rsImpuestosIepsCxP">
					<!--- Actualizar Monto Pagado CxP--->
					<cfquery datasource="#Arguments.Conexion#">
						update ImpIEPSDocumentosCxP
						set MontoPagadoIeps = MontoPagadoIeps + #rsImpuestosIepsCxP.MontoPagadoIeps#,
						    MontoCalculadoIeps = MontoCalculadoIeps - #rsImpuestosIepsCxP.MontoPagadoIeps#
						where IDdocumento = #idDocumento#
							and codIEPS    = '#codIEPS#'
							and	Ecodigo    = #Ecodigo#
					</cfquery>

			<!--- Inserta Monto Pagado en Tabla de Detalle CxP--->
					<cfquery datasource="#Arguments.Conexion#">

						insert into ImpIEPSDocumentosCxPMov
						(
							IDdocumento, Ecodigo, Fecha,
							CPTcodigo, Ddocumento, CPTpago,
							Periodo, Mes, BMUsucodigo,
							BMFecha, TpoCambio,codIEPS,MontoPagadoIeps,
							CcuentaACIeps,MontoPagadoLocalIeps)
						select #idDocumento#, #Ecodigo#, <cfqueryparam cfsqltype="cf_sql_date" value="#LvFecha#">,
								'#CCTcodigoNeteo#', '#DocCompensacion#', 0,
								#arguments.lvPeriodo#, #arguments.lvMes#, #session.Usucodigo#,
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, #TC#,
							 <cfif len(rsImpuestosIepsCxP.codIEPS)>
							 	'#rsImpuestosIepsCxP.codIEPS#'
							 <cfelse>
							 	null
							 </cfif>,
							 	coalesce(#rsImpuestosIepsCxP.MontoPagadoIeps#,0),
							 <cfif len(rsImpuestosIepsCxP.CcuentaACIeps)>
							 	#rsImpuestosIepsCxP.CcuentaACIeps#
							 <cfelse>
								null
							 </cfif>,
								coalesce(#rsImpuestosIepsCxP.MontoPagadoLocalIeps#,0)
					</cfquery>


			<!---- --->


			<!--- Traslado IEPS CxP  Contabilizacion --->
				<cfif len(CcuentaACIeps)>
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta,
								Mcodigo, Ocodigo,
								INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
								)
						select 	'CCND' as INTORI,
								1 as INTREL,
								<cf_dbfunction name="sPart"		args="'#CPTcodigo#' #_Cat# ' ' #_Cat# '#Ddocumento#';1;20" delimiters=";"> as INTDOC,
       							<cf_dbfunction name="sPart"		args="'#CCTcodigoNeteo#' #_Cat# ' ' #_Cat# '#DocCompensacion#';1;25" delimiters=";"> as INTrEF,
								<cfif CPTtipo EQ 'C'>'D'<cfelse>'C'</cfif> as INTTIP,
								'CxP: #Idescripcionieps# : #CCTcodigo# #Ddocumento# (Acreditada)' as INTDES,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								#CcuentaACIeps#,
								#arguments.lvMonLoc#,
								#Ocodigo#,
                                coalesce(#MontoPagadoLocalIeps#,0),
								1,
								coalesce(#MontoPagadoLocalIeps#,0)
    							,'#varNumeroEvento#'
					</cfquery>
				</cfif>
				</cfloop>
				<!--- <cf_dumptable var="#intarc#"> --->
				<!--- *** --->

				<!--- Balance multimoneda CxP --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
								,CFid
                                )
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CPTtipo = 'C' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxP: ' + i.Idescripcion + ' :' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							b.Mcodigo,
							b.Ocodigo,
							CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100)
								ELSE 0
						    END,
							#TC#,
                        	CASE
								WHEN i.Iporcentaje > 0 THEN ((((CAST(fi.MontoBaseCalc AS decimal(18, 10))) * CAST(i.Iporcentaje AS decimal(18, 10)) / 100) * (((CAST((a.Dmonto+a.DmontoRet) AS decimal(18, 10))) * 100) / (CAST(fi.TotalFac AS decimal(18, 10))))) / 100) * #TC#
								ELSE 0
						    END,
	<!--- Control Evento Inicia --->
    						a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo

					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>

				<! ----- VALORES DEL IEPS ----------------->
					<!--- Balance multimoneda IEPS CxP --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
								,CFid
                                )
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CPTtipo = 'C' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxP: ' + i.Idescripcion + ' :' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							b.Mcodigo,
							b.Ocodigo,
								round((a.Dmonto+a.DmontoRet) * coalesce(fi.MontoCalculadoIeps,0) / fi.TotalFac, 2),
							#TC#,
                        	round(
								round((a.Dmonto+a.DmontoRet) * coalesce(fi.MontoCalculadoIeps,0) / fi.TotalFac, 2)
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpIEPSDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS

					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>

				<!--------------------fin ieps----------------------------------->


				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
    							,CFid
    						)
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,

							case when cc.CPTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxP: ' + i.Idescripcion + ' :' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							#arguments.lvMonLoc#,
							b.Ocodigo,
                            round(
								round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
							* #TC#, 2),
							1,
                            round(
								round((a.Dmonto+a.DmontoRet) * fi.MontoCalculado / fi.TotalFac,2)
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.Icodigo

					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
				</cfquery>

			<!----------- valores del ieps ----------------->

				   <cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
    							,CFid
    						)
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,

							case when cc.CPTtipo = 'D' then 'D' else 'C' end,
							<cf_dbfunction name="concat" args="'CxP: ' + i.Idescripcion + ' :' + b.CPTcodigo + ' ' + rtrim(b.Ddocumento) + ' (CuentaBalancemultimoneda)'" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							#LvarCuentabalancemultimoneda#,
							#arguments.lvMonLoc#,
							b.Ocodigo,
                            round(
								round((a.Dmonto+a.DmontoRet) * coalesce(fi.MontoCalculadoIeps,0) / fi.TotalFac,2)
							* #TC#, 2),
							1,
                            round(
								round((a.Dmonto+a.DmontoRet) * coalesce(fi.MontoCalculadoIeps,0) / fi.TotalFac,2)
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones  cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo

						inner join ImpIEPSDocumentosCxP fi
							on fi.IDdocumento = a.idDocumento
						inner join Impuestos i
							on  i.Ecodigo = fi.Ecodigo
							and i.Icodigo = fi.codIEPS

					where aa.idDocCompensacion = #Arguments.idDocCompensacion#
					and b.Mcodigo != #arguments.lvMonLoc#
					and coalesce(fi.MontoCalculadoIeps,0) != 0
				</cfquery>

				<!------------fin del ieps ---------------------->



				<!--- Documentos de Cuentas x Cobrar --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta, Ocodigo,
							Mcodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
    							,CFid
    						)
					select 	'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CCTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CCTtipo = 'D' then 'C' else 'D' end,
							<cf_dbfunction name="concat" args="'CxC: Eliminación Saldo Documento ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							b.Ccuenta,
							b.Ocodigo,
							b.Mcodigo,
								round(a.Dmonto+a.DmontoRet,2),
							#TC#,
							round(
								round(a.Dmonto+a.DmontoRet,2)
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
							on b.Ecodigo = a.Ecodigo
							and b.CCTcodigo = a.CCTcodigo
							and b.Ddocumento = a.Ddocumento
						inner join CCTransacciones cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on cc.CCTcodigo = b.CCTcodigo
							and cc.Ecodigo = b.Ecodigo
					where a.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>

				<!--- Documentos de Cuentas por Pagar --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta, Ocodigo,
							Mcodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    						,NumeroEvento
	<!--- Control Evento Fin --->
    						,CFid
    						)
					select 'CCND',
							1,
							<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
							<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
							case when cc.CPTtipo = 'D' then 'C' else 'D' end,
							<cf_dbfunction name="concat" args="'CxP: Eliminación Saldo Documento ',b.CPTcodigo,'',b.Ddocumento">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							b.Ccuenta,
							b.Ocodigo,
							b.Mcodigo,
								abs(round(a.Dmonto+a.DmontoRet,2)),
							#TC#,
							round(
								abs(round(a.Dmonto+a.DmontoRet,2))
							* #TC#, 2)
	<!--- Control Evento Inicia --->
    						,a.NumeroEvento
	<!--- Control Evento Fin --->
    						,aa.CFid
					from DocCompensacion  aa <cf_dbforceindex name="PK_DocCompensacion">
						inner join DocCompensacionDCxP a <cf_dbforceindex name="Idx1_DocCompensacionDCxP">
							on a.idDocCompensacion = aa.idDocCompensacion
						inner join EDocumentosCP b <cf_dbforceindex name="PK_EDOCUMENTOSCP">
							on b.IDdocumento = a.idDocumento
						inner join CPTransacciones cc <cf_dbforceindex name="PK_CPTRANSACCIONES">
							on cc.CPTcodigo = b.CPTcodigo
							and cc.Ecodigo = b.Ecodigo
					where a.idDocCompensacion = #Arguments.idDocCompensacion#
				</cfquery>

				<!--- Retenciones: unicamente cuando es Aplicación de Anticipos --->

				<!--- Retencion de Cuentas x Cobrar --->
				<cfif LvarTipoNeteoDocs EQ 2>
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta, Ocodigo,
								Mcodigo,
								INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    						,NumeroEvento
	<!--- Control Evento Fin --->
    						,CFid
    						)
						select 	'CCND',
								1,
								<cf_dbfunction name="sPart"		args="b.CCTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
								<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
								case when cc.CCTtipo = 'D' then 'C' else 'D' end,
								<cf_dbfunction name="concat" args="'CxC: Eliminación Saldo Documento ' + b.CCTcodigo + ' ' + rtrim(b.Ddocumento)" delimiters="+">,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								b.Ccuenta,
								b.Ocodigo,
								<!--- Mcodigo, INTMOE, INTCAM, INTMON--->
								case
									when coalesce(r.Conta_MonOri,0) = 1
									then b.Mcodigo
									else #arguments.lvMonLoc#
								end as Mcodigo,

								round(
									case
										when coalesce(r.Conta_MonOri,0) = 1
										then
											a.DmontoRet
										else
											round(a.DmontoRet * #TC#, 2)
										<!---RETENCION COMPUESTA--->
									end * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
								,2) as INTMOE,

								case
									when coalesce(r.Conta_MonOri,0) = 1
									then #TC#
									else 1
								end as INTCAM,

								round(
									round(a.DmontoRet * #TC#, 2)
									 <!---RETENCION COMPUESTA--->
									 * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
								,2) as INTMON
	<!--- Control Evento Inicia --->
    							,a.NumeroEvento
	<!--- Control Evento Fin --->
    							,aa.CFid
						from DocCompensacion aa <cf_dbforceindex name="PK_DocCompensacion">
							inner join DocCompensacionDCxC a <cf_dbforceindex name="Idx1_DocCompensacionDCxC">
								on a.idDocCompensacion = aa.idDocCompensacion
							inner join Documentos b <cf_dbforceindex name="PK_DOCUMENTOS">
								on b.Ecodigo = a.Ecodigo
								and b.CCTcodigo = a.CCTcodigo
								and b.Ddocumento = a.Ddocumento
							inner join CCTransacciones cc <cf_dbforceindex name="PK_CCTRANSACCIONES">
								on cc.CCTcodigo = b.CCTcodigo
								and cc.Ecodigo = b.Ecodigo
							inner join Retenciones r 		<!--- retencion documento (simple/comp) --->
								on r.Ecodigo = b.Ecodigo
								and r.Rcodigo = b.Rcodigo
							left outer join RetencionesComp rc
								on rc.Ecodigo = r.Ecodigo
								and rc.Rcodigo = r.Rcodigo
							left outer join Retenciones rd 	<!--- retencion hija --->
								on rd.Ecodigo = rc.Ecodigo
								and rd.Rcodigo = rc.RcodigoDet
						where a.idDocCompensacion = #Arguments.idDocCompensacion#
					</cfquery>

					<!--- Genera los movimientos de Presupuesto en Efectivo (EJERCIDO Y PAGADO) a partir del NAP de las facturas pagadas --->
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select Pvalor
						  from Parametros
						 where Ecodigo = #Arguments.Ecodigo#
						   and Pcodigo = 1140
					</cfquery>
					<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>
					<cfif LvarGenerarEjercido>
						<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
						<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'EJ')>
						<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'P')>
					<cfelse>
						<!--- Movimientos de PAGADO: Presupuesto normal --->
						<cfset sbPresupuestoAntsEfectivo_CxC (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'P')>
					</cfif>
				</cfif>

				<!--- Retencion de Cuentas por Pagar --->
				<cfif LvarTipoNeteoDocs EQ 3>
					<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# (
								INTORI, INTREL, INTDOC, INTREF,
								INTTIP, INTDES, INTFEC,
								Periodo, Mes, Ccuenta, Ocodigo,
								Mcodigo,
								INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    							,NumeroEvento
	<!--- Control Evento Fin --->
    							,CFid
    							)
						select 'CCND',
								1,
								<cf_dbfunction name="sPart"		args="b.CPTcodigo #_CAT# ' ' #_CAT# b.Ddocumento;1;20" delimiters=";">,
								<cf_dbfunction name="sPart"		args="aa.CCTcodigo #_CAT# ' ' #_CAT# aa.DocCompensacion;1;25" delimiters=";">,
								cc.CPTtipo,
								<cf_dbfunction name="concat" args="'CxP: Retencion Documento ',b.CPTcodigo,'',b.Ddocumento">,
								'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',
								#arguments.lvPeriodo#,
								#arguments.lvMes#,
								b.Ccuenta,
								b.Ocodigo,

								<!--- Mcodigo, INTMOE, INTCAM, INTMON--->
								case
									when coalesce(r.Conta_MonOri,0) = 1
									then b.Mcodigo
									else #arguments.lvMonLoc#
								end as Mcodigo,

								round(
									case
										when coalesce(r.Conta_MonOri,0) = 1
										then
											a.DmontoRet
										else
											round(a.DmontoRet * #TC#, 2)
										<!---RETENCION COMPUESTA--->
									end * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
								,2) as INTMOE,

								case
									when coalesce(r.Conta_MonOri,0) = 1
									then #TC#
									else 1
								end as INTCAM,

								round(
									round(a.DmontoRet * #TC#, 2)
									 <!---RETENCION COMPUESTA--->
									 * coalesce (rd.Rporcentaje, r.Rporcentaje) / r.Rporcentaje
								,2) as INTMON
	<!--- Control Evento Inicia --->
    							,a.NumeroEvento
	<!--- Control Evento Fin --->
    							,aa.CFid
						from DocCompensacion  aa
							inner join DocCompensacionDCxP a
								on a.idDocCompensacion = aa.idDocCompensacion
							inner join EDocumentosCP b
								on b.IDdocumento = a.idDocumento
							inner join CPTransacciones cc
								on cc.CPTcodigo = b.CPTcodigo
								and cc.Ecodigo = b.Ecodigo
							inner join Retenciones r 		<!--- retencion documento (simple/comp) --->
								on r.Ecodigo = b.Ecodigo
								and r.Rcodigo = b.Rcodigo
							left outer join RetencionesComp rc
								on rc.Ecodigo = r.Ecodigo
								and rc.Rcodigo = r.Rcodigo
							left outer join Retenciones rd 	<!--- retencion hija --->
								on rd.Ecodigo = rc.Ecodigo
								and rd.Rcodigo = rc.RcodigoDet
						where a.idDocCompensacion = #Arguments.idDocCompensacion#
					</cfquery>

					<!--- Genera los movimientos de Presupuesto en Efectivo (EJERCIDO Y PAGADO) a partir del NAP de las facturas pagadas --->
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
						select Pvalor
						  from Parametros
						 where Ecodigo = #Arguments.Ecodigo#
						   and Pcodigo = 1140
					</cfquery>
					<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>
					<cfif LvarGenerarEjercido>
						<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
						<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'EJ')>
						<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'P')>
					<cfelse>
						<!--- Movimientos de PAGADO: Presupuesto normal --->
						<cfset sbPresupuestoAntsEfectivo_CxP (arguments.Conexion,Arguments.idDocCompensacion,arguments.lvFecha,arguments.lvPeriodo,arguments.lvMes,false,'P')>
					</cfif>
				</cfif>

				<!--- Encabezado de Neteo, cuando no es balanceado ??? --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into #INTARC# (
							INTORI, INTREL, INTDOC, INTREF,
							INTTIP, INTDES, INTFEC,
							Periodo, Mes, Ccuenta,
							Mcodigo, Ocodigo,
							INTMOE, INTCAM, INTMON
	<!--- Control Evento Inicia --->
    						,NumeroEvento
	<!--- Control Evento Fin --->
    						,CFid
    						)
					select
							'CCND',
							1,
							<cf_dbfunction name="sPart"		args="a.CCTcodigo #_CAT# ' ' #_CAT# a.DocCompensacion;1;20" delimiters=";">,
       						<cf_dbfunction name="sPart"		args="a.CCTcodigo #_CAT# ' ' #_CAT# a.DocCompensacion;1;25" delimiters=";">,
							case when b.CCTtipo = 'D' then 'C' else 'D' end,
							<cf_dbfunction name="concat" args="'Neteo: Eliminación de Saldos de Documento ' + a.DocCompensacion" delimiters="+">,
							'#YEAR(arguments.lvFecha)##RepeatString('0',2-Len(MONTH(arguments.lvFecha)))##MONTH(arguments.lvFecha)##RepeatString('0',2-Len(DAY(arguments.lvFecha)))##DAY(arguments.lvFecha)#',

							#arguments.lvPeriodo#,
							#arguments.lvMes#,
							/*c.SNcuentacxc,*/
							c.CFcuenta,
							a.Mcodigo,
							a.Ocodigo,
								abs(round(a.Dmonto, 2)),
							#TC#,
							round(
								abs(round(a.Dmonto, 2))
							* #TC#, 2)
    						,'#varNumeroEvento#'
                            ,a.CFid
					from DocCompensacion a <cf_dbforceindex name="PK_DocCompensacion">
						inner join CCTransacciones b <cf_dbforceindex name="PK_CCTRANSACCIONES">
							on b.CCTcodigo = a.CCTcodigo
							and b.Ecodigo = a.Ecodigo
						inner join SNCCTcuentas c <cf_dbforceindex name="PK_SNEGOCIOS">
							on c.Ecodigo = a.Ecodigo
							and c.SNcodigo = a.SNcodigo
							and c.CCTcodigo='SM'
					where a.idDocCompensacion = #Arguments.idDocCompensacion#
					and a.Dmonto > 0
				</cfquery>

				<cfif Arguments.Debug>
					<cfquery name="rsDebug" datasource="#Arguments.Conexion#">
					 select * from #INTARC#
					</cfquery>
					<cfdump var="#rsDebug#">
					<cftransaction action="rollback"/>
					<cf_abort errorInterfaz="">
				</cfif>

				<cfinvoke
					component="sif.Componentes.CG_GeneraAsiento"
					method="GeneraAsiento"
					returnvariable="IDcontable"
					oorigen="CCND"
					eperiodo="#arguments.lvPeriodo#"
					emes="#arguments.lvMes#"
					efecha="#arguments.lvFecha#"
					edescripcion="#arguments.lvDescripcion#"
					edocbase="#arguments.lvDocCompensacion#"
					ereferencia="#arguments.lvCCTcodigo#"
					debug="#Arguments.Debug#"
					Ocodigo="#rsDocCompensacion.Ocodigo#"
                    NumeroEvento = "#varNumeroEvento#"
                    />

	</cffunction>

	<!--- Método: getTipoCambio: Obtiene el Tipo de Cambio en el Histórico dada una Fecha y Moneda --->
	<cffunction access="private" name="getTipoCambio" output="false" returntype="numeric">
		<cfargument name="vMcodigo" required="yes" type="string">
		<cfargument name="vDfecha" required="no" type="string">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="string">

		<cfset var retTC = 1>

		<cfif isdefined('Arguments.vDfecha') and len(trim(Arguments.vDfecha))>
			<cfset lvDfecha = Arguments.vDfecha>
		<cfelse>
			<cfset lvDfecha = Now()>
		</cfif>

		<cfquery name="rsMonedaDesc" datasource="#Arguments.Conexion#">
			select Mnombre
			from Monedas
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.vMcodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>

		<cfquery name="rsMaxFecha" datasource="#Arguments.Conexion#">
			select max(Hfecha) as maxFecha
			from Htipocambio
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.vMcodigo#">
			and <cf_dbfunction name="to_datechar" args="Hfecha"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#lvDfecha#">
		</cfquery>

		<cfif isdefined('rsMaxFecha') and rsMaxFecha.recordCount GT 0>
			<cfquery name="rsTC" datasource="#Arguments.Conexion#">
				select TCcompra
				from Htipocambio
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.vMcodigo#">
				and Hfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#rsMaxFecha.maxFecha#">
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50981"
							msg  = "Error en CP_InterfazPagos. No se encontró el Tipo de Cambio para la Moneda @errorDat_1@ para la fecha @errorDat_2@."
							errorDat_1="#rsMonedaDesc.Mnombre#"
							errorDat_2="#lvDfecha#"
			>
		</cfif>

		<cfif isdefined('rsTC') and rsTC.recordCount GT 0 and rsTC.TCcompra GT 0>
			<cfset retTC = rsTC.TCcompra>
		</cfif>

		<cfreturn retTC>
	</cffunction>

	<cffunction name="DeterminarTipoCompensacionDocs" returntype="numeric" access="public">
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<!--- Periodo/Mes de Auxiliares --->
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAnoMesAux = rsPeriodo.Pvalor * 100 + rsMes.Pvalor>

		<!--- Periodo de Presupuesto --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CPPid, CPPestado
			  from CPresupuestoPeriodo
			 where Ecodigo = #Arguments.Ecodigo#
			   and #LvarAnoMesAux# between CPPanoMesDesde and CPPanoMesHasta
		</cfquery>

		<!--- Sin Presupuesto no hay restricciones --->
		<cfif rsSQL.CPPid EQ "" OR rsSQL.CPPestado EQ "5">
			<cfreturn 0>
		</cfif>

		<!--- En alta se indica que puede ser cualquiera con restricciones --->
		<cfif Arguments.idDoc EQ "-1">
			<cfreturn 1>
		</cfif>

		<cfset sbQueryDocs(Arguments.idDoc)>

		<cfif rsDocs.CxCs+rsDocs.CxPs EQ 0>
			<!--- Sin Documentos puede ser cualquiera con restricciones --->
			<cfreturn 1>
		<cfelseif rsDocs.cxcANTs+rsDocs.cxpANTs EQ 0>
			<!--- Sin Anticipos es Neteo Documentos --->
			<cfset LvarTipo = 1>
		<cfelseif rsDocs.cxcANTs GT 0 AND rsDocs.cxcFAVs EQ 0 AND rsDocs.CxPs EQ 0>
			<!--- Anticipos CxC sin CxC a favor ni CxP es Aplicacion Anticipos CxC --->
			<cfset LvarTipo = 2>
		<cfelseif rsDocs.cxpANTs GT 0 AND rsDocs.cxpFAVs EQ 0 AND rsDocs.CxCs EQ 0>
			<!--- Anticipos CxP sin CxP a favor ni CxC es Aplicacion Anticipos CxP --->
			<cfset LvarTipo = 3>
		<cfelseif rsDocs.cxcDOCs+rsDocs.cxcFAVs EQ 0 AND rsDocs.cxpDOCs+rsDocs.cxpFAVs EQ 0>
			<!--- Sólo Anticipos es Neteo Anticipos --->
			<cfset LvarTipo = 4>
		<cfelse>
			<!--- ERROR --->
			<cfreturn -1>
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update DocCompensacion
			   set TipoNeteoDocs = #LvarTipo#
			 where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDoc#">
			   and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfreturn LvarTipo>
	</cffunction>

	<cffunction name="VerificarTipoNeteoDocs" returntype="string" access="public">
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<cfset sbQueryDocs(Arguments.idDoc)>

		<cfif rsDocs.CxCs+rsDocs.CxPs EQ 0>
			<!--- Sin Documentos puede ser cualquiera --->
			<cfreturn "">
		<cfelseif rsDocs.TipoNeteoDocs EQ 1 AND NOT (rsDocs.cxcANTs+rsDocs.cxpANTs EQ 0)>
			<!--- Sin Anticipos es Neteo Documentos --->
			<cfreturn "Neteo de Documentos de CxC y CxP: No se permiten Anticipos de Efectivo">
		<cfelseif rsDocs.TipoNeteoDocs EQ 2 AND NOT (rsDocs.cxcANTs GTE 0 AND rsDocs.CxPs EQ 0)>
			<!--- Anticipos CxC sin CxP es Aplicacion Anticipos CxC --->
			<cfreturn "Aplicación de Anticipos de CxC: No se permiten Documentos de CxP">
		<cfelseif rsDocs.TipoNeteoDocs EQ 2 AND NOT (rsDocs.cxcANTs GTE 0 AND rsDocs.cxcFAVs EQ 0)>
			<!--- Anticipos CxC sin CxP es Aplicacion Anticipos CxC --->
			<cfreturn "Aplicación de Anticipos de CxC: No se permiten Documentos a favor de CxC que no sean de Anticipos">
		<cfelseif rsDocs.TipoNeteoDocs EQ 3 AND NOT (rsDocs.cxpANTs GTE 0 AND rsDocs.CxCs EQ 0)>
			<!--- Anticipos CxP sin CxC es Aplicacion Anticipos CxP --->
			<cfreturn "Aplicación de Anticipos de CxP: No se permiten Documentos de CxC">
		<cfelseif rsDocs.TipoNeteoDocs EQ 3 AND NOT (rsDocs.cxpANTs GTE 0 AND rsDocs.cxpFAVs EQ 0)>
			<!--- Anticipos CxP sin CxC es Aplicacion Anticipos CxP --->
			<cfreturn "Aplicación de Anticipos de CxP: No se permiten Documentos a favor que no sean de Anticipos">
		<cfelseif rsDocs.TipoNeteoDocs EQ 4 AND NOT (rsDocs.cxcDOCs+rsDocs.cxcFAVs EQ 0 AND rsDocs.cxpDOCs+rsDocs.cxpFAVs EQ 0)>
			<!--- Sólo Anticipos es Neteo Anticipos --->
			<cfreturn "Neteo de Anticipos de CxC y CxP: No se permiten Documentos que no son Anticipos de Efectivo">
		</cfif>
		<cfreturn "">
	</cffunction>

	<cffunction name="sbQueryDocs" returntype="void" access="private">
		<cfargument name="idDoc" type="numeric">
		<cfargument name="Ecodigo" type="string" default="#session.Ecodigo#">
		<cfargument name="conexion" type="string" default="#session.dsn#">

		<cfif isdefined("rsDocs")>
			<cfreturn>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#">
			delete from DocCompensacionDCxC
			 where (
					select count(1)
					  from Documentos d
					 where d.Ddocumento	= DocCompensacionDCxC.Ddocumento
					   and d.CCTcodigo	= DocCompensacionDCxC.CCTcodigo
					   and d.Ecodigo	= DocCompensacionDCxC.Ecodigo
					) = 0
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from DocCompensacionDCxP
			 where (
					select count(1)
					  from EDocumentosCP d
					 where d.IDdocumento = DocCompensacionDCxP.idDocumento
					) = 0
		</cfquery>

		<cfquery name="rsDocs" datasource="#Arguments.Conexion#">
			select	TipoNeteoDocs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxC b
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
						)
					,0) as CXCs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= DocCompensacion.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CCTtipo = 'D'
						)
					,0) as cxcDOCs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= b.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CCTtipo = 'C'
							   and (
							   		select count(1)
									  from DDocumentos d
									 where d.Ddocumento	= b.Ddocumento
									   and d.CCTcodigo	= b.CCTcodigo
									   and d.Ecodigo	= b.Ecodigo
									) > 0
						)
					,0) as cxcFAVs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxC b
								inner join CCTransacciones t
									 on t.CCTcodigo	= b.CCTcodigo
									and t.Ecodigo 	= b.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CCTtipo = 'C'
							   and (
							   		select count(1)
									  from DDocumentos d
									 where d.Ddocumento	= b.Ddocumento
									   and d.CCTcodigo	= b.CCTcodigo
									   and d.Ecodigo	= b.Ecodigo
									) = 0
						)
					,0) as cxcANTs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxP b
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
						)
					,0) as CxPs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocCompensacion.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CPTtipo = 'C'
						)
					,0) as cxpDOCs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocCompensacion.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CPTtipo = 'D'
							   and (
							   		select count(1)
									  from DDocumentosCP d
									 where d.IDdocumento	= b.idDocumento
									) > 0
						)
					,0) as cxpFAVs,
					coalesce(
						(
							select count(1)
							  from DocCompensacionDCxP b
								inner join CPTransacciones t
									 on t.CPTcodigo	= b.CPTcodigo
									and t.Ecodigo 	= DocCompensacion.Ecodigo
							 where b.idDocCompensacion = DocCompensacion.idDocCompensacion
							   and t.CPTtipo = 'D'
							   and (
							   		select count(1)
									  from DDocumentosCP d
									 where d.IDdocumento	= b.idDocumento
									) = 0
						)
					,0) as cxpANTs
			  from DocCompensacion
			 where idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.idDoc#">
			   and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
	</cffunction>

	<cffunction name="sbPresupuestoAntsEfectivo_CxC" access="private">
		<cfargument name="Conexion">
		<cfargument name="idDocCompensacion">
		<cfargument name="Fecha">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Anulacion">
		<cfargument name="TipoMov">

		<!--- Convierte las Ejecuciones del NAP de CxP a Pagado --->
		<!--- OJO, cuando se implemente Contabilizacion en Recepcion, hay que tomar en cuenta el NAP de la Recepción --->
		<cf_dbfunction name="to_char" args="sp.TESSPnumero" returnVariable="LvarTESSPnumero">

		<cfset LvarMontoPagado = "round((d.Dmonto + d.DmontoRet) / cc.Dtotal * nap.CPNAPDmontoOri,2)">
		<cfquery datasource="#Arguments.Conexion#">
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
			select  'CCND',
					aa.DocCompensacion,
					aa.CCTcodigo,
					<cf_dbfunction name="concat" args="'CxC: ';cc.CCTcodigo;'-';cc.Ddocumento" delimiters=";">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,

					coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
					<cfif Arguments.TipoMov NEQ 'P'>-</cfif>idDetalle as NumeroLineaID,
					nap.CFcuenta,																				<!--- CFuenta --->
					nap.Ocodigo,																				<!--- Oficina --->

						nap.Mcodigo,																				<!--- Mcodigo --->
						<cfif Arguments.Anulacion>-</cfif>#LvarMontoPagado# as MontoOrigen,
						#TC# as TC,
						<cfif Arguments.Anulacion>-</cfif>round(#LvarMontoPagado# * #TC#, 2) as MontoLocal,

					'#Arguments.TipoMov#' as Tipo,
					nap.CPNAPnum, nap.CPNAPDlinea,
					nap.PCGDid,
					<cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
				from DocCompensacion aa
					inner join DocCompensacionDCxC d
						 on d.idDocCompensacion = aa.idDocCompensacion
					inner join Documentos cc
						 on cc.Ecodigo		= d.Ecodigo
						and cc.CCTcodigo	= d.CCTcodigo
						and cc.Ddocumento	= d.Ddocumento
					inner join CPNAP nape
						  on nape.Ecodigo				= cc.Ecodigo
						 and nape.CPNAPmoduloOri		= 'CCFC'
						 and nape.CPNAPdocumentoOri		= cc.Ddocumento
						 and nape.CPNAPreferenciaOri	= cc.CCTcodigo
					inner join CPNAPdetalle nap
						  on nap.Ecodigo		= nape.Ecodigo
						 and nap.CPNAPnum		= nape.CPNAPnum
						 and nap.CPNAPDtipoMov = 'E'
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
	</cffunction>

	<cffunction name="sbPresupuestoAntsEfectivo_CxP" access="private">
		<cfargument name="Conexion">
		<cfargument name="idDocCompensacion">
		<cfargument name="Fecha">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Anulacion">
		<cfargument name="TipoMov">

		<!--- Convierte las Ejecuciones del NAP de CxP a Pagado --->
		<!--- OJO, cuando se implemente Contabilizacion en Recepcion, hay que tomar en cuenta el NAP de la Recepción --->

<!--- <cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
 select *
 from  #request.intarc#
 </cfquery>
 <br>INTARC<br>
 <cf_dump var="#rs_revisa_Intarc#">   --->

		<cfset LvarMontoPagado = "round((d.Dmonto + d.DmontoRet) / cp.Dtotal * nap.CPNAPDmontoOri,2)">
		delete #request.intPresupuesto#
        <cfquery datasource="#Arguments.Conexion#">
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
			select  'CCND',
					aa.DocCompensacion,
					aa.CCTcodigo,
					<cf_dbfunction name="concat" args="'CxP: ';cp.CPTcodigo;'-';rtrim(cp.Ddocumento)" delimiters=";">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,

					coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
					<cfif Arguments.TipoMov NEQ 'P'>-</cfif>idDetalle as NumeroLineaID,
					nap.CFcuenta,																				<!--- CFuenta --->
					nap.Ocodigo,																				<!--- Oficina --->

						nap.Mcodigo,																				<!--- Mcodigo --->
						<cfif Arguments.Anulacion>-</cfif>#LvarMontoPagado# as MontoOrigen,
						#TC# as TC,
						<cfif Arguments.Anulacion>-</cfif>round(#LvarMontoPagado# * #TC#, 2) as MontoLocal,

					'#Arguments.TipoMov#' as Tipo,
					nap.CPNAPnum, nap.CPNAPDlinea,
					nap.PCGDid,
					<cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
				from DocCompensacion  aa
					inner join DocCompensacionDCxP d
						on d.idDocCompensacion = aa.idDocCompensacion
					inner join HEDocumentosCP cp
						on cp.IDdocumento = d.idDocumento
					inner join CPNAPdetalle nap
						  on nap.Ecodigo		= cp.Ecodigo
						 and nap.CPNAPnum		= cp.NAP
						 and nap.CPNAPDtipoMov = 'E'
				where aa.idDocCompensacion = #Arguments.idDocCompensacion#
		</cfquery>
	</cffunction>
</cfcomponent>

