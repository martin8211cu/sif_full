<cfset validaMapeo = createobject("component","sif.ce.Componentes.ValidacionMapeo")>

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
<cfif isDefined("url.ctainicial")>
	<cfset form.ctainicial = "#url.ctainicial#">
	<cfset navegacion = navegacion & "&ctainicial=#url.ctainicial#">
</cfif>
<cfif isDefined("url.ctafinal")>
	<cfset form.ctafinal = "#url.ctafinal#">
	<cfset navegacion = navegacion & "&ctafinal=#url.ctafinal#">
</cfif>
<cfif isDefined("url.sinsaldoscero")>
	<cfset form.sinsaldoscero = "on">
	<cfset navegacion = navegacion & "&sinsaldoscero=on">
</cfif>
<cfif isDefined("url.fechaIni")>
	<cfset form.fechaIni = "#url.fechaIni#">
	<cfset navegacion = navegacion & "&fechaIni=#url.fechaIni#">
</cfif>
<cfif isDefined("url.fechaFin")>
	<cfset form.fechaFin = "#url.fechaFin#">
	<cfset navegacion = navegacion & "&fechaFin=#url.fechaFin#">
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

<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset lvarValorN = "">
<cfset lvarValorS = "">
<cfif #nivel.Pvalor# neq '-1'>
	<cfset lvarValorN = "AND (select PCDCniv from PCDCatalogoCuenta where Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv ) <= #nivel.Pvalor -1#">
	<cfelse>
	<cfset lvarValorS = "and cc.Cmovimiento = 'S'">
</cfif>

<cfquery name="rsEncabezado" datasource="#session.DSN#">
    SELECT cc.Ccuenta,
	       cc.Cformato as cuenta,
	       (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)) as NumUnIdenPol,
	       CONVERT(VARCHAR(10),he.Efecha,126) as Fecha,
	       cc.Cdescripcion as DescCuenta,
	       det.SLinicial as saldoInicial,
	       (det.SLinicial + det.DLdebitos - det.CLcreditos) as saldoFinal,
	       det.CEBperiodo,
	       det.CEBmes,
	       he.ECfechacreacion,
	       cce.Cdescripcion,
	       hd.IDcontable,
	       he.Cconcepto,
	       isnull(C,0) as Debe,
	       isnull(D,0) as Haber
	FROM CContables cc,
	     CEBalanzaSAT ba,
	     CEBalanzaDetSAT det,
	     HEContables he,
	     HDContables hd,
	     ConceptoContableE cce,
	     (SELECT Ccuenta,IDcontable,[C], [D]
		  FROM (select Ccuenta,IDcontable,Dmovimiento,isnull(Dlocal,0)Dlocal
		  FROM HDContables
		 ) AS SourceTable
		 PIVOT
		 (
		 SUM(Dlocal)
		 FOR Dmovimiento IN ([C], [D])
		 ) AS PivotTable
		) saldo
	WHERE cc.Ccuenta = det.Ccuenta
	  AND cc.Ccuenta = hd.Ccuenta
	  AND hd.IDcontable = he.IDcontable
	  AND det.CEBalanzaId = ba.CEBalanzaId
	  AND cce.Cconcepto = hd.Cconcepto
	  AND saldo.Ccuenta = cc.Ccuenta
	  AND saldo.IDcontable = hd.IDcontable
	  AND ba.CEBperiodo = det.CEBperiodo
	  AND ba.CEBmes = det.CEBmes
	  AND ba.CEBperiodo = he.Eperiodo
	  AND ba.CEBmes = he.Emes
	  AND ba.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Anio#">
	  AND ba.CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
	  and ba.GEid = -1
	<cfif isDefined("form.ctainicial") AND #form.ctainicial# NEQ "">
		AND cc.Cmayor >= <cfqueryparam value="#Trim(form.ctainicial)#" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif isDefined("form.ctafinal") AND #form.ctafinal# NEQ "">
	  	AND cc.Cmayor <= <cfqueryparam value="#Trim(form.ctafinal)#" cfsqltype="cf_sql_varchar">
	</cfif>
	<cfif isDefined("form.sinsaldoscero") AND #form.sinsaldoscero# EQ "on">
	  	AND det.SLinicial != 0 AND (det.SLinicial + det.DLdebitos - det.CLcreditos) != 0
	</cfif>
	<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
	  	AND he.ECfechacreacion >= <cfqueryparam value="#form.fechaIni#" cfsqltype="cf_sql_date">
	</cfif>
	<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
	  	AND he.ECfechacreacion <= <cfqueryparam value="#form.fechaFin#" cfsqltype="cf_sql_date">
	</cfif>
	GROUP BY cc.Ccuenta,
	         cc.Cformato,
	         (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)),
	         CONVERT(VARCHAR(10),he.Efecha,126),
	         cc.Cdescripcion,
	         det.SLinicial,
	         (det.SLinicial + det.DLdebitos - det.CLcreditos),
	         det.CEBperiodo,
	         det.CEBmes,
	         he.ECfechacreacion,
	         cce.Cdescripcion,
	         hd.IDcontable,
	         he.Cconcepto,
	         saldo.C,
	         saldo.D
	ORDER BY cc.Ccuenta
