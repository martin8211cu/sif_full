<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 25/09/2018
	Proceso: Se encarga de realizar la cancelacion del CP.
	         Revertir saldo a documentos y generar polizar de reversa.
 --->

<!--- OBTIENE INFO DE HISTORICA --->
<cfquery name="getInfo" datasource="#session.dsn#">
	SELECT RTRIM(LTRIM(Ddocumento)) AS Ddocumento, SNcodigo, CCTcodigo, NombreComplemento,
	       idHEfavor, EFtotal, Mcodigo, EFtipocambio
	FROM HEFavor
	WHERE idHeFavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHeFavor#">
	  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- VALIDACION DE TRANSACCIONES --->
<!--- BANCOS --->
<cfquery name="rsTransaccionBancos" datasource="#session.dsn#">
	SELECT TOP 1 BTid
	FROM BTransacciones
	WHERE BTcodigo = 'AC'
	  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  AND UPPER(BTtipo) = 'C'
</cfquery>
<cfif rsTransaccionBancos.RecordCount EQ 0>
	<cfthrow message="Error: No se ha configurado la transacci&oacute;n de bancos AC tipo Cr&eacute;dito">
</cfif>

<!--- CUENTAS POR COBRAR --->
<cfquery name="rsTransaccionCxC" datasource="#session.dsn#">
	SELECT
	  CCTcodigo
	FROM CCTransacciones
	WHERE CCTcodigo = 'XP'
	AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	AND UPPER(CCTtipo) = 'D'
</cfquery>
<cfif rsTransaccionCxC.RecordCount EQ 0>
	<cfthrow message="Error: No se ha configurado la transacci&oacute;n de CxC XP tipo D&eacute;bito">
</cfif>


