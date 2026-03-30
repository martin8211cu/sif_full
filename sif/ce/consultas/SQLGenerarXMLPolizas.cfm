<cfset validaMapeo = createobject("component","sif.ce.Componentes.ValidacionMapeo")>

<cfsetting requestTimeOut = "3600">
<cfif isdefined('url.tipoSolicitud') and len(trim(url.tipoSolicitud)) GT 0>
	<cfset tipoSolicitud = #url.tipoSolicitud#>
</cfif>
<cfif isdefined('url.tipoSolicitud') and len(trim(url.tipoSolicitud)) GT 0>
	<cfset tipoSolicitud = #url.tipoSolicitud#>
</cfif>
<cfif isdefined('url.numOrden') and len(trim(url.numOrden)) GT 0>
	<cfset numOrden = #url.numOrden#>
</cfif>
<cfif isdefined('url.numTramite') and len(trim(url.numTramite)) GT 0>
	<cfset numTramite = #url.numTramite#>
</cfif>
<cfif isdefined('url.periodo') and len(trim(url.periodo)) GT 0>
	<cfset periodo = #url.periodo#>
<cfelse>
	<cfset periodo = #form.periodo#>
</cfif>
<cfif isdefined('url.mes') and len(trim(url.mes)) GT 0>
	<cfset mes = #url.mes#>
<cfelse>
	<cfset mes = #form.mes#>
</cfif>
<cfif isdefined('url.chk') and len(trim(url.chk)) GT 0>
	<cfset form.chk = #url.chk#>
</cfif>
<cfif isdefined('url.lote') and len(trim(url.lote)) GT 0>
	<cfset form.lote = #url.lote#>
</cfif>
<cfif isdefined('url.poliza') and len(trim(url.poliza)) GT 0>
	<cfset form.poliza = #url.poliza#>
</cfif>
<cfif isdefined('url.moneda') and len(trim(url.moneda)) GT 0>
	<cfset form.Moneda = #url.moneda#>
</cfif>
<cfif isdefined('url.documento') and len(trim(url.documento)) GT 0>
	<cfset form.Documento = #url.documento#>
</cfif>
<cfif isdefined('url.Referencia') and len(trim(url.Referencia)) GT 0>
	<cfset form.Referencia = #url.Referencia#>
</cfif>
<cfif isdefined('url.fechaGenIni') and len(trim(url.fechaGenIni)) GT 0>
	<cfset form.fechaIni = #url.fechaGenIni#>
</cfif>
<cfif isdefined('url.fechaGenFin') and len(trim(url.fechaGenFin)) GT 0>
	<cfset form.fechaFin = #url.fechaGenFin#>
</cfif>
<cfquery name="rfc" datasource="#Session.DSN#">
	SELECT replace(Eidentificacion,'-','') Eidentificacion FROM Empresa WHERE Ereferencia = #Session.Ecodigo#