</cfquery>
<!--- <cf_dump var="#rsEncabezado#"> --->


<!--- VARIABLES PARA GUARDAR VALOR DE CADENA ORIGINAL POR NODOS --->
<cfset CadenaOriginalAuxiliarCtas = "">
<cfset CadenaOriginalCuenta = "">
<cfset CadenaOriginalDetalleAux = "">

<!--- CREACION DE XML AUXILIAR DE CUENTAS / SUBCUENTAS --->
<cfset xmlAuxiliarCtas = XmlNew()>

<!--- creacion del tag padre --->
<cfset xmlAuxiliarCtas.XMLRoot = XMLElemNew(xmlAuxiliarCtas,"AuxiliarCtas")>

<!--- se agregan atributos al padre --->

<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance">

<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["xsi:schemaLocation"]="www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas/AuxiliarCtas_1_3.xsd">

<cfset xmlAuxiliarCtas.XMLRoot.XmlAttributes["xmlns"]="www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas">


<!--- VERSION requerido--->
<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Version"] = "1.3">
<cfset CadenaOriginalAuxiliarCtas = "1.3">

<!--- RFC requerido--->
<cfif rsRfc.recordCount GTE 1>
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["RFC"] = "#rsRfc.Eidentificacion#">
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#rsRfc.Eidentificacion#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El RFC es requerido. A nivel raiz.|")>
</cfif>

<!--- MES requerido--->
<cfif #mes# NEQ "-1">
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Mes"] = "#mes#">
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#mes#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El mes es requerido. A nivel raiz.|")>
</cfif>

<!--- ANIO requerido--->
<cfif #anio# NEQ "-1">
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Anio"] = #anio#>
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#anio#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El Periodo es requerido. A nivel raiz.|")>
</cfif>

									<!--- DATOS SOLICITADOS PARA EL USUARIO --->
