<!---
-Se quitan los saltos de Linea y se pasa la hilera a XML
-Establezca el elemento raíz como el nodo Actual del DOM.
-Cuenta la Cantidad de Transacciones que posse el XML
-Recorre cada una de las Transacciones (lineas del XML).
-Verifica que la transaccion no exista en la tabla FAX001EX buscando por FAX01ENUMDOC y FAX01ESIS
-Si no se envio CTRO_COSTO el mismo se pone en Nulo
-Valida que los valores de FAX01EINDCODSUC,FAX01EINDANULA,FAX01EINDSERVSEP sea N,S o nulo
-Inserta el Encabezado de la transaccion(FAX001EX)
-Obtienen el siguiente FAX01NTR de FAX001.FAX01NTR para el mismo FAM01COD enviado en el XML
-Se genere un consecutivo de factura de Cajas (tomando el consecutivo según la impresora asignada a la caja correspondiente)
-Obtiene el Factor de Conversion entre la moneda local y la moneda de la transacción
-Insertar la transaccion de la Caja(FAX001)
-Inserta el Encabezado del Detalle de la transaccion
-INSERTAR LOS DETALLES CONTABLES DEL HIJO DEL DETALLE
-INSERTAR LOS CUPONES DEL HIJO DEL DETALLE	
INSERTAR LAS FORMAS DE PAGO FAX012
-Se revisa la tabla de facturación electrónica (fe_estadofacturacion) para saber si hay que generar documento electrónico o no.
-Registra en la tabla de facturación electrónica (fe_cola_facturas_electronicas) para que el documento sea enviado a signature
--->
<cfcomponent>

    <!---►►►Funcion Incluye Factura Directa◄◄◄--->
    <cffunction name="incluye_facturadirecta" access="remote" returntype="string" displayname="incluye_facturadirecta" hint="Funcion para incluir una Factura Directa">
		<cfargument name="xmlString" type="string" required="Yes" hint="XML con todas las transacciones">
	   
		<cfset resultado = "OK" >
        <!---►►►Se quitan los saltos de Linea y se pasa la hilera a XML◄◄◄--->
		<cfset LvarTiempoIni = GetTickCount()>