</cfquery>
<cfquery name="rsPolizas" datasource="#session.DSN#">
	select
		he.IDcontable,
		case co.TipoSAT
			when 'I' then 1
			when 'E' then 2
			when 'D' then 3
		end as tipo, (CONVERT(varchar(5),co.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)) as num, he.ECfechaaplica, he.Edescripcion,
		hd.Dlinea, hd.Ccuenta, hd.Ddescripcion, hd.Dmovimiento, hd.Doriginal, hd.Miso4217,hd.Dtipocambio,hd.CFformato, hd.CFdescripcion
	from HEContables he
	inner join ConceptoContableE co on he.Cconcepto = co.Cconcepto and he.Ecodigo = co.Ecodigo
	inner join (select hd1.IDcontable, hd1.Dlinea, hd1.Ccuenta, hd1.Ddescripcion, hd1.Dmovimiento,
					hd1.Doriginal, mo.Miso4217,hd1.Dtipocambio,cf.CFformato,hd1.Mcodigo, cf.CFdescripcion
				from HDContables hd1
				inner join CFinanciera cf
					on hd1.CFcuenta = cf.CFcuenta
					and hd1.Ecodigo = hd1.Ecodigo
				inner join Monedas mo
					on hd1.Mcodigo = mo.Mcodigo
					and hd1.Ecodigo = mo.Ecodigo
	) hd
		on hd.IDcontable = he.IDcontable
	where he.Eperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
		and he.Emes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
		and he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	<cfif isdefined("form.chk")>
		and he.IDcontable in (#form.chk#)
	<cfelse>
		<cfif isdefined("form.lote") and Len(Trim(form.lote)) and trim(form.lote) NEQ -1>
             AND he.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.lote)#">
         </cfif>
         <cfif isdefined("form.poliza") and Len(Trim(form.poliza)) and trim(form.poliza) NEQ -1>
             AND he.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.poliza)#">
         </cfif>
         <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
             AND hd.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Moneda)#">
         </cfif>
         <cfif isdefined("form.Documento") and Len(Trim(form.Documento))>
             AND UPPER(he.Edocbase) LIKE UPPER('%#form.Documento#%')
         </cfif>
         <cfif isdefined("form.Referencia") and Len(Trim(form.Referencia))>
             AND UPPER(he.Ereferencia) like '%#UCASE(form.Referencia)#%'
         </cfif>
         <cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) GT 0 and LSisdate(listgetat(form.fechaIni, 1))>
             AND <cf_dbfunction name="to_date00" args="he.ECfechacreacion"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
         </cfif>
         <cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) GT 0 and LSisdate(listgetat(form.fechaFin, 1))>
             AND <cf_dbfunction name="to_date00" args="he.ECfechacreacion"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
         </cfif>
	</cfif>
	order by (CONVERT(varchar(5),co.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento))
</cfquery>

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

<cfset CadenaOriginalE = "">

<cfset LobjRepo = createObject( "component","sif.ce.Componentes.RepositorioCFDIs")>
<cfset xmlPolizas = XmlNew()>
<cfset xmlPolizas.XmlRoot = XmlElemNew(xmlPolizas,"PLZ:Polizas")>
<cfset xmlPolizas.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance">
<cfset xmlPolizas.xmlRoot.XmlAttributes["xsi:schemaLocation"] ="www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo/PolizasPeriodo_1_3.xsd">
<cfset xmlPolizas.xmlRoot.XmlAttributes["xmlns:PLZ"] ="www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo">
<cfset xmlPolizas.xmlRoot.XmlAttributes["Version"] = "1.3" >
<cfset xmlPolizas.xmlRoot.XmlAttributes["RFC"] = "#replace(rfc.Eidentificacion,'-','','all')#" >
<cfset xmlPolizas.xmlRoot.XmlAttributes["Mes"] = "#mes#" >
<cfset xmlPolizas.xmlRoot.XmlAttributes["Anio"] = "#periodo#" >
<cfset xmlPolizas.xmlRoot.XmlAttributes["TipoSolicitud"] = "#tipoSolicitud#" >
<cfset vnumOrden = "">
<cfif isdefined('numOrden') and len(trim(numOrden)) GT 0 and numOrden NEQ 'null'>
	<cfset xmlPolizas.xmlRoot.XmlAttributes["NumOrden"] = "#numOrden#" >
	<cfset vnumOrden = "|#numOrden#">
</cfif>
	<cfset vnumTramite = "">
<cfif isdefined('numTramite') and len(trim(numTramite)) GT 0 and numTramite NEQ 'null'>
	<cfset xmlPolizas.xmlRoot.XmlAttributes["NumTramite"] = "#numTramite#" >
	<cfset vnumTramite = "|#numTramite#">
</cfif>
<!---Se obtiene la informacion para crear al nodo de Polizas --->
<cfquery dbtype="query" name="rsPolizasAgrup">
    	select IDcontable, num, ECfechaaplica, Edescripcion
        from rsPolizas
        group by IDcontable,num,ECfechaaplica,Edescripcion
    </cfquery>
