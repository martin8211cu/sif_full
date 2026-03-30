<!--- VARIABLES --->
<cfset navegacion = "">
<cfif isdefined("form.periodo")  or isdefined("url.periodo")>
	<cfset Anio = #url.periodo#>
	<cfset navegacion = "periodo=#Anio#">
</cfif>
<cfif isdefined("form.mes")  or isdefined("url.mes")>
	<cfset mes = #url.mes#>
	<cfset navegacion = navegacion & "&mes=#mes#">
</cfif>


<cfset listErrores = "">

<cfif isdefined("url.tipoSolicitud")>
	<cfset tipoSolicitud = #url.TipoSolicitud#>
</cfif>
<cfif isdefined("url.numOrden")>
	<cfset numOrden = #url.numOrden#>
</cfif>
<cfif isdefined("url.numTramite")>
	<cfset numTramite = #url.numTramite#>
</cfif>
<!--- <cf_dump var="#numOrden#"> --->
<cfif #mes# eq "1" >
<cfset mes = '01'>
<cfelseif #mes# eq "2">
<cfset mes = '02'>
<cfelseif #mes# eq "3">
<cfset mes = '03'>
<cfelseif #mes# eq "4">
<cfset mes = '04'>
<cfelseif #mes# eq "5">
<cfset mes = '05'>
<cfelseif #mes# eq "6">
<cfset mes = '06'>
<cfelseif #mes# eq "7">
<cfset mes = '07'>
<cfelseif #mes# eq "8">
<cfset mes = '08'>
<cfelseif #mes# eq "9">
<cfset mes = '09'>
</cfif>

<!--- obtencion del RFC de la empresa --->
<cfquery name="rsRfc" datasource="#Session.DSN#">
	SELECT Eidentificacion
	FROM Empresa
	WHERE Ereferencia = #Session.Ecodigo#
</cfquery>

<cfquery name="rsEncabezado" datasource="#session.DSN#">
    SELECT he.IDcontable, (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)) as NumUnIdenPol,
 	CONVERT(VARCHAR(10),he.Efecha,126) as Fecha,
 	rp.IdRep,
 	(CASE ISNULL(rp.TipoComprobante, 1)
       WHEN 1 THEN 1
       WHEN 2 THEN 3
       WHEN 3 THEN 2
       END) TipoComprobante, rp.TipoComprobante AS TDS, rp.xmlTimbrado,
 	REPLACE(ISNULL(rp.Miso4217, 'MXN'), 'MXP', 'MXN') Miso4217,
 	rp.TipoCambio, rp.timbre, rp.Serie,
 	rp.CEMetPago, rp.CESNB,
 	hd.Dtipocambio, hd.Doriginal as montoTotal, rp.rfc,
 	rp.linea
 	FROM HEContables he, HDContables hd, CERepositorio rp
 	WHERE rp.IdContable = he.IDcontable
 	AND hd.IDcontable = he.IDcontable
 	AND hd.IDcontable = rp.IdContable
 	AND hd.Dlinea = rp.linea
	AND he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	<cfif isdefined("mes")>
		AND he.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
	</cfif>
	<cfif isdefined("Anio")>
		AND he.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Anio#">
	</cfif>
	<cfif isdefined("form.chk")>
		and he.IDcontable in (#form.chk#)
	<cfelse>
		<cfif isdefined("url.lote") and Len(Trim(url.lote)) and trim(url.lote) NEQ -1>
             AND he.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.lote)#">
             <cfset navegacion = navegacion & "&lote=#url.lote#">
         </cfif>
         <cfif isdefined("url.poliza") and Len(Trim(url.poliza)) and trim(url.poliza) NEQ -1>
             AND he.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(url.poliza)#">
             <cfset navegacion = navegacion & "&poliza=#url.poliza#">
         </cfif>
         <cfif isdefined("url.moneda") and len(trim(url.moneda))>
             AND hd.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(url.moneda)#">
             <cfset navegacion = navegacion & "&moneda=#url.moneda#">
         </cfif>
         <cfif isdefined("url.documento") and Len(Trim(url.documento))>
             AND UPPER(he.Edocbase) LIKE UPPER('%#url.documento#%')
             <cfset navegacion = navegacion & "&documento=#url.documento#">
         </cfif>
         <cfif isdefined("url.Referencia") and Len(Trim(url.Referencia))>
             AND UPPER(he.Ereferencia) like '%#UCASE(url.Referencia)#%'
             <cfset navegacion = navegacion & "&Referencia=#url.Referencia#">
         </cfif>
         <cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) GT 0 and LSisdate(listgetat(url.fechaIni, 1))>
             AND <cf_dbfunction name="to_date00" args="he.ECfechacreacion"> >= #LSParseDateTime(listgetat(url.fechaIni, 1))#
             <cfset navegacion = navegacion & "&fechaIni=#url.fechaIni#">
         </cfif>
         <cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) GT 0 and LSisdate(listgetat(url.fechaFin, 1))>
             AND <cf_dbfunction name="to_date00" args="he.ECfechacreacion"> <= #LSParseDateTime(listgetat(url.fechaFin, 1))#
             <cfset navegacion = navegacion & "&fechaFin=#url.fechaFin#">
         </cfif>
	</cfif>
	ORDER BY (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)), rp.linea, rp.TipoComprobante
