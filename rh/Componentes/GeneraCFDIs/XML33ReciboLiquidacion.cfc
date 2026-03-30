<!---
Componente desarrollado para Generar el XML correspondiente para Recibo de Liquidacion, Finiquito de Nomina
Escrito por: Giancarlo Benï¿½tez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (2018-02-02) No se edito, unicamente se copiaron las funciones correspondientes
--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>

<!--- INICIA - Generacion de CadenaOriginal para Recibo de Liquidacion --->
    <cffunction name="CadenaOriginalFiniquitosLiqCFDI" returntype="string">
    	<cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="DLlinea" 					type="numeric" 	required="yes">

        <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
            <cfinvokeargument name="DLlinea" value="#Arguments.DLlinea#">
            <cfinvokeargument name="DEid" 	 value="#Arguments.DEid#">
        </cfinvoke>

        <cfset rsDeducFin = fnDeduccionesFiniquito(#Arguments.DLlinea#,#Arguments.DEid#)>
        <cfset lVarDeducciones="">
        <cfset lVarImp_ISPT=0>
        <cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF GT 0>
        	<cfset DeduccionISPTFiniquito="ISPT Finiquito">
            <cfset importeISPTFiniquito=#NumberFormat(rsLF.RHLFLisptF,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|002|00000000000ISPT|ISPT Finiquito|0.00|"&#importeISPTFiniquito#>
        	<cfset lVarImp_ISPT = #lVarImp_ISPT# + rsLF.RHLFLisptF>
        </cfif>
         <cfif rsLF.RHLFLISPTRealL GT 0>
         	<cfset DeduccionISPTRL = "ISPT Real Liquidacion">
            <cfset importeDeduccionISPTRL= #NumberFormat(rsLF.RHLFLISPTRealL/100,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|002|00000000000ISPT|ISPT Real Liquidacion|0.00|"&#importeDeduccionISPTRL#>
        	<cfset lVarImp_ISPT = #lVarImp_ISPT# + (rsLF.RHLFLISPTRealL/100)>
         </cfif>

         <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit GT 0>
         	<cfset DeduccionCreditoInfonavit="Credito Infonavit">
            <cfset importeDeduccionInfonavit = #NumberFormat(rsLF.RHLFLinfonavit,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|009|000000INFONAVIT|Credito Infonavit|0.00|"&#importeDeduccionInfonavit#>
         </cfif>
        <cfloop query="rsDeducFin">
         	<cfset lVarDeducciones=#lVarDeducciones#&"|"&#trim(rsDeducFin.RHCSATcodigo)#&"|"&#trim(rsDeducFin.TDcodigo)#&"|"&#trim(rsDeducFin.RHLDdescripcion)#&"|0.00|"&#LSNumberformat(rsDeducFin.importe,'_.00')#>
        </cfloop>

        <cfset rsLugarExpedicion    = GetLugarExpedicion(session.Ecodigo)>
        <cfset datosEmpLiqFin       = fnGetdatosEmpLiqFin(Arguments.DLlinea)>
        <cfset rsRegPatronal	    = fnGetDato(300)>
        <cfset rsTipoJornada        = fnGettipoJornada(Arguments.DEid)>
        <cfset rsPercepciones       = fnGetPercepciones(Arguments.DLlinea)>
        <cfset TotalDeducciones     = fnGetTotalDeducciones(Arguments.DLlinea,Arguments.DEid)>
		<cfset lVarTotalDeducciones = LSNumberformat(TotalDeducciones,'_.00')>
        <cfset lVarEmisor           = session.Enombre>
        <cfset lVarRFCEmisor        = rsLugarExpedicion.Eidentificacion>
        <cfset lVarLugarExpedicion  = rsLugarExpedicion.LugarExpedicion>
        <cfset lVarMoneda           = rsLugarExpedicion.Miso4217>
        <cfset lVarTotal            = LSNumberformat(rsLF.RHLFLRESULTADO,'_.00')>
        <cfset lVarRegFiscal        = rsLugarExpedicion.codigo_RegFiscal>
        <cfset lVarFechaExpedicion  = DateFormat(now(),'yyyy-mm-ddTHH:mm:00')>
        <cfset lVarNoEmp            = datosEmpLiqFin.DEidentificacion>
		<cfset lVarNombreEmp        = datosEmpLiqFin.Nombrecompleto>
        <cfset lVarRFCEmp           = datosEmpLiqFin.RFC>
        <cfset lVarCURP             = datosEmpLiqFin.CURP>
        <cfset lVarNoSegSocial      = datosEmpLiqFin.SeguroSocial>
        <cfset lVarMotivoBaja       =  datosEmpLiqFin.MotivoBaja>
        <cfset lVarpuesto           = datosEmpLiqFin.Puesto>
        <cfset lVarDepartamento     = datosEmpLiqFin.Departamento>
        <cfset lVarFechaIngreso     = DateFormat(datosEmpLiqFin.FechaIngreso,'yyyy-mm-dd')>
        <cfset lVarFechaBaja        = DateFormat(datosEmpLiqFin.FechaBaja,'yyyy-mm-dd')>
        <cfset lVarAntiguedad       = datosEmpLiqFin.Antiguedad>
        <cfset lVarTipoRegimen      = datosEmpLiqFin.TipoRegimen>
        <cfset lVarSDI              = LSNumberformat(datosEmpLiqFin.SDI,'_.00')>
        <cfset lVarBanco            = datosEmpLiqfin.Banco>
        <cfset lVarTipoContrato     = datosEmpLiqfin.Tipocontrato>
        <cfset lVarTipoJornada      = rsTipoJornada.TipoJornada>
        <cfset lVarSalarioBaseCotApor = LSNumberformat(datosEmpLiqFin.SDI,'_.00')>
        <cfset lVarPeriodicidadPago = rsTipoJornada.PeriodicidadPago>
        <cfset lVarRiesgoPuesto     = rsTipoJornada.riesgoPuesto>
        <cfset lVarRegPatronal	    = rsRegPatronal.Pvalor>
        <cfset lVarRetenciones      = NumberFormat(lVarImp_ISPT,'0.00')>
		<cfset lVarPercepciones     = "">
        <cfset importeExento        = 0>
        <cfset importegravado       = 0>
        <cfset TotalExento          = 0>
        <cfset TotalGravado         = 0>

        <!--- <cfloop query="rsPercepciones">
            	<cfset importeGravado=NumberFormat(rspercepciones.RHLIgrabado,'_.00')>
                <cfset importeExento=NumberFormat(rspercepciones.RHLIexento,'_.00')>
                <cfset TotalGravado = NumberFormat(importeGravado+TotalGravado,'_.00')>
                <cfset TotalExento = NumberFormat(importeExento+TotalExento,'_.00')>
                <cfset lVarTipoPercepcion = rspercepciones.RHCSATid >
                <cfset lVarClavePercepcion = rspercepciones.Clave >
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClavePercepcion#&"|"&#trim(rspercepciones.Descripcion)#&"|"&#importeGravado#&"|"&#importeExento# >
        </cfloop> --->

        <cfset lVarSubTotal = #NumberFormat(TotalGravado+TotalExento,'_.00')#>
        <cfset lVarPercepciones=#NumberFormat(TotalGravado,'_.00')#&"|"&#NumberFormat(TotalExento,'_.00')#&#lVarPercepciones#>
		<cfset lVarDeducciones="0.00|"&#lVarTotalDeducciones#&#lVarDeducciones#>
		<cfset lVarCadenaOriginal="||3.2|"&#lVarFechaExpedicion#&"|N|PUE|"
                                    &#lVarSubTotal#&"|0.00|1.00|"
                                    &#lVarMoneda#&"|"
                                    &#lVarTotal#&"|NA|"
                                    &#trim(lVarLugarExpedicion)#&"|"
                                    &#lVarRFCEmisor#&"|"&#lVarEmisor#&"|"&#lVarRegFiscal#&"|"
                                    &#lVarRFCEmp#&"|"&#lVarNombreEmp#&"|1|Servicio|Pago de "
                                    &#lVarMotivoBaja#&"|"
                                    &#LSNumberformat(lVarSubTotal,'_.00')#&"|"
                                    &#LSNumberformat(lVarSubTotal,'_.00')#&"|ISR|"&#lVarRetenciones#&"|"
                                    &#lVarRetenciones#&"|1.1|"
                                    &#lVarRegPatronal#&"|"
                                    &#lVarNoEmp#&"|"
                                    &#lVarCURP#&"|"
                                    &#lVarTipoRegimen#&"|"
                                    &#lVarNoSegSocial#&"|"
                                    &#lVarFechaBaja#&"|"&#lVarFechaBaja#&"|"&#lVarFechaBaja#&"|0|"
                                    &#lVarDepartamento#&"|"
                                    &#lVarBanco#&"|"
                                    &#lVarFechaIngreso#&"|"
                                    &#lVarAntiguedad#&"|"
                                    &#lVarPuesto#&"|"
                                    &#lVarTipoContrato#&"|"
                                    &#lVarTipoJornada#&"|"
                                    &#lVarPeriodicidadPago#&"|"
                                    &#lVarSalarioBaseCotApor#&"|"
                                    &#lVarRiesgoPuesto#&"|"
                                    &#lVarSDI#&"|"
                                    &#lVarPercepciones#&"|"
                                    &#lVarDeducciones#>

        <cfset lVarCadenaOriginal   = #lVarCadenaOriginal#&"||">
        <cfset lVarCadenaOriginal = cleanXML(lVarCadenaOriginal)>

        <cfreturn lVarCadenaOriginal>

 	</cffunction>
<!--- FIN - Generacion de CadenaOriginal para Recibo de Liquidacion --->

<!--- INICIA - Generacion de XML para Recibo de Liquidacion --->
    <cffunction name="XML32ReciboLiqFinCFDI" acces="private" returntype="string" >
     	<cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="DLlinea" 					type="numeric" 	required="yes">
        <cfargument name="sello" 					type="string" 	required="yes">

		<cfinvoke key="LB_Renta" default="ISR" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />

        <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
            <cfinvokeargument name="DLlinea" value="#Arguments.DLlinea#">
            <cfinvokeargument name="DEid" 	 value="#Arguments.DEid#">
        </cfinvoke>

		<cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
		    select Round(coalesce(sum(importe),0),2) as totDeduc
		    from RHLiqDeduccion
		    where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
		</cfquery>

		<cfquery name="rsFactor" datasource="#Session.DSN#">
			select coalesce(FactorDiasIMSS,FactorDiasSalario) as FactorDiasSalario
			from DLaboralesEmpleado dle
				inner join TiposNomina tn
					on tn.Ecodigo = dle.Ecodigo and tn.Tcodigo = dle.Tcodigo
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
			and DEid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>
		<cfif rsFactor.recordcount eq 0 or len(trim(rsFactor.FactorDiasSalario)) eq 0>
			<cfquery name="rs" datasource="#Arguments.Conexion#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#80#">
			</cfquery>
			<cfset factor = rs.Pvalor>
		<cfelse>
			<cfset factor = rsFactor.FactorDiasSalario>
		</cfif>

		<cfset salarioDiario = rsLF.RHLFLsalarioMensual / factor>
	    <cfset BaseImp = rsLF.RHLFLtotalL  - rsLF.RHLFLisptL>
	    <cfif rsLF.RHLFLsalarioMensual neq 0>
	        <cfset Factor = rsLF.RHLFLisptSalario / rsLF.RHLFLsalarioMensual>
	    <cfelse>
	        <cfset Factor = 0>
	    </cfif>
	    <cfset ISPTL = BaseImp * Factor>
	    <cfset ISPT = rsLF.RHLFLisptF + ISPTL  >
	    <cfset TotalD = ISPT + rsLF.RHLFLinfonavit+rsSumRHLiqDeduccion.totDeduc>

        <cfset rsDeducFin = fnDeduccionesFiniquito(Arguments.DLlinea,Arguments.DEid)>

        <cfset rsCertificado        = GetCertificado()>

        <cfset rsLugarExpedicion    = GetLugarExpedicion(session.Ecodigo)>
        <cfset datosEmpLiqFin       = fnGetdatosEmpLiqFin(Arguments.DLlinea)>
        <!--- <cfset rsRegPatronal	    = fnGetDato(300)> --->
        <cfset rsTipoJornada        = fnGettipoJornada(Arguments.DEid)>
        <cfset rsPercepciones       = fnGetPercepciones(Arguments.DLlinea)>

        <cfset TotalDeducciones     = fnGetTotalDeducciones(Arguments.DLlinea,Arguments.DEid)>
		<cfset lVarTotalDeducciones = LSNumberformat(TotalDeducciones,'_.00')>

        <cfset lVarEmisor           = session.Enombre>
        <cfset lVarRFCEmisor        = rsLugarExpedicion.Eidentificacion>
        <cfset lVarLugarExpedicion  = rsLugarExpedicion.LugarExpedicion>
        <cfset lVarMoneda           = rsLugarExpedicion.Miso4217>
        <cfset lVarTotal            = LSNumberformat(rsLF.RHLFLRESULTADO,'_.00')>
        <cfset lVarRegFiscal        = rsLugarExpedicion.codigo_RegFiscal>
        <cfset lVarFechaExpedicion  = DateFormat(now(),'yyyy-mm-ddTHH:mm:00')>
        <cfset lVarNoEmp            = datosEmpLiqFin.DEidentificacion>
		<cfset lVarNombreEmp        = datosEmpLiqFin.Nombrecompleto>
        <cfset lVarRFCEmp           = datosEmpLiqFin.RFC>
        <cfset lVarCURP             = datosEmpLiqFin.CURP>
        <cfset lVarNoSegSocial      = datosEmpLiqFin.SeguroSocial>
        <cfset lVarMotivoBaja       = datosEmpLiqFin.MotivoBaja>
        <cfset lVarpuesto           = datosEmpLiqFin.Puesto>
        <cfset lVarDepartamento     = datosEmpLiqFin.Departamento>
        <cfset lVarFechaIngreso     = DateFormat(datosEmpLiqFin.FechaIngreso,'yyyy-mm-dd')>
        <cfset lVarFechaBaja        = DateFormat(datosEmpLiqFin.FechaBaja,'yyyy-mm-dd')>
        <cfset lVarAntiguedad       = datosEmpLiqFin.Antiguedad>
        <cfset lVarTipoRegimen      = datosEmpLiqFin.TipoRegimen>
        <cfset lVarSDI              = LSNumberformat(datosEmpLiqFin.SDI,'_.00')>
        <cfset lVarBanco            = datosEmpLiqfin.Banco>
        <cfset lVarTipoContrato     = datosEmpLiqfin.Tipocontrato>
        <cfset lVarTipoJornada      = rsTipoJornada.TipoJornada>
        <cfset lVarSalarioBaseCotApor = LSNumberformat(datosEmpLiqFin.SDI,'_.00')>
        <cfset lVarPeriodicidadPago = rsTipoJornada.PeriodicidadPago>
        <cfset lVarRiesgoPuesto     = rsTipoJornada.riesgoPuesto>
        <cfset lVarRegPatronal	    = datosEmpLiqFin.RegPatronal>
		<cfset lVarPercepciones     = "">
        <cfset importeExento        = 0>
        <cfset importegravado       = 0>
        <cfset TotalExento          = 0>
        <cfset TotalGravado         = 0>
        <cfset lVarPerTotalGravado  = 0>
        <cfset lVarPerTotalExento   = 0>
		<!--- Percepciones que no son de Liquidacion/Finiquito --->
		<cfquery name="rsPercepcionesReg" dbtype="query">
			select Sum(Importe) sumImporte from rsPercepciones
			where RHCSATid not in ('025','023','022') <!--- Codigos de concepto SAT para Liquidaciones/Finiquito --->
		</cfquery>
		<cfset varTotalSueldos = 0>
		<cfif rsPercepcionesReg.RecordCount gt 0>
			<cfset varTotalSueldos = LSNumberFormat(rsPercepcionesReg.sumImporte,'9.00')>
		</cfif>

        <cfloop query="rsPercepciones">
            	<cfset importeGravado = rspercepciones.RHLIgrabado>
                <cfset importeExento  = rspercepciones.RHLIexento>
                <cfset lVarPerTotalGravado += importeGravado>
                <cfset lVarPerTotalExento  += importeExento>
                <cfset lVarTipoPercepcion  = rspercepciones.RHCSATid>
                <cfset lVarClavePercepcion = rspercepciones.Clave>
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClavePercepcion#&"|"&#trim(rspercepciones.Descripcion)#&"|"&#importeGravado#&"|"&#importeExento# >
        </cfloop>

		<cfset esLiquidacion = false>

		<cfquery name="rsLiq" dbtype="query">
			select * from rsPercepciones
			where RHCSATid = '025' <!--- Codigo de concepto SAT para Liquidaciones --->
		</cfquery>
		<cfset esLiquidacion = (rsLiq.RecordCount gt 0)>

		<cfset lvarLiqus = 0>
		<cfif esLiquidacion>
			<cfquery name="rsSumLiq" dbtype="query">
				select sum(RHLIEXENTO+RHLIGRABADO) sumImporte
				from rsPercepciones
				where RHCSATid in ('022','023','025') <!--- Codigo de concepto SAT para Liquidaciones --->
			</cfquery>
			<cfset lvarLiqus = LSNumberFormat(rsSumLiq.sumImporte,'9.00')>
		</cfif>

        <cfset lVarSubTotal = LSNumberFormat(lVarPerTotalGravado,'9.00')+LSNumberFormat(lVarPerTotalExento,'9.00')>
        <cfset lVarPercepciones=#NumberFormat(lVarPerTotalGravado,'_.00')#&"|"&#NumberFormat(lVarPerTotalExento,'_.00')#&#lVarPercepciones#>
		<cfset lVarDeducciones="">
        <cfset lVarImp_ISPT = 0>

        <cfset vNumCertificado = "#rsCertificado.NoCertificado#">
        <cfset vSello = "#Arguments.sello#">
        <cfset vCertificado = "#rsCertificado.certificado#">

		<!--- OPARRALES 2019-01-14
			- Modificacion para obtener la fecha de la BD
			- ya que al obtenerla del sistema genera conflicto en los minutos y segundos
		 --->

		<cfquery name="rsNow" datasource="#session.dsn#">
			select
				SUBSTRING(ltrim(rtrim(convert(char,getDate(),120))),1,10)+'T'+convert(char,getDate(),108) as fechaEmision
			from
				dual
		</cfquery>

		<cfset fechaEmision = rsNow.fechaEmision>
		<cfset session.fechaEmision = fechaEmision>
		<cfquery name="rsEntFed" datasource="#session.dsn#">
			select top(1)
				e.Pclave
			from
			DatosEmpleado de
			inner join DLaboralesEmpleado dle on de.DEid = dle.DEid
			inner join Oficinas o on o.Ocodigo = dle.Ocodigo and o.Ecodigo = dle.Ecodigo
			inner join Direcciones d on d.id_direccion = o.id_direccion
			inner join Pais p on p.Ppais = d.Ppais
			inner join CSATEstados e on E.Pclave = p.CSATPclave and d.estado = e.CSATdescripcion
			where  de.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>

		<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
            select top 1
				coalesce(SErenta,0) as ImporteExento
            from HSalarioEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			order by RCNid desc
        </cfquery>

        <cfoutput>
			<CFXML VARIABLE="xml32">
				<Comprobante
					Version="3.3"
					Serie="#trim(fnSecuenciasEscape(lVarNoEmp))#"
					Fecha="#fechaEmision#"
					Sello="#vSello#"
					Folio="#Trim(fnSecuenciasEscape(Arguments.DLlinea))#-#Minute(now())#"
					FormaPago="99"
					NoCertificado="#vNumCertificado#"
					Certificado="#vCertificado#"
					SubTotal="#LSNumberformat(lVarSubTotal,'_.00')#" <!--- todas las percepcions antes de descuentos. --->
                    <cfif TotalD gt 0>
					    Descuento="#LSNumberFormat(TotalD,'9.00')#"
                    </cfif>
					Moneda="#trim(fnSecuenciasEscape(rsLugarExpedicion.Miso4217))#"
					Total="#LSNumberformat(lVarSubTotal-TotalD,'_.00')#" <!--- subtotal - deducciones --->
					TipoDeComprobante="N"
					MetodoPago="PUE"
					LugarExpedicion="#trim(fnSecuenciasEscape(lVarLugarExpedicion))#"
					xmlns:cfdi="http://www.sat.gob.mx/cfd/3"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:nomina12="http://www.sat.gob.mx/nomina12"
					xsi:schemaLocation="http://www.sat.gob.mx/cfd/3
					http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd
					http://www.sat.gob.mx/nomina12 http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina12.xsd">

	                <Emisor
	                	Rfc="#trim(lVarRFCEmisor)#"
	                	Nombre="#trim(fnSecuenciasEscape(lVarEmisor))#"
					 	RegimenFiscal="#trim(rsLugarExpedicion.codigo_RegFiscal)#"/>
					<Receptor
						Rfc="#trim(fnSecuenciasEscape(lVarRFCEmp))#"
						Nombre="#lVarNombreEmp#"
						UsoCFDI="P01"/>
					<Conceptos>
						<Concepto
							ClaveProdServ="84111505"
							Cantidad="1"
							ClaveUnidad="ACT"
							Descripcion="Pago de nómina"
							ValorUnitario="#LSNumberformat(lVarSubTotal,'_.00')#"
							Importe="#LSNumberformat(lVarSubTotal,'_.00')#"
                            <cfif TotalD gt 0>
							    Descuento="#LSNumberformat(TotalD,'_.00')#"
                            </cfif>
							/>
					</Conceptos>

					<Complemento>
						<nomina12:Nomina
							Version="1.2"
							TipoNomina="E"
							FechaPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#"
							FechaInicialPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#"
							FechaFinalPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#"
							NumDiasPagados="1"
							<cfif lVarSubTotal gt 0>
								TotalPercepciones="#LSNumberFormat(varTotalSueldos+lvarLiqus,'9.00')#"
							</cfif>
							<cfif TotalD gt 0>
								TotalDeducciones="#LSNumberformat(TotalD,'_.00')#"
                            </cfif>
                                TotalOtrosPagos="#LSNumberformat(0,'_.00')#"
						>
						<nomina12:Emisor
							<cfif isDefined('curpPFisica')>
								Curp="#curpPFisica.Pvalor#"																			<!--- CURP Persona Fisica --->
							</cfif>
							RegistroPatronal="#trim(fnSecuenciasEscape(lVarRegPatronal))#"
							>
						</nomina12:Emisor>

						<nomina12:Receptor
							Curp="#trim(fnSecuenciasEscape(datosEmpLiqFin.CURP))#"
							NumSeguridadSocial="#trim(fnSecuenciasEscape(datosEmpLiqFin.SeguroSocial))#"
							FechaInicioRelLaboral="#DateFormat(datosEmpLiqFin.FechaIngreso,'yyyy-mm-dd')#"
							Antigüedad="P#datosEmpLiqFin.Antiguedad#W"
							TipoContrato="#trim(fnSecuenciasEscape(lVarTipoContrato))#"
							<cfif datosEmpLiqFin.DESindicalizado eq 1>
								Sindicalizado="Sí"
							</cfif>
							TipoJornada="#trim(fnSecuenciasEscape(datosEmpLiqFin.TipoJornada))#"
							TipoRegimen="02"
							NumEmpleado="#trim(fnSecuenciasEscape(datosEmpLiqFin.DEidentificacion))#"
							Departamento="#trim(datosEmpLiqFin.Departamento)#"
							Puesto="#trim(fnSecuenciasEscape(datosEmpLiqFin.Puesto))#"
							RiesgoPuesto="#datosEmpLiqFin.RiesgoPuesto#"
							PeriodicidadPago="99"
							SalarioBaseCotApor="#LSNumberformat(datosEmpLiqFin.SDI,'_.00')#"
							SalarioDiarioIntegrado="#LSNumberformat(datosEmpLiqFin.SDI,'_.00')#"
							ClaveEntFed="#trim(rsEntFed.Pclave)#">
	<!---Banco="#trim(datosEmpLiqFin.Banco)#"--->
						</nomina12:Receptor>

						<Percepciones
							TotalSueldos="#LSNumberformat(varTotalSueldos,'_.00')#"
							TotalExento="#LSNumberformat(lVarPerTotalExento,'_.00')#"
							<cfif esLiquidacion>
								TotalSeparacionIndemnizacion = "#LSNumberFormat(rsSumLiq.sumImporte,'9.00')#"
							</cfif>

							TotalGravado="#LSNumberformat(lVarPerTotalGravado,'_.00')#">

            			<cfloop query = "rsPercepciones">
			            	<Percepcion
			            		TipoPercepcion="#trim(RHCSATid)#"
			            		Clave="#trim(rsPercepciones.Clave)#"
			            		Concepto="#trim(rsPercepciones.Descripcion)#"
			            		ImporteGravado="#LSNumberformat(rsPercepciones.RHLIgrabado,'_.00')#"
			            		ImporteExento="#LSNumberformat(rsPercepciones.RHLIexento,'_.00')#"/>
            			</cfloop>

						<!---
						SOLO PARA LIQUIDACION TOTAL CONCEPTO DE INDEMNIZACION ... 022 023 025 codigos de incidencia, catalogo sat
						 --->
						<cfif esLiquidacion>
							<cfset lvarTotalPagado = rsLiq.RHLIEXENTO+rsLiq.RHLIGRABADO>
							<cfset lvarAntig = datosEmpLiqFin.yearInt>
							<cfif LSNumberFormat(datosEmpLiqFin.AntiguedadY,'9.00') gt LSNumberFormat((datosEmpLiqFin.yearInt+0.50),'9.00')>
								<cfset lvarAntig += 1>
							</cfif>

							<cfset lvarAcumulable = datosEmpLiqFin.SalarioMensual>
							<cfif lvarAcumulable gt lvarTotalPagado>
								<cfset lvarAcumulable = lvarTotalPagado>
							</cfif>

							<cfset lvarlNoAcumulable = rsLiq.RHLIGRABADO - datosEmpLiqFin.SalarioMensual>
							<SeparacionIndemnizacion
								TotalPagado="#LSNumberFormat(lvarTotalPagado,'9.00')#"
								NumAñosServicio="#lvarAntig#"
								UltimoSueldoMensOrd="#LSNumberFormat(datosEmpLiqFin.SalarioMensual,'9.00')#"
								IngresoAcumulable="#LSNumberFormat(lvarAcumulable,'9.00')#"
								IngresoNoAcumulable="#(lvarlNoAcumulable lt 0 ? 0 : lvarlNoAcumulable)#"/>

						</cfif>

	            	</Percepciones>

	            	<cfif TotalD gt 0>
						<Deducciones
							TotalOtrasDeducciones="#LSNumberFormat(TotalD-ISPT,'9.00')#"
							<cfif ISPT gt 0>
								TotalImpuestosRetenidos="#LSNumberformat(ISPT,'_.00')#"
							</cfif>
		            		>
							<cfif ISPT neq 0.00>
			            		<Deduccion
			            			TipoDeduccion="002"
			            			Clave="#right(('000000000000000'&trim(LB_Renta)),15)#"
			            			Concepto="#LB_Renta#"
									Importe="#LSNumberformat(ISPT,'_.00')#"/>
							</cfif>

	            			<cfloop query ="rsDeducFin">
				            	<Deduccion
				            		Clave="#trim(rsDeducFin.TDcodigo)#"
				            		Concepto="#trim(rsDeducFin.RHLDdescripcion)#"
				            		Importe="#LSNumberformat(rsDeducFin.importe,'_.00')#"
				            		TipoDeduccion="#trim(rsDeducFin.RHCSATcodigo)#"/>
	            			</cfloop>
	            		</Deducciones>
                    </cfif>
                        <nomina12:OtrosPagos>
                            <nomina12:OtroPago
                                Clave="000000000000009"
                                Concepto="Subsidio al Empleo"
                                Importe="#LSNumberFormat(0,'_.00')#"
                                TipoOtroPago="002">
                                <nomina12:SubsidioAlEmpleo SubsidioCausado="#LSNumberFormat(0,'_.00')#"/>
                            </nomina12:OtroPago>
                        </nomina12:OtrosPagos>
		            </nomina12:Nomina>
		          </Complemento>
		        </Comprobante>
            </CFXML>
        </cfoutput>

		<cfset xml32 = replace(#xml32#,"="" ","=""","ALL")>
        <cfset xml32 = replace(#xml32#,"Descuento="," Descuento=","ALL")>
        <cfset xml32 = replace(#xml32#,"Serie="," Serie=","ALL")>
        <cfset xml32 = replace(#xml32#,"<Comprobante ","<cfdi:Comprobante ")>
        <cfset xml32 = replace(#xml32#,"<Emisor","<cfdi:Emisor")>
        <cfset xml32 = replace(#xml32#,"<DomicilioFiscal","<cfdi:DomicilioFiscal")>
        <cfset xml32 = replace(#xml32#,"<ExpedidoEn","<cfdi:ExpedidoEn")>
        <cfset xml32 = replace(#xml32#,"<RegimenFiscal","<cfdi:RegimenFiscal")>
		<cfset xml32 = replace(#xml32#,"</RegimenFiscal","</cfdi:RegimenFiscal")>
        <cfset xml32 = replace(#xml32#,"</Emisor>","</cfdi:Emisor>")>
        <cfset xml32 = replace(#xml32#,"<Receptor","<cfdi:Receptor")>
        <cfset xml32 = replace(#xml32#,"<Domicilio","<cfdi:Domicilio")>
        <cfset xml32 = replace(#xml32#,"</Receptor>","</cfdi:Receptor>")>
        <cfset xml32 = replace(#xml32#,"<Conceptos>","<cfdi:Conceptos>")>
        <cfset xml32 = replace(#xml32#,"<Concepto ","<cfdi:Concepto ")>
        <cfset xml32 = replace(#xml32#,"</Conceptos>","</cfdi:Conceptos>")>
        <cfset xml32 = replace(#xml32#,"<Impuestos","<cfdi:Impuestos")>
        <cfset xml32 = replace(#xml32#,"<Retenciones>","<cfdi:Retenciones>")>
        <cfset xml32 = replace(#xml32#,"<Retencion ","<cfdi:Retencion ")>
        <cfset xml32 = replace(#xml32#,"</Retenciones>","</cfdi:Retenciones>")>
        <cfset xml32 = replace(#xml32#,"</Impuestos>","</cfdi:Impuestos>")>
        <cfset xml32 = replace(#xml32#,"<Complemento>","<cfdi:Complemento>")>
        <cfset xml32 = replace(#xml32#,"<Percepciones ","<nomina12:Percepciones ")>
        <cfset xml32 = replace(#xml32#,"<Percepcion ","<nomina12:Percepcion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Percepciones>","</nomina12:Percepciones>")>
        <cfset xml32 = replace(#xml32#,"<Deducciones ","<nomina12:Deducciones ")>
        <cfset xml32 = replace(#xml32#,"<Deduccion ","<nomina12:Deduccion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Deducciones>","</nomina12:Deducciones>")>
        <cfset xml32 = replace(#xml32#,"<Incapacidad ","<nomina12:Incapacidad ","ALL")>
        <cfset xml32 = replace(#xml32#,"<HorasExtra ","<nomina12:HorasExtra ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Nomina>","</nomina12:Nomina>")>
        <cfset xml32 = replace(#xml32#,"</Complemento>","</cfdi:Complemento>")>
        <cfset xml32 = replace(#xml32#,"</Comprobante>","</cfdi:Comprobante>")>
		<cfset xml32 = replace(#xml32#,"<SeparacionIndemnizacion","<nomina12:SeparacionIndemnizacion ")>

     	<cfreturn xml32>

    </cffunction>
<!--- FIN - Generacion de XML para Recibo de Liquidacion --->


<!--- INICIO - Funciones privadas para Recibo de Liquidacion --->

    <cffunction name="fnDeduccionesFiniquito" access="public" returntype="query">
		<cfargument name="DLlinea" 	 type="numeric">
		<cfargument name="DEid" 	 type="numeric">
		<cfargument name="Conexion"  type="string">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfif not isdefined('Arguments.DLlinea') or not isdefined('Arguments.DEid')>
			<cfthrow message="Debe definir los campos, DLlinea y DEid">
		</cfif>

		<cfquery name="rsDeducionesFin" datasource="#Arguments.Conexion#">
            select
				ld.RHLDdescripcion,
				ld.importe,
				right(('000000000000000'+td.TDcodigo),15) as TDcodigo,
				cs.RHCSATcodigo
            from  RHLiqDeduccion ld
            	inner join DeduccionesEmpleado de
            		on ld.DEid=de.DEid and ld.Did=de.Did
            	inner join TDeduccion td
            		on de.TDid=td.TDid
            	inner join RHCFDIConceptoSAT cs
            		on td.RHCSATid=cs.RHCSATid
                where
				DLlinea = #Arguments.DLlinea# and ld.DEid = #Arguments.DEid#
		</cfquery>

		<cfreturn rsDeducionesFin>
	</cffunction>

    <cffunction name="fnGetdatosEmpLiqFin"  returntype="query" access="public">
    	<cfargument name="DLlinea"		type="numeric" required="yes">

		<cfset rsRegPatr 	= fnGetDato(300)>
        <cfset rsRiesgoLab 	= fnGetDato(301)>

		<cfif rsRiesgoLab.RecordCount eq 0 or rsRiesgoLab.RecordCount gt 0 and Trim(rsRiesgoLab.Pvalor) eq ''>
			<cfthrow message="No se ha configurado el Riesgo Laboral" type="Application" detail="Parametros RH">
		</cfif>

        <cfset RegPatr 	= #rsRegPatr.Pvalor#>

         <cfquery name="rsClaveRiesgo"  datasource="#session.dsn#">
         	select coalesce(RHRiesgocodigo,0) as RiesgoPuesto from RHCFDI_Riesgo r
            where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRiesgoLab.Pvalor#">
         </cfquery>
         <cfif rsClaveRiesgo.RecordCount gt 0 and len(rsClaveRiesgo.RiesgoPuesto)>
         	<cfset RiesgoLab= #rsClaveRiesgo.RiesgoPuesto#>
         <cfelse>
         	<cfset RiesgoLab= 0>
         </cfif>

        <cfquery name="rsDatosEmpLiqFin" datasource="#Session.DSN#">
            select b.DEid,
                   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
                   b.DEidentificacion,
                   b.RFC,
                   b.CURP,
                   b.DEsdi as SDI,
                   b.DESeguroSocial as SeguroSocial,
                   a.RHLPfingreso as FechaIngreso,
                   c.DLfvigencia as FechaBaja,
                   d.RHPdescpuesto Puesto,
                   f.Ddescripcion Departamento,
                   g.RHTdesc as MotivoBaja,
                   c.Ecodigo,
                   c.Tcodigo,
                   i.Msimbolo,
                   i.Mnombre,
					coalesce(b.DESindicalizado,0) DESindicalizado,
                   coalesce(a.RHLPrenta, 0) as renta,
                   coalesce(a.RHLPfecha,getdate()) as RHLPfecha,
                   h.FactorDiasSalario as FactorDiasSalario,
					DATEDIFF(YY,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=b.Deid order by LTdesde desc),c.DLfvigencia) as yearInt,
					Round(DateDiff(second,DateAdd(second,1,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=b.Deid order by LTdesde desc)),c.DLfvigencia) /60/60/24/ 30.416666 / 12.00,2) AntiguedadY,
					<!--- DATEDIFF(WW,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=b.Deid order by LTdesde desc),c.DLfvigencia) as Antiguedad, --->
					Left((DATEDIFF(second,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=b.Deid order by LTdesde desc),c.DLfvigencia) / 86400.0 / 7),(Charindex('.',(DATEDIFF(second,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=b.Deid order by LTdesde desc),c.DLfvigencia) / 86400.0 / 7)))-1) as Antiguedad,
                   reg.RHRegimencodigo as tipoRegimen,
                   bnc.BcodigoOtro as Banco,

				(select top(1) coalesce(convert(int,r.RHRiesgocodigo),'#RiesgoLab#')
                from LineaTiempo lt
                inner join Oficinas p
					on lt.Ocodigo = p.Ocodigo
					and lt.Ecodigo = p.Ecodigo
                left join RHCFDI_Riesgo r
                on p.RHRiesgoid = r.RHRiesgoid and p.Ecodigo = r.Ecodigo
                where lt.Deid=b.Deid order by LTdesde DESC) as RiesgoPuesto,

				(select top(1) coalesce(p.Onumpatronal,'#RegPatr#')
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronal,

				(select top(1) p.Onumpatronal
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronalO,


				(select top(1)
                    <!--- case p.Ttipopago
                        when '3' then 'Mensual'
                        when '2' then 'Quincenal'
                        when '1' then 'Bisemanal'
                        when '0' then 'Semanal'
                        else 'ND'
                    end as PeriodicidadPago --->
					p.Tcodigo as PeriodicidadPago
                from LineaTiempo lt
                inner join TiposNomina p on lt.Tcodigo = p.Tcodigo and lt.Ecodigo=p.Ecodigo
                where lt.Deid=b.Deid order by LTdesde DESC) as PeriodicidadPago,

				(select RHLFLsalarioMensual from RHLiqFL fl where fl.DEid = b.DEid and fl.DLlinea = a.DLlinea ) as SalarioMensual,

				(select top(1) p.ClaveSAT
                from LineaTiempo lt
                inner join RHJornadas p on lt.RHJid = p.RHJid
                where lt.Deid=b.Deid order by LTdesde DESC) as TipoJornada,
				   tc.CSATclave as TipoContrato
            from RHLiquidacionPersonal a

                inner join DatosEmpleado b
                    on a.DEid = b.DEid

				inner join CSATTiposContrato tc
					on b.DEtipocontratacion = tc.TCid
                inner join DLaboralesEmpleado c
                    on a.DLlinea = c.DLlinea

                left join RHCFDI_Regimen reg
                    on b.RHRegimenid = reg.RHRegimenid

                inner join Bancos bnc
                    on bnc.Bid=b.Bid

                inner join RHPuestos d
                    on c.Ecodigo = d.Ecodigo
                    and c.RHPcodigo = d.RHPcodigo

                inner join EVacacionesEmpleado e
                    on a.DEid = e.DEid

                inner join Departamentos f
                    on c.Ecodigo = f.Ecodigo
                    and c.Dcodigo = f.Dcodigo

                inner join RHTipoAccion g
                    on c.RHTid = g.RHTid

                inner join TiposNomina h
                    on c.Ecodigo = h.Ecodigo
                    and c.Tcodigo = h.Tcodigo

                inner join Monedas i
                    on h.Ecodigo = i.Ecodigo
                    and h.Mcodigo = i.Mcodigo

            where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DLlinea#">
        </cfquery>

		<!--- VALIDACION: REGISTRO PATRONAL POR OFICINA OPARRALES 2018-09-20
			- Si existe por lo menos un Empleado con Registro patronal en su oficina
			- por regla de negocio todos deben tener configurado el registro patronal en la oficina.
		 --->

		 <cfquery name="rsRPOfi" dbtype="query">
			select *
            from rsDatosEmpLiqFin
			where RegPatronalO is not null
			<!--- or LTRIM(RTRIM(RegPatronalO)) <> '' --->
            order by NombreCompleto
		</cfquery>
		<cfset mensajeError = "">
		<cfif rsRPOfi.RecordCount gt 0>
			<!--- Buscando los empleados que hace falta configurar el registro patronal en su oficina --->
			<cfquery name="rsRPOfi2" dbtype="query">
				select *
	            from rsDatosEmpLiqFin
				where RegPatronalO is null
	            order by NombreCompleto
			</cfquery>

			<!--- Si existen empleados sin la configuracion se concatenan en mensaje de error --->
			<cfset NL = Chr(13)&Chr(10)>
			<cfloop query="rsRPOfi2">
				<cfset mensajeError &= "* #DEidentificacion#- #NombreCompleto#" & NL>
			</cfloop>

			<cfif Trim(mensajeError) neq ''>
				<cfthrow message="No se ha configurado el Registro Patronal de los siguientes empleados: #NL# #mensajeError#" detail="Registro Patronal - Oficinas" type="Application">
			</cfif>
		<cfelse>
			<cfif RegPatr eq ''>
				<cfthrow message="No se ha configurado el Registro Patronal" detail="Parametros RH" type="Application">
			</cfif>
		</cfif>

        <cfreturn rsDatosEmpLiqFin>
    </cffunction>

    <cffunction name="fnGetTipoJornada" returntype="query" access="public">
    	 <cfargument name="DEid" 		type="numeric" required="yes">

		 <cfset rsRiesgoLab 	= fnGetDato(301)>
         <cfquery name="rsClaveRiesgo"  datasource="#session.dsn#">
         	select coalesce(RHRiesgocodigo,0) as RiesgoPuesto from RHCFDI_Riesgo
            where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRiesgoLab.Pvalor#">
         </cfquery>
         <cfif rsClaveRiesgo.RecordCount gt 0 and len(rsClaveRiesgo.RiesgoPuesto)>
         	<cfset RiesgoLab= #rsClaveRiesgo.RiesgoPuesto#>
         <cfelse>
         	<cfset RiesgoLab= 0>
         </cfif>
         <cfquery name="rsTipoJornada" datasource="#session.dsn#">
             select top(1) p.RHJdescripcion as tipoJornada,
						case tn.Ttipopago
                        when '3' then 'Mensual'
                        when '2' then 'Quincenal'
                        when '1' then 'Bisemanal'
                        when '0' then 'Semanal'
                        else 'ND'
                    end as PeriodicidadPago,
                    lt.LTsalario as SalarioBaseCotApor,
                     coalesce(r.RHRiesgocodigo,'#RiesgoLab#') as RiesgoPuesto
                from LineaTiempo lt
                inner join RHJornadas p on lt.RHJid = p.RHJid
                inner join TiposNomina tn on lt.Tcodigo = tn.Tcodigo and lt.Ecodigo=p.Ecodigo
                inner join Oficinas o on lt.Ocodigo = o.Ocodigo and lt.Ecodigo = p.Ecodigo
                left join RHCFDI_Riesgo r on o.RHRiesgoid = r.RHRiesgoid and p.Ecodigo = r.Ecodigo
                where lt.Deid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                order by LTdesde DESC
         </cfquery>
         <cfreturn rsTipoJornada>
    </cffunction>
    <cffunction name="fnGetPercepciones" returntype="query" access="public">
    	 <cfargument name="DLlinea" 		type="numeric" required="yes">
         	<!---ERBG Parte ISPT Exenta INICIA--->
         	<cfquery name="rsDEid" datasource="#Session.DSN#">
         		select top(1) a.DEid from RHLiqIngresos a
                where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
         	</cfquery>
         	<cfquery name="rsConcepto" datasource="#Session.DSN#">
                select c.CIcodigo
                from RHLiqIngresos a
                    left outer join DDConceptosEmpleado b
                        on a.DLlinea = b.DLlinea and a.CIid = b.CIid
                    left outer join CIncidentes c
                        on a.CIid = c.CIid
                    left outer join RHCFDIConceptoSAT cs
                        on c.RHCSATid=cs.RHCSATid
                where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
                and coalesce(c.CISumarizarLiq,0) = 0
                and RHLIFiniquito= 0
				<!--- == INDEMINIZACIONES == --->
				and cs.RHCSATcodigo = '025' and RHCSATtipo = 'P'
				<!--- == INDEMINIZACIONES == --->
                order by c.CIcodigo desc
         	</cfquery>

            <cfset varCIcodigo = ''>
            <cfif rsConcepto.RecordCount gt 0 and len(rsConcepto.CIcodigo)>
				<cfset varCIcodigo = '#rsConcepto.CIcodigo#'>
            </cfif>
            <!---ERBG Parte ISPT Exenta FIN--->
            <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnRetencionISPT" returnvariable="ParteExenta">
                <cfinvokeargument name="DEid" value="#rsDEid.DEid#">
            </cfinvoke>

            <cfquery name="rsPercepciones" datasource="#Session.DSN#">
                select
					a.DEid,
					a.RHLPid,
					a.CIid,
					a.RHLPdescripcion as Descripcion,
					Round(a.importe,2) importe,
	                case c.CIcodigo
		                when '#varCIcodigo#' then 
                            case when c.CIcodigo = '13' then
                                case when b.DDCres <= Round(#ParteExenta#,2) then b.DDCres else Round(#ParteExenta#,2) end
                            else
                                Round(#ParteExenta#,2)
                            end
		                else Round(a.RHLIexento,2)
	                end as RHLIexento,

	                case
	                	when c.CIcodigo = '#varCIcodigo#' AND RHLIgrabado > #ParteExenta# then Round(RHLIgrabado - #ParteExenta#,2)
	                	when c.CIcodigo = '#varCIcodigo#' AND RHLIgrabado < #ParteExenta# then 0
	                	else Round(a.RHLIgrabado,2)
	                end as RHLIgrabado,
					<!---ERBG Parte ISPT Exenta FIN--->
	                right(('000'+Convert(varchar,cs.RHCSATcodigo)),3)as RHCSATid ,
					right(('000000000000000'+c.CIcodigo),15) as Clave,
					b.DDCres as Resultado,
					b.DDCcant as Cantidad,
					b.DDCimporte as Monto
                from RHLiqIngresos a
                    left outer join DDConceptosEmpleado b
                        on a.DLlinea = b.DLlinea and a.CIid = b.CIid
                    left outer join CIncidentes c
                        on a.CIid = c.CIid
                    left outer join RHCFDIConceptoSAT cs
                        on c.RHCSATid=cs.RHCSATid
                where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
                and coalesce(c.CISumarizarLiq,0) = 0
                and a.importe > 0
                <!---and a.RHLPautomatico = 1--->
            </cfquery>
            <cfreturn rsPercepciones>
    </cffunction>
    <cffunction name="fnGetTotalDeducciones" returntype="string" access="public">
    	<cfargument name="DLlinea" 		type="numeric" required="yes">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
            <cfinvokeargument name="DLlinea" value="#Arguments.DLlinea#">
            <cfinvokeargument name="DEid" 	 value="#Arguments.DEid#">
        </cfinvoke>


        <cfset BaseImp = rsLF.RHLFLtotalL  - rsLF.RHLFLisptL>
		<cfif rsLF.RHLFLsalarioMensual GT 0>
            <cfset Factor = rsLF.RHLFLisptSalario / rsLF.RHLFLsalarioMensual>
        <cfelse>
            <cfset Factor = 0>
        </cfif>

        <cfset ISPTL = BaseImp * Factor>
        <cfset ISPT = rsLF.RHLFLisptF + ISPTL >

		<cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF GT 0>
        	<cfset TotalD = rsLF.RHLFLisptF>
        <cfelse>
           	<cfset TotalD = ISPT>
        </cfif>
        <cfif rsLF.RHLFLISPTRealL gt 0>
        	<cfset TotalD = TotalD + #rsLF.RHLFLISPTRealL#/100>
        </cfif>
        <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit GT 0>
           	<cfset TotalD = TotalD + rsLF.RHLFLinfonavit>
        </cfif>
		<!---
        <cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
            select coalesce(sum(importe),0) as totDeduc
            from RHLiqDeduccion
            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
        </cfquery>
         --->
		<cfquery name="rsSumRHLiqDeduccion" datasource="#session.dsn#">
            select
				coalesce(sum(ld.importe),0) as totDeduc
            from  RHLiqDeduccion ld
           	inner join DeduccionesEmpleado de
           		on ld.DEid=de.DEid and ld.Did=de.Did
           	inner join TDeduccion td
           		on de.TDid=td.TDid
           	inner join RHCFDIConceptoSAT cs
           		on td.RHCSATid=cs.RHCSATid
            where
				DLlinea = #Arguments.DLlinea# and ld.DEid = #Arguments.DEid#
		</cfquery>
		<cfif rsSumRHLiqDeduccion.totDeduc neq 0>
            <cfquery name="rsDetRHLiqDeduccion" datasource="#session.DSN#">
                select importe
                from RHLiqDeduccion
                where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
            </cfquery>
            <cfloop query="rsDetRHLiqDeduccion">
					<cfset TotalD = TotalD + #rsDetRHLiqDeduccion.importe#>
            </cfloop>
        </cfif>

		<cfreturn TotalD>
    </cffunction>

	<cffunction name="fnGetDato" returntype="query" access="private">
        <cfargument name="Pcodigo" type="numeric" required="true">
        <cfargument name="Ecodigo" type="numeric">
        <cfargument name="Conexion" type="string">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "#session.dsn#">
        </cfif>

        <cfquery name="rs" datasource="#Arguments.Conexion#">
            select Pvalor
            from RHParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfreturn #rs#>
    </cffunction>


<!--- FIN - Funciones privadas para Recibo de Liquidacion --->

</cfcomponent>