<cfset VarPoliza = 0>
<cfif isdefined("Form.chk_selloDig")>
	<cfset CadenaOriginalE = "1.1|#rfc.Eidentificacion#|#mes#|#periodo#|#tipoSolicitud##vnumOrden##vnumTramite#">
</cfif>
<cfset CadenaOriginalD = "">
<!---Se inicia a agregar los atributos del nodo de Polizas--->
<cfloop query="rsPolizasAgrup">
	<cfset VarPoliza = VarPoliza + 1>
	<cfset xmlPolizas.Polizas.XmlChildren[VarPoliza] = XmlElemNew(xmlPolizas,"PLZ:Poliza")>
	<cfset xmlPolizas.Polizas.XmlChildren[VarPoliza].XmlAttributes["NumUnIdenPol"] = "#rsPolizasAgrup.num#" >
	<cfset xmlPolizas.Polizas.XmlChildren[VarPoliza].XmlAttributes["Fecha"] = "#DateFormat(rsPolizasAgrup.ECfechaaplica,"yyyy-mm-dd")#" >
	<cfset xmlPolizas.Polizas.XmlChildren[VarPoliza].XmlAttributes["Concepto"] = "#XMLFormat(validaMapeo.CleanHighAscii(rsPolizasAgrup.Edescripcion))#" >

	<cfif isdefined("Form.chk_selloDig")>
		<cfset CadenaOriginalD = "#rsPolizasAgrup.num#|#DateFormat(rsPolizasAgrup.ECfechaaplica,'yyyy-mm-dd')#|#XMLFormat(validaMapeo.CleanHighAscii(rsPolizasAgrup.Edescripcion))#">
	</cfif>

	<!---Se obtiene la informacion para crear al nodo de Transacciones --->
	<cfquery dbtype="query" name="rsPolizasTrans">
        select IDcontable,tipo, num, ECfechaaplica, Edescripcion,
        Dlinea, Ccuenta, Ddescripcion, Dmovimiento, Doriginal, Miso4217,Dtipocambio,CFformato, CFdescripcion
        from rsPolizas
        where IDcontable = #rsPolizasAgrup.IDcontable#
    </cfquery>
	<cfset VarLinea = 1>
	<!---Se inicia a agregar los atributos del nodo de transacciones--->
	
	<cfloop query = "rsPolizasTrans">
		<cfif VarLinea LTE rsPolizasTrans.RecordCount>
			<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea] = XmlElemNew(xmlPolizas,"PLZ:Transaccion")>
			<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["NumCta"] = "#trim(rsPolizasTrans.CFformato)#" >
			<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["DesCta"] = "#XMLFormat(validaMapeo.CleanHighAscii(rsPolizasTrans.CFdescripcion))#" >
			<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["Concepto"] = "#XMLFormat(Trim(validaMapeo.CleanHighAscii(rsPolizasTrans.Ddescripcion)))#" >
			<cfif isdefined("Form.chk_selloDig")>
				<cfset CadenaOriginalD = "#CadenaOriginalD#|#trim(rsPolizasTrans.CFformato)#|#XMLFormat(Trim(validaMapeo.CleanHighAscii(rsPolizasTrans.Ddescripcion)))#">
			</cfif>
			<cfif trim(rsPolizasTrans.Dmovimiento) eq 'D'>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["Debe"] = "#NumberFormat(rsPolizasTrans.Doriginal, '9.99')#" >
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["Haber"] = "#NumberFormat(0, '9.99')#" >
				<cfif isdefined("Form.chk_selloDig")>
					<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsPolizasTrans.Doriginal#|0">
				</cfif>
			<cfelse>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["Debe"] = "#NumberFormat(0, '9.99')#" >
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].XmlChildren[VarLinea].XmlAttributes["Haber"] = "#NumberFormat(rsPolizasTrans.Doriginal, '9.99')#" >
				<cfif isdefined("Form.chk_selloDig")>
					<cfset CadenaOriginalD = "#CadenaOriginalD#|0|#rsPolizasTrans.Doriginal#">
				</cfif>
			</cfif>
        </cfif>
		<!---Se obtiene la informacion para crear al nodo de Comprobantes --->
		<cfquery name="rsComprobantes" datasource="#Session.DSN#">
			select IdRep,timbre,total,replace(rfc,'-','') rfc, coalesce(TipoComprobante,1) as TipoComprobante, coalesce(Miso4217,'MXP') as Miso4217, CONVERT(decimal(19,5), coalesce(TipoCambio,1.00000)) as TipoCambio, Serie, xmlTimbrado
			from CERepositorio
			where IdContable = #rsPolizasTrans.IDcontable# and linea = #rsPolizasTrans.Dlinea#
		</cfquery>

		<cfset VarComprobante = 0>
		<cfif #rsComprobantes.RecordCount# gt 0>
			
			<cfset axml = LobjRepo.getInfoXML(#rsComprobantes.IdRep#)>

			<!---Se inicia a agregar los atributos del nodo de CompNal, CompExt, CompNalOtr --->
			<cfloop query="rsComprobantes">
				<cfset VarComprobante = VarComprobante + 1>
				<cfif #rsComprobantes.TipoComprobante# EQ 1>
					<!---CompNal--->
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante] = XmlElemNew(xmlPolizas,"PLZ:CompNal")>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["UUID_CFDI"] = "#rsComprobantes.timbre#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["RFC"] = "#trim(axml.RFCemisor)#">
					<cfif Len(Trim(#rsComprobantes.total#))>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["MontoTotal"] = "#NumberFormat(rsComprobantes.total, '9.99')#">
					<cfelseif Len(Trim(axml.SubTotal)) gt 0 and Len(Trim(axml.Impuesto)) gt 0>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["MontoTotal"] = "#NumberFormat(axml.SubTotal+axml.Impuesto, '9.99')#">
					<cfelse>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["MontoTotal"] = "#NumberFormat(0, '9.99')#">
					</cfif>

					<cfif isdefined('rsComprobantes.Miso4217') and rsComprobantes.Miso4217 NEQ 'MXP'>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["Moneda"] = "#replace(rsComprobantes.Miso4217,'MXP','MXN','all')#">
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["TipCamb"] = "#NumberFormat(rsComprobantes.TipoCambio, '9.99')#">
					</cfif>
					<cfif isdefined("Form.chk_selloDig")>
						<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsComprobantes.timbre#">
					</cfif>
				<cfelseif #rsComprobantes.TipoComprobante# EQ 3>
					<!---CompNalOtr--->
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante] = XmlElemNew(xmlPolizas,"PLZ:CompNalOtr")>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["CFD_CBB_Serie"] = "#rsComprobantes.Serie#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["CFD_CBB_NumFol"] = "#rsComprobantes.timbre#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["RFC"] = "#trim(rsComprobantes.rfc)#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["MontoTotal"] = "#NumberFormat(rsComprobantes.total, '9.99')#">
					<cfif isdefined('rsComprobantes.Miso4217') and rsComprobantes.Miso4217 NEQ 'MXP'>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["Moneda"] = "#rsComprobantes.Miso4217#">
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["TipCamb"] = "#NumberFormat(rsComprobantes.TipoCambio, '9.99')#">
					</cfif>
					<cfif isdefined("Form.chk_selloDig")>
						<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsComprobantes.Serie#|#rsComprobantes.timbre#">
					</cfif>
					<cfelse> <!---CompExt--->
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante] = XmlElemNew(xmlPolizas,"PLZ:CompExt")>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["NumFactExt"] = "#rsComprobantes.timbre#">
					<cfif isdefined('rsComprobantes.rfc') and len(trim(rsComprobantes.rfc)) GT 0>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["TaxID"] = "#trim(rsComprobantes.rfc)#">
					</cfif>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["MontoTotal"] = "#NumberFormat(rsComprobantes.total, '9.99')#">
					<cfif isdefined('rsComprobantes.Miso4217') and rsComprobantes.Miso4217 NEQ 'MXP'>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["Moneda"] = "#rsComprobantes.Miso4217#">
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarComprobante].XmlAttributes["TipCamb"] = "#NumberFormat(rsComprobantes.TipoCambio, '9.99')#">
					</cfif>
					<cfif isdefined("Form.chk_selloDig")>
						<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsComprobantes.timbre#">
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<!---Se obtiene la informacion para crear al nodo de Cheques --->
		<cfquery name="rsCheque" datasource="#Session.DSN#">
			SELECT TESTMPtipo, IBSATdocumento, c.ClaveSAT, CBcodigo,
				CONVERT(char(10), TESOPfechaPago,126) as TESOPfechaPago, TESOPtotalPago, IBSATbeneficiario, IBSATRFC,
				IBSAClaveSATtran, IBSATctadestinotran,
				CASE WHEN m.Miso4217 = 'MXP' THEN 0
				ELSE m.Miso4217
				END as Miso4217,
				CONVERT(decimal(19,5), coalesce(Dtipocambio,1.00000)) as Dtipocambio
			FROM (
				select IDcontable,TESTMPtipo,IBSATdocumento,ClaveSAT,CBcodigo,
					TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
					IBSAClaveSATtran,IBSATctadestinotran,max(Dlinea) Dlinea, PagoTercero
				from  CEInfoBancariaSAT
				group by IDcontable,TESTMPtipo,IBSATdocumento,ClaveSAT,CBcodigo,
						TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
						IBSAClaveSATtran,IBSATctadestinotran, PagoTercero
			) c
			INNER JOIN HDContables h ON h.IDcontable = c.IDcontable and h.Dlinea = c.Dlinea
			INNER JOIN Monedas m ON m.Mcodigo = h.Mcodigo and h.Ecodigo = m.Ecodigo
			<!--- INNER JOIN CContables cc ON cc.Ccuenta = h.Ccuenta and cc.Mcodigo = m.Mcodigo --->
			WHERE c.IDcontable = #rsPolizasTrans.IDcontable# and c.Dlinea = #rsPolizasTrans.Dlinea# and TESTMPtipo = 'CHK'
				AND h.Ecodigo = #session.Ecodigo# AND c.PagoTercero = 0
		</cfquery>
		<!--- <cf_dump var="#rsCheque#"> --->
		<cfset VarCheque = VarComprobante>
		<cfif #rsCheque.RecordCount# gt 0>
			<!---Se inicia a agregar los atributos del nodo de Cheques --->
			<cfloop query="rsCheque">
				<cfset VarCheque = VarCheque + 1>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque] = XmlElemNew(xmlPolizas,"PLZ:Cheque")>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["Num"] = "#rsCheque.IBSATdocumento#">
				<cfif isdefined('rsCheque.Miso4217') and rsCheque.Miso4217 EQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["BanEmisNal"] = "#rsCheque.ClaveSAT#">
				</cfif>
				<cfif isdefined('rsCheque.Miso4217') and rsCheque.Miso4217 NEQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["BanEmisExt"] = "#rsCheque.ClaveSAT#">
				</cfif>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["CtaOri"] = "#rsCheque.CBcodigo#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["Fecha"] = "#rsCheque.TESOPfechaPago#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["Benef"] = "#XMLFormat(validaMapeo.CleanHighAscii(rsCheque.IBSATbeneficiario))#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["RFC"] = "#trim(rsCheque.IBSATRFC)#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["Monto"] = "#NumberFormat(rsCheque.TESOPtotalPago, '9.99')#">
				<cfif isdefined('rsCheque.Miso4217') and rsCheque.Miso4217 NEQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["Moneda"] = "#rsCheque.Miso4217#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarCheque].XmlAttributes["TipCamb"] = "#NumberFormat(rsCheque.Dtipocambio, '9.99')#">
				</cfif>
				<cfif isdefined("Form.chk_selloDig")>
					<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsCheque.IBSATdocumento##vBanEmisNal##vBanEmisExt#|#rsCheque.CBcodigo#|#rsCheque.TESOPfechaPago#|#rsCheque.IBSATbeneficiario#|#trim(rsCheque.IBSATRFC)#|#rsCheque.TESOPtotalPago##vMon#">
				</cfif>
			</cfloop>
		</cfif>
		<!---Se obtiene la informacion para crear al nodo de Transferencia --->
		<cfquery name="rsTransferencia" datasource="#Session.DSN#">
			select TESTMPtipo, IBSATdocumento, c.ClaveSAT, CBcodigo,
				CONVERT(char(10), TESOPfechaPago,126) as TESOPfechaPago, TESOPtotalPago,
				IBSATbeneficiario, replace(IBSATRFC,'-','') IBSATRFC, IBSAClaveSATtran,
				IBSATctadestinotran,
				CASE WHEN m.Miso4217 = 'MXP' THEN 0
				ELSE m.Miso4217
				END as Miso4217,
				CONVERT(decimal(19,5), coalesce(Dtipocambio,1.00000)) as Dtipocambio
			from (
				select IDcontable,TESTMPtipo,IBSATdocumento,ClaveSAT,CBcodigo,
					TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
					IBSAClaveSATtran,IBSATctadestinotran,max(Dlinea) Dlinea, PagoTercero
				from  CEInfoBancariaSAT
				group by IDcontable,TESTMPtipo,IBSATdocumento,ClaveSAT,CBcodigo,
					TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,
					IBSAClaveSATtran,IBSATctadestinotran, PagoTercero) c
			INNER JOIN HDContables h ON h.IDcontable = c.IDcontable and h.Dlinea = c.Dlinea
			INNER JOIN Monedas m ON m.Mcodigo = h.Mcodigo and h.Ecodigo = m.Ecodigo
			<!--- INNER JOIN CContables cc ON cc.Ccuenta = h.Ccuenta and cc.Mcodigo = m.Mcodigo --->
			WHERE c.IDcontable = #rsPolizasTrans.IDcontable# and c.Dlinea = #rsPolizasTrans.Dlinea#
				and TESTMPtipo in ('TRM','TRE','TRI','TCE') AND c.PagoTercero = 0
		</cfquery>
		<!--- <cf_dump var="#rsTransferencia#"> --->
		<cfset VarTransf = VarCheque>
		<cfif #rsTransferencia.RecordCount# gt 0>
			<!---Se inicia a agregar los atributos del nodo de Cheques --->
			<cfloop query="rsTransferencia">
				<cfset VarTransf = VarTransf + 1>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf] = XmlElemNew(xmlPolizas,"PLZ:Transferencia")>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["CtaOri"] = "#rsTransferencia.CBcodigo#">
				<cfif isdefined('rsTransferencia.Miso4217') and rsTransferencia.Miso4217 EQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["BancoOriNal"] = "#rsTransferencia.ClaveSAT#">
				</cfif>
				<cfif isdefined('rsTransferencia.Miso4217') and rsTransferencia.Miso4217 NEQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["BancoOriExt"] = "#rsTransferencia.ClaveSAT#">
				</cfif>
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["CtaDest"] = "#rsTransferencia.IBSATctadestinotran#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["BancoDestNal"] = "#rsTransferencia.IBSAClaveSATtran#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["BancoDestExt"] = "">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["Fecha"] = "#rsTransferencia.TESOPfechaPago#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["Benef"] = "#XMLFormat(validaMapeo.CleanHighAscii(rsTransferencia.IBSATbeneficiario))#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["RFC"] = "#trim(rsTransferencia.IBSATRFC)#">
				<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["Monto"] = "#NumberFormat(rsTransferencia.TESOPtotalPago, '9.99')#">
				<cfif isdefined('rsTransferencia.Miso4217') and rsTransferencia.Miso4217 NEQ "0">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["Moneda"] = "#rsTransferencia.Miso4217#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarTransf].XmlAttributes["TipCamb"] = "#NumberFormat(rsTransferencia.Dtipocambio, '9.99')#">
				</cfif>
			</cfloop>
		</cfif>
		<!--- Inicia la creacion del nodo OtrMetodoPago --->
		<!--- MetPagoPol Fecha Benef RFC Monto Moneda TipCamb --->
		<cfquery name="rsOtrMetodoPago" datasource="#Session.DSN#">
			SELECT CONVERT(char(10), TESOPfechaPago,126) AS Fecha,
			       IBSATbeneficiario AS Benef,
			       IBSATRFC AS RFC,
			       TESOPtotalPago as Monto,
				   REPLACE(ISNULL(m.Miso4217, 'MXN'), 'MXP', 'MXN') Moneda,
				   CONVERT(decimal(19,5), coalesce(Dtipocambio,1.00000)) as TipCamb,
				   PagoTercero,TESTMPtipo
			FROM (SELECT IDcontable,
			             TESOPfechaPago,
			             IBSATbeneficiario,
			             IBSATRFC,
			             TESOPtotalPago,
			             max(Dlinea) Dlinea,
			             PagoTercero,TESTMPtipo
			      FROM CEInfoBancariaSAT
			      GROUP BY IDcontable,
			               TESOPfechaPago,
			               IBSATbeneficiario,
			               IBSATRFC,
			               TESOPtotalPago,
			               PagoTercero,TESTMPtipo) c
			           INNER JOIN HDContables h ON h.IDcontable = c.IDcontable and h.Dlinea = c.Dlinea
					   INNER JOIN Monedas m ON m.Mcodigo = h.Mcodigo and h.Ecodigo = m.Ecodigo
					   INNER JOIN CContables cc ON cc.Ccuenta = h.Ccuenta and cc.Ecodigo = m.Ecodigo
			WHERE c.IDcontable = #rsPolizasTrans.IDcontable#
			 AND c.Dlinea = #rsPolizasTrans.Dlinea#
			 AND h.Ecodigo = #session.Ecodigo#
			 AND (c.PagoTercero = 1 or TESTMPtipo = 'PT' or TESTMPtipo is null)
		</cfquery>

		<cfset VarOtrMetodoPago = VarComprobante>
		<cfif #rsOtrMetodoPago.RecordCount# gt 0>
			<cfquery name="rsGetMetPagoSAT" datasource="#Session.DSN#">
				SELECT TESTMPMtdoPago
				FROM TEStipoMedioPago
				WHERE TESTMPcodigo = 'PT'
			</cfquery>
			<cfif #rsGetMetPagoSAT.RecordCount# gt 0 AND Len(Trim(rsGetMetPagoSAT.TESTMPMtdoPago))>
				<cfloop query="rsOtrMetodoPago">
					<cfset VarOtrMetodoPago = VarOtrMetodoPago + 1>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago] = XmlElemNew(xmlPolizas,"PLZ:OtrMetodoPago")>
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["MetPagoPol"] = "#rsGetMetPagoSAT.TESTMPMtdoPago#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["Fecha"] = "#rsOtrMetodoPago.Fecha#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["Benef"] = "#XMLFormat(validaMapeo.CleanHighAscii(rsOtrMetodoPago.Benef))#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["RFC"] = "#rsOtrMetodoPago.RFC#">
					<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["Monto"] = "#NumberFormat(rsOtrMetodoPago.Monto, '9.99')#">
					<cfif rsOtrMetodoPago.Moneda NEQ "MXN" AND Len(Trim(rsOtrMetodoPago.Moneda))>
						<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["Moneda"] = "#rsOtrMetodoPago.Moneda#">
						<cfif Len(Trim(rsOtrMetodoPago.TipCamb))>
							<cfset xmlPolizas.Polizas.Poliza[VarPoliza].Transaccion[VarLinea].XmlChildren[VarOtrMetodoPago].XmlAttributes["TipCamb"] = "#NumberFormat(rsOtrMetodoPago.TipCamb, '9.99')#">
						</cfif>
					<cfelse>
						<cf_errorCode code = "80017" msg = "No existe la asignacion del Metodo de pago. Verifique en Asignaci�n de M�todo de Pago">
					</cfif>
					<cfif isdefined("Form.chk_selloDig")>
						<cfset CadenaOriginalD = "#CadenaOriginalD#|#rsTransferencia.CBcodigo##vBanEmisNal##vBanEmisExt#|#rsTransferencia.IBSATctadestinotran#|#rsTransferencia.IBSAClaveSATtran#|#rsTransferencia.TESOPfechaPago#|#rsTransferencia.IBSATbeneficiario#|#trim(rsTransferencia.IBSATRFC)#|##rsTransferencia.TESOPtotalPago###vMon#">
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<!--- Finaliza la creacion del nodo OtrMetodoPago --->
		<!--- <cf_dump var="#rsGetMetPagoSAT#"> --->
		<cfset VarLinea = VarLinea + 1>
	</cfloop>
	<!--- <cf_dump var="STOP"> --->
