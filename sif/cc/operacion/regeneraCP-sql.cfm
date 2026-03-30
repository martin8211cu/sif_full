<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 25/09/2018
	Proceso: Mostrar los complementos de pago generados,
	         para permitir la edicion y posteriormente la
	         regeneracion del mismo
 --->

<cfif isDefined("form.Regenerar")>
	<!--- OBTIENE EL XML --->
	<cfquery name="getXML" datasource="#session.dsn#">
		SELECT em.xmlTimbrado
		FROM HEFavor he
		INNER JOIN SNegocios sn ON sn.Ecodigo = he.Ecodigo AND sn.SNcodigo = he.SNcodigo
		INNER JOIN FA_CFDI_Emitido em ON em.Ecodigo = he.Ecodigo
		AND RTRIM(LTRIM(em.DocPago)) = RTRIM(LTRIM(he.Ddocumento))
		AND RTRIM(LTRIM(CONCAT(Serie,Folio,'_',DocPago))) = RTRIM(LTRIM(he.NombreComplemento))
		INNER JOIN Monedas m ON m.Mcodigo = he.Mcodigo AND m.Ecodigo = he.Ecodigo
		INNER JOIN HEMovimientos hm ON he.Ecodigo = hm.Ecodigo AND RTRIM(LTRIM(he.Ddocumento)) = hm.EMdocumento
		AND hm.SNcodigo = he.SNcodigo AND he.CCTcodigo = hm.TpoTransaccion
		WHERE he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isDefined("form.idHeFavor") AND LEN(form.idHeFavor)>
			AND he.idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHEfavor#">
		</cfif>
	</cfquery>
	<!--- ACTUALIZACION DE MONTOS Y NUMERO DE PARCIALIDAD A LA TABLA HISTORICA --->
	<cfif isdefined("getXML") AND #getXML.RecordCount# GT 0>
		<!--- Parseo de XML --->
		<cfset xmltimbrado = XmlParse(getXML.xmlTimbrado)>
		<!--- VARIABLES XML --->
		<cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
		<cfloop index="i" from = "1" to = #ArrayLen(nodearray.XmlChildren)#>
			<cfset att = nodearray.XmlChildren[i].XmlAttributes>
			<cfquery name="getNombreDoc" datasource="#session.dsn#">
				SELECT d.Ddocumento
				FROM Documentos d
				INNER JOIN FA_CFDI_Emitido e ON e.timbre = d.TimbreFiscal
				AND e.Ecodigo = d.Ecodigo
				WHERE CONCAT(RTRIM(LTRIM(e.Serie)), RTRIM(LTRIM(e.Folio))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(att.Serie)##TRIM(att.Folio)#">
			</cfquery>
			<cfif isdefined("getNombreDoc") AND #getNombreDoc.RecordCount# GT 0>
				<cfset lVarNombreDoc = #getNombreDoc.Ddocumento#>
			<cfelse>
				<cfset lVarNombreDoc = TRIM(att.Serie)&TRIM(att.Folio)>
			</cfif>
			<cfquery name="updateHDfavor" datasource="#session.dsn#">
				UPDATE HDFavor
				SET ImpSaldoInsoluto = <cfqueryparam cfsqltype="cf_sql_float" value="#att.ImpSaldoInsoluto#">,
				    ImpSaldoAnt = <cfqueryparam cfsqltype="cf_sql_float" value="#att.ImpSaldoAnt#">,
				    NumParcialidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#att.NumParcialidad#">
				WHERE idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHEfavor#">
				AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				AND RTRIM(LTRIM(DRdocumento)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(lVarNombreDoc)#">
			</cfquery>
		</cfloop>
	</cfif>
	<!--- OBTIENE INFO DE HISTORICA --->
	<cfquery name="getInfo" datasource="#session.dsn#">
		SELECT RTRIM(LTRIM(Ddocumento)) AS Ddocumento, SNcodigo, CCTcodigo, NombreComplemento,
		       idHEfavor
		FROM HEFavor
		WHERE idHeFavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idHeFavor#">
		  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif getInfo.RecordCount GT 0>
		<!--- ACTUALIZACION DE CAMPOS MODIFICADOS --->
		<cfquery name="updateCtaOrdenante" datasource="#session.dsn#">
			UPDATE HEMovimientos
			SET EMRfcBcoOrdenante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RFCOrdenante#">,
			    EMdescripcionOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CtaOrdenante#">
			WHERE EMdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.Ddocumento#">
			  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.SNcodigo#">
			  AND TpoTransaccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.CCTcodigo#">
		</cfquery>


		<!--- REGENERACION DEL COMPLEMENTO DE PAGO --->

		<!--- Invocación del componente --->
		<cfinvoke component="rh.Componentes.GeneraCFDIs.RegeneraComplementoPago"
				  method = "regenerarCP"
				  returnvariable = "nombreDoctoGenerado"
				  Ddocumento = "#getInfo.Ddocumento#"
				  Saldo = "#getInfo.Ddocumento#"
		/>

		<cfset lvarRegenera = "true">
		<cfquery name="rsPagoTimbrado" datasource="#session.dsn#">
			SELECT timbre, xmlTimbrado
			FROM FA_CFDI_Emitido
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  AND docPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.Ddocumento#">
			  AND NombreDoctoGenerado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreDoctoGenerado#">
			  AND stsTimbre = 1
		</cfquery>
		<cfset session.DocPago =  #getInfo.Ddocumento#>
		<cfset timbrePago = rsPagoTimbrado.timbre>
		<cfset xmlTimbrado = rsPagoTimbrado.xmlTimbrado>

		<!--- COPIA DE HISTORICA NO APLICA DE MOMENTO --->
		<!--- <cfquery name="insertHEFavor" datasource="#session.dsn#">
			INSERT INTO HEFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, Ccuenta, CFid, EFtipocambio, EFtotal,
			                     EFfecha, EFselect, EFusuario, BMUsucodigo, EFieps, CodTipoPago <cfif isDefined("nombreDoctoGenerado") AND #nombreDoctoGenerado# NEQ "">,NombreComplemento</cfif>)
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
			       <cfif isDefined("nombreDoctoGenerado") AND #nombreDoctoGenerado# NEQ "">
				       ,'#nombreDoctoGenerado#'
				   </cfif>
			FROM HEFavor
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  AND Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.Ddocumento#">
			  AND CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#getInfo.CCTcodigo#">
			  AND idHEfavor = <cfqueryparam cfsqltype="cf_sql_char" value="#getInfo.idHEfavor#">
			<cf_dbidentity1 name="insertHEFavor" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="insertHEFavor" datasource="#session.dsn#" returnvariable="lVarIdHEfavor"> --->

		<!--- Detalle  NO APLICA DE MOMENTO --->
		<!--- <cfquery name="insertHDFavor" datasource="#session.dsn#">
			INSERT INTO HDFavor (idHEfavor, Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, SNcodigo, Ccuenta, Mcodigo, CFid,
			                     DFmonto, DFtotal, DFmontodoc, DFtipocambio, BMUsucodigo, NumeroEvento)
			SELECT '#lVarIdHEfavor#',
			       Ecodigo,
			       CCTcodigo,
			       Ddocumento,
			       CCTRcodigo,
			       DRdocumento,
			       SNcodigo,
			       Ccuenta,
			       Mcodigo,
			       CFid,
			       DFmonto,
			       DFtotal,
			       DFmontodoc,
			       DFtipocambio,
			       BMUsucodigo,
			       NumeroEvento
			FROM HDFavor
			WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  AND Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getInfo.Ddocumento#">
			  AND CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#getInfo.CCTcodigo#">
			  AND idHEfavor = <cfqueryparam cfsqltype="cf_sql_char" value="#getInfo.idHEfavor#">
		</cfquery> --->

		<cfquery name="updateRegenerado" datasource="#session.dsn#">
			UPDATE HEFavor
			SET Regenerado = 1,
				UUIDHistorico =
				CASE WHEN UUIDHistorico IS NULL THEN <cfif isDefined("form.uuid") AND #form.uuid# NEQ ''>'#form.uuid#, #rsPagoTimbrado.timbre#'<cfelse>''</cfif>
				ELSE CONCAT(UUIDHistorico,', #rsPagoTimbrado.timbre#')
				END
			WHERE idHEfavor = <cfqueryparam cfsqltype="cf_sql_char" value="#getInfo.idHEfavor#">
			  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<!--- ACTUALIZACIÓN DE HISTORICA COMO REGENERADO --->
		<cfinclude template="/sif/fa/operacion/ImpresionMFECCO.cfm">

		<script language="javascript">
			alert('Complemento de Pago regenerado correctamente!');
			document.location = 'regeneraCP-list.cfm';
		</script>
	</cfif>
</cfif>