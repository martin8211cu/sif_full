<!--- Posteo de Documentos a Favor de CxP
Creador por: Marcel de M.
 Fecha: 12 Febrero de 2002
Migrado a componete por GustavoF/MauricioE.
 Fecha: 25-3-2008

DAmontodoc 		= Monto a Aplicar al Documento en moneda Documento
DAmonto			= Monto a Aplicar al Documento en moneda Pago

"DAtotaldoc" 	= Total a Pagar en moneda Documento = DAmontodoc - Rmontodoc
DAtotal			= Total a Pagar en moneda Pago
--->



<cfcomponent>
	<cffunction name="CP_PosteoDocsFavorCxP" access="public" output="false" returntype="string">
		<cfargument name='ID' 		type='numeric' 	required='true' 		hint="ID del Documento">
		<cfargument name='Ecodigo'		type='numeric' 	required='true' 	hint="Codigo empresa">
		<cfargument name='CPTcodigo'	type='string' 	required='true' 	hint="Código de la Transacción">
		<cfargument name='Ddocumento'	type='string' 	required='true' 	hint="Número del documento">
		<cfargument name='usuario' 		type='string' 	required='false'	hint="Login del usuario">
		<cfargument name='Usucodigo'	type='numeric' 	required='true' 	hint="Codigo del usuario">
		<cfargument name='fechaDoc' 	type='string' 	required='true' 	hint="Usar Fecha del Documento">
		<cfargument name='debug' 		type='string' 	required='false' 	default="N" hint="Ejecuta el debug S= si  N= no">
		<cfargument name='Conexion' 	type='string' 	required='false' 	default="#Session.DSN#">

		<cfset LvarGblConexion = Arguments.Conexion>
		<cfset LvarGblID       = Arguments.ID>

		<!--- Validaciones Preposteo --->
		<cfquery name="rsValida" datasource="#LvarGblConexion#">
			select count(1) as cantidad
			from EAplicacionCP
			where ID = #LvarGblID#
		</cfquery>
		<cfif rsValida.cantidad eq 0>
			<cf_errorCode	code = "50990" msg = "El documento a Favor indicado no existe! Proceso Cancelado!.">
		</cfif>

		<cfquery name="rsValida" datasource="#LvarGblConexion#">
			select count(1) as cantidad
			from DAplicacionCP
			where ID = #LvarGblID#
		</cfquery>

		<cfif rsValida.cantidad eq 0>
			<cf_errorCode	code = "50992" msg = "El documento a Favor indicado no tiene detalles! Proceso Cancelado!.">
		</cfif>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select Pvalor as Periodo
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 50
		</cfquery>
		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Periodo)) EQ 0>
			<cf_errorCode	code = "51146" msg = "No se ha definido el periodo de Auxiliares! Proceso Cancelado!.">
		</cfif>
		<cfset LvarPeriodo = rsSQL.Periodo>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select Pvalor as Mes
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 60
		</cfquery>

		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Mes)) EQ 0>
			<cf_errorCode	code = "51147" msg = "No se ha definido el Mes de Auxiliares! Proceso Cancelado!.">
		</cfif>

		<cfset LvarMes = rsSQL.Mes>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select Pvalor as CtaPuente
			from Parametros
			where Ecodigo = #Arguments.Ecodigo#
			  and Pcodigo = 200
			  and Mcodigo = 'CG'
		</cfquery>

		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.CtaPuente)) EQ 0>
			<cf_errorCode	code = "51148" msg = "No se ha definido la cuenta contable de trabajo! Proceso Cancelado!.">
		</cfif>

		<cfset LvarCuentaPuente = rsSQL.CtaPuente>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select p.Pvalor
			from Parametros p
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo = 130
		</cfquery>
		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Pvalor)) EQ 0>
			<cf_errorCode	code = "51149" msg = "No se ha definido la cuenta contable de ingreso por diferencial cambiario! Proceso Cancelado!.">
		</cfif>

		<cfset LvarCuentaIngDifCam = rsSql.Pvalor>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select p.Pvalor
			from Parametros p
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo = 140
		</cfquery>
		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Pvalor)) EQ 0>
			<cf_errorCode	code = "51150" msg = "No se ha definido la cuenta contable de Gasto por diferencial cambiario! Proceso Cancelado!.">
		</cfif>

		<cfset LvarCuentaGasDifCam = rsSql.Pvalor>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select p.Pvalor
			from Parametros p
			where Ecodigo = #Arguments.Ecodigo#
			and Pcodigo = 200
		</cfquery>
		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Pvalor)) EQ 0>
			<cf_errorCode	code = "51151" msg = "No se ha definido la cuenta contable de Balance Multimoneda! Proceso Cancelado!.">
		</cfif>

		<cfset LvarCuentabalancemultimoneda = rsSql.Pvalor>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select Mcodigo
			from Empresas
			where Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cfif rsSQL.recordcount NEQ 1 or len(trim(rsSQL.Mcodigo)) EQ 0>
			<cf_errorCode	code = "51152" msg = "No se ha definido la Moneda Local de la Empresa! Proceso Cancelado!.">
		</cfif>

		<cfset LvarMonLocal = rsSQL.Mcodigo>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select a.EAfecha, a.Mcodigo, a.SNcodigo, a.CPTcodigo, a.Ddocumento
			from EAplicacionCP a
			where a.ID = #LvarGblID#
		</cfquery>

		<cfset LvarFecha = now()>
		<cfset LvarEAfecha = createodbcdate(rsSQL.EAfecha)>
		<cfset LvarfechaChar = datepart('YYYY', LvarEAfecha) & datepart('M', LvarEAfecha) & datepart('D', LvarEAfecha)>
		<cfset LvarMonedaNC = rsSQL.Mcodigo>
		<cfset LvarSNcodigo = rsSQL.SNcodigo>
		<cfset LvarCPTcodigo = rsSQL.CPTcodigo>
		<cfset LvarDdocumento = rsSQL.Ddocumento>
		<cfset LvarDescripcion = "Aplicación de Doc. Favor CxP: " & LvarCPTcodigo & "-" & LvarDdocumento>

		<cfquery datasource="#LvarGblConexion#" name="rsSQL">
			select sum(DAmonto) as EAmonto
			  from DAplicacionCP b
			 where b.ID = #LvarGblID#
		</cfquery>
		<cfset LvarEAmonto = rsSQL.EAmonto>

		<cfquery name="rsSQL" datasource="#LvarGblConexion#">
			select b.Ocodigo
			from EDocumentosCP b
			where b.IDdocumento = #LvarGblID#
		</cfquery>

		<cfset LvarOcodigo = rsSQL.Ocodigo>

		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
		<cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#Arguments.Conexion#"></cfinvoke>

		<cftransaction>

       		<!---- Control  de Eventos----->
            <cfinvoke component="sif.Componentes.CG_ControlEvento"
                method	 ="ValidaEvento"
                Origen	 ="CPPA"
                Transaccion="#Arguments.CPTcodigo#"
                Conexion	="#Arguments.conexion#"
                Ecodigo		="#Arguments.Ecodigo#"
                returnvariable	= "varValidaEvento"
            />
            <cfset varNumeroEvento = "">
			<cfif varValidaEvento GT 0>
                <cfinvoke component="sif.Componentes.CG_ControlEvento"
                    method		= "CG_GeneraEvento"
                    Origen		= "CPPA"
                    Transaccion	= "#Arguments.CPTcodigo#"
                    Documento 	= "#Arguments.Ddocumento#"
                    SocioCodigo = "#LvarSNcodigo#"
                    Conexion	= "#Arguments.Conexion#"
                    Ecodigo		= "#Arguments.Ecodigo#"
                    returnvariable	= "arNumeroEvento"/>
                <cfif arNumeroEvento[3] EQ "">
                    <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
                </cfif>
                <cfset varNumeroEvento = arNumeroEvento[3]>
				<cfset varIDEvento = arNumeroEvento[4]>
              	<!--- Genera la relacion con la Nota de Credito Aplicada --->
                <cfquery name="rsNotaAplica" datasource="#LvarGblConexion#">
                	select ID, Ecodigo, CPTcodigo, Ddocumento, SNcodigo
                    from EAplicacionCP
                    where ID = #LvarGblID#
                </cfquery>
                <cfinvoke component="sif.Componentes.CG_ControlEvento"
                    method="CG_RelacionaEvento"
                    IDNEvento="#varIDEvento#"
                    Origen="CPFC"
                    Transaccion="#rsNotaAplica.CPTcodigo#"
                    Documento="#rsNotaAplica.Ddocumento#"
                    SocioCodigo="#rsNotaAplica.SNcodigo#"
                    Conexion="#LvarGblConexion#"
                    Ecodigo="#rsNotaAplica.Ecodigo#"
                    returnvariable="arRelacionEvento"
                />
                <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
                    <cfset varNumeroEvento = arRelacionEvento[4]>
                </cfif>
				<!--- Genera la relacion con las Facturas Aplicadas --->
                <cfquery name="rsDocumentoAplica" datasource="#LvarGblConexion#">
                	select ID, DAlinea, Ecodigo,DAtransref, DAdocref, SNcodigo, DAidref
                    from DAplicacionCP
                    where ID = #LvarGblID#
                </cfquery>
                <cfloop query="rsDocumentoAplica">
                    <cfinvoke component="sif.Componentes.CG_ControlEvento"
                        method="CG_RelacionaEvento"
                        IDNEvento="#varIDEvento#"
                        Origen="CPFC"
                        Transaccion="#rsDocumentoAplica.DAtransref#"
                        Documento="#rsDocumentoAplica.DAdocref#"
                        SocioCodigo="#rsDocumentoAplica.SNcodigo#"
                        Conexion="#LvarGblConexion#"
                        Ecodigo="#rsDocumentoAplica.Ecodigo#"
                        returnvariable="arRelacionEvento"
                    />
                    <cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
						<cfset varNumeroEventoDP = arRelacionEvento[4]>
                    <cfelse>
                        <cfset varNumeroEventoDP = varNumeroEvento>
                    </cfif>
                    <cfquery datasource="#LvarGblConexion#">
                    	update DAplicacionCP
                        set NumeroEvento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varNumeroEventoDP#">
                        where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumentoAplica.ID#">
                        and DAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumentoAplica.DAlinea#">
                    </cfquery>
            	</cfloop>
            </cfif>


			<!---- INSERTAR EN  LA DIOT  UN  NUEVO  REGISTRO  CON EL  PAGO DEL  ANTICIPO ---->
			<!--- COM  LA RELACION
			CPTcodigo	Ddocumento	CPTRcodigo	DRdocumento		Dtotal
				AN			3554       	FC			C79948      4150.00
				CALCULANDO LA PARTE PROPORCIONAL DEL  IVA DE ACUERDO  A LAS FACTURAS
				---->
			<cfquery name="rsAnticipoFCDIOT" datasource="#session.dsn#">
				select
					c.Ecodigo, c.CPTcodigo, ltrim(rtrim(c.Ddocumento)) as NoAnticipo,
					b.DAtransref, Ltrim(rtrim(b.DAdocref)) as Factura, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#">,
					a.Ccuenta, a.Ocodigo, a.SNcodigo, c.Mcodigo,
					c.EAtipocambio, b.DAtotal,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarEAfecha#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarEAfecha#">,
					#LvarPeriodo#, #LvarMes#, c.EAusuario,
					b.DAtipocambio, a.Mcodigo, b.DAmontodoc, <!--- #LvarIDcontable#, --->
					a.IDdocumento, a.Rcodigo,
					case when coalesce(EDretporigen,0)>0 then EDretporigen
					 when coalesce(EDmontoretori,0)>0 then EDmontoretori
					 when coalesce(EDretencionVariable,0)>0 then EDretencionVariable
					else 0 end as MontoRetIVA,
					CASE
			           WHEN i.Iporcentaje > 0 THEN CAST((CAST(b.DAmontodoc AS decimal(18, 10)) / CAST(a.Dtotal AS decimal(18, 10))) * (CAST(e.TotalFac AS decimal(18, 10)) - CAST(e.SubTotalFac AS decimal(18, 10))) * CAST(b.DAtipocambio AS decimal(18, 10)) AS decimal(18, 10))
			           ELSE 0
			        END AS MontoCalculado,
					sum(d.DDtotallin) DDtotallin,
					ltrim(rtrim(d.Icodigo)) Icodigo, a.Dtotal,
					CASE
			           WHEN i.Iporcentaje > 0 THEN CAST((CAST(b.DAmontodoc AS decimal(18, 10)) / CAST(a.Dtotal AS decimal(18, 10))) * (CAST(e.TotalFac AS decimal(18, 10)) - CAST(e.SubTotalFac AS decimal(18, 10))) * CAST(b.DAtipocambio AS decimal(18, 10)) AS decimal(18, 10)) / 0.16
			           ELSE a.Dtotal
			        END AS MontoSinIVA,
					b.DAmontodoc m1, a.Dtotal m2 ,  (e.TotalFac - e.SubTotalFac) m3
				FROM EAplicacionCP c
				INNER JOIN DAplicacionCP b
				INNER JOIN EDocumentosCP a ON a.Ecodigo = b.Ecodigo
					AND a.CPTcodigo = b.DAtransref
					AND a.Ddocumento = b.DAdocref
					AND a.SNcodigo = b.SNcodigo
					AND a.IDdocumento = b.DAidref ON b.ID = c.ID
				INNER JOIN DDocumentosCP d ON a.Ecodigo = d.Ecodigo AND a.IDdocumento = d.IDdocumento
					AND a.IDdocumento = d.IDdocumento
				INNER JOIN ImpDocumentosCxP e ON e.Ecodigo = d.Ecodigo
					AND e.IDdocumento = d.IDdocumento
					AND e.Icodigo = d.Icodigo
				INNER JOIN Impuestos i ON i.Ecodigo = c.Ecodigo AND i.Icodigo = e.Icodigo
				where c.ID = #LvarGblID#
				group by c.Ecodigo,	c.CPTcodigo, c.Ddocumento, DAtransref, b.DAdocref, a.Ccuenta, a.Ocodigo, a.SNcodigo, c.Mcodigo,	EAtipocambio,
				DAtotal, EAusuario,	DAtipocambio, a.Mcodigo, DAmontodoc, a.IDdocumento,	Rcodigo, MontoCalculado, d.Icodigo,	Dtotal, e.TotalFac, e.SubTotalFac,
				EDmontoretori, EDretencionVariable, i.Iporcentaje, EDretporigen
				order by a.IDdocumento, d.Icodigo desc
			</cfquery>

			<cfif isdefined('rsAnticipoFCDIOT') and rsAnticipoFCDIOT.RecordCount GT 0>

				<cfloop query="rsAnticipoFCDIOT">
					<cfquery name="rsDataDIOT" datasource="#session.dsn#">
						select
							DIOT_Control.Icodigo,IPeriodo,Documento,Pagado,
							(select DIOTivacodigo from ImpuestoDIOT where Icodigo = 'IVA0' and Ecodigo = #session.Ecodigo#) as DIOTivacodigo1,
							DIOT_Control.SNcodigo,
						  	case when coalesce(EDretporigen,0)> 0 then EDretporigen
								 when coalesce(EDmontoretori,0)>0 then EDmontoretori
							     when coalesce(EDretencionVariable,0)>0 then EDretencionVariable
							else 0 end as MontoRetIVA1,
						*
						from DIOT_Control
							left join HEDocumentosCP
							on HEDocumentosCP.Ddocumento = DIOT_Control.Documento
							and HEDocumentosCP.SNcodigo =  DIOT_Control.SNcodigo
						where DIOT_Control.Ecodigo = #session.Ecodigo#
						and Documento = '#rsAnticipoFCDIOT.Factura#'
						and CampoId   = #rsAnticipoFCDIOT.IDdocumento#
						and Pagado    = 0
						order by DIOT_Control.Icodigo
					</cfquery>

					<cfif isdefined('rsDataDIOT') and rsDataDIOT.RecordCount GT 0 and rsDataDIOT.RecordCount LT 2>
						<cfquery name="rsGetUltimoRegistroDIOT" datasource="#session.dsn#">
							SELECT TOP 1 *
							FROM DIOT_Control
							WHERE CampoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipoFCDIOT.IDdocumento#">
							  AND Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnticipoFCDIOT.Icodigo#">
							ORDER BY DIOTid DESC
						</cfquery>
						<cfquery datasource="#session.dsn#">
							insert into  DIOT_Control (Ecodigo, SNcodigo, Oorigen, TablaOrigen, CampoId, Icodigo, IPeriodo, IMes, OMontoBaseIVA,
							OIVAAcreditable, OIVAPagado, LMontoBaseIVA, LIVAAcreditable, LIVAPagado, TipoCambioIVA, Usucodigo, BMUsucodigo,
							ts_rversion, Documento, DIOTivacodigo, Pagado, MontoRetIVA, DocRefPago)
							values(
							#session.Ecodigo#,
							#rsAnticipoFCDIOT.SNcodigo#,
							'CPPA',
							'BMovimientosCxP',
							#rsAnticipoFCDIOT.IDdocumento#,
							'#rsAnticipoFCDIOT.Icodigo#',
							#LvarPeriodo#,
							#LvarMes#,
							#rsAnticipoFCDIOT.MontoSinIVA#,
							#rsGetUltimoRegistroDIOT.OIVAAcreditable# - #rsAnticipoFCDIOT.MontoCalculado#,
							#rsAnticipoFCDIOT.MontoCalculado#,
							#rsAnticipoFCDIOT.MontoSinIVA#,
							#rsGetUltimoRegistroDIOT.OIVAAcreditable# - #rsAnticipoFCDIOT.MontoCalculado#,
							#rsAnticipoFCDIOT.MontoCalculado#,
							#rsDataDIOT.TipoCambioIVA#,
							#session.Usucodigo#,
							#session.Usucodigo#,
							#now()#,
							'#rsAnticipoFCDIOT.Factura#',
							<cfif rsDataDIOT.DIOTivacodigo neq ''>
								#rsDataDIOT.DIOTivacodigo#,
							<cfelse>
								#rsDataDIOT.DIOTivacodigo1#,
							</cfif>
							1,
							<cfif rsDataDIOT.DIOTivacodigo neq ''>
								#rsDataDIOT.MontoRetIVA#,
							<cfelse>
								#rsDataDIOT.MontoRetIVA1#,
							</cfif>
							'#rsAnticipoFCDIOT.CPTCodigo# #rsAnticipoFCDIOT.NoAnticipo#'
							)
						</cfquery>
					<cfelseif rsDataDIOT.RecordCount EQ 2>
						<cfloop query="rsDataDIOT">
							<cfif rsDataDIOT.Icodigo EQ "IVA16" and rsAnticipoFCDIOT.Icodigo EQ 'IVA16'>
								<cfquery name="rsGetUltimoRegistroDIOT" datasource="#session.dsn#">
									SELECT TOP 1 *
									FROM DIOT_Control
									WHERE CampoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipoFCDIOT.IDdocumento#">
									  AND Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnticipoFCDIOT.Icodigo#">
									ORDER BY DIOTid DESC
								</cfquery>
								<cfquery datasource="#session.dsn#">
									insert into  DIOT_Control (Ecodigo, SNcodigo, Oorigen, TablaOrigen, CampoId, Icodigo, IPeriodo, IMes,
									OMontoBaseIVA, OIVAAcreditable, OIVAPagado, LMontoBaseIVA, LIVAAcreditable, LIVAPagado, TipoCambioIVA,
									Usucodigo, BMUsucodigo, ts_rversion, Documento, DIOTivacodigo, Pagado, MontoRetIVA, DocRefPago)
									values(
									#session.Ecodigo#,
									#rsAnticipoFCDIOT.SNcodigo#,
									'CPPA',
									'BMovimientosCxP',
									#rsAnticipoFCDIOT.IDdocumento#,
									'IVA16',
									#LvarPeriodo#,
									#LvarMes#,
									#rsAnticipoFCDIOT.MontoSinIVA#,
									#rsGetUltimoRegistroDIOT.OIVAAcreditable# - #rsAnticipoFCDIOT.MontoCalculado#,
									#rsAnticipoFCDIOT.MontoCalculado#,
									#rsAnticipoFCDIOT.MontoSinIVA#,
									#rsGetUltimoRegistroDIOT.OIVAAcreditable# - #rsAnticipoFCDIOT.MontoCalculado#,
									#rsAnticipoFCDIOT.MontoCalculado#,
									#rsDataDIOT.TipoCambioIVA#,
									#session.Usucodigo#,
									#session.Usucodigo#,
									#now()#,
									'#rsAnticipoFCDIOT.Factura#',
									#rsDataDIOT.DIOTivacodigo#,
									1,
									0,
									'#rsAnticipoFCDIOT.CPTCodigo# #rsAnticipoFCDIOT.NoAnticipo#'
									)
								</cfquery>
							<!---- IVA 0 ---->
								<cfquery datasource="#session.dsn#">
									insert into  DIOT_Control (Ecodigo, SNcodigo, Oorigen, TablaOrigen, CampoId, Icodigo, IPeriodo, IMes,
									OMontoBaseIVA, OIVAAcreditable, OIVAPagado, LMontoBaseIVA, LIVAAcreditable, LIVAPagado, TipoCambioIVA,
									Usucodigo, BMUsucodigo, ts_rversion, Documento, DIOTivacodigo, Pagado, MontoRetIVA, DocRefPago)
									values(
									#session.Ecodigo#,
									#rsAnticipoFCDIOT.SNcodigo#,
									'CPPA',
									'BMovimientosCxP',
									#rsAnticipoFCDIOT.IDdocumento#,
									'IVA0',
									#LvarPeriodo#,
									#LvarMes#,
									#rsAnticipoFCDIOT.MontoSinIVA#,
									0,
									0,
									#rsAnticipoFCDIOT.MontoSinIVA#,
									0,
									0,
									#rsDataDIOT.TipoCambioIVA#,
									#session.Usucodigo#,
									#session.Usucodigo#,
									#now()#,
									'#rsAnticipoFCDIOT.Factura#',
									3,
									1,
									0,
									'#rsAnticipoFCDIOT.CPTCodigo# #rsAnticipoFCDIOT.NoAnticipo#'
									)
								</cfquery>
							</cfif>
						</cfloop>
					</cfif>
					<cfquery name="rsGetTotalPagado" datasource="#session.dsn#">
							SELECT ROUND(SUM(d.LIVAPagado), 2) AS PagadoLocal,
							        COALESCE(((SELECT ROUND(dc.LIVAAcreditable, 4)
							           FROM DIOT_Control dc
							           WHERE dc.Pagado = 0
							             AND dc.Icodigo = d.Icodigo
							             AND dc.CampoId = d.CampoId
							             AND dc.Ecodigo = d.Ecodigo
							             AND ROUND(dc.LIVAAcreditable, 4) > 0) <!--- -
							          (SELECT ROUND(dc.LIVAAcreditable, 4)
							           FROM DIOT_Control dc
							           WHERE dc.Pagado = 5
							             AND dc.Icodigo = d.Icodigo
							             AND dc.CampoId = d.CampoId
							             AND dc.Ecodigo = d.Ecodigo
							             AND ROUND(dc.LIVAAcreditable, 4) > 0) ---> ),0) AS LIVAAcreditable
							FROM DIOT_Control d
							WHERE d.Pagado IN (1,5)
							  AND d.CampoId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnticipoFCDIOT.IDdocumento#">
							  AND d.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAnticipoFCDIOT.Icodigo#">
							  AND d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							GROUP BY d.Icodigo,
							         d.CampoId,
							         d.Ecodigo
						</cfquery>

						<cfif isDefined("rsGetTotalPagado") AND #rsGetTotalPagado.RecordCount# GT 0 AND (rsGetTotalPagado.PagadoLocal) GT (rsGetTotalPagado.LIVAAcreditable - 1) AND (rsGetTotalPagado.PagadoLocal) LT (rsGetTotalPagado.LIVAAcreditable + 1)>
							<cfquery datasource="#session.dsn#">
								update DIOT_Control
								set Pagado = 3
								where
								CampoId = <cfoutput>'#rsAnticipoFCDIOT.IDdocumento#'</cfoutput>
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
								and Pagado = 0
							</cfquery>
						</cfif>

						<cfif isDefined("rsAnticipoFCDIOT.Icodigo") AND #rsAnticipoFCDIOT.Icodigo# EQ 'IVA16'>
							<cfquery name="rsUpdateDiotNC" datasource="#session.dsn#">
								UPDATE DIOT_Control
								SET SaldoLin = SaldoLin - <cfqueryparam cfsqltype="cf_sql_money" value="#rsAnticipoFCDIOT.MontoSinIVA#">
								WHERE CampoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipoFCDIOT.IDdocumento#">
								AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipoFCDIOT.Ecodigo#">
								AND SaldoLin > 0
								AND Pagado = 0
							</cfquery>
						</cfif>
				</cfloop>

			</cfif>
			<!--- MEG 17/04/2015 --->



			<cfset fnInsertaMovimientoImpuestos()>
			<!---<cfset fnContabilizaDiferencialDocFavor(varNumeroEvento)>--->
			<cfset fnContabilizaDiferencialDocAplic(varNumeroEvento)>
			<cfset fnContabilizaAplicacion(varNumeroEvento)>
			<cfset fnContabilizaTrasladoImpuestos(varNumeroEvento)>
			
            <cfset fnContabilizaGasto(varNumeroEvento)>

			<!---<cf_dumpTable var = "#intarc#">--->
			<cfif Arguments.FechaDoc EQ "S">
				<cfset LvarEfecha = LvarEAfecha>
			<cfelse>
				<cfset LvarEfecha = LvarFecha>
			</cfif>

			<cfset sbAfectacionIETU("CPPA", arguments.Ecodigo, LvarGblID,
						#LvarEfecha#, #LvarPeriodo#, #LvarMes#,
						Arguments.conexion)>

			<!---<cfinvoke component	= "PRES_Presupuesto" method = "CreaTablaIntPresupuesto" Conexion= "#Arguments.Conexion#"/>--->


			<!---
				Ejecutar el Genera Asiento --- Asiento en Contabilidad General
			--->
			<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="Oorigen" value="CPPA"/>
				<cfinvokeargument name="Eperiodo" value="#LvarPeriodo#"/>
				<cfinvokeargument name="Emes" value="#LvarMes#"/>
				<cfinvokeargument name="Efecha" value="#LvarEfecha#"/>
				<cfinvokeargument name="Edescripcion" value="#LvarDescripcion#"/>
				<cfinvokeargument name="Edocbase" value="#arguments.Ddocumento#"/>
				<cfinvokeargument name="Ereferencia" value="#arguments.CPTcodigo#"/>
				<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#"/>
				<cfinvokeargument name="Usucodigo" value="#arguments.Usucodigo#"/>
				<cfinvokeargument name="debug" value="no"/>
				<cfinvokeargument name="PintaAsiento" value="false"/>
				<cfinvokeargument name="DocaFavor" value="true"/>
<!--- Control Evento Inicia --->
        		<cfinvokeargument name='NumeroEvento' 		value="#varNumeroEvento#"/>
<!--- Control Evento Fin --->

			</cfinvoke>

			<cfinvoke component="IETU" method="IETU_ActualizaIDcontable" >
				<cfinvokeargument name="IDcontable"	value="#LvarIDcontable#">
				<cfinvokeargument name="conexion"	value="#Arguments.Conexion#">
			</cfinvoke>


			<!---
				Insertar en el Histórico de CxP los movimientos a los documentos
			--->
			<cfquery datasource="#LvarGblConexion#">
				insert into BMovimientosCxP (
					Ecodigo, CPTcodigo, Ddocumento,
					CPTRcodigo, DRdocumento, BMfecha,
					Ccuenta, Ocodigo, SNcodigo, Mcodigo,
					Dtipocambio, Dtotal, Dfecha, Dvencimiento,
					BMperiodo, BMmes, BMusuario,
					BMfactor, Mcodigoref, BMmontoref, IDcontable)
				select
					c.Ecodigo, c.CPTcodigo, c.Ddocumento,
					b.DAtransref, b.DAdocref, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#">,
					a.Ccuenta, a.Ocodigo, a.SNcodigo, c.Mcodigo,
					c.EAtipocambio, b.DAtotal,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarEAfecha#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarEAfecha#">,
					#LvarPeriodo#, #LvarMes#, c.EAusuario,
					b.DAtipocambio, a.Mcodigo, b.DAmontodoc, #LvarIDcontable#
				from EAplicacionCP c
					inner join DAplicacionCP b
						inner join EDocumentosCP a
						on  a.Ecodigo     = b.Ecodigo
						and a.CPTcodigo   = b.DAtransref
						and a.Ddocumento  = b.DAdocref
						and a.SNcodigo    = b.SNcodigo
						and a.IDdocumento = b.DAidref
					on b.ID = c.ID
				where c.ID = #LvarGblID#
			</cfquery>

			<!--- Envía al Repositorio de  CFDI --->
			<!--- Si existe configurado un Repositorio de CFDIs --->
			<cfquery name="getContE" datasource="#Session.DSN#">
				select ERepositorio from Empresa
				where Ereferencia = #Session.Ecodigo#
			</cfquery>

			<cfquery name="rsLIneaNC" datasource="#Session.DSN#">
				select dc.Dlinea
				from DContables dc
				inner join EAplicacionCP c
					on dc.Ddocumento = c.Ddocumento
				where dc.IDcontable = #LvarIDcontable#
			</cfquery>

			<cfif isdefined("getContE.ERepositorio") and getContE.ERepositorio EQ "1">
				<!--- Comprobantes de la Linea de la Nota de Credito --->
				<cfquery name="rsDContable" datasource="#Session.DSN#">
					insert into CERepositorio(
						IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
	                	archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
						TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
						CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
					select dc.IDcontable, rep.IdDocumento, rep.numDocumento,
						'CPPA', #rsLIneaNC.Dlinea#, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
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
						SELECT r.*
						FROM EAplicacionCP c
						inner join DAplicacionCP b
							on b.ID = c.ID
						inner join EDocumentosCP a
							on  a.Ecodigo     = b.Ecodigo
							and a.CPTcodigo   = b.DAtransref
							and a.Ddocumento  = b.DAdocref
							and a.SNcodigo    = b.SNcodigo
							and a.IDdocumento = b.DAidref
						inner join CERepositorio r
							on a.IDdocumento = r.IdDocumento
						where r.origen = 'CPFC'
						union all
						SELECT r.*
						FROM EAplicacionCP c
						inner join CERepositorio r
							on c.Ddocumento = r.numDocumento
						where r.origen = 'CPFC'
					) rep
						on dc.Ddocumento = rep.numDocumento
						and dc.Ecodigo = rep.Ecodigo
					where dc.IDcontable = #LvarIDcontable#
				</cfquery>
				<!--- Comprobante por linea --->
				<cfquery name="rsDContable" datasource="#Session.DSN#">
					insert into CERepositorio(
						IdContable,IdDocumento,numDocumento,origen,linea,timbre,xmlTimbrado,archivoXML,
	                	archivo,nombreArchivo,extension, Ecodigo,BMUsucodigo,
						TipoComprobante,Serie,Mcodigo,TipoCambio,CEMetPago,rfc,total,
						CEtipoLinea,CESNB,CEtranOri,CEdocumentoOri,Miso4217)
					select dc.IDcontable, rep.IdDocumento, rep.numDocumento,
						'CPPA', dc.Dlinea, rep.timbre, rep.xmlTimbrado, rep.archivoXML, rep.archivo, rep.nombreArchivo,
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
						SELECT r.*
						FROM EAplicacionCP c
						inner join DAplicacionCP b
							on b.ID = c.ID
						inner join EDocumentosCP a
							on  a.Ecodigo     = b.Ecodigo
							and a.CPTcodigo   = b.DAtransref
							and a.Ddocumento  = b.DAdocref
							and a.SNcodigo    = b.SNcodigo
							and a.IDdocumento = b.DAidref
						inner join CERepositorio r
							on a.IDdocumento = r.IdDocumento
						where r.origen = 'CPFC'
					) rep
						on dc.Ddocumento = rep.numDocumento
						and dc.Ecodigo = rep.Ecodigo
					where dc.IDcontable = #LvarIDcontable#
				</cfquery>
			</cfif>
			<!--- Fin ContabilidadElectronica --->


			<!---
				Actualizar el saldo de los documentos Afectados
			--->
			<cfquery datasource="#LvarGblConexion#" name="rsSQL">
				select distinct
					b.Ecodigo, b.DAtransref, b.DAdocref, b.DAidref, b.SNcodigo, b.DAidref
				from DAplicacionCP b
				where b.ID = #LvarGblID#
			</cfquery>
			
			<cfloop query="rsSQL">
				<cfset LvarDEcodigo = rsSQL.Ecodigo>
				<cfset LvarDDAtransref = rsSQL.DAtransref>
				<cfset LvarDDAdocref = rsSQL.DAdocref>
				<cfset LvarDDAidref = rsSQL.DAidref>
				<cfset LvarDSNcodigo = rsSQL.SNcodigo>
				<cfset LvarDDAidref = rsSQL.DAidref>

				<cfquery datasource="#LvarGblConexion#">
					update EDocumentosCP
						set EDsaldo = EDsaldo -
							coalesce((
								select sum(DAmontodoc+isnull(Rmontodoc,0))
								from DAplicacionCP c
								where c.ID         = #LvarGblID#
								  and c.DAidref    = EDocumentosCP.IDdocumento
								  and c.Ecodigo    = EDocumentosCP.Ecodigo
								  and c.DAtransref = EDocumentosCP.CPTcodigo
								  and c.DAdocref   = EDocumentosCP.Ddocumento
								  and c.SNcodigo   = EDocumentosCP.SNcodigo
								  and c.DAidref    = EDocumentosCP.IDdocumento
							), 0.00)

							
					where EDocumentosCP.Ecodigo     = #LvarDEcodigo#
					  and EDocumentosCP.CPTcodigo   = '#LvarDDAtransref#'
					  and EDocumentosCP.Ddocumento  = '#LvarDDAdocref#'
					  and EDocumentosCP.IDdocumento = #LvarDDAidref#
					  and EDocumentosCP.SNcodigo    = #LvarDSNcodigo#
					  and EDocumentosCP.IDdocumento = #LvarDDAidref#
				</cfquery>


			</cfloop>

			<!---
				Actualizar el saldo del Documento a Favor
			--->
			<cfquery datasource="#LvarGblConexion#" name="rsSQL">
				select Ecodigo, CPTcodigo, Ddocumento, SNcodigo, coalesce(EAtotal, 0.00) as EAtotal
				from EAplicacionCP b
				where b.ID = #LvarGblID#
			</cfquery>

			<cfset LvarEAtotal     = rsSQL.EAtotal>
			<cfset LvarEEcodigo    = rsSQL.Ecodigo>
			<cfset LvarECPTcodigo  = rsSQL.CPTcodigo>
			<cfset LvarEDdocumento = rsSQL.Ddocumento>
			<cfset LvarESNcodigo   = rsSQL.SNcodigo>

			<cfquery datasource="#LvarGblConexion#">
				update EDocumentosCP
				set EDsaldo = EDsaldo - #LvarEAtotal#
				where EDocumentosCP.Ecodigo    = #LvarEEcodigo#
				  and EDocumentosCP.CPTcodigo  = '#LvarECPTcodigo#'
				  and EDocumentosCP.Ddocumento = '#LvarEDdocumento#'
				  and EDocumentosCP.SNcodigo   = #LvarESNcodigo#
			</cfquery>

			<!--- 6) Genera una linea de Retencion en TESdetallePago para llevar un control de las mismas vs los Pagos de CXP--->
				<cfquery name="rsSQLANCP" datasource="#LvarGblConexion#">
				SELECT * 
					FROM TESdetallePago 
					WHERE TESDPtipoDocumento=2
					and TESDPdocumentoOri='#LvarEDdocumento#'
					and TESDPreferenciaOri='#LvarECPTcodigo#'
					and TESDPmoduloOri = 'TESP'
					and EcodigoOri=#LvarEEcodigo#
					and TESDPestado=12
				</cfquery>


				<cfif isdefined("rsSQLANCP") and rsSQLANCP.RecordCount gt 0>
						<!--- Inserta un detalle negativo con la Retención calculada --->
					
						<cfquery name="rsSQLDCP" datasource="#session.DSN#">
							select * FROM DAplicacionCP
							where ID = #LvarGblID#
						</cfquery>
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into TESdetallePago
							(
							 TESid, CFid, OcodigoOri,
							 TESDPestado, TESSPid, TESOPid,
							 TESDPtipoDocumento, TESDPidDocumento,
							 TESDPmoduloOri, TESDPdocumentoOri, TESDPreferenciaOri,
							 SNcodigoOri,
							 TESDPfechaVencimiento, TESDPfechaSolicitada, TESDPfechaAprobada,
							 EcodigoOri, EcodigoPago, Miso4217Ori,
							 TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri, TESDPmontoAprobadoOri,
							 TESDPdescripcion,
							 CFcuentaDB, TESRPTCid, BMUsucodigo
							 ,Rcodigo, Rmonto, RlineaId,
							 TESDPtipoCambioOri
							)
						Select
								  dp.TESid, cxp.CFid, cxp.Ocodigo
								, 12
								, #rsSQLANCP.TESSPid#
								, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
								, 1, IDdocumento
								, 'CPFC', Ddocumento, cxp.CPTcodigo
								, cxp.SNcodigo
								, Dfechavenc , Dfechavenc , Dfechavenc
								, cxp.Ecodigo, cxp.Ecodigo, m.Miso4217,
								-isnull(cxp.EDmontoretori,0)*(1.0 * TESDPmontoSolicitadoOri/ (cxp.Dtotal- isnull(cxp.EDmontoretori, 0) ) )as  ret, 
								-isnull(cxp.EDmontoretori,0)*(1.0 * TESDPmontoSolicitadoOri/ (cxp.Dtotal- isnull(cxp.EDmontoretori, 0) ) )as  ret, 
								-isnull(cxp.EDmontoretori,0)*(1.0 * TESDPmontoSolicitadoOri/ (cxp.Dtotal- isnull(cxp.EDmontoretori, 0) ) )as  ret
								, ' - ' + r.Rdescripcion
								, (select min(CFcuenta) from CFinanciera where Ecodigo = cxp.Ecodigo and Ccuenta = coalesce(rd.Ccuentaretp, r.Ccuentaretp))
								, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, #session.Usucodigo#
								, case when rd.Rcodigo is not null then rd.Rcodigo else  r.Rcodigo end, 0, TESDPid,
								TESDPtipoCambioOri
						  from TESdetallePago dp
								outer apply(select top 1 * from EDocumentosCP
											where Ddocumento='#rsSQLDCP.DAdocref#'
											and CPTcodigo='#rsSQLDCP.DAtransref#'
											and SNcodigo=#rsSQLDCP.SNcodigo#
											and Ecodigo = #rsSQLDCP.Ecodigo#
											)cxp
								inner join Monedas m
									 on m.Miso4217 	= dp.Miso4217Ori
									 and m.Ecodigo = cxp.Ecodigo
								inner join Retenciones r
									left join RetencionesComp rc
										left join Retenciones rd
										 on rd.Ecodigo = rc.Ecodigo
										and rd.Rcodigo = rc.RcodigoDet
									 on rc.Ecodigo = r.Ecodigo
									and rc.Rcodigo = r.Rcodigo
								 on r.Ecodigo = cxp.Ecodigo
								and r.Rcodigo = cxp.Rcodigo
						  WHERE dp.TESDPid=#rsSQLANCP.TESDPid#
							AND dp.RlineaId is NULL				<!--- Sin retenciones --->
							AND dp.MlineaId is NULL				<!--- Sin multas: no se han generado Cesiones o Embargos --->
					</cfquery>
				</cfif>

			<!--- SML 26112021 Se insertan en las tablas del historico --->
			<cfquery datasource="#LvarGblConexion#">
				insert into HEAplicacionCP(ID, Ecodigo, CPTcodigo, Ddocumento, SNcodigo, Mcodigo, CFid, EAtipocambio, 
					EAtotal, EAfecha, EAusuario, EAselect, BMUsucodigo,HEACPreversa)
				select ID, Ecodigo, CPTcodigo, Ddocumento, SNcodigo, Mcodigo, CFid, EAtipocambio, 
					EAtotal, EAfecha, EAusuario, EAselect, BMUsucodigo,0
				from EAplicacionCP
				where Ecodigo = #LvarEEcodigo# 
					and ID = #LvarGblID#
				<cf_dbidentity1 name="rsHEAplicacionCP" datasource="#Arguments.Conexion#">
			</cfquery>
			<cf_dbidentity2 name="rsHEAplicacionCP" datasource="#Arguments.Conexion#" returnvariable="HEACPid">

			<cfquery datasource="#LvarGblConexion#">
				insert into HDAplicacionCP(HEACPid, ID, DAlinea, Ecodigo, SNcodigo, CFid, DAidref, DAtransref, DAdocref, DAmonto, DAtotal,
					DAmontodoc, DAtipocambio,
					BMUsucodigo, Rmontodoc, NumeroEvento)
				select #HEACPid#, ID, DAlinea, Ecodigo, SNcodigo, CFid, DAidref, DAtransref, DAdocref, DAmonto, DAtotal,
					DAmontodoc, DAtipocambio,
					BMUsucodigo, Rmontodoc, NumeroEvento
				from DAplicacionCP
				where Ecodigo = #LvarEEcodigo#  
					and ID = #LvarGblID#
			</cfquery>

			<!--- 7) Eliminar la aplicacion de las Estructuras Transaccionales --->
			<cfquery datasource="#LvarGblConexion#">
				delete from DAplicacionCP
				where ID = #LvarGblID#
			</cfquery>
			<cfquery datasource="#LvarGblConexion#">
				delete from EAplicacionCP
				where ID = #LvarGblID#
			</cfquery>

			<cfif arguments.debug eq 'S'>
				<cftransaction action="rollback"/>
				<cfreturn>
			</cfif>
		</cftransaction>

		<cfreturn>
	</cffunction>

	<cffunction name="fnContabilizaAplicacion" access="private" output="no">
    	<cfargument name="NumeroEvento" type="string"   required="no" default="">
		<!---
			Contabiliza la aplicacion de la Nota de Credito a las Facturas de Proveedor

			Proceso:
				Se contabiliza la cuenta de la nota de crédito con signo contrario al signo del documento original
				Se contabiliza la cuenta de las facturas con signo contrario al signo del documento original
				Se genera el balance entre monedas en la cuenta de balance de monedas ( solamente si son cuentas distintas )
		--->
		<!---
			1) Crédito: Documento a Favor por el monto aplicado (PAGO)
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento)
			select
				'CPPA',
				1,
				a.Ddocumento,
				a.CPTcodigo,
				round(a.EAtotal * a.EAtipocambio,2),
				'C',
				<cf_dbfunction name="concat" args="'CxP: Doc a Favor ',a.CPTcodigo,'-',a.Ddocumento">,
				'#LvarfechaChar#',
				a.EAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				b.Ccuenta,
				b.Mcodigo,
				b.Ocodigo,
				a.EAtotal
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP b
				on  a.ID = b.IDdocumento
				and a.Ecodigo = b.Ecodigo
				and a.CPTcodigo = b.CPTcodigo
				and a.Ddocumento = b.Ddocumento
				and a.SNcodigo = b.SNcodigo
			where a.ID = #LvarGblID#
		</cfquery>

		<!---
			2) Debito a cada uno de los Documentos Afectados, por el monto de la afectacion (CxP)
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento)
			select
				'CPPA',
				1,
				a.DAdocref,
				a.DAtransref,
				CASE WHEN b.EDmontoretori is not null and b.EDmontoretori >0 
				THEN 
				round((a.DAmontodoc)* (c.EAtipocambio / a.DAtipocambio),2)+
				round( (CAST(b.EDmontoretori as float)* ( (CAST(a.DAmontodoc as float)   )/(   CAST(b.Dtotal as float)  -  CAST(b.EDmontoretori as float) )) )* (c.EAtipocambio / a.DAtipocambio) ,2)
				ELSE 
				round((a.DAmontodoc)* c.EAtipocambio / a.DAtipocambio,2)
				END AS intmon,
				'D',
				<cf_dbfunction name="concat" args="'CxP: Pago Documento ',a.DAtransref,'-',a.DAdocref">,
				'#LvarfechaChar#',
				c.EAtipocambio / a.DAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				b.Ccuenta,
				b.Mcodigo,
				b.Ocodigo,
				CASE WHEN b.EDmontoretori is not null and b.EDmontoretori >0 
				THEN 
				a.DAmontodoc +
				round( CAST(b.EDmontoretori as float)* ( (CAST(a.DAmontodoc as float)   )/(   CAST(b.Dtotal as float)  -  CAST(b.EDmontoretori as float) )) ,2)
				ELSE 
					a.DAmontodoc 
				END AS intmoe
                ,a.NumeroEvento
			from EAplicacionCP c
				inner join DAplicacionCP a
					inner join EDocumentosCP b
					 on b.Ecodigo 	  = a.Ecodigo
					and b.CPTcodigo   = a.DAtransref
					and b.Ddocumento  = a.DAdocref
					and b.SNcodigo 	  = a.SNcodigo
					and b.IDdocumento = a.DAidref
				 on a.ID = c.ID
			where c.ID = #LvarGblID#
		</cfquery>
		<!---
			2.b) Credito a cada uno de los Documentos Afectados, por el monto de la Retención
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento)
			select
				'CPPA',
				1,
				a.DAdocref,
				a.DAtransref,
				round(a.Rmontodoc * c.EAtipocambio / a.DAtipocambio,2),
				'C',
				<cf_dbfunction name="concat" args="'CxP: Retención Documento ',a.DAtransref,'-',a.DAdocref">,
				'#LvarfechaChar#',
				c.EAtipocambio / a.DAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				b.Ccuenta,
				b.Mcodigo,
				b.Ocodigo,
				a.Rmontodoc
                ,a.NumeroEvento
			from EAplicacionCP c
				inner join DAplicacionCP a
					inner join EDocumentosCP b
					 on b.Ecodigo 	  = a.Ecodigo
					and b.CPTcodigo   = a.DAtransref
					and b.Ddocumento  = a.DAdocref
					and b.SNcodigo 	  = a.SNcodigo
					and b.IDdocumento = a.DAidref
				 on a.ID = c.ID
			where c.ID = #LvarGblID#
			  and a.Rmontodoc <> 0
		</cfquery>

		<!---
			3) Debito a la cuenta de Balance por Moneda por las aplicaciones en moneda diferente
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento)
			select
				'CPPA',
				1,

				a.DAdocref,
				a.DAtransref,
				round(a.DAtotal * c.EAtipocambio,2),
				'D',
				<cf_dbfunction name="concat" args="'Balance Moneda Documento ',a.DAtransref,'-',a.DAdocref">,
				'#LvarfechaChar#',
				c.EAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentaPuente#,
				#LvarMonedaNC#,
				b.Ocodigo,
				a.DAtotal
                ,a.NumeroEvento
			from EAplicacionCP c
				inner join DAplicacionCP a
					inner join EDocumentosCP b
					on a.Ecodigo = b.Ecodigo
					and a.DAtransref = b.CPTcodigo
					and a.DAdocref = b.Ddocumento
					and a.SNcodigo = b.SNcodigo
					and a.DAidref = b.IDdocumento

				on a.ID = c.ID
			where c.ID = #LvarGblID#
			  and b.Mcodigo <> #LvarMonedaNC#
		</cfquery>

		<!---
			4) Credito a la cuenta de Balance por Moneda por las aplicaciones en moneda diferente
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,NumeroEvento)
			select
				'CPPA',
				1,
				a.DAdocref,
				a.DAtransref,
				round( (a.DAmontodoc - a.Rmontodoc) * c.EAtipocambio / a.DAtipocambio,2),
				'C',
				<cf_dbfunction name="concat" args="'Balance Moneda Documento ',a.DAtransref,'-',a.DAdocref">,
				'#LvarfechaChar#',
				c.EAtipocambio / a.DAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentaPuente#,
				b.Mcodigo,
				b.Ocodigo,
				(a.DAmontodoc - a.Rmontodoc)
                ,a.NumeroEvento
			from EAplicacionCP c
				inner join DAplicacionCP a
					inner join EDocumentosCP b
					on a.Ecodigo = b.Ecodigo
					and a.DAtransref = b.CPTcodigo
					and a.DAdocref = b.Ddocumento
					and a.SNcodigo = b.SNcodigo
					and a.DAidref = b.IDdocumento
				on a.ID = c.ID
			where c.ID = #LvarGblID#
			  and b.Mcodigo <> #LvarMonedaNC#
		</cfquery>
	</cffunction>

	<cffunction name="fnInsertaMovimientoImpuestos" access="private" output="no">

		<!--- Primero actualiza el monto pagado de los impuestos credito fiscal ( tabla ImpDocumentosCxP ) --->
		<cfquery name="rsMovimientoImpuestos" datasource="#LvarGblConexion#">
			select
				x.IDdocumento,
				b.Icodigo,
				b.Ecodigo,
				<!--- round((#LvarEAmonto# * b.MontoCalculado)/b.TotalFac,2) as Pagado --->
				CASE
       				WHEN b.Icodigo = 'EXE' THEN 0
					WHEN b.Icodigo = 'IVA0' THEN 0
			        WHEN b.Icodigo = 'IVA16' THEN ROUND((#LvarEAmonto# * (b.TotalFac - b.SubTotalFac))/b.TotalFac,2)
			        ELSE 0
			    END AS Pagado
			from EAplicacionCP a
				inner join EDocumentosCP x
				on a.Ecodigo = x.Ecodigo
				and  a.CPTcodigo = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo = x.SNcodigo

				inner join ImpDocumentosCxP b
				on x.Ecodigo = b.Ecodigo
				and x.IDdocumento = b.IDdocumento

				inner join CPTransacciones d
				on x.Ecodigo = d.Ecodigo
				and x.CPTcodigo = d.CPTcodigo

				inner join Impuestos i
				on b.Ecodigo = i.Ecodigo
				and b.Icodigo = i.Icodigo
			where a.ID = #LvarGblID#
		</cfquery>

		<cfloop query="rsMovimientoImpuestos">
			<cfquery datasource="#LvarGblConexion#">
				update ImpDocumentosCxP
				set MontoPagado = MontoPagado + #rsMovimientoImpuestos.Pagado#,
					MontoCalculado = MontoCalculado - #rsMovimientoImpuestos.Pagado#
				where IDdocumento = #rsMovimientoImpuestos.IDdocumento#
				  and Icodigo     = '#rsMovimientoImpuestos.Icodigo#'
				  and Ecodigo     = #rsMovimientoImpuestos.Ecodigo#
			</cfquery>
		</cfloop>

		<!--- Segundo:  Actualizar los montos pagados de los impuestos correspondientes a las facturas --->
		<cfquery name="rsMovimientoImpuestos" datasource="#LvarGblConexion#">
			SELECT b.IDdocumento,
			       b.Icodigo,
			       b.Ecodigo,
			       b.TotalFac,
			       b.SubTotalFac,
			       <!--- round((det.DAmontodoc * b.MontoCalculado)/b.TotalFac,2) as Pagado --->
			       CASE
			           WHEN b.Icodigo = 'EXE' THEN 0
			           WHEN b.Icodigo = 'IVA0' THEN 0
			           WHEN b.Icodigo = 'IVA16' THEN ROUND((det.DAmontodoc * ((b.TotalFac - b.SubTotalFac))) / b.TotalFac, 2)
			           ELSE 0
			       END AS Pagado
			FROM EAplicacionCP a
			INNER JOIN DAplicacionCP det
			INNER JOIN ImpDocumentosCxP b ON det.Ecodigo = b.Ecodigo
			AND det.DAidref = b.IDdocumento
			INNER JOIN CPTransacciones d ON det.Ecodigo = d.Ecodigo
			AND det.DAtransref = d.CPTcodigo
			INNER JOIN Impuestos i ON b.Ecodigo = i.Ecodigo
			AND b.Icodigo = i.Icodigo ON a.ID = det.ID
			WHERE a.ID = #LvarGblID#
		</cfquery>

		<cfloop query="rsMovimientoImpuestos">
			<cfquery datasource="#LvarGblConexion#">
				update ImpDocumentosCxP
				set MontoPagado = MontoPagado + #rsMovimientoImpuestos.Pagado#,
				MontoCalculado = MontoCalculado - #rsMovimientoImpuestos.Pagado#
				where IDdocumento = #rsMovimientoImpuestos.IDdocumento#
				  and Icodigo     = '#rsMovimientoImpuestos.Icodigo#'
				  and Ecodigo     = #rsMovimientoImpuestos.Ecodigo#
			</cfquery>
		</cfloop>


		<!--- Inserta monto pagado por intereses en la tabla ImpDocumentosCxPMov --->
		<!---1.  Nota Crédito --->
		<cfquery datasource="#LvarGblConexion#">
			insert into ImpDocumentosCxPMov (
				IDdocumento,
				Icodigo,
				Ecodigo,
				Fecha,
				MontoPagado,
				CPTcodigo,
				Ddocumento,
				CPTpago,
				CcuentaAC,
				Periodo,
				Mes,
				BMUsucodigo,
				BMFecha,
				TpoCambio,
				MontoPagadoLocal
			)
			select
				x.IDdocumento,
				b.Icodigo,
				b.Ecodigo,
				a.EAfecha,
				round((#LvarEAmonto# * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2),
				a.CPTcodigo,
				a.Ddocumento,
				d.CPTpago,
				coalesce(i.CcuentaCxCAcred,i.Ccuenta),
				#LvarPeriodo#,
				#LvarMes#,

				b.BMUsucodigo,
				<cf_dbfunction name="now">,
				a.EAtipocambio,   <!---  Actualizacion del monto total del IVA ALG --->
				round(((#LvarEAmonto# * (b.MontoCalculado + b.MontoPagado))/b.TotalFac) * a.EAtipocambio,2)
			from EAplicacionCP a
				inner join EDocumentosCP x
				on a.Ecodigo = x.Ecodigo
				and  a.CPTcodigo = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo = x.SNcodigo

				inner join ImpDocumentosCxP b
				on x.Ecodigo = b.Ecodigo
				and x.IDdocumento = b.IDdocumento

				inner join CPTransacciones d
				on x.Ecodigo = d.Ecodigo
				and x.CPTcodigo = d.CPTcodigo

				inner join Impuestos i
				on b.Ecodigo = i.Ecodigo
				and b.Icodigo = i.Icodigo
			where a.ID = #LvarGblID#
		</cfquery>

		<!--- 2. Facturas --->
		<cfquery datasource="#LvarGblConexion#">
			insert into ImpDocumentosCxPMov (
				IDdocumento,
				Icodigo,
				Ecodigo,
				Fecha,
				MontoPagado,
				CPTcodigo,
				Ddocumento,
				CPTpago,
				CcuentaAC,
				Periodo,
				Mes,
				BMUsucodigo,
				BMFecha,
				TpoCambio,
				MontoPagadoLocal
			)
			select
				b.IDdocumento,
				b.Icodigo,
				b.Ecodigo,
				a.EAfecha,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2),
				d.CPTcodigo,
				a.Ddocumento,
				d.CPTpago,
				coalesce(i.CcuentaCxCAcred,i.Ccuenta),
				#LvarPeriodo#,
				#LvarMes#,

				b.BMUsucodigo,
				<cf_dbfunction name="now">,   <!---  Actualizacion del monto total del IVA ALG--->
				(det.DAmonto / det.DAmontodoc * a.EAtipocambio),
				round(((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac) * (det.DAmonto / det.DAmontodoc * a.EAtipocambio),2)
			from EAplicacionCP a
				inner join DAplicacionCP det
						inner join ImpDocumentosCxP b
						on det.Ecodigo = b.Ecodigo
						and det.DAidref  = b.IDdocumento

						inner join CPTransacciones d
						on det.Ecodigo = d.Ecodigo
						and det.DAtransref = d.CPTcodigo

						inner join Impuestos i
						on b.Ecodigo = i.Ecodigo
						and b.Icodigo = i.Icodigo
				on a.ID = det.ID
			where a.ID = #LvarGblID#
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="fnContabilizaDiferencialDocFavor" access="private" output="no">
    	<cfargument name="NumeroEvento" type="string"   required="no" default="">
		<!---
			Diferencial Cambiario Doc a Favor						D CtaCxP		round( ( round( a.EAtotal,2) ) * ( a.EAtipocambio - x.EDtcultrev), 2)
			Diferencial Cambiario Doc a Favor Impuesto CF			D CcuentaImp	round( ( round(((EAtotal * b.MontoCalculado)/b.TotalFac),2) ) * ( a.EAtipocambio - x.EDtcultrev) , 2)
			Ingreso/Gasto por Diferencial Cambiario Doc a Favor		D CtaDiff		(Diferencial Cambiario Doc a Favor) - sum(Diferencial Cambiario Doc a Favor Impuesto CF)
		--->

		<!--- 1. Diferencial Cambiario del Documento a Favor --->
		<!---<cfquery datasource="#LvarGblConexion#"> <!---SML No--->
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,
				x.CPTcodigo,
				round( ( round( a.EAtotal,2) ) * ( a.EAtipocambio - x.EDtcultrev), 2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="'Diferencial Cambiario (Doc a Favor): ', x.Ddocumento">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				x.Ccuenta,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
						inner join CPTransacciones d
						on x.Ecodigo    = d.Ecodigo
						and x.CPTcodigo = d.CPTcodigo
				on   a.Ecodigo = x.Ecodigo
				and  a.CPTcodigo = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo = x.SNcodigo
			where a.ID = #LvarGblID#
			  and x.Mcodigo <> #LvarMonlocal#
		</cfquery>--->


		<!--- 2. Ajuste de Diferencial Cambiario a los Impuestos Credito Fiscal del Documento a Favor --->
		<!---<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,
				x.CPTcodigo,
				round( ( round(((EAtotal * b.MontoCalculado)/b.TotalFac),2) ) * ( a.EAtipocambio - x.EDtcultrev) , 2),
				'C',
				<cf_dbfunction name="concat" args="'Diferencial Cambiario Impuesto CF (Doc a Favor): ',i.Icodigo">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				CcuentaImp,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
					inner join CPTransacciones d
						on x.Ecodigo     = d.Ecodigo
						and x.CPTcodigo  = d.CPTcodigo

				 on  a.Ecodigo    = x.Ecodigo
				and  a.CPTcodigo  = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo   = x.SNcodigo

				inner join ImpDocumentosCxP b
					inner join Impuestos i
						on b.Ecodigo = i.Ecodigo
						and b.Icodigo = i.Icodigo
				 on x.Ecodigo      = b.Ecodigo
				and x.IDdocumento = b.IDdocumento

			where a.ID = #LvarGblID#
			and   x.Mcodigo <> #LvarMonlocal#
		</cfquery>--->


		<!--- 3. Ingreso/Gasto por Diferencial Cambiario del Documento a Favor (Excluyendo el ajuste a los impuestos Credito Fiscal) --->
		<!---<cfquery datasource="#LvarGblConexion#"> <!---SML No--->
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,
				x.CPTcodigo,
				round( ( round( a.EAtotal,2) ) * ( a.EAtipocambio - x.EDtcultrev), 2) -
						coalesce(
							(
								select sum(round( ( round(((EAtotal * b.MontoCalculado)/b.TotalFac),2) ) * ( EAtipocambio - x.EDtcultrev) , 2))
								  from EAplicacionCP aa
									inner join EDocumentosCP x
										 on  a.Ecodigo    = x.Ecodigo
										and  a.CPTcodigo  = x.CPTcodigo
										and  a.Ddocumento = x.Ddocumento
										and  a.SNcodigo   = x.SNcodigo
									inner join ImpDocumentosCxP b
										 on x.Ecodigo      = b.Ecodigo
										and x.IDdocumento = b.IDdocumento
								 where aa.ID = a.ID
							)
						,0)
				,
				'C',
				case when a.EAtipocambio - x.EDtcultrev > 0
					then 'Ingreso por Diferencial Cambiario (Doc a Favor)'
					else 'Gasto por Diferencial Cambiario (Doc a Favor)'
				end,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				case when a.EAtipocambio - x.EDtcultrev > 0
					then #LvarCuentaIngDifCam#
					else #LvarCuentaGasDifCam#
				end,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
						inner join CPTransacciones d
						on x.Ecodigo    = d.Ecodigo
						and x.CPTcodigo = d.CPTcodigo
				on   a.Ecodigo = x.Ecodigo
				and  a.CPTcodigo = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo = x.SNcodigo
			where a.ID = #LvarGblID#
			  and x.Mcodigo <> #LvarMonlocal#
			  and a.EAtipocambio - x.EDtcultrev <> 0
		</cfquery>--->

		<cfreturn>
	</cffunction>

	<cffunction name="fnContabilizaDiferencialDocAplic" access="private" output="no">
    	<cfargument name="NumeroEvento" type="string"   required="no" default="">

		<!---
			Diferencial Cambiario Documento						D CtaCxP		round( ( round(DAmontodoc,2) ) * ( (DAmonto / DAmontodoc * a.EAtipocambio) - x.EDtcultrev) , 2)
			Diferencial Cambiario Documento Impuesto CF			D CcuentaImp	round( ( round(((DAmontodoc * b.MontoCalculado)/b.TotalFac),2) ) * ( (DAmonto / DAmontodoc * a.EAtipocambio) - x.EDtcultrev	) , 2),
			Ingreso/Gasto por Diferencial Cambiario Documento	D CtaDiff		(Diferencial Cambiario Documento) - sum(Diferencial Cambiario Documento Impuesto CF)
		--->

		<!--- 1. Diferencial Cambiario del Documento (Cuenta por pagar) --->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,
				x.CPTcodigo,
				round( ( round(DAmontodoc,2) ) * ( (DAmonto / DAmontodoc * a.EAtipocambio) - x.EDtcultrev) , 2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="'Ajuste Diferencial Cambiario: ', x.Ddocumento">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				x.Ccuenta,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
					inner join CPTransacciones d
					on det.Ecodigo = d.Ecodigo
					and det.DAtransref = d.CPTcodigo

					inner join EDocumentosCP x
					on det.Ecodigo = x.Ecodigo
					and  det.DAidref = x.IDdocumento

				on a.ID = det.ID
			where a.ID = #LvarGblID#
			and  x.Mcodigo <> #LvarMonlocal#
		</cfquery>

		<!--- 2. Ajuste por Diferencial Cambiario a los Impuestos Credito Fiscal de las Facturas  --->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,   <!--- Actualizacion del monto total del IVA--->
				x.CPTcodigo,
				round( (det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac * ( (det.DAmonto / det.DAmontodoc * a.EAtipocambio) - x.EDtcultrev ) , 2),
				'D',
				<cf_dbfunction name="concat" args="'Ajuste Diferencial Cambiario: ', i.Idescripcion">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				CcuentaImp,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
						inner join EDocumentosCP x
						on det.Ecodigo = x.Ecodigo
						and  det.DAidref = x.IDdocumento

						inner join ImpDocumentosCxP b
							inner join Impuestos i
							on b.Ecodigo = i.Ecodigo
							and b.Icodigo = i.Icodigo

						on det.Ecodigo = b.Ecodigo
						and det.DAidref  = b.IDdocumento

						inner join CPTransacciones d
						on det.Ecodigo = d.Ecodigo
						and det.DAtransref = d.CPTcodigo

				on a.ID = det.ID

			where a.ID = #LvarGblID#
			and  x.Mcodigo <> #LvarMonlocal#
		</cfquery>

		<!--- 3. Ingreso/Gasto por Diferencial Cambiario de las Facturas (Excluyendo el ajuste a los impuestos Credito Fiscal) --->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON,
							  INTTIP, INTDES, INTFEC, INTCAM, Periodo,
							   Mes,   Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				x.Ddocumento,
				x.CPTcodigo,
				round(DAmontodoc * ( (det.DAmonto / det.DAmontodoc * a.EAtipocambio) - x.EDtcultrev),2) -
						coalesce(
							(   <!--- Actualizacion del monto total del IVA ALG  --->
								select sum(round( (DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac * ( (DAmonto / DAmontodoc * a.EAtipocambio) - x.EDtcultrev ) , 2))
								  from DAplicacionCP dett
									inner join ImpDocumentosCxP b
										 on b.Ecodigo 	  = dett.Ecodigo
										and b.IDdocumento = dett.DAidref
									inner join EAplicacionCP a
										 on a.ID = dett.ID
									inner join EDocumentosCP x
										 on x.Ecodigo 	  = dett.Ecodigo
										and x.IDdocumento = dett.DAidref
								 where dett.DAlinea = det.DAlinea
							)
						,0)
				,
				'D',
				case when a.EAtipocambio - x.EDtcultrev > 0
					then 'Gasto Diferencial Cambiario'
					else 'Ingreso Diferencial Cambiario'
				end,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				case when a.EAtipocambio - x.EDtcultrev > 0
					then #LvarCuentaGasDifCam#
					else #LvarCuentaIngDifCam#
				end,
				x.Mcodigo,
				x.Ocodigo,
				0.00
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
					inner join CPTransacciones d
					on det.Ecodigo = d.Ecodigo
					and det.DAtransref = d.CPTcodigo

					inner join EDocumentosCP x
					on det.Ecodigo = x.Ecodigo
					and  det.DAidref = x.IDdocumento

				on a.ID = det.ID
			where a.ID = #LvarGblID#
			  and x.Mcodigo <> #LvarMonlocal#
			  and a.EAtipocambio - x.EDtcultrev <> 0
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="fnContabilizaTrasladoImpuestos" access="private" output="no">
    	<cfargument name="NumeroEvento" type="string"   required="no" default="">
		<!---
			Contabiliza el traslado de los montos de impuestos, de los documentos aplicados.
			La contabilización traslada de la cuenta contable de Impuestos por Acreditar a Impuestos Acreditados.
			Se debe de tomar en consideración que los Impuestos Acreditados se trasladan en la moneda local de la empresa
			Por este motivo, se realiza un balance entre monedas al trasladar los impuestos

			El proceso inicia por el traslado de impuestos de la nota de crédito del proveedor
			Continua trasladando los impuestos de las facturas asociadas
			Finaliza balanceando las monedas de los documentos y la moneda local

		--->
		<!---
			1.  Traslado de los impuestos asociados a la Nota Crédito
				Se contabiliza un movimiento a la cuenta de impuestos por acreditar de la tabla de impuestos
		--->
		<cfquery name="rsUno" datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select distinct
				'CPPA',
				1,
				a.Ddocumento,
				a.CPTcodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2),  <!--- Se suma el monto pagado, para encontrar el total del monto Calculado   ALG  --->
				d.CPTtipo,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor)'">,
				'#LvarfechaChar#',
				a.EAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				CcuentaImp,
				a.Mcodigo,
				x.Ocodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2)
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
				on   a.Ecodigo = x.Ecodigo
				and  a.CPTcodigo = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo = x.SNcodigo
				inner join ImpDocumentosCxP b
				on x.Ecodigo = b.Ecodigo
				and x.IDdocumento = b.IDdocumento
				inner join CPTransacciones d
				on x.Ecodigo = d.Ecodigo
				and x.CPTcodigo = d.CPTcodigo
				inner join Impuestos i
				on b.Ecodigo = i.Ecodigo
				and b.Icodigo = i.Icodigo
			where a.ID = #LvarGblID#
			and  x.Mcodigo <> #LvarMonlocal#
			and i.CcuentaCxPAcred is not null
		</cfquery>
		<!--- <cfdump var="#rsUno#"> --->

        <cfquery name="rsint" datasource="#LvarGblConexion#">
			INSERT INTO #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			SELECT INTORI,
			       INTREL,
				   Ddocumento,
				   CPTcodigo,
				   SUM(iva1) iva1,
				   CPTtipo,
				   Idescripcion,
				   fecha,
				   EAtipocambio,
				   periodo,
				   mes,
				   CcuentaImp,
				   Mcodigo,
				   Ocodigo,
				   SUM(iva2) iva2,
				   NumeroEvento
			FROM
			(SELECT 'CPPA' INTORI,
			        1 INTREL,
					a.Ddocumento,        
					a.CPTcodigo,
					round(((coalesce((b.MontoCalculado + b.MontoPagado), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((b.TotalFac-isnull(x.EDmontoretori,0)),0))) / 100),2) * round(a.EAtipocambio,2) AS iva1,
					d.CPTtipo,
					<cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor)'"> as Idescripcion,
					'#LvarfechaChar#' fecha,
					a.EAtipocambio,
					#LvarPeriodo# periodo,
					#LvarMes# mes,
					b.CcuentaImp,
					a.Mcodigo,   <!--- Actualizacion del monto total del IVA ALG --->
					x.Ocodigo,
					round(((coalesce((b.MontoCalculado + b.MontoPagado), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((b.TotalFac-isnull(x.EDmontoretori,0)),0))) / 100),2) * round(a.EAtipocambio,2) AS iva2,
					'#Arguments.NumeroEvento#' NumeroEvento
			FROM EAplicacionCP a
			INNER JOIN DAplicacionCP da ON a.Ecodigo = da.Ecodigo
			AND a.ID = da.ID
			INNER JOIN EDocumentosCP x ON da.Ecodigo = x.Ecodigo
			AND da.DAidref = x.IDdocumento
			INNER JOIN ImpDocumentosCxP b ON x.Ecodigo = b.Ecodigo
			AND x.IDdocumento = b.IDdocumento
			INNER JOIN CPTransacciones d ON x.Ecodigo = d.Ecodigo
			AND x.CPTcodigo = d.CPTcodigo
			INNER JOIN Impuestos i ON b.Ecodigo = i.Ecodigo
			AND b.Icodigo = i.Icodigo
			WHERE a.ID = #LvarGblID#
			  AND x.Mcodigo = #LvarMonlocal#
			  AND i.CcuentaCxPAcred IS NOT NULL)Tbl
			GROUP BY INTORI,
			         INTREL,
					 Ddocumento,
					 CPTcodigo,
					 CPTtipo,
					 Idescripcion,
					 fecha,
				     EAtipocambio,
				     periodo,
				     mes,
				     CcuentaImp,
				     Mcodigo,
				     Ocodigo,
				     NumeroEvento
		</cfquery>
		<!--- <cf_dump var="#rsint#"> --->
		<!--- 1.2 Calculo retentciones JARR abril 2020--->
		 <cfquery name="rsint" datasource="#LvarGblConexion#">
			INSERT INTO #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			SELECT INTORI,
			       INTREL,
				   Ddocumento,
				   CPTcodigo,
				   SUM(ret1) ret1,
				   CPTtipo,
				   Rdescripcion,
				   fecha,
				   EAtipocambio,
				   periodo,
				   mes,
				   Ccuentaretp,
				   Mcodigo,
				   Ocodigo,
				   SUM(ret2) ret2,
				   NumeroEvento
			FROM
			(SELECT 'CPPA' INTORI,
			        1 INTREL,
					a.Ddocumento,        
					a.CPTcodigo,
					round(((coalesce((x.EDmontoretori), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((x.Dtotal-isnull(x.EDmontoretori,0)),0))) / 100),2) * round(a.EAtipocambio,2) AS ret1,
					d.CPTtipo,
					<cf_dbfunction name="concat" args="r.Rdescripcion,' (Doc Retencion)'"> as Rdescripcion,
					'#LvarfechaChar#' fecha,
					a.EAtipocambio,
					#LvarPeriodo# periodo,
					#LvarMes# mes,
					r.Ccuentaretp,
					a.Mcodigo,  
					x.Ocodigo,
					round(((coalesce((x.EDmontoretori), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((x.Dtotal-isnull(x.EDmontoretori,0)),0))) / 100),2) * round(a.EAtipocambio,2) AS ret2,
					'#Arguments.NumeroEvento#' NumeroEvento
			FROM EAplicacionCP a
			INNER JOIN DAplicacionCP da ON a.Ecodigo = da.Ecodigo
			AND a.ID = da.ID
			INNER JOIN EDocumentosCP x ON da.Ecodigo = x.Ecodigo
			AND da.DAidref = x.IDdocumento
			INNER JOIN CPTransacciones d ON x.Ecodigo = d.Ecodigo
			AND x.CPTcodigo = d.CPTcodigo
			INNER JOIN Retenciones r ON x.Ecodigo = r.Ecodigo
			AND x.Rcodigo = r.Rcodigo
			WHERE a.ID = #LvarGblID#
			  AND x.Mcodigo = #LvarMonlocal#
			  and x.Rcodigo is not null)Tbl
			GROUP BY INTORI,
			         INTREL,
					 Ddocumento,
					 CPTcodigo,
					 CPTtipo,
					 Rdescripcion,
					 fecha,
				     EAtipocambio,
				     periodo,
				     mes,
				     Ccuentaretp,
				     Mcodigo,
				     Ocodigo,
				     NumeroEvento
		</cfquery>
		<!--- JARR retencion --->
		<cfquery datasource="#LvarGblConexion#">
			update DAplicacionCP
				set Rmontodoc=Table_B.ret1
			FROM DAplicacionCP AS Table_A
				INNER join  (SELECT
									round(((coalesce((x.EDmontoretori), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((x.Dtotal-isnull(x.EDmontoretori,0)),0))) / 100),4,1) * round(a.EAtipocambio,4,1) AS ret1,
								da.ID,	
								da.DAlinea
								FROM EAplicacionCP a
								INNER JOIN DAplicacionCP da ON a.Ecodigo = da.Ecodigo
								AND a.ID = da.ID
								INNER JOIN EDocumentosCP x ON da.Ecodigo = x.Ecodigo
								AND da.DAidref = x.IDdocumento
								INNER JOIN CPTransacciones d ON x.Ecodigo = d.Ecodigo
								AND x.CPTcodigo = d.CPTcodigo
								INNER JOIN Retenciones r ON x.Ecodigo = r.Ecodigo
								AND x.Rcodigo = r.Rcodigo
								WHERE a.ID = #LvarGblID#
								  AND x.Mcodigo = #LvarMonlocal#
								  and x.Rcodigo is not null) AS Table_B
				ON Table_A.ID = Table_B.ID
				and Table_A.DAlinea = Table_B.DAlinea
			WHERE Table_A.ID = #LvarGblID#
		</cfquery>

		<!--- <cfquery name="asdad" datasource="#LvarGblConexion#">
			select * from DAplicacionCP
		</cfquery>

		<cf_dump var="#asdad#"> --->
		<!---
			2.  Traslado de los impuestos asociados a la Nota Crédito
				Se contabiliza un movimiento a la cuenta de impuestos acreditatos, EN LA MONEDA LOCAL
		--->
		<cfquery name="rsIva3" datasource="#LvarGblConexion#">
<!--- 			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento) --->
			select
				'CPPA',
				1,
				a.Ddocumento,
				a.CPTcodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor  - Acreditada)'">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				i.CcuentaCxPAcred,
				#LvarMonlocal#,
				x.Ocodigo,            <!--- Actualizacion del monto total del IVA ALG --->  
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2)
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo

						on x.Ecodigo      = b.Ecodigo
						and x.IDdocumento = b.IDdocumento

						inner join CPTransacciones d
						on x.Ecodigo = d.Ecodigo
						and x.CPTcodigo = d.CPTcodigo

				on   a.Ecodigo    = x.Ecodigo
				and  a.CPTcodigo  = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo   = x.SNcodigo

			where a.ID = #LvarGblID#
			and i.CcuentaCxPAcred is not null
			and  x.Mcodigo <> #LvarMonlocal#
		</cfquery>
<!--- <cfdump var="#rsIva3#"> --->

        <cfquery name="rsIva4" datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			SELECT INTORI, INTREL, Ddocumento, CPTcodigo, SUM(iva1), CPTtipo, Idescripcion, fecha, num, periodo, mes, CcuentaCxPAcred, mon, Ocodigo, SUM(iva2), numE
			 FROM (SELECT 'CPPA' INTORI,
			              1 INTREL,
			              a.Ddocumento,
			              a.CPTcodigo,
			              round(((coalesce((imp.MontoCalculado + imp.MontoPagado), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((imp.TotalFac-isnull(ed.EDmontoretori,0)),0))) / 100),2) AS iva1,  <!--- Actualizacion del monto total del iva ALG --->  
			              CASE
			                  WHEN ct.CPTtipo = 'D' THEN 'C'
			                  ELSE 'D'
			              END CPTtipo,
			              <cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor  - Acreditada)'"> Idescripcion,
			              '#LvarfechaChar#' fecha,
			              1 num,
			              #LvarPeriodo# periodo,
			              #LvarMes# mes,
			              i.CcuentaCxPAcred,
			              #LvarMonlocal# mon,
			              ed.Ocodigo,
			              round(((coalesce((imp.MontoCalculado + imp.MontoPagado), 0) * ((coalesce(da.DAtotal,0) * 100) / coalesce((imp.TotalFac-isnull(ed.EDmontoretori,0)),0))) / 100),2) AS iva2,
			              '#Arguments.NumeroEvento#' numE
			FROM EAplicacionCP a
			INNER JOIN DAplicacionCP da ON a.ID = da.ID
			AND a.Ecodigo = da.Ecodigo
			INNER JOIN EDocumentosCP ed ON ed.IDdocumento = da.DAidref
			AND ed.Ecodigo = da.Ecodigo
			INNER JOIN ImpDocumentosCxP imp ON imp.IDdocumento = ed.IDdocumento
			AND imp.Ecodigo = ed.Ecodigo
			INNER JOIN Impuestos i ON i.Icodigo = imp.Icodigo
			AND i.Ecodigo = imp.Ecodigo
			INNER JOIN CPTransacciones ct ON ct.CPTcodigo = ed.CPTcodigo
			AND ct.Ecodigo = ed.Ecodigo
			WHERE a.ID = #LvarGblID#
			AND ed.Mcodigo = #LvarMonlocal#)Tbl
			GROUP BY INTORI,
			         INTREL,
					 Ddocumento,
					 CPTcodigo,
					 CPTtipo,
					 Idescripcion,
					 fecha,
					 num,
					 periodo,
					 mes,
					 CcuentaCxPAcred,
					 mon,
					 Ocodigo,
					 numE
		</cfquery>
<!--- <cf_dump var="#rsIva4#"> --->
		<!---
			***************************************************** IEPS ******************************************************
		--->

		<cfquery name="rsD" datasource="#LvarGblConexion#">
		 	insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			SELECT 'CPPA',
			       1,
			       a.Ddocumento,
			       a.CPTcodigo,
			       ROUND(SUM((imp.MontoCalculadoIeps * ((da.DAtotal * 100) / e.Dtotal))/100),2),
				   'C',
			       <cf_dbfunction name="concat" args="i.Idescripcion,' (IEPS POR ACREDITAR)'">,
			       '#LvarfechaChar#',
				   a.EAtipocambio,
			       #LvarPeriodo#,
			       #LvarMes#,
			       imp.CcuentaImpIeps,
			       a.Mcodigo,
			       e.Ocodigo,
			       ROUND(SUM((imp.MontoCalculadoIeps * ((da.DAtotal * 100) / e.Dtotal))/100),2),
			       '#Arguments.NumeroEvento#'
			FROM EAplicacionCP a
				 INNER JOIN DAplicacionCP da ON a.ID = da.ID
				 AND a.Ecodigo = da.Ecodigo
				 inner join EDocumentosCP e on e.IDdocumento = da.DAidref
				 and e.Ecodigo = da.Ecodigo
				 INNER JOIN ImpIEPSDocumentosCxP imp on imp.IDdocumento = e.IDdocumento
				 and imp.Ecodigo = e.Ecodigo
				 inner join Impuestos i on i.Icodigo = imp.codIEPS
				 and i.Ecodigo = imp.Ecodigo
				 and a.ID = #LvarGblID#
			group by a.Ddocumento,
			         a.CPTcodigo,
					 <cf_dbfunction name="concat" args="i.Idescripcion,' (IEPS POR ACREDITAR)'">,
					 a.EAtipocambio,
					 imp.CcuentaImpIeps,
					 a.Mcodigo,
					 e.Ocodigo
		</cfquery>

		<cfquery name="rsD" datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			SELECT 'CPPA',
			       1,
			       a.Ddocumento,
			       a.CPTcodigo,
			       ROUND(SUM((imp.MontoCalculadoIeps * ((da.DAtotal * 100) / e.Dtotal))/100),2),
				   'D',
			       <cf_dbfunction name="concat" args="i.Idescripcion,' (IEPS ACREDITABLE)'">,
			       '#LvarfechaChar#',
				   a.EAtipocambio,
			       #LvarPeriodo#,
			       #LvarMes#,
			       i.CcuentaCxPAcred,
			       a.Mcodigo,
			       e.Ocodigo,
			       ROUND(SUM((imp.MontoCalculadoIeps * ((da.DAtotal * 100) / e.Dtotal))/100),2),
			       '#Arguments.NumeroEvento#'
			FROM EAplicacionCP a
				 INNER JOIN DAplicacionCP da ON a.ID = da.ID
				 AND a.Ecodigo = da.Ecodigo
				 inner join EDocumentosCP e on e.IDdocumento = da.DAidref
				 and e.Ecodigo = da.Ecodigo
				 INNER JOIN ImpIEPSDocumentosCxP imp on imp.IDdocumento = e.IDdocumento
				 and imp.Ecodigo = e.Ecodigo
				 inner join Impuestos i on i.Icodigo = imp.codIEPS
				 and i.Ecodigo = imp.Ecodigo
				 and a.ID = #LvarGblID#
			group by a.Ddocumento,
			         a.CPTcodigo,
					 <cf_dbfunction name="concat" args="i.Idescripcion,' (IEPS ACREDITABLE)'">,
					 a.EAtipocambio,
					 i.CcuentaCxPAcred,
					 a.Mcodigo,
					 e.Ocodigo
		</cfquery>

		<!---
			3.  Hacer el balance multimoneda de los montos trasladados de impuestos crédito fiscal.
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				a.Ddocumento,
				a.CPTcodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor  - CuentaBalancemultimoneda)'">,
				'#LvarfechaChar#',
				a.EAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentabalancemultimoneda#,
				a.Mcodigo,
				x.Ocodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2)
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo
						on x.Ecodigo       = b.Ecodigo
						and x.IDdocumento = b.IDdocumento

						inner join CPTransacciones d
						on x.Ecodigo = d.Ecodigo
						and x.CPTcodigo = d.CPTcodigo

				on   a.Ecodigo    = x.Ecodigo
				and  a.CPTcodigo  = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo   = x.SNcodigo
			where a.ID = #LvarGblID#
			and i.CcuentaCxPAcred is not null
			and  x.Mcodigo <> #LvarMonlocal#
		</cfquery>

		<!---
			4.  Hacer el balance multimoneda de los montos trasladados de impuestos crédito fiscal.
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				a.Ddocumento,
				a.CPTcodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Doc a Favor (Acred) - CuentaBalancemultimoneda)'">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentabalancemultimoneda#,
				#LvarMonlocal#,
				x.Ocodigo,
				round((a.EAtotal * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round(a.EAtipocambio,2)
                ,'#Arguments.NumeroEvento#'
			from EAplicacionCP a
				inner join EDocumentosCP x
						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo

						on x.Ecodigo      = b.Ecodigo
						and x.IDdocumento = b.IDdocumento

						inner join CPTransacciones d
						on x.Ecodigo = d.Ecodigo
						and x.CPTcodigo = d.CPTcodigo

				on   a.Ecodigo    = x.Ecodigo
				and  a.CPTcodigo  = x.CPTcodigo
				and  a.Ddocumento = x.Ddocumento
				and  a.SNcodigo   = x.SNcodigo
			where a.ID = #LvarGblID#
			  and x.Mcodigo <> #LvarMonlocal#
			  and i.CcuentaCxPAcred is not null
		</cfquery>

		<!---
			5. Trasladar el impuesto credito fiscal de las Facturas a las que se aplicó la Nota de Crédito
			Se contabiliza un movimiento a la cuenta de impuestos por acreditar de la tabla de impuestos
		--->
		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				det.DAdocref,
				d.CPTcodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Documento)'">,
				'#LvarfechaChar#',
				round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				#LvarPeriodo#,
				#LvarMes#,
				CcuentaImp,
				x.Mcodigo,
				x.Ocodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2)  <!--- Actualizacion ALG (Monto total del iva)--->  
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
						inner join EDocumentosCP x
						on det.Ecodigo = x.Ecodigo
						and  det.DAidref = x.IDdocumento
						and  x.Mcodigo <> #LvarMonlocal#

						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo

						on det.Ecodigo = b.Ecodigo
						and det.DAidref  = b.IDdocumento

						inner join CPTransacciones d
						on det.Ecodigo = d.Ecodigo
						and det.DAtransref = d.CPTcodigo

				on a.ID = det.ID

			where a.ID = #LvarGblID#
			and i.CcuentaCxPAcred is not null
		</cfquery>

		<!---
			6.  Traslado de los impuestos asociados a las Facturas a las que se aplicó la Nota Crédito
				Se contabiliza un movimiento a la cuenta de impuestos acreditatos, EN LA MONEDA LOCAL
		--->

		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				det.DAdocref,
				d.CPTcodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Documento - Acreditada)'">,
				'#LvarfechaChar#',
				a.EAtipocambio,
				#LvarPeriodo#,
				#LvarMes#,
				i.CcuentaCxPAcred,
				#LvarMonlocal#,
				x.Ocodigo,   <!--- Actualizacion ALG (Monto total del iva) --->  
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2)
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
						inner join EDocumentosCP x
						on det.Ecodigo = x.Ecodigo
						and  det.DAidref = x.IDdocumento

						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo

						on det.Ecodigo = b.Ecodigo
						and det.DAidref  = b.IDdocumento

						inner join CPTransacciones d
						on det.Ecodigo = d.Ecodigo
						and det.DAtransref = d.CPTcodigo

				on a.ID = det.ID
			where a.ID = #LvarGblID#
			and  x.Mcodigo <> #LvarMonlocal#
			and i.CcuentaCxPAcred is not null

		</cfquery>

		<!---
			7.  Hacer el balance multimoneda de los montos trasladados de impuestos crédito fiscal.
		--->

		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				det.DAdocref,
				d.CPTcodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				case when d.CPTtipo = 'D' then 'C' else 'D' end,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Documento - CuentaBalancemultimoneda)'">,
				'#LvarfechaChar#',
				round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentabalancemultimoneda#,
				x.Mcodigo,
				x.Ocodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2)  <!--- Monto total del iva --->  
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
					inner join EDocumentosCP x
					on det.Ecodigo = x.Ecodigo
					and  det.DAidref = x.IDdocumento

					inner join ImpDocumentosCxP b
							inner join Impuestos i
							on b.Ecodigo = i.Ecodigo
							and b.Icodigo = i.Icodigo

					on det.Ecodigo = b.Ecodigo
					and det.DAidref  = b.IDdocumento

					inner join CPTransacciones d
					on det.Ecodigo = d.Ecodigo
					and det.DAtransref = d.CPTcodigo

				on a.ID = det.ID
			where a.ID = #LvarGblID#
			and  x.Mcodigo <> #LvarMonlocal#
			and i.CcuentaCxPAcred is not null
		</cfquery>

		<!---
			8.  Hacer el balance multimoneda de los montos trasladados de impuestos crédito fiscal.
		--->

		<cfquery datasource="#LvarGblConexion#">
			insert into #intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, NumeroEvento)
			select
				'CPPA',
				1,
				det.DAdocref,
				d.CPTcodigo,
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2),
				d.CPTtipo,
				<cf_dbfunction name="concat" args="i.Idescripcion,' (Documento (Acred) - CuentaBalancemultimoneda)'">,
				'#LvarfechaChar#',
				1,
				#LvarPeriodo#,
				#LvarMes#,
				#LvarCuentabalancemultimoneda#,
				#LvarMonlocal#,
				x.Ocodigo,   <!--- Actualizacion del monto total del IVA ALG --->  
				round((det.DAmontodoc * (b.MontoCalculado + b.MontoPagado))/b.TotalFac,2) * round((det.DAmonto / det.DAmontodoc * a.EAtipocambio),2)
                ,det.NumeroEvento
			from EAplicacionCP a
				inner join DAplicacionCP det
						inner join EDocumentosCP x
						on det.Ecodigo = x.Ecodigo
						and  det.DAidref = x.IDdocumento

						inner join ImpDocumentosCxP b
								inner join Impuestos i
								on b.Ecodigo = i.Ecodigo
								and b.Icodigo = i.Icodigo
						on det.Ecodigo = b.Ecodigo
						and det.DAidref  = b.IDdocumento

						inner join CPTransacciones d
						on det.Ecodigo = d.Ecodigo
						and det.DAtransref = d.CPTcodigo

				on a.ID = det.ID
			where a.ID = #LvarGblID#
			and i.CcuentaCxPAcred is not null
			and  x.Mcodigo <> #LvarMonlocal#
		</cfquery>
		<cfreturn>
	</cffunction>

	<cffunction name="sbAfectacionIETU" access="public"  output="false">
		<cfargument name="Oorigen"		type="string"	required="yes" >
		<cfargument name="Ecodigo"		type="numeric"	required="yes" >
		<cfargument name="ID" 			type='numeric' 	required="yes" >
		<cfargument name="Efecha"		type="date"		required="yes" >
		<cfargument name="Eperiodo"		type="numeric"	required="yes" >
		<cfargument name="Emes"			type="numeric"	required="yes" >
		<cfargument name='Conexion' 	type='string' 	required='true'>

		<!--- Verifica si es una aplicación de Anticipo --->
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select TESRPTCietu
			  from EAplicacionCP e
					inner join EDocumentosCP doc
					 on doc.Ecodigo 	= e.Ecodigo
					and doc.CPTcodigo	= e.CPTcodigo
					and doc.Ddocumento	= e.Ddocumento
					and doc.SNcodigo	= e.SNcodigo
			where e.ID = #Arguments.ID#
		</cfquery>

		<cfif NOT (rsSQL.TESRPTCietu EQ "1" OR rsSQL.TESRPTCietu EQ "2" OR rsSQL.TESRPTCietu EQ "3")>
			<cfreturn>
		</cfif>

		<!---  1) Documento a favor a Aplicar --->
		<cfquery name="rsIETUpago" datasource="#Arguments.Conexion#">
			insert into #request.IETUpago# (
					EcodigoPago,TipoPago,ReferenciaPago,DocumentoPago,
					FechaPago,SNid,
					McodigoPago,MontoPago,MontoPagoLocal,
					ReversarCreacion
				)
			select 	e.Ecodigo,
					2, 	<!--- CxP --->
					<cf_dbfunction name="sPart"	args="e.CPTcodigo,1,2">,
					<cf_dbfunction name="sPart"	args="e.Ddocumento,1,20">,

					e.EAfecha,

					sn.SNid,

					e.Mcodigo,
					e.EAtotal,
					round(e.EAtotal * e.EAtipocambio,2),
					1		<!--- Es una Aplicacion de Anticipo --->
			   from EAplicacionCP e
					inner join SNegocios sn
					 on sn.Ecodigo  = e.Ecodigo
					and sn.SNcodigo = e.SNcodigo
			where e.ID = #LvarGblID#
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
					2,	<!--- CxP --->
					<cf_dbfunction name="sPart"	args="doc.CPTcodigo,1,2">,
					<cf_dbfunction name="sPart"	args="doc.Ddocumento,1,20">,
					doc.Ocodigo,
					doc.Dfecha,

					-1,	<!--- Pago por Compra: Disminuye IETU --->

					doc.Mcodigo,
					round(d.DAmontodoc,2),

					<!---
						Proporcion aplicado al documento sobre el (Total - ImpuestosCF):
							MontoAplicado / Total * (Total-ImpuestosCF)
					--->
					round(d.DAmontodoc	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = doc.IDdocumento
							)
						, 1)
					,2),
					round(d.DAmontodoc	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = doc.IDdocumento
							)
						, 1) / d.DAtipocambio
					,2),
					round(d.DAmontodoc	*
						coalesce(
							(
								select (min(TotalFac)-sum(MontoCalculado)) / min(TotalFac)
								  from ImpDocumentosCxP
								 where IDdocumento = doc.IDdocumento
							)
						, 1) / d.DAtipocambio  * e.EAtipocambio
					,2),

					doc.TESRPTCid,
					0
			from EAplicacionCP e
				inner join DAplicacionCP d
					inner join EDocumentosCP doc
					 on doc.Ecodigo 	= d.Ecodigo
					and doc.CPTcodigo	= d.DAtransref
					and doc.Ddocumento	= d.DAdocref
					and doc.SNcodigo	= d.SNcodigo
					and doc.IDdocumento	= d.DAidref
				 on d.ID = e.ID
			where e.ID = #Arguments.ID#
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

    <!---SML--->
    <cffunction name="fnContabilizaGasto" access="public" output="no">
    	<cfargument name="NumeroEvento" type="string"   required="no" default="">

        <!----=======Valida que exista el Periodo Auxiliar=======--->
		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
			from Parametros
			Where Ecodigo =  #session.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 50
		</cfquery>
		<cfif isdefined("rsPeriodo") and rsPeriodo.RecordCount GT 0>
			<cfset Periodo =  rsPeriodo.Periodo>
		<cfelse>
			<cfthrow message="La empresa no tiene definido un Periodo Auxiliar">
		</cfif>

		<!----=======Valida que exista el Mes Auxiliar=======--->
		<cfquery name="rsMes" datasource="#session.DSN#">
			select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
			from Parametros
			Where Ecodigo =  #session.Ecodigo#
				and Mcodigo = 'GN'
				and Pcodigo = 60
		</cfquery>
		<cfif isdefined("rsMes") and rsMes.RecordCount GT 0>
			<cfset Mes =  rsMes.Mes>
		<cfelse>
			<cfthrow message="La empresa no tiene definido un Mes Auxiliar">
		</cfif>

        <cfquery name="rsSQL" datasource="#session.DSN#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.Ecodigo#
			   and Pcodigo = 1140
		</cfquery>

		<cfset LvarGenerarEjercido = (rsSQL.Pvalor EQ "S")>

		<cfif LvarGenerarEjercido>
			<!--- Movimientos de EJERCIDO Y PAGADO: Unicamente si está prendido parámetro de Contabilidad Presupuestaria --->
			<cfset sbPresupuestoAntsEfectivo_CxP ('CPPA',Periodo,Mes,false,'EJ')>
			<cfset sbPresupuestoAntsEfectivo_CxP ('CPPA',Periodo,Mes,false,'P')>
		<cfelse>
			<!--- Movimientos de PAGADO: Presupuesto normal --->
			<cfset sbPresupuestoAntsEfectivo_CxP ('CPPA',Periodo,Mes,false,'P')>
		</cfif>
	</cffunction>

    <cffunction name="sbPresupuestoAntsEfectivo_CxP" access="private">
		<cfargument name="Origen">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Anulacion">
		<cfargument name="TipoMov">

		<!--- Convierte las Ejecuciones del NAP de CxP a Pagado --->
		<!--- OJO, cuando se implemente Contabilizacion en Recepcion, hay que tomar en cuenta el NAP de la Recepción --->
		<cfquery datasource="#session.DSN#" name="rsPrueba">
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
			 <!---EJ/P:PAGADO' --->
			select '#Arguments.Origen#',
					a.DAdocref,
					b.CPTcodigo,
					<cf_dbfunction name="concat" args="'CxP: ';b.CPTcodigo;'-';rtrim(a.DAdocref)" delimiters=";">,
					b.Dfecha,
					#Arguments.Periodo# as Periodo,
					#Arguments.Mes# as Mes,
					coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
					<cfif Arguments.TipoMov NEQ 'P'>-</cfif>nap.CPNAPnum*100000+nap.CPNAPDlinea as NumeroLineaID,
					d.CFcuenta,																				<!--- CFuenta --->
					b.Ocodigo,																				<!--- Oficina --->
					b.Mcodigo,																				<!--- Mcodigo --->
					<cfif Arguments.Anulacion>-</cfif>a.DAmontodoc as MontoOrigen,
					c.EAtipocambio / a.DAtipocambio as TC,
					<cfif Arguments.Anulacion>-</cfif>round(a.DAmontodoc * c.EAtipocambio / a.DAtipocambio,2) as MontoLocal,
					'#Arguments.TipoMov#' as Tipo,
					nap.CPNAPnum, nap.CPNAPDlinea,
					nap.PCGDid,
					<cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
                from EAplicacionCP c
                    inner join DAplicacionCP a
                    inner join EDocumentosCP b on b.Ecodigo = a.Ecodigo and b.CPTcodigo = a.DAtransref
                        and b.Ddocumento = a.DAdocref and b.SNcodigo = a.SNcodigo and b.IDdocumento = a.DAidref on a.ID = c.ID
                    inner join DDocumentosCP d on d.IDdocumento = b.IDdocumento AND d.Ecodigo = b.Ecodigo AND d.DDtipo <> 'I'
                    inner join CPNAPdetalle nap on nap.Ecodigo = b.Ecodigo and nap.CPNAPnum	= b.NAP and nap.CFcuenta = d.CFcuenta
						and nap.CPNAPDtipoMov = 'E'
                where c.ID = #LvarGblID#
                union
                select '#Arguments.Origen#',
                	   a.DAdocref,
                       b.CPTcodigo,
                       <cf_dbfunction name="concat" args="'CxP: ';b.CPTcodigo;'-';rtrim(a.DAdocref)" delimiters=";">,
                       b.Dfecha,
                       #Arguments.Periodo# as Periodo,
					   #Arguments.Mes# as Mes,
                       coalesce((select max(INTLIN) from #request.intarc#),0)+1 as NumeroLinea,
					   <cfif Arguments.TipoMov NEQ 'P'>-</cfif>nap.CPNAPnum*100000+nap.CPNAPDlinea as NumeroLineaID,
					   d.CFcuenta,
                       b.Ocodigo,
                       b.Mcodigo,
                       <cfif Arguments.Anulacion>-</cfif>round((#LvarEAmonto# * e.MontoCalculado)/e.TotalFac,2) as MontoOrigen,
                       c.EAtipocambio / a.DAtipocambio as TC,
                       (round((#LvarEAmonto# * e.MontoCalculado)/e.TotalFac,2) / (c.EAtipocambio/a.DAtipocambio)) as MontoLocal,
                       '#Arguments.TipoMov#' as Tipo,
					   nap.CPNAPnum, nap.CPNAPDlinea,
					   nap.PCGDid,
					   <cfif Arguments.Anulacion>-</cfif>nap.PCGDcantidad as Cantidad_1
                from EAplicacionCP c
                    inner join DAplicacionCP a
                    inner join EDocumentosCP b on b.Ecodigo = a.Ecodigo and b.CPTcodigo = a.DAtransref
                        and b.Ddocumento = a.DAdocref and b.SNcodigo = a.SNcodigo and b.IDdocumento = a.DAidref on a.ID = c.ID
                    inner join DDocumentosCP d on d.IDdocumento = b.IDdocumento AND d.Ecodigo = b.Ecodigo AND d.DDtipo = 'I'
                    inner join CPNAPdetalle nap on nap.Ecodigo = b.Ecodigo and nap.CPNAPnum	= b.NAP and nap.CFcuenta = d.CFcuenta
                        and nap.CPNAPDtipoMov = 'E' and nap.CPNAPDmontoOri > 0
                    inner join ImpDocumentosCxP e on b.Ecodigo = e.Ecodigo and b.IDdocumento = e.IDdocumento and d.Icodigo = e.Icodigo
                    inner join Impuestos i on e.Ecodigo = i.Ecodigo and e.Icodigo = i.Icodigo
                where c.ID = #LvarGblID#
		</cfquery>
		<!---<cf_dumpTable var = "#request.intPresupuesto#">--->
	</cffunction>
</cfcomponent>