<cfif isDefined("form.CancelarFC") OR isDefined("form.CancelarMB")>
	<cfset lVarMbCancelado = "">
	<cfif getInfo.RecordCount GT 0>
		<!--- Reversa de saldos a documentos aplicados --->
		<cfquery name="getDocAplicados" datasource="#session.dsn#">
			SELECT CCTRcodigo,
			       DRdocumento,
			       SNcodigo,
			       Mcodigo,
			       DFmontodoc
			FROM HDFavor
			WHERE idHeFavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHeFavor#">
			AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cftransaction>
			<cftry>
				<cfloop query="getDocAplicados">
					<!--- Actualizacion de saldos Documentos relacionados--->
					<cfquery datasource="#session.dsn#">
						UPDATE Documentos
						   SET Dsaldo = Dsaldo + <cfqueryparam cfsqltype="cf_sql_float" value="#getDocAplicados.DFmontodoc#">
						 WHERE RTRIM(LTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.DRdocumento)#">
						   AND CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.CCTRcodigo)#">
						   AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDocAplicados.SNcodigo#">
						   AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<!--- Actualizacion de saldos HDocumentos PENDIENTE DE VALIDACION--->
					<!--- <cfquery datasource="#session.dsn#">
						UPDATE HDocumentos
						   SET Dsaldo = Dsaldo + <cfqueryparam cfsqltype="cf_sql_float" value="#getDocAplicados.DFmontodoc#">
						 WHERE RTRIM(LTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.DRdocumento)#">
						   AND CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.CCTRcodigo)#">
						   AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDocAplicados.SNcodigo#">
						   AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery> --->


					<!--- Se inserta nuevo movimiento tipo Debito --->
					<cfquery name="isrs" datasource="#session.dsn#">
						INSERT INTO BMovimientos ( IDcontable, Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento,
						                           BMfecha, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento,
						                           BMperiodo, BMmes, Ocodigo, BMusuario, Dtotalloc, Dtotalref, Mcodigoref,
						                           BMmontoref, BMfactor, Timbrefiscal, DdocumentoOri)
						SELECT IDcontable, Ecodigo, 'XP', Ddocumento, CCTRcodigo, DRdocumento,
						                           BMfecha, SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dfecha, Dvencimiento,
						                           BMperiodo, BMmes, Ocodigo, BMusuario, Dtotalloc, Dtotalref, Mcodigoref,
						                           BMmontoref, BMfactor, Timbrefiscal, DdocumentoOri
						 FROM BMovimientos
						WHERE RTRIM(LTRIM(DRdocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.DRdocumento)#">
						  AND RTRIM(LTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getInfo.Ddocumento)#">
						  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDocAplicados.SNcodigo#">
						  AND Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.Mcodigo#">
						  AND CCTcodigo IN
						    (SELECT CCTcodigo
						     FROM CCTransacciones
						     WHERE UPPER(CCTtipo) = 'C')
						  AND CCTRcodigo IN
						    (SELECT CCTcodigo
						     FROM CCTransacciones
						     WHERE UPPER(CCTtipo) = 'D')
						  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  AND BMCancelado IS NULL
					</cfquery>

					<!--- Se marca Movimiento como CANCELADO --->
					<cfquery name="updateEmov" datasource="#session.dsn#">
						UPDATE BMovimientos
						 SET  BMCancelado = 1
						WHERE RTRIM(LTRIM(DRdocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getDocAplicados.DRdocumento)#">
						  AND RTRIM(LTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getInfo.Ddocumento)#">
						  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDocAplicados.SNcodigo#">
						  AND Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.Mcodigo#">
						  AND CCTcodigo IN
						    (SELECT CCTcodigo
						     FROM CCTransacciones
						     WHERE UPPER(CCTtipo) = 'C')
						  AND CCTRcodigo IN
						    (SELECT CCTcodigo
						     FROM CCTransacciones
						     WHERE UPPER(CCTtipo) = 'D')
						  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
				</cfloop>

				<!--- Se regresa el saldo al Movimiento Bancario --->
				<cfquery datasource="#session.dsn#">
					UPDATE Documentos
					   SET Dsaldo = Dsaldo + <cfqueryparam cfsqltype="cf_sql_float" value="#getInfo.EFtotal#">
					 WHERE RTRIM(LTRIM(Ddocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getInfo.Ddocumento)#">
					   AND CCTcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(getInfo.CCTcodigo)#">
					   AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.SNcodigo#">
					   AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>

				<!---
					  Si es por Movimiento Bancario, se hace poliza de cancelacion
				      y Poliza por el movimiento Bancario
				--->
				<cfif isDefined("form.CancelarMB")>
					<cfquery name="rsInfoMB" datasource="#session.dsn#">
						SELECT he.EMid,
						       he.EMdocumento,
						       he.SNcodigo
						FROM HEMovimientos he
						INNER JOIN MLibros ml ON he.MLid = ml.MLid
						AND he.EMdocumento = ml.MLdocumento
						AND he.Ecodigo = ml.Ecodigo
						AND he.CBid = ml.CBid
						INNER JOIN HEFavor hf ON hf.Ddocumento = ml.MLdocumento
						AND hf.SNcodigo = he.SNcodigo
						AND hf.CCTcodigo = TpoTransaccion
						AND hf.Ecodigo = he.Ecodigo
						WHERE hf.idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHeFavor#">
						  AND hf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<cfif rsInfoMB.RecordCount GT 0>
						<!--- SE REGISTRA EL MOV. BANCARIO CR --->
						<!--- 'XP', Anulación de complemento de pago --->
						<cfquery name="insertMB" datasource="#session.dsn#">
							INSERT INTO EMovimientos (BTid, Ecodigo, CBid, CFid, Ocodigo, EMtipocambio, EMdocumento, EMtotal, EMreferencia, EMfecha, EMdescripcion, EMusuario, EMselect, BMUsucodigo, SNcodigo, id_direccion, TpoSocio, TpoTransaccion, Documento, SNid, CDCcodigo, EMdescripcionOD, EMBancoIdOD, Tipo, EMNombreBenefic, EMRfcBenefic, CodTipoPago, EMdocumentoRef, ERNid, EIid)
							SELECT #rsTransaccionBancos.BTid#,
							       Ecodigo,
							       CBid,
							       CFid,
							       Ocodigo,
							       EMtipocambio,
							       CONCAT(RTRIM(LTRIM(EMdocumento)),'-C') EMdocumento,
							       EMtotal,
							       EMreferencia,
							       EMfecha,
							       CONCAT(RTRIM(LTRIM(EMdocumento)),'-C') EMdescripcion,
							       EMusuario,
							       EMselect,
							       BMUsucodigo,
							       SNcodigo,
							       id_direccion,
							       TpoSocio,
							       'XP',
							       Documento,
							       SNid,
							       CDCcodigo,
							       EMdescripcionOD,
							       EMBancoIdOD,
							       Tipo,
							       EMNombreBenefic,
							       EMRfcBenefic,
							       CodTipoPago,
							       EMdocumentoRef,
							       ERNid,
							       EIid
							FROM HEMovimientos
							WHERE RTRIM(LTRIM(EMdocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(rsInfoMB.EMdocumento)#">
							  AND EMid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInfoMB.EMid#">
							  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
					</cfif>

					<cfquery name="rsGetMBCancelado" datasource="#session.dsn#">
						SELECT EMid, EMdocumento
						FROM EMovimientos
						WHERE RTRIM(LTRIM(EMdocumento)) LIKE '%-C'
						  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsInfoMB.SNcodigo#">
						  AND SUBSTRING(RTRIM(LTRIM(EMdocumento)), 0, LEN(RTRIM(LTRIM(EMdocumento))) - 1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(rsInfoMB.EMdocumento)#">
					</cfquery>

					<!--- Aplicación de Movimiento Bancario --->
					<!--- APLICACIÓN DEL MB, SE GUARDA EN LAS TABLAS HISTORICAS! --->
					<cfif rsGetMBCancelado.RecordCount GT 0>
						<cfset lVarMbCancelado = #TRIM(rsGetMBCancelado.EMdocumento)#>

						<cfquery datasource="#Session.DSN#">
							delete from HDMovimientos
							WHERE EMid = <cfqueryparam value="#rsGetMBCancelado.EMid#" cfsqltype="cf_sql_integer">
							  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery datasource="#Session.DSN#">
							DELETE FROM HEMovimientos
							WHERE EMid = <cfqueryparam value="#rsGetMBCancelado.EMid#" cfsqltype="cf_sql_integer">
							  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery datasource="#Session.DSN#" name="insertHDMovimientos">
							INSERT INTO HDMovimientos (EMid, DMlinea, Ecodigo, Ccuenta, Dcodigo, CFid, DMmonto, DMdescripcion, BMUsucodigo, PCGDid, CFcuenta, Icodigo)
							SELECT EMid,
							       DMlinea,
							       Ecodigo,
							       Ccuenta,
							       Dcodigo,
							       CFid,
							       DMmonto,
							       DMdescripcion,
							       BMUsucodigo,
							       PCGDid,
							       CFcuenta,
							       Icodigo
							FROM DMovimientos
							WHERE EMid = <cfqueryparam value="#rsGetMBCancelado.EMid#" cfsqltype="cf_sql_integer">
							  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfquery datasource="#Session.DSN#" name="insertHEMovimientos">
							INSERT INTO HEMovimientos (EMid, BTid, Ecodigo, CBid, CFid, Ocodigo, EMtipocambio, EMdocumento, EMtotal, EMreferencia, EMfecha, EMdescripcion, EMusuario, EMselect, BMUsucodigo, SNcodigo, id_direccion, TpoSocio, TpoTransaccion, Documento, SNid, CDCcodigo, EMdescripcionOD, EMBancoIdOD, Tipo, EMNombreBenefic, EMRfcBenefic, EMdocumentoRef, ERNid, EIid, CodTipoPago)
							SELECT EMid,
							       BTid,
							       Ecodigo,
							       CBid,
							       CFid,
							       Ocodigo,
							       EMtipocambio,
							       EMdocumento,
							       EMtotal,
							       EMreferencia,
							       EMfecha,
							       EMdescripcion,
							       EMusuario,
							       EMselect,
							       BMUsucodigo,
							       SNcodigo,
							       id_direccion,
							       TpoSocio,
							       TpoTransaccion,
							       Documento,
							       SNid,
							       CDCcodigo,
							       EMdescripcionOD,
							       EMBancoIdOD,
							       Tipo,
							       EMNombreBenefic,
							       EMRfcBenefic,
							       EMdocumentoRef,
							       ERNid,
							       EIid,
							       CodTipoPago
							FROM EMovimientos
							WHERE EMid = <cfqueryparam value="#rsGetMBCancelado.EMid#" cfsqltype="cf_sql_integer">
							  AND Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
							<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
							<cfinvokeargument name="EMid" value="#rsGetMBCancelado.EMid#"/>
							<cfinvokeargument name="usuario" value="#session.usucodigo#"/>
							<cfinvokeargument name="debug" value="N"/>
				            <cfinvokeargument name="ubicacion" value="0"/>
						</cfinvoke>
					</cfif>
				</cfif>

				<!--- Creación de poliza reversa --->
				<!--- Invocación del componente --->
				<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
						  method = "sbRevertirAplicacionDocs"
						  CCTcodigo = "#getInfo.CCTcodigo#"
						  Ddocumento = "#getInfo.Ddocumento#"
						  IdDocumento = "#getInfo.idHEfavor#"
						  returnvariable = "idContable"
				/>

				<!--- Se marca como cancelado el Complemento --->
				<cfquery name="updateCancelado" datasource="#session.dsn#">
					UPDATE HEFavor
					SET Cancelado = 1
					WHERE idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.idHEfavor#">
					AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>


				<cfquery name="getInfoDocCancel" datasource="#session.dsn#">
					SELECT Ecodigo,
					       CCTcodigo,
					       Ddocumento,
					       SNcodigo,
					       Mcodigo,
					       Ccuenta,
					       CFid,
					       EFtipocambio,
					       EFtotal,
					       EFfecha,
					       EFselect,
					       EFusuario,
					       BMUsucodigo,
					       EFieps,
					       CodTipoPago
					FROM HEFavor
					WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  AND idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.idHEfavor#">
				</cfquery>

				<cfif isdefined("getInfoDocCancel") AND #getInfoDocCancel.RecordCount# GT 0>
					<cfset lvarFecha = CreateDateTime(YEAR(getInfoDocCancel.EFfecha),
			                          MONTH(getInfoDocCancel.EFfecha),
			                          DAY(getInfoDocCancel.EFfecha),
			                          HOUR(now()),
			                          MINUTE(now()),
			                          SECOND(now()))>

					<!--- Se inserta nuevamente el encabezado de la aplicación de documentos EFavor --->
					<cfquery name="insertHEFavor" datasource="#session.dsn#">
						INSERT INTO EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, Ccuenta, CFid, EFtipocambio, EFtotal,
						                    EFfecha, EFselect, EFusuario, BMUsucodigo, EFieps, CodTipoPago)
						VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfoDocCancel.CCTcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfoDocCancel.Ddocumento#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.Ccuenta#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.CFid#"  null="#NOT LEN(TRIM(getInfoDocCancel.CFid))#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#getInfoDocCancel.EFtipocambio#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#getInfoDocCancel.EFtotal#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.EFselect#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfoDocCancel.EFusuario#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoDocCancel.BMUsucodigo#" null="#NOT LEN(TRIM(getInfoDocCancel.BMUsucodigo))#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#getInfoDocCancel.EFieps#"  null="#NOT LEN(TRIM(getInfoDocCancel.EFieps))#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfoDocCancel.CodTipoPago#">

								)
					</cfquery>
				</cfif>


				<!--- APLICACIÓN DEL MB BANCARIO DE CANCELACION AL ORIGINAL (SOLO ES ES POR CANCELACION MB) --->
				<cfif isDefined("form.CancelarMB")>
					<cfquery name="insertDFavor" datasource="#session.dsn#">
						INSERT INTO DFavor (Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, SNcodigo, Ccuenta, Mcodigo,
						                    DFmonto, DFtotal, DFmontodoc, DFtipocambio)
						SELECT Ecodigo,
						       CCTcodigo,
						       Ddocumento,
						       'XP',
						       <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarMbCancelado#">,
						       SNcodigo,
						       Ccuenta,
						       <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.Mcodigo#">,
						       SUM(DFmonto),
						       SUM(DFtotal),
						       SUM(DFmonto),
						       <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.EFtipocambio#">
						FROM HDFavor
						WHERE idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.idHEfavor#">
						  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						GROUP BY Ecodigo,
						         CCTcodigo,
						         Ddocumento,
						         SNcodigo,
						         Ccuenta,
						         DFtipocambio
					</cfquery>

					<!--- Aplicación de Documentos en CxC del movimiento cancelado vs el original --->
					<cfquery name="getEfavor" datasource="#session.dsn#">
						SELECT CCTcodigo,
						       Ddocumento,
						       sn.SNid
						FROM HEFavor e
						INNER JOIN SNegocios sn ON e.Ecodigo = sn.Ecodigo
						AND e.SNcodigo = sn.SNcodigo
						WHERE e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  AND idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfo.idHEfavor#">
					</cfquery>

					<cfif getEfavor.RecordCount GT 0>
						<!--- Invoca el componente de posteo --->
						<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
							method = "CC_PosteoDocsFavorCxC"
							Ecodigo    = "#Session.Ecodigo#"
							CCTcodigo  = "#getEfavor.CCTcodigo#"
							Ddocumento = "#getEfavor.Ddocumento#"
							usuario    = "#Session.usuario#"
							SNid       = "#getEfavor.SNid#"
							Usucodigo  = "#Session.usucodigo#"
							fechaDoc   = "S"
			                transaccionActiva = "false"
							debug      = "NO"/>
					</cfif>
				</cfif>

				<cftransaction action="commit" />
				<script language="javascript">
					alert('Complemento de Pago cancelado correctamente!');
					document.location = 'CancelarCP-list.cfm';
				</script>
				<cfcatch type="database">
					<cftransaction action="rollback" />
					<cfset lVarError = "">
					<cfif isDefined('cfcatch.queryError')>
						<cfset lVarError = lVarError & ", #cfcatch.queryError#">
					</cfif>
					<cfif isDefined('cfcatch.detail')>
						<cfset lVarError = lVarError & ", #cfcatch.detail#">
					</cfif>
					<cfthrow message="Error al cancelar el complemento. [#lVarError#]">
				</cfcatch>
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset lVarError = "">
					<cfif isDefined('cfcatch.sql')>
						<cfset lVarError = lVarError & ", #cfcatch.sql#">
					<cfelseif isDefined('cfcatch.Detail')>
						<cfset lVarError = lVarError & ", #cfcatch.Detail#">
					</cfif>
					<cfthrow message="Ha ocurrido un error al cancelar el complemento de pago. [#cfcatch.message# #lVarError#]">
				</cfcatch>
			</cftry>
		</cftransaction>
	</cfif>
</cfif>
