<!---
Componente desarrollado para Generar el XML correspondiente para Recibo de Nomina
Escrito por: Giancarlo Benítez V.
Version: 1.0
Fecha ultima modificacion: 2018-02-02
Observaciones:
    -   (2018-02-02) No se edito, unicamente se copiaron las funciones correspondientes
--->

<cfcomponent extends='rh.Componentes.GeneraCFDIs.SupportGeneraCFDI'>

<!--- INICIA - Generacion de CadenaOriginal para Recibo de Nomina --->
    <cffunction name="CadenaOriginalReciboNominaCFDI"  access="public" returntype="string">
        <cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="RCNid" 					type="numeric" 	required="yes">

        <cfinvoke key="LB_Renta" default="ISR" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cfset rsReporte 		 = GetInfoNomina(#session.Ecodigo#,Arguments.DEid,Arguments.RCNid)>
        <cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>

        <cfset vCadenaOriginal ="">
        <cfloop query="rsReporte">
            <cfoutput>
            <cfset vsNombre = trim(#rsReporte.Ape1#)>
            <cfif len(trim(#rsReporte.Ape2#))>
                <cfset vsNombre = #vsNombre# &' '& trim(#rsReporte.Ape2#)>
            </cfif>
            <cfif len(trim(#rsReporte.Nombre#))>
                <cfset vsNombre = #vsNombre# &' '& trim(#rsReporte.Nombre#)>
            </cfif>

            <cfset rsSalarioEmpleado = GetSalarioEmpleado(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfif rsReporte.Mcodigo eq rsLugarExpedicion.Mcodigo>
                <cfset TipoCambio ="1">
            <cfelse>
                <cfset TipoCambio ="">
            </cfif>
            <cfquery name="rsCalendarioPago" datasource="#Session.DSN#">
                select coalesce(RCDescripcion,'') as RCDescripcion
                from #vRCalculoNomina#
                where RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.IdNomina#">
            </cfquery>

            <cfset rsPercepciones = GetPercepciones(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset PercepcionesGrab = 0>
            <cfset PercepcionesExe  = 0>
            <cfloop query="rsPercepciones">
                <cfset PercepcionesGrab = #PercepcionesGrab# + #rsPercepciones.ImporteGravado#>
                <cfset PercepcionesExe  = #PercepcionesExe# + #rsPercepciones.ImporteExento#>
            </cfloop>

            <cfset rsDeducciones = GetDeducciones(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset DeduccionesGrab = 0>
            <cfset DeduccionesExe  = 0>
            <cfloop query="rsDeducciones">
                <cfset DeduccionesGrab = #DeduccionesGrab# + #rsDeducciones.ImporteGravado#>
                <cfset DeduccionesExe  = #DeduccionesExe# + #rsDeducciones.ImporteExento#>
            </cfloop>

        <!---    <cfset vTasa = 0>
            <cfquery name="rsTasaISR" datasource="#session.dsn#">
                select i.IRcodigo,e.EIRdesde,e.EIRhasta,d.DIRinf,d.DIRsup,d.DIRporcentaje
                from dbo.ImpuestoRenta i
                inner join EImpuestoRenta e
                on e.IRcodigo=i.IRcodigo
                inner join DImpuestoRenta d
                on e.EIRid=d.EIRid
                where
                    i.IRcodigo = '#rsFechas.IRcodigo#'  and
                    '#rsReporte.fechaPago#' between e.EIRdesde and e.EIRhasta and
                    #rsIngrGrab.montoGrab#+#rsSalarioEmpleado.SEsalariobruto# between d.DIRinf and d.DIRsup
            </cfquery>
            <cfif rsTasaISR.RecordCount gt 0>
                <cfset vTasa = #rsTasaISR.DIRporcentaje#>
            </cfif>

            <cfset vTasa = #LSNumberFormat(vTasa,'_.00')#>
        --->

			<cfset rsAusentismos = fnAusentismos(#rsReporte.IdNomina#,#rsReporte.DEid#)>
            <cfloop query = "rsAusentismos">
                <cfset DeduccionesGrab = #DeduccionesGrab# + #rsAusentismos.ImporteGravado#>
                <cfset DeduccionesExe  = #DeduccionesExe# + (#rsAusentismos.PEsaldiario#*#rsAusentismos.PEcantdias#)>
            </cfloop>

            <cfset rsSalarioSATcod = GetSalarioSATCod()>
            <cfset rsIncapacidad   = GetIncapacidad(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset rsHrsDobles	   = GetHrsDobles(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset rsHrsTriples	   = GetHrsTriples(#rsReporte.DEid#,#rsReporte.IdNomina#)>
        	<cfset rsCargasEmpl    = GetCargasEmpl(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>

			<!--- Cambio de orden en Cadena a la version 3.2 --->
			<!--- Consultas de los diferentes tipos de deducciones --->
			<cfquery name="rsSumCargas" dbtype="query">
				select (sum(ImporteGravado) + sum(IMPORTEEXENTO)) as sumCargas from rsCargasEmpl
			</cfquery>
			<cfquery name="rsSumDeducciones" dbtype="query">
				select sum(IMPORTEEXENTO) as sumDeducciones from rsDeducciones
			</cfquery>
			<cfquery name="rsSumAusentismos" dbtype="query">
				select (sum(PESALDIARIO*PECANTDIAS) + sum(ImporteGravado)) as sumAusentismos from rsAusentismos
			</cfquery>
			<!--- Aqui se realiza la suma del total de las Deducciones --->
			<cfset sumTotDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0) +
								 (IsNumeric(rsSumAusentismos.sumAusentismos) ? rsSumAusentismos.sumAusentismos : 0)+
								 (IsNumeric(rsSalarioEmpleado.ImporteExento) ? rsSalarioEmpleado.ImporteExento : 0)>
			<cfset sumTotOtDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0) +
								 (IsNumeric(rsSumAusentismos.sumAusentismos) ? rsSumAusentismos.sumAusentismos : 0)>
								 <!--- FALTA AGREGAR LA SUMA DE LAS DEDUCCIONES INDEPENDIENTES --->
			<!--- Se suma exento y gravado debido a que viaticos es 100% importe exento --->
			<cfquery name="sumTotOtrosP" datasource="#session.dsn#">
	            select case (sum(coalesce(IMPORTEEXENTO,0))+sum(coalesce(IMPORTEGRAVADO,0)))
	            	when '' then 0
	            	else sum(coalesce(IMPORTEEXENTO,0))+sum(coalesce(IMPORTEGRAVADO,0))
	            	end as importeGravado
	            from #Percepciones# where OtroPago = 1
	        </cfquery>
			<!--- Se obtiene la clave del Estado de a cuerdo a la Direccion de la Oficina a la que pertenece el Empleado --->
			<cfquery name="rsEntFed" datasource="#session.dsn#">
				select top(1)
					e.Eclave
				from
				DatosEmpleado de
				inner join DLaboralesEmpleado dle on de.DEid = dle.DEid
				inner join Oficinas o on o.Ocodigo = dle.Ocodigo and o.Ecodigo = dle.Ecodigo
				inner join Direcciones d on d.id_direccion = o.id_direccion
				inner join Pais p on p.Ppais = d.Ppais
				inner join CSATEstados e on E.Pclave = p.CSATPclave and d.estado = e.CSATdescripcion
				where  de.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
			</cfquery>
			<cfquery name="rsNoCert" datasource="#session.dsn#">
				select NoCertificado from RH_CFDI_Certificados
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfquery name="rsOtrosPagos" datasource="#session.dsn#">
	            select *
	            from #Percepciones# where OTROPAGO = 1
	        </cfquery>
			<cfset totalPercepc = PercepcionesGrab + PercepcionesExe+ rsSalarioEmpleado.SEsalariobruto>
			<cfset importeGravadoOP = (sumTotOtrosP.importeGravado eq '' ? 0 : sumTotOtrosP.importeGravado)>
			<cfset importeExentoSE = (rsSalarioEmpleado.ImporteExento eq '' ? 0 : rsSalarioEmpleado.ImporteExento)>
            <cfset vCadenaOriginal =
            "|"&																									<!---Inicio Cadena--->
            "|"&"3.3"&																								<!---Version--->
            "|"&#DateFormat(now(),'yyyy-MM-ddTHH:mm:00')#&															<!---Fecha--->
            "|"&"N"&																							<!---Tipo Comprobante--->
            "|"&"99"&																							<!---forma de pago--->
            "|"&"#LSNumberformat(totalPercepc+importeGravadoOP,'_.00')#"&											<!---Sub-Total--->
            "|"&"#LSNumberformat(sumTotDeduc,'_.00')#"&																<!---Descuento--->
            <!--- "|"&"#TipoCambio#"&																						<!---Tipo de Cambio---> --->
            "|"&trim(#rsLugarExpedicion.Miso4217#)&																	<!---Moneda--->
            "|"&"#LSNumberformat((totalPercepc+importeGravadoOP-rsSalarioEmpleado.ImporteExento)-sumTotOtDeduc,'_.00')#"&				<!---Total--->
            "|"&"PUE"&																								<!---Metodo de Pago--->
            "|"&trim(#rsLugarExpedicion.LugarExpedicion#)&															<!---LugarExpedicion--->
			<!--- EMISOR --->
            "|"&#trim(rsLugarExpedicion.Eidentificacion)#&															<!---RFCEmisor--->
            "|"&trim(#rsLugarExpedicion.Enombre#)&																	<!---NombreEmisor--->

			<!--- SubNodo EMISOR-DOMICILIO FISCAL --->
			<!--- SubNodo EMISOR-REGIEMN FISCAL --->
            "|"&trim(#rsLugarExpedicion.codigo_RegFiscal#)&															<!---Regimen--->
			<!--- RECEPTOR --->
            "|"&trim(#rsReporte.RFC#)&																				<!---RFCReceptor--->
            "|"&#vsNombre#&																							<!---NombreReceptor--->
			<!--- CONCEPTOS --->
            "|"&"1"&																								<!---Cantidad--->
            "|"&"ACT"&																								<!---Unidad--->
            "|"&"Pago de nómina"&																					<!---Descripcion--->
            "|"&"#LSNumberformat(importeGravadoOP+totalPercepc,'_.00')#"&		<!---valorUnitario--->
            "|"&"#LSNumberformat(importeGravadoOP+totalPercepc,'_.00')#"&		<!---importe--->
			<!--- IMPUESTOS --->
			<!--- COMPLEMENTO --->
            "|"&"1.2"&																								<!---Versión del Complemento--->
			"|"&"#trim(rsReporte.TipoNomina)#"&																		<!--- TIPO DE NOMINA --->
            "|"&"#DateFormat(rsReporte.fechaPago,'yyyy-mm-dd')#"&													<!---Fecha de Pago--->
            "|"&"#DateFormat(rsReporte.fechaDesde,'yyyy-mm-dd')#"&													<!---Fecha Inicial de Pago--->
            "|"&"#DateFormat(rsReporte.fechaHasta,'yyyy-mm-dd')#"&													<!---Fecha Final de Pago--->
            "|"&"#rsReporte.DiasLab#">																				<!---NumDiasPagados--->
			<cfif totalPercepc gt 0>
				<cfset vCadenaOriginal &= "|"&"#totalPercepc#">														<!--- Total Percepciones --->
			</cfif>
			<cfif sumTotDeduc gt 0>
				<cfset vCadenaOriginal &= "|"&"#LSNumberformat(sumTotDeduc,'_.00')#">								<!--- Total Deducciones --->
			</cfif>
			<cfif sumTotOtrosP.RecordCount gt 0>
				<cfset vCadenaOriginal &= "|"&"#LSNumberformat(importeGravadoOP,'_.00')#">				<!--- Total Otros Pagos --->
			</cfif>
			<!--- EMISOR --->
			<cfif isDefined('curpPFisica')>
				<cfset vCadenaOriginal &= "|"&"#curpPFisica.Pvalor#">												<!--- CURP Persona Fisica --->
			</cfif>
			<cfset vCadenaOriginal &= "|"&"#trim(rsReporte.RegistroPatronal)#">										<!--- RegistroPatronal --->
			<!--- RECEPTOR --->
			<cfset vCadenaOriginal &=
            "|"&"#trim((rsReporte.CURP))#"&																			<!---CURP--->
            "|"&"#trim((rsReporte.NumSeguridadSocial))#"&															<!---Numero Seguridad Social--->
            "|"&"#DateFormat(rsReporte.FechaInicioRelLaboral,'yyyy-mm-dd')#"&										<!---FechaInicioRelLaboral--->
            "|"&"P#rsReporte.Antiguedad#W"&																			<!---Antiguedad--->
            "|"&"#trim((rsReporte.TipoContrato))#">																	<!---Tipo Contrato--->
			<cfif rsReporte.DESindicalizado eq 1>
				<cfset vCadenaOriginal &="|"&"Sí">																	<!--- Sindicalizado --->
			</cfif>
            <cfset vCadenaOriginal &= "|"&"#trim((rsReporte.TipoJornada))#"&										<!---Tipo Jornada--->
            "|"&"#trim(rsReporte.TipoRegimen)#"&																	<!---Tipo Regimen--->
			"|"&"#trim((rsReporte.Identificacion))#"&																<!---NumEmpleado--->
            "|"&"#trim(rsReporte.Departamento)#"&																	<!---Departamento--->
            "|"&"#trim((rsReporte.Puesto))#"&																		<!---Puesto--->
            "|"&"#rsReporte.RiesgoPuesto#"&																			<!---Riesgo Puesto--->
            "|"&"#trim((rsReporte.PeriodicidadPago))#"&																<!---Periodicidad Pago--->
            "|"&"#LSNumberformat(rsReporte.SalarioBaseCotApor,'_.00')#"&											<!---SalarioBaseCotApor--->
            "|"&"#LSNumberformat(rsReporte.SalarioDiarioIntegrado,'_.00')#"&									<!---Salario Diario Integrado--->
			"|"&"#trim(rsEntFed.Pclave)#"&																			<!--- Clave Entidad Federativa --->
			<!--- PERCEPCIONES --->
			"|"&"#LSNumberformat(PercepcionesExe+PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto,'_.00')#"&		<!--- Total Sueldos --->
            "|"&"#LSNumberformat((PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto),'_.00')#"&				<!---Percepciones TotalGravado--->
            "|"&"#LSNumberformat(PercepcionesExe,'_.00')#"&													<!---Percepciones Total Exento--->

            "|"&"#rsSalarioSATcod.RHCSATcodigo#"&																	<!---Tipo Percepción--->
            "|"&"#trim(rsSalarioSATcod.CScodigo)#"&																	<!---Clave Percepción--->
            "|"&"#trim(rsSalarioSATcod.CSdescripcion)#"&															<!---Descripción Percepción--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEsalariobruto,'_.00')#"&										<!---Importe Gravado Percepción--->
            "|"&"0.00">																								<!---Importe Exento Percepción--->
            <cfloop query = "rsPercepciones">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsPercepciones.TipoPercepcion)#"& 														<!---Tipo Percepción--->
                "|"&"#trim(rsPercepciones.Clave)#"&																	<!---Clave Percepción--->
                "|"&"#trim(rsPercepciones.Concepto)#"&																<!---Concepto Percepción--->
                "|"&"#LSNumberformat(rsPercepciones.ImporteGravado,'_.00')#"&										<!---Importe Gravado Percepción--->
                "|"&"#LSNumberformat(rsPercepciones.ImporteExento,'_.00')#">										<!---Importe Exento Percepción--->
            </cfloop>

			<!--- DEDUCCIONES --->
            <cfset vCadenaOriginal = #vCadenaOriginal#&
            "|"&"#LSNumberformat(sumTotOtDeduc,'_.00')#">
			<cfif rsSalarioEmpleado.ImporteExento neq 0.00>
	       		<cfset vCadenaOriginal &=
	       		"|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"&											<!---TotalImpuestosRetenidos--->
				"|"&"002"&																								<!---Tipo Deducción--->
	            "|"&"#right(('000000000000000'&trim(LB_Renta)),15)#"&													<!---Clave Deducción--->
	            "|"&"#LB_Renta#"&																						<!---Descripcion Deduccion--->
	            "|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#">
			</cfif>														<!---Total Deducciones--->
            <cfloop query = "rsCargasEmpl">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsCargasEmpl.TipoDeduccion)#"& 															<!---Tipo Deducción--->
                "|"&"#trim(rsCargasEmpl.Clave)#"&																	<!---Clave Deducción--->
                "|"&"#trim(rsCargasEmpl.Concepto)#"&																<!---Concepto Deducción--->
                "|"&"#LSNumberformat(rsCargasEmpl.ImporteGravado + rsCargasEmpl.ImporteExento,'_.00')#">			<!--- Importe--->
            </cfloop>
            <cfloop query = "rsDeducciones">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsDeducciones.TipoDeduccion)#"& 															<!---Tipo Deducción--->
                "|"&"#trim(rsDeducciones.Clave)#"&																	<!---Clave Deducción--->
                "|"&"#trim(rsDeducciones.Concepto)#"&																<!---Concepto Deducción--->
                "|"&"#LSNumberformat(rsDeducciones.ImporteGravado+rsDeducciones.ImporteExento,'_.00')#">			<!---Importe--->
            </cfloop>

			<!--- OTROS PAGOS --->
			<cfif isdefined("rsOtrosPagos") and rsOtrosPagos.RecordCount gt 0>
				<!--- <cfif rsSalarioEmpleado.SEDEDUCCIONES neq 0.00 and rsSalarioEmpleado.ImporteExento eq 0.00>
					<cfset vCadenaOriginal &=
							"|"&"002"
							"|"&"000000000000D02"
							"|"&"Subsidio para el empleo"
							"|"&"#LSNumberFormat(rsSalarioEmpleado.SEDEDUCCIONES,'_.00')#"
					>
				</cfif> --->
				<cfloop query="rsOtrosPagos">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
					"|"&"#trim(rsOtrosPagos.TIPOPERCEPCION)#"&														<!--- Tipo Otro Pago --->
					"|"&"#trim(rsOtrosPagos.CLAVE)#"&																<!--- Clave Otro Pago --->
					"|"&"#trim(rsOtrosPagos.CONCEPTO)#"&															<!--- Concepto Otro Pago --->
					"|"&"#LSNumberFormat(rsOtrosPagos.IMPORTEEXENTO+rsOtrosPagos.IMPORTEGRAVADO,'_.00')#">			<!--- Importe Otro Pago --->
					<!--- Validacion en base a la clave de catalogos del SAT OtrosPagos --->
					<cfif trim(rsOtrosPagos.TIPOPERCEPCION) eq '002'>
						<cfset vCadenaOriginal = #vCadenaOriginal#&"|"&"#LSNumberFormat(rsOtrosPagos.IMPORTEGRAVADO,'_.00')#">
					</cfif>
            </cfloop>
			</cfif>
            <cfloop query ="rsIncapacidad">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#LSNumberformat(rsIncapacidad.PEcantdias,'_.00')#"& 										<!---DiasIncapacidad--->
                "|"&"#rsIncapacidad.RHIncapcodigo#"&															<!---Tipo Incapacidad--->
                "|"&"#LSNumberformat(rsIncapacidad.Descuento,'_.00')#">											<!---Descuento--->
            </cfloop>

           <!---  <cfloop query = "rsAusentismos">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsAusentismos.RHCSATcodigo)#"& 															<!---Tipo Ausentismo--->
                "|"&"#trim(rsAusentismos.TDcodigo)#"&																<!---Clave Ausentismo--->

                "|"&"#trim(rsAusentismos.RHTdesc)#"&																<!---Concepto Ausentismo--->
                "|"&"#LSNumberformat(rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias,'_.00')#">					<!---Importe--->
            </cfloop> --->

            <cfset vCadenaOriginal = #vCadenaOriginal#&"||"> 														<!---Fin de Cadena--->

            </cfoutput>
        </cfloop>

        <cfset vCadenaOriginal = cleanXML(vCadenaOriginal)>

        <cfreturn vcadenaOriginal>
    </cffunction>
<!--- FIN - Generacion de CadenaOriginal para Recibo de Nomina --->

<!--- INICIA - Generacion de XML para Recibo de Nomina --->
    <cffunction name="XML32ReciboNominaCFDI" access="public" returntype="string">
        <cfargument name="DEid"     	type="numeric" 	required="yes">
        <cfargument name="RCNid" 	    type="numeric" 	required="yes">
        <cfargument name="sello" 		type="string" 	required="yes">
        <cfargument name="Retimbrar"    type="boolean" 	required="yes" default="false">

        <cfinvoke key="LB_Renta" default="ISR" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cfset rsCertificado 		= GetCertificado()>

        <cfset rsReporte 		    = GetInfoNomina(#session.Ecodigo#,Arguments.DEid,Arguments.RCNid)>
        <cfset rsLugarExpedicion    = GetLugarExpedicion(#session.Ecodigo#)>
        <cfset xml32 ="">
        <cfloop query="rsReporte">

            <cfoutput>
            <cfset vsNombre = trim(#rsReporte.Ape1#)>
            <cfif len(trim(#rsReporte.Ape2#))>
                <cfset vsNombre = #vsNombre# &' '& trim(#rsReporte.Ape2#)>
            </cfif>
            <cfif len(trim(#rsReporte.Nombre#))>
                <cfset vsNombre = #vsNombre# &' '& trim(#rsReporte.Nombre#)>
            </cfif>
            <cfset vsNombre = fnSecuenciasEscape(#vsNombre#)>

			<!--- OPARRALES 2018-10-22 Validaciones para Datos Empleado --->
			<cfif Trim(rsReporte.CURP) eq ''>
				<cfthrow detail="La CURP no se ha configurado para el empleado #vsNombre#" message="DATOS EMPLEADO: ">
			</cfif>

			<cfif Trim(rsReporte.RFC) eq ''>
				<cfthrow detail="No se ha configurado el RFC para el empleado #vsNombre#" message="DATOS EMPLEADO: ">
			</cfif>

			<cfif Trim(rsReporte.NumSeguridadSocial) eq ''>
				<cfthrow detail="No se ha configurado el NSS para el empleado #vsNombre#" message="DATOS EMPLEADO: ">
			</cfif>

			<cfif Trim(rsReporte.TipoRegimen) eq '' or rsReporte.TipoRegimen eq 0>
				<cfthrow detail="No se ha configurado el Regimen de Contrataci&oacute;n para el empleado #vsNombre#" message="DATOS EMPLEADO: ">
			</cfif>

            <cfset rsSalarioEmpleado = GetSalarioEmpleado(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfif rsReporte.Mcodigo eq rsLugarExpedicion.Mcodigo>
                <cfset TipoCambio ="1">
            <cfelse>
                <cfset TipoCambio ="">
            </cfif>
            <cfquery name="rsCalendarioPago" datasource="#Session.DSN#">
                select coalesce(RCDescripcion,'') as RCDescripcion
                from #vRCalculoNomina#
                where RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.IdNomina#">
            </cfquery>

            <cfset rsPercepciones = GetPercepciones(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>
			<cfquery name="rsOtrosPagos" datasource="#session.dsn#">
	            select *
	            from #Percepciones# where OtroPago = 1
	        </cfquery>

	        <cfset varSubsCaus = 0>
	        <cfquery name="rsImpCaus" datasource="#session.dsn#">
				select
					RHSvalor
				from
					HRHSubsidio
				where
					RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.IdNomina#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsImpCaus.RecordCount gt 0>
				<cfset varSubsCaus= LSNumberFormat(rsImpCaus.RHSvalor,'9.00')>
			</cfif>

            <cfset PercepcionesGrab = 0>
            <cfset PercepcionesExe  = 0>
            <cfloop query="rsPercepciones">
                <cfset PercepcionesGrab = #PercepcionesGrab# + #rsPercepciones.ImporteGravado#>
                <cfset PercepcionesExe  = #PercepcionesExe# + #rsPercepciones.ImporteExento#>
            </cfloop>

            <cfset rsDeducciones = GetDeducciones(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfquery name="rsOtrosPagosDeducciones" datasource="#session.dsn#">
                select ABS(ImporteExento) as VImporteExento,* from #Deducciones# where OtroPago = 1 and TipoDeduccion in ('001','005')
            </cfquery>
            <cfset totalOtrosPagosDeducciones = 0>
             <cfloop query="rsOtrosPagosDeducciones">
                <cfset totalOtrosPagosDeducciones +=  rsOtrosPagosDeducciones.VImporteExento>
            </cfloop>

            <cfquery name="rsDeducciones" datasource="#session.dsn#">
                select * from #Deducciones# where (OtroPago = 0 and TipoDeduccion not in ('001')) or (OtroPago = 1 and TipoDeduccion not in ('005'))
            </cfquery>

            <cfset DeduccionesGrab = 0>
            <cfset DeduccionesExe  = 0>
            <cfloop query="rsDeducciones">
                <cfset DeduccionesGrab = #DeduccionesGrab# + #rsDeducciones.ImporteGravado#>
                <cfset DeduccionesExe  = #DeduccionesExe# + #rsDeducciones.ImporteExento#>
            </cfloop>

            <cfset rsAusentismos = fnAusentismos(#rsReporte.IdNomina#,#rsReporte.DEid#)>
			<!---
            <cfloop query = "rsAusentismos">
                <cfset DeduccionesGrab = #DeduccionesGrab# + #rsAusentismos.ImporteGravado#>
                <cfset DeduccionesExe  = #DeduccionesExe# + (#rsAusentismos.PEsaldiario#*#rsAusentismos.PEcantdias#)>
            </cfloop>
			 --->


       <!---     <cfset vTasa = 0>
            <cfquery name="rsTasaISR" datasource="#session.dsn#">
                select i.IRcodigo,e.EIRdesde,e.EIRhasta,d.DIRinf,d.DIRsup,d.DIRporcentaje
                from dbo.ImpuestoRenta i
                inner join EImpuestoRenta e
                on e.IRcodigo=i.IRcodigo
                inner join DImpuestoRenta d
                on e.EIRid=d.EIRid
                where
                    i.IRcodigo = '#rsFechas.IRcodigo#'  and
                    '#rsReporte.fechaPago#' between e.EIRdesde and e.EIRhasta and
                    #rsIngrGrab.montoGrab#+#rsSalarioEmpleado.SEsalariobruto# between d.DIRinf and d.DIRsup
            </cfquery>
            <cfif rsTasaISR.RecordCount gt 0>
                <cfset vTasa = #rsTasaISR.DIRporcentaje#>
            </cfif>
            <cfset vTasa = #LSNumberFormat(vTasa,'_.00')#>
        --->
            <cfset rsSalarioSATcod = GetSalarioSATCod()>
            <cfset rsIncapacidad   = GetIncapacidad(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset rsHrsDobles	   = GetHrsDobles(#rsReporte.DEid#,#rsReporte.IdNomina#)>
            <cfset rsHrsTriples	   = GetHrsTriples(#rsReporte.DEid#,#rsReporte.IdNomina#)>
        	<cfset rsCargasEmpl    = GetCargasEmpl(#session.Ecodigo#,#rsReporte.DEid#,#rsReporte.IdNomina#)>

			<cfset vNumCertificado = "#rsCertificado.NoCertificado#">
            <cfset vSello = "#sello#">
            <cfset vCertificado = "#rsCertificado.certificado#">

			<!--- Consultas de los diferentes tipos de deducciones --->
			<cfquery name="rsSumCargas" dbtype="query">
				select (sum(ImporteGravado) + sum(IMPORTEEXENTO)) as sumCargas from rsCargasEmpl
            </cfquery>
           
            <cfquery name="rsSumDeducciones" datasource="#session.dsn#">
               select Sum(IMPORTEEXENTO) as sumDeducciones  from #Deducciones# 
               where OtroPago = 0 and TipoDeduccion not in ('001','002')
               or OtroPago = 1 and TipoDeduccion not in ('005')
            </cfquery>

            <!--- La suma de deducciones con clave 002 en rsDeducciones --->
            <cfset  varDecucciones= 0>
            <cfloop query ="rsDeducciones">
                <cfif rsDeducciones.TipoDeduccion eq '002'>
                    <cfset varDecucciones+=rsDeducciones.ImporteExento>
                </cfif>
            </cfloop>

			<!--- Los montos ausentismos no se consideran ya que vienen descontado en la percepcion de salario empleado
					solo entran en juego los dias de pago.
			<!--- <cfquery name="rsSumAusentismos" dbtype="query">
				select (sum(PESALDIARIO*PECANTDIAS) + sum(ImporteGravado)) as sumAusentismos from rsAusentismos
			</cfquery> --->
			<!--- Aqui se realiza la suma del total de las Deducciones --->
			<cfset sumTotDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0) +
								 (IsNumeric(rsSumAusentismos.sumAusentismos) ? rsSumAusentismos.sumAusentismos : 0)+
								 (IsNumeric(rsSalarioEmpleado.ImporteExento) ? rsSalarioEmpleado.ImporteExento : 0)>
			<cfset sumTotOtDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0) +
								 (IsNumeric(rsSumAusentismos.sumAusentismos) ? rsSumAusentismos.sumAusentismos : 0)>
			 --->
			<cfset sumTotDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0) +
                                 (IsNumeric(rsSalarioEmpleado.ImporteExento) ? rsSalarioEmpleado.ImporteExento : 0) +
                                 (IsNumeric(varDecucciones) ? varDecucciones : 0)>
                                 
			<cfset sumTotOtDeduc = (IsNumeric(rsSumCargas.sumCargas)? rsSumCargas.sumCargas : 0) +
								 (IsNumeric(rsSumDeducciones.sumDeducciones)? rsSumDeducciones.sumDeducciones : 0)>
            
								 <!--- FALTA AGREGAR LA SUMA DE LAS DEDUCCIONES INDEPENDIENTES --->
            <!--- Se suma exento y gravado debido a que viaticos es 100% importe exento --->
			<cfquery name="sumTotOtrosP" datasource="#session.dsn#">
	            select (sum(coalesce(IMPORTEEXENTO,0))+sum(coalesce(IMPORTEGRAVADO,0))) as importeGravado
	            from #Percepciones# where OtroPago = 1
	        </cfquery>
			<!--- Se obtiene la clave del Estado de a cuerdo a la Direccion de la Oficina a la que pertenece el Empleado --->

			<cfquery name="rsEntFed" datasource="#session.dsn#">
				select top(1)
					e.Pclave
				from DatosEmpleado de
				inner join DLaboralesEmpleado dle on de.DEid = dle.DEid
				inner join Oficinas o on o.Ocodigo = dle.Ocodigo and o.Ecodigo = dle.Ecodigo
				inner join Direcciones d on d.id_direccion = o.id_direccion
				inner join Pais p on p.Ppais = d.Ppais
				inner join CSATEstados e on E.Pclave = p.CSATPclave and d.estado = e.CSATdescripcion
				where  de.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
			</cfquery>

			<cfset importeGravadoOP = (sumTotOtrosP.importeGravado eq '' ? 0 : sumTotOtrosP.importeGravado)>
			<cfset totalPercepc = PercepcionesGrab + PercepcionesExe+ rsSalarioEmpleado.SEsalariobruto >
			<cfset fechaEmision = now()>
			<cfset session.fechaEmision = fechaEmision>

			<cfset varDiasAguinaldo = 1>

			<cfif rsReporte.CPTipoCalRenta eq 2>
				<cfquery datasource="#session.dsn#" name="rsDiasAg">
					Select
						ICvalor
					from
						HIncidenciasCalculo
					where
						RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
					order by ICvalor desc
				</cfquery>
				<cfset varDiasAguinaldo = rsDiasAg.ICvalor>
			</cfif>

			<!--- OPARRALES 2019-01-14
				- Modificacion para restar las Acciones de ausentismos y
				- las Incidencias de Horas Falta a los dias laborados.
			 --->
			<cfquery name="rsFaltas" datasource="#session.dsn#">
				select
					pe.DEid,
					sum((DateDiff(day,lt.LTdesde,LThasta)+1) * ta.RHTfactorfalta) as dias
				from
					HRCalculoNomina rc
				inner join HPagosEmpleado pe
					on rc.RCNid = pe.RCNid
				inner join RHTipoAccion ta
					on pe.RHTid = ta.RHTid
				inner join LineaTiempo lt
					on lt.LTid = pe.LTid
					and lt.DEid = pe.DEid
				where
					rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="13">
				and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
				and rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				group by pe.DEid
			</cfquery>
			<cfset lvarFaltasDias = (Trim(rsFaltas.dias) neq '' ? rsFaltas.dias : 0)>

			<cfquery name="rsIncFaltas" datasource="#session.dsn#">
				select
					ic.ICvalor
				from HIncidenciasCalculo ic
				inner join CIncidentes ci
				on ci.CIid = ic.CIid
				where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
				and ci.CIcodigo = '04'
			</cfquery>
			<cfset varHrsToDias = (rsIncFaltas.ICvalor gt 0 ? ((rsIncFaltas.ICvalor * 1.1) / 8) : 0)>

			<cfquery name="rsDiasCP" datasource="#session.dsn#">
				select
					(DateDiff(day,RCdesde,RChasta)+1) as DiasCP
				from
					HRCalculoNomina rc
				where
					rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
            
            <cfquery name="rsCantDiasMensual" datasource="#session.dsn#">
                select 
                    FactorDiasSalario, FactorDiasIMSS, IRcodigo, TtipoPago
                from TiposNomina
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporte.Tcodigo#">
            </cfquery>
            <cfif len(trim(rsCantDiasMensual.FactorDiasSalario)) and rsCantDiasMensual.FactorDiasSalario gt 0>
                <cfset CantDiasMensual = rsCantDiasMensual.FactorDiasSalario >
            <cfelse>
                <cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
            </cfif>

            <!---si no viene definido ninguno de los 2 valores usa el que se define en parametros generales para ambas variables--->
            <cfif len(trim(rsCantDiasMensual.FactorDiasIMSS)) and rsCantDiasMensual.FactorDiasIMSS gt 0>
                <cfset CantDiasMensualIMSS = rsCantDiasMensual.FactorDiasIMSS >
            <cfelse>
                <cfset CantDiasMensualIMSS = #CantDiasMensual# >
            </cfif>
            
            <cfset lvarDiasXCal = rsDiasCP.DiasCP>

            <!--- SE reasigna solo para nominas quincenales --->
            <cfif rsCantDiasMensual.TtipoPago eq 2>
                <cfset lvarDiasXCal = CantDiasMensualIMSS>
            </cfif>

            <cfquery name="rsFecCP" datasource="#session.dsn#">
				select
					RCdesde,RChasta
				from
					HRCalculoNomina rc
				where
					rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and rc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

            <!--- OPARRALES 2018-01-13
				- Se agrega validacion para buscar empleados dados de alta despues de la fecha inicio del calendario de pago
				- Si existen empleados se saca los dias trabajados de fecha de alta vs Fecha fin de pago
			 --->
			<cfquery name="rsLTAlta" datasource="#session.dsn#">
				select top 1 lt.LTdesde from LineaTiempo lt
				inner join RHTipoAccion ta
					on ta.RHTid = lt.RHTid
					and ta.Ecodigo = lt.Ecodigo
				where
					lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
				and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ta.RHTcomportam = 1 <!--- Accion de Tipo Nombramiento --->
				and lt.LTdesde
					between <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecCP.RCdesde#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecCP.RChasta#">
				AND lt.BMUsucodigo is not null
				order by lt.LTdesde desc
			</cfquery>

			<cfset diasSinLab = 0>
			<cfif rsLTAlta.RecordCount gt 0>                
                <cfset varDiasP = 0>
				<cfset varDiasP = (DateDiff("d",rsFecCP.RCdesde,rsFecCP.RChasta) + 1) - (DateDiff("d",rsLTAlta.LTdesde,rsFecCP.RChasta) + 1)>
				<cfset lvarDiasXCal = CantDiasMensualIMSS - varDiasP>
			</cfif>
            
            <cfset lVarDiasCP = lvarDiasXCal - varHrsToDias - lvarFaltasDias>

            <!--- OPARRALES 2019-03-14 Restamos dias de incapacidad --->
            <cfif rsIncapacidad.RecordCount gt 0>
                <cfloop query="rsIncapacidad">
                    <cfset lVarDiasCP -= rsIncapacidad.PEcantdias>
                </cfloop>
            </cfif>

            <!--- OPARRALES 2019-03-21 Modificacion para dias laborados resultante a cero por motivos de formula --->
            <cfif lVarDiasCP lte 0>
                <cfset lVarDiasCP = 0.1>
            </cfif>
            
            <!--- Obtener Historico de SDI segun el calendario de pago --->

			<!--- Obtener Salario Diario --->
			<cfquery name="rsSalario" datasource="#session.dsn#">
				select
					PEsalario
				from
					HPagosEmpleado
				where
					DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
			<cfquery name="rsFactorNomina" datasource="#session.dsn#">
				select
					FactorDiasSalario
				from
					TiposNomina
				where
					Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporte.Tcodigo#">
			</cfquery>
            <cfset varSD = rsSalario.PEsalario neq "" ? rsSalario.PEsalario: 0 / rsFactorNomina.FactorDiasSalario>

            <cfif Arguments.Retimbrar>
                <cfquery name="rsAnterior" datasource="#session.dsn#">
                    select
                        timbre 
                    from 
                        RH_CFDI_RecibosNomina
                    where 
                        DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporte.DEid#">
                    and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    and stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                </cfquery>
            </cfif>
			<cfset rsSaldosAFavor= GetCompensacionSaldosAFavor(Arguments.DEid,Arguments.RCNid)>
				<cfset importeGravadoTmp=0>
				<cfset SaldoFavorTemp=0>
			   <cfif rsSaldosAFavor.RecordCount gt 0> 
					<cfset importeGravadoTmp=sumTotOtrosP.importeGravado neq '' ? sumTotOtrosP.importeGravado:0>
					<cfset SaldoFavorTemp=rsSaldosAFavor.SaldoFavor neq '' ? rsSaldosAFavor.SaldoFavor:0>
				</cfif>

            <CFXML VARIABLE="xml32">
            <Comprobante
				Version="3.3"
				Serie="#trim(fnSecuenciasEscape(rsReporte.Identificacion))#"
				Fecha="#Trim(fechaEmision)#"
				Sello="#vSello#"
				Folio="#Trim(fnSecuenciasEscape(rsReporte.CodigoNomina))#-#Minute(Now())#-#Second(Now())#"
				FormaPago="99"
				NoCertificado="#vNumCertificado#"
                Certificado="#vCertificado#" 
                SubTotal="#LSNumberformat((totalPercepc eq '0'?0:totalPercepc)+(sumTotOtrosP.importeGravado eq '' ? 0:sumTotOtrosP.importeGravado),'_.00')+SaldoFavorTemp+totalOtrosPagosDeducciones#"
				<cfif sumTotDeduc gt 0>
					Descuento="#LSNumberformat(sumTotDeduc,'_.00')#"
				</cfif>
				<!--- TipoCambio="#TipoCambio#" --->
				Moneda="#trim(fnSecuenciasEscape(rsLugarExpedicion.Miso4217))#"
				<cfset varTotal = (sumTotOtrosP.importeGravado eq '' ? 0 :sumTotOtrosP.importeGravado)+(totalPercepc eq ''?0: totalPercepc)+SaldoFavorTemp+totalOtrosPagosDeducciones>
                <cfset varTotal -= sumTotDeduc>
				Total="#LSNumberformat(varTotal,'_.00')#"
				TipoDeComprobante="N"
				MetodoPago="PUE"
				LugarExpedicion="#trim(fnSecuenciasEscape(rsLugarExpedicion.LUGAREXPEDICION))#"
				xmlns:cfdi="http://www.sat.gob.mx/cfd/3"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:nomina12="http://www.sat.gob.mx/nomina12"
				xsi:schemaLocation="http://www.sat.gob.mx/cfd/3
				http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv33.xsd
				http://www.sat.gob.mx/nomina12 http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina12.xsd">
               
			   
			   
                <cfif Arguments.Retimbrar and IsDefined('rsAnterior') and rsAnterior.RecordCount gt 0>
                    <cfdi:CfdiRelacionados TipoRelacion="04">
                        <cfdi:CfdiRelacionado UUID="#rsAnterior.timbre#"/>
                    </cfdi:CfdiRelacionados>
                </cfif>

                <Emisor	Rfc="#trim(rsLugarExpedicion.Eidentificacion)#" Nombre="#trim(fnSecuenciasEscape(rsLugarExpedicion.Enombre))#"
				 RegimenFiscal="#trim(rsLugarExpedicion.codigo_RegFiscal)#"/>
					<!---<DomicilioFiscal pais="#trim(fnSecuenciasEscape(rsLugarExpedicion.Pais))#"/>--->
				<Receptor
					Rfc="#trim(fnSecuenciasEscape(rsReporte.RFC))#"
					Nombre="#vsNombre#"
                    UsoCFDI="P01"/>
                                        
				<Conceptos>
					<Concepto
						ClaveProdServ="84111505"
						Cantidad="1"
						ClaveUnidad="ACT"
						Descripcion="Pago de nómina"
						ValorUnitario="#LSNumberformat(totalPercepc+importeGravadoOP+SaldoFavorTemp+totalOtrosPagosDeducciones,'_.00')#"
						Importe="#LSNumberformat(totalPercepc+importeGravadoOP+SaldoFavorTemp+totalOtrosPagosDeducciones,'_.00')#"
						<cfif sumTotDeduc gt 0>
							Descuento="#LSNumberformat(sumTotDeduc,'_.00')#"
						</cfif>
						/>
				</Conceptos>
				<!--- <Impuestos
					<!--- totalImpuestosRetenidos="#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#">
					<Retenciones>
						<Retencion
						impuesto="ISR"
						importe="#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"/>
					</Retenciones --->
					>
				</Impuestos> --->
				
				
				<Complemento>
					<nomina12:Nomina
						Version="1.2"
						TipoNomina="#trim(rsReporte.TipoNomina)#"
						FechaPago="#DateFormat(rsReporte.fechaPago,'yyyy-mm-dd')#"
						FechaInicialPago="#DateFormat(rsReporte.fechaDesde,'yyyy-mm-dd')#"
						FechaFinalPago="#DateFormat(rsReporte.fechaHasta,'yyyy-mm-dd')#"
						NumDiasPagados="#(rsReporte.CPTipoCalRenta eq 2 ? LSNumberFormat(varDiasAguinaldo,'9.000') : LSNumberFormat(lVarDiasCP,'9.000'))#"
						<cfif totalPercepc gt 0>
							TotalPercepciones="#totalPercepc#"
						</cfif>
						<cfif sumTotDeduc gt 0>
							TotalDeducciones="#LSNumberformat(sumTotDeduc,'_.00')#"
						</cfif>
						
						<cfif sumTotOtrosP.RecordCount gt 0 OR rsSaldosAFavor.RecordCount gt 0> 
						    <cfset importeGravadoTmp=sumTotOtrosP.importeGravado neq '' ? sumTotOtrosP.importeGravado:0>
							<cfset SaldoFavorTemp=rsSaldosAFavor.SaldoFavor neq '' ? rsSaldosAFavor.SaldoFavor:0>
							TotalOtrosPagos="#LSNumberformat(importeGravadoTmp+SaldoFavorTemp+totalOtrosPagosDeducciones,'_.00')#"
						</cfif>
                    >

                        <nomina12:Emisor
                            <cfif isDefined('curpPFisica')>
                                Curp="#curpPFisica.Pvalor#"																			<!--- CURP Persona Fisica --->
                            </cfif>
                            RegistroPatronal="#trim(fnSecuenciasEscape(rsReporte.RegistroPatronal))#"
                            >
                        </nomina12:Emisor>
                        <nomina12:Receptor
                            Curp="#trim(fnSecuenciasEscape(rsReporte.CURP))#"
                            NumSeguridadSocial="#trim(fnSecuenciasEscape(rsReporte.NumSeguridadSocial))#"
                            FechaInicioRelLaboral="#DateFormat(rsReporte.FechaInicioRelLaboral,'yyyy-mm-dd')#"
                            Antigüedad="P#rsReporte.Antiguedad#W"
                            TipoContrato="#trim(fnSecuenciasEscape(rsReporte.TipoContrato))#"
                            <cfif rsReporte.DESindicalizado eq 1>
                                Sindicalizado="Sí"
                            </cfif>
                            TipoJornada="#trim(fnSecuenciasEscape(rsReporte.TipoJornada))#"
                            TipoRegimen="#trim(rsReporte.TipoRegimen)#"
                            NumEmpleado="#trim(fnSecuenciasEscape(rsReporte.Identificacion))#"
                            Departamento="#trim(rsReporte.Departamento)#"
                            Puesto="#trim(fnSecuenciasEscape(rsReporte.Puesto))#"
                            RiesgoPuesto="#rsReporte.RiesgoPuesto#"
                            PeriodicidadPago="#trim(fnSecuenciasEscape(rsReporte.CPTipoCalRenta neq 2 ? rsReporte.PeriodicidadPago : '99'))#"
                            SalarioBaseCotApor="#LSNumberformat(varSD,'_.00')#"
                            SalarioDiarioIntegrado="#LSNumberformat(rsReporte.SalarioDiarioIntegrado,'_.00')#"
                            ClaveEntFed="#trim(rsEntFed.Pclave)#"
                        >
        <!---Banco="#trim(rsReporte.Banco)#"--->
                        </nomina12:Receptor>

                        <nomina12:Percepciones
                            TotalSueldos="#LSNumberformat(PercepcionesExe+PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto,'_.00')#"
                            TotalExento="#LSNumberformat(PercepcionesExe,'_.00')#"
                            TotalGravado="#LSNumberformat(PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto,'_.00')#"
                        >
                            <cfif rsSalarioEmpleado.SEsalariobruto gt 0>
                                <nomina12:Percepcion
                                    TipoPercepcion="#Trim(rsSalarioSATcod.RHCSATcodigo)#"
                                    Clave="#trim(rsSalarioSATcod.CScodigo)#"
                                    Concepto="#trim(rsSalarioSATcod.CSdescripcion)#"
                                    ImporteGravado="#LSNumberformat(rsSalarioEmpleado.SEsalariobruto,'_.00')#"
                                    ImporteExento="0.00"
                                />
                            </cfif>

                            <cfloop query = "rsPercepciones">
                                <Percepcion
                                    TipoPercepcion="#trim(rsPercepciones.TipoPercepcion)#"
                                    Clave="#trim(rsPercepciones.Clave)#"
                                    Concepto="#trim(rsPercepciones.Concepto)#"
                                    ImporteGravado="#LSNumberformat(rsPercepciones.ImporteGravado,'_.00')#"
                                    ImporteExento="#LSNumberformat(rsPercepciones.ImporteExento,'_.00')#"
                                    <cfif trim(rsPercepciones.TipoPercepcion) eq '019'>
                                        >
                                        <cfif rsHrsDobles.RecordCount gt 0 or rsHrsTriples.RecordCount gt 0>
                                            <cfif rsHrsDobles.RecordCount gt 0>
                                                <HorasExtra
                                                    Dias="#LSNumberformat(rsHrsDobles.dias)#"
                                                    TipoHoras="01"
                                                    HorasExtra="#LSNumberformat(rsHrsDobles.horas)#"
                                                    ImportePagado="#LSNumberformat(rsHrsDobles.monto,'_.00')#"/>
                                            </cfif>
                                            <cfif rsHrsTriples.RecordCount gt 0>
                                                <HorasExtra
                                                    Dias="#LSNumberformat(rsHrsTriples.dias)#"
                                                    TipoHoras="02"
                                                    HorasExtra="#LSNumberformat(rsHrsTriples.horas)#"
                                                    ImportePagado="#LSNumberformat(rsHrsTriples.monto,'_.00')#"/>
                                            </cfif>
                                        </cfif>
                                        </Percepcion>
                                    <cfelse>
                                        />
                                    </cfif>
                            </cfloop>
                        </nomina12:Percepciones>
                        <!--- OPARRALES 2018-10-30 Se agrega validacion para nomina de Aguinaldo --->
                        <!--- <cfif rsReporte.CPTipoCalRenta neq 2> --->
								<cfset rsDeduccionISRT = GetDeduccionISR(Arguments.DEid,Arguments.RCNid)>
								<cfset ajusteDeduccion = rsDeduccionISRT.Valor neq ''?rsDeduccionISRT.Valor:0 >
                            <cfif sumTotOtDeduc neq 0 OR (rsSalarioEmpleado.ImporteExento+varDecucciones) neq 0.00>

                            <Deducciones
                                TotalOtrasDeducciones="#LSNumberFormat(sumTotOtDeduc,'9.00')#"
                                <cfif rsSalarioEmpleado.ImporteExento neq 0.00>
                                    TotalImpuestosRetenidos="#LSNumberformat(rsSalarioEmpleado.ImporteExento+varDecucciones,'_.00')#"
                                </cfif>
                                <!--- TotalGravado="#LSNumberformat(DeduccionesGrab,'_.00')#"
                                TotalExento="#LSNumberformat(rsSalarioEmpleado.ImporteExento+rsSalarioEmpleado.SEcargasempleado+DeduccionesExe,'_.00')#"
                                --->
                                >
                                <cfif rsSalarioEmpleado.ImporteExento neq 0.00>
								
                                    <Deduccion
                                        TipoDeduccion="002"
                                        Clave="#right(('000000000000000'&trim(LB_Renta)),15)#"
                                        Concepto="#LB_Renta#"
                                        Importe="#LSNumberformat(rsSalarioEmpleado.ImporteExento+varDecucciones,'_.00')#" 
                                        <!--- ImporteExento="#LSNumberformat(rsSalarioEmpleado.ImporteExento+ajusteDeduccion,'_.00')#"
                                        ImporteGravado="0.00" --->
                                    />
                                </cfif>
                                <cfloop query ="rsCargasEmpl">
                                    <Deduccion
                                        Clave="#trim(rsCargasEmpl.Clave)#"
                                        Concepto="#trim(rsCargasEmpl.Concepto)#"
                                        Importe="#LSNumberformat(rsCargasEmpl.ImporteExento+rsCargasEmpl.ImporteGravado,'_.00')#"
                                        TipoDeduccion="#trim(rsCargasEmpl.TipoDeduccion)#"
                                        <!--- ImporteExento="#LSNumberformat(rsCargasEmpl.ImporteExento,'_.00')#"
                                            ImporteGravado="#LSNumberformat(rsCargasEmpl.ImporteGravado,'_.00')#" --->
                                        />
                                </cfloop>
                                <cfloop query ="rsDeducciones">
                                    <cfif rsDeducciones.TipoDeduccion neq  '002'>
                                        <Deduccion
                                        Clave="#trim(rsDeducciones.Clave)#"
                                        Concepto="#trim(rsDeducciones.Concepto)#"
                                        Importe="#LSNumberformat(rsDeducciones.ImporteExento + rsDeducciones.ImporteGravado,'_.00')#"
                                        TipoDeduccion="#trim(rsDeducciones.TipoDeduccion)#"
                                        <!--- ImporteExento="#LSNumberformat(rsDeducciones.ImporteExento,'_.00')#"
                                        ImporteGravado="#LSNumberformat(rsDeducciones.ImporteGravado,'_.00')#" --->
                                        />
                                    </cfif>
                                </cfloop>
                                <!---
                                <cfloop query = "rsAusentismos">
                                    <cfset totAusent = rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias + rsAusentismos.ImporteGravado>
                                    <Deduccion
                                        Clave="#trim(rsAusentismos.TDcodigo)#"
                                        Concepto="#trim(rsAusentismos.RHTdesc)#"
                                        Importe="#LSNumberformat(rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias,'_.00')#"
                                        TipoDeduccion="#trim(rsAusentismos.RHCSATcodigo)#"
                                        <!--- ImporteExento="#LSNumberformat(rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias,'_.00')#"
                                        ImporteGravado="#LSNumberformat(rsAusentismos.ImporteGravado,'_.00')#" --->
                                        />
                                </cfloop>
                                --->
                            </Deducciones>
							</cfif>
                        <!--- </cfif> --->
						
						
                        <cfif (isdefined("rsOtrosPagos") and rsOtrosPagos.RecordCount gt 0) OR rsSaldosAFavor.RecordCount gt 0 OR rsOtrosPagosDeducciones.RecordCount gt 0>
                            <nomina12:OtrosPagos>
							<cfif (isdefined("rsOtrosPagos") and rsOtrosPagos.RecordCount gt 0)>
                            <!--- <cfif rsSalarioEmpleado.SEDEDUCCIONES neq 0.00 and rsSalarioEmpleado.ImporteExento eq 0.00>
                                <nomina12:OtroPago
                                Clave="000000000000D02"
                                Concepto="Subsidio para el empleo"
                                Importe="#LSNumberFormat(rsSalarioEmpleado.SEDEDUCCIONES,'_.00')#"
                                TipoOtroPago="002">
                                <!--- Validacion en base a la clave de catalogos del SAT OtrosPagos --->
                            </nomina12:OtroPago>
                            </cfif> --->
                                <cfloop query="rsOtrosPagos">
                                    <nomina12:OtroPago
                                        Clave="#trim(rsOtrosPagos.CLAVE)#"
                                        Concepto="#trim(rsOtrosPagos.CONCEPTO)#"
                                        Importe="#LSNumberFormat(rsOtrosPagos.IMPORTEEXENTO+rsOtrosPagos.IMPORTEGRAVADO,'_.00')#"
                                        TipoOtroPago="#trim(rsOtrosPagos.TIPOPERCEPCION)#">
                                        <!--- Validacion en base a la clave de catalogos del SAT OtrosPagos --->
                                        <cfif trim(rsOtrosPagos.TIPOPERCEPCION) eq '002'>
                                            <cfset var_SubsidioCausado = getSubsidioCausado(RCNid=rsOtrosPagos.RCNid,DEid=rsOtrosPagos.DEid)>
                                            <nomina12:SubsidioAlEmpleo
                                            SubsidioCausado="#LSNumberFormat(var_SubsidioCausado,'_.00')#"></nomina12:SubsidioAlEmpleo>
                                        </cfif>
                                    </nomina12:OtroPago>
                                </cfloop>
								</cfif>
								<cfif rsSaldosAFavor.RecordCount gt 0>
								<nomina12:OtroPago TipoOtroPago="#rsSaldosAFavor.Codigo#" Clave="#rsSaldosAFavor.Codigo#" Concepto="#rsSaldosAFavor.Concepto#" Importe="#LSNumberformat(rsSaldosAFavor.SaldoFavor,'_.00')#" >
									<nomina12:CompensacionSaldosAFavor SaldoAFavor="#LSNumberformat(rsSaldosAFavor.SaldoFavor,'_.00')#" Año="#rsSaldosAFavor.Year#" RemanenteSalFav="#LSNumberformat(rsSaldosAFavor.SaldoFavor,'_.00')#" />
								</nomina12:OtroPago>
                                </cfif>
                                
                                <cfif rsOtrosPagosDeducciones.RecordCount gt 0>
                                    <nomina12:OtroPago TipoOtroPago="#trim(rsOtrosPagosDeducciones.TipoDeduccion)#" Clave="#trim(rsOtrosPagosDeducciones.Clave)#" Concepto="#trim(rsOtrosPagosDeducciones.Concepto)#" Importe="#LSNumberformat(rsOtrosPagosDeducciones.VImporteExento,'_.00')#" >

								    </nomina12:OtroPago>
                                </cfif>
								
                            </nomina12:OtrosPagos>
                        <cfelse>
                            <nomina12:OtrosPagos>
							    <nomina12:OtroPago
                                    Clave="000000000000009"
                                    Concepto="Subsidio al Empleo"
                                    Importe="#LSNumberFormat(0,'_.00')#"
                                    TipoOtroPago="002">
                                    <nomina12:SubsidioAlEmpleo SubsidioCausado="#LSNumberFormat(0,'_.00')#"/>
                                </nomina12:OtroPago>								
                            </nomina12:OtrosPagos>
                        </cfif>
                        <cfif rsIncapacidad.RecordCount gt 0>
                            <nomina12:Incapacidades>
                                <cfloop query ="rsIncapacidad">
                                    <nomina12:Incapacidad
                                        DiasIncapacidad="#LSNumberformat(rsIncapacidad.PEcantdias,'_')#"
                                        TipoIncapacidad="#rsIncapacidad.RHIncapcodigo#"
                                        ImporteMonetario="#LSNumberformat(rsIncapacidad.Descuento,'_.00')#" />
                                </cfloop>
                            </nomina12:Incapacidades>
                        </cfif>
		            </nomina12:Nomina>
		        </Complemento>
		    </Comprobante>
            </CFXML>
            </cfoutput>
        </cfloop>
        
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
		<cfset xml32 = replace(#xml32#,"/Percepcion","/nomina12:Percepcion","ALL")>
        <cfset xml32 = replace(#xml32#,"</Percepciones>","</nomina12:Percepciones>")>
        <cfset xml32 = replace(#xml32#,"<Deducciones ","<nomina12:Deducciones ")>
        <cfset xml32 = replace(#xml32#,"<Deduccion ","<nomina12:Deduccion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Deducciones>","</nomina12:Deducciones>")>
        <cfset xml32 = replace(#xml32#,"<Incapacidad ","<nomina12:Incapacidad ","ALL")>
        <cfset xml32 = replace(#xml32#,"<HorasExtra ","<nomina12:HorasExtra ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Nomina>","</nomina12:Nomina>")>
        <cfset xml32 = replace(#xml32#,"</Complemento>","</cfdi:Complemento>")>
        <cfset xml32 = replace(#xml32#,"</Comprobante>","</cfdi:Comprobante>")>
		<cfset xml32 = replace(#xml32#,"Fecha="," Fecha=","ALL")>
		<cfset xml32 = replace(#xml32#,"</HorasExtra>","</nomina12:HorasExtra>","ALL")>

        <!--- <cfset xml32 = cleanXML(xml32)> --->
        <cfreturn xml32>
     </cffunction>
<!--- FIN - Generacion de XML para Recibo de Nomina --->


<!--- INICIA - Funciones privadas para Recibo de Nomina --->

    <cffunction name="GetPercepciones" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>

        <cfset rsFechas = GetFechasCalendario(Arguments.Ecodigo,Arguments.RCNid)>

        <cf_dbtemp name="Percepciones" returnvariable="Percepciones">
            <cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
            <cf_dbtempcol name="RCNid" 			type="int" 			mandatory="no">
            <cf_dbtempcol name="TipoPercepcion"	type="char(10)"     mandatory="no">
            <cf_dbtempcol name="Clave"			type="char(15)"     mandatory="no">
            <cf_dbtempcol name="Concepto"		type="char(60)"     mandatory="no">
            <cf_dbtempcol name="ImporteExento"	type="money"       	mandatory="no">
            <cf_dbtempcol name="ImporteGravado"	type="money"       	mandatory="no">
            <cf_dbtempcol name="Horas" 			type="int" 			mandatory="no">
			<cf_dbtempcol name="OtroPago" 		type="int"			mandatory="no">
        </cf_dbtemp>

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>



        <cfquery datasource="#session.dsn#" name="rsPr">
           insert #Percepciones#(DEid,RCNid,Clave,TipoPercepcion,Concepto,ImporteExento,ImporteGravado,OtroPago)
                select hic.DEid,hic.RCNid,right(('000000000000000'+CI.CIcodigo),15) as CIcodigo,cs.RHCSATcodigo,CI.CIdescripcion,
                case CI.CInorenta
                    when 1 then hic.ICmontores
                    when 0 then 0
                end as ImporteExento,
                case CI.CInorenta
                    when 1 then 0
                    when 0 then hic.ICmontores
                end as ImporteGravado,
				cs.RHCSATOtroPago
                from #vIncidenciasCalculo# hic
                inner join CIncidentes CI
                on hic.CIid=CI.CIid
				and CI.CItimbrar = 0
                inner join LineaTiempo b
                on hic.DEid = b.DEid
                left join RHCFDIConceptoSAT cs
                on CI.RHCSATid = cs.RHCSATid and CI.Ecodigo=cs.Ecodigo
                inner join CalendarioPagos x
                on 	b.Tcodigo = x.Tcodigo
                    and x.CPid = hic.RCNid
                        and ((b.LThasta >= x.CPdesde and b.LTdesde <= x.CPhasta) or (b.LTdesde <= x.CPhasta and b.LThasta >= x.CPdesde))
                        and b.LThasta = (select MAX(c.LThasta) from LineaTiempo c where c.DEid = b.DEid
                        and ((c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#"> and c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">)
                        or (c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#"> and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">))
                        )
                where hic.ICmontores > 0
                and x.CPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                and hic.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and CI.CItimbrar = 0 <!--- Excluir conceptos como el Pago en efectivo --->
        <!---Cuota Sindical, debe sumar en las percepciones--->
                union
                select distinct hic.DEid,hic.RCNid,right(('000000000000000'+CI.TDcodigo),15) as TDcodigo,
				cs.RHCSATcodigo, CI.TDdescripcion, (0-hic.DCvalor),0,
				cs.RHCSATOtroPago
                from #vDeduccionesCalculo# hic
                inner join LineaTiempo b
                on hic.DEid = b.DEid
                inner join DeduccionesEmpleado de
                on hic.Did=de.Did
                left join TDeduccion CI
                on CI.TDid=de.TDid
                inner join CalendarioPagos c
                on hic.RCNid = c.CPid
                and b.Tcodigo = c.Tcodigo
                left join RHCFDIConceptoSAT cs
                on CI.RHCSATid = cs.RHCSATid and CI.Ecodigo=cs.Ecodigo
                inner join CalendarioPagos x
                    on 	b.Tcodigo = x.Tcodigo
                        and x.CPid = hic.RCNid
                where x.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
               		and hic.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
               		and CI.TDcodigo ='06'
        <!---Cuota Sindical, debe sumar en las percepciones--->
        </cfquery>
        <cfquery name="rsPercepciones" datasource="#session.dsn#">
            select *
            from #Percepciones# where OtroPago = 0
        </cfquery>
        <cfreturn rsPercepciones>
    </cffunction>

    <cffunction name="GetDeducciones" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>

        <cfset rsFechas = GetFechasCalendario(Arguments.Ecodigo,Arguments.RCNid)>
        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cf_dbtemp name="Deducciones" returnvariable="Deducciones">
            <cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
            <cf_dbtempcol name="RCNid" 			type="int" 			mandatory="no">
            <cf_dbtempcol name="OtroPago"       type="int" 			mandatory="no">
            <cf_dbtempcol name="TipoDeduccion"	type="char(10)"     mandatory="no">
            <cf_dbtempcol name="Clave"			type="char(15)"     mandatory="no">
            <cf_dbtempcol name="Concepto"		type="char(60)"     mandatory="no">
            <cf_dbtempcol name="ImporteExento"	type="money"       	mandatory="no">
            <cf_dbtempcol name="ImporteGravado"	type="money"       	mandatory="no">
        </cf_dbtemp>

        <cfquery datasource="#session.dsn#" name="aaa">
            insert #Deducciones#(DEid,RCNid,TipoDeduccion,Clave,Concepto,ImporteExento,ImporteGravado,OtroPago)
                select
					distinct hic.DEid,
					hic.RCNid,
					cs.RHCSATcodigo,
					right(('000000000000000'+CI.TDcodigo),15) as TDcodigo,
					CI.TDdescripcion,
					hic.DCvalor,
					0,
                    cs.RHCSATOtroPago
                from #vDeduccionesCalculo# hic
                inner join LineaTiempo b
                on hic.DEid = b.DEid
                inner join DeduccionesEmpleado de
                on hic.Did=de.Did
                left join TDeduccion CI
                on CI.TDid=de.TDid
                inner join CalendarioPagos c
                on hic.RCNid = c.CPid
                and b.Tcodigo = c.Tcodigo
                left join RHCFDIConceptoSAT cs
                on CI.RHCSATid = cs.RHCSATid and CI.Ecodigo=cs.Ecodigo
                inner join CalendarioPagos x
                    on 	b.Tcodigo = x.Tcodigo
                        and x.CPid = hic.RCNid
                where x.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
               		and hic.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
               		and CI.TDcodigo <> '06' <!---Cuota Sindical, debe sumar en las percepciones--->
					/* and cs.RHCSATcodigo <> 002
                    and cs.RHCSATcodigo <> 004*/
        </cfquery>
        <cfquery name="rsDeducciones" datasource="#session.dsn#">
            select *
            from #Deducciones#
        </cfquery>
        
        <cfreturn rsDeducciones>
    </cffunction>

    <cffunction name="GetSalarioEmpleado" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

		<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
            select coalesce(SErenta,0) as ImporteExento, coalesce(SEsalariobruto,0) as SEsalariobruto, coalesce(SEcargasempleado,0) as SEcargasempleado, coalesce(SEdeducciones,0) as SEdeducciones, coalesce(SEliquido,0) as SEliquido, coalesce(SEincidencias,0) as
                    SEincidencias, coalesce(SEliquido,0) as SEliquido, coalesce(SEincidencias,0) as SEincidencias
            from #vSalarioEmpleado#
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfquery>
        <cfreturn rsSalarioEmpleado>
    </cffunction>

    <cffunction name="GetSalarioSATCod" access="public" returntype="query">
        <cfquery name="rsDatosSalarioSATcod" datasource="#Session.DSN#">
            select right(('000000000000000'+cs.CScodigo),15) as CScodigo, cs.CSdescripcion, cSAT.RHCSATcodigo from ComponentesSalariales cs
            inner join dbo.RHCFDIConceptoSAT cSAT
            on cs.Ecodigo = cSAT.Ecodigo
			and cs.RHCSATid=cSAT.RHCSATid
			and cSAT.RHCSATtipo = 'P'
            where cSAT.RHCSATcodigo='001'
        </cfquery>
        <cfreturn rsDatosSalarioSATcod>
    </cffunction>

    <cffunction name="GetIncapacidad" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <!--- 2019-03-08 OPARRALES Obtener Factor Dias IMSS del Tipo de Nomina --->
        <cfquery name="rsDiasIMSS" datasource="#session.dsn#">
            select max(LTid),tn.FactorDiasIMSS 
            from LineaTiempo lt
            inner join TiposNomina tn
            on tn.Tcodigo = lt.Tcodigo
            where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
            group by FactorDiasIMSS
        </cfquery>

        <cfquery name="rsDatosIncapacidad" datasource="#session.dsn#">
            select 
                max(lt.DLlinea),
                pe.PEcantdias,
                rhi.RHIncapcodigo,
                (lt.DLsalario / #rsDiasIMSS.FactorDiasIMSS#)* pe.PEcantdias as Descuento
            from #vPagosEmpleado# pe
            inner join  CalendarioPagos x
                on pe.RCNid = x.CPid
            inner join DLaboralesEmpleado lt
                on pe.DEid = lt.DEid
            inner join  RHTipoAccion ta
                on pe.RHTid = ta.RHTid
                    and ta.RHTcomportam = 5
            left join RHCFDIIncapacidad rhi
            on ta.RHIncapid = rhi.RHIncapid
            where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and pe.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            group by 
                pe.PEcantdias,
                rhi.RHIncapcodigo,
                (lt.DLsalario / #rsDiasIMSS.FactorDiasIMSS#)* pe.PEcantdias
        </cfquery>

        <cfreturn rsDatosIncapacidad>
    </cffunction>

    <cffunction name="GetHrsDobles" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">
        <cfquery name="rsDatosHrsDobles" datasource="#session.dsn#">
            select
				count(*)as dias,
				case
					when SUM(ICValor) < 0.5 then 1
					else round(SUM(ICValor),0)
				end as horas,
				SUM(ICmontores) as monto
            from HIncidenciasCalculo hic
            inner join CIncidentes CI
            on hic.CIid=CI.CIid
            inner join RHCFDIConceptoSAT r
            on CI.RHCSATid=r.RHCSATid
            where CI.CIfactor in (1,2)
			and r.RHCSATcodigo=19
            and hic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and hic.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            group by RCNid,DEid
            order by RCNid,DEid
        </cfquery>
        <cfreturn rsDatosHrsDobles>
    </cffunction>

    <cffunction name="GetHrsTriples" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfquery name="rsDatosHrsTriples" datasource="#session.dsn#">
            select count(*)as dias, SUM(ICValor) as horas , SUM(ICmontores) as monto
            from HIncidenciasCalculo hic
            inner join CIncidentes CI
            on hic.CIid=CI.CIid
            inner join RHCFDIConceptoSAT r
            on CI.RHCSATid=r.RHCSATid
            where CI.CIfactor = 3 and r.RHCSATcodigo=19
            and hic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            and hic.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            group by RCNid,DEid
            order by RCNid,DEid
        </cfquery>
        <cfreturn rsDatosHrsTriples>
    </cffunction>

    <cffunction name="GetCargasEmpl" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>
        <cfquery name="rsDatosCargasEmpl" datasource="#session.dsn#">
            select right(('000000000000000'+c.ECcodigo),15) as Clave, c.ECdescripcion as Concepto, r.RHCSATcodigo as TipoDeduccion, sum(coalesce(CCvaloremp,0)) as ImporteExento, 0 as ImporteGravado
            from HCargasCalculo a, DCargas b, ECargas c
            inner join RHCFDIConceptoSAT r
            on c.RHCSATid = r.RHCSATid
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and a.DClinea = b.DClinea
              and b.ECid = c.ECid
              and CCvaloremp <> 0
            group by DEid,c.ECcodigo,RHCSATcodigo,ECdescripcion
        </cfquery>
        <cfreturn rsDatosCargasEmpl>
    </cffunction>

    <cffunction name="fnAusentismos" access="public" returntype="query">
		<cfargument name="RCNid" 	 type="numeric" required="yes">
		<cfargument name="DEid" 	 type="numeric" required="yes">

		<cfquery name="rsDeducionesFin" datasource="#session.dsn#">
            select
				a.DEid,
				right(('000000000000000'+min(d.RHTcodigo)),15) as TDcodigo,
				0 as ImporteGravado,
            	min(cs.RHCSATcodigo) as RHCSATcodigo,
				min(d.RHTdesc) as RHTdesc,
            	min(a.PEsalario)/30.4 as PEsaldiario,
				(coalesce(sum(PEcantdias),0) * (d.RHTfactorfalta)) as PEcantdias
            from HPagosEmpleado a
            inner join RHTipoAccion d
            	on coalesce(d.RHTid,0) = coalesce(a.RHTid,0)
            inner join RHCFDIConceptoSAT cs
            	on coalesce(d.RHIncapid,0) = coalesce(cs.RHCSATid,0)
            where coalesce(a.DEid,0)  	   		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            	and coalesce(a.RCNid,0) 	   	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            	and coalesce(a.PEtiporeg,0)    	= 0
            	and coalesce(d.RHTcomportam,0) 	= 13
            group by a.DEid, d.RHTfactorfalta
		</cfquery>

		<cfreturn rsDeducionesFin>
	</cffunction>

    <cffunction name="GetFechasCalendario" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>

        <cfquery name="rsFechasCalendario" datasource="#session.dsn#">
            select cp.CPid, cp.CPdesde as finicio, cp.CPhasta as ffinal, cp.Tcodigo, cp.CPfpago, cp.CPdescripcion, tn.IRcodigo, CPcodigo
            from CalendarioPagos cp
            inner join TiposNomina tn
            on cp.Ecodigo = tn.Ecodigo and cp.Tcodigo=tn.Tcodigo
            where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and CPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>
        <cfreturn rsFechasCalendario>
    </cffunction>

    <cffunction name="GetInfoNomina" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>

        <cfset rsRegPatr 	= fnGetDato(300)>
        <cfset rsRiesgoLab 	= fnGetDato(301)>

		<cfif rsRiesgoLab.RecordCount eq 0 or rsRiesgoLab.RecordCount gt 0 and Trim(rsRiesgoLab.Pvalor) eq ''>
			<cfthrow message="No se ha configurado el Riesgo Laboral" type="Application" detail="Parametros RH">
		</cfif>

		<cfset RegPatr = (rsRegPatr.RecordCount gt 0 ? Trim(rsRegPatr.Pvalor): "")>

         <cfquery name="rsClaveRiesgo"  datasource="#session.dsn#">
         	select coalesce(RHRiesgocodigo,0) as RiesgoPuesto from RHCFDI_Riesgo r
            where RHRiesgoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRiesgoLab.Pvalor#">
         </cfquery>
         <cfif rsClaveRiesgo.RecordCount gt 0 and len(rsClaveRiesgo.RiesgoPuesto)>
         	<cfset RiesgoLab= #rsClaveRiesgo.RiesgoPuesto#>
         <cfelse>
         	<cfset RiesgoLab= 0>
         </cfif>

		<cfquery name="rsunEmp" datasource="#session.dsn#">
			select
				CBTcodigo,
				DESeguroSocial,
				RFC,
				CURP,
				DEtipocontratacion,
				DEtiposalario,
				Concat(DEidentificacion,' - ',DEnombre,' ',DEapellido1,' ',DEapellido2) as NombreEmp
			from
				DatosEmpleado
			where
				DEid = <cfqueryparam cfsqltype="cf_Sql_numeric" value="#Arguments.DEid#">
			and	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- OPARRALES 2018-10-22 Validaciones para Datos Empleado --->
		<cfif Trim(rsunEmp.CBTcodigo) eq ''>
			<cfthrow detail="El Tipo de Cuenta no se ha configurado para el empleado #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

		<cfif Trim(rsunEmp.DESeguroSocial) eq ''>
			<cfthrow detail="No se ha configurado el NSS para el empleado #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

		<cfif Trim(rsunEmp.RFC) eq ''>
			<cfthrow detail="No se ha configurado el RFC para el empleado #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

		<cfif Trim(rsunEmp.CURP) eq ''>
			<cfthrow detail="La CURP no se ha configurado para el empleado #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

		<cfif Trim(rsunEmp.DEtipocontratacion) eq ''>
			<cfthrow detail="El Tipo de Empleado no se ha configurado para #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

		<cfif Trim(rsunEmp.DEtiposalario) eq '' or rsunEmp.DEtiposalario eq -1>
			<cfthrow detail="No se ha configurado el Tipo de Salario para #rsunEmp.NombreEmp#" message="DATOS EMPLEADO: ">
		</cfif>

        <cfset rsCertificado 		= GetCertificado(Arguments.Ecodigo)>
        <cfset rsLugarExpedicion 	= GetLugarExpedicion(Arguments.Ecodigo)>
        <cfset rsFechas 			= GetFechasCalendario(Arguments.Ecodigo,Arguments.RCNid)>

        <cf_dbtemp name="salida" returnvariable="salida">
            <cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
            <cf_dbtempcol name="IdNomina" 		type="int" 			mandatory="no">
            <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
            <cf_dbtempcol name="Nombre"   		type="char(100)"    mandatory="no">
            <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
            <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
            <cf_dbtempcol name="RFC"			type="char(18)"     mandatory="no">
            <cf_dbtempcol name="RegistroPatronal" type="char(40)"   mandatory="no">
            <cf_dbtempcol name="CURP"			type="char(18)"     mandatory="no">
            <cf_dbtempcol name="TipoRegimen"	type="char(10)"     mandatory="no">
            <cf_dbtempcol name="NumSeguridadSocial"	type="char(60)" mandatory="no">
            <cf_dbtempcol name="Departamento"	type="char(60)"     mandatory="no">
            <cf_dbtempcol name="CLABE"			type="char(25)"     mandatory="no">
            <cf_dbtempcol name="Banco"			type="char(50)"     mandatory="no">
            <cf_dbtempcol name="FechaInicioRelLaboral"   	type="datetime"     mandatory="no">
            <cf_dbtempcol name="Antiguedad" 	type="int" 			mandatory="no">
            <cf_dbtempcol name="Puesto"			type="char(80)"     mandatory="no">
            <cf_dbtempcol name="TipoContrato"	type="char(18)"     mandatory="no">
            <cf_dbtempcol name="TipoJornada"	type="char(60)" mandatory="no">
            <cf_dbtempcol name="PeriodicidadPago"	type="char(20)"     mandatory="no">
            <cf_dbtempcol name="SalarioBaseCotApor"	type="money"       	mandatory="no">
            <cf_dbtempcol name="RiesgoPuesto" 	type="int" 			mandatory="no">
            <cf_dbtempcol name="SalarioDiarioIntegrado"	type="money"       	mandatory="no">
            <cf_dbtempcol name="Mcodigo"		type="int"     	mandatory="no">

            <cf_dbtempcol name="DEdato1"   		type="char(80)"     mandatory="no">
            <cf_dbtempcol name="fechaDesde"   	type="datetime"     mandatory="no">
            <cf_dbtempcol name="fechaHasta"   	type="datetime"     mandatory="no">
            <cf_dbtempcol name="fechaPago"   	type="datetime"     mandatory="no">
            <cf_dbtempcol name="DiasLab" 		type="int"       	mandatory="no">
            <cf_dbtempcol name="Dfaltas" 		type="int"       	mandatory="no">
            <cf_dbtempcol name="MtoDiasFalta"	type="money"       	mandatory="no">
            <cf_dbtempcol name="DiasIncap" 		type="int"       	mandatory="no">
            <cf_dbtempcol name="DiasVac" 		type="int"       	mandatory="no">
            <cf_dbtempcol name="ISPT"			type="money"       	mandatory="no">
            <cf_dbtempcol name="CSsalario" 		type="money"     	mandatory="no">
            <cf_dbtempcol name="SDI"			type="money"       	mandatory="no">
            <cf_dbtempcol name="SalDiario" 		type="money"     	mandatory="no">
			<cf_dbtempcol name="TipoNomina"		type="char(20)"		mandatory="no">
			<cf_dbtempcol name="DESindicalizado" type="bit" 		mandatory="no" default="0">
			<cf_dbtempcol name="TipoRegimenDesc" type="char(200)"   mandatory="no">
			<cf_dbtempcol name="CodigoNomina" 	type="char(200)" 	mandatory="no">

			<cf_dbtempcol name="RegistroPatronalO" type="char(40)"   mandatory="no"><!--- por oficina --->
			<cf_dbtempcol name="fechaEmision"	type="char(25)"		mandatory="no">
			<cf_dbtempcol name="CPTipoCalRenta"	type="int"			mandatory="no">
			<cf_dbtempcol name="OficinaD"		type="char(250)"	mandatory="no">
			<cf_dbtempcol name="Tcodigo"		type="char(250)"	mandatory="no">

        </cf_dbtemp>

		<!---
        <cfquery datasource="#session.dsn#" name="rsEmpleados">
            insert #salida# (DEid,IdNomina, Identificacion, Nombre,Ape1,Ape2,DEdato1,RFC, FechaDesde, FechaHasta, fechaPago,CSsalario,
            RegistroPatronal,
            CURP, TipoRegimen,NumSeguridadSocial,
            Departamento,CLABE,Banco,
            FechaInicioRelLaboral,
            Antiguedad,
            Puesto,
            TipoContrato,
            TipoJornada,PeriodicidadPago,SalarioBaseCotApor,
			RiesgoPuesto,SalarioDiarioIntegrado,Mcodigo,
			TipoNomina, DESindicalizado ,TipoRegimenDesc,CodigoNomina,RegistroPatronalO,fechaEmision,CPTipoCalRenta)
            select distinct a.DEid,c.CPid, a.DEidentificacion, coalesce(a.DEnombre,'') as DEnombre, coalesce(a.DEapellido1,'') as DEapellido1, coalesce(a.DEapellido2,'') as DEapellido2, a.DEdato1,coalesce(replace(a.RFC,'-',''),'') as RFC ,c.CPdesde, c.CPhasta, c.CPfpago, 0,

                (select top(1) coalesce(p.Onumpatronal,'#RegPatr#')
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronal,

                a.CURP, reg.RHRegimencodigo as RegimenContra,a.DESeguroSocial,
                (select top(1) p.Ddescripcion
                from LineaTiempo lt
                inner join Departamentos p on lt.Dcodigo = p.Dcodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as Departamento,

                a.CBcc,bnc.BcodigoOtro,
                (select top(1) LTdesde from LineaTiempo lt
					inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
				 where lt.Deid=a.Deid and rhta.RHTcomportam = 1 order by LTdesde desc) as FechaInicioRelLaboral,
                <!--- DATEDIFF(WW,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=a.Deid order by LTdesde desc),c.CPhasta) as Antiguedad, --->
				Left((DATEDIFF(second,(select top(1) LTdesde from LineaTiempo lt
				inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
				 where lt.Deid=a.Deid and rhta.RHTcomportam = 1 order by LTdesde desc),c.CPhasta) / 86400.0 / 7),(Charindex('.',(DATEDIFF(second,(select top(1) LTdesde from LineaTiempo lt inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
				 where lt.Deid=a.Deid and rhta.RHTcomportam = 1 order by LTdesde desc),c.CPhasta) / 86400.0 / 7)))-1) as Antiguedad,
                (select top(1) <!---coalesce(replace(replace(p.RHPdescpuesto,'&',''),'"',''),'') as---> p.RHPdescpuesto
                    from LineaTiempo lt
                    inner join RHPuestos p on lt.RHPcodigo = p.RHPcodigo
                    where lt.Deid=a.Deid order by LTdesde DESC) as Puesto,
                <!--- case a.DEtipocontratacion
                    when '3' then 'Construccion'
                    when '2' then 'Eventual'
                    when '1' then 'Fijo'
                    else 'ND'
                end as TipoContratacion, --->
				tc.CSATclave as TipoContratacion,
                (select top(1) p.ClaveSAT
                from LineaTiempo lt
                inner join RHJornadas p on lt.RHJid = p.RHJid
                where lt.Deid=a.Deid order by LTdesde DESC) as TipoJornada,

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
                where lt.Deid=a.Deid order by LTdesde DESC) as PeriodicidadPago,

           <!---     (select top(1) lt.LTsalario
                from LineaTiempo lt
                where lt.Deid=a.Deid
                order by LTdesde DESC) as SalarioBaseCotApor,
            --->
				a.DEsdi as SalarioBaseCotApor,
                (select top(1) coalesce(r.RHRiesgocodigo,'#RiesgoLab#')
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                left join RHCFDI_Riesgo r
                on p.RHRiesgoid = r.RHRiesgoid and p.Ecodigo = r.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as IdRiesgo,

           <!---     (select top(1) lt.LTsalarioSDI
                from LineaTiempo lt
                where lt.Deid=a.Deid
                order by LTdesde DESC) as SalarioDiarioIntegrado,
            --->
				a.DEsdi as SalarioDiarioIntegrado,
                a.Mcodigo,
				case c.CPtipo
					when 0 then 'O'
					else 'E'
				end as TipoNomina,
				<!--- (select top(1) p.TipoNomina as TipoNomina
                from LineaTiempo lt
                inner join TiposNomina p on lt.Tcodigo = p.Tcodigo and lt.Ecodigo=p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as TipoNomina, --->
				coalesce(a.DESindicalizado,0) DESindicalizado,
				reg.RHRegimendescripcion as TipoRegimenDesc,
				(select CPcodigo from CalendarioPagos a, HRCalculoNomina b,TiposNomina c
				where a.Ecodigo = 1 and b.RCNid = a.CPid and b.Ecodigo = c.Ecodigo and b.Tcodigo = c.Tcodigo
				and a.CPfcalculo is not null and b.RCNid = #arguments.RCNid#) as CodigoNomina,
				(select top(1) p.Onumpatronal
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronalO,
				SUBSTRING(ltrim(rtrim(convert(char,getDate(),120))),1,10)+'T'+convert(char,getDate(),108) as fechaEmision,
				<!--- OPARRALES 2018-10-29 Se agrega para validacion de Aguinaldo --->
				c.CPTipoCalRenta
            from DatosEmpleado a
				inner join CSATTiposContrato tc
				on tc.TCid = a.DEtipocontratacion
                left join LineaTiempo b
                    on a.DEid = b.DEid
                left join DLineaTiempo d
                    on b.LTid = d.LTid
                inner join ComponentesSalariales cs
                    on d.CSid = cs.CSid
                        and CSsalariobase = 1
                inner join CalendarioPagos c
                    on c.Tcodigo = b.Tcodigo
                        and c.Ecodigo = a.Ecodigo
                inner join RHPlazas p
                    on b.RHPid = p.RHPid
                inner join CFuncional f
                    on p.CFid = f.CFid
                    and a.Ecodigo = f.Ecodigo
                left join RHCFDI_Regimen reg
                    on a.RHRegimenid = reg.RHRegimenid
                inner join Bancos bnc
                    on bnc.Bid=a.Bid
                inner join CalendarioPagos x
                    on 	b.Tcodigo = x.Tcodigo
                        and c.CPid = x.CPid
                        and ((b.LThasta >= x.CPdesde and b.LTdesde <= x.CPhasta) or (b.LTdesde <= x.CPhasta and b.LThasta >= x.CPdesde))
                        and b.LThasta = (select MAX(c.LThasta) from LineaTiempo c where c.DEid = a.DEid
                        and ((c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#"> and c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">)
                        or (c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#"> and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">))
                            )
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and x.CPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                and a.DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            order by DEid
        </cfquery>
		 --->
		 <cfquery datasource="#session.dsn#" name="rsEmpleados">
            insert #salida# (DEid,IdNomina, Identificacion, Nombre,Ape1,Ape2,DEdato1,RFC, FechaDesde, FechaHasta, fechaPago,CSsalario,
            RegistroPatronal,
            CURP, TipoRegimen,NumSeguridadSocial,
            Departamento,CLABE,Banco,
            FechaInicioRelLaboral,
            Antiguedad,
            Puesto,
            TipoContrato,
            TipoJornada,PeriodicidadPago,SalarioBaseCotApor,
			RiesgoPuesto,SalarioDiarioIntegrado,Mcodigo,
			TipoNomina,DESindicalizado,TipoRegimenDesc,CodigoNomina,RegistroPatronalO,fechaEmision,CPTipoCalRenta,OficinaD,Tcodigo)
            select distinct a.DEid,c.CPid, a.DEidentificacion, coalesce(a.DEnombre,'') as DEnombre,
				coalesce(a.DEapellido1,'') as DEapellido1, coalesce(a.DEapellido2,'') as DEapellido2,
				a.DEdato1,coalesce(replace(a.RFC,'-',''),'') as RFC ,c.CPdesde, c.CPhasta, c.CPfpago, 0,

                (select top(1) coalesce(p.Onumpatronal,'#RegPatr#')
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronal,

                a.CURP, reg.RHRegimencodigo as RegimenContra,a.DESeguroSocial,
                (select top(1) p.Ddescripcion
                from LineaTiempo lt
                inner join Departamentos p on lt.Dcodigo = p.Dcodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as Departamento,

                a.CBcc,bnc.BcodigoOtro,
                (select top(1) DLfvigencia from DLaboralesEmpleado lt
                    inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
                    where lt.Deid=a.DEid and rhta.RHTcomportam = 1 order by DLfvigencia desc) as FechaInicioRelLaboral,
                <!--- DATEDIFF(WW,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=a.Deid order by LTdesde desc),c.CPhasta) as Antiguedad, --->
				Left((DATEDIFF(second,(select top(1) DLfvigencia from DLaboralesEmpleado lt
				inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
				 where lt.Deid=a.Deid and rhta.RHTcomportam = 1  order by DLfvigencia desc),c.CPhasta) / 86400.0 / 7),(Charindex('.',(DATEDIFF(second,(select top(1) DLfvigencia from DLaboralesEmpleado lt inner join RHTipoAccion rhta on rhta.RHTid = lt.RHTid and rhta.RHTcomportam = 1
				 where lt.Deid=a.Deid and rhta.RHTcomportam = 1  order by DLfvigencia desc),c.CPhasta) / 86400.0 / 7)))-1) as Antiguedad,
                (select top(1) <!---coalesce(replace(replace(p.RHPdescpuesto,'&',''),'"',''),'') as---> p.RHPdescpuesto
                    from LineaTiempo lt
                    inner join RHPuestos p on lt.RHPcodigo = p.RHPcodigo
                    where lt.Deid=a.Deid order by LTdesde DESC) as Puesto,
                <!--- case a.DEtipocontratacion
                    when '3' then 'Construccion'
                    when '2' then 'Eventual'
                    when '1' then 'Fijo'
                    else 'ND'
                end as TipoContratacion, --->
				tc.CSATclave as TipoContratacion,
                (select top(1) p.ClaveSAT
                from LineaTiempo lt
                inner join RHJornadas p on lt.RHJid = p.RHJid
                where lt.Deid=a.Deid order by LTdesde DESC) as TipoJornada,

				<!---
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
                where lt.Deid=a.Deid order by LTdesde DESC) as PeriodicidadPago,
				SE MODIFICA POR CUESTIONES DE URGENCIA, MODIFICAR EN CATALOGO DE TIPOS DE NOMINA Y OBTENER VALOR
				 --->
				 '02' as PeriodicidadPago,

           <!---     (select top(1) lt.LTsalario
                from LineaTiempo lt
                where lt.Deid=a.Deid
                order by LTdesde DESC) as SalarioBaseCotApor,
            --->
				a.DEsdi as SalarioBaseCotApor,<!--- PEsalario /  Factor dias SDI nomina --->
                (select top(1) coalesce(r.RHRiesgocodigo,'#RiesgoLab#')
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                left join RHCFDI_Riesgo r
                on p.RHRiesgoid = r.RHRiesgoid and p.Ecodigo = r.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as IdRiesgo,

           <!---     (select top(1) lt.LTsalarioSDI
                from LineaTiempo lt
                where lt.Deid=a.Deid
                order by LTdesde DESC) as SalarioDiarioIntegrado,
            --->
				<!--- a.DEsdi as SalarioDiarioIntegrado, ---><!--- Ultimo del Historico segun el bimestre de la nomina --->
				(select top 1
					RHHmonto
				from RHHistoricoSDI
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
					and RHHperiodo <= DatePart(year,c.CPhasta)
					and RHHmes <= DatePart(month,c.CPhasta)
					order by RHHperiodo desc,RHHmes desc ) as SalarioDiarioIntegrado,
                a.Mcodigo,
				case c.CPtipo
					when 0 then 'O'
					else 'E'
				end as TipoNomina,
				<!--- (select top(1) p.TipoNomina as TipoNomina
                from LineaTiempo lt
                inner join TiposNomina p on lt.Tcodigo = p.Tcodigo and lt.Ecodigo=p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as TipoNomina, --->
				coalesce(a.DESindicalizado,0) DESindicalizado,
				reg.RHRegimendescripcion as TipoRegimenDesc,
				(select CPcodigo from CalendarioPagos a, HRCalculoNomina b,TiposNomina c
				where a.Ecodigo = 1 and b.RCNid = a.CPid and b.Ecodigo = c.Ecodigo and b.Tcodigo = c.Tcodigo
				and a.CPfcalculo is not null and b.RCNid = #arguments.RCNid#) as CodigoNomina,
				(select top(1) p.Onumpatronal
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as RegPatronalO,
				SUBSTRING(ltrim(rtrim(convert(char,getDate(),120))),1,10)+'T'+convert(char,getDate(),108) as fechaEmision,
				<!--- OPARRALES 2018-10-29 Se agrega para validacion de Aguinaldo --->
				c.CPTipoCalRenta,
				(select top(1) concat(RTRIM(LTRIM(p.Oficodigo)),' ',RTRIM(LTRIM(p.Odescripcion)))
                from LineaTiempo lt
                inner join Oficinas p on lt.Ocodigo = p.Ocodigo and lt.Ecodigo = p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as OficinaD
				,b.Tcodigo
            from DatosEmpleado a
				inner join CSATTiposContrato tc
				on tc.TCid = a.DEtipocontratacion
                left join LineaTiempo b
                    on a.DEid = b.DEid
                left join DLineaTiempo d
                    on b.LTid = d.LTid
                inner join ComponentesSalariales cs
                    on d.CSid = cs.CSid
                        and CSsalariobase = 1
                inner join CalendarioPagos c
                    on c.Tcodigo = b.Tcodigo
                        and c.Ecodigo = a.Ecodigo
                inner join RHPlazas p
                    on b.RHPid = p.RHPid
                inner join CFuncional f
                    on p.CFid = f.CFid
                    and a.Ecodigo = f.Ecodigo
                left join RHCFDI_Regimen reg
                    on a.RHRegimenid = reg.RHRegimenid
                inner join Bancos bnc
                    on bnc.Bid=a.Bid
                inner join CalendarioPagos x
                    on 	b.Tcodigo = x.Tcodigo
                        and c.CPid = x.CPid
                        and ((b.LThasta >= x.CPdesde and b.LTdesde <= x.CPhasta) or (b.LTdesde <= x.CPhasta and b.LThasta >= x.CPdesde))
                        and b.LThasta = (select MAX(c.LThasta) from LineaTiempo c where c.DEid = a.DEid
                        and ((c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#"> and c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#">)
                        or (c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.ffinal#"> and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechas.finicio#">))
                            )
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and x.CPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                and a.DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            order by DEid
        </cfquery>

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cfquery datasource="#session.dsn#" name="rsFaltas">
            update #salida#
                set Dfaltas =
                            coalesce(
                            (select sum(pe.PEcantdias)
                            from #vPagosEmpleado# pe
                                inner join  CalendarioPagos x
                                    on pe.RCNid = x.CPid
                                inner join LineaTiempo lt
                                    on pe.LTid = lt.LTid
                                inner join  RHTipoAccion ta
                                    on pe.RHTid = ta.RHTid
                                        and ta.RHTcomportam = 13
                                    where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina),0)
                , MtoDiasFalta =
                            coalesce(
                            (select sum(((coalesce(ta.RHTfactorfalta,1) * (pe.PEsalario / 30))* pe.PEcantdias))
                            from #vPagosEmpleado# pe
                                inner join  CalendarioPagos x
                                    on pe.RCNid = x.CPid
                                inner join LineaTiempo lt
                                    on pe.LTid = lt.LTid
                                inner join  RHTipoAccion ta
                                    on pe.RHTid = ta.RHTid
                                        and ta.RHTcomportam = 13
                                    where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina),0)

                 , DiasIncap =
                                    coalesce(
                                    (select sum(pe.PEcantdias)
                                    from #vPagosEmpleado# pe
                                    inner join  CalendarioPagos x
                                        on pe.RCNid = x.CPid
                                        inner join LineaTiempo lt
                                            on pe.LTid = lt.LTid
                                        inner join  RHTipoAccion ta
                                            on pe.RHTid = ta.RHTid
                                                and ta.RHTcomportam = 5
                                            where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina),0)
                    , DiasVac =
                                    coalesce(
                                    (select sum(pe.PEcantdias)
                                    from #vPagosEmpleado# pe
                                        inner join  CalendarioPagos x
                                            on pe.RCNid = x.CPid
                                        inner join LineaTiempo lt
                                            on pe.LTid = lt.LTid
                                        inner join  RHTipoAccion ta
                                            on pe.RHTid = ta.RHTid
                                                and ta.RHTcomportam = 3
                                            where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina),0)
                    , DiasLab =
                                 coalesce(
                                    (select sum(pe.PEcantdias)
                                    from #vPagosEmpleado# pe
                                        inner join  CalendarioPagos x
                                            on pe.RCNid = x.CPid
                                        inner join LineaTiempo lt
                                            on pe.LTid = lt.LTid
                                        inner join  RHTipoAccion ta
                                            on pe.RHTid = ta.RHTid
                                                and ta.RHTcomportam not in(3,5,13)
                                            where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina
											group by x.CPTipoCalRenta),0)
        </cfquery>
        <!--- Consultas para el Reporte --->

		<!--- VALIDACION: REGISTRO PATRONAL POR OFICINA OPARRALES 2018-09-20
			- Si existe por lo menos un Empleado con Registro patronal en su oficina
			- por regla de negocio todos deben tener configurado el registro patronal en la oficina.
		 --->
		<cfquery name="rsRPOfi" datasource="#session.dsn#">
			select *
            from #salida#
			where RegistroPatronalO is not null
            order by Ape1,Ape2,Nombre
		</cfquery>

		<cfset mensajeError = "">
		<cfif rsRPOfi.RecordCount gt 0>
			<!--- Buscando los empleados que hace falta configurar el registro patronal en su oficina --->
			<cfquery name="rsRPOfi2" datasource="#session.dsn#">
				select *
	            from #salida#
				where RegistroPatronalO is null
	            order by Ape1,Ape2,Nombre
			</cfquery>

			<!--- Si existen empleados sin la configuracion se concatenan en mensaje de error --->
			<cfset NL = Chr(13)&Chr(10)>
			<cfloop query="rsRPOfi2">
				<cfset mensajeError &= "* #Identificacion# - #Nombre#" & NL>
			</cfloop>

			<cfif Trim(mensajeError) neq ''>
				<cfthrow message="No se ha configurado el Registro Patronal de los siguientes empleados: #NL# #mensajeError#" detail="Registro Patronal - Oficinas" type="Application">
			</cfif>
		<cfelse>
			<cfif RegPatr eq ''>
				<cfthrow message="No se ha configurado el Registro Patronal" detail="Parametros RH" type="Application">
			</cfif>
		</cfif>

        <cfquery name="rsReporte" datasource="#session.dsn#">
            select *
            from #salida#
            order by Ape1,Ape2,Nombre
        </cfquery>

        <cfreturn rsReporte>

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
	
	<cffunction name="GetDeduccionISR" access="public" returntype="query">
		<cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">
	
		<cfquery name="rsDeduccionISR" datasource="#session.dsn#" >
			select  DCvalor as Valor,RHCSATcodigo as Codigo
            from HSalarioEmpleado sa
            inner join HDeduccionesCalculo hic
            on sa.DEid=hic.DEid and sa.RCNid=hic.RCNid
            inner join DeduccionesEmpleado de
                on hic.Did=de.Did
            left join TDeduccion CI
                on CI.TDid=de.TDid
				left join RHCFDIConceptoSAT cs
                on CI.RHCSATid = cs.RHCSATid and CI.Ecodigo=cs.Ecodigo
            where sa.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and sa.DEid =  <cfqueryparam cfsqltype="cf_Sql_numeric" value="#Arguments.DEid#">
               and cs.RHCSATcodigo=002 
			   and cs.RHCSATOtroPago=0
		
		</cfquery>
		<cfreturn rsDeduccionISR>
	</cffunction>
	
	<cffunction name="GetCompensacionSaldosAFavor" access="public" returntype="query">
		<cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">
	
		<cfquery name="rsSaldoAFavor" datasource="#session.dsn#" >
			 select ABS(DCvalor) as SaldoFavor,ABS(DCvalor+SERentaT) as Remanente,SERentaT as ISR, YEAR ( Dfechaini ) as Year,RHCSATcodigo as Codigo,RHCSATdescripcion as Concepto
            from HSalarioEmpleado sa
            inner join HDeduccionesCalculo hic
            on sa.DEid=hic.DEid and sa.RCNid=hic.RCNid
            inner join DeduccionesEmpleado de
                on hic.Did=de.Did
            left join TDeduccion CI
                on CI.TDid=de.TDid
				left join RHCFDIConceptoSAT cs
                on CI.RHCSATid = cs.RHCSATid and CI.Ecodigo=cs.Ecodigo
            where sa.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and sa.DEid =  <cfqueryparam cfsqltype="cf_Sql_numeric" value="#Arguments.DEid#">
              and cs.RHCSATcodigo=004 
			  and cs.RHCSATOtroPago=1
		
        </cfquery>
		<cfreturn rsSaldoAFavor>
    </cffunction>
    
    <cffunction  name="getSubsidioCausado" access="private" hint="Funcion para obtener el subsidio causado por empleado">
        <cfargument name="RCNid" 		type="numeric" required="yes">
        <cfargument name="DEid" 		type="numeric" required="yes">

        <cfquery name="rsSubsidioCausado" datasource="#session.dsn#">
            select RHSvalor from 
            HRHSubsidio where Ecodigo=#session.Ecodigo# and RCNid=#RCNid# and DEid=#DEid#
        </cfquery>

        <cfreturn rsSubsidioCausado.RHSvalor neq "" ? rsSubsidioCausado.RHSvalor:0>
    </cffunction>
	
<!--- FIN - Funciones privadas para Recibo de Nomina --->

</cfcomponent>