</cfloop>
	<cfif isdefined("Form.chk_selloDig")>
		<cfset cadenaR = "#CadenaOriginalE#|#CadenaOriginalD#">

		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="GeneraSelloDigital" returnvariable="vSello">
			<cfinvokeargument name="cadenaOriginal"   value="||#XmlFormat(validaMapeo.CleanHighAscii(cadenaR))#||">
		    <cfinvokeargument name="archivoKey"   value="#Form.key_selloDig#">
		    <cfinvokeargument name="clave"   value="#Form.psw_selloDig#">
		</cfinvoke>

		<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="ObtenerCertificado" returnvariable="vCertificado">
			<cfinvokeargument name="archivoCer"   value="#Form.cer_selloDig#">
		</cfinvoke>

		<cfset xmlPolizas.xmlRoot.XmlAttributes["Sello"] = "#vSello#">
		<cfset xmlPolizas.xmlRoot.XmlAttributes["noCertificado"] = "#vCertificado.getSerialNumber()#">
		<cfset xmlPolizas.xmlRoot.XmlAttributes["Certificado"] = "#vCertificado.getCertificado()#">
	</cfif>

<!--- MANEJO DE XML A ZIP --->
<cfset strPath = ExpandPath( "./" ) />
<cfset strFileName = "#rfc.Eidentificacion##periodo##mes#PL.xml"/>
<cfset strFileNameZip = "#rfc.Eidentificacion##periodo##mes#PL.zip"/>
<cfset XMLText=ToString(xmlPolizas)>
<!---guarda xml temporal --->
<cffile action="write" file="#strPath##strFileName#" output="#xmlPolizas#">
<!---crea el zip y lo guarda temporal --->
<cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>
<!--- ELIMINACION DE ARCHIVO xml--->
<cfif FileExists("#strPath##strFileName#")>
	<cffile action = "delete" file = "#strPath##strFileName#">
</cfif>
<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
<cfheader name="Content-Disposition" value="inline; filename=#strFileNameZip#">
<cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">
<cfquery name="rsVal" datasource="#Session.DSN#">
	select Id_Poliza from CEPoliza where Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">
	and Mes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mes#">
</cfquery>
<cfif #rsVal.RecordCount# eq 0>
	<cfquery name="rs" datasource="#Session.DSN#">
		insert into CEPoliza(Periodo,Mes) values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#periodo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#mes#">)
	</cfquery>
</cfif>
