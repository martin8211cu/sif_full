 <cfcomponent>
 	<cffunction name="obtenerCFDI" access="public" >
    	<cfargument name="DEid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="RCNid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="DLlinea" 					type="numeric" 	required="no" default="-1">
        <cfargument name="OImpresionID" 			type="numeric" 	required="no" default="-1">
        <cfset reciboNomina=0>
        <cfset facturaElectronica=0>
        <cfset reciboNominaLiqFiniquito=0>


        <cfquery name="getDatosCert" datasource="#session.dsn#">
        	select archivoKey from RH_CFDI_Certificados
        </cfquery>
        <cfset vsPath = #getDatosCert.archivoKey#>
        <cfset vsPath = left(vsPath,22)>
        <!---<cfset vsPath_A = "D:">--->
	<cfset vsPath_A = left(vsPath,2)>

				<cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
                	<cfquery name="rsReciboCFDI" datasource="#session.dsn#" >
                            select * from RH_CFDI_RecibosNomina
                            where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                            and RCNid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                    </cfquery>
                    <cfset reciboNomina=1>
                    <cfset cadenaOriginal=CadenaOriginalReciboNominaCFDI(Arguments.DEid,Arguments.RCNid)>
                    <cfif rsReciboCFDI.RecordCount EQ 0>
                        <cfquery name="insEmp" datasource="#session.dsn#">
                           insert into RH_CFDI_RecibosNomina (Ecodigo,DEid,RCNid,DLlinea,CadenaOriginal,stsTimbre)
                           values(#session.Ecodigo#,#Arguments.DEid#,#Arguments.RCNid#,#Arguments.DLlinea#,'#CadenaOriginal#',0)
                        </cfquery>
                    <cfelse>
                        <cfquery name="upEmp" datasource="#session.dsn#">
                           update RH_CFDI_RecibosNomina
                           set CadenaOriginal='#CadenaOriginal#',stsTimbre=0
                           where Ecodigo=#session.Ecodigo# and DEid=#Arguments.DEid# and RCNid=#Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                        </cfquery>
                    </cfif>
                </cfif>
                <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                	<cfquery name="rsReciboLiqCFDI" datasource="#session.dsn#" >
                            select * from RH_CFDI_RecibosNomina
                            where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                            and DLlinea =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
                            and Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    </cfquery>
                    <cfset reciboNominaLiqFiniquito=1>
                    <cfset cadenaOriginal=CadenaOriginalFiniquitosLiqCFDI(Arguments.DEid,Arguments.DLlinea)>
                    <cfif rsReciboLiqCFDI.RecordCount EQ 0>
                        <cfquery name="insEmp" datasource="#session.dsn#">
                           insert into RH_CFDI_RecibosNomina (Ecodigo,DEid,RCNid,DLlinea,CadenaOriginal,stsTimbre)
                           values(#session.Ecodigo#,#Arguments.DEid#,#Arguments.RCNid#,#Arguments.DLlinea#,'#CadenaOriginal#',0)
                        </cfquery>
                    <cfelse>
                        <cfquery name="upEmp" datasource="#session.dsn#">
                           update RH_CFDI_RecibosNomina
                           set CadenaOriginal='#CadenaOriginal#',stsTimbre=0
                           where Ecodigo=#session.Ecodigo# and DEid=#Arguments.DEid# and RCNid=#Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                        </cfquery>
                    </cfif>
                </cfif>

                <cfif Arguments.OImpresionID GT 0 >
                    <cfset facturaElectronica=1>
                    <cfset cadenaOriginal=CadenaOriginalFacturaCFDI(Arguments.OImpresionID)>
                </cfif>

                <cfset sello=GeneraSelloDigital(cadenaOriginal)>
                <!--- Validacion y creacion de carpetar para almacenar Facturas --->
                <cf_foldersFacturacion>
                <cfif reciboNominaLiqFiniquito EQ 1>
                	<cfset xml = XML32ReciboLiqFinCFDI(Arguments.DEid,Arguments.DLlinea, sello)>
                    <cfquery name="upSello" datasource="#session.dsn#">
                       update RH_CFDI_RecibosNomina
                       set SelloDigital='#sello#', xml32 ='#xml#'
                       where Ecodigo = #session.Ecodigo# and Deid=#Arguments.DEid# and RCNid = #Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                    </cfquery>
                    
                    <cfset archivoXml=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\xmlST\#Arguments.DEid#_#Arguments.RCNid##Arguments.DLlinea#.xml">
                    <!---<cfset archivoXml="c:\Enviar\xmlST\#Arguments.DEid#_#Arguments.RCNid##Arguments.DLlinea#.xml">--->
                    <!---ERBG Cambio para la Ñ charset="utf-8"--->
                    <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
                    <cfset xmlTimbrado = TimbraXML(xml,Arguments.DEid,Arguments.RCNid,Arguments.DLlinea)>
                </cfif>
                <cfif reciboNomina EQ 1>

                    <cfset xml = XML32ReciboNominaCFDI(Arguments.DEid,Arguments.RCNid, sello)>

                    <cfquery name="upSello" datasource="#session.dsn#">
                       update RH_CFDI_RecibosNomina
                       set SelloDigital='#sello#', xml32 ='#xml#'
                       where Ecodigo = #session.Ecodigo# and Deid=#Arguments.DEid# and RCNid = #Arguments.RCNid# and DLlinea=#Arguments.DLlinea#
                    </cfquery>

		            <cfset archivoXml=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\xmlST\#Arguments.DEid#_#Arguments.RCNid#.xml">
                    <!---<cfset archivoXml="c:\Enviar\xmlST\#Arguments.DEid#_#Arguments.RCNid#.xml">--->

                    <!---ERBG Cambio para la Ñ charset="utf-8"--->
                    <CFFILE ACTION="WRITE" FILE="#archivoXml#" OUTPUT="#ToString(xml)#" charset="utf-8">
                    <cfset xmlTimbrado = TimbraXML(xml,Arguments.DEid,Arguments.RCNid)>
                </cfif>
                <cfif facturaElectronica EQ 1>
                    <cfset xml = XML32FacturaCFDI(Arguments.OImpresionID)>
                    <cfset xmlTimbrado = TimbraXML(xml)>
                </cfif>
    </cffunction>

    <cffunction name="CadenaOriginalFiniquitosLiqCFDI" access="private" returntype="string">
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
         	<cfset DeduccionISPTRL = "ISPT Real Liquidación">
            <cfset importeDeduccionISPTRL= #NumberFormat(rsLF.RHLFLISPTRealL/100,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|002|00000000000ISPT|ISPT Real Liquidacion|0.00|"&#importeDeduccionISPTRL#>
        	<cfset lVarImp_ISPT = #lVarImp_ISPT# + (rsLF.RHLFLISPTRealL/100)>
         </cfif>

         <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit GT 0>
         	<cfset DeduccionCreditoInfonavit="Credito Infonavit">
            <cfset importeDeduccionInfonavit = #NumberFormat(rsLF.RHLFLinfonavit,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|009|000000INFONAVIT|Crédito Infonavit|0.00|"&#importeDeduccionInfonavit#>
         </cfif>
        <cfloop query="rsDeducFin">
         	<cfset lVarDeducciones=#lVarDeducciones#&"|"&#trim(rsDeducFin.RHCSATcodigo)#&"|"&#trim(rsDeducFin.TDcodigo)#&"|"&#trim(rsDeducFin.RHLDdescripcion)#&"|0.00|"&#LSNumberformat(rsDeducFin.importe,'_.00')#>
        </cfloop>
        <cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>
        <cfset datosEmpLiqFin = fnGetdatosEmpLiqFin(#Arguments.DLlinea#)>
        <cfset rsRegPatronal	= fnGetDato(300)>
        <cfset rsTipoJornada = fnGettipoJornada(#Arguments.DEid#)>
        <cfset rsPercepciones= fnGetPercepciones(#Arguments.DLlinea#)>

        <cfset TotalDeducciones=fnGetTotalDeducciones(#Arguments.DLlinea#,#Arguments.DEid#)>
		<cfset lVarTotalDeducciones = #LSNumberformat(TotalDeducciones,'_.00')#>

        <cfset lVarEmisor = #session.Enombre#>
        <cfset lVarRFCEmisor = #rsLugarExpedicion.Eidentificacion#>
        <cfset lVarLugarExpedicion =#rsLugarExpedicion.LugarExpedicion#>
        <cfset lVarMoneda=#rsLugarExpedicion.Miso4217#>
        <cfset lVarTotal = #LSNumberformat(rsLF.RHLFLRESULTADO,'_.00')#>
        <cfset lVarRegFiscal =#rsLugarExpedicion.nombre_RegFiscal#>
        <cfset lVarFechaExpedicion=#DateFormat(now(),'yyyy-mm-ddTHH:mm:00')#>
        <cfset lVarNoEmp  = #datosEmpLiqFin.DEidentificacion#>
		<cfset lVarNombreEmp = #datosEmpLiqFin.Nombrecompleto#>
        <cfset lVarRFCEmp = #datosEmpLiqFin.RFC#>
        <cfset lVarCURP = #datosEmpLiqFin.CURP#>
        <cfset lVarNoSegSocial = #datosEmpLiqFin.SeguroSocial#>
        <cfset lVarMotivoBaja =  #datosEmpLiqFin.MotivoBaja#>
        <cfset lVarpuesto  = #datosEmpLiqFin.Puesto#>
        <cfset lVarDepartamento = #datosEmpLiqFin.Departamento#>
        <cfset lVarFechaIngreso = #DateFormat(datosEmpLiqFin.FechaIngreso,'yyyy-mm-dd')#>
        <cfset lVarFechaBaja = #DateFormat(datosEmpLiqFin.FechaBaja,'yyyy-mm-dd')#>
        <cfset lVarAntiguedad= #datosEmpLiqFin.Antiguedad#>
        <cfset lVarTipoRegimen=#datosEmpLiqFin.TipoRegimen#>
        <cfset lVarSDI = #LSNumberformat(datosEmpLiqFin.SDI,'_.00')#>
        <cfset lVarBanco = #datosEmpLiqfin.Banco#>
        <cfset lVarTipoContrato = #datosEmpLiqfin.Tipocontrato#>
        <cfset lVarTipoJornada =#rsTipoJornada.TipoJornada#>
        <cfset lVarSalarioBaseCotApor = #LSNumberformat(datosEmpLiqFin.SDI,'_.00')#>
        <cfset lVarPeriodicidadPago = #rsTipoJornada.PeriodicidadPago#>
        <cfset lVarRiesgoPuesto =#rsTipoJornada.riesgoPuesto#>
        <cfset lVarRegPatronal	= #rsRegPatronal.Pvalor#>
        <cfset lVarRetenciones=#NumberFormat(lVarImp_ISPT,'0.00')#>
		<cfset lVarPercepciones="">
        <cfset importeExento=0>
        <cfset importegravado=0>
        <cfset TotalExento=0>
        <cfset TotalGravado=0>

        <cfloop query="rsPercepciones">
        	<!---<cfset per = #find("Exent",rspercepciones.Descripcion)#>
            <cfif per EQ 0>--->
            	<cfset importeGravado=#NumberFormat(rspercepciones.RHLIgrabado,'_.00')#>
                <cfset importeExento=#NumberFormat(rspercepciones.RHLIexento,'_.00')#>
                <cfset TotalGravado = #NumberFormat(importeGravado+TotalGravado,'_.00')#>
                <cfset TotalExento = #NumberFormat(importeExento+TotalExento,'_.00')#>
                <cfset lVarTipoPercepcion = #rspercepciones.RHCSATid# >
                <cfset lVarClavePercepcion = #rspercepciones.Clave# >
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClavePercepcion#&"|"&#trim(rspercepciones.Descripcion)#&"|"&#importeGravado#&"|"&#importeExento# >
            <!---<cfelse>
                <cfset importeExento=#NumberFormat(rspercepciones.Importe,'_.00')#>
                 <cfset TotalExento = #NumberFormat(importeExento+TotalExento,'_.00')#>
                 <cfset lVarTipoPercepcion = #rspercepciones.RHCSATid#>
                 <cfset lVarClavePercepcion = #rspercepciones.Clave# >
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClavePercepcion#&"|"&#trim(rspercepciones.Descripcion)#&"|0.00|"&#importeExento#>
            </cfif>--->
        </cfloop>

        <cfset lVarSubTotal = #NumberFormat(TotalGravado+TotalExento,'_.00')#>
        <cfset lVarPercepciones=#NumberFormat(TotalGravado,'_.00')#&"|"&#NumberFormat(TotalExento,'_.00')#&#lVarPercepciones#>
		<cfset lVarDeducciones="0.00|"&#lVarTotalDeducciones#&#lVarDeducciones#>
		<cfset lVarCadenaOriginal="||3.2|"&#lVarFechaExpedicion#&"|egreso|Pago en una sola exhibicion|"
		&#lVarSubTotal#&"|0.00|1.00|"
		&#lVarMoneda#&"|"
		&#lVarTotal#&"|No Identificado|"
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
        <cfset lVarCadenaOriginal=#lVarCadenaOriginal#&"||">
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"á","a","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"é","e","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"í","i","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"ó","o","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"ú","u","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"ü","u","ALL")>
        <cfset lVarCadenaOriginal = replace(#lVarCadenaOriginal#,"  "," ","ALL")>
        <cfreturn lVarCadenaOriginal>
 	</cffunction>

	<cffunction name="CadenaOriginalReciboNominaCFDI"  access="private" returntype="string">
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

<!---            <cfset vTasa = 0>
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

            <cfset vCadenaOriginal =
            "|"&																									<!---Inicio Cadena--->
            "|"&"3.2"&																								<!---Version--->
            "|"&#DateFormat(now(),'yyyy-mm-ddTHH:mm:00')#&															<!---Fecha--->
            "|"&"egreso"&																							<!---Tipo Comprobante--->
            "|"&"Pago en una sola exhibición"&																		<!---forma de pago--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#"&		<!---Sub-Total--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEcargasempleado+rsSalarioEmpleado.SEdeducciones<!---+rsSalarioEmpleado.ImporteExento--->,'_.00')#"&		<!---Descuento--->
            <!---"|"&"Deducciones nómina"&--->																		<!---Motivo Descuento--->
            "|"&"#TipoCambio#"&																						<!---Tipo de Cambio--->
            "|"&<!---fnSecuenciasEscape--->trim(#rsLugarExpedicion.Miso4217#)&										<!---Moneda--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEliquido,'_.00')#"&												<!---Total--->
            "|"&"No Identificado"&																					<!---Metodo de Pago--->
            "|"&<!---fnSecuenciasEscape--->trim(#rsLugarExpedicion.LugarExpedicion#)&								<!---LugarExpedicion--->
            "|"&<!---fnSecuenciasEscape--->#trim(rsLugarExpedicion.Eidentificacion)#&								<!---RFCEmisor--->
            "|"&<!---fnSecuenciasEscape--->trim(#rsLugarExpedicion.Enombre#)&										<!---NombreEmisor--->
            <!---"|"&#fnSecuenciasEscape(rsLugarExpedicion.Pais)#&--->												<!---Pais--->
            "|"&<!---fnSecuenciasEscape--->trim(#rsLugarExpedicion.nombre_RegFiscal#)&								<!---Regimen--->
            "|"&<!---fnSecuenciasEscape--->trim(#rsReporte.RFC#)&													<!---RFCReceptor--->
            "|"&#vsNombre#&																							<!---NombreReceptor--->
            "|"&"1"&																								<!---Cantidad--->
            "|"&"Servicio"&																							<!---Unidad--->
            "|"&"Pago de nómina "&<!---fnSecuenciasEscape--->trim(#rsCalendarioPago.RCDescripcion#)&				<!---Descripcion--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#"&		<!---valorUnitario--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#"&		<!---importe--->
            "|"&"ISR"&																								<!---Tipo de impuesto--->
            <!---"|"&#vTasa#&--->																					<!---Tasa Impuesto ISR--->
            <!---"|"&"#LSNumberformat(0,'_.00')#"&--->																<!---Impuesto ISR--->
            <!---"|"&"#LSNumberformat(0,'_.00')#"&--->																<!---Det Impuesto ISR--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"&											<!---Impuesto ISR--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"&											<!---Impuesto ISR--->
            "|"&"1.1"&																							<!---Versión del Complemento--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.RegistroPatronal))#"&									<!---RegistroPatronal--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.Identificacion))#"&									<!---NumEmpleado--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.CURP))#"&												<!---CURP--->
            "|"&"#trim(rsReporte.TipoRegimen)#"&																	<!---Tipo Regimen--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.NumSeguridadSocial))#"&							<!---Número Seguridad Social--->
            "|"&"#DateFormat(rsReporte.fechaPago,'yyyy-mm-dd')#"&													<!---Fecha de Pago--->
            "|"&"#DateFormat(rsReporte.fechaDesde,'yyyy-mm-dd')#"&													<!---Fecha Inicial de Pago--->
            "|"&"#DateFormat(rsReporte.fechaHasta,'yyyy-mm-dd')#"&													<!---Fecha Final de Pago--->
            "|"&"#rsReporte.DiasLab#"&																				<!---NumDiasPagados--->
            "|"&"#trim(rsReporte.Departamento)#"&																	<!---Departamento--->
            "|"&"#trim(rsReporte.Banco)#"&																			<!---Banco--->
            "|"&"#DateFormat(rsReporte.FechaInicioRelLaboral,'yyyy-mm-dd')#"&										<!---FechaInicioRelLaboral--->
            "|"&"#rsReporte.Antiguedad#"&																			<!---Antiguedad--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.Puesto))#"&											<!---Puesto--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.TipoContrato))#"&										<!---Tipo Contrato--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.TipoJornada))#"&										<!---Tipo Jornada--->
            "|"&"#trim(<!---fnSecuenciasEscape--->(rsReporte.PeriodicidadPago))#"&									<!---Periodicidad Pago--->
            "|"&"#LSNumberformat(rsReporte.SalarioBaseCotApor,'_.00')#"&											<!---SalarioBaseCotApor--->
            "|"&"#rsReporte.RiesgoPuesto#"&																			<!---Riesgo Puesto--->
            "|"&"#LSNumberformat(rsReporte.SalarioDiarioIntegrado,'_.00')#"&									<!---Salario Diario Integrado--->
            "|"&"#LSNumberformat((PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto),'_.00')#"&				<!---Percepciones TotalGravado--->
            "|"&"#LSNumberformat(PercepcionesExe,'_.00')#"&													<!---Percepciones Total Exento--->

            "|"&"#rsSalarioSATcod.RHCSATcodigo#"&																	<!---Tipo Percepción--->
            "|"&"#trim(rsSalarioSATcod.CScodigo)#"&																	<!---Clave Percepción--->
            "|"&"#trim(rsSalarioSATcod.CSdescripcion)#"&															<!---Descripción Percepción--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.SEsalariobruto,'_.00')#"&									<!---Importe Gravado Percepción--->
            "|"&"0.00">																							<!---Importe Exento Percepción--->
            <cfloop query = "rsPercepciones">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsPercepciones.TipoPercepcion)#"& 													<!---Tipo Percepción--->
                "|"&"#trim(rsPercepciones.Clave)#"&																<!---Clave Percepción--->
                "|"&"#trim(rsPercepciones.Concepto)#"&															<!---Concepto Percepción--->
                "|"&"#LSNumberformat(rsPercepciones.ImporteGravado,'_.00')#"&									<!---Importe Gravado Percepción--->
                "|"&"#LSNumberformat(rsPercepciones.ImporteExento,'_.00')#">									<!---Importe Exento Percepción--->
            </cfloop>

            <cfset vCadenaOriginal = #vCadenaOriginal#&
            "|"&"#LSNumberformat(DeduccionesGrab,'_.00')#"&											<!---Deducciones TotalGravado--->
        "|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento+rsSalarioEmpleado.SEcargasempleado+DeduccionesExe,'_.00')#"&			<!---Deducciones Total Exento--->
            "|"&"002"&																							<!---Tipo Deducción--->
            "|"&"#right(('000000000000000'&trim(LB_Renta)),15)#"&												<!---Clave Deducción--->
            "|"&"#LB_Renta#"&																					<!---Descripción Deducción--->
            "|"&"0.00"&																							<!---Importe Gravado Deducción--->
            "|"&"#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#">										<!---Importe Exento Deducción--->
            <cfloop query = "rsCargasEmpl">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsCargasEmpl.TipoDeduccion)#"& 														<!---Tipo Deducción--->
                "|"&"#trim(rsCargasEmpl.Clave)#"&																<!---Clave Deducción--->
                "|"&"#trim(rsCargasEmpl.Concepto)#"&															<!---Concepto Deducción--->
                "|"&"#LSNumberformat(rsCargasEmpl.ImporteGravado,'_.00')#"&									<!---Importe Gravado Deducción--->
                "|"&"#LSNumberformat(rsCargasEmpl.ImporteExento,'_.00')#">										<!---Importe Exento Deducción--->
            </cfloop>
            <cfloop query = "rsDeducciones">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsDeducciones.TipoDeduccion)#"& 														<!---Tipo Deducción--->
                "|"&"#trim(rsDeducciones.Clave)#"&																<!---Clave Deducción--->
                "|"&"#trim(rsDeducciones.Concepto)#"&															<!---Concepto Deducción--->
                "|"&"#LSNumberformat(rsDeducciones.ImporteGravado,'_.00')#"&									<!---Importe Gravado Deducción--->
                "|"&"#LSNumberformat(rsDeducciones.ImporteExento,'_.00')#">										<!---Importe Exento Deducción--->
            </cfloop>

            <cfloop query = "rsAusentismos">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#trim(rsAusentismos.RHCSATcodigo)#"& 														<!---Tipo Ausentismo--->
                "|"&"#trim(rsAusentismos.TDcodigo)#"&															<!---Clave Ausentismo--->
                "|"&"#trim(rsAusentismos.RHTdesc)#"&															<!---Concepto Ausentismo--->
                "|"&"#LSNumberformat(rsAusentismos.ImporteGravado,'_.00')#"&								<!---Importe Gravado Ausentismo--->
                "|"&"#LSNumberformat(rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias,'_.00')#">				<!---Importe Exento Ausentismo--->
            </cfloop>

            <cfloop query ="rsIncapacidad">
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#LSNumberformat(rsIncapacidad.PEcantdias,'_.00')#"& 										<!---DiasIncapacidad--->
                "|"&"#rsIncapacidad.RHIncapcodigo#"&															<!---Tipo Incapacidad--->
                "|"&"#LSNumberformat(rsIncapacidad.Descuento,'_.00')#">											<!---Descuento--->
            </cfloop>

            <cfif rsHrsDobles.RecordCount gt 0>
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#LSNumberformat(rsHrsDobles.dias)#"&														<!---HorasExtraDobles Dias--->
                "|"&"Dobles"&																				<!---HorasExtraDobles TipoHoras--->
				"|"&"#LSNumberformat(rsHrsDobles.horas)#"&
                "|"&"#LSNumberformat(rsHrsDobles.monto,'_.00')#">												<!---HorasExtraDobles Importe--->
            </cfif>

            <cfif rsHrsTriples.RecordCount gt 0>
                <cfset vCadenaOriginal = #vCadenaOriginal#&
                "|"&"#LSNumberformat(rsHrsTriples.dias)#"&														<!---HorasExtraTriple Dias--->
                "|"&"Triples"&																				<!---HorasExtraTriple TipoHoras--->
				"|"&"#LSNumberformat(rsHrsTriples.horas)#"&
                "|"&"#LSNumberformat(rsHrsTriples.monto,'_.00')#">												<!---HorasExtraTriple Importe--->
            </cfif>

            <cfset vCadenaOriginal = #vCadenaOriginal#&"||"> 														<!---Fin de Cadena--->

            </cfoutput>
        </cfloop>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"á","a","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"é","e","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"í","i","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"ó","o","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"ú","u","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"ü","u","ALL")>
        <cfset vCadenaOriginal = replace(#vCadenaOriginal#,"  "," ","ALL")>

        <cfreturn vcadenaOriginal>
     </cffunction>

    <cffunction name="CadenaOriginalFacturaCFDI" access="private" returntype="string">
    	<cfargument name="OImpresionID" 			type="numeric" 	required="yes">
        <cfquery datasource="#session.dsn#" name="rsEmpresa">
            select a.Enombre, b.direccion1, b.direccion2, b.ciudad, b.estado, a.Eidentificacion , b.codPostal,
            a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
            from Empresa a
            inner join Direcciones b
            on a.id_direccion = b.id_direccion
            where a.Ecodigo = #session.Ecodigosdc#
        </cfquery>
        <cfquery name="rsRFCEmpresa" datasource="#session.DSN#">
            select Eidentificacion from Empresas
            where ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <cfquery name="rsDatosfac" datasource="#session.DSN#">
               SELECT distinct SNnombre, SNidentificacion, d.direccion1 as SNdireccion,
                      d.direccion2 as SNdireccion2,OItotal, OItotal as OItotalLetras,
                      OIimpuesto, OIDescuento,
                      OItotal + OIDescuento - OIimpuesto as OIsubtotal,
                      OIfecha, OIDdescripcion, OIDdescnalterna,
                      OIDCantidad,OIDtotal,OIDPrecioUni, OIObservacion,f.observaciones,
                      OIDdescuento, a.OIdiasvencimiento,Mnombre,
                      Oivencimiento,Ciudad+','+estado as LugarExpedicion,
                      a.OImpresionID as NUMERODOC  ,a.Ecodigo,
                      case a.CCTcodigo
                      	when  'FC' then 'ingreso'
                        when  'FA' then 'ingreso'
                        else  'egreso' end as tipoCFD,
                      datepart(dd,OIfecha),datepart(mm,OIfecha),datepart(yyyy,OIfecha),
                      datepart(hh,OIfecha),oidetalle,
					  SUBSTRING(ltrim(rtrim(convert(char,oifecha,120))),1,10)+'T'+convert(char,oifecha,108) as fechaFactura,
					  iporcentaje,oitipocambio,m.Miso4217,
                      a.codigo_TipoPago, a.codigo_RegFiscal, a.Cta_tipoPago, TP.nombre_TipoPago, RF.nombre_RegFiscal,Udescripcion
                      FROM minisif..FAEOrdenImpresion a
                      inner join minisif..FADOrdenImpresion b
                            on a.OImpresionID = b.OImpresionID
                            and a.Ecodigo = b.Ecodigo
                      INNER JOIN minisif..SNegocios c
                            on a.SNcodigo = c.SNcodigo
                            and a.Ecodigo = c.Ecodigo
                      LEFT JOIN  minisif..DireccionesSIF d
                            on a.id_direccionFact = d.id_direccion
                      LEFT JOIN  minisif..Monedas m
                            on a.mCodigo = m.Mcodigo
                      inner join minisif..FAPreFacturaE f
                            on a.oidocumento = f.ddocumentoref
                      inner JOIN minisif..FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo
                            and f.IDpreFactura=pfd.IDpreFactura
                      inner JOIN minisif..Conceptos con on pfd.Ecodigo =con.Ecodigo
                            and con.Cid=pfd.Cid
                      inner JOIN minisif..Unidades u on u.Ecodigo=con.Ecodigo
                            and con.Ucodigo= u.Ucodigo
                      inner join minisif..IMPUESTOS I
                            on b.icodigo = i.icodigo
                            and b.ecodigo = i.ecodigo
                      left join minisif..FATipoPago TP
                            on TP.Ecodigo = a.Ecodigo and TP.codigo_tipopago = a.codigo_tipopago
                      left join minisif..FARegFiscal RF
                            on RF.Ecodigo = a.Ecodigo and RF.codigo_RegFiscal = a.codigo_RegFiscal
                      WHERE a.OImpresionID =  #OImpresionID#
                      		and a.Ecodigo = #session.Ecodigo#
  					  order by oidetalle
        </cfquery>
        <cfset lVarNombreEmisor = rsEmpresa.Enombre>
        <cfset lVarRFCEmisor= rsRFCEmpresa.Eidentificacion>
        <cfset lVarNombreCliente = 	rsDatosfac.SNnombre>
        <cfset lVarRFCCliente = rsDatosfac.SNidentificacion>
        <cfset lVarDireccionCliente = rsDatosfac.SNdireccion>
        <cfset lVarSubTotal = rsDatosfac.OIsubtotal>
        <cfset lVarDescuento=rsDatosfac.OIDescuento>
        <cfset lVarTotal = rsDatosfac.OItotal>
        <cfset lVarImpuesto = rsDatosfac.OIimpuesto>
        <cfset lVarFechaExpedicion =rsDatosfac.fechaFactura>
        <cfset lVarTipoCFD=rsDatosfac.tipoCFD>
        <cfset lVarLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>>
        <cfset lVarTipoPagoId= rsDatosfac.codigo_TipoPago>
        <cfset lVarRegFiscalId = rsDatosfac.codigo_RegFiscal>
        <cfset lVarCtaPago= rsDatosfac.Cta_tipoPago>
        <cfset lVarTipoPago=rsDatosfac.nombre_TipoPago>
        <cfset lvarRegFiscal= rsDatosfac.nombre_RegFiscal>
        <cfset lVarPctjeImpuesto= rsDatosfac.iporcentaje>
        <cfset lVarTipoCambio = rsDatosfac.oitipocambio>
        <cfset lVarMoneda=rsDatosfac.Miso4217>
        <cfset lVarCadenaOriginal="||3.2">
        <cfset lVarConceptosFactura="">
        <cfset lVarIvaDetFactura="">
        <cfloop query="rsDatosfac" >
        	<cfset lVarCantidad  = rsDatosfac.OIDCantidad>
            <cfset lVarUniMedida = rsDatosfac.Udescripcion>
        	<cfset lVarDescripcion = rsDatosfac.OIDdescripcion &" " & rsDatosfac.OIDdescnalterna >
            <cfset lVarPrecioUnitario = rsDatosfac.OIDPrecioUni>
            <cfset lVarImporte= rsDatosfac.OIDtotal>
            <cfset lVarImp=(rsDatosfac.OIDtotal) * (lVarPctjeImpuesto/100)>
            <cfset lVarLinea = rsDatosfac.oidetalle>
            <cfset lVarConceptosFactura=#lVarConceptosFactura#&#lVarCantidad#&"|"&#lVarUniMedida#&"|"&#Replace(lVarDescripcion,"  "," ")#&"|"&#lVarPrecioUnitario#&"|"&#lVarImporte#>
            <cfset lVarIvaDetFactura=#lVarIvaDetFactura#&"IVA|"&#lVarPctjeImpuesto#&"|"&#lVarImp#>
        </cfloop>
        <!---<cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>--->
		<cfset lVarCadenaOriginal=#lVarCadenaOriginal#
		&"|"&#lVarFechaExpedicion#
		&"|"&#lVarTipoCFD#
		&"|Pago en una sola exhibicion|"
		&#lVarSubTotal#
		&"|"&#lVarDescuento#
		&"|"&#lVarTipoCambio#
		&"|"&#lVarMoneda#
		&"|"&#lVarTotal#
		&"|No Identificado|"
		&#lVarLugarExpedicion.LugarExpedicion#
		&"|"&#lVarNombreEmisor#
		&"|"&lVarRFCEmisor
		&"|"&#lVarConceptosFactura#&#lVarIvaDetFactura#>
        <cfset lVarCadenaOriginal = #lVarCadenaOriginal#&"||">
 		<cfthrow message="#lVarCadenaOriginal#">
        <cfreturn lVarCadenaOriginal>
    </cffunction>

    <cffunction name="GeneraSelloDigital" access="private" returntype="string">
    	<cfargument name="cadenaOriginal" 				type="string" 	required="yes">
        <cfquery name="datosSello" datasource="#session.dsn#">
        	select archivoKey, clave from RH_CFDI_Certificados
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>

        <!--- para instanciar la Clase GeneraCSD --->
		<cfobject type="java" class="generacsd.GeneraCSD" name="myGeneraCSD">

		<cfset selloDigital = myGeneraCSD.getSelloDigital(cadenaOriginal,datosSello.archivoKey,datosSello.clave)>

        <cfreturn selloDigital>
    </cffunction>

    <cffunction name="XML32ReciboNominaCFDI" access="private" returntype="string">
        <cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="RCNid" 					type="numeric" 	required="yes">
        <cfargument name="sello" 					type="string" 	required="yes">

        <cfinvoke key="LB_Renta" default="ISR" returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" />

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cfset rsCertificado 		 = GetCertificado()>

        <cfset rsReporte 		 = GetInfoNomina(#session.Ecodigo#,Arguments.DEid,Arguments.RCNid)>
        <cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>
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

            <cfset rsAusentismos = fnAusentismos(#rsReporte.IdNomina#,#rsReporte.DEid#)>

            <cfloop query = "rsAusentismos">
                <cfset DeduccionesGrab = #DeduccionesGrab# + #rsAusentismos.ImporteGravado#>
                <cfset DeduccionesExe  = #DeduccionesExe# + (#rsAusentismos.PEsaldiario#*#rsAusentismos.PEcantdias#)>
            </cfloop>


<!---            <cfset vTasa = 0>
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

            <CFXML VARIABLE="xml32">
            <Comprobante  xmlns:cfdi="http://www.sat.gob.mx/cfd/3"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:nomina="http://www.sat.gob.mx/nomina" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/nomina http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina11.xsd"  version="3.2" serie="#trim(fnSecuenciasEscape(rsReporte.Identificacion))#" folio="#trim(rsFechas.CPcodigo)#" fecha="#DateFormat(now(),'yyyy-mm-ddTHH:mm:00')#" sello="#vSello#" formaDePago="Pago en una sola exhibición" noCertificado="#vNumCertificado#" certificado="#vCertificado#"	subTotal="#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#" descuento="#LSNumberformat(rsSalarioEmpleado.SEcargasempleado+rsSalarioEmpleado.SEdeducciones<!---+rsSalarioEmpleado.ImporteExento--->,'_.00')#" motivoDescuento="Deducciones nómina" TipoCambio="#TipoCambio#" Moneda="#trim(fnSecuenciasEscape(rsLugarExpedicion.Miso4217))#" total="#LSNumberformat(rsSalarioEmpleado.SEliquido,'_.00')#" tipoDeComprobante="egreso" metodoDePago="No Identificado" LugarExpedicion="#trim(fnSecuenciasEscape(rsLugarExpedicion.LugarExpedicion))#">
                <Emisor nombre="#trim(fnSecuenciasEscape(rsLugarExpedicion.Enombre))#" rfc="#trim(fnSecuenciasEscape(rsLugarExpedicion.Eidentificacion))#"><!---<DomicilioFiscal pais="#trim(fnSecuenciasEscape(rsLugarExpedicion.Pais))#"/>---><RegimenFiscal Regimen="#trim(fnSecuenciasEscape(rsLugarExpedicion.nombre_RegFiscal))#"/>
                </Emisor><Receptor nombre="#vsNombre#" rfc="#trim(fnSecuenciasEscape(rsReporte.RFC))#"></Receptor><Conceptos><Concepto cantidad="1" unidad="Servicio" descripcion="Pago de nómina #trim(rsCalendarioPago.RCDescripcion)#" valorUnitario="#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#" importe="#LSNumberformat(rsSalarioEmpleado.SEsalariobruto+rsSalarioEmpleado.SEincidencias,'_.00')#" /></Conceptos><Impuestos  totalImpuestosRetenidos="#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"><Retenciones><Retencion impuesto="ISR" importe="#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#"/></Retenciones></Impuestos><Complemento><Nomina Version="1.1" RegistroPatronal="#trim(fnSecuenciasEscape(rsReporte.RegistroPatronal))#" NumEmpleado="#trim(fnSecuenciasEscape(rsReporte.Identificacion))#" CURP="#trim(fnSecuenciasEscape(rsReporte.CURP))#" TipoRegimen="#trim(rsReporte.TipoRegimen)#" NumSeguridadSocial="#trim(fnSecuenciasEscape(rsReporte.NumSeguridadSocial))#" FechaPago="#DateFormat(rsReporte.fechaPago,'yyyy-mm-dd')#" FechaInicialPago="#DateFormat(rsReporte.fechaDesde,'yyyy-mm-dd')#" FechaFinalPago="#DateFormat(rsReporte.fechaHasta,'yyyy-mm-dd')#" NumDiasPagados="#rsReporte.DiasLab#" Departamento="#trim(rsReporte.Departamento)#" Banco="#trim(rsReporte.Banco)#" FechaInicioRelLaboral="#DateFormat(rsReporte.FechaInicioRelLaboral,'yyyy-mm-dd')#" Antiguedad="#rsReporte.Antiguedad#" Puesto="#trim(fnSecuenciasEscape(rsReporte.Puesto))#" TipoContrato="#trim(fnSecuenciasEscape(rsReporte.TipoContrato))#" TipoJornada="#trim(fnSecuenciasEscape(rsReporte.TipoJornada))#" PeriodicidadPago="#trim(fnSecuenciasEscape(rsReporte.PeriodicidadPago))#" SalarioBaseCotApor="#LSNumberformat(rsReporte.SalarioBaseCotApor,'_.00')#" RiesgoPuesto="#rsReporte.RiesgoPuesto#" SalarioDiarioIntegrado="#LSNumberformat(rsReporte.SalarioDiarioIntegrado,'_.00')#"><Percepciones TotalGravado="#LSNumberformat(PercepcionesGrab+rsSalarioEmpleado.SEsalariobruto,'_.00')#" TotalExento="#LSNumberformat(PercepcionesExe,'_.00')#"><Percepcion TipoPercepcion="#rsSalarioSATcod.RHCSATcodigo#" Clave="#trim(rsSalarioSATcod.CScodigo)#" Concepto="#trim(rsSalarioSATcod.CSdescripcion)#" ImporteExento="0.00" ImporteGravado="#LSNumberformat(rsSalarioEmpleado.SEsalariobruto,'_.00')#" />
            <cfloop query = "rsPercepciones">
            <Percepcion TipoPercepcion="#trim(rsPercepciones.TipoPercepcion)#" Clave="#trim(rsPercepciones.Clave)#" Concepto="#trim(rsPercepciones.Concepto)#" ImporteExento="#LSNumberformat(rsPercepciones.ImporteExento,'_.00')#" ImporteGravado="#LSNumberformat(rsPercepciones.ImporteGravado,'_.00')#" />
            </cfloop>
            </Percepciones><Deducciones TotalGravado="#LSNumberformat(DeduccionesGrab,'_.00')#" TotalExento="#LSNumberformat(rsSalarioEmpleado.ImporteExento+rsSalarioEmpleado.SEcargasempleado+DeduccionesExe,'_.00')#"><Deduccion TipoDeduccion="002" Clave="#right(('000000000000000'&trim(LB_Renta)),15)#" Concepto="#LB_Renta#" ImporteExento="#LSNumberformat(rsSalarioEmpleado.ImporteExento,'_.00')#" ImporteGravado="0.00" />
            <cfloop query ="rsCargasEmpl">
            <Deduccion TipoDeduccion="#trim(rsCargasEmpl.TipoDeduccion)#" Clave="#trim(rsCargasEmpl.Clave)#" Concepto="#trim(rsCargasEmpl.Concepto)#" ImporteExento="#LSNumberformat(rsCargasEmpl.ImporteExento,'_.00')#" ImporteGravado="#LSNumberformat(rsCargasEmpl.ImporteGravado,'_.00')#" />
            </cfloop>
            <cfloop query ="rsDeducciones">
            <Deduccion TipoDeduccion="#trim(rsDeducciones.TipoDeduccion)#" Clave="#trim(rsDeducciones.Clave)#" Concepto="#trim(rsDeducciones.Concepto)#" ImporteExento="#LSNumberformat(rsDeducciones.ImporteExento,'_.00')#" ImporteGravado="#LSNumberformat(rsDeducciones.ImporteGravado,'_.00')#" />
            </cfloop>
            <cfloop query = "rsAusentismos">
            <Deduccion TipoDeduccion="#trim(rsAusentismos.RHCSATcodigo)#" Clave="#trim(rsAusentismos.TDcodigo)#" Concepto="#trim(rsAusentismos.RHTdesc)#" ImporteExento="#LSNumberformat(rsAusentismos.PEsaldiario*rsAusentismos.PEcantdias,'_.00')#" ImporteGravado="#LSNumberformat(rsAusentismos.ImporteGravado,'_.00')#" />
            </cfloop>
            </Deducciones>
            <cfif rsIncapacidad.RecordCount gt 0>
                <nomina:Incapacidades>
                        <cfloop query ="rsIncapacidad">
                        <Incapacidad DiasIncapacidad="#LSNumberformat(rsIncapacidad.PEcantdias,'_.00')#" TipoIncapacidad="#rsIncapacidad.RHIncapcodigo#" Descuento="#LSNumberformat(rsIncapacidad.Descuento,'_.00')#" />
                        </cfloop>
                </nomina:Incapacidades>
                        </cfif>
          	<cfif rsHrsDobles.RecordCount gt 0 or rsHrsTriples.RecordCount gt 0>
                <nomina:HorasExtras>
                        <cfif rsHrsDobles.RecordCount gt 0>
                        <nomina:HorasExtra Dias="#LSNumberformat(rsHrsDobles.dias)#" TipoHoras="Dobles" HorasExtra="#LSNumberformat(rsHrsDobles.horas)#" ImportePagado="#LSNumberformat(rsHrsDobles.monto,'_.00')#" />
                        </cfif>
                        <cfif rsHrsTriples.RecordCount gt 0>
                        <nomina:HorasExtra Dias="#LSNumberformat(rsHrsTriples.dias)#" TipoHoras="Triples" HorasExtra="#LSNumberformat(rsHrsTriples.horas)#" ImportePagado="#LSNumberformat(rsHrsTriples.monto,'_.00')#" />
                        </cfif>
                </nomina:HorasExtras>
            </cfif></Nomina></Complemento></Comprobante>
            </CFXML>
            </cfoutput>
        </cfloop>

        <cfset xml32 = replace(#xml32#,"="" ","=""","ALL")>
        <cfset xml32 = replace(#xml32#,"descuento="," descuento=","ALL")>
        <cfset xml32 = replace(#xml32#,"serie="," serie=","ALL")>
        <cfset xml32 = replace(#xml32#,"<Comprobante","<cfdi:Comprobante")>
        <cfset xml32 = replace(#xml32#,"<Emisor","<cfdi:Emisor")>
        <cfset xml32 = replace(#xml32#,"<DomicilioFiscal","<cfdi:DomicilioFiscal")>
        <cfset xml32 = replace(#xml32#,"<ExpedidoEn","<cfdi:ExpedidoEn")>
        <cfset xml32 = replace(#xml32#,"<RegimenFiscal","<cfdi:RegimenFiscal")>
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
        <cfset xml32 = replace(#xml32#,"<Nomina ","<nomina:Nomina ")>
        <cfset xml32 = replace(#xml32#,"<Percepciones ","<nomina:Percepciones ")>
        <cfset xml32 = replace(#xml32#,"<Percepcion ","<nomina:Percepcion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Percepciones>","</nomina:Percepciones>")>
        <cfset xml32 = replace(#xml32#,"<Deducciones ","<nomina:Deducciones ")>
        <cfset xml32 = replace(#xml32#,"<Deduccion ","<nomina:Deduccion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Deducciones>","</nomina:Deducciones>")>
        <cfset xml32 = replace(#xml32#,"<Incapacidad ","<nomina:Incapacidad ","ALL")>
        <cfset xml32 = replace(#xml32#,"<HorasExtra ","<nomina:HorasExtra ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Nomina>","</nomina:Nomina>")>
        <cfset xml32 = replace(#xml32#,"</Complemento>","</cfdi:Complemento>")>
        <cfset xml32 = replace(#xml32#,"</Comprobante>","</cfdi:Comprobante>")>

        <cfset xml32 = replace(#xml32#,"á","a","ALL")>
        <cfset xml32 = replace(#xml32#,"é","e","ALL")>
        <cfset xml32 = replace(#xml32#,"í","i","ALL")>
        <cfset xml32 = replace(#xml32#,"ó","o","ALL")>
        <cfset xml32 = replace(#xml32#,"ú","u","ALL")>
        <cfset xml32 = replace(#xml32#,"ü","u","ALL")>

        <cfreturn xml32>
     </cffunction>

     <cffunction name="XML32ReciboLiqFinCFDI" acces="private" returntype="string" >
     	<cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="DLlinea" 					type="numeric" 	required="yes">
        <cfargument name="sello" 					type="string" 	required="yes">
     	    <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
            <cfinvokeargument name="DLlinea" value="#Arguments.DLlinea#">
            <cfinvokeargument name="DEid" 	 value="#Arguments.DEid#">
        </cfinvoke>

        <cfset rsDeducFin = fnDeduccionesFiniquito(#Arguments.DLlinea#,#Arguments.DEid#)>

        <cfset rsCertificado = GetCertificado()>

        <cfset rsLugarExpedicion = GetLugarExpedicion(#session.Ecodigo#)>
        <cfset datosEmpLiqFin = fnGetdatosEmpLiqFin(#Arguments.DLlinea#)>
        <cfset rsRegPatronal	= fnGetDato(300)>
        <cfset rsTipoJornada = fnGettipoJornada(#Arguments.DEid#)>
        <cfset rsPercepciones= fnGetPercepciones(#Arguments.DLlinea#)>

        <cfset TotalDeducciones=fnGetTotalDeducciones(#Arguments.DLlinea#,#Arguments.DEid#)>
		<cfset lVarTotalDeducciones = #LSNumberformat(TotalDeducciones,'_.00')#>

        <cfset lVarEmisor = #session.Enombre#>
        <cfset lVarRFCEmisor = #rsLugarExpedicion.Eidentificacion#>
        <cfset lVarLugarExpedicion =#rsLugarExpedicion.LugarExpedicion#>
        <cfset lVarMoneda=#rsLugarExpedicion.Miso4217#>
        <cfset lVarTotal = #LSNumberformat(rsLF.RHLFLRESULTADO,'_.00')#>
        <cfset lVarRegFiscal =#rsLugarExpedicion.nombre_RegFiscal#>
        <cfset lVarFechaExpedicion=#DateFormat(now(),'yyyy-mm-ddTHH:mm:00')#>
        <cfset lVarNoEmp  = #datosEmpLiqFin.DEidentificacion#>
		<cfset lVarNombreEmp = #datosEmpLiqFin.Nombrecompleto#>
        <cfset lVarRFCEmp = #datosEmpLiqFin.RFC#>
        <cfset lVarCURP = #datosEmpLiqFin.CURP#>
        <cfset lVarNoSegSocial = #datosEmpLiqFin.SeguroSocial#>
        <cfset lVarMotivoBaja =  #datosEmpLiqFin.MotivoBaja#>
        <cfset lVarpuesto  = #datosEmpLiqFin.Puesto#>
        <cfset lVarDepartamento = #datosEmpLiqFin.Departamento#>
        <cfset lVarFechaIngreso = #DateFormat(datosEmpLiqFin.FechaIngreso,'yyyy-mm-dd')#>
        <cfset lVarFechaBaja = #DateFormat(datosEmpLiqFin.FechaBaja,'yyyy-mm-dd')#>
        <cfset lVarAntiguedad= #datosEmpLiqFin.Antiguedad#>
        <cfset lVarTipoRegimen=#datosEmpLiqFin.TipoRegimen#>
        <cfset lVarSDI = #LSNumberformat(datosEmpLiqFin.SDI,'_.00')#>
        <cfset lVarBanco = #datosEmpLiqfin.Banco#>
        <cfset lVarTipoContrato = #datosEmpLiqfin.Tipocontrato#>
        <cfset lVarTipoJornada =#rsTipoJornada.TipoJornada#>
        <cfset lVarSalarioBaseCotApor = #LSNumberformat(datosEmpLiqFin.SDI,'_.00')#>
        <cfset lVarPeriodicidadPago = #rsTipoJornada.PeriodicidadPago#>
        <cfset lVarRiesgoPuesto =#rsTipoJornada.riesgoPuesto#>
        <cfset lVarRegPatronal	= #rsRegPatronal.Pvalor#>
		<cfset lVarPercepciones="">
        <cfset importeExento=0>
        <cfset importegravado=0>
        <cfset TotalExento=0>
        <cfset TotalGravado=0>
        <cfset lVarPerTotalGravado=0>
        <cfset lVarPerTotalExento=0>

        <cfloop query="rsPercepciones">
        	<!---<cfset per = #find("Exent",rspercepciones.Descripcion)#>
            <cfif per EQ 0>--->
            	<cfset importeGravado=#NumberFormat(rspercepciones.RHLIgrabado,'_.00')#>
                <cfset importeExento=#NumberFormat(rspercepciones.RHLIexento,'_.00')#>
                <cfset lVarPerTotalGravado = #NumberFormat(importeGravado+lVarPerTotalGravado,'_.00')#>
                <cfset lVarPerTotalExento = #NumberFormat(importeExento+lVarPerTotalExento,'_.00')#>
                <cfset lVarTipoPercepcion = #rspercepciones.RHCSATid# >
                <cfset lVarClavePercepcion = #rspercepciones.Clave# >
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClavePercepcion#&"|"&#trim(rspercepciones.Descripcion)#&"|"&#importeGravado#&"|"&#importeExento# >
           <!--- <cfelse>
                <cfset importeExento=#NumberFormat(rspercepciones.Importe,'_.00')#>
                 <cfset lVarPerTotalExento = #NumberFormat(importeExento+lVarPerTotalExento,'_.00')#>
                 <cfset lVarTipoPercepcion = #rspercepciones.RHCSATid#>
                <cfset lVarClave=#rspercepciones.Clave#>
                <cfset lVarPercepciones = #lVarPercepciones#&"|"&#lVarTipoPercepcion#&"|"&#lVarClave#&"|"&#rspercepciones.Descripcion#&"|0.00|"&#importeExento#>
            </cfif>--->
        </cfloop>

        <cfset lVarSubTotal = #NumberFormat(lVarPerTotalGravado+lVarPerTotalExento,'_.00')#>
        <cfset lVarPercepciones=#NumberFormat(lVarPerTotalGravado,'_.00')#&"|"&#NumberFormat(lVarPerTotalExento,'_.00')#&#lVarPercepciones#>
		<cfset lVarDeducciones="">
        <cfset lVarImp_ISPT=0>
        <cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF GT 0>
        	<cfset DeduccionISPTFiniquito="ISPT Finiquito">
            <cfset importeISPTFiniquito=#NumberFormat(rsLF.RHLFLisptF,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|TipoDeduccion|Clave|ISPT Finiquito|0.00|"&#importeISPTFiniquito#>
            <cfset lVarImp_ISPT = #lVarImp_ISPT# + rsLF.RHLFLisptF>
        </cfif>
         <cfif rsLF.RHLFLISPTRealL GT 0>
         	<cfset DeduccionISPTRL = "ISPT Real Liquidación">
            <cfset importeDeduccionISPTRL= #NumberFormat(rsLF.RHLFLISPTRealL/100,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|TipoDeduccion|Clave|ISPT Real Liquidación|0.00|"&#importeDeduccionISPTRL#>
            <cfset lVarImp_ISPT = #lVarImp_ISPT# + (rsLF.RHLFLISPTRealL/100)>
         </cfif>
         <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit GT 0>
         	<cfset DeduccionCreditoInfonavit="Credito Infonavit">
            <cfset importeDeduccionInfonavit = #NumberFormat(rsLF.RHLFLinfonavit,'0.00')#>
            <cfset lVarDeducciones=#lVarDeducciones#&"|TipoDeduccion|Clave|Crédito Infonavit|0.00|"&#importeDeduccionInfonavit#>
         </cfif>
		<cfset lVarDeducciones="0.00|"&#lVarTotalDeducciones#&#lVarDeducciones#>

        <cfset vNumCertificado = "#rsCertificado.NoCertificado#">
        <cfset vSello = "#sello#">
        <cfset vCertificado = "#rsCertificado.certificado#">

           <cfoutput>
            <CFXML VARIABLE="xml32">
        		<Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/3"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:nomina="http://www.sat.gob.mx/nomina" xsi:schemaLocation="http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/nomina http://www.sat.gob.mx/sitio_internet/cfd/nomina/nomina11.xsd"
                version="3.2" serie="#lVarNoEmp#" folio="#Arguments.DLlinea#" fecha="#DateFormat(now(),'yyyy-mm-ddTHH:mm:00')#" sello="#vSello#" formaDePago="Pago en una sola exhibición" noCertificado="#vNumCertificado#" certificado="#vCertificado#"	subTotal="#lVarSubTotal#" descuento="0.00" TipoCambio="1.00" Moneda="#trim(fnSecuenciasEscape(rsLugarExpedicion.Miso4217))#" total="#LSNumberformat(lVarTotal,'_.00')#" tipoDeComprobante="egreso" metodoDePago="No Identificado" LugarExpedicion="#trim(fnSecuenciasEscape(lVarLugarExpedicion))#" >

                <Emisor nombre="#trim(fnSecuenciasEscape(lVarEmisor))#" rfc="#trim(fnSecuenciasEscape(lVarRFCEmisor))#">
                	<RegimenFiscal Regimen="#trim(fnSecuenciasEscape(lVarRegFiscal))#"/>
                </Emisor>
                <Receptor nombre="#lVarNombreEmp#" rfc="#trim(fnSecuenciasEscape(lVarRFCEmp))#"></Receptor>
                <Conceptos>
                <Concepto cantidad="1" unidad="Servicio" descripcion="Pago de #trim(lVarMotivoBaja)#" valorUnitario="#LSNumberformat(lVarSubTotal,'_.00')#" importe="#LSNumberformat(lVarSubTotal,'_.00')#" /></Conceptos>
                <Impuestos totalImpuestosRetenidos="#LSNumberformat(lVarImp_ISPT,'_.00')#"><Retenciones><Retencion impuesto="ISR" importe="#LSNumberformat(lVarImp_ISPT,'_.00')#"/></Retenciones></Impuestos>
                <Complemento>
                <Nomina Version="1.1" RegistroPatronal="#trim(lVarRegPatronal)#" NumEmpleado="#lVarNoEmp#" CURP="#trim(lVarCURP)#" TipoRegimen="#trim(lVarTipoRegimen)#" NumSeguridadSocial="#trim(lVarNoSegSocial)#" FechaPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#"  FechaInicialPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#" FechaFinalPago="#DateFormat(lVarFechaBaja,'yyyy-mm-dd')#" NumDiasPagados="0" Departamento="#trim(lVarDepartamento)#" Banco="#trim(lVarBanco)#"  FechaInicioRelLaboral="#DateFormat(lVarFechaIngreso,'yyyy-mm-dd')#" Antiguedad="#lVarAntiguedad#" Puesto="#trim(fnSecuenciasEscape(lVarpuesto))#" TipoContrato="#trim(lVarTipoContrato)#" TipoJornada="#trim(lVarTipoJornada)#" PeriodicidadPago="#trim(lVarPeriodicidadPago)#" SalarioBaseCotApor="#LSNumberformat(lVarSalarioBaseCotApor,'_.00')#" RiesgoPuesto="#lVarRiesgoPuesto#" SalarioDiarioIntegrado="#LSNumberformat(lVarSDI,'_.00')#"  >
                <Percepciones TotalGravado="#LSNumberformat(lVarPerTotalGravado,'_.00')#" TotalExento="#LSNumberformat(lVarPerTotalExento,'_.00')#">
                <cfloop query="rsPercepciones">
				<Percepcion TipoPercepcion="#rspercepciones.RHCSATid#" Clave="#rspercepciones.Clave#" Concepto="#trim(rsPercepciones.Descripcion)#" ImporteExento="#LSNumberformat(rsPercepciones.RHLIexento,'_.00')#" ImporteGravado="#LSNumberformat(rsPercepciones.RHLIgrabado,'_.00')#"></Percepcion>
                </cfloop>
                </Percepciones>
                <Deducciones TotalGravado="0.00" TotalExento="#LSNumberformat(lVarTotalDeducciones,'_.00')#">
                <cfif len(trim('rsLF.RHLFLisptF')) and rsLF.RHLFLisptF GT 0>
                <Deduccion TipoDeduccion="002" Clave="00000000000ISPT" Concepto="ISPT Finiquito" ImporteExento="#LSNumberformat(rsLF.RHLFLisptF,'_.00')#" ImporteGravado="0.00"></Deduccion></cfif>
                <cfif rsLF.RHLFLISPTRealL GT 0><Deduccion TipoDeduccion="002" Clave="00000000000ISPT" Concepto="ISPT Real Liquidación" ImporteExento="#LSNumberformat(rsLF.RHLFLISPTRealL/100,'_.00')#" ImporteGravado="0.00"></Deduccion></cfif>
                <cfif len(trim('rsLF.RHLFLinfonavit')) and rsLF.RHLFLinfonavit GT 0><Deduccion TipoDeduccion="009" Clave="00000000INFONAVIT" Concepto="Credito Infonavit" ImporteExento="#LSNumberformat(rsLF.RHLFLinfonavit,'_.00')#" ImporteGravado="0.00"></Deduccion></cfif>

                 <cfloop query="rsDeducFin">
                    <Deduccion TipoDeduccion="#trim(rsDeducFin.RHCSATcodigo)#" Clave="#trim(rsDeducFin.TDcodigo)#" Concepto="#trim(rsDeducFin.RHLDdescripcion)#" ImporteExento="#LSNumberformat(rsDeducFin.importe,'_.00')#" ImporteGravado="0.00"></Deduccion>
                </cfloop>

                </Deducciones>
                 </Nomina>
                </Complemento>
                </Comprobante>
        	</CFXML>
            </cfoutput>

        <cfset xml32 = replace(#xml32#,"="" ","=""","ALL")>
        <cfset xml32 = replace(#xml32#,"descuento="," descuento=","ALL")>
        <cfset xml32 = replace(#xml32#,"serie="," serie=","ALL")>
        <cfset xml32 = replace(#xml32#,"<Comprobante","<cfdi:Comprobante")>
        <cfset xml32 = replace(#xml32#,"<Emisor","<cfdi:Emisor")>
        <cfset xml32 = replace(#xml32#,"<DomicilioFiscal","<cfdi:DomicilioFiscal")>
        <cfset xml32 = replace(#xml32#,"<ExpedidoEn","<cfdi:ExpedidoEn")>
        <cfset xml32 = replace(#xml32#,"<RegimenFiscal","<cfdi:RegimenFiscal")>
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
        <cfset xml32 = replace(#xml32#,"<Nomina ","<nomina:Nomina ")>
        <cfset xml32 = replace(#xml32#,"<Percepciones ","<nomina:Percepciones ")>
        <cfset xml32 = replace(#xml32#,"<Percepcion ","<nomina:Percepcion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Percepciones>","</nomina:Percepciones>")>
        <cfset xml32 = replace(#xml32#,"<Deducciones ","<nomina:Deducciones ")>
        <cfset xml32 = replace(#xml32#,"<Deduccion ","<nomina:Deduccion ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Deducciones>","</nomina:Deducciones>")>
        <cfset xml32 = replace(#xml32#,"<Incapacidad ","<nomina:Incapacidad ","ALL")>
        <cfset xml32 = replace(#xml32#,"<HorasExtra ","<nomina:HorasExtra ","ALL")>
        <cfset xml32 = replace(#xml32#,"</Nomina>","</nomina:Nomina>")>
        <cfset xml32 = replace(#xml32#,"</Complemento>","</cfdi:Complemento>")>
        <cfset xml32 = replace(#xml32#,"</Comprobante>","</cfdi:Comprobante>")>

        <cfset xml32 = replace(#xml32#,"á","a","ALL")>
        <cfset xml32 = replace(#xml32#,"é","e","ALL")>
        <cfset xml32 = replace(#xml32#,"í","i","ALL")>
        <cfset xml32 = replace(#xml32#,"ó","o","ALL")>
        <cfset xml32 = replace(#xml32#,"ú","u","ALL")>
        <cfset xml32 = replace(#xml32#,"ü","u","ALL")>
        <cfset xml32 = replace(#xml32#,"  "," ","ALL")>

     	<cfreturn xml32>
     </cffunction>

    <cffunction name="XML32FacturaCFDI" access="private" returntype="string">
    	<cfargument name="OImpresionID" 			type="numeric" 	required="yes">

    	<cfreturn xml32>
    </cffunction>

    <cffunction name="TimbraXML" access="private" returntype="string">
    	<cfargument name="xml32" 					type="string" 	required="yes">
        <cfargument name="DEid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="RCNid" 					type="numeric" 	required="no" default="-1">
        <cfargument name="DLlinea" 					type="numeric" 	required="no" default="-1">
        <cfargument name="OImpresionID" 			type="numeric" 	required="no" default="-1">

        <cfquery name="getUrl" datasource="#session.dsn#">
        	select Pvalor from Parametros where Ecodigo=#session.Ecodigo#
            and Mcodigo='FA' and Pcodigo = 440
        </cfquery>

        <cfquery name="getToken" datasource="#session.dsn#">
        	select Pvalor from Parametros where Ecodigo=#session.Ecodigo#
            and Mcodigo='FA' and Pcodigo = 445
        </cfquery>

        <cfquery name="getUsr" datasource="#session.dsn#">
        	select Pvalor from Parametros where Ecodigo=#session.Ecodigo#
            and Mcodigo='FA' and Pcodigo = 442
        </cfquery>

        <cfquery name="getPwd" datasource="#session.dsn#">
        	select Pvalor from Parametros where Ecodigo=#session.Ecodigo#
            and Mcodigo='FA' and Pcodigo = 443
        </cfquery>

        <cfquery name="getCta" datasource="#session.dsn#">
        	select Pvalor from Parametros where Ecodigo=#session.Ecodigo#
            and Mcodigo='FA' and Pcodigo = 444
        </cfquery>


        <cfquery name="getDatosCert" datasource="#session.dsn#">
        	select archivoKey from RH_CFDI_Certificados
        </cfquery>
        <cfset vsPath = #getDatosCert.archivoKey#>
        <cfset vsPath = left(vsPath,22)>
        <!---<cfset vsPath_A = "D:">--->
	<cfset vsPath_A = left(vsPath,2)>

        <cfset LvarToken="#getToken.Pvalor#" >
		<cfset LvarUsuario="#getUsr.Pvalor#" >
		<cfset LvarPassword="#getPwd.Pvalor#" >
		<cfset LvarCuenta="#getCta.Pvalor#" >
        <cfset LvarUrl = "#getUrl.Pvalor#">
        <!---<cfset long=#len(xml32)#>
        <cfthrow message="#long# -#xml32#-">--->
        <!--- Validacion y creacion de carpetar para almacenar Facturas --->
        <cf_foldersFacturacion>
		<cfset xmlTimbrado="">
		<!--- ERBG Se comenta para el timbrado manual
		<cfinvoke webservice="#LvarUrl#"
            method="get"
            returnvariable="xmlTimbrado">
            <cfinvokeargument name="cad" value = #xml32#/>
            <cfinvokeargument name="tk" value = #Lvartoken#/>
            <cfinvokeargument name="user" value = #LvarUsuario#/>
            <cfinvokeargument name="pass" value = #LvarPassword#/>
            <cfinvokeargument name="cuenta" value = #LvarCuenta#/>
        </cfinvoke>
		--->

        <!--- guardando el mxl en el server de coldfucion --->
        <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
        	<cfquery name="rsEmp" datasource="#session.dsn#">
                select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
                from DatosEmpleado
                where DEid = #Arguments.DEid#
            </cfquery>
            <cfquery name="rsNomina" datasource="#session.dsn#">
            	select RCDescripcion from HRCalculoNomina
                where RCNid=#Arguments.RCNid#
            </cfquery>

		<cfset archivoXmlT=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\#rsEmp.Emp#_#rsNomina.RCDescripcion#T.xml">
	<!---<cfset archivoXmlT="c:\Enviar\#rsEmp.Emp#_#rsNomina.RCDescripcion#T.xml">--->


         </cfif>
         <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
         	<cfquery name="rsEmp" datasource="#session.dsn#">
                select DEidentificacion + '_'+ DEnombre + ' ' + DEapellido1 +' ' + DEapellido2 as Emp
                from DatosEmpleado
                where DEid = #Arguments.DEid#
            </cfquery>
            <cfquery name="rsBaja" datasource="#session.dsn#">
            	select {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
                dateadd(dd, -1, c.DLfvigencia) as FechaBaja,
                g.RHTdesc MotivoBaja
                from RHLiquidacionPersonal a
                inner join DatosEmpleado b on a.DEid = b.DEid
   				inner join DLaboralesEmpleado c on a.DLlinea = c.DLlinea
                inner join RHTipoAccion g on c.RHTid = g.RHTid
                where a.DLlinea =#Arguments.DLlinea#
            </cfquery>
            <cfset archivoXmlT=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\#rsEmp.Emp#_#rsBaja.MotivoBaja##DateFormat(rsBaja.FechaBaja,'yyyymmdd')#T.xml">

	    <!---
            <cfset archivoXmlT="c:\Enviar\#rsEmp.Emp#_#rsBaja.MotivoBaja##DateFormat(rsBaja.FechaBaja,'yyyymmdd')#T.xml">
		--->

         </cfif>
         <cfif OImpresionID GT 0>
         	<cfset archivoXmlT=#vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\FE_#OImpresionID#T.xml">
         	<!---<cfset archivoXmlT="c:\Enviar\FE_#OImpresionID#T.xml">--->
         </cfif>
         <!---ERBG Cambio para la Ñ charset="utf-8"--->
         <CFFILE ACTION="WRITE" FILE="#archivoXmlT#" OUTPUT="#ToString(xmlTimbrado)#" charset="utf-8">
         <!--- parseando el xml --->


         <!---<cfset archivoXmlT=#vsPath_A#&"\Enviar\FE_8_508T.xml">--->

		 <!--- ERBG Timbrado Manual
		 <cfset MyXMLDoc = xmlParse(archivoXmlT)>
		 --->
		<!--- cargando variables --->

		<cfset lVarXmlTimbrado = replace("#xmlTimbrado#","""","\""","All")>
        <cfset lVarXmlTimbrado = replace("#xmlTimbrado#","'","''","All")>

		<cftry>

		<!--- ERBG Timbrado Manual

         	<cfset lVarTotal=MyXMLDoc.Comprobante.XmlAttributes.total>
        	<cfset lVarRFCemisor=MyXMLDoc.Comprobante.Emisor.XmlAttributes.rfc>
            <cfset lVarRFCreceptor=MyXMLDoc.Comprobante.Receptor.XmlAttributes.rfc>
			<cfset lVarTimbre = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID>
            <cfset lVarCertificadoSAT = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.noCertificadoSAT>
            <cfset lVarSelloCFD = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.selloCFD>
            <cfset lVarSelloSAT = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.selloSAT>
            <cfset lVarFechaTimbrado = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.FechaTimbrado>
            <cfset lVarVersion = MyXMLDoc.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.version>
            <cfset lVarCadenaSAT = "||#lVarVersion#|#lVarTimbre#|#lVarFechaTimbrado#|#lVarSelloCFD#|#lVarCertificadoSAT#||">
            <cfset lvarEstado = 1>

            <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
                <cfquery name="updReciboCFDI" datasource="#session.dsn#">
                    UPDATE RH_CFDI_RecibosNomina
                       SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
                           timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
                           certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
                           cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
                           selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
                           fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                           stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">
                     	   WHERE Ecodigo = #session.Ecodigo#
                       	   AND DEid = #Arguments.DEid#
                       	   AND RCNid = #Arguments.RCNid#
                </cfquery>
        	</cfif>
             <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                <cfquery name="updLiqFinCFDI" datasource="#session.dsn#">
                    UPDATE RH_CFDI_RecibosNomina
                       SET xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">,
                           timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarTimbre#">,
                           certificadoSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCertificadoSAT#">,
                           cadenaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarCadenaSAT#">,
                           selloSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarSelloSAT#">,
                           fechaTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarFechaTimbrado#">,
                           stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">
                     	   WHERE Ecodigo = #session.Ecodigo#
                       	   AND DEid = #Arguments.DEid#
                       	   AND RCNid = #Arguments.RCNid#
                           AND DLlinea = #Arguments.DLlinea#
                </cfquery>
        	</cfif>

		--->

            <cfif OImpresionID GT 0>
            	<!--- aqui  el  update a la db_FacturaEmitida--->
            </cfif>
        <cfcatch type="any">
            <cftry>
                <cfset lVarError = MyXMLDoc.ERROR>
                <cfset lVarErrorCode = MyXMLDoc.ERROR.XmlAttributes.codError>
                <cfset lvarEstado = 2>

                <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
                    <cfquery name="updReciboCFDI" datasource="#session.dsn#">
                        UPDATE RH_CFDI_RecibosNomina
                           SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                           xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                        WHERE Ecodigo = #session.Ecodigo#
                               AND DEid = #Arguments.DEid#
                               AND RCNid = #Arguments.RCNid#
                    </cfquery>
                </cfif>
                <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
                    <cfquery name="updReciboCFDI" datasource="#session.dsn#">
                        UPDATE RH_CFDI_RecibosNomina
                           SET stsTimbre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEstado#">,
                           xmlTimbrado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lVarXmlTimbrado#">
                        WHERE Ecodigo = #session.Ecodigo#
                               AND DEid = #Arguments.DEid#
                               AND RCNid = #Arguments.RCNid#
                               AND DLlinea = #Arguments.DLlinea#
                    </cfquery>
                </cfif>
                <cfif OImpresionID GT 0>
            		<!--- aqui  el  update a la db_FacturaEmitida con error--->
            	</cfif>
                <!---<cfoutput>
                    #lVarErrorCode# &nbsp;
                    #lVarError#<br>
                </cfoutput>--->
            <cfcatch type="any">
            	  <!---<cfthrow type="Invalid_XML" message="XML incorrecto #rsEmp.Emp#">--->
            </cfcatch>
            </cftry>
        </cfcatch>
        </cftry>

        <cfif Arguments.DEid GT 0 and Arguments.RCNid GT 0>
        	<cfset imgQR = #vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\imgQR\#DEid#_#RCNid#.jpg">
        </cfif>
        <cfif Arguments.DEid GT 0 and Arguments.DLlinea GT 0>
        	<cfset imgQR = #vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\imgQR\#DEid#_#RCNid##DLlinea#.jpg">
        </cfif>
        <cfif OImpresionID GT 0>
        	<cfset imgQR = #vsPath_A#&"\Enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\imgQR\FE_#Serie##Folio#.jpg">
        </cfif>
	<!--- ERBG Timbrado Manual
        <cfif lvarEstado EQ 1>
            <cfset lVarTotal = #LSNumberformat(lVarTotal,'0000000000.000000')#>
	    <cfset cadenaQR = "?re=#lVarRFCemisor#&rr=#lVarRFCreceptor#&tt=#lVarTotal#&id=#lVarTimbre#">

            <cfobject type="java" class="generacsd.TestQRCode" name="myTestQRCode">

            <cfset image = myTestQRCode.generateQR(imgQR,cadenaQR,300,300)>
            <cfquery name="upCodigoQR" datasource="#session.dsn#">
            	UPDATE RH_CFDI_RecibosNomina
                           SET codigoQR ='#imgQR#'
                        WHERE Ecodigo = #session.Ecodigo#
                               AND DEid = #Arguments.DEid#
                               AND RCNid = #Arguments.RCNid#
                               AND DLlinea =#Arguments.DLlinea#
            </cfquery>
         <cfelseif lvarEstado EQ 2>

        </cfif>
	--->
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
            select coalesce(Pvalor,'SIN REG') as Pvalor
            from RHParametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfreturn #rs#>
    </cffunction>

    <cffunction name="GetCertificado" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>
        <cfquery name="rsCertificado" datasource="#session.dsn#">
            select coalesce(NoCertificado,'NA') as NoCertificado, coalesce(certificado,'NA') as certificado, coalesce(archivoKey,'NA') as llave
            from RH_CFDI_Certificados
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfreturn rsCertificado>
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

    <cffunction name="GetLugarExpedicion" access="public" returntype="query">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">

        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>

        <cfquery name="rsDatosLugarExpedicion" datasource="#session.DSN#">
            select coalesce(e.Enombre,'') as Enombre, coalesce(replace(e.Eidentificacion,'-',''),'') as Eidentificacion,
            coalesce(d.ciudad,'')+', '+coalesce(d.estado,'') as LugarExpedicion,ms.Mcodigo,m.Miso4217,r.nombre_RegFiscal,
            coalesce(d.Ppais,'') as Pais
            from Empresa e
            inner join Empresas es
            on e.Ecodigo=es.EcodigoSDC
            inner join Direcciones d
            on e.id_direccion = d.id_direccion
            inner join Moneda m
            on e.Mcodigo = m.Mcodigo
            inner join Monedas ms
            on ms.Miso4217 = m.Miso4217
            inner join FARegFiscal r
            on r.Ecodigo=es.Ecodigo
            where es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>

        <cfreturn rsDatosLugarExpedicion>
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
        </cf_dbtemp>

        <cfquery datasource="#session.dsn#" name="rsEmpleados">
            insert #salida# (DEid,IdNomina, Identificacion, Nombre,Ape1,Ape2,DEdato1,RFC, FechaDesde, FechaHasta, fechaPago,CSsalario,
            RegistroPatronal,
            CURP, TipoRegimen,NumSeguridadSocial,
            Departamento,CLABE,Banco,
            FechaInicioRelLaboral,
            Antiguedad,
            Puesto,
            TipoContrato,
            TipoJornada,PeriodicidadPago,SalarioBaseCotApor,RiesgoPuesto,SalarioDiarioIntegrado,Mcodigo )
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
                (select top(1) LTdesde from LineaTiempo lt where lt.Deid=a.Deid order by LTdesde) as FechaInicioRelLaboral,
                DATEDIFF(WW,(select top(1) LTdesde from LineaTiempo lt where lt.Deid=a.Deid order by LTdesde),c.CPhasta) as Antiguedad,
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
				tc.TCclave as TipoContratacion,
                (select top(1) p.RHJdescripcion
                from LineaTiempo lt
                inner join RHJornadas p on lt.RHJid = p.RHJid
                where lt.Deid=a.Deid order by LTdesde DESC) as TipoJornada,

                (select top(1)
                    case p.Ttipopago
                        when '3' then 'Mensual'
                        when '2' then 'Quincenal'
                        when '1' then 'Bisemanal'
                        when '0' then 'Semanal'
                        else 'ND'
                    end as PeriodicidadPago
                from LineaTiempo lt
                inner join TiposNomina p on lt.Tcodigo = p.Tcodigo and lt.Ecodigo=p.Ecodigo
                where lt.Deid=a.Deid order by LTdesde DESC) as PeriodicidadPago,

<!---                (select top(1) lt.LTsalario
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

<!---                (select top(1) lt.LTsalarioSDI
                from LineaTiempo lt
                where lt.Deid=a.Deid
                order by LTdesde DESC) as SalarioDiarioIntegrado,
--->
				tc.TCdescr
				a.DEsdi as SalarioDiarioIntegrado,
                a.Mcodigo
            from DatosEmpleado a
				inner join CSATTiposContratacion tc
					on tc.IdTipoContratacion = a.DEtipocontratacion
                inner join LineaTiempo b
                    on a.DEid = b.DEid
                inner join DLineaTiempo d
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
                                            where pe.DEid = #salida#.DEid and pe.RCNid = #salida#.IdNomina),0)
        </cfquery>
        <!--- Consultas para el Reporte --->
        <cfquery name="rsReporte" datasource="#session.dsn#">
            select *
            from #salida#
            order by Ape1,Ape2,Nombre
        </cfquery>
        <cfreturn rsReporte>
    </cffunction>

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
        </cf_dbtemp>

        <cfset vSalarioEmpleado 	= 'HSalarioEmpleado'>
        <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
        <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
        <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
        <cfset vPagosEmpleado 		= 'HPagosEmpleado'>
        <cfset vCargasCalculo 		= 'HCargasCalculo'>
        <cfset vRHSubsidio          = 'HRHSubsidio'>

        <cfquery datasource="#session.dsn#" >
            insert #Percepciones#(DEid,RCNid,Clave,TipoPercepcion,Concepto,ImporteExento,ImporteGravado)
                select hic.DEid,hic.RCNid,right(('000000000000000'+CI.CIcodigo),15) as CIcodigo,cs.RHCSATcodigo,CI.CIdescripcion,
                case CI.CInorenta
                    when 1 then hic.ICmontores
                    when 0 then 0
                end as ImporteExento,
                case CI.CInorenta
                    when 1 then 0
                    when 0 then hic.ICmontores
                end as ImporteGravado
                from #vIncidenciasCalculo# hic
                inner join CIncidentes CI
                on hic.CIid=CI.CIid
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
        <!---Cuota Sindical, debe sumar en las percepciones--->
                union
                select distinct hic.DEid,hic.RCNid,right(('000000000000000'+CI.TDcodigo),15) as TDcodigo,cs.RHCSATcodigo, CI.TDdescripcion, (0-hic.DCvalor),0
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
            from #Percepciones#
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
            <cf_dbtempcol name="TipoDeduccion"	type="char(10)"     mandatory="no">
            <cf_dbtempcol name="Clave"			type="char(15)"     mandatory="no">
            <cf_dbtempcol name="Concepto"		type="char(60)"     mandatory="no">
            <cf_dbtempcol name="ImporteExento"	type="money"       	mandatory="no">
            <cf_dbtempcol name="ImporteGravado"	type="money"       	mandatory="no">
        </cf_dbtemp>

        <cfquery datasource="#session.dsn#">
            insert #Deducciones#(DEid,RCNid,TipoDeduccion,Clave,Concepto,ImporteExento,ImporteGravado)
                select distinct hic.DEid,hic.RCNid,cs.RHCSATcodigo,right(('000000000000000'+CI.TDcodigo),15) as TDcodigo,CI.TDdescripcion,hic.DCvalor,0
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
            on cs.Ecodigo = cSAT.Ecodigo and cs.RHCSATid=cSAT.RHCSATid
            where cSAT.RHCSATcodigo='001'
        </cfquery>
        <cfreturn rsDatosSalarioSATcod>
    </cffunction>

    <cffunction name="GetIncapacidad" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">

         <cfquery name="rsDatosIncapacidad" datasource="#session.dsn#">
            select pe.PEcantdias, rhi.RHIncapcodigo, (lt.LTsalario / 30)* pe.PEcantdias as Descuento
            from #vPagosEmpleado# pe
                inner join  CalendarioPagos x
                    on pe.RCNid = x.CPid
                inner join LineaTiempo lt
                    on pe.LTid = lt.LTid
                inner join  RHTipoAccion ta
                    on pe.RHTid = ta.RHTid
                        and ta.RHTcomportam = 5
                left join RHCFDIIncapacidad rhi
                on ta.RHIncapid = rhi.RHIncapid
                    where pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and pe.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>

        <cfreturn rsDatosIncapacidad>
    </cffunction>

    <cffunction name="GetHrsDobles" access="public" returntype="query">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="RCNid" 		type="numeric" required="yes">
        <cfquery name="rsDatosHrsDobles" datasource="#session.dsn#">
            select count(*)as dias, SUM(ICValor) as horas , SUM(ICmontores) as monto
            from HIncidenciasCalculo hic
            inner join CIncidentes CI
            on hic.CIid=CI.CIid
            inner join RHCFDIConceptoSAT r
            on CI.RHCSATid=r.RHCSATid
            where CI.CIfactor in (1,2) and r.RHCSATcodigo=19
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

    <cffunction name="fnSecuenciasEscape" returntype="string" access="public">
        <cfargument name="Texto" type="string" required="yes">
        <cfset LvarCuentaC = replace(Texto,"-","","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"&","&amp;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"""","&quot;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"<","&lt;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,">","&gt;","ALL")>
        <cfset LvarCuentaC = replace(#LvarCuentaC#,"'","&apos;","ALL")>
        <cfset LvarCuentaC = Rtrim(Ltrim("#LvarCuentaC#"))>
        <cfreturn #LvarCuentaC#>
    </cffunction>
    <cffunction name="fnGetdatosEmpLiqFin"  returntype="query" access="public">
    	 <cfargument name="DLlinea"		type="numeric" required="yes">
         <cfquery name="rsDatosEmpLiqFin" datasource="#Session.DSN#">
            select b.DEid,
                   {fn concat({fn concat({fn concat({fn concat(b.DEapellido1, ' ')}, b.DEapellido2)}, ' ')}, b.DEnombre)} as NombreCompleto,
                   b.DEidentificacion,
                   b.RFC,
                   b.CURP,
                   b.DEsdi as SDI,
                   b.DESeguroSocial as SeguroSocial,
                   a.RHLPfingreso as FechaIngreso,
                   <cf_dbfunction name="dateadd" args="-1,c.DLfvigencia"> as FechaBaja,
                   d.RHPdescpuesto Puesto,
                   f.Ddescripcion Departamento,
                   g.RHTdesc as MotivoBaja,
                   c.Ecodigo,
                   c.Tcodigo,
                   i.Msimbolo,
                   i.Mnombre,
                   coalesce(a.RHLPrenta, 0) as renta,
                   coalesce(a.RHLPfecha,getdate()) as RHLPfecha,
                   <cf_dbfunction name="to_number" args="h.FactorDiasSalario"> as FactorDiasSalario,
                   datediff(ww, a.RHLPfingreso, c.DLfvigencia) as Antiguedad,
                   reg.RHRegimenid as tipoRegimen,
                   bnc.BcodigoOtro as Banco,
                   <!--- case b.DEtipocontratacion
                        when '3' then 'Construccion'
                        when '2' then 'Eventual'
                        when '1' then 'Fijo'
                        else 'ND'
               	   end as TipoContrato --->
				tc.TCclave as TipoContrato
            from RHLiquidacionPersonal a

                inner join DatosEmpleado b
                    on a.DEid = b.DEid

				inner join CSATTiposContrato tc
					on tc.IdTipoContrato = b.DEtipocontratacion

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
                select top(1) c.CIcodigo
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
                select a.DEid, a.RHLPid, a.CIid, a.RHLPdescripcion as Descripcion, a.importe,
                <!---ERBG Parte ISPT Exenta INICIA--->
                case c.CIcodigo
                when '#varCIcodigo#' then #ParteExenta#
                else a.RHLIexento
                end as RHLIexento,
                case c.CIcodigo
                when '#varCIcodigo#' then (RHLIgrabado - #ParteExenta#)
                else a.RHLIgrabado
                end as RHLIgrabado,
				<!---ERBG Parte ISPT Exenta FIN--->
                right(('000'+Convert(varchar,cs.RHCSATcodigo)),3)as RHCSATid , right(('000000000000000'+c.CIcodigo),15) as Clave,
                       b.DDCres as Resultado, b.DDCcant as Cantidad, b.DDCimporte as Monto
                from RHLiqIngresos a
                    left outer join DDConceptosEmpleado b
                        on a.DLlinea = b.DLlinea and a.CIid = b.CIid
                    left outer join CIncidentes c
                        on a.CIid = c.CIid
                    left outer join RHCFDIConceptoSAT cs
                        on c.RHCSATid=cs.RHCSATid
                where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DLlinea#">
                and coalesce(c.CISumarizarLiq,0) = 0
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
        <cfset ISPT = rsLF.RHLFLisptF + ISPTL>

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
        <cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
            select coalesce(sum(importe),0) as totDeduc
            from RHLiqDeduccion
            where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
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
            select ld.RHLDdescripcion, ld.importe, right(('000000000000000'+td.TDcodigo),15) as TDcodigo, cs.RHCSATcodigo
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

	<cffunction name="fnAusentismos" access="public" returntype="query">
		<cfargument name="RCNid" 	 type="numeric" required="yes">
		<cfargument name="DEid" 	 type="numeric" required="yes">

		<cfquery name="rsDeducionesFin" datasource="#session.dsn#">
            select a.DEid, right(('000000000000000'+min(d.RHTcodigo)),15) as TDcodigo, 0 as ImporteGravado,
            	min(cs.RHCSATcodigo) as RHCSATcodigo, min(d.RHTdesc) as RHTdesc,
            	min(a.PEsalario)/30 as PEsaldiario, (coalesce(sum(PEcantdias),0) * (d.RHTfactorfalta)) as PEcantdias
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
 </cfcomponent>