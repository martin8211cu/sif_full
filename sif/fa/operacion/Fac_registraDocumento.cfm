<!--- Modificacion: Se agregan los campos TESRPTCid, TESRPTCietu
	Justificacion: Se modifica componente para tomar en cuenta el Concepto de cobro por cambio de IETU
	Fecha: 07/07/2009
	Realizo: ABG --->

<!------
	Proceso de Aplicacion de cotizaciones
	Creado 4 septiembre 2008
	por ABG
------->
<cfset varControlFlujo = true>
<cfset varControlFiltro = true>
<cfset varPosteo = true>
<cfset busca = ' '>

<!--- Fin del Codigo de prueba para la factura electronica --->

    <cfquery name="rsupdfac1" datasource="#session.DSN#">
    	select IDpreFactura,enviamail,ltrim(rtrim(foliofacele)) as foliofacele,
        ltrim(rtrim(seriefacele)) as seriefacele,PFTcodigo,CCTcodigo,a.SNcodigo
        FROM FAEOrdenImpresion a
        inner join FAPreFacturaE f on a.OIdocumento = f.DdocumentoREF and a.Ecodigo = f.Ecodigo
		WHERE a.OImpresionID =  #OImpresionID#
     </cfquery>
      		<cfif #rsupdfac1.enviamail# neq 1>
                	<cfabort showerror="No se ha generado el Archivo XML y/o enviado el mail">
            </cfif>


		<cfif  #rsupdfac1.foliofacele# gt 0>
				<!--- Consulta tipo de transaccion --->
				<cfquery name="rsGetTpoTransaccion" datasource="#session.DSN#">
					SELECT COALESCE(tr.esContado, 0) AS esContado,
					       sn.SNidentificacion,
					       pf.PFDocumento,
					       tr.CCTcodigoRef,
					       pf.Impuesto,
					       pf.Total,
					       pf.Descuento,
					       pf.Mcodigo,
					       pf.TipoCambio,
					       pf.Ocodigo,
					       CFid = (select top 1 CFid from CFuncional where Ocodigo = pf.Ocodigo and Ecodigo = #session.Ecodigo#),
					       pf.Fecha_doc,
					       CASE
					           WHEN
					                  (SELECT COUNT(1)
					                   FROM SNCCTcuentas
					                   WHERE SNcodigo = pf.SNcodigo
					                     AND CCTcodigo = tr.CCTcodigoRef) > 0 THEN
					                  (SELECT TOP 1 CFcuenta
					                   FROM SNCCTcuentas
					                   WHERE SNcodigo = pf.SNcodigo
					                     AND CCTcodigo = tr.CCTcodigoRef)
					           ELSE sn.SNcuentacxc
					       END AS CFcuentaCxC
					FROM FAPreFacturaE pf
					INNER JOIN FAPFTransacciones tr ON pf.Ecodigo = tr.Ecodigo
					AND pf.PFTcodigo = tr.PFTcodigo
					INNER JOIN SNegocios sn ON sn.Ecodigo = pf.Ecodigo
					AND sn.SNcodigo = pf.SNcodigo
					WHERE pf.oidocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
					  AND pf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>

				<cfif isdefined("rsGetTpoTransaccion.esContado") AND rsGetTpoTransaccion.esContado EQ 1>
					<!--- SE TRATA DE UNA TRANSACCION DE CONTADO, SOLO GENERA POLIZA --->
					<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
					<cfset INTARC 		= LobjCONTA.CreaIntarc("#session.dsn#")>

					<cfset LvarAnoAux 				= fnGetParametro (#session.Ecodigo#, 50,  "Periodo de Auxiliares")>
					<cfset LvarMesAux 				= fnGetParametro (#session.Ecodigo#, 60,  "Mes de Auxiliares")>

					<!--- Socio --->
					
					<cfquery name="rsSQL" datasource="#session.dsn#">
						INSERT INTO #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,
						 					  Mcodigo, INTMOE, INTCAM, INTMON,NumeroEvento,CFid)
						VALUES ('CCFC',
						        1,
						        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetTpoTransaccion.PFDocumento#">,
						        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetTpoTransaccion.CCTcodigoRef#">,
						        'D',
						        <cfqueryparam cfsqltype="cf_sql_varchar" value="Transaccion Contado #rsGetTpoTransaccion.SNidentificacion#">,
						        '#dateFormat(now(),"YYYYMMDD")#',
						        #LvarAnoAux#,
								#LvarMesAux#,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetTpoTransaccion.CFcuentaCxC#">, <!--- ccuenta --->
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetTpoTransaccion.Ocodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetTpoTransaccion.Mcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#rsGetTpoTransaccion.Total#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#rsGetTpoTransaccion.TipoCambio#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#rsGetTpoTransaccion.Total * rsGetTpoTransaccion.TipoCambio#">,
								'', <!--- Numero Evento --->
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetTpoTransaccion.CFid#">)
					</cfquery>

					<!--- Concepto/Servicios --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						INSERT INTO #INTARC#
							(
								INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo
								, Mcodigo, INTMOE, INTCAM, INTMON
			    				,NumeroEvento,CFid
							<!--- Contabilidad Electronica Inicia --->
								, CEtipoLinea, CEdocumentoOri, CEtranOri, CESNB
							<!--- Contabilidad Electronica Fin --->
							)
						SELECT
						  'CCFC',
						  1,
						  a.PFDocumento,
						  a.CCTcodigoREF,
						  'C',
						  CASE
						    WHEN b.TipoLinea = 'A' THEN CASE
						        WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN CONCAT('Cuenta transitoria: Articulo: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            art.Adescripcion
						          FROM Articulos art
						          WHERE art.Aid = b.Aid)
						          ))))
						        ELSE CONCAT('Articulo: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            art.Adescripcion
						          FROM Articulos art
						          WHERE art.Aid = b.Aid)
						          ))))
						      END
						    WHEN b.TipoLinea = 'T' THEN CASE
						        WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN CONCAT('Cuenta transitoria: Transito: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            art.Adescripcion
						          FROM Articulos art
						          WHERE art.Aid = b.Aid)
						          ))))
						        ELSE CONCAT('Transito: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            art.Adescripcion
						          FROM Articulos art
						          WHERE art.Aid = b.Aid)
						          ))))
						      END
						    WHEN b.TipoLinea = 'S' THEN CASE
						        WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN CONCAT('Cuenta transitoria: Concepto: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            con.Cdescripcion
						          FROM Conceptos con
						          WHERE con.Cid = b.Cid)
						          ))))
						        ELSE CONCAT('Concepto: ', RTRIM(LTRIM(COALESCE(b.Descripcion, (SELECT
						            con.Cdescripcion
						          FROM Conceptos con
						          WHERE con.Cid = b.Cid)
						          ))))
						      END
						    WHEN b.TipoLinea = 'F' THEN CASE
						        WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN CONCAT('Cuenta transitoria: Activo: ', RTRIM(LTRIM(COALESCE(b.Descripcion, b.Descripcion_Alt))))
						        ELSE CONCAT('Activo: ', RTRIM(LTRIM(COALESCE(b.Descripcion, b.Descripcion_Alt))))
						      END
						    ELSE CASE
						        WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN CONCAT('Cuenta transitoria: ', RTRIM(LTRIM(COALESCE(b.Descripcion, b.Descripcion_Alt))))
						        ELSE RTRIM(LTRIM(COALESCE(b.Descripcion, b.Descripcion_Alt)))
						      END
						  END,
						  '#dateFormat(now(),"YYYYMMDD")#',
						  #LvarAnoAux#,
						  #LvarMesAux#,
						  CASE
						    WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN COALESCE((SELECT
						        Ccuenta
						      FROM CFinanciera
						      WHERE CFcuenta = cf.CFcuentatransitoria), 0)
						    ELSE b.Ccuenta
						  END,
						  CASE
						    WHEN COALESCE(cf.CFACTransitoria, 0) = 1 THEN COALESCE(cf.CFcuentatransitoria, 0)
						    ELSE COALESCE((SELECT
											CFcuenta
										  FROM CFinanciera
										  WHERE Ccuenta = b.Ccuenta), 0)
						  END,
						  COALESCE(cf.Ocodigo, a.Ocodigo),
						  a.Mcodigo,
						  (a.Total - a.Impuesto - a.Descuento),
						  a.TipoCambio,
						  ROUND((a.Total - a.Impuesto - a.Descuento) * a.TipoCambio, 2),
						  '',
						  b.CFid,
						  0,
						  a.PFDocumento,
						  a.CCTcodigoREF,
						  a.SNcodigo
						FROM FAPreFacturaE a
						INNER JOIN FAPreFacturaD b
						LEFT JOIN CFuncional cf
						  ON cf.Ecodigo = b.Ecodigo
						  AND cf.CFid = b.CFid
						  ON b.IDpreFactura = a.IDpreFactura
						  AND b.TipoLinea IN ('A', 'S', 'O')
						  AND b.TotalLinea != 0
						INNER JOIN CCTransacciones c
						  ON c.Ecodigo = a.Ecodigo
						  AND c.CCTcodigo = a.CCTcodigoREF
						WHERE a.oidocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
						AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<!--- DETALLE IMPUESTOS --->
					<cfquery name="rsSQL" datasource="#session.dsn#">
						insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, CFcuenta, Ocodigo,
												Mcodigo, INTMOE, INTCAM, INTMON
			    								,NumeroEvento,CFid)
						SELECT 'CCFC',
						       1,
						       pf.PFDocumento,
						       pf.CCTcodigoREF,
						       'C',
						       i.Idescripcion,
						       '#dateFormat(now(),"YYYYMMDD")#',
						       #LvarAnoAux#,
							   #LvarMesAux#,
							   i.CcuentaCxCAcred,
							   i.CFcuentaCxCAcred,
							   pf.Ocodigo,
							   pf.Mcodigo,
							   SUM(pf.Impuesto),
							   pf.TipoCambio,
							   SUM(ROUND(pf.Impuesto * pf.TipoCambio, 2)),
							   '',
							   pfd.CFid
						FROM FAPreFacturaE pf
						INNER JOIN FAPreFacturaD pfd ON pf.IDpreFactura = pfd.IDpreFactura
						AND pf.Ecodigo = pfd.Ecodigo
						INNER JOIN Impuestos i ON i.Icodigo = pfd.Icodigo
						AND i.Ecodigo = pfd.Ecodigo
						WHERE pf.oidocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
						  AND pf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						GROUP BY pf.PFDocumento,
						         pf.CCTcodigoREF,
						         i.Idescripcion,
						         i.CcuentaCxCAcred,
						         i.CFcuentaCxCAcred,
						         pf.Ocodigo,
						         pf.Mcodigo,
						         pf.TipoCambio,
						         pfd.CFid
					</cfquery>
					
					<!--- Marca la Orden de Impresion como Terminada --->
			        <cfquery datasource="#session.DSN#">
	    		    	update FAEOrdenImpresion
	        		    set OIEstado = 'T'
	            		where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
	            		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        	</cfquery>

					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
						<cfinvokeargument name="Ecodigo"		value="#session.Ecodigo#"/>
						<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
						<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
						<cfinvokeargument name="Efecha"			value="#rsGetTpoTransaccion.Fecha_doc#"/>
						<cfinvokeargument name="Oorigen"		value="CCFC"/>
						<cfinvokeargument name="Edocbase"		value="#rsGetTpoTransaccion.PFDocumento#"/>
						<cfinvokeargument name="Ereferencia"	value="#rsGetTpoTransaccion.CCTcodigoREF#"/>
						<cfinvokeargument name="Edescripcion"	value="Documento Factura de contado: #rsGetTpoTransaccion.PFDocumento#"/>
						<cfinvokeargument name="Ocodigo"		value="#rsGetTpoTransaccion.Ocodigo#"/>
					</cfinvoke>

					<!---  --->
					<script language="javascript">
					document.location = 'ProcImprimeDocumentoMFE.cfm';
				</script>
				<cfelse>
					<!--- GENERA DOCUMENTOS COMPLETOS --->
					<cfif #rsupdfac1.pftcodigo# eq 'PF' or rsupdfac1.CCTcodigo EQ 'FC'>
	                	<cfset busca= 'FE'>
	                </cfif>
	                <cfif #rsupdfac1.pftcodigo# eq 'PN' or rsupdfac1.CCTcodigo EQ 'NC'>
	                	<cfset busca= 'NE'>
	                </cfif>

	            	<!--- Busca si el Documento No existe en los documentos Aplicados --->
	                <cfquery name="rsVerifica" datasource="#session.DSN#">
	                	select 1 from HDocumentos
	                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#busca#-#rsupdfac1.foliofacele#">
	                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
	                </cfquery>
	                <cfquery name="rsVerifica2" datasource="#session.DSN#">
	                	select 1 from EDocumentosCxC
	                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer"value="#session.Ecodigo#">
	                    and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar"value="FE-#rsupdfac1.foliofacele#">
	                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
	                </cfquery>

	              	<cfif rsVerifica.recordcount GT 0 OR rsVerifica2.recordcount GT 0>

	              	    <cfquery  datasource="#session.DSN#">
							update faprefacturae
						   	   set foliofacele = 0,seriefacele='',factura = 0
						     wHERE idprefactura = <cfqueryparam cfsqltype="cf_sql_varchar"value="#rsupdfac1.idprefactura#">
	     				 </cfquery>

						<cfabort showerror="Documento #rsupdfac1.seriefacele##rsupdfac1.foliofacele# ya existe en los Documentos de CxC">

					</cfif>

	                <!--- Inserta del Documento en el auxiliar de CxC --->
					<cftransaction>
	                <cfquery name="rsOIinsert" datasource="#session.DSN#">
					select *, isnull(OIMRetencion,0) as SumRet 
					    from FAEOrdenImpresion a
					    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
					    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
	                <!--- Para Obtener la cuenta del Encabezado --->
	                <!--- si la id Direccion es nula toma la cuenta del socio --->
					<cfif rsOIinsert.id_direccionFact EQ "">
	                	<cfset varCuenta = rsOIinsert.Ccuenta>
	                <cfelse>
	                	<!--- Busca la cuenta de la direccion indicada --->
	                    <!--- Si la direccion no tiene cuenta Contable usa la cuenta del socio --->
	                    <cfquery name="rsCuentaD" datasource="#session.DSN#">
							select SNDCFcuentaCliente
	                        from SNDirecciones sd
	                        	inner join SNegocios sn
	                            on sd.Ecodigo = sn.Ecodigo
	                            and sd.SNid = sn.SNid
	                        where sn.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">
	                        and sd.id_direccion = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionFact#">
	                    </cfquery>
	                 	<cfif rsCuentaD.SNDCFcuentaCliente EQ "">
	                    		<cfset varCuenta = rsOIinsert.Ccuenta>
	                    	<cfelse>
	                    		<cfset varCuenta = rsCuentaD.SNDCFcuentaCliente>
	                  	</cfif>
					</cfif>

					<!--- Se verifica si hay cuenta por excepcion para la transaccion --->
					<cfquery name="rsCtaExcep" datasource="#session.DSN#">
						select ce.SNcodigo, ce.CCTcodigo, cf.Ccuenta
						from SNCCTcuentas ce
						inner join CFinanciera cf
							on ce.CFcuenta = cf.CFcuenta
						where ce.Ecodigo = #session.Ecodigo#
							and ce.SNcodigo = #rsOIinsert.SNcodigo#
							and ce.CCTcodigo = '#rsOIinsert.CCTcodigo#'
					</cfquery>

					<cfif rsCtaExcep.recordCount gt 0 and rsCtaExcep.Ccuenta neq "">
						<cfset varCuenta = rsCtaExcep.Ccuenta>
					</cfif>

					<!--- Encabezado --->

	                <cfquery name="insertDoc"datasource="#session.DSN#">
	                	insert into EDocumentosCxC
	                        (Ocodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo,
	                    	EDtipocambio, Ccuenta, EDdescuento, EDporcdesc, EDimpuesto,
	                        EDtotal, EDfecha, EDusuario, EDselect, Interfaz,
	                        id_direccionFact, id_direccionEnvio, DEdiasVencimiento, EDvencimiento,
	                    	DEobservacion, DEdiasMoratorio, Ecodigo, BMUsucodigo, TESRPTCid, TESRPTCietu,TimbreFiscal,EDieps,EDMRetencion)
						values
	                		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Ocodigo#">,
	                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
	                         <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">,--->
	                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#busca#-#rsupdfac1.foliofacele#">,
	                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
	            	         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Mcodigo#">,
		                     <cfqueryparam cfsqltype="cf_sql_float" value="#rsOIinsert.OItipoCambio#">,
	                         <cfqueryparam cfsqltype="cf_sql_integer" value="#varCuenta#">,
	                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OIdescuento#">,
	                         	0,
	                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OIimpuesto#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OItotal#">-<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOIinsert.SumRet#">,
	                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.OIfecha#">,
	    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
	                         0,
	                         0,
	                         <cfif rsOIinsert.id_direccionFact EQ "">
								 null,
	                         <cfelse>
	                             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionFact#">,
	                         </cfif>
	                         <cfif rsOIinsert.id_direccionEnvio EQ "">
	                         	null,
	                         <cfelse>
	        	             	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionEnvio#">,
	                         </cfif>
	                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.OIdiasvencimiento#">,
	                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.OIvencimiento#">,
	                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIobservacion#">,
	                         0,
	                         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
	        	             <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
	                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCid#">,
	                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCietu#">,
	                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.TimbreFiscal#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OIieps#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.SumRet#">
	                     	)
	            			<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insertDoc"  >

	                <cfquery name="validaCE" datasource="#session.DSN#">
	                    select ERepositorio from Empresa where Ereferencia=#session.Ecodigo#
	                </cfquery>
	                <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1>
	                <!--- Si existe configurado un Repositorio de CFDIs --->
	                   <cfif rsOIinsert.CCTcodigo EQ "NC">
	                   		<cfset tipoComprobante=2>
	                   <cfelse>
	                        <cfset tipoComprobante=1>
	                   </cfif>
	                   <cfquery name="XML_Timbrado" datasource="#session.dsn#">
	                   		select timbre, xmlTimbrado from FA_CFDI_Emitido
	                        where timbre=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.TimbreFiscal#">
	                        and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                   </cfquery>
						<cfquery name="insRepTmp" datasource="#session.dsn#">
	                       insert into CERepoTMP (Ecodigo,TimbreFiscal,ID_Documento,Documento,Origen,TipoComprobante,BMUsucodigo,xmlTimbrado)
	                       values(
	                       <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
	                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.TimbreFiscal#">,
	                       <cfqueryparam cfsqltype="cf_sql_integer" value="#insertDoc.identity#">,
	                       <cfqueryparam cfsqltype="cf_sql_char" value="#busca#-#rsupdfac1.foliofacele#">,
	                       'CCFC',
	                       #tipoComprobante#,
	                       <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">,
	                       <cfqueryparam cfsqltype="cf_sql_varchar" value="#XML_Timbrado.xmlTimbrado#">
	                       )
	                   </cfquery>
	              </cfif>
	                <cfquery name="rsOIDinsert" datasource="#session.DSN#">
						select *
					    from FADOrdenImpresion a
					    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
					    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<!--- Detalles --->
	                <cfloop query="rsOIDinsert">
		                <cfquery datasource="#session.DSN#">
	    	            	insert DDocumentosCxC
	        	            	(EDid, Aid, Cid, Alm_Aid,
	            	             Ccuenta, Ecodigo, DDdescripcion, DDdescalterna,
	                	         DDcantidad, DDpreciou, DDdesclinea,
	                    	     DDporcdesclin, DDtotallinea, DDtipo, Icodigo, CFid,
	                        	 BMUsucodigo,Dcodigo,codIEPS,DDMontoIEPS,afectaIVA, Rcodigo)
		                    values
	    	                	(<cfqueryparam cfsqltype="cf_sql_integer" value="#insertDoc.identity#">,
	        	                 <cfif rsOIDinsert.ItemTipo EQ "A">
		        	            	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.ItemCodigo#">,
	                	       	 <cfelse>
	                    	       	null,
	                        	 </cfif>
		                         <cfif rsOIDinsert.ItemTipo EQ "S">
			                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.ItemCodigo#">,
	        	                 <cfelse>
	            	             	null,
	                	         </cfif>
	                    	     <cfif rsOIDinsert.ItemTipo EQ "A">
		                    	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.OIDAlmacen#">,
		                         <cfelse>
	    	                     	null,
	        	                 </cfif>
	            	             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.Ccuenta#">,
	                	         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
	                    	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.OIDdescripcion#">,
	                        	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.OIDdescnalterna#">,
		                         <cfqueryparam cfsqltype="cf_sql_float" value="#rsOIDinsert.OIDCantidad#">,
	   	    	                 <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDPrecioUni#">,
	    	                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDdescuento#">,
	            	             0,
	                             <cfif rsOIDinsert.OIMontoIEPSLinea GT 0 and rsOIDinsert.afectaIVA EQ 0>
	                	         	<cfset subT= rsOIDinsert.OIDtotal - rsOIDinsert.OIMontoIEPSLinea>
	                                <cfqueryparam cfsqltype="cf_sql_money" value="#subT#">,
	                             <cfelse>
	                             	<cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDtotal#">,
	                             </cfif>
	                    	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.ItemTipo#">,
	                        	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.Icodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.CFid#">,
	    	                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
	        	                 0,
	                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.codIEPS#">,
	                             <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIMontoIEPSLinea#">,
	                             <cfqueryparam cfsqltype="cf_sql_bit" value="#rsOIDinsert.afectaIVA#">,
															 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.Rcodigo#">
	            	            )
	                	</cfquery>
	                </cfloop>
	                </cftransaction>
	                <!--- Postea Documento CxC
	          <cfif varPosteo>--->

			<!---	  </cfif> --->
	                <!--- Inserta un registro en la Bitacora para la PF--->
	                <cfquery datasource="#session.DSN#">
		                insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF,
	                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
	    	            select <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
	                    		IDpreFactura,
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsupdfac1.seriefacele##rsupdfac1.foliofacele#">,
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
	                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
	                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	                            'A',
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	                    from FAPreFacturaE
	                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIdocumento#">
				        and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">
					</cfquery>
	                <!--- Inserta un registro en la Bitacora para la OI--->
	                <cfquery datasource="#session.DSN#">
		                insert FABitacoraMovPF (Ecodigo, OImpresionID, DdocumentoREF, CCTcodigoREF, SNcodigoREF,
	                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
	    	            values (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
	                    		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OImpresionID#">,
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsupdfac1.seriefacele##rsupdfac1.foliofacele#">,
	                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
	                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
	                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	                            'A',
	                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
					</cfquery>
	                <!--- Marca las PreFacturas con el Documento Generado --->
	                <cfquery datasource="#session.DSN#">
		                update FAPreFacturaE
	    	                set DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsupdfac1.seriefacele##rsupdfac1.foliofacele#">,
	        	            CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
	            	        TipoDocumentoREF = 2
	                    from FAPreFacturaE
	                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIdocumento#">
				        and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">
					</cfquery>

					<!--- Marca la Orden de Impresion como Terminada --->
			        <cfquery datasource="#session.DSN#">
	    		    	update FAEOrdenImpresion
	        		    set OIEstado = 'T'
	            		where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
	            		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		        	</cfquery>

	    	         	 <cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
							method="PosteoDocumento"
							EDid	= "#insertDoc.identity#"
							Ecodigo = "#Session.Ecodigo#"
							usuario = "#Session.usuario#"
							debug = "N"
						/>
	                <cfset From.SNcodigo = "">
	                <cfset Form.OIdocumento = "">
	                <cfset form.PFDocumento = "">
	                <cfset varControlFiltro = false>
					<cfset varControlFlujo = false>

					<!--- Eduardo Gonzalez (APH)
						  Aplicacion de NC y aplicacion de Docs a Favor.
						  03/12/2018
						   --->
					<!--- INICIO: APLICACION DE NOTA DE CREDITO Y CREACION DE LA APLICACION DE DOCUMENTOS A FAVOR --->
					<cfif isdefined("insertDoc.identity") AND LEN(insertDoc.identity)>
						<cftransaction>
							<cftry>
								<cfquery name="rsGetDocumento" datasource="#session.DSN#">
				                	SELECT TOP 1 Ecodigo,
									           CCTcodigo,
									           Ddocumento,
									           SNcodigo,
									           Mcodigo,
									           Ccuenta,
									           CFid,
									           Dtipocambio,
									           Dtotal,
									           Dfecha,
									           Dusuario,
									           BMUsucodigo,
									           EDieps
									FROM HDocumentos
									WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  AND Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#busca#-#rsupdfac1.foliofacele#">
									  AND CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
									  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsupdfac1.SNcodigo#">
				                </cfquery>

								<cfif rsGetDocumento.RecordCount GT 0>
									<cfset lvarFecha = CreateDateTime(YEAR(rsGetDocumento.Dfecha),
											                          MONTH(rsGetDocumento.Dfecha),
											                          DAY(rsGetDocumento.Dfecha),
											                          HOUR(now()),
											                          MINUTE(now()),
											                          SECOND(now()))>
									<!--- ENCABEZADO --->
									<!--- Se inserta nuevamente el encabezado de la aplicaci�n de documentos EFavor --->
									<cfquery name="insertEFavor" datasource="#session.dsn#">
										INSERT INTO EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, Ccuenta, CFid, EFtipocambio, EFtotal,
										                    EFfecha, EFselect, EFusuario, BMUsucodigo, EFieps, CodTipoPago)
										VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.Ecodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDocumento.CCTcodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDocumento.Ddocumento#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.SNcodigo#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.Mcodigo#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.Ccuenta#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.CFid#"  null="#NOT LEN(TRIM(rsGetDocumento.CFid))#">,
												<cfqueryparam cfsqltype="cf_sql_float" value="#rsGetDocumento.Dtipocambio#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#rsGetDocumento.Dtotal#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#lvarFecha#">,
												0,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDocumento.Dusuario#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDocumento.BMUsucodigo#" null="#NOT LEN(TRIM(rsGetDocumento.BMUsucodigo))#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#rsGetDocumento.EDieps#"  null="#NOT LEN(TRIM(rsGetDocumento.EDieps))#">,
												0)
									</cfquery>

									<!--- DETALLE --->

									<cfif isDefined("form.Ddocumento") AND #LEN(form.Ddocumento)# AND rsGetDocumento.RecordCount GT 0>
										<cfset arrayDocs = listToArray (form.Ddocumento, ",",true,true)>
										<cfset lvarNumDocs = ArrayLen(arrayDocs)>
										<cfset lvarTotalNC = #rsGetDocumento.Dtotal#>
										<cfset lvarTotalDocs = 0>

										<cfquery name="rsGetTotal" datasource="#session.dsn#">
											SELECT SUM(Dtotal) AS totalDocs
											FROM Documentos
											WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											  AND Ddocumento IN (<cfloop index="i" from="1" to="#arrayLen(arrayDocs)#">
																	<cfif i NEQ arrayLen(arrayDocs)>
																		'#arrayDocs[i]#',
																	<cfelse>
																		'#arrayDocs[i]#'
																	</cfif>
																 </cfloop>)
											  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsupdfac1.SNcodigo#">
										</cfquery>

										<cfif rsGetTotal.RecordCount GT 0>
											<cfset lvarTotalDocs = rsGetTotal.totalDocs>
										</cfif>
										<cfloop index="i" from="1" to="#arrayLen(arrayDocs)#">
											<cfquery name="rsGetDetalle" datasource="#session.dsn#">
												SELECT Ecodigo,
												       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDocumento.CCTcodigo#"> AS CCTcodigo,
												       <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDocumento.Ddocumento#"> AS Ddocumento,
												       CCTcodigo AS CCTcodigoR,
												       Ddocumento AS DdocumentoR,
												       SNcodigo,
												       Ccuenta,
												       Dtotal,
												       Mcodigo,
												       Dtipocambio
												FROM Documentos
												WHERE Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arrayDocs[i]#">
												  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											</cfquery>

											<cfif rsGetDetalle.RecordCount GT 0>
												<cfset lVarMontoDet = (lvarTotalNC * rsGetDetalle.Dtotal) / lvarTotalDocs>
												<cfquery name="insertDetalle" datasource="#session.dsn#">
													INSERT INTO DFavor (Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, SNcodigo,
													                    Ccuenta, Mcodigo, DFmonto, DFtotal, DFmontodoc, DFtipocambio)
													VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDetalle.Ecodigo#">,
													        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDetalle.CCTcodigo#">,
													        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDetalle.Ddocumento#">,
													        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDetalle.CCTcodigoR#">,
													        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetDetalle.DdocumentoR#">,
													        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDetalle.SNcodigo#">,
													        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDetalle.Ccuenta#">,
													        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetDetalle.Mcodigo#">,
													        <cfqueryparam cfsqltype="cf_sql_float" value="#lVarMontoDet#">,
													        <cfqueryparam cfsqltype="cf_sql_float" value="#lVarMontoDet#">,
													        <cfqueryparam cfsqltype="cf_sql_float" value="#lVarMontoDet / rsGetDetalle.Dtipocambio#">,
													        <cfqueryparam cfsqltype="cf_sql_float" value="#(lVarMontoDet / rsGetDetalle.Dtipocambio) / lVarMontoDet#">)
												</cfquery>
											</cfif>
										</cfloop>
									</cfif>
								</cfif>

								<cftransaction action="commit" />
								<cfcatch type="database">
									<cftransaction action="rollback" />
									<cfset lVarError = "">
									<cfset lVarError = "#cfcatch.message#">
									<cfif isDefined('cfcatch.sql')>
										<cfset lVarError = "#cfcatch.sql#">
									</cfif>
									<cfif isDefined('cfcatch.queryError')>
										<cfset lVarError = lVarError & " #cfcatch.queryError#">
									</cfif>
									<cfif isDefined('cfcatch.detail')>
										<cfset lVarError = lVarError & " #cfcatch.detail#">
									</cfif>
									<cfthrow message="Error: [#lVarError#]">
								</cfcatch>
								<cfcatch type="any">
									<cftransaction action="rollback" />
									<cfset lVarError = "">
									<cfif isDefined('cfcatch.sql')>
										<cfset lVarError = "#cfcatch.sql#">
									<cfelseif isDefined('cfcatch.Detail')>
										<cfset lVarError = "#cfcatch.Detail#">
									<cfelse>
										<cfset lVarError = "#cfcatch.message#">
									</cfif>
									<cfthrow message="Error: [#cfcatch.message#]">
								</cfcatch>
							</cftry>
						</cftransaction>
					</cfif>
				</cfif>

				<!--- FIN: APLICACION DE NOTA DE CREDITO Y CREACION DE LA APLICACION DE DOCUMENTOS A FAVOR --->

	<!--- <cfinclude template="ListaImprimeDocumento.cfm"> --->
</cfif>


<cffunction name="fnGetParametro" returntype="string" access="private">
	<cfargument name='Ecodigo'		type='numeric' 	required='true'>	 <!--- Codigo empresa ---->
	<cfargument name='Pcodigo'		type='string' 	required='true'>
	<cfargument name='Pdescripcion'	type='string' 	required='true'>
	<cfargument name='Conexion' 	type='string' 	required='false' default	= "#Session.DSN#">
	<cfargument name='Pdefault'		type='string' 	required='no' default="��">

	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select Pvalor
		from Parametros
		where Ecodigo = #Arguments.Ecodigo#
		  and Pcodigo = #Arguments.Pcodigo#
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cfif Arguments.Pdefault EQ "��">
			<cf_errorCode	code = "50999"
							msg  = "No se ha definido el Par�metro: @errorDat_1@ - @errorDat_2@"
							errorDat_1="#Arguments.Pcodigo#"
							errorDat_2="#Arguments.Pdescripcion#"
			>
		<cfelse>
			<cfreturn Arguments.Pdefault>
		</cfif>
	</cfif>
	<cfreturn rsSQL.Pvalor>
</cffunction>