<!--- TIPO DE SOLICITUD requerido--->
<cfif isdefined("tipoSolicitud") and Len(Trim(#tipoSolicitud#))>
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["TipoSolicitud"] = #tipoSolicitud#>
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#tipoSolicitud#">
	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "El Tipo de solicitud es requerido. A nivel raiz.|")>
</cfif>

<!--- ESTA VALIDACION SE REALIZA DESDE EL POPUP CON JAVASCRIPT --->
<!--- NUMORDEN Opcional, requerido si el tipo de solicitud es: AF o FC--->
<cfif isdefined("numOrden") and Len(Trim(#numOrden#))>
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["NumOrden"] = #numOrden#>
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#numOrden#">
</cfif>

<!--- NumTramite Opcional requerido si el tipo de solicitud es: DE o CO--->
<cfif isdefined("numTramite") and Len(Trim(#numTramite#))>
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["NumTramite"] = #numTramite#>
	<cfset CadenaOriginalAuxiliarCtas = CadenaOriginalAuxiliarCtas & "|#numTramite#">
</cfif>

<!--- FALTA PROCESO DE SELLADO --->
<!--- SELLO Opcional --->
<!--- <cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Sello"] = ""> --->
<!--- NUM. CERTIFICADO Opcional --->
<!--- <cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["noCertificado"] = ""> --->
<!--- CERTIFICADO Opcional --->
<!--- <cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Certificado"] = ""> --->


<!--- ITERACION DE CUENTAS --->
<cfif rsEncabezado.recordCount GTE 1>
	<cfset rsCcuenta = "">
	<cfset VarPosition = 0>
	<cfset VarNieto = 1>
	<cfloop query="rsEncabezado">
		<cfif rsCcuenta NEQ rsEncabezado.Ccuenta>
			<cfset VarNieto = 1>
			<cfset VarPosition = 1 + VarPosition>
			    <!--- se crea hijo --->
				<cfset xmlAuxiliarCtas.AuxiliarCtas.XmlChildren[VarPosition] = XmlElemNew(xmlAuxiliarCtas,"Cuenta")>
				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.cuenta))>
					<cfset xmlAuxiliarCtas.AuxiliarCtas.XmlChildren[VarPosition].XmlAttributes["NumCta"] = "#Trim(rsEncabezado.cuenta)#">
					<cfif #CadenaOriginalCuenta# EQ "">
						<cfset CadenaOriginalCuenta = CadenaOriginalCuenta & "#Trim(rsEncabezado.cuenta)#">
						<cfelse>
							<cfset CadenaOriginalCuenta = CadenaOriginalCuenta & "|#Trim(rsEncabezado.cuenta)#">
					</cfif>
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El N&uacute;m. de cuenta es requerido.|")>
				</cfif>
				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.DescCuenta))>
					<cfset xmlAuxiliarCtas.AuxiliarCtas.XmlChildren[VarPosition].XmlAttributes["DesCta"] = "#Trim(rsEncabezado.DescCuenta)#">
						<cfset CadenaOriginalCuenta = CadenaOriginalCuenta & "|#Trim(rsEncabezado.DescCuenta)#">
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "La descripci&oacute;n es requerida, cuenta: #rsEncabezado.cuenta#.|")>
				</cfif>
				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.saldoInicial))>
					<cfset xmlAuxiliarCtas.AuxiliarCtas.XmlChildren[VarPosition].XmlAttributes["SaldoIni"] = "#Trim(numberFormat(rsEncabezado.saldoInicial,"0.00"))#">
					<cfset CadenaOriginalCuenta = CadenaOriginalCuenta & "|#Trim(numberFormat(rsEncabezado.saldoInicial,"0.00"))#">
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El saldo inicial es requerido, cuenta: #rsEncabezado.cuenta#.|")>
				</cfif>
				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.saldoFinal))>
					<cfset xmlAuxiliarCtas.AuxiliarCtas.XmlChildren[VarPosition].XmlAttributes["SaldoFin"] = "#Trim(numberFormat(rsEncabezado.saldoFinal,"0.00"))#">
					<cfset CadenaOriginalCuenta = CadenaOriginalCuenta & "|#Trim(numberFormat(rsEncabezado.saldoFinal,"0.00"))#">
					<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El saldo final es requerido, cuenta: #rsEncabezado.cuenta#.|")>
				</cfif>

				<!--- INICIO DETAUX PARA TIMBRADO --->
				<!--- a) Fecha b) NumUnIdenPol c) Debe d) Haber --->
				<cfif #CadenaOriginalDetalleAux# EQ "">
					<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "#rsEncabezado.Fecha#">
					<cfelse>
						<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#rsEncabezado.Fecha#">
				</cfif>
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#rsEncabezado.NumUnIdenPol#">
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#Trim(numberFormat(rsEncabezado.Debe,"0.00"))#">
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#Trim(numberFormat(rsEncabezado.Haber,"0.00"))#">
				<!--- FIN DETAUX PARA TIMBRADO --->
				<!--- PRIMER NIETO DetalleAux --->
				<cfset arrayappend(xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].XmlChildren, XmlElemNew(xmlAuxiliarCtas,"DetalleAux"))>

					<!--- se agregan atributos al nuevo nieto --->

					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Fecha))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[1].XmlAttributes["Fecha"]="#rsEncabezado.Fecha#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "La fecha es requerida, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.NumUnIdenPol))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[1].XmlAttributes["NumUnIdenPol"]="#rsEncabezado.NumUnIdenPol#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El n&uacute;mero de p&oacute;liza es requerido, cuenta: #rsEncabezado.cuenta#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Cdescripcion))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[1].XmlAttributes["Concepto"]="#Trim(XmlFormat(validaMapeo.CleanHighAscii(rsEncabezado.Cdescripcion)))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El concepto es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Debe))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[1].XmlAttributes["Debe"]="#Trim(numberFormat(rsEncabezado.Debe,"0.00"))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Debe es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Haber))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[1].XmlAttributes["Haber"]="#Trim(numberFormat(rsEncabezado.Haber,"0.00"))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Haber es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<cfset VarNieto = 2>
			<cfset rsCcuenta = rsEncabezado.Ccuenta>

			<cfelse>
				<!--- CUANDO SE TRATA DE LA MISMA POLIZA, ENTONCES SOLO CREA NIETOS --->
				<!--- INICIO DETAUX PARA TIMBRADO --->
				<!--- a) Fecha b) NumUnIdenPol c) Debe d) Haber --->
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#rsEncabezado.Fecha#">
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#rsEncabezado.NumUnIdenPol#">
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#Trim(numberFormat(rsEncabezado.Debe,"0.00"))#">
				<cfset CadenaOriginalDetalleAux = CadenaOriginalDetalleAux & "|#Trim(numberFormat(rsEncabezado.Haber,"0.00"))#">
				<!--- FIN DETAUX PARA TIMBRADO --->

				<cfset arrayappend(xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].XmlChildren, XmlElemNew(xmlAuxiliarCtas,"DetalleAux"))>

				<!--- se agregan atributos al nuevo nieto --->

				<!--- Requerido --->
				<cfif Len(Trim(rsEncabezado.Fecha))>
					<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[VarNieto].XmlAttributes["Fecha"]="#rsEncabezado.Fecha#">
					<cfelse>
					<cfset listErrores = ListAppend(listErrores, "La fecha es requerida, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
				</cfif>
				<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.NumUnIdenPol))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[VarNieto].XmlAttributes["NumUnIdenPol"]="#rsEncabezado.NumUnIdenPol#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El n&uacute;mero de p&oacute;liza: es requerido, cuenta: #rsEncabezado.cuenta#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Cdescripcion))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[VarNieto].XmlAttributes["Concepto"]="#XmlFormat(validaMapeo.CleanHighAscii(Trim(rsEncabezado.Cdescripcion)))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El concepto es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Debe))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[VarNieto].XmlAttributes["Debe"]="#Trim(numberFormat(rsEncabezado.Debe,"0.00"))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Debe es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
					<!--- Requerido --->
					<cfif Len(Trim(rsEncabezado.Haber))>
						<cfset xmlAuxiliarCtas.AuxiliarCtas.Cuenta[VarPosition].DetalleAux[VarNieto].XmlAttributes["Haber"]="#Trim(numberFormat(rsEncabezado.Haber,"0.00"))#">
						<cfelse>
						<cfset listErrores = ListAppend(listErrores, "El Haber es requerido, p&oacute;liza: #rsEncabezado.NumUnIdenPol#.|")>
					</cfif>
				<cfset VarNieto = 1 + VarNieto>
		</cfif>
	</cfloop>

	<cfelse>
		<cfset listErrores = ListAppend(listErrores, "No existen registros de cuentas que cumplan con los filtros.")>
