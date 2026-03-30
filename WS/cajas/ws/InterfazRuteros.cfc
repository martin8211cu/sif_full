<cfcomponent>

    <cffunction name="fnProcesaLiquidacionRuteros" access="public" returntype="string" displayname="fnProcesaLiquidacionRuteros" hint="Funcion para la liquidacion de ruteros">
		<cfargument name="XMLString" type="string" required="Yes" hint="XML con todas las transacciones">

        <!--- Se quitan los saltos de Linea y se pasa la hilera a XML --->
		<cfset lvarXML = replace(Arguments.XMLString, chr(13), "", "All") >
		<!--- Establezca el elemento raíz como el nodo Actual del DOM --->
        <cfset XMLTRANSACCION = XMLParse(lvarXML).XMLROOT>
        <!--- Cuenta la Cantidad de Transacciones que posse el XML --->        
		<cftransaction>
			<cfset XMLFAXC003 = XMLTRANSACCION.FAXC003><!--- Solo viene 1 encabezado de relacion por request --->
			<cfset RERCOD = fnGetNumeroRelacion()><!--- Obtiene Numero Relacion --->
			<cfset Error = fnAltaFAXC003(RERCOD, XMLFAXC003.RERDES.XmlText, XMLFAXC003.RERUSR.XmlText, XMLFAXC003.RERFEC.XmlText, XMLFAXC003.FAM33COD.XmlText, XMLFAXC003.C09COD.XmlText, XMLFAXC003.USRPAGADO.XmlText, XMLFAXC003.FAM01COD.XmlText, XMLFAXC003.MONCOD.XmlText)>
			<cfif len(trim(Error)) gt 0>
				<cfthrow message="#Error#">
			</cfif>
			<cfset lFC5 = XmlSearch(XMLFAXC003, "//FAXC005")>
            <!---Valida que vengan datos en la FAXC005--->
            <cfif #Arraylen(lFC5)# eq 0>
            	<!---<cfthrow message="Los datos de FAXC005 no pueden ir en blanco en el XML">
				las liquidaciones de ruteros pueden venir con abonos de crédito y facturas de contado  o solo facturas de contado, en el caso de que solo vengan facturas de contado  
				no debe validarse ni insertar en las FAXC005 y FAXC006, y se asume que cuando no envian el encabezado de la FAXC005 es porque solo vienen facturas de contado--->
                <cfset LvarProcesaFAXC005y6 = false>
            <cfelse>
            	<cfset LvarProcesaFAXC005y6 = true>
            </cfif>
            <cfif LvarProcesaFAXC005y6>
                <cfloop from="1" to="#Arraylen(lFC5)#" index="z">
                    <cfset lFAXC5COD = fnGetFAXC5COD(RERCOD)>
                    <cfset lFC6 = XmlSearch(lFC5[z], "//FAXC005[RENREC/text()='#lFC5[z].RENREC.XmlText#']//FAXC006")>
                    <!---Valida que vengan datos en la FAXC006--->
                    <cfif #Arraylen(lFC6)# eq 0>
                        <cfthrow message="Los datos de FAXC006 no pueden ir en blanco en el XML">
                    </cfif>
    
                    <cfset Error = fnAltaFAXC005(RERCOD, lFAXC5COD, lFC5[z].RENREC.XmlText, lFC5[z].RENMON.XmlText, lFC5[z].RENFEC.XmlText, lFC5[z].C06COD.XmlText, lFC5[z].CLICOD.XmlText, lFC5[z].MONCOD.XmlText, lFC5[z].MONTPC.XmlText, lFC6)>
                    <cfif len(trim(Error)) gt 0>
                        <cfthrow message="#Error#">
                    </cfif>
                    <cfloop from="1" to="#Arraylen(lFC6)#" index="j">
                        <cfset Error = fnAltaFAXC006(RERCOD, lFAXC5COD, lFC6[j].FACTTR.XmlText, lFC6[j].FACDOC.XmlText, lFC6[j].RENREC.XmlText, lFC6[j].REDMON.XmlText, lFC6[j].CLICOD.XmlText, lFC6[j].MONCOD.XmlText)>
                        <cfif len(trim(Error)) gt 0>
                            <cfthrow message="#Error#">
                        </cfif>
                    </cfloop>
                    <!--- Por solisitud de jenner se elimina el proceso de generar el excedente y se valida que la sumatoria de los detalles coincida eon el encabezado de la relacion --->
                    <!---<cfset Error = fnGeneraExcedente(RERCOD, lFAXC5COD, lFC5[z].CLICOD.XmlText, lFC5[z].MONCOD.XmlText)>--->
                    <cfset Error = fnValidaMontosPagados(RERCOD, lFAXC5COD)>
                    <cfif len(trim(Error)) gt 0>
                        <cfthrow message="#Error#">
                    </cfif>
                </cfloop>
            </cfif>
            
			<cfset lFC7 = XmlSearch(XMLFAXC003, "//FAXC007")>
			<cfloop from="1" to="#Arraylen(lFC7)#" index="z">
				<cfset Error = fnAltaFAXC007(RERCOD, lFC7[z].num_factura.XmlText, lFC7[z].cod_puve.XmlText, lFC7[z].fec_emision.XmlText, lFC7[z].mon_saldo.XmlText, lFC7[z].num_liquidacion.XmlText, lFC7[z].mon_original.XmlText)>
				<cfif len(trim(Error)) gt 0>
					<cfthrow message="#Error#">
				</cfif>
				<cfset lFC8 = XmlSearch(lFC7[z], "//FAXC007[num_factura/text()='#lFC7[z].num_factura.XmlText#']//FAXC008")>
				<cfloop from="1" to="#Arraylen(lFC8)#" index="j">
					<cfset Error = fnAltaFAXC008(RERCOD, lFC8[j].num_factura.XmlText, lFC8[j].num_linea.XmlText, lFC8[j].cod_producto.XmlText, lFC8[j].fec_despacho.XmlText, lFC8[j].num_edicion.XmlText, lFC8[j].cantidad_cred.XmlText, lFC8[j].monto_descuento.XmlText, lFC8[j].monto_impuesto.XmlText, lFC8[j].monto_linea.XmlText, lFC8[j].CTAP01.XmlText, lFC8[j].CTAP02.XmlText, lFC8[j].CTAP03.XmlText, lFC8[j].CTAP04.XmlText, lFC8[j].CTAP05.XmlText, lFC8[j].CTAP06.XmlText, lFC8[j].CTAD01.XmlText, lFC8[j].CTAD02.XmlText, lFC8[j].CTAD03.XmlText, lFC8[j].CTAD04.XmlText, lFC8[j].CTAD05.XmlText, lFC8[j].CTAD06.XmlText, lFC8[j].CTAI01.XmlText, lFC8[j].CTAI02.XmlText, lFC8[j].CTAI03.XmlText, lFC8[j].CTAI04.XmlText, lFC8[j].CTAI05.XmlText, lFC8[j].CTAI06.XmlText)>
					<cfif len(trim(Error)) gt 0>
						<cfthrow message="#Error#">
					</cfif>
				</cfloop>
			</cfloop>
		</cftransaction>
		<cfreturn "OK">
	</cffunction>
	
	<!--- Funcion para insertar el encabezado de la relacion (FAXC003) --->
    <cffunction name="fnAltaFAXC003" access="private" returnType="string" hint="Funcion para insertar el encabezado de la relacion (FAXC003)">
	    <cfargument name="RERCOD" 		type="numeric" 	required="yes">
        <cfargument name="RERDES" 		type="string" 	required="yes">
        <cfargument name="RERUSR" 		type="string" 	required="yes">
        <cfargument name="RERFEC" 		type="string"   required="yes">
        <cfargument name="FAM33COD" 	type="string" 	required="yes">
        <cfargument name="C09COD" 	 	type="string" 	required="yes">
        <cfargument name="USRPAGADO" 	type="string" 	required="yes">
        <cfargument name="FAM01COD" 	type="string" 	required="yes">
        <cfargument name="MONCOD" 		type="string" 	required="yes">

        <cfset resultadoAFC3 = "">
		
		<cftry>
			<cfif not IsDate(Arguments.RERFEC)>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El campo RERFEC(#Arguments.RERFEC#) no es de tipo fecha.">
			</cfif>
			<cfif len(trim(Arguments.FAM33COD)) eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El campo FAM33COD no puede venir en blanco.">
			</cfif>
			<cfif len(trim(Arguments.C09COD)) eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El campo C09COD no puede venir en blanco.">
			</cfif>
			<cfif len(trim(Arguments.FAM01COD)) eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El campo FAM01COD no puede venir en blanco.">
			</cfif>
			<cfif len(trim(Arguments.MONCOD)) eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El campo MONCOD no puede venir en blanco.">
			</cfif>
			
			<cfquery name="rsEmpresa" datasource="CAJAS">
				select 1 
				from FAM033 
				where FAM33COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.FAM33COD#">
			</cfquery>
			<cfif rsEmpresa.recordcount eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El código de la empresa no existe(#Arguments.FAM33COD#).">
			</cfif>
			<cfset lvarFecha = ParseDateTime(Replace(Arguments.RERFEC,"T"," "))>
			<cfif len(trim(resultadoAFC3)) eq 0>
				<!--- Inserción en la base de datos FAXC003 --->
				<cfquery datasource="CAJAS" name="InsertaFax001ex">
					INSERT INTO FAXC003( RERCOD, RERDES, RERUSR, RERFEC, FAX01TIP, REREST, FAM33COD, C09COD, USRPAGADO, FAM01COD, MONCOD)
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RERCOD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.RERDES#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.RERUSR#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#lvarFecha#">,
						'RU',
						'TS',
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.FAM33COD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.C09COD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.USRPAGADO#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.FAM01COD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.MONCOD#">
					)
				</cfquery>
			</cfif>
			<cfif len(trim(resultadoAFC3)) gt 0>
				<cfset resultadoAFC3 = "([fnAltaFAXC003] : Tabla[FAXC003] : Llave-Descripción[#RERDES#] : Error[#resultadoAFC3#])"> 
			</cfif>
			
			<cfcatch type = "Any">
				<cfrethrow>
				<cfset resultadoAFC3 = "([fnAltaFAXC003-Catch] : Mensaje[#cfcatch.message#] : Detalle[#cfcatch.detail#]">
			</cfcatch>
		</cftry>
        <cfreturn resultadoAFC3>
    </cffunction>
	
	<!--- Funcion para insertar recibo de la relacion (FAXC005) --->
    <cffunction name="fnAltaFAXC005" access="private" returnType="string" hint="Funcion para insertar recibo de la relacion (FAXC005)">
		<cfargument name="RERCOD" 		type="numeric" 	required="yes">
		<cfargument name="FAXC5COD" 	type="numeric" 	required="yes">
		<cfargument name="RENREC" 		type="string" 	required="Yes">
		<cfargument name="RENMON" 		type="string"	required="Yes">
		<cfargument name="RENFEC" 		type="string" 	required="Yes">
		<cfargument name="C06COD" 		type="string"	required="Yes">
		<cfargument name="CLICOD" 		type="string" 	required="Yes">
		<cfargument name="MONCOD" 		type="string" 	required="Yes">
		<cfargument name="MONTPC" 		type="string"	required="Yes">
		<cfargument name="FAXC006" 		type="array"	required="Yes">
					
		<cfset resultadoAFC5 = "">
		<cftry>
			<cfquery name="rsFAXC005" datasource="CAJAS">
				select CG49CO_CXC 
				from FAM033
				where FAM33COD = (select FAM33COD
								  from FAXC003
								  where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">)
			</cfquery>
			<cfquery name="rsFAP000" datasource="CAJAS"> <!--- Preguntar Filtro --->
				select CODCIA_CLO 
				from FAP000
			</cfquery>
			<cfif rsFAXC005.CG49CO_CXC eq rsFAP000.CODCIA_CLO>
				<cfquery name="rsCCT006_CLO" datasource="CAJAS">
					select 1 
					from CCT006_CLO
					where TTRCOD = 'RE'
					  and RENREC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RENREC#">
				</cfquery>
				<cfif rsCCT006_CLO.recordcount gt 0>
					<cfset resultadoAFC5 = "#resultadoAFC5# - El documento '#Arguments.RENREC#' no existe en la tabla CCT006_CLO.">
				</cfif>
			<cfelse>
				<cfquery name="rsCCT006" datasource="CAJAS">
					select 1 
					from CCT006
					where TTRCOD = 'RE'
					  and RENREC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RENREC#">
				</cfquery>
				<cfif rsCCT006.recordcount eq 0>
					<cfset resultadoAFC5 = "#resultadoAFC5# - El documento '#Arguments.RENREC#' no existe en la tabla CCT006.">
				</cfif>
			</cfif>
			
			<cfquery name="rsCCT003" datasource="CAJAS">
				select 1 
				from CCT003
				where RECNUM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RENREC#">
			</cfquery>
			<cfif rsCCT003.recordcount gt 0>
				<cfset resultadoAFC5 = "#resultadoAFC5# - El documento #Arguments.RENREC# ya existe en la tabla CCT003.">
			</cfif>
			
			<cfquery name="rsCCX005" datasource="CAJAS">
				select 1 
				from CCX005
				where RENREC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RENREC#">
			</cfquery>
			<cfif rsCCX005.recordcount gt 0>
				<cfset resultadoAFC5 = "#resultadoAFC5# - El documento '#Arguments.RENREC#' ya existe en la tabla CCX005.">
			</cfif>
			
			<cfset RENCTL = 0>
			
			<cfset sXMLFAXC006 = Arguments.FAXC006>
			<cfset snFAXC006 = Arraylen(sXMLFAXC006)>
			
			<cfloop from="1" to="#snFAXC006#" index="a">
				<cfset RENCTL = RENCTL + sXMLFAXC006[a].REDMON.XmlText>
			</cfloop>
			
			<cfif #numberformat(RENCTL,',9.0000')# neq #numberformat(Arguments.RENMON,',9.0000')#>
				<cfset resultadoAFC5 = "#resultadoAFC5# - El monto RENCTL(#numberformat(RENCTL,',9.0000')#) y RENMON(#numberformat(Arguments.RENMON,',9.0000')#) deben de coincidir.">
			</cfif>
			
			<cfquery name="rsCorporacion" datasource="CAJAS">
				select 1 
				from CCM006  
				where C06COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.C06COD#">
			</cfquery>
			<cfif rsCorporacion.recordcount eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El código de corporación no existe(#Arguments.C06COD#).">
			</cfif>
			
			<cfquery name="rsCliente" datasource="CAJAS">
				select 1 
				from CCM002_CXC  
				where CLICOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CLICOD#">
			</cfquery>
			<cfif rsCliente.recordcount eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El código de cliente no existe(#Arguments.CLICOD#).">
			</cfif>
			
			<cfquery name="rsMoneda" datasource="CAJAS">
				select 1 
				from CCM001  
				where MONCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MONCOD#">
			</cfquery>
			<cfif rsMoneda.recordcount eq 0>
				<cfset resultadoAFC3 = "#resultadoAFC3# - El código de moneda no existe(#Arguments.MONCOD#).">
			</cfif>
			<cfset lvarFecha = ParseDateTime(Replace(Arguments.RENFEC,"T"," "))>
			<cfif len(trim(resultadoAFC5)) eq 0>
				<!--- Insertar la recibos de relacion (FAXC005) --->
				<cfquery  name="InsFAX001" datasource="CAJAS">
					insert FAXC005(RERCOD, FAXC5COD, TTRCOD, RENREC, RENMON, RENCTL,   
								   RENFEC, C06COD,   CLICOD, MONCOD, MONTPC, TPFPAG,
								   CCMONTOREC)   
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RERCOD#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.FAXC5COD#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="RE">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.RENREC#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.RENMON#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#RENCTL#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#lvarFecha#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.C06COD#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CLICOD#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.MONCOD#">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#Arguments.MONTPC#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="8">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.RENMON#">
					)
				</cfquery>				
			</cfif>
			<cfif len(trim(resultadoAFC5)) gt 0>
				<cfset resultadoAFC5 = "([fnAltaFAXC005] : Tabla[FAXC005] : Llave-Descripción[#RENREC#] : Error[#resultadoAFC5#])"> 
			</cfif>
			<cfcatch type = "Any">
				<cfrethrow>
				<cfset resultadoAFC5 = "([fnAltaFAXC005-Catch] : Mensaje[#cfcatch.message#] : Detalle[#cfcatch.detail#]">
			</cfcatch>
		</cftry>
		<cfreturn resultadoAFC5>
	</cffunction>	
	
	<!--- Funcion para insertar el detalle de recibo de la relacion(FAXC006) --->
    <cffunction name="fnAltaFAXC006" access="private" returnType="string" hint="Funcion para insertar el detalle de recibo de la relacion(FAXC006)">
        <cfargument name="RERCOD" 		type="numeric" 	required="Yes">
        <cfargument name="FAXC5COD" 	type="numeric" 	required="Yes">
        <cfargument name="FACTTR" 		type="string" 	required="Yes">
        <cfargument name="FACDOC" 		type="string" 	required="Yes">
		<cfargument name="RENREC" 		type="string" 	required="Yes">
        <cfargument name="REDMON" 		type="string" 	required="Yes">
        <cfargument name="CLICOD" 		type="string" 	required="Yes">
        <cfargument name="MONCOD" 		type="string" 	required="Yes">

        <cfset resultadoAFC6 = "" >
		<cftry>
			<!--- Obtiene la linea para el detalle de la relacion --->
			<cfquery  name="rsFAXC006" datasource="CAJAS">
				select coalesce(max(REDLIN),0) + 1 as cantidad
				from FAXC006
				where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
				  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
			</cfquery>
			<cfset REDLIN = rsFAXC006.cantidad>
			
			<cfquery name="rsFAP000" datasource="CAJAS">
				select CODCIA_CLO
				from FAP000
			</cfquery>
			<cfquery name="rsFAM033" datasource="CAJAS">
				select CG49CO_CXC
				from FAM033
				where FAM33COD = (select FAM33COD 
								  from FAXC003 
								  where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">)
			</cfquery>
			<cfset lvarTabla = "CCT002">
			<cfif rsFAM033.CG49CO_CXC eq rsFAP000.CODCIA_CLO>
				<cfset lvarTabla = "CCT002_CLO">
			</cfif>
			<cfquery name="rsCCT002" datasource="CAJAS">
				select 1
				from #lvarTabla#
				where FACTTR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FACTTR#">
				  and FACDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FACDOC#">
			</cfquery>
			<cfif rsCCT002.recordCount eq 0>
				<cfset resultadoAFC6 = "#resultadoAFC6# - No existe el registro #FACDOC# en la tabla #lvarTabla# con los filtros FACTTR = #Arguments.FACTTR# y FACDOC = #Arguments.FACDOC#.">
			</cfif>
			<cf_dbfunction name="to_float" args="coalesce(FACMON,0) - (coalesce(FACREC,0) + coalesce(FACMD1,0) + coalesce(FACMD2,0) + coalesce(FACTMP,0))" dec="4" datasource="CAJAS" returnvariable="lvarSaldo">
			<cfquery  name="rsSaldoFactura" datasource="CAJAS">
				select #lvarSaldo#	as Saldo
				from #lvarTabla#
				where FACTTR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FACTTR#">
				  and FACDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FACDOC#">
				  and CLICOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CLICOD#">
			</cfquery>
			<cfif rsSaldoFactura.Saldo gte Arguments.REDMON>
				<cfset lvarREDMON = Arguments.REDMON>
				<cfif len(trim(lvarREDMON)) eq 0>
					<cfset resultadoAFC6 = "#resultadoAFC6# -El monto suministrado o el saldo de la factura esta vacio.">
				</cfif>
			<cfelse>
				<cfset lvarREDMON = rsSaldoFactura.Saldo>
				<cfif len(trim(lvarREDMON)) eq 0>
					<cfset resultadoAFC6 = "#resultadoAFC6# -El saldo de la factura esta vacio.">
				</cfif>
			</cfif>
			<cfquery  name="rsFC05" datasource="CAJAS">
				select MONTPC, MONCOD
				from FAXC005
				where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
				  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
			</cfquery>
			<cfif Arguments.MONCOD neq rsFC05.MONCOD><!--- Validar codigo de moneda --->
				 <cfset resultadoAFC6 = "#resultadoAFC6# - EL código de modena sumistrado(#Arguments.MONCOD#) es diferente al código de moneda de la realción(#rsFC05.MONCOD#).">
			</cfif>
			
			<cfquery name="rsMoneda" datasource="CAJAS">
				select 1 
				from CCM001  
				where MONCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MONCOD#">
			</cfquery>
			<cfif rsMoneda.recordcount eq 0>
				<cfset resultadoAFC6 = "#resultadoAFC6# - El código de moneda no existe(#Arguments.MONCOD#).">
			</cfif>
	
			<cfif len(trim(resultadoAFC6)) eq 0>	
				<cfquery name="InsertaFAX004" datasource="CAJAS">
					 insert FAXC006 (RERCOD,  FAXC5COD, REDLIN,  FACTTR,  FACDOC,  REDMON,
									REDDES,  REDTIP, REDNOA, CLICOD, REDMOR,  REDMOL, MONCOD, EnviaCxC, REDDEL)
					  values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.RERCOD#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.FAXC5COD#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#REDLIN#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.FACTTR#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.FACDOC#">,
						<cfqueryparam cfsqltype="cf_sql_money" 			value="#lvarREDMON#">,								   	
						<cfqueryparam cfsqltype="cf_sql_money" 			value="0">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="D">,	
						null,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.CLICOD#">,	
						<cfqueryparam cfsqltype="cf_sql_money" 			value="#lvarREDMON#">,	
						<cfqueryparam cfsqltype="cf_sql_money" 			value="#lvarREDMON * rsFC05.MONTPC#">,	
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.MONCOD#">,	
						<cfqueryparam cfsqltype="cf_sql_char" 			value="S">,
						0
					)
				</cfquery>
			</cfif>
			<cfif len(trim(resultadoAFC6)) gt 0>
				<cfset resultadoAFC6 = "([fnAltaFAXC006] : Tabla[FAXC006] : Llave-Descripción[#Arguments.FACDOC#,#Arguments.RENREC#] : Error[#resultadoAFC6#])"> 
			</cfif>
			<cfcatch type = "Any">
				<cfrethrow>
				<cfset resultadoAFC6 = "([fnAltaFAXC006-Catch] : Mensaje[#cfcatch.message#] : Detalle[#cfcatch.detail#]">
			</cfcatch>
		</cftry>
		<cfreturn resultadoAFC6>
    </cffunction>
	
	<!--- Funcion para insertar el encabezado de la factura (FAXC007) --->
    <cffunction name="fnAltaFAXC007" access="private" returnType="string" hint="Funcion para insertar el encabezado de la factura (FAXC007)">
        <cfargument name="RERCOD" 			type="numeric" 	required="Yes">
        <cfargument name="num_factura" 		type="string" 	required="Yes">
        <cfargument name="cod_puve" 		type="string" 	required="Yes">
        <cfargument name="fec_emision" 		type="string" 	required="Yes">
				<cfargument name="mon_saldo" 		type="string" 	required="Yes">
        <cfargument name="num_liquidacion" 	type="numeric" 	required="Yes">
        <cfargument name="mon_original" 	type="string" 	required="Yes">

        <cfset resultadoAFC7 = "" >
		<cftry>	
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.num_factura, "El campo num_factura")>
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.cod_puve, "El campo cod_puve tabla")>
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.fec_emision, "El campo fec_emision", 1)>
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.mon_saldo, "El campo mon_saldo")>
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.num_liquidacion, "El campo num_liquidacion")>
			<cfset resultadoAFC7 = resultadoAFC7 & fnValidarCampo(Arguments.mon_original, "El campo mon_original")>
			<cfset lvarFecha = ParseDateTime(Replace(Arguments.fec_emision,"T"," "))>
			<cfif len(trim(resultadoAFC7)) eq 0>	
            	<cfquery name="rsRela" datasource="CAJAS">
                	select count(1) cantidad 
                    	from FAXC003 where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
                </cfquery>	
                <cfif rsRela.cantidad EQ 0>
                	<cfthrow message="La relacion no existe #Arguments.RERCOD#">
                </cfif>
                
				<cfquery name="InsertaFAXC007" datasource="CAJAS">
					 insert FAXC007 (RERCOD,  num_factura, cod_puve,  fec_emision,  mon_saldo,  num_liquidacion, mon_original)
					  values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.RERCOD#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.num_factura#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.cod_puve#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" 		value="#lvarFecha#">,								   	
						<cfqueryparam cfsqltype="cf_sql_decimal"		value="#Arguments.mon_saldo#" scale="2">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.num_liquidacion#">,	
						<cfqueryparam cfsqltype="cf_sql_decimal" 		value="#Arguments.mon_original#" scale="2">
					)
				</cfquery>
			</cfif>
			<cfif len(trim(resultadoAFC7)) gt 0>
				<cfset resultadoAFC7 = "([fnAltaFAXC007] : Tabla[FAXC007] : Llave-Descripción[#num_factura#] : Error[#resultadoAFC7#])"> 
			</cfif>
			<cfcatch type = "Any">
				<cfrethrow>
				<cfset resultadoAFC7 = "([fnAltaFAXC007-Catch] : Mensaje[#cfcatch.message#] : Detalle[#cfcatch.detail#]">
			</cfcatch>
		</cftry>
		<cfreturn resultadoAFC7>
    </cffunction>
	
	<!--- Funcion para insertar el detalle de factura (FAXC008) --->
    <cffunction name="fnAltaFAXC008" access="private" returnType="string" hint="Funcion para insertar el detalle de factura (FAXC008)">
        <cfargument name="RERCOD" 			type="numeric" 	required="Yes">
        <cfargument name="num_factura" 		type="string" 	required="Yes">
        <cfargument name="num_linea" 		type="numeric" 	required="Yes">
        <cfargument name="cod_producto" 	type="string" 	required="Yes">
		<cfargument name="fec_despacho" 	type="string" 	required="Yes">
		<cfargument name="num_edicion" 		type="numeric" 	required="Yes">
        <cfargument name="cantidad_cred" 	type="numeric" 	required="Yes">
        <cfargument name="monto_descuento" 	type="string" 	required="Yes">
		<cfargument name="monto_impuesto" 	type="string" 	required="Yes">
		<cfargument name="monto_linea" 		type="string" 	required="Yes">
		<cfargument name="CTAP01" 			type="string" 	required="Yes">
		<cfargument name="CTAP02" 			type="string" 	required="Yes">
		<cfargument name="CTAP03" 			type="string" 	required="Yes">
		<cfargument name="CTAP04" 			type="string" 	required="Yes">
		<cfargument name="CTAP05" 			type="string" 	required="Yes">
		<cfargument name="CTAP06" 			type="string" 	required="Yes">
		<cfargument name="CTAD01" 			type="string" 	required="Yes">
		<cfargument name="CTAD02" 			type="string" 	required="Yes">
		<cfargument name="CTAD03" 			type="string" 	required="Yes">
		<cfargument name="CTAD04" 			type="string" 	required="Yes">
		<cfargument name="CTAD05" 			type="string" 	required="Yes">
		<cfargument name="CTAD06" 			type="string" 	required="Yes">
		<cfargument name="CTAI01" 			type="string" 	required="Yes">
		<cfargument name="CTAI02" 			type="string" 	required="Yes">
		<cfargument name="CTAI03" 			type="string" 	required="Yes">
		<cfargument name="CTAI04" 			type="string" 	required="Yes">
		<cfargument name="CTAI05" 			type="string" 	required="Yes">
		<cfargument name="CTAI06" 			type="string" 	required="Yes">
		
        <cfset resultadoAFC8 = "" >
		<cftry>	
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.num_factura, "El campo num_factura")>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.num_linea, "El campo num_linea")>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.cod_producto, "El campo cod_producto")>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.fec_despacho, "El campo fec_despacho", 1)>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.monto_descuento, "El campo monto_descuento")>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.monto_impuesto, "El campo monto_impuesto")>
			<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Arguments.monto_linea, "El campo monto_linea")>

			<cfif Arguments.monto_linea gt 0>
            	<cfloop from="1" to="6" index="o">
					<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Evaluate('Arguments.CTAP0#o#'), "El campo CTAP0#o#")>
				</cfloop>
            <cfelse>
            	<cfset resultadoAFC8 = "([fnAltaFAXC008] : Tabla[FAXC008] : Llave-Descripción[#Arguments.num_factura#,#Arguments.num_linea#] : Error: El monto linea es menor que cero )"> 
            </cfif>
            
            <cfif Arguments.monto_descuento gt 0>
            	<cfloop from="1" to="6" index="o">
					<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Evaluate('Arguments.CTAD0#o#'), "El campo CTAD0#o#")>
				</cfloop>
            </cfif>

            <cfif Arguments.monto_impuesto gt 0>
            	<cfloop from="1" to="6" index="o">
					<cfset resultadoAFC8 = resultadoAFC8 & fnValidarCampo(Evaluate('Arguments.CTAI0#o#'), "El campo CTAI0#o#")>
				</cfloop>
            </cfif>
            
            
			<cfset lvarFecha = ParseDateTime(Replace(Arguments.fec_despacho,"T"," "))>
			<cfquery name="RM" datasource="CAJAS">
					 select * from FAXC007
					 where RERCOD = #Arguments.RERCOD# and 
					 num_factura = '#Arguments.num_factura#'
			</cfquery>
			<cfif len(trim(resultadoAFC8)) eq 0>
				<cfquery name="InsertaFAXC007" datasource="CAJAS">
					 insert FAXC008 (RERCOD, num_factura, num_linea, cod_producto, fec_despacho, num_edicion, cantidad_cred,
						monto_descuento, monto_impuesto, monto_linea, 
						CTAP01, CTAP02, CTAP03, CTAP04, CTAP05, CTAP06,
						CTAD01, CTAD02, CTAD03, CTAD04, CTAD05, CTAD06,
						CTAI01, CTAI02, CTAI03, CTAI04, CTAI05, CTAI06)
					  values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.RERCOD#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.num_factura#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.num_linea#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 		value="#Arguments.cod_producto#">,								   	
						<cfqueryparam cfsqltype="cf_sql_timestamp" 		value="#lvarFecha#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.num_edicion#">,	
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.cantidad_cred#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.monto_descuento#" scale="2">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.monto_impuesto#"  scale="2">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 		value="#Arguments.monto_linea#" 	scale="2">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP01#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP02#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP03#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP04#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP05#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAP06#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD01#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD02#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD03#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD04#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD05#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAD06#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI01#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI02#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI03#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI04#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI05#">,
						<cfqueryparam cfsqltype="cf_sql_char" 			value="#Arguments.CTAI06#">
					)
				</cfquery>

			</cfif>
			<cfif len(trim(resultadoAFC8)) gt 0>
				<cfset resultadoAFC8 = "([fnAltaFAXC008] : Tabla[FAXC008] : Llave-Descripción[#Arguments.num_factura#,#Arguments.num_linea#] : Error[#resultadoAFC8#])"> 
			</cfif>
			<cfcatch type = "Any">
				<cfrethrow>
				<cfset resultadoAFC8 = "([fnAltaFAXC008-Catch] : Mensaje[#cfcatch.message#] : Detalle[#cfcatch.detail#]">
			</cfcatch>
		</cftry>
		<cfreturn resultadoAFC8>
    </cffunction>
	
	<cffunction name="fnGetNumeroRelacion" acess="private" returntype="numeric" hint="Funcion para obtener el numero de relacion">
 
		<cfquery name="rsNumeroRelacion" datasource="CAJAS">	
			 select coalesce(max(PARNUMLIQ),0) + 1 as Numero
			 from CCP001
		</cfquery>
		 <cfquery datasource="CAJAS">	
			 update CCP001 set PARNUMLIQ = coalesce(PARNUMLIQ,0) + 1
		</cfquery>
		
        <cfreturn rsNumeroRelacion.Numero>
    </cffunction>
	
	<!--- Obtiene el consecutivo de recibo de la relacion(FAXC005) --->
	<cffunction name="fnGetFAXC5COD" access="private" returnType="numeric" hint="Obtiene el consecutivo de recibo de la relacion(FAXC005)">
		<cfargument name="RERCOD" 		type="numeric" 	required="yes">
		
		<cfquery  name="rsFAXC005" datasource="CAJAS">
			select coalesce(max(FAXC5COD),0) + 1 as cantidad
			from FAXC005
			where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
		</cfquery>
		
		<cfreturn rsFAXC005.cantidad>
	</cffunction>
	
	<!--- Genera Carga Excedente en Recibo de la relacion --->
	<cffunction name="fnGeneraExcedente" access="private" returnType="string" hint="Genera Carga Excedente en Recibo de la relacion">
		<cfargument name="RERCOD" 		type="numeric" 	required="yes">
		<cfargument name="FAXC5COD" 	type="numeric" 	required="yes">
		<cfargument name="CLICOD" 		type="string" 	required="yes">
		<cfargument name="MONCOD" 		type="string" 	required="yes">
		
		<cfset resultadoGE = "">
		
		<cfquery name="rsMontoFAXC005" datasource="CAJAS">
			select RENMON
			from FAXC005
			where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
			  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
		</cfquery>
		<cfquery name="rsSumFAXC006" datasource="CAJAS">
			select sum(REDMON) as SumREDMON
			from FAXC006
			where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
			  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
		</cfquery>
		<cfif rsSumFAXC006.SumREDMON gt rsMontoFAXC005.RENMON >
			<cfset resultadoGE = "El monto de los detalles de recibos de la relación(#numberformat(rsSumFAXC006.SumREDMON,',9.0000')#) no puede ser mayor al monto total de recibo(#numberformat(rsMontoFAXC005.RENMON,',9.0000')#).">
		<cfelseif rsSumFAXC006.SumREDMON lt rsMontoFAXC005.RENMON>
			<cftry>		
				<cfquery name="rsGeneraNCRecibo" datasource="CAJAS">
					exec fa_GeneraNCRecibo
					   @RERCOD 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">,
					   @FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">,
					   @CLICOD	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CLICOD#">,
					   @MONCOD	 = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.MONCOD#">
				</cfquery>
				<cfcatch type = "Any">
					<cfrethrow>
					<cfset resultadoGE = "#cfcatch.message# - #cfcatch.detail#">
				</cfcatch>
			</cftry>
		</cfif>
		<cfif len(trim(resultadoGE)) gt 0>
			<cfset resultadoGE = "([fnGeneraExcedente] : Tabla[FAXC005,FAXC006] : Llave-Descripción[#Arguments.RERCOD#,#Arguments.FAXC005#,#Arguments.CLICOD#,#Arguments.MONCOD#] : Error[#resultadoGE#])"> 
		</cfif>
		<cfreturn resultadoGE>
	</cffunction>
	
	<!--- Valida monto pagado de los detalles --->
	<cffunction name="fnValidaMontosPagados" access="private" returnType="string" hint="Valida monto pagado de los detalles">
		<cfargument name="RERCOD" 		type="numeric" 	required="yes">
		<cfargument name="FAXC5COD" 	type="numeric" 	required="yes">

		<cfset resultadoMP = "">
		
		<cfquery name="rsDFAXC005" datasource="CAJAS">
			select RENMON, RENREC
			from FAXC005
			where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
			  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
		</cfquery>
		<cfquery name="rsSumFAXC006" datasource="CAJAS">
			select sum(REDMON) as SumREDMON
			from FAXC006
			where RERCOD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RERCOD#">
			  and FAXC5COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FAXC5COD#">
		</cfquery>
		<cfif rsSumFAXC006.SumREDMON neq rsDFAXC005.RENMON >
			<cfset resultadoMP = "El monto de los detalles de recibos de la relación(#numberformat(rsSumFAXC006.SumREDMON,',9.0000')#) no puede ser diferente al monto total de recibo(#numberformat(rsDFAXC005.RENMON,',9.0000')#).
			El error ocurrio con los argumentos RERCOD:#Arguments.RERCOD#  y el FAXC5COD:#Arguments.FAXC5COD#">
		</cfif>
		<cfif len(trim(resultadoMP)) gt 0>
			<cfset resultadoMP = "([fnValidaMontosPagados] : Llave[RENREC : #rsDFAXC005.RENREC#] : Error[#resultadoMP#])"> 
		</cfif>
		<cfreturn resultadoMP>
	</cffunction>
	
	<!--- Validaciones en el valor suministrado --->
	<cffunction name="fnValidarCampo" access="private" returnType="string" hint="Validaciones en el valor suministrado">
		<cfargument name="Valor" 		type="string" 	required="yes">
		<cfargument name="Etiqueta" 	type="string" 	required="yes">
		<cfargument name="Fecha" 		type="boolean" 	required="yes" default="0">
		
		<cfset resultadoVC = "">
		
		<cfif len(trim(Arguments.Valor)) eq 0>
			<cfset resultadoVC = "#Arguments.Etiqueta# no puede ser nulo ni vacio. ">
		</cfif>
		
		<cfif Arguments.Fecha and not IsDate(Arguments.Valor)>
			<cfset resultadoVC = resultadoVC & " - " & "#Arguments.Etiqueta# debe de ser tipo fecha(#Arguments.Valor#). ">
		</cfif>
		
		<cfif resultadoVC neq "">
			<cfset resultadoVC = "[fnValidarCampo] : #resultadoVC#. ">
		</cfif>
		<cfreturn resultadoVC>
	</cffunction>
				

</cfcomponent>