</cfquery>
<!--- <cf_dump var="#rsEncabezado#"> --->


<!--- VARIABLES PARA GUARDAR VALOR DE CADENA ORIGINAL POR NODOS --->
<cfset CadenaOriginalRepAuxFol = "">
<cfset CadenaOriginalDetAuxFol= "">
<cfset CadenaOriginalComprNal = "">
<cfset CadenaOriginalComprNalOtr = "">
<cfset CadenaOriginalComprExt = "">

<!--- CREACION DE XML AUXILIAR DE FOLIOS --->
<cfset xmlRepAuxFol = XmlNew()>

<!--- creacion del tag padre --->
<cfset xmlRepAuxFol.XMLRoot = XMLElemNew(xmlRepAuxFol,"RepAuxFol")>

<!--- se agregan atributos al padre --->

<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["xmlns:contelec_td"] = "www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogosParaEsqContE">

<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["xmlns"] = "www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios">

<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance">

<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["xsi:schemaLocation"] = "www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios/AuxiliarFolios_1_3.xsd">
<!--- <cfset xmlRepAuxFol.xmlRoot.XmlAttributes[""] = ""> --->

<!--- VERSION requerido--->
<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["Version"] = "1.3">
<cfset CadenaOriginalRepAuxFol = "1.3">

<!--- RFC requerido--->
<cfif rsRfc.recordCount GTE 1>
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["RFC"] = "#rsRfc.Eidentificacion#">
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#rsRfc.Eidentificacion#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El RFC es requerido. A nivel raiz.|")>
</cfif>

<!--- MES requerido--->
<cfif #mes# NEQ "-1">
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["Mes"] = "#mes#">
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#mes#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El mes es requerido. A nivel raiz.|")>
</cfif>

<!--- ANIO requerido--->
<cfif #anio# NEQ "-1">
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["Anio"] = #anio#>
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#anio#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El Periodo es requerido. A nivel raiz.|")>
</cfif>

									<!--- DATOS SOLICITADOS PARA EL USUARIO --->