</cfif>

<!--- PROCESO DE SELLADO --->
<cfif isdefined("Form.chk_incSelloDigital") AND #Form.key_incSelloDigital# NEQ "">
	<cfset varCadenaOriginal = "||#CadenaOriginalAuxiliarCtas#|#CadenaOriginalCuenta#|#CadenaOriginalDetalleAux#||">
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="GeneraSelloDigital" returnvariable="vSello">
		<cfinvokeargument name="cadenaOriginal"   value="#varCadenaOriginal#">
		<cfinvokeargument name="archivoKey"   value="#Form.key_incSelloDigital#">
		<cfinvokeargument name="clave"   value="#Form.psw_incSelloDigital#">
	</cfinvoke>
	<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs" method="ObtenerCertificado" returnvariable="vCertificado">
		<cfinvokeargument name="archivoCer"   value="#Form.cer_incSelloDigital#">
	</cfinvoke>
	<!--- SELLO Opcional --->
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Sello"] = "#vSello#">
	<!--- NUM. CERTIFICADO Opcional --->
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["noCertificado"] = "#vCertificado.getSerialNumber()#">
	<!--- CERTIFICADO Opcional --->
	<cfset xmlAuxiliarCtas.xmlRoot.XmlAttributes["Certificado"] = "#vCertificado.getCertificado()#">