<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, inicializado: #LvarTiempoIni#">
<!--- <cfset LvarTiempo = GetTickCount()> --->


        
		<cfset archivo_xml = replace (#Arguments.xmlString#, chr(13), "", "All") >
		<cfset transXMLDOM = XMLParse(#archivo_xml#)>
		<!---►►►Establezca el elemento raíz como el nodo Actual del DOM◄◄◄--->
        <cfset trans 			= transXMLDOM.XMLROOT>
        <!---►►►Cuenta la Cantidad de Transacciones que posse el XML◄◄--->        
        <cfset numTRANSACCIONES = Arraylen(trans.XMLChildren)>
        <cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Antes de transaccion ******, milisegundos: #GetTickCount() - LvarTiempoIni#">
		<cftry>
        	<cftransaction>
            	<!---►►►Recorre cada una de las Transacciones (lineas del XML)◄◄◄--->
                <cfloop from="1" to="#numTRANSACCIONES#" index="i">
						<cfset TRANSACCION = trans.XmlChildren[i]>
                    	<!---►►►Verifica que la transaccion no exista en la tabla FAX001EX buscando por FAX01ENUMDOC y FAX01ESIS◄◄◄--->
						<cfset existeTransaccion = existeEncabezadoTransaccion("#TRANSACCION.FAX01ENUMDOC.XmlText#", "#TRANSACCION.FAX01ESIS.XmlText#") >
                    <cfif existeTransaccion EQ "SI">
                        <cfset resultado = "Ya existe el registro">
                     <cfelse>
                        <cfset resultado = procesarTransaccion(TRANSACCION)>
                    </cfif>
                </cfloop>
            </cftransaction>
			<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Fin de transaccion  ******, milisegundos: #GetTickCount() - LvarTiempoIni#">
				<cfcatch type = "Any">
					<cfset resultado="#cfcatch.message#, Detalle1: #cfcatch.detail#" & 
					                 "#TRANSACCION.FAX01ENUMDOC.XmlText#, #TRANSACCION.FAX01ESIS.XmlText#,"&
									 "#TRANSACCION.CODSUC.XmlText#, #TRANSACCION.FAM33COD.XmlText#">
                    <cftransaction action="rollback">
				</cfcatch>
			</cftry>
		<cfreturn "#resultado#">
	</cffunction>
	<!---►►►Funcion Procesar Transaccion◄◄◄--->
    <cffunction name="procesarTransaccion" access="private" returnType="string" hint="Funcion para procesar un unico Registro">
        <cfargument name="trans" type="xml" required="Yes" hint="Transacccion">
        
	    <cfset resultadoPT = "OK">
        <!---►►►Si no se envio CTRO_COSTO el mismo se pone en Nulo◄◄◄--->
        <cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Inicia procesarTransaccion, milisegundos: #GetTickCount() - LvarTiempoIni#">
		<cfset selectedElements = XmlSearch(trans,"//CTRO_COSTO")>
        <cfif Arraylen(selectedElements) LTE 0>
            <cfset CTRO_COSTO = "NULL">
        <cfelse>
            <cfset CTRO_COSTO = #trans.CTRO_COSTO.XmlText#>
        </cfif>
	    <cfset resultadoPT = insertarEncabezadoTransaccion(   
                                #trans.FAX01ENUMDOC.XmlText#,
                                #trans.FAX01ESIS.XmlText#,
                                #trans.CODSUC.XmlText#,
                                #trans.FAM33COD.XmlText#,
                                #trans.FAX01EDESEMP.XmlText#,
                                #trans.MONCOD.XmlText#,
                                #trans.FAX01ECLICOD.XmlText#,
                                #trans.FAX01EDESCLI.XmlText#,
                                #trans.FAX01ECEDCLI.XmlText#,
                                #trans.FAX01ECLIDEPTO.XmlText#,
                                #trans.FAX01EDESDEPTO.XmlText#,
                                #trans.FAX01ECEDDEP.XmlText#,
                                #trans.CCM21COD.XmlText#,
                                #trans.CCM21DES.XmlText#,
                                #trans.VYCCOD.XmlText#,
                                #trans.VYCNOM.XmlText#,
                                #trans.FAX01ECODODI.XmlText#,
                                #trans.FAX01EINDCODSUC.XmlText#,
                                #trans.FAX01EINDANULA.XmlText#,
                                #trans.FAX01EINDSERVSEP.XmlText#,
                                #CTRO_COSTO#) >
		<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Luego de insertarEncabezadoTransaccion y antes del cf lock, milisegundos: #GetTickCount() - LvarTiempoIni#">						
								
		<!---►►►Obtienen el siguiente FAX01NTR de FAX001.FAX01NTR para el mismo FAM01COD enviado en el XML◄◄◄--->
		<cflock type="exclusive" name="IS700" timeout="36000">
				
            <cfquery  name="TraeNumTr" datasource="CAJAS">
                select Coalesce(max(FAX01NTR), 0) as NumTrans
                from FAX001
                where FAM01COD = '#trans.CAJA.XmlText#'
        <!---►►►Se genere un consecutivo de factura de Cajas (tomando el consecutivo según la impresora asignada a la caja correspondiente)◄◄◄--->
            </cfquery>
			<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Luego de TraeNumTr, mlisegundos: #GetTickCount() - LvarTiempoIni#">						
		
            <cfquery  datasource="CAJAS">
			     update FAX001 
				 set FAX01NTR = FAX01NTR
                 where FAM01COD = '#trans.CAJA.XmlText#'
				  and FAX01NTR = #TraeNumTr.NumTrans#
            </cfquery>       
			<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Luego de update a FAX001, mlisegundos: #GetTickCount() - LvarTiempoIni#">
            <cfset LvarNumTrans = TraeNumTr.NumTrans + 1>
        
           	<cfset NewConsecutivo = ObtenerConsecutivoCaja(trans.CAJA.XmlText,trans.FAM33COD.XmlText)>
			<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Luego de NewConsecutivo, mlisegundos: #GetTickCount() - LvarTiempoIni#">
			<cfset resultadoPT = insertarTransCaja(
                                    #trans.CAJA.XmlText#,
                                    #trans.MONCOD.XmlText#,
                                    #trans.FAX01ECLICOD.XmlText#,
                                    #trans.USUARIO.XmlText#,
                                    #NewConsecutivo#,
                                    #trans.FAX01EDESCLI.XmlText#,
                                    #trans.FAM33COD.XmlText#,
                                    #trans.CCM21COD.XmlText#,
                                    #LvarNumTrans#,
                                    #trans.IMPRESAXCAJA.XmlText#)>
		</cflock>

		
		<cflog file="IS700Times#DateFormat(now(),'YYYYMMDD')#" text="IS700Times, Luego de insertarTransCaja y termina el cf lock ***, mlisegundos: #GetTickCount() - LvarTiempoIni#">
        
		<!--- ***** INSERTAR LOS DETALLES DE LA TRANSACCION --->
    	<cfset TotalD = 0.00>
		<cfset DescD = 0.00>
		<cfset ImpD = 0.00>	
        <cfset detallesTransaccion = trans.DETALLES >
        <cfset nDetalles = Arraylen( detallesTransaccion.XMLChildren ) >
        <cfloop from="1" to="#nDetalles#" index="i" >
            <cfset detalleHijo = detallesTransaccion.XmlChildren[i] >
			<cfset TotalD = TotalD + #detalleHijo.FAX04ETOTAL.XmlText#>
			<cfset DescD = DescD + #detalleHijo.FAX04EDESC.XmlText#>
			<cfset ImpD = ImpD + #detalleHijo.FAX04EIMPVENT.XmlText#>						
            <!--- ►►►Inserta el Encabezado del Detalle de la transaccion◄◄◄--->
            <cfset resultadoPT = insertarDetallesTransaccion( 
                                #detalleHijo.FAX01ENUMDOC.XmlText#,
                                #detalleHijo.FAX01ESIS.XmlText#,
                                #detalleHijo.FAX04ELIN.XmlText#,
                                #detalleHijo.FAX04EFECEMI.XmlText#,
                                #detalleHijo.FAX04ESTADO.XmlText#,
                                #detalleHijo.FAX04EMANUAL.XmlText#,
                                #detalleHijo.FAX04EDEV.XmlText#,
                                #detalleHijo.FAX04TTRAN.XmlText#,
                                #detalleHijo.FAX04ENUMOC.XmlText#,
                                #detalleHijo.FAX04EDETALLE.XmlText#,
                                #detalleHijo.FAX04EUSER.XmlText#,
                                #detalleHijo.FAX04EFEC.XmlText#,
                                #detalleHijo.FAX04ETIPPAGO.XmlText#,
                                #detalleHijo.FAX04ECANTIDAD.XmlText#,
                                #detalleHijo.FAX04ECODPRO.XmlText#,
                                #detalleHijo.FAX04EDESPRO.XmlText#,
                                #detalleHijo.FAX04EEDICION.XmlText#,
                                #detalleHijo.FAX04EFECDESP.XmlText#,
                                #detalleHijo.FAX04EFECVENCE.XmlText#,
                                #detalleHijo.FAX04EINDVENCE.XmlText#,
                                #detalleHijo.FAX04ESEPARAR.XmlText#,
                                #detalleHijo.FAX04ESUBTOT.XmlText#,
                                #detalleHijo.FAX04ENAC.XmlText#,
                                #detalleHijo.FAX04EVALES.XmlText#,
                                #detalleHijo.FAX04EDESC.XmlText#,
                                #detalleHijo.FAX04ETIMBRE.XmlText#,
                                #detalleHijo.FAX04EIMPVENT.XmlText#,
                                #detalleHijo.FAX04ECANJE.XmlText#,
                                #detalleHijo.FAX04ESERVICIO.XmlText#,
                                #detalleHijo.FAX04ETOTAL.XmlText#,
                                #detalleHijo.FAX11LIN.XmlText#,
                                #detalleHijo.FAX09SER.XmlText#,
                                #detalleHijo.FAM01COD.XmlText#,
                                #detalleHijo.FAX01NTR.XmlText#,
                                #detalleHijo.FAX04EBAT.XmlText#,
								#LvarNumTrans#,
								#trans.CAJA.XmlText#) >

            <!--- ***** INSERTAR LOS DETALLES CONTABLES DEL HIJO DEL DETALLE --->
			<cfset detallesContable = detalleHijo.CONTABLES >
            <cfset nDetallesContable = Arraylen( detallesContable.XMLChildren ) >
            <cfloop from="1" to="#nDetallesContable#" index="j" >
                <cfset contable = detallesContable.XmlChildren[j] >
                <cfset resultadoPT = insertarDetalleContable( 
                                #contable.FAX01ENUMDOC.XmlText#,
                                #contable.FAX01ESIS.XmlText#,
                                #contable.FAX04ELIN.XmlText#,
                                #contable.FAX04ECLIN.XmlText#,
                                #contable.FAX04ECRUB.XmlText#,
                                #contable.FAX04ECMONTO.XmlText#,
                                #contable.FAX04ECMOV.XmlText#,
                                #contable.MONCOD.XmlText#,
                                #contable.FAX04ECDES.XmlText#,
                                #contable.CTAM01.XmlText#,
                                #contable.CTAM02.XmlText#,
                                #contable.CTAM03.XmlText#,
                                #contable.CTAM04.XmlText#,
                                #contable.CTAM05.XmlText#,
                                #contable.CTAM06.XmlText#) >
            </cfloop>
            <!--- ***** INSERTAR LOS CUPONES DEL HIJO DEL DETALLE --->
            <cfset numCupones = XmlChildPos( detalleHijo, "CUPONES", 1) >
            <cfif numCupones NEQ "-1" >
                <cfset detallesCupones = detalleHijo.CUPONES >
                <cfset nCupones = Arraylen( detallesCupones.XMLChildren ) >
                <cfloop from="1" to="#nCupones#" index="k" >
                    <cfset cupon = detallesCupones.XmlChildren[k] >
                    <cfset resultadoPT = insertarDetalleCupon(
                                #cupon.FAX01ENUMDOC.XmlText#,
                                #cupon.FAX01ESIS.XmlText#,
                                #cupon.FAX04ELIN.XmlText#,
                                #cupon.FAX04ELINCUPON.XmlText#,
                                #cupon.FAX04ECANTCUPON.XmlText#,
                                #cupon.FAX04EVALCUPON.XmlText#,
                                #cupon.FAX04ECODCUPON.XmlText#) >
                </cfloop>
            </cfif>
        </cfloop>
		
		
            <!--- Fin de loop DETALLES DE TRANSACCION --->	
	        <!--- ***** INSERTAR LAS FORMAS DE PAGO FAX012--->
			<cfset TotalC = 0.00>
			<cfset TotalOTC = 0.00>
			<cfset TotalEF = 0.00>	
			<cfset TotalEFC = 0.00>	
			<cfset TotalTCC = 0.00>	
			<cfset TotalCkC = 0.00>
			<cfset detallesTransaccion = trans.FORMAPAGO >
			<cfset nDetalles = Arraylen( detallesTransaccion.XMLChildren ) >
			<cfloop from="1" to="#nDetalles#" index="i" >
				<cfset detalleHijo = detallesTransaccion.XmlChildren[i] >
				<cfif #detalleHijo.TIPO.XmlText# EQ "CK">
				   <cfset TotalCkC = TotalCkC + #detalleHijo.MONTOMONEDADOC.XmlText#>
				<cfelse>
					 <cfif #detalleHijo.TIPO.XmlText# EQ "TC">
					   <cfset TotalTCC = TotalTCC + #detalleHijo.MONTOMONEDADOC.XmlText#>
					 <cfelse>
					    <cfif #detalleHijo.TIPO.XmlText# EQ "EF">
						   <cfset TotalEF= TotalEF + #detalleHijo.MONTO.XmlText#>
						   <cfset TotalEFC = TotalEFC + #detalleHijo.MONTOMONEDADOC.XmlText#>
						<cfelse>
						   <cfset TotalOTC = TotalEFC + #detalleHijo.MONTOMONEDADOC.XmlText#>						
						</cfif>  
					 </cfif>  
				</cfif>
				<cfset TotalC = TotalC + #detalleHijo.MONTOMONEDADOC.XmlText#>	
				<cfset resultadoPT = insertarFAX012(
										#trans.CAJA.XmlText#,
										#LvarNumTrans#,
										#detalleHijo.FAX12lIN.XmlText#,
										#detalleHijo.TIPO.XmlText#,
										#detalleHijo.NUMERODOCUMENTO.XmlText#,
										#detalleHijo.MONEDA.XmlText#,
										#detalleHijo.MONTO.XmlText#,
										#detalleHijo.MONTOMONEDADOC.XmlText#,
										#detalleHijo.FECHA.XmlText#,
										#detalleHijo.BANCO.XmlText#,
										#detalleHijo.CUENTA.XmlText#,
										#detalleHijo.CODIGOTARJETA.XmlText#,
										#detalleHijo.AUTORIZACION.XmlText#,
										#detalleHijo.EMPRESA.XmlText#,
										#detalleHijo.BANCOD.XmlText#)>  
										                 
                                        
				<!---FAX014--->
                      
                 <cfquery datasource="CAJAS" name="rsLLave">
                    select FAX14CON  
                        from FAX014 
                       where CLICOD = '#trans.FAX01ECLICOD.XmlText#' 
                      and FAX14DOC = '#detalleHijo.NUMERODOCUMENTO.XmlText#'
                </cfquery>                       
                      
                <cfif rsLLave.recordcount eq 1>  
                    
                    <cfquery datasource="CAJAS" name="rsDatos">
                        select FAX14MON,FAX14MAP ,MONCOD 
                            from FAX014 
                            where FAX14CON=#rsLLave.FAX14CON#
                            and CLICOD = '#trans.FAX01ECLICOD.XmlText# '
                    </cfquery>
                    
                    <cfset LvarMonto =#detalleHijo.MONTO.XmlText#>
                    <cfset FactorCambio =1>
                    <cfif #detalleHijo.MONEDA.XmlText# neq rsDatos.MONCOD>
                        <cfset FactorCambio = ObtenerFactorConversion(#detalleHijo.MONEDA.XmlText#)>  
                        <cfset LvarMonto= LvarMonto *FactorCambio>
                   </cfif>
                    
                    <cfif #detalleHijo.TIPO.XmlText# eq 'AD' and rsDatos.FAX14MON gte (rsDatos.FAX14MAP+ #LvarMonto#)>
    
                        <cfquery datasource="CAJAS">
                            update FAX014 
                              set FAX14MAP = FAX14MAP + <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonto#">
                              where FAX14CON=#rsLLave.FAX14CON#
                              and CLICOD = '#trans.FAX01ECLICOD.XmlText# '
                        </cfquery>
                    
                    
                        <!---FAX016--->
                
                        <cfset resultadoFAX016 = insertarFAX016(
                                    #rsLLave.FAX14CON#,
                                    #trans.CAJA.XmlText#,
                                    #detalleHijo.MONTO.XmlText#,
                                    'FA',
                                    #TraeNumTr.NumTrans#,
                                    'T',
                                    #trans.FAX01ECLICOD.XmlText#
                                    )> 
						
						<cfif resultadoFAX016 neq "OK">
							<cfthrow message="#resultadoFAX016#">
						</cfif>		 
									
                    
                    <cfelse>
                        <cfthrow message = "Error tipo de documento no es AD (adelanto) o se sobregiro el monto del adelanto al actualizar el saldo (tipo enviado=#detalleHijo.TIPO.XmlText#, monto enviado=#LvarMonto# y TC=#FactorCambio#) ">
                    </cfif>                                                                         
                <cfelse>
                    <cfthrow message = "El numero de documento enviado (#detalleHijo.NUMERODOCUMENTO.XmlText#) no es valido para el cliente(#trans.FAX01ECLICOD.XmlText# ) ">		 		  	
                </cfif>                

                                    
			</cfloop>	
			<!--- Terminar la transaccion de Cajas  --->
			<cfif TotalC NEQ TotalD>
			   <cfset resultadoPT = " El detalle de las formas de pago no coincide con el total de la factura">
			<cfelse>
				<cfset resultadoPT = ActualizaTrans(
											#trans.CAJA.XmlText#,
											#LvarNumTrans#,
											 #TotalD#,
											 #DescD#,
											 #ImpD#,
											 #NewConsecutivo#,
											 #TotalC#,
											 #TotalOTC#,
											 #TotalEF#,	
											 #TotalEFC#,
											 #TotalTCC#,
											 #TotalCkC#,
											 #trans.USUARIO.XmlText#)>

			</cfif>
            <!---►►►Se revisa la tabla de facturación electrónica (fe_estadofacturacion) para saber si hay que generar documento electrónico o no◄◄◄--->
				<cfset RealizarFacElectronica = VerificaFacturacionElectronica()>
            <!---►►►Registra en la tabla de facturación electrónica (fe_cola_facturas_electronicas) para que el documento sea enviado a signature◄◄◄--->
			<cfif RealizarFacElectronica>
            	<cfset RegistraFacElectronica(trans.CAJA.XmlText,LvarNumTrans,NewConsecutivo)>
            </cfif>
		<cfset resultadoPT = replace(resultadoPT,"'","")>
        <cfreturn "#resultadoPT#">
    </cffunction>
    
	<!---►►►Funcion para insertar en FAX016◄◄◄--->
     <cffunction name="insertarFAX016" access="private" returnType="string" hint="Funcion para la insertar a la FAX016)">
        <cfargument name="FAX14CON"     type="string" required="Yes" hint="Consecutivo">
        <cfargument name="FAM01COD"     type="string" required="Yes" hint="Codigo de Caja">
        <cfargument name="FAX16MON"     type="string" required="Yes" hint="Monto a aplicar">
        <cfargument name="FAX16TIP"     type="string" required="Yes" hint="Tipo de Documento">
        <cfargument name="FAX01NTR"     type="string" required="Yes" hint="Numero de Transaccion">
        <cfargument name="FAX16STA"     type="string" required="Yes" hint="Estado de Aplicacion">
        <cfargument name="CLICOD"       type="string" required="Yes" hint="Código del cliente (Doc CxC)">
            <cfset resultadoFAX016 ="OK">
            
             <cfquery datasource="CAJAS" name="rsDatos">
                        select coalesce(max(FAX16CON),0) +1 as FAX16CON 
                            from FAX016 
                    </cfquery>
            <cftry>
                  
                <!---►►►Insertar la transaccion de la Caja(FAX001)◄◄◄--->
                <cfquery  name="InsFAX016" datasource="CAJAS">
                     insert FAX016 (FAX14CON,FAM01COD, FAX16MON,  FAX16TIP, FAX01NTR, FAX16STA, FAX16NDC, FAX16FEC,
                                     CLICOD, FAX16OBS,  FAX16CON)   
                        values(
                        <cfqueryparam cfsqltype="cf_sql_integer"    value="#ARGUMENTS.FAX14CON#">,
                        <cfqueryparam cfsqltype="cf_sql_char"       value="#ARGUMENTS.FAM01COD#">,
                        <cfqueryparam cfsqltype="cf_sql_float"      value="#ARGUMENTS.FAX16MON#">,
                        <cfqueryparam cfsqltype="cf_sql_char"       value="#ARGUMENTS.FAX16TIP#">,
                        <cfqueryparam cfsqltype="cf_sql_integer"    value="#ARGUMENTS.FAX01NTR#">,
                        <cfqueryparam cfsqltype="cf_sql_char"       value="#ARGUMENTS.FAX16STA#">,
                       '',
                        <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_char"       value="#ARGUMENTS.CLICOD#">,                        
                       '',
                        <cfqueryparam cfsqltype="cf_sql_integer"    value="#rsDatos.FAX16CON#">)
                </cfquery> 
				               
                <cfcatch type = "Any">
                    <cfset resultadoFAX016 = "[insertaFAX016]:" & #cfcatch.message# & ", Detalle2:" & #cfcatch.detail# >
                </cfcatch>
            </cftry>
            <cfreturn "#resultadoFAX016#">            
    </cffunction>
    
	<!---►►►Funcion que Verifica que la transaccion no exista en la tabla FAX001EX buscando por FAX01ENUMDOC y FAX01ESIS◄◄◄--->
    <cffunction name="existeEncabezadoTransaccion" access="private" returnType="string" hint="Funcion que Verifica que la transaccion no exista en la tabla FAX001EX buscando por FAX01ENUMDOC y FAX01ESIS">
        <cfargument name="FAX01ENUMDOC" type="string" required="Yes" hint="Campo FAX01ENUMDOC de la tabla FAX001EX">
        <cfargument name="FAX01ESIS"    type="string" required="Yes" hint="Campo FAX01ESIS de la tabla FAX001EX">
        <cftry>               
			<cfquery name="SelectFax001ex" datasource="CAJAS"> 
				SELECT 1 
					FROM FAX001EX 
					WHERE FAX01ENUMDOC = '#ARGUMENTS.FAX01ENUMDOC#' 
					  AND FAX01ESIS = '#ARGUMENTS.FAX01ESIS#' 
			</cfquery>
            <cfif #SelectFax001ex.RecordCount# GT 0>
                <cfset res = "SI">
            <cfelse>
                <cfset res = "NO">
            </cfif>
 	        <cfcatch type = "ANY">
                <cfset res = "[Ya Existe FAX001EX] " & #CFCATCH.message# & ", Detalle7: " & #CFCATCH.detail# >
            </cfcatch>
        </cftry>
        <cfreturn "#res#"/>
    </cffunction>
	<!---►►►Funcion para insertar el Encabezado de la transacción◄◄◄--->
    <cffunction name="insertarEncabezadoTransaccion" access="private" returnType="string" hint="Funcion para insertar el Encabezado de la transacción(FAX001EX)">
	    <cfargument name="FAX01ENUMDOC" 	 type="string" required="Yes">
        <cfargument name="FAX01ESIS" 		 type="string" required="Yes">
        <cfargument name="CODSUC" 			 type="string" required="Yes">
        <cfargument name="FAM33COD" 		 type="string" required="Yes">
        <cfargument name="FAX01EDESEMP" 	 type="string" required="Yes">
        <cfargument name="MONCOD" 			 type="string" required="Yes">
        <cfargument name="FAX01ECLICOD" 	 type="string" required="Yes">
        <cfargument name="FAX01EDESCLI" 	 type="string" required="Yes">
        <cfargument name="FAX01ECEDCLI" 	 type="string" required="Yes">
        <cfargument name="FAX01ECLIDEPTO" 	 type="string" required="Yes">
        <cfargument name="FAX01EDESDEPTO" 	 type="string" required="Yes">
        <cfargument name="FAX01ECEDDEP" 	 type="string" required="Yes">
        <cfargument name="CCM21COD" 		 type="string" required="Yes">
        <cfargument name="CCM21DES" 		 type="string" required="Yes">
        <cfargument name="VYCCOD" 			 type="string" required="Yes">
        <cfargument name="VYCNOM" 			 type="string" required="Yes">
        <cfargument name="FAX01ECODODI" 	 type="string" required="Yes">
        <cfargument name="FAX01EINDCODSUC" 	 type="string" required="Yes">
        <cfargument name="FAX01EINDANULA" 	 type="string" required="Yes">
        <cfargument name="FAX01EINDSERVSEP"  type="string" required="Yes">
        <cfargument name="CTRO_COSTO"  		 type="string" required="No">
        <cfset resultadoIET = "OK">
        <cfset hileraIET    = "#ARGUMENTS.FAX01ENUMDOC#, #ARGUMENTS.FAX01ESIS#, #ARGUMENTS.CODSUC#, #ARGUMENTS.FAM33COD#" >
        <!---►►►Valida que los valores de FAX01EINDCODSUC,FAX01EINDANULA,FAX01EINDSERVSEP sea N,S o nulo◄◄◄--->
        <cfif FAX01EINDCODSUC NEQ "S" AND FAX01EINDCODSUC NEQ "N" AND FAX01EINDCODSUC NEQ "NULL">
            <cfset resultadoIET = "Valor de FAX01EINDCODSUC incorrecto" >
        </cfif>
        <cfif resultadoIET EQ "OK">
            <cfif FAX01EINDANULA NEQ "S" AND FAX01EINDANULA NEQ "N" AND FAX01EINDANULA NEQ "NULL">
                <cfset resultadoIET = "Valor de FAX01EINDANULA incorrecto" >
            </cfif>
        </cfif>
        <cfif resultadoIET EQ "OK">
            <cfif FAX01EINDSERVSEP NEQ "S" AND FAX01EINDSERVSEP NEQ "N" AND FAX01EINDSERVSEP NEQ "NULL">
                <cfset resultadoIET = "Valor de FAX01EINDSERVSEP incorrecto">
            </cfif>
        </cfif>

        <cfif resultadoIET EQ "OK">
            <!---►►►Armado de la sentencia sql◄◄◄--->
            <cfset sqlIET = "INSERT INTO FAX001EX ( FAX01ENUMDOC, FAX01ESIS, CODSUC, FAM33COD, FAX01EDESEMP, " &
                            "MONCOD, FAX01ECLICOD, FAX01EDESCLI, FAX01ECEDCLI, FAX01ECLIDEPTO, FAX01EDESDEPTO, " &
                            "FAX01ECEDDEP, CCM21COD, CCM21DES, VYCCOD, VYCNOM, FAX01ECODODI, FAX01EINDCODSUC, " &
                            "FAX01EINDANULA, FAX01EINDSERVSEP, CTRO_COSTO ) VALUES (" >
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ENUMDOC#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ESIS#,       0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.CODSUC#,          0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAM33COD#,        0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EDESEMP#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.MONCOD#,          0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ECLICOD#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EDESCLI#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ECEDCLI#,    0, 0)> 
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ECLIDEPTO#,  0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EDESDEPTO#,  0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ECEDDEP#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.CCM21COD#,        0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.CCM21DES#,        0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.VYCCOD#,          0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.VYCNOM#,          0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01ECODODI#,    0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EINDCODSUC#, 0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EINDANULA#,  0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.FAX01EINDSERVSEP#,0, 0)>
            <cfset sqlIET = sqlIET & procesarArgumento(#ARGUMENTS.CTRO_COSTO#,      0, 1)>

            <!---►►►2. Inserción en la base de datos FAX001EX◄◄◄--->
            <cftry>
                <cfquery datasource="CAJAS" name="InsertaFax001ex">
                    #PreserveSingleQuotes(sqlIET)#
                </cfquery>
                <cfcatch type = "Any">
                    <cfset resultadoIET = "#cfcatch.message#, Detalle2: #cfcatch.detail#">
                </cfcatch>
            </cftry>
        </cfif>
        <cfif resultadoIET NEQ "OK">    
            <cfthrow message = "[insertarEncabezadoTransaccion]: #resultadoIET#">
        </cfif>
        <cfreturn "#resultadoIET#"/>
    </cffunction>
	<!---►►►Funcion para procesa Argumentos del SQL◄◄◄--->
    <cffunction name="procesarArgumento" access="private" returnType="string" hint="Funcion para procesa Argumentos del SQL">
        <cfargument name="VALOR" 	 type="string"  required="Yes" hint="Valor del Argumento">
        <cfargument name="ES_NUMERO" type="numeric" required="Yes" hint="Bandera para saber si es Numerico">
        <cfargument name="ES_ULTIMO" type="numeric" required="Yes" hint="Bandera para saber si es el Ultimo valor del SQL">

        <!--- Para prevenir espacios en el sql, se los elimina aquí --->
        <CFSET argumento  = "#ARGUMENTS.VALOR#" >
        <CFSET resFuncion = "" >
        <CFSET conector   = "" >
        
        <cfif ES_ULTIMO EQ 1 >
            <cfset conector = ")" >
        <cfelse>
            <cfset conector = "," >
        </cfif>    
        
        <cfif argumento EQ "NULL" >
            <cfset resFuncion = "NULL" & conector>
        <cfelse>
            <cfif ARGUMENTS.ES_NUMERO EQ 1 >
                <cfset resFuncion = "#argumento#" & conector>
            <cfelse>
                <cfset resFuncion = "'#argumento#'" & conector>
            </cfif>        
        </cfif>
        
        <cfreturn resFuncion>
    </cffunction>
	<!------>
    <cffunction name="insertarTransCaja" access="private" returnType="string" hint="Funcion para la insertar la transaccion de la Caja(FAX001)">
		<cfargument name="CAJA" 		type="string" required="Yes" hint="Caja">
		<cfargument name="MONCOD" 		type="string" required="Yes" hint="Moneda">
		<cfargument name="FAX01ECLICOD" type="string" required="Yes">
		<cfargument name="USUARIO" 		type="string" required="Yes">
		<cfargument name="DOCUMENTO" 	type="string" required="Yes">
		<cfargument name="FAX01EDESCLI" type="string" required="Yes">
		<cfargument name="FAM33COD" 	type="string" required="Yes">
		<cfargument name="CCM21COD" 	type="string" required="Yes">
		<cfargument name="NumTrans" 	type="string" required="Yes">	
		<cfargument name="ImpresaxCaja" type="string" required="Yes">				
			<cfset resultadoITC ="OK">
			<cftry>
				<cfquery  name="TraeCia" datasource="CAJAS">
				   select CG49CO 
						from FAM033
						where FAM33COD = '#ARGUMENTS.FAM33COD#'
				</cfquery>	
                <!---►►►Obtiene el Factor de Conversion entre la moneda local y la moneda de la transacción◄◄◄--->
				<cfset FactorCambio = ObtenerFactorConversion(ARGUMENTS.MONCOD)>
				<!---►►►Insertar la transaccion de la Caja(FAX001)◄◄◄--->
				
   <!---         <cfset sqlIDT = "insert FAX001 (FAM01COD, FAX01NTR,  FAX01FEC,    FAX01TOT,     FAX01TIP,   MONCOD,   CLICOD, " &
                            " FAX01TPG, FAX01STA,  FAX01USR,    FAX01AUT,     FAX01DOC,   FAX01PDC, FAX01PDT, FAX01MDT, FAX01MDL, " &
                            " FAX01MIT, FAX01APD,  FAX01EXE,    FAX01NDOC,    CG49CO,     CCM21COD, " &
                            "FAX01IMP, FAX01FCAM, FAX01FACDIR, FAX01IMPCAJA, FAX01IMPPV, FAX01USUARIOFD) VALUES (">
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.CAJA#,   		0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.NumTrans#,    1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#now()#,      			0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.0,   					1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(1,    					0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.MONCOD#,   	0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX01ECLICOD#,0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0,     					1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento("P",     				0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.USUARIO#,     0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0,     					1, 0)>						
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.DOCUMENTO#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.00,     				1, 0)>						
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.00,     				1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.00,     				1, 0)>												
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.00,     				1, 0)>						
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.00,     				1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0,     					1, 0)>												
            <cfset sqlIDT = sqlIDT & procesarArgumento(0,     					1, 0)>						
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX01EDESCLI#,0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#TraeCia.CG49CO#,     	1, 0)>		
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.CCM21COD#,    0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(0.0,     				1, 0)>		
            <cfset sqlIDT = sqlIDT & procesarArgumento(#FactorCambio#,     		1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento("S",     				0, 0)>		
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.IMPRESAXCAJA#,0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento("N",     				0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.USUARIO#,     0, 1)>		--->																												
        		
				<cfset LvarFecha = createODBCdatetime(now())>
                <cfquery  name="InsFAX001" datasource="CAJAS">
				     insert FAX001 (FAM01COD, FAX01NTR,  FAX01FEC,    FAX01TOT,     FAX01TIP,   MONCOD,   CLICOD,
					 				FAX01TPG, FAX01STA,  FAX01USR,    FAX01AUT,     FAX01DOC,   FAX01PDC, FAX01PDT, FAX01MDT, FAX01MDL, 
								    FAX01MIT, FAX01APD,  FAX01EXE,    FAX01NDOC,    CG49CO,     CCM21COD, 
								    FAX01IMP, FAX01FCAM, FAX01FACDIR, FAX01IMPCAJA, FAX01IMPPV, FAX01USUARIOFD)   
					    values(
                        <cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.CAJA#">,
						<cfqueryparam cfsqltype="cf_sql_integer" 	value="#ARGUMENTS.NumTrans#">,
						#now()#,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="0.0">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="1">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.MONCOD#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.FAX01ECLICOD#">,
						<cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="P">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.USUARIO#">,
						<cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.DOCUMENTO#">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="0.0">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="0.0">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="0.0">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="0.0">, 
						<cfqueryparam cfsqltype="cf_sql_money" 		value="0.0">, 
						<cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,
						<cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.FAX01EDESCLI#">,
						<cfqueryparam cfsqltype="cf_sql_integer"	value="#TraeCia.CG49CO#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.CCM21COD#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="0.0">,
						<cfqueryparam cfsqltype="cf_sql_float" 		value="#FactorCambio#">,	
						<cfqueryparam cfsqltype="cf_sql_char" 		value="S">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.IMPRESAXCAJA#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="N">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.USUARIO#">)
				</cfquery>				
			    <cfcatch type = "Any">
<!---                    <cfset resultadoITC = "[insertaFAX001]:" & #cfcatch.message# & ", Detalle2:" & #cfcatch.detail# & ", SQL:" & #sqlIDT#>--->
					<cfset resultadoITC = "[insertaFAX001]:" & #cfcatch.message# & ", Detalle2:" & #cfcatch.detail# >
                </cfcatch>
            </cftry>
			
			<cfif resultadoITC NEQ "OK" >    
            	<cfthrow message = "[insertarEncabezadoFAX001]: #resultadoITC#" >
        	</cfif>
			
			<cfreturn "#resultadoITC#">			
	</cffunction>	
	
    <cffunction name="insertarDetallesTransaccion" access="private" returnType="string" >
        <cfargument name="FAX01ENUMDOC" 	type="string" required="Yes">
        <cfargument name="FAX01ESIS" 		type="string" required="Yes">
        <cfargument name="FAX04ELIN" 		type="string" required="Yes">
        <cfargument name="FAX04EFECEMI" 	type="string" required="Yes">
        <cfargument name="FAX04ESTADO" 		type="string" required="Yes">
        <cfargument name="FAX04EMANUAL" 	type="string" required="Yes">
        <cfargument name="FAX04EDEV" 		type="string" required="Yes">
        <cfargument name="FAX04TTRAN" 		type="string" required="Yes">
        <cfargument name="FAX04ENUMOC" 		type="string" required="Yes">
        <cfargument name="FAX04EDETALLE" 	type="string" required="Yes">
        <cfargument name="FAX04EUSER" 		type="string" required="Yes">
        <cfargument name="FAX04EFEC" 		type="string" required="Yes">
        <cfargument name="FAX04ETIPPAGO" 	type="string" required="Yes">
        <cfargument name="FAX04ECANTIDAD" 	type="string" required="Yes">
        <cfargument name="FAX04ECODPRO" 	type="string" required="Yes">
        <cfargument name="FAX04EDESPRO" 	type="string" required="Yes">
        <cfargument name="FAX04EEDICION" 	type="string" required="Yes">
        <cfargument name="FAX04EFECDESP" 	type="string" required="Yes">
        <cfargument name="FAX04EFECVENCE" 	type="string" required="Yes">
        <cfargument name="FAX04EINDVENCE" 	type="string" required="Yes">
        <cfargument name="FAX04ESEPARAR" 	type="string" required="Yes">
        <cfargument name="FAX04ESUBTOT" 	type="string" required="Yes">
        <cfargument name="FAX04ENAC" 		type="string" required="Yes">
        <cfargument name="FAX04EVALES" 		type="string" required="Yes">
        <cfargument name="FAX04EDESC" 		type="string" required="Yes">
        <cfargument name="FAX04ETIMBRE" 	type="string" required="Yes">
        <cfargument name="FAX04EIMPVENT" 	type="string" required="Yes">
        <cfargument name="FAX04ECANJE" 		type="string" required="Yes">
        <cfargument name="FAX04ESERVICIO" 	type="string" required="Yes">
        <cfargument name="FAX04ETOTAL" 		type="string" required="Yes">
        <cfargument name="FAX11LIN" 		type="string" required="Yes">
        <cfargument name="FAX09SER" 		type="string" required="Yes">
        <cfargument name="FAM01COD" 		type="string" required="Yes">
        <cfargument name="FAX01NTR" 		type="string" required="Yes">
        <cfargument name="FAX04EBAT" 		type="string" required="Yes">
        <cfargument name="NumTrans" 		type="string" required="Yes">
        <cfargument name="CAJA" 			type="string" required="Yes">		

        <cfset resultadoIDT = "OK" >
        <cfset enviadoIDT   = "" >
        <cfset hileraIDT    = "#ARGUMENTS.FAX01ENUMDOC#, #ARGUMENTS.FAX01ESIS#, #ARGUMENTS.FAX04ELIN#" >
        <!--- ****** Validaciones correspondientes --->
        <cfif FAX04ESTADO NEQ "P" AND FAX04ESTADO NEQ "A" AND FAX04ESTADO NEQ "I" AND FAX04ESTADO NEQ "E">
            <cfset resultadoIDT = "Valor de FAX04ESTADO incorrecto" >
        </cfif>
        <cfif resultadoIDT EQ "OK" >
            <cfif FAX04EDEV NEQ "S" AND FAX04EDEV NEQ "N" AND FAX04EDEV NEQ "NULL" >
                <cfset resultadoIDT = "Valor de FAX04EDEV incorrecto" >
            </cfif>
        </cfif>
        <cfif resultadoIDT EQ "OK" >
            <cfif FAX04EINDVENCE NEQ "S" AND FAX04EINDVENCE NEQ "N" >
                <cfset resultadoIDT = "Valor de FAX04EINDVENCE incorrecto" >
            </cfif>
        </cfif>
        <cfif resultadoIDT EQ "OK" >
            <cfif FAX04ETIPPAGO NEQ "TC" AND FAX04ETIPPAGO NEQ "CK" AND FAX04ETIPPAGO NEQ "DB" AND FAX04ETIPPAGO NEQ "NC" AND 
                  FAX04ETIPPAGO NEQ "CP" AND FAX04ETIPPAGO NEQ "EF" AND FAX04ETIPPAGO NEQ "OT" AND FAX04ETIPPAGO NEQ "AD" AND 
                  FAX04ETIPPAGO NEQ "CR" AND FAX04ETIPPAGO NEQ "OC" AND FAX04ETIPPAGO NEQ "NULL" >
                <cfset resultadoIDT = "Valor de FAX04ETIPPAGO incorrecto" >
            </cfif>
        </cfif>
        <cfif resultadoIDT EQ "OK" >
            <cfif FAX04ESEPARAR NEQ "S" AND FAX04ESEPARAR NEQ "N" AND FAX04ESEPARAR NEQ "NULL" >
                <cfset resultadoIDT = "Valor de FAX04ESEPARAR incorrecto" >
            </cfif>
        </cfif>
        <cfif resultadoIDT EQ "OK" >
            <!--- ***** 1. Armado de la sentencia sql --->
            <cfset sqlIDT = "INSERT INTO FAX004EX ( FAX01ENUMDOC, FAX01ESIS, FAX04ELIN, FAX04EFECEMI, FAX04ESTADO, " &
                            "FAX04EMANUAL, FAX04EDEV, FAX04TTRAN, FAX04ENUMOC, FAX04EDETALLE, FAX04EUSER, FAX04EFEC, " &
                            "FAX04ETIPPAGO, FAX04ECANTIDAD, FAX04ECODPRO, FAX04EDESPRO, FAX04EEDICION, FAX04EFECDESP, " &
                            "FAX04EFECVENCE, FAX04EINDVENCE, FAX04ESEPARAR, FAX04ESUBTOT, FAX04ENAC, FAX04EVALES, " &
                            "FAX04EDESC, FAX04ETIMBRE, FAX04EIMPVENT, FAX04ECANJE, FAX04ESERVICIO, FAX04ETOTAL, FAX11REC, " &
                            "FAX09SER, FAM01COD, FAX01NTR, FAX04EBAT ) VALUES (">
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX01ENUMDOC#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX01ESIS#,      0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ELIN#,      1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EFECEMI#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ESTADO#,    0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EMANUAL#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EDEV#,      0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04TTRAN#,     0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ENUMOC#,    0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EDETALLE#,  0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EUSER#,     0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EFEC#,      0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ETIPPAGO#,  0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ECANTIDAD#, 1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ECODPRO#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EDESPRO#,   0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EEDICION#,  1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EFECDESP#,  0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EFECVENCE#, 0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EINDVENCE#, 0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ESEPARAR#,  0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ESUBTOT#,   1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ENAC#,      1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EVALES#,    1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EDESC#,     1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ETIMBRE#,   1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EIMPVENT#,  1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ECANJE#,    1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ESERVICIO#, 1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04ETOTAL#,    1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX11LIN#,       1, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX09SER#,       0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAM01COD#,       0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX01NTR#,       0, 0)>
            <cfset sqlIDT = sqlIDT & procesarArgumento(#ARGUMENTS.FAX04EBAT#,      1, 1)>
            <!--- ***** 2. Inserción en la base de datos FAX004EX --->
            <cftry>
                <cfquery datasource="CAJAS" name="InsertaFax004ex">
                    #PreserveSingleQuotes(sqlIDT)#
                </cfquery>
				<cfcatch type = "Any">
                    <cfset resultadoIDT = "FAX004EX:: Mensaje: SQL:  #cfcatch.Message# #cfcatch.Sql# ">
                </cfcatch>
			</cftry>
		</cfif>
		<cfif resultadoIDT EQ "OK" >
			<cftry>	
				<cfset PrecioU = ((FAX04ESUBTOT+FAX04ETIMBRE + FAX04ESERVICIO) - (FAX04ENAC+FAX04EVALES+FAX04ECANJE)) / FAX04ECANTIDAD >
	            <!--- ***** 3. Inserción del detalle de la transaccion FAX004 --->				
				<cfquery name="InsertaFAX004" datasource="CAJAS">
					 insert FAX004 (FAM01COD,  FAX01NTR, FAX04LIN,  FAX01FEC,  FAX04CAN,  FAX04CVD,
								    FAX04TIP,  FAX04PRE, FAX04DESC, FAX04PDSC, FAX04IMP,  FAX04EXE, FAX04TOT, FAX04DEL,
								    FAX04DES,  FAX04LIE, FAX04CDE,  FAX04NTE)
						  values ( <cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.CAJA#">,	
						           <cfqueryparam cfsqltype="cf_sql_integer" 		value="#ARGUMENTS.NumTrans#">,	
								   <cfqueryparam cfsqltype="cf_sql_integer" 		value="#ARGUMENTS.FAX04ELIN#">,
							   	   <cfqueryparam cfsqltype="cf_sql_date" 	value="#ARGUMENTS.FAX04EFECEMI#">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#ARGUMENTS.FAX04ECANTIDAD#">,
								   <cfqueryparam cfsqltype="cf_sql_varchar" 		value="  ">,								   	
								   <cfqueryparam cfsqltype="cf_sql_char" 		value="A">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#PrecioU#">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#ARGUMENTS.FAX04EDESC#">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#ARGUMENTS.FAX04EDESC#">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#ARGUMENTS.FAX04EIMPVENT#">,	
								   <cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,	
								   <cfqueryparam cfsqltype="cf_sql_float" 		value="#ARGUMENTS.FAX04ETOTAL#">,	
								   <cfqueryparam cfsqltype="cf_sql_bit" 		value="0">,	
								   <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#ARGUMENTS.FAX04EDESPRO#">,	
								   <cfqueryparam cfsqltype="cf_sql_integer" 	value="#ARGUMENTS.FAX04ELIN#">,	
								   <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#ARGUMENTS.FAX01ESIS#">,	
								   <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#ARGUMENTS.FAX01ENUMDOC#">)

				</cfquery>
				
                <cfcatch type = "Any">
                    <!---<cfset resultadoIDT = "#cfcatch.message#, INSFAX004: #cfcatch.detail# pk #ARGUMENTS.CAJA# #ARGUMENTS.NumTrans# #ARGUMENTS.FAX04ELIN# pk" >--->
					<cfset resultadoIDT = "INSFAX004:... #cfcatch.detail# pk #ARGUMENTS.CAJA# #ARGUMENTS.NumTrans# #ARGUMENTS.FAX04ELIN# pk" >
                </cfcatch>
            </cftry>
        </cfif>
		<cfif resultadoIDT NEQ "OK" >    
            <cfthrow message = "[insertarDetalleFAX004EX]: #resultadoIDT#" >
        </cfif>
		<cfreturn "#resultadoIDT#" />
    </cffunction>
	
    <cffunction name="insertarDetalleContable" access="private" returnType="string" >
        <cfargument name="FAX01ENUMDOC" type="string" required="Yes">
        <cfargument name="FAX01ESIS" 	type="string" required="Yes">
        <cfargument name="FAX04ELIN" 	type="string" required="Yes">
        <cfargument name="FAX04ECLIN" 	type="string" required="Yes">
        <cfargument name="FAX04ECRUB" 	type="string" required="Yes">
        <cfargument name="FAX04ECMONTO" type="string" required="Yes">
        <cfargument name="FAX04ECMOV" 	type="string" required="Yes">
        <cfargument name="MONCOD" 		type="string" required="Yes">
        <cfargument name="FAX04ECDES" 	type="string" required="Yes">
        <cfargument name="CTAM01" 		type="string" required="Yes">
        <cfargument name="CTAM02" 		type="string" required="Yes">
        <cfargument name="CTAM03" 		type="string" required="Yes">
        <cfargument name="CTAM04" 		type="string" required="Yes">
        <cfargument name="CTAM05" 		type="string" required="Yes">
        <cfargument name="CTAM06" 		type="string" required="Yes">

        <cfset resultadoIDC = "OK" >
        <cfset enviadoIDC   = "" >
        <!--- ****** Validaciones correspondientes --->
        <cfif FAX04ECMOV NEQ "C" AND FAX04ECMOV NEQ "D">
            <cfset resultadoIDC = "Valor de FAX04ECMOV incorrecto" >
        </cfif>
        <cfif resultadoIDC EQ "OK" >
            <!--- ***** 1. Armado de la sentencia sql --->
            <cfset sqlIDC = "INSERT INTO FAX004EXC ( FAX01ENUMDOC, FAX01ESIS, FAX04ELIN, FAX04ECLIN, FAX04ECRUB, " &
                            "FAX04ECMONTO, FAX04ECMOV, MONCOD, FAX04ECDES, CTAM01, CTAM02, CTAM03, CTAM04, CTAM05, " &
                            "CTAM06 ) VALUES (">
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX01ENUMDOC#, 0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX01ESIS#,    0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ELIN#,    1, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ECLIN#,   1, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ECRUB#,   0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ECMONTO#, 1, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ECMOV#,   0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.MONCOD#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.FAX04ECDES#,   0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM01#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM02#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM03#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM04#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM05#,       0, 0)>
            <cfset sqlIDC = sqlIDC & procesarArgumento(#ARGUMENTS.CTAM06#,       0, 1)>

            <!--- ***** 2. Inserción en la base de datos FAX004EXC --->
            <cftry>
                <cfquery datasource="CAJAS" name="InsertaFax004exc">
                    #PreserveSingleQuotes(sqlIDC)#
                </cfquery>
                <cfcatch type = "Any">
                    <cfset resultadoIDC = "#cfcatch.message#, Detalle4: #cfcatch.detail#, sql: #sqlIDC#" >
                </cfcatch>
            </cftry>
        </cfif>
        <cfif resultadoIDC NEQ "OK" >    
            <cfthrow message = "[insertarDetalleContable]: #resultadoIDC#" >
        </cfif>
        <cfreturn "#resultadoIDC#" />
    </cffunction>
	
    <cffunction name="insertarDetalleCupon" access="private" returnType="string" >
        <cfargument name="FAX01ENUMDOC" 	type="string" required="Yes">
        <cfargument name="FAX01ESIS" 		type="string" required="Yes">
        <cfargument name="FAX04ELIN" 		type="string" required="Yes">
        <cfargument name="FAX04ELINCUPON" 	type="string" required="Yes">
        <cfargument name="FAX04ECANTCUPON" 	type="string" required="Yes">
        <cfargument name="FAX04EVALCUPON" 	type="string" required="Yes">
        <cfargument name="FAX04ECODCUPON" 	type="string" required="Yes">
        <cfset resultadoCUP = "OK" >
        <!--- ***** 1. Armado de la sentencia sql --->
        <cfset sqlCUP = "INSERT INTO FAX004EXCUP ( FAX01ENUMDOC, FAX01ESIS, FAX04ELIN, FAX04ELINCUPON, " &
                        "FAX04ECANTCUPON, FAX04EVALCUPON, FAX04ECODCUPON ) VALUES (" >
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX01ENUMDOC#,    0, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX01ESIS#,       0, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX04ELIN#,       1, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX04ELINCUPON#,  1, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX04ECANTCUPON#, 1, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX04EVALCUPON#,  1, 0)>
        <cfset sqlCUP = sqlCUP & procesarArgumento(#ARGUMENTS.FAX04ECODCUPON#,  0, 1)>
        <!--- ***** 2. Inserción en la base de datos FAX004EXCUP --->
        <cftry>
            <cfquery datasource="CAJAS" name="InsertaFax004excup">
                #PreserveSingleQuotes(sqlCUP)#
            </cfquery>
            <cfcatch type = "Any">
                <cfset resultadoCUP = "#cfcatch.message#, Detalle5: #cfcatch.detail#, sql: #sqlCUP#" >
            </cfcatch>
        </cftry>
        <cfif resultadoCUP NEQ "OK" >    
            <cfthrow message="[insertarDetalleCupon]: #resultadoCUP#" >
        </cfif>
        <cfreturn "#resultadoCUP#" />
    </cffunction>

	<cffunction name="InsertarFAX012" access="private" returntype="string">
		  <cfargument name="CAJA" 			type="string" required="Yes">
		  <cfargument name="NumTrans" 		type="string" required="Yes">
		  <cfargument name="Linea" 			type="string" required="Yes">
		  <cfargument name="Tipo" 			type="string" required="Yes">
		  <cfargument name="NumDocumento" 	type="string" required="No">
  		  <cfargument name="Moneda" 		type="string" required="Yes">
		  <cfargument name="Monto" 			type="string" required="Yes">
		  <cfargument name="MontoMDoc" 		type="string" required="Yes">
		  <cfargument name="Fecha" 			type="string" required="Yes">
  		  <cfargument name="Banco" 			type="string" required="No">
 		  <cfargument name="Cuenta" 		type="string" required="No">
		  <cfargument name="CodigoTarjeta" 	type="string" required="No">
		  <cfargument name="Autorizacion" 	type="string" required="No">   	
  		  <cfargument name="Empresa" 		type="string" required="No">  
  		  <cfargument name="Bancod" 		type="string" required="No">  		   		  
		  <cfset resultado = "OK">
		  <cftry>
				
			<cfquery  name="TraeCiaCk" datasource="CAJAS">
				   select CG49CO = CG49CO
						from FAM033
						where FAM33COD = '#ARGUMENTS.Empresa#'
			</cfquery>	
			<cfif #TraeCiaCk.RecordCount# GT 0>
			   <cfset Cia = #TraeCiaCk.CG49CO#>
			<cfelse>
			   <cfset Cia = 'null'>
			</cfif>
			<cfif ARGUMENTS.Tipo EQ "DB" >
				<cfquery  name="TraeBAnco" datasource="CAJAS">
					   select B01COD = B01COD, BANCUE= BANCUE
							from BANARC
							where BANCOD = '#ARGUMENTS.Bancod#'
				</cfquery>	
				<cfif #TraeBanco.RecordCount# GT 0>
				   <cfset BancoC = #TraeBanco.B01COD#>
				   <cfset CuentaC = #TraeBanco.BANCUE#>				   
				</cfif>
			<cfelse>
				   <cfset BancoC = #ARGUMENTS.Banco#>
				   <cfset CuentaC = #ARGUMENTS.Cuenta#>				   
			</cfif>
			
			
			<cfquery datasource="CAJAS" name="InsertaFAX012">
				insert FAX012 
				(FAM01COD, FAX01NTR, FAX12LIN, FAX12NUM ,  MONCOD, FAX12TOT, FAX12TOTMF, FAX12FEC, FAX12TIP, FAX12GND,  B01COD, FAX12CTA, FAX12ATB, CG49CO, FAM10COD)
				
				values (<cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.CAJA#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.NumTrans#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.Linea#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.NumDocumento#">,						
						<cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.Moneda#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.Monto#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.MontoMDoc#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#ARGUMENTS.Fecha#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.Tipo#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						<cfif isdefined("BancoC") and len(trim(BancoC)) and  BancoC NEQ "NULL"><cfqueryparam cfsqltype="cf_sql_varchar" value="#BancoC#"><cfelse>null</cfif>,
						<cfif isdefined("CuentaC") and len(trim(CuentaC)) and CuentaC NEQ "NULL"><cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaC#"><cfelse>null</cfif>,
						<cfif isdefined("ARGUMENTS.Autorizacion") and len(trim(ARGUMENTS.Autorizacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Autorizacion#"><cfelse>null</cfif>,
						<cfif isdefined("TraeCiaCk.CG49CO") and len(trim(TraeCiaCk.CG49CO))><cfqueryparam cfsqltype="cf_sql_integer" value="#TraeCiaCk.CG49CO#"><cfelse>null</cfif>,
						<cfif isdefined("ARGUMENTS.CodigoTarjeta") and len(trim(ARGUMENTS.CodigoTarjeta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.CodigoTarjeta#"><cfelse>null</cfif>)
						

			</cfquery>
			<cfcatch type = "Any">
				<cfset resultado = "[FAX012]: #cfcatch.message#, INSERT FAX012 Detalle: #cfcatch.detail#" >
			</cfcatch>
		  </cftry>
				<cfquery datasource="CAJAS" name="rsFAX012">
						select FAM01COD from FAX012 where FAM01COD = '#ARGUMENTS.CAJA#'       AND FAX01NTR = #ARGUMENTS.NumTrans#
				</cfquery>
				<cfif rsFAX012.recordcount EQ 0>
					 <cfset resultado = " CATCH: " & resultado & " - Error en la forma de pago">
				</cfif>
				<cfif resultado NEQ "OK" >    
                    <cfthrow message="[InsertaFAX012]: #resultado#" >
                </cfif>
		  <cfreturn "#resultado#">			
	</cffunction>

	<cffunction name="ActualizaTrans" acess="private" returntype="string">
		  <cfargument name="CAJA" 		type="string" required="Yes">
		  <cfargument name="NumTrans" 	type="string" required="Yes">
		  <cfargument name="TotalD" 	type="string" required="Yes">
		  <cfargument name="DescD" 		type="string" required="Yes">
		  <cfargument name="ImpD" 		type="string" required="Yes">
  		  <cfargument name="Documento" 	type="string" required="Yes">
		  <cfargument name="TotalC" 	type="string" required="Yes">
		  <cfargument name="TotalOTC" 	type="string" required="Yes">
		  <cfargument name="TotalEF" 	type="string" required="Yes">
		  <cfargument name="TotalEFC" 	type="string" required="Yes">
		  <cfargument name="TotalTCC" 	type="string" required="Yes">
		  <cfargument name="TotalCkC" 	type="string" required="Yes">
  		  <cfargument name="Usuario" 	type="string" required="Yes">
		  <cfset resultado = "OK">
		  <cftry>
		 
		    <cfquery name="LinFAX11LIN" datasource="CAJAS">
				select MaxLin = isnull(max(FAX11LIN), 0)+1
				from FAX011
				where FAM01COD = '#ARGUMENTS.CAJA#'
				and FAX01NTR = #ARGUMENTS.NumTrans#
			</cfquery>
		    <cfquery name="ObtMaq" datasource="CAJAS">
				select Maquina = FAM09MAQ
				from FAM001
				where FAM01COD = '#ARGUMENTS.CAJA#'
			</cfquery>
			
			<cfset Serie = MID(Documento, 1, Find('-',Documento)-1)>
			<cfset NumeroDocumento = MID(Documento, Find('-',Documento)+1, len(Documento))>
			
			<cfquery datasource="CAJAS">
			    update FAX001
				   set FAX01TOT = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalD#">
				   	 , FAX01PDT = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.DescD#">
					 , FAX01MDL = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.DescD#">
					 , FAX01MIT = <cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.ImpD#">
				 where FAM01COD = '#ARGUMENTS.CAJA#'
				   and FAX01NTR = #ARGUMENTS.NumTrans#
			</cfquery>
			
			<cfquery datasource="CAJAS">			
			  	insert into FAX011 (FAM01COD, FAX01NTR, FAX11LIN, FAM09MAQ, FAX11REC, FAX11STS, FAX09SER,
							FAX11TIM, TTRCOD, FACDOC)
					 values (<cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.CAJA#">,	
					 		 <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.NumTrans#">,
	 				 		 <cfqueryparam cfsqltype="cf_sql_integer" value="#LinFAX11LIN.MaxLin#">,
	 				 		 <cfqueryparam cfsqltype="cf_sql_integer" value="#ObtMaq.Maquina#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#NumeroDocumento#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="I">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#Serie#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="M">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="FC">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Documento#">)
			</cfquery>
			
			<cfquery datasource="CAJAS">
				  insert FAX010 (FAM01COD, FAX01NTR, FAX10CHK, FAX10TCR, FAX10OTR, FAX01EFE, FAX10EF1, FAX10EF2,
								FAX10EF3, FAX10EFTOT, FAX10CAM, FAX10TOT, FAX10TPG)
				  	values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.CAJA#">,	
					 		<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.NumTrans#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalCkC#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalTCC#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalOTC#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalEF#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalEFC#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="0.00">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.TotalC#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="0">)
			</cfquery>
			<cfquery datasource="CAJAS">

	 		   update FAX004EX 
				 set FAX04EUSER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.Usuario#">
					 , FAX04EFEC = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 , FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.CAJA#">
					 , FAX01NTR = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.NumTrans#">
					 , FAX11REC = <cfqueryparam cfsqltype="cf_sql_integer" value="#NumeroDocumento#">
					 , FAX09SER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Serie#">
					, FAX04ESTADO = <cfqueryparam cfsqltype="cf_sql_char" value="I">
				 from FAX004 A
				 where A.FAM01COD = '#ARGUMENTS.CAJA#'
					and A.FAX01NTR = #ARGUMENTS.NumTrans#
				    and A.FAX04DEL != 1
				    and A.FAX04CDE = FAX01ESIS
				    and A.FAX04NTE = FAX01ENUMDOC
				    and A.FAX04LIE = FAX04ELIN
				    and FAX04ESTADO = 'P'
			</cfquery>
			
			<cfquery datasource="CAJAS">
				update FAX001
				   set FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				 where FAM01COD = '#ARGUMENTS.CAJA#'
				   and FAX01NTR = #ARGUMENTS.NumTrans#

                exec fa_Calcula_Egresos_Contado @FAM01COD = '#ARGUMENTS.CAJA#' , @FAX01NTR = #ARGUMENTS.NumTrans#

	    		exec fa_MueveComToCxC @FAM01COD = '#ARGUMENTS.CAJA#', @FAX01NTR = #ARGUMENTS.NumTrans#

			</cfquery>
		    <cfcatch type = "Any">
				<cfset resultado = "#cfcatch.message#, UPDATE MULTIPLE Detalle: #cfcatch.detail# " >
		    </cfcatch>
		  </cftry>
		  <cfreturn "#resultado#">			
	</cffunction>
    <!---►►►Obtienen el Nuevo Consecutivo de la Caja◄◄◄--->
    <cffunction name="ObtenerConsecutivoCaja" acess="private" returntype="string" hint="Obtienen el Nuevo Consecutivo de la Caja">
		  <cfargument name="FAM01COD" type="string" required="Yes" hint="Codigo de la Caja">
          <cfargument name="FAM33COD" type="string" required="Yes">
             
			<cfquery datasource="CAJAS" name="NewConsecutivo">
                select a.FAX09NXT + 1 next, a.FAX09SER serie, a.CG49CO CG49CO, a.FAM12COD FAM12COD, rtrim(ltrim(a.FAX09SER))+'-' +rtrim(ltrim(convert(varchar, a.FAX09NXT ))) documento
                    from FAX009 a
                        inner join FAM014 b
                            on b.FAM12COD = a.FAM12COD
                        inner join FAM001 c
                             on b.FAM09MAQ = c.FAM09MAQ 
                            and b.FAM14TDC = c.FAM01TFC
                        inner join FAM033 d
                            on d.CG49CO = a.CG49CO
                where c.FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FAM01COD#">
                  and d.FAM33COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FAM33COD#">
            </cfquery>
			<cfif NOT NewConsecutivo.recordCount>
              	<cfthrow message="No existe consecutivo para la caja #Arguments.FAM01COD# y empresa #Arguments.FAM33COD# para la impresora y compañia">
            <cfelse>
                <cfquery datasource="CAJAS">
                    update FAX009 
                      set FAX09NXT = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NewConsecutivo.next#">
                    where FAM12COD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NewConsecutivo.FAM12COD#">
                      and CG49CO   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NewConsecutivo.CG49CO#"> 
                </cfquery>
            </cfif>
      <cfreturn NewConsecutivo.documento>
	</cffunction>
    <!---►►►Obtiene el Factor de Conversion entre la moneda local y la moneda de la transacción◄◄◄ --->
    <cffunction name="ObtenerFactorConversion" acess="private" returntype="numeric" hint="Obtiene el Factor de Conversion entre la moneda local y la moneda de la transacción">
          <cfargument name="MonedaTransaccion" type="string" required="Yes" hint="Moneda de la Transaccion(Origen)">
             
            <cfquery  name="Parametro" datasource="CAJAS">
            	select CGMLOC monedaLocal from CGX001
            </cfquery>
            <cfif NOT Parametro.Recordcount>
            	<cfthrow message="No esta Definido el parametro Moneda Local (CGX001.CGMLOC)">
            </cfif>
            <cfif Parametro.monedaLocal EQ Arguments.MonedaTransaccion>
            	<cfreturn 1>
            <cfelse>
            	 <cfquery  name="FactorConversion" datasource="CAJAS">
                	exec FA_Trae_Factor_Conversion
                       @moneda1 = <cfqueryparam cfsqltype="cf_sql_char" value="#Parametro.monedaLocal#">, 
                       @moneda2 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MonedaTransaccion#">
            	</cfquery>
				<cfif FactorConversion.recordCount and FactorConversion.Factor NEQ 0>
					<cfreturn FactorConversion.Factor>
                <cfelse>
                    <cfreturn 1>
                </cfif>
           </cfif>	
	</cffunction>
 	<!---►►►Funcion para Revisar la tabla de facturación electrónica (fe_estadofacturacion) para saber si hay que generar documento electrónico o no◄◄◄--->
    <cffunction name="VerificaFacturacionElectronica" acess="private" returntype="boolean" hint="Funcion para Revisar la tabla de facturación electrónica (fe_estadofacturacion) para saber si hay que generar documento electrónico o no">
    	<cfargument name="cod_flujo" type="string" required="no" default="CJF" hint="Código de flujo">
        <cfquery  name="FactorConversion" datasource="CAJAS">	
			 exec fe_Indicador_Impresion
               @cod_flujo = '#Arguments.cod_flujo#'
		</cfquery>
		<cfif listfind( '2,3,4',FactorConversion.cod_estado) GT 0>
			<cfreturn true>
        <cfelse>
        	<cfreturn false>
        </cfif>
    </cffunction>
   <!---►►►Registra en la tabla de facturación electrónica (fe_cola_facturas_electronicas) para que el documento sea enviado a signature◄◄◄--->
    <cffunction name="RegistraFacElectronica" acess="private" hint="Registra en la tabla de facturación electrónica (fe_cola_facturas_electronicas) para que el documento sea enviado a signature">		
    	<cfargument name="FAM01COD" 	 type="string"  required="yes"  			  hint="Codigo de la Caja">
        <cfargument name="FAX01NTR" 	 type="numeric" required="yes"  			  hint="FAX01NTR">
		<cfargument name="num_factura" 	 type="string"  required="yes"                hint="Numeros de Factura">
        <cfargument name="cod_sistema"	 type="string"  required="no" default="CJF"   hint="Código de flujo">
        <cfargument name="num_prioridad" type="numeric" required="no" default="2"     hint="Prioridad">
        <cfargument name="cod_estado" 	 type="string"  required="no" default="PEN"   hint="Codigo del Estado">		
		        
        <cfquery  datasource="CAJAS">
            exec fe_Llenar_Bitacora
			   @num_factura    =  <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.num_factura#">,
               @cod_sistema    =  <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.cod_sistema#">,
               @fec_emision    =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
               @cod_estado     =  <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.cod_estado#">,
               @num_prioridad  =  <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.num_prioridad#">,
               @FAM01COD       =  <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.FAM01COD#">,
               @FAX01NTR       =  <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.FAX01NTR#">
        </cfquery>
    </cffunction>	
</cfcomponent>