<!--- TIPO DE SOLICITUD requerido--->
<cfif isdefined("tipoSolicitud") and Len(Trim(#tipoSolicitud#))>
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["TipoSolicitud"] = #tipoSolicitud#>
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#TipoSolicitud#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El Tipo de solicitud es requerido. A nivel raiz.|")>
</cfif>

<!--- ESTA VALIDACION SE REALIZA DESDE EL POPUP CON JAVASCRIPT --->
<!--- NUMORDEN Opcional, requerido si el tipo de solicitud es: AF o FC--->
<cfif isdefined("numOrden") and Len(Trim(#numOrden#))>
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#numOrden#">
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["NumOrden"] = #numOrden#>
</cfif>

<!--- NumTramite Opcional requerido si el tipo de solicitud es: DE o CO--->
<cfif isdefined("numTramite") and Len(Trim(#numTramite#))>
	<cfset CadenaOriginalRepAuxFol = CadenaOriginalRepAuxFol & "|#numOrden#">
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["NumTramite"] = #numTramite#>
</cfif>


<!--- ITERACION DE POLIZAS --->
<cfif rsEncabezado.recordCount GTE 1>
<cfset rsIdContable = "">
<cfset VarPosition = 0>
<cfset VarNietoTipo1 = 1>
<cfset VarNietoTipo2 = 1>
<cfset VarNietoTipo3 = 1>
<cfset varInfoXML = "">
<cfset strgXmlTimbrado = "">
<cfset varRFCEmisor = "">
<cfset varMontoTotal = "">
<cfset varTipoCambio = "">

	<cfset varMetodoPago = "">
	<cfloop query="rsEncabezado">
		<cfif Len(Trim(rsEncabezado.xmlTimbrado)) NEQ 0>
				<cfset strgXmlTimbrado = #rsEncabezado.xmlTimbrado#>
				<cfset strgXmlTimbrado = ReplaceNoCase(strgXmlTimbrado,"''", '"',"all")>
				<cfset varInfoXML = XmlParse(strgXmlTimbrado)>
				<cfif Len(Trim(#varInfoXML.Comprobante.Emisor.XmlAttributes.rfc#))>
					<cfset varRFCEmisor = "#Trim(varInfoXML.Comprobante.Emisor.XmlAttributes.rfc)#">
				</cfif>
				<cfif isdefined("varInfoXML.Comprobante.Emisor.XmlAttributes.total") AND Len(Trim(#varInfoXML.Comprobante.Emisor.XmlAttributes.total#))>
					<cfset varMontoTotal = "#Trim(numberFormat(varInfoXML.Comprobante.XmlAttributes.total,"0.00"))#">
				</cfif>
				<cfif isdefined("varInfoXML.Comprobante.Emisor.XmlAttributes.TipoCambio") AND Len(Trim(#varInfoXML.Comprobante.Emisor.XmlAttributes.TipoCambio#))>
					<cfset varTipoCambio = "#Trim(numberFormat(varInfoXML.Comprobante.XmlAttributes.TipoCambio,"0.00"))#">
				</cfif>
				<cfif isDefined("varInfoXML.Comprobante.Emisor.XmlAttributes.TipoCambio") AND Len(Trim(#varInfoXML.Comprobante.Emisor.XmlAttributes.TipoCambio#))>
					<cfset varMetodoPago = "#Trim(numberFormat(varInfoXML.Comprobante.XmlAttributes.TipoCambio,"0.00"))#">
				</cfif>
		</cfif>
		<cfif varRFCEmisor EQ "" AND  Len(Trim(rsEncabezado.rfc)) NEQ 0>
			<cfset varRFCEmisor = "#Trim(rsEncabezado.rfc)#">
		</cfif>
		<cfif varMontoTotal EQ "" AND  Len(Trim(rsEncabezado.montoTotal)) NEQ 0>
			<cfset varMontoTotal = "#Trim(numberFormat(rsEncabezado.montoTotal,"0.00"))#">
		</cfif>
		<cfif varTipoCambio EQ "" AND  Len(Trim(rsEncabezado.Dtipocambio)) NEQ 0>
			<cfset varTipoCambio = "#Trim(numberFormat(rsEncabezado.Dtipocambio,"0.00"))#">
		</cfif>
		<!--- <cf_dump var="varMontoTotal #varMontoTotal#"> --->
		<cfif rsIdContable NEQ rsEncabezado.IDcontable>
			<cfset VarPosition = 1 + VarPosition>
				<cfset VarNietoTipo1 = 1>
				<cfset VarNietoTipo2 = 1>
				<cfset VarNietoTipo3 = 1>
				<cfif  Len(Trim(rsEncabezado.CEMetPago)) NEQ 0>
					<cfquery name="rsGetMetPago" datasource="#Session.DSN#">
						SELECT tab.Concepto, tab.Clave
						FROM
						(SELECT DISTINCT mtd.Clave, mtd.Concepto, abd.TESTMPcodigo, abd.TESTMPMtdoPago
						FROM TEStipoMedioPago abd LEFT OUTER JOIN CEMtdoPago mtd ON abd.TESTMPMtdoPago = mtd.Clave) tab
						WHERE tab.TESTMPcodigo = <cfqueryparam value="#trim(rsEncabezado.CEMetPago)#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>


				<cfif  Len(Trim(rsEncabezado.CESNB)) NEQ 0>
					<cfquery name="rsTaxID" datasource="#Session.DSN#">
						SELECT SNidentificacion
						FROM SNegocios
						WHERE SNcodigo = <cfqueryparam value="#trim(rsEncabezado.CESNB)#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<!--- NUEVO NODO HIJO --->
				<cfset xmlRepAuxFol.RepAuxFol.XmlChildren[VarPosition] = XmlElemNew(xmlRepAuxFol,"DetAuxFol")>
				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.NumUnIdenPol))>
					<cfif #CadenaOriginalDetAuxFol# EQ "">
						<cfset CadenaOriginalDetAuxFol = CadenaOriginalDetAuxFol & "#Trim(rsEncabezado.NumUnIdenPol)#">
						<cfelse>
							<cfset CadenaOriginalDetAuxFol = CadenaOriginalDetAuxFol & "|#Trim(rsEncabezado.NumUnIdenPol)#">
					</cfif>
					<cfset xmlRepAuxFol.RepAuxFol.XmlChildren[VarPosition].XmlAttributes["NumUnIdenPol"] = "#rsEncabezado.NumUnIdenPol#">
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Num. de poliza es requerido.|")>
				</cfif>

				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.Fecha))>
					<cfset xmlRepAuxFol.RepAuxFol.XmlChildren[VarPosition].XmlAttributes["Fecha"] = "#rsEncabezado.Fecha#">
					<cfset CadenaOriginalDetAuxFol = CadenaOriginalDetAuxFol & "|#Trim(rsEncabezado.Fecha)#">
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "La fecha es requerida, para la poliza #rsEncabezado.NumUnIdenPol#.|")>
				</cfif>


				<!--- AGREGA PRIMER COMPROBANTE --->
				<cfif rsEncabezado.TipoComprobante EQ 1>
					 <!--- ComprNal --->
					 <!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprNal"))>
					<cfif #CadenaOriginalComprNal# EQ "">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "#Trim(rsEncabezado.timbre)#">
						<cfelse>
							<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#Trim(rsEncabezado.timbre)#">
					</cfif>
					<!--- se agregan atributos al nuevo nieto --->

					<!--- Requerido --->
					<cfif Len(Trim(#rsEncabezado.timbre#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["UUID_CFDI"]="#Trim(rsEncabezado.timbre)#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El UUID es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varRFCEmisor#))>

						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["RFC"]="#Trim(varRFCEmisor)#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#Trim(varRFCEmisor)#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El RFC es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["MetPagoAux"]="#Trim(rsGetMetPago.Clave)#">
							<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#Trim(rsGetMetPago.Clave)#">
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["Moneda"]="#Trim(rsEncabezado.Miso4217)#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#Trim(rsEncabezado.Miso4217)#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[1].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#varTipoCambio#">
					</cfif>

					<!--- SE MANDA LA POSICION 2 A LA VARIABLE DE NIETOS, POR SI TUVIERA MAS COMPROBANTES --->
					<cfset VarNietoTipo1 = 2>
				</cfif>

				<cfif rsEncabezado.TipoComprobante EQ 2>
					<!--- ComprExt --->
					<!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprExt"))>
					<!--- se agregan atributos al nuevo nieto --->
					<!--- Requerido --->
					<cfif Len(Trim(#rsEncabezado.timbre#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["NumFactExt"]="#Trim(rsEncabezado.timbre)#">
						<cfif #CadenaOriginalComprExt# EQ "">
							<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "#Trim(rsEncabezado.timbre)#">
							<cfelse>
								<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsEncabezado.timbre)#">
						</cfif>
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El NumFactExt es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CESNB)) NEQ 0 AND isDefined("rsTaxID.SNidentificacion") AND Len(Trim(#rsTaxID.SNidentificacion#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["TaxID"]="#Trim(rsTaxID.SNidentificacion)#">
					</cfif>


					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["MetPagoAux"]="#Trim(rsGetMetPago.Clave)#">
							<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsGetMetPago.Clave)#">
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#))  AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["Moneda"]="#Trim(rsEncabezado.Miso4217)#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsEncabezado.Miso4217)#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#))  AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#varTipoCambio#">
					</cfif>

					<!--- SE MANDA LA POSICION 2 A LA VARIABLE DE NIETOS, POR SI TUVIERA MAS COMPROBANTES --->
					<cfset VarNietoTipo2 = 2>

				</cfif>

				<cfif rsEncabezado.TipoComprobante EQ 3>
					<!--- ComprNalOtr --->
					<!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprNalOtr"))>
					<!--- se agregan atributos al nuevo nieto --->
					<!--- Opcional --->
					<cfif Len(Trim(#rsEncabezado.serie#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["CFD_CBB_Serie"]="#Trim(rsEncabezado.Serie)#">
						<cfif #CadenaOriginalComprNalOtr# EQ "">
							<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "#Trim(rsEncabezado.Serie)#">
							<cfelse>
								<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.Serie)#">
						</cfif>
					</cfif>
					<!--- Requerido --->
					<cfif IsNumeric(#rsEncabezado.timbre#)>
						<cfif Len(Trim(#rsEncabezado.timbre#))>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["CFD_CBB_NumFol"]="#Trim(rsEncabezado.timbre)#">
							<cfif #CadenaOriginalComprNalOtr# EQ "">
							 	<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "#Trim(rsEncabezado.timbre)#">
								<cfelse>
									<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.timbre)#">
							</cfif>
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El numero de folio del comprobante CFD_CBB es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						</cfif>
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El numero de folio del comprobante CFD_CBB es un numero invalido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varRFCEmisor#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["RFC"]="#varRFCEmisor#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varRFCEmisor#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El RFC es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.")>
					</cfif>

					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[1].XmlAttributes["MetPagoAux"]="#Trim(rsGetMetPago.Clave)#">
							<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsGetMetPago.Clave)#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["Moneda"]="#Trim(rsEncabezado.Miso4217)#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.Miso4217)#">
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[1].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varTipoCambio#">
					</cfif>

					<!--- SE MANDA LA POSICION 2 A LA VARIABLE DE NIETOS, POR SI TUVIERA MAS COMPROBANTES --->
					<cfset VarNietoTipo3 = 2>
				</cfif>


				<!--- Se alimenta rsIdContable, para cambiar el valor inicial --->
				<cfset rsIdContable = rsEncabezado.IDcontable>

			<cfelse>

				<!--- SOLO NIETOS EN CASO DE QUE SEA LA MISMA POLIZA --->

				<cfif  Len(Trim(rsEncabezado.CEMetPago)) NEQ 0>
					<cfquery name="rsGetMetPago" datasource="#Session.DSN#">
						SELECT tab.Concepto, tab.Clave
						FROM
						(SELECT DISTINCT mtd.Clave, mtd.Concepto, abd.TESTMPcodigo, abd.TESTMPMtdoPago
						FROM TEStipoMedioPago abd LEFT OUTER JOIN CEMtdoPago mtd ON abd.TESTMPMtdoPago = mtd.Clave) tab
						WHERE tab.TESTMPcodigo = <cfqueryparam value="#trim(rsEncabezado.CEMetPago)#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>

				<cfif  Len(Trim(rsEncabezado.CESNB)) NEQ 0>
					<cfquery name="rsTaxID" datasource="#Session.DSN#">
						SELECT SNidentificacion
						FROM SNegocios
						WHERE SNcodigo = <cfqueryparam value="#trim(rsEncabezado.CESNB)#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>

				<cfif rsEncabezado.TipoComprobante EQ 1>
					 <!--- ComprNal --->
					 <!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprNal"))>

					<!--- se agregan atributos al nuevo nieto --->

					<!--- Requerido --->
					<cfif Len(Trim(#rsEncabezado.timbre#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["UUID_CFDI"]="#Trim(rsEncabezado.timbre)#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#Trim(rsEncabezado.timbre)#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El UUID es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>


					<!--- Requerido --->
					<cfif Len(Trim(#varRFCEmisor#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["RFC"]="#varRFCEmisor#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#varRFCEmisor#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El RFC es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Concepto)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["MetPagoAux"]="#rsGetMetPago.Clave#">
							<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#rsGetMetPago.Clave#">
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["Moneda"]="#rsEncabezado.Miso4217#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#rsEncabezado.Miso4217#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNal[VarNietoTipo1].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprNal = CadenaOriginalComprNal & "|#varTipoCambio#">
					</cfif>

					<!--- SE VA INCREMENTANDO LA VARIABLE DE NIETOS POR SI LLEGARA A TENER MAS EN EL PROX. REGISTRO --->
					<cfset VarNietoTipo1 = 1 + VarNietoTipo1>
				</cfif>


				<cfif rsEncabezado.TipoComprobante EQ 2>
					<!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprExt"))>
					<!--- se agregan atributos al nuevo nieto --->
					<!--- Requerido --->
					<cfif Len(Trim(#rsEncabezado.timbre#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["NumFactExt"]="#Trim(rsEncabezado.timbre)#">
						<cfif #CadenaOriginalComprExt# EQ "">
							<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "#Trim(rsEncabezado.timbre)#">
							<cfelse>
								<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsEncabezado.timbre)#">
						</cfif>
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El NumFactExt es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CESNB)) NEQ 0 AND isDefined("rsTaxID.SNidentificacion") AND Len(Trim(#rsTaxID.SNidentificacion#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["TaxID"]="#Trim(rsTaxID.SNidentificacion)#">
					</cfif>


					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["MetPagoAux"]="#rsGetMetPago.Clave#">
							<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsGetMetPago.Clave)#">
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#))  AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["Moneda"]="#Trim(rsEncabezado.Miso4217)#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#Trim(rsEncabezado.Miso4217)#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#))  AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo2].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprExt = CadenaOriginalComprExt & "|#varTipoCambio#">
					</cfif>

					<!--- SE VA INCREMENTANDO LA VARIABLE DE NIETOS POR SI LLEGARA A TENER MAS EN EL PROX. REGISTRO --->
					<cfset VarNietoTipo2 = 1 + VarNietoTipo2>
				</cfif>


				<cfif rsEncabezado.TipoComprobante EQ 3>
					<!--- ComprNalOtr --->
					<!--- se crea nuevo nodo nieto --->
					<cfset arrayappend(xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].XmlChildren, XmlElemNew(xmlRepAuxFol,"ComprNalOtr"))>
					<!--- se agregan atributos al nuevo nieto --->
					<!--- Opcional --->
					<cfif Len(Trim(#rsEncabezado.serie#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["CFD_CBB_Serie"]="#Trim(rsEncabezado.Serie)#">
						<cfif #CadenaOriginalComprNalOtr# EQ "">
							<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "#Trim(rsEncabezado.Serie)#">
							<cfelse>
								<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.Serie)#">
						</cfif>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(#rsEncabezado.timbre#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["CFD_CBB_NumFol"]="#Trim(rsEncabezado.timbre)#">
						<cfif #CadenaOriginalComprNalOtr# EQ "">
							<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "#Trim(rsEncabezado.timbre)#">
							<cfelse>
								<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.timbre)#">
						</cfif>
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El numero de folio del comprobante CFD_CBB es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Requerido --->
					<cfif Len(Trim(#varRFCEmisor#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["RFC"]="#varRFCEmisor#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varRFCEmisor#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El RFC es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(#varMontoTotal#))>
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["MontoTotal"]="#varMontoTotal#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varMontoTotal#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Monto total es requerido, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
					</cfif>

					<!--- Opcional --->
					<cfif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) EQ 0>
						<cfset listErrores = ListAppend(listErrores, "El metodo de pago no esta configurado correctamente, poliza: #rsEncabezado.NumUnIdenPol#, l&iacute;nea: #rsEncabezado.linea#.|")>
						<cfelseif Len(Trim(rsEncabezado.CEMetPago)) NEQ 0 AND Len(Trim(rsGetMetPago.Clave)) NEQ 0>
							<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprExt[VarNietoTipo3].XmlAttributes["MetPagoAux"]="#Trim(rsGetMetPago.Clave)#">
							<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsGetMetPago.Clave)#">
					</cfif>

					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#rsEncabezado.Miso4217#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["Moneda"]="#Trim(rsEncabezado.Miso4217)#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#Trim(rsEncabezado.Miso4217)#">
					</cfif>
					<!--- Opcional - Req. solo si la moneda es diferente a peso mexicano--->
					<cfif Len(Trim(#varTipoCambio#)) AND Trim(#rsEncabezado.Miso4217#) NEQ "MXN">
						<cfset xmlRepAuxFol.RepAuxFol.DetAuxFol[VarPosition].ComprNalOtr[VarNietoTipo3].XmlAttributes["TipCamb"]="#varTipoCambio#">
						<cfset CadenaOriginalComprNalOtr = CadenaOriginalComprNalOtr & "|#varTipoCambio#">
					</cfif>

				<cfset VarNietoTipo3 = 1 + VarNietoTipo3>
				</cfif>
		</cfif>
	</cfloop>
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "No esta completa la informacion de todos los comprobantes.|")>
</cfif>

	<!--- PROCESO DE SELLADO --->
<cfif isdefined("Form.chk_selloDig") AND #Form.key_selloDig# NEQ "">
	<cfset varCadenaOriginal = "||#CadenaOriginalRepAuxFol#|#CadenaOriginalDetAuxFol#|#CadenaOriginalComprNal#|#CadenaOriginalComprNalOtr#|#CadenaOriginalComprExt#||">
	<!--- <cf_dump var="#varCadenaOriginal#"> --->
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="GeneraSelloDigital" returnvariable="vSello">
		<cfinvokeargument name="cadenaOriginal"   value="#varCadenaOriginal#">
		<cfinvokeargument name="archivoKey"   value="#Form.key_selloDig#">
		<cfinvokeargument name="clave"   value="#Form.psw_selloDig#">
	</cfinvoke>
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="ObtenerCertificado" returnvariable="vCertificado">
		<cfinvokeargument name="archivoCer"   value="#Form.cer_selloDig#">
	</cfinvoke>
	<!--- SELLO Opcional --->
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["Sello"] = "#vSello#">
	<!--- NUM. CERTIFICADO Opcional --->
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["noCertificado"] = "#vCertificado.getSerialNumber()#">
	<!--- CERTIFICADO Opcional --->
	<cfset xmlRepAuxFol.xmlRoot.XmlAttributes["Certificado"] = "#vCertificado.getCertificado()#">
</cfif>


<!--- validacion para ver si se lanza o no el xml a pantalla(se toman en cuenta los errores) --->
<cfif listLen(listErrores) EQ 0>
<!--- 	<cfsetting enablecfoutputonly="yes">
	<cfprocessingdirective suppresswhitespace="Yes">
	<cfcontent type="application/xml">
	<cfheader name="Content-Disposition" value="attachment; filename=#rsRfc.Eidentificacion##periodo##mes#XF.xml">
	<cfoutput>#xmlRepAuxFol#</cfoutput>
	</cfprocessingdirective> --->

	<!--- MANEJO DE XML A ZIP --->
	<cfset strPath = ExpandPath( "./" ) />
	<cfset strFileName = "#rsRfc.Eidentificacion##periodo##mes#XF.xml"/>
	<cfset strFileNameZip = "#rsRfc.Eidentificacion##periodo##mes#XF.zip"/>

	<cfset XMLText=ToString(xmlRepAuxFol)>
	<!--- guarda xml temporal --->
	<cffile action="write" file="#strPath##strFileName#" output="#XMLText#">

	<!--- crea el zip y lo guarda temporal --->
	<cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>

	<!--- VALIDACION DE XML VS XSD --->
	<!--- <cfset
	myResults=XMLValidate("#strPath##strFileName#",
	"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios/AuxiliarFolios_1_2.xsd")>
	<cf_dump var="#myResults#"> --->

	<!--- ELIMINACION DE ARCHIVO xml--->
	<cfif FileExists("#strPath##strFileName#")>
		<cffile action = "delete" file = "#strPath##strFileName#">
	</cfif>

   	<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
	<cfheader name="Content-Disposition" value="inline; filename=#strFileNameZip#">
	<cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">
	<cfelse>
		<script language="javascript" type="text/javascript">
			var strError = "";
			var cont = 1;
			var w = window.open('', 'Errores', "left=250,top=85,width=800,height=550,status=no,directories=no,menubar=no,toolbar=no,scrollbars=yes,location=no,resizable=no,titlebar=no");
			w.document.write('<title>Errores encontrados</title>')
			w.document.write('<br><br>')
			w.document.write('<div style=\"font-family: Arial, Helvetica, sans-serif;\">')
			w.document.write('<table align=\"center\" width=\"80%\" border=\"0\" cellpadding=\"0\" cellspacing=\"2\">');
			w.document.write('<tr><td>');
			w.document.write('<strong>Se han presentado los siguientes errores en la generacion del XML Auxiliar de folios: </strong>');
			w.document.write('</td></tr>');
			<cfloop list="#listErrores#" index="i" delimiters = "|">
			<cfoutput>strError = "#i#"</cfoutput>
			if(strError != ""){
				w.document.write('<tr><td style=\"font-size:14;\">');
				if(strError.charAt(0) == ","){
					strError = strError.substring(1)
				}
				w.document.write(cont + ".- " + strError);
				w.document.write('</td></tr>');
				cont = 1 + cont;
			}
			</cfloop>
			w.document.write('<tr><td>&nbsp;</td></tr>')
			w.document.write('<tr><td align=\"center\"><input type=\"button\" value=\"Aceptar\" onclick=\"javascript:window.close()\"></td></tr>')
			w.document.write('</table>');
			w.document.write('</div>')
			w.document.close();
			window.location = '/cfmx/sif/ce/consultas/listaConsultaPolizas.cfm?ret=yes&Tipo=1&' + '<cfoutput>#navegacion#</cfoutput>';
		</script>
</cfif>