</cfif>


<!--- validacion para ver si se lanza o no el xml a pantalla(se toman en cuenta los errores) --->
<cfif listLen(listErrores) EQ 0>
<!--- 	<cfsetting enablecfoutputonly="yes">
	<cfprocessingdirective suppresswhitespace="Yes">
	<cfcontent type="application/xml">
	<cfheader name="Content-Disposition" value="attachment; filename=#rsRfc.Eidentificacion##periodo##mes#XC.xml">
	<cfoutput>#xmlAuxiliarCtas#</cfoutput>
	</cfprocessingdirective> --->

	<!--- MANEJO DE XML A ZIP --->
	<cfset strPath = ExpandPath( "./" ) />
	<cfset strFileName = "#rsRfc.Eidentificacion##periodo##mes#XC.xml"/>
	<cfset strFileNameZip = "#rsRfc.Eidentificacion##periodo##mes#XC.zip"/>

	<cfset XMLText=ToString(xmlAuxiliarCtas)>
	<!--- guarda xml temporal --->
	<cffile action="write" file="#strPath##strFileName#" output="#XMLText#">

	<!--- crea el zip y lo guarda temporal --->
	<cfzip action="zip" source="#strPath##strFileName#" file="#strPath##strFileNameZip#"/>

	<!--- VALIDACION DE XML VS XSD --->
<!--- 	<cfset
	myResults=XMLValidate("D:\ColdFusion8\wwwroot\sif\ce\consultas\rptAuxCtasSbCtas\test-35.xml",
	"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas/AuxiliarCtas_1_3.xsd")>
	<cf_dump var="#myResults#"> --->

	<!--- ELIMINACION DE ARCHIVO xml--->
	<cfif FileExists("#strPath##strFileName#")>
		<cffile action = "delete" file = "#strPath##strFileName#">
	</cfif>


   	<!--- SE MANDA A PANTALLA PARA DESCARGARSE --->
	<cfheader name="Content-Disposition" charset=utf-8 value="inline; filename=#strFileNameZip#">
	<cfcontent type="application/x-zip-compressed" file="#strPath##strFileNameZip#" deletefile="yes">

	<cfelse>
		<script language="javascript" type="text/javascript">
			// <cfoutput>alert('Se han presentado los siguientes errores:\n' + '#listErrores#');</cfoutput>
			var strError = "";
			var cont = 1;
			var w = window.open('', 'Errores', "left=250,top=85,width=800,height=550,status=no,directories=no,menubar=no,toolbar=no,scrollbars=yes,location=no,resizable=no,titlebar=no");
			w.document.write('<title>Errores encontrados</title>')
			w.document.write('<br><br>')
			w.document.write('<div style=\"font-family: Arial, Helvetica, sans-serif;\">')
			w.document.write('<table align=\"center\" width=\"80%\" border=\"0\" cellpadding=\"0\" cellspacing=\"2\">');
			w.document.write('<tr><td>');
			w.document.write('<strong>Se han presentado los siguientes errores en la generacion del XML Auxiliar de Cuentas y/o Subcuentas: </strong>');
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
			window.location = '/cfmx/sif/ce/consultas/rptAuxCtasSbCtas/list.cfm?' + '<cfoutput>#navegacion#</cfoutput>';
		</script>
</cfif>



