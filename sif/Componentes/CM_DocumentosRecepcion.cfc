<cfcomponent hint="Componente para el Manejo de los Documento de Recepcion en el Modulo de importacion de Compras">
	<cffunction name="ProcesarDocumento" access="public">
        <cfargument name="EDRid" 		required="yes" type="numeric" hint="Id del Documento de Recepción">
        <cfargument name="INTARC" 		required="yes" type="string" hint="Nombre de la temporal de INTARC">
        
        <cfargument name="conexion" 	required="no"  type="string"  hint="Nombre del Datasource">
        
        <cfif NOT ISDEFINED('Arguments.conexion') AND ISDEFINED('SESSION.dsn')>
            <CFSET Arguments.conexion = session.dsn>
        </cfif>
    	
    
    	<cfquery name="RsDetalles" datasource="#Arguments.conexion#">
        	select Coalesce(dcm.Ecodigo,docm.Ecodigo) as Ecodigo, docm.CMtipo, docm.Aid, docm.Alm_Aid,hddr.DDRcantrec, 
            		hedr.Mcodigo, 
                    Coalesce(docm.DSlinea,-1) as DSlinea,
                    docm.FPAEid, docm.CFComplemento, hedr.EDRfecharec, 
            	   hedr.EDRnumero, round(hddr.DDRprecioorig,2) DDRprecioorig,  round(round(hddr.DDRprecioorig,2) * hedr.EDRtc, 2) DDRprecioLoc
                   ,Coalesce((select min(Ocodigo) from Almacen where Aid = docm.Alm_Aid), 
                   			 (select min(Ocodigo) from CFuncional where CFid = hedr.CFid),
                             (select min(Ocodigo) from Oficinas where Ecodigo = hedr.Ecodigo)) as Ocodigo
                   ,coalesce((select min(Dcodigo) from CFuncional where CFid = hedr.CFid), 
                   			 (select min(Dcodigo) from Almacen where Aid = hedr.Aid)) as Dcodigo
                   ,hedr.EDRtc, docm.CFcuenta, hedr.SNcodigo, hedr.EDRreferencia,
                   c.ACcadq CuentaAdquisicion,
                   docm.ACcodigo,docm.ACid,docm.CFid,docm.DOdescripcion,
                   round(hddr.DDRtotallin,2) DDRtotallin,  round(round(hddr.DDRtotallin,2) * hedr.EDRtc, 2) DDRtotallinLoc, 
                   hddr.DDRcantrec * case 
                   						when Coalesce(CUconvarticulo, 1) = 0 then 
                    						 Coalesce(CUfactor,1) 
                                        else 
                                        	Coalesce(CUAfactor,1) end  
                        		CantidadConvertida,
                 <!---►ISO de la Moneda--->
                 (select Miso4217 from Monedas where Mcodigo = hedr.Mcodigo) as Miso4217
                   
            from EDocumentosRecepcion hedr
            
				inner join DDocumentosRecepcion hddr
					on hedr.EDRid   = hddr.EDRid
				   and hedr.Ecodigo = hddr.Ecodigo
                   
                inner join DOrdenCM docm		
					on hddr.DOlinea = docm.DOlinea	
                
                LEFT OUTER JOIN DSolicitudCompraCM dcm
                   ON dcm.DSlinea = docm.DSlinea 
                   
                left outer join AClasificacion c
                    on c.Ecodigo   = docm.Ecodigo
                   and c.ACid      = docm.ACid
                   and c.ACcodigo  = docm.ACcodigo
                 
                LEFT OUTER JOIN Articulos act
                	on act.Aid = docm.Aid
                    
                LEFT OUTER JOIN ConversionUnidades cu
                	 ON cu.Ecodigo    = docm.Ecodigo
                    AND cu.Ucodigo    = docm.Ucodigo
                    AND cu.Ucodigoref = act.Ucodigo
               
               LEFT OUTER JOIN ConversionUnidadesArt cua
                	 ON cua.Ecodigo  = docm.Ecodigo
                    AND cua.Aid      = docm.Aid
                    AND cua.Ucodigo  = docm.Ucodigo
                   
             where hedr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
        </cfquery>
        <!---►►Valida que no se hallan Mesclado Empresas◄◄--->
        <cfquery name="rsEcodigo" dbtype="query">
            select Distinct Ecodigo from RsDetalles
        </cfquery>
        <cfif rsEcodigo.RecordCount GT 1>
            <cfthrow message="No puede incluir Lineas de Costos de Distintas Empresas">
        <cfelse>
            <cfset LvarEcodigoSolicitante = rsEcodigo.Ecodigo>
        </cfif>
        
        <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
            select Pvalor
            from Parametros
            where Ecodigo = #LvarEcodigoSolicitante# 
              and Mcodigo = 'GN'
              and Pcodigo = 50
        </cfquery>
        <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
            <cfthrow message="No esta definido el período de Auxiliares. Proceso Cancelado!">
        </cfif>
		<cfset LvarAnoAux = rsSQL.Pvalor>
	
        <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
            select Pvalor
            from Parametros
            where Ecodigo = #LvarEcodigoSolicitante# 
              and Mcodigo = 'GN'
              and Pcodigo = 60
        </cfquery>
        <cfif rsSQL.recordcount EQ 0 or len(trim(rsSQL.Pvalor)) EQ 0>
            <cfthrow message="No esta definido el Mes de Auxiliares. Proceso Cancelado!">
        </cfif>
        <cfset LvarMesAux = rsSQL.Pvalor>
        
        
        <cfinvoke method="Contabiliza">
        	<cfinvokeargument name="INTARC" 	value="#Arguments.INTARC#">
            <cfinvokeargument name="EDRid"  	value="#Arguments.EDRid#">
            <cfinvokeargument name="FechaDoc"  	value="#RsDetalles.EDRfecharec#">
            <cfinvokeargument name="Documento" 	value="#RsDetalles.EDRnumero#">
            <cfinvokeargument name="Referencia" value="#RsDetalles.EDRreferencia#">
            <cfinvokeargument name="Ecodigo" 	value="#LvarEcodigoSolicitante#">
        </cfinvoke>
        
        <cfloop query="RsDetalles">
        	<cfif UCASE(RsDetalles.CMtipo) EQ 'A'>	
                <cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="LvarDatosInv">
                		<cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->
                        <cfinvokeargument name="Referencia" 	  	value="CM-Importacion"/>
                        <cfinvokeargument name="TransaccionActiva"	value="true">
                        <cfinvokeargument name="insertarEnKardex" 	value="true"/>
                        <cfinvokeargument name="Tipo_Mov"      		value="E"/>
                        <cfinvokeargument name="Tipo_ES"       	  	value="E">
                        <cfinvokeargument name="ObtenerCosto"  		value="false">
                        <cfinvokeargument name="Aid" 	       		value="#RsDetalles.Aid#"/>							
                        <cfinvokeargument name="Alm_Aid"       		value="#RsDetalles.Alm_Aid#"/>
                        <cfinvokeargument name="Cantidad"      		value="#RsDetalles.CantidadConvertida#"/>
                        <cfinvokeargument name="McodigoOrigen" 		value="#RsDetalles.Mcodigo#">
                        <cfinvokeargument name="FechaDoc" 	      	value="#RsDetalles.EDRfecharec#"/>	
                        <cfinvokeargument name="Documento" 	      	value="#RsDetalles.EDRnumero#"/>	
                        <cfinvokeargument name="CostoOrigen"   		value="#RsDetalles.DDRtotallin#">
                        <cfinvokeargument name="CostoLocal"       	value="#RsDetalles.DDRtotallinLoc#">
                        <cfinvokeargument name="Ocodigo" 	      	value="#RsDetalles.Ocodigo#"/>
                      <cfif LEN(TRIM(RsDetalles.Dcodigo))>
                        <cfinvokeargument name="Dcodigo"       		value="#RsDetalles.Dcodigo#"/>
                      </cfif>
                        <cfinvokeargument name="Conexion"         	value="#Arguments.Conexion#">
                    <cfif LEN(TRIM(RsDetalles.FPAEid))>
                        <cfinvokeargument name="FPAEid"         	value="#RsDetalles.FPAEid#">
                    </cfif>
                    <cfif LEN(TRIM(RsDetalles.FPAEid))>
                        <cfinvokeargument name="CFComplemento"		value="#RsDetalles.CFComplemento#">	
                    </cfif>	
                    	 <cfinvokeargument name="DSlinea"	 		value="#RsDetalles.DSlinea#">			
                </cfinvoke>
                
            <cfelseif UCASE(RsDetalles.CMtipo) EQ 'F'>
            	<!---►►Al aplicarse la Adquisicion, realizara
				  Debito:Cuenta de Adquisicion de la categoria clase
				  Credito: Cuenta de Inversion (AltaDAadquisicion.CFcuenta) si esta no se envia se usa la de transito (Parametros)◄◄--->
          	  	<cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AltaEAadquisicion" returnvariable="LvarEAcplinea">
                        <cfinvokeargument name="Ecodigo" 		 value="#LvarEcodigoSolicitante#">
                        <cfinvokeargument name="EAcpidtrans" 	 value="CM">
                        <cfinvokeargument name="EAcpdoc" 		 value="#RsDetalles.EDRnumero#">
                        <cfinvokeargument name="Ocodigo" 		 value="#RsDetalles.Ocodigo#">
                   <cfif LEN(TRIM(RsDetalles.Alm_Aid))>
                   		<cfinvokeargument name="Aid" 			 value="#RsDetalles.Alm_Aid#">
                   </cfif>
                        <cfinvokeargument name="EAPeriodo" 		 value="#LvarAnoAux#">
                        <cfinvokeargument name="EAmes" 			 value="#LvarMesAux#">
                        <cfinvokeargument name="EAFecha" 		 value="#RsDetalles.EDRfecharec#">
                        <cfinvokeargument name="Mcodigo" 		 value="-1">
                        <cfinvokeargument name="EAtipocambio" 	 value="#RsDetalles.EDRtc#">
                        <cfinvokeargument name="Ccuenta" 		 value="#RsDetalles.CuentaAdquisicion#">
                        <cfinvokeargument name="SNcodigo" 		 value="#RsDetalles.SNcodigo#">
                        <cfinvokeargument name="EAdescripcion" 	 value="CM-Doc.Recepcion:#RsDetalles.EDRnumero#">
                        <cfinvokeargument name="EAcantidad" 	 value="#RsDetalles.DDRcantrec#">
                        <cfinvokeargument name="EAtotalori" 	 value="#RsDetalles.DDRtotallin#">
                        <cfinvokeargument name="EAtotalloc" 	 value="#RsDetalles.DDRtotallinLoc#">
                        <cfinvokeargument name="EAstatus" 		 value="0">
                        <cfinvokeargument name="EAselect" 		 value="0">
                        <cfinvokeargument name="Usucodigo" 		 value="#session.Usucodigo#">
                        <cfinvokeargument name="BMfechaproceso"  value="#now()#">
                        <cfinvokeargument name="IDcontable" 	 value="-1">
                        <cfinvokeargument name="BMUsucodigo" 	 value="#session.Usucodigo#">
                       	<cfinvokeargument name="Conexion" 		 value="#Arguments.conexion#">
                        <cfinvokeargument name="Miso4217" 		 value="#RsDetalles.Miso4217#"> 
           		</cfinvoke>
                
                <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AltaDAadquisicion" returnvariable="LvarDAlinea">
                		<cfinvokeargument name="Ecodigo" 		 value="#LvarEcodigoSolicitante#">
                   		<cfinvokeargument name="EAcpidtrans" 	 value="CM">
                   		<cfinvokeargument name="EAcpdoc" 		 value="#RsDetalles.EDRnumero#">
                        <cfinvokeargument name="EAcplinea" 		 value="#LvarEAcplinea#">
                        <cfinvokeargument name="DAmonto" 		 value="#RsDetalles.DDRtotallin#">
                        <cfinvokeargument name="CFcuenta" 		 value="#RsDetalles.CFcuenta#"><!---►►Cuenta de Inversion--->
                        <cfinvokeargument name="Usucodigo" 		 value="#session.Usucodigo#">
                        <cfinvokeargument name="DAtc" 		 	 value="#RsDetalles.EDRtc#">
                        <cfinvokeargument name="BMUsucodigo" 	 value="#session.Usucodigo#">
                       	<cfinvokeargument name="Conexion" 		 value="#Arguments.conexion#">
                </cfinvoke>
                <cfloop from="1" to="#RsDetalles.DDRcantrec#" index="i">
                    <cfinvoke component="sif.Componentes.AF_AdquisicionActivos" method="AltaDSActivosAdq" returnvariable="Lvarlin">
                            <cfinvokeargument name="Ecodigo" 		 value="#LvarEcodigoSolicitante#">
                            <cfinvokeargument name="EAcpidtrans" 	 value="CM">
                            <cfinvokeargument name="EAcpdoc" 		 value="#RsDetalles.EDRnumero#">
                            <cfinvokeargument name="EAcplinea" 		 value="#LvarEAcplinea#">
                            <cfinvokeargument name="DAlinea" 		 value="#LvarDAlinea#">
                            <cfinvokeargument name="DSdescripcion"   value="#DOdescripcion#-#i#">  
                            <cfinvokeargument name="DSfechainAdq"    value="#RsDetalles.EDRfecharec#">
                            <cfinvokeargument name="DSmonto" 		 value="#RsDetalles.DDRtotallin / RsDetalles.DDRcantrec#">
                            <cfinvokeargument name="ACcodigo"   	 value="#RsDetalles.ACcodigo#">    
                            <cfinvokeargument name="ACid"   	     value="#RsDetalles.ACid#">  
                            <cfinvokeargument name="CFid"   	     value="#RsDetalles.CFid#">  
                    </cfinvoke>
               </cfloop>
			</cfif>
     	</cfloop>
     
    </cffunction>
    <!---►►Proceso de Contabilizacion◄◄--->
    <cffunction name="Contabiliza" access="private">
    	<cfargument name="Ecodigo"  			type="numeric"  required="no">
        <cfargument name="Conexion" 			type="numeric" 	required="no">
        <cfargument name="INTARC"   			type="string" 	required="yes">
        <cfargument name="EDRid" 				type="numeric" 	required="yes">
        <cfargument name="FechaDoc" 			type="date" 	required="yes">
        <cfargument name="Documento" 			type="string" 	required="yes">
        <cfargument name="Referencia" 			type="string" 	required="yes"> 
        
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
			<cfset Arguments.Conexion = session.dsn>
       </cfif>
       
       <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
       </cfif>
       <!---►►Cuenta de Activos en transito◄◄--->
       <cfquery name="rscuentatransitoAF" datasource="#Arguments.Conexion#">
       		select Pvalor 
            	from Parametros 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
              and Pcodigo = 240
       </cfquery>
       <cfif NOT rscuentatransitoAF.RecordCount OR NOT LEN(TRIM(rscuentatransitoAF.Pvalor))>
       		<cfthrow message="No se ha definido la cuenta de Activos en transito en cuentas contables de operación">
       </cfif>
       <!---Articulos
	   		D-Cuenta de Inventario del grupo de Cuentas del Articulo de Almacen(Cuenta del Detalle de transito. ) 
			C-Cuenta de Transito del grupo de Cuentas del Articulo de Almacen(Cuenta del Detalle de transito. )
			
			Activos Fijos
			D-Cuenta del Detalle de la Orden de Compra  
			C- Cuenta de Activos en transito
			
			Servicios
			D-Cuenta en transito 
			C-Cuenta del Detalle de la OC, Gasto 
			--->
            <cfquery datasource="#Arguments.Conexion#" name="Cuentas">
				select DDRlinea          	
				from EDocumentosRecepcion hedr
                
				inner join DDocumentosRecepcion hddr
					on hedr.EDRid   = hddr.EDRid
				   and hedr.Ecodigo = hddr.Ecodigo
                    
                inner join DOrdenCM docm		
					on hddr.DOlinea = docm.DOlinea	
                   
                left outer join Articulos f
                     on docm.Aid     = f.Aid
            
                left outer join Existencias g
                     on f.Ecodigo = g.Ecodigo
                    and f.Aid = g.Aid
                    and g.Alm_Aid = docm.Alm_Aid
            
                left outer join  IAContables h
                     on g.IACcodigo = h.IACcodigo
                    and g.Ecodigo = h.Ecodigo	
                                    
             where hedr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
               and case docm.CMtipo 
                	when 'A' then (select min(Ccuenta) from CFinanciera where Ccuenta = h.IACinventario)
                    when 'F' then (select min(Ccuenta) from CFinanciera where Ccuenta = #rscuentatransitoAF.Pvalor#)
                    when 'S' then (select min(Ccuenta) from CFinanciera where Ccuenta = #rscuentatransitoAF.Pvalor#)
               else null end is null
    	</cfquery>
        <cfif Cuentas.Recordcount>
        	<cfthrow message="Error en cuenta: Verifique  la configuración del grupo de cuentas de Inventario ligadas al Articulo,la Cuenta de Activos en transito y Servicios, para las lineas: #ValueList(Cuentas.DDRlinea)#">
        </cfif>
        
    	<!---►►Inserta el Credito◄◄--->
    	<cfquery datasource="#Arguments.Conexion#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, INTCAM, INTMON,CFid)
				select 
					'CPFC',
					1,
					hedr.EDRnumero,
					hedr.EDRreferencia,
					'C',
					case docm.CMtipo when 'A' then 'Tránsito de Inventario' 
                    				 when 'F' then 'Tránsito de Activos'
                                     when 'S' then 'Tránsito al Gasto'
                                     else 'Adquisicion Desconocida' end,
					<cf_dbfunction name="Date_Format" args="hedr.EDRfecharec,YYYYMMDD">,
					#LvarAnoAux#,
					#LvarMesAux#,
                    case docm.CMtipo 
                    when 'A' then (select min(Ccuenta) from CFinanciera where Ccuenta = h.IACtransito)
                    when 'F' then (select min(Ccuenta) from CFinanciera where Ccuenta = #rscuentatransitoAF.Pvalor#)
                    when 'S' then (select min(Ccuenta) from CFinanciera where Ccuenta = #rscuentatransitoAF.Pvalor#)
                    else null end,
                    	
					hedr.Mcodigo,
					Coalesce((select min(Ocodigo) from Almacen where Aid = docm.Alm_Aid), 
                   			 (select min(Ocodigo) from CFuncional where CFid = hedr.CFid),
                             (select min(Ocodigo) from Oficinas where Ecodigo = hedr.Ecodigo)) as Ocodigo,
					round(hddr.DDRtotallin,2),
                    hedr.EDRtc,
					round(round(hddr.DDRtotallin,2) * hedr.EDRtc, 2),hedr.CFid
				from EDocumentosRecepcion hedr
                
				inner join DDocumentosRecepcion hddr
					on hedr.EDRid   = hddr.EDRid
				   and hedr.Ecodigo = hddr.Ecodigo
                    
                inner join DOrdenCM docm		
					on hddr.DOlinea = docm.DOlinea	
                   
                left outer join Articulos f
                     on f.Aid = docm.Aid
            
                left outer join Existencias g
                     on f.Ecodigo = g.Ecodigo
                    and f.Aid 	  = g.Aid
                    and g.Alm_Aid = docm.Alm_Aid
            
                left outer join  IAContables h
                     on g.IACcodigo = h.IACcodigo
                    and g.Ecodigo = h.Ecodigo	
                                    
             where hedr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
			</cfquery>
            
            <!---►►Inserta el Debito◄◄--->
            <cfquery datasource="#Arguments.Conexion#">
			insert into #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, INTCAM, INTMON,CFid)
				select 
					'CPFC',
					1,
					hedr.EDRnumero,
					hedr.EDRreferencia,
					'D',
					case docm.CMtipo when 'A' then 'Entrada al Inventario' 
                    				 when 'F' then 'Compra de Activo'
                                     when 'S' then 'Adquisición al Gasto'
                                     else 'Adquisicion Desconocida' end,
					<cf_dbfunction name="Date_Format" args="hedr.EDRfecharec,YYYYMMDD">,
					#LvarAnoAux#,
					#LvarMesAux#,
                    case docm.CMtipo 
                    	when 'A' then (select min(Ccuenta) from CFinanciera where Ccuenta = h.IACinventario)
                        when 'F' then (select min(Ccuenta) from CFinanciera where CFcuenta = docm.CFcuenta)
                        when 'S' then (select min(Ccuenta) from CFinanciera where CFcuenta = docm.CFcuenta)
                        else null end,
					hedr.Mcodigo,
					Coalesce((select min(Ocodigo) from Almacen where Aid = docm.Alm_Aid), 
                   			 (select min(Ocodigo) from CFuncional where CFid = hedr.CFid),
                             (select min(Ocodigo) from Oficinas where Ecodigo = hedr.Ecodigo)) as Ocodigo,
					round(hddr.DDRtotallin,2),
                    hedr.EDRtc,
					round(round(hddr.DDRtotallin,2) * hedr.EDRtc, 2),hedr.CFid
				from EDocumentosRecepcion hedr
                
				inner join DDocumentosRecepcion hddr
					on hedr.EDRid   = hddr.EDRid
				   and hedr.Ecodigo = hddr.Ecodigo
                    
                inner join DOrdenCM docm		
					on hddr.DOlinea = docm.DOlinea	
                
                 left outer join Articulos f
                     on docm.Aid = f.Aid
            
                left outer join Existencias g
                     on f.Ecodigo = g.Ecodigo
                    and f.Aid     = g.Aid
                    and g.Alm_Aid = docm.Alm_Aid
            
                left outer join  IAContables h
                     on g.IACcodigo = h.IACcodigo
                    and g.Ecodigo = h.Ecodigo	
                    
             where hedr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EDRid#">
			</cfquery>
            
            <!---►►BALANCEO MONEDA OFICINA.  Verifica que el Asiento esté Balanceado en Moneda Local◄◄--->
			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 100
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="La cuenta de Ajuste por Redondeo de Monedas no esta Definida. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC# 
					( 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						INTTIP, INTDES, 
						Ccuenta, 
						Mcodigo, INTMOE, INTCAM, INTMON,CFid
					)
				select 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, Ocodigo, 
						case 
							when INTTIP = 'D' 
								then case when INTMON > INTMON2 then 'C' else 'D' end
								else case when INTMON < INTMON2 then 'C' else 'D' end
						end, 
						'Ajuste Redondeo', 
						#LvarCtaBalanceMoneda#, 
						i.Mcodigo, 0, 0, 
						abs(INTMON - INTMON2),i.CFid
				  from #INTARC# i
				 where INTMON2 IS NOT NULL
				   and INTMON <> INTMON2
			</cfquery>

			<cfquery name="rsVerifica" datasource="#Arguments.Conexion#">
				select 	
					sum(case when INTTIP = 'D' then INTMON else -INTMON end) as Diferencia, 
					sum(0.05) as Permitido, 
					sum(case when INTTIP = 'D' then INTMON end) as Debitos, 
					sum(case when INTTIP = 'C' then INTMON end) as Creditos,
					count(1) as Cantidad
				  from #INTARC#
			</cfquery>

			<cfif rsVerifica.recordcount EQ 0 or rsVerifica.Cantidad EQ 0 or rsVerifica.Permitido LT 0.05>
				<cf_errorCode	code = "51158" msg = "El Asiento Generado está vacio. Proceso Cancelado">
			</cfif>

			<cfset LvarDiferencia = rsVerifica.Diferencia>
			<cfset LvarPermitido  = rsVerifica.Permitido>
			
			<cfif rsVerifica.Diferencia LT 0>
				<cfset LvarDiferencia = LvarDiferencia * -1.00>
			</cfif>

			<cfif LvarDiferencia GT LvarPermitido>
				<font color="##FF0000" style="font-size:18px">
					<cfoutput>
					El Asiento Generado no está balanceado en Moneda Local. <BR>Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!
					</cfoutput>
					<BR><BR><BR>
				</font>

				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="PintaAsiento">
					<cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
					<cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
					<cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
					<cfinvokeargument name="Efecha"			value="#Arguments.FechaDoc#"/>
					<cfinvokeargument name="Oorigen"		value="CMRI"/>
					<cfinvokeargument name="Edocbase"		value="#Arguments.Documento#"/>
					<cfinvokeargument name="Ereferencia"	value="#Arguments.Referencia#"/>						
					<cfinvokeargument name="Edescripcion"	value="Documento de Recepción: #Arguments.Documento#"/>
				</cfinvoke>

				<cftransaction action="rollback" />
				<cf_abort errorInterfaz="El Asiento Generado no está balanceado en Moneda Local. Debitos= #numberformat(rsVerifica.Debitos, ',9.00')#, Creditos= #numberformat(rsVerifica.Creditos, ',9.00')#. Proceso Cancelado!">
			</cfif>

			<!---►►Balance Multimoneda◄◄--->
			<cfquery name="rsCtaBalance" datasource="#Arguments.Conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #Arguments.Ecodigo#
				  and Pcodigo = 200
			</cfquery>
			<cfif rsCtaBalance.recordcount EQ 0 or len(trim(rsCtaBalance.Pvalor)) EQ 0>
                <cfthrow message="No esta definida la Cuenta Balance Multimoneda. Proceso Cancelado!">
            </cfif>
			<cfset LvarCtaBalanceMoneda = rsCtaBalance.Pvalor>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #INTARC#
					( 
						Ocodigo, Mcodigo, INTCAM, 
						INTORI, INTREL, INTDOC, INTREF, 
						INTFEC, Periodo, Mes, 
						INTTIP, INTDES, 
						Ccuenta, 
						INTMOE, INTMON,CFid
					)
				select 
						Ocodigo, i.Mcodigo, round(INTCAM,10), 
						min(INTORI), min(INTREL), min(INTDOC), min(INTREF), 
						min(INTFEC), min(Periodo), min(Mes), 
						'D', 'Balance entre Monedas', 
						#LvarCtaBalanceMoneda#, 
						-sum(case when INTTIP = 'D' then INTMOE else -INTMOE end),
						-sum(case when INTTIP = 'D' then INTMON else -INTMON end),i.CFid
				  from #INTARC# i
				 where i.Mcodigo in
					(
						select Mcodigo
						  from #INTARC#
						 group by Mcodigo
						having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
					)
				group by	i.Ocodigo, i.Mcodigo, round(INTCAM,10),i.CFid
				having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
			</cfquery>
            <cfquery name="Asiento" datasource="#Arguments.Conexion#">
            	select min(Ocodigo) Ocodigo from #INTARC#
            </cfquery>
            
			<!---►►Genera el Asiento Contable◄◄--->
            <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
                <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
                <cfinvokeargument name="Eperiodo"		value="#LvarAnoAux#"/>
                <cfinvokeargument name="Emes"			value="#LvarMesAux#"/>
                <cfinvokeargument name="Efecha"			value="#Arguments.FechaDoc#"/>
                <cfinvokeargument name="Oorigen"		value="CMRI"/>
                <cfinvokeargument name="Edocbase"		value="#Arguments.Documento#"/>
                <cfinvokeargument name="Ereferencia"	value="#Arguments.Referencia#"/>						
                <cfinvokeargument name="Edescripcion"	value="Documento de Recepción: #Arguments.Documento#"/>
                <cfinvokeargument name="Ocodigo"		value="#Asiento.Ocodigo#"/>						
<!---           <cfinvokeargument name="NAP"			value="#Arguments.NAP#"/>						
                <cfinvokeargument name="CPNAPIid"		value="#Arguments.CPNAPIid#"/>		--->				
                <cfinvokeargument name="PintaAsiento"	value="false"/>						
            </cfinvoke>
    </cffunction>
</cfcomponent>